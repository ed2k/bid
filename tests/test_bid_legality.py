import unittest
from bid.models import Seat, Suit, Strain, Rank, Call, CallType, Hand, Card
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition


def net_with_x():
    net = DecisionNet("legality")
    net.add_rule(DecisionNetRule(
        "X_ANY", Call(CallType.DOUBLE),
        [], priority=50))          # unconditional candidate; legality must filter
    net.add_rule(DecisionNetRule(
        "XX_ANY", Call(CallType.REDOUBLE),
        [], priority=50))
    net.add_rule(DecisionNetRule(
        "PASS_OK", Call(CallType.PASS), [], priority=1))
    return net


def call(lvl, letter):
    strain = {"C": Strain.CLUBS, "D": Strain.DIAMONDS,
              "H": Strain.HEARTS, "S": Strain.SPADES,
              "N": Strain.NT}[letter]
    return Call(CallType.BID, lvl, strain)


class TestDoubleLegality(unittest.TestCase):
    def setUp(self):
        self.net = net_with_x()
        self.hand = Hand([Card(Suit.SPADES, Rank.ACE)])

    def legal(self, history, seat, dealer=Seat.NORTH):
        return self.net.actions(self.hand, list(history), seat, dealer, 0)

    def test_no_double_before_any_bid(self):
        self.assertNotIn(Call(CallType.DOUBLE), self.legal([], Seat.NORTH))

    def test_double_available_over_opponent_bid(self):
        # N opens 1H, E to act -> X is legal
        hist = [call(1, "H")]
        got = self.legal(hist, Seat.EAST)
        self.assertIn(Call(CallType.DOUBLE), got)

    def test_no_double_of_partners_bid(self):
        # N opens 1H, S to act -> partner's bid cannot be doubled
        hist = [call(1, "H")]
        got = self.legal(hist, Seat.SOUTH)
        self.assertNotIn(Call(CallType.DOUBLE), got)

    def test_no_double_after_double(self):
        # N 1H, E X, S to act: double-after-double illegal
        hist = [call(1, "H"), Call(CallType.DOUBLE)]
        got = self.legal(hist, Seat.SOUTH)
        self.assertNotIn(Call(CallType.DOUBLE), got)

    def test_redouble_only_for_doubled_side(self):
        hist = [call(1, "H"), Call(CallType.DOUBLE)]
        # S is on the doubled side -> XX available
        self.assertIn(Call(CallType.REDOUBLE), self.legal(hist, Seat.SOUTH))
        # W is not -> XX unavailable
        self.assertNotIn(Call(CallType.REDOUBLE), self.legal(hist, Seat.WEST))
        # and W also cannot double again
        self.assertNotIn(Call(CallType.DOUBLE), self.legal(hist, Seat.WEST))


if __name__ == "__main__":
    unittest.main()
