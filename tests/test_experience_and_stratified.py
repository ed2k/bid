import unittest
from bid.models import Suit, Seat, Hand, Call, CallType, Strain
from bid.experience import StratifiedDealGenerator, ExperienceBuffer, PrioritizedExperience, ExploratoryCandidateGenerator
from bid.sampling import PartialState
from bid.decision_net import DecisionNet

class TestExperienceAndStratified(unittest.TestCase):

    def test_stratified_deal_generator(self):
        # Generate 9-card spade hand
        hand_9s = StratifiedDealGenerator.generate_hand_with_suit_length(Suit.SPADES, 9)
        self.assertGreaterEqual(hand_9s.length(Suit.SPADES), 9)
        self.assertEqual(len(hand_9s.cards), 13)

        # Generate hand with HCP between 20 and 22
        hand_hcp = StratifiedDealGenerator.generate_hand_with_hcp_range(20, 22)
        self.assertGreaterEqual(hand_hcp.hcp, 20)
        self.assertLessEqual(hand_hcp.hcp, 22)
        self.assertEqual(len(hand_hcp.cards), 13)

        # Complete deal with 8-card heart hand
        deal = StratifiedDealGenerator.generate_stratified_deal(
            Seat.SOUTH,
            suit_stratum=(Suit.HEARTS, 8)
        )
        self.assertGreaterEqual(deal.hands[Seat.SOUTH].length(Suit.HEARTS), 8)

    def test_experience_buffer_priority(self):
        buf = ExperienceBuffer(max_capacity=50)

        # Normal hand
        normal_hand = Hand.from_string("SA4 HK32 D432 C4321")
        p1, r1 = buf.calculate_priority(normal_hand, {Call(CallType.PASS)}, Call(CallType.PASS))

        # Rare 9-spade hand with policy disagreement
        rare_hand = StratifiedDealGenerator.generate_hand_with_suit_length(Suit.SPADES, 9)
        p2, r2 = buf.calculate_priority(
            rare_hand,
            {Call(CallType.BID, 1, Strain.SPADES)},
            Call(CallType.BID, 4, Strain.SPADES),
            value_gap=100.0
        )

        self.assertGreater(p2, p1)

        ps = PartialState(Seat.SOUTH, rare_hand, [])
        exp = PrioritizedExperience(
            partial_state=ps,
            candidate_actions={Call(CallType.BID, 1, Strain.SPADES)},
            teacher_call=Call(CallType.BID, 4, Strain.SPADES),
            priority=p2,
            reason=r2
        )
        buf.add(exp)
        self.assertEqual(len(buf.buffer), 1)

        batch = buf.sample_batch(1)
        self.assertEqual(len(batch), 1)
        self.assertEqual(batch[0].reason, r2)

    def test_exploratory_candidate_generator(self):
        gen = ExploratoryCandidateGenerator(base_epsilon=1.0) # Always explore
        net = DecisionNet("EmptyNet")
        ps = PartialState(Seat.SOUTH, Hand.random(), [])

        candidates = gen.generate_candidates(ps, net, allow_exploration=True)
        # Should include opening bids
        self.assertIn(Call(CallType.BID, 1, Strain.NT), candidates)
        self.assertIn(Call(CallType.BID, 1, Strain.SPADES), candidates)

if __name__ == "__main__":
    unittest.main()
