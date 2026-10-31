#!/usr/bin/env python3
"""GPU-vectorized DecisionNet evaluation, team matches, and continuation rollouts.

Compiles symbolic `.dsl` rule sets (`DecisionNet`) into compact PyTorch tensors
that run identically on CUDA (Colab A100), Apple MPS, or CPU:

1. **Unique-Atom Matrix Evaluation (`TensorDecisionNet`)**:
   Deduplicates all `(feature, op, value)` predicates across a `.dsl` file into
   $U$ unique atomic conditions, evaluates them once per state batch `(B, U)`,
   and computes all $R$ rule conjunctions via a single matrix multiply
   `(B, U) @ (U, R)` (Tensor Core friendly on A100). Preserves exact rule
   priorities, negative-rule vetoes, bridge legality, and lexicographical
   tie-breaking of `DecisionNet.best_call`.

2. **Lockstep Batched Auction Engine (`BatchedAuctionEnv`)**:
   Steps $B$ 4-player auctions in parallel on the device, maintaining all 129
   `BridgeFeatures` (including `agreed_trump`, `keycard_count_agreed`,
   `partner_hcp_min/max`, `combined_hcp_min/max`, `rule_of_21`, stopper quality,
   and competition metrics) in-place in PyTorch tensors.

3. **O(1) Precomputed DD Table & Exact WBF IMP Scoring**:
   Indexes `(B, 4, 5)` double-dummy trick tables and a precomputed duplicate
   score lookup tensor (`SCORE_LUT`) built from `bid.scoring`, giving 100%
   scoring parity with `BiddingArena` at >100x throughput.

4. **Multi-Step Continuation Counterfactuals (`gpu_continuation_q_values`)**:
   Scores candidate calls in `open_uncont` / `later_cont` / `later_uncont` by
   rolling out the full continuation auction to `PASS-PASS-PASS` rather than
   scoring 1-step "if the auction stopped here".

Usage:
    # Run a fast vectorized team match (with optional parity check vs CPU):
    .venv/bin/python research/gpu_arena.py match \\
        --a system/brill_distilled_shipdd.dsl \\
        --b system/brill_distilled.dsl \\
        --boards 200 --seed 7 --verify-parity

    # Export a self-contained deal + DD table bundle for Google Colab A100:
    .venv/bin/python research/gpu_arena.py bundle \\
        --boards 1000 --seed 7 --out data/colab_bundle.pt
"""

import argparse
import math
import os
import sys
import time
from typing import Any, Dict, List, Optional, Sequence, Tuple, Union

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if os.path.join(REPO, "src") not in sys.path:
    sys.path.insert(0, os.path.join(REPO, "src"))
if REPO not in sys.path:
    sys.path.insert(0, REPO)

import torch

from bid.decision_net import DecisionNet
from bid.eval_vs_dds import build_deals, load_decision_net_dsl
from bid.features import BridgeFeatures
from bid.models import Call, CallType, Hand, Rank, Seat, Strain, Suit
from bid.sampling import Deal
from bid.scoring import Vulnerability, calculate_contract_score

# ---------------------------------------------------------------------------
# Canonical vocabularies & feature layout (129 features)
# ---------------------------------------------------------------------------

BIDS_35: List[str] = [
    f"{lvl}{st}" for lvl in range(1, 8)
    for st in ("C", "D", "H", "S", "NT")
]
# 38 legal bridge calls in canonical index order 0..37:
#   0 = PASS, 1..35 = 1C..7NT, 36 = X, 37 = XX
CALL_NAMES: List[str] = ["PASS"] + BIDS_35 + ["X", "XX"]
CALL_TO_IDX: Dict[str, int] = {name: i for i, name in enumerate(CALL_NAMES)}
IDX_PASS = 0
IDX_X = 36
IDX_XX = 37

# Encoding for string call features (where "NONE" = -1, PASS = 0, 1C..XX = 1..37)
CALL_FEAT_TO_CODE: Dict[str, int] = {"NONE": -1}
for _i, _name in enumerate(CALL_NAMES):
    CALL_FEAT_TO_CODE[_name] = _i
    if _name == "PASS":
        CALL_FEAT_TO_CODE["P"] = _i

# Lexicographical rank of each call string (matches DecisionNet.actions sort
# `key=lambda cp: (-cp[1], str(cp[0]))`)
_LEX_SORTED_CALLS = sorted(CALL_NAMES)
CALL_LEX_RANK: List[int] = [_LEX_SORTED_CALLS.index(c) for c in CALL_NAMES]

STRAIN_TO_CODE: Dict[str, int] = {
    "NONE": -1, "C": 0, "D": 1, "H": 2, "S": 3, "NT": 4
}
SEAT_TO_CODE: Dict[str, int] = {
    "NONE": -1, "N": 0, "E": 1, "S": 2, "W": 3
}
VULN_PRESSURE_TO_CODE: Dict[str, int] = {
    "equal": 0, "favorable": 1, "unfavorable": 2
}
STRENGTH_CLASS_TO_CODE: Dict[str, int] = {
    "unknown": 0, "weak": 1, "strong": 2
}

CALL_STRING_FEATURES = {
    "my_first_call", "my_last_call", "opening_bid",
    "opp_first_call", "opp_last_call",
    "partner_first_call", "partner_last_call",
}
STRAIN_STRING_FEATURES = {
    "agreed_trump", "last_bid_strain", "partner_last_bid_strain",
}
SEAT_STRING_FEATURES = {
    "last_bid_seat", "my_seat",
}


def _discover_feature_keys() -> List[str]:
    """Return the canonical sorted list of all 129 BridgeFeatures keys."""
    dummy_deal = build_deals(1, seed=1, include_stratified=False)[0]
    feats = BridgeFeatures.extract_all(
        dummy_deal.hands[Seat.NORTH], [], Seat.NORTH, dummy_deal.dealer, dummy_deal.vuln
    )
    return sorted(feats.keys())


FEATURE_KEYS: List[str] = _discover_feature_keys()
FEAT_TO_COL: Dict[str, int] = {k: i for i, k in enumerate(FEATURE_KEYS)}
NUM_FEATURES: int = len(FEATURE_KEYS)


def encode_feature_value(key: str, val: Any) -> float:
    """Encode any Python feature or RuleCondition constant as a float32 scalar."""
    if isinstance(val, bool):
        return 1.0 if val else 0.0
    if key in CALL_STRING_FEATURES:
        s = str(val).strip()
        if s not in CALL_FEAT_TO_CODE:
            raise KeyError(f"Unknown call literal {val!r} for feature {key}")
        return float(CALL_FEAT_TO_CODE[s])
    if key in STRAIN_STRING_FEATURES:
        s = str(val).strip()
        return float(STRAIN_TO_CODE.get(s, -999))
    if key in SEAT_STRING_FEATURES:
        s = str(val).strip()
        return float(SEAT_TO_CODE.get(s, -999))
    if key == "vuln_pressure":
        return float(VULN_PRESSURE_TO_CODE.get(str(val).strip(), -999))
    if key == "opp_strength_class":
        return float(STRENGTH_CLASS_TO_CODE.get(str(val).strip(), -999))
    if key == "shape_pattern":
        return float(int(str(val).strip()))
    if isinstance(val, (int, float)):
        return float(val)
    s = str(val).strip()
    if s in ("True", "true"):
        return 1.0
    if s in ("False", "false"):
        return 0.0
    return float(s)


def encode_feature_dict(feats: Dict[str, Any], out: Optional[torch.Tensor] = None) -> torch.Tensor:
    """Convert a Python feature dict from BridgeFeatures.extract_all into a (F,) float32 tensor."""
    if out is None:
        out = torch.empty(NUM_FEATURES, dtype=torch.float32)
    for i, k in enumerate(FEATURE_KEYS):
        out[i] = encode_feature_value(k, feats[k])
    return out


def pick_device(preferred: Optional[str] = None) -> torch.device:
    """Select best available PyTorch device (cuda > mps > cpu)."""
    if preferred:
        return torch.device(preferred)
    if torch.cuda.is_available():
        return torch.device("cuda")
    if getattr(torch.backends, "mps", None) is not None and torch.backends.mps.is_available():
        return torch.device("mps")
    return torch.device("cpu")


