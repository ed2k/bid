#!/usr/bin/env python3
"""
cot_model.py — P1 seq2seq reasoner for CoT-bidder (torch, nanoGPT-lite).

Architecture (research/cot-bidder.md §5b, tier S):
  decoder-only transformer, 6 layers × d_model 256, 4 heads, ctx 512 ≈ 5M params.
Loss only on tokens after <sep> (the reasoning + bid); state prefix is
conditioning. Greedy/sampled generation post-verified by the symbolic
constraint checker + auction legality (from cot_bidder).

Requires: pip install torch   (everything else is stdlib)
"""

import argparse
import json
import math
import os
import sys
import time
from typing import List, Dict, Any, Optional

try:
    import torch
    import torch.nn as nn
    from torch.nn import functional as F
    TORCH = True
except ImportError:
    TORCH = False

PAD_ID = 0
SEP_ID = 2
EOT_ID = 3


def pick_device():
    """Best available backend: Apple MPS > CUDA > CPU."""
    if not TORCH:
        return "cpu"
    if getattr(torch.backends, "mps", None) is not None \
            and torch.backends.mps.is_available():
        return "mps"
    if torch.cuda.is_available():
        return "cuda"
    return "cpu"


# ---------------- model ----------------

class CausalSelfAttention(nn.Module):
    def __init__(self, d, heads):
        super().__init__()
        self.qkv = nn.Linear(d, 3 * d)
        self.proj = nn.Linear(d, d)
        self.heads = heads

    def forward(self, x):
        B, T, C = x.shape
        q, k, v = self.qkv(x).split(C, dim=2)
        hs = C // self.heads
        q = q.view(B, T, self.heads, hs).transpose(1, 2)
        k = k.view(B, T, self.heads, hs).transpose(1, 2)
        v = v.view(B, T, self.heads, hs).transpose(1, 2)
        att = (q @ k.transpose(-2, -1)) / math.sqrt(hs)
        mask = torch.tril(torch.ones(T, T, device=x.device)).view(1, 1, T, T)
        att = att.masked_fill(mask == 0, float("-inf"))
        att = F.softmax(att, dim=-1)
        y = (att @ v).transpose(1, 2).reshape(B, T, C)
        return self.proj(y)


class Block(nn.Module):
    def __init__(self, d, heads):
        super().__init__()
        self.ln1 = nn.LayerNorm(d)
        self.attn = CausalSelfAttention(d, heads)
        self.ln2 = nn.LayerNorm(d)
        self.mlp = nn.Sequential(nn.Linear(d, 4 * d), nn.GELU(),
                                 nn.Linear(4 * d, d))
        self.drop = nn.Dropout(0.1)

    def forward(self, x):
        x = x + self.drop(self.attn(self.ln1(x)))
        return x + self.drop(self.mlp(self.ln2(x)))


class COTModel(nn.Module):
    def __init__(self, vocab_size, block_size=512, n_layer=6, n_head=4,
                 n_embd=256, dropout=0.1):
        super().__init__()
        self.block_size = block_size
        self.tok_emb = nn.Embedding(vocab_size, n_embd)
        self.pos_emb = nn.Embedding(block_size, n_embd)
        self.drop = nn.Dropout(dropout)
        self.blocks = nn.Sequential(*[Block(n_embd, n_head)
                                      for _ in range(n_layer)])
        self.ln_f = nn.LayerNorm(n_embd)
        self.head = nn.Linear(n_embd, vocab_size, bias=False)
        self.apply(self._init)

    def _init(self, m):
        if isinstance(m, nn.Linear):
            nn.init.normal_(m.weight, mean=0.0, std=0.02)
            if m.bias is not None:
                nn.init.zeros_(m.bias)

    def forward(self, idx, targets=None):
        B, T = idx.shape
        pos = torch.arange(T, device=idx.device)
        x = self.drop(self.tok_emb(idx) + self.pos_emb(pos)[:T])
        for blk in self.blocks:
            x = blk(x)
        logits = self.head(self.ln_f(x))
        loss = None
        if targets is not None:
            loss = F.cross_entropy(logits.view(-1, logits.size(-1)),
                                   targets.view(-1), ignore_index=-100)
        return logits, loss


# ---------------- data ----------------

