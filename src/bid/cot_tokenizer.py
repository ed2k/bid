#!/usr/bin/env python3
"""
cot_tokenizer.py — field-level tokenizer for CoT-bidder traces.

Splits trace text into a tiny closed vocabulary (words, numbers, operators,
punctuation). Deterministic; no external dependencies.

Special tokens: <pad>=0 <bos>=1 <sep>=2 <eot>=3
"""

import json
import re
from typing import Dict, List, Tuple

PAD, BOS, SEP, EOT = "<pad>", "<bos>", "<sep>", "<eot>"
SPECIALS = [PAD, BOS, SEP, EOT]

_TOKEN_RE = re.compile(r"\w+|[^\w\s]")


def tokenize_line(line: str) -> List[str]:
    return _TOKEN_RE.findall(line)


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
            if cnt >= min_count:
                vocab[tok] = len(vocab)
        return cls(vocab)

    @classmethod
    def load(cls, path: str) -> "Tokenizer":
        with open(path) as f:
            return cls(json.load(f))

    def save(self, path: str) -> None:
        with open(path, "w") as f:
            json.dump(self.vocab, f, indent=0, sort_keys=True)

    def encode_line(self, line: str) -> List[int]:
        unk = self.vocab.get("<unk>")
        return [self.vocab[t] for t in tokenize_line(line)
                if t in self.vocab] if unk is None else \
               [self.vocab.get(t, unk) for t in tokenize_line(line)]

    def decode(self, ids: List[int]) -> str:
        toks = [self.inv[i] for i in ids if self.inv[i] not in (PAD, BOS)]
        out, prev_special = [], False
        for t in toks:
            if t == SEP:
                out.append("\n")
                continue
            if t == EOT:
                break
            out.append(t)
        # light re-join: spaces between alnum tokens, none around punctuation
        s = " ".join(out)
        for p in ("( ", " )", " :", " ,", " |", " >=", " <=", " ==", " >", " <"):
            s = s.replace(p, p[1:])
        return s


def example_lines(trace_obj: dict) -> Tuple[List[str], List[str]]:
    """Returns (prefix_lines, target_lines) for one training example."""
    inp = trace_obj["input"]
    board = trace_obj["board"]
    prefix = [
        f"<bos> STATE dealer={board['dealer']} vuln={board['vuln']}",
        f"seat={trace_obj['seat']} turn={trace_obj['call_index']}",
        "AUCTION " + " ".join(inp["auction"]) if inp["auction"] else "AUCTION -",
        "HAND " + inp["hand"],
    ]
    exp = trace_obj["explanation"]
    cons = " ".join(f"( {k} {op} {v} )" for k, op, v in exp["constraints"])
    target = [
        f"EXPLANATION RULE {exp['rule']} {cons}".strip(),
        f"BID {trace_obj['bid']}",
        "<eot>",
    ]
    return prefix, target


if __name__ == "__main__":
    print(tokenize_line("EXPLANATION RULE R_1D( hcp >= 12 )( diamond_len >= 4 )"))
