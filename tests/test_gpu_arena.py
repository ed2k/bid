import os
import sys
import unittest
import torch

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if os.path.join(REPO, "research") not in sys.path:
    sys.path.insert(0, os.path.join(REPO, "research"))

from bid.eval_vs_dds import build_deals, load_decision_net_dsl
from bid.features import BridgeFeatures
from bid.models import Seat
from gpu_arena import (
    CALL_NAMES,
    FEAT_TO_COL,
    FEATURE_KEYS,
    BatchedAuctionEnv,
    DealBundle,
    TensorDecisionNet,
    encode_feature_dict,
    gpu_continuation_q_values,
    gpu_team_match,
    verify_parity,
)


class TestGpuArena(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.deals = build_deals(8, seed=42, include_stratified=False)
        cls.bundle = DealBundle.from_deals(cls.deals, compute_dd=True, device="cpu")

    def test_feature_and_call_parity_brill_distilled(self):
        dsl_path = os.path.join(REPO, "system", "brill_distilled.dsl")
        checked, mismatches = verify_parity(self.deals, dsl_path, device="cpu", bundle=self.bundle)
        self.assertGreater(checked, 30)
        self.assertEqual(mismatches, 0)

    def test_feature_and_call_parity_champion_and_improved(self):
        for fname in ("champion_system.dsl", "improved_system.dsl"):
            dsl_path = os.path.join(REPO, "system", fname)
            checked, mismatches = verify_parity(self.deals, dsl_path, device="cpu", bundle=self.bundle)
            self.assertGreater(checked, 30)
            self.assertEqual(mismatches, 0, f"Mismatches in {fname}")

    def test_step_by_step_129_feature_equality(self):
        dsl_path = os.path.join(REPO, "system", "champion_system.dsl")
        py_net = load_decision_net_dsl(dsl_path)
        t_net = TensorDecisionNet(py_net, device="cpu")
        env = BatchedAuctionEnv(self.bundle)
        env.passes_since_last_np = torch.zeros(env.B, dtype=torch.long)

        py_histories = [[] for _ in self.deals]
        for _turn in range(12):
            if bool(env.done.all().item()):
                break
            X, seat = env.build_features()
            lmask = env.legal_mask(seat)
            _, gpu_calls = t_net.call_scores(X, lmask)

            for b, deal in enumerate(self.deals):
                if bool(env.done[b].item()):
                    continue
                cur_seat = Seat((deal.dealer.value + len(py_histories[b])) % 4)
                py_feats = BridgeFeatures.extract_all(
                    deal.hands[cur_seat], py_histories[b], cur_seat, deal.dealer, deal.vuln
                )
                expected = encode_feature_dict(py_feats)
                actual = X[b]
                for k in FEATURE_KEYS:
                    col = FEAT_TO_COL[k]
                    self.assertAlmostEqual(
                        float(actual[col].item()),
                        float(expected[col].item()),
                        places=5,
                        msg=f"Board {b} turn {_turn} feature {k!r}: gpu={actual[col].item()} vs py={expected[col].item()} (hist={py_histories[b]})",
                    )
                py_call = py_net.best_call(
                    deal.hands[cur_seat], py_histories[b], cur_seat, deal.dealer, deal.vuln
                )
                self.assertEqual(str(py_call), CALL_NAMES[int(gpu_calls[b].item())])
                py_histories[b].append(py_call)

            env.step(gpu_calls)

    def test_gpu_team_match_mirror_symmetry(self):
        net_a = TensorDecisionNet.from_dsl(os.path.join(REPO, "system", "brill_distilled_shipdd.dsl"), device="cpu")
        net_b = TensorDecisionNet.from_dsl(os.path.join(REPO, "system", "champion_system.dsl"), device="cpu")
        res_ab = gpu_team_match(self.bundle, net_a, net_b)
        res_ba = gpu_team_match(self.bundle, net_b, net_a)
        self.assertEqual(res_ab["total"], -res_ba["total"])
        self.assertEqual(res_ab["wins"], res_ba["losses"])
        self.assertEqual(res_ab["losses"], res_ba["wins"])

    def test_gpu_continuation_q_values(self):
        small_bundle = DealBundle.from_deals(self.deals[:4], compute_dd=True, device="cpu")
        net = TensorDecisionNet.from_dsl(os.path.join(REPO, "system", "champion_system.dsl"), device="cpu")
        q_pts, lmask = gpu_continuation_q_values(small_bundle, net)
        self.assertEqual(tuple(q_pts.shape), (4, 38))
        self.assertEqual(tuple(lmask.shape), (4, 38))
        # At opening (turn 0), PASS (0) and 1C..7NT (1..35) are legal, X (36) and XX (37) are illegal
        self.assertTrue(bool(lmask[:, :36].all().item()))
        self.assertFalse(bool(lmask[:, 36:].any().item()))
        self.assertFalse(bool(torch.isnan(q_pts[:, :36]).any().item()))
        self.assertTrue(bool(torch.isnan(q_pts[:, 36:]).all().item()))


if __name__ == "__main__":
    unittest.main()
