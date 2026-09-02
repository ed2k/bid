from typing import List, Dict, Tuple, Optional, Any, Set
import math
from bid.models import Hand, Call, CallType, Seat
from bid.features import BridgeFeatures
from bid.decision_net import DecisionNet
from bid.sampling import Deal, PartialState
from bid.pidm import PIDMEngine

class ID3Node:
    def __init__(self,
                 feature_name: Optional[str] = None,
                 threshold: Optional[Any] = None,
                 is_continuous: bool = True,
                 is_leaf: bool = False,
                 prediction: Optional[Call] = None):
        self.feature_name = feature_name
        self.threshold = threshold
        self.is_continuous = is_continuous
        self.is_leaf = is_leaf
        self.prediction = prediction
        self.left_child: Optional['ID3Node'] = None  # <= threshold or == threshold
        self.right_child: Optional['ID3Node'] = None # > threshold or != threshold

    def predict(self, features: Dict[str, Any]) -> Call:
        if self.is_leaf:
            return self.prediction

        val = features.get(self.feature_name)
        if val is None:
            return self.prediction

        if self.is_continuous:
            if val <= self.threshold:
                return self.left_child.predict(features) if self.left_child else self.prediction
            else:
                return self.right_child.predict(features) if self.right_child else self.prediction
        else:
            if val == self.threshold:
                return self.left_child.predict(features) if self.left_child else self.prediction
            else:
                return self.right_child.predict(features) if self.right_child else self.prediction

    def __repr__(self):
        if self.is_leaf:
            return f"Leaf({self.prediction})"
        op = "<=" if self.is_continuous else "=="
        return f"Node({self.feature_name} {op} {self.threshold})"

class ID3DecisionTree:
    """
    ID3 Decision Tree Classifier using Shannon Information Gain.
    Handles continuous and categorical bridge features for multi-class call prediction.
    """
    def __init__(self, max_depth: int = 5, min_samples_split: int = 2):
        self.max_depth = max_depth
        self.min_samples_split = min_samples_split
        self.root: Optional[ID3Node] = None

    @staticmethod
    def calculate_entropy(labels: List[Call]) -> float:
        if not labels:
            return 0.0
        n = len(labels)
        counts: Dict[Call, int] = {}
        for l in labels:
            counts[l] = counts.get(l, 0) + 1

        entropy = 0.0
        for count in counts.values():
            p = count / n
            if p > 0:
                entropy -= p * math.log2(p)
        return entropy

    def majority_class(self, labels: List[Call]) -> Call:
        counts: Dict[Call, int] = {}
        for l in labels:
            counts[l] = counts.get(l, 0) + 1
        return max(counts, key=counts.get)

    def fit(self,
            features_list: List[Dict[str, Any]],
            labels: List[Call],
            candidate_features: Optional[List[str]] = None):
        if not features_list or not labels:
            self.root = ID3Node(is_leaf=True, prediction=Call(CallType.PASS))
            return

        if candidate_features is None:
            # Default to all numerical and boolean keys present
            sample_keys = list(features_list[0].keys())
            candidate_features = [k for k in sample_keys if isinstance(features_list[0].get(k), (int, float, bool))]

        self.root = self._build_tree(features_list, labels, candidate_features, depth=0)

    def _build_tree(self,
                    X: List[Dict[str, Any]],
                    y: List[Call],
                    features: List[str],
                    depth: int) -> ID3Node:
        # Base cases: pure node, max depth, or too few samples
        entropy = self.calculate_entropy(y)
        maj_call = self.majority_class(y)

        if entropy == 0.0 or depth >= self.max_depth or len(y) < self.min_samples_split:
            return ID3Node(is_leaf=True, prediction=maj_call)

        best_gain = -1.0
        best_feature = None
        best_threshold = None
        best_split: Optional[Tuple[List[int], List[int]]] = None

        n = len(y)

        for feat in features:
            values = [x.get(feat, 0) for x in X]
            unique_vals = sorted(list(set(values)))
            if len(unique_vals) <= 1:
                continue

            # Evaluate split points (midpoints between consecutive unique values)
            split_candidates = []
            for i in range(len(unique_vals) - 1):
                mid = (unique_vals[i] + unique_vals[i + 1]) / 2.0
                split_candidates.append(mid)

            for threshold in split_candidates:
                left_idx = [i for i, val in enumerate(values) if val <= threshold]
                right_idx = [i for i, val in enumerate(values) if val > threshold]

                if not left_idx or not right_idx:
                    continue

                left_y = [y[i] for i in left_idx]
                right_y = [y[i] for i in right_idx]

                h_left = self.calculate_entropy(left_y)
                h_right = self.calculate_entropy(right_y)

                gain = entropy - ((len(left_y) / n) * h_left + (len(right_y) / n) * h_right)

                if gain > best_gain:
                    best_gain = gain
                    best_feature = feat
                    best_threshold = threshold
                    best_split = (left_idx, right_idx)

        if best_gain <= 1e-6 or best_split is None:
            return ID3Node(is_leaf=True, prediction=maj_call)

        left_idx, right_idx = best_split
        left_X = [X[i] for i in left_idx]
        left_y = [y[i] for i in left_idx]
        right_X = [X[i] for i in right_idx]
        right_y = [y[i] for i in right_idx]

        node = ID3Node(feature_name=best_feature,
                       threshold=best_threshold,
                       is_continuous=True,
                       is_leaf=False,
                       prediction=maj_call)

        node.left_child = self._build_tree(left_X, left_y, features, depth + 1)
        node.right_child = self._build_tree(right_X, right_y, features, depth + 1)

        return node

    def predict(self, features: Dict[str, Any]) -> Call:
        if self.root is None:
            return Call(CallType.PASS)
        return self.root.predict(features)