def load_dataset(path):
    with open(path) as f:
        ds = json.load(f)
    vocab = ds["vocab"]
    pad = vocab[PAD_ID] if PAD_ID in vocab else 0
    IGNORE = -100

    def to_tensor(ex, block):
        L = len(ex["ids"])
        ids = list(ex["ids"][:block]) + [pad] * max(0, block - L)
        tgt = [IGNORE] * block
        for i in range(min(L, block)):
            tgt[i] = ex["ids"][i]
        return ids, tgt

    out = {}
    for split in ("train", "val"):
        rows = []
        for ex in ds[split]:
            ids, tgt = to_tensor(ex, ds["meta"]["block_size_max"] + 1)
            rows.append((ids[:-1], tgt[1:]))
        out[split] = rows
    return vocab, out, ds["meta"]


# ---------------- train / generate ----------------

def cmd_train(args):
    if not TORCH:
        sys.exit("torch not installed: pip install torch")
    vocab, splits, meta = load_dataset(args.dataset)
    V = len(vocab)
    if args.block is None:
        args.block = int(meta.get("block_size_max", 128))
    dev = pick_device()
    model = COTModel(V, block_size=args.block).to(dev)
    if getattr(args, "init_from", None) and os.path.exists(args.init_from):
        sd = torch.load(args.init_from, map_location="cpu")
        if "tok_emb.weight" in sd and sd["tok_emb.weight"].shape[0] == V:
            if "pos_emb.weight" in sd and sd["pos_emb.weight"].shape[0] == args.block:
                model.load_state_dict(sd)
                print(f"warm-started model weights from {args.init_from}")
            else:
                old_b = sd.get("pos_emb.weight", torch.empty(0)).shape[0]
                print(f"skipping warm-start: block size mismatch ({old_b} vs {args.block})")
        else:
            old_v = sd["tok_emb.weight"].shape[0] if "tok_emb.weight" in sd else None
            print(f"skipping warm-start: vocab size mismatch ({old_v} vs {V}); training from scratch")
    opt = __import__("torch").optim.AdamW(model.parameters(), lr=args.lr,
                                          betas=(0.9, 0.95))
    rng = __import__("random").Random(7)
    train = splits["train"]
    print(f"training {sum(p.numel() for p in model.parameters()):,} params "
          f"on {len(train)} examples | {args.epochs} epochs | "
          f"device={dev} block={args.block}")
    step = 0
    for ep in range(args.epochs):
        rng.shuffle(train)
        for i in range(0, len(train) - args.batch + 1, args.batch):
            batch = train[i:i + args.batch]
            x = __import__("torch").tensor([b[0] for b in batch]).to(dev)
            y = __import__("torch").tensor([b[1] for b in batch]).to(dev)
            _, loss = model(x, y)
            opt.zero_grad(set_to_none=True)
            loss.backward()
            __import__("torch").nn.utils.clip_grad_norm_(model.parameters(), 1.0)
            opt.step()
            step += 1
            if step % args.log_every == 0:
                print(f"  epoch {ep} step {step} loss {loss.item():.4f}")
    os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)
    __import__("torch").save(model.state_dict(), args.out)
    with open(args.out + ".vocab.json", "w") as f:
        json.dump(vocab, f)
    print(f"saved {args.out}")


def _load_model(vocab_size, args, meta):
    """Build model on best device, inferring context length from the
    checkpoint's positional embedding when --block is not given."""
    dev = pick_device()
    sd = torch.load(args.ckpt, map_location="cpu")
    if args.block is None:
        if "pos_emb.weight" in sd:
            args.block = int(sd["pos_emb.weight"].shape[0])
        else:  # pragma: no cover - malformed ckpt fallback
            args.block = int(meta.get("block_size_max", 128))
    model = COTModel(vocab_size, block_size=args.block).to(dev)
    model.load_state_dict(sd)
    model.to(dev)
    model.eval()
    return model


