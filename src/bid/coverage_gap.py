#!/usr/bin/env python3
"""
coverage_gap.py — find hand distributions a bidding-system DSL cannot bid.

For a given system file (either DSL format) the tool enumerates the space of
possible hands as (HCP, distribution) cells and reports every cell in which
NO rule can fire — i.e. every region where the engine would silently fall
back to PASS because the system has no opinion.

Phases:
  opening   empty auction (opener's first call)                    [default]
  history   a user-supplied auction prefix, e.g. --history "1C P 1D P";
            cells are checked for the player whose turn it is
  auction   random-deal self-play; logs every turn (for any seat) where the
            system produces no call

A cell is *covered* when at least one sampled real hand inside it triggers
some rule.  Constraints beyond (hcp, suit lengths, balanced) — controls,
aces, major-HCP, stoppers — depend on honor placement, so cells are verified
by exact random construction of hands with the required (hcp, shape); use
--samples to trade runtime for confidence.  Cells whose (hcp, shape) pair is
arithmetically impossible (e.g. 34 HCP with a 4-3-3-3 shape) are excluded.

In the history phase a cell is also *excluded* when the hand could not have
produced the acting player's own earlier calls in that auction (an 8-HCP hand
cannot sit opposite a "1C P 1D P" prefix if this seat opened the strong 1C):
only hands consistent with the system's own previous calls are judged.

Usage:
  python3 -m bid.coverage_gap --system system/precision.dsl
  python3 -m bid.coverage_gap --system system/blue_club.dsl --history "1C P 1D P"
  python3 -m bid.coverage_gap --system system/improved_system.dsl --phase auction --deals 300
"""

import argparse
import glob
import json
import os
import random
import re
import sys
from itertools import combinations
from typing import Dict, List, Optional, Sequence, Tuple

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if REPO_ROOT not in sys.path:
    sys.path.insert(0, os.path.join(REPO_ROOT, "src"))

from bid.models import Call, CallType, Card, Hand, Rank, Seat, Strain, Suit  # noqa: E402

SUITS = (Suit.CLUBS, Suit.DIAMONDS, Suit.HEARTS, Suit.SPADES)
SUIT_LETTER = {Suit.CLUBS: "C", Suit.DIAMONDS: "D", Suit.HEARTS: "H", Suit.SPADES: "S"}
RANKS_DESC = [Rank.ACE, Rank.KING, Rank.QUEEN, Rank.JACK, Rank.TEN,
              Rank.NINE, Rank.EIGHT, Rank.SEVEN, Rank.SIX, Rank.FIVE,
              Rank.FOUR, Rank.THREE, Rank.TWO]

# ---------------------------------------------------------------------------
# (HCP, length) -> rank-combination tables
# ---------------------------------------------------------------------------

def _build_tables():
    """All rank subsets of one suit grouped by (length, hcp)."""
    by_len_hcp: Dict[Tuple[int, int], List[Tuple[Rank, ...]]] = {}
    for mask in range(1 << 13):
        ranks = tuple(RANKS_DESC[i] for i in range(13) if mask >> i & 1)
        hcp = sum({Rank.ACE: 4, Rank.KING: 3, Rank.QUEEN: 2, Rank.JACK: 1}.get(r, 0)
                  for r in ranks)
        by_len_hcp.setdefault((len(ranks), hcp), []).append(ranks)
    return by_len_hcp


_COMBOS = _build_tables()


def _hcp_values(length: int) -> List[int]:
    return sorted(v for (l, v) in _COMBOS if l == length and _COMBOS[(l, v)])


def max_hcp(shape: Sequence[int]) -> int:
    """Highest HCP a hand of this shape can hold (top cards of each suit)."""
    return sum(max(_hcp_values(l)) for l in shape)


def min_hcp(shape: Sequence[int]) -> int:
    return sum(min(_hcp_values(l)) for l in shape)


