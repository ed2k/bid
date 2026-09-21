"""Tests for the outcome relabelling in `research/brill_distill.py`.

Every model in this repo was fitted to imitate Brill's *call*. §6.81 showed
why that has stopped paying: we reach game 38% of the time against Brill's
52%, and that uniform level bias is invisible to per-call fidelity (§6.80)
and cancels out in self-play attribution. So `--relabel outcome` changes
the training target from "what did Brill bid" to "what did bidding that
earn".

That swap is a silent-corruption risk in the same family as the compact-row
change this file sits next to: nothing errors if it is wrong, the fit just
quietly optimises something else. Four things have to hold:

* a row must land in the leaf the tree would actually *predict* with —
  `leaf_of` re-implements `ID3Node.predict`, and the two can drift;
* the outcome must be read at the row's own position in the auction, or a
  leaf is relabelled with somebody else's result;
* only calls **observed** in the leaf are candidates. Off-policy calls have
  no data behind them, so choosing one would be invention, not improvement;
* `min_support` and `margin` are the only guards against flipping a leaf on
  noise (three lucky slams), so they must actually bite.
"""
import os
import sys

import pytest

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))
sys.path.insert(0, os.path.join(REPO, "research"))

from bid.brill.convert import parse_call                            # noqa: E402
from bid.learner import ID3DecisionTree, ID3Node                    # noqa: E402
from brill_distill import (leaf_of, load_outcomes,                  # noqa: E402
                           relabel_outcome_leaves)


class _Tree:
    """`relabel_outcome_leaves` only ever touches `tree.root`."""

    def __init__(self, root):
        self.root = root


def _split_tree(low="PASS", high="1S"):
    """hcp <= 10 -> left leaf, else right leaf."""
    root = ID3Node(feature_name="hcp", threshold=10.0, is_continuous=True)
    root.left_child = ID3Node(is_leaf=True, prediction=parse_call(low))
    root.right_child = ID3Node(is_leaf=True, prediction=parse_call(high))
    return _Tree(root)


def _rows(n, deal0=0, call="PASS", ctx="", hcp=5):
    """`n` traces, one per deal, all at auction position `len(ctx)`.

    `rows` are raw trace dicts (what `ctxs[i]` holds), `gx` are the feature
    rows the tree walks -- the two are parallel arrays in the real call.
    """
    rows = [{"deal": "D%d" % (deal0 + k), "ctx": ctx, "call": call}
            for k in range(n)]
    gx = [{"hcp": hcp} for _ in range(n)]
    return gx, rows


def _outcomes(deals, values):
    """deal -> [outcome per auction position]; `values[i]` for deal i."""
    return {"D%d" % (deals + k): [v] for k, v in enumerate(values)}


# --- leaf_of -----------------------------------------------------------

def test_leaf_of_returns_the_leaf_predict_would_use():
    tree = _split_tree()
    for hcp in (0, 5, 10, 11, 20):
        feats = {"hcp": hcp}
        node = leaf_of(tree.root, feats)
        assert node.is_leaf
        assert node.prediction == tree.root.predict(feats)