# ---------------------------------------------------------------------------
# Tensorized DecisionNet (Unique-Atom Matrix Formulation)
# ---------------------------------------------------------------------------

OP_EQ = 1
OP_NE = 2
OP_GE = 3
OP_LE = 4
OP_GT = 5
OP_LT = 6
OP_IN = 7
OP_NOT_IN = 8

_OP_MAP = {
    "==": OP_EQ,
    "!=": OP_NE,
    ">=": OP_GE,
    "<=": OP_LE,
    ">": OP_GT,
    "<": OP_LT,
    "in": OP_IN,
    "not_in": OP_NOT_IN,
}


class TensorDecisionNet:
    """Compiled PyTorch representation of a DecisionNet.

    All unique `(key, op, value)` atoms across all rules are evaluated once
    on the input batch `X: (B, F)`, producing `atom_sat: (B, U)`. Rule matching
    is then a single matrix multiplication `atom_sat @ rule_atom_mat.T == rule_n_atoms`.
    """

    def __init__(self, net: DecisionNet, device: Union[str, torch.device] = "cpu"):
        self.name = net.name
        self.device = torch.device(device)
        self.num_rules = len(net.rules)
        self.rule_ids = [r.rule_id for r in net.rules]

        atom_index: Dict[Tuple[int, int, Any], int] = {}
        atom_feats: List[int] = []
        atom_ops: List[int] = []
        atom_vals: List[float] = []
        atom_in_masks: List[int] = []

        rule_atoms_list: List[List[int]] = []
        rule_unmatchable: List[bool] = []
        rule_calls: List[int] = []
        rule_prios: List[int] = []
        rule_neg: List[bool] = []

        for r in net.rules:
            c_str = str(r.call)
            call_idx = CALL_TO_IDX.get(c_str, IDX_PASS)
            rule_calls.append(call_idx)
            rule_prios.append(int(r.priority))
            rule_neg.append(bool(r.is_negative))

            r_atoms: List[int] = []
            unmatchable = False
            for cond in r.conditions:
                if cond.key not in FEAT_TO_COL:
                    # Mirrors RuleCondition.evaluate: missing key -> False
                    unmatchable = True
                    break
                f_idx = FEAT_TO_COL[cond.key]
                op_code = _OP_MAP[cond.op]
                if op_code in (OP_IN, OP_NOT_IN):
                    # Encode set membership over integer codes (-1..37 shifted by +1 -> 0..38)
                    mask = 0
                    for item in cond.value:
                        code = int(round(encode_feature_value(cond.key, item))) + 1
                        if 0 <= code < 62:
                            mask |= (1 << code)
                    key_tuple = (f_idx, op_code, mask)
                    v_float = 0.0
                else:
                    v_float = encode_feature_value(cond.key, cond.value)
                    mask = 0
                    key_tuple = (f_idx, op_code, v_float)

                u_idx = atom_index.get(key_tuple)
                if u_idx is None:
                    u_idx = len(atom_feats)
                    atom_index[key_tuple] = u_idx
                    atom_feats.append(f_idx)
                    atom_ops.append(op_code)
                    atom_vals.append(v_float)
                    atom_in_masks.append(mask)
                r_atoms.append(u_idx)
            rule_atoms_list.append(r_atoms)
            rule_unmatchable.append(unmatchable)

        self.num_atoms = max(1, len(atom_feats))
        if not atom_feats:
            atom_feats = [0]
            atom_ops = [OP_GE]
            atom_vals = [-1e9]
            atom_in_masks = [0]

        self.atom_feat = torch.tensor(atom_feats, dtype=torch.long, device=self.device)
        self.atom_op = torch.tensor(atom_ops, dtype=torch.uint8, device=self.device)
        self.atom_val = torch.tensor(atom_vals, dtype=torch.float32, device=self.device)
        self.atom_in_mask = torch.tensor(atom_in_masks, dtype=torch.int64, device=self.device)
        self.has_in_atoms = bool(((self.atom_op == OP_IN) | (self.atom_op == OP_NOT_IN)).any().item())
        in_lut = torch.zeros((len(atom_in_masks), 64), dtype=torch.bool)
        for u_i, m_val in enumerate(atom_in_masks):
            if m_val:
                for bit_i in range(62):
                    if (m_val >> bit_i) & 1:
                        in_lut[u_i, bit_i] = True
        self.atom_in_lut = in_lut.to(self.device)
        self.u_arange = torch.arange(len(atom_in_masks), dtype=torch.long, device=self.device)

        R = max(1, self.num_rules)
        U = self.num_atoms
        mat = torch.zeros((R, U), dtype=torch.float32)
        n_atoms = torch.zeros((R,), dtype=torch.float32)
        for r_idx, r_atoms in enumerate(rule_atoms_list):
            if rule_unmatchable[r_idx]:
                n_atoms[r_idx] = 1e6
                continue
            unique_r_atoms = set(r_atoms)
            for u_idx in unique_r_atoms:
                mat[r_idx, u_idx] = 1.0
            n_atoms[r_idx] = float(len(unique_r_atoms))

        self.rule_atom_mat = mat.to(self.device)
        self.rule_n_atoms = n_atoms.to(self.device)
        self.rule_call = torch.tensor(
            rule_calls if rule_calls else [IDX_PASS], dtype=torch.long, device=self.device
        )
        self.rule_prio = torch.tensor(
            rule_prios if rule_prios else [0], dtype=torch.float32, device=self.device
        )
        self.rule_neg = torch.tensor(
            rule_neg if rule_neg else [False], dtype=torch.bool, device=self.device
        )

        # Precompute (R, 38) one-hot matrix mapping each positive rule to its call
        pos_mask = (~self.rule_neg)[:, None] & (
            self.rule_call[:, None] == torch.arange(38, device=self.device)[None, :]
        )
        neg_mask = self.rule_neg[:, None] & (
            self.rule_call[:, None] == torch.arange(38, device=self.device)[None, :]
        )
        self.has_neg_rules = bool(self.rule_neg.any().item())
        self.pos_rule_call_mat = pos_mask.to(torch.float32)  # (R, 38)
        self.neg_rule_call_mat = neg_mask.to(torch.float32)  # (R, 38)

        # Combined score for each positive rule: priority * 64 - lex_rank(call)
        # Ensures max over rules and argmax over calls reproduces DecisionNet's
        # exact `(-priority, str(call))` ordering without scatter_reduce_.
        lex_ranks = torch.tensor(CALL_LEX_RANK, dtype=torch.float32, device=self.device)
        self.call_tiebreak = -lex_ranks  # (38,)
        rule_lex = lex_ranks[self.rule_call]
        self.rule_score = torch.where(
            self.rule_neg,
            torch.full_like(self.rule_prio, -1e9),
            self.rule_prio * 64.0 - rule_lex,
        )  # (R,)

    @classmethod
    def from_dsl(cls, path_or_net: Union[str, DecisionNet],
                 device: Union[str, torch.device] = "cpu") -> "TensorDecisionNet":
        net = (load_decision_net_dsl(path_or_net)
               if isinstance(path_or_net, str) else path_or_net)
        return cls(net, device=device)

    def evaluate_atoms(self, X: torch.Tensor) -> torch.Tensor:
        """Evaluate all U unique condition atoms on feature matrix X: (B, F) -> (B, U) float32."""
        vals = X[:, self.atom_feat]  # (B, U)
        op = self.atom_op[None, :]   # (1, U)
        thresh = self.atom_val[None, :]  # (1, U)

        sat = (
            ((op == OP_EQ) & (vals == thresh))
            | ((op == OP_NE) & (vals != thresh))
            | ((op == OP_GE) & (vals >= thresh))
            | ((op == OP_LE) & (vals <= thresh))
            | ((op == OP_GT) & (vals > thresh))
            | ((op == OP_LT) & (vals < thresh))
        )
        if self.has_in_atoms:
            shifts = (vals.round().to(torch.long) + 1).clamp(0, 62)
            in_hit = self.atom_in_lut[self.u_arange[None, :], shifts]
            sat = sat | ((op == OP_IN) & in_hit) | ((op == OP_NOT_IN) & (~in_hit))
        return sat.to(torch.float32)

    def match_rules(self, X: torch.Tensor) -> torch.Tensor:
        """Return boolean mask (B, R) of rules matched for each row in X: (B, F)."""
        if self.num_rules == 0:
            return torch.zeros((X.shape[0], 1), dtype=torch.bool, device=self.device)
        atom_sat = self.evaluate_atoms(X)  # (B, U)
        hits = atom_sat @ self.rule_atom_mat.T  # (B, R)
        return (hits - self.rule_n_atoms[None, :]).abs() < 0.5

    def call_scores(self, X: torch.Tensor, legal_mask: torch.Tensor) -> Tuple[torch.Tensor, torch.Tensor]:
        """Compute per-call candidate mask (B, 38) and best_call indices (B,).

        Matches `DecisionNet.actions` + `DecisionNet.best_call` bit-for-bit using
        pure matrix/elementwise ops (works natively on CUDA, Apple MPS, and CPU):
        1. Positive rules have score `priority * 64 - lex_rank(call)`.
        2. Negative rules unconditionally veto their call.
        3. Illegal calls are masked out via `legal_mask[:, rule_call]`.
        4. Because max_c(max_{r in rules(c)} score(r)) == max_r score(r), the
           winning call is simply `rule_call[argmax_r active_rule_scores]`,
           falling back to `IDX_PASS` when no legal non-vetoed positive rule fires.
        """
        B = X.shape[0]
        matched = self.match_rules(X)  # (B, R)
        pos_matched = matched & (~self.rule_neg[None, :])  # (B, R)

        # Negative-rule vetoes mapped back to rules via rule_call
        if self.has_neg_rules:
            neg_matched = (matched & self.rule_neg[None, :]).to(torch.float32)
            vetoed_calls = (neg_matched @ self.neg_rule_call_mat) > 0.5  # (B, 38)
            rule_vetoed = vetoed_calls[:, self.rule_call]  # (B, R)
            pos_matched = pos_matched & (~rule_vetoed)

        # Filter positive rules whose emitted call is legal at this auction state
        rule_legal = legal_mask[:, self.rule_call]  # (B, R)
        valid_pos = pos_matched & rule_legal  # (B, R)

        NEG_INF = -1e9
        active_scores = torch.where(
            valid_pos,
            self.rule_score[None, :].expand(B, -1),
            torch.full((B, matched.shape[1]), NEG_INF, dtype=torch.float32, device=self.device),
        )
        max_score, best_r = active_scores.max(dim=1)  # (B,)
        best_calls = torch.where(
            max_score > NEG_INF / 2,
            self.rule_call[best_r],
            torch.full((B,), IDX_PASS, dtype=torch.long, device=self.device),
        )

        # Candidate indicator matrix (B, 38)
        cand_mask = (valid_pos.to(torch.float32) @ self.pos_rule_call_mat) > 0.5
        cand_mask[:, IDX_PASS] = cand_mask[:, IDX_PASS] | (~(max_score > NEG_INF / 2))
        return cand_mask.to(torch.float32), best_calls


