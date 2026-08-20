#!/usr/bin/env python3
"""
Partial Information Decision Making (PIDM) Engine for Bid.
Directly implements BEN's candidate bid evaluation approach:
Monte Carlo deal simulation followed by native Double Dummy Solver (DDS)
trick solving and IMP round-robin scoring.
"""

from typing import List, Dict, Set, Optional, Tuple
from bid.models import Hand, Card, Suit, Strain, Seat, Call, CallType
from bid.scoring import calculate_contract_score, score_to_imp, Vulnerability
from bid.dds import DDSolver
from bid.decision_net import DecisionNet
from bid.sampling import Deal, PartialState, RBMBMCSampler

class CandidateBidEvaluation:
    """
    Candidate Bid evaluation record ported from BEN (objects.py / botbidder.py).
    Stores simulated rollouts, Double Dummy trick distributions, expected points, and IMPs.
    """
    def __init__(self,
                 call: Call,
                 expected_score: float,
                 expected_tricks: float,
                 expected_imp: float,
                 simulated_scores: List[float]):
        self.call = call
        self.expected_score = expected_score
        self.expected_tricks = expected_tricks
        self.expected_imp = expected_imp
        self.simulated_scores = simulated_scores

    def __repr__(self) -> str:
        return f"CandidateBid({str(self.call):<4} -> ExpScore: {self.expected_score:+.1f} pts, ExpTricks: {self.expected_tricks:.1f}, ExpIMP: {self.expected_imp:+.2f})"

