import unittest
from bid.models import Hand, Seat, Call, CallType, Strain
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.learner import ID3DecisionTree, DecisionNetLearner

class TestID3Refinement(unittest.TestCase):

    def test_id3_information_gain_and_split(self):
        # Create dataset as in research document section 17:
        # Hands with 15-17 HCP, balanced, 5 hearts
        # heart_hcp <= 8 -> 1NT
        # heart_hcp > 8 -> 1H
        X = [
            {"hcp": 15, "heart_hcp": 6, "controls": 3, "heart_len": 5, "is_balanced": True},
            {"hcp": 16, "heart_hcp": 7, "controls": 3, "heart_len": 5, "is_balanced": True},
            {"hcp": 16, "heart_hcp": 8, "controls": 4, "heart_len": 5, "is_balanced": True},
            {"hcp": 17, "heart_hcp": 8, "controls": 3, "heart_len": 5, "is_balanced": True},
            {"hcp": 15, "heart_hcp": 9, "controls": 2, "heart_len": 5, "is_balanced": True},
            {"hcp": 16, "heart_hcp": 9, "controls": 3, "heart_len": 5, "is_balanced": True},
            {"hcp": 16, "heart_hcp": 10, "controls": 4, "heart_len": 5, "is_balanced": True},
            {"hcp": 17, "heart_hcp": 11, "controls": 3, "heart_len": 5, "is_balanced": True},
        ]
        y = [
            Call(CallType.BID, 1, Strain.NT),
            Call(CallType.BID, 1, Strain.NT),
            Call(CallType.BID, 1, Strain.NT),
            Call(CallType.BID, 1, Strain.NT),
            Call(CallType.BID, 1, Strain.HEARTS),
            Call(CallType.BID, 1, Strain.HEARTS),
            Call(CallType.BID, 1, Strain.HEARTS),
            Call(CallType.BID, 1, Strain.HEARTS),
        ]

        tree = ID3DecisionTree(max_depth=3)
        tree.fit(X, y)

        # Test predictions on new hands
        test_nt = {"hcp": 16, "heart_hcp": 7, "controls": 3, "heart_len": 5, "is_balanced": True}
        test_h = {"hcp": 16, "heart_hcp": 10, "controls": 4, "heart_len": 5, "is_balanced": True}

        self.assertEqual(tree.predict(test_nt), Call(CallType.BID, 1, Strain.NT))
        self.assertEqual(tree.predict(test_h), Call(CallType.BID, 1, Strain.HEARTS))

    def test_decision_net_refinement_attachment(self):
        net = DecisionNet("TestNet")
        # Rule 1: 1NT (15-17 HCP, balanced)
        net.add_rule(DecisionNetRule(
            rule_id="R1_1NT",
            call=Call(CallType.BID, 1, Strain.NT),
            conditions=[
                RuleCondition("hcp", ">=", 15),
                RuleCondition("hcp", "<=", 17),
                RuleCondition("is_balanced", "==", True)
            ]
        ))
        # Rule 2: 1H (12-21 HCP, 5+ hearts)
        net.add_rule(DecisionNetRule(
            rule_id="R2_1H",
            call=Call(CallType.BID, 1, Strain.HEARTS),
            conditions=[
                RuleCondition("hcp", ">=", 12),
                RuleCondition("hcp", "<=", 21),
                RuleCondition("heart_len", ">=", 5)
            ]
        ))

        # Hand with 16 HCP, 5 hearts, balanced (3 spades, 5 hearts, 3 diamonds, 2 clubs)
        hand_low_heart_hcp = Hand.from_string("SAK4 H76543 DAQ3 CK2") # 16 HCP, 5 hearts with 0 heart HCP
        actions_before = net.actions(hand_low_heart_hcp, [])
        # actions() now returns a priority-ordered LIST of candidates
        self.assertEqual(set(actions_before), {Call(CallType.BID, 1, Strain.NT), Call(CallType.BID, 1, Strain.HEARTS)})
        self.assertEqual(actions_before[0], Call(CallType.BID, 1, Strain.HEARTS))  # tie -> call-string order

        # Train and attach refinement to ("R1_1NT", "R2_1H")
        tree = ID3DecisionTree(max_depth=3)
        X = [
            {"hcp": 16, "heart_hcp": 0, "heart_len": 5, "is_balanced": True},
            {"hcp": 16, "heart_hcp": 10, "heart_len": 5, "is_balanced": True}
        ]
        y = [
            Call(CallType.BID, 1, Strain.NT),
            Call(CallType.BID, 1, Strain.HEARTS)
        ]
        tree.fit(X, y)

        net.attach_refinement(("R1_1NT", "R2_1H"), tree)

        # After refinement: resolved to single call {1NT} for low heart HCP hand
        actions_after = net.actions(hand_low_heart_hcp, [])
        self.assertEqual(actions_after, [Call(CallType.BID, 1, Strain.NT)])

if __name__ == "__main__":
    unittest.main()