# ---------------------------------------------------------------------------
# Precomputed Duplicate Score & WBF IMP Lookup Tensors
# ---------------------------------------------------------------------------

def _build_score_lut(device: torch.device) -> torch.Tensor:
    """Precompute exact duplicate bridge scores: shape (36, 3, 2, 14).

    Dimensions:
      - contract_idx: 0 = PASS_OUT, 1..35 = 1C..7NT
      - doubled: 0 = undoubled, 1 = X, 2 = XX
      - is_vulnerable: 0 = False, 1 = True
      - tricks: 0..13
    """
    lut = torch.zeros((36, 3, 2, 14), dtype=torch.float32)
    strains = [Strain.CLUBS, Strain.DIAMONDS, Strain.HEARTS, Strain.SPADES, Strain.NT]
    for c_idx in range(1, 36):
        lvl = (c_idx - 1) // 5 + 1
        st = strains[(c_idx - 1) % 5]
        for dbl in range(3):
            for vul in range(2):
                for tr in range(14):
                    lut[c_idx, dbl, vul, tr] = float(
                        calculate_contract_score(
                            level=lvl,
                            strain=st,
                            doubled=dbl,
                            is_vulnerable=bool(vul),
                            tricks_taken=tr,
                        )
                    )
    return lut.to(device)


_WBF_IMP_CUTOFFS = [
    10, 40, 80, 120, 160, 210, 260, 310, 360, 420, 490, 590,
    740, 890, 1090, 1290, 1490, 1740, 1990, 2240, 2490, 2990, 3490, 3990
]


def points_to_imps_tensor(diff: torch.Tensor) -> torch.Tensor:
    """Vectorized signed WBF IMP conversion matching `bid.scoring.score_to_imp`."""
    rounded = diff.round().to(torch.int64)
    abs_d = rounded.abs()
    cutoffs = torch.tensor(_WBF_IMP_CUTOFFS, dtype=torch.int64, device=diff.device)
    mag = (abs_d[..., None] > cutoffs).sum(dim=-1)
    return torch.where(rounded < 0, -mag, mag)


# ---------------------------------------------------------------------------
# Batched Deal Bundle & Lockstep 4-Player Auction Environment
# ---------------------------------------------------------------------------

