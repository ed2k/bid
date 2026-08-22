import unittest
import random

from bid.models import Seat, Suit, Strain
from bid.sampling import Deal
from bid.sds import SDSScorer


class TestSDSScorer(unittest.TestCase):
    def _deal(self):
        import random as _r
        _r.seed(7)
        return Deal.random_deal(dealer=Seat.NORTH)

    def test_known_seats_preserved(self):
        deal = self._deal()
        scorer = SDSScorer(num_worlds=5, seed=1)
        worlds = scorer.sample_worlds(deal, (Seat.SOUTH, Seat.NORTH), 5, random.Random(1))
        unknown = [s for s in Seat if s not in (Seat.SOUTH, Seat.NORTH)]
        for cards_a, cards_b in worlds:
            self.assertEqual(len(cards_a), len(deal.hands[unknown[0]].cards))
            self.assertEqual(len(cards_b), len(deal.hands[unknown[1]].cards))
            combined = sorted((c.suit, c.rank.value) for c in cards_a + cards_b)
            truth = sorted((c.suit, c.rank.value) for s in unknown for c in deal.hands[s].cards)
            self.assertEqual(combined, truth)
        self.assertEqual(len(worlds), 5)

    def test_deterministic_with_seed(self):
        deal = self._deal()
        w1 = SDSScorer.sample_worlds(deal, (Seat.EAST, Seat.WEST), 4, random.Random(42))
        w2 = SDSScorer.sample_worlds(deal, (Seat.EAST, Seat.WEST), 4, random.Random(42))
        self.assertEqual(
            [[(c.suit, c.rank.value) for c in cs] for pair in w1 for cs in pair],
            [[(c.suit, c.rank.value) for c in cs] for pair in w2 for cs in pair])

    def test_score_contract_bounds(self):
        deal = self._deal()
        res = SDSScorer(num_worlds=6, seed=3).score_contract(
            deal, level=3, strain=Strain.NT, declarer=Seat.SOUTH, vuln=0)
        self.assertEqual(res.num_worlds, 6)
        self.assertTrue(-800 <= res.mean_score <= 800)
        self.assertTrue(0.0 <= res.p_make <= 1.0)
        self.assertTrue(0 <= res.mean_tricks <= 13)


if __name__ == "__main__":
    unittest.main()
