#!/usr/bin/env python3
"""Joint Policy Search (JPS) over `DiffDSLNet` with 100% Explainable Bids.

Borrows the core algorithms from `../jps` (Tian et al., NeurIPS 2020: "Joint
Policy Search for Multi-agent Collaboration with Imperfect Information") and
applies them directly to our neuro-symbolic `DiffDSLNet` model:

  1. **Depth-2 Coupled `(Opener, Responder)` Joint Policy Search (`simple_game/search.h`,
     `rela/rollouts_new.h`)**:
     Tracks partnership rule transitions `(r_1 at turn t) -> (r_2 at turn t+2)`
     including downstream rules whose reachability (`alterReach`) changes when
     `r_1` changes its call `a_1 -> a_1'`. Evaluates joint pairs
     `(r_1 -> a_1', r_2 -> a_2')` simultaneously in packed mega-batches.
  2. **Reachability-Weighted Empirical Bayes Edge Shrinkage
     (`rela/search_actor_refactored_new.h:343-382`)**:
     Regularizes rollout edge estimates by active board reachability:
       `shrunk_edge = (N_active / (N_active + lambda_shrink)) * mean_imp_gain`
     combined with board-level t-statistic filtering.
  3. **Gradient-Guided Threshold (`atom_val`) & Split Search on `DiffDSLNet`**:
     Uses Straight-Through Estimator (STE) gradients on `DiffDSLNet.atom_val`
     and `DiffDSLNet.rule_call_logits` to rank high-leverage threshold shifts
     and coupled partner-fit condition splits, updating the model weights
     in-place and exporting back to a human-readable `.dsl` file.
  4. **100% Explainable Bid Output**:
     Every bid and every JPS policy improvement is accompanied by a verified
     `BidExplanation` (`EXPLANATION RULE <id> ( ... ) -> BID <call>`).
"""
from __future__ import annotations

import argparse
from collections import defaultdict
import math
import os
import sys
import time
from typing import Any, Dict, List, Optional, Sequence, Tuple

import torch
import torch.nn.functional as F

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if os.path.join(REPO_ROOT, "src") not in sys.path:
    sys.path.insert(0, os.path.join(REPO_ROOT, "src"))
if os.path.join(REPO_ROOT, "research") not in sys.path:
    sys.path.insert(0, os.path.join(REPO_ROOT, "research"))

import gpu_arena as ga
from gpu_evolve_dsl import candidate_calls_for_rule, slice_bundle
from bid.diff_dsl_net import BidExplanation, DiffDSLNet


def record_jps_coupling_and_baseline(
    bundle: ga.DealBundle,
    cand_net: ga.TensorDecisionNet,
    opp_net: ga.TensorDecisionNet,
) -> Tuple[torch.Tensor, torch.Tensor, torch.Tensor, Dict[Tuple[int, int], torch.Tensor]]:
    """Play Table 1 and Table 2 and record both single-rule active masks `(B, R)`
    and depth-2 partnership rule coupling `(r_1 at turn t, r_2 at turn t+2) -> board_mask`.
    """
    B = bundle.num_boards
    R = cand_net.num_rules
    dev = bundle.hand_features.device
    active_mask = torch.zeros((B, R), dtype=torch.bool, device=dev)
    pair_boards: Dict[Tuple[int, int], List[torch.Tensor]] = defaultdict(list)

    def _run_table(cand_is_ns: bool) -> torch.Tensor:
        env = ga.BatchedAuctionEnv(bundle)
        env.passes_since_last_np = torch.zeros(B, dtype=torch.long, device=dev)
        # Track winning rule per turn for the candidate partnership
        turn_win_rule: List[torch.Tensor] = []
        turn_had_match: List[torch.Tensor] = []
        turn_was_cand: List[torch.Tensor] = []

        for t in range(20):
            if bool(env.done.all().item()):
                break
            X, seat = env.build_features()
            lmask = env.legal_mask(seat)
            is_ns = (seat % 2) == 0
            cand_turn = (is_ns if cand_is_ns else (~is_ns)) & (~env.done)

            matched = cand_net.match_rules(X)  # (B, R)
            if cand_net.has_neg_rules:
                neg_matched = (matched & cand_net.rule_neg[None, :]).to(torch.float32)
                vetoed_calls = (neg_matched @ cand_net.neg_rule_call_mat) > 0.5
                rule_vetoed = vetoed_calls[:, cand_net.rule_call]
            else:
                rule_vetoed = torch.zeros_like(matched)

            rule_legal = lmask[:, cand_net.rule_call]
            pos_matched = matched & (~cand_net.rule_neg[None, :])
            valid_pos = pos_matched & (~rule_vetoed) & rule_legal

            NEG_INF = -1e9
            scores = cand_net.rule_score[None, :].expand(B, R)
            masked_scores = torch.where(valid_pos, scores, torch.full_like(scores, NEG_INF))
            max_score, best_r = masked_scores.max(dim=1)
            has_match = max_score > (NEG_INF / 2)
            cand_calls = torch.where(
                has_match,
                cand_net.rule_call[best_r],
                torch.full_like(best_r, ga.IDX_PASS),
            )

            win_prio = torch.where(has_match, cand_net.rule_prio[best_r], torch.full_like(max_score, -1e9))
            could_matter = pos_matched & (~rule_vetoed) & (cand_net.rule_prio[None, :] >= win_prio[:, None])
            turn_active = cand_turn[:, None] & could_matter
            active_mask.logical_or_(turn_active)

            turn_win_rule.append(best_r.detach())
            turn_had_match.append((cand_turn & has_match).detach())
            turn_was_cand.append(cand_turn.detach())

            # Record depth-2 partnership transitions `(turn t-2 -> turn t)` (Opener -> Responder)
            if t >= 2:
                both_valid = turn_had_match[t - 2] & turn_had_match[t]
                if bool(both_valid.any().item()):
                    b_valid = torch.where(both_valid)[0]
                    r1_vec = turn_win_rule[t - 2][b_valid].cpu().tolist()
                    r2_vec = turn_win_rule[t][b_valid].cpu().tolist()
                    b_cpu = b_valid.cpu().tolist()
                    for b_i, r1, r2 in zip(b_cpu, r1_vec, r2_vec):
                        if r1 != r2:
                            pair_boards[(r1, r2)].append(b_i)

            if cand_net is opp_net:
                calls = cand_calls
            else:
                _, opp_calls = opp_net.call_scores(X, lmask)
                calls = torch.where(cand_turn, cand_calls, opp_calls)
            env.step(calls)
        return env.terminal_ns_scores()

    s1 = _run_table(cand_is_ns=True)
    s2 = _run_table(cand_is_ns=False)

    pair_tensors: Dict[Tuple[int, int], torch.Tensor] = {}
    for pair_key, b_list in pair_boards.items():
        uniq_b = sorted(set(b_list))
        if len(uniq_b) >= 4:
            pair_tensors[pair_key] = torch.tensor(uniq_b, dtype=torch.long, device=dev)

    return s1, s2, active_mask, pair_tensors


