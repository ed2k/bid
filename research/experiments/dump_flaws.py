#!/usr/bin/env python3
"""Dumps flaw-board auctions for improved_system.dsl vs DDS par (train set)."""
import random
from bid.models import Seat
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler
from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
import os

random.seed(99)
deals = build_deals(36, seed=42)
from bid.dds import DDSolver
dd = [(DDSolver.calculate_par(d, d.vuln)[0], DDSolver.calculate_par(d, d.vuln)[1], DDSolver.solve_dd_table(d)) for d in deals]

engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06), max_lookahead_depth=1)
arena = BiddingArena(engine=engine)
net = load_decision_net_dsl(os.path.join(SYSTEM_DIR, "improved_system.dsl"))
res = evaluate_system(arena, "base", net, deals, dd, run_diagnostics=True, seed=1234)

print(f"score {res['avg_score']:+.1f} | flaws: {dict(res['flaws'])}\n")
for d in res["diagnostics"]:
    auction = " ".join(str(c) for c in d.actual_history)
    print(f"Board {d.board_id:<3} [{d.flaw_type.value:<18}] {d.par_contract:<18} ({d.par_score:+5d})  loss {d.severity_pts:5.0f}")
    print(f"   auction: {auction}")