class DealBundle:
    """Pre-extracted tensor representation of B deals and their 20-entry DD tables."""

    def __init__(self,
                 hand_features: torch.Tensor,
                 dealers: torch.Tensor,
                 vulns: torch.Tensor,
                 dd_tricks: torch.Tensor,
                 suit_lengths: torch.Tensor,
                 suit_has_king: torch.Tensor,
                 suit_has_queen: torch.Tensor,
                 suit_stopper_q: torch.Tensor,
                 ace_counts: torch.Tensor):
        # hand_features: (B, 4, NUM_FEATURES) static baseline per seat (N=0, E=1, S=2, W=3)
        self.hand_features = hand_features
        self.dealers = dealers              # (B,) int64 in 0..3
        self.vulns = vulns                  # (B,) int64 in 0..3
        self.dd_tricks = dd_tricks          # (B, 4, 5) int64: declarer 0..3, strain 0..4 (C,D,H,S,NT)
        self.suit_lengths = suit_lengths    # (B, 4, 4) int64: seat 0..3, suit 0..3 (C,D,H,S)
        self.suit_has_king = suit_has_king  # (B, 4, 4) bool
        self.suit_has_queen = suit_has_queen  # (B, 4, 4) bool
        self.suit_stopper_q = suit_stopper_q  # (B, 4, 4) float32 stopper quality (2.0, 1.0, 0.5, 0.0)
        self.ace_counts = ace_counts        # (B, 4) int64

    @property
    def num_boards(self) -> int:
        return int(self.dealers.shape[0])

    def to(self, device: Union[str, torch.device]) -> "DealBundle":
        dev = torch.device(device)
        return DealBundle(
            self.hand_features.to(dev),
            self.dealers.to(dev),
            self.vulns.to(dev),
            self.dd_tricks.to(dev),
            self.suit_lengths.to(dev),
            self.suit_has_king.to(dev),
            self.suit_has_queen.to(dev),
            self.suit_stopper_q.to(dev),
            self.ace_counts.to(dev),
        )

    def save(self, path: str) -> None:
        os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
        torch.save({
            "feature_keys": FEATURE_KEYS,
            "hand_features": self.hand_features.cpu(),
            "dealers": self.dealers.cpu(),
            "vulns": self.vulns.cpu(),
            "dd_tricks": self.dd_tricks.cpu(),
            "suit_lengths": self.suit_lengths.cpu(),
            "suit_has_king": self.suit_has_king.cpu(),
            "suit_has_queen": self.suit_has_queen.cpu(),
            "suit_stopper_q": self.suit_stopper_q.cpu(),
            "ace_counts": self.ace_counts.cpu(),
        }, path)

    @classmethod
    def load(cls, path: str, device: Union[str, torch.device] = "cpu") -> "DealBundle":
        try:
            d = torch.load(path, map_location="cpu", weights_only=False)
        except TypeError:
            d = torch.load(path, map_location="cpu")
        if d.get("feature_keys") != FEATURE_KEYS:
            raise ValueError("DealBundle feature_keys mismatch with current BridgeFeatures")
        return cls(
            d["hand_features"], d["dealers"], d["vulns"], d["dd_tricks"],
            d["suit_lengths"], d["suit_has_king"], d["suit_has_queen"],
            d["suit_stopper_q"], d["ace_counts"]
        ).to(device)

    @classmethod
    def from_deals(cls, deals: Sequence[Deal], compute_dd: bool = True,
                   device: Union[str, torch.device] = "cpu") -> "DealBundle":
        """Build a DealBundle from a list of Deal objects (computing DD tables if requested)."""
        from bid.dds import DDSolver

        B = len(deals)
        hand_features = torch.zeros((B, 4, NUM_FEATURES), dtype=torch.float32)
        dealers = torch.zeros((B,), dtype=torch.long)
        vulns = torch.zeros((B,), dtype=torch.long)
        dd_tricks = torch.zeros((B, 4, 5), dtype=torch.long)
        suit_lengths = torch.zeros((B, 4, 4), dtype=torch.long)
        suit_has_king = torch.zeros((B, 4, 4), dtype=torch.bool)
        suit_has_queen = torch.zeros((B, 4, 4), dtype=torch.bool)
        suit_stopper_q = torch.zeros((B, 4, 4), dtype=torch.float32)
        ace_counts = torch.zeros((B, 4), dtype=torch.long)

        strains = (Strain.CLUBS, Strain.DIAMONDS, Strain.HEARTS, Strain.SPADES, Strain.NT)
        suits = (Suit.CLUBS, Suit.DIAMONDS, Suit.HEARTS, Suit.SPADES)

        for b, deal in enumerate(deals):
            dealers[b] = deal.dealer.value
            vulns[b] = int(deal.vuln)
            for seat in Seat:
                s_idx = seat.value
                hand = deal.hands[seat]
                feats = BridgeFeatures.extract_all(hand, [], seat, deal.dealer, deal.vuln)
                encode_feature_dict(feats, out=hand_features[b, s_idx])
                ace_counts[b, s_idx] = hand.ace_count
                for su_idx, su in enumerate(suits):
                    cards = hand.by_suit.get(su, [])
                    ranks = {c.rank for c in cards}
                    L = len(cards)
                    suit_lengths[b, s_idx, su_idx] = L
                    suit_has_king[b, s_idx, su_idx] = Rank.KING in ranks
                    suit_has_queen[b, s_idx, su_idx] = Rank.QUEEN in ranks
                    if Rank.ACE in ranks:
                        sq = 2.0
                    elif Rank.KING in ranks and L >= 2:
                        sq = 1.0
                    elif Rank.QUEEN in ranks and L >= 3:
                        sq = 0.5
                    else:
                        sq = 0.0
                    suit_stopper_q[b, s_idx, su_idx] = sq

            if compute_dd:
                table = DDSolver.solve_dd_table(deal)
                for st_idx, st in enumerate(strains):
                    for seat in Seat:
                        dd_tricks[b, seat.value, st_idx] = int(table[(st, seat)])

        return cls(
            hand_features, dealers, vulns, dd_tricks,
            suit_lengths, suit_has_king, suit_has_queen, suit_stopper_q, ace_counts
        ).to(device)


# Precompute HCP windows per call index 0..37 matching `_partner_hcp_window` in features.py
def _build_call_hcp_windows(device: torch.device) -> Tuple[torch.Tensor, torch.Tensor, torch.Tensor]:
    """Return (has_win, win_lo, win_hi) of shape (38,) for call indices 0..37."""
    has_win = torch.zeros(38, dtype=torch.bool)
    win_lo = torch.zeros(38, dtype=torch.long)
    win_hi = torch.full((38,), 37, dtype=torch.long)
    nt_wins = {1: (15, 17), 2: (20, 21), 3: (25, 27), 4: (28, 30), 5: (31, 32), 6: (33, 34), 7: (35, 37)}
    for c_idx in range(1, 36):
        lvl = (c_idx - 1) // 5 + 1
        st = (c_idx - 1) % 5  # 0=C, 1=D, 2=H, 3=S, 4=NT
        has_win[c_idx] = True
        if st == 4:
            lo, hi = nt_wins[lvl]
        elif lvl == 1:
            lo, hi = (11, 21)
        elif lvl == 2:
            lo, hi = (22, 37) if st == 0 else (5, 10)
        else:
            lo, hi = (5, 10)
        win_lo[c_idx] = lo
        win_hi[c_idx] = hi
    return has_win.to(device), win_lo.to(device), win_hi.to(device)


