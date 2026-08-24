import unittest
import random

from bid.models import Seat, Suit, Strain
from bid.sampling import Deal
from bid.sds import SDSScorer


class TestSDSScorer(unittest.TestCase):
    def _deal(self):
        import random as _r
        _r.seed(7)
        return Deal.random_deal(dealer=Seat.NORTH)

    def test_known_seats_preserved(self):
        deal = self._deal()
        scorer = SDSScorer(num_worlds=5, seed=1)
        worlds = scorer.sample_worlds(deal, (Seat.SOUTH, Seat.NORTH), 5, random.Random(1))
        unknown = [s for s in Seat if s not in (Seat.SOUTH, Seat.NORTH)]
        for cards_a, cards_b in worlds:
            self.assertEqual(len(cards_a), len(deal.hands[unknown[0]].cards))
            self.assertEqual(len(cards_b), len(deal.hands[unknown[1]].cards))
            combined = sorted((c.suit, c.rank.value) for c in cards_a + cards_b)
            truth = sorted((c.suit, c.rank.value) for s in unknown for c in deal.hands[s].cards)
            self.assertEqual(combined, truth)
        self.assertEqual(len(worlds), 5)

    def test_deterministic_with_seed(self):
        deal = self._deal()
        w1 = SDSScorer.sample_worlds(deal, (Seat.EAST, Seat.WEST), 4, random.Random(42))
        w2 = SDSScorer.sample_worlds(deal, (Seat.EAST, Seat.WEST), 4, random.Random(42))
        self.assertEqual(
            [[(c.suit, c.rank.value) for c in cs] for pair in w1 for cs in pair],
            [[(c.suit, c.rank.value) for c in cs] for pair in w2 for cs in pair])

    def test_score_contract_bounds(self):
        deal = self._deal()
        res = SDSScorer(num_worlds=6, seed=3).score_contract(
            deal, level=3, strain=Strain.NT, declarer=Seat.SOUTH, vuln=0)
        self.assertEqual(res.num_worlds, 6)
        self.assertTrue(-800 <= res.mean_score <= 800)
        self.assertTrue(0.0 <= res.p_make <= 1.0)
        self.assertTrue(0 <= res.mean_tricks <= 13)


    def test_conditioned_sampling_prefers_consistent_worlds(self):
        """Auction: N opens 1C, W overcalls 1S. Conditioned worlds must keep
        West's 5+ spade / 8+ HCP overcall holding far more often than uniform
        sampling (uniform ignores the auction entirely)."""
        import random
        from bid.models import Seat, Strain, Call, CallType
        from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition

        deal = self._deal()
        # dealer NORTH -> calls: N=1C, E=pass, W=1S overcall
        history = [Call(CallType.BID, 1, Strain.CLUBS),   # N
                   Call(CallType.PASS),                    # E
                   Call(CallType.PASS),                    # S (fixed hand)
                   Call(CallType.BID, 1, Strain.SPADES)]   # W overcall

        net = DecisionNet("cond")
        net.add_rule(DecisionNetRule(
            "T_OPEN_1C", Call(CallType.BID, 1, Strain.CLUBS),
            [RuleCondition("is_opening", "==", True),
             RuleCondition("hcp", ">=", 12),
             RuleCondition("club_len", ">=", 3)], priority=20))
        net.add_rule(DecisionNetRule(
            "T_OVERCALL_1S", Call(CallType.BID, 1, Strain.SPADES),
            [RuleCondition("is_competitive", "==", True),
             RuleCondition("spade_len", ">=", 5),
             RuleCondition("hcp", ">=", 8)], priority=22))
        models = {s: net for s in Seat}

        rng = random.Random(5)
        worlds_all = SDSScorer.sample_world_dicts(
            deal, (Seat.NORTH, Seat.SOUTH), 100, rng)

        def west_ok(w):
            return len([c for c in w[Seat.WEST]
                        if c.suit.name == "SPADES"]) >= 5

        uniform_frac = sum(west_ok(w) for w in worlds_all[:100]) / 100.0

        scorer = SDSScorer(num_worlds=30, seed=9, condition_factor=8)
        kept, incs = scorer._select_consistent(
            deal, (Seat.NORTH, Seat.SOUTH), history, models, 30,
            random.Random(9))
        cond_frac = sum(west_ok(w) for w in kept) / len(kept)

        self.assertGreater(cond_frac, uniform_frac + 0.25,
                           f"uniform {uniform_frac:.2f} vs conditioned {cond_frac:.2f}")
        self.assertEqual(len(kept), 30)

