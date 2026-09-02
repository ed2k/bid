#!/usr/bin/env python3
"""
v8: proper partner-context gates on the simple-raise rules:
  R_RESP_2H -> partner_last_call == '1H'
  R_RESP_2S -> partner_last_call == '1S'
Kills unsound 2-level competitive "raises" without partner auction.
Paired confirmation on 3 seeds.
"""

import json
import os
import shutil
import time

from bid.models import Strain, Call, CallType
from bid.decision_net import DecisionNetRule, RuleCondition
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
from improve_improved_system import precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
STATE_PATH = os.path.join(SYSTEM_DIR, "flywheel_state.json")


def patch_raise_gates(net):
    net.rules = [r for r in net.rules
                 if r.rule_id not in ("R_RESP_2H", "R_RESP_2S")]
    net.add_rule(DecisionNetRule(
        "R_RESP_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"),
            RuleCondition("heart_len", ">=", 3),
            RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)], priority=18))
    net.add_rule(DecisionNetRule(
        "R_RESP_2S", Call(CallType.BID, 2, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"),
            RuleCondition("spade_len", ">=", 3),
            RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)], priority=18))


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    base_net = load_decision_net_dsl(TARGET)
    fixed = base_net.clone()
    patch_raise_gates(fixed)

    deltas = []
    flaw_lines = []
    for seed in (42, 7, 13):
        deals = build_deals(64, seed=seed)
        dd = precompute(deals)
        rb = evaluate_system(arena, "base", base_net, deals, dd, seed=777)
        rf = evaluate_system(arena, "fixed", fixed, deals, dd, seed=777)
        d = rf["avg_score"] - rb["avg_score"]
        deltas.append(d)
        print(f"  seed {seed:<3} base {rb['avg_score']:+8.1f} -> fixed {rf['avg_score']:+8.1f} ({d:+7.1f}) "
              f"| acc {rb['par_accuracy']:.1f}->{rf['par_accuracy']:.1f}% | imp {rb['avg_imp_loss']:.2f}->{rf['avg_imp_loss']:.2f}")
        flaw_lines.append((seed, dict(rb["flaws"]), dict(rf["flaws"])))

    for seed, bf, ff in flaw_lines:
        print(f"  seed {seed} flaws base {bf}")
        print(f"           flaws fixed {ff}")

    avg = sum(deltas) / 3
    wins = sum(1 for x in deltas if x > 0)
    print(f"\nResult: {wins}/3 sets, avg {avg:+.1f}")

    state = json.load(open(STATE_PATH)) if os.path.exists(STATE_PATH) else {"version": 7}
    v = state.get("version", 7)
    os.makedirs(os.path.join(SYSTEM_DIR, "history"), exist_ok=True)
    shutil.copy(TARGET, os.path.join(SYSTEM_DIR, "history", f"improved_system_v{v}.dsl"))
    state["version"] = v + 1
    fixed.name = f"ImprovedSystem_v{v + 1}"
    fixed.save_dsl(TARGET)
    state["applied"].append({"sig": "manual:RAISE_PARTNER_GATES", "name": "RAISE_PARTNER_GATES",
                             "delta": round(avg, 1)})
    json.dump(state, open(STATE_PATH, "w"), indent=2)
    print(f"Saved v{v + 1} (policy: defensive discipline) -> {TARGET}")
    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
