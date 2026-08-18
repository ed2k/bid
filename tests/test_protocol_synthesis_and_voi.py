import unittest
from bid.models import Hand, Seat, Call, CallType, Strain
from bid.decision_net import DecisionNet
from bid.sampling import Deal, PartialState
from bid.pidm import PIDMEngine
from bid.protocol import ConventionProtocol, ProtocolStep, ProtocolOpType, ValueOfInformationEvaluator, AdversarialSignalingEvaluator

class TestProtocolSynthesisAndVOI(unittest.TestCase):

    def test_protocol_rule_compilation(self):
        stayman = ConventionProtocol.create_stayman()
        rules = stayman.compile_to_rules()
        self.assertGreaterEqual(len(rules), 2)

        # Apply Stayman to DecisionNet
        net = DecisionNet("1NT_System")
        for r in rules:
            net.add_rule(r)

        # History: 1NT - 2C. Opener with 4 hearts should bid 2H
        opener_hand_hearts = Hand.from_string("SA4 HKJ43 DQ432 CA3")
        history = [Call(CallType.BID, 1, Strain.NT), Call(CallType.BID, 2, Strain.CLUBS)]
        actions = net.actions(opener_hand_hearts, history)
        self.assertIn(Call(CallType.BID, 2, Strain.HEARTS), actions)

        # Opener with 2 hearts should bid 2D
        opener_hand_no_major = Hand.from_string("SA4 HK4 DQJ432 CA43")
        actions_no_m = net.actions(opener_hand_no_major, history)
        self.assertIn(Call(CallType.BID, 2, Strain.DIAMONDS), actions_no_m)

    def test_jacoby_transfer_compilation(self):
        jacoby = ConventionProtocol.create_jacoby_transfer()
        rules = jacoby.compile_to_rules()
        self.assertGreaterEqual(len(rules), 1)

        net = DecisionNet("JacobyNet")
        for r in rules:
            net.add_rule(r)

        opener_hand = Hand.from_string("SAK4 H432 DK432 CA3")
        history = [Call(CallType.BID, 1, Strain.NT), Call(CallType.BID, 2, Strain.DIAMONDS)]
        actions = net.actions(opener_hand, history)
        self.assertIn(Call(CallType.BID, 2, Strain.HEARTS), actions)

    def test_blackwood_step_encoding(self):
        blackwood = ConventionProtocol.create_blackwood()
        rules = blackwood.compile_to_rules()

        net = DecisionNet("BlackwoodNet")
        for r in rules:
            net.add_rule(r)

        # Partner has 2 aces
        hand_2_aces = Hand.from_string("SA4 HA32 DK432 CT98")
        self.assertEqual(hand_2_aces.ace_count, 2)

        history = [Call(CallType.BID, 4, Strain.NT)]
        actions = net.actions(hand_2_aces, history)
        self.assertIn(Call(CallType.BID, 5, Strain.HEARTS), actions)

    def test_value_of_information(self):
        engine = PIDMEngine()
        voi_eval = ValueOfInformationEvaluator(engine)

        stayman = ConventionProtocol.create_stayman()
        step = stayman.steps[0]

        # States facing 1NT opening
        states = []
        for _ in range(3):
            states.append(PartialState(Seat.NORTH, Hand.random(), [Call(CallType.BID, 1, Strain.NT), Call(CallType.BID, 2, Strain.CLUBS)]))

        models = {s: DecisionNet(f"M_{s}") for s in Seat}
        voi = voi_eval.evaluate_voi(step, states, models)
        self.assertGreaterEqual(voi, 0.0)

if __name__ == "__main__":
    unittest.main()
