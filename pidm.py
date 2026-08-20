from typing import List, Dict, Set, Optional, Tuple
from bid.models import Hand, Card, Suit, Strain, Seat, Call, CallType
from bid.scoring import calculate_contract_score, score_to_imp, Vulnerability
from bid.dds import DDSolver
from bid.decision_net import DecisionNet
from bid.sampling import Deal, PartialState, RBMBMCSampler

class PIDMEngine:
    """
    Partial Information Decision Making (PIDM) Engine.
    Executes model-based Monte Carlo decision making with nested player simulation and lookahead.
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
            # Fallback: pass
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

        # Multi-candidate path: sample worlds
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
