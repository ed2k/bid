#!/usr/bin/env python3
"""
v10 candidate: replace the forced 6NT slam drive with an explicit control ask
(Blackwood-style 4NT -> ace-count response -> placement).

Variants vs current v9 (paired, one process, 3 seeds):
  A_ASK_ONLY : SLAM_DRIVE_6NT removed; ask/response/placement rules added
  B_KEEP_BOTH: drive kept too; PIDM expected-value arbitrates ask vs drive
Verification: Board 1 must still reach slam; paired deltas + flaw counts.
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


def _ask_pack(net):
    net.add_rule(DecisionNetRule(
        "ASK_4NT_ACES", Call(CallType.BID, 4, Strain.NT), [
            RuleCondition("partner_last_call", "==", "3NT"),
            RuleCondition("hcp", ">=", 15)], description="Blackwood-style ace ask over 3NT", priority=29))
    for aces, strain in ((0, Strain.CLUBS), (1, Strain.DIAMONDS), (2, Strain.HEARTS), (3, Strain.SPADES)):
        conds = [RuleCondition("partner_last_call", "==", "4NT"),
                 RuleCondition("ace_count", "==", aces)]
        if aces < 3:
            conds.append(RuleCondition("ace_count", "<=", aces))
        else:
            conds[0].value = "4NT"
        net.add_rule(DecisionNetRule(
            f"BW_RESP_{strain.name[0]}", Call(CallType.BID, 5, strain),
            conds, description=f"Ace response {aces}", priority=31))
    net.add_rule(DecisionNetRule(
        "PLACE_6NT_ACES", Call(CallType.BID, 6, Strain.NT), [
            RuleCondition("my_last_call", "==", "4NT"),
            RuleCondition("partner_last_call", "in", ["5D", "5H", "5S"])],
        description="Place 6NT with an ace shown", priority=32))
    net.add_rule(DecisionNetRule(
        "SIGNOFF_5NT_NOACE", Call(CallType.BID, 5, Strain.NT), [
            RuleCondition("my_last_call", "==", "4NT"),
            RuleCondition("partner_last_call", "==", "5C")],
        description="Sign off in 5NT with no ace shown", priority=32))


def patch_a(net):
    net.rules = [r for r in net.rules if r.rule_id != "SLAM_DRIVE_6NT"]
    _ask_pack(net)


def patch_b(net):
    _ask_pack(net)


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

    variants = {"A_ASK_ONLY": base_net.clone(), "B_KEEP_BOTH": base_net.clone()}
    patch_a(variants["A_ASK_ONLY"])
    patch_b(variants["B_KEEP_BOTH"])

    print("[1] Board 1 verification:")
    deals8 = build_deals(8, seed=42)
    b1_scores = {}
    for name in list(variants):
        print(f"   {name}:")
        b1_scores[name] = replay_board1(variants[name], arena, deals8)

    print("\n[2] Paired confirmation (64 boards x 3 seeds):")
    deltas = {n: [] for n in variants if not n.endswith("_b1")}
    miss = {n: (0, 0) for n in deltas}
    obid = {n: (0, 0) for n in deltas}
    for seed in (42, 7, 13):
        deals = build_deals(64, seed=seed)
        dd = precompute(deals)
        rb = evaluate_system(arena, "base", base_net, deals, dd, run_diagnostics=True, seed=777)
        line = f"  seed {seed:<3} base {rb['avg_score']:+8.1f}"
        for name in list(deltas):
            rf = evaluate_system(arena, name, variants[name], deals, dd, run_diagnostics=True, seed=777)
            d = rf["avg_score"] - rb["avg_score"]
            deltas[name].append(d)
            miss[name] = (miss[name][0] + rb["flaws"].get("MISSED_SLAM", 0),
                          miss[name][1] + rf["flaws"].get("MISSED_SLAM", 0))
            obid[name] = (obid[name][0] + rb["flaws"].get("OVERBID_DOWN", 0),
                          obid[name][1] + rf["flaws"].get("OVERBID_DOWN", 0))
            line += f" | {name} {d:+7.1f}"
        print(line)

    print()
    chosen = None
    for name in deltas:
        ds = deltas[name]
        wins = sum(1 for x in ds if x > 0)
        b1_slam = b1_scores.get(name)
        b1_ok = b1_slam is not None and b1_slam >= 900
        print(f"  {name:<12} wins {wins}/3 avg {sum(ds)/3:+.1f} | MISSED_SLAM {miss[name][0]}->{miss[name][1]} "
              f"| OVERBID_DOWN {obid[name][0]}->{obid[name][1]} | Board1 {'SLAM OK' if b1_ok else 'FAIL'}")
        if wins >= 2 and sum(ds) / 3 > -8 and b1_ok:
            chosen = name
    if len(deltas) == 2 and chosen is None:
        pass

    if chosen:
        winner = variants[chosen]
        state = json.load(open(STATE_PATH)) if os.path.exists(STATE_PATH) else {"version": 9}
        v = state.get("version", 9)
        os.makedirs(os.path.join(SYSTEM_DIR, "history"), exist_ok=True)
        shutil.copy(TARGET, os.path.join(SYSTEM_DIR, "history", f"improved_system_v{v}.dsl"))
        state["version"] = v + 1
        winner.name = f"ImprovedSystem_v{v + 1}"
        winner.save_dsl(TARGET)
        state["applied"].append({"sig": f"manual:{chosen}", "name": chosen,
                                 "delta": round(sum(deltas[chosen]) / 3, 1)})
        json.dump(state, open(STATE_PATH, "w"), indent=2)
        print(f"\nSAVED {chosen} as v{v + 1} -> {TARGET}")
    else:
        print("\nNOT SAVED (no variant met acceptance)")
    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
