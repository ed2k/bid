#!/usr/bin/env python3
"""
convention_lab.py — mathematical & empirical testing ground for convention claims.

Three rigor tiers:
  EXACT      closed-form / DP combinatorics (HCP distribution, suit breaks)
  MONTE-CARLO huge-N estimates with reported CIs (8+ fit probability)
  DOMINANCE  paired significance tests between systems/thresholds over the
             uniform deal distribution using the native DD oracle

Subcommands:
  hcp-dist              exact P(HCP = h) and P(HCP >= t) for t=10..16
  breaks                exact suit-split probabilities for a given fit length
  fit [--samples N]     P(partnership holds an 8+ card fit) with CI
  info-bound            provable channel-capacity style bound on auction precision
  thresholds [--boards N]  duel opening-threshold families (11/12/13/14) vs baseline
  duel --a NAME --b NAME [--boards N]   head-to-head archetypes, both orientations, CI
  weak2 [--boards N]    v11 with weak-2s vs without (paired regret delta)

Everything prints numbers plus its evidential status.
"""

import argparse
import math
import os
import random
import statistics
import sys
from functools import lru_cache
from typing import Dict, List, Tuple

from bid.models import Seat, Strain, Card, Rank
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler
from bid.scoring import score_to_imp

from bid.eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR, precompute


# ================= EXACT: HCP distribution =================

def hcp_generating_polynomial():
    """Per-card HCP weights: A=4 K=3 Q=2 J=1 others 0. Four copies of each."""
    return [4, 3, 2, 1] + [0] * 9   # A,K,Q,J,T,9..2


def exact_hcp_distribution():
    """
    Exact count of 13-card hands by total HCP via polynomial DP:
    product over 52 cards of (1 + y*x^w_card), take coefficient of choosing 13.
    Returns list of 41 integers indexed by hcp 0..40.
    """
    weights = hcp_generating_polynomial()
    # dp[k][h] = ways to pick k cards with h hcp so far
    dp = [[0] * 41 for _ in range(14)]
    dp[0][0] = 1
    cards = [(s, w) for s in range(4) for w in weights]
    for s, w in cards:
        for k in range(12, -1, -1):
            for h in range(40, -1, -1):
                if dp[k][h] and h + w <= 40 and k + 1 <= 13:
                    dp[k + 1][h + w] += dp[k][h]
    return dp[13]


def cmd_hcp_dist():
    dist = exact_hcp_distribution()
    total = sum(dist)
    assert total == math.comb(52, 13), f"sanity failed: {total}"
    print(f"EXACT (sum check {total} == C(52,13))")
    for t in range(10, 17):
        ge = sum(dist[t:]) / total
        lt = sum(dist[:t]) / total
        print(f"  P(HCP >= {t}) = {ge:.6f}    P(HCP < {t}) = {lt:.6f}")
    print("\n  pmf:")
    for h in range(41):
        if dist[h]:
            print(f"   HCP={h:<2} p={dist[h] / total:.6f}")


# ================= EXACT: suit break probabilities =================

def cmd_breaks(fit: int):
    """Opponents hold 13-fit cards; exact split probs (hypergeometric)."""
    opp_total = 13 - fit                     # defenders' cards in our suit
    others = 26 - opp_total                  # defenders' cards outside the suit
    denom = math.comb(26, 13)
    print(f"EXACT: defenders hold {opp_total} of our suit (fit={fit}); splits:")
    tot_check = 0.0
    for e in range(0, min(opp_total, 13) + 1):
        w = opp_total - e
        p = math.comb(opp_total, e) * math.comb(others, 13 - e) / denom
        tot_check += p
        print(f"   E={e} W={w}: {p:.4f}")
    print(f"   (sum check {tot_check:.4f})")


# ================= MONTE-CARLO: 8+ fit probability =================

