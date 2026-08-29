#!/usr/bin/env python3
"""
build_cot_dataset.py — converts traces.jsonl into a training dataset:

  data/cot_dataset/dataset.json {
    "vocab": {token: id},
    "train": [{"ids":[...], "prefix_len":P}, ...],   # loss only on ids[P:]
    "val":   [...],
    "meta": {...}
  }

Layout per example:
  <bos> STATE ... AUCTION ... HAND ... <sep> EXPLANATION ... BID x <eot>
"""

import json
import os
import sys

from cot_tokenizer import Tokenizer, PAD, BOS, SEP, EOT, example_lines


def _sha256(path):
    import hashlib
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def build_example(tok: Tokenizer, trace_obj: dict):
    prefix_lines, target_lines = example_lines(trace_obj)
    V = tok.vocab
    ids = [V[BOS]]
    for line in prefix_lines:
        ids += tok.encode_line(line)
    ids.append(V[SEP])                      # real special id, not split text
    prefix_len = len(ids)
    for line in target_lines:
        if line == EOT:
            ids.append(V[EOT])
        else:
            ids += tok.encode_line(line)
    ids.append(V[EOT])
    return {"ids": ids, "prefix_len": prefix_len}


def main():
    corpus = sys.argv[1] if len(sys.argv) > 1 else "data/traces/traces.jsonl"
    outdir = "data/cot_dataset"
    os.makedirs(outdir, exist_ok=True)

    traces = [json.loads(l) for l in open(corpus)]
    all_lines = []
    for t in traces:
        pre, tgt = example_lines(t)
        all_lines += pre + tgt
    tok = Tokenizer.train(all_lines)

    rng = __import__("random").Random(7)
    idxs = list(range(len(traces)))
    rng.shuffle(idxs)
    n_val = max(1, int(0.1 * len(traces)))
    val_idx = set(idxs[:n_val])

    split = {"train": [], "val": []}
    total_tokens = 0
    for i, t in enumerate(traces):
        ex = build_example(tok, t)
        ex["ids"] = [tok.vocab[PAD]] + ex["ids"]     # leading pad for shift
        total_tokens += len(ex["ids"])
        split["val" if i in val_idx else "train"].append(ex)

    meta = {"corpus": corpus, "n_traces": len(traces),
            "corpus_sha256": _sha256(corpus) if os.path.exists(corpus) else None,
            "vocab_size": len(tok.vocab),
            "block_size_max": max(len(e["ids"]) for e in
                                  split["train"] + split["val"]),
            "total_tokens": total_tokens}
    out = {"vocab": tok.vocab, "meta": meta,
           "train": split["train"], "val": split["val"]}
    path = os.path.join(outdir, "dataset.json")
    with open(path, "w") as f:
        json.dump(out, f)
    print(f"dataset -> {path}")
    print(f"  traces {len(traces)} | vocab {len(tok.vocab)} | "
          f"max block {meta['block_size_max']} | tokens {total_tokens:,} "
          f"| train/val {len(split['train'])}/{len(split['val'])}")


if __name__ == "__main__":
    main()
