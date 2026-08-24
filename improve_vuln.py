#!/usr/bin/env python3
"""
v16 candidate: vulnerability-tiered competitive policy.

Vulnerability DISCIPLINE: flat hcp>=8 overcalls kept for non-vulnerable
seats only; a separate hcp>=11 rule covers the vulnerable seat (first
experiment: unfavorable-cell regret improved -159 -> -146, while light
favorable overcalls backfired and are dropped).

Paired confirmation on seeds 42/7/13 (DD score); saves v16 if consistent.
"""

import json
import os
import shutil
import time

from bid.models import Strain, Seat, Call, CallType
from bid.decision_net import DecisionNetRule, RuleCondition
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
from improve_improved_system import precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
STATE_PATH = os.path.join(SYSTEM_DIR, "flywheel_state.json")


def _overcall_rules():
    """Flat hcp>=8 overcalls for non-vulnerable seats; hcp>=11 discipline
    when vulnerable (empirically: unfavorable-cell regret -159 -> -146)."""
    rules = []
    for strain, opps, length_key in (
        (Strain.HEARTS, ["1C", "1D", "1S"], "heart_len"),
        (Strain.SPADES, ["1C", "1D", "1H"], "spade_len"),
    ):
        letter = strain.name[0]
        rules.append(DecisionNetRule(
            f"FW_OVERCALL_1{letter}", Call(CallType.BID, 1, strain),
            [RuleCondition("opp_last_call", "in", opps),
             RuleCondition(length_key, ">=", 5),
             RuleCondition("hcp", ">=", 8),
             RuleCondition("is_vulnerable", "==", False)],
            description=f"{letter} overcall, not vulnerable", priority=22))
        rules.append(DecisionNetRule(
            f"VULN_OVR_UNF_{letter}", Call(CallType.BID, 1, strain),
            [RuleCondition("opp_last_call", "in", opps),
             RuleCondition(length_key, ">=", 5),
             RuleCondition("hcp", ">=", 11),
             RuleCondition("is_vulnerable", "==", True)],
            description=f"{letter} overcall when vulnerable (discipline)",
            priority=22))
    return rules


def apply_patch(net):
    ids = {"FW_OVERCALL_1H", "FW_OVERCALL_1S"}
    net.rules = [r for r in net.rules if r.rule_id not in ids]
    for r in _overcall_rules():
        net.add_rule(r)


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6,
                                              timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    base_net = load_decision_net_dsl(TARGET)
    fixed = base_net.clone()
    apply_patch(fixed)

    print(f"Patch adds vuln-tiered overcalls + favorable TKOs "
          f"({len(fixed.rules)} rules)\n")

    all_deltas, cell_before, cell_after = [], [], []
    for seed in (42, 7, 13):
        deals = build_deals(64, seed=seed)
        dd = precompute(deals)
        rb = evaluate_system(arena, "base", base_net, deals, dd, seed=777)
        rf = evaluate_system(arena, "fixed", fixed, deals, dd, seed=777)
        d = rf["avg_score"] - rb["avg_score"]
        all_deltas.append(d)
        print(f"  seed {seed:<3} base {rb['avg_score']:+8.1f} -> fixed {rf['avg_score']:+8.1f} "
              f"(delta {d:+7.1f}) | acc {rb['par_accuracy']:.1f}->{rf['par_accuracy']:.1f}% "
              f"| imp {rb['avg_imp_loss']:.2f}->{rf['avg_imp_loss']:.2f}")

        if seed == 42:
            # per-cell breakdown on this seed
            def cells(res):
                out = {}
                for deal, sc in zip(deals, res["scores"]):
                    par = dd[deals.index(deal)][0] if False else None
                return out
            for label, res in (("base", rb), ("fixed", rf)):
                buckets = {}
                for i, (deal, sc) in enumerate(zip(deals, res["scores"])):
                    we = deal.vuln in (1, 3)
                    they = deal.vuln in (2, 3)
                    key = ("WeV" if we else "WeNV") + "/" + ("TheyV" if they else "TheyNV")
                    buckets.setdefault(key, []).append(sc - dd[i][0])
                line = f"    [{label}] "
                for k in sorted(buckets):
                    vals = buckets[k]
                    line += f"{k}: {sum(vals)/len(vals):+.0f} ({len(vals)})  "
                print(line)

    wins = sum(1 for x in all_deltas if x > 0)
    avg = sum(all_deltas) / 3
    print(f"\nResult: wins {wins}/3, avg delta {avg:+.1f}")

    state = json.load(open(STATE_PATH)) if os.path.exists(STATE_PATH) else {"version": 15}
    v = state.get("version", 15)
    accept = wins >= 2 and avg > -8
    if accept:
        os.makedirs(os.path.join(SYSTEM_DIR, "history"), exist_ok=True)
        shutil.copy(TARGET, os.path.join(SYSTEM_DIR, "history", f"improved_system_v{v}.dsl"))
        state["version"] = v + 1
        fixed.name = f"ImprovedSystem_v{v + 1}"
        fixed.save_dsl(TARGET)
        state["applied"].append({"sig": "manual:VULN_POLICY", "name": "VULN_POLICY",
                                 "delta": round(avg, 1)})
        json.dump(state, open(STATE_PATH, "w"), indent=2)
        print(f"\nSAVED v{v + 1} -> {TARGET}")
    else:
        print("\nNOT SAVED (acceptance failed)")
    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
