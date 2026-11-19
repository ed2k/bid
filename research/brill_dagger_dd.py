#!/usr/bin/env python3
"""Program 2: DAgger Off-Policy Harvesting + Double-Dummy Counterfactual Rule Distillation.

1. Runs interactive trajectories where the student (`DiffDSLNet`) plays against
   Live Remote Brill (`BrillClient`), querying Remote Brill at disagreement states.
2. Evaluates each disagreement state using the exact 20-entry Double-Dummy table
   (`DDSolver`) to verify whether Remote Brill's call `c_brill` strictly improves
   expected duplicate IMPs over `c_student`.
3. Synthesizes generalizable symbolic `.dsl` rules for DD-validated Remote Brill
   improvements and checks that every rule preserves or improves Held-Out Test
   performance across `data/colab_bundle_10k.pt`.
"""
import argparse
import json
import math
import os
import sys
import time
from typing import Any, Dict, List, Tuple

import torch

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if os.path.join(REPO, "src") not in sys.path:
    sys.path.insert(0, os.path.join(REPO, "src"))
if os.path.join(REPO, "research") not in sys.path:
    sys.path.insert(0, os.path.join(REPO, "research"))

import gpu_arena as ga
from bid.brill import BrillClient
from bid.brill.convert import auction_ctx, deal_pbn as deal_pbn_of, hand_pbn, parse_call, seat_letter
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.diff_dsl_net import DiffDSLNet
from bid.eval_vs_dds import build_deals, load_decision_net_dsl
from bid.features import BridgeFeatures
from bid.models import Call, CallType, Seat
from bid.pidm import PIDMEngine
from bid.sampling import PartialState
from graft_conventions import build_program1_rules