class DecisionNetLearner:
    """
    Learner that refines a DecisionNet by finding ambiguous states (|φ(s)| > 1),
    labeling them with an expensive PIDM teacher, and fitting local ID3 trees at intersection nodes.
    """
    def __init__(self, teacher_engine: PIDMEngine):
        self.teacher = teacher_engine

    def find_ambiguous_states(self,
                              decision_net: DecisionNet,
                              target_count: int = 20,
                              max_attempts: int = 500,
                              dealer: Seat = Seat.NORTH) -> List[PartialState]:
        ambiguous: List[PartialState] = []
        attempts = 0

        while len(ambiguous) < target_count and attempts < max_attempts:
            attempts += 1
            deal = Deal.random_deal(dealer=dealer)
            p_state = PartialState(Seat.SOUTH, deal.hands[Seat.SOUTH], [], dealer=dealer)
            actions = decision_net.actions(p_state.my_hand, p_state.history, p_state.my_seat, dealer)
            if len(actions) > 1:
                ambiguous.append(p_state)

        return ambiguous

    def tag_states(self,
                   states: List[PartialState],
                   models: Dict[Seat, DecisionNet]) -> List[Tuple[Dict[str, Any], Call, Tuple[str, ...]]]:
        """
        Runs expensive PIDM on ambiguous states to generate training tuples:
        (features, best_call, matched_rule_ids)
        """
        labeled_data = []
        for p_state in states:
            best_call, _ = self.teacher.decide(p_state, models)
            features = BridgeFeatures.extract_all(p_state.my_hand, p_state.history, p_state.my_seat, p_state.dealer)
            
            # Identify matched rules
            matched_ids = []
            for r in models[p_state.my_seat].rules:
                if r.matches(features) and not r.is_negative:
                    matched_ids.append(r.rule_id)

            if len(matched_ids) > 1:
                labeled_data.append((features, best_call, tuple(sorted(matched_ids))))

        return labeled_data

    def refine_decision_net(self,
                            decision_net: DecisionNet,
                            labeled_data: List[Tuple[Dict[str, Any], Call, Tuple[str, ...]]]):
        """
        Groups labeled examples by intersection node, fits an ID3DecisionTree for each group,
        and attaches the tree to the decision net.
        """
        # Group by intersection key
        groups: Dict[Tuple[str, ...], Tuple[List[Dict[str, Any]], List[Call]]] = {}
        for features, call, key in labeled_data:
            if key not in groups:
                groups[key] = ([], [])
            groups[key][0].append(features)
            groups[key][1].append(call)

        for key, (X, y) in groups.items():
            if len(X) >= 1:
                tree = ID3DecisionTree(max_depth=4)
                tree.fit(X, y)
                decision_net.attach_refinement(key, tree)
