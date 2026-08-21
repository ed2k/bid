#!/usr/bin/env python3
"""Shows concrete board results for improved_system.dsl vs native DDS par."""
import os
import random
import sys

from bid.models import Seat
from bid.sampling import PartialState
from bid.dds import DDSolver
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler
from bid.diagnostics import ParDiagnosticEngine
from eval_vs_dds import build_deals, load_decision_net_dsl, SYSTEM_DIR, contract_string

EVAL_SEED = 1234


def hand_str(hand) -> str:
    return "  ".join(f"{s}{'-' if not hand.by_suit[s] else ''.join(str(c.rank)[0] for c in sorted(hand.by_suit[s], key=lambda c: c.rank.value, reverse=True))}"
                     for s in [Suit.SPADES, Suit.HEARTS, Suit.DIAMONDS, Suit.CLUBS]) if False else None


def fmt_hand(hand) -> str:
    from bid.models import Suit
    parts = []
    for suit in (Suit.SPADES, Suit.HEARTS, Suit.DIAMONDS, Suit.CLUBS):
        cards = "".join(str(c.rank) for c in sorted(hand.by_suit[suit], key=lambda c: c.rank.value, reverse=True))
        parts.append(f"{suit.name[0]}:{cards if cards else '-'}")
    return " ".join(parts)


def print_auction(history, dealer):
    seats = [Seat.NORTH, Seat.EAST, Seat.SOUTH, Seat.WEST]
    start = seats.index(dealer)
    cells = [""] * start + [str(c) for c in history]
    rows = [cells[i:i + 4] for i in range(0, len(cells), 4)]
    print(f"   {'N':<7}{'E':<7}{'S':<7}{'W':<7}")
    for row in rows:
        print("   " + "".join(f"{c:<7}" for c in row))


def main():
    which = [int(x) for x in sys.argv[1:]] if len(sys.argv) > 1 else None
    random.seed(None)
    deals = build_deals(64, seed=42)
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    net = load_decision_net_dsl(os.path.join(SYSTEM_DIR, "improved_system.dsl"))

    indices = which if which else [3, 9, 16, 21, 22, 49]
    for idx in indices:
        deal = deals[idx - 1]
        par_score, par_contract = DDSolver.calculate_par(deal, deal.vuln)
        dd_table = DDSolver.solve_dd_table(deal)

        history, score = arena.play_board(deal, net, net)
        pstate = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], history, deal.dealer, deal.vuln)
        contract = contract_string(pstate)

        diag = ParDiagnosticEngine.diagnose_board(idx, deal, history, score)
        status = "OPTIMAL" if diag.flaw_type.value == "OPTIMAL_PAR" else f"FLAW: {diag.flaw_type.value}"

        print("=" * 78)
        print(f"BOARD {idx} | Dealer {deal.dealer.name} | Vul {deal.vuln} | {status}")
        print("-" * 78)
        for seat in (Seat.NORTH, Seat.EAST, Seat.SOUTH, Seat.WEST):
            marker = " (opens)" if seat == deal.dealer else ""
            print(f"   {seat.name:<6} {fmt_hand(deal.hands[seat])}{marker}")
        print("-" * 78)
        print_auction(history, deal.dealer)
        tricks = ""
        c = pstate.get_contract()
        if c:
            lvl, strain, decl, dbl = c
            t = DDSolver.get_tricks(deal, strain, decl)
            need = lvl + 6
            tricks = f" | DDS: {t}/{need} tricks ({'made' if t >= need else 'down ' + str(need - t)})"
        print(f"   Result : {contract:<12} -> NS score {score:+.0f}{tricks}")
        print(f"   DDS Par: {par_contract:<12} -> {par_score:+d}")
        print(f"   Regret : {score - par_score:+.0f} pts")
        if diag.flaw_type.value != "OPTIMAL_PAR":
            print(f"   Note   : {diag.remediation_advice}")
        print()


if __name__ == "__main__":
    main()
