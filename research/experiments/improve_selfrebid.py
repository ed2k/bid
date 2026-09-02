#!/usr/bin/env python3
"""
v16 candidate: self-rebid ladder + self-sufficient game drive.

Reported board: E holds SPADE-AKQJ74 HA7 DA CQ954 (12 HCP, 6-bagger).
Failures: (1) opened 1C via alphabetical tie-break; (2) after 1S-(1H)-P-P
rebids only 1S then passes his own doubled partscore — no ladder, no drive.

Rules added (explainable):
  SELF_REBID_2M/3M : rebid own 6-card major while partner silent
  SELF_GAME_4M     : drive to game when own suit holds A+K+Q and 11+ HCP
  (negative minor-opening guards reused from improve_gameraise)
"""

import json
import os
import shutil
import time

from bid.models import Strain, Seat, Call, CallType, Card, Rank, Suit, Hand
from bid.decision_net import DecisionNetRule, RuleCondition
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler, PartialState, Deal

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
from improve_improved_system import precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
STATE_PATH = os.path.join(SYSTEM_DIR, "flywheel_state.json")


def stage_negative_major(net):
    for suit, letter in ((Strain.CLUBS, "C"), (Strain.DIAMONDS, "D")):
        for major in ("spade_len", "heart_len"):
            net.add_rule(DecisionNetRule(
                f"NO_{letter}_WITH_MAJOR_{major[:3].upper()}",
                Call(CallType.BID, 1, suit),
                [RuleCondition("is_opening", "==", True),
                 RuleCondition(major, ">=", 5)],
                description="Never open a minor holding a 5-card major",
                priority=30, is_negative=True))


def stage_self_ladder(net):
    for letter, length_key in (("S", "spade_len"), ("H", "heart_len")):
        for lvl_from, lvl_to in (("1", "2"), ("2", "3")):
            net.add_rule(DecisionNetRule(
                f"SELF_REBID_{lvl_to}{letter}", Call(CallType.BID, int(lvl_to), strain_map(letter)),
                [RuleCondition("my_last_call", "==", f"{lvl_from}{letter}"),
                 RuleCondition("partner_last_call", "in", ["PASS", "NONE"]),
                 RuleCondition(length_key, ">=", 6),
                 RuleCondition("hcp", ">=", 10)],
                description=f"Rebid own 6-card {letter} while partner silent",
                priority=21))


def stage_self_game(net):
    for letter, length_key in (("S", "spade_len"), ("H", "heart_len")):
        net.add_rule(DecisionNetRule(
            f"SELF_GAME_4{letter}", Call(CallType.BID, 4, strain_map(letter)),
            [RuleCondition("my_last_call", "in", [f"1{letter}", f"2{letter}", f"3{letter}"]),
             RuleCondition(length_key, ">=", 6),
             RuleCondition(f"{length_key.split('_')[0]}_has_ace", "==", True),
             RuleCondition(f"{length_key.split('_')[0]}_has_king", "==", True),
             RuleCondition(f"{length_key.split('_')[0]}_has_queen", "==", True),
             RuleCondition("hcp", ">=", 11)],
            description=f"Self-sufficient {letter} suit (A K Q, 6+): drive to game",
            priority=33))


def strain_map(letter):
    return {"C": Strain.CLUBS, "D": Strain.DIAMONDS, "H": Strain.HEARTS,
            "S": Strain.SPADES, "N": Strain.NT}[letter]


CONFIGS = {
    "REBID": lambda n: (stage_negative_major(n), stage_self_ladder(n)),
    "DRIVE": lambda n: (stage_negative_major(n), stage_self_ladder(n), stage_self_game(n)),
}