if __name__ == "__main__":
    unittest.main()


    def test_conditioned_sampling_prefers_consistent_worlds(self):
        """With an auction where West opened 1S, conditioned worlds keep
        West's 5+ spade holding far more often than uniform sampling."""
        import random
        from bid.models import Seat, Strain, Call, CallType
        from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition

        deal = self._deal()
        # force a West 1S opening auction against this fixed N/S
        history = [Call(CallType.BID, 1, Strain.SPADES)]

        net = DecisionNet("cond")
        net.add_rule(DecisionNetRule(
            "T_OPEN_1S", Call(CallType.BID, 1, Strain.SPADES),
            [RuleCondition("is_opening", "==", True),
             RuleCondition("spade_len", ">=", 5),
             RuleCondition("hcp", ">=", 8)], priority=20))
        models = {s: net for s in Seat}

        rng = random.Random(5)
        worlds_all = SDSScorer.sample_world_dicts(
            deal, (Seat.NORTH, Seat.SOUTH), 200, rng)

        def west_spades_ok(w):
            return len([c for c in w[Seat.WEST]
                        if c.suit.name == "SPADES"]) >= 5

        uniform_frac = sum(west_spades_ok(w) for w in worlds_all[:100]) / 100.0

        scorer = SDSScorer(num_worlds=30, seed=9, condition_factor=8)
        kept, incs = scorer._select_consistent(
            deal, (Seat.NORTH, Seat.SOUTH), history, models, 30,
            random.Random(9))
        cond_frac = sum(west_spades_ok(w) for w in kept) / len(kept)

        self.assertGreater(cond_frac, uniform_frac + 0.25,
                           f"uniform {uniform_frac:.2f} vs conditioned {cond_frac:.2f}")
        self.assertEqual(len(kept), 30)


if __name__ == "__main__":
    unittest.main()

    def test_conditioned_sampling_prefers_consistent_worlds(self):
        """With an auction where West opened 1S, conditioned worlds keep
        West's 5+ spade holding far more often than uniform sampling."""
        import random
        from bid.models import Seat, Strain, Call, CallType
        from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition

        deal = self._deal()
        # force a West 1S opening auction against this fixed N/S
        history = [Call(CallType.BID, 1, Strain.SPADES)]

        net = DecisionNet("cond")
        net.add_rule(DecisionNetRule(
            "T_OPEN_1S", Call(CallType.BID, 1, Strain.SPADES),
            [RuleCondition("is_opening", "==", True),
             RuleCondition("spade_len", ">=", 5),
             RuleCondition("hcp", ">=", 8)], priority=20))
        models = {s: net for s in Seat}

        rng = random.Random(5)
        worlds_all = SDSScorer.sample_world_dicts(
            deal, (Seat.NORTH, Seat.SOUTH), 200, rng)

        def west_spades_ok(w):
            return len([c for c in w[Seat.WEST]
                        if c.suit.name == "SPADES"]) >= 5

        uniform_frac = sum(west_spades_ok(w) for w in worlds_all[:100]) / 100.0

        scorer = SDSScorer(num_worlds=30, seed=9, condition_factor=8)
        kept, incs = scorer._select_consistent(
            deal, (Seat.NORTH, Seat.SOUTH), history, models, 30,
            random.Random(9))
        cond_frac = sum(west_spades_ok(w) for w in kept) / len(kept)

        self.assertGreater(cond_frac, uniform_frac + 0.25,
                           f"uniform {uniform_frac:.2f} vs conditioned {cond_frac:.2f}")
        self.assertEqual(len(kept), 30)
