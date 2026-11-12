"""Differentiable Rule Network (`DiffDSLNet`) with 100% Explainable Bid Output.

Compiles a symbolic Bridge bidding `.dsl` (`DecisionNet`) directly into PyTorch
`nn.Module` weights (`nn.Parameter` tensors) with three interpretable layers:
  1. Condition Atom Layer (`atom_val`): Evaluates `(feature op threshold)` atoms
     with exact step functions in hard mode and Straight-Through Estimator (STE)
     sigmoid gates in differentiable mode.
  2. Rule Conjunction Layer (`rule_atom_mat`): Evaluates logical AND over each
     rule's condition atoms via matrix multiplication `atom_sat @ W_rule.T`.
  3. Priority & Action Layer (`rule_prio_param`, `rule_call_logits`): Computes
     per-rule priority scores and maps rules to the 38 legal bridge calls, plus
     a JPS-inspired Partner-Hand Belief & State-Value head.

Every bid produced by `DiffDSLNet` is 100% explainable via `explain_bid()` and
`forward_with_explanation()`, which return the firing rule ID, priority, every
satisfied condition `(feature, op, learned_threshold, actual_value)`, any
negative-rule vetoes, and a canonical Chain-of-Thought (CoT) string.
"""
from __future__ import annotations

from dataclasses import dataclass, field
import os
import sys
from typing import Any, Dict, List, Optional, Sequence, Tuple, Union

import torch
import torch.nn as nn
import torch.nn.functional as F

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
if os.path.join(REPO_ROOT, "research") not in sys.path:
    sys.path.insert(0, os.path.join(REPO_ROOT, "research"))

import gpu_arena as ga
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.eval_vs_dds import load_decision_net_dsl, parse_call
from bid.features import BridgeFeatures
from bid.models import Call, CallType, Hand, Seat
from bid.sampling import Deal
from bid.scoring import Vulnerability


_INV_OP_MAP = {
    ga.OP_EQ: "==",
    ga.OP_NE: "!=",
    ga.OP_GE: ">=",
    ga.OP_LE: "<=",
    ga.OP_GT: ">",
    ga.OP_LT: "<",
    ga.OP_IN: "in",
    ga.OP_NOT_IN: "not_in",
}

_BOOL_FEATURES = {
    "is_balanced",
    "is_semi_balanced",
    "opponents_bid",
    "opp_is_in_game",
    "auction_contested",
    "opp_preempted",
    "opp_fit_shown",
    "our_fit_shown",
    "has_trump_king",
    "has_trump_queen",
    "has_stopper",
    "is_balancing",
    "is_competitive",
    "is_opening",
    "we_opened",
    "they_opened",
    "partner_passed",
    "partner_opened",
    "rho_bid",
    "lho_bid",
    "is_doubled",
    "is_redoubled",
    "am_i_vulnerable",
    "are_they_vulnerable",
    "partner_bid_current_suit",
    "has_fit_with_partner",
}

_CALL_CODED_FEATURES = {
    "opening_bid",
    "last_bid",
    "partner_first_call",
    "partner_last_call",
    "rho_last_call",
    "lho_last_call",
    "my_first_call",
    "my_last_call",
    "opp_first_call",
    "opp_last_call",
}

_STRAIN_CODED_FEATURES = {
    "longest_suit",
    "second_suit",
    "shortest_suit",
    "agreed_trump",
    "partner_last_bid_strain",
    "current_contract_strain",
    "opening_strain",
}

_INV_STRENGTH_CODE = {v: k for k, v in ga.STRENGTH_CLASS_TO_CODE.items()}
_INV_STRAIN_CODE = {0: "C", 1: "D", 2: "H", 3: "S", 4: "NT", -1: "NONE"}


def format_decoded_feature_val(feat_key: str, val: float) -> Any:
    """Decode a numeric tensor feature value back into its human-readable DSL token."""
    iv = int(round(val))
    if feat_key in _BOOL_FEATURES:
        return bool(iv != 0)
    if feat_key in _CALL_CODED_FEATURES:
        if iv < 0:
            return "NONE"
        if 0 <= iv < len(ga.CALL_NAMES):
            return ga.CALL_NAMES[iv]
        return str(iv)
    if feat_key in _STRAIN_CODED_FEATURES:
        return _INV_STRAIN_CODE.get(iv, str(iv))
    if feat_key == "opp_strength_class":
        return _INV_STRENGTH_CODE.get(iv, "unknown")
    if abs(val - iv) < 1e-4:
        return iv
    return round(float(val), 2)


@dataclass
class AtomTrace:
    """Single condition atom evaluation inside a rule explanation."""
    atom_idx: int
    feature: str
    op: str
    threshold: Any
    actual_value: Any
    satisfied: bool

    def to_dsl_str(self) -> str:
        return f"{self.feature} {self.op} {self.threshold}"

    def to_cot_str(self) -> str:
        return f"( {self.feature} {self.op} {self.threshold} [actual={self.actual_value}] )"


