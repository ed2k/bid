from typing import List, Dict, Tuple, Optional, Any, Set
import random
from bid.models import Hand, Card, Suit, Rank, Seat, Call, CallType, Strain
from bid.scoring import Vulnerability
from bid.sampling import Deal, PartialState
from bid.features import BridgeFeatures
from bid.decision_net import DecisionNet

class StratifiedDealGenerator:
    """
    Generates deals conditioned on specific strata to solve the rare-hand problem
    (e.g., 9-card suits, extreme HCP, void shapes, freak distributions).
    """

    @staticmethod
    def generate_hand_with_suit_length(target_suit: Suit, min_length: int) -> Hand:
        """Generates a 13-card hand containing at least min_length cards in target_suit."""
        all_cards_in_suit = [Card(target_suit, r) for r in Rank]
        random.shuffle(all_cards_in_suit)

        chosen_suit_cards = all_cards_in_suit[:min_length]

        other_cards = [Card(s, r) for s in Suit if s != target_suit for r in Rank]
        random.shuffle(other_cards)

        needed = 13 - min_length
        total_cards = chosen_suit_cards + other_cards[:needed]
        return Hand(total_cards)

    @staticmethod
    def generate_hand_with_hcp_range(min_hcp: int, max_hcp: int, max_attempts: int = 500) -> Hand:
        """Generates a hand strictly within [min_hcp, max_hcp]."""
        for _ in range(max_attempts):
            hand = Hand.random()
            if min_hcp <= hand.hcp <= max_hcp:
                return hand
        return Hand.random()

    @staticmethod
    def generate_stratified_deal(seat: Seat,
                                 suit_stratum: Optional[Tuple[Suit, int]] = None,
                                 hcp_stratum: Optional[Tuple[int, int]] = None,
                                 dealer: Seat = Seat.NORTH,
                                 vuln: int = Vulnerability.NONE) -> Deal:
        """Generates a complete deal where seat satisfies the stratum criteria."""
        if suit_stratum:
            suit, length = suit_stratum
            hand = StratifiedDealGenerator.generate_hand_with_suit_length(suit, length)
        elif hcp_stratum:
            min_h, max_h = hcp_stratum
            hand = StratifiedDealGenerator.generate_hand_with_hcp_range(min_h, max_h)
        else:
            hand = Hand.random()

        return Deal.completion_from_known(seat, hand, dealer, vuln)

class PrioritizedExperience:
    def __init__(self,
                 partial_state: PartialState,
                 candidate_actions: Set[Call],
                 teacher_call: Call,
                 priority: float,
                 reason: str = "ambiguity"):
        self.partial_state = partial_state
        self.candidate_actions = candidate_actions
        self.teacher_call = teacher_call
        self.priority = priority
        self.reason = reason
        self.features = BridgeFeatures.extract_all(
            partial_state.my_hand,
            partial_state.history,
            partial_state.my_seat,
            partial_state.dealer,
            partial_state.vuln
        )

class ExperienceBuffer:
    """
    Prioritized Experience Replay Buffer for storing and sampling informative bridge states:
    - Rare distributions (e.g. 9-card suits)
    - Disagreements between fast policy and expensive PIDM teacher
    - High-value utility gaps
    - Out-of-distribution hands
    """
    def __init__(self, max_capacity: int = 1000):
        self.max_capacity = max_capacity
        self.buffer: List[PrioritizedExperience] = []

    def add(self, exp: PrioritizedExperience):
        if len(self.buffer) >= self.max_capacity:
            # Remove lowest priority item
            self.buffer.sort(key=lambda x: x.priority)
            self.buffer.pop(0)
        self.buffer.append(exp)

    def calculate_priority(self,
                           hand: Hand,
                           policy_actions: Set[Call],
                           teacher_call: Call,
                           value_gap: float = 0.0) -> Tuple[float, str]:
        # Feature checks
        longest = max(hand.length(s) for s in Suit)
        is_rare = (longest >= 8 or hand.hcp >= 22 or hand.hcp <= 2)
        disagreement = (teacher_call not in policy_actions) if policy_actions else True

        priority = 1.0
        reason = "standard"

        if is_rare:
            priority += 5.0
            reason = "rare_hand"
        if disagreement:
            priority += 10.0
            reason = "policy_disagreement"
        if value_gap > 50.0:
            priority += 5.0
            reason = "high_value_gap"

        return priority, reason

    def sample_batch(self, batch_size: int = 10) -> List[PrioritizedExperience]:
        if not self.buffer:
            return []
        if len(self.buffer) <= batch_size:
            return list(self.buffer)

        # Weighted sampling by priority
        total_p = sum(e.priority for e in self.buffer)
        weights = [e.priority / total_p for e in self.buffer]
        return random.choices(self.buffer, weights=weights, k=batch_size)

class ExploratoryCandidateGenerator:
    """
    Generates exploratory actions:
    A(s) = A_expert(s) U A_explore(s) with adaptive exploration rate epsilon.
    """
    def __init__(self, base_epsilon: float = 0.05):
        self.base_epsilon = base_epsilon

    def generate_candidates(self,
                            partial_state: PartialState,
                            expert_net: DecisionNet,
                            allow_exploration: bool = True) -> Set[Call]:
        expert_actions = expert_net.actions(
            partial_state.my_hand,
            partial_state.history,
            partial_state.my_seat,
            partial_state.dealer,
            partial_state.vuln
        )

        if not allow_exploration or random.random() > self.base_epsilon:
            return expert_actions

        # Add sensible exploratory bids (e.g. alternate 1-level openings or responses)
        candidates = set(expert_actions)
        if len(partial_state.history) == 0:
            # Opening bids exploration
            candidates.add(Call(CallType.BID, 1, Strain.CLUBS))
            candidates.add(Call(CallType.BID, 1, Strain.DIAMONDS))
            candidates.add(Call(CallType.BID, 1, Strain.HEARTS))
            candidates.add(Call(CallType.BID, 1, Strain.SPADES))
            candidates.add(Call(CallType.BID, 1, Strain.NT))

        return candidates
