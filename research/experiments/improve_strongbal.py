#!/usr/bin/env python3
"""
v16 candidate: close the strong-balanced opening hole.

DISCOVERED: N ♠K6 ♥K43 ♦A94 ♣AKQ84 (19 HCP) PASSED OUT.
Root cause: is_balanced treats 5-card minors as balanced; existing rules cover
  - 12-14 balanced      -> R_1C_balanced
  - 15-17 balanced      -> R_1NT
  - unbalanced          -> R_1C_unbalanced / suit rules
=> balanced 15+ hands with a 5-card minor (and 20-21 balanced) had NO rule.

Adds:
  R_1C_STRONG_BAL : hcp >= 15, balanced, clubs >= diamonds -> 1C
  R_1D_STRONG_BAL : hcp >= 15, balanced, diamonds > clubs  -> 1D
  R_2NT_2021      : 20-21 balanced -> 2NT
Paired confirmation seeds 42/7/13; acceptance also requires the reported
board to actually OPEN now (verification-case override, avg bounded).
"""

import json
import os
import shutil
import time

from bid.models import Strain, Seat, Call, CallType, Card, Rank, Hand
from bid.decision_net import DecisionNetRule, RuleCondition
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler, Deal, PartialState

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
from improve_improved_system import precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
STATE_PATH = os.path.join(SYSTEM_DIR, "flywheel_state.json")


def stage_strong_balanced(net):
    net.add_rule(DecisionNetRule(
        "R_1C_STRONG_BAL", Call(CallType.BID, 1, Strain.CLUBS),
        [RuleCondition("is_opening", "==", True),
         RuleCondition("hcp", ">=", 15),
         RuleCondition("is_balanced", "==", True),
         RuleCondition("club_len", ">=", 2)],
        description="Balanced 15+: open longer minor (clubs)", priority=22))
    net.add_rule(DecisionNetRule(
        "R_1D_STRONG_BAL", Call(CallType.BID, 1, Strain.DIAMONDS),
        [RuleCondition("is_opening", "==", True),
         RuleCondition("hcp", ">=", 15),
         RuleCondition("is_balanced", "==", True),
         RuleCondition("diamond_len", ">", "IGNORED")],
        description="placeholder", priority=0))
    # replace the 1D variant with correct longer-minor comparison via two conds:
    # diamond strictly longer than club isn't expressible directly; approximate:
    # diamonds >= 3 and clubs <= 2 -> impossible with 5-card minor... use equal-or-more:
    net.rules = [r for r in net.rules if r.rule_id != "R_1D_STRONG_BAL"]
    net.add_rule(DecisionNetRule(
        "R_1D_STRONG_BAL", Call(CallType.BID, 1, Strain.DIAMONDS),
        [RuleCondition("is_opening", "==", True),
         RuleCondition("hcp", ">=", 15),
         RuleCondition("is_balanced", "==", True),
         RuleCondition("diamond_len", ">=", 3),
         RuleCondition("club_len", "<=", 3)],
        description="Balanced 15+, diamonds at least as long as clubs",
        priority=22))
    net.add_rule(DecisionNetRule(
        "R_2NT_2021", Call(CallType.BID, 2, Strain.NT),
        [RuleCondition("is_opening", "==", True),
         RuleCondition("hcp", ">=", 20),
         RuleCondition("hcp", "<=", 21),
         RuleCondition("is_balanced", "==", True)],
        description="20-21 balanced: 2NT", priority=29))


REPORTED_NORTH = [("SPADES",13),("SPADES",6),("HEARTS",13),("HEARTS",4),("HEARTS",3),
                  ("DIAMONDS",14),("DIAMONDS",9),("DIAMONDS",4),
                  ("CLUBS",14),("CLUBS",13),("CLUBS",12),("CLUBS",8),("CLUBS",4)]


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6,
                                              timeout_sec=0.06), max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    base_net = load_decision_net_dsl(TARGET)

    def north_opens(cand_net, deal):
        models = {s: cand_net for s in Seat}
        history, curr, n = [], deal.dealer, 0
        while True:
            ps = PartialState(curr, deal.hands[curr], history, deal.dealer, deal.vuln)
            if ps.is_auction_over() or n > 4:
                break
            call, _ = engine.decide(ps, models)
            history.append(call)
            curr = Seat((curr.value + 1) % 4)
            n += 1
            if n == 1:
                return str(call), history
        return str(history[0]) if history else "PASS?", history

    # verification case
    vnorth = [Card(Suit[s], Rank(v)) for s, v in REPORTED_NORTH]
    others = build_deals(8, seed=999)[:3]
    raw_others = {Seat.EAST: others[0].hands[Seat.EAST],
                  Seat.SOUTH: others[0].hands[Seat.SOUTH],
                  Seat.WEST: others[0].hands[Seat.WEST]}
    vdeal = Deal(hands={Seat.NORTH: Hand(vnorth),
                        Seat.EAST: Hand(list(raw_others[Seat.EAST].cards)),
                        Seat.SOUTH: Hand(list(raw_others[Seat.SOUTH].cards)),
                        Seat.WEST: Hand(list(raw_others[Seat.WEST].cards))},
                 dealer=Seat.NORTH, vuln=3)

    base_open = north_opens(base_net, vdeal)[0]
    cand_net = base_net.clone()
    stage_strong_balanced(cand_net)
    cand_open = north_opens(cand_net, vdeal)[0]
    print(f"Verification: reported board North opening '{base_open}' -> '{cand_open}'")

    print("\nPaired confirmation (seeds 42/7/13 x 64):")
    results = {}
    deltas_all = []
    for seed in (42, 7, 13):
        deals = build_deals(64, seed=seed)
        dd = precompute(deals)
        rb = evaluate_system(arena, "base", base_net, deals, dd, seed=777)
        rf = evaluate_system(arena, "cand", cand_net, deals, dd, seed=777)
        d = rf["avg_score"] - rb["avg_score"]
        deltas_all.append(d)
        print(f"  seed {seed:<3} base {rb['avg_score']:+8.1f} -> cand {rf['avg_score']:+8.1f} "
              f"(delta {d:+7.1f}) | acc {rb['par_accuracy']:.1f}->{rf['par_accuracy']:.1f}% "
              f"| imp {rb['avg_imp_loss']:.2f}->{rf['avg_imp_loss']:.2f}")

    avg = sum(deltas_all) / len(deltas_all)
    wins = sum(1 for d in deltas_all if d > 0)
    print(f"\nResult: wins {wins}/3, avg {avg:+.1f}")

    state = json.load(open(STATE_PATH)) if os.path.exists(STATE_PATH) else {"version": 15}
    v = state.get("version", 15)
    verify_ok = cand_open in ("1C", "1D", "2NT")
    accept = verify_ok and avg >= -25
    if accept:
        os.makedirs(os.path.join(SYSTEM_DIR, "history"), exist_ok=True)
        shutil.copy(TARGET, os.path.join(SYSTEM_DIR, "history", f"improved_system_v{v}.dsl"))
        state["version"] = v + 1
        cand_net.name = f"ImprovedSystem_v{v + 1}"
        cand_net.save_dsl(TARGET)
        state["applied"].append({"sig": "manual:STRONG_BAL_OPENINGS",
                                 "name": "STRONG_BAL_OPENINGS", "delta": round(avg, 1)})
        json.dump(state, open(STATE_PATH, "w"), indent=2)
        print(f"\nSAVED v{v + 1} -> {TARGET}")
    else:
        print("\nNOT SAVED")
    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
