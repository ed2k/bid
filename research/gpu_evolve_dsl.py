#!/usr/bin/env python3
"""GPU-Accelerated Full-Continuation Coordinate Ascent for Bridge Bidding DSLs.

Unlike 1-step static Double-Dummy leaf relabelling (`research/leaf_ceiling.py`),
which evaluates a call as if the auction stopped immediately on that call (and
therefore fails on `BD_open_uncont_` and `BD_later_cont_`), this optimizer
evaluates every candidate modification to a rule `r`:
  - retargeting `r` to candidate calls in `{PASS, 1C..7NT, X}`
  - ablating / disabling `r` (falling through to lower-priority rules)
by playing the **complete two-table duplicate auction to `PASS-PASS-PASS`**
under the partnership policy on GPU.

Key algorithmic speedup (Active-Board Subsetting + Mega-Batch Rule Packing):
  1. For any rule `r`, changing `r`'s target call or disabling `r` can ONLY
     affect boards where rule `r` matches at the winning priority in Table 1
     or Table 2 (`active_mask[r]`). On all other boards, the auction and WBF
     IMP outcome are provably 100% identical to the baseline.
  2. Across hundreds of active rules `{r_1, r_2, ...}`, we pack all
     `(rule_idx, candidate_call, active_board_index)` triples into dense GPU
     mega-batches of ~8,000 concurrent boards using per-row rule override
     vectors `(ov_rule[b], ov_call[b], ov_score[b], ov_disabled[b])`.
     This evaluates **all candidate calls for 500+ rules across 5,000 boards
     in ~20-30 seconds per pass** on a Colab GPU.
  3. Strict 3-way split (Train / Validation / Held-Out Test):
     - Candidate rule edits are proposed on Train (`B_train = 5,000` boards).
     - Each proposed edit is verified out-of-fold on Validation (`B_val = 2,500`
       boards) and greedily accepted only if it improves Validation and Train.
     - The resulting `.dsl` file is evaluated once on the untouched Held-Out
       Test split (`B_test = 2,500` boards + `colab_bundle_500.pt`).
"""
from __future__ import annotations

import argparse
import math
import os
import re
import sys
import time
from typing import Dict, List, Optional, Tuple

import torch

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if os.path.join(REPO_ROOT, "src") not in sys.path:
    sys.path.insert(0, os.path.join(REPO_ROOT, "src"))
if os.path.join(REPO_ROOT, "research") not in sys.path:
    sys.path.insert(0, os.path.join(REPO_ROOT, "research"))

import gpu_arena as ga  # noqa: E402
from bid.eval_vs_dds import load_decision_net_dsl  # noqa: E402


def slice_bundle(bundle: ga.DealBundle, indices: torch.Tensor) -> ga.DealBundle:
    """Return a sub-bundle for the given 1D board index tensor."""
    return ga.DealBundle(
        bundle.hand_features[indices],
        bundle.dealers[indices],
        bundle.vulns[indices],
        bundle.dd_tricks[indices],
        bundle.suit_lengths[indices],
        bundle.suit_has_king[indices],
        bundle.suit_has_queen[indices],
        bundle.suit_stopper_q[indices],
        bundle.ace_counts[indices],
        bundle.suit_intermediates[indices],
    )


def candidate_calls_for_rule(old_call: int, allow_doubles: bool = False) -> List[int]:
    """Return plausible candidate modifications for a rule currently emitting `old_call`.

    Includes:
      - `-1`: ablate/disable the rule (fall through to lower-priority rules)
      - `0`: `PASS`
      - `36`: `X` (only if `allow_doubles=True`)
      - All 5 strains within +/- 1 level of `old_call`'s level (or levels 1..4 if PASS/X)
      - Same strain across levels 1..6
    """
    cands = {-1, ga.IDX_PASS}
    if allow_doubles:
        cands.add(ga.IDX_X)
    if 1 <= old_call <= 35:
        old_lvl = (old_call - 1) // 5 + 1
        old_st = (old_call - 1) % 5
        for lvl in range(max(1, old_lvl - 1), min(7, old_lvl + 2)):
            for st in range(5):
                cands.add((lvl - 1) * 5 + 1 + st)
        for lvl in range(1, 7):
            cands.add((lvl - 1) * 5 + 1 + old_st)
    else:
        for lvl in range(1, 5):
            for st in range(5):
                cands.add((lvl - 1) * 5 + 1 + st)
    cands.discard(old_call)
    return sorted(cands)


