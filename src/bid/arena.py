#!/usr/bin/env python3
"""
Duplicate Bridge Tournament Arena for Bid.
Evaluates competing bidding systems by comparing both the bidding auctions
(strains, levels, bidding efficiency) and the resulting duplicate bridge scores
against native Double Dummy Solver (DDS) par benchmarks.
"""

from typing import Dict, List, Tuple, Any, Optional
from bid.models import Hand, Seat, Call, CallType, Strain
from bid.decision_net import DecisionNet
from bid.sampling import Deal, PartialState, RBMBMCSampler
from bid.pidm import PIDMEngine
from bid.scoring import score_to_imp, diff_to_imps
from bid.dds import DDSolver

class BoardComparison:
    """
    Detailed dual comparison of both the BID (auction trajectory, contract, level, strain)
    and the SCORE (DDS tricks, duplicate score, Par regret, and IMP swing).
    """
    def __init__(self, board_id: int, deal: Deal):
        self.board_id = board_id
        self.deal = deal
        self.par_score: int = 0
        self.par_contract: str = "N/A"

        # Room A
        self.sys_a_name: str = ""
        self.room_a_history: List[Call] = []
        self.room_a_contract: str = "Pass"
        self.room_a_declarer: str = "None"
        self.room_a_tricks: int = 0
        self.room_a_score: float = 0.0
        self.room_a_par_regret: float = 0.0

        # Room B
        self.sys_b_name: str = ""
        self.room_b_history: List[Call] = []
        self.room_b_contract: str = "Pass"
        self.room_b_declarer: str = "None"
        self.room_b_tricks: int = 0
        self.room_b_score: float = 0.0
        self.room_b_par_regret: float = 0.0

        # Comparative Metrics
        self.point_diff: float = 0.0
        self.imp_swing: int = 0
        self.bidding_analysis: str = ""

    def summary(self) -> str:
        s = f"Board #{self.board_id:<2} | Par: {self.par_contract:<10} ({self.par_score:+d} pts)\n"
        s += f"  • {self.sys_a_name:<24}: Bid {self.room_a_contract:<8} (by {self.room_a_declarer}) -> Made {self.room_a_tricks} tricks -> Score: {self.room_a_score:+.0f} pts (Par Regret: {self.room_a_par_regret:+.0f} pts)\n"
        s += f"    Auction A : {' '.join(str(c) for c in self.room_a_history)}\n"
        s += f"  • {self.sys_b_name:<24}: Bid {self.room_b_contract:<8} (by {self.room_b_declarer}) -> Made {self.room_b_tricks} tricks -> Score: {self.room_b_score:+.0f} pts (Par Regret: {self.room_b_par_regret:+.0f} pts)\n"
        s += f"    Auction B : {' '.join(str(c) for c in self.room_b_history)}\n"
        s += f"  ⚖️  Result   : Δ Pts: {self.point_diff:+.0f} | Swing: {self.imp_swing:+d} IMPs | {self.bidding_analysis}\n"
        return s

class MatchResult:
    def __init__(self, sys_a_name: str, sys_b_name: str):
        self.sys_a_name = sys_a_name
        self.sys_b_name = sys_b_name
        self.total_deals = 0
        self.sys_a_points = 0.0
        self.sys_b_points = 0.0
        self.sys_a_imps = 0
        self.sys_b_imps = 0
        self.net_imps = 0
        self.wins_a = 0
        self.wins_b = 0
        self.ties = 0
        self.boards: List[BoardComparison] = []

    @property
    def avg_imps_per_deal(self) -> float:
        return self.net_imps / self.total_deals if self.total_deals else 0.0

    def summary(self) -> str:
        res_str = f"🏆 Match: {self.sys_a_name} vs {self.sys_b_name}\n"
        res_str += f"   • Boards: {self.total_deals} | Net IMPs: {self.net_imps:+d} ({self.avg_imps_per_deal:+.2f} IMPs/deal)\n"
        res_str += f"   • Score: {self.sys_a_name} {self.sys_a_imps} IMPs ({self.wins_a} wins) vs {self.sys_b_name} {self.sys_b_imps} IMPs ({self.wins_b} wins) | {self.ties} ties\n"
        return res_str

