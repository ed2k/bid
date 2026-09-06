#!/usr/bin/env python3
"""
cot_tokenizer.py — canonical semantic-atom tokenizer for CoT-bidder traces.

Emits traces with a fixed alphabet of semantic atoms:
  - Cards: space-separated rank characters ('S : A K 4')
  - Calls: fixed 38-token set (35 bids + PASS + X + XX)
  - Numbers: individual digit atoms ('2 1' instead of '21')
  - Constraint sentences: templated expressions over feature atoms

Special tokens: <pad>=0 <bos>=1 <sep>=2 <eot>=3
"""

import glob
import json
import os
import re
from typing import Any, Dict, List, Optional, Tuple

PAD, BOS, SEP, EOT = "<pad>", "<bos>", "<sep>", "<eot>"
SPECIALS = [PAD, BOS, SEP, EOT]

CALLS_38 = [f"{lvl}{strain}" for lvl in range(1, 8) for strain in ["C", "D", "H", "S", "NT"]] + ["PASS", "X", "XX"]

# Call pattern with negative lookbehind and lookahead so R_1D matches as an identifier, not a call
_CALL_PAT = r"(?<!\w)(?:[1-7](?:NT|[CDHS])|PASS|XX?)(?!\w)"
_TOKEN_RE = re.compile(rf"{_CALL_PAT}|>=|<=|==|!=|<[^>]+>|[A-Za-z_][A-Za-z0-9_]*|\d|[^\w\s]")


def tokenize_line(line: str) -> List[str]:
    """Splits a line into canonical semantic atoms."""
    return _TOKEN_RE.findall(line)


def format_num_split(val: Any) -> str:
    """Emits multi-digit integers as space-separated single digits (e.g. 21 -> '2 1').
    Explicitly preserves boolean types (type(val) is int)."""
    if type(val) is int:
        return " ".join(str(val))
    return str(val)


def format_state_prefix(dealer: Any, vuln: Any, seat: Any, turn: Any,
                        auction_strs: List[str], hand_str: str) -> List[str]:
    """Canonical representation of the state prefix."""
    v_str = vuln.name if hasattr(vuln, "name") else str(vuln)
    if type(vuln) is int:
        v_str = format_num_split(vuln)
    s_str = seat.name if hasattr(seat, "name") else str(seat)
    d_str = dealer.name if hasattr(dealer, "name") else str(dealer)
    turn_str = format_num_split(turn) if type(turn) is int else str(turn)
    auc_str = " ".join(str(c) for c in auction_strs) if auction_strs else "-"
    return [
        f"STATE dealer = {d_str} vuln = {v_str}",
        f"seat = {s_str} turn = {turn_str}",
        f"AUCTION {auc_str}",
        f"HAND {hand_str}",
    ]


def example_lines(trace_obj: dict) -> Tuple[List[str], List[str]]:
    """Returns (prefix_lines, target_lines) for one training example."""
    inp = trace_obj["input"]
    board = trace_obj["board"]
    prefix = format_state_prefix(
        dealer=board["dealer"],
        vuln=board["vuln"],
        seat=trace_obj["seat"],
        turn=trace_obj["call_index"],
        auction_strs=inp["auction"],
        hand_str=inp["hand"],
    )

    exp = trace_obj.get("explanation", {})
    cons_parts = []
    for k, op, v in exp.get("constraints", []):
        if type(v) is int:
            v_str = format_num_split(v)
        elif isinstance(v, list):
            v_str = "[ " + " , ".join(str(x) for x in v) + " ]"
        else:
            v_str = str(v)
        cons_parts.append(f"( {k} {op} {v_str} )")
    cons = " ".join(cons_parts)

    rule = exp.get("rule")
    rule_token = f"RULE {rule}" if rule else "FALLBACK_PASS"
    target = [
        f"EXPLANATION {rule_token} {cons}".strip(),
        f"BID {trace_obj['bid']}",
    ]
    return prefix, target


class Tokenizer:
    def __init__(self, vocab: Dict[str, int]):
        self.vocab = vocab
        self.inv = {i: t for t, i in vocab.items()}

    @classmethod
    def train(cls, lines: List[str], min_count: int = 1) -> "Tokenizer":
        freq: Dict[str, int] = {}
        for line in lines:
            for tok in tokenize_line(line):
                freq[tok] = freq.get(tok, 0) + 1
        vocab = {t: i for i, t in enumerate(SPECIALS)}
        for tok, cnt in sorted(freq.items(), key=lambda kv: (-kv[1], kv[0])):
            if cnt >= min_count and tok not in vocab:
                vocab[tok] = len(vocab)
        return cls(vocab)

    @classmethod
    def load(cls, path: str) -> "Tokenizer":
        with open(path) as f:
            return cls(json.load(f))

    def save(self, path: str) -> None:
        os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
        with open(path, "w") as f:
            json.dump(self.vocab, f, indent=0, sort_keys=True)

    def encode_line(self, line: str, strict: bool = True) -> List[int]:
        unk = self.vocab.get("<unk>")
        tokens = tokenize_line(line)
        ids = []
        for t in tokens:
            if t in self.vocab:
                ids.append(self.vocab[t])
            elif unk is not None:
                ids.append(unk)
            elif strict:
                raise KeyError(f"Unseen token '{t}' in line: '{line}'. Frozen vocabulary violated!")
        return ids

    def decode(self, ids: List[int]) -> str:
        toks = [self.inv[i] for i in ids if i in self.inv and self.inv[i] not in (PAD, BOS)]
        out = []
        for t in toks:
            if t == SEP:
                out.append("\n")
                continue
            if t == EOT:
                break
            out.append(t)
        s = " ".join(out)
        for p in ("( ", " )", " :", " ,", " [", " ]"):
            s = s.replace(p, p[1:])
        return s


