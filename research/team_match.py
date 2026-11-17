#!/usr/bin/env python3
"""Head-to-head team match between two bidding systems.

    python3 research/team_match.py --a system/brill_distilled.dsl \
        --b system/champion_system.dsl --boards 400 --seed 7

WHY THIS EXISTS
---------------
Every other comparison in this repo scores a system against **par**, and par
comparisons have a trap: `mean_imp_loss` is an absolute deviation, so beating
par by too much is scored as badly as missing it, while `mean_imp_diff` is
signed and rewards optimism. The two rank systems in opposite directions
(§6.28) — remote Brill is +1.36 abs vs champion (t +10.81) but −0.18 signed
(t −0.91), so "is Brill better?" has no answer on those numbers alone.

A team match removes par from the question entirely. Each deal is played at
two tables:

    table 1:  NS = A,  EW = B   ->  NS score s1
    table 2:  NS = B,  EW = A   ->  NS score s2

A sits NS at one table and EW at the other, so A's net on the board is
`s1 - s2` (A's EW result is `-s2`). That difference is converted straight to
IMPs. This is exactly how duplicate team games are scored, and it asks the
only question that matters: **which system wins the board when both are at the
table?** No par, no absolute-value artefact, no signed/unsigned ambiguity.

It is also a paired design, which is why it is far more sensitive than
comparing two independent means: both systems bid the same cards.

COMMON RANDOM NUMBERS
---------------------
`play_board` is stochastic (PIDM sampling), so the two tables could differ by
luck as well as by system. The seed is reset to the same value before each
table, so both see the same random stream and the systems' difference is what
remains. This is variance reduction, not cheating: it removes noise, it does
not favour either side, since both get the identical stream.

OUTPUT
------
Mean IMP/board for A (positive = A wins), with a t-statistic against 0, plus
boards won/lost and per-side pass-out counts.
"""
import argparse
import json
import os
import sys
from typing import Any, Dict, List, Tuple

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))

from bid.arena import BiddingArena                              # noqa: E402
from bid.eval_vs_dds import (build_deals, load_decision_net_dsl,  # noqa: E402
                             seed_board)
from bid.scoring import diff_to_imps                            # noqa: E402

SYSTEM_DIR = os.path.join(REPO, "system")


def to_imps(net_points: float) -> int:
    """Signed IMPs for a point differential (diff_to_imps is magnitude only)."""
    n = int(round(net_points))
    mag = diff_to_imps(n)
    return -mag if n < 0 else mag


def passed_out(hist: List[Any]) -> bool:
    return not any(str(c) != "PASS" for c in hist)


def contested(hist: List[Any], dealer: Any) -> bool:
    """True if BOTH partnerships bid — i.e. the auction was competitive.

    Seat of call i is (dealer + i) % 4; N/S are one side, E/W the other.
    This splits the match into auctions the two systems actually fought over
    versus ones where one side bought it uncontested, which matters because a
    system can be fine in its own auctions and still lose every fight.
    """
    from bid.models import CallType, Seat
    ns = (Seat.NORTH, Seat.SOUTH)
    ns_bid = ew_bid = False
    for i, c in enumerate(hist):
        if c.type == CallType.BID:
            seat = Seat((dealer.value + i) % 4)
            if seat in ns:
                ns_bid = True
            else:
                ew_bid = True
    return ns_bid and ew_bid


class RemoteBrill:
    """Adapt the Brill service to the model interface `play_board` expects.

    Returns exactly one candidate -- Brill's own answer -- so PIDMEngine has
    no frontier to search. That keeps it at one HTTP request per call (~8
    per board) instead of the ~3x that `decide`'s candidate probing would
    cost.

    FAIRNESS CAVEAT: a local DecisionNet hands PIDM a *ranked candidate
    list* and PIDM picks with one seat of lookahead, whereas Brill hands it a
    single call. So in a team match the local side gets PIDM assistance and
    Brill does not. This is the same asymmetry the repo already accepts in
    `brill_remote_eval.py`, and there is no way to remove it -- Brill's
    service exposes only its chosen call, not a ranked set. Treat a Brill
    *win* as strong evidence and a Brill *loss* as unproven.
    """

    def __init__(self, client: Any):
        self.client = client
        self.name = "remote_brill"
        self.calls = 0

    def actions(self, hand: Any, history: List[Any], seat: Any,
                dealer: Any, vuln: int) -> List[Any]:
        from bid.brill.convert import auction_ctx, parse_call
        from bid.models import Call, CallType
        try:
            res = self.client.bid(hand, ctx=auction_ctx(history), seat=seat,
                                  dealer=dealer, vul=vuln)
            self.calls += 1
            if res and getattr(res, "bid", None):
                return [parse_call(res.bid)]
        except Exception:                                        # noqa: BLE001
            pass
        return [Call(CallType.PASS)]


