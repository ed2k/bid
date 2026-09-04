#!/usr/bin/env python3
"""
Play ONE board of self-play or explain a recorded LIN/BBO deal,
identifying the bidding system and conventions, explaining every call with alerts,
and evaluating the outcome with DDS and par regret.

For each call it shows:
  * the player's context (relevant extracted features)
  * bid alert / convention annotation (e.g. from BBO GIB)
  * which DSL rules matched (candidate generation phi(s))
  * agreement or divergence with the decision net system

Evaluation section:
  * final contract + exact double-dummy tricks + duplicate score
  * actual play result (when play history or claim is recorded in LIN)
  * native DDS par + regret
  * structural flaw diagnosis
  * SDS two-hand expectation (declarer partnership view)

Examples:
  PYTHONPATH=src python3 -m bid.explain_board --board 1
  PYTHONPATH=src python3 -m bid.explain_board --lin "https://www.bridgebase.com/tools/handviewer.html?lin=..."
  PYTHONPATH=src python3 -m bid.explain_board "https://www.bridgebase.com/tools/handviewer.html?lin=..."
  PYTHONPATH=src python3 -m bid.explain_board --lin board12.lin
"""

import argparse
import os
import random
import sys
from typing import Optional, Tuple, List, Dict

from bid.models import Seat, Suit, Strain, Call, CallType, Hand
from bid.sampling import Deal, PartialState
from bid.dds import DDSolver
from bid.pidm import PIDMEngine
from bid.sds import SDSScorer
from bid.diagnostics import ParDiagnosticEngine
from bid.scoring import Vulnerability, score as compute_duplicate_score
from bid.lin import LinParser, LinDeal, clean_alert
from bid.system_identifier import BiddingSystemIdentifier, SystemIdentificationResult

from bid.eval_vs_dds import build_deals, load_decision_net_dsl, SYSTEM_DIR, contract_string

EVAL_SEED = 1234


def fmt_hand(hand: Hand) -> str:
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


def context_line(features) -> str:
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


def compute_play_tricks(deal: LinDeal, decl: Seat, strain: Strain) -> Optional[Tuple[int, int]]:
    """Compute (decl_tricks, def_tricks) from play_history and/or claim."""
    if not deal.play_history and deal.claim is None:
        return None

    RANK_MAP = {
        '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9,
        'T': 10, 'J': 11, 'Q': 12, 'K': 13, 'A': 14
    }
    SUIT_MAP = {'S': Suit.SPADES, 'H': Suit.HEARTS, 'D': Suit.DIAMONDS, 'C': Suit.CLUBS}

    def parse_card(c_str: str) -> Optional[Tuple[Suit, int]]:
        if len(c_str) < 2:
            return None
        # Suit may be first or second depending on notation
        c0 = c_str[0].upper()
        c1 = c_str[1].upper()
        if c0 in SUIT_MAP and c1 in RANK_MAP:
            return SUIT_MAP[c0], RANK_MAP[c1]
        elif c1 in SUIT_MAP and c0 in RANK_MAP:
            return SUIT_MAP[c1], RANK_MAP[c0]
        return None

    trump_suit = None
    if strain != Strain.NT:
        trump_suit = Suit(strain.value)

    decl_side = {decl, Seat((decl.value + 2) % 4)}
    leader = Seat((decl.value + 1) % 4)

    decl_tricks = 0
    def_tricks = 0

    cards = deal.play_history
    n_tricks = len(cards) // 4
    for t_idx in range(n_tricks):
        t_cards = [parse_card(cards[t_idx * 4 + k]) for k in range(4)]
        if any(c is None for c in t_cards):
            break
        t_seats = [Seat((leader.value + k) % 4) for k in range(4)]

        lead_s, lead_r = t_cards[0]
        win_idx = 0
        win_s, win_r = lead_s, lead_r

        for k in range(1, 4):
            s, r = t_cards[k]
            if s == win_s:
                if r > win_r:
                    win_idx = k
                    win_s, win_r = s, r
            elif trump_suit and s == trump_suit and win_s != trump_suit:
                win_idx = k
                win_s, win_r = s, r

        winner = t_seats[win_idx]
        if winner in decl_side:
            decl_tricks += 1
        else:
            def_tricks += 1
        leader = winner

    if deal.claim is not None:
        if deal.claim <= 13 and deal.claim >= decl_tricks:
            decl_tricks = deal.claim
            def_tricks = 13 - decl_tricks

    return decl_tricks, def_tricks