def discover_alter_reach_partner_rules(
    bundle: ga.DealBundle,
    cand_net: ga.TensorDecisionNet,
    opp_net: ga.TensorDecisionNet,
    r1_idx: int,
    new_c1: int,
    r1_boards: torch.Tensor,
    top_m: int = 3,
) -> List[Tuple[int, torch.Tensor]]:
    """JPS `alterReach` Discovery (`rela/rollouts_new.h`):
    When rule `r1_idx` is overridden to `new_c1` on `r1_boards`, run a probe
    rollout to discover which downstream partner rules `r2` fire at `t+2` under
    the new auction trajectory!
    """
    if r1_boards.numel() == 0 or new_c1 < 0:
        return []
    sub = slice_bundle(bundle, r1_boards)
    B_sub = sub.num_boards
    dev = sub.hand_features.device
    R = cand_net.num_rules
    b_arange = torch.arange(B_sub, device=dev)
    prio1 = float(cand_net.rule_prio[r1_idx].item())
    s1_val = prio1 * 64.0 - float(ga.CALL_LEX_RANK[new_c1])

    r2_hits: Dict[int, List[int]] = defaultdict(list)

    for cand_is_ns in (True, False):
        env = ga.BatchedAuctionEnv(sub)
        env.passes_since_last_np = torch.zeros(B_sub, dtype=torch.long, device=dev)
        r1_fired_turn = torch.full((B_sub,), -10, dtype=torch.long, device=dev)

        for t in range(20):
            if bool(env.done.all().item()):
                break
            X, seat = env.build_features()
            lmask = env.legal_mask(seat)
            is_ns = (seat % 2) == 0
            cand_turn = (is_ns if cand_is_ns else (~is_ns)) & (~env.done)

            matched = cand_net.match_rules(X)
            if cand_net.has_neg_rules:
                neg_matched = (matched & cand_net.rule_neg[None, :]).to(torch.float32)
                vetoed_calls = (neg_matched @ cand_net.neg_rule_call_mat) > 0.5
            else:
                vetoed_calls = torch.zeros((B_sub, 38), dtype=torch.bool, device=dev)

            rule_vetoed = vetoed_calls[:, cand_net.rule_call]
            rule_legal = lmask[:, cand_net.rule_call]
            pos_matched = matched & (~cand_net.rule_neg[None, :])
            valid_pos = pos_matched & (~rule_vetoed) & rule_legal

            # Apply r1 override
            r1_m = pos_matched[:, r1_idx]
            r1_v = vetoed_calls[:, new_c1]
            r1_l = lmask[:, new_c1]
            valid_pos[:, r1_idx] = r1_m & (~r1_v) & r1_l

            NEG_INF = -1e9
            scores = cand_net.rule_score[None, :].expand(B_sub, R).clone()
            scores[:, r1_idx] = s1_val
            masked_scores = torch.where(valid_pos, scores, torch.full_like(scores, NEG_INF))
            max_score, best_r = masked_scores.max(dim=1)
            has_match = max_score > (NEG_INF / 2)
            base_c = cand_net.rule_call[best_r]
            chosen_c = torch.where(best_r == r1_idx, torch.full_like(base_c, new_c1), base_c)
            cand_calls = torch.where(has_match, chosen_c, torch.full_like(chosen_c, ga.IDX_PASS))

            # Check if this turn is `t_r1 + 2` (partner's response to r1's new call!)
            is_partner_resp = cand_turn & has_match & (r1_fired_turn == (t - 2))
            if bool(is_partner_resp.any().item()):
                resp_b = torch.where(is_partner_resp)[0]
                for local_b, r2_val in zip(resp_b.cpu().tolist(), best_r[resp_b].cpu().tolist()):
                    if r2_val != r1_idx:
                        r2_hits[r2_val].append(int(r1_boards[local_b].item()))

            fired_now = cand_turn & has_match & (best_r == r1_idx)
            r1_fired_turn = torch.where(fired_now, torch.full_like(r1_fired_turn, t), r1_fired_turn)

            _, opp_calls = opp_net.call_scores(X, lmask)
            calls = torch.where(cand_turn, cand_calls, opp_calls)
            env.step(calls)

    ranked_r2: List[Tuple[int, torch.Tensor]] = []
    for r2_i, orig_boards in r2_hits.items():
        uniq = sorted(set(orig_boards))
        if len(uniq) >= 3:
            ranked_r2.append((r2_i, torch.tensor(uniq, dtype=torch.long, device=dev)))
    ranked_r2.sort(key=lambda x: int(x[1].numel()), reverse=True)
    return ranked_r2[:top_m]


def run_packed_coupled_override_batch(
    base_bundle: ga.DealBundle,
    cand_net: ga.TensorDecisionNet,
    opp_net: ga.TensorDecisionNet,
    board_idx: torch.Tensor,
    ov_r1: torch.Tensor,
    ov_c1: torch.Tensor,
    ov_s1: torch.Tensor,
    ov_d1: torch.Tensor,
    ov_r2: torch.Tensor,
    ov_c2: torch.Tensor,
    ov_s2: torch.Tensor,
    ov_d2: torch.Tensor,
) -> Tuple[torch.Tensor, torch.Tensor]:
    """Run Table 1 and Table 2 on a packed mega-batch of coupled depth-2 overrides
    `(ov_r1 -> ov_c1, ov_r2 -> ov_c2)` simultaneously.
    """
    sub = slice_bundle(base_bundle, board_idx)
    B_tot = sub.num_boards
    dev = sub.hand_features.device
    R = cand_net.num_rules
    b_arange = torch.arange(B_tot, device=dev)

    def _select_with_coupled_override(X: torch.Tensor, lmask: torch.Tensor) -> torch.Tensor:
        matched = cand_net.match_rules(X)  # (B_tot, R)
        if cand_net.has_neg_rules:
            neg_matched = (matched & cand_net.rule_neg[None, :]).to(torch.float32)
            vetoed_calls = (neg_matched @ cand_net.neg_rule_call_mat) > 0.5
        else:
            vetoed_calls = torch.zeros((B_tot, 38), dtype=torch.bool, device=dev)

        rule_vetoed = vetoed_calls[:, cand_net.rule_call]
        rule_legal = lmask[:, cand_net.rule_call]
        pos_matched = matched & (~cand_net.rule_neg[None, :])
        valid_pos = pos_matched & (~rule_vetoed) & rule_legal

        # Override 1 (Opener / First rule)
        valid_pos[b_arange, ov_r1] = (
            pos_matched[b_arange, ov_r1]
            & (~ov_d1)
            & (~vetoed_calls[b_arange, ov_c1])
            & lmask[b_arange, ov_c1]
        )
        # Override 2 (Responder / Partner rule)
        valid_pos[b_arange, ov_r2] = (
            pos_matched[b_arange, ov_r2]
            & (~ov_d2)
            & (~vetoed_calls[b_arange, ov_c2])
            & lmask[b_arange, ov_c2]
        )

        NEG_INF = -1e9
        scores = cand_net.rule_score[None, :].expand(B_tot, R).clone()
        scores[b_arange, ov_r1] = ov_s1
        scores[b_arange, ov_r2] = ov_s2
        masked_scores = torch.where(valid_pos, scores, torch.full_like(scores, NEG_INF))

        max_score, best_r = masked_scores.max(dim=1)
        has_match = max_score > (NEG_INF / 2)
        base_chosen = cand_net.rule_call[best_r]
        chosen = torch.where(
            best_r == ov_r1,
            ov_c1,
            torch.where(best_r == ov_r2, ov_c2, base_chosen),
        )
        return torch.where(has_match, chosen, torch.full_like(chosen, ga.IDX_PASS))

    def _run_table(cand_is_ns: bool) -> torch.Tensor:
        env = ga.BatchedAuctionEnv(sub)
        env.passes_since_last_np = torch.zeros(B_tot, dtype=torch.long, device=dev)
        for _ in range(20):
            if bool(env.done.all().item()):
                break
            X, seat = env.build_features()
            lmask = env.legal_mask(seat)
            is_ns = (seat % 2) == 0
            cand_turn = is_ns if cand_is_ns else (~is_ns)
            cand_calls_out = _select_with_coupled_override(X, lmask)
            _, opp_calls_out = opp_net.call_scores(X, lmask)
            calls = torch.where(cand_turn, cand_calls_out, opp_calls_out)
            env.step(calls)
        return env.terminal_ns_scores()

    return _run_table(cand_is_ns=True), _run_table(cand_is_ns=False)


