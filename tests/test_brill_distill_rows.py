"""Tests for the compact feature rows in `research/brill_distill.py`.

`featurise` no longer stores one dict per trace; it stores a `__slots__`
object that answers `row.get(k, default)` and `row.keys()`. That is a
memory optimisation (3.2x smaller per row, which is what lets the largest
slice fit at all), but it is also a silent-corruption risk: ID3 reads rows
only through those two methods, so if either behaves slightly differently
from a dict the tree changes without any error.

The two invariants that matter, both discovered by getting them wrong:

* `keys()` must be the extractor's **insertion** order, not sorted. ID3
  breaks information-gain ties by taking the first feature it sees, so
  sorting `keys()` reorders the candidates and moves held-out agreement
  (71.1% -> 71.5% on `data/brill_traces.jsonl`).
* every feature must survive the conversion. A missing slot would make
  `get` fall through to the default, which ID3 reads as a legitimate 0.
"""
import os
import sys

import pytest

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))
sys.path.insert(0, os.path.join(REPO, "research"))

from bid.features import BridgeFeatures                             # noqa: E402
from bid.brill.convert import (hand_from_pbn, parse_call,           # noqa: E402
                               seat_from_letter)
from brill_distill import _compact_row                              # noqa: E402


def _features(auction=()):
    hand = hand_from_pbn("AQJ9.KQ8.AQ7.KQ3")
    history = [parse_call(c) for c in auction]
    return BridgeFeatures.extract_all(hand, history,
                                      seat_from_letter("S"),
                                      seat_from_letter("N"), 0)


@pytest.fixture(autouse=True)
def _reset_row_class():
    """`_compact_row` caches the class globally; tests must not leak it."""
    import brill_distill
    saved = (brill_distill._ROW_CLASS, brill_distill._ROW_NAMES)
    brill_distill._ROW_CLASS, brill_distill._ROW_NAMES = None, None
    yield
    brill_distill._ROW_CLASS, brill_distill._ROW_NAMES = saved


def test_every_feature_survives_the_conversion():
    feats = _features(("1S", "P", "2H"))
    row = _compact_row(feats)
    assert list(row.keys()) == list(feats)
    for k, v in feats.items():
        assert row.get(k) == v, k


def test_keys_keep_insertion_order_not_sorted():
    """Sorted order silently changes ID3's tie-breaking (see module doc)."""
    feats = _features()
    assert list(_compact_row(feats).keys()) == list(feats)
    assert list(feats) != sorted(feats), "extractor already sorts; pick a " \
        "case where the two differ so this test can actually fail"


def test_missing_key_falls_back_to_the_default_like_a_dict():
    """ID3 calls `row.get(feat, 0)`; the default must come back unchanged."""
    row = _compact_row(_features())
    assert row.get("not_a_feature") is None
    assert row.get("not_a_feature", 0) == 0
    assert row.get("not_a_feature", "x") == "x"


def test_string_features_survive_so_categorical_splits_still_work():
    feats = _features(("1S", "P", "2H"))
    row = _compact_row(feats)
    assert isinstance(row.get("opp_last_call"), str)
    assert row.get("opp_last_call") == feats["opp_last_call"]


def test_rows_have_no_dict_so_they_are_actually_smaller():
    row = _compact_row(_features())
    assert not hasattr(row, "__dict__")
    # A slots object stores one pointer per feature and nothing else.
    assert len(row.keys()) > 100


def test_a_changed_key_set_fails_loudly():
    """A silent key change would drop features into the default, not error."""
    _compact_row(_features())
    smaller = dict(_features())
    smaller.pop("hcp")
    with pytest.raises(ValueError, match="feature keys changed"):
        _compact_row(smaller)
