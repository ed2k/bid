import os
import sys
import tempfile
import unittest

import torch

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if os.path.join(REPO_ROOT, "src") not in sys.path:
    sys.path.insert(0, os.path.join(REPO_ROOT, "src"))
if os.path.join(REPO_ROOT, "research") not in sys.path:
    sys.path.insert(0, os.path.join(REPO_ROOT, "research"))

import gpu_arena as ga
import jps_search as jps
from bid.diff_dsl_net import BidExplanation, DiffDSLNet
from bid.eval_vs_dds import build_deals


class TestDiffDSLNetAndJPS(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.dsl_path = os.path.join(REPO_ROOT, "system", "brill_gpu_evolved.dsl")
        cls.deals = build_deals(16, seed=7, include_stratified=False)
        full_bundle = ga.DealBundle.load(os.path.join(REPO_ROOT, "data", "colab_bundle_500.pt"), device="cpu")
        cls.bundle = jps.slice_bundle(full_bundle, torch.arange(16))

    def test_exact_parity_with_tensor_decision_net(self):
        t_net = ga.TensorDecisionNet.from_dsl(self.dsl_path, device="cpu")
        d_net = DiffDSLNet.from_dsl(self.dsl_path, device="cpu")

        env = ga.BatchedAuctionEnv(self.bundle)
        env.passes_since_last_np = torch.zeros(env.B, dtype=torch.long)
        total = 0
        mismatches = 0
        for _ in range(20):
            if bool(env.done.all().item()):
                break
            X, seat = env.build_features()
            lmask = env.legal_mask(seat)
            _, tc = t_net.call_scores(X, lmask)
            _, dc = d_net.call_scores(X, lmask, soft=False)
            active = ~env.done
            total += int(active.sum().item())
            mismatches += int((tc[active] != dc[active]).sum().item())
            env.step(dc)
        self.assertGreater(total, 50)
        self.assertEqual(mismatches, 0)

    def test_every_bid_is_explainable(self):
        d_net = DiffDSLNet.from_dsl(self.dsl_path, device="cpu")
        env = ga.BatchedAuctionEnv(self.bundle)
        env.passes_since_last_np = torch.zeros(env.B, dtype=torch.long)
        X, seat = env.build_features()
        lmask = env.legal_mask(seat)
        _, calls = d_net.call_scores(X, lmask, soft=False)
        exps = d_net.explain_batch(X, lmask)

        self.assertEqual(len(exps), self.bundle.num_boards)
        for b, ex in enumerate(exps):
            self.assertIsInstance(ex, BidExplanation)
            self.assertEqual(ex.call_idx, int(calls[b].item()))
            cot = ex.to_cot_str()
            self.assertTrue(cot.startswith("EXPLANATION "))
            self.assertTrue(cot.endswith(f"-> BID {ex.call_str}"))
            for atom_trace in ex.conditions:
                self.assertTrue(atom_trace.satisfied)

        # Single-hand explainability check
        deal0 = self.deals[0]
        hand_ex = d_net.explain_hand(
            deal0.hands[deal0.dealer], [], deal0.dealer, deal0.dealer, deal0.vuln
        )
        self.assertEqual(hand_ex.call_str, exps[0].call_str)
        self.assertEqual(hand_ex.rule_id, exps[0].rule_id)

    def test_ste_gradients_and_round_trip_dsl_export(self):
        d_net = DiffDSLNet.from_dsl(self.dsl_path, device="cpu")
        env = ga.BatchedAuctionEnv(self.bundle)
        env.passes_since_last_np = torch.zeros(env.B, dtype=torch.long)
        X, seat = env.build_features()
        lmask = env.legal_mask(seat)

        out = d_net.forward(X, lmask, soft=True)
        loss = -out["pi"][:, 1:10].sum() + out["v"].sum()
        loss.backward()
        self.assertIsNotNone(d_net.atom_val.grad)
        self.assertIsNotNone(d_net.rule_call_logits.grad)
        self.assertGreater(float(d_net.atom_val.grad.abs().sum().item()), 0.0)
        self.assertGreater(float(d_net.rule_call_logits.grad.abs().sum().item()), 0.0)

        with tempfile.NamedTemporaryFile(suffix=".dsl") as tf:
            d_net.export_dsl(tf.name)
            reloaded = ga.TensorDecisionNet.from_dsl(tf.name, device="cpu")
            orig = ga.TensorDecisionNet.from_dsl(self.dsl_path, device="cpu")
            _, s_orig = ga.play_boards_batched(self.bundle, orig, orig)
            _, s_rel = ga.play_boards_batched(self.bundle, reloaded, reloaded)
            self.assertTrue(torch.equal(s_orig, s_rel))

    def test_jps_coupled_override_and_shrinkage(self):
        t_net = ga.TensorDecisionNet.from_dsl(self.dsl_path, device="cpu")
        s1, s2, active_mask, pair_tensors = jps.record_jps_coupling_and_baseline(
            self.bundle, t_net, t_net
        )
        self.assertEqual(s1.shape[0], self.bundle.num_boards)
        self.assertEqual(active_mask.shape, (self.bundle.num_boards, t_net.num_rules))

        shrunk_small = jps.jps_shrink_edge(20.0, cnt=2, total_boards=100, lambda_shrink=15.0)
        shrunk_large = jps.jps_shrink_edge(20.0, cnt=50, total_boards=100, lambda_shrink=15.0)
        self.assertGreater(shrunk_large, shrunk_small)

    def test_program1_to_4_features_and_bayesian_search(self):
        from bid.bayesian_search import BayesianSingleDummyBidder
        from bid.eval_vs_dds import parse_call
        from bid.models import Seat

        jps_dsl = os.path.join(REPO_ROOT, "system", "brill_jps_diff.dsl")
        bidder = BayesianSingleDummyBidder(jps_dsl, num_worlds=4, pool_size=40)
        deal9 = self.deals[9]  # Board 10 (seed=7): 1S - P - 2NT - P - 3D - P - 4S - P - 4NT
        hist = [parse_call(c) for c in ("1S", "PASS", "2NT", "PASS", "3D", "PASS", "4S", "PASS")]
        call, exp = bidder.decide_with_explanation(
            deal9.hands[Seat.NORTH], hist, Seat.NORTH, deal9.dealer, deal9.vuln
        )
        self.assertEqual(str(call), "4NT")
        self.assertTrue(exp.to_cot_str().endswith("-> BID 4NT"))


if __name__ == "__main__":
    unittest.main()