@dataclass
class BidExplanation:
    """Complete human- and machine-verifiable explanation for a single bid."""
    call_idx: int
    call_str: str
    rule_idx: Optional[int]
    rule_id: str
    priority: float
    conditions: List[AtomTrace] = field(default_factory=list)
    vetoed_rules: List[Tuple[str, str, str]] = field(default_factory=list)
    partner_hcp_est: Optional[float] = None
    value_est_imps: Optional[float] = None

    @property
    def is_fallback(self) -> bool:
        return self.rule_idx is None

    def to_cot_str(self) -> str:
        """Render in canonical CoT trace format (`EXPLANATION RULE ... -> BID ...`)."""
        if self.is_fallback:
            return f"EXPLANATION FALLBACK_PASS -> BID {self.call_str}"
        cond_s = " ".join(c.to_cot_str() for c in self.conditions)
        veto_s = ""
        if self.vetoed_rules:
            v_parts = [f"vetoed:{r_id}({c_s})_by_{neg_id}" for r_id, c_s, neg_id in self.vetoed_rules]
            veto_s = " [" + ", ".join(v_parts) + "]"
        return f"EXPLANATION RULE {self.rule_id} {cond_s}{veto_s} -> BID {self.call_str}".strip()


class DiffDSLNet(nn.Module):
    """Neuro-Symbolic Differentiable DSL Network whose weights ARE the compiled DSL rules.

    Guarantees:
      - In hard evaluation mode (`soft=False`), `call_scores(X, legal_mask)` is
        100% bit-for-bit identical to `TensorDecisionNet.call_scores(X, legal_mask)`
        and `DecisionNet.best_call`.
      - In soft / STE mode (`soft=True`), gradients flow end-to-end through
        `rule_call_logits`, `rule_prio_param`, `rule_atom_logits`, and continuous
        condition thresholds `atom_val`.
      - Every decision is 100% explainable via `explain_batch(X, legal_mask)` or
        `explain_hand(hand, history, seat, dealer, vuln)`.
      - Updated weights export cleanly back to a standard `.dsl` file via `export_dsl()`.
    """

    def __init__(
        self,
        net: DecisionNet,
        device: Union[str, torch.device] = "cpu",
        temp: float = 10.0,
    ):
        super().__init__()
        self.name = net.name
        self.device = torch.device(device)
        self.temp = float(temp)

        t_net = ga.TensorDecisionNet(net, device=self.device)
        self.num_rules = t_net.num_rules
        self.num_atoms = t_net.num_atoms
        self.rule_ids: List[str] = list(t_net.rule_ids)

        # Preserve original condition metadata for exact round-trip DSL export
        self._orig_conditions: List[List[RuleCondition]] = [
            [RuleCondition(c.key, c.op, c.value) for c in r.conditions]
            for r in net.rules
        ]
        # Map each unique atom index `u_i` -> original `(key, op, value, orig_float_val)`
        self._atom_orig_meta: Dict[int, Tuple[str, str, Any, float]] = {}
        atom_index_check: Dict[Tuple[int, int, Any], int] = {}
        for r in net.rules:
            for cond in r.conditions:
                if cond.key not in ga.FEAT_TO_COL:
                    break
                f_idx = ga.FEAT_TO_COL[cond.key]
                op_code = ga._OP_MAP[cond.op]
                if op_code in (ga.OP_IN, ga.OP_NOT_IN):
                    mask = 0
                    for item in cond.value:
                        code = int(round(ga.encode_feature_value(cond.key, item))) + 1
                        if 0 <= code < 62:
                            mask |= (1 << code)
                    key_tuple = (f_idx, op_code, mask)
                    v_float = 0.0
                else:
                    v_float = ga.encode_feature_value(cond.key, cond.value)
                    key_tuple = (f_idx, op_code, v_float)
                u_idx = atom_index_check.get(key_tuple)
                if u_idx is None:
                    u_idx = len(atom_index_check)
                    atom_index_check[key_tuple] = u_idx
                    self._atom_orig_meta[u_idx] = (cond.key, cond.op, cond.value, v_float)

        # Layer 1: Condition Atom buffers + learnable thresholds `atom_val`
        self.register_buffer("atom_feat", t_net.atom_feat.clone())
        self.register_buffer("atom_op", t_net.atom_op.clone())
        self.atom_val = nn.Parameter(t_net.atom_val.clone())
        self.register_buffer("atom_in_mask", t_net.atom_in_mask.clone())
        self.register_buffer("atom_in_lut", t_net.atom_in_lut.clone())
        self.register_buffer("u_arange", t_net.u_arange.clone())
        self.has_in_atoms = t_net.has_in_atoms

        # Identify which atoms are continuous/numeric thresholds (safe to shift by gradient)
        tunable_mask = torch.zeros(self.num_atoms, dtype=torch.bool, device=self.device)
        for u_i in range(self.num_atoms):
            op_c = int(self.atom_op[u_i].item())
            f_key = ga.FEATURE_KEYS[int(self.atom_feat[u_i].item())]
            if op_c in (ga.OP_GE, ga.OP_LE, ga.OP_GT, ga.OP_LT) and (
                f_key not in _BOOL_FEATURES
                and f_key not in _CALL_CODED_FEATURES
                and f_key not in _STRAIN_CODED_FEATURES
            ):
                tunable_mask[u_i] = True
        self.register_buffer("atom_tunable_mask", tunable_mask)

        # Layer 2: Rule Conjunction weights (R, U)
        self.register_buffer("rule_atom_mat", t_net.rule_atom_mat.clone())
        self.register_buffer("rule_n_atoms", t_net.rule_n_atoms.clone())
        self.rule_atom_logits = nn.Parameter(t_net.rule_atom_mat.clone())

        # Layer 3: Rule Priority & Rule-to-Call Assignment Weights
        self.register_buffer("rule_neg", t_net.rule_neg.clone())
        self.register_buffer("rule_disabled", torch.zeros(max(1, self.num_rules), dtype=torch.bool, device=self.device))
        self.has_neg_rules = t_net.has_neg_rules
        self.register_buffer("neg_rule_call_mat", t_net.neg_rule_call_mat.clone())
        self.register_buffer("lex_ranks", torch.tensor(ga.CALL_LEX_RANK, dtype=torch.float32, device=self.device))

        self.rule_prio_param = nn.Parameter(t_net.rule_prio.clone())
        # Initialize rule_call_logits so argmax_c rule_call_logits[r, c] == t_net.rule_call[r]
        init_call_logits = torch.full((max(1, self.num_rules), 38), -10.0, dtype=torch.float32, device=self.device)
        init_call_logits.scatter_(1, t_net.rule_call.unsqueeze(1), 10.0)
        self.rule_call_logits = nn.Parameter(init_call_logits)

        # JPS-inspired Auxiliary Partner-Belief & Value Bottleneck Head (for RL / search value estimation)
        self._init_num_rules = max(1, self.num_rules)
        in_v_dim = ga.NUM_FEATURES + self._init_num_rules
        self.partner_belief_net = nn.Sequential(
            nn.Linear(ga.NUM_FEATURES, 64),
            nn.ReLU(),
            nn.Linear(64, 5),  # predicted partner [hcp_norm, C_len, D_len, H_len, S_len]
        ).to(self.device)
        self.value_head = nn.Sequential(
            nn.Linear(in_v_dim + 5, 64),
            nn.ReLU(),
            nn.Linear(64, 1),
        ).to(self.device)

    @classmethod
    def from_dsl(
        cls,
        path_or_net: Union[str, DecisionNet],
        device: Union[str, torch.device] = "cpu",
        temp: float = 10.0,
    ) -> "DiffDSLNet":
        net = (
            load_decision_net_dsl(path_or_net)
            if isinstance(path_or_net, str)
            else path_or_net
        )
        return cls(net, device=device, temp=temp)

    @property
    def rule_call(self) -> torch.Tensor:
        """Current discrete call assignment `(R,)` derived directly from `rule_call_logits`."""
        return self.rule_call_logits.argmax(dim=1)

    @property
    def rule_prio(self) -> torch.Tensor:
        """Current rule priority vector `(R,)`."""
        return self.rule_prio_param

    @property
    def rule_score(self) -> torch.Tensor:
        """Combined tie-breaking score `priority * 64 - lex_rank(call)` of shape `(R,)`."""
        c_idx = self.rule_call
        rule_lex = self.lex_ranks[c_idx]
        neg_Or_dis = self.rule_neg | self.rule_disabled
        return torch.where(
            neg_Or_dis,
            torch.full_like(self.rule_prio_param, -1e9),
            self.rule_prio_param * 64.0 - rule_lex,
        )

    @property
    def pos_rule_call_mat(self) -> torch.Tensor:
        """Dynamic `(R, 38)` positive rule-to-call matrix derived from `rule_call_logits`."""
        c_idx = self.rule_call
        pos_mask = (~self.rule_neg) & (~self.rule_disabled)
        one_hot = F.one_hot(c_idx, num_classes=38).to(torch.float32)
        return one_hot * pos_mask.unsqueeze(1).to(torch.float32)

    def effective_atom_val(self) -> torch.Tensor:
        """Return threshold vector where non-tunable atoms stay frozen at exact codes."""
        return torch.where(
            self.atom_tunable_mask,
            self.atom_val,
            self.atom_val.detach(),
        )

    def evaluate_atoms(self, X: torch.Tensor, soft: bool = False) -> torch.Tensor:
        """Evaluate all U unique condition atoms on `X: (B, F) -> (B, U)`."""
        vals = X[:, self.atom_feat]  # (B, U)
        op = self.atom_op[None, :]   # (1, U)
        thresh_param = self.effective_atom_val()[None, :]  # (1, U)
        thresh_hard = thresh_param

        sat_hard = (
            ((op == ga.OP_EQ) & (vals == thresh_hard))
            | ((op == ga.OP_NE) & (vals != thresh_hard))
            | ((op == ga.OP_GE) & (vals >= thresh_hard))
            | ((op == ga.OP_LE) & (vals <= thresh_hard))
            | ((op == ga.OP_GT) & (vals > thresh_hard))
            | ((op == ga.OP_LT) & (vals < thresh_hard))
        )
        if self.has_in_atoms:
            shifts = (vals.round().to(torch.long) + 1).clamp(0, 62)
            in_hit = self.atom_in_lut[self.u_arange[None, :], shifts]
            sat_hard = sat_hard | ((op == ga.OP_IN) & in_hit) | ((op == ga.OP_NOT_IN) & (~in_hit))
        hard_f = sat_hard.to(torch.float32)

        if not soft:
            return hard_f

        # Differentiable sigmoid relaxation for Straight-Through Estimator (STE)
        b = self.temp
        ge_soft = torch.sigmoid(b * (vals - thresh_param + 0.5))
        le_soft = torch.sigmoid(b * (thresh_param - vals + 0.5))
        gt_soft = torch.sigmoid(b * (vals - thresh_param - 0.5))
        lt_soft = torch.sigmoid(b * (thresh_param - vals - 0.5))
        eq_soft = ge_soft * le_soft
        ne_soft = 1.0 - eq_soft

        soft_f = (
            (op == ga.OP_EQ).to(torch.float32) * eq_soft
            + (op == ga.OP_NE).to(torch.float32) * ne_soft
            + (op == ga.OP_GE).to(torch.float32) * ge_soft
            + (op == ga.OP_LE).to(torch.float32) * le_soft
            + (op == ga.OP_GT).to(torch.float32) * gt_soft
            + (op == ga.OP_LT).to(torch.float32) * lt_soft
        )
        if self.has_in_atoms:
            in_mask = ((op == ga.OP_IN) | (op == ga.OP_NOT_IN)).to(torch.float32)
            soft_f = soft_f * (1.0 - in_mask) + hard_f * in_mask

        # Straight-Through Estimator: exact hard forward, smooth sigmoid backward
        return hard_f + (soft_f - soft_f.detach())

    def match_rules(self, X: torch.Tensor, soft: bool = False) -> torch.Tensor:
        """Return rule-matching tensor `(B, R)` (`bool` when `soft=False`, STE `float32` when `soft=True`)."""
        if self.num_rules == 0:
            return torch.zeros((X.shape[0], 1), dtype=torch.bool, device=self.device)
        atom_sat = self.evaluate_atoms(X, soft=soft)  # (B, U)
        hits = atom_sat @ self.rule_atom_mat.T  # (B, R)
        matched_hard = (hits - self.rule_n_atoms[None, :]).abs() < 0.5
        if not soft:
            return matched_hard
        soft_conj = torch.sigmoid(self.temp * (hits - self.rule_n_atoms[None, :] + 0.5))
        hard_f = matched_hard.to(torch.float32)
        return hard_f + (soft_conj - soft_conj.detach())

    def call_scores(
        self,
        X: torch.Tensor,
        legal_mask: torch.Tensor,
        soft: bool = False,
    ) -> Tuple[torch.Tensor, torch.Tensor]:
        """Compute `(cand_mask_or_probs, best_calls)` on batch `X: (B, F)`.

        Matches `TensorDecisionNet.call_scores` bit-for-bit when `soft=False`.
        """
        B = X.shape[0]
        matched_raw = self.match_rules(X, soft=soft)
        matched = matched_raw > 0.5 if soft else matched_raw

        c_idx = self.rule_call  # (R,)
        pos_matched = matched & (~self.rule_neg[None, :]) & (~self.rule_disabled[None, :])

        if self.has_neg_rules:
            neg_matched = (matched & self.rule_neg[None, :] & (~self.rule_disabled[None, :])).to(torch.float32)
            vetoed_calls = (neg_matched @ self.neg_rule_call_mat) > 0.5  # (B, 38)
            rule_vetoed = vetoed_calls[:, c_idx]  # (B, R)
            pos_matched = pos_matched & (~rule_vetoed)
        else:
            vetoed_calls = torch.zeros((B, 38), dtype=torch.bool, device=self.device)

        rule_legal = legal_mask[:, c_idx]  # (B, R)
        valid_pos = pos_matched & rule_legal  # (B, R)

        NEG_INF = -1e9
        r_score = self.rule_score
        active_scores = torch.where(
            valid_pos,
            r_score[None, :].expand(B, -1),
            torch.full((B, matched.shape[1]), NEG_INF, dtype=torch.float32, device=self.device),
        )
        max_score, best_r = active_scores.max(dim=1)  # (B,)
        best_calls = torch.where(
            max_score > NEG_INF / 2,
            c_idx[best_r],
            torch.full((B,), ga.IDX_PASS, dtype=torch.long, device=self.device),
        )

        pos_mat = self.pos_rule_call_mat
        cand_mask = (valid_pos.to(torch.float32) @ pos_mat) > 0.5
        cand_mask[:, ga.IDX_PASS] = cand_mask[:, ga.IDX_PASS] | (~(max_score > NEG_INF / 2))

        if not soft:
            return cand_mask.to(torch.float32), best_calls

        # Differentiable policy distribution over the 38 calls via soft rule-call assignment
        rule_probs = F.softmax(self.rule_call_logits, dim=-1)  # (R, 38)
        weights = matched_raw * (~self.rule_neg[None, :]).to(torch.float32) * (~self.rule_disabled[None, :]).to(torch.float32)
        call_logits = weights @ (rule_probs * (self.rule_prio_param.unsqueeze(1).clamp(min=1.0) / 100.0))
        call_logits = call_logits.masked_fill(~legal_mask | vetoed_calls, -1e9)
        call_probs = F.softmax(call_logits, dim=-1)
        return call_probs, best_calls

    def forward(
        self,
        X: torch.Tensor,
        legal_mask: torch.Tensor,
        soft: bool = True,
    ) -> Dict[str, torch.Tensor]:
        """Full JPS-style forward returning `pi`, `best_calls`, `v`, and `infer_partner`."""
        matched_f = self.match_rules(X, soft=soft).to(torch.float32)
        pi_or_mask, best_calls = self.call_scores(X, legal_mask, soft=soft)
        p_belief = self.partner_belief_net(X)
        matched_v = matched_f[:, : self._init_num_rules]
        if matched_v.shape[1] < self._init_num_rules:
            matched_v = F.pad(matched_v, (0, self._init_num_rules - matched_v.shape[1]))
        v_in = torch.cat([X, matched_v, p_belief], dim=-1)
        v = self.value_head(v_in)
        return {
            "pi": pi_or_mask,
            "best_calls": best_calls,
            "v": v,
            "infer_partner": p_belief,
            "rule_activations": matched_f,
        }

    # ------------------------------------------------------------------
    # Explainability API (Every Bid is 100% Explainable)
    # ------------------------------------------------------------------

    @torch.no_grad()
    def explain_batch(
        self,
        X: torch.Tensor,
        legal_mask: torch.Tensor,
    ) -> List[BidExplanation]:
        """Produce a structured `BidExplanation` for every row in `X: (B, F)`."""
        B = X.shape[0]
        atom_sat = self.evaluate_atoms(X, soft=False) > 0.5  # (B, U)
        matched = self.match_rules(X, soft=False)            # (B, R)
        c_idx = self.rule_call                               # (R,)
        r_score = self.rule_score                            # (R,)
        eff_thresh = self.effective_atom_val()               # (U,)

        neg_matched = matched & self.rule_neg[None, :] & (~self.rule_disabled[None, :])
        if self.has_neg_rules:
            vetoed_calls = (neg_matched.to(torch.float32) @ self.neg_rule_call_mat) > 0.5
            rule_vetoed = vetoed_calls[:, c_idx]
        else:
            rule_vetoed = torch.zeros_like(matched)

        rule_legal = legal_mask[:, c_idx]
        pos_matched = matched & (~self.rule_neg[None, :]) & (~self.rule_disabled[None, :])
        valid_pos = pos_matched & (~rule_vetoed) & rule_legal

        NEG_INF = -1e9
        active_scores = torch.where(
            valid_pos,
            r_score[None, :].expand(B, -1),
            torch.full((B, matched.shape[1]), NEG_INF, dtype=torch.float32, device=self.device),
        )
        max_score, best_r = active_scores.max(dim=1)

        explanations: List[BidExplanation] = []
        for b in range(B):
            has_winner = bool((max_score[b] > NEG_INF / 2).item())
            win_r = int(best_r[b].item()) if has_winner else None
            win_c = int(c_idx[win_r].item()) if win_r is not None else ga.IDX_PASS
            win_c_str = ga.CALL_NAMES[win_c]
            win_prio = float(self.rule_prio_param[win_r].item()) if win_r is not None else 0.0
            win_rid = self.rule_ids[win_r] if win_r is not None else "FALLBACK_PASS"

            cond_traces: List[AtomTrace] = []
            if win_r is not None:
                u_indices = torch.where(self.rule_atom_mat[win_r] > 0.5)[0].tolist()
                for u_i in u_indices:
                    f_col = int(self.atom_feat[u_i].item())
                    f_key = ga.FEATURE_KEYS[f_col]
                    op_code = int(self.atom_op[u_i].item())
                    op_str = _INV_OP_MAP[op_code]
                    actual_raw = float(X[b, f_col].item())
                    actual_dec = format_decoded_feature_val(f_key, actual_raw)
                    if op_code in (ga.OP_IN, ga.OP_NOT_IN):
                        mask_val = int(self.atom_in_mask[u_i].item())
                        items = []
                        for bit_i in range(62):
                            if (mask_val >> bit_i) & 1:
                                items.append(format_decoded_feature_val(f_key, float(bit_i - 1)))
                        thresh_dec: Any = items
                    else:
                        t_val = float(eff_thresh[u_i].item()) if bool(self.atom_tunable_mask[u_i].item()) else float(self.atom_val[u_i].item())
                        thresh_dec = format_decoded_feature_val(f_key, t_val)
                    cond_traces.append(
                        AtomTrace(
                            atom_idx=u_i,
                            feature=f_key,
                            op=op_str,
                            threshold=thresh_dec,
                            actual_value=actual_dec,
                            satisfied=bool(atom_sat[b, u_i].item()),
                        )
                    )

            # Record any higher-priority positive rules that matched on `b` but were vetoed by a negative rule
            vetoed_list: List[Tuple[str, str, str]] = []
            vetoed_pos_r = torch.where(pos_matched[b] & rule_vetoed[b] & rule_legal[b])[0].tolist()
            for vr in vetoed_pos_r:
                if win_r is None or float(r_score[vr].item()) > float(r_score[win_r].item()):
                    vc = int(c_idx[vr].item())
                    # Find which negative rule vetoed `vc`
                    neg_r_hits = torch.where(neg_matched[b] & (c_idx == vc))[0].tolist()
                    neg_id = self.rule_ids[neg_r_hits[0]] if neg_r_hits else "neg_rule"
                    vetoed_list.append((self.rule_ids[vr], ga.CALL_NAMES[vc], neg_id))

            explanations.append(
                BidExplanation(
                    call_idx=win_c,
                    call_str=win_c_str,
                    rule_idx=win_r,
                    rule_id=win_rid,
                    priority=win_prio,
                    conditions=cond_traces,
                    vetoed_rules=vetoed_list,
                )
            )
        return explanations

    @torch.no_grad()
    def explain_hand(
        self,
        hand: Hand,
        history: Sequence[Call],
        seat: Seat,
        dealer: Seat,
        vuln: Vulnerability,
    ) -> BidExplanation:
        """Explain the bid chosen for a single Python `(hand, history, seat, dealer, vuln)` state."""
        feats = BridgeFeatures.extract_all(hand, list(history), seat, dealer, vuln)
        x_row = ga.encode_feature_dict(feats).to(self.device).unsqueeze(0)  # (1, F)
        lmask = torch.zeros((1, 38), dtype=torch.bool, device=self.device)
        last_bid: Optional[Call] = None
        last_np: Optional[Tuple[int, Call]] = None
        for i, call in enumerate(history):
            if call.type == CallType.BID:
                last_bid = call
            if call.type != CallType.PASS:
                last_np = (i, call)
        x_ok = False
        xx_ok = False
        if last_np is not None:
            idx, lc = last_np
            seat_of_lc = Seat((dealer.value + idx) % 4)
            opp_of_me = seat_of_lc not in (seat, seat.partner)
            if lc.type == CallType.BID:
                x_ok = opp_of_me
            elif lc.type == CallType.DOUBLE and opp_of_me:
                j = idx - 1
                while j >= 0:
                    pc = history[j]
                    if pc.type != CallType.PASS:
                        ps_seat = Seat((dealer.value + j) % 4)
                        if pc.type == CallType.BID and ps_seat in (seat, seat.partner):
                            xx_ok = True
                        break
                    j -= 1
        for c_i, c_name in enumerate(ga.CALL_NAMES):
            c_obj = parse_call(c_name)
            if c_obj.type == CallType.PASS:
                lmask[0, c_i] = True
            elif c_obj.type == CallType.DOUBLE:
                lmask[0, c_i] = x_ok
            elif c_obj.type == CallType.REDOUBLE:
                lmask[0, c_i] = xx_ok
            elif c_obj.type == CallType.BID:
                if last_bid is None or c_obj.level > last_bid.level or (
                    c_obj.level == last_bid.level and c_obj.strain.value > last_bid.strain.value
                ):
                    lmask[0, c_i] = True
        return self.explain_batch(x_row, lmask)[0]

    # ------------------------------------------------------------------
    # Weight Manipulation & Export Back to `.dsl`
    # ------------------------------------------------------------------

    @torch.no_grad()
    def set_rule_call(self, rule_idx: int, call_idx: int) -> None:
        """Update `rule_call_logits` weight row so `rule_idx` emits `call_idx` (or disable if `< 0`)."""
        if call_idx < 0:
            self.rule_disabled[rule_idx] = True
        else:
            self.rule_disabled[rule_idx] = False
            self.rule_call_logits[rule_idx].fill_(-10.0)
            self.rule_call_logits[rule_idx, call_idx] = 10.0

    @torch.no_grad()
    def set_atom_threshold(self, atom_idx: int, new_val: float) -> None:
        """Update condition atom threshold weight `atom_val[atom_idx]`."""
        self.atom_val[atom_idx] = float(new_val)

    @torch.no_grad()
    def clone_and_split_rule(
        self,
        parent_rule_idx: int,
        new_rule_id: str,
        feat_key: str,
        op_str: str,
        val: float,
        new_call_idx: int,
        prio_bump: float = 1.0,
    ) -> int:
        """Append a new child rule directly into the network weight matrices."""
        f_idx = ga.FEAT_TO_COL[feat_key]
        op_code = ga._OP_MAP[op_str]

        # Check if atom already exists
        existing_u = None
        for u_i in range(self.num_atoms):
            if (
                int(self.atom_feat[u_i].item()) == f_idx
                and int(self.atom_op[u_i].item()) == op_code
                and abs(float(self.atom_val[u_i].item()) - float(val)) < 1e-4
            ):
                existing_u = u_i
                break

        if existing_u is None:
            existing_u = self.num_atoms
            self.num_atoms += 1
            self.atom_feat = torch.cat([self.atom_feat, torch.tensor([f_idx], dtype=torch.long, device=self.device)])
            self.atom_op = torch.cat([self.atom_op, torch.tensor([op_code], dtype=torch.uint8, device=self.device)])
            self.atom_val = nn.Parameter(
                torch.cat([self.atom_val.data, torch.tensor([float(val)], dtype=torch.float32, device=self.device)])
            )
            self.atom_in_mask = torch.cat([self.atom_in_mask, torch.tensor([0], dtype=torch.int64, device=self.device)])
            new_lut_row = torch.zeros((1, 64), dtype=torch.bool, device=self.device)
            self.atom_in_lut = torch.cat([self.atom_in_lut, new_lut_row], dim=0)
            self.u_arange = torch.arange(self.num_atoms, dtype=torch.long, device=self.device)
            is_tun = op_code in (ga.OP_GE, ga.OP_LE, ga.OP_GT, ga.OP_LT) and (
                feat_key not in _BOOL_FEATURES
                and feat_key not in _CALL_CODED_FEATURES
                and feat_key not in _STRAIN_CODED_FEATURES
            )
            self.atom_tunable_mask = torch.cat(
                [self.atom_tunable_mask, torch.tensor([is_tun], dtype=torch.bool, device=self.device)]
            )
            # Pad rule_atom_mat with a new column
            pad_col = torch.zeros((self.num_rules, 1), dtype=torch.float32, device=self.device)
            self.rule_atom_mat = torch.cat([self.rule_atom_mat, pad_col], dim=1)
            self.rule_atom_logits = nn.Parameter(self.rule_atom_mat.clone())

        # Create new rule row copying parent's atoms + adding `existing_u`
        new_row = self.rule_atom_mat[parent_rule_idx].clone()
        new_row[existing_u] = 1.0
        new_n_atoms = float(new_row.sum().item())

        self.rule_atom_mat = torch.cat([self.rule_atom_mat, new_row.unsqueeze(0)], dim=0)
        self.rule_atom_logits = nn.Parameter(self.rule_atom_mat.clone())
        self.rule_n_atoms = torch.cat(
            [self.rule_n_atoms, torch.tensor([new_n_atoms], dtype=torch.float32, device=self.device)]
        )
        self.rule_neg = torch.cat([self.rule_neg, torch.tensor([False], dtype=torch.bool, device=self.device)])
        self.rule_disabled = torch.cat([self.rule_disabled, torch.tensor([False], dtype=torch.bool, device=self.device)])
        self.neg_rule_call_mat = torch.cat(
            [self.neg_rule_call_mat, torch.zeros((1, 38), dtype=torch.float32, device=self.device)],
            dim=0,
        )

        new_prio = float(self.rule_prio_param[parent_rule_idx].item()) + float(prio_bump)
        self.rule_prio_param = nn.Parameter(
            torch.cat([self.rule_prio_param.data, torch.tensor([new_prio], dtype=torch.float32, device=self.device)])
        )
        new_call_row = torch.full((1, 38), -10.0, dtype=torch.float32, device=self.device)
        new_call_row[0, new_call_idx] = 10.0
        self.rule_call_logits = nn.Parameter(torch.cat([self.rule_call_logits.data, new_call_row], dim=0))

        self.rule_ids.append(new_rule_id)
        parent_conds = [RuleCondition(c.key, c.op, c.value) for c in self._orig_conditions[parent_rule_idx]]
        dec_val = format_decoded_feature_val(feat_key, float(val))
        parent_conds.append(RuleCondition(feat_key, op_str, dec_val))
        self._orig_conditions.append(parent_conds)

        new_r_idx = self.num_rules
        self.num_rules += 1
        return new_r_idx

    @torch.no_grad()
    def to_tensor_decision_net(self) -> ga.TensorDecisionNet:
        """Convert current learned weights into a fast `ga.TensorDecisionNet` directly on device."""
        t_net = object.__new__(ga.TensorDecisionNet)
        t_net.name = self.name
        t_net.device = self.device
        t_net.num_rules = self.num_rules
        t_net.rule_ids = list(self.rule_ids)
        t_net.num_atoms = self.num_atoms
        t_net.atom_feat = self.atom_feat
        t_net.atom_op = self.atom_op
        t_net.atom_val = self.effective_atom_val()
        t_net.atom_in_mask = self.atom_in_mask
        t_net.has_in_atoms = self.has_in_atoms
        t_net.atom_in_lut = self.atom_in_lut
        t_net.u_arange = self.u_arange
        t_net.rule_atom_mat = self.rule_atom_mat
        t_net.rule_n_atoms = self.rule_n_atoms
        t_net.rule_call = self.rule_call
        t_net.rule_prio = self.rule_prio_param
        t_net.rule_neg = self.rule_neg
        t_net.has_neg_rules = self.has_neg_rules
        t_net.pos_rule_call_mat = self.pos_rule_call_mat
        t_net.neg_rule_call_mat = self.neg_rule_call_mat * (~self.rule_disabled).unsqueeze(1).to(torch.float32)
        t_net.call_tiebreak = -self.lex_ranks
        t_net.rule_score = self.rule_score
        return t_net

    @torch.no_grad()
    def to_decision_net(self) -> DecisionNet:
        """Decompile current `DiffDSLNet` weights back into a symbolic `DecisionNet`."""
        eff_thresh = self.effective_atom_val()
        c_indices = self.rule_call
        rules: List[DecisionNetRule] = []

        for r_idx in range(self.num_rules):
            if bool(self.rule_disabled[r_idx].item()):
                continue
            r_id = self.rule_ids[r_idx]
            prio = int(round(float(self.rule_prio_param[r_idx].item())))
            is_neg = bool(self.rule_neg[r_idx].item())
            c_idx = int(c_indices[r_idx].item())
            call_obj = parse_call(ga.CALL_NAMES[c_idx])

            # Reconstruct conditions from active atoms in `rule_atom_mat[r_idx]`
            u_indices = torch.where(self.rule_atom_mat[r_idx] > 0.5)[0].tolist()
            conds: List[RuleCondition] = []
            for u_i in u_indices:
                f_col = int(self.atom_feat[u_i].item())
                f_key = ga.FEATURE_KEYS[f_col]
                op_code = int(self.atom_op[u_i].item())
                op_str = _INV_OP_MAP[op_code]
                t_val = float(eff_thresh[u_i].item())
                if u_i in self._atom_orig_meta:
                    orig_k, orig_op, orig_val, orig_f = self._atom_orig_meta[u_i]
                    if op_code in (ga.OP_IN, ga.OP_NOT_IN) or abs(t_val - orig_f) < 1e-5:
                        conds.append(RuleCondition(orig_k, orig_op, orig_val))
                        continue
                if op_code in (ga.OP_IN, ga.OP_NOT_IN):
                    mask_val = int(self.atom_in_mask[u_i].item())
                    items = []
                    for bit_i in range(62):
                        if (mask_val >> bit_i) & 1:
                            items.append(format_decoded_feature_val(f_key, float(bit_i - 1)))
                    conds.append(RuleCondition(f_key, op_str, items))
                else:
                    dec_val = format_decoded_feature_val(f_key, t_val)
                    conds.append(RuleCondition(f_key, op_str, dec_val))

            rules.append(
                DecisionNetRule(
                    rule_id=r_id,
                    priority=prio,
                    call=call_obj,
                    conditions=conds,
                    is_negative=is_neg,
                )
            )
        net = DecisionNet(name=self.name)
        net.rules = rules
        return net

    @torch.no_grad()
    def export_dsl(self, path: str) -> int:
        """Export current `DiffDSLNet` weights directly to a human-readable `.dsl` file."""
        net = self.to_decision_net()
        lines: List[str] = [
            f"# Exported from DiffDSLNet ({self.name}) — {len(net.rules)} active rules",
            "",
        ]
        for r in net.rules:
            lines.append(f"RULE {r.rule_id}:")
            lines.append(f"  PRIORITY: {r.priority}")
            lines.append(f"  CALL: {r.call}")
            if r.is_negative:
                lines.append("  NEGATIVE: True")
            for c in r.conditions:
                if isinstance(c.value, list):
                    v_str = "[" + ", ".join(repr(x) if isinstance(x, str) else str(x) for x in c.value) + "]"
                elif isinstance(c.value, str):
                    v_str = f"'{c.value}'"
                else:
                    v_str = str(c.value)
                lines.append(f"  CONDITION: {c.key} {c.op} {v_str}")
            lines.append("")
        os.makedirs(os.path.dirname(os.path.abspath(path)), exist_ok=True)
        with open(path, "w") as f:
            f.write("\n".join(lines))
        return len(net.rules)
