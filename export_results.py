#!/usr/bin/env python3
"""
Plays 64 random deals with system/improved_system.dsl and writes a full report
(hands, auction, DDS tricks/score, DDS par result) to improved_system_64_deals.txt.
"""

import argparse
import os
import time

from bid.models import Seat
from bid.sampling import PartialState
from bid.dds import DDSolver
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler
from bid.diagnostics import ParDiagnosticEngine
from eval_vs_dds import build_deals, load_decision_net_dsl, SYSTEM_DIR, contract_string

OUT_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "improved_system_64_deals.txt")
NUM_DEALS = 64
SEED = 42
EVAL_SEED = 1234

SUIT_ORDER = None


def fmt_hand(hand) -> str:
    from bid.models import Suit
    parts = []
    for suit in (Suit.SPADES, Suit.HEARTS, Suit.DIAMONDS, Suit.CLUBS):
        cards = "".join(str(c.rank) for c in sorted(hand.by_suit[suit], key=lambda c: c.rank.value, reverse=True))
        parts.append(f"{suit.name[0]}:{cards if cards else '-'}")
    return " ".join(parts)


def print_auction(lines, history, dealer):
    seats = [Seat.NORTH, Seat.EAST, Seat.SOUTH, Seat.WEST]
    start = seats.index(dealer)
    cells = [""] * start + [str(c) for c in history]
    lines.append(f"   {'N':<7}{'E':<7}{'S':<7}{'W':<7}")
    for row in [cells[i:i + 4] for i in range(0, len(cells), 4)]:
        lines.append("   " + "".join(f"{c:<7}" for c in row))


def main():
    parser = argparse.ArgumentParser(description="Export board results vs DDS par to txt")
    parser.add_argument("--deals", type=int, default=NUM_DEALS)
    parser.add_argument("--seed", type=int, default=SEED)
    parser.add_argument("--out", type=str, default=None)
    args = parser.parse_args()
    out_path = args.out or f"improved_system_{args.deals}_deals.txt"

    t0 = time.time()
    deals = build_deals(args.deals, seed=args.seed, include_stratified=False)
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    net = load_decision_net_dsl(os.path.join(SYSTEM_DIR, "improved_system.dsl"))

    lines = []
    lines.append("=" * 80)
    lines.append(f" IMPROVED SYSTEM — {args.deals} RANDOM DEALS vs NATIVE DDS PAR")
    lines.append(f" deal seed {args.seed}, MC seed {EVAL_SEED}, generated {time.strftime('%Y-%m-%d %H:%M:%S')}")
    lines.append("=" * 80)

    tot_score = tot_par = 0.0
    optimal = 0
    flaw_counts = {}

    for idx, deal in enumerate(deals, 1):
        par_score, par_contract = DDSolver.calculate_par(deal, deal.vuln)
        history, score = arena.play_board(deal, net, net)
        pstate = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], history, deal.dealer, deal.vuln)
        contract = contract_string(pstate)
        diag = ParDiagnosticEngine.diagnose_board(idx, deal, history, score)

        tot_score += score
        tot_par += par_score
        if diag.flaw_type.value == "OPTIMAL_PAR":
            optimal += 1
        else:
            flaw_counts[diag.flaw_type.value] = flaw_counts.get(diag.flaw_type.value, 0) + 1

        lines.append("")
        lines.append("-" * 80)
        tricks_s = ""
        c = pstate.get_contract()
        if c:
            lvl, strain, decl, dbl = c
            t = DDSolver.get_tricks(deal, strain, decl)
            need = lvl + 6
            tricks_s = f" | DDS tricks: {t}/{need} ({'MADE' if t >= need else 'down ' + str(need - t)})"
        lines.append(f"BOARD {idx:<3} | Dealer {deal.dealer.name:<5} | Vul {deal.vuln} | {diag.flaw_type.value}")
        lines.append("-" * 80)
        for seat in (Seat.NORTH, Seat.EAST, Seat.SOUTH, Seat.WEST):
            lines.append(f"  {seat.name:<6} {fmt_hand(deal.hands[seat])}")
        lines.append("")
        print_auction(lines, history, deal.dealer)
        lines.append("")
        lines.append(f"  Result : {contract}{tricks_s}")
        lines.append(f"  NS score {score:+.0f}   |   DDS Par: {par_contract}  ({par_score:+d})   |   Regret: {score - par_score:+.0f}")

    n = len(deals)
    lines.append("")
    lines.append("=" * 80)
    lines.append(" SUMMARY")
    lines.append("=" * 80)
    lines.append(f"  Boards played        : {n}")
    lines.append(f"  Avg NS score         : {tot_score / n:+.1f} pts/board")
    lines.append(f"  Avg DDS par          : {tot_par / n:+.1f} pts/board")
    lines.append(f"  Avg regret vs par    : {(tot_score - tot_par) / n:+.1f} pts/board")
    lines.append(f"  Optimal boards       : {optimal}/{n} ({optimal / n * 100:.1f}%)")
    for flaw, cnt in sorted(flaw_counts.items(), key=lambda kv: -kv[1]):
        lines.append(f"  {flaw:<20}: {cnt}")
    lines.append(f"  Total runtime        : {time.time() - t0:.1f}s")
    lines.append("=" * 80)

    with open(out_path, "w") as f:
        f.write("\n".join(lines) + "\n")
    print(f"Wrote {out_path} ({len(deals)} boards)")
    print("\n".join(lines[-12:]))


if __name__ == "__main__":
    main()
