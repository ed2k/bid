"""Tests for the counterfactual label in `research/brill_distill.py`.

`--relabel` scored each call by what the board *paid* after Brill finished
the auction, and that label cost −1.95 IMP/board (§6.82): it is on-policy
with respect to Brill's continuation, so within a leaf it compares which
*deals* each call was made on, and the argmax mines noise (§6.83).
`--relabel-dd` scores each call by the double-dummy value of the contract
it would produce, which is a function of the deal alone.

That only pays if the value is right, and it can be wrong silently — a
wrong sign, a wrong declarer, or a call scored at a position where it is
illegal all produce a plausible-looking number and a worse model. The
traps this covers:

* **side attribution.** The value must be from the caller's point of view.
  Sign-flipping it would make PASS look wonderful whenever the opponents
  are going down.
* **legality.** A bid below the one it follows is dropped by
  `DecisionNet.actions` and becomes a PASS, so scoring it as if it stood
  would relabel leaves with calls that can never be made.
* **doubles belong to the bid they follow.** `4H X` is not `4H`, and PASS
  over a doubled contract is not PASS over an undoubled one.
* **declarer is the partnership's choice**, so take the better of the two
  seats rather than the caller's own.
"""
import os
import sys

import pytest

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))
sys.path.insert(0, os.path.join(REPO, "research"))

from bid.brill.convert import seat_from_letter                      # noqa: E402
from bid.models import Seat, Strain                                 # noqa: E402
from brill_distill import (best_side_score, bid_beats, call_value,  # noqa: E402
                           last_bid, side_tricks, signed_imps)

N = seat_from_letter("N")

# NS take 10 tricks in hearts (game), 9 in spades (partscore+1);
# EW take 9 in spades and only 3 in hearts.
TRICKS = {"HEARTS:NORTH": 10, "HEARTS:SOUTH": 9,
          "HEARTS:EAST": 3, "HEARTS:WEST": 3,
          "SPADES:NORTH": 4, "SPADES:SOUTH": 9,
          "SPADES:EAST": 9, "SPADES:WEST": 8,
          "CLUBS:NORTH": 6, "CLUBS:SOUTH": 6,
          "CLUBS:EAST": 6, "CLUBS:WEST": 6}


# --- the pieces --------------------------------------------------------

def test_last_bid_records_the_bidder_and_ignores_passes():
    lvl, strain, seat, dbl = last_bid(["1H", "P", "2S"], N)
    assert (lvl, strain, seat, dbl) == (2, Strain.SPADES, Seat.SOUTH, 0)


def test_a_double_attaches_to_the_bid_it_follows():
    assert last_bid(["1H", "P", "2S", "X"], N)[3] == 1
    assert last_bid(["1H", "P", "2S", "X", "XX"], N)[3] == 2


def test_no_bid_yet_means_no_contract():
    assert last_bid([], N) is None
    assert last_bid(["P", "P"], N) is None


def test_legality_is_level_then_strain():
    last = last_bid(["2S"], N)
    assert bid_beats(3, Strain.HEARTS, last)
    assert bid_beats(2, Strain.NT, last)          # same level, higher strain
    assert not bid_beats(2, Strain.HEARTS, last)
    assert bid_beats(1, Strain.CLUBS, None)       # opening bid


def test_the_partnership_gets_its_better_declarer():
    # SOUTH takes 9 spade tricks, NORTH only 4: the side plays it from
    # SOUTH whichever of them is on lead.
    assert side_tricks(TRICKS, Strain.SPADES, Seat.NORTH) == 9
    assert side_tricks(TRICKS, Strain.SPADES, Seat.EAST) == 9


# --- the value ---------------------------------------------------------

def test_a_game_bid_is_worth_the_game_bonus():
    # 4H non-vulnerable making 10 = 120 + 300.
    assert call_value("4H", [], N, 0, TRICKS) == 420.0


def test_a_bid_that_cannot_be_made_has_no_value():
    """`DecisionNet.actions` drops it and falls back to PASS, so scoring it
    as a real contract would relabel leaves with unreachable calls."""
    assert call_value("2H", ["1H", "P", "2S"], N, 0, TRICKS) is None