def jps_shrink_edge(
    gain_sum: float,
    cnt: int,
    total_boards: int,
    lambda_shrink: float = 15.0,
) -> float:
    """JPS Reachability-Weighted Empirical Bayes Edge Shrinkage
    (`rela/search_actor_refactored_new.h:343-382`):
      shrunk_gain = (cnt / (cnt + lambda_shrink)) * (gain_sum / total_boards)
    """
    if cnt <= 0 or total_boards <= 0:
        return 0.0
    reach_weight = float(cnt) / (float(cnt) + float(lambda_shrink))
    return reach_weight * (float(gain_sum) / float(total_boards))


def train_belief_and_value_heads(
    bundle: ga.DealBundle,
    diff_net: DiffDSLNet,
    steps: int = 30,
    lr: float = 3e-3,
    batch_boards: int = 512,
) -> Dict[str, float]:
    """Train `diff_net.partner_belief_net` (predicting partner's normalized
    `[hcp/40, club_len/13, diamond_len/13, heart_len/13, spade_len/13]`) and
    `diff_net.value_head` (predicting expected terminal score) via batched
    self-play rollouts on `bundle`.
    """
    dev = bundle.hand_features.device
    B = min(batch_boards, bundle.num_boards)
    sub = slice_bundle(bundle, torch.arange(B, device=dev))
    cand_t = diff_net.to_tensor_decision_net()

    # Roll out once with cand_t to collect turn-level states (X, seat) and terminal NS scores
    env = ga.BatchedAuctionEnv(sub)
    env.passes_since_last_np = torch.zeros(B, dtype=torch.long, device=dev)
    traj_X: List[torch.Tensor] = []
    traj_seat: List[torch.Tensor] = []
    traj_active: List[torch.Tensor] = []

    for _ in range(16):
        if bool(env.done.all().item()):
            break
        X, seat = env.build_features()
        lmask = env.legal_mask(seat)
        active = (~env.done).clone()
        traj_X.append(X.detach())
        traj_seat.append(seat.detach())
        traj_active.append(active.detach())
        _, calls = cand_t.call_scores(X, lmask)
        env.step(calls)

    term_ns_pts = env.terminal_ns_scores().to(torch.float32)  # (B,)
    # Normalize points to [-1, 1] scale using tanh(pts / 400.0)
    term_ns_norm = torch.tanh(term_ns_pts / 400.0)

    hcp_col = ga.FEAT_TO_COL["hcp"]
    b_arange = torch.arange(B, device=dev)

    # Flatten active turn decisions into a training dataset
    x_rows: List[torch.Tensor] = []
    belief_targets: List[torch.Tensor] = []
    val_targets: List[torch.Tensor] = []

    for X_t, seat_t, act_t in zip(traj_X, traj_seat, traj_active):
        if not bool(act_t.any().item()):
            continue
        p_seat = (seat_t + 2) % 4
        p_hcp = sub.hand_features[b_arange, p_seat, hcp_col] / 40.0  # (B,)
        p_suits = sub.suit_lengths[b_arange, p_seat, :].to(torch.float32) / 13.0  # (B, 4)
        p_target = torch.cat([p_hcp[:, None], p_suits], dim=-1)  # (B, 5)
        is_ns = ((seat_t % 2) == 0).to(torch.float32)
        v_target = torch.where(is_ns > 0.5, term_ns_norm, -term_ns_norm)[:, None]  # (B, 1)

        x_rows.append(X_t[act_t])
        belief_targets.append(p_target[act_t])
        val_targets.append(v_target[act_t])

    if not x_rows:
        return {"belief_mse": 0.0, "val_mse": 0.0}

    X_all = torch.cat(x_rows, dim=0)
    B_target_all = torch.cat(belief_targets, dim=0)
    V_target_all = torch.cat(val_targets, dim=0)

    params = list(diff_net.partner_belief_net.parameters()) + list(diff_net.value_head.parameters())
    opt = torch.optim.AdamW(params, lr=lr, weight_decay=1e-4)

    with torch.no_grad():
        rule_acts_all = diff_net.match_rules(X_all, soft=False).detach()
        R_init = getattr(diff_net, "_init_num_rules", rule_acts_all.shape[1])
        if rule_acts_all.shape[1] >= R_init:
            rule_acts_v = rule_acts_all[:, :R_init]
        else:
            pad = torch.zeros(
                (rule_acts_all.shape[0], R_init - rule_acts_all.shape[1]),
                dtype=rule_acts_all.dtype,
                device=dev,
            )
            rule_acts_v = torch.cat([rule_acts_all, pad], dim=-1)

    belief_loss_val = 0.0
    val_loss_val = 0.0
    for _ in range(steps):
        opt.zero_grad()
        pred_belief = diff_net.partner_belief_net(X_all)
        v_in = torch.cat([X_all, rule_acts_v, pred_belief], dim=-1)
        pred_v = torch.tanh(diff_net.value_head(v_in))
        b_loss = F.mse_loss(pred_belief, B_target_all)
        v_loss = F.mse_loss(pred_v, V_target_all)
        loss = b_loss + v_loss
        loss.backward()
        opt.step()
        belief_loss_val = float(b_loss.item())
        val_loss_val = float(v_loss.item())

    diff_net.zero_grad()
    return {"belief_mse": belief_loss_val, "val_mse": val_loss_val, "n_decisions": int(X_all.shape[0])}


def compute_ste_gradient_importance(
    bundle: ga.DealBundle,
    diff_net: DiffDSLNet,
) -> Tuple[torch.Tensor, torch.Tensor]:
    """Run one differentiable rollout pass through `DiffDSLNet(soft=True)` to
    compute Straight-Through Estimator (STE) gradient magnitudes on:
      - `atom_val` (`(U,)`) — identifies which condition thresholds have the
        highest sensitivity
      - `rule_call_logits` (`(R, 38)`) — identifies which rules have the highest
        call-assignment gradient
    """
    diff_net.zero_grad()
    B = min(512, bundle.num_boards)
    sub = slice_bundle(bundle, torch.arange(B, device=bundle.hand_features.device))
    env = ga.BatchedAuctionEnv(sub)
    env.passes_since_last_np = torch.zeros(B, dtype=torch.long, device=env.device)

    total_surrogate = torch.zeros((), dtype=torch.float32, device=env.device)
    for _ in range(12):
        if bool(env.done.all().item()):
            break
        X, seat = env.build_features()
        lmask = env.legal_mask(seat)
        out = diff_net.forward(X, lmask, soft=True)
        # Combine learned value_head gradient + policy entropy sensitivity
        active_f = (~env.done).to(torch.float32)
        entropy_term = -(out["pi"] * (out["pi"].clamp(min=1e-6).log())).sum(dim=-1)
        v_term = -out["v"].squeeze(-1)
        total_surrogate = total_surrogate + ((v_term + 0.25 * entropy_term) * active_f).sum()
        env.step(out["best_calls"])

    total_surrogate.backward()
    atom_grad = (
        diff_net.atom_val.grad.detach().abs()
        if diff_net.atom_val.grad is not None
        else torch.zeros_like(diff_net.atom_val)
    )
    rule_grad = (
        diff_net.rule_call_logits.grad.detach().abs().sum(dim=1)
        if diff_net.rule_call_logits.grad is not None
        else torch.zeros(diff_net.num_rules, device=env.device)
    )
    diff_net.zero_grad()
    return atom_grad, rule_grad


