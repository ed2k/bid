import unittest

from bid.features import BridgeFeatures
from bid.models import Call, CallType, Card, Hand, Rank, Seat, Strain, Suit
from bid.sampling import Deal
from bid.sds import (
    Front,
    OutcomeVector,
    PlayPosition,
    PlaySearcher,
    SDSScorer,
    SearchConfig,
    canonical_legal_cards,
)
from bid.suitc import SuitCSolver


class TestSuitCSolver(unittest.TestCase):
    def test_classic_finesse_aq2_opposite_543(self):
        """AQ2 opposite 543: 2 tricks 50.4845%, expected 1.5048 tricks."""
        self.assertTrue(SuitCSolver.is_available())
        res = SuitCSolver.analyze_cards("AQ2", "543")
        self.assertEqual(res.min_tricks, 1)
        self.assertEqual(res.max_tricks, 2)
        self.assertAlmostEqual(res.expected_tricks, 1.5048, places=4)
        self.assertAlmostEqual(res.p_at_least(1), 1.0, places=6)
        self.assertAlmostEqual(res.p_at_least(2), 0.504845, places=5)
        self.assertAlmostEqual(res.p_at_least(3), 0.0, places=6)

    def test_intermediates_value_hand_valuation_md(self):
        """Verify Gerrit's hand-valuation.md finding: QT982 opposite 765 vastly outperforms Q432."""
        r_kq = SuitCSolver.analyze_cards("765", "KQ432")
        r_q_spot = SuitCSolver.analyze_cards("765", "Q432")
        r_qt98 = SuitCSolver.analyze_cards("765", "QT982")

        self.assertGreater(r_qt98.expected_tricks, r_q_spot.expected_tricks + 0.5)
        self.assertGreater(r_kq.expected_tricks, r_q_spot.expected_tricks + 0.5)

    def test_vacant_places_shifts_finesse_odds(self):
        """With West holding 6 vacant places vs East 12, AQ2/543 drops to 33.34%."""
        res = SuitCSolver.analyze_cards("AQ2", "543", west_vacant=6, east_vacant=12)
        self.assertAlmostEqual(res.p_at_least(2), 0.333387, places=5)
        self.assertAlmostEqual(res.expected_tricks, 1.3334, places=4)

    def test_stopper_analysis_defense_mode(self):
        """Guarded King (K43 opposite 652) stops the suit when East leads (-D -Le)."""
        res = SuitCSolver.stopper_tricks("K43", "652", leader="e")
        self.assertAlmostEqual(res.expected_tricks, 1.0, places=4)
        self.assertAlmostEqual(res.p_at_least(1), 1.0, places=4)

    def test_void_and_full_suit_edge_cases(self):
        r_void = SuitCSolver.analyze_cards(".", ".")
        self.assertEqual(r_void.expected_tricks, 0.0)
        self.assertEqual(r_void.max_tricks, 0)

        r_akq = SuitCSolver.analyze_cards("AKQ", ".")
        self.assertAlmostEqual(r_akq.expected_tricks, 3.0, places=4)


class TestSuitCHandValuationFeatures(unittest.TestCase):
    def test_intermediates_and_wasted_short_honors(self):
        # Spades: Q T 9 8 2 (5 cards, 2 HCP, 3 intermediates: T,9,8)
        # Hearts: K Q (2 cards, 5 HCP without Ace -> 5 wasted short-suit HCP)
        # Diamonds: A 3 (2 cards, 4 HCP with Ace -> 0 wasted HCP)
        # Clubs: 7 6 5 4 (4 cards, 0 HCP, 0 intermediates)
        cards = [
            Card(Suit.SPADES, Rank.QUEEN),
            Card(Suit.SPADES, Rank.TEN),
            Card(Suit.SPADES, Rank.NINE),
            Card(Suit.SPADES, Rank.EIGHT),
            Card(Suit.SPADES, Rank.TWO),
            Card(Suit.HEARTS, Rank.KING),
            Card(Suit.HEARTS, Rank.QUEEN),
            Card(Suit.DIAMONDS, Rank.ACE),
            Card(Suit.DIAMONDS, Rank.THREE),
            Card(Suit.CLUBS, Rank.SEVEN),
            Card(Suit.CLUBS, Rank.SIX),
            Card(Suit.CLUBS, Rank.FIVE),
            Card(Suit.CLUBS, Rank.FOUR),
        ]
        hand = Hand(cards)
        h_feats = BridgeFeatures.extract_hand_features(hand)
        self.assertEqual(h_feats["long_suit_intermediates"], 3)
        self.assertEqual(h_feats["long_suit_hcp"], 2)
        self.assertEqual(h_feats["short_suit_wasted_hcp"], 5)

        # Auction agreeing spades: N=1S, E=PASS, S=2S
        history = [
            Call(CallType.BID, 1, Strain.SPADES),
            Call(CallType.PASS),
            Call(CallType.BID, 2, Strain.SPADES),
        ]
        all_feats = BridgeFeatures.extract_all(hand, history, Seat.NORTH, dealer=Seat.NORTH)
        self.assertEqual(all_feats["agreed_trump"], "S")
        self.assertEqual(all_feats["trump_intermediates"], 3)