def record_baseline_and_active_rules(
    bundle: ga.DealBundle,
    cand_net: ga.TensorDecisionNet,
    opp_net: ga.TensorDecisionNet,
) -> Tuple[torch.Tensor, torch.Tensor, torch.Tensor]:
    """Play baseline Table 1 (cand NS vs opp EW) and Table 2 (opp NS vs cand EW)
    and record which boards each rule `r` in `cand_net` could influence.

    Returns `(s1, s2, active_board_mask)` where `active_board_mask` has shape `(B, R)`.
    """
    B = bundle.num_boards
    R = cand_net.num_rules
    dev = bundle.hand_features.device
    active_mask = torch.zeros((B, R), dtype=torch.bool, device=dev)

    def _run_table(cand_is_ns: bool) -> torch.Tensor:
        env = ga.BatchedAuctionEnv(bundle)
        env.passes_since_last_np = torch.zeros(B, dtype=torch.long, device=dev)
        for _ in range(20):
            if bool(env.done.all().item()):
                break
            X, seat = env.build_features()
            lmask = env.legal_mask(seat)
            is_ns = (seat % 2) == 0
            cand_turn = is_ns if cand_is_ns else (~is_ns)

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
            turn_active = (cand_turn & (~env.done))[:, None] & could_matter
            active_mask.logical_or_(turn_active)

            if cand_net is opp_net:
                calls = cand_calls
            else:
                _, opp_calls = opp_net.call_scores(X, lmask)
                calls = torch.where(cand_turn, cand_calls, opp_calls)
            env.step(calls)
        return env.terminal_ns_scores()

    s1 = _run_table(cand_is_ns=True)
    s2 = _run_table(cand_is_ns=False)
    return s1, s2, active_mask


def run_packed_override_batch(
    base_bundle: ga.DealBundle,
    cand_net: ga.TensorDecisionNet,
    opp_net: ga.TensorDecisionNet,
    board_idx: torch.Tensor,
    ov_rule: torch.Tensor,
    ov_call: torch.Tensor,
    ov_score: torch.Tensor,
    ov_disabled: torch.Tensor,
) -> Tuple[torch.Tensor, torch.Tensor]:
    """Run Table 1 and Table 2 on a packed mega-batch of `(board_idx, ov_rule, ov_call)` rows."""
    sub = slice_bundle(base_bundle, board_idx)
    B_tot = sub.num_boards
    dev = sub.hand_features.device
    R = cand_net.num_rules
    b_arange = torch.arange(B_tot, device=dev)

    def _select_with_override(X: torch.Tensor, lmask: torch.Tensor) -> torch.Tensor:
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

        r_matched_ov = pos_matched[b_arange, ov_rule]
        r_veto_ov = vetoed_calls[b_arange, ov_call]
        r_legal_ov = lmask[b_arange, ov_call]
        valid_pos[b_arange, ov_rule] = (
            r_matched_ov & (~ov_disabled) & (~r_veto_ov) & r_legal_ov
        )

        NEG_INF = -1e9
        scores = cand_net.rule_score[None, :].expand(B_tot, R).clone()
        scores[b_arange, ov_rule] = ov_score
        masked_scores = torch.where(valid_pos, scores, torch.full_like(scores, NEG_INF))

        max_score, best_r = masked_scores.max(dim=1)
        has_match = max_score > (NEG_INF / 2)
        base_chosen = cand_net.rule_call[best_r]
        chosen = torch.where(best_r == ov_rule, ov_call, base_chosen)
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
            cand_calls_out = _select_with_override(X, lmask)
            _, opp_calls_out = opp_net.call_scores(X, lmask)
            calls = torch.where(cand_turn, cand_calls_out, opp_calls_out)
            env.step(calls)
        return env.terminal_ns_scores()

    return _run_table(cand_is_ns=True), _run_table(cand_is_ns=False)


