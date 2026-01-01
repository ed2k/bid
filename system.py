from typing import List, Callable, Optional
from bid.models import Call, Hand
from bid.constraints import HandConstraints

class Rule:
    def __init__(self, 
                 priority: int,
                 trigger: Callable[[List[Call]], bool],
                 constraints: HandConstraints,
                 call: Call,
                 description: str = ""):
        self.priority = priority
        self.trigger = trigger  # Function taking auction history -> bool
        self.constraints = constraints
        self.call = call
        self.description = description

    def applies(self, history: List[Call], hand: Hand) -> bool:
        if not self.trigger(history):
            return False
        return self.constraints.matches(hand)

class BiddingSystem:
    def __init__(self, name: str):
        self.name = name
        self.rules: List[Rule] = []

    def add_rule(self, rule: Rule):
        self.rules.append(rule)
        # Keep sorted by priority (highest first)
        self.rules.sort(key=lambda r: r.priority, reverse=True)

    def get_bid(self, history: List[Call], hand: Hand) -> Optional[Rule]:
        for rule in self.rules:
            if rule.applies(history, hand):
                return rule
        return None