def select_reference_dsl(sys_res: SystemIdentificationResult, default_dsl: str) -> Tuple[str, str]:
    """Select the reference DSL closest to the identified system."""
    all_text = f"{sys_res.ns.system_name} {sys_res.ew.system_name} {sys_res.summary}".lower()
    if sys_res.is_bbo_gib or "gib" in all_text:
        target = os.path.join(SYSTEM_DIR, "gib.dsl")
        if os.path.isfile(target):
            return target, "auto-selected (matches identified BBO GIB system)"
        target = os.path.join(SYSTEM_DIR, "improved_system.dsl")
        if os.path.isfile(target):
            return target, "auto-selected (matches identified BBO GIB / Modern 2/1 system)"
    elif "2/1" in all_text or "sayc" in all_text or "american" in all_text:
        target = os.path.join(SYSTEM_DIR, "gib.dsl")
        if os.path.isfile(target):
            return target, "auto-selected (matches identified Modern 2/1 / GIB system)"
        target = os.path.join(SYSTEM_DIR, "improved_system.dsl")
        if os.path.isfile(target):
            return target, "auto-selected (matches identified Modern 2/1 system)"
    elif "precision" in all_text or "strong club" in all_text:
        target = os.path.join(SYSTEM_DIR, "champion_system.dsl")
        if os.path.isfile(target):
            return target, "auto-selected (matches identified Precision / Strong Club system)"
    elif "blue club" in all_text:
        target = os.path.join(SYSTEM_DIR, "champion_system.dsl")
        if os.path.isfile(target):
            return target, "auto-selected (matches identified Blue Club system)"
    elif "acol" in all_text:
        target = os.path.join(SYSTEM_DIR, "improved_system.dsl")
        if os.path.isfile(target):
            return target, "auto-selected (matches identified Acol / Natural system)"
    return default_dsl, "default reference system"


def render_system_report(sys_res: SystemIdentificationResult):
    """Print identified systems, styles, conventions, and evidence."""
    print("\n---- IDENTIFIED BIDDING SYSTEMS & CONVENTIONS ----")
    print(f"Summary     : {sys_res.summary}")
    print()
    print(f"North-South : {sys_res.ns.system_name} ({sys_res.ns.confidence} confidence)")
    print(f"  Style     : {sys_res.ns.primary_style}")
    conv_ns = ", ".join(sys_res.ns.key_conventions) if sys_res.ns.key_conventions else "Natural / Standard"
    print(f"  Conventions: {conv_ns}")
    if sys_res.ns.evidence:
        print(f"  Evidence  : {'; '.join(sys_res.ns.evidence)}")
    print()
    print(f"East-West   : {sys_res.ew.system_name} ({sys_res.ew.confidence} confidence)")
    print(f"  Style     : {sys_res.ew.primary_style}")
    conv_ew = ", ".join(sys_res.ew.key_conventions) if sys_res.ew.key_conventions else "Natural / Standard"
    print(f"  Conventions: {conv_ew}")
    if sys_res.ew.evidence:
        print(f"  Evidence  : {'; '.join(sys_res.ew.evidence)}")


