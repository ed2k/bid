#!/usr/bin/env python3
"""
Stage-2 improvement of system/improved_system.dsl targeting diagnosed flaws:
  - OVERBID_DOWN: gate R_RESP_3NT and R_4H/R_4S with auction context
  - SOFT_DEFENSE / wrong-strain: add 1-level new-suit responses + opener rebids
  - diagnostic families (COMP/GAME/SLAM) retested post junk-cleanup
Greedy hill-climb on train set (seed 42), validation on disjoint seed 7,
persists winner to system/improved_system.dsl.
"""

import os
import time
from typing import Callable, Dict, List

from bid.models import Seat, Strain, Call, CallType
from bid.decision_net import DecisionNetRule, RuleCondition
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
from improve_improved_system import precompute, make_add_patch, summarize

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
EVAL_SEED = 1234


def replace_rules(net, replacements: List[DecisionNetRule]) -> None:
    ids = {r.rule_id for r in replacements}
    net.rules = [r for r in net.rules if r.rule_id not in ids]
    for r in replacements:
        net.add_rule(r)


def patch_gate_3nt(net) -> None:
    replace_rules(net, [DecisionNetRule(
        "R_RESP_3NT", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "in", ["1C", "1D", "1H", "1S", "1NT"]),
            RuleCondition("is_balanced", "==", True),
            RuleCondition("hcp", ">=", 10), RuleCondition("hcp", "<=", 15),
        ], description="3NT response only over partner's opening/1NT", priority=22)])


def patch_gate_direct_game(net) -> None:
    replace_rules(net, [
        DecisionNetRule("R_4H", Call(CallType.BID, 4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "in", ["1H", "2H", "3H"]),
            RuleCondition("heart_len", ">=", 6), RuleCondition("hcp", ">=", 13),
        ], description="4H requires partner heart auction", priority=25),
        DecisionNetRule("R_4S", Call(CallType.BID, 4, Strain.SPADES), [
            RuleCondition("partner_last_call", "in", ["1S", "2S", "3S"]),
            RuleCondition("spade_len", ">=", 6), RuleCondition("hcp", ">=", 13),
        ], description="4S requires partner spade auction", priority=25),
    ])


def patch_new_suit_responses(net) -> None:
    make_add_patch([
        DecisionNetRule("R_RESP_1S", Call(CallType.BID, 1, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1H"),
            RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 6),
        ], description="1S new-suit response to 1H", priority=20),
        DecisionNetRule("R_RESP_1H", Call(CallType.BID, 1, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1S"),
            RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 6),
        ], description="1H new-suit response to 1S", priority=20),
        DecisionNetRule("R_RESP_1D", Call(CallType.BID, 1, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "in", ["1H", "1S"]),
            RuleCondition("diamond_len", ">=", 4), RuleCondition("hcp", ">=", 6),
        ], description="1D new-suit response to 1M", priority=15),
        DecisionNetRule("R_RESP_1NT_NEW", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("partner_last_call", "in", ["1C", "1D", "1H", "1S"]),
            RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10),
        ], description="1NT response to partner opening", priority=14),
    ])(net)


def patch_opener_rebids(net) -> None:
    make_add_patch([
        DecisionNetRule("R_REBID_1NT_OP", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("partner_last_call", "in", ["1C", "1D", "1H", "1S"]),
            RuleCondition("is_balanced", "==", True),
            RuleCondition("hcp", ">=", 12), RuleCondition("hcp", "<=", 14),
        ], description="Opener 1NT rebid 12-14 balanced", priority=21),
        DecisionNetRule("R_REBID_2NT_OP", Call(CallType.BID, 2, Strain.NT), [
            RuleCondition("partner_last_call", "in", ["1C", "1D", "1H", "1S"]),
            RuleCondition("is_balanced", "==", True),
            RuleCondition("hcp", ">=", 18), RuleCondition("hcp", "<=", 19),
        ], description="Opener 2NT rebid 18-19 balanced", priority=22),
        DecisionNetRule("R_RAISE_2S", Call(CallType.BID, 2, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"),
            RuleCondition("spade_len", ">=", 3),
            RuleCondition("hcp", ">=", 13), RuleCondition("hcp", "<=", 16),
        ], description="Opener raise of responder 1S", priority=20),
        DecisionNetRule("R_RAISE_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"),
            RuleCondition("heart_len", ">=", 3),
            RuleCondition("hcp", ">=", 13), RuleCondition("hcp", "<=", 16),
        ], description="Opener raise of responder 1H", priority=20),
    ])(net)


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)

    train_deals = build_deals(36, seed=42)
    val_deals = build_deals(36, seed=7)
    dd_train = precompute(train_deals)
    dd_val = precompute(val_deals)

    base_net = load_decision_net_dsl(TARGET)

    def evl(net, deals, dd, diags=False):
        return evaluate_system(arena, "cand", net, deals, dd, run_diagnostics=diags, seed=EVAL_SEED)

    base_train = evl(base_net, train_deals, dd_train, diags=True)
    base_val = evl(base_net, val_deals, dd_val)
    print("Baseline (current improved_system.dsl):")
    summarize("train", base_train)
    summarize("val", base_val)

    from bid.diagnostics import ParDiagnosticEngine
    corrective = ParDiagnosticEngine.generate_corrective_rules_for_diagnostics(base_train["diagnostics"])
    families: Dict[str, List] = {}
    for r in corrective:
        families.setdefault(r.rule_id.split("_")[0], []).append(r)

    patches: Dict[str, Callable] = {
        "GATE_3NT": patch_gate_3nt,
        "GATE_GAME": patch_gate_direct_game,
        "NEW_SUIT_RESP": patch_new_suit_responses,
        "OPENER_REBIDS": patch_opener_rebids,
    }
    for fam, rules in sorted(families.items()):
        patches[f"ADD_{fam}"] = make_add_patch(rules)

    current, current_train = base_net.clone(), base_train
    applied: List[str] = []
    pool = dict(patches)

    for rnd in range(1, 4):
        print(f"\nGreedy round {rnd}: {len(pool)} patches on train set...")
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
                mark = "  <-- best"
            print(f"    {name:<16} delta {delta:+8.1f} (acc {res['par_accuracy']:5.1f}% "
                  f"game {res['game_conversion']:5.1f}% flaws {dict(res['flaws'])}){mark}")

        if best_name is None:
            print("    No improving patch; stopping.")
            break
        pool[best_name](current)
        applied.append(best_name)
        current_train = best_res
        del pool[best_name]
        print(f"    APPLIED {best_name} (delta {best_delta:+.1f}); rules {len(current.rules)}")

    final_val = evl(current, val_deals, dd_val)
    final_train = evl(current, train_deals, dd_train, diags=True)
    print("\nFinal comparison:")
    summarize("baseline train", base_train)
    summarize("improved train", final_train)
    summarize("baseline val", base_val)
    summarize("improved val", final_val)
    print(f"    Applied: {applied or 'none'}")
    print(f"    Train flaws now: {dict(final_train['flaws'])}")

    train_gain = final_train["avg_score"] - base_train["avg_score"]
    val_gain = final_val["avg_score"] - base_val["avg_score"]
    if val_gain >= -5.0:
        current.name = "ImprovedSystem_v3"
        current.save_dsl(TARGET)
        print(f"\nSaved v3 to {TARGET} (train {train_gain:+.1f}, val {val_gain:+.1f} pts/board)")
    else:
        print(f"\nRejected on validation (val {val_gain:+.1f}); keeping existing file.")

    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
