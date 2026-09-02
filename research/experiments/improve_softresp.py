#!/usr/bin/env python3
"""
v16 candidate: restore core guards + close response-side coverage holes.

Fixes three verified cases:
  CASE A (19 HCP balanced 5-card minor passed out)  -> strong-balanced openings
  CASE B (13 HCP 6-card club silent over phantom 1C)-> minor competition rules
  PLUS     : restore is_opening guards on all opening rules (root rot)

Verification boards:
  V-A: reported 19-HCP hand must OPEN
  V-B: seed42/board35 -- South must make a non-pass call, final level >= 2
"""

import json
import os
import shutil
import time

from bid.models import Strain, Seat, Suit, Call, CallType, Card, Rank, Hand
from bid.decision_net import DecisionNetRule, RuleCondition
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler, Deal, PartialState

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
from improve_improved_system import precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
STATE_PATH = os.path.join(SYSTEM_DIR, "flywheel_state.json")

OPEN_IDS = {"R_1C_unbalanced", "R_1C_balanced", "R_1D", "R_1H", "R_1S"}


# ---------------- stages ----------------

def stage_repair(net):
    for i, r in enumerate(net.rules):
        if r.rule_id in OPEN_IDS and not any(
                c.key == "is_opening" for c in r.conditions):
            conds = [RuleCondition("is_opening", "==", True)] + list(r.conditions)
            net.rules[i] = DecisionNetRule(r.rule_id, r.call, conds,
                                           description=r.description,
                                           priority=r.priority)


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
         RuleCondition("diamond_len", ">=", 3),
         RuleCondition("club_len", "<=", 3)],
        description="Balanced 15+, diamonds at least as long", priority=22))
    net.add_rule(DecisionNetRule(
        "R_2NT_2021", Call(CallType.BID, 2, Strain.NT),
        [RuleCondition("is_opening", "==", True),
         RuleCondition("hcp", ">=", 20),
         RuleCondition("hcp", "<=", 21),
         RuleCondition("is_balanced", "==", True)],
        description="20-21 balanced: 2NT", priority=29))


def stage_minor_competition(net):
    """Overcalls + responses in minors (the class that was entirely absent)."""
    # overcall a 6-card minor over opponent's 1-of-suit
    strain_map = {"C": Strain.CLUBS, "D": Strain.DIAMONDS}
    for letter in ("C", "D"):
        strain = strain_map[letter]
        length_key = f"{letter.lower()}_len"
        net.add_rule(DecisionNetRule(
            f"MC_OVERCALL_2{letter}", Call(CallType.BID, 2, strain),
            [RuleCondition("opp_last_call", "in",
                           ["1C", "1D", "1H", "1S"]),
             RuleCondition(length_key, ">=", 6),
             RuleCondition("hcp", ">=", 11)],
            description=f"Competitive 2{letter} with 6-card minor, 11+",
            priority=21))
    # respond in own 6-card minor over partner's 1D / 1C opening
    net.add_rule(DecisionNetRule(
        "MC_RESP_2C_OVER_1D", Call(CallType.BID, 2, Strain.CLUBS),
        [RuleCondition("partner_last_call", "==", "1D"),
         RuleCondition("club_len", ">=", 5),
         RuleCondition("hcp", ">=", 10)],
        description="Respond 2C: own 5+ club suit, 10+ HCP", priority=21))
    net.add_rule(DecisionNetRule(
        "MC_RESP_2D_OVER_1C", Call(CallType.BID, 2, Strain.DIAMONDS),
        [RuleCondition("partner_last_call", "==", "1C"),
         RuleCondition("diamond_len", ">=", 5),
         RuleCondition("hcp", ">=", 10)],
        description="Respond 2D: own 5+ diamond suit, 10+ HCP", priority=21))
    # game drive: unbalanced with 6-card minor + 13 HCP -> 3NT attempt needs
    # stoppers; instead show the suit twice is enough for PIDM to judge NT.
    net.add_rule(DecisionNetRule(
        "MC_REBID_3MINOR", None if False else Call(CallType.BID, 3, Strain.CLUBS),
        [RuleCondition("my_last_call", "==", "2C"),
         RuleCondition("club_len", ">=", 6),
         RuleCondition("hcp", ">=", 12)],
        description="Rebid 6-card club at 3-level, 12+", priority=24))
    net.add_rule(DecisionNetRule(
        "MC_REBID_3D", Call(CallType.BID, 3, Strain.DIAMONDS),
        [RuleCondition("my_last_call", "==", "2D"),
         RuleCondition("diamond_len", ">=", 6),
         RuleCondition("hcp", ">=", 12)],
        description="Rebid 6-card diamond at 3-level, 12+", priority=24))


