import unittest
from bid.models import Seat, Hand, Call, CallType, Strain
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.sampling import Deal, PartialState
from bid.pidm import PIDMEngine
from bid.cotrain import CoTrainer

class TestCoTraining(unittest.TestCase):

    def setUp(self):
        self.nets = {}
        for s in Seat:
            net = DecisionNet(f"System_{s}")
            net.add_rule(DecisionNetRule(
                rule_id="R_1NT",
                call=Call(CallType.BID, 1, Strain.NT),
                conditions=[
                    RuleCondition("hcp", ">=", 15),
                    RuleCondition("hcp", "<=", 17),
                    RuleCondition("is_balanced", "==", True)
                ]
            ))
            net.add_rule(DecisionNetRule(
                rule_id="R_1H",
                call=Call(CallType.BID, 1, Strain.HEARTS),
                conditions=[
                    RuleCondition("hcp", ">=", 12),
                    RuleCondition("hcp", "<=", 21),
                    RuleCondition("heart_len", ">=", 5)
                ]
            ))
            self.nets[s] = net

        self.teacher = PIDMEngine()

    def test_co_training_execution(self):
        cotrainer = CoTrainer(
            self.teacher,
            self.nets[Seat.NORTH],
            self.nets[Seat.SOUTH],
            self.nets[Seat.EAST],
            self.nets[Seat.WEST]
        )

        stats = cotrainer.run_training_round(num_states_per_seat=4)
        self.assertIn("north_trained_examples", stats)
        self.assertIn("south_trained_examples", stats)

if __name__ == "__main__":
    unittest.main()