def shapes_13() -> List[Tuple[int, int, int, int]]:
    out = []
    for c in range(14):
        for d in range(14 - c):
            for h in range(14 - c - d):
                s = 13 - c - d - h
                out.append((c, d, h, s))
    return out


def shape_str(shape: Sequence[int]) -> str:
    return "-".join(str(x) for x in sorted(shape, reverse=True))


def shape_family(shape: Sequence[int]) -> str:
    ls = sorted(shape, reverse=True)
    if ls in ([4, 3, 3, 3], [4, 4, 3, 2], [5, 3, 3, 2]):
        return "balanced"
    if ls[0] >= 7:
        return "one-suited 7+"
    if ls[0] == 6 and ls[1] >= 4:
        return "6-4+ two-suiter"
    if ls[0] == 6:
        return "one-suited 6"
    if ls[0] == 5 and ls[1] == 5:
        return "5-5 two-suiter"
    if ls[0] == 5 and ls[1] == 4:
        return "5-4"
    if ls[0] == 4 and ls[1] == 4 and ls[2] == 4:
        return "4-4-4-1/0 three-suiter"
    return "other"


def hand_shape(hand: Hand) -> Tuple[int, int, int, int]:
    return tuple(hand._lengths[s] for s in SUITS)  # noqa: SLF001


# ---------------------------------------------------------------------------
# Exact hand construction for a (hcp, shape) cell
# ---------------------------------------------------------------------------

def sample_hand(rng: random.Random, hcp: int, shape: Sequence[int]) -> Optional[Hand]:
    """Construct a real 13-card hand with exactly this hcp and distribution,
    or None when the cell is impossible.  Exact — no rejection sampling."""
    vsets = [_hcp_values(l) for l in shape]

    # suffix-achievable sums: suffix[i] = sums suits i..3 can still add
    suffix: List[set] = [set() for _ in range(5)]
    suffix[4] = {0}
    for i in range(3, -1, -1):
        suffix[i] = {v + s for v in vsets[i] for s in suffix[i + 1]}
    if hcp not in suffix[0]:
        return None

    targets, rem = [], hcp
    for i in range(4):
        cand = [v for v in vsets[i] if rem - v in suffix[i + 1]]
        v = rng.choice(cand)
        targets.append(v)
        rem -= v

    cards = []
    for suit, length, v in zip(SUITS, shape, targets):
        for rank in rng.choice(_COMBOS[(length, v)]):
            cards.append(Card(suit, rank))
    return Hand(cards)


def sample_cell(rng: random.Random, hcp: int, shape: Sequence[int],
                n: int) -> List[Hand]:
    """Up to n distinct real hands inside the cell (deterministic seed)."""
    hands, seen = [], set()
    for _ in range(n * 3):
        if len(hands) >= n:
            break
        h = sample_hand(rng, hcp, shape)
        if h is None:
            break
        key = tuple(sorted((c.suit, c.rank) for c in h.cards))
        if key not in seen:
            seen.add(key)
            hands.append(h)
    return hands


# ---------------------------------------------------------------------------
# System adapters (both DSL formats)
# ---------------------------------------------------------------------------

class LegacyAdapter:
    """SystemTranslator format: OPEN/RESPONSE/(1C) sequences (precision, blue_club, gib)."""

    def __init__(self, system):
        self.system = system
        self.n_rules = len(system.rules)

    def any_match(self, history: List[Call], hand: Hand, seat: Seat) -> bool:
        return any(r.applies(history, hand) for r in self.system.rules)

    def can_produce(self, history: List[Call], hand: Hand, call: Call) -> bool:
        return any(r.applies(history, hand) and r.call == call
                   for r in self.system.rules)

    def first_call(self, history: List[Call], hand: Hand, seat: Seat) -> Optional[Call]:
        rule = self.system.get_bid(history, hand)
        return rule.call if rule else None


