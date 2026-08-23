import random
import unittest

from bid.models import Seat, Suit, Strain, Card, Rank
from bid.dds import DDSolver
from bid.sds import (PlayPosition, PlaySearcher, SearchConfig,
                     legal_cards, trick_winner)


def make_cards(specs):
    return [Card(suit, Rank(v)) for suit, v in specs]


class TestTrickMechanics(unittest.TestCase):
    def test_high_card_of_led_suit_wins(self):
        trick = [(Seat.NORTH, Card(Suit.HEARTS, Rank.FIVE)),
                 (Seat.EAST, Card(Suit.HEARTS, Rank.TEN)),
                 (Seat.SOUTH, Card(Suit.HEARTS, Rank.TWO)),
                 (Seat.WEST, Card(Suit.HEARTS, Rank.SEVEN))]
        self.assertEqual(trick_winner(trick, Strain.NT), Seat.EAST)

    def test_trump_beats_led_suit(self):
        trick = [(Seat.NORTH, Card(Suit.HEARTS, Rank.ACE)),
                 (Seat.EAST, Card(Suit.CLUBS, Rank.TWO)),
                 (Seat.SOUTH, Card(Suit.HEARTS, Rank.KING)),
                 (Seat.WEST, Card(Suit.SPADES, Rank.THREE))]
        self.assertEqual(trick_winner(trick, Strain.CLUBS), Seat.EAST)

    def test_higher_trump_wins(self):
        trick = [(Seat.NORTH, Card(Suit.CLUBS, Rank.QUEEN)),
                 (Seat.EAST, Card(Suit.DIAMONDS, Rank.ACE)),
                 (Seat.SOUTH, Card(Suit.CLUBS, Rank.KING)),
                 (Seat.WEST, Card(Suit.HEARTS, Rank.ACE))]
        self.assertEqual(trick_winner(trick, Strain.CLUBS), Seat.SOUTH)

    def test_discard_does_not_win(self):
        trick = [(Seat.NORTH, Card(Suit.SPADES, Rank.SIX)),
                 (Seat.EAST, Card(Suit.HEARTS, Rank.ACE)),
                 (Seat.SOUTH, Card(Suit.DIAMONDS, Rank.ACE)),
                 (Seat.WEST, Card(Suit.CLUBS, Rank.ACE))]
        self.assertEqual(trick_winner(trick, Strain.NT), Seat.NORTH)

    def test_must_follow_suit(self):
        hand = make_cards([(Suit.SPADES, Rank.FOUR), (Suit.SPADES, Rank.NINE),
                           (Suit.HEARTS, Rank.KING)])
        trick = [(Seat.NORTH, Card(Suit.SPADES, Rank.QUEEN))]
        legal = legal_cards(hand, trick)
        self.assertEqual(len(legal), 2)
        self.assertTrue(all(c.suit == Suit.SPADES for c in legal))
        self.assertEqual(legal_cards(hand, []), hand)


# ------------------------------------------------------------------
# Independent exhaustive minimax oracle
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# Searcher cross-validation against native DD and the oracle
# ------------------------------------------------------------------

def reduced_endgame(seed):
    """Random 3-trick endgame: 3 cards per hand from a 12-card pool."""
    rng = random.Random(seed)
    pool = [Card(s, Rank(v)) for s in Suit
            for v in range(Rank.SEVEN.value, Rank.ACE.value + 1)]
    chosen = rng.sample(pool, 12)
    rng.shuffle(chosen)
    hands = {Seat.NORTH: chosen[0:3], Seat.EAST: chosen[3:6],
             Seat.SOUTH: chosen[6:9], Seat.WEST: chosen[9:12]}
    trump = rng.choice([Strain.NT, Strain.SPADES, Strain.HEARTS,
                        Strain.DIAMONDS, Strain.CLUBS])
    return hands, trump


def variant_worlds(hands, n_worlds, seed):
    """Keeps N/S fixed, reshuffles the E/W six cards between E and W."""
    rng = random.Random(seed)
    hidden = list(hands[Seat.EAST]) + list(hands[Seat.WEST])
    out = []
    for _ in range(n_worlds):
        rng.shuffle(hidden)
        w = dict(hands)
        w[Seat.EAST] = list(hidden[:3])
        w[Seat.WEST] = list(hidden[3:])
        out.append(w)
    return out


def make_pos(hands, trump):
    return PlayPosition(hands={s: list(hands[s]) for s in Seat},
                        trump=trump, declarer=Seat.NORTH,
                        to_play=Seat.NORTH, leader=Seat.NORTH,
                        trick=[], tricks_max=0, tricks_min=0)


class TestPlaySearch(unittest.TestCase):
    def test_full_depth_single_world_equals_dd(self):
        """Single world, exact search == native double-dummy value."""
        for seed in range(5):
            hands, trump = reduced_endgame(seed)
            pos = make_pos(hands, trump)
            worlds = [{s: list(hands[s]) for s in Seat}]
            searcher = PlaySearcher(SearchConfig(target=2))
            res = searcher.solve_pimc(pos, worlds)
            vec = res.per_move[res.best_card]
            truth = DDSolver.solve_position({sn: list(hands[sn]) for sn in Seat},
                                            DDSolver.strain_to_dds_index(trump),
                                            Seat.NORTH.value, [])
            self.assertAlmostEqual(vec.values[0], float(truth), places=6,
                                   msg=f"seed {seed}")

    def test_matches_native_dd_across_seeds(self):
        """Searcher best-line value equals native DD on every endgame."""
        for seed in range(6):
            hands, trump = reduced_endgame(seed)
            pos = make_pos(hands, trump)
            worlds = [{s: list(hands[s]) for s in Seat}]
            res = PlaySearcher(SearchConfig(target=2)).solve_pimc(pos, worlds)
            vec = res.per_move[res.best_card]
            truth = DDSolver.solve_position({s: list(hands[s]) for s in Seat},
                                            DDSolver.strain_to_dds_index(trump),
                                            Seat.NORTH.value, [])
            self.assertAlmostEqual(vec.values[0], float(truth), places=6,
                                   msg=f"seed {seed}")

    def test_multi_world_elementwise_never_beats_dd(self):
        for seed in range(3):
            hands, trump = reduced_endgame(seed)
            worlds = variant_worlds(hands, 4, seed + 300)
            pos = make_pos(hands, trump)
            searcher = PlaySearcher(SearchConfig(target=2))
            res = searcher.solve_pimc(pos, worlds)
            vec = res.per_move[res.best_card]
            tidx = DDSolver.strain_to_dds_index(trump)
            self.assertEqual(len(vec.values), len(worlds))
            for j, w in enumerate(worlds):
                truth = DDSolver.solve_position({sn: list(w[sn]) for sn in Seat},
                                                tidx, Seat.NORTH.value, [])
                self.assertLessEqual(vec.values[j], float(truth) + 1e-9,
                                     msg=f"seed {seed} world {j}")

    def test_deterministic_across_instances(self):
        hands, trump = reduced_endgame(77)
        pos = make_pos(hands, trump)
        worlds = [{s: list(hands[s]) for s in Seat}]
        r1 = PlaySearcher(SearchConfig(target=2)).solve_pimc(pos, worlds)
        r2 = PlaySearcher(SearchConfig(target=2)).solve_pimc(pos, worlds)
        self.assertEqual(r1.best_card, r2.best_card)
        self.assertEqual(r1.per_move[r1.best_card].values,
                         r2.per_move[r2.best_card].values)


if __name__ == "__main__":
    unittest.main()