def test_pass_over_no_bid_is_worth_nothing():
    assert call_value("PASS", [], N, 0, TRICKS) == 0.0


def test_values_are_from_the_callers_side_not_ns():
    """The label is 'points for us'. If it were NS's score, every PASS in
    front of a failing enemy contract would look like a winning call."""
    # 2S by SOUTH (index 2). Caller at index 3 is WEST — defending, so the
    # 140 NS score for 2S+1 is a cost, not a gain.
    assert call_value("PASS", ["1H", "P", "2S"], N, 0, TRICKS) == -140.0
    # Caller at index 6 is SOUTH, the bidder: the same contract is a gain.
    assert call_value("PASS", ["1H", "P", "2S", "P", "P", "P"], N, 0,
                      TRICKS) == 140.0


def test_pass_over_a_doubled_contract_is_not_pass_over_an_undoubled_one():
    """EW bid 2H holding 3 heart tricks — down five. What NS get for
    passing depends entirely on whether the double was left in."""
    # Dealer E, two-call prefix: the caller is WEST, i.e. the side that
    # bid it — so this is EW's own doubled disaster, from their side.
    e = seat_from_letter("E")
    assert call_value("PASS", ["2H", "P"], e, 0, TRICKS) == -250.0
    assert call_value("PASS", ["2H", "X"], e, 0, TRICKS) == -1100.0


def test_doubling_your_own_side_is_illegal():
    # 1H by NORTH (index 0); the caller at index 3 is WEST — a double there
    # is legal, but from NORTH's own side (index 2, SOUTH) it is not.
    assert call_value("X", ["1H", "P", "P"], N, 0, TRICKS) is not None
    assert call_value("X", ["P", "P", "P", "P"], N, 0, TRICKS) is None


def test_redouble_needs_a_double_first():
    assert call_value("XX", ["2H", "X"], seat_from_letter("W"), 0, TRICKS) \
        is not None
    assert call_value("XX", ["2H"], seat_from_letter("W"), 0, TRICKS) is None


def test_the_imp_scale_is_kinked_and_signed():
    # 30 points is 1 IMP, 500 is 11, and the sign survives: this is the
    # scale the match is scored on, not a linear rescaling of points.
    assert signed_imps(30.0) == 1
    assert signed_imps(500.0) == 11
    assert signed_imps(-500.0) == -11


def test_the_reference_is_what_the_other_table_scores():
    """IMPs are a difference, so a target in IMPs needs the other side of
    it: the same cards played at the other table."""
    assert best_side_score(TRICKS, (Seat.NORTH, Seat.SOUTH), 0) == 420.0
    assert best_side_score(TRICKS, (Seat.EAST, Seat.WEST), 0) == 140.0


def test_imps_and_points_rank_a_single_deal_the_same_but_not_a_leaf():
    """Monotone per deal, so any single board agrees. The difference only
    appears when a leaf averages several — which is why units matter."""
    ref = best_side_score(TRICKS, (Seat.EAST, Seat.WEST), 0)
    pts_4h = call_value("4H", [], N, 0, TRICKS)
    imp_4h = call_value("4H", [], N, 0, TRICKS, ref=ref)
    assert pts_4h == 420.0 and imp_4h == 7
    # 2H also takes 10 tricks: 170 vs their 140 is +1 IMP, where in points
    # it is a 250-point gap from game. The kink is the whole difference.
    assert call_value("2H", [], N, 0, TRICKS) == 170.0
    assert call_value("2H", [], N, 0, TRICKS, ref=ref) == 1


def test_a_failing_game_is_worse_than_the_partscore_it_replaces():
    """The whole point of the label: it has to be able to say that bidding
    game on a hand that cannot take 10 tricks is a mistake."""
    few = dict(TRICKS)
    few.update({"HEARTS:NORTH": 8, "HEARTS:SOUTH": 8})     # 4H down 2
    assert call_value("4H", [], N, 0, few) == -100.0
    assert call_value("2H", [], N, 0, few) == 110.0


if __name__ == "__main__":
    pytest.main([__file__])
