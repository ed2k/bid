from typing import Dict, Any, List, Optional, Tuple
from bid.models import Hand, Card, Suit, Strain, Seat, Rank, Call, CallType
from bid.scoring import Vulnerability

# Partner's calls inverted into an HCP window. Deliberately conservative:
# only calls that unambiguously promise a range narrow it, everything else
# leaves it wide. NT bids are precise (1NT is a 2-point window), suit bids
# are wide, and preempts are capped from above.
#
# UNINFORMATIVE is the "no idea" window, not "no points". Distinguishing it
# matters: a feature that silently says 0 when it means "unknown" teaches
# the tree that partner is broke. 0 and 37 are the true bounds of HCP, so
# they are the honest encoding of ignorance.
_HCP_UNINFORMATIVE = (0, 37)

# level -> (lo, hi) for notrump bids. Brill's NT ladder is standard.
_NT_WINDOWS = {
    1: (15, 17),
    2: (20, 21),
    3: (25, 27),
    4: (28, 30),
    5: (31, 32),
    6: (33, 34),
    7: (35, 37),
}

# 1-level suit opening: wide, and it is the single most common case.
_SUIT_1_WINDOW = (11, 21)
# 2C strong/artificial vs every other 2-level call, which is weak.
_SUIT_2C_WINDOW = (22, 37)
_SUIT_2_WEAK_WINDOW = (5, 10)
# 3-level and up in a suit is a preempt unless it was forced there.
_SUIT_PREEMPT_WINDOW = (5, 10)


