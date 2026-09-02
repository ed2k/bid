#!/usr/bin/env python3
"""
High-power confirmation of stage-2 candidate patches.
Paired per-board comparison on 64-deal train (seed 42) and 64-deal val (seed 7).
Saves the best patch to improved_system.dsl only if it gains on BOTH sets.
"""

import os
import time
from typing import Callable, Dict

from bid.models import CallType
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
from improve_improved_system import precompute
from improve_stage2 import (patch_gate_3nt, patch_gate_direct_game,
                            patch_new_suit_responses, patch_opener_rebids)

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
EVAL_SEED = 1234


def patch_no_double(net) -> None:
    net.rules = [r for r in net.rules if r.call.type != CallType.DOUBLE]


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

    patches: Dict[str, Callable] = {
        "NEW_SUIT_RESP": patch_new_suit_responses,
        "OPENER_REBIDS": patch_opener_rebids,
        "GATE_3NT": patch_gate_3nt,
        "GATE_GAME": patch_gate_direct_game,
        "NO_DOUBLE": patch_no_double,
    }

    print(f"Baseline evals on {len(sets['train'][0])}-deal sets...")
    base = {tag: evl(base_net, tag) for tag in sets}
    for tag in sets:
        b = base[tag]
        print(f"  {tag:<6} score {b['avg_score']:+8.1f} | acc {b['par_accuracy']:5.1f}% | game {b['game_conversion']:5.1f}%")

    print("\nPaired patch deltas (same deals, same MC seed):")
    winners = {}
    for name, fn in patches.items():
        cand = base_net.clone()
        fn(cand)
        line = f"  {name:<16}"
        ok_both = True
        for tag in sets:
            res = evl(cand, tag)
            delta = res["avg_score"] - base[tag]["avg_score"]
            acc_ok = res["par_accuracy"] >= base[tag]["par_accuracy"] - 5.0
            game_ok = res["game_conversion"] >= base[tag]["game_conversion"] - 10.0
            if delta <= 0 or not (acc_ok and game_ok):
                ok_both = False
            line += f" | {tag} {delta:+7.1f}"
        winners[name] = ok_both
        print(line)

    confirmed = [n for n, ok in winners.items() if ok]
    print(f"\nConfirmed on both sets: {confirmed or 'none'}")

    if confirmed:
        final = base_net.clone()
        for name in confirmed:
            patches[name](final)
        final.name = "ImprovedSystem_v3"
        final.save_dsl(TARGET)
        print(f"Saved {confirmed} to {TARGET}")
    else:
        print("No patch confirmed; keeping existing improved_system.dsl unchanged.")

    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
