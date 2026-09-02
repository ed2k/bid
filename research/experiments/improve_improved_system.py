#!/usr/bin/env python3
"""
Closed-loop improvement of system/improved_system.dsl using eval_vs_dds:
  1. Baseline eval with per-board diagnostics vs native DDS par (train deal set, seeded).
  2. Candidate patches: junk-rule removal + corrective rule families synthesized
     from the repo's own ParDiagnosticEngine.
  3. Greedy hill-climb on train set, validation on a disjoint deal set.
  4. Persists the winner back to system/improved_system.dsl (with .bak backup).
"""

import os
import random
import shutil
import time
from typing import Callable, Dict, List, Tuple

from bid.models import Seat
from bid.sampling import Deal
from bid.dds import DDSolver
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler

from eval_vs_dds import (build_deals, evaluate_system, load_decision_net_dsl,
                         SYSTEM_DIR)

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
TRAIN_SEED, VAL_SEED, EVAL_SEED = 42, 7, 1234
JUNK_PREFIXES = ("Stayman_Response_", "Jacoby_Transfer_", "Smolen_", "Texas_Transfer_")


def precompute(deals: List[Deal]) -> List[Tuple[int, str, dict]]:
    out = []
    for deal in deals:
        par_score, par_contract = DDSolver.calculate_par(deal, deal.vuln)
        dd_table = DDSolver.solve_dd_table(deal)
        out.append((par_score, par_contract, dd_table))
    return out


def patch_drop_junk(net) -> None:
    net.rules = [r for r in net.rules if not r.rule_id.startswith(JUNK_PREFIXES)
                 and r.rule_id != "R_RESP_2D_WAITING"]


def make_add_patch(rules: List) -> Callable:
    ids = {r.rule_id for r in rules}

    def patch(net) -> None:
        existing = {r.rule_id for r in net.rules}
        for r in rules:
            if r.rule_id not in existing or r.rule_id not in ids:
                net.add_rule(r)
    return patch


def summarize(tag: str, res: dict) -> None:
    print(f"    {tag:<28} score {res['avg_score']:+8.1f} | regret {res['avg_regret']:+7.1f} "
          f"| acc {res['par_accuracy']:5.1f}% | game {res['game_conversion']:5.1f}% "
          f"| imp_loss {res['avg_imp_loss']:.2f}")


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)

    print(f"[1] Building train deals (seed {TRAIN_SEED}) and val deals (seed {VAL_SEED})...")
    train_deals = build_deals(30, seed=TRAIN_SEED)
    val_deals = build_deals(30, seed=VAL_SEED)
    dd_train = precompute(train_deals)
    dd_val = precompute(val_deals)

    base_net = load_decision_net_dsl(TARGET)
    print(f"[2] Baseline: {len(base_net.rules)} rules, {len(base_net.intersection_nodes)} intersection nodes")

    def evl(net, deals, dd, diags=False):
        return evaluate_system(arena, "cand", net, deals, dd, run_diagnostics=diags, seed=EVAL_SEED)

    base_train = evl(base_net, train_deals, dd_train, diags=True)
    base_val = evl(base_net, val_deals, dd_val)
    print("[3] Baseline performance:")
    summarize("train", base_train)
    summarize("val", base_val)
    flaws = ", ".join(f"{k} x{v}" for k, v in base_train["flaws"].most_common()) or "none"
    print(f"    train flaws: {flaws}")

    # Synthesize corrective rule families from baseline diagnostics
    from bid.diagnostics import ParDiagnosticEngine
    corrective = ParDiagnosticEngine.generate_corrective_rules_for_diagnostics(base_train["diagnostics"])
    families: Dict[str, List] = {}
    for r in corrective:
        fam = r.rule_id.split("_")[0]
        families.setdefault(fam, []).append(r)
    print(f"[4] Corrective families from diagnostics: "
          f"{ {k: len(v) for k, v in families.items()} }")

    patches: Dict[str, Callable] = {"DROP_JUNK": patch_drop_junk}
    for fam, rules in sorted(families.items()):
        patches[f"ADD_{fam}"] = make_add_patch(rules)

    current, current_train = base_net.clone(), base_train
    applied: List[str] = []
    pool = dict(patches)

    for rnd in range(1, 4):
        print(f"\n[5.{rnd}] Greedy round {rnd}: testing {len(pool)} candidate patches on train set...")
        best_name, best_delta, best_res = None, 0.0, None
        for name, fn in pool.items():
            cand = current.clone()
            fn(cand)
            res = evl(cand, train_deals, dd_train)
            delta = res["avg_score"] - current_train["avg_score"]
            acc_ok = res["par_accuracy"] >= current_train["par_accuracy"] - 5.0
            game_ok = res["game_conversion"] >= current_train["game_conversion"] - 10.0
            mark = ""
            if delta > best_delta and acc_ok and game_ok:
                best_delta, best_name, best_res = delta, name, res
                mark = "  <-- best so far"
            print(f"    {name:<16} delta {delta:+8.1f} (acc {res['par_accuracy']:5.1f}% game {res['game_conversion']:5.1f}%){mark}")

        if best_name is None:
            print("    No improving patch found; stopping hill-climb.")
            break

        pool[best_name](current)
        applied.append(best_name)
        current_train = best_res
        del pool[best_name]
        print(f"    APPLIED {best_name} (delta {best_delta:+.1f}); rules now {len(current.rules)}")

    print("\n[6] Final validation on disjoint deal set...")
    final_val = evl(current, val_deals, dd_val)
    summarize("baseline val", base_val)
    summarize("improved val", final_val)
    summarize("baseline train", base_train)
    summarize("improved train", current_train)

    val_gain = final_val["avg_score"] - base_val["avg_score"]
    train_gain = current_train["avg_score"] - base_train["avg_score"]
    print(f"\n    Net gain: train {train_gain:+.1f} pts/board, val {val_gain:+.1f} pts/board")
    print(f"    Applied patches: {applied or 'none'}")

    backup = TARGET + ".bak"
    if not os.path.exists(backup):
        shutil.copy(TARGET, backup)
    current.name = "ImprovedSystem_v2"
    current.save_dsl(TARGET)
    print(f"[7] Saved improved system to {TARGET} (original backed up to {backup})")

    reloaded = load_decision_net_dsl(TARGET)
    reload_res = evl(reloaded, train_deals, dd_train)
    print(f"    Round-trip check (reloaded): score {reload_res['avg_score']:+.1f} "
          f"(expected ~{current_train['avg_score']:+.1f}), "
          f"rules {len(reloaded.rules)}, intersections {len(reloaded.intersection_nodes)}")
    print(f"\nDone in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