def test_leaf_of_agrees_with_predict_on_a_fitted_tree():
    """The real risk: `leaf_of` re-implements `predict` and can drift."""
    gx = [{"hcp": h, "controls": h // 4} for h in (4, 6, 12, 14, 18, 20)]
    gy = [parse_call(c) for c in ("PASS", "PASS", "1S", "1S", "2S", "2S")]
    tree = ID3DecisionTree(max_depth=3)
    tree.fit(gx, gy)
    for row in gx:
        node = leaf_of(tree.root, row)
        assert node.is_leaf, "walked to an internal node on a fitted tree"
        assert node.prediction == tree.root.predict(row)


def test_a_row_missing_the_split_feature_reaches_no_leaf():
    """`predict` would fall back to the node's own (None) prediction.

    Counting such a row into the nearest leaf would credit it with a
    score it never earned, so it has to be dropped instead.
    """
    tree = _split_tree()
    node = leaf_of(tree.root, {"controls": 3})
    assert not node.is_leaf


# --- relabelling -------------------------------------------------------

def test_the_better_scoring_observed_call_takes_the_leaf():
    gx, rows = _rows(20, deal0=0, call="PASS")
    gx2, rows2 = _rows(20, deal0=100, call="1S")
    outs = _outcomes(0, [0.0] * 20)
    outs.update(_outcomes(100, [420.0] * 20))

    tree = _split_tree(low="PASS")
    changed, leaves = relabel_outcome_leaves(
        tree, gx + gx2, rows + rows2, outs, min_support=20, margin=0.0)

    assert leaves == 1
    assert changed == 1
    assert tree.root.left_child.prediction == parse_call("1S")


def test_min_support_blocks_a_lucky_call():
    """Three slams that happened to make is not evidence."""
    gx, rows = _rows(20, deal0=0, call="PASS")
    gx2, rows2 = _rows(3, deal0=100, call="4S")
    outs = _outcomes(0, [100.0] * 20)
    outs.update(_outcomes(100, [620.0] * 3))

    tree = _split_tree(low="PASS")
    changed, _ = relabel_outcome_leaves(
        tree, gx + gx2, rows + rows2, outs, min_support=20, margin=0.0)

    assert changed == 0
    assert tree.root.left_child.prediction == parse_call("PASS")


def test_margin_blocks_a_marginal_improvement():
    gx, rows = _rows(20, deal0=0, call="PASS")
    gx2, rows2 = _rows(20, deal0=100, call="1S")
    outs = _outcomes(0, [100.0] * 20)
    outs.update(_outcomes(100, [110.0] * 20))

    tree = _split_tree(low="PASS")
    changed, _ = relabel_outcome_leaves(
        tree, gx + gx2, rows + rows2, outs, min_support=20, margin=50.0)
    assert changed == 0

    changed, _ = relabel_outcome_leaves(
        tree, gx + gx2, rows + rows2, outs, min_support=20, margin=5.0)
    assert changed == 1


def test_only_calls_observed_in_the_leaf_are_candidates():
    """Off-policy calls have no data behind them: never invent one."""
    gx, rows = _rows(20, deal0=0, call="PASS")
    outs = _outcomes(0, [0.0] * 20)

    tree = _split_tree(low="PASS")
    changed, _ = relabel_outcome_leaves(
        tree, gx, rows, outs, min_support=1, margin=0.0)
    assert changed == 0
    assert tree.root.left_child.prediction == parse_call("PASS")


def test_a_leaf_with_no_outcome_data_is_left_alone():
    gx, rows = _rows(20, deal0=0, call="PASS")
    changed, leaves = relabel_outcome_leaves(
        _split_tree(), gx, rows, {}, min_support=1, margin=0.0)
    assert (changed, leaves) == (0, 0)


def test_rows_whose_deal_was_never_labelled_are_skipped():
    gx, rows = _rows(20, deal0=0, call="PASS")
    gx2, rows2 = _rows(20, deal0=100, call="1S")
    outs = _outcomes(100, [420.0] * 20)          # only the 1S deals labelled

    tree = _split_tree(low="PASS")
    changed, _ = relabel_outcome_leaves(
        tree, gx + gx2, rows + rows2, outs, min_support=20, margin=0.0)
    # 20 labelled rows all say 1S, so the flip still happens -- but only
    # because the labelled subset happens to be the challenger.
    assert changed == 1
    assert tree.root.left_child.prediction == parse_call("1S")


# --- outcome alignment -------------------------------------------------

def test_the_outcome_is_read_at_the_rows_own_auction_position():
    """ctx has one token per earlier call, so `len(ctx)` is the row's index."""
    gx, rows = _rows(20, deal0=0, call="PASS", ctx="")
    gx2, rows2 = _rows(20, deal0=100, call="1S", ctx="1H-P-")
    # deal 100+k: position 0 is worthless, position 2 is the 1S decision
    outs = {"D%d" % (100 + k): [0.0, 0.0, 420.0] for k in range(20)}

    tree = _split_tree(low="PASS")
    changed, _ = relabel_outcome_leaves(
        tree, gx + gx2, rows + rows2, outs, min_support=20, margin=0.0)
    assert changed == 1
    assert tree.root.left_child.prediction == parse_call("1S")


def test_a_row_past_the_end_of_the_labelled_auction_is_skipped():
    gx, rows = _rows(20, deal0=0, call="PASS", ctx="1H-P-1S-")
    outs = {"D%d" % k: [0.0, 0.0] for k in range(20)}   # only 2 positions
    changed, leaves = relabel_outcome_leaves(
        _split_tree(), gx, rows, outs, min_support=1, margin=0.0)
    assert (changed, leaves) == (0, 0)


# --- load_outcomes -----------------------------------------------------

def test_load_outcomes_merges_shards_behind_a_glob(tmp_path):
    for shard, deals in enumerate((("A", 10.0), ("B", 20.0))):
        p = tmp_path / ("out.%d" % shard)
        p.write_text('{"deal": "%s", "n": 1, "out": [%f]}\n'
                     % (deals[0], deals[1]))
    got = load_outcomes([str(tmp_path / "out.*")])
    assert got == {"A": [10.0], "B": [20.0]}


def test_load_outcomes_ignores_blank_lines_and_missing_files(tmp_path):
    p = tmp_path / "out.0"
    p.write_text('{"deal": "A", "n": 1, "out": [1.0]}\n\n')
    assert load_outcomes([str(p)]) == {"A": [1.0]}
    assert load_outcomes([str(tmp_path / "nope.*")]) == {}


if __name__ == "__main__":
    pytest.main([__file__])
