import json
import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from bid import flywheel as fw
from bid.autoloop import PoolBuilder, eval_seed_for
from bid.continuous import load_run_state, plan_cycle, save_run_state
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.models import Call, CallType, Strain
from bid.player_model import CallModel
from bid.refresh_student import decide_promotion, player_model_stale


class TestFlywheelStateHealing(unittest.TestCase):
    def test_normalize_flattens_legacy_pair_entries(self):
        st = {"version": 25, "failed": [["loosen:X", "LOOSEN_X"], "tighten:Y",
                                        ["loosen:X", "LOOSEN_X"], 42, None]}
        out = fw.normalize_state(st)
        self.assertEqual(out["failed"], ["loosen:X", "tighten:Y"])

    def test_normalize_backfills_failed_at_with_grace(self):
        st = {"version": 25, "failed": ["a", "b"]}
        out = fw.normalize_state(st)
        # legacy entries get the current version -> full expiry grace period
        self.assertEqual(out["failed_at"], {"a": 25, "b": 25})

    def test_mark_failed_records_version(self):
        st = {"version": 30, "failed": [], "failed_at": {}}
        fw.mark_failed(st, "gate:R1")
        self.assertIn("gate:R1", st["failed"])
        self.assertEqual(st["failed_at"]["gate:R1"], 30)
        fw.mark_failed(st, "gate:R1")  # idempotent membership, refreshes stamp
        self.assertEqual(st["failed"].count("gate:R1"), 1)

    def test_expire_failed_drops_only_old_entries(self):
        st = {"version": 40,
              "failed": ["old", "fresh"],
              "failed_at": {"old": 20, "fresh": 38}}
        dropped = fw.expire_failed(st, expiry_versions=8)
        self.assertEqual(dropped, 1)
        self.assertEqual(st["failed"], ["fresh"])
        self.assertEqual(st["failed_at"], {"fresh": 38})

    def test_expire_failed_uses_grace_for_unstamped_entries(self):
        st = {"version": 9, "failed": ["x"], "failed_at": {}}
        dropped = fw.expire_failed(st, expiry_versions=8)
        self.assertEqual(dropped, 0)  # backfilled to current version


class TestSeedRotation(unittest.TestCase):
    def test_seed_varies_per_version(self):
        self.assertNotEqual(eval_seed_for(25), eval_seed_for(26))

    def test_seed_stable_within_version(self):
        self.assertEqual(eval_seed_for(25), eval_seed_for(25))


class TestEffectFloor(unittest.TestCase):
    """Regression: a no-op patch re-scored through the wall-clock-timeout
    sampler once produced a +0.04 delta with z=inf and burned a version."""

    def test_noise_level_deltas_rejected(self):
        self.assertFalse(fw.passes_effect_floor(0.04))
        self.assertFalse(fw.passes_effect_floor(0.0))
        self.assertFalse(fw.passes_effect_floor(-1.0))

    def test_real_deltas_pass(self):
        self.assertTrue(fw.passes_effect_floor(0.5))
        self.assertTrue(fw.passes_effect_floor(23.7))

    def test_winner_gate_blocks_noise_even_when_ladder_passed(self):
        """The stage-2 winner decision must gate on the floor itself: an
        ok=True candidate with a noise delta still loses (this exact hole
        let SUPPORT burn v28 with delta 0.0 while the floor 'was wired')."""
        self.assertFalse(fw.winner_gate(True, 0.04))
        self.assertFalse(fw.winner_gate(True, 0.0))
        self.assertTrue(fw.winner_gate(True, 0.6))
        self.assertFalse(fw.winner_gate(False, 23.7))


class TestPoolBuilderSignatures(unittest.TestCase):
    """Regression: the loosen family once built tuple signatures that never
    matched the JSON-cached failure strings, so they were re-screened
    forever while corrupting flywheel_state.json with list entries."""

    def _net(self):
        net = DecisionNet("T")
        net.add_rule(DecisionNetRule("R_T1", Call(CallType.BID, 1, Strain.NT),
                                     [RuleCondition("hcp", ">=", 15)]))
        return net

    def test_all_signatures_are_strings(self):
        pb = PoolBuilder({"version": 1, "failed": []})
        sigs = [sig for sig, _, _ in pb.build(self._net(), [])]
        self.assertTrue(sigs)
        for s in sigs:
            self.assertIsInstance(s, str, f"non-string signature: {s!r}")
        self.assertEqual(len(sigs), len(set(sigs)))


