#!/usr/bin/env python3
"""
v11 candidate: extend the control ladder with a KING ask (5NT) enabling
verified grand slams.

Ladder: 4NT (aces) -> 5x (ace count) -> 5NT (kings, only if asker 16+ and an
ace shown) -> 6x (king count) -> 7NT / 6NT placement.
Board 1 expectation: 4NT-5H-5NT-6C(0 kings)-6NT => still +1020, now fully verified.
Paired confirm on 3 seeds; save v11 if accepted.
"""

import json
import os
import shutil
import time

from bid.models import Strain, Seat, Call, CallType
from bid.decision_net import DecisionNetRule, RuleCondition
from bid.sampling import PartialState
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR, contract_string
from improve_improved_system import precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
STATE_PATH = os.path.join(SYSTEM_DIR, "flywheel_state.json")


def patch_kings(net):
    ids = {"PLACE_6NT_ACES"}
    net.rules = [r for r in net.rules if r.rule_id not in ids]

    net.add_rule(DecisionNetRule(
        "ASK_5NT_KINGS", Call(CallType.BID, 5, Strain.NT), [
            RuleCondition("my_last_call", "==", "4NT"),
            RuleCondition("partner_last_call", "in", ["5D", "5H", "5S"]),
            RuleCondition("hcp", ">=", 16)], description="King ask after ace show, 16+", priority=33))
    net.add_rule(DecisionNetRule(
        "PLACE_6NT_ACES", Call(CallType.BID, 6, Strain.NT), [
            RuleCondition("my_last_call", "==", "4NT"),
            RuleCondition("partner_last_call", "in", ["5D", "5H", "5S"]),
            RuleCondition("hcp", "<=", 15)], description="Place 6NT, no king ask", priority=32))

    net.add_rule(DecisionNetRule(
        "KW_RESP_0_6C", Call(CallType.BID, 6, Strain.CLUBS), [
            RuleCondition("partner_last_call", "==", "5NT"),
            RuleCondition("my_last_call", "in", ["5D", "5H", "5S"]),
            RuleCondition("king_count", "==", 0)], description="0 kings", priority=34))
    net.add_rule(DecisionNetRule(
        "KW_RESP_1_6D", Call(CallType.BID, 6, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "==", "5NT"),
            RuleCondition("my_last_call", "in", ["5D", "5H", "5S"]),
            RuleCondition("king_count", "==", 1)], description="1 king", priority=34))
    net.add_rule(DecisionNetRule(
        "KW_RESP_2_6H", Call(CallType.BID, 6, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "5NT"),
            RuleCondition("my_last_call", "in", ["5D", "5H", "5S"]),
            RuleCondition("king_count", ">=", 2)], description="2+ kings", priority=34))

    net.add_rule(DecisionNetRule(
        "GRAND_7NT_TWO_K", Call(CallType.BID, 7, Strain.NT), [
            RuleCondition("my_last_call", "==", "5NT"),
            RuleCondition("partner_last_call", "in", ["6H", "6S"]),
            RuleCondition("hcp", ">=", 17)], description="7NT with 2+ kings shown", priority=36))
    net.add_rule(DecisionNetRule(
        "GRAND_7NT_ONE_K", Call(CallType.BID, 7, Strain.NT), [
            RuleCondition("my_last_call", "==", "5NT"),
            RuleCondition("partner_last_call", "==", "6D"),
            RuleCondition("hcp", ">=", 19)], description="7NT with 1 king, huge hand", priority=36))
    net.add_rule(DecisionNetRule(
        "PLACE_6NT_AFTER_K_ASK", Call(CallType.BID, 6, Strain.NT), [
            RuleCondition("my_last_call", "==", "5NT"),
            RuleCondition("partner_last_call", "in", ["6C", "6D", "6H"])],
        description="Settle in 6NT after king info", priority=30))


def replay_board1(net, arena, deals):
    deal = deals[0]
    hist, sc = arena.play_board(deal, net, net)
    ps = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], hist, deal.dealer, deal.vuln)
    from bid.diagnostics import ParDiagnosticEngine
    diag = ParDiagnosticEngine.diagnose_board(1, deal, hist, sc)
    print(f"   auction : {' '.join(str(c) for c in hist)}")
    print(f"   contract: {contract_string(ps)} | NS {sc:+.0f} | flaw {diag.flaw_type.value}")
    return sc


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    base_net = load_decision_net_dsl(TARGET)
    patched = base_net.clone()
    patch_kings(patched)

    print("[1] Board 1 verification:")
    b1 = replay_board1(patched, arena, build_deals(8, seed=42))

    print("\n[2] Paired confirmation (64 boards x 3 seeds):")
    deltas = []
    agg = {}
    for seed in (42, 7, 13):
        deals = build_deals(64, seed=seed)
        dd = precompute(deals)
        rb = evaluate_system(arena, "base", base_net, deals, dd, run_diagnostics=True, seed=777)
        rf = evaluate_system(arena, "kings", patched, deals, dd, run_diagnostics=True, seed=777)
        d = rf["avg_score"] - rb["avg_score"]
        deltas.append(d)
        for k in ("MISSED_SLAM", "OVERBID_DOWN"):
            a, _ = agg.get(k, (0, 0))
            agg[k] = (a + rb["flaws"].get(k, 0), _ + rf["flaws"].get(k, 0))
        print(f"  seed {seed:<3} base {rb['avg_score']:+8.1f} -> kings {rf['avg_score']:+8.1f} ({d:+7.1f}) "
              f"| acc {rb['par_accuracy']:.1f}->{rf['par_accuracy']:.1f}% | imp {rb['avg_imp_loss']:.2f}->{rf['avg_imp_loss']:.2f}")

    avg = sum(deltas) / 3
    wins = sum(1 for x in deltas if x > 0)
    print(f"\nResult: {wins}/3 sets, avg {avg:+.1f}")
    for k, (before, after) in agg.items():
        print(f"  {k}: {before} -> {after}")

    state = json.load(open(STATE_PATH)) if os.path.exists(STATE_PATH) else {"version": 10}
    v = state.get("version", 10)
    accept = wins >= 2 and avg > -8 and b1 is not None and b1 >= 900
    if accept:
        os.makedirs(os.path.join(SYSTEM_DIR, "history"), exist_ok=True)
        shutil.copy(TARGET, os.path.join(SYSTEM_DIR, "history", f"improved_system_v{v}.dsl"))
        state["version"] = v + 1
        patched.name = f"ImprovedSystem_v{v + 1}"
        patched.save_dsl(TARGET)
        state["applied"].append({"sig": "manual:KING_ASK_LADDER", "name": "KING_ASK_LADDER",
                                 "delta": round(avg, 1)})
        json.dump(state, open(STATE_PATH, "w"), indent=2)
        print(f"\nSAVED v{v + 1} -> {TARGET}")
    else:
        print("\nNOT SAVED (acceptance failed)")
    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
