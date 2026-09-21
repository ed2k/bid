#!/usr/bin/env python3
"""On-policy outcome label for every decision in a Brill trace set.

    python3 research/brill_outcomes.py --traces data/brill_traces_330k.jsonl \
        --out data/brill_outcomes_330k.jsonl --shard 0 --shards 6

WHY
---
Every model in this repo is fitted to reproduce Brill's *call*. §6.81
showed why that has stopped paying: we reach partscore 60% of the time
against Brill's 43%, game 38% against 52%, slam 0.7% against 3.6%, and
that uniform level bias is invisible both to per-call fidelity (§6.80:
five interventions raised it and bought nothing) and to self-play
attribution (§6.81: it cancels).

The fix is to change the training signal from "what did Brill bid" to
"what did bidding that earn". This computes the second signal.

For each board the harvest recorded Brill's complete auction, so the
final contract is known and DDS can score it exactly. The score is then
attributed to the side that made each decision:

    outcome(board, i) =  NS score  if caller i sits N/S
                        -NS score  if caller i sits E/W

That is an **on-policy** value estimate: "we were in this position, we
made this call, and the rest of the auction followed Brill, and here is
what our side scored". Averaged within a leaf of the fitted tree it says
what each available call is actually worth there — which is the quantity
`--relabel outcome` in `brill_distill.py` then maximises.

COST
----
One DDS solve per board (~230 ms), not per decision. Shard with
`--shards` and run the shards in parallel: 33,450 boards take ~21 min on
6 workers. Sharding is by CRC32 of the deal string, so it is stable
across runs and no worker needs the whole file.

That cost is why a long run is worth protecting: pass `--resume` after a
kill (a crash, a Ctrl-C, or the machine giving out) and the shard files
are topped up instead of rewritten. The first run here was killed at 62%
of the 330k set; resuming costs the 38% that is missing, not the lot.

UNITS
-----
Raw duplicate score (+620, -50, ...), not IMPs. IMP conversion needs par,
which roughly doubles the cost; raw score is monotone in the right
direction and the differences that matter here (partscore vs game) are
large. Revisit if the signal looks noisy.
"""
import argparse
import json
import os
import sys
import zlib
from collections import defaultdict
from typing import Any, Dict, List

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))
sys.path.insert(0, os.path.join(REPO, "research"))

from bid.arena import BiddingArena                                  # noqa: E402
from bid.brill.convert import (hand_from_pbn, parse_call,           # noqa: E402
                               seat_from_letter)
from bid.models import Seat                                         # noqa: E402
from bid.sampling import Deal                                       # noqa: E402

SEATS = (Seat.NORTH, Seat.EAST, Seat.SOUTH, Seat.WEST)
NS = (Seat.NORTH, Seat.SOUTH)


def shard_of(deal: str, shards: int) -> int:
    return zlib.crc32(deal.encode()) % shards


def labelled_deals(path: str) -> set:
    """Deals a shard file has already scored, for `--resume`.

    A killed run can leave a torn last line on the file it was appending
    to, so a line that will not parse is skipped rather than fatal: the
    alternative is refusing to resume at all, which costs a full re-solve.
    """
    out: set = set()
    if not os.path.exists(path):
        return out
    for line in open(path):
        line = line.strip()
        if not line:
            continue
        try:
            out.add(json.loads(line)["deal"])
        except ValueError:
            continue
    return out


def run_shard(args, shard: int) -> None:
    calls_by_deal: Dict[str, Dict[int, str]] = defaultdict(dict)
    meta: Dict[str, Dict[str, Any]] = {}
    for line in open(args.traces):
        line = line.strip()
        if not line:
            continue
        r = json.loads(line)
        deal = r.get("deal")
        if not deal or shard_of(deal, args.shards) != shard:
            continue
        ctx = [t for t in (r.get("ctx") or "").split("-") if t.strip()]
        calls_by_deal[deal][len(ctx)] = r.get("call")
        if deal not in meta:
            meta[deal] = {"dealer": r.get("dealer"), "vul": int(r.get("vul", 0)),
                          "hands_pbn": None}
        if r.get("hand") and r.get("seat"):
            meta[deal].setdefault("hands", {})[str(r["seat"])[-1].upper()] = \
                r["hand"]

    arena = BiddingArena()
    out_path = "%s.%d" % (args.out, shard)

    # --resume: a killed run leaves its shard files full of good work, and a
    # DDS solve per board is the whole cost of this tool. Re-solving 20,780
    # boards to pick up 12,670 is pure waste, so skip what is already there
    # and append. Sharding is by CRC32 of the deal, so a deal always lands
    # in the same shard file and a resume cannot duplicate one.
    already = labelled_deals(out_path) if args.resume else set()
    if already:
        print("  [shard %d] resuming, %d boards already labelled"
              % (shard, len(already)), file=sys.stderr)

    done = 0
    with open(out_path, "a" if args.resume else "w") as fh:
        for k, deal in enumerate(sorted(calls_by_deal)):
            idx = sorted(calls_by_deal[deal])
            if idx != list(range(len(idx))):
                continue                       # incomplete auction
            if deal in already:
                continue
            m = meta[deal]
            try:
                dealer_letter, hands_pbn = deal.split(":", 1)
                parts = hands_pbn.split()
                if len(parts) != 4:
                    continue
                d = Deal({s: hand_from_pbn(p) for s, p in zip(SEATS, parts)},
                         seat_from_letter(dealer_letter.strip()),
                         m["vul"])
                calls = [parse_call(calls_by_deal[deal][i]) for i in idx]
            except Exception:                  # noqa: BLE001
                continue
            ns = arena.engine.evaluate_terminal_deal(d, calls, Seat.SOUTH,
                                                     d.dealer, d.vuln)
            dealer = d.dealer
            out = []
            for i in idx:
                seat = Seat((dealer.value + i) % 4)
                out.append(ns if seat in NS else -ns)
            fh.write(json.dumps({"deal": deal, "n": len(idx), "out": out}) + "\n")
            done += 1
            if args.flush_every and done % args.flush_every == 0:
                fh.flush()
                print("  [shard %d] %d boards" % (shard, done), file=sys.stderr)
    print("  [shard %d] DONE %d boards -> %s" % (shard, done, out_path),
          file=sys.stderr)


def main() -> int:
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--traces", default=os.path.join("data",
                                                     "brill_traces_330k.jsonl"))
    ap.add_argument("--out", default=os.path.join("data", "brill_outcomes"))
    ap.add_argument("--shard", type=int, default=0)
    ap.add_argument("--shards", type=int, default=1)
    ap.add_argument("--workers", type=int, default=1)
    ap.add_argument("--resume", action="store_true",
                    help="skip deals already present in the shard's output "
                         "file and append to it, instead of starting over")
    ap.add_argument("--flush-every", type=int, default=500)
    args = ap.parse_args()

    if args.workers > 1:
        from multiprocessing import Process
        procs = []
        for s in range(args.workers):
            a = argparse.Namespace(**vars(args))
            a.shard, a.shards = s, args.workers
            p = Process(target=run_shard, args=(a, s))
            p.start()
            procs.append(p)
        for p in procs:
            p.join()
        return 0
    run_shard(args, args.shard)
    return 0


if __name__ == "__main__":
    sys.exit(main())