def mc_fit_prob(samples: int = 2_000_000, seed: int = 7):
    rng = random.Random(seed)
    hits = 0
    # Precompute deck once; sampling = shuffle 52, count NS per suit
    deck = [(s, r) for s in range(4) for r in range(13)]
    for _ in range(samples):
        rng.shuffle(deck)
        ns = [0, 0, 0, 0]
        for i in range(26):                      # first 26 = N+S combined
            ns[deck[i][0]] += 1
        if any(c >= 8 for c in ns):
            hits += 1
    p = hits / samples
    half = 1.96 * math.sqrt(p * (1 - p) / samples)
    print(f"MONTE-CARLO (n={samples:,}, seed={seed})")
    print(f"  P(NS hold an 8+ card fit) = {p:.4f} +/- {half:.4f} (95% CI)")


# ================= PROVABLE: information bound =================

def cmd_info_bound():
    """
    Provable counting bound: an auction is a sequence of distinct-in-context
    calls; the number of DISTINCT legal auctions of length <= L bounds the
    number of distinguishable 'messages'. Compare with the number of coarse
    partnership-hands classes that conventions must separate.
    """
    bids_available = 35            # 5 levels x 7 strains (ignoring X/XX)
    # crude upper bound on auctions of length <= 10 with legality factor:
    # each call after the first has <= bids_available options anyway (upper bound)
    L = 10
    upper_auctions = sum(bids_available ** k for k in range(1, L + 1))
    bits_upper = math.log2(upper_auctions)

    # partner-hand classes a system must convey (coarse but practical):
    hcp_classes = 7                # 0-5,6-9,10-12,13-15,16-18,19-21,22+
    shape_classes = 5              # balanced / semi / one-5 / one-6 / two-suiter
    major_stop = 2                 # stopper yes/no in a side suit (approx)
    partner_entropy = math.log2(hcp_classes * shape_classes * major_stop)

    print("PROVABLE COUNTING BOUND (upper bound style)")
    print(f"  auctions of length <= {L}: <= {upper_auctions:,} "
          f"=> log2 capacity = {bits_upper:.1f} bits")
    print(f"  coarse partner classes needed: {hcp_classes}x{shape_classes}x{major_stop} "
          f"=> {partner_entropy:.1f} bits")
    print("  => capacity comfortably exceeds the coarse requirement; precision")
    print("     (fine HCP/exact shape, ~20+ bits) is what forces conventions to be LOSSY.")
    print("  Corollary: any convention is a lossy code; disputes are about WHICH loss.")


# ================= DOMINANCE: opening threshold family =================

BASE_OPENINGS = [
    ("OPEN_1NT", dict(call=(1, Strain.NT)),
     [("is_opening", "==", True), ("hcp", ">=", 15), ("hcp", "<=", 17),
      ("is_balanced", "==", True)]),
]

def sayc_like_net(threshold: int):
    """Natural system: 5-card majors, longer minor, opening HCP = threshold."""
    from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
    from bid.models import Call, CallType
    net = DecisionNet(f"SAYC_t{threshold}")
    O = [("is_opening", "==", True)]

    def R(rid, lvl, strain, extra, lo=None, hi=None, prio=20):
        conds = [RuleCondition("is_opening", "==", True),
                 RuleCondition("hcp", ">=", lo if lo is not None else threshold)]
        if hi is not None:
            conds.append(RuleCondition("hcp", "<=", hi))
        for k, op, v in extra:
            conds.append(RuleCondition(k, op, v))
        net.add_rule(DecisionNetRule(rid, Call(CallType.BID, lvl, strain),
                                     conds, priority=prio))

    R(f"T{threshold}_1H", 1, Strain.HEARTS, [("heart_len", ">=", 5)])
    R(f"T{threshold}_1S", 1, Strain.SPADES, [("spade_len", ">=", 5)])
    R(f"T{threshold}_1D", 1, Strain.DIAMONDS, [("diamond_len", ">=", 4)], prio=15)
    R(f"T{threshold}_1C", 1, Strain.CLUBS, [("club_len", ">=", 3)], prio=10)
    # 1NT stays fixed 15-17 balanced regardless of threshold
    net.add_rule(DecisionNetRule(
        f"T{threshold}_1NT", Call(CallType.BID, 1, Strain.NT),
        [RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 15),
         RuleCondition("hcp", "<=", 17), RuleCondition("is_balanced", "==", True)],
        priority=20))
    # minimal responses so opener-passout doesn't dominate everything
    net.add_rule(DecisionNetRule(
        f"T{threshold}_RESP_1NT", Call(CallType.BID, 1, Strain.NT),
        [RuleCondition("partner_last_call", "in", ["1C", "1D", "1H", "1S"]),
         RuleCondition("hcp", ">=", 6)], priority=14))
    return net


