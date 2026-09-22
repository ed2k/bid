"""Tests for `--relabel-dd-candidates` in `research/brill_distill.py`.

§6.87: the DD relabeller drew its candidate set from "the calls Brill
happened to make in this leaf". That is not neutral, it is load-bearing —
it is the only reason X and XX were ever reachable, and twelve leaves
relabelled to a double turned a +0.212 IMP/board gain into a −0.05 loss
(paired: +0.331 ± 0.040, t +8.30). A candidate set you cannot see cannot
be audited, so it is now a declared argument.

What has to hold:

* `observed` reproduces the historical behaviour exactly, so every number
  published before this change still means what it said;
* `bids` and `legal` enumerate instead of inheriting from the data, and
  they keep only calls that are legal *where the leaf lands* — an illegal
  call is dropped silently by `DecisionNet.actions` and played as PASS, so
  an enumerating mode that ignored legality would quietly train passes;
* X is absent when the last bid is our own side's. That is the §6.87
  mechanism: in `later_uncont` the opponents have not bid, so at most of
  the positions those leaves reach a double is not a legal call.
"""
import os
import sys

import pytest

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))
sys.path.insert(0, os.path.join(REPO, "research"))

from bid.brill.convert import parse_call                        # noqa: E402
from bid.models import Seat                                     # noqa: E402
from brill_distill import (DD_BID_CALLS, dd_candidates)         # noqa: E402

# Legality does not depend on the deal, so an empty trick table is enough
# to ask "is this call available here?".
NO_TRICKS: dict = {}


def test_observed_is_pass_through_and_sorted():
    got = dd_candidates("observed", {"1S", "PASS", "2H"}, [], Seat.NORTH,
                        0, NO_TRICKS)
    assert got == ["1S", "2H", "PASS"]


def test_observed_ignores_the_enumerated_pool():
    """`observed` must not widen, or old numbers stop meaning what they said."""
    got = dd_candidates("observed", {"PASS"}, [], Seat.NORTH, 0, NO_TRICKS)
    assert got == ["PASS"]


def test_the_enumerated_pool_is_pass_plus_every_contract():
    assert DD_BID_CALLS[0] == "PASS"
    assert len(DD_BID_CALLS) == 36          # 7 levels x 5 strains, plus PASS
    assert len(set(DD_BID_CALLS)) == 36


def test_the_pool_is_spelled_like_the_calls_it_competes_with():
    """Otherwise a candidate is never == the call already in the leaf.

    `str(node.prediction)` and the observed calls are both short-form
    ("1S"). A long-form candidate would therefore read as a change even
    where it is the same call, and would miss `means.get(cur)` so the
    margin guard would not fire either.
    """
    assert "1S" in DD_BID_CALLS
    assert "1SPADES" not in DD_BID_CALLS
    for c in DD_BID_CALLS:
        assert str(parse_call(c)) == c, c


def test_bids_covers_every_contract_at_an_empty_auction():
    got = dd_candidates("bids", set(), [], Seat.NORTH, 0, NO_TRICKS)
    assert set(got) == set(DD_BID_CALLS)


def test_bids_never_offers_a_penalty():
    for ctx, dealer in ((["1H"], Seat.NORTH),
                        (["1H", "PASS"], Seat.NORTH),
                        (["1H", "X"], Seat.NORTH)):
        got = dd_candidates("bids", set(), ctx, dealer, 0, NO_TRICKS)
        assert "X" not in got and "XX" not in got, (ctx, dealer)


def test_legal_offers_a_double_over_the_opponents_bid():
    """ctx ['1H'] with NORTH dealing: NORTH bid, EAST is to call. EAST may X."""
    got = dd_candidates("legal", set(), ["1H"], Seat.NORTH, 0, NO_TRICKS)
    assert "X" in got
    assert "XX" not in got


def test_legal_offers_no_double_over_our_own_bid():
    """The §6.87 mechanism.

    ctx ['1H', 'PASS'] with NORTH dealing: NORTH bid 1H, EAST passed, SOUTH
    is to call. The last bid is SOUTH's partner's, so X is not a legal call
    — and `DecisionNet.actions` would drop it and play PASS instead. In
    `later_uncont` the opponents have not bid, so this is the shape of most
    of the positions those leaves reach.
    """
    got = dd_candidates("legal", set(), ["1H", "PASS"], Seat.NORTH,
                        0, NO_TRICKS)
    assert "X" not in got
    assert "XX" not in got


def test_legal_offers_redouble_only_over_our_doubled_bid():
    # NORTH 1H, EAST X, SOUTH to call: our bid, doubled. XX is the call.
    got = dd_candidates("legal", set(), ["1H", "X"], Seat.NORTH,
                        0, NO_TRICKS)
    assert "XX" in got
    assert "X" not in got


def test_legal_drops_bids_that_do_not_beat_the_last_one():
    got = dd_candidates("legal", set(), ["1H"], Seat.NORTH, 0, NO_TRICKS)
    assert "1H" not in got          # equal level and strain: not higher
    assert "1C" not in got          # higher strain? no — lower
    assert "1D" not in got
    assert "1S" in got              # same level, higher strain: legal
    assert "2C" in got              # higher level: legal


def test_cache_returns_the_same_answer_as_a_cold_call():
    cache: dict = {}
    ctx, dealer = ["1H"], Seat.NORTH
    cold = dd_candidates("legal", set(), ctx, dealer, 0, NO_TRICKS)
    warm = dd_candidates("legal", set(), ctx, dealer, 0, NO_TRICKS,
                         cache=cache)
    assert warm == cold
    # A second position must not be served the first one's answer.
    other = dd_candidates("legal", set(), [], Seat.NORTH, 0, NO_TRICKS,
                          cache=cache)
    assert other != cold
    assert len(cache) == 2


def test_cache_is_not_consulted_in_observed_mode():
    """`observed` depends on the leaf, so a position-keyed cache must not
    be used for it — two leaves can share a position and differ in what
    Brill did there."""
    cache: dict = {}
    a = dd_candidates("observed", {"1S"}, ["1H"], Seat.NORTH, 0,
                      NO_TRICKS, cache=cache)
    b = dd_candidates("observed", {"2H"}, ["1H"], Seat.NORTH, 0,
                      NO_TRICKS, cache=cache)
    assert a == ["1S"] and b == ["2H"]
    assert cache == {}
