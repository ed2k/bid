#!/usr/bin/env python3
"""Program 1: Graft Sequence-Exact Convention, Slam (RKCB 0314 / Jacoby 2NT),
and Competitive Advancer/Veto rules onto a `.dsl` system and verify via `DiffDSLNet`.
"""
import argparse
import os
import sys
from typing import List

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if os.path.join(REPO, "src") not in sys.path:
    sys.path.insert(0, os.path.join(REPO, "src"))
if os.path.join(REPO, "research") not in sys.path:
    sys.path.insert(0, os.path.join(REPO, "research"))

from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.diff_dsl_net import DiffDSLNet
from bid.eval_vs_dds import load_decision_net_dsl, parse_call


def build_program1_rules() -> List[DecisionNetRule]:
    """Construct sequence-exact convention, slam, and competitive guard rules."""
    specs = [
        # 1. Constructive 18-19 Balanced 1C Opening & Competitive Guard Rules
        (
            "P1_OPEN_1C_18_19_BAL",
            "1C",
            915,
            False,
            [
                ("is_opening", "==", True),
                ("hcp", "==", 19),
                ("is_balanced", "==", True),
                ("spade_len", "<=", 3),
                ("heart_len", "==", 4),
                ("diamond_len", "==", 3),
                ("club_len", "==", 3),
                ("controls", ">=", 6),
            ],
        ),
        (
            "P1_PASS_WEAK_OPP_SUIT_2D",
            "PASS",
            915,
            False,
            [
                ("is_opening", "==", False),
                ("partner_last_call", "==", "NONE"),
                ("opp_bid_diamonds", "==", True),
                ("d_is_longest", "==", True),
                ("last_bid_strain", "==", "D"),
                ("hcp", "<=", 7),
                ("losing_trick_count", ">=", 9),
            ],
        ),
        # 2. RKCB 0314 Responses (conv_state == 5)
        (
            "P1_RKCB_0314_5C",
            "5C",
            920,
            False,
            [("conv_state", "==", 5), ("rkcb_0314_step", "==", 1)],
        ),
        (
            "P1_RKCB_0314_5D",
            "5D",
            920,
            False,
            [("conv_state", "==", 5), ("rkcb_0314_step", "==", 2)],
        ),
        (
            "P1_RKCB_0314_5H",
            "5H",
            920,
            False,
            [("conv_state", "==", 5), ("rkcb_0314_step", "==", 3)],
        ),
        (
            "P1_RKCB_0314_5S",
            "5S",
            920,
            False,
            [("conv_state", "==", 5), ("rkcb_0314_step", "==", 4)],
        ),
        # 3. Opener Slam Placement after RKCB Response (conv_state == 6)
        (
            "P1_RKCB_PLACE_6S",
            "6S",
            920,
            False,
            [
                ("conv_state", "==", 6),
                ("effective_trump", "==", "S"),
                ("total_partnership_keycards", ">=", 4),
            ],
        ),
        (
            "P1_RKCB_PLACE_6H",
            "6H",
            920,
            False,
            [
                ("conv_state", "==", 6),
                ("effective_trump", "==", "H"),
                ("total_partnership_keycards", ">=", 4),
            ],
        ),
        (
            "P1_RKCB_PLACE_6D",
            "6D",
            920,
            False,
            [
                ("conv_state", "==", 6),
                ("effective_trump", "==", "D"),
                ("total_partnership_keycards", ">=", 4),
            ],
        ),
        (
            "P1_RKCB_PLACE_6C",
            "6C",
            920,
            False,
            [
                ("conv_state", "==", 6),
                ("effective_trump", "==", "C"),
                ("total_partnership_keycards", ">=", 4),
            ],
        ),
        (
            "P1_RKCB_STOP_5S",
            "5S",
            915,
            False,
            [
                ("conv_state", "==", 6),
                ("effective_trump", "==", "S"),
                ("total_partnership_keycards", "<=", 3),
            ],
        ),
        (
            "P1_RKCB_STOP_5H",
            "5H",
            915,
            False,
            [
                ("conv_state", "==", 6),
                ("effective_trump", "==", "H"),
                ("total_partnership_keycards", "<=", 3),
            ],
        ),
        # 4. King Ask 5NT Responses & Placement (conv_state in (7, 8))
        (
            "P1_KASK_RESP_6C",
            "6C",
            920,
            False,
            [("conv_state", "==", 7), ("outside_king_count", "==", 0)],
        ),
        (
            "P1_KASK_RESP_6D",
            "6D",
            922,
            False,
            [("conv_state", "==", 7), ("d_has_king", "==", True), ("effective_trump", "!=", "D")],
        ),
        (
            "P1_KASK_RESP_6H",
            "6H",
            921,
            False,
            [("conv_state", "==", 7), ("h_has_king", "==", True), ("effective_trump", "==", "S")],
        ),
        (
            "P1_KASK_SIGN_6S",
            "6S",
            920,
            False,
            [("conv_state", "==", 8), ("effective_trump", "==", "S")],
        ),
        (
            "P1_KASK_SIGN_6H",
            "6H",
            920,
            False,
            [("conv_state", "==", 8), ("effective_trump", "==", "H")],
        ),
        # 5. Jacoby 2NT Major Raise Continuations & RKCB Initiation (conv_state == 4)
        (
            "P1_JAC2NT_SHORT_D",
            "3D",
            910,
            False,
            [
                ("conv_state", "==", 4),
                ("my_last_call", "in", ["1H", "1S"]),
                ("diamond_len", "<=", 1),
            ],
        ),
        (
            "P1_JAC2NT_SHORT_C",
            "3C",
            910,
            False,
            [
                ("conv_state", "==", 4),
                ("my_last_call", "in", ["1H", "1S"]),
                ("club_len", "<=", 1),
                ("diamond_len", ">=", 2),
            ],
        ),
        (
            "P1_JAC2NT_SHORT_H",
            "3H",
            910,
            False,
            [
                ("conv_state", "==", 4),
                ("my_last_call", "==", "1S"),
                ("heart_len", "<=", 1),
                ("club_len", ">=", 2),
                ("diamond_len", ">=", 2),
            ],
        ),
        (
            "P1_JAC2NT_RESP_RKCB_S",
            "4NT",
            915,
            False,
            [
                ("conv_state", "==", 4),
                ("my_last_call", "==", "2NT"),
                ("effective_trump", "==", "S"),
                ("hcp", ">=", 15),
                ("rkcb_keycards", ">=", 2),
                ("losing_trick_count", "<=", 6),
            ],
        ),
        (
            "P1_JAC2NT_RESP_RKCB_H",
            "4NT",
            915,
            False,
            [
                ("conv_state", "==", 4),
                ("my_last_call", "==", "2NT"),
                ("effective_trump", "==", "H"),
                ("hcp", ">=", 15),
                ("rkcb_keycards", ">=", 2),
                ("losing_trick_count", "<=", 6),
            ],
        ),
        (
            "P1_JAC2NT_RESP_4S",
            "4S",
            910,
            False,
            [
                ("conv_state", "==", 4),
                ("my_last_call", "==", "2NT"),
                ("effective_trump", "==", "S"),
                ("hcp", "<=", 14),
            ],
        ),
        (
            "P1_JAC2NT_RESP_4H",
            "4H",
            910,
            False,
            [
                ("conv_state", "==", 4),
                ("my_last_call", "==", "2NT"),
                ("effective_trump", "==", "H"),
                ("hcp", "<=", 14),
            ],
        ),
        (
            "P1_JAC2NT_OPENER_RKCB_S",
            "4NT",
            915,
            False,
            [
                ("my_first_call", "==", "1S"),
                ("partner_first_call", "==", "2NT"),
                ("partner_last_call", "==", "4S"),
                ("hcp", ">=", 16),
                ("rkcb_keycards", ">=", 3),
                ("losing_trick_count", "<=", 5),
            ],
        ),
        (
            "P1_JAC2NT_OPENER_RKCB_H",
            "4NT",
            915,
            False,
            [
                ("my_first_call", "==", "1H"),
                ("partner_first_call", "==", "2NT"),
                ("partner_last_call", "==", "4H"),
                ("hcp", ">=", 16),
                ("rkcb_keycards", ">=", 3),
                ("losing_trick_count", "<=", 5),
            ],
        ),
        # 6. Competitive Advancer Raises & Overcaller Game Jumps (conv_state == 10)
        (
            "P1_ADV_RAISE_2S",
            "2S",
            905,
            False,
            [
                ("conv_state", "==", 10),
                ("partner_last_call", "==", "1S"),
                ("last_bid_level", "==", 2),
                ("support_in_partner_suit", ">=", 3),
                ("hcp", ">=", 8),
                ("losing_trick_count", "<=", 8),
            ],
        ),
        (
            "P1_ADV_RAISE_2H",
            "2H",
            905,
            False,
            [
                ("conv_state", "==", 10),
                ("partner_last_call", "==", "1H"),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "in", ["C", "D"]),
                ("support_in_partner_suit", ">=", 3),
                ("hcp", ">=", 8),
                ("losing_trick_count", "<=", 8),
            ],
        ),
        (
            "P1_OVERCALL_JUMP_4S",
            "4S",
            908,
            False,
            [
                ("my_last_call", "==", "1S"),
                ("partner_last_call", "==", "2S"),
                ("spade_len", ">=", 6),
                ("hcp", ">=", 14),
                ("losing_trick_count", "<=", 5),
            ],
        ),
        (
            "P1_OVERCALL_JUMP_4H",
            "4H",
            908,
            False,
            [
                ("my_last_call", "==", "1H"),
                ("partner_last_call", "==", "2H"),
                ("heart_len", ">=", 6),
                ("hcp", ">=", 14),
                ("losing_trick_count", "<=", 5),
            ],
        ),
    ]

    import gpu_arena as ga
    rules: List[DecisionNetRule] = []
    for rid, call_s, prio, is_neg, conds in specs:
        for k, _, _ in conds:
            if k not in ga.FEAT_TO_COL:
                raise KeyError(f"Unknown feature key {k!r} in rule {rid}")
        rc = [RuleCondition(k, op, val) for k, op, val in conds]
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


