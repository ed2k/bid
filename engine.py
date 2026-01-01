from typing import List, Dict, Optional
from bid.models import Hand, Call, CallType, Seat
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

    def estimate_deal(self, 
                      history: List[Call], 
                      my_seat: Seat, 
                      dealer_seat: Seat, 
                      my_system: BiddingSystem, 
                      opp_system: BiddingSystem) -> Dict[Seat, HandConstraints]:
        """
        Analyze the auction and return constraints for each player.
        """
        # Initialize constraints (0-37 HCP, 0-13 len)
        constraints = {s: HandConstraints() for s in Seat}
        
        current_seat = dealer_seat
        
        for i, call in enumerate(history):
            # Determine which system applies
            is_my_side = (current_seat == my_seat) or (current_seat == my_seat.partner)
            active_system = my_system if is_my_side else opp_system
            
            history_before = history[:i]
            matching_rules = []
            
            # Find rules in the active system that would produce this call
            for r in active_system.rules:
                if r.trigger(history_before) and r.call == call:
                    matching_rules.append(r)
            
            if matching_rules:
                # If multiple rules match, ideally intersection/union. 
                # For now, take first match.
                r = matching_rules[0]
                constraints[current_seat] = constraints[current_seat].intersect(r.constraints)
            else:
                # No rule matched. 
                # If PASS, implies no opening/response rule triggered. 
                # This logic is complex (negative processing). 
                # For now, do nothing if no explicit rule matches.
                pass
            
            current_seat = Seat((current_seat.value + 1) % 4)
            
        return constraints

    def format_estimate(self, constraints: HandConstraints) -> str:
        return str(constraints)
