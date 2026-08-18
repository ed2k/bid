import unittest
from bid.models import Hand, Seat, Call, CallType, Strain
from bid.invention import BidInventionEngine

class TestBidInventionE2E(unittest.TestCase):

    def test_e2e_engine_bidding(self):
        engine = BidInventionEngine(sample_size=3, max_lookahead_depth=2)

        # South opens 1NT with 16 HCP balanced (4-3-3-3, 16 HCP)
        hand_1nt = Hand.from_string("SAK4 HK32 DQ32 CA432")
        call, values = engine.get_bid(hand_1nt, history=[], my_seat=Seat.SOUTH, dealer=Seat.SOUTH)
        self.assertEqual(call, Call(CallType.BID, 1, Strain.NT))

        # South opens 1H with 13 HCP and 5 hearts (5-3-3-2, 13 HCP)
        hand_1h = Hand.from_string("SAK4 HKQJ32 D432 C43")
        call_h, values_h = engine.get_bid(hand_1h, history=[], my_seat=Seat.SOUTH, dealer=Seat.SOUTH)
        self.assertEqual(call_h, Call(CallType.BID, 1, Strain.HEARTS))

    def test_e2e_co_training(self):
        engine = BidInventionEngine(sample_size=2, max_lookahead_depth=2)
        results = engine.run_co_training(rounds=1, states_per_round=4)

        self.assertIn("rounds", results)
        self.assertEqual(len(results["rounds"]), 1)

if __name__ == "__main__":
    unittest.main()
