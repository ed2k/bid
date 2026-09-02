import json
import os
import unittest

from bid.models import Seat, Suit, Strain, Rank, Call, CallType

sys_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys_path_root = os.path.dirname(sys_path)
for pth in (sys_path, sys_path_root):
    if pth not in __import__("sys").path:
        __import__("sys").path.insert(0, pth)

from bid.cot_bidder import verify_constraints, bid_legal, load_traces, distance


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
        with open(self.CORPUS, "r", encoding="utf-8") as f:
            for i, line in enumerate(f):
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


class TestBatchedNeuralInference(unittest.TestCase):
    def test_generate_batch_synthetic(self):
        try:
            import torch
            from bid.cot_model import COTModel, generate_batch
        except ImportError:
            self.skipTest("torch not installed")

        torch.manual_seed(42)
        vocab_size = 30
        model = COTModel(vocab_size=vocab_size, block_size=32, n_layer=1, n_head=1, n_embd=16)
        model.eval()

        prompts = [
            [1, 5, 8],
            [1, 4, 7, 10, 12],
            [1, 2],
        ]

        results = generate_batch(model, prompts, max_new=10, temp=0.0, batch_size=2)
        self.assertEqual(len(results), len(prompts))
        for r in results:
            self.assertIn("generated_ids", r)
            self.assertIn("confidences", r)
            self.assertIn("entropies", r)
            self.assertIn("avg_confidence", r)
            self.assertIn("avg_entropy", r)
            self.assertGreaterEqual(r["avg_confidence"], 0.0)
            self.assertLessEqual(r["avg_confidence"], 1.0)
            self.assertGreaterEqual(r["avg_entropy"], 0.0)


if __name__ == "__main__":
    unittest.main()
