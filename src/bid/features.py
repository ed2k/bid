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
        if getattr(hand, "_cached_features", None) is not None:
            return dict(hand._cached_features)

        features: Dict[str, Any] = {}

        # 1. High Card Points (HCP)
        s_mask = hand.suit_masks[Suit.SPADES]
        h_mask = hand.suit_masks[Suit.HEARTS]
        d_mask = hand.suit_masks[Suit.DIAMONDS]
        c_mask = hand.suit_masks[Suit.CLUBS]

        def _mask_hcp(m: int) -> int:
            return 4 * ((m >> 12) & 1) + 3 * ((m >> 11) & 1) + 2 * ((m >> 10) & 1) + ((m >> 9) & 1)

        s_hcp = _mask_hcp(s_mask)
        h_hcp = _mask_hcp(h_mask)
        d_hcp = _mask_hcp(d_mask)
        c_hcp = _mask_hcp(c_mask)

        features["hcp"] = hand.hcp
        features["major_hcp"] = hand.major_hcp
        features["minor_hcp"] = c_hcp + d_hcp
        features["spade_hcp"] = s_hcp
        features["heart_hcp"] = h_hcp
        features["diamond_hcp"] = d_hcp
        features["club_hcp"] = c_hcp

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

        king_count = sum(((m >> 11) & 1) for m in (s_mask, h_mask, d_mask, c_mask))
        queen_count = sum(((m >> 10) & 1) for m in (s_mask, h_mask, d_mask, c_mask))
        jack_count = sum(((m >> 9) & 1) for m in (s_mask, h_mask, d_mask, c_mask))

        features["king_count"] = king_count
        features["queen_count"] = queen_count
        features["jack_count"] = jack_count
        features["keycard_count_1430"] = hand.ace_count # Base aces

        # 5. Suit specific honors
        for suit, mask, s_len in ((Suit.CLUBS, c_mask, c_len),
                                  (Suit.DIAMONDS, d_mask, d_len),
                                  (Suit.HEARTS, h_mask, h_len),
                                  (Suit.SPADES, s_mask, s_len)):
            s_name = str(suit).lower()
            has_ace = bool(mask & (1 << 12))
            has_king = bool(mask & (1 << 11))
            has_queen = bool(mask & (1 << 10))
            has_jack = bool(mask & (1 << 9))
            has_ten = bool(mask & (1 << 8))

            features[f"{s_name}_has_ace"] = has_ace
            features[f"{s_name}_has_king"] = has_king
            features[f"{s_name}_has_queen"] = has_queen
            features[f"{s_name}_has_jack"] = has_jack
            features[f"{s_name}_has_ten"] = has_ten

            top2 = (1 if has_ace else 0) + (1 if has_king else 0)
            top3 = top2 + (1 if has_queen else 0)
            features[f"{s_name}_top2_honors"] = top2
            features[f"{s_name}_top3_honors"] = top3

            # Stopper level (None=0, Half=1, Single=2, Double=3)
            stopper = 0
            if has_ace:
                stopper = 2
            elif has_king and s_len >= 2:
                stopper = 2
            elif has_queen and s_len >= 3:
                stopper = 1
            elif has_jack and has_ten and s_len >= 3:
                stopper = 1
            features[f"{s_name}_stopper"] = stopper

        # 6. Evaluation metrics: Total Points, Loser Count (LTC), Quick Tricks
        features["total_points"] = hand.total_points

        # Losing Trick Count (LTC)
        ltc = 0
        for mask, s_len in ((c_mask, c_len), (d_mask, d_len), (h_mask, h_len), (s_mask, s_len)):
            if s_len == 0:
                continue
            has_ace = bool(mask & (1 << 12))
            has_king = bool(mask & (1 << 11))
            has_queen = bool(mask & (1 << 10))
            if s_len == 1:
                if not has_ace:
                    ltc += 1
            elif s_len == 2:
                if not has_ace:
                    ltc += 1
                if not has_king:
                    ltc += 1
            else: # length >= 3
                if not has_ace:
                    ltc += 1
                if not has_king:
                    ltc += 1
                if not has_queen:
                    ltc += 1
        features["losing_trick_count"] = ltc

        # Quick Tricks
        quick_tricks = 0.0
        for mask, s_len in ((c_mask, c_len), (d_mask, d_len), (h_mask, h_len), (s_mask, s_len)):
            has_ace = bool(mask & (1 << 12))
            has_king = bool(mask & (1 << 11))
            has_queen = bool(mask & (1 << 10))
            if has_ace and has_king:
                quick_tricks += 2.0
            elif has_ace and has_queen:
                quick_tricks += 1.5
            elif has_ace:
                quick_tricks += 1.0
            elif has_king and has_queen:
                quick_tricks += 1.0
            elif has_king and s_len >= 2:
                quick_tricks += 0.5
        features["quick_tricks"] = quick_tricks

        hand._cached_features = features
        return dict(features)

    @staticmethod
    def extract_auction_features(history: List[Call],
                                 my_seat: Seat,
                                 dealer: Seat = Seat.NORTH,
                                 vuln: int = Vulnerability.NONE,
                                 hand: Optional[Hand] = None) -> Dict[str, Any]:
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
        last_opp_bid = None
        for i in range(len(history) - 1, -1, -1):
            caller_seat = Seat((dealer.value + i) % 4)
            if caller_seat in (opp1, opp2) and history[i].type == CallType.BID:
                last_opp_bid = history[i]
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
        features["is_unfavorable_vuln"] = my_vuln and (not opp_vuln)
        features["vuln_pressure"] = ("favorable" if features["is_favorable_vuln"]
                                     else "unfavorable" if features["is_unfavorable_vuln"]
                                     else "equal")

        # ---- opponent aggressiveness / competition modeling ----------------
        # Seat-correct attribution: seat of call i is (dealer + i) % 4
        def _seat_of(idx):
            return Seat((dealer.value + idx) % 4)

        opp_bid_calls = [c for i, c in enumerate(history)
                         if _seat_of(i) in (opp1, opp2) and c.type == CallType.BID]
        my_side_calls = [c for i, c in enumerate(history)
                         if _seat_of(i) in (my_seat, my_seat.partner)
                         and c.type == CallType.BID]
        features["opp_bid_count"] = len(opp_bid_calls)
        features["my_side_bid_count"] = len(my_side_calls)
        features["competition_level"] = sum(
            1 for c in history if c.type != CallType.PASS)

        # auction altitude: highest level reached by anyone
        all_bids = [c for c in history if c.type == CallType.BID]
        features["auction_altitude"] = max((c.level for c in all_bids), default=0)
        features["auction_contested"] = bool(opp_bid_calls) and bool(my_side_calls)

        # preemption: opponents' FIRST bid at level >= 3 (or a 2-level suit
        # opening, classic weak-two) => they are signaling a weak/shaky hand
        opp_first = opp_bid_calls[0] if opp_bid_calls else None
        features["opp_preempted"] = bool(
            opp_first and (opp_first.level >= 3 or
                           (opp_first.level == 2 and opp_first.strain is not None
                            and opp_first.strain != Strain.NT
                            and len(history) <= 4)))
        features["opp_first_bid_level"] = opp_first.level if opp_first else 0

        # rough strength class inferred from opponents' bidding shape
        if features["opp_preempted"]:
            features["opp_strength_class"] = "weak"
        elif opp_first is not None and opp_first.level >= 4:
            features["opp_strength_class"] = "strong"
        else:
            features["opp_strength_class"] = "unknown"

        # fit inference: how many distinct suits each side has bid
        opp_suits = {c.strain for c in opp_bid_calls
                     if c.strain is not None and c.strain != Strain.NT}
        my_suits = {c.strain for c in my_side_calls
                    if c.strain is not None and c.strain != Strain.NT}
        features["opp_fit_shown"] = len(opp_suits) >= 2
        partner_suits = {c.strain for c in bids_by_seat[my_seat.partner]
                         if c.type == CallType.BID and c.strain is not None
                         and c.strain != Strain.NT}
        my_own_suits = {c.strain for c in bids_by_seat[my_seat]
                        if c.type == CallType.BID and c.strain is not None
                        and c.strain != Strain.NT}
        # true shown fit: BOTH members of the partnership bid the same suit
        features["our_fit_shown"] = bool(my_own_suits & partner_suits)

        # partner competition signal: has partner made a non-pass, non-first
        # bid (i.e., partner voluntarily re-entered the auction)
        features["partner_rebid"] = len(
            [c for c in bids_by_seat[my_seat.partner]]) >= 2

        # ---- support for partner's shown suit (raise decisions) ------------
        partner_last_bid = None
        for c in reversed(bids_by_seat[my_seat.partner]):
            if c.type == CallType.BID and c.strain is not None \
                    and c.strain != Strain.NT:
                partner_last_bid = c
                break
        if partner_last_bid is not None:
            features["partner_last_bid_strain"] = str(partner_last_bid.strain)
            if hand is not None:
                features["support_in_partner_suit"] = len(
                    hand.by_suit.get(partner_last_bid.strain, []))
            else:
                features["support_in_partner_suit"] = -1
        else:
            features["partner_last_bid_strain"] = "NONE"
            features["support_in_partner_suit"] = -1

        # ---- NT stopper quality in opponents' bid suits ---------------------
        # Deterministic holding check: A=2, guarded K (K + 1 other)=1,
        # guarded Q (Q + 2 others)=0.5; the best stopper across every suit
        # the opponents have bid. 0.0 => no stopper anywhere.
        def _stopper_q(suit):
            cards = hand.by_suit.get(suit, [])
            ranks = {c.rank for c in cards}
            if Rank.ACE in ranks:
                return 2.0
            if Rank.KING in ranks and len(cards) >= 2:
                return 1.0
            if Rank.QUEEN in ranks and len(cards) >= 3:
                return 0.5
            return 0.0

        if opp_suits and hand is not None:
            features["opp_suit_stoppers"] = max(_stopper_q(s) for s in opp_suits)
        else:
            features["opp_suit_stoppers"] = 2.0   # nothing to stop / no hand: treat as safe
        features["has_stopper"] = features["opp_suit_stoppers"] > 0


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
        a_feats = BridgeFeatures.extract_auction_features(history, my_seat, dealer, vuln, hand=hand)
        return {**h_feats, **a_feats}