class BiddingArena:
    """
    Duplicate bridge tournament arena comparing competing bidding systems
    under identical deals, evaluating both auction bids and duplicate score outcomes.
    """
    def __init__(self, engine: Optional[PIDMEngine] = None):
        self.engine = engine or PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06), max_lookahead_depth=1)

    def play_board(self,
                   deal: Deal,
                   ns_model: DecisionNet,
                   ew_model: DecisionNet) -> Tuple[List[Call], float]:
        """Plays a single board and returns the final auction and North-South duplicate score."""
        history: List[Call] = []
        curr = deal.dealer
        models = {
            Seat.NORTH: ns_model,
            Seat.SOUTH: ns_model,
            Seat.EAST: ew_model,
            Seat.WEST: ew_model
        }

        while True:
            ps = PartialState(curr, deal.hands[curr], history, deal.dealer, deal.vuln)
            if ps.is_auction_over() or len(history) >= 20:
                break
            call, _ = self.engine.decide(ps, models)
            history.append(call)
            curr = Seat((curr.value + 1) % 4)

        score = self.engine.evaluate_terminal_deal(deal, history, Seat.SOUTH, deal.dealer, deal.vuln)
        return history, score

    def compare_board(self,
                      board_id: int,
                      deal: Deal,
                      system_a: DecisionNet,
                      system_b: DecisionNet,
                      opponent_system: DecisionNet) -> BoardComparison:
        """
        Runs a dual room comparison on a single board, analyzing both BID and SCORE.
        """
        comp = BoardComparison(board_id, deal)
        comp.sys_a_name = system_a.name
        comp.sys_b_name = system_b.name

        # Calculate exact Par via native DDSolver
        par_score, par_contract = DDSolver.calculate_par(deal, deal.vuln)
        comp.par_score = par_score
        comp.par_contract = par_contract

        # Room 1: System A
        hist_a, score_a = self.play_board(deal, system_a, opponent_system)
        comp.room_a_history = hist_a
        comp.room_a_score = score_a
        comp.room_a_par_regret = score_a - par_score

        ps_a = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], hist_a, deal.dealer, deal.vuln)
        c_a = ps_a.get_contract()
        if c_a:
            lvl, strain, decl, dbl = c_a
            comp.room_a_contract = f"{lvl}{['C','D','H','S','NT'][strain.value]}{'X' if dbl==1 else ('XX' if dbl==2 else '')}"
            comp.room_a_declarer = decl.name
            comp.room_a_tricks = DDSolver.get_tricks(deal, strain, decl)

        # Room 2: System B
        hist_b, score_b = self.play_board(deal, system_b, opponent_system)
        comp.room_b_history = hist_b
        comp.room_b_score = score_b
        comp.room_b_par_regret = score_b - par_score

        ps_b = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], hist_b, deal.dealer, deal.vuln)
        c_b = ps_b.get_contract()
        if c_b:
            lvl, strain, decl, dbl = c_b
            comp.room_b_contract = f"{lvl}{['C','D','H','S','NT'][strain.value]}{'X' if dbl==1 else ('XX' if dbl==2 else '')}"
            comp.room_b_declarer = decl.name
            comp.room_b_tricks = DDSolver.get_tricks(deal, strain, decl)

        # Comparison analysis
        comp.point_diff = score_a - score_b
        comp.imp_swing = score_to_imp(int(comp.point_diff))

        if comp.room_a_contract == comp.room_b_contract and comp.room_a_declarer == comp.room_b_declarer:
            comp.bidding_analysis = "Identical contract reached in both rooms."
        elif comp.imp_swing > 0:
            comp.bidding_analysis = f"{system_a.name} gained by bidding {comp.room_a_contract} vs {comp.room_b_contract}."
        elif comp.imp_swing < 0:
            comp.bidding_analysis = f"{system_b.name} gained by bidding {comp.room_b_contract} vs {comp.room_a_contract}."
        else:
            comp.bidding_analysis = f"Different contracts ({comp.room_a_contract} vs {comp.room_b_contract}) produced identical duplicate score."

        return comp

    def play_match(self,
                   deals: List[Deal],
                   system_a: DecisionNet,
                   system_b: DecisionNet,
                   opponent_system: DecisionNet) -> MatchResult:
        """
        Plays a duplicate bridge match where System A and System B both play
        identical deals as North-South, recording full board-by-board bid & score comparisons.
        """
        match = MatchResult(system_a.name, system_b.name)
        match.total_deals = len(deals)

        for i, deal in enumerate(deals, 1):
            board_comp = self.compare_board(i, deal, system_a, system_b, opponent_system)
            match.boards.append(board_comp)

            match.sys_a_points += board_comp.room_a_score
            match.sys_b_points += board_comp.room_b_score

            if board_comp.imp_swing > 0:
                match.sys_a_imps += board_comp.imp_swing
                match.wins_a += 1
            elif board_comp.imp_swing < 0:
                match.sys_b_imps += abs(board_comp.imp_swing)
                match.wins_b += 1
            else:
                match.ties += 1

            match.net_imps += board_comp.imp_swing

        return match
