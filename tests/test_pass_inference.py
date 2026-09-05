import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from bid.constraints import HandConstraints
from bid.engine import Engine
from bid.models import Call, CallType, Seat, Strain
from bid.translator import SystemTranslator

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


class TestPassInference(unittest.TestCase):
    """research/todo.md item 4: a PASS must yield information — the crude
    complement of declined lower-bound system rules."""

    def setUp(self):
        self.precision = SystemTranslator().parse(
            open(os.path.join(REPO, "system", "precision.dsl")).read())
        self.engine = Engine(self.precision)

    def test_constraints_module_supports_cap(self):
        c = HandConstraints().cap_above("hcp", 15)
        self.assertEqual(c.hcp_max, 15)
        self.assertEqual(c.hcp_min, 0)
        c2 = HandConstraints().cap_above("spades", 4)
        from bid.models import Suit
        self.assertEqual(c2.length_max[Suit.SPADES], 4)

    def test_passing_over_strong_club_bounds_hcp(self):
        """Dealer passes in an uncontested auction over Precision: the
        declined '1C: HCP 16+' must cap the dealer at hcp <= 15."""
        est = self.engine.estimate_deal(
            [Call(CallType.PASS)], Seat.SOUTH, Seat.NORTH,
            self.precision, self.precision)
        north = est[Seat.NORTH]
        self.assertLess(north.hcp_max, 16,
            "passing over Precision 1C (16+) must bound hcp_max <= 15")

    def test_bid_still_intersects_normally(self):
        """A real bid keeps the old behaviour (intersect the rule's constraints)."""
        est = self.engine.estimate_deal(
            [Call(CallType.BID, 1, Strain.CLUBS)],
            Seat.SOUTH, Seat.NORTH, self.precision, self.precision)
        north = est[Seat.NORTH]
        self.assertGreaterEqual(north.hcp_min, 16)


if __name__ == "__main__":
    unittest.main()