class NetAdapter:
    """DecisionNet format: RULE/CONDITION files (improved_system.dsl)."""

    def __init__(self, net):
        self.net = net
        self.n_rules = len(net.rules) + (len(net.wrapped_system.rules)
                                         if net.wrapped_system else 0)

    def _features(self, history, hand, seat):
        from bid.features import BridgeFeatures
        return BridgeFeatures.extract_all(hand, history, seat, Seat.NORTH, 0)

    def any_match(self, history: List[Call], hand: Hand, seat: Seat) -> bool:
        feats = self._features(history, hand, seat)
        if any(r.matches(feats) for r in self.net.rules):
            return True
        ws = self.net.wrapped_system
        return bool(ws and any(r.applies(history, hand) for r in ws.rules))

    def can_produce(self, history: List[Call], hand: Hand, call: Call) -> bool:
        feats = self._features(history, hand, seat=Seat.SOUTH)
        if any(r.matches(feats) and r.call == call for r in self.net.rules):
            return True
        ws = self.net.wrapped_system
        return bool(ws and any(r.applies(history, hand) and r.call == call
                               for r in ws.rules))

    def first_call(self, history: List[Call], hand: Hand, seat: Seat) -> Optional[Call]:
        calls = self.net.actions(hand, history, seat, Seat.NORTH, 0)
        return calls[0] if calls else None


def load_adapter(path: str):
    """Load either DSL format; raises when the file yields no rules at all."""
    from bid.eval_vs_dds import load_decision_net_dsl
    net = load_decision_net_dsl(path)
    if net.rules:
        return NetAdapter(net)
    if net.wrapped_system is not None:
        return LegacyAdapter(net.wrapped_system)
    raise SystemExit(f"{path}: no rules parsed by either DSL loader")


def parse_history(s: str) -> List[Call]:
    """'1C P 1D P' / '1C - (1D) - X' -> [Call, ...] (parens are decorative)."""
    from bid.eval_vs_dds import parse_call
    tokens = [t for t in re.split(r"[\s\-]+", s.strip()) if t]
    calls = []
    for t in tokens:
        tok = t.strip("()").upper().replace("NT", "NT")
        calls.append(parse_call(tok))
    return calls


def history_str(calls: Sequence[Call]) -> str:
    out = []
    for c in calls:
        if c.type == CallType.PASS:
            out.append("P")
        elif c.type == CallType.DOUBLE:
            out.append("X")
        elif c.type == CallType.REDOUBLE:
            out.append("XX")
        else:
            out.append(f"{c.level}{'NT' if c.strain == Strain.NT else c.strain.name[0]}")
    return " ".join(out)


# ---------------------------------------------------------------------------
# Scanners
# ---------------------------------------------------------------------------

def _own_turn_prefixes(history: List[Call]) -> List[Tuple[int, Call]]:
    """Prefixes at which the NEXT actor already bid in this auction
    (positions len-4, len-8, ...), paired with the call they made."""
    out = []
    p = len(history) - 4
    while p >= 0:
        out.append((history[:p], history[p]))
        p -= 4
    return out


def scan_cells(adapter, history: List[Call], hcps: Sequence[int],
               shapes: Optional[Sequence[Tuple[int, int, int, int]]],
               samples: int, seed: int,
               progress_every: int = 2000) -> List[dict]:
    """Status per (hcp, shape) cell: covered | gap | excluded | impossible.

    'excluded' cells cannot arise for the player to act: the hand could not
    have produced that player's own earlier calls in this auction (e.g. an
    8-HCP hand after partner opened a strong 1C that requires 16+)."""
    rng = random.Random(seed)
    shapes = list(shapes) if shapes is not None else shapes_13()
    seat = Seat(list(Seat)[(Seat.NORTH.value + len(history)) % 4])
    own = _own_turn_prefixes(history)
    results = []
    for idx, (hcp, shape) in enumerate((h, s) for h in hcps for s in shapes):
        if idx and progress_every and idx % progress_every == 0:
            print(f"  ... {idx} cells scanned", file=sys.stderr)
        if hcp < min_hcp(shape) or hcp > max_hcp(shape):
            results.append({"hcp": hcp, "shape": list(shape), "status": "impossible"})
            continue
        hands = sample_cell(rng, hcp, shape, samples)
        if not hands:
            results.append({"hcp": hcp, "shape": list(shape), "status": "unverified"})
            continue
        consistent = [h for h in hands
                      if all(adapter.can_produce(prefix, h, call)
                             for prefix, call in own)]
        if not consistent:
            results.append({"hcp": hcp, "shape": list(shape), "status": "excluded"})
            continue
        covered = any(adapter.any_match(history, h, seat) for h in consistent)
        results.append({"hcp": hcp, "shape": list(shape),
                        "status": "covered" if covered else "gap"})
    return results