def main():
    ap = argparse.ArgumentParser(description="One explained board (self-play or LIN/BBO URL) + evaluation")
    ap.add_argument("target", nargs="?", default=None,
                    help="Optional board number (e.g. 1) or LIN text / BBO Handviewer URL")
    ap.add_argument("--board", type=int, default=None,
                    help="1-based board index inside the deal set or LIN deals")
    ap.add_argument("--lin", "--url", dest="lin_input", default=None,
                    help="LIN string, BBO Handviewer URL, or path to .lin file")
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--pool", type=int, default=64,
                    help="deal-set size to draw --board from (self-play mode)")
    ap.add_argument("--random", action="store_true",
                    help="pick a random board instead of --board")
    ap.add_argument("--dsl", default=os.path.join(SYSTEM_DIR, "champion_system.dsl"))
    ap.add_argument("--opp-dsl", default=None,
                    help="optional DIFFERENT system for East/West")
    ap.add_argument("--worlds", type=int, default=20)
    ap.add_argument("--condition", action="store_true",
                    help="auction-conditioned SDS world selection")
    ap.add_argument("--condition-factor", type=int, default=4)
    ap.add_argument("--max-calls", type=int, default=24)
    args = ap.parse_args()

    # Determine if target positional argument is board index or LIN / URL
    if args.target:
        if args.lin_input is None:
            if args.target.isdigit():
                if args.board is None:
                    args.board = int(args.target)
            else:
                args.lin_input = args.target

    # Fall back to improved_system.dsl if champion_system.dsl is not found
    dsl_path = args.dsl
    if not os.path.isfile(dsl_path):
        alt = os.path.join(SYSTEM_DIR, "improved_system.dsl")
        if os.path.isfile(alt):
            dsl_path = alt

    net = load_decision_net_dsl(dsl_path)
    opp_net = (load_decision_net_dsl(args.opp_dsl) if args.opp_dsl else net)
    models = {Seat.NORTH: net, Seat.SOUTH: net, Seat.EAST: opp_net, Seat.WEST: opp_net}

    engine = PIDMEngine(sampler=None, max_lookahead_depth=1)
    from bid.sampling import RBMBMCSampler
    engine.sampler = RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06)

    # ---------------- LIN / URL RECORDED DEAL MODE ----------------
    if args.lin_input:
        parser = LinParser()
        lin_deals = parser.parse(args.lin_input)
        if not lin_deals:
            print(f"Error: Could not parse any deals from input '{args.lin_input}'")
            sys.exit(1)

        deal_idx = (args.board - 1) if (args.board and 1 <= args.board <= len(lin_deals)) else 0
        lin_deal = lin_deals[deal_idx]

        # Map vulnerability to integer
        VULN_INT_MAP = {
            'NONE': Vulnerability.NONE,
            'NS': Vulnerability.NS,
            'EW': Vulnerability.EW,
            'BOTH': Vulnerability.BOTH
        }
        vuln_int = VULN_INT_MAP.get(lin_deal.vulnerability, Vulnerability.NONE)
        deal = Deal(lin_deal.hands, lin_deal.dealer, vuln_int)

        # Identify Bidding System & Conventions
        sys_res = BiddingSystemIdentifier.identify(lin_deal)

        # Reference system: automatically choose the system close to the guess system if user didn't specify --dsl
        user_specified_dsl = any(arg.startswith("--dsl") for arg in sys.argv)
        sys_note = ""
        if not user_specified_dsl:
            auto_dsl, reason = select_reference_dsl(sys_res, dsl_path)
            if auto_dsl != dsl_path:
                dsl_path = auto_dsl
                net = load_decision_net_dsl(dsl_path)
                opp_net = (load_decision_net_dsl(args.opp_dsl) if args.opp_dsl else net)
                models = {Seat.NORTH: net, Seat.SOUTH: net, Seat.EAST: opp_net, Seat.WEST: opp_net}
            sys_note = f" [{reason}]"

        board_label = lin_deal.board_id or f"LIN Board {deal_idx + 1}"
        print("=" * 78)
        print(f"{board_label.upper()} | Dealer: {deal.dealer.name} | Vul: {lin_deal.vulnerability}")
        p_names = []
        for s in (Seat.NORTH, Seat.EAST, Seat.SOUTH, Seat.WEST):
            name = lin_deal.players.get(s, "")
            if name:
                p_names.append(f"{s.name}: {name}")
        if p_names:
            print("Players: " + " | ".join(p_names))
        print("Reference System : " + os.path.basename(dsl_path) + sys_note)
        print("=" * 78)

        render_system_report(sys_res)

        print("\n---- HANDS ----")
        for seat in Seat:
            h = deal.hands[seat]
            mark = "  <- opens" if seat == deal.dealer else ""
            p_str = f"({lin_deal.players.get(seat, '')})" if lin_deal.players.get(seat) else ""
            h_info = f"HCP: {h.hcp:>2} | {h.length(Suit.SPADES)}-{h.length(Suit.HEARTS)}-{h.length(Suit.DIAMONDS)}-{h.length(Suit.CLUBS)} | Ctrls: {h.controls}"
            print(f"  {seat.name:<6} {fmt_hand(h):<28} [{h_info}] {p_str}{mark}")

        # Auction explanation
        print("\n---- RECORDED AUCTION (explained with alerts & system comparison) ----")
        history: List[Call] = []
        curr = deal.dealer
        alert_footnotes: Dict[int, str] = {}
        unmatched_alert_recommendations: List[str] = []

        BridgeFeatures = __import__("bid.features", fromlist=["BridgeFeatures"]).BridgeFeatures

        for n_call, call in enumerate(lin_deal.bidding_history):
            raw_alert = lin_deal.bidding_alerts[n_call] if n_call < len(lin_deal.bidding_alerts) else ""
            c_alert = clean_alert(raw_alert)
            if c_alert:
                alert_footnotes[n_call + 1] = c_alert

            feats = BridgeFeatures.extract_all(
                deal.hands[curr], history, curr, deal.dealer, deal.vuln
            )

            matched = []
            for r in net.rules:
                try:
                    if r.matches(feats):
                        matched.append(r)
                except Exception:
                    pass

            matched_rule_names = sorted({r.rule_id for r in matched})
            if net.wrapped_system is not None:
                sys_rule = net.wrapped_system.get_bid(history, deal.hands[curr])
                if sys_rule:
                    matched_rule_names.append(f"sys_{sys_rule.description or str(sys_rule.call)}")

            candidates = net.actions(deal.hands[curr], history, curr, deal.dealer, deal.vuln)
            cand_s = sorted(str(c) for c in candidates)
            agrees = str(call) in cand_s

            alert_tag = f" [ALERT: {c_alert}]" if c_alert else ""
            call_str = str(call)
            print(f"#{n_call + 1:<2} {curr.name:<6} bids {call_str:<5}{alert_tag}")
            print(f"     context : {context_line(feats)}")
            mm = ", ".join(matched_rule_names) or "(no rule)"
            print(f"     matched : {mm}")
            status = "AGREES" if agrees else "DIFFERS"
            if not agrees and c_alert:
                status += f" -> alert suggests: '{c_alert}'"
                unmatched_alert_recommendations.append(
                    f"Call #{n_call + 1} ({curr.name} {call_str}): Alert '{c_alert}' -> consider rule for {call_str} when {context_line(feats)}"
                )
            print(f"     system  : candidate actions -> {cand_s} ({status})")

            history.append(call)
            curr = Seat((curr.value + 1) % 4)

        # Compact auction grid
        print()
        print_auction_header()
        grid_cells: List[str] = [""] * list(Seat).index(deal.dealer)
        for i, c in enumerate(history):
            star = "*" if (i + 1) in alert_footnotes else ""
            grid_cells.append(f"{str(c)}{star}")

        rows = [grid_cells[i:i + 4] for i in range(0, len(grid_cells), 4)]
        for row in rows:
            print("   " + "".join(f"{c:<8}" for c in row))

        if alert_footnotes:
            print("\n  Alerts:")
            for c_idx, note in sorted(alert_footnotes.items()):
                print(f"    *{c_idx}: {note}")

        if unmatched_alert_recommendations:
            print("\n---- SYSTEM DESIGN IMPROVEMENT RECOMMENDATIONS ----")
            for rec in unmatched_alert_recommendations:
                print(f"  * {rec}")

        # Evaluation
        pstate = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], history, deal.dealer, deal.vuln)
        contract = contract_string(pstate)
        score = engine.evaluate_terminal_deal(deal, history, Seat.SOUTH, deal.dealer, deal.vuln)
        par_score, par_contract = DDSolver.calculate_par(deal, deal.vuln)

        print("\n---- EVALUATION ----")
        print(f"  contract : {contract}")
        c = pstate.get_contract()
        if c:
            lvl, strain, decl, dbl = c
            t = DDSolver.get_tricks(deal, strain, decl)
            need = lvl + 6
            print(f"  dd tricks: {t}/{need} ({'MADE' if t >= need else 'down ' + str(need - t)})")

            # Actual play outcome if recorded
            play_res = compute_play_tricks(lin_deal, decl, strain)
            if play_res:
                actual_decl_t, actual_def_t = play_res
                actual_made = actual_decl_t >= need
                actual_status = f"MADE" if actual_made else f"down {need - actual_decl_t}"
                is_vul = Vulnerability.is_vulnerable(deal.vuln, decl)
                
                # Format contract str for score engine e.g. '6D', '4S'
                strain_char = strain.name[0] if strain != Strain.NT else 'N'
                dbl_str = "XX" if dbl == 2 else ("X" if dbl == 1 else "")
                c_code = f"{lvl}{strain_char}{dbl_str}"
                actual_decl_score = compute_duplicate_score(c_code, is_vul, actual_decl_t)
                actual_ns_score = actual_decl_score if decl in (Seat.NORTH, Seat.SOUTH) else -actual_decl_score
                print(f"  play tricks: {actual_decl_t}/{need} ({actual_status}) -> actual duplicate score {actual_ns_score:+.0f} (NS)")

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

        diag = ParDiagnosticEngine.diagnose_board(deal_idx + 1, deal, history, score)
        print(f"  verdict  : {diag.flaw_type.value}")
        if diag.flaw_type.value != "OPTIMAL_PAR":
            print(f"  note     : {diag.remediation_advice}")

        return

    # ---------------- SELF-PLAY SIMULATION MODE ----------------
    deals = build_deals(args.pool, seed=args.seed, include_stratified=False)
    idx = args.board
    if args.random or idx is None:
        idx = random.Random().randint(1, len(deals))
    assert 1 <= idx <= len(deals), f"--board must be 1..{len(deals)}"
    random.seed(args.seed * 1000 + idx)   # reproducible MC world sampling
    deal = deals[idx - 1]

    print("=" * 78)
    print(f"BOARD {idx} (seed {args.seed}) | Dealer {deal.dealer.name} | Vul {deal.vuln}")
    print(f"system : {os.path.basename(dsl_path)}"
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
