#!/usr/bin/env python3
"""
v9: slam-bidding improvement, verified on Board 1 (seed 42).

Patch SLAM_DRIVE:
  1. Opener strong rebid: my 1C opening + partner 1M response + 6-card side suit
     + 17+ HCP -> rebid 3D (shows the source of tricks)
  2. Fit slam drive: partner 3D + doubleton+ + 12+ HCP -> offer 6D (DDS lookahead filters)
  3. NT slam drive: partner 2NT/3NT + 14+ HCP -> offer 6NT
Protocol: replay Board 1 before/after, paired confirm on seeds 42/7/13,
check MISSED_SLAM counts, save v9 if accepted.
"""

import json
import os
import shutil
import time

from bid.models import Strain, Seat, Call, CallType
from bid.decision_net import DecisionNetRule, RuleCondition
from bid.sampling import PartialState
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR, contract_string
from improve_improved_system import precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
STATE_PATH = os.path.join(SYSTEM_DIR, "flywheel_state.json")


def patch_slam_drive(net):
    ids = {"SLAM_REBID_3D", "SLAM_FIT_6D", "SLAM_FIT_3NT_D", "SLAM_DRIVE_6NT",
           "FW_2NT_FORCE", "FW_2NT_ACCEPT_H", "FW_2NT_ACCEPT_S", "FW_2NT_DECLINE"}
    net.rules = [r for r in net.rules if r.rule_id not in ids]
    net.add_rule(DecisionNetRule(
        "SLAM_REBID_3D", Call(CallType.BID, 3, Strain.DIAMONDS), [
            RuleCondition("my_last_call", "in", ["1C", "1D"]),
            RuleCondition("partner_last_call", "in", ["1H", "1S"]),
            RuleCondition("diamond_len", ">=", 6),
            RuleCondition("hcp", ">=", 17)], description="Opener: strong 6-diamond rebid", priority=28))
    net.add_rule(DecisionNetRule(
        "SLAM_FIT_6D", Call(CallType.BID, 6, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "==", "3D"),
            RuleCondition("diamond_len", ">=", 2),
            RuleCondition("hcp", ">=", 12)], description="Slam drive with diamond fit", priority=30))
    net.add_rule(DecisionNetRule(
        "SLAM_FIT_3NT_D", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "3D"),
            RuleCondition("is_balanced", "==", True),
            RuleCondition("hcp", ">=", 11)], description="3NT over partner strong 3D", priority=24))
    net.add_rule(DecisionNetRule(
        "SLAM_DRIVE_6NT", Call(CallType.BID, 6, Strain.NT), [
            RuleCondition("partner_last_call", "in", ["2NT", "3NT"]),
            RuleCondition("hcp", ">=", 14)], description="Drive 6NT over partner's strong NT", priority=26))
    net.add_rule(DecisionNetRule(
        "FW_2NT_FORCE_H", Call(CallType.BID, 2, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1H"),
            RuleCondition("heart_len", ">=", 3),
            RuleCondition("hcp", ">=", 11)], description="Forcing raise of 1H", priority=24))
    net.add_rule(DecisionNetRule(
        "FW_2NT_FORCE_S", Call(CallType.BID, 2, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1S"),
            RuleCondition("spade_len", ">=", 3),
            RuleCondition("hcp", ">=", 11)], description="Forcing raise of 1S", priority=24))
    net.add_rule(DecisionNetRule(
        "FW_2NT_DECLINE", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "2NT"),
            RuleCondition("hcp", "<=", 12)], description="Decline forcing raise", priority=20))


def replay_board1(net, arena, deals):
    deal = deals[0]
    hist, sc = arena.play_board(deal, net, net)
    ps = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], hist, deal.dealer, deal.vuln)
    diag = ParDiagnosticEngine_diagnose(deal, hist, sc)
    print(f"   auction : {' '.join(str(c) for c in hist)}")
    print(f"   contract: {contract_string(ps)} | NS {sc:+.0f} | flaw {diag}")
    return sc


def ParDiagnosticEngine_diagnose(deal, hist, sc):
    from bid.diagnostics import ParDiagnosticEngine
    d = ParDiagnosticEngine.diagnose_board(1, deal, hist, sc)
    return d.flaw_type.value


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    base_net = load_decision_net_dsl(TARGET)
    patched = base_net.clone()
    patch_slam_drive(patched)

    print("[1] Board 1 verification:")
    deals8 = build_deals(8, seed=42)
    print("   BEFORE:")
    replay_board1(base_net, arena, deals8)
    print("   AFTER:")
    s_b1 = replay_board1(patched, arena, deals8)

    print("\n[2] Paired confirmation (64 boards x 3 seeds):")
    deltas, miss_before_total, miss_after_total = [], 0, 0
    for seed in (42, 7, 13):
        deals = build_deals(64, seed=seed)
        dd = precompute(deals)
        rb = evaluate_system(arena, "base", base_net, deals, dd, run_diagnostics=True, seed=777)
        rf = evaluate_system(arena, "slam", patched, deals, dd, run_diagnostics=True, seed=777)
        d = rf["avg_score"] - rb["avg_score"]
        deltas.append(d)
        mb = rb["flaws"].get("MISSED_SLAM", 0)
        ma = rf["flaws"].get("MISSED_SLAM", 0)
        miss_before_total += mb
        miss_after_total += ma
        print(f"  seed {seed:<3} base {rb['avg_score']:+8.1f} -> slam {rf['avg_score']:+8.1f} ({d:+7.1f}) "
              f"| MISSED_SLAM {mb}->{ma} | acc {rb['par_accuracy']:.1f}->{rf['par_accuracy']:.1f}% "
              f"| imp {rb['avg_imp_loss']:.2f}->{rf['avg_imp_loss']:.2f}")

    avg = sum(deltas) / 3
    wins = sum(1 for x in deltas if x > 0)
    slam_improved = miss_after_total < miss_before_total
    print(f"\nResult: {wins}/3 sets, avg {avg:+.1f} | total MISSED_SLAM {miss_before_total}->{miss_after_total}")

    state = json.load(open(STATE_PATH)) if os.path.exists(STATE_PATH) else {"version": 8}
    v = state.get("version", 8)
    accept = (wins >= 2 and avg > -8) or (slam_improved and wins >= 2)
    if accept:
        os.makedirs(os.path.join(SYSTEM_DIR, "history"), exist_ok=True)
        shutil.copy(TARGET, os.path.join(SYSTEM_DIR, "history", f"improved_system_v{v}.dsl"))
        state["version"] = v + 1
        patched.name = f"ImprovedSystem_v{v + 1}"
        patched.save_dsl(TARGET)
        state["applied"].append({"sig": "manual:SLAM_DRIVE", "name": "SLAM_DRIVE", "delta": round(avg, 1)})
        json.dump(state, open(STATE_PATH, "w"), indent=2)
        print(f"SAVED v{v + 1} -> {TARGET}")
    else:
        print("NOT SAVED (acceptance failed)")
    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
