from typing import List, Dict, Set, Callable, Optional, Any, Union, Tuple
from bid.models import Hand, Call, CallType, Seat, Strain, Suit
from bid.features import BridgeFeatures
from bid.system import BiddingSystem, Rule

class RuleCondition:
    """Predicate condition on bridge features."""
    def __init__(self, key: str, op: str, value: Any):
        self.key = key
        self.op = op # '==', '!=', '>=', '<=', '>', '<', 'in', 'not_in'
        self.value = value

    def evaluate(self, features: Dict[str, Any]) -> bool:
        if self.key not in features:
            return False
        v = features[self.key]
        if self.op == '==': return v == self.value
        if self.op == '!=': return v != self.value
        if self.op == '>=': return v >= self.value
        if self.op == '<=': return v <= self.value
        if self.op == '>': return v > self.value
        if self.op == '<': return v < self.value
        if self.op == 'in': return v in self.value
        if self.op == 'not_in': return v not in self.value
        return False

    def __repr__(self):
        return f"{self.key} {self.op} {self.value}"

class DecisionNetRule:
    def __init__(self,
                 rule_id: str,
                 call: Call,
                 conditions: List[RuleCondition],
                 description: str = "",
                 is_negative: bool = False,
                 priority: int = 10):
        self.rule_id = rule_id
        self.call = call
        self.conditions = conditions
        self.description = description
        self.is_negative = is_negative
        self.priority = priority

    def matches(self, features: Dict[str, Any]) -> bool:
        return all(c.evaluate(features) for c in self.conditions)

    def __repr__(self):
        prefix = "NOT " if self.is_negative else ""
        return f"Rule({self.rule_id}: {prefix}{self.call} IF {self.conditions})"

class IntersectionNode:
    """
    Represents an intersection where multiple rules fire simultaneously.
    Can have an attached learned refinement classifier (e.g. ID3 tree).
    """
    def __init__(self, rule_ids: Tuple[str, ...]):
        self.rule_ids = tuple(sorted(rule_ids))
        self.refinement_classifier: Optional[Any] = None

    def attach_refinement(self, classifier: Any):
        self.refinement_classifier = classifier

    def resolve(self, features: Dict[str, Any], candidate_actions: Set[Call]) -> Set[Call]:
        if self.refinement_classifier is not None:
            # Classifier predicts a single call or narrowed set
            predicted = self.refinement_classifier.predict(features)
            if isinstance(predicted, Call):
                return {predicted}
            elif isinstance(predicted, (set, list)):
                return set(predicted)
        return candidate_actions

