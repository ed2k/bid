import unittest
from bid.models import Hand, Seat, Call, CallType, Strain
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.sampling import Deal, PartialState, RBMBMCSampler, calculate_inconsistency

class TestRBMBMCSampling(unittest.TestCase):

    def setUp(self):
        self.models = {}
        for s in Seat:
            net = DecisionNet(f"Model_{s}")
            # 1H opening if hearts >= 5 and HCP >= 12
            net.add_rule(DecisionNetRule(
                rule_id="R_1H",
                call=Call(CallType.BID, 1, Strain.HEARTS),
                conditions=[
                    RuleCondition("hcp", ">=", 12),
                    RuleCondition("heart_len", ">=", 5)
                ],
                priority=20
            ))
            # 1S opening if spades >= 5 and HCP >= 12
            net.add_rule(DecisionNetRule(
                rule_id="R_1S",
                call=Call(CallType.BID, 1, Strain.SPADES),
                conditions=[
                    RuleCondition("hcp", ">=", 12),
                    RuleCondition("spade_len", ">=", 5)
                ],
                priority=20
            ))
            self.models[s] = net

    def test_inconsistency_calculation(self):
        # North opened 1H
        history = [Call(CallType.BID, 1, Strain.HEARTS)]

        # Consistent deal: North has 13 HCP and 5 hearts
        north_hand_consistent = Hand.from_string("SAK4 HKQJ43 D432 C43") # 13 HCP, 5 hearts
        deal_consistent = Deal.completion_from_known(Seat.NORTH, north_hand_consistent)
        score_consistent = calculate_inconsistency(deal_consistent, history, self.models, dealer=Seat.NORTH)
        self.assertEqual(score_consistent, 0)

        # Inconsistent deal: North has 6 HCP and 2 hearts
        north_hand_inconsistent = Hand.from_string("S432 H43 D432 CA432") # 4 HCP, 2 hearts
        deal_inconsistent = Deal.completion_from_known(Seat.NORTH, north_hand_inconsistent)
        score_inconsistent = calculate_inconsistency(deal_inconsistent, history, self.models, dealer=Seat.NORTH)
        self.assertEqual(score_inconsistent, 1)

    def test_rbmbmc_sampler_selection(self):
        # Auction: North 1H - East Pass - South 2H - West Pass
        history = [
            Call(CallType.BID, 1, Strain.HEARTS),
            Call(CallType.PASS),
            Call(CallType.BID, 2, Strain.HEARTS),
            Call(CallType.PASS)
        ]
        south_hand = Hand.from_string("SK43 HA32 DQ852 CK64")
        ps = PartialState(Seat.SOUTH, south_hand, history, dealer=Seat.NORTH)

        sampler = RBMBMCSampler(sample_size=3, max_iterations=40, timeout_sec=0.5)
        worlds = sampler.sample(ps, self.models)

        self.assertEqual(len(worlds), 3)
        # All sampled worlds must have South's known cards fixed
        for w in worlds:
            self.assertEqual(w.hands[Seat.SOUTH].cards, south_hand.cards)
            # The inconsistency should be scored
            score = calculate_inconsistency(w, history, self.models, dealer=Seat.NORTH)
            self.assertGreaterEqual(score, 0)

if __name__ == "__main__":
    unittest.main()
