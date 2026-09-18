#!/usr/bin/env python3
"""Where, exactly, do we lose to Brill? Attribute the gap to contracts.

    python3 research/brill_gap_where.py --traces data/brill_traces_held.jsonl \
        --a system/brill_distilled.dsl --boards 1500

WHY
---
§6.80 closed the data lever: 1.75x more traces bought +0.01 ± 0.03. So the
next question is not "how do we get more signal" but **what the remaining
+1.555 IMP/board actually consists of**. `where_lost.py` already answers
that for two local systems, but the gap that matters is to *remote Brill*,
and Brill is not a local system.

This script makes it one, without a network call: the harvest
(`brill_harvest.py`) already recorded Brill's complete auction on every
board it played. Replaying that auction is Brill. So on one board:

    ours  : net vs net                     -> contract_A, NS score_A
    Brill : the recorded Brill-vs-Brill auction -> contract_B, NS score_B

and score_A - score_B is an IMP difference on identical cards, exactly the
quantity `where_lost.py` attributes.

HELD-OUT BOARDS ONLY
--------------------
The whole point is a held-out measurement. `--traces` must be a harvest the
model was NOT distilled from; `brill_distilled.py` warns if the eval seed
collides with a harvest seed, and §6.80's harvest used seeds 9002-9012.
Check before pointing this at a traces file.

WHAT IT REPORTS
---------------
1. Total gap, with an se, so it can be compared to §6.77's +1.555.
2. **Concentration** — does the worst 1% of boards carry the loss, or is it
   spread thinly? These have opposite remedies (§6.60's framing).
3. Contract class reached by each side, and the game/slam gaps.
4. Net IMP by (our class, Brill's class) pair.
5. A contested/uncontested split, since contested is the slice that has
   resisted every intervention (§6.76).
"""
import argparse
import json
import os
import sys
from collections import Counter, defaultdict
from typing import Any, Dict, List, Optional, Tuple

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))
sys.path.insert(0, os.path.join(REPO, "research"))

from bid.arena import BiddingArena                                  # noqa: E402
from bid.brill.convert import hand_from_pbn, parse_call             # noqa: E402
from bid.eval_vs_dds import load_decision_net_dsl, seed_board       # noqa: E402
from bid.models import CallType, Seat                               # noqa: E402
from bid.sampling import Deal                                       # noqa: E402
from where_lost import (contract_class, contract_str,               # noqa: E402
                        final_contract, to_imps)

SYSTEM_DIR = os.path.join(REPO, "system")
SEATS = (Seat.NORTH, Seat.EAST, Seat.SOUTH, Seat.WEST)


def load_boards(path: str) -> List[Dict[str, Any]]:
    """One entry per deal: hands, dealer, vul, and Brill's full auction."""
    by_deal: Dict[str, Dict[str, Any]] = {}
    for line in open(path):
        line = line.strip()
        if not line:
            continue
        r = json.loads(line)
        deal = r.get("deal")
        if not deal:
            continue
        ctx = [t for t in (r.get("ctx") or "").split("-") if t.strip()]
        entry = by_deal.setdefault(deal, {"calls": {}, "dealer": r.get("dealer"),
                                          "vul": int(r.get("vul", 0)),
                                          "hands": {}})
        entry["calls"][len(ctx)] = r.get("call")
        seat = r.get("seat")
        if seat and r.get("hand"):
            entry["hands"][str(seat)[-1].upper()] = r["hand"]

    boards = []
    for deal, e in by_deal.items():
        idx = sorted(e["calls"])
        if not idx or idx != list(range(len(idx))):
            continue                      # incomplete auction, skip
        try:
            calls = [parse_call(e["calls"][i]) for i in idx]
            dealer_letter, hands_pbn = deal.split(":", 1)
            parts = hands_pbn.split()
            if len(parts) != 4:
                continue
            hands = {s: hand_from_pbn(p) for s, p in zip(SEATS, parts)}
        except Exception:                 # noqa: BLE001
            continue
        boards.append({"deal_str": deal,
                       "dealer": _seat(dealer_letter.strip()),
                       "vul": e["vul"], "hands": hands, "calls": calls})
    boards.sort(key=lambda b: b["deal_str"])
    return boards


def _seat(letter: str) -> Seat:
    return {"N": Seat.NORTH, "E": Seat.EAST,
            "S": Seat.SOUTH, "W": Seat.WEST}[letter[-1].upper()]


def contested(calls: List[Any], dealer: Seat) -> bool:
    """True if both partnerships made at least one bid."""
    sides = set()
    for i, c in enumerate(calls):
        if c.type == CallType.BID:
            sides.add((dealer.value + i) % 2)
    return len(sides) == 2