def _partner_hcp_window(partner_calls: List[Call]) -> Tuple[int, int]:
    """Invert partner's *bids* into the HCP range they have promised.

    Passes, doubles and redoubles are ignored: a pass says "not enough to
    open" only in some seats, and a double is ambiguous between takeout and
    penalty, so neither is safe to invert. That keeps this a lower bound on
    what is knowable rather than a guess.

    Windows are intersected in the order the bids were made, which is what
    a real partnership does -- 1H then 2NT means 20-21, not 11-21. When a
    later bid contradicts the range already established (e.g. an opening
    followed by a preemptive-looking jump) the later bid is dropped rather
    than collapsing the whole thing to "unknown": the earlier, wider
    commitment is the one that is still true.
    """
    lo, hi = _HCP_UNINFORMATIVE
    for call in partner_calls or []:
        if call.type != CallType.BID:
            continue
        lvl = call.level
        if call.strain == Strain.NT:
            win = _NT_WINDOWS.get(lvl)
        elif lvl == 1:
            win = _SUIT_1_WINDOW
        elif lvl == 2:
            win = (_SUIT_2C_WINDOW if call.strain == Strain.CLUBS
                   else _SUIT_2_WEAK_WINDOW)
        elif lvl >= 3:
            win = _SUIT_PREEMPT_WINDOW
        else:
            win = None
        if win is None:
            continue
        nlo, nhi = max(lo, win[0]), min(hi, win[1])
        if nlo > nhi:
            # Contradiction: keep what was already established.
            continue
        lo, hi = nlo, nhi
    return lo, hi


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

        # --- longest / best-suit predicates ---------------------------------
        # Brill writes `clublongest`, `bestsuit('D')`, `bestmajor('H')`,
        # `bestminor('C')` — 171 occurrences between them. All mean "suit X is
        # the longest", i.e. a FEATURE-TO-FEATURE comparison
        # (X_len >= longest_suit_len), which the DSL cannot express: the RHS
        # would be parsed as the string 'longest_suit_len'. Precomputed here
        # instead.
        #
        # Ties are INCLUDED. Brill's own row
        #   diamondlongest and not (diamonds >= 5 and (spadelongest or heartlongest))
        # only has a meaning if a 5-5 tie marks BOTH suits as longest —
        # that is exactly the case the `not` clause exists to exclude.
        longest = lengths_sorted[0]
        for suit, n in ((Suit.CLUBS, c_len), (Suit.DIAMONDS, d_len),
                        (Suit.HEARTS, h_len), (Suit.SPADES, s_len)):
            features[f"{str(suit).lower()}_is_longest"] = (n == longest)
        # "best major"/"best minor" = the longer of the two, ties included.
        features["h_is_best_major"] = h_len >= s_len
        features["s_is_best_major"] = s_len >= h_len
        features["c_is_best_minor"] = c_len >= d_len
        features["d_is_best_minor"] = d_len >= c_len

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
        # Aces only — this is NOT the RKCB 1430 keycard count, which also
        # includes the king of trump. That needs `agreed_trump` and lives in
        # `keycard_count_agreed` (see extract_auction_features).
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

            # Brill's `realsolid('X')` gates 256 slam rows
            # (`6X <- realsolid('X') and losers == 1`). Fitted against Brill's
            # own engine by holding `losers` fixed and varying only this suit:
            # 350/350 on held-out hands. See status §6.53.
            #
            # It is NOT "AKQ and 6+", which is the obvious guess and is wrong.
            # Ace and king are both mandatory; the queen, jack and ten then
            # move the length threshold:
            #     AKQJ -> 6+    AKQT -> 7+    AKQ -> 8+    AKJ(+-T) -> 9+
            # `AK` and `AKT` are never realsolid at any length, and the ten
            # only counts when the queen is there and the jack is not.
            if s_len < 6 or not (has_ace and has_king):
                realsolid = False
            elif has_queen and has_jack:
                realsolid = True           # AKQJ, 6+
            elif has_queen and has_ten:
                realsolid = s_len >= 7     # AKQT, 7+
            elif has_queen:
                realsolid = s_len >= 8     # AKQ, 8+
            elif has_jack:
                realsolid = s_len >= 9     # AKJ (with or without the ten)
            else:
                realsolid = False
            features[f"{s_name}_realsolid"] = realsolid

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

        # 7. SuitC Hand-Valuation Features (Gerrit van der Velde, SuitC/docs/hand-valuation.md)
        # - Intermediates (T, 9, 8) in long suits (length >= 5, or longest suit if 4333):
        #   SuitC shows QT982 opposite 743 produces 2.84 tricks vs Q5432's 2.26 (+0.58 tricks,
        #   nearly equal to KQ432's 2.91 despite 3 fewer HCP).
        # - Long-suit vs wasted short-suit honours: HCP concentrated in 5+ card suits works
        #   for trick generation, whereas singleton/doubleton K/Q/J without the Ace is wasted.
        long_suit_intermediates = 0
        long_suit_hcp = 0
        short_suit_wasted_hcp = 0
        for mask, s_len, s_hcp_val in (
            (c_mask, c_len, c_hcp),
            (d_mask, d_len, d_hcp),
            (h_mask, h_len, h_hcp),
            (s_mask, s_len, s_hcp),
        ):
            interm_cnt = ((mask >> 8) & 1) + ((mask >> 7) & 1) + ((mask >> 6) & 1)
            if s_len >= 5 or s_len == longest:
                long_suit_intermediates += interm_cnt
            if s_len >= 5:
                long_suit_hcp += s_hcp_val
            if s_len <= 2 and not (mask & (1 << 12)):
                short_suit_wasted_hcp += s_hcp_val

        features["long_suit_intermediates"] = long_suit_intermediates
        features["long_suit_hcp"] = long_suit_hcp
        features["short_suit_wasted_hcp"] = short_suit_wasted_hcp

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

        # ---- inferred partnership assets --------------------------------
        # Deciding game and slam means combining YOUR hand with the range
        # partner has shown. Nothing here exposed that: `partner_last_call`
        # is a bare category, so a depth-limited tree has to spend one split
        # per call value to learn "with 1NT opposite, 25 is enough". That is
        # ruinously expensive in tree budget, and §6.65 measured the result:
        # agreement is 96.5% on PASS and 92.6% on 1-level calls but 22-27%
        # on game and slam, which is where the IMPs are.
        #
        # Measured before building: across 40,779 traces where partner's call
        # is invertible, P(Brill bids game) rises monotonically 0% -> 51%
        # with combined_hcp_min. The signal is there; it was just not
        # reachable. Two numbers make it a single split.
        # `combined_hcp_*` lives in extract_all, not here: this function
        # builds its own features dict and has no `hcp` key, so adding my
        # HCP in this scope would silently produce the partner window alone.
        plo, phi = _partner_hcp_window(partner_bids)
        features["partner_hcp_min"] = plo
        features["partner_hcp_max"] = phi

        my_bids = bids_by_seat[my_seat]
        features["my_last_call"] = str(my_bids[-1]) if my_bids else "NONE"

        opp1 = Seat((my_seat.value + 1) % 4)
        opp2 = Seat((my_seat.value + 3) % 4)
        opp_bids = bids_by_seat[opp1] + bids_by_seat[opp2]
        features["opponents_bid"] = any(c.type == CallType.BID for c in opp_bids)

        # ---- auction routing identity -----------------------------------
        # `*_last_call` says what was said most recently. These say how the
        # auction *began*, which is what actually selects the branch of the
        # convention tree: Stayman and transfers only exist after 1NT, cue
        # bids only after an overcall, and so on. Without them a model has to
        # infer the branch from `auction_len` and the current bid alone.
        #
        # That is the gap §6.60 measured: distillation reproduces 78.1% of
        # Brill's calls yet loses ~4 IMP/board to Brill, because picking the
        # wrong branch is not a one-call mistake, it is a different contract
        # entirely. These are strings on purpose -- ID3 can split on them now
        # that categorical support exists, and the DSL spells the result
        # `opening_bid == '1NT'` next to the hand-authored conventions.
        first_bid = next((c for c in history if c.type == CallType.BID), None)
        features["opening_bid"] = str(first_bid) if first_bid else "NONE"
        features["my_first_call"] = str(my_bids[0]) if my_bids else "NONE"
        features["partner_first_call"] = (str(partner_bids[0])
                                          if partner_bids else "NONE")
        opp_first = None
        for i, c in enumerate(history):
            if Seat((dealer.value + i) % 4) in (opp1, opp2):
                opp_first = c
                break
        features["opp_first_call"] = str(opp_first) if opp_first else "NONE"

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

        # ---- agreed trump: the auction's semantic state --------------------
        # The auction-agreed strain is the most recently bid suit that BOTH
        # members of the partnership have shown. NT is never a trump
        # agreement. `our_fit_shown` is only a bool; slam conventions need to
        # know *which* suit. Without this, Brill's `havekeycards` (4 aces +
        # the TRUMP king) and `trumpqueen` cannot be written as conditions at
        # all — see research/status.md §6.41.
        shared_suits = my_own_suits & partner_suits
        agreed_trump = None
        if shared_suits:
            for i in range(len(history) - 1, -1, -1):
                c = history[i]
                if (c.type == CallType.BID and c.strain is not None
                        and c.strain in shared_suits):
                    agreed_trump = c.strain
                    break
        features["agreed_trump"] = (str(agreed_trump)
                                    if agreed_trump is not None else "NONE")

        if agreed_trump is not None and hand is not None:
            trump_suit = Suit(agreed_trump.value)   # Strain/Suit share 0..3
            trump_cards = hand.by_suit.get(trump_suit, [])
            trump_ranks = {c.rank for c in trump_cards}
            has_tk = Rank.KING in trump_ranks
            features["agreed_trump_len"] = len(trump_cards)
            features["has_trump_king"] = has_tk
            features["has_trump_queen"] = Rank.QUEEN in trump_ranks
            # RKCB 1430/0314: four aces plus the king of trump.
            features["keycard_count_agreed"] = hand.ace_count + (1 if has_tk else 0)
            features["trump_intermediates"] = sum(
                1 for r in (Rank.TEN, Rank.NINE, Rank.EIGHT) if r in trump_ranks
            )
        else:
            features["agreed_trump_len"] = -1
            features["has_trump_king"] = False
            features["has_trump_queen"] = False
            # No agreed suit (NT auctions, Gerber): keycards are plain aces.
            features["keycard_count_agreed"] = hand.ace_count if hand is not None else -1
            features["trump_intermediates"] = 0

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
        feats = {**h_feats, **a_feats}

        # Rule of 21 — Brill's `ruleof21`. Brill's prose says "if the number
        # of high card points and the number of cards in your two longest
        # suits add to twenty and you have two quick tricks, open the hand.
        # In the third or fourth seats, one only needs 1 1/2 quick tricks
        # (the rule of 21 1/2)" — but the engine does not implement 20.
        #
        # MEASURED, not assumed. 400 probed opening hands (hcp<=11 so the
        # HCP>=12 route cannot apply, no 6+ suit so no preempt, quick tricks
        # >= 2 held constant) — total <= 19 passed 100% of the time, total
        # >= 21 opened 100% of the time, total == 20 was mixed. Brill's own
        # `explanation` prints it as "RuleOf >= 21". So the threshold is 21
        # even though the quantity is the classic rule-of-20 total.
        #
        # Exposed as ONE boolean rather than as `rule20_total >= 21` plus
        # `quick_tricks >= 2` because Brill also writes `not ruleof21` (its
        # "No opening bid" pass rule and the weak-two denies), and a
        # conjunction cannot be negated in this DSL — only a bare boolean
        # can be flipped to `== False`.
        total = (h_feats.get("hcp", 0) + h_feats.get("longest_suit_len", 0)
                 + h_feats.get("second_longest_len", 0))
        feats["rule20_total"] = total
        # With no bid yet, every call in the history is a pass, so the count
        # of them says which seat we are: 0/1 = 1st/2nd, 2/3 = 3rd/4th.
        third_or_fourth = bool(a_feats.get("is_opening")) and len(history) >= 2
        need_qt = 1.5 if third_or_fourth else 2.0
        feats["rule_of_21"] = (total >= 21
                               and h_feats.get("quick_tricks", 0.0) >= need_qt)

        # Partnership assets: my HCP combined with the range partner has
        # promised. This is the quantity game and slam decisions are
        # actually made on, and it could previously only be reconstructed
        # by splitting on `partner_last_call` once per call value. See the
        # comment on `partner_hcp_min` in extract_auction_features.
        # Clamped at 40 because that is all the HCP in the deck. Without the
        # clamp, "partner is unknown" reads as my_hcp + 37, which can exceed
        # 40 and would let the tree split on values no deal can produce.
        my_hcp = int(h_feats.get("hcp") or 0)
        feats["combined_hcp_min"] = my_hcp + int(a_feats.get("partner_hcp_min", 0))
        feats["combined_hcp_max"] = min(
            40, my_hcp + int(a_feats.get("partner_hcp_max", 37)))
        return feats