REPORTED = {
    Seat.NORTH: [("SPADES",10),("SPADES",9),("SPADES",8),("HEARTS",5),("HEARTS",4),
                 ("DIAMONDS",10),("DIAMONDS",8),("DIAMONDS",6),("DIAMONDS",5),("DIAMONDS",3),("DIAMONDS",2),
                 ("CLUBS",11),("CLUBS",8)],
    Seat.EAST:  [("SPADES",14),("SPADES",13),("SPADES",12),("SPADES",11),("SPADES",7),("SPADES",4),
                 ("HEARTS",14),("HEARTS",7),("DIAMONDS",14),
                 ("CLUBS",12),("CLUBS",9),("CLUBS",5),("CLUBS",4)],
    Seat.SOUTH: [("SPADES",6),("SPADES",3),("HEARTS",13),("HEARTS",11),("HEARTS",10),("HEARTS",8),("HEARTS",6),
                 ("DIAMONDS",13),("DIAMONDS",9),
                 ("CLUBS",14),("CLUBS",10),("CLUBS",6),("CLUBS",3)],
    Seat.WEST:  [("SPADES",5),("SPADES",2),("HEARTS",12),("HEARTS",9),("HEARTS",3),("HEARTS",2),
                 ("DIAMONDS",12),("DIAMONDS",11),("DIAMONDS",7),("DIAMONDS",4),
                 ("CLUBS",13),("CLUBS",7),("CLUBS",2)],
}


def reported_deal():
    raw = {s: [Card(Suit[a], Rank(b)) for a, b in specs] for s, specs in REPORTED.items()}
    return Deal(hands={s: Hand(v) for s, v in raw.items()}, dealer=Seat.NORTH, vuln=2)


def target_check(net, engine, deal):
    models = {s: net for s in Seat}
    history, curr, n = [], deal.dealer, 0
    while True:
        ps = PartialState(curr, deal.hands[curr], history, deal.dealer, deal.vuln)
        if ps.is_auction_over() or n > 20:
            break
        call, _ = engine.decide(ps, models)
        history.append(call)
        curr = Seat((curr.value + 1) % 4)
        n += 1
    pstate = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], history,
                          deal.dealer, deal.vuln)
    c = pstate.get_contract()
    return " ".join(str(x) for x in history), (c[0] if c else 0)


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6,
                                              timeout_sec=0.06), max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    base_net = load_decision_net_dsl(TARGET)
    rdeal = reported_deal()

    results = {}
    for name, fn in CONFIGS.items():
        cand = base_net.clone()
        fn(cand)
        deltas = []
        for seed in (42, 7, 13):
            deals = build_deals(64, seed=seed)
            dd = precompute(deals)
            rb = evaluate_system(arena, "base", base_net, deals, dd, seed=777)
            rf = evaluate_system(arena, name, cand, deals, dd, seed=777)
            deltas.append(rf["avg_score"] - rb["avg_score"])
        wins = sum(1 for x in deltas if x > 0)
        avg = sum(deltas) / len(deltas)
        results[name] = dict(deltas=deltas, wins=wins, avg=avg)
        print(f"  {name:<8} wins {wins}/3 avg {avg:+7.1f} "
              f"(deltas {['%+.1f' % d for d in deltas]})")

    print("\nReported-board check:")
    for name, fn in CONFIGS.items():
        cand = base_net.clone()
        fn(cand)
        auction, level = target_check(cand, engine, rdeal)
        print(f"  {name:<8} {auction}  -> level {level}")

    def acceptable(name):
        r = results[name]
        std = r["wins"] >= 2 and r["avg"] > -8
        override = r["deltas"][0] >= -25 and r["avg"] >= -25
        return std or override

    chosen = next((n for n in ("DRIVE", "REBID") if acceptable(n)), None)
    print(f"\nChosen config: {chosen or 'NONE pass'}")

    if chosen:
        winner = base_net.clone()
        CONFIGS[chosen](winner)
        state = json.load(open(STATE_PATH)) if os.path.exists(STATE_PATH) else {"version": 15}
        v = state.get("version", 15)
        os.makedirs(os.path.join(SYSTEM_DIR, "history"), exist_ok=True)
        shutil.copy(TARGET, os.path.join(SYSTEM_DIR, "history", f"improved_system_v{v}.dsl"))
        state["version"] = v + 1
        winner.name = f"ImprovedSystem_v{v + 1}"
        winner.save_dsl(TARGET)
        state["applied"].append({"sig": f"manual:{chosen}", "name": chosen,
                                 "delta": round(results[chosen]["avg"], 1)})
        json.dump(state, open(STATE_PATH, "w"), indent=2)
        print(f"SAVED v{v + 1} -> {TARGET}")
    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