BANDS = [(0, 7, "0-7"), (8, 11, "8-11"), (12, 14, "12-14"),
         (15, 17, "15-17"), (18, 21, "18-21"), (22, 37, "22+")]


def band_of(hcp: int) -> str:
    for lo, hi, name in BANDS:
        if lo <= hcp <= hi:
            return name
    return "22+"


def aggregate_cells(results: List[dict]):
    """Group gap cells into (band x family) rows with example shapes."""
    groups: Dict[Tuple[str, str], List[str]] = {}
    counts = {"covered": 0, "gap": 0, "impossible": 0, "unverified": 0,
              "excluded": 0}
    for r in results:
        counts[r["status"]] += 1
        if r["status"] == "gap":
            key = (band_of(r["hcp"]), shape_family(r["shape"]))
            groups.setdefault(key, []).append(shape_str(r["shape"]))
    rows = []
    for (band, family), shapes in sorted(groups.items(),
                                         key=lambda kv: (-len(kv[1]), kv[0])):
        uniq = sorted(set(shapes), key=lambda s: tuple(-int(x) for x in s.split("-")))
        rows.append({"band": band, "family": family, "cells": len(shapes),
                     "examples": uniq[:5], "distinct_shapes": len(uniq)})
    return rows, counts


def walk_auctions(adapter, deals: int, depth: int, seed: int) -> List[dict]:
    """Self-play with the same system in all four seats; log every turn the
    system has no rule for (the engine would fall back to PASS)."""
    rng = random.Random(seed)
    deck = [Card(s, r) for s in SUITS for r in RANKS_DESC]
    seats = list(Seat)
    gaps = []
    for _ in range(deals):
        rng.shuffle(deck)
        hands = [Hand(deck[i * 13:(i + 1) * 13]) for i in range(4)]
        history: List[Call] = []
        while len(history) < depth:
            seat = seats[len(history) % 4]
            call = adapter.first_call(history, hands[seat.value], seat)
            if call is None:
                hand = hands[seat.value]
                gaps.append({"history": history_str(history), "seat": seat.name,
                             "hcp": hand.hcp, "shape": list(hand_shape(hand)),
                             "family": shape_family(hand_shape(hand))})
                call = Call(CallType.PASS)
            history.append(call)
            if len(history) >= 4 and all(c.type == CallType.PASS
                                         for c in history[-4:]):
                break
    return gaps


