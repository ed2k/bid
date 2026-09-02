#!/usr/bin/env python3
"""Inspect guardrail details for GATE_3NT and the GATE_3NT+GATE_GAME combo."""
import os
import time

from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
from improve_improved_system import precompute
from improve_stage2 import patch_gate_3nt, patch_gate_direct_game

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
EVAL_SEED = 1234


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)

    sets = {}
    for tag, seed in (("train", 42), ("val", 7)):
        deals = build_deals(64, seed=seed)
        sets[tag] = (deals, precompute(deals))

    base_net = load_decision_net_dsl(TARGET)

    def evl(net, tag):
        deals, dd = sets[tag]
        return evaluate_system(arena, "cand", net, deals, dd, seed=EVAL_SEED)

    variants = {
        "base": base_net.clone(),
        "GATE_3NT": None,
        "GATE_3NT+GAME": None,
    }
    variants["GATE_3NT"] = base_net.clone(); patch_gate_3nt(variants["GATE_3NT"])
    variants["GATE_3NT+GAME"] = base_net.clone(); patch_gate_3nt(variants["GATE_3NT+GAME"]); patch_gate_direct_game(variants["GATE_3NT+GAME"])

    for vname, net in variants.items():
        for tag in sets:
            r = evl(net, tag)
            print(f"  {vname:<16} {tag:<6} score {r['avg_score']:+8.1f} | regret {r['avg_regret']:+8.1f} "
                  f"| acc {r['par_accuracy']:5.1f}% | game {r['game_conversion']:5.1f}% | imp {r['avg_imp_loss']:.2f}")
        print()

    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