def search_threshold_shifts_on_diff_net(
    tr_bundle: ga.DealBundle,
    val_bundle: ga.DealBundle,
    diff_net: DiffDSLNet,
    opp_nets: Sequence[ga.TensorDecisionNet],
    min_train_gain: float = 12.0,
    min_train_t: float = 1.4,
    lambda_shrink: float = 15.0,
    gpu_scale: bool = False,
) -> List[Dict[str, Any]]:
    """Evaluate threshold shifts on tunable `atom_val` parameters in `DiffDSLNet`,
    prioritized by STE gradient importance, using fast primary-opponent screening
    followed by full multi-opponent Train + Validation verification.
    """
    atom_grad, _ = compute_ste_gradient_importance(tr_bundle, diff_net)
    tunable_u = torch.where(diff_net.atom_tunable_mask)[0].tolist()
    tunable_u.sort(key=lambda u: float(atom_grad[u].item()), reverse=True)

    primary_opp = opp_nets[0]
    base_t_net = diff_net.to_tensor_decision_net()

    def _eval_single_opp(bundle: ga.DealBundle, net: ga.TensorDecisionNet, opp: ga.TensorDecisionNet) -> torch.Tensor:
        _, s1 = ga.play_boards_batched(bundle, net, opp)
        _, s2 = ga.play_boards_batched(bundle, opp, net)
        return ga.points_to_imps_tensor(s1 - s2).to(torch.float32)

    def _eval_multi_opp(bundle: ga.DealBundle, net: ga.TensorDecisionNet) -> torch.Tensor:
        return torch.stack([_eval_single_opp(bundle, net, opp) for opp in opp_nets], dim=0).mean(dim=0)

    tr_prim_base = _eval_single_opp(tr_bundle, base_t_net, primary_opp)
    tr_multi_base: Optional[torch.Tensor] = None
    val_multi_base: Optional[torch.Tensor] = None

    accepted_shifts: List[Dict[str, Any]] = []
    max_atoms_scan = 64 if gpu_scale else 28
    deltas_scan = (-1.0, +1.0, -2.0, +2.0) if gpu_scale else (-1.0, +1.0)

    for u_i in tunable_u[:max_atoms_scan]:
        f_col = int(diff_net.atom_feat[u_i].item())
        f_key = ga.FEATURE_KEYS[f_col]
        orig_val = float(diff_net.atom_val[u_i].item())
        affected_rules = torch.where(diff_net.rule_atom_mat[:, u_i] > 0.5)[0].tolist()
        if not affected_rules:
            continue

        best_cand_val = None
        best_shrunk = 0.0
        best_prim_imps = None
        best_stats = None

        for delta in deltas_scan:
            cand_val = orig_val + delta
            if f_key in ("hcp", "total_points", "zar_points", "long_suit_hcp") and cand_val < 0:
                continue
            if f_key in ("long_suit_intermediates", "trump_intermediates", "controls", "aces") and cand_val < 0:
                continue

            diff_net.set_atom_threshold(u_i, cand_val)
            cand_t_net = diff_net.to_tensor_decision_net()
            tr_prim_cand = _eval_single_opp(tr_bundle, cand_t_net, primary_opp)
            diff_vec = tr_prim_cand - tr_prim_base
            changed_mask = diff_vec.abs() > 1e-4
            n_changed = int(changed_mask.sum().item())
            if n_changed < 3:
                continue
            gain_sum = float(diff_vec.sum().item())
            if gain_sum < min_train_gain:
                continue
            act_diffs = diff_vec[changed_mask]
            mean_d = float(act_diffs.mean().item())
            sd_d = float(act_diffs.std(unbiased=True).item()) if n_changed > 1 else 0.0
            se_d = sd_d / math.sqrt(n_changed) if n_changed > 0 else 0.0
            t_val = (mean_d / se_d) if se_d > 1e-6 else 0.0
            if t_val < min_train_t:
                continue

            shrunk = jps_shrink_edge(gain_sum, n_changed, tr_bundle.num_boards, lambda_shrink)
            if shrunk > best_shrunk:
                best_shrunk = shrunk
                best_cand_val = cand_val
                best_prim_imps = tr_prim_cand
                best_stats = (gain_sum, t_val, n_changed)

        diff_net.set_atom_threshold(u_i, orig_val)

        if best_cand_val is not None and best_stats is not None:
            if tr_multi_base is None:
                base_now = diff_net.to_tensor_decision_net()
                tr_multi_base = _eval_multi_opp(tr_bundle, base_now)
                val_multi_base = _eval_multi_opp(val_bundle, base_now)

            gain_sum, t_val, n_changed = best_stats
            diff_net.set_atom_threshold(u_i, best_cand_val)
            cand_t_net = diff_net.to_tensor_decision_net()
            tr_multi_cand = _eval_multi_opp(tr_bundle, cand_t_net)
            tr_multi_gain = float((tr_multi_cand - tr_multi_base).sum().item())
            val_multi_cand = _eval_multi_opp(val_bundle, cand_t_net)
            val_gain = float((val_multi_cand - val_multi_base).sum().item())

            if tr_multi_gain >= min_train_gain * 0.5 and val_gain > 0.0:
                tr_prim_base = best_prim_imps
                tr_multi_base = tr_multi_cand
                val_multi_base = val_multi_cand
                r_names = [diff_net.rule_ids[r] for r in affected_rules[:3]]
                accepted_shifts.append({
                    "type": "atom_threshold_shift",
                    "atom_idx": u_i,
                    "feature": f_key,
                    "old_val": orig_val,
                    "new_val": best_cand_val,
                    "affected_rules": r_names,
                    "train_gain_imps": tr_multi_gain,
                    "train_t": t_val,
                    "val_gain_imps": val_gain,
                    "n_changed": n_changed,
                })
                print(
                    f"  [ACCEPT THRESHOLD] atom[{u_i}] {f_key}: {orig_val:.1f} -> {best_cand_val:.1f} "
                    f"(rules={r_names}) | train {tr_multi_gain:+.1f} IMP (t={t_val:+.2f}, n={n_changed}) "
                    f"| val {val_gain:+.1f} IMP"
                )
            else:
                diff_net.set_atom_threshold(u_i, orig_val)

    return accepted_shifts


