#!/usr/bin/env python3
"""
mine_disagreements.py — active-disagreement mining + verified relabeling.

Replays auctions of the current DSL system while querying BOTH:
  * the symbolic teacher (low-budget PIDM decide, exactly like trace_factory)
  * the trained CoT student (greedy decode from its state prefix)

Where the two disagree, a HIGH-BUDGET PIDM search arbitrates and emits an
augmented trace row using the exact trace_factory schema:

  * the label comes from a stronger search than the base corpus
    (verified relabeling: labels better than the ones that made the corpus),
  * rows are keyed-deduped across runs,
  * per-run stats show how often the student flagged genuine gaps
    (arb agrees with student against the system) vs plain student errors.

Output feeds straight back into training:
    PYTHONPATH=.. python3 mine_disagreements.py --boards 200
    cat data/traces/traces.jsonl data/traces/disagreements.jsonl > combined
    python3 build_cot_dataset.py combined

Usage:
  PYTHONPATH=.. python3 mine_disagreements.py [--boards 24] [--seed 42]
      [--ckpt data/cot_model/ckpt.pt] [--out data/traces/disagreements.jsonl]
"""

import argparse
import hashlib
import json
import os
import sys
import time

from bid.models import Seat
from bid.features import BridgeFeatures
from bid.pidm import PIDMEngine
from bid.sampling import PartialState, RBMBMCSampler

from eval_vs_dds import build_deals, load_decision_net_dsl, SYSTEM_DIR
from trace_factory import hand_str, serialize_features, trace_object

try:
    import torch
    from cot_model import COTModel, pick_device, PAD_ID, SEP_ID, EOT_ID
    TORCH = True
except ImportError:
    TORCH = False


class StudentPolicy:
    """Greedy-decode bid oracle over the trained CoT transformer."""

    def __init__(self, ckpt_path):
        if not TORCH:
            sys.exit("torch not installed")
        vocab_path = ckpt_path + ".vocab.json"
        if not os.path.exists(ckpt_path):
            sys.exit(f"no checkpoint at {ckpt_path}")
        if not os.path.exists(vocab_path):
            sys.exit(f"no vocab sidecar at {vocab_path} (train first)")
        self.vocab = json.load(open(vocab_path))
        self.inv = {i: t for t, i in self.vocab.items()}
        sd = torch.load(ckpt_path, map_location="cpu")
        block = (int(sd["pos_emb.weight"].shape[0])
                 if "pos_emb.weight" in sd else 128)
        self.block = block
        self.dev = pick_device()
        self.model = COTModel(len(self.vocab), block_size=block).to(self.dev)
        self.model.load_state_dict(sd)
        self.model.to(self.dev)
        self.model.eval()
        print(f"student ready: {os.path.basename(ckpt_path)} "
              f"| device={self.dev} block={block}")

    def prefix_ids(self, dealer, vuln, seat, turn, auction_strs, hand):
        V = self.vocab
        lines = [
            f"<bos> STATE dealer={dealer} vuln={vuln}",
            f"seat={seat} turn={turn}",
            ("AUCTION " + " ".join(auction_strs)) if auction_strs
            else "AUCTION -",
            f"HAND {hand}",
        ]
        ids = [V["<bos>"]]
        for ln in lines:
            ids += [V[t] for t in _tokens(ln) if t in V]
        ids.append(V["<sep>"])
        return ids

    def bid(self, dealer, vuln, seat_name, turn, auction_strs, hand_str_,
            max_new=48, temp=0.0):
        """Returns (bid_string_or_None, generated_text)."""
        ids = self.prefix_ids(dealer, vuln, seat_name, turn,
                              auction_strs, hand_str_)
        with torch.no_grad():
            for _ in range(max_new):
                x = torch.tensor([ids[-self.block:]]).to(self.dev)
                logits, _ = self.model(x)
                nxt = int(torch.argmax(logits[0, -1]))
                if nxt in (EOT_ID, PAD_ID, SEP_ID):
                    break
                ids.append(nxt)
        toks = [self.inv[i] for i in ids]
        text = " ".join(toks)
        parts = text.split()
        if "BID" not in parts:
            return None, text
        k = len(parts) - parts[::-1].index("BID")
        return " ".join(parts[k:]) or None, text


def _tokens(line):
    import re
    return re.compile(r"\w+|[^\w\s]").findall(line)


def dedup_key(obj):
    blob = json.dumps([obj["board"], obj["call_index"], obj["seat"],
                       obj["input"]["auction"], obj["input"]["hand"]],
                      sort_keys=True)
    return hashlib.sha256(blob.encode()).hexdigest()[:16]



