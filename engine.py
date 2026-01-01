from typing import List, Dict, Optional
from bid.models import Hand, Call, CallType
from bid.system import BiddingSystem, Rule
from bid.constraints import HandConstraints

class Engine:
    def __init__(self, system: BiddingSystem):
        self.system = system

    def get_bid(self, history: List[Call], hand: Hand) -> Call:
        rule = self.system.get_bid(history, hand)
        if rule:
            return rule.call
        # Default fallback: Pass
        return Call(CallType.PASS)

    def explain_auction(self, history: List[Call], dealer_seat_index: int = 0):
        """
        Analyze the auction and return constraints for each player.
        Assuming 4 seats: N, E, S, W (0, 1, 2, 3)
        """
        # Initialize constraints (0-37 HCP, 0-13 len)
        constraints = {i: HandConstraints() for i in range(4)}
        
        current_seat = dealer_seat_index
        
        for i, call in enumerate(history):
            # Find the rule that generated this call
            # We need to find which rule *would* generate this call in this context
            # CAUTION: This assumes the player is playing OUR system.
            # In validation, we assume everyone plays the same system.
            
            # Since we don't have the hand, we look for rules where
            # trigger(history_before) is true AND rule.call == actual_call
            
            history_before = history[:i]
            matching_rules = []
            
            for r in self.system.rules:
                if r.trigger(history_before) and r.call == call:
                    matching_rules.append(r)
            
            # If multiple rules match, it's ambiguous, but usually different constraints.
            # Ideally we take the union of constraints.
            # For simplicity, take the highest priority one or the first one.
            
            if matching_rules:
                r = matching_rules[0]
                # Update constraints for current_seat
                constraints[current_seat] = constraints[current_seat].intersect(r.constraints)
            
            current_seat = (current_seat + 1) % 4
            
        return constraints

    def format_estimate(self, constraints: HandConstraints) -> str:
        return str(constraints)