def search_jps_partner_belief_splits_on_diff_net(
    tr_bundle: ga.DealBundle,
    val_bundle: ga.DealBundle,
    diff_net: DiffDSLNet,
    opp_nets: Sequence[ga.TensorDecisionNet],
    min_train_gain: float = 12.0,
    min_train_t: float = 1.4,
    lambda_shrink: float = 15.0,
    gpu_scale: bool = False,
    gen_idx: int = 1,
) -> List[Dict[str, Any]]:
    """Stage 3: Search JPS Partner-Belief & Fit Condition Splits directly on `DiffDSLNet`,
    refining top high-traffic partnership rules with conditions on:
      - `combined_hcp_min` (>= 23, >= 24, >= 25, >= 26, <= 21, <= 19)
      - `support_in_partner_suit` (>= 3, >= 4, <= 2)
      - `agreed_trump_len` (>= 4, >= 5)
      - `partner_hcp_min` (>= 12, >= 15)
      - `trump_intermediates` (>= 1, >= 2)
      - `long_suit_intermediates` (>= 2)
      - `losing_trick_count` (<= 6, <= 5)
      - `short_suit_wasted_hcp` (== 0)
    """
    primary_opp = opp_nets[0]
    cand_t = diff_net.to_tensor_decision_net()
    s1, s2, tr_active, _ = record_jps_coupling_and_baseline(tr_bundle, cand_t, primary_opp)
    tr_prim_base = ga.points_to_imps_tensor(s1 - s2).to(torch.float32)

    max_rules_scan = 45 if gpu_scale else 25
    rule_counts = tr_active.sum(dim=0)
    top_rules = sorted(
        [
            (int(rule_counts[r].item()), r)
            for r in range(cand_t.num_rules)
            if not bool(cand_t.rule_neg[r].item()) and int(rule_counts[r].item()) >= 16
        ],
        reverse=True,
    )[:max_rules_scan]

    split_predicates = [
        ("combined_hcp_min", ">=", 24.0),
        ("combined_hcp_min", ">=", 26.0),
        ("combined_hcp_min", "<=", 21.0),
        ("support_in_partner_suit", ">=", 3.0),
        ("support_in_partner_suit", ">=", 4.0),
        ("agreed_trump_len", ">=", 4.0),
        ("partner_hcp_min", ">=", 12.0),
        ("trump_intermediates", ">=", 1.0),
        ("long_suit_intermediates", ">=", 2.0),
    ]
    if gpu_scale:
        split_predicates.extend([
            ("combined_hcp_min", ">=", 25.0),
            ("combined_hcp_min", "<=", 19.0),
            ("support_in_partner_suit", "<=", 2.0),
            ("agreed_trump_len", ">=", 5.0),
            ("partner_hcp_min", ">=", 15.0),
            ("losing_trick_count", "<=", 6.0),
            ("short_suit_wasted_hcp", "==", 0.0),
        ])

    def _eval_single_opp(bundle: ga.DealBundle, net: ga.TensorDecisionNet, opp: ga.TensorDecisionNet) -> torch.Tensor:
        _, s1_o = ga.play_boards_batched(bundle, net, opp)
        _, s2_o = ga.play_boards_batched(bundle, opp, net)
        return ga.points_to_imps_tensor(s1_o - s2_o).to(torch.float32)

    def _eval_multi_opp(bundle: ga.DealBundle, net: ga.TensorDecisionNet) -> torch.Tensor:
        return torch.stack([_eval_single_opp(bundle, net, opp) for opp in opp_nets], dim=0).mean(dim=0)

    tr_multi_base = _eval_multi_opp(tr_bundle, cand_t)
    val_multi_base = _eval_multi_opp(val_bundle, cand_t)
    accepted_splits: List[Dict[str, Any]] = []
    existing_rids = set(diff_net.rule_ids)

    for _cnt, r_i in top_rules:
        active_b = torch.where(tr_active[:, r_i])[0]
        if int(active_b.numel()) < 12:
            continue
        sub_tr = slice_bundle(tr_bundle, active_b)
        sub_base_imps = tr_prim_base[active_b]
        old_c = int(diff_net.rule_call[r_i].item())
        cands = [c for c in candidate_calls_for_rule(old_c, allow_doubles=False)[:8] if c >= 0]
        parent_id = diff_net.rule_ids[r_i]

        best_split = None
        best_shrunk = 0.0

        for feat_k, op_s, val_f in split_predicates:
            if feat_k not in ga.FEAT_TO_COL:
                continue
            for new_c in cands:
                new_rid = f"{parent_id}_JPS_G{gen_idx}_{feat_k}_{int(val_f)}_{ga.CALL_NAMES[new_c]}"
                if new_rid in existing_rids:
                    continue
                # Snapshot diff_net state sizes before temporary split
                orig_num_rules = diff_net.num_rules
                orig_num_atoms = diff_net.num_atoms
                diff_net.clone_and_split_rule(r_i, new_rid, feat_k, op_s, val_f, new_c, prio_bump=1.0)
                sub_cand_imps = _eval_single_opp(sub_tr, diff_net.to_tensor_decision_net(), primary_opp)
                diff_vec = sub_cand_imps - sub_base_imps

                # Roll back the temporary split
                diff_net.num_rules = orig_num_rules
                diff_net.rule_ids.pop()
                diff_net._orig_conditions.pop()
                diff_net.rule_atom_mat = diff_net.rule_atom_mat[:orig_num_rules]
                diff_net.rule_atom_logits = torch.nn.Parameter(diff_net.rule_atom_mat.clone())
                diff_net.rule_n_atoms = diff_net.rule_n_atoms[:orig_num_rules]
                diff_net.rule_neg = diff_net.rule_neg[:orig_num_rules]
                diff_net.rule_disabled = diff_net.rule_disabled[:orig_num_rules]
                diff_net.neg_rule_call_mat = diff_net.neg_rule_call_mat[:orig_num_rules]
                diff_net.rule_prio_param = torch.nn.Parameter(diff_net.rule_prio_param.data[:orig_num_rules])
                diff_net.rule_call_logits = torch.nn.Parameter(diff_net.rule_call_logits.data[:orig_num_rules])
                if diff_net.num_atoms > orig_num_atoms:
                    diff_net.num_atoms = orig_num_atoms
                    diff_net.atom_feat = diff_net.atom_feat[:orig_num_atoms]
                    diff_net.atom_op = diff_net.atom_op[:orig_num_atoms]
                    diff_net.atom_val = torch.nn.Parameter(diff_net.atom_val.data[:orig_num_atoms])
                    diff_net.atom_in_mask = diff_net.atom_in_mask[:orig_num_atoms]
                    diff_net.atom_in_lut = diff_net.atom_in_lut[:orig_num_atoms]
                    diff_net.u_arange = torch.arange(orig_num_atoms, dtype=torch.long, device=diff_net.device)
                    diff_net.atom_tunable_mask = diff_net.atom_tunable_mask[:orig_num_atoms]
                    diff_net.rule_atom_mat = diff_net.rule_atom_mat[:, :orig_num_atoms]
                    diff_net.rule_atom_logits = torch.nn.Parameter(diff_net.rule_atom_mat.clone())

                changed_mask = diff_vec.abs() > 1e-4
                n_ch = int(changed_mask.sum().item())
                if n_ch < 3:
                    continue
                gain = float(diff_vec.sum().item())
                if gain < min_train_gain:
                    continue
                act_d = diff_vec[changed_mask]
                mean_d = float(act_d.mean().item())
                sd_d = float(act_d.std(unbiased=True).item()) if n_ch > 1 else 0.0
                se_d = sd_d / math.sqrt(n_ch) if n_ch > 0 else 0.0
                t_val = (mean_d / se_d) if se_d > 1e-6 else 0.0
                if t_val < min_train_t:
                    continue
                shrunk = jps_shrink_edge(gain, n_ch, tr_bundle.num_boards, lambda_shrink)
                if shrunk > best_shrunk:
                    best_shrunk = shrunk
                    best_split = (feat_k, op_s, val_f, new_c, new_rid, gain, t_val, n_ch)

        if best_split is not None:
            feat_k, op_s, val_f, new_c, new_rid, gain, t_val, n_ch = best_split
            orig_num_rules = diff_net.num_rules
            orig_num_atoms = diff_net.num_atoms
            diff_net.clone_and_split_rule(r_i, new_rid, feat_k, op_s, val_f, new_c, prio_bump=1.0)
            cand_now = diff_net.to_tensor_decision_net()
            tr_m_cand = _eval_multi_opp(tr_bundle, cand_now)
            tr_m_gain = float((tr_m_cand - tr_multi_base).sum().item())
            val_m_cand = _eval_multi_opp(val_bundle, cand_now)
            val_m_gain = float((val_m_cand - val_multi_base).sum().item())

            if tr_m_gain >= min_train_gain * 0.5 and val_m_gain > 0.0:
                tr_multi_base = tr_m_cand
                val_multi_base = val_m_cand
                tr_prim_base = _eval_single_opp(tr_bundle, cand_now, primary_opp)
                existing_rids.add(new_rid)
                accepted_splits.append({
                    "type": "jps_partner_belief_split",
                    "parent_rule": parent_id,
                    "new_rule_id": new_rid,
                    "condition": f"{feat_k} {op_s} {val_f:g}",
                    "old_call": ga.CALL_NAMES[old_c],
                    "new_call": ga.CALL_NAMES[new_c],
                    "shrunk_edge": best_shrunk,
                    "train_gain_imps": tr_m_gain,
                    "train_t": t_val,
                    "val_gain_imps": val_m_gain,
                    "n_changed": n_ch,
                })
                print(
                    f"  [ACCEPT JPS SPLIT] {new_rid} ({feat_k} {op_s} {val_f:g}): "
                    f"{ga.CALL_NAMES[old_c]}->{ga.CALL_NAMES[new_c]} | "
                    f"shrunk={best_shrunk:+.4f} | train {tr_m_gain:+.1f} IMP (t={t_val:+.2f}, n={n_ch}) | "
                    f"val {val_m_gain:+.1f} IMP"
                )
            else:
                diff_net.num_rules = orig_num_rules
                diff_net.rule_ids.pop()
                diff_net._orig_conditions.pop()
                diff_net.rule_atom_mat = diff_net.rule_atom_mat[:orig_num_rules]
                diff_net.rule_atom_logits = torch.nn.Parameter(diff_net.rule_atom_mat.clone())
                diff_net.rule_n_atoms = diff_net.rule_n_atoms[:orig_num_rules]
                diff_net.rule_neg = diff_net.rule_neg[:orig_num_rules]
                diff_net.rule_disabled = diff_net.rule_disabled[:orig_num_rules]
                diff_net.neg_rule_call_mat = diff_net.neg_rule_call_mat[:orig_num_rules]
                diff_net.rule_prio_param = torch.nn.Parameter(diff_net.rule_prio_param.data[:orig_num_rules])
                diff_net.rule_call_logits = torch.nn.Parameter(diff_net.rule_call_logits.data[:orig_num_rules])
                if diff_net.num_atoms > orig_num_atoms:
                    diff_net.num_atoms = orig_num_atoms
                    diff_net.atom_feat = diff_net.atom_feat[:orig_num_atoms]
                    diff_net.atom_op = diff_net.atom_op[:orig_num_atoms]
                    diff_net.atom_val = torch.nn.Parameter(diff_net.atom_val.data[:orig_num_atoms])
                    diff_net.atom_in_mask = diff_net.atom_in_mask[:orig_num_atoms]
                    diff_net.atom_in_lut = diff_net.atom_in_lut[:orig_num_atoms]
                    diff_net.u_arange = torch.arange(orig_num_atoms, dtype=torch.long, device=diff_net.device)
                    diff_net.atom_tunable_mask = diff_net.atom_tunable_mask[:orig_num_atoms]
                    diff_net.rule_atom_mat = diff_net.rule_atom_mat[:, :orig_num_atoms]
                    diff_net.rule_atom_logits = torch.nn.Parameter(diff_net.rule_atom_mat.clone())

    return accepted_splits