def main() -> int:
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--traces", default=os.path.join("data",
                                                     "brill_traces_held.jsonl"))
    ap.add_argument("--a", default=os.path.join(SYSTEM_DIR,
                                                "brill_distilled.dsl"))
    ap.add_argument("--boards", type=int, default=0, help="0 = all")
    ap.add_argument("--seed", type=int, default=7)
    ap.add_argument("--dump", default="", help="write per-board rows as jsonl")
    args = ap.parse_args()

    boards = load_boards(args.traces)
    if args.boards:
        boards = boards[:args.boards]
    if not boards:
        sys.exit("no complete auctions in %s" % args.traces)

    a = load_decision_net_dsl(args.a)
    a.name = os.path.splitext(os.path.basename(args.a))[0]
    arena = BiddingArena()

    rows: List[Dict[str, Any]] = []
    for i, b in enumerate(boards):
        deal = Deal(b["hands"], b["dealer"], b["vul"])
        seed_board(args.seed, i)
        h_a, s_a = arena.play_board(deal, a, a)
        s_b = arena.engine.evaluate_terminal_deal(deal, b["calls"],
                                                  Seat.SOUTH, b["dealer"],
                                                  b["vul"])
        ct_a, ct_b = final_contract(h_a), final_contract(b["calls"])
        rows.append({"i": i, "imp": to_imps(s_a - s_b),
                     "ct_a": ct_a, "ct_b": ct_b,
                     "cls_a": contract_class(ct_a), "cls_b": contract_class(ct_b),
                     "contested": contested(b["calls"], b["dealer"]),
                     "calls_b": " ".join(str(c) for c in b["calls"]),
                     "calls_a": " ".join(str(c) for c in h_a)})

    n = len(rows)
    tot = sum(r["imp"] for r in rows)
    mean = tot / n
    sd = (sum((r["imp"] - mean) ** 2 for r in rows) / (n - 1)) ** 0.5
    se = sd / (n ** 0.5)
    print("%s vs remote Brill (replayed), %d held-out boards, each playing "
          "itself" % (a.name, n))
    print("  %s net: %+.3f IMP/board  (se %.3f, t %+.2f), total %+d"
          % (a.name, mean, se, mean / se if se else 0, tot))
    print("  (§6.77 measured +1.555 against Brill on 200 boards)")

    print("\nCONCENTRATION  (diffuse or a few disasters?)")
    by_loss = sorted(rows, key=lambda r: r["imp"])
    abs_tot = sum(abs(r["imp"]) for r in rows) or 1
    for pct in (0.01, 0.05, 0.10, 0.25):
        k = max(1, int(n * pct))
        share = sum(abs(r["imp"]) for r in by_loss[:k]) / abs_tot
        print("  worst %2d%% of boards (%4d) carry %4.1f%% of all IMP movement"
              % (pct * 100, k, 100 * share))
    print("  10 worst boards: %s"
          % " ".join("%+d" % r["imp"] for r in by_loss[:10]))
    for r in by_loss[:5]:
        print("      %-8s %-14s  Brill %-14s  -> %+d IMP"
              % ("board %d" % r["i"], contract_str(r["ct_a"]),
                 contract_str(r["ct_b"]), r["imp"]))
        print("               us: %s" % r["calls_a"])
        print("            brill: %s" % r["calls_b"])

    print("\nCONTRACT CLASS REACHED")
    ca = Counter(r["cls_a"] for r in rows)
    cb = Counter(r["cls_b"] for r in rows)
    print("  %-12s %10s %10s" % ("class", a.name, "Brill"))
    for cls in ("passed_out", "partscore", "game", "slam"):
        print("  %-12s %10d %10d" % (cls, ca[cls], cb[cls]))

    print("\nGAME / SLAM GAP  (one side bids it, the other stops below)")
    for lo, hi in (("partscore", "game"), ("partscore", "slam"),
                   ("game", "slam")):
        for label, grp in (("%s %s, Brill %s" % (a.name, hi, lo),
                            [r for r in rows if r["cls_a"] == hi
                             and r["cls_b"] == lo]),
                           ("Brill %s, %s %s" % (hi, a.name, lo),
                            [r for r in rows if r["cls_b"] == hi
                             and r["cls_a"] == lo])):
            if not grp:
                continue
            imp = sum(r["imp"] for r in grp)
            print("  %-44s n=%-4d net %+6d IMP  (%+.2f each)"
                  % (label, len(grp), imp, imp / len(grp)))

    print("\nCONTESTED SPLIT")
    for lab, grp in (("contested",
                      [r for r in rows if r["contested"]]),
                     ("uncontested",
                      [r for r in rows if not r["contested"]])):
        if not grp:
            continue
        imp = sum(r["imp"] for r in grp)
        m = imp / len(grp)
        sdv = (sum((r["imp"] - m) ** 2 for r in grp) / (len(grp) - 1)) ** 0.5
        print("  %-12s n=%-5d %+.3f IMP/board (se %.3f)  net %+d"
              % (lab, len(grp), m, sdv / (len(grp) ** 0.5), imp))

    print("\nNET IMP BY CONTRACT-CLASS PAIR  (%s / Brill)" % a.name)
    pair: Dict[Tuple[str, str], List[int]] = defaultdict(list)
    for r in rows:
        pair[(r["cls_a"], r["cls_b"])].append(r["imp"])
    for (ka, kb), imps in sorted(pair.items(),
                                 key=lambda kv: -abs(sum(kv[1])))[:10]:
        print("  %-12s / %-12s n=%-4d net %+6d  (%+.2f each)"
              % (ka, kb, len(imps), sum(imps), sum(imps) / len(imps)))

    if args.dump:
        with open(args.dump, "w") as fh:
            for r in rows:
                r = dict(r)
                r["ct_a"] = contract_str(r["ct_a"])
                r["ct_b"] = contract_str(r["ct_b"])
                fh.write(json.dumps(r) + "\n")
        print("\nwrote %s" % args.dump)
    return 0


if __name__ == "__main__":
    sys.exit(main())
