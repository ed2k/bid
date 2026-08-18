from typing import Dict, List, Tuple, Any
from bid.models import Seat, Hand, Call, CallType
from bid.decision_net import DecisionNet
from bid.sampling import Deal, PartialState, RBMBMCSampler
from bid.pidm import PIDMEngine
from bid.learner import DecisionNetLearner

class CoTrainer:
    """
    Co-training system for bridge partners (North and South).
    Partners learn in parallel, refine their local decision nets on ambiguous states,
    and exchange refined models across iterative rounds.
    """
    def __init__(self,
                 teacher_engine: PIDMEngine,
                 north_net: DecisionNet,
                 south_net: DecisionNet,
                 east_net: DecisionNet,
                 west_net: DecisionNet):
        self.teacher = teacher_engine
        self.learner = DecisionNetLearner(teacher_engine)
        self.models: Dict[Seat, DecisionNet] = {
            Seat.NORTH: north_net.clone(),
            Seat.SOUTH: south_net.clone(),
            Seat.EAST: east_net.clone(),
            Seat.WEST: west_net.clone()
        }

    def run_training_round(self,
                           num_states_per_seat: int = 10,
                           dealer: Seat = Seat.NORTH) -> Dict[str, Any]:
        """
        Executes one parallel co-training round:
        1. North finds ambiguous states -> tags with PIDM -> refines North net.
        2. South finds ambiguous states -> tags with PIDM -> refines South net.
        3. Exchange refined nets in partnership.
        """
        # North training
        north_ambiguous = self.learner.find_ambiguous_states(
            self.models[Seat.NORTH],
            target_count=num_states_per_seat,
            dealer=dealer
        )
        # Adapt seats for north states
        for s in north_ambiguous:
            s.my_seat = Seat.NORTH

        north_data = self.learner.tag_states(north_ambiguous, self.models)
        self.learner.refine_decision_net(self.models[Seat.NORTH], north_data)

        # South training
        south_ambiguous = self.learner.find_ambiguous_states(
            self.models[Seat.SOUTH],
            target_count=num_states_per_seat,
            dealer=dealer
        )
        south_data = self.learner.tag_states(south_ambiguous, self.models)
        self.learner.refine_decision_net(self.models[Seat.SOUTH], south_data)

        return {
            "north_trained_examples": len(north_data),
            "south_trained_examples": len(south_data),
            "north_refinements": len(self.models[Seat.NORTH].intersection_nodes),
            "south_refinements": len(self.models[Seat.SOUTH].intersection_nodes)
        }

    def evaluate_partnership(self,
                             test_deals: List[Deal],
                             fast_engine: PIDMEngine) -> float:
        """
        Evaluates the NS partnership performance over a set of test deals.
        Returns average partnership duplicate points / utility.
        """
        total_score = 0.0
        for deal in test_deals:
            # Simulate auction from dealer
            history: List[Call] = []
            curr = deal.dealer
            while True:
                p_state = PartialState(curr, deal.hands[curr], history, deal.dealer, deal.vuln)
                if p_state.is_auction_over() or len(history) >= 20:
                    break
                call, _ = fast_engine.decide(p_state, self.models)
                history.append(call)
                curr = Seat((curr.value + 1) % 4)

            score = fast_engine.evaluate_terminal_deal(deal, history, Seat.SOUTH, deal.dealer, deal.vuln)
            total_score += score

        return total_score / len(test_deals) if test_deals else 0.0