def run_jps_coupled_search_on_diff_net(
    tr_bundle: ga.DealBundle,
    val_bundle: ga.DealBundle,
    diff_net: DiffDSLNet,
    opp_nets: Sequence[ga.TensorDecisionNet],
    min_train_gain: float = 12.0,
    min_train_t: float = 1.4,
    lambda_shrink: float = 15.0,
    max_batch_rows: int = 8192,
    gpu_scale: bool = False,
) -> List[Dict[str, Any]]:
    """Run Depth-2 Coupled `(Opener r_1 -> c_1, Responder r_2 -> c_2)` JPS Search
    with `alterReach` partner rule discovery and Empirical Bayes reach shrinkage.
    """
    dev = tr_bundle.hand_features.device
    cand_net = diff_net.to_tensor_decision_net()
    primary_opp = opp_nets[0]
    if gpu_scale and max_batch_rows < 24576:
        max_batch_rows = 24576

    s1, s2, tr_active, pair_tensors = record_jps_coupling_and_baseline(
        tr_bundle, cand_net, primary_opp
    )
    tr_base_primary = ga.points_to_imps_tensor(s1 - s2).to(torch.float32)

    # Sort observed `(r1, r2)` partnership pairs by active board reach
    sorted_pairs = sorted(
        pair_tensors.items(),
        key=lambda kv: int(kv[1].numel()),
        reverse=True,
    )

    max_pairs_scan = 60 if gpu_scale else 30
    max_alter_r1 = 16 if gpu_scale else 8

    # Also discover `alterReach` partner rules for top opener rules when they change call
    rule_counts = tr_active.sum(dim=0)
    top_r1 = sorted(
        [(int(rule_counts[r].item()), r) for r in range(cand_net.num_rules) if not bool(cand_net.rule_neg[r].item()) and int(rule_counts[r].item()) >= 12],
        reverse=True,
    )[:max_alter_r1]

    coupled_tasks: List[Tuple[int, int, int, int, torch.Tensor]] = []
    seen_task_keys = set()

    # 1. Observed `(r1, r2)` coupled pairs
    for (r1, r2), b_idx in sorted_pairs[:max_pairs_scan]:
        if bool(cand_net.rule_neg[r1].item()) or bool(cand_net.rule_neg[r2].item()):
            continue
        # Union of boards where r1 or r2 is active so we capture full board impact
        union_mask = tr_active[:, r1] | tr_active[:, r2]
        u_boards = torch.where(union_mask)[0]
        if int(u_boards.numel()) < 5:
            continue
        old_c1 = int(cand_net.rule_call[r1].item())
        old_c2 = int(cand_net.rule_call[r2].item())
        allow_dbl1 = gpu_scale and ("_cont_" in diff_net.rule_ids[r1])
        allow_dbl2 = gpu_scale and ("_cont_" in diff_net.rule_ids[r2])
        c1_cands = [old_c1] + candidate_calls_for_rule(old_c1, allow_doubles=allow_dbl1)[:8]
        c2_cands = [old_c2] + candidate_calls_for_rule(old_c2, allow_doubles=allow_dbl2)[:8]
        for c1 in c1_cands:
            for c2 in c2_cands:
                if c1 == old_c1 and c2 == old_c2:
                    continue
                t_key = (r1, c1, r2, c2)
                if t_key not in seen_task_keys:
                    seen_task_keys.add(t_key)
                    coupled_tasks.append((r1, c1, r2, c2, u_boards))

    # 2. `alterReach` newly reachable `(r1 -> c1', r2 -> c2')` pairs
    for _cnt, r1 in top_r1[:max_alter_r1]:
        r1_b = torch.where(tr_active[:, r1])[0]
        old_c1 = int(cand_net.rule_call[r1].item())
        for c1 in candidate_calls_for_rule(old_c1, allow_doubles=False)[:5]:
            if c1 < 0:
                continue
            alter_r2_list = discover_alter_reach_partner_rules(
                tr_bundle, cand_net, primary_opp, r1, c1, r1_b, top_m=(3 if gpu_scale else 2)
            )
            for r2, _r2_b in alter_r2_list:
                if bool(cand_net.rule_neg[r2].item()):
                    continue
                union_b = torch.where(tr_active[:, r1] | tr_active[:, r2])[0]
                old_c2 = int(cand_net.rule_call[r2].item())
                for c2 in candidate_calls_for_rule(old_c2, allow_doubles=False)[:6]:
                    t_key = (r1, c1, r2, c2)
                    if t_key not in seen_task_keys:
                        seen_task_keys.add(t_key)
                        coupled_tasks.append((r1, c1, r2, c2, union_b))

    print(f"  [JPS Depth-2] Evaluating {len(coupled_tasks)} coupled (Opener, Responder) policy pairs...")

    lex_ranks = ga.CALL_LEX_RANK
    proposals: List[Tuple[float, float, float, int, int, int, int, int]] = []

    idx = 0
    num_tasks = len(coupled_tasks)
    while idx < num_tasks:
        b_list, r1_list, c1_list, s1_list, d1_list = [], [], [], [], []
        r2_list, c2_list, s2_list, d2_list = [], [], [], []
        slices: List[Tuple[int, int, int, int, int, int]] = []
        cur_rows = 0

        while idx < num_tasks:
            r1, c1, r2, c2, u_boards = coupled_tasks[idx]
            m = int(u_boards.numel())
            if cur_rows > 0 and cur_rows + m > max_batch_rows:
                break

            p1 = float(cand_net.rule_prio[r1].item())
            p2 = float(cand_net.rule_prio[r2].item())
            c1_v = ga.IDX_PASS if c1 < 0 else c1
            s1_v = -1e9 if c1 < 0 else (p1 * 64.0 - float(lex_ranks[c1]))
            d1_v = c1 < 0

            c2_v = ga.IDX_PASS if c2 < 0 else c2
            s2_v = -1e9 if c2 < 0 else (p2 * 64.0 - float(lex_ranks[c2]))
            d2_v = c2 < 0

            b_list.append(u_boards)
            r1_list.append(torch.full((m,), r1, dtype=torch.long, device=dev))
            c1_list.append(torch.full((m,), c1_v, dtype=torch.long, device=dev))
            s1_list.append(torch.full((m,), s1_v, dtype=torch.float32, device=dev))
            d1_list.append(torch.full((m,), d1_v, dtype=torch.bool, device=dev))

            r2_list.append(torch.full((m,), r2, dtype=torch.long, device=dev))
            c2_list.append(torch.full((m,), c2_v, dtype=torch.long, device=dev))
            s2_list.append(torch.full((m,), s2_v, dtype=torch.float32, device=dev))
            d2_list.append(torch.full((m,), d2_v, dtype=torch.bool, device=dev))

            slices.append((r1, c1, r2, c2, cur_rows, cur_rows + m))
            cur_rows += m
            idx += 1

        b_cat = torch.cat(b_list)
        s1_out, s2_out = run_packed_coupled_override_batch(
            tr_bundle,
            cand_net,
            primary_opp,
            b_cat,
            torch.cat(r1_list),
            torch.cat(c1_list),
            torch.cat(s1_list),
            torch.cat(d1_list),
            torch.cat(r2_list),
            torch.cat(c2_list),
            torch.cat(s2_list),
            torch.cat(d2_list),
        )
        imps_out = ga.points_to_imps_tensor(s1_out - s2_out).to(torch.float32)
        diff_out = imps_out - tr_base_primary[b_cat]

        for r1, c1, r2, c2, st, en in slices:
            d_vec = diff_out[st:en]
            gain = float(d_vec.sum().item())
            if gain < min_train_gain:
                continue
            changed_mask = d_vec.abs() > 1e-4
            n_ch = int(changed_mask.sum().item())
            if n_ch < 3:
                continue
            act_d = d_vec[changed_mask]
            mean_d = float(act_d.mean().item())
            sd_d = float(act_d.std(unbiased=True).item()) if n_ch > 1 else 0.0
            se_d = sd_d / math.sqrt(n_ch) if n_ch > 0 else 0.0
            t_val = (mean_d / se_d) if se_d > 1e-6 else 0.0
            if t_val < min_train_t:
                continue
            shrunk = jps_shrink_edge(gain, n_ch, tr_bundle.num_boards, lambda_shrink)
            proposals.append((shrunk, gain, t_val, r1, c1, r2, c2, n_ch))

    proposals.sort(reverse=True)

    # Validate top coupled proposals across ALL opponents on Train and Validation
    def _eval_multi_opp(bundle: ga.DealBundle, net: ga.TensorDecisionNet) -> torch.Tensor:
        imps_list = []
        for opp in opp_nets:
            _, s1_m = ga.play_boards_batched(bundle, net, opp)
            _, s2_m = ga.play_boards_batched(bundle, opp, net)
            imps_list.append(ga.points_to_imps_tensor(s1_m - s2_m).to(torch.float32))
        return torch.stack(imps_list, dim=0).mean(dim=0)

    tr_multi_base = _eval_multi_opp(tr_bundle, diff_net.to_tensor_decision_net())
    val_multi_base = _eval_multi_opp(val_bundle, diff_net.to_tensor_decision_net())

    accepted_jps: List[Dict[str, Any]] = []
    modified_rules = set()
    max_prop_eval = 40 if gpu_scale else 25

    for shrunk, gain, t_val, r1, c1, r2, c2, n_ch in proposals[:max_prop_eval]:
        if r1 in modified_rules or r2 in modified_rules:
            continue
        old_c1 = int(diff_net.rule_call[r1].item())
        old_c2 = int(diff_net.rule_call[r2].item())
        old_d1 = bool(diff_net.rule_disabled[r1].item())
        old_d2 = bool(diff_net.rule_disabled[r2].item())

        diff_net.set_rule_call(r1, c1)
        diff_net.set_rule_call(r2, c2)
        cand_t = diff_net.to_tensor_decision_net()

        tr_cand = _eval_multi_opp(tr_bundle, cand_t)
        tr_multi_gain = float((tr_cand - tr_multi_base).sum().item())
        val_cand = _eval_multi_opp(val_bundle, cand_t)
        val_multi_gain = float((val_cand - val_multi_base).sum().item())

        if tr_multi_gain >= min_train_gain * 0.5 and val_multi_gain > 0.0:
            tr_multi_base = tr_cand
            val_multi_base = val_cand
            modified_rules.add(r1)
            modified_rules.add(r2)
            c1_s = "ABLATE" if c1 < 0 else ga.CALL_NAMES[c1]
            c2_s = "ABLATE" if c2 < 0 else ga.CALL_NAMES[c2]
            accepted_jps.append({
                "type": "jps_coupled_pair",
                "r1_id": diff_net.rule_ids[r1],
                "old_c1": ga.CALL_NAMES[old_c1],
                "new_c1": c1_s,
                "r2_id": diff_net.rule_ids[r2],
                "old_c2": ga.CALL_NAMES[old_c2],
                "new_c2": c2_s,
                "shrunk_edge": shrunk,
                "train_gain_imps": tr_multi_gain,
                "train_t": t_val,
                "val_gain_imps": val_multi_gain,
                "n_changed": n_ch,
            })
            print(
                f"  [ACCEPT JPS PAIR] ({diff_net.rule_ids[r1]}: {ga.CALL_NAMES[old_c1]}->{c1_s}, "
                f"{diff_net.rule_ids[r2]}: {ga.CALL_NAMES[old_c2]}->{c2_s}) | "
                f"shrunk={shrunk:+.4f} | train {tr_multi_gain:+.1f} IMP (t={t_val:+.2f}, n={n_ch}) | "
                f"val {val_multi_gain:+.1f} IMP"
            )
        else:
            # Revert
            diff_net.set_rule_call(r1, -1 if old_d1 else old_c1)
            diff_net.set_rule_call(r2, -1 if old_d2 else old_c2)

    return accepted_jps


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--bundle", default="data/colab_bundle_10k.pt")
    ap.add_argument("--dsl", default="system/brill_gpu_evolved.dsl")
    ap.add_argument("--out-dsl", default="system/brill_jps_diff.dsl")
    ap.add_argument("--out-pt", default="data/diff_dsl_jps.pt")
    ap.add_argument("--generations", type=int, default=1, help="Number of JPS self-improvement generations")
    ap.add_argument("--gpu-scale", action="store_true", help="Enable expanded GPU search breadth")
    ap.add_argument("--train-boards", type=int, default=5000)
    ap.add_argument("--val-boards", type=int, default=2500)
    ap.add_argument("--test-boards", type=int, default=2500)
    ap.add_argument("--min-train-gain", type=float, default=12.0)
    ap.add_argument("--min-train-t", type=float, default=1.4)
    ap.add_argument("--lambda-shrink", type=float, default=15.0)
    ap.add_argument("--device", default="")
    args = ap.parse_args()

    dev = ga.pick_device(args.device or None)
    gpu_scale = bool(args.gpu_scale or (dev.type == "cuda"))
    t0 = time.perf_counter()
    print(f"Loading bundle {args.bundle} on [{dev}] (gpu_scale={gpu_scale}, generations={args.generations})...")
    full_bundle = ga.DealBundle.load(args.bundle, device=dev)
    N = full_bundle.num_boards
    n_tr = min(args.train_boards, N // 2)
    n_val = min(args.val_boards, (N - n_tr) // 2)
    n_te = min(args.test_boards, N - n_tr - n_val)

    tr_bundle = slice_bundle(full_bundle, torch.arange(0, n_tr, device=dev))
    val_bundle = slice_bundle(full_bundle, torch.arange(n_tr, n_tr + n_val, device=dev))
    te_bundle = slice_bundle(full_bundle, torch.arange(n_tr + n_val, n_tr + n_val + n_te, device=dev))
    print(f"Splits: Train={tr_bundle.num_boards}, Val={val_bundle.num_boards}, Test={te_bundle.num_boards}")

    diff_net = DiffDSLNet.from_dsl(args.dsl, device=dev)
    opp_distilled = ga.TensorDecisionNet.from_dsl("system/brill_distilled.dsl", device=dev)
    opp_shipdd = ga.TensorDecisionNet.from_dsl("system/brill_distilled_shipdd.dsl", device=dev)
    opp_evolved = ga.TensorDecisionNet.from_dsl(args.dsl, device=dev)
    opp_nets: List[ga.TensorDecisionNet] = [opp_distilled, opp_shipdd, opp_evolved]

    print(f"\nInitialized DiffDSLNet from {args.dsl}: {diff_net.num_rules} rules, {diff_net.num_atoms} condition atoms")

    # Baseline Test Evaluation
    base_t = diff_net.to_tensor_decision_net()
    base_res = ga.gpu_team_match(te_bundle, base_t, opp_distilled)
    print(f"Baseline vs brill_distilled on Held-Out Test ({n_te} bds): {base_res['mean']:+.4f} +/- {base_res['se']:.4f} IMP/bd")

    for gen in range(1, args.generations + 1):
        gen_t0 = time.perf_counter()
        print(f"\n======================================================================")
        print(f"  GENERATION {gen}/{args.generations} | League Pool Size: {len(opp_nets)} | Rules: {diff_net.num_rules}")
        print(f"======================================================================")

        print(f"\n[Gen {gen} - Stage 0] Online Training of partner_belief_net & value_head...")
        head_metrics = train_belief_and_value_heads(
            tr_bundle,
            diff_net,
            steps=(40 if gpu_scale else 20),
            batch_boards=(1024 if gpu_scale else 512),
        )
        print(
            f"  Trained heads on {head_metrics.get('n_decisions', 0)} decisions: "
            f"belief_mse={head_metrics['belief_mse']:.4f}, val_mse={head_metrics['val_mse']:.4f}"
        )

        print(f"\n[Gen {gen} - Stage 1] Depth-2 Coupled JPS Search over DiffDSLNet...")
        jps_edits = run_jps_coupled_search_on_diff_net(
            tr_bundle,
            val_bundle,
            diff_net,
            opp_nets,
            min_train_gain=args.min_train_gain,
            min_train_t=args.min_train_t,
            lambda_shrink=args.lambda_shrink,
            gpu_scale=gpu_scale,
        )

        print(f"\n[Gen {gen} - Stage 2] STE Gradient-Guided Threshold Search over DiffDSLNet.atom_val...")
        thresh_edits = search_threshold_shifts_on_diff_net(
            tr_bundle,
            val_bundle,
            diff_net,
            opp_nets,
            min_train_gain=args.min_train_gain,
            min_train_t=args.min_train_t,
            lambda_shrink=args.lambda_shrink,
            gpu_scale=gpu_scale,
        )

        print(f"\n[Gen {gen} - Stage 3] JPS Partner-Belief & Fit Condition Splits on DiffDSLNet...")
        split_edits = search_jps_partner_belief_splits_on_diff_net(
            tr_bundle,
            val_bundle,
            diff_net,
            opp_nets,
            min_train_gain=args.min_train_gain,
            min_train_t=args.min_train_t,
            lambda_shrink=args.lambda_shrink,
            gpu_scale=gpu_scale,
            gen_idx=gen,
        )

        n_gen_edits = len(jps_edits) + len(thresh_edits) + len(split_edits)
        gen_t = diff_net.to_tensor_decision_net()
        gen_t.name = f"diff_dsl_gen_{gen}"
        gen_te_res = ga.gpu_team_match(te_bundle, gen_t, opp_distilled)
        gen_ev_res = ga.gpu_team_match(te_bundle, gen_t, opp_evolved)
        print(
            f"\n[Gen {gen} Summary] Accepted {n_gen_edits} edits "
            f"(coupled={len(jps_edits)}, thresh={len(thresh_edits)}, splits={len(split_edits)}) "
            f"in {time.perf_counter() - gen_t0:.1f}s | Rules={diff_net.num_rules}\n"
            f"  Held-Out Test vs brill_distilled : {gen_te_res['mean']:+.4f} +/- {gen_te_res['se']:.4f} IMP/bd (t={gen_te_res['t']:+.2f})\n"
            f"  Held-Out Test vs brill_gpu_evolved: {gen_ev_res['mean']:+.4f} +/- {gen_ev_res['se']:.4f} IMP/bd (t={gen_ev_res['t']:+.2f})"
        )

        if n_gen_edits == 0:
            print(f"  No additional edits passed multi-opponent Validation in Gen {gen}; stopping early.")
            break

        # Add Generation g checkpoint to the League Opponent Pool for Generation g+1
        opp_nets.insert(0, gen_t)

    # Export updated DiffDSLNet weights to .dsl and .pt
    n_exported = diff_net.export_dsl(args.out_dsl)
    torch.save(diff_net.state_dict(), args.out_pt)
    print(f"\nExported updated DiffDSLNet ({n_exported} rules) -> {args.out_dsl} and weights -> {args.out_pt}")

    # Held-Out Test Evaluation
    final_t = diff_net.to_tensor_decision_net()
    final_t.name = "brill_jps_diff"
    eval_opps = [
        ("brill_distilled", opp_distilled),
        ("brill_distilled_shipdd", opp_shipdd),
        ("brill_gpu_evolved", opp_evolved),
    ]
    if os.path.exists("system/champion_system.dsl"):
        eval_opps.append(("champion_system", ga.TensorDecisionNet.from_dsl("system/champion_system.dsl", device=dev)))
    for opp_label, opp_net in eval_opps:
        opp_net.name = opp_label
        res = ga.gpu_team_match(te_bundle, final_t, opp_net)
        print(
            f"Held-Out Test ({n_te} bds) vs {opp_label:<24}: "
            f"{res['mean']:+.4f} +/- {res['se']:.4f} IMP/bd (t={res['t']:+.2f}, total={res['total']:+d} IMP)"
        )

    # Show sample explainable bids on Held-Out Test boards
    env = ga.BatchedAuctionEnv(slice_bundle(te_bundle, torch.arange(5, device=dev)))
    env.passes_since_last_np = torch.zeros(5, dtype=torch.long, device=dev)
    X0, s0 = env.build_features()
    lm0 = env.legal_mask(s0)
    exps = diff_net.explain_batch(X0, lm0)
    print("\nSample Explainable Bids from DiffDSLNet on Held-Out Test:")
    for i, ex in enumerate(exps):
        print(f"  Board {i}: {ex.to_cot_str()}")

    print(f"\nCompleted in {time.perf_counter() - t0:.1f}s")
    return 0


if __name__ == "__main__":
    sys.exit(main())