class TestParetoFrontAndNonFusion(unittest.TestCase):
    def test_front_prevents_strategy_fusion_at_interior_max_node(self):
        """
        Construct a 1-trick, 2-world position where North (Max) leads H2,
        East (Min) must follow with H3 in both worlds, and South (Max, interior node)
        holds {SA, HA} (1-card trick? No, 1 card per hand: let's use a 2-card endgame
        or mid-trick position where South is to play!).
        """
        # Trick in progress: North led C2, East played C3, South (Max) is to play
        # with 1 card left in South's hand? No, South has 2 cards {HA, SA} and must
        # discard on C2 (trump = Spades in world 0? No, trump is fixed: trump = NT,
        # wait: if South has 2 cards left, it's a 2-trick game!).
        # Even simpler: 1-trick game where North led C2, East played C3, and South (Max)
        # has 2 legal cards {CA, CK}? No, in a 1-trick game everyone has 1 card.
        # In a 2-trick game:
        # Trick 1: North (Max) has {HA, H2}, South (Max) has {SA, DA}.
        # World 0: West has {HK, S2}, East has {HQ, D2}.
        # World 1: West has {HQ, D2}, East has {HK, S2}.
        # Look at Trick 1 if North leads H2:
        #   East plays HQ (in w0) / HK (in w1)? Wait: give East {H3, S2/D2} in both worlds!
        # Let's set trump = NT:
        #   North (Max): {HA, C2}
        #   East  (Min): {C3, S2} in World 0, {C3, D2} in World 1
        #   South (Max): {SA, DA} (void in Clubs! Must discard on Trick 1 when North leads C2!)
        #   West  (Min): {C4, D2} in World 0, {C4, S2} in World 1
        # Trace when North leads C2 on Trick 1:
        #   1. North leads C2.
        #   2. East must follow suit with C3 in BOTH World 0 and World 1!
        #   3. Now South (interior Max node!) is void in Clubs and must discard either SA or DA:
        #      - If South discards DA (keeping SA):
        #        West wins Trick 1 with C4 and leads Trick 2:
        #        In World 0, West's remaining card is D2; North has HA, East has S2, South has SA -> West wins D2! (Max gets 0 tricks in w0).
        #        In World 1, West's remaining card is S2; South's SA wins Trick 2! (Max gets 1 trick in w1).
        #        So keeping SA gives OutcomeVector([0, 1]).
        #      - If South discards SA (keeping DA):
        #        West wins Trick 1 with C4 and leads Trick 2:
        #        In World 0, West leads D2 and South's DA wins Trick 2! (Max gets 1 trick in w0).
        #        In World 1, West leads S2 and wins Trick 2! (Max gets 0 tricks in w1).
        #        So keeping DA gives OutcomeVector([1, 0]).
        # Notice:
        #   - A fused searcher (`elementwise_max` at South) claims leading C2 gives
        #     max([0, 1], [1, 0]) = [1, 1] (mean 1.0 trick)!
        #   - An exact non-fused Pareto-front searcher (`Front.union` at South) keeps
        #     Front({[0, 1], [1, 0]}), so leading C2 gives mean 0.5 tricks, and North
        #     correctly prefers cashing HA (which guarantees [1, 1], mean 1.0 trick)!
        north = [Card(Suit.HEARTS, Rank.ACE), Card(Suit.CLUBS, Rank.TWO)]
        south = [Card(Suit.SPADES, Rank.ACE), Card(Suit.DIAMONDS, Rank.ACE)]
        w0 = {
            Seat.NORTH: list(north),
            Seat.SOUTH: list(south),
            Seat.EAST: [Card(Suit.CLUBS, Rank.THREE), Card(Suit.SPADES, Rank.TWO)],
            Seat.WEST: [Card(Suit.CLUBS, Rank.FOUR), Card(Suit.DIAMONDS, Rank.TWO)],
        }
        w1 = {
            Seat.NORTH: list(north),
            Seat.SOUTH: list(south),
            Seat.EAST: [Card(Suit.CLUBS, Rank.THREE), Card(Suit.DIAMONDS, Rank.TWO)],
            Seat.WEST: [Card(Suit.CLUBS, Rank.FOUR), Card(Suit.SPADES, Rank.TWO)],
        }
        pos = PlayPosition(
            hands={Seat.NORTH: list(north), Seat.SOUTH: list(south)},
            trump=Strain.NT,
            declarer=Seat.NORTH,
            to_play=Seat.NORTH,
            leader=Seat.NORTH,
            trick=[],
            tricks_max=0,
            tricks_min=0,
        )
        res = PlaySearcher(SearchConfig(target=1)).solve_amu(pos, [w0, w1])
        ha, c2 = north[0], north[1]
        self.assertAlmostEqual(res.per_move[c2].mean(), 0.5, places=6)
        self.assertAlmostEqual(res.per_move[ha].mean(), 1.0, places=6)
        self.assertEqual(res.best_card, ha)

    def test_canonical_legal_cards_collapses_touching_honors(self):
        hand = [
            Card(Suit.SPADES, Rank.QUEEN),
            Card(Suit.SPADES, Rank.JACK),
            Card(Suit.SPADES, Rank.TEN),
            Card(Suit.SPADES, Rank.FIVE),
            Card(Suit.SPADES, Rank.FOUR),
        ]
        canon = canonical_legal_cards(hand, [])
        self.assertEqual(
            [str(c) for c in canon],
            ["QS", "5S"],
        )

    def test_vacant_places_inference(self):
        # Dealer North: N=PASS, E=3H (7 hearts -> 6 vacant), S=PASS, W=1S (5 spades -> 8 vacant)
        history = [
            Call(CallType.PASS),
            Call(CallType.BID, 3, Strain.HEARTS),
            Call(CallType.PASS),
            Call(CallType.BID, 1, Strain.SPADES),
        ]
        vac = SDSScorer.infer_vacant_places(history, Seat.NORTH, (Seat.NORTH, Seat.SOUTH))
        self.assertEqual(vac[Seat.EAST], 6)
        self.assertEqual(vac[Seat.WEST], 8)


if __name__ == "__main__":
    unittest.main()

