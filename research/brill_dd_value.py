#!/usr/bin/env python3
"""Double-dummy trick table for every deal in a Brill trace set.

    python3 research/brill_dd_value.py --traces data/brill_traces_330k.jsonl \
        --out data/brill_dd --shards 3 --workers 3 [--resume]

WHY
---
`brill_outcomes.py` labels each decision with what the board *paid* after
Brill finished the auction. §6.82 showed that label costs −1.95 IMP/board
and §6.83 showed why: it is on-policy with respect to Brill's continuation,
so a leaf comparing calls is really comparing *which deals* each call was
made on, and the argmax mines noise.

This computes the other kind of label — a **counterfactual** one. One
`CalcDDtable` per deal gives the tricks each side can take in each strain,
from which the value of *any* contract on that deal is pure arithmetic:

    value(call) = duplicate score if the auction stopped there

No continuation is assumed and no Brill call is involved, so the value of
two different calls is measured on the *same* deal. That is what makes it
a policy target rather than a record of what happened.

COST
----
One DD table per board (5 strains x 4 declarers in a single solve), not per
decision: 33,450 boards take ~12 min on 3 workers. Sharded by CRC32 of the
deal, so `--resume` can top the shard files up after a kill (see
`brill_outcomes.py`).
"""
import argparse
import json
import os
import sys
import zlib
from typing import Any, Dict, List

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))
sys.path.insert(0, os.path.join(REPO, "research"))

from bid.dds import DDSolver                                        # noqa: E402
from bid.brill.convert import hand_from_pbn, seat_from_letter       # noqa: E402
from bid.models import Seat                                         # noqa: E402
from bid.sampling import Deal                                       # noqa: E402
from brill_outcomes import labelled_deals, shard_of                 # noqa: E402

SEATS = (Seat.NORTH, Seat.EAST, Seat.SOUTH, Seat.WEST)


def load_dd_tables(patterns: List[str]) -> Dict[str, Dict[str, int]]:
    """deal -> {"S:N": tricks, ...} from `brill_dd_value.py` output."""
    import glob as _glob
    out: Dict[str, Dict[str, int]] = {}
    for pat in patterns:
        for path in sorted(_glob.glob(pat)) or ([pat] if os.path.exists(pat)
                                                else []):
            for line in open(path):
                line = line.strip()
                if not line:
                    continue
                r = json.loads(line)
                if r.get("deal"):
                    out[r["deal"]] = r["tricks"]
    return out


def run_shard(args, shard: int) -> None:
    deals: Dict[str, Any] = {}
    for line in open(args.traces):
        line = line.strip()
        if not line:
            continue
        r = json.loads(line)
        deal = r.get("deal")
        if not deal or shard_of(deal, args.shards) != shard:
            continue
        if deal not in deals:
            deals[deal] = {"vul": int(r.get("vul", 0))}

    out_path = "%s.%d" % (args.out, shard)
    already = labelled_deals(out_path) if args.resume else set()
    if already:
        print("  [shard %d] resuming, %d boards already solved"
              % (shard, len(already)), file=sys.stderr)

    done = 0
    with open(out_path, "a" if args.resume else "w") as fh:
        for deal in sorted(deals):
            if deal in already:
                continue
            try:
                dealer_letter, hands_pbn = deal.split(":", 1)
                parts = hands_pbn.split()
                if len(parts) != 4:
                    continue
                d = Deal({s: hand_from_pbn(p) for s, p in zip(SEATS, parts)},
                         seat_from_letter(dealer_letter.strip()),
                         deals[deal]["vul"])
            except Exception:                  # noqa: BLE001
                continue
            table = DDSolver.solve_dd_table(d)
            if not table:
                continue
            fh.write(json.dumps({
                "deal": deal,
                "tricks": {"%s:%s" % (k[0].name, k[1].name): v
                           for k, v in table.items()}}) + "\n")
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
    ap.add_argument("--out", default=os.path.join("data", "brill_dd"))
    ap.add_argument("--shard", type=int, default=0)
    ap.add_argument("--shards", type=int, default=1)
    ap.add_argument("--workers", type=int, default=1)
    ap.add_argument("--flush-every", type=int, default=500)
    ap.add_argument("--resume", action="store_true",
                    help="skip deals already present in the shard's output "
                         "file and append to it")
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