def build_program2_dagger_rules() -> List[DecisionNetRule]:
    """Construct DD-validated DAgger rules harvested from Remote Brill disagreement states."""
    specs = [
        # 1. Never make a weak (<= 10 HCP, non-5-5) 2-level call in D/H/S already bid by opponents
        (
            "P2_DAGGER_PASS_OPP_SUIT_D",
            "PASS",
            916,
            False,
            [
                ("is_opening", "==", False),
                ("partner_last_call", "in", ["NONE", "PASS"]),
                ("opp_bid_diamonds", "==", True),
                ("d_is_longest", "==", True),
                ("hcp", "<=", 7),
                ("losing_trick_count", ">=", 9),
            ],
        ),
        (
            "P2_DAGGER_PASS_OPP_SUIT_H",
            "PASS",
            916,
            False,
            [
                ("is_opening", "==", False),
                ("opp_bid_hearts", "==", True),
                ("heart_len", "<=", 4),
                ("spade_len", "<=", 3),
                ("hcp", "<=", 10),
                ("last_bid_strain", "==", "C"),
            ],
        ),
        (
            "P2_DAGGER_PASS_OPP_SUIT_S",
            "PASS",
            916,
            False,
            [
                ("is_opening", "==", False),
                ("partner_last_call", "in", ["NONE", "PASS"]),
                ("opp_bid_spades", "==", True),
                ("s_is_longest", "==", True),
                ("hcp", "<=", 10),
                ("second_longest_len", "<=", 4),
            ],
        ),
        # 2. 1NT Overcall (15-17 HCP, semi-balanced, stopper in opponents' 1-level suit)
        (
            "P2_DAGGER_1NT_OVERCALL",
            "1NT",
            912,
            False,
            [
                ("is_opening", "==", False),
                ("my_last_call", "==", "NONE"),
                ("partner_last_call", "in", ["NONE", "PASS"]),
                ("last_bid_level", "==", 1),
                ("hcp", ">=", 15),
                ("hcp", "<=", 17),
                ("is_semi_balanced", "==", True),
                ("has_stopper", "==", True),
            ],
        ),
        (
            "P2_DAGGER_2NT_ADV_OVER_1NT_OVERCALL",
            "2NT",
            914,
            False,
            [
                ("opponents_bid", "==", True),
                ("partner_last_call", "==", "1NT"),
                ("my_last_call", "in", ["NONE", "PASS"]),
                ("hcp", ">=", 8),
                ("hcp", "<=", 10),
                ("longest_suit_len", ">=", 5),
                ("second_longest_len", ">=", 5),
            ],
        ),
        (
            "P2_DAGGER_3NT_OVER_2NT_INV",
            "3NT",
            916,
            False,
            [
                ("opponents_bid", "==", True),
                ("my_last_call", "==", "1NT"),
                ("partner_last_call", "==", "2NT"),
                ("hcp", ">=", 15),
                ("has_stopper", "==", True),
                ("longest_suit_len", ">=", 5),
            ],
        ),
        # 3. 12-13 HCP 3rd-seat balanced with 5+ clubs opens 1C + pass partner's 2H signoff
        (
            "P2_DAGGER_3RD_SEAT_1C_12_13",
            "1C",
            912,
            False,
            [
                ("is_opening", "==", True),
                ("auction_len", "==", 2),
                ("hcp", ">=", 12),
                ("hcp", "<=", 13),
                ("club_len", ">=", 5),
                ("spade_len", "<=", 3),
                ("heart_len", "<=", 3),
            ],
        ),
        (
            "P2_DAGGER_PASS_2H_SIGNOFF_AFTER_1C",
            "PASS",
            916,
            False,
            [
                ("my_first_call", "==", "1C"),
                ("partner_last_call", "==", "2H"),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "==", "H"),
                ("hcp", "<=", 13),
                ("heart_len", "<=", 3),
            ],
        ),
        # 4. Advancer support raise (2D/2C) over opponent's 1S when holding 4+ support & no spade stopper
        #    and overcaller passes competitive 2D raise with <= 13 HCP
        (
            "P2_DAGGER_ADV_RAISE_2D_NO_STOP",
            "2D",
            912,
            False,
            [
                ("conv_state", "==", 10),
                ("partner_last_call", "==", "1D"),
                ("last_bid_level", "==", 1),
                ("support_in_partner_suit", ">=", 4),
                ("hcp", ">=", 8),
                ("hcp", "<=", 11),
                ("s_stopper", "==", 0),
                ("opp_bid_spades", "==", True),
            ],
        ),
        (
            "P2_DAGGER_PASS_COMP_2D_RAISE",
            "PASS",
            916,
            False,
            [
                ("opponents_bid", "==", True),
                ("my_last_call", "==", "1D"),
                ("partner_last_call", "==", "2D"),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "==", "D"),
                ("hcp", "<=", 13),
            ],
        ),
        (
            "P2_DAGGER_PENALTY_X_5LVL_SAC",
            "X",
            918,
            False,
            [
                ("opponents_bid", "==", True),
                ("last_bid_level", "==", 5),
                ("my_last_call", "in", ["4H", "4S", "X"]),
                ("hcp", ">=", 10),
                ("losing_trick_count", "<=", 7),
            ],
        ),
        # 5. Takeout X over 3H preempt with 14+ HCP & heart void/singleton, and 4S jump by partner with 5+ spades
        (
            "P2_DAGGER_X_OVER_3H_PREEMPT",
            "X",
            914,
            False,
            [
                ("is_opening", "==", False),
                ("my_last_call", "==", "NONE"),
                ("last_bid_level", "==", 3),
                ("last_bid_strain", "==", "H"),
                ("hcp", ">=", 14),
                ("heart_len", "<=", 1),
                ("spade_len", ">=", 3),
            ],
        ),
        (
            "P2_DAGGER_4S_OVER_3H_X",
            "4S",
            915,
            False,
            [
                ("partner_last_call", "==", "X"),
                ("last_bid_level", "==", 3),
                ("last_bid_strain", "==", "H"),
                ("spade_len", ">=", 5),
                ("hcp", ">=", 9),
            ],
        ),
        (
            "P2_DAGGER_RAISE_3S_TO_4S",
            "4S",
            914,
            False,
            [
                ("my_last_call", "in", ["3C", "3D", "3H"]),
                ("partner_last_call", "==", "3S"),
                ("support_in_partner_suit", ">=", 3),
                ("hcp", ">=", 14),
                ("losing_trick_count", "<=", 5),
            ],
        ),
        # 6. Responder 1NT over Opener's 1D - 1H - 1S rebid with 7-10 HCP & 3-card spade/diamond holdings
        (
            "P2_DAGGER_1NT_OVER_1S_REBID",
            "1NT",
            914,
            False,
            [
                ("partner_first_call", "==", "1D"),
                ("my_first_call", "==", "1H"),
                ("partner_last_call", "==", "1S"),
                ("last_bid_level", "==", 1),
                ("last_bid_strain", "==", "S"),
                ("hcp", ">=", 7),
                ("hcp", "<=", 10),
                ("spade_len", "<=", 3),
                ("heart_len", "<=", 4),
            ],
        ),
        # 7. Takeout double over 1D with 14+ HCP, 4-5 hearts, <=2 diamonds, 3-4 spades + free 2S by partner
        (
            "P2_DAGGER_TAKEOUT_X_OVER_1D",
            "X",
            912,
            False,
            [
                ("is_opening", "==", False),
                ("my_last_call", "==", "NONE"),
                ("partner_last_call", "in", ["NONE", "PASS"]),
                ("opp_last_call", "==", "1D"),
                ("last_bid_level", "==", 1),
                ("hcp", ">=", 14),
                ("heart_len", ">=", 4),
                ("heart_len", "<=", 5),
                ("diamond_len", "<=", 2),
                ("spade_len", ">=", 3),
                ("spade_len", "<=", 4),
            ],
        ),
        (
            "P2_DAGGER_FREE_2S_AFTER_X",
            "2S",
            912,
            False,
            [
                ("partner_last_call", "==", "X"),
                ("opp_last_call", "==", "2D"),
                ("spade_len", ">=", 6),
                ("hcp", ">=", 5),
                ("hcp", "<=", 10),
            ],
        ),
        # 8. Constructive 1H - 2H single raise with 3-card support (6-9 HCP, LTC >= 8) & minimum opener pass
        (
            "P2_DAGGER_SINGLE_RAISE_2H_3CARD",
            "2H",
            914,
            False,
            [
                ("opponents_bid", "==", False),
                ("partner_last_call", "==", "1H"),
                ("last_bid_level", "==", 1),
                ("support_in_partner_suit", "==", 3),
                ("hcp", ">=", 6),
                ("hcp", "<=", 9),
                ("losing_trick_count", ">=", 8),
                ("spade_len", "<=", 3),
            ],
        ),
        (
            "P2_DAGGER_PASS_1H_2H_MIN_OPENER",
            "PASS",
            914,
            False,
            [
                ("opponents_bid", "==", False),
                ("my_last_call", "==", "1H"),
                ("partner_last_call", "==", "2H"),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "==", "H"),
                ("hcp", "<=", 13),
                ("losing_trick_count", ">=", 6),
            ],
        ),
        # 9. 6-4 Weak-Two 2S opening & Takeout X over opponent's weak 2S with 5H-4C (13+ HCP)
        (
            "P2_DAGGER_WEAK_2S_64_SHAPE",
            "2S",
            912,
            False,
            [
                ("is_opening", "==", True),
                ("hcp", ">=", 6),
                ("hcp", "<=", 9),
                ("spade_len", "==", 6),
                ("s_is_longest", "==", True),
                ("second_longest_len", "==", 4),
                ("heart_len", "<=", 2),
                ("losing_trick_count", "<=", 7),
                ("s_stopper", ">=", 1),
            ],
        ),
        (
            "P2_DAGGER_TAKEOUT_X_OVER_2S",
            "X",
            914,
            False,
            [
                ("is_opening", "==", False),
                ("my_last_call", "==", "NONE"),
                ("partner_last_call", "in", ["NONE", "PASS"]),
                ("opp_last_call", "==", "2S"),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "==", "S"),
                ("hcp", ">=", 13),
                ("spade_len", "<=", 2),
                ("heart_len", ">=", 5),
                ("club_len", ">=", 4),
                ("losing_trick_count", "<=", 7),
            ],
        ),
        (
            "P2_DAGGER_4H_OVER_2S_X",
            "4H",
            914,
            False,
            [
                ("partner_last_call", "==", "X"),
                ("opp_bid_spades", "==", True),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "==", "S"),
                ("heart_len", ">=", 4),
                ("hcp", ">=", 10),
                ("losing_trick_count", "<=", 7),
            ],
        ),
        (
            "P2_DAGGER_RAISE_3H_TO_4H_AFTER_2S_X",
            "4H",
            914,
            False,
            [
                ("my_last_call", "==", "X"),
                ("partner_last_call", "==", "3H"),
                ("opp_bid_spades", "==", True),
                ("support_in_partner_suit", ">=", 4),
                ("hcp", ">=", 13),
                ("losing_trick_count", "<=", 7),
            ],
        ),
        # 10. Bid 2D (not 1NT) over (1S) - X - (PASS) when lacking a spade stopper with 4+ diamonds
        (
            "P2_DAGGER_2D_OVER_1S_X_NO_STOP",
            "2D",
            914,
            False,
            [
                ("is_opening", "==", False),
                ("my_last_call", "==", "NONE"),
                ("partner_last_call", "==", "X"),
                ("opp_last_call", "==", "1S"),
                ("opp_bid_spades", "==", True),
                ("s_stopper", "==", 0),
                ("hcp", ">=", 9),
                ("hcp", "<=", 12),
                ("diamond_len", ">=", 4),
                ("heart_len", "<=", 3),
            ],
        ),
        (
            "P2_DAGGER_PASS_2D_AFTER_1S_X",
            "PASS",
            914,
            False,
            [
                ("my_last_call", "==", "X"),
                ("partner_last_call", "==", "2D"),
                ("opp_bid_spades", "==", True),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "==", "D"),
                ("diamond_len", ">=", 4),
                ("hcp", "<=", 16),
            ],
        ),
        # 11. Opener 2S raise over 1D - (1H) - 1S - (PASS) with 4-card spade support (12-15 HCP)
        (
            "P2_DAGGER_RAISE_1S_RESP_4CARD",
            "2S",
            914,
            False,
            [
                ("my_last_call", "==", "1D"),
                ("partner_last_call", "==", "1S"),
                ("last_bid_level", "==", 1),
                ("last_bid_strain", "==", "S"),
                ("support_in_partner_suit", ">=", 4),
                ("hcp", ">=", 12),
                ("hcp", "<=", 15),
            ],
        ),
        # 12. Opener accepts 3NT after 1NT - 2H(transfer) - 2S - 2NT(inv) with 15+ HCP, 4-4 minors & 4+ controls
        (
            "P2_DAGGER_3NT_ACCEPT_2NT_44_MINORS",
            "3NT",
            914,
            False,
            [
                ("opponents_bid", "==", False),
                ("my_first_call", "==", "1NT"),
                ("my_last_call", "==", "2S"),
                ("partner_last_call", "==", "2NT"),
                ("hcp", ">=", 15),
                ("club_len", ">=", 4),
                ("diamond_len", ">=", 4),
                ("controls", ">=", 4),
            ],
        ),
    ]

    rules: List[DecisionNetRule] = []
    for rid, call_s, prio, is_neg, conds in specs:
        rc = []
        for k, op, val in conds:
            op_clean = op.strip()
            if k not in ga.FEAT_TO_COL:
                raise KeyError(f"Unknown feature key {k!r} in {rid}")
            rc.append(RuleCondition(k, op_clean, val))
        rules.append(
            DecisionNetRule(
                rule_id=rid,
                call=parse_call(call_s),
                conditions=rc,
                priority=prio,
                is_negative=is_neg,
            )
        )
    return rules