def duel(a_net, b_net, deals, engine, arena):
    """Both orientations; returns per-board imp diffs (A minus B)."""
    diffs = []
    for deal in deals:
        _, sc_a_ns = arena.play_board(deal, a_net, b_net)
        diffs.append(score_to_imp(int(sc_a_ns)))
        _, sc_b_ns = arena.play_board(deal, b_net, a_net)
        diffs.append(-score_to_imp(int(sc_b_ns)))
    return diffs


def summarize(diffs, label):
    n = len(diffs)
    m = sum(diffs) / n
    sd = statistics.stdev(diffs) if n > 1 else 0.0
    z = m / (sd / (n ** 0.5)) if sd > 0 else float("inf") * (1 if m > 0 else 0)
    print(f"  {label:<28} n={n:<5} imps/board {m:+7.3f}  z={z:+5.2f}")
    return m, z


def cmd_thresholds(boards: int):
    from bid.sampling import RBMBMCSampler
    from bid.pidm import PIDMEngine
    from bid.arena import BiddingArena
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6,
                                              timeout_sec=0.06), max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    deals = [d for d in build_deals(max(boards // 2, 8), seed=TRAIN_SEED_LIKE())
             if True][:boards]

    nets = {t: sayc_like_net(t) for t in (11, 12, 13, 14)}
    print("DOMINANCE TEST: opening-threshold family, natural 5-card majors.")
    print(f"  boards={len(deals)} x 2 orientations per pairing\n")
    base = nets[12]           # human standard as pivot
    for t in (11, 13, 14):
        diffs = duel(nets[t], base, deals, engine, arena)
        m, z = summarize(diffs, f"t={t}  vs  t=12 (standard)")
        verdict = ("significantly better" if z >= 2 else
                   "significantly worse" if z <= -2 else
                   "not separable at this n")
        print(f"    -> {verdict}\n")
    print("EPISTEMIC STATUS: statistical dominance over uniform deals with this")
    print("continuation set; NOT a full-game equilibrium proof.")


def TRAIN_SEED_LIKE():
    return 42


# ================= DOMINANCE: archetype duels =================

ARCHETYPES = None

def get_archetypes():
    global ARCHETYPES
    if ARCHETYPES is None:
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
        from bid.optimizer import SystemOptimizer
        o = SystemOptimizer()
        ARCHETYPES = {
            "sayc": o.create_sayc_baseline(),
            "precision": o.create_precision_system(),       # ARTIFICIAL 1C = 16+
            "modern21": o.create_modern_2over1(),
        }
    return ARCHETYPES


def cmd_duel(a: str, b: str, boards: int):
    from bid.sampling import RBMBMCSampler
    from bid.pidm import PIDMEngine
    from bid.arena import BiddingArena
    arch = get_archetypes()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6,
                                              timeout_sec=0.06), max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    deals = build_deals(boards, seed=42)[:boards]
    diffs = duel(arch[a], arch[b], deals, engine, arena)
    print(f"DOMINANCE TEST: {a.upper()} vs {b.upper()}  ({boards} boards x 2)")
    m, z = summarize(diffs, f"{a} vs {b}")
    if z >= 2:
        print(f"  -> {a} significantly better over uniform deals (z={z:.2f})")
    elif z <= -2:
        print(f"  -> {b} significantly better (z={z:.2f})")
    else:
        print("  -> not separable at this board count; escalate n")


# ================= DOMINANCE: weak-2 ablation on v11 =================

def cmd_weak2(boards: int):
    base = load_decision_net_dsl(os.path.join(SYSTEM_DIR, "improved_system.dsl"))
    ablated = base.clone()
    removed = [r.rule_id for r in ablated.rules
               if r.rule_id.startswith(("R_WEAK_2H", "R_WEAK_2S"))]
    ablated.rules = [r for r in ablated.rules if r.rule_id not in removed]

    from bid.sampling import RBMBMCSampler
    from bid.pidm import PIDMEngine
    from bid.arena import BiddingArena
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6,
                                              timeout_sec=0.06), max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    deals = build_deals(boards, seed=42)

    res_with = evaluate_system(arena, "with", base, deals, precompute(deals), seed=777)
    res_wo = evaluate_system(arena, "without", ablated, deals,
                             precompute(deals), seed=777)

    # identical par per board => score deltas equal regret deltas
    d_score = [b - a for a, b in zip(res_with["scores"], res_wo["scores"])]
    m, z = summarize(d_score, "score delta: WITH weak2 minus WITHOUT")

    print(f"  regret@with={res_with['avg_regret']:+.1f}  "
          f"regret@without={res_wo['avg_regret']:+.1f}")
    if z >= 2:
        print("  -> weak-2 openings significantly ADD value over uniform deals")
    elif z <= -2:
        print("  -> weak-2 openings significantly COST value over uniform deals")
    else:
        print("  -> not separable here; escalate --boards")


