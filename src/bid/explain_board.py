#!/usr/bin/env python3
"""
Play ONE board of self-play with the current system and explain every call,
then evaluate the result so a human can judge.

For each call it shows:
  * the player's context (relevant extracted features)
  * which DSL rules matched (candidate generation phi(s))
  * the legal candidate set after the auction filter
  * PIDM expected values per candidate when more than one survives
    (single-candidate calls are marked FORCED -- no search was needed)

Evaluation section:
  * final contract + exact double-dummy tricks + duplicate score
  * native DDS par + regret
  * structural flaw diagnosis
  * SDS two-hand expectation (declarer partnership view), optionally
    auction-conditioned (RBMBMC elite world selection)

Examples:
  PYTHONPATH=.. python3 explain_board.py --board 1
  PYTHONPATH=.. python3 explain_board.py --random --condition
  PYTHONPATH=.. python3 explain_board.py --board 7 --dsl system/champion_system.dsl
"""

import argparse
import os
import random
import sys

from bid.models import Seat, Suit, Strain, Call, CallType
from bid.sampling import PartialState
from bid.dds import DDSolver
from bid.pidm import PIDMEngine
from bid.sds import SDSScorer
from bid.diagnostics import ParDiagnosticEngine

from bid.eval_vs_dds import build_deals, load_decision_net_dsl, SYSTEM_DIR, contract_string

EVAL_SEED = 1234


def fmt_hand(hand):
    parts = []
    for suit in (Suit.SPADES, Suit.HEARTS, Suit.DIAMONDS, Suit.CLUBS):
        cards = "".join(str(c.rank) for c in
                        sorted(hand.by_suit[suit], key=lambda c: c.rank.value,
                               reverse=True))
        parts.append(f"{suit.name[0]}:{cards or '-'}")
    return " ".join(parts)


FEATURE_KEYS = ["hcp", "total_points", "spade_len", "heart_len",
                "diamond_len", "club_len", "is_balanced", "is_opening",
                "controls", "partner_last_call", "my_last_call",
                "opp_last_call", "last_bid_strain", "passes_since_last_bid",
                "is_balancing", "is_competitive"]


def context_line(features):
    bits = []
    for k in FEATURE_KEYS:
        if k not in features:
            continue
        v = features[k]
        if isinstance(v, str):
            bits.append(f"{k}={v}")
        elif isinstance(v, bool):
            if v:
                bits.append(k)
        else:
            bits.append(f"{k}={v}")
    return " ".join(bits)


def print_auction_header():
    print(f"   {'N':<8}{'E':<8}{'S':<8}{'W':<8}")