def build_frozen_vocab(repo_root: Optional[str] = None) -> Dict[str, int]:
    """Compiles the static canonical vocabulary of all semantic atoms."""
    if repo_root is None:
        repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))

    specials = [PAD, BOS, SEP, EOT]
    structural = [
        "STATE", "AUCTION", "HAND", "EXPLANATION", "RULE", "BID", "FALLBACK_PASS",
        "dealer", "vuln", "seat", "turn", "NORTH", "EAST", "SOUTH", "WEST",
    ]
    punct = [
        "=", ":", "-", "(", ")", "[", "]", ",", "'", '"', "!",
        ">", "<", ">=", "<=", "==", "!=", "in", "not_in",
    ]
    suits_ranks = ["S", "H", "D", "C", "NT", "A", "K", "Q", "J", "T"]
    digits = [str(d) for d in range(10)]
    literals = ["True", "False", "None", "NONE", "BOTH", "NS", "EW"]
    calls = CALLS_38

    # Rules across all system DSLs
    rules = set()
    dsl_files = glob.glob(os.path.join(repo_root, "system", "*.dsl")) + \
                glob.glob(os.path.join(repo_root, "system", "history", "*.dsl"))
    for f in dsl_files:
        try:
            with open(f) as fh:
                for line in fh:
                    if line.lstrip().startswith("#"):
                        continue  # comments are prose, never semantic atoms
                    m = re.match(r"RULE\s+([A-Za-z0-9_]+)", line)
                    if m:
                        rules.add(m.group(1))
        except Exception:
            pass

    # Rules across existing traces
    for tf in glob.glob(os.path.join(repo_root, "data", "traces", "*.jsonl")):
        try:
            with open(tf) as fh:
                for line in fh:
                    obj = json.loads(line)
                    rule = obj.get("explanation", {}).get("rule")
                    if rule:
                        rules.add(rule)
                    for r in obj.get("explanation", {}).get("all_matched", []):
                        rules.add(r)
        except Exception:
            pass

    # Features extracted in BridgeFeatures
    from bid.features import BridgeFeatures
    from bid.eval_vs_dds import build_deals
    from bid.models import Seat
    deals = build_deals(1, seed=42)
    feats = BridgeFeatures.extract_all(deals[0].hands[Seat.NORTH], [], Seat.NORTH, Seat.NORTH, 0)
    feat_keys = set(feats.keys())

    for f in dsl_files:
        try:
            with open(f) as fh:
                for line in fh:
                    if line.lstrip().startswith("#"):
                        continue  # comments are prose, never semantic atoms
                    m = re.findall(r"(\b[a-zA-Z_][a-zA-Z0-9_]*)\s*(?:==|!=|>=|<=|>|<|in\b|not_in\b)", line)
                    for k in m:
                        feat_keys.add(k)
        except Exception:
            pass

    tags = [
        "ARB_SYSTEM", "ARB_STUDENT_LEGAL", "ARB_STUDENT_ILLEGAL", "ARB_THIRD",
        "student_confidence", "student_entropy",
    ]

    all_atoms: List[str] = []
    seen = set()
    for grp in [specials, structural, punct, suits_ranks, digits, literals, calls,
                sorted(rules), sorted(feat_keys), tags]:
        for tok in grp:
            if tok not in seen:
                seen.add(tok)
                all_atoms.append(tok)

    # Frozen ids are immutable: trained checkpoints embed them.  Reconcile
    # against data/cot_dataset/vocab.json — keep every existing assignment
    # verbatim and APPEND only atoms the corpus gained since it was frozen.
    # (Delete vocab.json deliberately to force a full remap.)
    frozen_path = os.path.join(repo_root, "data", "cot_dataset", "vocab.json")
    if os.path.exists(frozen_path):
        with open(frozen_path) as fh:
            frozen = json.load(fh)
        vocab = dict(frozen)
        next_id = max(frozen.values(), default=-1) + 1
        for tok in all_atoms:
            if tok not in vocab:
                vocab[tok] = next_id
                next_id += 1
        return vocab

    return {tok: i for i, tok in enumerate(all_atoms)}


if __name__ == "__main__":
    vocab = build_frozen_vocab()
    print(f"Generated frozen vocab with {len(vocab)} tokens.")
