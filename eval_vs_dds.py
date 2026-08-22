#!/usr/bin/env python3
"""
Evaluate every bidding system in the repo against native DDS par results.
Loads champion_system.dsl / improved_system.dsl back into DecisionNets,
plays full auctions for each system on a fixed deal set, scores final
contracts with exact DDS tricks, ranks systems by regret vs par.
"""

import argparse
import os
import random
import re
import time
from collections import Counter
from typing import Any, Dict, List, Tuple

from bid.models import Seat, Strain, Call, CallType
from bid.sampling import Deal, PartialState
from bid.experience import StratifiedDealGenerator
from bid.dds import DDSolver
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler
from bid.invention import BidInventionEngine
from bid.optimizer import SystemOptimizer
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.diagnostics import ParDiagnosticEngine
from bid.scoring import score_to_imp

STRAIN_STR = ['C', 'D', 'H', 'S', 'NT']
SYSTEM_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "system")


def parse_call(s: str) -> Call:
    s = s.strip()
    if s in ("X", "DBL"):
        return Call(CallType.DOUBLE)
    if s == "XX":
        return Call(CallType.REDOUBLE)
    if s.upper() in ("P", "PASS"):
        return Call(CallType.PASS)
    level = int(s[0])
    strain_s = s[1:].upper()
    strain = {"C": Strain.CLUBS, "D": Strain.DIAMONDS, "H": Strain.HEARTS,
              "S": Strain.SPADES, "NT": Strain.NT}[strain_s]
    return Call(CallType.BID, level, strain)


def _split_conditions(text: str) -> List[str]:
    parts, depth, quote, cur = [], 0, None, ""
    for ch in text:
        if quote:
            cur += ch
            if ch == quote:
                quote = None
            continue
        if ch in "'\"":
            quote = ch
            cur += ch
        elif ch == "[":
            depth += 1
            cur += ch
        elif ch == "]":
            depth -= 1
            cur += ch
        elif ch == "," and depth == 0:
            parts.append(cur.strip())
            cur = ""
        else:
            cur += ch
    if cur.strip():
        parts.append(cur.strip())
    return [p for p in parts if p]


def _parse_value(tok: str) -> Any:
    tok = tok.strip()
    if tok.startswith("["):
        inner = tok[1:-1].strip()
        if not inner:
            return []
        return [_parse_value(t) for t in _split_conditions(inner)]
    if (tok.startswith("'") and tok.endswith("'")) or (tok.startswith('"') and tok.endswith('"')):
        return tok[1:-1]
    if tok == "True":
        return True
    if tok == "False":
        return False
    try:
        return int(tok)
    except ValueError:
        pass
    try:
        return float(tok)
    except ValueError:
        pass
    return tok


def parse_condition(text: str) -> RuleCondition:
    m = re.match(r"^(\w+)\s*(==|!=|>=|<=|>|<|not_in|in)\s*(.+)$", text.strip())
    if not m:
        raise ValueError(f"Bad condition: {text!r}")
    key, op, val = m.group(1), m.group(2), m.group(3)
    return RuleCondition(key, op, _parse_value(val))


class ResolvedCallClassifier:
    def __init__(self, call: Call):
        self.call = call

    def predict(self, features: Dict[str, Any]) -> Call:
        return self.call


def load_decision_net_dsl(path: str) -> DecisionNet:
    """Loads both exported formats:
    one-line:  RULE <id> PRIORITY <n> ACTION <call> WHEN c1, c2, ...
    block:     RULE <id>: / CALL: / PRIORITY: / CONDITION: (+ INTERSECTION trees)
    """
    name = os.path.splitext(os.path.basename(path))[0]
    net = DecisionNet(name)
    with open(path) as f:
        lines = f.readlines()

    i = 0
    while i < len(lines):
        line = lines[i].rstrip("\n")
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            i += 1
            continue

        one_line = re.match(r"^RULE\s+(\S+)\s+PRIORITY\s+(-?\d+)\s+ACTION\s+(\S+)\s+WHEN\s+(.+)$", stripped)
        if one_line:
            rid, prio, action, conds = one_line.groups()
            conditions = [parse_condition(c) for c in _split_conditions(conds)]
            net.add_rule(DecisionNetRule(rid, parse_call(action), conditions, priority=int(prio)))
            i += 1
            continue

        block_rule = re.match(r"^RULE\s+(.+?):$", stripped)
        if block_rule:
            rid = block_rule.group(1).strip()
            call, prio, conditions = None, 10, []
            i += 1
            while i < len(lines):
                sub = lines[i].rstrip("\n").strip()
                if sub.startswith("RULE ") or sub.startswith("INTERSECTION"):
                    break
                if sub.startswith("CALL:"):
                    call = parse_call(sub.split("CALL:", 1)[1])
                elif sub.startswith("PRIORITY:"):
                    prio = int(sub.split("PRIORITY:", 1)[1].strip())
                elif sub.startswith("CONDITION:"):
                    conditions.append(parse_condition(sub.split("CONDITION:", 1)[1]))
                i += 1
            if call is not None:
                net.add_rule(DecisionNetRule(rid, call, conditions, priority=prio))
            continue

        inter = re.match(r"^INTERSECTION\s+(.+?):$", stripped)
        if inter:
            rule_ids = [t.strip() for t in inter.group(1).split("^")]
            resolved = None
            i += 1
            while i < len(lines):
                sub = lines[i].rstrip("\n").strip()
                if sub.startswith("RULE ") or sub.startswith("INTERSECTION"):
                    break
                if sub.startswith("RESOLVED_CALL:"):
                    resolved = parse_call(sub.split("RESOLVED_CALL:", 1)[1])
                i += 1
            if resolved is not None and len(rule_ids) > 1:
                net.attach_refinement(tuple(rule_ids), ResolvedCallClassifier(resolved))
            continue

        i += 1
    return net


