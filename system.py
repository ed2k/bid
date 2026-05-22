from typing import List, Callable, Optional
from bid.models import Call, Hand
from bid.constraints import HandConstraints

class Rule:
    def __init__(self, 
                 priority: int,
                 trigger: Callable[[List[Call]], bool],
                 constraints: HandConstraints,
                 call: Call,
                 description: str = "",
                 metadata: Optional[dict] = None,
                 trigger_type: str = "",
                 sequence_history: Optional[List] = None,
                 is_common: bool = False):
        self.priority = priority
        self.trigger = trigger  # Function taking auction history -> bool
        self.constraints = constraints
        self.call = call
        self.description = description
        self.metadata = metadata or {}
        self.trigger_type = trigger_type
        self.sequence_history = sequence_history or []
        self.is_common = is_common

    def applies(self, history: List[Call], hand: Hand) -> bool:
        if not self.trigger(history):
            return False
        return self.constraints.matches(hand)

class BiddingSystem:
    def __init__(self, name: str):
        self.name = name
        self.rules: List[Rule] = []

    def add_rule(self, rule: Rule):
        # Override strategy:
        # If the new rule is system-specific (rule.is_common is False),
        # we override/replace any existing common rules (existing_rule.is_common is True)
        # that have the same trigger_type, sequence_history, and call.
        if not rule.is_common:
            self.rules = [
                r for r in self.rules
                if not (r.is_common and
                        r.trigger_type == rule.trigger_type and
                        r.sequence_history == rule.sequence_history and
                        r.call == rule.call)
            ]
        self.rules.append(rule)
        # Keep sorted by priority (highest first)
        self.rules.sort(key=lambda r: r.priority, reverse=True)

    def get_bid(self, history: List[Call], hand: Hand) -> Optional[Rule]:
        for rule in self.rules:
            if rule.applies(history, hand):
                return rule
        return None
