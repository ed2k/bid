#!/usr/bin/env python3
"""
cot_export_web.py — export the trained CoT transformer (data/cot_model/ckpt.pt)
to static browser artifacts under web/models/cot/ so the review UI can run the
SAME student model the Python loops trained.

  manifest.json  config (dims, block, n_head), the token vocabulary, and a
                 tensor index into weights.bin
  weights.bin    all tensors concatenated as little-endian FP16 (~10 MB)

Usage:
  python3 -m bid.cot_export_web [--ckpt data/cot_model/ckpt.pt]
                                [--vocab data/cot_model/ckpt.pt.vocab.json]
                                [--out web/models/cot]
"""

import argparse
import json
import os
import struct

import torch

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))


def main():
    ap = argparse.ArgumentParser(description="Export CoT student for the browser")
    ap.add_argument("--ckpt", default=os.path.join(REPO_ROOT, "data", "cot_model", "ckpt.pt"))
    ap.add_argument("--vocab", default=os.path.join(REPO_ROOT, "data", "cot_model", "ckpt.pt.vocab.json"))
    ap.add_argument("--out", default=os.path.join(REPO_ROOT, "web", "models", "cot"))
    args = ap.parse_args()

    sd = torch.load(args.ckpt, map_location="cpu")
    if isinstance(sd, dict) and "model" in sd:
        sd = sd["model"]

    with open(args.vocab) as f:
        vocab = json.load(f)

    vocab_size, n_embd = sd["tok_emb.weight"].shape
    block = sd["pos_emb.weight"].shape[0]
    n_layer = len({k.split(".")[1] for k in sd if k.startswith("blocks.")})
    # head dims: qkv is (3*d, d); heads default to 4 in cot_model.train
    n_head = 4

    order = list(sd.keys())
    index, blob = {}, bytearray()
    for name in order:
        t = sd[name].to(torch.float32).contiguous()
        raw = t.numpy().tobytes()
        index[name] = {"shape": list(t.shape), "offset": len(blob),
                       "bytes": len(raw)}
        blob.extend(raw)

    os.makedirs(args.out, exist_ok=True)
    manifest = {
        "format": "bid-cot-student",
        "version": 1,
        "dtype": "fp32",
        "config": {"vocab_size": int(vocab_size), "block": int(block),
                   "n_layer": int(n_layer), "n_embd": int(n_embd),
                   "n_head": int(n_head)},
        "vocab": vocab,
        "tensors": index,
        "source_ckpt": os.path.relpath(args.ckpt, REPO_ROOT),
    }
    with open(os.path.join(args.out, "manifest.json"), "w") as f:
        json.dump(manifest, f)
    with open(os.path.join(args.out, "weights.bin"), "wb") as f:
        f.write(bytes(blob))

    print(f"exported -> {args.out} ({len(blob) / 1e6:.1f} MB fp32, "
          f"{len(order)} tensors | vocab {vocab_size} | block {block} | "
          f"{n_layer} layers x {n_embd} d)")


if __name__ == "__main__":
    main()
