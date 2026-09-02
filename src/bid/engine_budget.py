#!/usr/bin/env python3
"""
Engine budget experiment: does deeper PIDM lookahead / more MC sampling beat
the current eval engine? Paired comparison on seed-42 train set, validation of
the winner on seeds 7/13. Reports score vs compute cost.
"""

import argparse
import os
import time

from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler

from bid.eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR, precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
EVAL_SEED = 777

CONFIGS = [
    ("eval_base",      dict(sample_size=2, max_iterations=6,  timeout_sec=0.06), 1),
    ("smp4",           dict(sample_size=4, max_iterations=15, timeout_sec=0.15), 1),
    ("depth2",         dict(sample_size=2, max_iterations=6,  timeout_sec=0.06), 2),
    ("smp4_depth2",    dict(sample_size=4, max_iterations=15, timeout_sec=0.15), 2),
    ("heavy",          dict(sample_size=6, max_iterations=30, timeout_sec=0.30), 3),
]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--boards", type=int, default=64)
    parser.add_argument("--configs", type=str, default=None, help="comma list to subset")
    args = parser.parse_args()

    configs = CONFIGS
    if args.configs:
        wanted = set(args.configs.split(","))
        configs = [c for c in CONFIGS if c[0] in wanted]

    net = load_decision_net_dsl(TARGET)

    sets = {}
    for tag, seed in (("train", 42), ("val7", 7), ("val13", 13)):
        deals = build_deals(args.boards, seed=seed)
        sets[tag] = (deals, precompute(deals))

    results = {}
    for name, smp, depth in configs:
        engine = PIDMEngine(sampler=RBMBMCSampler(**smp), max_lookahead_depth=depth)
        arena = BiddingArena(engine=engine)
        t0 = time.time()
        r = evaluate_system(arena, name, net, *sets["train"], seed=EVAL_SEED)
        r["sec_per_board"] = (time.time() - t0) / len(sets["train"][0])
        results[name] = r
        print(f"  {name:<13} score {r['avg_score']:+8.1f} | regret {r['avg_regret']:+8.1f} "
              f"| acc {r['par_accuracy']:5.1f}% | game {r['game_conversion']:5.1f}% "
              f"| imp {r['avg_imp_loss']:.2f} | {r['sec_per_board']:.2f}s/bd")

    ranked = sorted(results, key=lambda n: results[n]["avg_score"], reverse=True)
    best = ranked[0]
    print(f"\nBest on train: {best}")

    if best != "eval_base":
        name, smp, depth = next(c for c in CONFIGS if c[0] == best)
        engine = PIDMEngine(sampler=RBMBMCSampler(**smp), max_lookahead_depth=depth)
        arena = BiddingArena(engine=engine)
        base_engine = PIDMEngine(sampler=RBMBMCSampler(**CONFIGS[0][1]), max_lookahead_depth=CONFIGS[0][2])
        base_arena = BiddingArena(engine=base_engine)
        for tag in ("val7", "val13"):
            rv = evaluate_system(arena, best, net, *sets[tag], seed=EVAL_SEED)
            rb = evaluate_system(base_arena, "eval_base", net, *sets[tag], seed=EVAL_SEED)
            print(f"  val {tag}: base {rb['avg_score']:+8.1f} -> {best} {rv['avg_score']:+8.1f} "
                  f"({rv['avg_score'] - rb['avg_score']:+.1f})")


if __name__ == "__main__":
    main()
