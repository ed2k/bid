#!/usr/bin/env python3
from typing import Dict, List, Tuple, Any, Optional
from bid.models import Hand, Seat, Call, CallType, Strain
from bid.decision_net import DecisionNet
from bid.sampling import Deal, PartialState, RBMBMCSampler
from bid.pidm import PIDMEngine
from bid.scoring import score_to_imp

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
    under identical deals and duplicate scoring conditions.
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

    def play_match(self,
                   deals: List[Deal],
                   system_a: DecisionNet,
                   system_b: DecisionNet,
                   opponent_system: DecisionNet) -> MatchResult:
        """
        Plays a duplicate bridge team match where System A and System B
        both play identical deals as North-South against Opponent System.
        """
        match = MatchResult(system_a.name, system_b.name)
        match.total_deals = len(deals)

        for deal in deals:
            # Room 1: System A as North-South
            _, score_a = self.play_board(deal, system_a, opponent_system)
            # Room 2: System B as North-South
            _, score_b = self.play_board(deal, system_b, opponent_system)

            match.sys_a_points += score_a
            match.sys_b_points += score_b

            diff = int(score_a - score_b)
            board_imp = score_to_imp(diff)

            if board_imp > 0:
                match.sys_a_imps += board_imp
                match.wins_a += 1
            elif board_imp < 0:
                match.sys_b_imps += abs(board_imp)
                match.wins_b += 1
            else:
                match.ties += 1

            match.net_imps += board_imp

        return match