CONFIG_FULL = lambda n: (stage_repair(n), stage_negative_major(n),
                         stage_strong_balanced(n), stage_minor_competition(n))


# ---------------- verification boards ----------------

BOARD_A_NORTH = [("SPADES",13),("SPADES",6),("HEARTS",13),("HEARTS",4),("HEARTS",3),
                 ("DIAMONDS",14),("DIAMONDS",9),("DIAMONDS",4),
                 ("CLUBS",14),("CLUBS",13),("CLUBS",12),("CLUBS",8),("CLUBS",4)]
BOARD_B_SEED, BOARD_B_INDEX = 42, 34


def build_verification_deals():
    deals_b = build_deals(64, seed=BOARD_B_SEED)[BOARD_B_INDEX - 1]
    va_north = [Card(Suit[s], Rank(v)) for s, v in BOARD_A_NORTH]
    filler = build_deals(8, seed=999)[0]
    deal_a = Deal(hands={Seat.NORTH: Hand(va_north),
                         Seat.EAST: Hand(list(filler.hands[Seat.EAST].cards)),
                         Seat.SOUTH: Hand(list(filler.hands[Seat.SOUTH].cards)),
                         Seat.WEST: Hand(list(filler.hands[Seat.WEST].cards))},
                  dealer=Seat.NORTH, vuln=3)
    return [("V-A 19HCP", deal_a), ("V-B board35", deals_b)]


def auction_summary(net, engine, deal):
    models = {s: net for s in Seat}
    history, curr, n = [], deal.dealer, 0
    south_active = False
    while True:
        ps = PartialState(curr, deal.hands[curr], history, deal.dealer, deal.vuln)
        if ps.is_auction_over() or n > 20:
            break
        call, _ = engine.decide(ps, models)
        if curr == Seat.SOUTH and call.type != CallType.PASS:
            south_active = True
        history.append(call)
        curr = Seat((curr.value + 1) % 4)
        n += 1
    pstate = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], history,
                          deal.dealer, deal.vuln)
    c = pstate.get_contract()
    level = c[0] if c else 0
    return " ".join(str(x) for x in history), level, south_active


def main():
    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6,
                                              timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    base_net = load_decision_net_dsl(TARGET)

    cand_net = base_net.clone()
    CONFIG_FULL(cand_net)

    # paired confirmation
    print("Paired confirmation (seeds 42/7/13 x 64):")
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
    print(f"  Result: wins {wins}/3, avg {avg:+.1f}")

    # verification boards
    print("\nVerification boards:")
    vdeals = build_verification_deals()
    checks = []
    for label, vdeal in vdeals:
        auction, level, s_active = auction_summary(cand_net, engine, vdeal)
        b_auction, _, _ = auction_summary(base_net, engine, vdeal)
        print(f"  [{label}]")
        print(f"    base:    {b_auction}")
        print(f"    cand:    {auction}  (level {level}, south_active={s_active})")

    ok_a = True   # V-A: North must open (any non-pass first call)
    first_call = None
    models_c = {s: cand_net for s in Seat}
    vdeal_a = vdeals[0][1]
    ps = PartialState(Seat.NORTH, vdeal_a.hands[Seat.NORTH], [],
                      vdeal_a.dealer, vdeal_a.vuln)
    c0, _ = engine.decide(ps, models_c)
    ok_a = str(c0) != "PASS"
    ok_b = True
    vdeal_b = vdeals[1][1]
    bh, bl, sa = auction_summary(cand_net, engine, vdeal_b)
    ok_b = sa and bl >= 2
    print(f"\n  V-A opens: {ok_a} | V-B south-active & level>=2: {ok_b}")

    accept = (avg >= -25) and ok_a and ok_b
    state = json.load(open(STATE_PATH)) if os.path.exists(STATE_PATH) else {"version": 15}
    v = state.get("version", 15)
    if accept:
        os.makedirs(os.path.join(SYSTEM_DIR, "history"), exist_ok=True)
        shutil.copy(TARGET, os.path.join(SYSTEM_DIR, "history",
                                         f"improved_system_v{v}.dsl"))
        state["version"] = v + 1
        cand_net.name = f"ImprovedSystem_v{v + 1}"
        cand_net.save_dsl(TARGET)
        state["applied"].append({"sig": "manual:CORE_GUARDS_AND_RESPONSES",
                                 "name": "CORE_GUARDS_AND_RESPONSES",
                                 "delta": round(avg, 1)})
        json.dump(state, open(STATE_PATH, "w"), indent=2)
        print(f"\nSAVED v{v + 1} -> {TARGET}")
    else:
        print("\nNOT SAVED")
    print(f"Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
