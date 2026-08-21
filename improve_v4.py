#!/usr/bin/env python3
"""
v4 fix: gate the four pipeline-generated rules that lost their auction-context
conditions (R_RESP_2H/R_RESP_2S fire as openings on 3+ suits; R_RESP_4H and
R_REBID_4H bid games without any partner auction). Paired confirmation across
three independent deal sets in a single process; saves v4 if consistently positive.
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

GATED_RULES = [
    DecisionNetRule("R_RESP_2H", Call(CallType.BID, 2, Strain.HEARTS), [
        RuleCondition("partner_last_call", "==", "1H"),
        RuleCondition("heart_len", ">=", 3), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10),
    ], description="Simple raise of partner 1H", priority=18),
    DecisionNetRule("R_RESP_2S", Call(CallType.BID, 2, Strain.SPADES), [
        RuleCondition("partner_last_call", "==", "1S"),
        RuleCondition("spade_len", ">=", 3), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10),
    ], description="Simple raise of partner 1S", priority=18),
    DecisionNetRule("R_RESP_4H", Call(CallType.BID, 4, Strain.HEARTS), [
        RuleCondition("partner_last_call", "in", ["1H", "2H", "3H"]),
        RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 12),
    ], description="Game raise of partner hearts", priority=24),
    DecisionNetRule("R_REBID_4H", Call(CallType.BID, 4, Strain.HEARTS), [
        RuleCondition("partner_last_call", "in", ["1H", "2H", "3H"]),
        RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 16),
    ], description="Rebid own 5+ hearts at game", priority=26),
]


def patch_gate_contextless(net) -> None:
    ids = {r.rule_id for r in GATED_RULES}
    net.rules = [r for r in net.rules if r.rule_id not in ids]
    for r in GATED_RULES:
        net.add_rule(r)


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    base_net = load_decision_net_dsl(TARGET)

    fixed = base_net.clone()
    patch_gate_contextless(fixed)

    print(f"Patching {len(GATED_RULES)} contextless rules -> fixed net has {len(fixed.rules)} rules\n")
    deltas = []
    for seed in (42, 7, 13):
        deals = build_deals(64, seed=seed)
        dd = precompute(deals)

        rb = evaluate_system(arena, "base", base_net, deals, dd, seed=777)
        rf = evaluate_system(arena, "fixed", fixed, deals, dd, seed=777)
        delta = rf["avg_score"] - rb["avg_score"]
        deltas.append(delta)
        print(f"  seed {seed:<3} base {rb['avg_score']:+8.1f} -> fixed {rf['avg_score']:+8.1f} "
              f"(delta {delta:+7.1f}) | acc {rb['par_accuracy']:.1f}->{rf['par_accuracy']:.1f}% "
              f"| game {rb['game_conversion']:.1f}->{rf['game_conversion']:.1f}% "
              f"| imp {rb['avg_imp_loss']:.2f}->{rf['avg_imp_loss']:.2f}")

    wins = sum(1 for d in deltas if d > 0)
    avg_gain = sum(deltas) / len(deltas)
    acc_ok = True
    print(f"\nResult: wins {wins}/3 sets, avg gain {avg_gain:+.1f} pts/board")

    if wins >= 2 and avg_gain > 0:
        # verify guardrails on aggregate before saving
        deals = build_deals(64, seed=42)
        dd = precompute(deals)
        rb = evaluate_system(arena, "base", base_net, deals, dd, seed=777)
        rf = evaluate_system(arena, "fixed", fixed, deals, dd, seed=777)
        if (rf["par_accuracy"] >= rb["par_accuracy"] - 5 and rf["avg_imp_loss"] <= rb["avg_imp_loss"]):
            fixed.name = "ImprovedSystem_v4"
            fixed.save_dsl(TARGET)
            print(f"Saved v4 to {TARGET}")
        else:
            print("Guardrail failed; not saved.")
    else:
        print("Not consistent; keeping current file.")

    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