def main():
    ap = argparse.ArgumentParser(description="One explained self-play board + evaluation")
    ap.add_argument("--board", type=int, default=None,
                    help="1-based board index inside the seeded deal set")
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--pool", type=int, default=64,
                    help="deal-set size to draw --board from")
    ap.add_argument("--random", action="store_true",
                    help="pick a random board instead of --board")
    ap.add_argument("--dsl", default=os.path.join(SYSTEM_DIR, "improved_system.dsl"))
    ap.add_argument("--opp-dsl", default=None,
                    help="optional DIFFERENT system for East/West")
    ap.add_argument("--worlds", type=int, default=20)
    ap.add_argument("--condition", action="store_true",
                    help="auction-conditioned SDS world selection")
    ap.add_argument("--condition-factor", type=int, default=4)
    ap.add_argument("--max-calls", type=int, default=24)
    args = ap.parse_args()

    deals = build_deals(args.pool, seed=args.seed, include_stratified=False)
    idx = args.board
    if args.random or idx is None:
        idx = random.Random().randint(1, len(deals))
    assert 1 <= idx <= len(deals), f"--board must be 1..{len(deals)}"
    random.seed(args.seed * 1000 + idx)   # reproducible MC world sampling
    deal = deals[idx - 1]

    net = load_decision_net_dsl(args.dsl)
    opp_net = (load_decision_net_dsl(args.opp_dsl)
               if args.opp_dsl else net)
    models = {Seat.NORTH: net, Seat.SOUTH: net,
              Seat.EAST: opp_net, Seat.WEST: opp_net}

    engine = PIDMEngine(sampler=None, max_lookahead_depth=1)
    # sampler unused by decide() fast paths we surface below; give it one anyway
    from bid.sampling import RBMBMCSampler
    engine.sampler = RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06)

    print("=" * 78)
    print(f"BOARD {idx} (seed {args.seed}) | Dealer {deal.dealer.name} | Vul {deal.vuln}")
    print(f"system : {os.path.basename(args.dsl)}"
          + (f" | opponents: {os.path.basename(args.opp_dsl)}" if args.opp_dsl else " (self-play)"))
    print("=" * 78)
    for seat in Seat:
        mark = "  <- opens" if seat == deal.dealer else ""
        print(f"  {seat.name:<6} {fmt_hand(deal.hands[seat])}{mark}")

    history = []
    curr = deal.dealer
    n_calls = 0

    print("\n---- AUCTION (explained) ----")
    print_auction_header()

    while True:
        ps = PartialState(curr, deal.hands[curr], history,
                          deal.dealer, deal.vuln)
        if ps.is_auction_over() or n_calls >= args.max_calls:
            break

        feats = __import__("bid.features", fromlist=["BridgeFeatures"]) \
            .BridgeFeatures.extract_all(deal.hands[curr], history, curr,
                                        deal.dealer, deal.vuln)

        matched = []
        for r in net.rules:
            try:
                if r.matches(feats):
                    matched.append(r)
            except Exception:
                pass
        candidates = net.actions(deal.hands[curr], history, curr,
                                 deal.dealer, deal.vuln)

        call, values = engine.decide(ps, models)
        forced = len(candidates) == 1

        # ---- render this call ----
        print(f"#{n_calls + 1:<2} {curr.name:<6} bids {call}")

        mm = ", ".join(sorted({r.rule_id for r in matched})) or "(no rule)"
        print(f"     context : {context_line(feats)}")
        print(f"     matched : {mm}")
        cand_s = sorted(str(c) for c in candidates)
        print(f"     phi(s)  : {cand_s}")
        if forced:
            print(f"     decision: FORCED (only one legal candidate)")
        else:
            ranked = sorted(values.items(), key=lambda kv: -kv[1])
            vals_s = ", ".join(f"{str(c)}={v:+.0f}" for c, v in ranked)
            print(f"     decision: argmax E[score] -> {vals_s}")
        if matched:
            top = max(matched, key=lambda r: r.priority)
            conds = "; ".join(f"{x.key} {x.op} {x.value}" for x in top.conditions)
            print(f"     why     : {top.rule_id}: {conds}")

        history.append(call)
        curr = Seat((curr.value + 1) % 4)
        n_calls += 1

    # re-render compact auction grid
    print()
    cells = [""] * list(Seat).index(deal.dealer) + [str(c) for c in history]
    rows = [cells[i:i + 4] for i in range(0, len(cells), 4)]
    print_auction_header()
    for row in rows:
        print("   " + "".join(f"{c:<8}" for c in row))

    # ---------------- evaluation ----------------
    pstate = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], history,
                          deal.dealer, deal.vuln)
    contract = contract_string(pstate)
    score = engine.evaluate_terminal_deal(deal, history, Seat.SOUTH,
                                          deal.dealer, deal.vuln)

    par_score, par_contract = DDSolver.calculate_par(deal, deal.vuln)
    dd_table = DDSolver.solve_dd_table(deal)

    print("\n---- EVALUATION ----")
    print(f"  contract : {contract}")
    c = pstate.get_contract()
    if c:
        lvl, strain, decl, dbl = c
        t = DDSolver.get_tricks(deal, strain, decl)
        need = lvl + 6
        print(f"  dd tricks: {t}/{need} ({'MADE' if t >= need else 'down ' + str(need - t)})")

        scorer = SDSScorer(num_worlds=args.worlds, seed=2024,
                           condition_factor=args.condition_factor if args.condition else 0)
        sds = scorer.score_contract(deal, lvl, strain, decl, dbl, deal.vuln,
                                    history=history, models=models)
        side = "declarer(N/S)" if decl in (Seat.NORTH, Seat.SOUTH) else "defenders(E/W)"
        print(f"  SDS[{side}, {args.worlds} worlds"
              + (", auction-conditioned" if args.condition else "") + "]")
        print(f"     P(make)      : {sds.p_make:.2f}")
        print(f"     E[tricks]    : {sds.mean_tricks:.2f}")
        print(f"     E[dup score] : {sds.mean_score:+.1f}  -> "
              f"NS-perspective {('+' if decl in (Seat.NORTH, Seat.SOUTH) else '-')}"
              f"{abs(sds.mean_score):.1f}")
    print(f"  NS score : {score:+.0f}")
    print(f"  DDS par  : {par_contract} ({par_score:+d})"
          f"   |   regret {score - par_score:+.0f}")

    diag = ParDiagnosticEngine.diagnose_board(idx, deal, history, score)
    print(f"  verdict  : {diag.flaw_type.value}")
    if diag.flaw_type.value != "OPTIMAL_PAR":
        print(f"  note     : {diag.remediation_advice}")

    print("\n(Judge: compare the explained auction against the DD-par contract;")
    print(" SDS P(make)<~0.5 means the final contract leans on luck.)")


if __name__ == "__main__":
    main()