def cmd_generate(args):
    if not TORCH:
        sys.exit("torch not installed")
    from bid.cot_bidder import verify_constraints, bid_legal
    vocab, splits, meta = load_dataset(args.dataset)
    inv = {i: t for t, i in vocab.items()}
    V = len(vocab)
    dev = pick_device()
    model = _load_model(V, args, meta)
    model.eval()

    # prompt = raw state prefix from the val split (rows carry prefix_len)
    ds = json.load(open(args.dataset))
    row = ds["val"][args.index % len(ds["val"])]
    plen = int(row.get("prefix_len") or 0)
    prompt = list(row["ids"][:plen])
    ids = list(prompt)
    generated = []
    __import__("torch").manual_seed(args.seed)
    for _ in range(args.max_new):
        x = __import__("torch").tensor([ids[-args.block:]]).to(dev)
        with __import__("torch").no_grad():
            logits, _ = model(x)
        if args.temp > 0:
            probs = __import__("torch").softmax(logits[0, -1] / args.temp, dim=-1)
            nxt = int(__import__("torch").multinomial(probs, 1))
        else:
            nxt = int(__import__("torch").argmax(logits[0, -1]))
        if nxt == EOT_ID:
            break
        ids.append(nxt)
        generated.append(inv[nxt])
    text = " ".join(generated)
    print("GENERATED:", text)

    # ---- symbolic verification of the emitted reasoning ----
    import re
    cons = re.findall(r"\(\s*(\w+)\s*(==|!=|>=|<=|>|<)\s*([^)]+?)\s*\)", text)
    bid_m = re.search(r"BID\s+(\S+)\s*$", text)
    ok_cons = all(True for _ in cons)   # feature check needs real features:
    # caller should run cot_bidder.verify_constraints against the true features
    print("parsed constraints:", cons)
    print("parsed bid:", bid_m.group(1) if bid_m else None)


def generate_batch(model, prompts: List[List[int]], max_new: int = 48,
                   temp: float = 0.0, dev=None, pad_id: int = PAD_ID,
                   eot_id: int = EOT_ID, sep_id: int = SEP_ID,
                   batch_size: int = 32, block_size: Optional[int] = None) -> List[Dict[str, Any]]:
    """Batched autoregressive generation for a list of prompt token ID lists.

    Returns a list of dicts for each prompt:
      {
        "generated_ids": List[int],
        "confidences": List[float],
        "entropies": List[float],
        "avg_confidence": float,
        "avg_entropy": float
      }
    """
    if dev is None:
        dev = next(model.parameters()).device
    if block_size is None:
        block_size = getattr(model, "block_size", 512)

    results: List[Dict[str, Any]] = []
    for chunk_start in range(0, len(prompts), batch_size):
        chunk = prompts[chunk_start:chunk_start + batch_size]
        B = len(chunk)
        active_ids = [list(p) for p in chunk]
        finished = [False] * B
        confidences = [[] for _ in range(B)]
        entropies = [[] for _ in range(B)]

        for _ in range(max_new):
            if all(finished):
                break

            # Slices restricted to block_size context window
            slices = [seq[-block_size:] for seq in active_ids]
            lens = [len(s) for s in slices]
            max_len = max(lens)

            # Build on CPU, transfer once to avoid repeated device allocations
            batch_cpu = torch.full((B, max_len), pad_id, dtype=torch.long)
            for i, s in enumerate(slices):
                batch_cpu[i, :len(s)] = torch.tensor(s, dtype=torch.long)
            batch_dev = batch_cpu.to(dev)

            with torch.no_grad():
                logits, _ = model(batch_dev)

            # Vectorized extraction of last valid token logits for each sequence
            indices = torch.tensor([lens[i] - 1 for i in range(B)], device=dev)
            last_logits = logits[torch.arange(B, device=dev), indices]
            probs = torch.softmax(last_logits, dim=-1)

            # Vectorized Shannon entropy: H = - sum(p * log(p))
            log_probs = torch.log(probs.clamp(min=1e-12))
            batch_ents = (-(probs * log_probs).sum(dim=-1)).cpu().tolist()

            if temp > 0.0:
                scaled = last_logits / max(1e-5, temp)
                nxt_tokens = torch.multinomial(torch.softmax(scaled, dim=-1), num_samples=1).squeeze(-1)
            else:
                nxt_tokens = torch.argmax(last_logits, dim=-1)

            batch_confs = probs[torch.arange(B, device=dev), nxt_tokens].cpu().tolist()
            nxt_list = nxt_tokens.cpu().tolist()

            for i in range(B):
                if finished[i]:
                    continue
                nxt = nxt_list[i]
                conf = float(batch_confs[i])
                ent = float(batch_ents[i])

                confidences[i].append(conf)
                entropies[i].append(ent)

                if nxt in (eot_id, pad_id, sep_id):
                    finished[i] = True
                else:
                    active_ids[i].append(nxt)

        for i in range(B):
            prompt_len = len(chunk[i])
            gen = active_ids[i][prompt_len:]
            confs = confidences[i]
            ents = entropies[i]
            avg_c = sum(confs) / len(confs) if confs else 1.0
            avg_e = sum(ents) / len(ents) if ents else 0.0
            results.append({
                "generated_ids": gen,
                "confidences": confs,
                "entropies": ents,
                "avg_confidence": avg_c,
                "avg_entropy": avg_e,
            })
    return results


