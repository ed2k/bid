from typing import Optional, Dict, Tuple
from bid.models import Suit, Strain, Seat, Rank, Hand, Call, CallType

class Vulnerability:
    NONE = 0
    NS = 1
    EW = 2
    BOTH = 3

    @staticmethod
    def is_vulnerable(vuln: int, seat: Seat) -> bool:
        if vuln == Vulnerability.BOTH:
            return True
        if vuln == Vulnerability.NONE:
            return False
        if vuln == Vulnerability.NS:
            return seat in (Seat.NORTH, Seat.SOUTH)
        if vuln == Vulnerability.EW:
            return seat in (Seat.EAST, Seat.WEST)
        return False

# IMP conversion table (difference in duplicate points -> IMPs)
IMP_TABLE = [
    (15, 0),
    (45, 1),
    (85, 2),
    (125, 3),
    (165, 4),
    (215, 5),
    (265, 6),
    (315, 7),
    (365, 8),
    (425, 9),
    (495, 10),
    (595, 11),
    (745, 12),
    (895, 13),
    (1095, 14),
    (1295, 15),
    (1495, 16),
    (1745, 17),
    (1995, 18),
    (2245, 19),
    (2495, 20),
    (2995, 21),
    (3495, 22),
    (3995, 23),
    (float('inf'), 24)
]

def score_to_imp(diff: int) -> int:
    """Convert points difference to International Match Points (IMPs)."""
    sign = 1 if diff >= 0 else -1
    abs_diff = abs(diff)
    for threshold, imp in IMP_TABLE:
        if abs_diff <= threshold:
            return sign * imp
    return sign * 24

def calculate_contract_score(level: int,
                             strain: Strain,
                             declarer_seat: Seat,
                             tricks_taken: int,
                             vulnerable: bool,
                             doubled: int = 0) -> int:
    """
    Calculate duplicate bridge score from declarer's perspective.
    level: 1 to 7
    strain: Suit / NT
    tricks_taken: 0 to 13
    vulnerable: True if declarer side is vulnerable
    doubled: 0 = undoubled, 1 = doubled (X), 2 = redoubled (XX)
    """
    contract_tricks = level + 6
    diff = tricks_taken - contract_tricks

    # Passed out or invalid level
    if level <= 0:
        return 0

    if diff >= 0:
        # Contract Made!
        # 1. Trick score
        if strain in (Strain.CLUBS, Strain.DIAMONDS):
            base_per_trick = 20
        elif strain in (Strain.HEARTS, Strain.SPADES):
            base_per_trick = 30
        else: # NT
            base_per_trick = 30 # first trick is 40

        if strain == Strain.NT:
            base_trick_score = 40 + (level - 1) * 30
        else:
            base_trick_score = level * base_per_trick

        if doubled == 1:
            trick_score = base_trick_score * 2
        elif doubled == 2:
            trick_score = base_trick_score * 4
        else:
            trick_score = base_trick_score

        # 2. Game / Partscore bonus
        if trick_score >= 100:
            game_bonus = 500 if vulnerable else 300
        else:
            game_bonus = 50

        # 3. Slam bonus
        slam_bonus = 0
        if level == 6:
            slam_bonus = 750 if vulnerable else 500
        elif level == 7:
            slam_bonus = 1500 if vulnerable else 1000

        # 4. Insult bonus (for making doubled/redoubled contract)
        insult_bonus = 0
        if doubled == 1:
            insult_bonus = 50
        elif doubled == 2:
            insult_bonus = 100

        # 5. Overtricks
        overtrick_score = 0
        overtricks = diff
        if overtricks > 0:
            if doubled == 0:
                if strain in (Strain.CLUBS, Strain.DIAMONDS):
                    overtrick_score = overtricks * 20
                else:
                    overtrick_score = overtricks * 30
            elif doubled == 1:
                rate = 200 if vulnerable else 100
                overtrick_score = overtricks * rate
            elif doubled == 2:
                rate = 400 if vulnerable else 200
                overtrick_score = overtricks * rate

        total = trick_score + game_bonus + slam_bonus + insult_bonus + overtrick_score
        return total

    else:
        # Contract Defeated (Down)
        undertricks = -diff
        if doubled == 0:
            rate = 100 if vulnerable else 50
            return - (undertricks * rate)
        elif doubled == 1: # Doubled
            if vulnerable:
                # 200 for 1st, 300 for subsequent
                total_down = 200 + (undertricks - 1) * 300
            else:
                # 100 for 1st, 200 for 2nd and 3rd, 300 for 4th+
                if undertricks == 1:
                    total_down = 100
                elif undertricks == 2:
                    total_down = 300
                elif undertricks == 3:
                    total_down = 500
                else:
                    total_down = 500 + (undertricks - 3) * 300
            return -total_down
        else: # Redoubled
            # Twice doubled penalty
            if vulnerable:
                total_down = (200 + (undertricks - 1) * 300) * 2
            else:
                if undertricks == 1:
                    total_down = 200
                elif undertricks == 2:
                    total_down = 600
                elif undertricks == 3:
                    total_down = 1000
                else:
                    total_down = (500 + (undertricks - 3) * 300) * 2
            return -total_down

