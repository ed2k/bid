#!/usr/bin/env python3
"""
player_model.py — learned probabilistic player models for RBMBMC (#4).

The symbolic DecisionNets give only a binary answer to "would this player
make this call?". This module learns a *soft* probability distribution
P(call | context) from the trace corpus (data/traces/traces.jsonl), where
context is a compact discretization of the decision point:

    ctx = phase (opening/resp/comp/…) × hcp_bucket × shape
          × partner_called_bid × opponent_bid_present

Uses:
  * train a model from the current corpus and save as JSON
  * score world consistency SOFTLY during RBMBMC sampling: instead of
    counting 1 inconsistency per impossible call, add
    soft_weight * (-log2 P(call|ctx)) for every observed call.

CLI:
  PYTHONPATH=.. python3 player_model.py train --corpus data/traces/traces.jsonl
      [--out data/player_models/call_model.json] [--holdout 0.1]
  PYTHONPATH=.. python3 player_model.py score --model ... --corpus ...   # quick sanity eval
"""

import argparse
import collections
import json
import math
import os

FEATURE_KEYS = ["hcp", "is_balanced", "spade_len", "heart_len",
                "diamond_len", "club_len"]

HCP_BUCKETS = [(0, 7), (8, 10), (11, 13), (14, 16), (17, 19), (20, 99)]


def hcp_bucket(hcp):
    for i, (lo, hi) in enumerate(HCP_BUCKETS):
        if lo <= hcp <= hi:
            return i
    return len(HCP_BUCKETS) - 1


_SEAT_VAL = {"NORTH": 0, "EAST": 1, "SOUTH": 2, "WEST": 3}


def _partnership_flags(seat_name, call_index, auction_strs):
    """Did partner / opponents already make a non-PASS call before turn?"""
    my_val = _SEAT_VAL.get(seat_name)
    if my_val is None:
        return False, False
    p_bid = o_bid = False
    for i, s in enumerate(auction_strs[:call_index]):
        rel = (i - call_index) % 4      # relative seat index vs mine
        if s not in ("PASS", "-"):
            if rel == 2:                # partner sits 2 seats away
                p_bid = True
            elif rel in (1, 3):
                o_bid = True
    return p_bid, o_bid


def featurize(seat_name, call_index, auction_strs, feats_subset):
    """Compact context key. Works on serialized features (int/bool/str)."""
    n = len(auction_strs)
    started = any(s != "PASS" for s in auction_strs[:n])
    phase = ("open" if n == 0 else
             "passed" if not started else f"c{min(n // 4, 4)}")
    hcp = int(feats_subset.get("hcp", 0))
    lens = sorted((feats_subset.get("spade_len", 0),
                   feats_subset.get("heart_len", 0),
                   feats_subset.get("diamond_len", 0),
                   feats_subset.get("club_len", 0)), reverse=True)
    spread = lens[0] - lens[3]
    shape = ("bal" if feats_subset.get("is_balanced")
             else ("freak" if spread >= 4 else
                   "shaped" if spread >= 2 else "even"))
    p_bid, o_bid = _partnership_flags(seat_name, call_index, auction_strs)
    return (
        f"ph={phase}",
        f"h{hcp_bucket(hcp)}",
        shape,
        "pBID" if p_bid else "pNB",
        "oBID" if o_bid else "oNB",
    )


def subset_features(full_feats):
    return {k: full_feats.get(k) for k in FEATURE_KEYS}


from collections import Counter
from bid.models import Seat


class CallModel:
    """Add-smoothed table model over ctx -> call, with global backoff."""

    def __init__(self, alpha=12.0, backoff=0.4):
        self.alpha = alpha          # pseudo-count mass toward backoff mix
        self.backoff = backoff      # mixture weight of global distribution
        self.ctx_counts = {}        # ctx_key -> {bid: count}
        self.global_counts = Counter()
        self.n_ctx_total = {}

    @classmethod
    def train(cls, rows, **kw):
        m = cls(**kw)
        for r in rows:
            f = subset_features(r["input"].get("features") or {})
            ctx = "|".join(featurize(r["seat"], r["call_index"],
                                     r["input"]["auction"], f))
            d = m.ctx_counts.setdefault(ctx, {})
            d[r["bid"]] = d.get(r["bid"], 0) + 1
            m.global_counts[r["bid"]] += 1
        m.n_ctx_total = {c: sum(v.values()) for c, v in m.ctx_counts.items()}
        return m

    def prob(self, ctx_tuple, bid):
        """P(bid | ctx), smoothed against the global call distribution."""
        ctx = "|".join(ctx_tuple)
        cg = self.ctx_counts.get(ctx, {})
        tot_g = max(1, sum(self.global_counts.values()))
        vocab = set(self.global_counts) | set(cg) | {bid}
        V = max(1, len(vocab))
        p_global = (self.global_counts.get(bid, 0) + 1.0) / (tot_g + V)
        n_c = self.n_ctx_total.get(ctx, 0)
        if n_c == 0:
            return p_global
        p_ctx = (cg.get(bid, 0) + self.alpha * p_global) / (n_c + self.alpha)
        return self.backoff * p_global + (1 - self.backoff) * p_ctx

    def save(self, path):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        payload = {
            "alpha": self.alpha, "backoff": self.backoff,
            "ctx_counts": self.ctx_counts,
            "global_counts": dict(self.global_counts),
            "meta": {"contexts": len(self.ctx_counts),
                     "bids": len(self.global_counts)},
        }
        with open(path, "w") as f:
            json.dump(payload, f)

    @classmethod
    def load(cls, path):
        with open(path) as f:
            p = json.load(f)
        m = cls(alpha=p["alpha"], backoff=p["backoff"])
        m.ctx_counts = p["ctx_counts"]
        m.global_counts = Counter(p["global_counts"])
        m.n_ctx_total = {c: sum(v.values()) for c, v in m.ctx_counts.items()}

