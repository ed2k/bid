from typing import Dict, List, Tuple, Any
from bid.models import Seat, Hand, Call, CallType, Strain
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
                             fast_engine: PIDMEngine) -> Dict[str, float]:
        """
        Evaluates the NS partnership performance over a set of test deals against native DDS.
        Returns a dict containing:
        - avg_score: average partnership duplicate points
        - avg_par: average theoretical DDS par score
        - avg_regret: score - par (0 = perfect par)
        - par_accuracy: % of boards where score >= par
        - makable_game_reached: % of makable games found
        """
        from bid.dds import DDSolver
        total_score = 0.0
        total_par = 0.0
        par_hits = 0
        makable_games = 0
        games_reached = 0

        for deal in test_deals:
            # Calculate native DDS Par
            par_score, par_contract = DDSolver.calculate_par(deal, deal.vuln)
            total_par += par_score

            # Check if 4M or 3NT is makable via DDS
            dd_table = DDSolver.solve_dd_table(deal)
            ns_can_make_game = (
                dd_table.get((Strain.SPADES, Seat.NORTH), 0) >= 10 or
                dd_table.get((Strain.SPADES, Seat.SOUTH), 0) >= 10 or
                dd_table.get((Strain.HEARTS, Seat.NORTH), 0) >= 10 or
                dd_table.get((Strain.HEARTS, Seat.SOUTH), 0) >= 10 or
                dd_table.get((Strain.NT, Seat.NORTH), 0) >= 9 or
                dd_table.get((Strain.NT, Seat.SOUTH), 0) >= 9
            )
            if ns_can_make_game:
                makable_games += 1

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

            if score >= par_score:
                par_hits += 1

            p_state = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], history, deal.dealer, deal.vuln)
            contract = p_state.get_contract()
            if contract:
                lvl, strain, decl, _ = contract
                if decl in (Seat.NORTH, Seat.SOUTH):
                    if (strain in (Strain.SPADES, Strain.HEARTS) and lvl >= 4) or (strain == Strain.NT and lvl >= 3) or (lvl >= 5):
                        if ns_can_make_game:
                            games_reached += 1

        n = len(test_deals) if test_deals else 1
        avg_score = total_score / n
        avg_par = total_par / n
        par_accuracy = (par_hits / n) * 100.0
        game_conversion = (games_reached / max(1, makable_games)) * 100.0 if makable_games else 100.0

        return {
            "avg_score": avg_score,
            "avg_par": avg_par,
            "avg_regret": avg_score - avg_par,
            "par_accuracy": par_accuracy,
            "game_conversion": game_conversion
        }
