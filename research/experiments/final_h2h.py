#!/usr/bin/env python3
"""Final head-to-head on an unseen third seed, single process (paired)."""
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler
from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
from improve_improved_system import precompute
from improve_stage2 import patch_gate_3nt, patch_gate_direct_game
import os

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")


def main():
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    deals = build_deals(64, seed=13)
    dd = precompute(deals)
    base_net = load_decision_net_dsl(TARGET)

    g3 = base_net.clone(); patch_gate_3nt(g3)
    combo = base_net.clone(); patch_gate_3nt(combo); patch_gate_direct_game(combo)

    for name, net in (("base", base_net), ("GATE_3NT", g3), ("GATE_3NT+GAME", combo)):
        r = evaluate_system(arena, name, net, deals, dd, seed=777)
        print(f"  {name:<16} score {r['avg_score']:+8.1f} | regret {r['avg_regret']:+8.1f} "
              f"| acc {r['par_accuracy']:5.1f}% | game {r['game_conversion']:5.1f}% | imp {r['avg_imp_loss']:.2f}")


if __name__ == "__main__":
    main()
