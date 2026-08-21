#!/usr/bin/env python3
"""
Autonomous improvement flywheel for system/improved_system.dsl:
  ROUND:
    1. Play deal set vs DDS par, dump flaw boards with auctions
    2. Build patch pool (curated anti-flaw patches + diagnostic-generated families)
    3. Paired greedy hill-climb on train set (same deals, same MC seed)
    4. Confirm combo on disjoint validation sets; save only if consistently positive
    5. Repeat with fresh flaw dump
"""

import argparse
import os
import time
from typing import Callable, Dict, List

from bid.models import Strain, Seat, Call, CallType
from bid.decision_net import DecisionNetRule, RuleCondition
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler
from bid.diagnostics import ParDiagnosticEngine

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
from improve_improved_system import precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
TRAIN_SEED, VAL_SEEDS = 42, (7, 13)
EVAL_SEED = 777
N_DEALS = 64


def rule(rid, call, conds, prio=20, desc=""):
    return DecisionNetRule(rid, call, conds, description=desc, priority=prio)


def B(level, strain):
    return Call(CallType.BID, level, strain)


def add_rules(net, rules: List[DecisionNetRule]):
    existing = {r.rule_id for r in net.rules}
    added = False
    for r in rules:
        if r.rule_id not in existing:
            net.add_rule(r)
            added = True
    return added


def replace_rules(net, rules: List[DecisionNetRule]):
    ids = {r.rule_id for r in rules}
    net.rules = [r for r in net.rules if r.rule_id not in ids]
    for r in rules:
        net.add_rule(r)


# ---------------- curated anti-flaw patches ----------------

def p_overcalls(net):
    add_rules(net, [
        rule("FW_OVERCALL_1H", B(1, Strain.HEARTS), [
            RuleCondition("opp_last_call", "in", ["1C", "1D", "1S"]),
            RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 8)], prio=22),
        rule("FW_OVERCALL_1S", B(1, Strain.SPADES), [
            RuleCondition("opp_last_call", "in", ["1C", "1D", "1H"]),
            RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 8)], prio=22),
    ])


def p_balancing(net):
    add_rules(net, [
        rule("FW_BAL_1H", B(1, Strain.HEARTS), [
            RuleCondition("is_balancing", "==", True),
            RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 8)], prio=23),
        rule("FW_BAL_1S", B(1, Strain.SPADES), [
            RuleCondition("is_balancing", "==", True),
            RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 8)], prio=23),
    ])


def p_tko_shape(net):
    add_rules(net, [
        rule("FW_TKO_VS_S", Call(CallType.DOUBLE), [
            RuleCondition("is_competitive", "==", True),
            RuleCondition("last_bid_strain", "==", "S"),
            RuleCondition("spade_len", "<=", 2), RuleCondition("hcp", ">=", 11),
            RuleCondition("heart_len", ">=", 4)], prio=25),
        rule("FW_TKO_VS_H", Call(CallType.DOUBLE), [
            RuleCondition("is_competitive", "==", True),
            RuleCondition("last_bid_strain", "==", "H"),
            RuleCondition("heart_len", "<=", 2), RuleCondition("hcp", ">=", 11),
            RuleCondition("spade_len", ">=", 4)], prio=25),
    ])


def p_resp_1nt(net):
    add_rules(net, [
        rule("FW_RESP_1NT", B(1, Strain.NT), [
            RuleCondition("partner_last_call", "in", ["1C", "1D", "1H", "1S"]),
            RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)], prio=14),
    ])


def p_force_raise(net):
    add_rules(net, [
        rule("FW_2NT_FORCE", B(2, Strain.NT), [
            RuleCondition("partner_last_call", "in", ["1H", "1S"]),
            RuleCondition("hcp", ">=", 11)], prio=24),
        rule("FW_2NT_ACCEPT_H", B(4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "2NT"),
            RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 13)], prio=26),
        rule("FW_2NT_ACCEPT_S", B(4, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "2NT"),
            RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 13)], prio=26),
        rule("FW_2NT_DECLINE", B(3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "2NT"),
            RuleCondition("hcp", "<=", 12)], prio=20),
    ])


def p_weak2_resp(net):
    add_rules(net, [
        rule("FW_W2_GAME_H", B(4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "2H"),
            RuleCondition("heart_len", ">=", 3), RuleCondition("hcp", ">=", 13)], prio=27),
        rule("FW_W2_GAME_S", B(4, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "2S"),
            RuleCondition("spade_len", ">=", 3), RuleCondition("hcp", ">=", 13)], prio=27),
    ])


# ---------------- flywheel ----------------

