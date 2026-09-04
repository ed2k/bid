#!/usr/bin/env python3
"""
trace_factory.py — generates (position → explanation → bid) training triples
from self-play auctions of the current system.

Output: JSONL, one object per CALL. Schema in research/cot-bidder.md §3.
Invariants: bid == system choice (legal), constraints all hold on features,
`forced` flag marks single-candidate decisions.
"""

import argparse
import json
import os
import random
import sys
import time

from bid.models import Seat, Suit, Strain, Rank, Call, CallType, Hand
from bid.sampling import Deal, PartialState
from bid.features import BridgeFeatures
from bid.pidm import PIDMEngine

from bid.eval_vs_dds import build_deals, load_decision_net_dsl, SYSTEM_DIR

FEATURE_KEYS = ["hcp", "total_points", "spade_len", "heart_len",
                "diamond_len", "club_len", "is_balanced", "is_opening",
                "controls", "partner_last_call", "my_last_call",
                "opp_last_call", "is_vulnerable", "is_favorable_vuln"]


def hand_str(hand):
    parts = []
    for suit in (Suit.SPADES, Suit.HEARTS, Suit.DIAMONDS, Suit.CLUBS):
        cards = " ".join(str(c.rank) for c in
                         sorted(hand.by_suit[suit], key=lambda c: c.rank.value,
                                reverse=True))
        parts.append(f"{suit.name[0]} : {cards or '-'}")
    return " ".join(parts)


def serialize_features(feats):
    """Full copy — explanation constraints may reference any extracted key."""
    out = {}
    for k, v in feats.items():
        v = getattr(v, "value", v)
        if isinstance(v, (int, float, bool, str)) or (
                isinstance(v, list) and all(
                    isinstance(x, (int, float, bool, str))
                    or hasattr(x, "value") for x in v)):
            if isinstance(v, list):
                v = [getattr(x, "value", x) for x in v]
            out[k] = v
    return out


def trace_object(deal, seed, board_idx, call_index, seat, history, feats,
                 matched_rules, candidates, call, values):
    forced = len(candidates) == 1
    agreeing = [r for r in matched_rules
                if str(r.call) == str(call)] or matched_rules
    top = max(agreeing, key=lambda r: r.priority) if agreeing else None
    constraints = [[c.key, c.op, getattr(c.value, "value", c.value)]
                   for c in (top.conditions if top else [])]
    explanation = {
        "rule": top.rule_id if top else None,
        "constraints": constraints,
        "text": f"RULE {top.rule_id}(" + ",".join(
            f"{k}{op}{v}" for k, op, v in constraints) + ")" if top else "FALLBACK_PASS",
        "all_matched": sorted({r.rule_id for r in matched_rules}),
    }
    return {
        "board": {"seed": seed, "index": board_idx,
                  "dealer": deal.dealer.name, "vuln": deal.vuln},
        "call_index": call_index,
        "seat": seat.name,
        "input": {
            "auction": [str(c) for c in history],
            "hand": hand_str(deal.hands[seat]),
            "features": serialize_features(feats),
        },
        "explanation": explanation,
        "bid": str(call),
        "forced": forced,
        "ev": {str(c): round(v, 1) for c, v in values.items()} if values else {},
    }


def generate(net, engine, deals, seed, out_path):
    models = {s: net for s in Seat}
    n_traces = 0
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "w") as f:
        for b_idx, deal in enumerate(deals, 1):
            history = []
            curr = deal.dealer
            n = 0
            while True:
                ps = PartialState(curr, deal.hands[curr], history,
                                  deal.dealer, deal.vuln)
                if ps.is_auction_over() or n >= 24:
                    break
                feats = BridgeFeatures.extract_all(
                    deal.hands[curr], history, curr, deal.dealer, deal.vuln)
                matched = [r for r in net.rules
                           if r.matches(BridgeFeatures.extract_all(
                               deal.hands[curr], history, curr,
                               deal.dealer, deal.vuln))]
                candidates = net.actions(deal.hands[curr], history, curr,
                                         deal.dealer, deal.vuln)
                call, values = engine.decide(ps, models)
                obj = trace_object(deal, seed, b_idx, n, curr, history,
                                   feats, matched, candidates, call, values)
                # factory invariant: constraints hold on the true features
                for key, op, val in obj["explanation"]["constraints"]:
                    fv = feats.get(key)
                    fv = getattr(fv, "value", fv)
                    vv = getattr(val, "value", val)
                    try:
                        if op == "in":
                            ok = fv in vv
                        elif op == "not_in":
                            ok = fv not in vv
                        else:
                            ok = {"==": fv == vv, "!=": fv != vv,
                                  ">=": fv is not None and fv >= vv,
                                  "<=": fv is not None and fv <= vv,
                                  ">": fv is not None and fv > vv,
                                  "<": fv is not None and fv < vv}.get(op, False)
                    except TypeError:
                        ok = False
                    assert ok, f"constraint violated: {key} {op} {vv} (feat={fv})"
                f.write(json.dumps(obj, default=str) + "\n")
                n_traces += 1

                history.append(call)
                curr = Seat((curr.value + 1) % 4)
                n += 1
    return n_traces


def _sha256(path):
    import hashlib
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def main():
    ap = argparse.ArgumentParser(description="Generate CoT-bidder training corpus")
    ap.add_argument("--boards", type=int, default=32)
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--dsl", default=os.path.join(SYSTEM_DIR, "improved_system.dsl"))
    ap.add_argument("--out", default="data/traces/traces.jsonl")
    args = ap.parse_args()

    deals = build_deals(args.boards, seed=args.seed, include_stratified=False)
    net = load_decision_net_dsl(args.dsl)
    engine = PIDMEngine()

    # generation is only valid against the exact rule set used
    dsl_sha = _sha256(args.dsl) if os.path.exists(args.dsl) else None

    n = generate(net, engine, deals, args.seed, args.out)

    import hashlib
    corpus_sha = _sha256(args.out)
    meta_path = os.path.splitext(args.out)[0] + ".meta.json"
    meta = {
        "schema_version": 1,
        "generator": "trace_factory.py",
        "created": time.strftime("%Y-%m-%d %H:%M:%S"),
        "seed": args.seed,
        "boards": args.boards,
        "n_traces": n,
        "dsl_source": os.path.relpath(args.dsl),
        "dsl_sha256": dsl_sha,
        "corpus_sha256": corpus_sha,
    }
    with open(meta_path, "w") as f:
        json.dump(meta, f, indent=2)
    print(f"Wrote {n} call-traces ({len(deals)} boards) -> {args.out}")
    print(f"Meta   : {meta_path} | corpus sha256={corpus_sha[:16]}… "
          f"dsl sha256={str(dsl_sha)[:16]}…")


if __name__ == "__main__":
    main()
