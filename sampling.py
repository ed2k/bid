from typing import List, Dict, Tuple, Optional, Set, Any
import random
import time
from bid.models import Card, Suit, Rank, Hand, Call, CallType, Seat, Strain
from bid.scoring import Vulnerability
from bid.decision_net import DecisionNet

class Deal:
    def __init__(self,
                 hands: Dict[Seat, Hand],
                 dealer: Seat = Seat.NORTH,
                 vuln: int = Vulnerability.NONE):
        self.hands = hands
        self.dealer = dealer
        self.vuln = vuln

    @staticmethod
    def random_deal(dealer: Seat = Seat.NORTH, vuln: int = Vulnerability.NONE) -> 'Deal':
        deck = [Card(s, r) for s in Suit for r in Rank]
        random.shuffle(deck)
        hands = {
            Seat.NORTH: Hand(deck[0:13]),
            Seat.EAST: Hand(deck[13:26]),
            Seat.SOUTH: Hand(deck[26:39]),
            Seat.WEST: Hand(deck[39:52])
        }
        return Deal(hands, dealer, vuln)

    @staticmethod
    def completion_from_known(known_seat: Seat,
                               known_hand: Hand,
                               dealer: Seat = Seat.NORTH,
                               vuln: int = Vulnerability.NONE) -> 'Deal':
        """Generate a random deal keeping known_seat's hand fixed."""
        all_cards = [Card(s, r) for s in Suit for r in Rank]
        # Remove known cards
        known_card_set = {(c.suit, c.rank) for c in known_hand.cards}
        remaining_cards = [c for c in all_cards if (c.suit, c.rank) not in known_card_set]
        random.shuffle(remaining_cards)

        other_seats = [s for s in Seat if s != known_seat]
        hands = {known_seat: known_hand}
        hands[other_seats[0]] = Hand(remaining_cards[0:13])
        hands[other_seats[1]] = Hand(remaining_cards[13:26])
        hands[other_seats[2]] = Hand(remaining_cards[26:39])

        return Deal(hands, dealer, vuln)

class PartialState:
    def __init__(self,
                 my_seat: Seat,
                 my_hand: Hand,
                 history: List[Call],
                 dealer: Seat = Seat.NORTH,
                 vuln: int = Vulnerability.NONE):
        self.my_seat = my_seat
        self.my_hand = my_hand
        self.history = list(history)
        self.dealer = dealer
        self.vuln = vuln

    @property
    def current_turn(self) -> Seat:
        seat_val = (self.dealer.value + len(self.history)) % 4
        return Seat(seat_val)

    def is_auction_over(self) -> bool:
        """
        Check if auction is terminated:
        - 4 passes at start (passed out)
        - 3 consecutive passes after at least one non-pass call
        """
        h = self.history
        if len(h) < 4:
            return False
        if len(h) == 4 and all(c.type == CallType.PASS for c in h):
            return True
        if len(h) >= 4 and all(c.type == CallType.PASS for c in h[-3:]):
            return True
        return False

    def get_contract(self) -> Optional[Tuple[int, Strain, Seat, int]]:
        """
        Determine (level, strain, declarer, doubled) from auction.
        doubled: 0=normal, 1=doubled (X), 2=redoubled (XX).
        Returns None if passed out.
        """
        if not self.is_auction_over():
            return None

        # Find last bid
        last_bid_idx = -1
        last_bid: Optional[Call] = None
        last_bid_seat: Optional[Seat] = None

        doubled = 0
        curr = self.dealer

        for i, call in enumerate(self.history):
            if call.type == CallType.BID:
                last_bid = call
                last_bid_seat = curr
                last_bid_idx = i
                doubled = 0
            elif call.type == CallType.DOUBLE:
                doubled = 1
            elif call.type == CallType.REDOUBLE:
                doubled = 2
            curr = Seat((curr.value + 1) % 4)

        if last_bid is None:
            return None # Passed out

        level = last_bid.level
        strain = last_bid.strain
        partnership = (last_bid_seat, last_bid_seat.partner)

        # Declarer is the first player of the winning partnership who bid the strain
        curr = self.dealer
        declarer = last_bid_seat
        for call in self.history:
            if call.type == CallType.BID and call.strain == strain and curr in partnership:
                declarer = curr
                break
            curr = Seat((curr.value + 1) % 4)

        return (level, strain, declarer, doubled)

def calculate_inconsistency(deal: Deal,
                            history: List[Call],
                            models: Dict[Seat, DecisionNet],
                            dealer: Seat = Seat.NORTH,
                            vuln: int = Vulnerability.NONE,
                            cutoff: Optional[int] = None) -> int:
    """
    Replays the auction backwards from step T to 1.
    For each call a_t, checks if a_t in φ_{player}(PS(s_t, player)).
    Returns the total InconsistencyCount.
    Early stops if cutoff is reached or exceeded.
    """
    inconsistency_count = 0
    num_calls = len(history)

    # Replay backwards
    for t in range(num_calls - 1, -1, -1):
        step_seat_val = (dealer.value + t) % 4
        player = Seat(step_seat_val)
        call_t = history[t]
        history_before = history[:t]

        player_hand = deal.hands[player]
        player_model = models.get(player)

        if player_model is not None:
            candidate_actions = player_model.actions(player_hand, history_before, player, dealer, vuln)
            if call_t not in candidate_actions:
                inconsistency_count += 1
                if cutoff is not None and inconsistency_count >= cutoff:
                    return inconsistency_count

    return inconsistency_count

class RBMBMCSampler:
    """
    Resource-Bounded Model-Based Monte Carlo Sampler.
    Samples K plausible worlds maximally consistent with observed auction actions.
    """
    def __init__(self, sample_size: int = 5, max_iterations: int = 50, timeout_sec: float = 0.5):
        self.sample_size = sample_size
        self.max_iterations = max_iterations
        self.timeout_sec = timeout_sec

    def sample(self,
               partial_state: PartialState,
               models: Dict[Seat, DecisionNet]) -> List[Deal]:
        """
        Runs RBMBMC algorithm to return K best deals.
        """
        K = self.sample_size
        known_seat = partial_state.my_seat
        known_hand = partial_state.my_hand
        history = partial_state.history
        dealer = partial_state.dealer
        vuln = partial_state.vuln

        # If history is empty (opening bid), any deal is 0 inconsistency
        if not history:
            return [Deal.completion_from_known(known_seat, known_hand, dealer, vuln) for _ in range(K)]

        start_time = time.time()
        sample: List[Tuple[int, Deal]] = [] # list of (inconsistency_score, deal)

        # 1. Initial K random worlds
        for _ in range(K):
            deal = Deal.completion_from_known(known_seat, known_hand, dealer, vuln)
            score = calculate_inconsistency(deal, history, models, dealer, vuln)
            sample.append((score, deal))

        # Sort sample by score (lowest inconsistency first)
        sample.sort(key=lambda item: item[0])
        max_inconsist = sample[-1][0]

        # 2. Spend remaining budget / iterations replacing worst worlds
        iterations = 0
        while iterations < self.max_iterations and max_inconsist > 0:
            if time.time() - start_time > self.timeout_sec:
                break

            iterations += 1
            deal = Deal.completion_from_known(known_seat, known_hand, dealer, vuln)
            score = calculate_inconsistency(deal, history, models, dealer, vuln, cutoff=max_inconsist)

            if score < max_inconsist:
                # Replace the worst world (last item)
                sample[-1] = (score, deal)
                sample.sort(key=lambda item: item[0])
                max_inconsist = sample[-1][0]

        return [deal for score, deal in sample]