def scan_rules_mega_batched(
    tr_bundle: ga.DealBundle,
    cand_net: ga.TensorDecisionNet,
    opp_net: ga.TensorDecisionNet,
    tr_active: torch.Tensor,
    tr_imps: torch.Tensor,
    scan_rules: List[Tuple[int, int]],
    rule_ids: List[str],
    min_train_imp_gain: float,
    min_train_t: float,
    max_batch_rows: int = 8192,
) -> List[Tuple[float, float, int, int, int]]:
    """Evaluate all candidate modifications for `scan_rules` packed into mega-batches."""
    dev = tr_bundle.hand_features.device
    lex_ranks = ga.CALL_LEX_RANK

    # Build task descriptors: (r_i, c_id, b_indices)
    tasks: List[Tuple[int, int, torch.Tensor]] = []
    for _cnt, r_i in scan_rules:
        b_indices = torch.where(tr_active[:, r_i])[0]
        old_c = int(cand_net.rule_call[r_i].item())
        cands = candidate_calls_for_rule(old_c, allow_doubles=False)
        for c_id in cands:
            tasks.append((r_i, c_id, b_indices))

    proposals_by_rule: Dict[int, Tuple[float, float, int, int, int]] = {}

    idx = 0
    num_tasks = len(tasks)
    while idx < num_tasks:
        batch_b_list: List[torch.Tensor] = []
        batch_r_list: List[torch.Tensor] = []
        batch_c_list: List[torch.Tensor] = []
        batch_s_list: List[torch.Tensor] = []
        batch_d_list: List[torch.Tensor] = []
        batch_slices: List[Tuple[int, int, torch.Tensor, int, int]] = []
        cur_rows = 0

        while idx < num_tasks:
            r_i, c_id, b_indices = tasks[idx]
            m = int(b_indices.numel())
            if cur_rows > 0 and cur_rows + m > max_batch_rows:
                break
            prio = float(cand_net.rule_prio[r_i].item())
            if c_id < 0:
                c_val = ga.IDX_PASS
                s_val = -1e9
                d_val = True
            else:
                c_val = c_id
                s_val = prio * 64.0 - float(lex_ranks[c_id])
                d_val = False

            batch_b_list.append(b_indices)
            batch_r_list.append(torch.full((m,), r_i, dtype=torch.long, device=dev))
            batch_c_list.append(torch.full((m,), c_val, dtype=torch.long, device=dev))
            batch_s_list.append(torch.full((m,), s_val, dtype=torch.float32, device=dev))
            batch_d_list.append(torch.full((m,), d_val, dtype=torch.bool, device=dev))
            batch_slices.append((r_i, c_id, b_indices, cur_rows, cur_rows + m))
            cur_rows += m
            idx += 1

        b_cat = torch.cat(batch_b_list)
        r_cat = torch.cat(batch_r_list)
        c_cat = torch.cat(batch_c_list)
        s_cat = torch.cat(batch_s_list)
        d_cat = torch.cat(batch_d_list)

        s1_out, s2_out = run_packed_override_batch(
            tr_bundle, cand_net, opp_net, b_cat, r_cat, c_cat, s_cat, d_cat
        )
        imps_out = ga.points_to_imps_tensor(s1_out - s2_out).to(torch.float32)
        base_out = tr_imps[b_cat]
        diff_out = imps_out - base_out

        for r_i, c_id, b_indices, st, en in batch_slices:
            diff_vec = diff_out[st:en]
            gain = float(diff_vec.sum().item())
            if gain < min_train_imp_gain:
                continue
            cnt = en - st
            changed = int((diff_vec.abs() > 0).sum().item())
            if changed < 3:
                continue
            mean_d = gain / cnt
            sd_d = float(diff_vec.std(unbiased=True).item()) if cnt > 1 else 0.0
            se_d = sd_d / math.sqrt(cnt) if cnt > 0 else 0.0
            t_val = (mean_d / se_d) if se_d > 1e-6 else 0.0
            if t_val < min_train_t:
                continue
            prev = proposals_by_rule.get(r_i)
            if prev is None or gain > prev[0]:
                proposals_by_rule[r_i] = (gain, t_val, r_i, c_id, cnt)

    proposals = list(proposals_by_rule.values())
    proposals.sort(reverse=True)
    return proposals


