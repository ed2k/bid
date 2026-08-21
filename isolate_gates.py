#!/usr/bin/env python3
"""
Isolate which contextless rules are EV-negative pollution vs EV-positive aggression:
  A) gate only R_RESP_2H/2S (2-level raises firing as openings)
  B) gate only R_RESP_4H/R_REBID_4H (contextless 4H games)
  C) gate all four (v4 candidate from improve_v4.py)
Paired, one process, three seeds.
"""

import os
import time

from bid.models import Strain, Call, CallType
from bid.decision_net import DecisionNetRule, RuleCondition
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
from improve_improved_system import precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")


def mk(rule_id, level, strain, partner_in, min_len, min_hcp, max_hcp=None):
    conds = [RuleCondition("partner_last_call", "in", partner_in),
             RuleCondition(f"{strain.name.lower()}_len", ">=", min_len),
             RuleCondition("hcp", ">=", min_hcp)]
    if max_hcp:
        conds.append(RuleCondition("hcp", "<=", max_hcp))
    return DecisionNetRule(rule_id, Call(CallType.BID, level, strain), conds, priority=18 if level == 2 else 24)


def patch_a(net) -> None:
    repl = [
        mk("R_RESP_2H", 2, Strain.HEARTS, ["1H"], 3, 6, 10),
        mk("R_RESP_2S", 2, Strain.SPADES, ["1S"], 3, 6, 10),
    ]
    ids = {r.rule_id for r in repl}
    net.rules = [r for r in net.rules if r.rule_id not in ids]
    for r in repl:
        net.add_rule(r)


def patch_b(net) -> None:
    repl = [
        mk("R_RESP_4H", 4, Strain.HEARTS, ["1H", "2H", "3H"], 4, 12),
        DecisionNetRule("R_REBID_4H", Call(CallType.BID, 4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "in", ["1H", "2H", "3H"]),
            RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 16)], priority=26),
    ]
    ids = {r.rule_id for r in repl}
    net.rules = [r for r in net.rules if r.rule_id not in ids]
    for r in repl:
        net.add_rule(r)


def patch_c(net) -> None:
    patch_a(net)
    patch_b(net)


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    base_net = load_decision_net_dsl(TARGET)

    variants = {"A_gate2only": base_net.clone(), "B_gate4Honly": base_net.clone(), "C_gateAll": base_net.clone()}
    patch_a(variants["A_gate2only"])
    patch_b(variants["B_gate4Honly"])
    patch_c(variants["C_gateAll"])

    totals = {n: [] for n in variants}
    for seed in (42, 7, 13):
        deals = build_deals(64, seed=seed)
        dd = precompute(deals)
        rb = evaluate_system(arena, "base", base_net, deals, dd, seed=777)
        line = f"  seed {seed:<3} base {rb['avg_score']:+8.1f}"
        for name, net in variants.items():
            rf = evaluate_system(arena, name, net, deals, dd, seed=777)
            d = rf["avg_score"] - rb["avg_score"]
            totals[name].append(d)
            line += f" | {name} {d:+7.1f}"
        print(line)

    print()
    for name, ds in totals.items():
        print(f"  {name:<14} wins {sum(1 for d in ds if d > 0)}/3  avg {sum(ds)/len(ds):+.1f}")

    best = max(totals, key=lambda n: sum(totals[n]))
    ds = totals[best]
    if sum(1 for d in ds if d > 0) >= 2 and sum(ds) / 3 > 0:
        variants[best].name = "ImprovedSystem_v4"
        variants[best].save_dsl(TARGET)
        print(f"\nSaved winner {best} as v4 to {TARGET}")
    else:
        print("\nNo variant consistent; keeping current file.")
    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