def estimate_double_dummy_tricks(hands: Dict[Seat, Hand], strain: Strain, declarer: Seat) -> int:
    """
    Fast Double Dummy Trick Estimator using bridge heuristics:
    HCP fit, combined partnership suit lengths, stoppers, and shape synergy.
    """
    partner = declarer.partner
    decl_hand = hands[declarer]
    part_hand = hands[partner]

    opp1 = Seat((declarer.value + 1) % 4)
    opp2 = Seat((declarer.value + 3) % 4)
    opp1_hand = hands[opp1]
    opp2_hand = hands[opp2]

    ns_hcp = decl_hand.hcp + part_hand.hcp
    ew_hcp = opp1_hand.hcp + opp2_hand.hcp

    if strain == Strain.NT:
        # Baseline from HCP: 20 HCP = 7 tricks, 25 HCP = 9 tricks, 29 HCP = 10 tricks, 33 HCP = 12 tricks
        base = (ns_hcp - 20) * 0.4 + 7.0
        # Long suit running potential in NT: 5+ cards with honors
        long_suit_bonus = 0.0
        for s in Suit:
            combined_len = decl_hand.length(s) + part_hand.length(s)
            if combined_len >= 8:
                long_suit_bonus += 0.5 * (combined_len - 7)
        # Stopper penalty: void or weak doubleton in opponent long suit
        stopper_penalty = 0.0
        for s in Suit:
            combined_hcp = sum(c.hcp for c in decl_hand.by_suit[s] + part_hand.by_suit[s])
            opp_len = opp1_hand.length(s) + opp2_hand.length(s)
            if opp_len >= 8 and combined_hcp < 3:
                stopper_penalty += 0.5

        tricks = base + long_suit_bonus - stopper_penalty
    else:
        # Trump contract
        trump_suit = Suit(strain.value)
        combined_trump = decl_hand.length(trump_suit) + part_hand.length(trump_suit)
        trump_hcp = sum(c.hcp for c in decl_hand.by_suit[trump_suit] + part_hand.by_suit[trump_suit])

        # Base tricks from HCP & Fit
        # 20 HCP + 8 fit = ~7.5 tricks, 25 HCP + 8 fit = ~9.5 tricks, 26 HCP + 8 fit = 10 tricks
        base = (ns_hcp - 20) * 0.35 + 7.0
        fit_bonus = max(0, combined_trump - 7) * 0.75

        # Ruffing / distributional power (singletons / voids in side suits)
        ruff_bonus = 0.0
        if combined_trump >= 8:
            for s in Suit:
                if s != trump_suit:
                    short_side = min(decl_hand.length(s), part_hand.length(s))
                    if short_side == 0:
                        ruff_bonus += 1.0
                    elif short_side == 1:
                        ruff_bonus += 0.5

        tricks = base + fit_bonus + ruff_bonus

    estimated = int(round(max(0, min(13, tricks))))
    return estimated