def eval_holdout(model, rows):
    """Top-1 accuracy + mean log-loss vs a smoothed unigram baseline."""
    tot_g = max(1, sum(model.global_counts.values()))
    V = max(1, len(model.global_counts))
    maj = model.global_counts.most_common(1)[0][0]
    bids = set(model.global_counts)
    hit = base_hit = 0
    ll_m = ll_b = 0.0
    for r in rows:
        f = subset_features(r["input"].get("features") or {})
        ctx = featurize(r["seat"], r["call_index"],
                        r["input"]["auction"], f)
        ll_m -= math.log2(max(model.prob(ctx, r["bid"]), 1e-9))
        p_uni = (model.global_counts.get(r["bid"], 0) + 1.0) / (tot_g + V)
        ll_b -= math.log2(max(p_uni, 1e-9))
        best = max(((model.prob(ctx, b), b) for b in bids),
                   key=lambda kv: kv[0])[1]
        hit += best == r["bid"]
        base_hit += maj == r["bid"]
    n = max(1, len(rows))
    return {"acc": hit / n, "base_acc": base_hit / n,
            "logloss_bits": ll_m / n, "baseline_logloss": ll_b / n,
            "n": n}


class SoftInconsistencyScorer:
    """
    Bridges a CallModel into RBMBMC as a soft world-consistency term.
    penalty(deal, history, dealer) = weight * sum_t -log2 P(hist_t | ctx_t).
    """

    def __init__(self, player_model, weight=0.15):
        self.pm = player_model
        self.weight = weight

    def penalty(self, deal, history, dealer):
        from bid.features import BridgeFeatures
        total = 0.0
        for t, call in enumerate(history):
            seat = Seat((dealer.value + t) % 4)
            f = BridgeFeatures.extract_all(deal.hands[seat], history[:t],
                                           seat, dealer, deal.vuln)
            sub = subset_features({k: getattr(v, "value", v)
                                   for k, v in f.items()})
            ctx = featurize(seat.name, t, [str(c) for c in history], sub)
            total += -math.log2(max(self.pm.prob(ctx, str(call)), 1e-6))
        return self.weight * total


def main():
    ap = argparse.ArgumentParser(description="Learned player models")
    sub = ap.add_subparsers(dest="cmd", required=True)
    tr = sub.add_parser("train")
    tr.add_argument("--corpus", default="data/traces/traces.jsonl")
    tr.add_argument("--out", default="data/player_models/call_model.json")
    tr.add_argument("--holdout", type=float, default=0.15)
    args = ap.parse_args()

    rows = [json.loads(l) for l in open(args.corpus)]
    import random as _r
    rng = _r.Random(7)
    rng.shuffle(rows)
    n_val = max(1, int(args.holdout * len(rows)))
    val, train = rows[:n_val], rows[n_val:]

    model = CallModel.train(train)
    model.save(args.out)
    res = eval_holdout(model, val)
    print(f"trained on {len(train)} rows "
          f"({len(model.ctx_counts)} contexts, "
          f"{len(model.global_counts)} distinct bids)")
    print(f"held-out ({len(val)} rows):")
    print(f"  top-1 accuracy : {res['acc']*100:.1f}% "
          f"(majority baseline {res['base_acc']*100:.1f}%)")
    print(f"  mean log-loss  : {res['logloss_bits']:.3f} bits "
          f"(baseline {res['baseline_logloss']:.3f})")
    print(f"saved -> {args.out}")


if __name__ == "__main__":
    main()