def apply_edits_to_dsl_file(
    src_dsl_path: str,
    dst_dsl_path: str,
    rule_id_to_new_call: Dict[str, Optional[str]],
) -> Tuple[int, int]:
    """Rewrite `src_dsl_path` -> `dst_dsl_path` applying retargets and ablations.

    Supports both multi-line (`RULE <id>:\\n  CALL: <call>`) and single-line
    (`RULE <id> <call>`) DSL formats.
    """
    with open(src_dsl_path, "r") as f:
        lines = f.readlines()

    out_lines: List[str] = []
    i = 0
    n_retarget = 0
    n_ablate = 0
    cur_rid: Optional[str] = None
    block_header_re = re.compile(r"^\s*RULE\s+(\S+?):\s*$")
    inline_header_re = re.compile(r"^(\s*RULE\s+)(\S+)(\s+)(~?\S+)(\s+.*)?$")

    while i < len(lines):
        line = lines[i]
        stripped = line.rstrip("\n")
        m_block = block_header_re.match(stripped)
        if m_block:
            rid = m_block.group(1)
            if rid in rule_id_to_new_call and rule_id_to_new_call[rid] is None:
                # Ablate entire multi-line RULE block
                n_ablate += 1
                i += 1
                while i < len(lines) and lines[i].strip() and not lines[i].lstrip().startswith("RULE "):
                    i += 1
                continue
            cur_rid = rid
            out_lines.append(line)
            i += 1
            continue

        if cur_rid in rule_id_to_new_call and line.lstrip().startswith("CALL:"):
            new_call = rule_id_to_new_call[cur_rid]
            if new_call is not None:
                n_retarget += 1
                out_lines.append(f"  CALL: {new_call}\n")
                cur_rid = None
                i += 1
                continue

        m_inline = inline_header_re.match(stripped)
        if m_inline and not stripped.endswith(":") and m_inline.group(2) in rule_id_to_new_call:
            rid = m_inline.group(2)
            new_call = rule_id_to_new_call[rid]
            if new_call is None:
                n_ablate += 1
                i += 1
                while i < len(lines) and lines[i].strip() and not lines[i].lstrip().startswith("RULE "):
                    i += 1
                continue
            else:
                n_retarget += 1
                prefix, _, mid, _, suffix = m_inline.groups()
                suffix = suffix or ""
                out_lines.append(f"{prefix}{rid}{mid}{new_call}{suffix}\n")
                i += 1
                continue

        out_lines.append(line)
        i += 1

    os.makedirs(os.path.dirname(dst_dsl_path) or ".", exist_ok=True)
    with open(dst_dsl_path, "w") as f:
        f.writelines(out_lines)
    return n_retarget, n_ablate


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--base-dsl", default="system/brill_distilled_shipdd.dsl")
    ap.add_argument("--opp-dsl", default="system/brill_distilled_shipdd.dsl",
                    help="Opponent DSL used during self/head-to-head evolution")
    ap.add_argument("--transfer-dsl", default="system/champion_system.dsl",
                    help="Third-party opponent DSL required not to regress on Validation")
    ap.add_argument("--out-dsl", default="system/brill_gpu_evolved.dsl")
    ap.add_argument("--bundle", default="data/colab_bundle_10k.pt")
    ap.add_argument("--extra-test-bundle", default="data/colab_bundle_500.pt")
    ap.add_argument("--train-boards", type=int, default=5000)
    ap.add_argument("--val-boards", type=int, default=2500)
    ap.add_argument("--min-active", type=int, default=5,
                    help="Minimum active boards in Train to consider editing a rule")
    ap.add_argument("--max-rules-per-pass", type=int, default=800,
                    help="Max most-active rules to scan per coordinate-ascent pass")
    ap.add_argument("--passes", type=int, default=3,
                    help="Number of coordinate-ascent passes")
    ap.add_argument("--min-train-imp-gain", type=float, default=10.0,
                    help="Minimum total IMP gain on Train to propose a candidate")
    ap.add_argument("--min-train-t", type=float, default=1.30,
                    help="Minimum paired t-statistic on active Train boards")
    args = ap.parse_args()

    dev = ga.pick_device()
    print(f"=== GPU BIDDING SYSTEM EVOLUTION [{dev}] ===")
    if dev.type == "cuda":
        print(f"GPU: {torch.cuda.get_device_name(0)}")

    full_bundle = ga.DealBundle.load(args.bundle, device=dev)
    N = full_bundle.num_boards
    n_tr = min(args.train_boards, N // 2)
    n_val = min(args.val_boards, (N - n_tr) // 2)
    n_te = N - n_tr - n_val

    tr_bundle = slice_bundle(full_bundle, torch.arange(0, n_tr, device=dev))
    val_bundle = slice_bundle(full_bundle, torch.arange(n_tr, n_tr + n_val, device=dev))
    te_bundle = slice_bundle(full_bundle, torch.arange(n_tr + n_val, N, device=dev))
    print(f"Dataset split: Train={n_tr} | Val={n_val} | Held-Out Test={n_te} boards")

    py_net = load_decision_net_dsl(args.base_dsl)
    rule_ids = [r.rule_id for r in py_net.rules]

    cand_net = ga.TensorDecisionNet(py_net, device=dev)
    cand_net.name = "brill_gpu_evolved"
    opp_net = ga.TensorDecisionNet.from_dsl(args.opp_dsl, device=dev)
    opp_net.name = os.path.splitext(os.path.basename(args.opp_dsl))[0]
    dist_net = ga.TensorDecisionNet.from_dsl("system/brill_distilled.dsl", device=dev)
    dist_net.name = "brill_distilled"
    shipdd_net = ga.TensorDecisionNet.from_dsl("system/brill_distilled_shipdd.dsl", device=dev)
    shipdd_net.name = "brill_distilled_shipdd"
    transfer_net = (
        ga.TensorDecisionNet.from_dsl(args.transfer_dsl, device=dev)
        if args.transfer_dsl and os.path.exists(args.transfer_dsl)
        else None
    )

    for split_name, sb in [("Train", tr_bundle), ("Val", val_bundle), ("Test", te_bundle)]:
        res = ga.gpu_team_match(sb, cand_net, dist_net)
        print(
            f"Initial [{split_name:5s}] vs brill_distilled: "
            f"{res['mean']:+.4f} IMP/bd (se {res['se']:.4f}, t {res['t']:+.2f}, total {res['total']:+d} IMP)"
        )

    edits: Dict[str, Optional[str]] = {}
    t_start = time.perf_counter()

    for p_idx in range(args.passes):
        t_p0 = time.perf_counter()
        tr_s1, tr_s2, tr_active = record_baseline_and_active_rules(tr_bundle, cand_net, opp_net)
        tr_imps = ga.points_to_imps_tensor(tr_s1 - tr_s2).to(torch.float32)

        active_counts = tr_active.sum(dim=0)  # (R,)
        eligible_rules: List[Tuple[int, int]] = []
        for r_i in range(cand_net.num_rules):
            if bool(cand_net.rule_neg[r_i].item()):
                continue
            rid = rule_ids[r_i]
            if rid == "BD_default_pass":
                continue
            cnt = int(active_counts[r_i].item())
            if cnt >= args.min_active:
                eligible_rules.append((cnt, r_i))
        eligible_rules.sort(reverse=True)
        scan_rules = eligible_rules[: args.max_rules_per_pass]

        print(
            f"\n--- Pass {p_idx + 1}/{args.passes}: mega-batch scanning {len(scan_rules)} active rules "
            f"(>= {args.min_active} boards) on {n_tr} Train boards ---"
        )

        proposals = scan_rules_mega_batched(
            tr_bundle,
            cand_net,
            opp_net,
            tr_active,
            tr_imps,
            scan_rules,
            rule_ids,
            args.min_train_imp_gain,
            args.min_train_t,
        )
        print(
            f"  Found {len(proposals)} Train proposals (>= +{args.min_train_imp_gain:.0f} IMP, "
            f"t >= {args.min_train_t:.2f}) in {time.perf_counter() - t_p0:.1f}s. "
            f"Validating on {n_val} Val boards..."
        )

        val_s1, val_s2, val_active = record_baseline_and_active_rules(val_bundle, cand_net, opp_net)
        val_imps = ga.points_to_imps_tensor(val_s1 - val_s2).to(torch.float32)
        if transfer_net is not None:
            val_s1_trf, val_s2_trf, val_active_trf = record_baseline_and_active_rules(val_bundle, cand_net, transfer_net)
            val_imps_trf = ga.points_to_imps_tensor(val_s1_trf - val_s2_trf).to(torch.float32)
        else:
            val_active_trf = None
            val_imps_trf = None
        cur_tr_total = float(tr_imps.sum().item())
        cur_val_total = float(val_imps.sum().item())
        accepted_this_pass = 0

        for train_gain, train_t, r_i, new_c, cnt in proposals:
            rid = rule_ids[r_i]
            old_c = int(cand_net.rule_call[r_i].item())
            old_score = float(cand_net.rule_score[r_i].item())
            prio = float(cand_net.rule_prio[r_i].item())

            b_tr_idx = torch.where(tr_active[:, r_i])[0]
            b_val_idx = torch.where(val_active[:, r_i])[0]
            if b_tr_idx.numel() == 0:
                continue

            if new_c < 0:
                cand_net.rule_score[r_i] = -1e9
            else:
                cand_net.rule_call[r_i] = new_c
                cand_net.rule_score[r_i] = prio * 64.0 - float(ga.CALL_LEX_RANK[new_c])

            sub_tr_b = slice_bundle(tr_bundle, b_tr_idx)
            _, s1_tr_sub = ga.play_boards_batched(sub_tr_b, cand_net, opp_net)
            _, s2_tr_sub = ga.play_boards_batched(sub_tr_b, opp_net, cand_net)
            new_tr_sub_imps = ga.points_to_imps_tensor(s1_tr_sub - s2_tr_sub).to(torch.float32)
            d_tr = float((new_tr_sub_imps - tr_imps[b_tr_idx]).sum().item())

            if b_val_idx.numel() > 0:
                sub_val_b = slice_bundle(val_bundle, b_val_idx)
                _, s1_val_sub = ga.play_boards_batched(sub_val_b, cand_net, opp_net)
                _, s2_val_sub = ga.play_boards_batched(sub_val_b, opp_net, cand_net)
                new_val_sub_imps = ga.points_to_imps_tensor(s1_val_sub - s2_val_sub).to(torch.float32)
                d_val = float((new_val_sub_imps - val_imps[b_val_idx]).sum().item())
            else:
                new_val_sub_imps = None
                d_val = 0.0

            d_trf = 0.0
            new_trf_sub_imps = None
            b_trf_idx = torch.where(val_active_trf[:, r_i])[0] if val_active_trf is not None else torch.empty(0, dtype=torch.long, device=dev)
            if transfer_net is not None and b_trf_idx.numel() > 0:
                sub_trf_b = slice_bundle(val_bundle, b_trf_idx)
                _, s1_trf_sub = ga.play_boards_batched(sub_trf_b, cand_net, transfer_net)
                _, s2_trf_sub = ga.play_boards_batched(sub_trf_b, transfer_net, cand_net)
                new_trf_sub_imps = ga.points_to_imps_tensor(s1_trf_sub - s2_trf_sub).to(torch.float32)
                d_trf = float((new_trf_sub_imps - val_imps_trf[b_trf_idx]).sum().item())

            accept = (d_tr >= args.min_train_imp_gain * 0.6) and (d_val > 0.0) and (d_trf >= 0.0)
            if accept:
                tr_imps[b_tr_idx] = new_tr_sub_imps
                if new_val_sub_imps is not None:
                    val_imps[b_val_idx] = new_val_sub_imps
                if new_trf_sub_imps is not None and val_imps_trf is not None:
                    val_imps_trf[b_trf_idx] = new_trf_sub_imps
                cur_tr_total += d_tr
                cur_val_total += d_val
                accepted_this_pass += 1
                old_str = ga.CALL_NAMES[old_c]
                new_str = "ABLATE" if new_c < 0 else ga.CALL_NAMES[new_c]
                edits[rid] = None if new_c < 0 else new_str
                print(
                    f"    [ACCEPT] {rid:24s} ({old_str:4s} -> {new_str:6s}) | "
                    f"Train: {d_tr:+6.1f} IMP (t={train_t:+.2f}, n={cnt:3d}) | "
                    f"Val: {d_val:+6.1f} IMP | Trf: {d_trf:+6.1f} IMP"
                )
                if accepted_this_pass % 8 == 0:
                    tr_s1, tr_s2, tr_active = record_baseline_and_active_rules(tr_bundle, cand_net, opp_net)
                    tr_imps = ga.points_to_imps_tensor(tr_s1 - tr_s2).to(torch.float32)
                    val_s1, val_s2, val_active = record_baseline_and_active_rules(val_bundle, cand_net, opp_net)
                    val_imps = ga.points_to_imps_tensor(val_s1 - val_s2).to(torch.float32)
                    if transfer_net is not None:
                        val_s1_trf, val_s2_trf, val_active_trf = record_baseline_and_active_rules(val_bundle, cand_net, transfer_net)
                        val_imps_trf = ga.points_to_imps_tensor(val_s1_trf - val_s2_trf).to(torch.float32)
                    cur_tr_total = float(tr_imps.sum().item())
                    cur_val_total = float(val_imps.sum().item())
            else:
                cand_net.rule_call[r_i] = old_c
                cand_net.rule_score[r_i] = old_score

        print(
            f"  Pass {p_idx + 1} accepted {accepted_this_pass} edits "
            f"(Train vs {opp_net.name}: {cur_tr_total:+.0f} IMP [{cur_tr_total/n_tr:+.4f}/bd], "
            f"Val vs {opp_net.name}: {cur_val_total:+.0f} IMP [{cur_val_total/n_val:+.4f}/bd])"
        )
        if accepted_this_pass == 0:
            break

    n_ret, n_abl = apply_edits_to_dsl_file(args.base_dsl, args.out_dsl, edits)
    print(f"\nExported {args.out_dsl} ({n_ret} rules retargeted, {n_abl} rules ablated) in {time.perf_counter()-t_start:.1f}s")

    reloaded_net = ga.TensorDecisionNet.from_dsl(args.out_dsl, device=dev)
    reloaded_net.name = "brill_gpu_evolved"
    champ_net = ga.TensorDecisionNet.from_dsl("system/champion_system.dsl", device=dev)
    champ_net.name = "champion_system"

    print("\n=== FINAL EVALUATION (RELOADED .DSL FROM DISK) ===")
    for split_name, sb in [("Train (5000)", tr_bundle), ("Val (2500)", val_bundle), ("Held-Out Test (2500)", te_bundle)]:
        r_vs_dist = ga.gpu_team_match(sb, reloaded_net, dist_net)
        r_vs_shipdd = ga.gpu_team_match(sb, reloaded_net, shipdd_net)
        r_vs_champ = ga.gpu_team_match(sb, reloaded_net, champ_net)
        base_vs_champ = ga.gpu_team_match(sb, shipdd_net, champ_net)
        print(f"  [{split_name}]")
        print(
            f"    vs {dist_net.name:22s}: {r_vs_dist['mean']:+.4f} IMP/bd "
            f"(se {r_vs_dist['se']:.4f}, t {r_vs_dist['t']:+.2f}, total {r_vs_dist['total']:+d} IMP, "
            f"W/L/T {r_vs_dist['wins']}/{r_vs_dist['losses']}/{r_vs_dist['ties']})"
        )
        print(
            f"    vs {shipdd_net.name:22s}: {r_vs_shipdd['mean']:+.4f} IMP/bd "
            f"(se {r_vs_shipdd['se']:.4f}, t {r_vs_shipdd['t']:+.2f}, total {r_vs_shipdd['total']:+d} IMP, "
            f"W/L/T {r_vs_shipdd['wins']}/{r_vs_shipdd['losses']}/{r_vs_shipdd['ties']})"
        )
        print(
            f"    vs {champ_net.name:22s}: {r_vs_champ['mean']:+.4f} IMP/bd "
            f"(se {r_vs_champ['se']:.4f}, t {r_vs_champ['t']:+.2f}) "
            f"[shipdd vs champ: {base_vs_champ['mean']:+.4f} IMP/bd]"
        )

    if args.extra_test_bundle and os.path.exists(args.extra_test_bundle):
        b500 = ga.DealBundle.load(args.extra_test_bundle, device=dev)
        r500_dist = ga.gpu_team_match(b500, reloaded_net, dist_net)
        r500_ship = ga.gpu_team_match(b500, reloaded_net, shipdd_net)
        print("  [Seed-7 Bundle (500)]")
        print(
            f"    vs {dist_net.name:22s}: {r500_dist['mean']:+.4f} IMP/bd "
            f"(se {r500_dist['se']:.4f}, t {r500_dist['t']:+.2f}, total {r500_dist['total']:+d} IMP)"
        )
        print(
            f"    vs {shipdd_net.name:22s}: {r500_ship['mean']:+.4f} IMP/bd "
            f"(se {r500_ship['se']:.4f}, t {r500_ship['t']:+.2f}, total {r500_ship['total']:+d} IMP)"
        )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