# ================= DIAGNOSTIC: vulnerability-cell regret =================

def cmd_vulncells(boards: int):
    """Average NS score-minus-par grouped by vulnerability cell.
    Reveals where vuln-blindness costs most."""
    base = load_decision_net_dsl(os.path.join(SYSTEM_DIR, "improved_system.dsl"))
    from bid.sampling import RBMBMCSampler
    from bid.pidm import PIDMEngine
    from bid.arena import BiddingArena
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6,
                                              timeout_sec=0.06), max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)
    deals = build_deals(boards, seed=42)[:boards]
    dd = precompute(deals)
    res = evaluate_system(arena, "v", base, deals, dd, seed=777)

    cells: Dict[str, List[float]] = {}
    for deal, score in zip(deals, res["scores"]):
        par = dd[[d is deal for d in deals].index(True)][0] if False else None
        # find par by index
    for idx, (deal, score) in enumerate(zip(deals, res["scores"])):
        par = dd[idx][0]
        we = deal.vuln in (1, 3)
        they = deal.vuln in (2, 3)
        cell = ("WeV" if we else "WeNV") + "/" + ("TheyV" if they else "TheyNV")
        cells.setdefault(cell, []).append(score - par)

    print("VULNERABILITY-CELL REGRET (score - DDS par), current improved system:")
    print(f"  {'cell':<14}{'boards':>7}{'avg regret':>12}")
    for cell in sorted(cells):
        vals = cells[cell]
        m = sum(vals) / len(vals)
        print(f"  {cell:<14}{len(vals):>7}{m:>12.1f}")


# ================= CLI =================

def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("hcp-dist")
    brk = sub.add_parser("breaks"); brk.add_argument("--fit", type=int, default=9)
    fit = sub.add_parser("fit"); fit.add_argument("--samples", type=int, default=1_000_000)
    sub.add_parser("info-bound")
    th = sub.add_parser("thresholds"); th.add_argument("--boards", type=int, default=64)
    du = sub.add_parser("duel"); du.add_argument("--a", required=True)
    du.add_argument("--b", required=True); du.add_argument("--boards", type=int, default=96)
    wk = sub.add_parser("weak2"); wk.add_argument("--boards", type=int, default=48)
    vc = sub.add_parser("vuln-cells"); vc.add_argument("--boards", type=int, default=48)
    args = ap.parse_args()

    if args.cmd == "hcp-dist":
        cmd_hcp_dist()
    elif args.cmd == "breaks":
        cmd_breaks(args.fit)
    elif args.cmd == "fit":
        mc_fit_prob(args.samples)
    elif args.cmd == "info-bound":
        cmd_info_bound()
    elif args.cmd == "thresholds":
        cmd_thresholds(args.boards)
    elif args.cmd == "duel":
        cmd_duel(args.a, args.b, args.boards)
    elif args.cmd == "weak2":
        cmd_weak2(args.boards)
    elif args.cmd == "vuln-cells":
        cmd_vulncells(args.boards)


if __name__ == "__main__":
    main()
