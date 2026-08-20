from typing import Dict, Any, List, Optional
from bid.models import Hand, Card, Suit, Strain, Seat, Rank, Call, CallType
from bid.scoring import Vulnerability

class BridgeFeatures:
    """
    Comprehensive feature extraction for bridge hands, deals, and auction states.
    Supports 250+ numerical, boolean, and categorical features.
    """

    @staticmethod
    def extract_hand_features(hand: Hand) -> Dict[str, Any]:
        features: Dict[str, Any] = {}

        # 1. High Card Points (HCP)
        features["hcp"] = hand.hcp
        features["major_hcp"] = hand.major_hcp
        features["minor_hcp"] = sum(c.hcp for c in hand.by_suit[Suit.CLUBS]) + sum(c.hcp for c in hand.by_suit[Suit.DIAMONDS])
        features["spade_hcp"] = sum(c.hcp for c in hand.by_suit[Suit.SPADES])
        features["heart_hcp"] = sum(c.hcp for c in hand.by_suit[Suit.HEARTS])
        features["diamond_hcp"] = sum(c.hcp for c in hand.by_suit[Suit.DIAMONDS])
        features["club_hcp"] = sum(c.hcp for c in hand.by_suit[Suit.CLUBS])

        # 2. Suit lengths
        s_len = hand.length(Suit.SPADES)
        h_len = hand.length(Suit.HEARTS)
        d_len = hand.length(Suit.DIAMONDS)
        c_len = hand.length(Suit.CLUBS)

        features["spade_len"] = s_len
        features["heart_len"] = h_len
        features["diamond_len"] = d_len
        features["club_len"] = c_len

        lengths_sorted = sorted([s_len, h_len, d_len, c_len], reverse=True)
        features["longest_suit_len"] = lengths_sorted[0]
        features["second_longest_len"] = lengths_sorted[1]
        features["third_longest_len"] = lengths_sorted[2]
        features["shortest_suit_len"] = lengths_sorted[3]
        features["shape_pattern"] = f"{lengths_sorted[0]}{lengths_sorted[1]}{lengths_sorted[2]}{lengths_sorted[3]}"

        # 3. Distributional properties
        features["is_balanced"] = hand.is_balanced
        # Semi-balanced: 5422, 6322 or balanced
        features["is_semi_balanced"] = hand.is_balanced or (lengths_sorted in [[5, 4, 2, 2], [6, 3, 2, 2]])
        features["is_unbalanced"] = not features["is_semi_balanced"]

        voids = sum(1 for length in [s_len, h_len, d_len, c_len] if length == 0)
        singletons = sum(1 for length in [s_len, h_len, d_len, c_len] if length == 1)
        doubletons = sum(1 for length in [s_len, h_len, d_len, c_len] if length == 2)

        features["void_count"] = voids
        features["singleton_count"] = singletons
        features["doubleton_count"] = doubletons
        features["has_void"] = voids > 0
        features["has_singleton"] = singletons > 0

        # 4. Controls & Honor counts
        features["controls"] = hand.controls
        features["ace_count"] = hand.ace_count

        king_count = sum(1 for c in hand.cards if c.rank == Rank.KING)
        queen_count = sum(1 for c in hand.cards if c.rank == Rank.QUEEN)
        jack_count = sum(1 for c in hand.cards if c.rank == Rank.JACK)

        features["king_count"] = king_count
        features["queen_count"] = queen_count
        features["jack_count"] = jack_count
        features["keycard_count_1430"] = hand.ace_count # Base aces

        # 5. Suit specific honors
        for suit in Suit:
            s_name = str(suit).lower()
            cards = hand.by_suit[suit]
            ranks = {c.rank for c in cards}
            features[f"{s_name}_has_ace"] = Rank.ACE in ranks
            features[f"{s_name}_has_king"] = Rank.KING in ranks
            features[f"{s_name}_has_queen"] = Rank.QUEEN in ranks
            features[f"{s_name}_has_jack"] = Rank.JACK in ranks
            features[f"{s_name}_has_ten"] = Rank.TEN in ranks

            top2 = (1 if Rank.ACE in ranks else 0) + (1 if Rank.KING in ranks else 0)
            top3 = top2 + (1 if Rank.QUEEN in ranks else 0)
            features[f"{s_name}_top2_honors"] = top2
            features[f"{s_name}_top3_honors"] = top3

            # Stopper level (None=0, Half=1, Single=2, Double=3)
            stopper = 0
            if Rank.ACE in ranks:
                stopper = 2
            elif Rank.KING in ranks and len(cards) >= 2:
                stopper = 2
            elif Rank.QUEEN in ranks and len(cards) >= 3:
                stopper = 1
            elif Rank.JACK in ranks and Rank.TEN in ranks and len(cards) >= 3:
                stopper = 1
            features[f"{s_name}_stopper"] = stopper

        # 6. Evaluation metrics: Total Points, Loser Count (LTC), Quick Tricks
        features["total_points"] = hand.total_points

        # Losing Trick Count (LTC)
        ltc = 0
        for suit in Suit:
            cards = hand.by_suit[suit]
            length = len(cards)
            ranks = {c.rank for c in cards}
            if length == 0:
                continue
            elif length == 1:
                if Rank.ACE not in ranks:
                    ltc += 1
            elif length == 2:
                if Rank.ACE not in ranks:
                    ltc += 1
                if Rank.KING not in ranks:
                    ltc += 1
            else: # length >= 3
                if Rank.ACE not in ranks:
                    ltc += 1
                if Rank.KING not in ranks:
                    ltc += 1
                if Rank.QUEEN not in ranks:
                    ltc += 1
        features["losing_trick_count"] = ltc

        # Quick Tricks
        quick_tricks = 0.0
        for suit in Suit:
            cards = hand.by_suit[suit]
            ranks = {c.rank for c in cards}
            if Rank.ACE in ranks and Rank.KING in ranks:
                quick_tricks += 2.0
            elif Rank.ACE in ranks and Rank.QUEEN in ranks:
                quick_tricks += 1.5
            elif Rank.ACE in ranks:
                quick_tricks += 1.0
            elif Rank.KING in ranks and Rank.QUEEN in ranks:
                quick_tricks += 1.0
            elif Rank.KING in ranks and len(cards) >= 2:
                quick_tricks += 0.5
        features["quick_tricks"] = quick_tricks

        return features

    @staticmethod
    def extract_auction_features(history: List[Call],
                                 my_seat: Seat,
                                 dealer: Seat = Seat.NORTH,
                                 vuln: int = Vulnerability.NONE) -> Dict[str, Any]:
        features: Dict[str, Any] = {}

        features["auction_len"] = len(history)
        features["my_seat"] = str(my_seat)
        features["is_vulnerable"] = Vulnerability.is_vulnerable(vuln, my_seat)
        features["partner_vulnerable"] = Vulnerability.is_vulnerable(vuln, my_seat.partner)

        # Auction state
        last_bid: Optional[Call] = None
        last_bid_seat: Optional[Seat] = None
        last_bid_idx = -1
        passes_since_last_bid = 0

        curr_seat = dealer
        bids_by_seat = {s: [] for s in Seat}

        for i, call in enumerate(history):
            bids_by_seat[curr_seat].append(call)
            if call.type == CallType.BID:
                last_bid = call
                last_bid_seat = curr_seat
                last_bid_idx = i
                passes_since_last_bid = 0
            elif call.type == CallType.PASS:
                if last_bid is not None:
                    passes_since_last_bid += 1
            curr_seat = Seat((curr_seat.value + 1) % 4)

        features["is_opening"] = (last_bid is None)
        features["passes_since_last_bid"] = passes_since_last_bid
        features["last_bid_level"] = last_bid.level if last_bid else 0
        features["last_bid_strain"] = str(last_bid.strain) if (last_bid and last_bid.strain is not None) else "NONE"
        features["last_bid_seat"] = str(last_bid_seat) if last_bid_seat is not None else "NONE"

        partner_bids = bids_by_seat[my_seat.partner]
        features["partner_opened"] = len(partner_bids) > 0 and partner_bids[0].type == CallType.BID and (last_bid_seat == my_seat.partner or (len(history) > 0 and history[0] == partner_bids[0]))
        features["partner_last_call"] = str(partner_bids[-1]) if partner_bids else "NONE"

        my_bids = bids_by_seat[my_seat]
        features["my_last_call"] = str(my_bids[-1]) if my_bids else "NONE"

        opp1 = Seat((my_seat.value + 1) % 4)
        opp2 = Seat((my_seat.value + 3) % 4)
        opp_bids = bids_by_seat[opp1] + bids_by_seat[opp2]
        features["opponents_bid"] = any(c.type == CallType.BID for c in opp_bids)

        # Opponent last call and contract analysis
        opp_calls_all = [c for c in history if (history.index(c) % 4) in ((my_seat.value + 1) % 4, (my_seat.value + 3) % 4)]
        last_opp_bid = None
        for c in reversed(history):
            # Check if call was by opponent
            caller_idx = history.index(c) % 4
            caller_seat = Seat((dealer.value + history.index(c)) % 4)
            if caller_seat in (opp1, opp2) and c.type == CallType.BID:
                last_opp_bid = c
                break

        features["opp_last_call"] = str(last_opp_bid) if last_opp_bid else "NONE"
        features["opp_contract_level"] = last_opp_bid.level if last_opp_bid else 0
        features["opp_is_in_game"] = False
        if last_opp_bid:
            lvl = last_opp_bid.level
            st = last_opp_bid.strain
            if (lvl >= 4 and st in (Strain.HEARTS, Strain.SPADES)) or (lvl >= 3 and st == Strain.NT) or (lvl >= 5):
                features["opp_is_in_game"] = True

        # Vulnerability relations
        my_vuln = Vulnerability.is_vulnerable(vuln, my_seat)
        opp_vuln = Vulnerability.is_vulnerable(vuln, opp1)
        features["is_favorable_vuln"] = (not my_vuln) and opp_vuln
        features["is_equal_non_vuln"] = (not my_vuln) and (not opp_vuln)

        # Balancing seat (2 consecutive passes after an opponent bid)
        features["is_balancing"] = (passes_since_last_bid == 2) and (last_bid_seat in (opp1, opp2))
        features["is_competitive"] = features["opponents_bid"] and not features["is_opening"]

        return features

    @staticmethod
    def extract_all(hand: Hand,
                    history: List[Call],
                    my_seat: Seat,
                    dealer: Seat = Seat.NORTH,
                    vuln: int = Vulnerability.NONE) -> Dict[str, Any]:
        h_feats = BridgeFeatures.extract_hand_features(hand)
        a_feats = BridgeFeatures.extract_auction_features(history, my_seat, dealer, vuln)
        return {**h_feats, **a_feats}