class PIDMEngine:
    """
    Partial Information Decision Making (PIDM) Engine.
    Executes Monte Carlo deal simulation with nested player lookahead and Double Dummy Solver.
    """
    def __init__(self,
                 sampler: Optional[RBMBMCSampler] = None,
                 max_lookahead_depth: int = 4):
        self.sampler = sampler or RBMBMCSampler(sample_size=3, max_iterations=30, timeout_sec=0.2)
        self.max_lookahead_depth = max_lookahead_depth

    def evaluate_terminal_deal(self,
                               deal: Deal,
                               history: List[Call],
                               my_seat: Seat,
                               dealer: Seat,
                               vuln: int) -> float:
        """
        Calculates duplicate bridge points / utility for the contract resulting from history.
        Uses exact Double Dummy Solver (DDSolver) ported from BEN.
        Score is returned from my_seat's partnership perspective.
        """
        temp_state = PartialState(my_seat, deal.hands[my_seat], history, dealer, vuln)
        contract = temp_state.get_contract()

        if contract is None:
            # Passed out
            return 0.0

        level, strain, declarer, doubled = contract
        is_vul = Vulnerability.is_vulnerable(vuln, declarer)

        # Exact Double Dummy Solver (DDSolver) calculation
        tricks = DDSolver.get_tricks(deal, strain, declarer)
        score_val = calculate_contract_score(level=level, strain=strain, doubled=doubled, is_vulnerable=is_vul, tricks_taken=tricks)

        # Declarer score -> perspective of my_seat
        my_partnership = (my_seat, my_seat.partner)
        if declarer in my_partnership:
            return float(score_val)
        else:
            return float(-score_val)

    def lookahead(self,
                  deal: Deal,
                  history: List[Call],
                  models: Dict[Seat, DecisionNet],
                  my_seat: Seat,
                  dealer: Seat,
                  vuln: int,
                  depth: int = 0) -> float:
        """
        Recursively simulates future auction calls using nested player models.
        """
        temp_state = PartialState(my_seat, deal.hands[my_seat], history, dealer, vuln)
        if temp_state.is_auction_over() or depth >= self.max_lookahead_depth:
            return self.evaluate_terminal_deal(deal, history, my_seat, dealer, vuln)

        next_seat = temp_state.current_turn
        next_hand = deal.hands[next_seat]
        next_model = models.get(next_seat)

        if next_model is None:
            next_actions = {Call(CallType.PASS)}
        else:
            next_actions = next_model.actions(next_hand, history, next_seat, dealer, vuln)

        if not next_actions:
            next_actions = {Call(CallType.PASS)}

        # If only 1 action, take it
        if len(next_actions) == 1:
            chosen_call = next(iter(next_actions))
            return self.lookahead(deal, history + [chosen_call], models, my_seat, dealer, vuln, depth + 1)

        # If multiple actions, evaluate based on whose turn it is
        is_my_side = (next_seat == my_seat or next_seat == my_seat.partner)
        action_values: List[float] = []

        for action in next_actions:
            val = self.lookahead(deal, history + [action], models, my_seat, dealer, vuln, depth + 1)
            action_values.append(val)

        if is_my_side:
            # Partnership maximizes score
            return max(action_values)
        else:
            # Opponents minimize our score
            return min(action_values)

    def evaluate_candidates_with_simulation_dds(self,
                                                partial_state: PartialState,
                                                models: Dict[Seat, DecisionNet],
                                                candidate_calls: List[Call],
                                                num_samples: int = 5) -> List[CandidateBidEvaluation]:
        """
        Evaluates candidate final bids using Monte Carlo deal simulation followed by
        native Double Dummy Solver (DDS) trick solving and IMP round-robin scoring.
        Directly implements BEN's simulation + DDS evaluation approach.
        """
        from bid.calculate import calculate_imp_score
        my_seat = partial_state.my_seat
        my_hand = partial_state.my_hand
        history = partial_state.history
        dealer = partial_state.dealer
        vuln = partial_state.vuln

        # 1. Generate N simulated deals consistent with partial state
        worlds = self.sampler.sample(partial_state, models)
        if not worlds or len(worlds) < num_samples:
            while len(worlds) < max(1, num_samples):
                worlds.append(Deal.completion_from_known(my_seat, my_hand, dealer, vuln))

        candidate_scores_matrix: Dict[str, List[float]] = {}
        evaluations: List[CandidateBidEvaluation] = []

        for call in candidate_calls:
            c_str = str(call)
            scores_for_call: List[float] = []
            tricks_for_call: List[float] = []

            for world in worlds:
                # Simulate auction rollout to terminal state
                terminal_history = history + [call]
                curr = Seat((my_seat.value + 1) % 4)
                while len(terminal_history) < 20:
                    ps = PartialState(curr, world.hands[curr], terminal_history, dealer, vuln)
                    if ps.is_auction_over():
                        break
                    next_model = models.get(curr)
                    if next_model:
                        acts = next_model.actions(world.hands[curr], terminal_history, curr, dealer, vuln)
                        act = next(iter(acts)) if acts else Call(CallType.PASS)
                    else:
                        act = Call(CallType.PASS)
                    terminal_history.append(act)
                    curr = Seat((curr.value + 1) % 4)

                # Solve terminal contract via native DDSolver
                ps_end = PartialState(my_seat, world.hands[my_seat], terminal_history, dealer, vuln)
                contract = ps_end.get_contract()
                if contract:
                    lvl, strain, decl, dbl = contract
                    t = DDSolver.get_tricks(world, strain, decl)
                    tricks_for_call.append(float(t))
                else:
                    tricks_for_call.append(0.0)

                u = self.evaluate_terminal_deal(world, terminal_history, my_seat, dealer, vuln)
                scores_for_call.append(u)

            candidate_scores_matrix[c_str] = scores_for_call
            mean_score = sum(scores_for_call) / len(scores_for_call) if scores_for_call else 0.0
            mean_tricks = sum(tricks_for_call) / len(tricks_for_call) if tricks_for_call else 0.0
            evaluations.append(CandidateBidEvaluation(
                call=call,
                expected_score=round(mean_score, 1),
                expected_tricks=round(mean_tricks, 1),
                expected_imp=0.0,
                simulated_scores=scores_for_call
            ))

        # Calculate IMP scores across candidate matrix
        if len(candidate_calls) > 1:
            imp_results = calculate_imp_score(candidate_scores_matrix)
            for ev in evaluations:
                ev.expected_imp = imp_results.get(str(ev.call), 0.0)

        # Sort candidates by Expected IMP / EV score
        evaluations.sort(key=lambda x: (x.expected_imp, x.expected_score), reverse=True)
        return evaluations

    def decide(self,
               partial_state: PartialState,
               models: Dict[Seat, DecisionNet],
               candidate_actions: Optional[Set[Call]] = None) -> Tuple[Call, Dict[Call, float]]:
        """
        Runs PIDM decision process:
        1. Query my_model for candidate calls. If 1 call, return immediately.
        2. If > 1 call: Sample K worlds using RBMBMC.
        3. Evaluate each candidate call via LookAhead across all K worlds.
        4. Choose best candidate action a* = argmax V(a).
        """
        my_seat = partial_state.my_seat
        my_hand = partial_state.my_hand
        history = partial_state.history
        dealer = partial_state.dealer
        vuln = partial_state.vuln
        my_model = models.get(my_seat)

        if candidate_actions is None:
            if my_model is not None:
                actions = my_model.actions(my_hand, history, my_seat, dealer, vuln)
            else:
                actions = {Call(CallType.PASS)}
        else:
            actions = set(candidate_actions)

        if not actions:
            actions = {Call(CallType.PASS)}

        # Fast path: single candidate
        if len(actions) == 1:
            single_action = next(iter(actions))
            return single_action, {single_action: 0.0}

        # Multi-candidate path: sample worlds and evaluate via simulation + DDS
        worlds = self.sampler.sample(partial_state, models)
        if not worlds:
            worlds = [Deal.completion_from_known(my_seat, my_hand, dealer, vuln)]

        values: Dict[Call, float] = {}

        for action in actions:
            total_u = 0.0
            for world in worlds:
                u = self.lookahead(world, history + [action], models, my_seat, dealer, vuln, depth=1)
                total_u += u
            values[action] = total_u / len(worlds)

        best_call = max(values, key=values.get)
        return best_call, values
