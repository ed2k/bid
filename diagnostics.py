#!/usr/bin/env python3
"""
Par Diagnostic & Bidding Flaw Detection Engine for Bid.
Analyzes differences between actual auction results and Double Dummy Solver (DDS) Par
to classify specific bidding defects (e.g., Soft Defense, Missed Game, Missed Slam,
Overbidding, or Missed Penalty Doubles) and synthesize targeted corrective rules.
"""

from enum import Enum
from typing import Dict, List, Tuple, Any, Optional
from bid.models import Seat, Hand, Call, CallType, Strain, Suit
from bid.sampling import Deal, PartialState
from bid.dds import DDSolver
from bid.scoring import score, Vulnerability
from bid.decision_net import DecisionNetRule, RuleCondition

class BiddingFlawType(Enum):
    OPTIMAL_PAR = "OPTIMAL_PAR"                   # Hit or exceeded Par (No flaw)
    MISSED_GAME = "MISSED_GAME"                   # NS had makable 4M/3NT/5m but stopped in partscore
    MISSED_SLAM = "MISSED_SLAM"                   # NS had makable 6/7 level slam but stopped short
    SOFT_DEFENSE = "SOFT_DEFENSE"                 # Opponents bought contract; NS failed to compete/sacrifice
    OVERBID_DOWN = "OVERBID_DOWN"                 # Contract failed when lower partscore made
    MISSED_PENALTY_DOUBLE = "MISSED_PENALTY_DBL"  # Opponents contract went down 2+ undoubled
    TAKEOUT_PASS = "TAKEOUT_PASS"                 # Passed partner's takeout double holding 10+ HCP
    LUCKY_MASKED_MISS = "LUCKY_MASKED_MISS"       # Score >= par (often via punishing opponents) but NS underbid

class BiddingDiagnostic:
    def __init__(self,
                 board_id: int,
                 deal: Deal,
                 actual_history: List[Call],
                 actual_score: float,
                 par_score: int,
                 par_contract: str,
                 flaw_type: BiddingFlawType,
                 severity_pts: float,
                 remediation_advice: str):
        self.board_id = board_id
        self.deal = deal
        self.actual_history = actual_history
        self.actual_score = actual_score
        self.par_score = par_score
        self.par_contract = par_contract
        self.flaw_type = flaw_type
        self.severity_pts = severity_pts
        self.remediation_advice = remediation_advice

    def summary(self) -> str:
        s = f"Board #{self.board_id:<2} | Score: {self.actual_score:+.0f} vs Par: {self.par_contract} ({self.par_score:+d}) | Regret: {self.actual_score - self.par_score:+.0f} pts\n"
        s += f"  ⚠️ Flaw Identified : {self.flaw_type.value} (Loss: {self.severity_pts:.0f} pts)\n"
        s += f"  🔧 Remediation Plan : {self.remediation_advice}\n"
        return s

