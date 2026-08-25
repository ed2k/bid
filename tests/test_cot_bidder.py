import json
import os
import unittest

from bid.models import Seat, Suit, Strain, Rank, Call, CallType

sys_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys_path_root = os.path.dirname(sys_path)
for pth in (sys_path, sys_path_root):
    if pth not in __import__("sys").path:
        __import__("sys").path.insert(0, pth)

from cot_bidder import verify_constraints, bid_legal, load_traces, distance


class TestConstraintVerifier(unittest.TestCase):
    def test_all_hold(self):
        feats = {"hcp": 17, "is_balanced": True}
        cons = [["hcp", ">=", 15], ["hcp", "<=", 17], ["is_balanced", "==", True]]
        ok, fails = verify_constraints(cons, feats)
        self.assertTrue(ok)
        self.assertEqual(fails, [])

    def test_detects_violation(self):
        feats = {"hcp": 11, "spade_len": 2}
        cons = [["spade_len", "<=", 2], ["hcp", ">=", 11]]
        ok, _ = verify_constraints(cons, feats)
        self.assertTrue(ok)
        ok, fails = verify_constraints([["spade_len", ">=", 5]], feats)
        self.assertFalse(ok)
        self.assertEqual(fails[0][1], ">=")

    def test_in_operator(self):
        ok, _ = verify_constraints(
            [["partner_last_call", "in", ["1C", "1D"]]],
            {"partner_last_call": "1C"})
        self.assertTrue(ok)


class TestBidLegality(unittest.TestCase):
    def test_no_double_before_bid(self):
        self.assertFalse(bid_legal("X", [], seat_i=1))
        self.assertTrue(bid_legal("PASS", [], seat_i=1))

    def test_level_ordering(self):
        auction = ["1C"]
        self.assertTrue(bid_legal("1D", auction, seat_i=1))
        self.assertFalse(bid_legal("1C", auction, seat_i=1))
        self.assertTrue(bid_legal("2C", auction, seat_i=3))

    def test_malformed_rejected(self):
        self.assertFalse(bid_legal("9X", ["1C"], seat_i=1))


class TestCorpusInvariants(unittest.TestCase):
    CORPUS = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                          "data", "traces", "traces.jsonl")

    @unittest.skipUnless(os.path.exists(CORPUS), "corpus not generated")
    def test_constraints_hold_on_features(self):
        bad = 0
        for i, line in enumerate(open(self.CORPUS)):
            t = json.loads(line)
            ok, fails = verify_constraints(t["explanation"]["constraints"],
                                           t["input"]["features"])
            if not ok:
                bad += 1
                if bad <= 3:
                    print(f"trace {i}: {fails}")
        self.assertEqual(bad, 0)

    @unittest.skipUnless(os.path.exists(CORPUS), "corpus not generated")
    def test_distance_symmetry_sample(self):
        tr = load_traces(self.CORPUS)[:20]
        a, b = tr[0]["input"]["features"], tr[1]["input"]["features"]
        d_ab = distance(a, b)
        d_ba = distance(b, a)
        self.assertAlmostEqual(d_ab, d_ba, places=9)


if __name__ == "__main__":
    unittest.main()