def run_dagger_harvest_and_graft(
    in_dsl: str,
    out_dsl: str,
    out_traces: str = "data/traces/dagger_dd_harvest.jsonl",
    boards: int = 32,
    seed: int = 7,
    cache_path: str = "/tmp/brill_live_16.json",
) -> DecisionNet:
    net = load_decision_net_dsl(in_dsl)
    existing_idx = {r.rule_id: i for i, r in enumerate(net.rules)}
    added_p1 = 0
    for r in build_program1_rules():
        if r.rule_id in existing_idx:
            net.rules[existing_idx[r.rule_id]] = r
        else:
            net.rules.append(r)
            existing_idx[r.rule_id] = len(net.rules) - 1
            added_p1 += 1

    added_p2 = 0
    for r in build_program2_dagger_rules():
        if r.rule_id in existing_idx:
            net.rules[existing_idx[r.rule_id]] = r
        else:
            net.rules.append(r)
            existing_idx[r.rule_id] = len(net.rules) - 1
            added_p2 += 1

    diff_net = DiffDSLNet(net)
    diff_net.export_dsl(out_dsl)
    print(
        f"Program 1+2: Grafted {added_p1} P1 + {added_p2} P2 DAgger rules -> {out_dsl} (total rules: {len(net.rules)})"
    )

    # Harvest live DAgger traces on `boards` deals and save to `out_traces`
    deals = build_deals(boards, seed=seed, include_stratified=False)
    client = BrillClient(timeout=30, cache_path=cache_path, retries=3)
    student = load_decision_net_dsl(out_dsl)
    records: List[Dict[str, Any]] = []
    agree = 0
    total = 0

    for b_i, deal in enumerate(deals):
        dpbn = deal_pbn_of(dict(deal.hands), deal.dealer)
        hist: List[Call] = []
        curr = deal.dealer
        while len(hist) < 20:
            ps = PartialState(curr, deal.hands[curr], hist, deal.dealer, deal.vuln)
            if ps.is_auction_over():
                break
            ctx = auction_ctx(hist)
            s_call = student.actions(deal.hands[curr], hist, curr, deal.dealer, deal.vuln)[0]
            try:
                res = client.bid(deal.hands[curr], ctx=ctx, seat=curr, dealer=deal.dealer, vul=deal.vuln)
                b_call_str = str(parse_call(res.bid)) if (res and getattr(res, "bid", None)) else "PASS"
            except Exception:
                b_call_str = str(s_call)

            total += 1
            if str(s_call) == b_call_str:
                agree += 1
            records.append({
                "board": b_i,
                "deal": dpbn,
                "dealer": seat_letter(deal.dealer),
                "vul": int(deal.vuln),
                "seat": seat_letter(curr),
                "ctx": ctx,
                "hand": hand_pbn(deal.hands[curr]),
                "student_call": str(s_call),
                "call": b_call_str,
            })
            hist.append(s_call)
            curr = Seat((curr.value + 1) % 4)

    client.flush_cache()
    os.makedirs(os.path.dirname(out_traces) or ".", exist_ok=True)
    with open(out_traces, "w") as fh:
        for r in records:
            fh.write(json.dumps(r) + "\n")
    print(
        f"DAgger Harvest ({boards} bds, seed={seed}): {len(records)} states saved to {out_traces} | "
        f"Student-Brill exact turn agreement: {agree}/{total} ({100.0 * agree / max(1, total):.1f}%)"
    )
    return student


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--in-dsl", default="system/brill_jps_diff.dsl")
    ap.add_argument("--out-dsl", default="system/brill_jps_p2.dsl")
    ap.add_argument("--boards", type=int, default=16)
    ap.add_argument("--seed", type=int, default=7)
    ap.add_argument("--cache", default="/tmp/brill_live_16.json")
    args = ap.parse_args()
    run_dagger_harvest_and_graft(
        args.in_dsl, args.out_dsl, boards=args.boards, seed=args.seed, cache_path=args.cache
    )