def flaw_dump(res, max_boards=8):
    lines = []
    diags = sorted(res["diagnostics"], key=lambda d: -d.severity_pts)[:max_boards]
    for d in diags:
        auction = " ".join(str(c) for c in d.actual_history)
        lines.append(f"    Bd {d.board_id:<3} [{d.flaw_type.value:<15}] {d.par_contract:<14} "
                     f"loss {d.severity_pts:5.0f} | {auction}")
    return lines


def main():
    parser = argparse.ArgumentParser(description="Autonomous improvement flywheel")
    parser.add_argument("--deals", type=int, default=N_DEALS)
    args = parser.parse_args()
    n_deals = args.deals

    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)

    train_deals = build_deals(n_deals, seed=TRAIN_SEED)
    dd_train = precompute(train_deals)
    val_sets = {}
    for s in VAL_SEEDS:
        d = build_deals(n_deals, seed=s)
        val_sets[s] = (d, precompute(d))

    def evl(net, deals, dd):
        return evaluate_system(arena, "cand", net, deals, dd, run_diagnostics=True, seed=EVAL_SEED)

    original = load_decision_net_dsl(TARGET)
    orig_train = evl(original, train_deals, dd_train)
    orig_val = {s: evl(original, *val_sets[s]) for s in VAL_SEEDS}

    current = original.clone()
    cur_train = orig_train

    for round_no in (1, 2):
        print(f"\n{'='*90}\n FLYWHEEL ROUND {round_no}\n{'='*90}")
        print(f"  Current train: score {cur_train['avg_score']:+.1f} | flaws {dict(cur_train['flaws'])}")
        print("  Worst flaw boards:")
        for line in flaw_dump(cur_train):
            print(line)

        pool: Dict[str, Callable] = {
            "OVERCALLS": p_overcalls,
            "BALANCING": p_balancing,
            "TKO_SHAPE": p_tko_shape,
            "RESP_1NT": p_resp_1nt,
            "FORCE_RAISE_2NT": p_force_raise,
            "WEAK2_GAME": p_weak2_resp,
        }
        corrective = ParDiagnosticEngine.generate_corrective_rules_for_diagnostics(cur_train["diagnostics"])
        fams: Dict[str, List] = {}
        for r in corrective:
            fams.setdefault(r.rule_id.split("_")[0], []).append(r)
        for fam, rules in sorted(fams.items()):
            pool[f"ADD_{fam}"] = (lambda rl: (lambda n: add_rules(n, rl)))(rules)

        for pass_no in (1, 2, 3):
            print(f"\n  [round {round_no} pass {pass_no}] testing {len(pool)} patches:")
            best_name, best_delta, best_res = None, 0.0, None
            for name, fn in pool.items():
                cand = current.clone()
                fn(cand)
                res = evl(cand, train_deals, dd_train)
                delta = res["avg_score"] - cur_train["avg_score"]
                ok = (delta > 0
                      and res["par_accuracy"] >= cur_train["par_accuracy"] - 5
                      and res["avg_imp_loss"] <= cur_train["avg_imp_loss"] + 0.15)
                mark = " <-- best" if ok and (best_name is None or delta > best_delta) else ""
                if mark:
                    best_name, best_delta, best_res = name, delta, res
                print(f"    {name:<18} delta {delta:+8.1f} (acc {res['par_accuracy']:5.1f}% "
                      f"game {res['game_conversion']:5.1f}% imp {res['avg_imp_loss']:.2f}){mark}")
            if best_name is None:
                print("    no improving patch this pass")
                break
            pool[best_name](current)
            cur_train = best_res
            del pool[best_name]
            print(f"    APPLIED {best_name} ({best_delta:+.1f}); rules {len(current.rules)}")

    print(f"\n{'='*90}\n VALIDATION vs ORIGINAL\n{'='*90}")
    final_train = evl(current, train_deals, dd_train)
    print(f"  train: {orig_train['avg_score']:+.1f} -> {final_train['avg_score']:+.1f} "
          f"({final_train['avg_score'] - orig_train['avg_score']:+.1f})")
    val_ok = True
    for s in VAL_SEEDS:
        rv = evl(current, *val_sets[s])
        d = rv["avg_score"] - orig_val[s]["avg_score"]
        val_ok = val_ok and d > -5
        print(f"  val {s} : {orig_val[s]['avg_score']:+.1f} -> {rv['avg_score']:+.1f} ({d:+.1f})")
        print(f"         flaws {dict(rv['flaws'])}")

    train_gain = final_train["avg_score"] - orig_train["avg_score"]
    if train_gain > 0 and val_ok:
        current.name = "ImprovedSystem_v5"
        current.save_dsl(TARGET)
        print(f"\n  SAVED v5 (train {train_gain:+.1f}) -> {TARGET}")
    else:
        print(f"\n  NOT SAVED (train {train_gain:+.1f}, val_ok={val_ok}); keeping current file")
    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
