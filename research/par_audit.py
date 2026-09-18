#!/usr/bin/env python3
"""Signed and absolute deviation from par, for us and for Brill.

    python3 research/par_audit.py --dump /tmp/gap_all.jsonl \
        --traces data/brill_traces_held.jsonl

WHY
---
§6.81 established that we lose 1.780 IMP/board to Brill head-to-head on
identical cards, and that the mechanism is a level bias: we stop in
partscore 60% of the time against Brill's 43%. The obvious fix is "bid
more" — but §6.28's duality is a standing warning that *bidding more* is
exactly the kind of change `mean_imp_diff` rewards and `mean_imp_loss`
punishes, and §6.68 already saw a forced-aggression experiment make
things worse.

So before recommending anything: is our conservatism actually costing,
measured against par? Three distinguishable worlds:

  * we are below par and Brill is nearer par   -> bid more, unambiguously
  * we are nearer par and Brill is over par    -> Brill is overbidding and
                                                  getting away with it
  * both equidistant, opposite directions      -> no free lunch, the fix
                                                  is strain/level accuracy
                                                  not raw aggression

Absolute deviation alone cannot tell these apart; signed deviation alone
cannot either. This prints both, side by side, on the same boards, using
the auctions already replayed by `brill_gap_where.py`.
"""
import argparse
import json
import os
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))
sys.path.insert(0, os.path.join(REPO, "research"))

from bid.arena import BiddingArena                                  # noqa: E402
from bid.brill.convert import parse_call                            # noqa: E402
from bid.eval_vs_dds import imp_diff, imp_loss, precompute          # noqa: E402
from bid.models import Seat                                         # noqa: E402
from bid.sampling import Deal                                       # noqa: E402
from brill_gap_where import load_boards                             # noqa: E402


def mean_sd(xs):
    n = len(xs)
    m = sum(xs) / n
    sd = (sum((x - m) ** 2 for x in xs) / (n - 1)) ** 0.5 if n > 1 else 0.0
    return m, sd / (n ** 0.5)


def main() -> int:
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--traces", default=os.path.join("data",
                                                     "brill_traces_held.jsonl"))
    ap.add_argument("--dump", required=True,
                    help="jsonl from brill_gap_where.py --dump")
    ap.add_argument("--boards", type=int, default=0)
    args = ap.parse_args()

    boards = load_boards(args.traces)
    rows = [json.loads(l) for l in open(args.dump)]
    n = min(len(boards), len(rows))
    if args.boards:
        n = min(n, args.boards)
    boards, rows = boards[:n], rows[:n]

    deals = [Deal(b["hands"], b["dealer"], b["vul"]) for b in boards]
    print("computing par for %d boards (DDS) ..." % n, file=sys.stderr)
    par = precompute(deals)

    arena = BiddingArena()
    ours_diff, ours_loss, brill_diff, brill_loss = [], [], [], []
    for b, r, (par_score, par_contract, _dd) in zip(boards, rows, par):
        d = deals[len(ours_diff)]
        def score(s):
            calls = [parse_call(t) for t in s.split()] if s.strip() else []
            return arena.engine.evaluate_terminal_deal(d, calls, Seat.SOUTH,
                                                       b["dealer"], b["vul"])
        s_a, s_b = score(r["calls_a"]), score(r["calls_b"])
        ours_diff.append(imp_diff(s_a, par_score))
        ours_loss.append(imp_loss(s_a, par_score))
        brill_diff.append(imp_diff(s_b, par_score))
        brill_loss.append(imp_loss(s_b, par_score))

    print("\nsigned vs par (mean_imp_diff, + = beating par) and "
          "absolute (mean_imp_loss, lower is better)")
    print("  %-8s %14s %14s" % ("", "signed", "absolute"))
    for name, sd_, sl in (("ours", ours_diff, ours_loss),
                          ("Brill", brill_diff, brill_loss)):
        md, sed = mean_sd(sd_)
        ml, sel = mean_sd(sl)
        print("  %-8s %+7.3f +-%.3f %7.3f +-%.3f"
              % (name, md, sed, ml, sel))
    md_o, _ = mean_sd(ours_diff)
    md_b, _ = mean_sd(brill_diff)
    print("\n  Brill's signed edge over us: %+.3f IMP/board"
          % (md_b - md_o))
    return 0


if __name__ == "__main__":
    sys.exit(main())
