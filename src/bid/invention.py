from typing import Dict, List, Tuple, Optional, Any, Set
from bid.models import Hand, Card, Suit, Strain, Rank, Seat, Call, CallType
from bid.scoring import Vulnerability, score_to_imp
from bid.features import BridgeFeatures
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.sampling import Deal, PartialState, RBMBMCSampler, calculate_inconsistency
from bid.pidm import PIDMEngine
from bid.learner import DecisionNetLearner, ID3DecisionTree
from bid.cotrain import CoTrainer
from bid.experience import StratifiedDealGenerator, ExperienceBuffer, PrioritizedExperience, ExploratoryCandidateGenerator
from bid.protocol import ConventionProtocol, ProtocolStep, ProtocolOpType, ValueOfInformationEvaluator, AdversarialSignalingEvaluator

class BidInventionEngine:
    """
    High-level facade and experimental engine implementing:
    - Amit-Markovitch (2006) BIDI architecture
    - RBMBMC vs Uniform PIMC comparison
    - ID3 Speedup Refinement & Partner Co-Training
    - Stratified rare-state sampling & Prioritized Experience Replay
    - Semantic Convention Synthesis, Value of Information (VOI), and Strategic Gambling
    """
    def __init__(self,
                 sample_size: int = 3,
                 max_lookahead_depth: int = 3):
        self.sampler = RBMBMCSampler(sample_size=sample_size, max_iterations=20, timeout_sec=0.2)
        self.pidm = PIDMEngine(sampler=self.sampler, max_lookahead_depth=max_lookahead_depth)
        self.exp_buffer = ExperienceBuffer(max_capacity=500)
        self.candidate_generator = ExploratoryCandidateGenerator(base_epsilon=0.05)
        self.models: Dict[Seat, DecisionNet] = self._create_default_models()

    def _create_default_models(self) -> Dict[Seat, DecisionNet]:
        """Creates standard baseline bidding models with built-in rule intersections."""
        models: Dict[Seat, DecisionNet] = {}
        for seat in Seat:
            net = DecisionNet(f"System_{seat}")

            # 1NT Opening rule (15-17 HCP, balanced)
            net.add_rule(DecisionNetRule(
                rule_id="R_1NT",
                call=Call(CallType.BID, 1, Strain.NT),
                conditions=[
                    RuleCondition("hcp", ">=", 15),
                    RuleCondition("hcp", "<=", 17),
                    RuleCondition("is_balanced", "==", True)
                ],
                description="1NT Opening: 15-17 HCP balanced",
                priority=20
            ))

            # 1H Opening rule (12-21 HCP, 5+ hearts)
            net.add_rule(DecisionNetRule(
                rule_id="R_1H",
                call=Call(CallType.BID, 1, Strain.HEARTS),
                conditions=[
                    RuleCondition("hcp", ">=", 12),
                    RuleCondition("hcp", "<=", 21),
                    RuleCondition("heart_len", ">=", 5)
                ],
                description="1H Opening: 12-21 HCP, 5+ hearts",
                priority=20
            ))

            # 1S Opening rule (12-21 HCP, 5+ spades)
            net.add_rule(DecisionNetRule(
                rule_id="R_1S",
                call=Call(CallType.BID, 1, Strain.SPADES),
                conditions=[
                    RuleCondition("hcp", ">=", 12),
                    RuleCondition("hcp", "<=", 21),
                    RuleCondition("spade_len", ">=", 5)
                ],
                description="1S Opening: 12-21 HCP, 5+ spades",
                priority=20
            ))

            # 1D Opening rule (12-21 HCP, 4+ diamonds)
            net.add_rule(DecisionNetRule(
                rule_id="R_1D",
                call=Call(CallType.BID, 1, Strain.DIAMONDS),
                conditions=[
                    RuleCondition("hcp", ">=", 12),
                    RuleCondition("hcp", "<=", 21),
                    RuleCondition("diamond_len", ">=", 4)
                ],
                description="1D Opening: 12-21 HCP, 4+ diamonds",
                priority=15
            ))

            # 1C Opening rule (12-21 HCP unbalanced or 12-14 balanced, 3+ clubs)
            net.add_rule(DecisionNetRule(
                rule_id="R_1C_unbalanced",
                call=Call(CallType.BID, 1, Strain.CLUBS),
                conditions=[
                    RuleCondition("hcp", ">=", 12),
                    RuleCondition("hcp", "<=", 21),
                    RuleCondition("club_len", ">=", 3),
                    RuleCondition("is_balanced", "==", False)
                ],
                description="1C Opening: 12-21 HCP, 3+ clubs unbalanced",
                priority=10
            ))
            net.add_rule(DecisionNetRule(
                rule_id="R_1C_balanced",
                call=Call(CallType.BID, 1, Strain.CLUBS),
                conditions=[
                    RuleCondition("hcp", ">=", 12),
                    RuleCondition("hcp", "<=", 14),
                    RuleCondition("club_len", ">=", 3),
                    RuleCondition("is_balanced", "==", True)
                ],
                description="1C Opening: 12-14 HCP balanced",
                priority=10
            ))

            # Game bids
            net.add_rule(DecisionNetRule(
                rule_id="R_4H",
                call=Call(CallType.BID, 4, Strain.HEARTS),
                conditions=[
                    RuleCondition("heart_len", ">=", 6),
                    RuleCondition("hcp", ">=", 13)
                ],
                description="4H Game bid",
                priority=25
            ))

            net.add_rule(DecisionNetRule(
                rule_id="R_4S",
                call=Call(CallType.BID, 4, Strain.SPADES),
                conditions=[
                    RuleCondition("spade_len", ">=", 6),
                    RuleCondition("hcp", ">=", 13)
                ],
                description="4S Game bid",
                priority=25
            ))

            models[seat] = net

        return models

    def get_bid(self,
                hand: Hand,
                history: List[Call],
                my_seat: Seat = Seat.SOUTH,
                dealer: Seat = Seat.NORTH,
                vuln: int = Vulnerability.NONE) -> Tuple[Call, Dict[Call, float]]:
        """Get best bid using PIDM and selection strategy."""
        p_state = PartialState(my_seat, hand, history, dealer, vuln)
        return self.pidm.decide(p_state, self.models)

    def run_co_training(self, rounds: int = 2, states_per_round: int = 10) -> Dict[str, Any]:
        """Runs iterative partner co-training."""
        cotrainer = CoTrainer(
            self.pidm,
            self.models[Seat.NORTH],
            self.models[Seat.SOUTH],
            self.models[Seat.EAST],
            self.models[Seat.WEST]
        )
        round_stats = []
        for r in range(rounds):
            stats = cotrainer.run_training_round(num_states_per_seat=states_per_round)
            round_stats.append({"round": r + 1, **stats})

        self.models = cotrainer.models
        return {"rounds": round_stats}