def play_match(a: Any, b: Any, deals: List[Any], arena: BiddingArena,
               seed: int, label_a: str, label_b: str) -> Dict[str, Any]:
    imps: List[int] = []
    nets: List[int] = []
    wins = losses = ties = 0
    a_passed = b_passed = 0
    both_passed = 0
    cont: List[int] = []
    uncont: List[int] = []
    per_board: List[Dict[str, Any]] = []

    for i, deal in enumerate(deals):
        # Same seed at both tables: see COMMON RANDOM NUMBERS above.
        seed_board(seed, i)
        h1, s1 = arena.play_board(deal, a, b)
        seed_board(seed, i)
        h2, s2 = arena.play_board(deal, b, a)

        net = s1 - s2
        imp = to_imps(net)
        imps.append(imp)
        nets.append(int(round(net)))
        is_cont = contested(h1, deal.dealer)
        (cont if is_cont else uncont).append(imp)
        # Per-board records, so two runs on the same --seed can be DIFFERENCED
        # board by board. That paired test is far tighter than comparing two
        # independent t-statistics, which is what you are otherwise reduced to.
        per_board.append({"board": i, "net": int(round(net)), "imp": imp,
                          "contested": bool(is_cont)})
        if imp > 0:
            wins += 1
        elif imp < 0:
            losses += 1
        else:
            ties += 1

        # At table 1 A is NS, at table 2 A is EW.
        p1, p2 = passed_out(h1), passed_out(h2)
        if p1 and p2:
            both_passed += 1
        if p1:
            a_passed += 1
        if p2:
            b_passed += 1

    n = len(imps)
    mean = sum(imps) / n
    sd = (sum((x - mean) ** 2 for x in imps) / (n - 1)) ** 0.5 if n > 1 else 0.0
    se = sd / (n ** 0.5) if n else 0.0
    def _stats(xs):
        if not xs:
            return None
        m = sum(xs) / len(xs)
        sd = (sum((v - m) ** 2 for v in xs) / (len(xs) - 1)) ** 0.5 \
            if len(xs) > 1 else 0.0
        se = sd / (len(xs) ** 0.5)
        return {"n": len(xs), "mean": m, "se": se,
                "t": (m / se) if se else 0.0, "total": sum(xs)}

    return {
        "contested": _stats(cont), "uncontested": _stats(uncont),
        "boards": per_board,
        "label_a": label_a, "label_b": label_b, "n": n,
        "mean": mean, "sd": sd, "se": se,
        "t": (mean / se) if se else 0.0,
        "total": sum(imps), "wins": wins, "losses": losses, "ties": ties,
        "a_passed": a_passed, "b_passed": b_passed,
        "both_passed": both_passed, "imps": imps, "nets": nets,
    }


def report(r: Dict[str, Any]) -> None:
    n, mean, se, t = r["n"], r["mean"], r["se"], r["t"]
    print("\nTEAM MATCH  %s  vs  %s" % (r["label_a"], r["label_b"]))
    print("  boards                %d" % n)
    print("  %-20s %+6.2f IMP/board  (se %.2f, t %+.2f)"
          % (r["label_a"] + " net:", mean, se, t))
    print("  total                 %+d IMP" % r["total"])
    print("  boards won/lost/tied  %d / %d / %d"
          % (r["wins"], r["losses"], r["ties"]))
    print("  passed out            %s %d | %s %d | both %d"
          % (r["label_a"], r["a_passed"], r["label_b"], r["b_passed"],
             r["both_passed"]))
    for key, lbl in (("contested", "CONTESTED"),
                     ("uncontested", "UNCONTESTED")):
        s = r.get(key)
        if not s:
            continue
        print("  %-12s n=%-4d %+6.2f IMP/board (se %.2f, t %+.2f) total %+d"
              % (lbl, s["n"], s["mean"], s["se"], s["t"], s["total"]))
    verdict = ("%s wins" % r["label_a"] if t > 1.96 else
               "%s wins" % r["label_b"] if t < -1.96 else
               "no significant difference")
    print("  --> %s (95%%)" % verdict)


def main():
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--a", default=os.path.join(SYSTEM_DIR,
                                                "brill_distilled.dsl"))
    ap.add_argument("--b", default=os.path.join(SYSTEM_DIR,
                                                "champion_system.dsl"))
    ap.add_argument("--boards", type=int, default=400)
    ap.add_argument("--seed", type=int, default=7)
    ap.add_argument("--remote-a", action="store_true",
                    help="play A through the live Brill service instead of a "
                         "DSL file (one HTTP request per call)")
    ap.add_argument("--cache", default="/tmp/team_match_brill.json",
                    help="response cache for --remote-a")
    ap.add_argument("--swap", action="store_true",
                    help="run the mirror match too (B as 'A'), which should "
                         "mirror the result; a large asymmetry means the "
                         "harness or the seeding is biased")
    ap.add_argument("--dump", help="write the full result record, including "
                                   "per-board nets, as JSON (for paired "
                                   "comparison of two runs on the same seed)")
    ap.add_argument("--bayes-b", action="store_true",
                    help="wrap B in Program 4 BayesianSingleDummyBidder")
    args = ap.parse_args()

    if args.remote_a:
        from bid.brill import BrillClient
        a = RemoteBrill(BrillClient(cache_path=args.cache))
        # Remote Brill is the interesting side, so put it on A where the
        # reported sign is "A net".
        a.name = "remote_brill"
    else:
        a = load_decision_net_dsl(args.a)
        a.name = os.path.splitext(os.path.basename(args.a))[0]
    b = load_decision_net_dsl(args.b)
    b.name = os.path.splitext(os.path.basename(args.b))[0]
    if args.bayes_b:
        from bid.bayesian_search import BayesianSingleDummyBidder
        b = BayesianSingleDummyBidder(b, num_worlds=8)

    deals = build_deals(args.boards, seed=args.seed, include_stratified=False)
    arena = BiddingArena()
    print("%s vs %s on %d boards (seed %d)"
          % (a.name, b.name, len(deals), args.seed))

    res = play_match(a, b, deals, arena, args.seed, a.name, b.name)
    if args.remote_a:
        a.client.flush_cache()
    report(res)
    if args.dump:
        with open(args.dump, "w") as fh:
            json.dump(res, fh)
        print("  dumped per-board results to %s" % args.dump)
    if args.swap:
        report(play_match(b, a, deals, arena, args.seed, b.name, a.name))
    return 0


if __name__ == "__main__":
    sys.exit(main())