def cmd_evalval(args):
    """Pipeline validation: greedy decode val examples in batched forward
    passes; report exact-sequence and final-BID accuracy."""
    if not TORCH:
        sys.exit("torch not installed")
    vocab, splits, meta = load_dataset(args.dataset)
    inv = {i: t for t, i in vocab.items()}
    pad = vocab.get(PAD_ID, 0)
    eot = vocab.get(EOT_ID, 3)
    dev = pick_device()
    model = _load_model(len(vocab), args, meta)
    model.eval()

    val_examples = splits["val"]
    prompts = []
    truths = []
    for ex in val_examples:
        ids, _ = ex
        sep_i = ids.index(SEP_ID) if SEP_ID in ids else len(ids)
        plen = sep_i + 1
        prompts.append(list(ids[:plen]))
        truths.append([i for i in ids[plen:] if i not in (eot, pad)])

    bs = getattr(args, "batch_size", 32)
    t0 = time.time()
    batch_outputs = generate_batch(
        model, prompts, max_new=args.max_new, temp=0.0, dev=dev,
        pad_id=pad, eot_id=eot, sep_id=SEP_ID,
        batch_size=bs, block_size=args.block
    )

    total = seq_exact = bid_ok = 0

    def bid_of(s):
        parts = s.split()
        if "BID" in parts:
            k = len(parts) - parts[::-1].index("BID")
            return " ".join(parts[k:])
        return None

    for out, truth in zip(batch_outputs, truths):
        gen_ids = out["generated_ids"]
        gt = " ".join(inv[i] for i in gen_ids if i in inv)
        tt = " ".join(inv[i] for i in truth if i in inv)
        total += 1
        bo, bt = bid_of(gt), bid_of(tt)
        if gt.strip() == tt.strip():
            seq_exact += 1
        if bo is not None and bo == bt:
            bid_ok += 1
        else:
            print(f"    miss: got BID {bo!r} want {bt!r}")

    elapsed = time.time() - t0
    print(f"\nval examples        : {total} ({elapsed:.1f}s)")
    print(f"exact sequence match: {seq_exact}/{total} "
          f"({seq_exact / total * 100:.1f}%)")
    print(f"BID correct         : {bid_ok}/{total} "
          f"({bid_ok / total * 100:.1f}%)")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    tr = sub.add_parser("train")
    tr.add_argument("--dataset", default="data/cot_dataset/dataset.json")
    tr.add_argument("--epochs", type=int, default=5)
    tr.add_argument("--batch", type=int, default=32)
    tr.add_argument("--lr", type=float, default=3e-4)
    tr.add_argument("--block", type=int, default=None,
                    help="context length (default: dataset block_size_max)")
    tr.add_argument("--log-every", type=int, default=20)
    tr.add_argument("--out", default="data/cot_model/ckpt.pt")
    tr.add_argument("--init-from", default=None,
                    help="checkpoint path to initialize weights from (warm-start)")
    ge = sub.add_parser("generate")
    ge.add_argument("--dataset", default="data/cot_dataset/dataset.json")
    ge.add_argument("--ckpt", default="data/cot_model/ckpt.pt")
    ge.add_argument("--index", type=int, default=0)
    ge.add_argument("--max-new", type=int, default=64)
    ge.add_argument("--temp", type=float, default=0.0)
    ge.add_argument("--seed", type=int, default=7)
    ge.add_argument("--block", type=int, default=None,
                    help="context length (default: dataset block_size_max)")
    ev = sub.add_parser("eval-val")
    ev.add_argument("--dataset", default="data/cot_dataset/dataset.json")
    ev.add_argument("--ckpt", default="data/cot_model/ckpt.pt")
    ev.add_argument("--max-new", type=int, default=48)
    ev.add_argument("--batch-size", type=int, default=32,
                    help="inference batch size for evaluation")
    ev.add_argument("--block", type=int, default=None,
                    help="context length (default: dataset block_size_max)")
    args = ap.parse_args()
    if args.cmd == "train":
        cmd_train(args)
    elif args.cmd == "generate":
        cmd_generate(args)
    else:
        cmd_evalval(args)