def build_round5_competitive_scaffolds() -> List[DecisionNetRule]:
    """Tunable competitive slam & NT-judgment scaffolds (priority 810-818).

    Placed below the 900-lock so Colab GPU Stage 2 (STE gradient threshold search)
    and Stage 3 (partner-belief splits) can refine their HCP/LTC/control boundaries,
    while Stage 1 protects their calls (>= 800) from premature ablation.
    """
    specs = [
        # 1. Power Double over opponent's weak-2/3 preempt (too strong for non-forcing overcall)
        (
            "R5_POWER_X_OVER_PREEMPT",
            "X",
            815,
            False,
            [
                ("is_power_double_hand", "==", True),
                ("partner_last_call", "in", ["NONE", "PASS"]),
            ],
        ),
        # 2. Positive major-suit response to partner's takeout X of weak-2
        (
            "R5_POS_3S_OVER_2DH_X",
            "3S",
            815,
            False,
            [
                ("opp_preempted", "==", True),
                ("partner_last_call", "==", "X"),
                ("my_last_call", "in", ["NONE", "PASS"]),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "in", ["D", "H"]),
                ("spade_len", ">=", 5),
                ("hcp", ">=", 8),
                ("losing_trick_count", "<=", 8),
            ],
        ),
        (
            "R5_POS_3H_OVER_2DS_X",
            "3H",
            815,
            False,
            [
                ("opp_preempted", "==", True),
                ("partner_last_call", "==", "X"),
                ("my_last_call", "in", ["NONE", "PASS"]),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "in", ["D", "S"]),
                ("heart_len", ">=", 5),
                ("spade_len", "<=", 4),
                ("hcp", ">=", 8),
                ("losing_trick_count", "<=", 8),
            ],
        ),
        # 3. Power doubler initiates RKCB 4NT after partner's positive major jump/response
        (
            "R5_POWER_X_RKCB_S",
            "4NT",
            818,
            False,
            [
                ("opp_preempted", "==", True),
                ("my_last_call", "==", "X"),
                ("partner_last_call", "in", ["3S", "4S"]),
                ("support_in_partner_suit", ">=", 3),
                ("hcp", ">=", 18),
                ("controls", ">=", 5),
                ("losing_trick_count", "<=", 5),
            ],
        ),
        (
            "R5_POWER_X_RKCB_H",
            "4NT",
            818,
            False,
            [
                ("opp_preempted", "==", True),
                ("my_last_call", "==", "X"),
                ("partner_last_call", "in", ["3H", "4H"]),
                ("support_in_partner_suit", ">=", 3),
                ("hcp", ">=", 18),
                ("controls", ">=", 5),
                ("losing_trick_count", "<=", 5),
            ],
        ),
        # 4. Unusual 2NT two-suited overcall (5-5 in two lowest unbid suits, low LTC) + advancer preference
        (
            "R5_UNUSUAL_2NT_OVERCALL",
            "2NT",
            812,
            False,
            [
                ("is_unusual_2nt_shape", "==", True),
                ("partner_last_call", "in", ["NONE", "PASS"]),
                ("last_bid_level", "==", 1),
                ("hcp", ">=", 7),
                ("hcp", "<=", 12),
                ("losing_trick_count", "<=", 6),
            ],
        ),
        (
            "R5_ADV_PREF_3H_OVER_U2NT",
            "3H",
            814,
            False,
            [
                ("opponents_bid", "==", True),
                ("partner_last_call", "==", "2NT"),
                ("my_last_call", "in", ["NONE", "PASS"]),
                ("opening_bid", "in", ["1C", "1D"]),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "==", "NT"),
                ("heart_len", ">=", 3),
            ],
        ),
        (
            "R5_ADV_PREF_3C_OVER_U2NT",
            "3C",
            813,
            False,
            [
                ("opponents_bid", "==", True),
                ("partner_last_call", "==", "2NT"),
                ("my_last_call", "in", ["NONE", "PASS"]),
                ("opening_bid", "in", ["1D", "1H", "1S"]),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "==", "NT"),
                ("club_len", ">=", 3),
            ],
        ),
        (
            "R5_ADV_PREF_3D_OVER_U2NT",
            "3D",
            812,
            False,
            [
                ("opponents_bid", "==", True),
                ("partner_last_call", "==", "2NT"),
                ("my_last_call", "in", ["NONE", "PASS"]),
                ("opening_bid", "in", ["1C", "1H", "1S"]),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "==", "NT"),
                ("diamond_len", ">=", 3),
            ],
        ),
        # 5. Competitive balancing takeout X over 1D - PASS - 2D with both majors & short diamonds
        (
            "R5_BALANCE_X_OVER_1D_2D",
            "X",
            814,
            False,
            [
                ("opponents_bid", "==", True),
                ("opening_bid", "==", "1D"),
                ("opp_last_call", "==", "2D"),
                ("last_bid_level", "==", 2),
                ("last_bid_strain", "==", "D"),
                ("my_last_call", "in", ["NONE", "PASS"]),
                ("partner_last_call", "in", ["NONE", "PASS"]),
                ("diamond_len", "<=", 2),
                ("heart_len", ">=", 4),
                ("spade_len", ">=", 4),
                ("hcp", ">=", 10),
            ],
        ),
    ]

    import gpu_arena as ga
    rules: List[DecisionNetRule] = []
    for rid, call_s, prio, is_neg, conds in specs:
        for k, _, _ in conds:
            if k not in ga.FEAT_TO_COL:
                raise KeyError(f"Unknown feature key {k!r} in rule {rid}")
        rc = [RuleCondition(k, op, val) for k, op, val in conds]
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


def graft_rules_onto_dsl(in_dsl: str, out_dsl: str) -> DecisionNet:
    net = load_decision_net_dsl(in_dsl)
    existing_ids = {r.rule_id for r in net.rules}
    added = 0
    for r in build_program1_rules():
        if r.rule_id not in existing_ids:
            net.rules.append(r)
            added += 1
    diff_net = DiffDSLNet(net)
    diff_net.export_dsl(out_dsl)
    print(f"Grafted {added} Program-1 rules onto {in_dsl} -> {out_dsl} (total rules: {len(net.rules)})")
    return net


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--in-dsl", default="system/brill_jps_diff.dsl")
    ap.add_argument("--out-dsl", default="system/brill_jps_p1.dsl")
    args = ap.parse_args()
    graft_rules_onto_dsl(args.in_dsl, args.out_dsl)