class TestStudentPromotionGate(unittest.TestCase):
    def test_no_incumbent_below_floor_blocked(self):
        promote, reason = decide_promotion(1.9, None, 0.0, 25.0)
        self.assertFalse(promote)
        self.assertIn("floor", reason)

    def test_no_incumbent_above_floor_promotes(self):
        promote, _ = decide_promotion(60.7, None, 0.0, 25.0)
        self.assertTrue(promote)

    def test_regression_vs_incumbent_blocked(self):
        promote, _ = decide_promotion(29.1, 47.3, 0.0, 25.0)
        self.assertFalse(promote)

    def test_improvement_vs_incumbent_promotes(self):
        promote, _ = decide_promotion(48.0, 47.3, 0.0, 25.0)
        self.assertTrue(promote)

    def test_floor_blocks_even_vs_weaker_incumbent(self):
        promote, reason = decide_promotion(22.0, 20.0, 0.0, 25.0)
        self.assertFalse(promote)
        self.assertIn("below accuracy floor", reason)

    def test_tolerance_allows_small_regression(self):
        promote, _ = decide_promotion(50.0, 50.5, 1.0, 25.0)
        self.assertTrue(promote)


class TestPlayerModelFreshness(unittest.TestCase):
    def _rows(self):
        feats = {"hcp": 12, "is_balanced": True, "spade_len": 4,
                 "heart_len": 3, "diamond_len": 3, "club_len": 3}
        return [{"seat": "SOUTH", "call_index": 0, "bid": "1NT",
                 "input": {"features": feats, "auction": []}}]

    def test_trained_model_records_corpus_sha(self):
        model = CallModel.train(self._rows(),
                                meta={"corpus_sha256": "abc123", "rows": 1})
        with tempfile.TemporaryDirectory() as td:
            path = os.path.join(td, "call_model.json")
            model.save(path)
            with open(path) as f:
                meta = json.load(f)["meta"]
        self.assertEqual(meta["corpus_sha256"], "abc123")
        self.assertEqual(meta["contexts"], 1)

    def test_staleness_checks(self):
        model = CallModel.train(self._rows(), meta={"corpus_sha256": "abc123"})
        with tempfile.TemporaryDirectory() as td:
            path = os.path.join(td, "call_model.json")
            model.save(path)
            self.assertFalse(player_model_stale(path, corpus_sha="abc123"))
            self.assertTrue(player_model_stale(path, corpus_sha="other"))
            missing = os.path.join(td, "nope.json")
            self.assertTrue(player_model_stale(missing, corpus_sha="abc123"))
            with open(path, "w") as f:
                f.write("{not json")
            self.assertTrue(player_model_stale(path, corpus_sha="abc123"))


class TestContinuousOrchestrator(unittest.TestCase):
    def test_plan_cycle_base_stages(self):
        self.assertEqual(plan_cycle(1, 0), ["teacher", "student", "mine"])
        self.assertEqual(plan_cycle(2, 3), ["teacher", "student", "mine"])

    def test_plan_cycle_rl_every_n(self):
        self.assertEqual(plan_cycle(3, 3),
                         ["teacher", "student", "mine", "rl"])
        self.assertEqual(plan_cycle(6, 3),
                         ["teacher", "student", "mine", "rl"])
        self.assertNotIn("rl", plan_cycle(4, 3))

    def test_run_state_roundtrip_and_resume(self):
        with tempfile.TemporaryDirectory() as td:
            path = os.path.join(td, "continuous_state.json")
            st = load_run_state(path)
            self.assertEqual(st["cycle"], 1)
            self.assertEqual(st["next_stage"], 0)
            st["cycle"] = 4
            st["next_stage"] = 2
            save_run_state(st, path)
            resumed = load_run_state(path)
            self.assertEqual(resumed["cycle"], 4)
            self.assertEqual(resumed["next_stage"], 2)

    def test_load_state_recovers_from_corruption(self):
        with tempfile.TemporaryDirectory() as td:
            path = os.path.join(td, "continuous_state.json")
            with open(path, "w") as f:
                f.write("{broken json")
            st = load_run_state(path)
            self.assertEqual(st["cycle"], 1)


if __name__ == "__main__":
    unittest.main()
