#!/usr/bin/env python3
"""
cot_bidder.py — constrained-decode bidding prototype over the trace corpus.

Back-end (P0): nearest-neighbour retrieval over data/traces/traces.jsonl.
For each decision it:
  1. retrieves the most similar stored positions
  2. transfers the neighbour's constraint sentence
  3. VERIFIES the constraints against the actual hand features
  4. checks the transferred bid is legal against the actual auction
  5. plays it; otherwise falls through to the next neighbour;
     final fallback: DecisionNet (the symbolic system)

This is the P0 stand-in for the planned seq2seq reasoner (research/cot-bidder.md);
the decode/verify loop and interfaces are identical — only the text generator
is substituted later.

CLI:
  PYTHONPATH=.. python3 cot_bidder.py play --board 1 --k 5
  PYTHONPATH=.. python3 cot_bidder.py evaluate --boards 16
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from typing import List

from bid.models import Seat, Suit, Strain, Call, CallType
from bid.sampling import Deal, PartialState
from bid.pidm import PIDMEngine

from bid.eval_vs_dds import build_deals, load_decision_net_dsl, SYSTEM_DIR, contract_string

CORPUS_DEFAULT = "data/traces/traces.jsonl"
NUMERIC_KEYS = ["hcp", "total_points", "spade_len", "heart_len",
                "diamond_len", "club_len", "controls"]
CAT_KEYS = ["is_balanced", "is_opening", "partner_last_call",
            "opp_last_call", "my_last_call"]


# ---------------- loading ----------------

def load_traces(path=CORPUS_DEFAULT):
    traces = []
    with open(path) as f:
        for line in f:
            line = line.strip()
            if line:
                traces.append(json.loads(line))
    return traces


# ---------------- verification ----------------

def verify_constraints(constraints, features):
    """All constraints must hold on the real features."""
    fails = []
    for key, op, val in constraints:
        fv = features.get(key)
        fv = getattr(fv, "value", fv) if fv is not None else None
        vv = getattr(val, "value", val) if not isinstance(val, (int, float, bool, str, list)) else val
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
        if not ok:
            fails.append((key, op, val, fv))
    return len(fails) == 0, fails


def last_bid_and_state(auction):
    last_bid = None
    last_np = None          # (seat_index, call_str)
    for i, tok in enumerate(auction):
        if tok == "P":
            continue
        last_np = (i, tok)
        if tok != "X" and tok != "XX":
            last_bid = tok
    return last_bid, last_np


def bid_legal(bid: str, auction: List[str], seat_i: int, dealer_i: int = 0) -> bool:
    if bid == "PASS":
        return True
    if bid == "X" or bid == "XX":
        # simplified: need a pending bid/double by opponents; full rules live
        # in decision_net.actions (used by the fallback path anyway)
        last_np = None
        for i, tok in enumerate(auction):
            if tok != "P":
                last_np = (i, tok)
        if last_np is None:
            return False
        idx, tok = last_np
        seat_of = Seat((dealer_i + idx) % 4)
        opp = seat_of not in (Seat(seat_i), Seat((seat_i + 2) % 4))
        if tok in ("X", "XX"):
            return False
        return opp
    try:
        lvl = int(bid[0])
        strain = {"C": 0, "D": 1, "H": 2, "S": 3, "N": 4}[bid[1]]
    except (ValueError, KeyError, IndexError):
        return False
    last_bid, _ = last_bid_and_state(auction)
    if last_bid is None or len(last_bid) < 2 or not last_bid[0].isdigit():
        return True
    try:
        plvl = int(last_bid[0])
        pstrain = {"C": 0, "D": 1, "H": 2, "S": 3, "N": 4}[last_bid[1]]
    except (ValueError, KeyError):
        return True
    return (lvl > plvl) or (lvl == plvl and strain > pstrain)


# ---------------- retrieval ----------------

def distance(fa: dict, fb: dict) -> float:
    d = 0.0
    for k in NUMERIC_KEYS:
        va, vbv = fa.get(k), fb.get(k)
        va = getattr(va, "value", va)
        vbv = getattr(vbv, "value", vbv)
        if isinstance(va, (int, float)) and isinstance(vbv, (int, float)):
            d += abs(va - vbv)
        else:
            d += 5.0
    for k in CAT_KEYS:
        va = getattr(fa.get(k), "value", fa.get(k))
        vbv = getattr(fb.get(k), "value", fb.get(k))
        if str(va) != str(vbv):
            d += 3.0
    return d


class RetrievalReasoner:
    def __init__(self, traces, net=None, engine=None, k=5):
        self.traces = traces
        self.net = net
        self.engine = engine
        self.k = k
        self.stats = {"transferred": 0, "fallback_net": 0}

    def bid(self, hand, auction, features, seat, dealer):
        ranked = sorted(
            self.traces,
            key=lambda t: distance(features, t["input"]["features"]))
        tried = 0
        for t in ranked:
            tried += 1
            if tried > self.k * 6:
                break
            cons = [(k, op, v) for k, op, v in t["explanation"]["constraints"]]
            ok, fails = verify_constraints(cons, features)
            if not ok:
                continue
            bid = t["bid"]
            seat_i = seat.value
            if not bid_legal(bid, auction, seat_i, dealer.value):
                continue
            self.stats["transferred"] += 1
            cot = (f"[retrieved rule {t['explanation']['rule']}] "
                   f"constraints {cons} verified on hand "
                   f"(distance={distance(features, t['input']['features']):.1f})")
            return Call.parse_like(bid) if hasattr(Call, "parse_like") else parse_bid(bid), cot
        self.stats["fallback_net"] += 1
        return None


class NeuralCotReasoner:
    """Neural reasoner backed by a trained CoT transformer model with batched inference."""

    def __init__(self, ckpt_path="data/cot_model/ckpt.pt",
                 dataset_path="data/cot_dataset/dataset.json",
                 device=None, block=None):
        try:
            import torch
        except ImportError:
            raise ImportError("torch is required for NeuralCotReasoner")
        from bid.cot_model import _load_model, load_dataset, pick_device, PAD_ID, EOT_ID, SEP_ID, generate_batch
        self.dev = device or pick_device()
        self.vocab, _, self.meta = load_dataset(dataset_path)
        self.inv = {i: t for t, i in self.vocab.items()}
        class _Args: pass
        args = _Args()
        args.ckpt = ckpt_path
        args.block = block
        self.block = block or int(self.meta.get("block_size_max", 128))
        self.model = _load_model(len(self.vocab), args, self.meta)
        self.model.eval()

    def prefix_ids(self, dealer, vuln, seat, turn, auction_strs, hand_str):
        from bid.cot_tokenizer import format_state_prefix, tokenize_line, BOS, SEP
        V = self.vocab
        lines = format_state_prefix(dealer, vuln, seat, turn, auction_strs, hand_str)
        ids = [V[BOS]]
        for ln in lines:
            ids += [V[t] for t in tokenize_line(ln) if t in V]
        ids.append(V[SEP])
        return ids

    def bid_batch(self, items, max_new=48, temp=0.0, batch_size=32):
        """Batched reasoning for a list of items:
        items: list of (hand, auction, features, seat, dealer, turn, vuln)
        Returns: list of (Call_or_None, cot_text, avg_conf, avg_ent)
        """
        from bid.trace_factory import hand_str
        from bid.cot_model import PAD_ID, EOT_ID, SEP_ID, generate_batch
        prompts = []
        parsed_items = []
        for it in items:
            hand, auction, features, seat, dealer = it[:5]
            turn = it[5] if len(it) > 5 else len(auction)
            vuln = it[6] if len(it) > 6 else 0
            h_str = hand_str(hand) if not isinstance(hand, str) else hand
            p_ids = self.prefix_ids(dealer, vuln, seat, turn, auction, h_str)
            prompts.append(p_ids)
            parsed_items.append((hand, auction, features, seat, dealer))

        batch_out = generate_batch(
            self.model, prompts, max_new=max_new, temp=temp,
            dev=self.dev, pad_id=PAD_ID, eot_id=EOT_ID, sep_id=SEP_ID,
            batch_size=batch_size, block_size=self.block
        )

        results = []
        for out, prompt, (hand, auction, features, seat, dealer) in zip(batch_out, prompts, parsed_items):
            all_ids = prompt + out["generated_ids"]
            toks = [self.inv.get(i, "") for i in all_ids]
            text = " ".join(toks)
            parts = text.split()
            bid_call = None
            if "BID" in parts:
                k = len(parts) - parts[::-1].index("BID")
                bid_str = " ".join(parts[k:]) or None
                if bid_str:
                    seat_i = seat.value if hasattr(seat, "value") else int(seat)
                    dealer_i = dealer.value if hasattr(dealer, "value") else int(dealer)
                    if bid_legal(bid_str, auction, seat_i, dealer_i):
                        bid_call = parse_bid(bid_str)
            results.append((bid_call, text, out["avg_confidence"], out["avg_entropy"]))
        return results

    def bid(self, hand, auction, features, seat, dealer, temp=0.0):
        res = self.bid_batch([(hand, auction, features, seat, dealer)], temp=temp, batch_size=1)
        call_obj, cot, _, _ = res[0]
        return call_obj, cot


def parse_bid(s: str):
    from bid.models import Call as C
    if s == "PASS":
        return C(CallType.PASS)
    if s == "X":
        return C(CallType.DOUBLE)
    if s == "XX":
        return C(CallType.REDOUBLE)
    strain = {"C": Strain.CLUBS, "D": Strain.DIAMONDS,
              "H": Strain.HEARTS, "S": Strain.SPADES,
              "N": Strain.NT}[s[1]]
    return C(CallType.BID, int(s[0]), strain)


# ---------------- play / evaluate ----------------

def play_board(net, engine, reasoner, deal, verbose=True):
    models = {s: net for s in Seat}
    history_tok, history_call = [], []
    curr, n = deal.dealer, 0
    while True:
        ps = PartialState(curr, deal.hands[curr], history_call,
                          deal.dealer, deal.vuln)
        if ps.is_auction_over() or n >= 24:
            break
        feats = __import__("bid.features", fromlist=["BridgeFeatures"]) \
            .BridgeFeatures.extract_all(deal.hands[curr], history_call,
                                        curr, deal.dealer, deal.vuln)
        auction_tok = [str(c) for c in history_call]
        bid_obj, cot = reasoner.bid(deal.hands[curr], auction_tok, feats,
                                    curr, deal.dealer)
        source = "CoT-retrieval"
        if bid_obj is None:
            call, values = engine.decide(ps, models)
            bid_obj, cot = call, "[fallback DecisionNet]"
            source = "fallback"
        if verbose:
            print(f"#{n+1} {curr.name:<6} {str(bid_obj):<5} [{source}] {cot}")
        history_call.append(bid_obj)
        history_tok.append(str(bid_obj))
        curr = Seat((curr.value + 1) % 4)
        n += 1
    return history_call, history_tok


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)

    p_play = sub.add_parser("play")
    p_play.add_argument("--board", type=int, default=1)
    p_play.add_argument("--seed", type=int, default=42)
    p_play.add_argument("--pool", type=int, default=64)
    p_play.add_argument("--traces", default=CORPUS_DEFAULT)
    p_play.add_argument("--k", type=int, default=5)

    p_ev = sub.add_parser("evaluate")
    p_ev.add_argument("--boards", type=int, default=12)
    p_ev.add_argument("--seed", type=int, default=42)
    p_ev.add_argument("--traces", default=CORPUS_DEFAULT)
    p_ev.add_argument("--k", type=int, default=5)

    args = ap.parse_args()
    traces = load_traces(args.traces)
    print(f"Loaded {len(traces)} traces")

    engine = PIDMEngine()
    net = load_decision_net_dsl(os.path.join(SYSTEM_DIR, "improved_system.dsl"))
    reasoner = RetrievalReasoner(traces, net=net, engine=engine, k=args.k)
    models = {s: net for s in Seat}

    if args.cmd == "play":
        deals = build_deals(args.pool, seed=args.seed, include_stratified=False)
        deal = deals[args.board - 1]
        hc, ht = play_board(net, engine, reasoner, deal, verbose=True)
        ps = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], hc,
                          deal.dealer, deal.vuln)
        print("\nfinal:", contract_string(ps))
        print("stats:", reasoner.stats)
    else:
        deals = build_deals(args.boards, seed=args.seed, include_stratified=False)
        agree_calls = same_contract = total_calls = 0
        boards_same = 0
        illegal = 0
        for b_idx, deal in enumerate(deals, 1):
            hc_cot, ht_cot = play_board(net, engine, reasoner, deal, verbose=False)
            hc_ref, ht_ref = [], []
            curr = deal.dealer
            mmodels = {s: net for s in Seat}
            nn = 0
            while True:
                ps = PartialState(curr, deal.hands[curr], hc_ref,
                                  deal.dealer, deal.vuln)
                if ps.is_auction_over() or nn >= 24:
                    break
                call, _ = engine.decide(ps, mmodels)
                hc_ref.append(call)
                ht_ref.append(str(call))
                curr = Seat((curr.value + 1) % 4)
                nn += 1
            minl = min(len(ht_cot), len(ht_ref))
            agree_calls += sum(1 for i in range(minl)
                               if ht_cot[i] == ht_ref[i])
            total_calls += max(len(ht_cot), len(ht_ref))
            if ht_cot == ht_ref:
                boards_same += 1
            # count consecutive-double violations in CoT line
            prev = None
            for tok in ht_cot:
                if tok == "X" and prev == "X":
                    illegal += 1
                prev = tok
        print(f"Boards identical auctions : {boards_same}/{len(deals)}")
        print(f"Call-level agreement      : {agree_calls}/{total_calls} "
              f"({agree_calls / max(1, total_calls) * 100:.1f}%)")
        print(f"Illegal double-after-double: {illegal}")
        print("reasoner stats:", reasoner.stats)


if __name__ == "__main__":
    main()