def main():
    ap = argparse.ArgumentParser(
        description="Mine model-vs-system disagreements and relabel them "
                    "with high-budget PIDM search.")
    ap.add_argument("--boards", type=int, default=24)
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--dsl", default=os.path.join(SYSTEM_DIR,
                                                  "improved_system.dsl"))
    ap.add_argument("--ckpt", default="data/cot_model/ckpt.pt")
    ap.add_argument("--out", default="data/traces/disagreements.jsonl")
    ap.add_argument("--max-new", type=int, default=48)
    ap.add_argument("--heavy-samples", type=int, default=6)
    ap.add_argument("--heavy-timeout", type=float, default=0.35)
    args = ap.parse_args()

    student = StudentPolicy(args.ckpt)
    net = load_decision_net_dsl(args.dsl)
    models = {s: net for s in Seat}
    base_engine = PIDMEngine()          # identical budget to trace_factory
    heavy_engine = PIDMEngine(          # the referee / relabeler
        sampler=RBMBMCSampler(sample_size=args.heavy_samples,
                              max_iterations=20,
                              timeout_sec=args.heavy_timeout),
        max_lookahead_depth=2)

    deals = build_deals(args.boards, seed=args.seed,
                        include_stratified=False)
    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    seen = set()
    stats = {"decisions": 0, "forced": 0, "agreements": 0,
             "disagreements": 0, "arb_system_right": 0,
             "arb_student_right": 0, "arb_new_call": 0, "rows_written": 0}
    t0 = time.time()

    out_rows = []
    for b_idx, deal in enumerate(deals, 1):
        history, curr, n = [], deal.dealer, 0
        while not PartialState(curr, deal.hands[curr], history,
                               deal.dealer, deal.vuln).is_auction_over() \
                and n < 24:
            ps = PartialState(curr, deal.hands[curr], history,
                              deal.dealer, deal.vuln)
            feats = BridgeFeatures.extract_all(
                deal.hands[curr], history, curr, deal.dealer, deal.vuln)
            candidates = net.actions(deal.hands[curr], history, curr,
                                     deal.dealer, deal.vuln)
            cand_strs = {str(c) for c in candidates}
            call, values = base_engine.decide(ps, models)
            stats["decisions"] += 1

            if len(candidates) <= 1:
                stats["forced"] += 1
            else:
                s_bid, _text = student.bid(
                    deal.dealer.name, deal.vuln, curr.name, n,
                    [str(c) for c in history],
                    hand_str(deal.hands[curr]), max_new=args.max_new)
                if s_bid == str(call):
                    stats["agreements"] += 1
                else:
                    stats["disagreements"] += 1
                    illegal = s_bid is None or s_bid not in cand_strs
                    arb_call, arb_values = heavy_engine.decide(ps, models)
                    if str(arb_call) == str(call):
                        tag = "ARB_SYSTEM"
                        stats["arb_system_right"] += 1
                    elif s_bid is not None and str(arb_call) == s_bid:
                        tag = "ARB_STUDENT_LEGAL" if not illegal \
                            else "ARB_STUDENT_ILLEGAL"
                        stats["arb_student_right"] += 1
                    else:
                        tag = "ARB_THIRD"
                        stats["arb_new_call"] += 1
                    matched = [r for r in net.rules if r.matches(feats)]
                    obj = trace_object(deal, args.seed, b_idx, n, curr,
                                       history, feats, matched, candidates,
                                       arb_call, arb_values)
                    obj["explanation"]["all_matched"] = sorted(
                        set(obj["explanation"]["all_matched"]) | {tag})
                    key = dedup_key(obj)
                    if key not in seen:
                        seen.add(key)
                        out_rows.append(json.dumps(obj, default=str))
                        stats["rows_written"] += 1
            history.append(call)
            curr = Seat((curr.value + 1) % 4)
            n += 1
        if b_idx % 10 == 0 or b_idx == len(deals):
            print(f"  board {b_idx}/{len(deals)} | "
                  f"agree {stats['agreements']} "
                  f"disagree {stats['disagreements']} "
                  f"| rows {stats['rows_written']}", flush=True)

    with open(args.out, "a") as f:
        for row in out_rows:
            f.write(row + "\n")

    meta_path = os.path.splitext(args.out)[0] + ".meta.json"
    stats["elapsed_sec"] = round(time.time() - t0, 1)
    stats["dsl_sha256"] = _sha(args.dsl)
    stats["ckpt"] = os.path.relpath(args.ckpt)
    with open(meta_path, "w") as f:
        json.dump(stats, f, indent=2)

    d = max(1, stats["decisions"])
    print(f"\n==== mining summary -> {args.out} ====")
    print(f"  decisions      : {stats['decisions']} "
          f"(forced/skipped {stats['forced']})")
    print(f"  agreements     : {stats['agreements']} "
          f"({stats['agreements']/d*100:.1f}%)")
    print(f"  disagreements  : {stats['disagreements']} -> arb: "
          f"system {stats['arb_system_right']} | "
          f"student {stats['arb_student_right']} | "
          f"third option {stats['arb_new_call']}")
    print(f"  rows written   : {stats['rows_written']} (deduped; appended)")
    print(f"  elapsed        : {stats['elapsed_sec']}s | meta: {meta_path}")


def _sha(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


if __name__ == "__main__":
    main()