def aggregate_walk(gaps: List[dict], top: int = 15) -> List[dict]:
    groups: Dict[Tuple[str, str, str], List[dict]] = {}
    for g in gaps:
        key = (g["history"], band_of(g["hcp"]), g["family"])
        groups.setdefault(key, []).append(g)
    rows = []
    for (hist, band, family), items in sorted(groups.items(),
                                              key=lambda kv: -len(kv[1]))[:top]:
        ex = items[0]
        rows.append({"history": hist, "band": band, "family": family,
                     "count": len(items), "example_shape": shape_str(ex["shape"]),
                     "seat": ex["seat"]})
    return rows


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main(argv: Optional[List[str]] = None) -> int:
    ap = argparse.ArgumentParser(description="Find hand distributions a DSL cannot bid")
    ap.add_argument("--system", required=True, help="path to a .dsl system file")
    ap.add_argument("--phase", choices=["opening", "history", "auction"], default="opening")
    ap.add_argument("--history", help='auction prefix, e.g. "1C P 1D P" (phase=history)')
    ap.add_argument("--samples", type=int, default=8,
                    help="hands sampled per (hcp, shape) cell")
    ap.add_argument("--deals", type=int, default=300, help="deals for --phase auction")
    ap.add_argument("--depth", type=int, default=16, help="max auction length")
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--json", help="override output JSON path")
    ap.add_argument("--hcps", help="restrict scan, e.g. '8-11' or '0-7,12+'")
    args = ap.parse_args(argv)

    adapter = load_adapter(args.system)
    name = os.path.splitext(os.path.basename(args.system))[0]

    if args.phase == "auction":
        gaps = walk_auctions(adapter, args.deals, args.depth, args.seed)
        rows = aggregate_walk(gaps)
        print(f"=== coverage: {name} ({type(adapter).__name__}, {adapter.n_rules} rules) "
              f"— phase=auction, {args.deals} deals ===")
        print(f"turns with no rule (forced PASS): {len(gaps)} "
              f"({len(gaps) / max(1, args.deals * args.depth):.1%} of turns)")
        print("\nTop gap patterns (auction x HCP band x shape family):")
        for r in rows:
            print(f"  after [{r['history']:<18}] {r['seat']:<5} hcp {r['band']:<5} "
                  f"{r['family']:<20} {r['count']:>4}x   e.g. {r['example_shape']}")
        out = {"system": name, "phase": "auction", "deals": args.deals,
               "forced_pass_turns": len(gaps), "patterns": rows, "gaps": gaps}
    else:
        if args.phase == "history":
            if not args.history:
                ap.error("--history is required with --phase history")
            history = parse_history(args.history)
        else:
            history = []
        if args.hcps:
            hcps = []
            for part in args.hcps.split(","):
                m = re.match(r"(\d+)(-|\+)?(\d+)?", part.strip())
                if not m:
                    ap.error(f"bad --hcps part: {part}")
                lo, op, hi = int(m.group(1)), m.group(2), m.group(3)
                hcps += [lo] if op is None else (
                    list(range(lo, int(hi) + 1)) if op == "-" else list(range(lo, 38)))
            hcps = sorted(set(hcps))
        else:
            hcps = list(range(38))

        results = scan_cells(adapter, history, hcps, None, args.samples, args.seed)
        rows, counts = aggregate_cells(results)
        possible = counts["covered"] + counts["gap"]
        print(f"=== coverage: {name} ({type(adapter).__name__}, {adapter.n_rules} rules) "
              f"— phase={args.phase}"
              + (f", history [{history_str(history)}]" if history else "") + " ===")
        print(f"cells: {len(results)} scanned | impossible {counts['impossible']} | "
              f"excluded {counts['excluded']} (inconsistent with own earlier calls) | "
              f"covered {counts['covered']} | GAP {counts['gap']} | "
              f"unverified {counts['unverified']}")
        if possible:
            print(f"coverage of possible cells: {counts['covered'] / possible:.1%}")
        if rows:
            print("\nGaps by HCP band x shape family:")
            for r in rows:
                print(f"  hcp {r['band']:<5} x {r['family']:<20} {r['cells']:>5} cells "
                      f"({r['distinct_shapes']} shapes)  e.g. {', '.join(r['examples'])}")
        out = {"system": name, "phase": args.phase,
               "history": history_str(history) if history else None,
               "counts": counts, "patterns": rows,
               "gap_cells": [r for r in results if r["status"] == "gap"],
               "unverified_cells": [r for r in results if r["status"] == "unverified"]}

    out_dir = args.json or os.path.join(REPO_ROOT, "debug", "coverage_gaps",
                                        f"{name}.{out['phase']}"
                                        + ("." + history_str(history).replace(" ", "_")
                                           if out.get("history") else "") + ".json")
    os.makedirs(os.path.dirname(out_dir) or ".", exist_ok=True)
    with open(out_dir, "w") as f:
        json.dump(out, f, indent=1)
    print(f"\nfull report -> {out_dir}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