def build_deals(num_random: int, seed: int = 42, include_stratified: bool = True) -> List[Deal]:
    import random
    random.seed(seed)
    from bid.models import Suit
    deals = [Deal.random_deal(dealer=Seat.NORTH) for _ in range(num_random)]
    if not include_stratified:
        return deals
    deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.SOUTH, suit_stratum=(Suit.SPADES, 8)))
    deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.NORTH, suit_stratum=(Suit.HEARTS, 8)))
    deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.SOUTH, suit_stratum=(Suit.DIAMONDS, 7)))
    deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.SOUTH, hcp_stratum=(22, 25)))
    deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.NORTH, hcp_stratum=(16, 18)))
    deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.SOUTH, hcp_stratum=(0, 4)))
    return deals


def contract_string(pstate: PartialState) -> str:
    c = pstate.get_contract()
    if not c:
        return "Pass"
    lvl, strain, decl, dbl = c
    x = "X" if dbl == 1 else ("XX" if dbl == 2 else "")
    return f"{lvl}{STRAIN_STR[strain.value]} by {decl.name}"


def evaluate_system(arena: BiddingArena, name: str, net: DecisionNet, deals: List[Deal],
                    dd_data: List[Tuple[int, str, dict]], run_diagnostics: bool = False,
                    seed: int = None, sds_scorer=None):
    if seed is not None:
        random.seed(seed)
    total_score = 0.0
    total_par = 0.0
    total_imp_loss = 0.0
    total_sds = 0.0
    sds_boards = 0
    par_hits = 0
    makable_games = 0
    games_reached = 0
    flaws = Counter()
    worst = []
    diagnostics = []

    for i, deal in enumerate(deals):
        par_score, par_contract, dd_table = dd_data[i]

        history, score = arena.play_board(deal, net, net)
        total_score += score
        total_par += par_score
        regret = score - par_score
        if score >= par_score - 10:
            par_hits += 1
        else:
            total_imp_loss += abs(score_to_imp(int(regret)))

        ns_can_make_game = (
            dd_table.get((Strain.SPADES, Seat.NORTH), 0) >= 10 or
            dd_table.get((Strain.SPADES, Seat.SOUTH), 0) >= 10 or
            dd_table.get((Strain.HEARTS, Seat.NORTH), 0) >= 10 or
            dd_table.get((Strain.HEARTS, Seat.SOUTH), 0) >= 10 or
            dd_table.get((Strain.NT, Seat.NORTH), 0) >= 9 or
            dd_table.get((Strain.NT, Seat.SOUTH), 0) >= 9
        )
        pstate = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], history, deal.dealer, deal.vuln)
        c = pstate.get_contract()
        if sds_scorer is not None and c:
            lvl, strain, decl, dbl = c
            sds_res = sds_scorer.score_contract(deal, lvl, strain, decl, dbl, deal.vuln)
            sign = 1.0 if decl in (Seat.NORTH, Seat.SOUTH) else -1.0
            total_sds += sign * sds_res.mean_score
            sds_boards += 1
        if ns_can_make_game:
            makable_games += 1
            if c:
                lvl, strain, decl, dbl = c
                if decl in (Seat.NORTH, Seat.SOUTH):
                    if (strain in (Strain.SPADES, Strain.HEARTS) and lvl >= 4) or (strain == Strain.NT and lvl >= 3) or lvl >= 5:
                        games_reached += 1

        if run_diagnostics and regret < -10:
            diag = ParDiagnosticEngine.diagnose_board(i + 1, deal, history, score)
            flaws[diag.flaw_type.value] += 1
            worst.append((regret, i + 1, contract_string(pstate), par_contract, par_score, diag.flaw_type.value))
            diagnostics.append(diag)

    n = len(deals)
    return {
        "name": name,
        "avg_score": total_score / n,
        "avg_par": total_par / n,
        "avg_regret": (total_score - total_par) / n,
        "avg_imp_loss": total_imp_loss / n,
        "par_accuracy": par_hits / n * 100.0,
        "game_conversion": (games_reached / makable_games * 100.0) if makable_games else 100.0,
        "makable_games": makable_games,
        "flaws": flaws,
        "worst": sorted(worst)[:3],
        "diagnostics": diagnostics,
        "avg_score_sds": (total_sds / sds_boards) if sds_boards else 0.0,
        "sds_boards": sds_boards,
    }