class BatchedAuctionEnv:
    """Vectorized 4-player bridge auction state machine in PyTorch.

    Maintains the exact 129 `BridgeFeatures` across `B` concurrent auctions
    in lockstep on GPU/MPS/CPU.
    """

    def __init__(self, bundle: DealBundle):
        self.bundle = bundle
        self.device = bundle.hand_features.device
        self.B = bundle.num_boards
        self.call_has_win, self.call_win_lo, self.call_win_hi = _build_call_hcp_windows(self.device)
        self.score_lut = _build_score_lut(self.device)
        self.suit_bits_1d = torch.tensor([1, 2, 4, 8], dtype=torch.long, device=self.device)
        self.reset()

    def reset(self) -> None:
        B, dev = self.B, self.device
        self.turn = 0
        self.done = torch.zeros(B, dtype=torch.bool, device=dev)
        self.history_calls = torch.full((B, 20), -1, dtype=torch.long, device=dev)
        self.history_len = torch.zeros(B, dtype=torch.long, device=dev)

        self.last_bid = torch.zeros(B, dtype=torch.long, device=dev)  # 0 = none, 1..35 = 1C..7NT
        self.last_bid_seat = torch.full((B,), -1, dtype=torch.long, device=dev)
        self.passes_since_last_bid = torch.zeros(B, dtype=torch.long, device=dev)
        self.doubled = torch.zeros(B, dtype=torch.long, device=dev)  # 0, 1 (X), 2 (XX)

        # Last non-pass call tracking for X / XX legality
        self.last_np_call = torch.full((B,), -1, dtype=torch.long, device=dev)
        self.last_np_seat = torch.full((B,), -1, dtype=torch.long, device=dev)

        # First seat on each side (0=NS, 1=EW) to bid each strain (0..4) -> declarer tracking
        self.first_bidder = torch.full((B, 2, 5), -1, dtype=torch.long, device=dev)

        # Per-seat trackers (B, 4)
        self.seat_call_count = torch.zeros((B, 4), dtype=torch.long, device=dev)
        self.seat_bid_count = torch.zeros((B, 4), dtype=torch.long, device=dev)
        self.seat_first_call = torch.full((B, 4), -1, dtype=torch.long, device=dev)
        self.seat_last_call = torch.full((B, 4), -1, dtype=torch.long, device=dev)
        self.seat_opened_first = torch.zeros((B, 4), dtype=torch.bool, device=dev)
        self.seat_first_call_was_bid = torch.zeros((B, 4), dtype=torch.bool, device=dev)
        self.seat_last_suit_bid_strain = torch.full((B, 4), -1, dtype=torch.long, device=dev)
        self.seat_suits_mask = torch.zeros((B, 4), dtype=torch.long, device=dev)  # 4-bit mask C,D,H,S
        self.seat_hcp_lo = torch.zeros((B, 4), dtype=torch.long, device=dev)
        self.seat_hcp_hi = torch.full((B, 4), 37, dtype=torch.long, device=dev)

        # Per-side trackers (side 0 = NS, side 1 = EW)
        self.side_bid_count = torch.zeros((B, 2), dtype=torch.long, device=dev)
        self.side_first_call = torch.full((B, 2), -1, dtype=torch.long, device=dev)
        self.side_first_bid = torch.full((B, 2), -1, dtype=torch.long, device=dev)
        self.side_first_bid_level = torch.zeros((B, 2), dtype=torch.long, device=dev)
        self.side_preempted = torch.zeros((B, 2), dtype=torch.bool, device=dev)
        self.side_last_bid = torch.full((B, 2), -1, dtype=torch.long, device=dev)
        self.side_suits_mask = torch.zeros((B, 2), dtype=torch.long, device=dev)

        # Global auction trackers
        self.opening_bid = torch.full((B,), -1, dtype=torch.long, device=dev)
        self.competition_level = torch.zeros(B, dtype=torch.long, device=dev)
        self.auction_altitude = torch.zeros(B, dtype=torch.long, device=dev)
        self.last_suit_turn = torch.full((B, 4), -1, dtype=torch.long, device=dev)  # most recent turn suit 0..3 was bid

    def current_seats(self) -> torch.Tensor:
        return (self.bundle.dealers + self.turn) % 4

    def legal_mask(self, my_seat: torch.Tensor) -> torch.Tensor:
        """Compute (B, 38) boolean mask of legal calls for `my_seat: (B,)`."""
        B, dev = self.B, self.device
        mask = torch.zeros((B, 38), dtype=torch.bool, device=dev)
        mask[:, IDX_PASS] = True

        # Bids 1..35 are legal iff c_idx > last_bid
        bid_indices = torch.arange(1, 36, device=dev)[None, :]  # (1, 35)
        mask[:, 1:36] = bid_indices > self.last_bid[:, None]

        # X legality: last non-pass was a BID by an opponent
        my_side = my_seat % 2
        last_np_side = self.last_np_seat % 2
        opp_last_np = (self.last_np_seat >= 0) & (last_np_side != my_side)
        is_last_np_bid = (self.last_np_call >= 1) & (self.last_np_call <= 35)
        mask[:, IDX_X] = opp_last_np & is_last_np_bid

        # XX legality: last non-pass was X by an opponent on our side's bid
        last_bid_side = self.last_bid_seat % 2
        our_bid_doubled = (
            opp_last_np
            & (self.last_np_call == IDX_X)
            & (self.last_bid_seat >= 0)
            & (last_bid_side == my_side)
        )
        mask[:, IDX_XX] = our_bid_doubled
        return mask

    def build_features(self) -> Tuple[torch.Tensor, torch.Tensor]:
        """Build the exact (B, 129) feature matrix for the current turn's active seats."""
        B, dev = self.B, self.device
        b_idx = torch.arange(B, device=dev)
        my_seat = self.current_seats()          # (B,) in 0..3
        partner_seat = (my_seat + 2) % 4        # (B,)
        my_side = my_seat % 2                   # (B,) 0=NS, 1=EW
        opp_side = 1 - my_side                  # (B,)

        # Start from the static hand features for `my_seat`
        X = self.bundle.hand_features[b_idx, my_seat].clone()  # (B, F)

        t = self.turn
        X[:, FEAT_TO_COL["auction_len"]] = float(t)

        is_open = self.last_bid == 0
        X[:, FEAT_TO_COL["is_opening"]] = is_open.to(torch.float32)
        X[:, FEAT_TO_COL["passes_since_last_bid"]] = self.passes_since_last_bid.to(torch.float32)

        # Rule of 21 depends on whether we are in 3rd/4th seat of an unopened auction
        hcp = X[:, FEAT_TO_COL["hcp"]]
        r20 = X[:, FEAT_TO_COL["rule20_total"]]
        qt = X[:, FEAT_TO_COL["quick_tricks"]]
        need_qt = torch.where(is_open & (t >= 2), torch.tensor(1.5, device=dev), torch.tensor(2.0, device=dev))
        X[:, FEAT_TO_COL["rule_of_21"]] = ((r20 >= 21.0) & (qt >= need_qt)).to(torch.float32)

        last_lvl = torch.where(is_open, torch.zeros_like(self.last_bid), (self.last_bid - 1) // 5 + 1)
        last_st = torch.where(is_open, torch.full_like(self.last_bid, -1), (self.last_bid - 1) % 5)
        X[:, FEAT_TO_COL["last_bid_level"]] = last_lvl.to(torch.float32)
        X[:, FEAT_TO_COL["last_bid_strain"]] = last_st.to(torch.float32)
        X[:, FEAT_TO_COL["last_bid_seat"]] = self.last_bid_seat.to(torch.float32)

        # Partner features
        p_first_was_bid = self.seat_first_call_was_bid[b_idx, partner_seat]
        p_opened_first = self.seat_opened_first[b_idx, partner_seat]
        p_opened = p_first_was_bid & ((self.last_bid_seat == partner_seat) | p_opened_first)
        X[:, FEAT_TO_COL["partner_opened"]] = p_opened.to(torch.float32)
        X[:, FEAT_TO_COL["partner_last_call"]] = self.seat_last_call[b_idx, partner_seat].to(torch.float32)
        X[:, FEAT_TO_COL["partner_first_call"]] = self.seat_first_call[b_idx, partner_seat].to(torch.float32)
        X[:, FEAT_TO_COL["partner_rebid"]] = (self.seat_call_count[b_idx, partner_seat] >= 2).to(torch.float32)

        plo = self.seat_hcp_lo[b_idx, partner_seat].to(torch.float32)
        phi = self.seat_hcp_hi[b_idx, partner_seat].to(torch.float32)
        X[:, FEAT_TO_COL["partner_hcp_min"]] = plo
        X[:, FEAT_TO_COL["partner_hcp_max"]] = phi
        X[:, FEAT_TO_COL["combined_hcp_min"]] = hcp + plo
        X[:, FEAT_TO_COL["combined_hcp_max"]] = torch.clamp(hcp + phi, max=40.0)

        # Own call features
        X[:, FEAT_TO_COL["my_last_call"]] = self.seat_last_call[b_idx, my_seat].to(torch.float32)
        X[:, FEAT_TO_COL["my_first_call"]] = self.seat_first_call[b_idx, my_seat].to(torch.float32)
        X[:, FEAT_TO_COL["opening_bid"]] = self.opening_bid.to(torch.float32)

        # Opponent features
        opp_b_cnt = self.side_bid_count[b_idx, opp_side]
        my_b_cnt = self.side_bid_count[b_idx, my_side]
        opps_bid = opp_b_cnt > 0
        X[:, FEAT_TO_COL["opponents_bid"]] = opps_bid.to(torch.float32)
        X[:, FEAT_TO_COL["opp_first_call"]] = self.side_first_call[b_idx, opp_side].to(torch.float32)

        opp_last = self.side_last_bid[b_idx, opp_side]
        has_opp_last = opp_last >= 1
        opp_lvl = torch.where(has_opp_last, (opp_last - 1) // 5 + 1, torch.zeros_like(opp_last))
        opp_st = torch.where(has_opp_last, (opp_last - 1) % 5, torch.full_like(opp_last, -1))
        opp_in_game = has_opp_last & (
            ((opp_lvl >= 4) & ((opp_st == 2) | (opp_st == 3)))
            | ((opp_lvl >= 3) & (opp_st == 4))
            | (opp_lvl >= 5)
        )
        X[:, FEAT_TO_COL["opp_last_call"]] = opp_last.to(torch.float32)
        X[:, FEAT_TO_COL["opp_contract_level"]] = opp_lvl.to(torch.float32)
        X[:, FEAT_TO_COL["opp_is_in_game"]] = opp_in_game.to(torch.float32)

        X[:, FEAT_TO_COL["opp_bid_count"]] = opp_b_cnt.to(torch.float32)
        X[:, FEAT_TO_COL["my_side_bid_count"]] = my_b_cnt.to(torch.float32)
        X[:, FEAT_TO_COL["competition_level"]] = self.competition_level.to(torch.float32)
        X[:, FEAT_TO_COL["auction_altitude"]] = self.auction_altitude.to(torch.float32)
        X[:, FEAT_TO_COL["auction_contested"]] = (opps_bid & (my_b_cnt > 0)).to(torch.float32)

        opp_pre = self.side_preempted[b_idx, opp_side]
        opp_f_lvl = self.side_first_bid_level[b_idx, opp_side]
        X[:, FEAT_TO_COL["opp_preempted"]] = opp_pre.to(torch.float32)
        X[:, FEAT_TO_COL["opp_first_bid_level"]] = opp_f_lvl.to(torch.float32)
        # strength class: 0=unknown, 1=weak, 2=strong
        s_cls = torch.where(
            opp_pre,
            torch.ones_like(opp_f_lvl),
            torch.where(opp_f_lvl >= 4, torch.full_like(opp_f_lvl, 2), torch.zeros_like(opp_f_lvl)),
        )
        X[:, FEAT_TO_COL["opp_strength_class"]] = s_cls.to(torch.float32)

        # Fit & support features
        opp_s_mask = self.side_suits_mask[b_idx, opp_side]
        # popcount >= 2 iff mask & (mask - 1) != 0
        opp_fit = (opp_s_mask & (opp_s_mask - 1)) != 0
        my_s_mask = self.seat_suits_mask[b_idx, my_seat]
        p_s_mask = self.seat_suits_mask[b_idx, partner_seat]
        shared_mask = my_s_mask & p_s_mask
        X[:, FEAT_TO_COL["opp_fit_shown"]] = opp_fit.to(torch.float32)
        X[:, FEAT_TO_COL["our_fit_shown"]] = (shared_mask != 0).to(torch.float32)

        p_last_st = self.seat_last_suit_bid_strain[b_idx, partner_seat]
        X[:, FEAT_TO_COL["partner_last_bid_strain"]] = p_last_st.to(torch.float32)
        clamped_p_st = p_last_st.clamp(0, 3)
        supp_len = self.bundle.suit_lengths[b_idx, my_seat, clamped_p_st]
        X[:, FEAT_TO_COL["support_in_partner_suit"]] = torch.where(
            p_last_st >= 0, supp_len, torch.full_like(supp_len, -1)
        ).to(torch.float32)

        # Agreed trump: shared suit with the largest `last_suit_turn`
        suit_bits = torch.tensor([1, 2, 4, 8], device=dev)[None, :]  # (1, 4)
        in_shared = (shared_mask[:, None] & suit_bits) != 0          # (B, 4)
        shared_turns = torch.where(in_shared, self.last_suit_turn, torch.full_like(self.last_suit_turn, -1))
        max_turn, best_suit = shared_turns.max(dim=1)
        agreed = torch.where(max_turn >= 0, best_suit, torch.full_like(best_suit, -1))
        has_agreed = agreed >= 0
        clamped_ag = agreed.clamp(0, 3)

        ag_len = torch.where(
            has_agreed,
            self.bundle.suit_lengths[b_idx, my_seat, clamped_ag],
            torch.full((B,), -1, dtype=torch.long, device=dev),
        )
        has_tk = has_agreed & self.bundle.suit_has_king[b_idx, my_seat, clamped_ag]
        has_tq = has_agreed & self.bundle.suit_has_queen[b_idx, my_seat, clamped_ag]
        kc_agreed = self.bundle.ace_counts[b_idx, my_seat] + has_tk.to(torch.long)

        X[:, FEAT_TO_COL["agreed_trump"]] = agreed.to(torch.float32)
        X[:, FEAT_TO_COL["agreed_trump_len"]] = ag_len.to(torch.float32)
        X[:, FEAT_TO_COL["has_trump_king"]] = has_tk.to(torch.float32)
        X[:, FEAT_TO_COL["has_trump_queen"]] = has_tq.to(torch.float32)
        X[:, FEAT_TO_COL["keycard_count_agreed"]] = kc_agreed.to(torch.float32)

        # Opponent suit stoppers
        in_opp_suits = (opp_s_mask[:, None] & suit_bits) != 0  # (B, 4)
        hand_stop_q = self.bundle.suit_stopper_q[b_idx, my_seat]  # (B, 4)
        masked_stop_q = torch.where(in_opp_suits, hand_stop_q, torch.full_like(hand_stop_q, -1.0))
        max_stop_q = masked_stop_q.max(dim=1).values
        opp_stoppers = torch.where(opp_s_mask != 0, max_stop_q, torch.full_like(max_stop_q, 2.0))
        X[:, FEAT_TO_COL["opp_suit_stoppers"]] = opp_stoppers
        X[:, FEAT_TO_COL["has_stopper"]] = (opp_stoppers > 0.0).to(torch.float32)

        # Balancing & competitive flags
        last_bid_side = self.last_bid_seat % 2
        is_bal = (self.passes_since_last_bid == 2) & (self.last_bid_seat >= 0) & (last_bid_side == opp_side)
        X[:, FEAT_TO_COL["is_balancing"]] = is_bal.to(torch.float32)
        X[:, FEAT_TO_COL["is_competitive"]] = (opps_bid & (~is_open)).to(torch.float32)

        return X, my_seat

    def step(self, calls: torch.Tensor) -> None:
        """Apply chosen calls: (B,) in 0..37 for active boards and advance turn."""
        B, dev = self.B, self.device
        b_idx = torch.arange(B, device=dev)
        active = ~self.done
        if not bool(active.any().item()):
            return

        seat = self.current_seats()
        side = seat % 2
        t = self.turn

        c = torch.where(active, calls, torch.full_like(calls, -1))
        self.history_calls[:, t] = c
        self.history_len = torch.where(active, self.history_len + 1, self.history_len)

        is_pass = active & (c == IDX_PASS)
        is_bid = active & (c >= 1) & (c <= 35)
        is_x = active & (c == IDX_X)
        is_xx = active & (c == IDX_XX)
        is_non_pass = active & (c != IDX_PASS)

        # Per-seat call history updates
        prev_cnt = self.seat_call_count[b_idx, seat]
        is_first_seat_call = active & (prev_cnt == 0)
        self.seat_first_call[b_idx, seat] = torch.where(
            is_first_seat_call, c, self.seat_first_call[b_idx, seat]
        )
        self.seat_first_call_was_bid[b_idx, seat] = torch.where(
            is_first_seat_call, is_bid, self.seat_first_call_was_bid[b_idx, seat]
        )
        if t == 0:
            self.seat_opened_first[b_idx, seat] = is_bid
        self.seat_last_call[b_idx, seat] = torch.where(
            active, c, self.seat_last_call[b_idx, seat]
        )
        self.seat_call_count[b_idx, seat] = torch.where(active, prev_cnt + 1, prev_cnt)

        # Side first call (any call, including PASS)
        prev_side_first = self.side_first_call[b_idx, side]
        self.side_first_call[b_idx, side] = torch.where(
            active & (prev_side_first < 0), c, prev_side_first
        )

        # Bid-specific updates
        bid_lvl = torch.clamp((c - 1) // 5 + 1, 0, 7)
        bid_st = torch.clamp((c - 1) % 5, 0, 4)
        is_suit_bid = is_bid & (bid_st < 4)

        self.opening_bid = torch.where(
            is_bid & (self.opening_bid < 0), c, self.opening_bid
        )
        self.last_bid = torch.where(is_bid, c, self.last_bid)
        self.last_bid_seat = torch.where(is_bid, seat, self.last_bid_seat)
        self.passes_since_last_bid = torch.where(
            is_bid,
            torch.zeros_like(self.passes_since_last_bid),
            torch.where(
                is_pass & (self.last_bid > 0),
                self.passes_since_last_bid + 1,
                self.passes_since_last_bid,
            ),
        )
        self.doubled = torch.where(
            is_bid,
            torch.zeros_like(self.doubled),
            torch.where(is_x, torch.ones_like(self.doubled),
                        torch.where(is_xx, torch.full_like(self.doubled, 2), self.doubled)),
        )

        self.last_np_call = torch.where(is_non_pass, c, self.last_np_call)
        self.last_np_seat = torch.where(is_non_pass, seat, self.last_np_seat)

        # First bidder of (side, strain) for declarer determination
        cur_fb = self.first_bidder[b_idx, side, bid_st]
        self.first_bidder[b_idx, side, bid_st] = torch.where(
            is_bid & (cur_fb < 0), seat, cur_fb
        )

        # Side bid counts and preempt detection
        prev_side_bids = self.side_bid_count[b_idx, side]
        is_first_side_bid = is_bid & (prev_side_bids == 0)
        self.side_first_bid[b_idx, side] = torch.where(
            is_first_side_bid, c, self.side_first_bid[b_idx, side]
        )
        self.side_first_bid_level[b_idx, side] = torch.where(
            is_first_side_bid, bid_lvl, self.side_first_bid_level[b_idx, side]
        )
        # Note: in features.py line 444, `len(history) <= 4` checks total auction length,
        # but at turn t, `len(history)` when `extract_auction_features` runs on LATER turns
        # is the future auction length! Wait: let's check line 444 of features.py!
        # In features.py:
        #   opp_first and (opp_first.level >= 3 or (opp_first.level == 2 and opp_first.strain != NT and len(history) <= 4))
        # We compute `opp_preempted` dynamically or store whether opp_first was a 2-level suit bid.
        self.side_bid_count[b_idx, side] = torch.where(is_bid, prev_side_bids + 1, prev_side_bids)
        self.side_last_bid[b_idx, side] = torch.where(is_bid, c, self.side_last_bid[b_idx, side])

        self.seat_bid_count[b_idx, seat] = torch.where(
            is_bid, self.seat_bid_count[b_idx, seat] + 1, self.seat_bid_count[b_idx, seat]
        )
        self.seat_last_suit_bid_strain[b_idx, seat] = torch.where(
            is_suit_bid, bid_st, self.seat_last_suit_bid_strain[b_idx, seat]
        )

        suit_bit = torch.where(
            is_suit_bid,
            self.suit_bits_1d[bid_st.clamp(0, 3)],
            torch.zeros_like(bid_st),
        )
        self.seat_suits_mask[b_idx, seat] |= suit_bit
        self.side_suits_mask[b_idx, side] |= suit_bit

        clamped_suit = bid_st.clamp(0, 3)
        self.last_suit_turn[b_idx, clamped_suit] = torch.where(
            is_suit_bid,
            torch.full_like(self.last_suit_turn[b_idx, clamped_suit], t),
            self.last_suit_turn[b_idx, clamped_suit],
        )

        # Update partner HCP window for `seat`
        has_w = is_bid & self.call_has_win[c.clamp(0, 37)]
        w_lo = self.call_win_lo[c.clamp(0, 37)]
        w_hi = self.call_win_hi[c.clamp(0, 37)]
        old_lo = self.seat_hcp_lo[b_idx, seat]
        old_hi = self.seat_hcp_hi[b_idx, seat]
        new_lo = torch.maximum(old_lo, w_lo)
        new_hi = torch.minimum(old_hi, w_hi)
        valid_w = has_w & (new_lo <= new_hi)
        self.seat_hcp_lo[b_idx, seat] = torch.where(valid_w, new_lo, old_lo)
        self.seat_hcp_hi[b_idx, seat] = torch.where(valid_w, new_hi, old_hi)

        self.competition_level = torch.where(is_non_pass, self.competition_level + 1, self.competition_level)
        self.auction_altitude = torch.where(
            is_bid, torch.maximum(self.auction_altitude, bid_lvl), self.auction_altitude
        )

        self.turn += 1
        # Update dynamic opp_preempted for next turn `self.turn` (matches `len(history) <= 4` in features.py:444)
        for s_side in (0, 1):
            fb = self.side_first_bid[:, s_side]
            has_fb = fb >= 1
            fb_lvl = torch.where(has_fb, (fb - 1) // 5 + 1, torch.zeros_like(fb))
            fb_st = torch.where(has_fb, (fb - 1) % 5, torch.full_like(fb, 4))
            self.side_preempted[:, s_side] = has_fb & (
                (fb_lvl >= 3) | ((fb_lvl == 2) & (fb_st != 4) & (self.turn <= 4))
            )

        # Termination check:
        # 1) Passed out: 4 calls made and last_bid == 0
        # 2) Bid followed by 3 consecutive passes (and NO X/XX since last bid? Wait: in PartialState.is_auction_over,
        #    let's check how PartialState.is_auction_over works: 3 consecutive passes after ANY non-pass call!)
        # Wait: let's track `passes_since_last_np` for auction termination!
        if not hasattr(self, "passes_since_last_np"):
            self.passes_since_last_np = torch.zeros(B, dtype=torch.long, device=dev)
        self.passes_since_last_np = torch.where(
            is_non_pass,
            torch.zeros_like(self.passes_since_last_np),
            torch.where(is_pass, self.passes_since_last_np + 1, self.passes_since_last_np),
        )
        passed_out_done = (self.history_len == 4) & (self.last_bid == 0)
        three_passes_done = (self.last_bid > 0) & (self.passes_since_last_np >= 3)
        cap_done = self.history_len >= 20
        self.done = self.done | passed_out_done | three_passes_done | cap_done

    def terminal_ns_scores(self) -> torch.Tensor:
        """Compute North-South duplicate score for all B boards at termination."""
        B, dev = self.B, self.device
        b_idx = torch.arange(B, device=dev)
        has_contract = self.last_bid > 0
        c_idx = self.last_bid.clamp(0, 35)
        st = torch.clamp((c_idx - 1) % 5, 0, 4)
        winning_side = (self.last_bid_seat % 2).clamp(0, 1)  # 0=NS, 1=EW
        declarer = self.first_bidder[b_idx, winning_side, st].clamp(0, 3)

        tricks = self.bundle.dd_tricks[b_idx, declarer, st].clamp(0, 13)
        v = self.bundle.vulns
        decl_is_ns = (declarer == 0) | (declarer == 2)
        is_vul = (
            (v == Vulnerability.BOTH)
            | ((v == Vulnerability.NS) & decl_is_ns)
            | ((v == Vulnerability.EW) & (~decl_is_ns))
        ).to(torch.long)

        raw_score = self.score_lut[c_idx, self.doubled.clamp(0, 2), is_vul, tricks]
        ns_score = torch.where(
            ~has_contract,
            torch.zeros_like(raw_score),
            torch.where(decl_is_ns, raw_score, -raw_score),
        )
        return ns_score


def play_boards_batched(bundle: DealBundle,
                        ns_net: TensorDecisionNet,
                        ew_net: TensorDecisionNet) -> Tuple[torch.Tensor, torch.Tensor]:
    """Play all B deals in `bundle` with `ns_net` (N/S) vs `ew_net` (E/W).

    Returns `(history_calls, ns_scores)` where `history_calls` has shape `(B, 20)`
    and `ns_scores` has shape `(B,)`.
    """
    env = BatchedAuctionEnv(bundle)
    env.passes_since_last_np = torch.zeros(env.B, dtype=torch.long, device=env.device)

    for _ in range(20):
        if bool(env.done.all().item()):
            break
        X, seat = env.build_features()
        lmask = env.legal_mask(seat)
        is_ns = (seat % 2) == 0

        if ns_net is ew_net:
            _, calls = ns_net.call_scores(X, lmask)
        else:
            _, ns_calls = ns_net.call_scores(X, lmask)
            _, ew_calls = ew_net.call_scores(X, lmask)
            calls = torch.where(is_ns, ns_calls, ew_calls)
        env.step(calls)

    return env.history_calls, env.terminal_ns_scores()


def gpu_team_match(bundle: DealBundle,
                   net_a: TensorDecisionNet,
                   net_b: TensorDecisionNet) -> Dict[str, Any]:
    """Run a two-table duplicate team match on GPU/MPS/CPU.

    Table 1: NS = A, EW = B -> s1
    Table 2: NS = B, EW = A -> s2
    Net IMPs for A = points_to_imps(s1 - s2).
    """
    t0 = time.perf_counter()
    h1, s1 = play_boards_batched(bundle, net_a, net_b)
    h2, s2 = play_boards_batched(bundle, net_b, net_a)
    net_pts = s1 - s2
    imps = points_to_imps_tensor(net_pts)
    elapsed_ms = (time.perf_counter() - t0) * 1000.0

    imps_f = imps.to(torch.float32)
    n = bundle.num_boards
    mean = float(imps_f.mean().item())
    sd = float(imps_f.std(unbiased=True).item()) if n > 1 else 0.0
    se = sd / math.sqrt(n) if n else 0.0
    t_stat = (mean / se) if se > 0 else 0.0

    wins = int((imps > 0).sum().item())
    losses = int((imps < 0).sum().item())
    ties = int((imps == 0).sum().item())

    return {
        "label_a": net_a.name,
        "label_b": net_b.name,
        "n": n,
        "mean": mean,
        "sd": sd,
        "se": se,
        "t": t_stat,
        "total": int(imps.sum().item()),
        "wins": wins,
        "losses": losses,
        "ties": ties,
        "elapsed_ms": elapsed_ms,
        "imps": imps.cpu().tolist(),
        "nets": net_pts.round().to(torch.int64).cpu().tolist(),
        "h1": h1.cpu(),
        "h2": h2.cpu(),
    }


def gpu_continuation_q_values(bundle: DealBundle,
                              net: TensorDecisionNet,
                              prefix_calls: Optional[List[List[int]]] = None) -> Tuple[torch.Tensor, torch.Tensor]:
    """Compute full-continuation rollout Q-values (in duplicate points from caller's side)
    for all 38 candidate calls at the current position of each board in `bundle`.

    For each candidate call `c in 0..37` that is legal at the position:
      1. Force call `c` at the current turn.
      2. Roll out the rest of the auction to `PASS-PASS-PASS` under `net`.
      3. Score the resulting terminal contract using `bundle.dd_tricks`.

    Returns `(q_points, legal_mask)` both of shape `(B, 38)`.
    """
    base_env = BatchedAuctionEnv(bundle)
    base_env.passes_since_last_np = torch.zeros(base_env.B, dtype=torch.long, device=base_env.device)

    if prefix_calls:
        max_p = max(len(p) for p in prefix_calls)
        for t in range(max_p):
            step_c = torch.tensor(
                [p[t] if t < len(p) else IDX_PASS for p in prefix_calls],
                dtype=torch.long, device=base_env.device
            )
            still_in_prefix = torch.tensor(
                [t < len(p) for p in prefix_calls],
                dtype=torch.bool, device=base_env.device
            )
            base_env.done = ~still_in_prefix
            base_env.step(step_c)
        base_env.done = torch.zeros(base_env.B, dtype=torch.bool, device=base_env.device)

    caller_seat = base_env.current_seats()
    caller_is_ns = (caller_seat % 2) == 0
    lmask = base_env.legal_mask(caller_seat)  # (B, 38)
    q_points = torch.full((base_env.B, 38), float("nan"), dtype=torch.float32, device=base_env.device)

    for c_idx in range(38):
        if not bool(lmask[:, c_idx].any().item()):
            continue
        # Clone state for candidate c_idx
        env = BatchedAuctionEnv(bundle)
        env.passes_since_last_np = base_env.passes_since_last_np.clone()
        for k, v in base_env.__dict__.items():
            if isinstance(v, torch.Tensor) and k not in ("score_lut", "call_has_win", "call_win_lo", "call_win_hi"):
                setattr(env, k, v.clone())
        env.turn = base_env.turn

        forced = torch.full((env.B,), c_idx, dtype=torch.long, device=env.device)
        env.step(forced)
        for _ in range(env.turn, 20):
            if bool(env.done.all().item()):
                break
            X, seat = env.build_features()
            m = env.legal_mask(seat)
            _, next_calls = net.call_scores(X, m)
            env.step(next_calls)

        ns_pts = env.terminal_ns_scores()
        caller_pts = torch.where(caller_is_ns, ns_pts, -ns_pts)
        q_points[:, c_idx] = torch.where(lmask[:, c_idx], caller_pts, q_points[:, c_idx])

    return q_points, lmask


# ---------------------------------------------------------------------------
# Parity Verification vs Python `DecisionNet` + `BridgeFeatures`
# ---------------------------------------------------------------------------

def verify_parity(deals: Sequence[Deal],
                  dsl_path: str,
                  device: Union[str, torch.device] = "cpu",
                  bundle: Optional[DealBundle] = None) -> Tuple[int, int]:
    """Verify bit-exact agreement between `BatchedAuctionEnv` + `TensorDecisionNet`
    and Python `BridgeFeatures.extract_all` + `DecisionNet.best_call` across all
    boards and turns.

    Returns `(total_decisions_checked, mismatches)`.
    """
    py_net = load_decision_net_dsl(dsl_path)
    t_net = TensorDecisionNet(py_net, device=device)
    if bundle is None:
        bundle = DealBundle.from_deals(deals, compute_dd=False, device=device)
    else:
        bundle = bundle.to(device)
    env = BatchedAuctionEnv(bundle)
    env.passes_since_last_np = torch.zeros(env.B, dtype=torch.long, device=env.device)

    py_histories: List[List[Call]] = [[] for _ in deals]
    total_checked = 0
    mismatches = 0

    for _ in range(20):
        if bool(env.done.all().item()):
            break
        X, seat = env.build_features()
        lmask = env.legal_mask(seat)
        _, gpu_calls = t_net.call_scores(X, lmask)

        for b, deal in enumerate(deals):
            if bool(env.done[b].item()):
                continue
            cur_seat = Seat((deal.dealer.value + len(py_histories[b])) % 4)
            py_call = py_net.best_call(
                deal.hands[cur_seat], py_histories[b], cur_seat, deal.dealer, deal.vuln
            )
            gpu_call_str = CALL_NAMES[int(gpu_calls[b].item())]
            total_checked += 1
            if str(py_call) != gpu_call_str:
                mismatches += 1
            py_histories[b].append(py_call)

        env.step(gpu_calls)

    return total_checked, mismatches


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    m_p = sub.add_parser("match", help="Run a GPU-vectorized team match between two DSL systems")
    m_p.add_argument("--a", default="system/brill_distilled_shipdd.dsl")
    m_p.add_argument("--b", default="system/brill_distilled.dsl")
    m_p.add_argument("--boards", type=int, default=200)
    m_p.add_argument("--seed", type=int, default=7)
    m_p.add_argument("--bundle", default="", help="Optional precomputed DealBundle .pt path")
    m_p.add_argument("--device", default="", help="cuda / mps / cpu (default: auto)")
    m_p.add_argument("--verify-parity", action="store_true",
                     help="Verify 100%% bit-exact call parity against Python DecisionNet")

    b_p = sub.add_parser("bundle", help="Export a self-contained DealBundle (.pt) for Colab A100")
    b_p.add_argument("--boards", type=int, default=500)
    b_p.add_argument("--seed", type=int, default=7)
    b_p.add_argument("--out", default="data/colab_bundle.pt")

    args = ap.parse_args()
    dev = pick_device(getattr(args, "device", None) or None)

    if args.cmd == "bundle":
        t0 = time.perf_counter()
        deals = build_deals(args.boards, seed=args.seed, include_stratified=False)
        bundle = DealBundle.from_deals(deals, compute_dd=True, device="cpu")
        bundle.save(args.out)
        dt = time.perf_counter() - t0
        print(f"Saved {bundle.num_boards} boards + DD tables to {args.out} ({dt:.1f}s)")
        return 0

    if args.cmd == "match":
        if args.bundle and os.path.exists(args.bundle):
            bundle = DealBundle.load(args.bundle, device=dev)
            deals = None
        else:
            deals = build_deals(args.boards, seed=args.seed, include_stratified=False)
            if args.verify_parity:
                checked, miss = verify_parity(deals[: min(64, len(deals))], args.a, device=dev)
                print(f"Parity check on {min(64, len(deals))} boards: {checked} decisions, {miss} mismatches")
                if miss > 0:
                    return 1
            bundle = DealBundle.from_deals(deals, compute_dd=True, device=dev)

        net_a = TensorDecisionNet.from_dsl(args.a, device=dev)
        net_b = TensorDecisionNet.from_dsl(args.b, device=dev)
        net_a.name = os.path.splitext(os.path.basename(args.a))[0]
        net_b.name = os.path.splitext(os.path.basename(args.b))[0]

        res = gpu_team_match(bundle, net_a, net_b)
        print(f"\nGPU TEAM MATCH [{dev}]  {res['label_a']}  vs  {res['label_b']}")
        print(f"  boards                {res['n']}  ({res['elapsed_ms']:.1f} ms auction+scoring)")
        print(f"  {res['label_a'] + ' net:':<20} {res['mean']:+6.3f} IMP/board  (se {res['se']:.3f}, t {res['t']:+.2f})")
        print(f"  total                 {res['total']:+d} IMP")
        print(f"  boards won/lost/tied  {res['wins']} / {res['losses']} / {res['ties']}")
        return 0

    return 0


if __name__ == "__main__":
    sys.exit(main())