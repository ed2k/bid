#!/usr/bin/env python3
"""
Fix Board-1-class defects:
  A) X_RESPONSE pack: advancer rules over partner's takeout double
  B) GATE_RESP_2H: R_RESP_2H requires partner_last_call == '1H'
Paired confirmation on 3 seeds; saves v7 if consistent.
Also prints the re-diagnosed Board 1 after the winning patch.
"""

import json
import os
import shutil
import time

from bid.models import Strain, Call, CallType, Seat
from bid.decision_net import DecisionNetRule, RuleCondition
from bid.sampling import PartialState
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR, contract_string
from improve_improved_system import precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
STATE_PATH = os.path.join(SYSTEM_DIR, "flywheel_state.json")


def patch_x_response(net):
    for strain in (Strain.HEARTS, Strain.SPADES):
        net.add_rule(DecisionNetRule(
            f"X_LIFT_2{strain.name[0]}", Call(CallType.BID, 2, strain), [
                RuleCondition("partner_last_call", "==", "X"), RuleCondition("hcp", ">=", 6),
                RuleCondition(f"{strain.name.lower()}_len", ">=", 4)], priority=26))
    net.add_rule(DecisionNetRule(
        "X_LIFT_3D", Call(CallType.BID, 3, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "==", "X"), RuleCondition("hcp", ">=", 11),
            RuleCondition("diamond_len", ">=", 5)], priority=27))
    net.add_rule(DecisionNetRule(
        "X_RESP_2NT", Call(CallType.BID, 2, Strain.NT), [
            RuleCondition("partner_last_call", "==", "X"), RuleCondition("hcp", ">=", 10),
            RuleCondition("is_balanced", "==", True)], priority=25))


def patch_gate_2h(net):
    net.rules = [r for r in net.rules if r.rule_id != "R_RESP_2H"]
    net.add_rule(DecisionNetRule(
        "R_RESP_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"),
            RuleCondition("heart_len", ">=", 3),
            RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)], priority=18))


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    base_net = load_decision_net_dsl(TARGET)

    variants = {
        "A_X_RESPONSE": base_net.clone(),
        "B_GATE_2H": base_net.clone(),
        "C_BOTH": base_net.clone(),
    }
    patch_x_response(variants["A_X_RESPONSE"])
    patch_gate_2h(variants["B_GATE_2H"])
    patch_x_response(variants["C_BOTH"]); patch_gate_2h(variants["C_BOTH"])

    deltas = {n: [] for n in variants}
    for seed in (42, 7, 13):
        deals = build_deals(64, seed=seed)
        dd = precompute(deals)
        rb = evaluate_system(arena, "base", base_net, deals, dd, seed=777)
        line = f"  seed {seed:<3} base {rb['avg_score']:+8.1f}"
        for name, net in variants.items():
            rf = evaluate_system(arena, name, net, deals, dd, seed=777)
            d = rf["avg_score"] - rb["avg_score"]
            deltas[name].append(d)
            line += f" | {name} {d:+7.1f}"
        print(line)

    print()
    for n, ds in deltas.items():
        print(f"  {n:<14} wins {sum(1 for x in ds if x > 0)}/3 avg {sum(ds)/3:+.1f}")

    def ok(name):
        ds = deltas[name]
        return sum(1 for x in ds if x > 0) >= 2 and sum(ds) / 3 > -5

    chosen = "C_BOTH" if ok("C_BOTH") else ("A_X_RESPONSE" if ok("A_X_RESPONSE") else None)
    if chosen:
        winner = variants[chosen]
        state = json.load(open(STATE_PATH)) if os.path.exists(STATE_PATH) else {"version": 6}
        v = state.get("version", 6)
        os.makedirs(os.path.join(SYSTEM_DIR, "history"), exist_ok=True)
        shutil.copy(TARGET, os.path.join(SYSTEM_DIR, "history", f"improved_system_v{v}.dsl"))
        state["version"] = v + 1
        winner.name = f"ImprovedSystem_v{v + 1}"
        winner.save_dsl(TARGET)
        state["applied"].append({"sig": f"manual:{chosen}", "name": chosen, "delta": round(sum(deltas[chosen]) / 3, 1)})
        json.dump(state, open(STATE_PATH, "w"), indent=2)
        print(f"\nSaved {chosen} as v{v + 1} -> {TARGET}")
    else:
        winner = base_net
        print("\nNo variant met acceptance; file unchanged.")

    deals = build_deals(8, seed=42)
    deal = deals[0]
    hist, sc = arena.play_board(deal, winner, winner)
    ps = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], hist, deal.dealer, deal.vuln)
    from bid.diagnostics import ParDiagnosticEngine
    diag = ParDiagnosticEngine.diagnose_board(1, deal, hist, sc)
    print(f"\nBoard 1 replay under {'winner' if chosen else 'current'}:")
    print("   auction:", " ".join(str(c) for c in hist))
    print(f"   contract {contract_string(ps)} | NS score {sc:+.0f} | flaw {diag.flaw_type.value}")
    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