def main():
    parser = argparse.ArgumentParser(description="Rank all repo bidding systems vs native DDS par")
    parser.add_argument("--boards", type=int, default=30, help="Number of random boards (default 30)")
    parser.add_argument("--no-stratified", action="store_true", help="Skip the 6 stratified deals")
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--dsl", action="append", default=[], help="Extra DSL files to load")
    parser.add_argument("--sds", action="store_true", help="Also score contracts with SDS two-hand view")
    args = parser.parse_args()

    t0 = time.time()
    deals = build_deals(args.boards, seed=args.seed, include_stratified=not args.no_stratified)
    strat = "" if args.no_stratified else " + 6 stratified"
    print(f"Deals: {len(deals)} ({args.boards} random{strat}, seed {args.seed})")

    opt = SystemOptimizer()
    systems: List[Tuple[str, DecisionNet]] = [
        ("Pipeline Baseline", BidInventionEngine().models[Seat.SOUTH]),
        ("champion_system.dsl", load_decision_net_dsl(os.path.join(SYSTEM_DIR, "champion_system.dsl"))),
        ("improved_system.dsl", load_decision_net_dsl(os.path.join(SYSTEM_DIR, "improved_system.dsl"))),
        ("SUP (archetype)", opt.create_singularity_ultra_precision()),
        ("AOP (archetype)", opt.create_apex_omega_precision()),
        ("ARP (archetype)", opt.create_alpha_relay_precision()),
        ("QRP (archetype)", opt.create_quantum_relay_precision()),
        ("Autonomous Evolved", opt.create_autonomous_evolved_system()),
        ("Modern 2/1 GF", opt.create_modern_2over1()),
        ("Precision StrongClub", opt.create_precision_system()),
        ("SAYC Baseline", opt.create_sayc_baseline()),
    ]
    for extra in args.dsl:
        systems.append((os.path.basename(extra), load_decision_net_dsl(extra)))

    print(f"Precomputing DDS par + double-dummy tables for {len(deals)} deals...")
    dd_data = []
    for deal in deals:
        par_score, par_contract = DDSolver.calculate_par(deal, deal.vuln)
        dd_table = DDSolver.solve_dd_table(deal)
        dd_data.append((par_score, par_contract, dd_table))

    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06), max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)

    sds_scorer = None
    if args.sds:
        from bid.sds import SDSScorer
        sds_scorer = SDSScorer(num_worlds=20, seed=2024)
        print("SDS two-hand scoring enabled (20 worlds per played contract)")

    results = []
    for name, net in systems:
        t = time.time()
        res = evaluate_system(arena, name, net, deals, dd_data, run_diagnostics=True,
                              sds_scorer=sds_scorer)
        res["elapsed"] = time.time() - t
        results.append(res)
        print(f"  evaluated {name:<28} avg_regret {res['avg_regret']:+7.1f}  ({res['elapsed']:.1f}s)")

    results.sort(key=lambda r: (r["avg_regret"], r["avg_imp_loss"]), reverse=True)

    print()
    print("=" * 118)
    print(" SYSTEM RANKING vs NATIVE DDS PAR (best first)")
    print("=" * 118)
    print(f" {'#':<3} | {'System':<24} | {'Avg NS Score':<12} | {'Avg DDS Par':<11} | {'Regret':<9} | {'IMP Loss/Bd':<11} | {'Par Acc':<8} | {'Game Conv':<9}" + (" | {'SDS Score':<10}" if args.sds else ""))
    print("-" * 118)
    for idx, r in enumerate(results, 1):
        crown = "👑" if idx == 1 else "  "
        line = (f" {crown}{idx:<2} | {r['name']:<24} | {r['avg_score']:<+12.1f} | {r['avg_par']:<+11.1f} | "
                f"{r['avg_regret']:<+9.1f} | {r['avg_imp_loss']:<11.2f} | {r['par_accuracy']:<7.1f}% | {r['game_conversion']:<8.1f}%")
        if args.sds:
            line += f" | {r['avg_score_sds']:+9.1f}"
        print(line)
    print("-" * 118)
    print(f" Makable NS games in deal set: {results[0]['makable_games']} | Total eval time: {time.time() - t0:.1f}s")

    best = results[0]
    print(f"\n 🏆 BEST SYSTEM: {best['name']}")
    print(f"    Flaw breakdown: " + (", ".join(f"{k} x{v}" for k, v in best['flaws'].most_common()) or "none"))
    if best["worst"]:
        print("    Worst boards:")
        for regret, board, actual, par_c, par_s, flaw in best["worst"]:
            print(f"      Board {board:<3} {actual:<14} vs Par {par_c:<16} ({par_s:+d})  regret {regret:+.0f} pts  [{flaw}]")


if __name__ == "__main__":
    main()