class ParDiagnosticEngine:
    """
    Analyzes auction outcomes vs DDS double dummy matrices and diagnoses exact bidding deficiencies.
    """

    @classmethod
    def diagnose_board(cls,
                       board_id: int,
                       deal: Deal,
                       history: List[Call],
                       actual_score: float) -> BiddingDiagnostic:
        # 1. Query Native DDS Solver for Par & Full Matrix
        par_score, par_contract = DDSolver.calculate_par(deal, deal.vuln)
        dd_table = DDSolver.solve_dd_table(deal)
        regret = actual_score - par_score

        temp_state = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], history, deal.dealer, deal.vuln)
        contract = temp_state.get_contract()

        # NS makable tricks in all strains (independent of what was bid)
        max_ns_s = max(dd_table.get((Strain.SPADES, Seat.NORTH), 0), dd_table.get((Strain.SPADES, Seat.SOUTH), 0))
        max_ns_h = max(dd_table.get((Strain.HEARTS, Seat.NORTH), 0), dd_table.get((Strain.HEARTS, Seat.SOUTH), 0))
        max_ns_nt = max(dd_table.get((Strain.NT, Seat.NORTH), 0), dd_table.get((Strain.NT, Seat.SOUTH), 0))
        max_ns_minor = max(
            dd_table.get((Strain.CLUBS, Seat.NORTH), 0), dd_table.get((Strain.CLUBS, Seat.SOUTH), 0),
            dd_table.get((Strain.DIAMONDS, Seat.NORTH), 0), dd_table.get((Strain.DIAMONDS, Seat.SOUTH), 0)
        )

        decl_is_ns = (contract is not None) and (contract[2] in (Seat.NORTH, Seat.SOUTH))
        decl_is_ew = (contract is not None) and (contract[2] in (Seat.EAST, Seat.WEST))

        def _mk(flaw: BiddingFlawType, severity: float, advice: str) -> BiddingDiagnostic:
            return BiddingDiagnostic(
                board_id=board_id,
                deal=deal,
                actual_history=history,
                actual_score=actual_score,
                par_score=par_score,
                par_contract=par_contract,
                flaw_type=flaw,
                severity_pts=max(0.0, severity),
                remediation_advice=advice,
            )

        # ---- Structural checks FIRST: auction-quality flaws that score can mask ----

        # A. Passing partner's takeout double with real values
        from bid.features import BridgeFeatures
        for t, call_t in enumerate(history):
            if call_t.type != CallType.PASS or t == 0:
                continue
            hist_before = history[:t]
            player = Seat((deal.dealer.value + t) % 4)
            feats = BridgeFeatures.extract_all(deal.hands[player], hist_before, player, deal.dealer, deal.vuln)
            if feats.get("partner_last_call") == "X" and feats.get("hcp", 0) >= 10:
                potential = cls._ns_missed_potential(dd_table, contract, actual_score)
                return _mk(BiddingFlawType.TAKEOUT_PASS,
                           max(abs(min(regret, 0)), potential, 300),
                           f"{player.name} passed partner's takeout double holding {feats['hcp']} HCP. "
                           "Add advancer/response-to-X rules: lift with 5+ suit or bid 2NT with stoppers.")

        # B. Missed slam regardless of score (e.g. lucky penalty masked it)
        ns_can_slam = max(max_ns_s, max_ns_h, max_ns_nt, max_ns_minor) >= 12
        if ns_can_slam and (contract is not None and contract[0] < 6):
            target_slam = "6S" if max_ns_s >= 12 else ("6H" if max_ns_h >= 12 else ("6NT" if max_ns_nt >= 12 else "6m"))
            potential = cls._ns_missed_potential(dd_table, contract, actual_score)
            return _mk(BiddingFlawType.MISSED_SLAM,
                       max(abs(min(regret, 0)), potential),
                       f"Missed {target_slam} despite score masking. Add Blackwood 4NT / cuebids on 20+ combined HCP and controls.")

        # C. Missed game regardless of score
        ns_can_game = max_ns_s >= 10 or max_ns_h >= 10 or max_ns_nt >= 9 or max_ns_minor >= 11
        if ns_can_game and contract is not None and decl_is_ns and contract[0] <= 2:
            target_game = "4S" if max_ns_s >= 10 else ("4H" if max_ns_h >= 10 else ("3NT" if max_ns_nt >= 9 else "5m"))
            potential = cls._ns_missed_potential(dd_table, contract, actual_score)
            return _mk(BiddingFlawType.MISSED_GAME,
                       max(abs(min(regret, 0)), potential),
                       f"Underbid Game ({target_game} makable) despite score masking. Synthesize game-forcing continuations & acceptance rules.")

        # D. Own side doubled and set 2+ (unsound competition even when lucky elsewhere)
        if contract is not None and decl_is_ns and contract[3] >= 1:
            lvl, strain, decl, dbl = contract
            tricks_taken = DDSolver.get_tricks(deal, strain, decl)
            if tricks_taken <= lvl + 4:
                return _mk(BiddingFlawType.OVERBID_DOWN,
                           abs(min(regret, -50)) + 100,
                           "Own doubled contract set 2+. Tighten competitive minimums; do not double for penalties without defensive tricks.")

        # E. Score-based optimal check (now only after structural review)
        if actual_score >= par_score - 10 and regret >= -10:
            return BiddingDiagnostic(
                board_id=board_id,
                deal=deal,
                actual_history=history,
                actual_score=actual_score,
                par_score=par_score,
                par_contract=par_contract,
                flaw_type=BiddingFlawType.OPTIMAL_PAR,
                severity_pts=0.0,
                remediation_advice="Optimal auction reached. No correction required."
            )

        loss = abs(regret)

        # Check 1: Missed Grand / Small Slam (score-driven path)
        if ns_can_slam and (contract is not None and contract[0] < 6):
            target_slam = "6S" if max_ns_s >= 12 else ("6H" if max_ns_h >= 12 else "6NT")
            if max_ns_s >= 13 or max_ns_h >= 13 or max_ns_nt >= 13:
                target_slam = "7NT / 7M Grand Slam"
            return BiddingDiagnostic(
                board_id=board_id,
                deal=deal,
                actual_history=history,
                actual_score=actual_score,
                par_score=par_score,
                par_contract=par_contract,
                flaw_type=BiddingFlawType.MISSED_SLAM,
                severity_pts=loss,
                remediation_advice=f"Missed {target_slam}. Add Blackwood 4NT / Splinter cuebids to explore slam on 20+ combined HCP and controls."
            )

        # Check 2: Missed Game
        if (max_ns_s >= 10 or max_ns_h >= 10 or max_ns_nt >= 9 or max_ns_minor >= 11) and (contract is not None and contract[0] <= 2 and decl_is_ns):
            target_game = "4S" if max_ns_s >= 10 else ("4H" if max_ns_h >= 10 else "3NT")
            return BiddingDiagnostic(
                board_id=board_id,
                deal=deal,
                actual_history=history,
                actual_score=actual_score,
                par_score=par_score,
                par_contract=par_contract,
                flaw_type=BiddingFlawType.MISSED_GAME,
                severity_pts=loss,
                remediation_advice=f"Underbid Game. System stopped in partscore while {target_game} was makable. Synthesize Game Forcing 2/1 continuations & Opener Maximum Acceptance."
            )

        # Check 3: Soft Defense / Failure to Compete
        if decl_is_ew or (contract is None):
            return BiddingDiagnostic(
                board_id=board_id,
                deal=deal,
                actual_history=history,
                actual_score=actual_score,
                par_score=par_score,
                par_contract=par_contract,
                flaw_type=BiddingFlawType.SOFT_DEFENSE,
                severity_pts=loss,
                remediation_advice="Defense too soft. Opponents stole contract or passed out. Add Balancing 1NT/Overcalls, Takeout Doubles, and Competitive Overcalls."
            )

        # Check 4: Overbidding Down
        if contract is not None and decl_is_ns:
            lvl, strain, decl, dbl = contract
            tricks_taken = DDSolver.get_tricks(deal, strain, decl)
            if tricks_taken < lvl + 6:
                return BiddingDiagnostic(
                    board_id=board_id,
                    deal=deal,
                    actual_history=history,
                    actual_score=actual_score,
                    par_score=par_score,
                    par_contract=par_contract,
                    flaw_type=BiddingFlawType.OVERBID_DOWN,
                    severity_pts=loss,
                    remediation_advice=f"Overbid contract down {lvl + 6 - tricks_taken} tricks. Tighten minimum opening requirements and enforce safe partscore signoffs."
                )

        # Fallback
        return BiddingDiagnostic(
            board_id=board_id,
            deal=deal,
            actual_history=history,
            actual_score=actual_score,
            par_score=par_score,
            par_contract=par_contract,
            flaw_type=BiddingFlawType.SOFT_DEFENSE,
            severity_pts=loss,
            remediation_advice="Suboptimal auction trajectory. Refine competitive bidding rules."
        )

    @classmethod
    def _ns_missed_potential(cls, dd_table, contract, actual_score: float) -> float:
        """Estimates points NS left on the table vs their best makable game/slam."""
        letters = {Strain.CLUBS: 'C', Strain.DIAMONDS: 'D', Strain.HEARTS: 'H',
                   Strain.SPADES: 'S', Strain.NT: 'N'}
        best = 0.0
        for strain, game_lvl in ((Strain.SPADES, 4), (Strain.HEARTS, 4),
                                 (Strain.NT, 3), (Strain.DIAMONDS, 5), (Strain.CLUBS, 5)):
            tricks = max(dd_table.get((strain, Seat.NORTH), 0), dd_table.get((strain, Seat.SOUTH), 0))
            if tricks < game_lvl + 6:
                continue
            lvl = min(7, max(game_lvl, tricks - 6))
            made = score(f"{lvl}{letters[strain]}", False, tricks)
            if contract is not None and contract[0] >= lvl and contract[1] == strain:
                continue
            best = max(best, made - actual_score)
        return best

    @classmethod
    def generate_corrective_rules_for_diagnostics(cls, diagnostics: List[BiddingDiagnostic]) -> List[DecisionNetRule]:
        """
        Synthesizes targeted DecisionNet rules based on the diagnosed bidding flaws.
        """
        rules: List[DecisionNetRule] = []

        flaw_counts = {}
        for d in diagnostics:
            flaw_counts[d.flaw_type] = flaw_counts.get(d.flaw_type, 0) + 1

        # 0. If TAKEOUT_PASS detected -> Synthesize advancer/response-to-X rules
        if flaw_counts.get(BiddingFlawType.TAKEOUT_PASS, 0) > 0:
            for suit_name, strain in (("Hearts", Strain.HEARTS), ("Spades", Strain.SPADES)):
                key = f"{strain.name.lower()}_len"
                rules.append(DecisionNetRule(
                    f"X_LIFT_2{strain.name[0]}",
                    Call(CallType.BID, 2, strain),
                    [RuleCondition("partner_last_call", "==", "X"), RuleCondition("hcp", ">=", 6),
                     RuleCondition(key, ">=", 4)],
                    description="Advancer: lift partner's takeout X with 4+ card major",
                    priority=26
                ))
            rules.append(DecisionNetRule(
                "X_LIFT_3D",
                Call(CallType.BID, 3, Strain.DIAMONDS),
                [RuleCondition("partner_last_call", "==", "X"), RuleCondition("hcp", ">=", 11),
                 RuleCondition("diamond_len", ">=", 5)],
                description="Advancer: jump to 3D with 5+ diamonds and values over partner's X",
                priority=27
            ))
            rules.append(DecisionNetRule(
                "X_RESP_2NT",
                Call(CallType.BID, 2, Strain.NT),
                [RuleCondition("partner_last_call", "==", "X"), RuleCondition("hcp", ">=", 10),
                 RuleCondition("is_balanced", "==", True)],
                description="Advancer: 2NT with stoppers and 10+ HCP over partner's X",
                priority=25
            ))

        # 1. If SOFT_DEFENSE detected -> Synthesize aggressive competitive & balancing rules
        if flaw_counts.get(BiddingFlawType.SOFT_DEFENSE, 0) > 0:
            # Balancing 1NT in passout seat (11-14 HCP)
            rules.append(DecisionNetRule(
                "COMP_BALANCING_1NT",
                Call(CallType.BID, 1, Strain.NT),
                [RuleCondition("is_balancing", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("is_balanced", "==", True)],
                description="Competitive: Balance 1NT to prevent opponents from buying contract cheaply",
                priority=24
            ))
            # Competitive Takeout Double over opponent suit
            rules.append(DecisionNetRule(
                "COMP_TAKEOUT_DBL",
                Call(CallType.DOUBLE),
                [RuleCondition("is_competitive", "==", True), RuleCondition("hcp", ">=", 12), RuleCondition("heart_len", ">=", 3), RuleCondition("spade_len", ">=", 3)],
                description="Competitive: Aggressive Takeout Double on 12+ HCP",
                priority=25
            ))
            # Direct 1-Level Overcall (8-16 HCP 5-card suit)
            rules.append(DecisionNetRule(
                "COMP_1S_OVERCALL",
                Call(CallType.BID, 1, Strain.SPADES),
                [RuleCondition("is_competitive", "==", True), RuleCondition("hcp", ">=", 9), RuleCondition("spade_len", ">=", 5)],
                description="Competitive: Direct 1S Overcall to contest auction",
                priority=23
            ))

        # 2. If MISSED_GAME detected -> Synthesize Game Acceptance and 2/1 GF rules
        if flaw_counts.get(BiddingFlawType.MISSED_GAME, 0) > 0:
            # Opener Maximum Game Conversion
            rules.append(DecisionNetRule(
                "GAME_ACCEPT_4S_OVER_3S",
                Call(CallType.BID, 4, Strain.SPADES),
                [RuleCondition("partner_last_call", "in", ["2S", "3S"]), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 13)],
                description="Game Maximizer: Accept limit raise and bid 4S game with 13+ HCP",
                priority=33
            ))
            rules.append(DecisionNetRule(
                "GAME_ACCEPT_4H_OVER_3H",
                Call(CallType.BID, 4, Strain.HEARTS),
                [RuleCondition("partner_last_call", "in", ["2H", "3H"]), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 13)],
                description="Game Maximizer: Accept limit raise and bid 4H game with 13+ HCP",
                priority=33
            ))
            rules.append(DecisionNetRule(
                "GAME_ACCEPT_3NT_OVER_2NT",
                Call(CallType.BID, 3, Strain.NT),
                [RuleCondition("partner_last_call", "==", "2NT"), RuleCondition("hcp", ">=", 14)],
                description="Game Maximizer: Accept 2NT invite and bid 3NT with 14+ HCP",
                priority=32
            ))

        # 3. If MISSED_SLAM detected -> Synthesize Blackwood / Cuebid Small Slam rules
        if flaw_counts.get(BiddingFlawType.MISSED_SLAM, 0) > 0:
            rules.append(DecisionNetRule(
                "SLAM_EXPLORE_6S",
                Call(CallType.BID, 6, Strain.SPADES),
                [RuleCondition("partner_last_call", "in", ["3S", "4S"]), RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 19), RuleCondition("controls", ">=", 6)],
                description="Slam Protocol: Jump to 6S on 19+ HCP and 6+ Controls",
                priority=35
            ))
            rules.append(DecisionNetRule(
                "SLAM_EXPLORE_6H",
                Call(CallType.BID, 6, Strain.HEARTS),
                [RuleCondition("partner_last_call", "in", ["3H", "4H"]), RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 19), RuleCondition("controls", ">=", 6)],
                description="Slam Protocol: Jump to 6H on 19+ HCP and 6+ Controls",
                priority=35
            ))

        return rules
