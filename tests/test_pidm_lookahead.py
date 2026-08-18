import unittest
from bid.models import Hand, Seat, Call, CallType, Strain
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.sampling import Deal, PartialState
from bid.pidm import PIDMEngine

class TestPIDMLookahead(unittest.TestCase):

    def setUp(self):
        self.models = {}
        for s in Seat:
            net = DecisionNet(f"Model_{s}")
            # 1H opening
            net.add_rule(DecisionNetRule(
                rule_id="R_1H",
                call=Call(CallType.BID, 1, Strain.HEARTS),
                conditions=[
                    RuleCondition("hcp", ">=", 12),
                    RuleCondition("heart_len", ">=", 5)
                ],
                priority=20
            ))
            # 2H Raise response
            net.add_rule(DecisionNetRule(
                rule_id="R_2H",
                call=Call(CallType.BID, 2, Strain.HEARTS),
                conditions=[
                    RuleCondition("hcp", ">=", 6),
                    RuleCondition("hcp", "<=", 10),
                    RuleCondition("heart_len", ">=", 3)
                ],
                priority=15
            ))
            # 4H Game bid
            net.add_rule(DecisionNetRule(
                rule_id="R_4H",
                call=Call(CallType.BID, 4, Strain.HEARTS),
                conditions=[
                    RuleCondition("hcp", ">=", 13),
                    RuleCondition("heart_len", ">=", 5)
                ],
                priority=25
            ))
            self.models[s] = net

        self.engine = PIDMEngine()

    def test_single_candidate_fast_path(self):
        # Hand matches only 1H (12 HCP, 5 hearts)
        hand = Hand.from_string("SKQ4 HKJ432 DK43 C43") # 12 HCP (KQ=5, KJ=4, K=3), 5 hearts
        ps = PartialState(Seat.NORTH, hand, [], dealer=Seat.NORTH)

        call, values = self.engine.decide(ps, self.models)
        self.assertEqual(call, Call(CallType.BID, 1, Strain.HEARTS))

    def test_multi_candidate_evaluation(self):
        # Explicitly give candidate actions: Pass vs 4H
        hand = Hand.from_string("SAKQ3 HKQJ43 DA2 C32") # 20 HCP, 5 hearts
        history = [
            Call(CallType.BID, 1, Strain.HEARTS),
            Call(CallType.PASS),
            Call(CallType.BID, 2, Strain.HEARTS),
            Call(CallType.PASS)
        ]
        ps = PartialState(Seat.NORTH, hand, history, dealer=Seat.NORTH)

        candidates = {Call(CallType.PASS), Call(CallType.BID, 4, Strain.HEARTS)}
        call, values = self.engine.decide(ps, self.models, candidate_actions=candidates)

        # 4H should have higher expected utility than Pass when holding 20 HCP and 5 hearts facing a 2H raise
        self.assertEqual(call, Call(CallType.BID, 4, Strain.HEARTS))
        self.assertGreater(values[Call(CallType.BID, 4, Strain.HEARTS)], values[Call(CallType.PASS)])

if __name__ == "__main__":
    unittest.main()