class DecisionNet:
    """
    Selection Strategy φ(s) -> 2^A.
    Implements rule matching, conflict detection, intersection nodes, and local refinement trees.
    """
    def __init__(self, name: str = "DecisionNet"):
        self.name = name
        self.rules: List[DecisionNetRule] = []
        self.intersection_nodes: Dict[Tuple[str, ...], IntersectionNode] = {}
        self.wrapped_system: Optional[BiddingSystem] = None

    def add_rule(self, rule: DecisionNetRule):
        self.rules.append(rule)

    def attach_system(self, system: BiddingSystem):
        self.wrapped_system = system

    def attach_refinement(self, rule_ids: Tuple[str, ...], classifier: Any):
        key = tuple(sorted(rule_ids))
        if key not in self.intersection_nodes:
            self.intersection_nodes[key] = IntersectionNode(key)
        self.intersection_nodes[key].attach_refinement(classifier)

    def actions(self,
                hand: Hand,
                history: List[Call],
                my_seat: Seat = Seat.SOUTH,
                dealer: Seat = Seat.NORTH,
                vuln: int = 0) -> Set[Call]:
        """
        Evaluate partial state s and return candidate calls φ(s).
        """
        features = BridgeFeatures.extract_all(hand, history, my_seat, dealer, vuln)
        
        # 1. Evaluate explicit decision net rules
        positive_calls: Set[Call] = set()
        negative_calls: Set[Call] = set()
        matched_rule_ids: List[str] = []

        for r in self.rules:
            if r.matches(features):
                if r.is_negative:
                    negative_calls.add(r.call)
                else:
                    positive_calls.add(r.call)
                    matched_rule_ids.append(r.rule_id)

        # 2. If wrapped BiddingSystem is present, add its matched bid if any
        if self.wrapped_system is not None:
            sys_rule = self.wrapped_system.get_bid(history, hand)
            if sys_rule:
                positive_calls.add(sys_rule.call)
                matched_rule_ids.append(f"sys_{sys_rule.description or str(sys_rule.call)}")

        # Default fallback if no positive rules matched
        if not positive_calls:
            # Fallback: Pass
            candidate_calls = {Call(CallType.PASS)}
        else:
            candidate_calls = positive_calls - negative_calls
            if not candidate_calls:
                candidate_calls = {Call(CallType.PASS)}

        # 3. Check for intersection node refinement if multiple rules matched
        if len(matched_rule_ids) > 1:
            key = tuple(sorted(matched_rule_ids))
            if key in self.intersection_nodes:
                candidate_calls = self.intersection_nodes[key].resolve(features, candidate_calls)
            else:
                # Check for subset intersection keys
                for inter_key, inter_node in self.intersection_nodes.items():
                    if set(inter_key).issubset(set(matched_rule_ids)):
                        candidate_calls = inter_node.resolve(features, candidate_calls)
                        break

        # 4. Filter out illegal calls based on auction history
        last_bid: Optional[Call] = None
        last_np: Optional[Tuple[int, Call]] = None   # (seat_index, call)
        for i, call in enumerate(history):
            if call.type == CallType.BID:
                last_bid = call
            if call.type != CallType.PASS:
                last_np = (i, call)

        # Double/redouble availability (bridge legality):
        #   DOUBLE  : last non-pass action is an OPPONENT's bid, not already doubled
        #   REDOUBLE: our side's bid was just doubled by an opponent
        x_ok = False
        xx_ok = False
        if last_np is not None:
            idx, lc = last_np
            seat_of_lc = Seat((dealer.value + idx) % 4)
            opp_of_me = seat_of_lc not in (my_seat, my_seat.partner)
            if lc.type == CallType.BID:
                x_ok = opp_of_me
            elif lc.type == CallType.DOUBLE and opp_of_me:
                # they doubled our bid -> only we may redouble;
                # a further double by anyone is illegal
                j = idx - 1
                while j >= 0:
                    pc = history[j]
                    if pc.type != CallType.PASS:
                        ps_seat = Seat((dealer.value + j) % 4)
                        if pc.type == CallType.BID and ps_seat in (
                                my_seat, my_seat.partner):
                            xx_ok = True
                        break
                    j -= 1

        legal_calls: Set[Call] = set()
        for c in candidate_calls:
            if c.type == CallType.PASS:
                legal_calls.add(c)
            elif c.type == CallType.DOUBLE:
                if x_ok:
                    legal_calls.add(c)
            elif c.type == CallType.REDOUBLE:
                if xx_ok:
                    legal_calls.add(c)
            elif c.type == CallType.BID:
                if last_bid is None:
                    legal_calls.add(c)
                elif c.level > last_bid.level:
                    legal_calls.add(c)
                elif c.level == last_bid.level and c.strain.value > last_bid.strain.value:
                    legal_calls.add(c)

        if not legal_calls:
            legal_calls = {Call(CallType.PASS)}

        return legal_calls

    def clone(self) -> 'DecisionNet':
        new_net = DecisionNet(self.name)
        new_net.rules = list(self.rules)
        new_net.wrapped_system = self.wrapped_system
        for k, v in self.intersection_nodes.items():
            node = IntersectionNode(k)
            node.refinement_classifier = v.refinement_classifier
            new_net.intersection_nodes[k] = node
        return new_net

    def export_dsl(self) -> str:
        """Exports the current refined DecisionNet rules and attached ID3 exception trees to DSL code."""
        lines = [
            f"# ==========================================",
            f"# IMPROVED BIDDING SYSTEM: {self.name}",
            f"# Generated via Continuous Self-Improvement Pipeline",
            f"# ==========================================\n",
            "# --- Active Rules & Conventions ---"
        ]

        for r in self.rules:
            if r.is_negative:
                lines.append(f"\nRULE {r.rule_id}:")
                lines.append(f"  CALL: {r.call}")
                lines.append(f"  PRIORITY: {r.priority}")
                lines.append("  NEGATIVE: True")
                for c in r.conditions:
                    lines.append(f"  CONDITION: {c.key} {c.op} {c.value}")
                if r.description:
                    lines.append(f"  # {r.description}")
            call_str = str(r.call)
            lines.append(f"\nRULE {r.rule_id}:")
            lines.append(f"  CALL: {call_str}")
            lines.append(f"  PRIORITY: {r.priority}")
            for c in r.conditions:
                lines.append(f"  CONDITION: {c.key} {c.op} {c.value}")
            if r.description:
                lines.append(f"  # {r.description}")

        if self.intersection_nodes:
            lines.append("\n\n# --- Refined ID3 Exception Trees (Speedup Learning Splits) ---")
            for key, node in self.intersection_nodes.items():
                lines.append(f"\nINTERSECTION {' ^ '.join(key)}:")
                if node.refinement_classifier is not None and hasattr(node.refinement_classifier, "call"):
                    lines.append(f"  RESOLVED_CALL: {node.refinement_classifier.call}")
                    continue
                if node.refinement_classifier is not None and hasattr(node.refinement_classifier, "root"):
                    root = node.refinement_classifier.root
                    if root is not None:
                        if root.is_leaf:
                            lines.append(f"  RESOLVED_CALL: {root.prediction}")
                        else:
                            lines.append(f"  SPLIT_FEATURE: {root.feature_name}")
                            lines.append(f"  THRESHOLD: {root.threshold}")
                            if root.left_child and root.left_child.prediction:
                                lines.append(f"    IF <= {root.threshold} -> {root.left_child.prediction}")
                            if root.right_child and root.right_child.prediction:
                                lines.append(f"    IF >  {root.threshold} -> {root.right_child.prediction}")

        return "\n".join(lines) + "\n"

    def save_dsl(self, filepath: str) -> None:
        """Saves the refined bidding system DSL to a file on disk."""
        dsl_content = self.export_dsl()
        with open(filepath, "w") as f:
            f.write(dsl_content)

