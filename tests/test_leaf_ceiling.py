"""Tests for `research/leaf_ceiling.py`, the leaf-representation diagnostic.

§6.82–6.85 tried four training targets on one tree and all of them landed
at zero or worse. That invites the explanation "the tree cannot express the
answer", which is a claim about a *bound*, and a bound is only worth
something if it is measured. This tool measures it — and the way it can be
wrong is instructive, because the first version of the measurement was.

The traps it has to avoid:

* **leaf identity is the rule, not the call.** Two different leaves
  routinely emit the same call. Keying leaf groups on the call collapses
  them, and a "best call per leaf" then gets credited on hands the leaf
  never sees — which is exactly how the first version of this reported 32
  leaves and 19.9 distinct best calls instead of 762 and 7.7.
* **illegal calls are played as PASS.** `DecisionNet.actions` silently
  drops a call that is illegal where it lands. Scoring those rows as
  skipped would flatter precisely the models that emit them.
* **support is legality, not observation.** The guard counts the rows in
  which the chosen call is legal, as §6.84's `min_support` did. Counting
  rows in which Brill happened to make it would drop every unobserved call
  and quietly reduce `--candidates all` to `--candidates observed`.
* **the metric is circular for a DD target.** Scoring a DD-retargeted
  model with the one-step valuation that produced its labels can only
  agree with itself (§6.86), which is why `--emit` exists: the bound has
  to be played, not scored.
"""
import os
import shutil
import sys
import tempfile

import pytest

sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__))), "research"))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(
    os.path.abspath(__file__))), "src"))

from bid.models import Seat                                     # noqa: E402
from brill_distill import call_value                            # noqa: E402
import leaf_ceiling                                             # noqa: E402


DSL = """# fixture
RULE P_low:
  CALL: PASS
  PRIORITY: 10
  CONDITION: hcp <= 10.5

RULE P_high:
  CALL: 2H
  PRIORITY: 10
  CONDITION: hcp <= 20.5

RULE OTHER_x:
  CALL: 3C
  PRIORITY: 10
  CONDITION: hcp <= 20.5
"""


@pytest.fixture
def tmpdir():
    """`tmp_path` cannot mkdir under this sandbox; mkdtemp can."""
    d = tempfile.mkdtemp()
    try:
        yield d
    finally:
        shutil.rmtree(d, ignore_errors=True)


@pytest.fixture
def dsl(tmpdir):
    p = os.path.join(tmpdir, "t.dsl")
    with open(p, "w") as fh:
        fh.write(DSL)
    return p


class _FakeArgs:
    def __init__(self, **kw):
        self.dsl = ""
        self.emit = ""
        self.emit_min = 12
        self.candidates = "observed"
        self.units = "imp"
        self.__dict__.update(kw)


# ---------------------------------------------------------------- leaf rules

def test_leaf_rules_filters_by_prefix_and_keeps_rule_id(dsl):
    rules = leaf_ceiling.leaf_rules(dsl, "P_")
    assert [r[0] for r in rules] == ["P_low", "P_high"]
    assert [r[2] for r in rules] == ["PASS", "2H"]


def test_leaf_of_row_returns_first_matching_rule(dsl):
    """Tree paths are mutually exclusive; the net resolves ties by
    priority, so first-match has to be the rule used here too."""
    rules = leaf_ceiling.leaf_rules(dsl, "P_")
    assert leaf_ceiling.leaf_of_row(rules, {"hcp": 5}) == "P_low"
    assert leaf_ceiling.leaf_of_row(rules, {"hcp": 15}) == "P_high"


def test_leaf_of_row_returns_none_when_nothing_matches(dsl):
    rules = leaf_ceiling.leaf_rules(dsl, "P_")
    assert leaf_ceiling.leaf_of_row(rules, {"hcp": 99}) is None


def test_play_falls_back_to_pass_when_no_leaf_matches(dsl):
    """What the net does: an uncovered position is a pass, not a crash."""
    rules = leaf_ceiling.leaf_rules(dsl, "P_")
    assert leaf_ceiling._play(rules, {"hcp": 99}) == "PASS"
    assert leaf_ceiling._play(rules, {"hcp": 5}) == "PASS"


# -------------------------------------------------------- illegal-call value

def _row(ctx, tricks, ref=None):
    r = type("R", (), {})()
    r.ctx, r.tricks, r.ref = ctx, tricks, ref
    r.dealer, r.vul = Seat.NORTH, 0
    return r


TRICKS = {"SPADES:NORTH": 8}


def test_model_value_scores_an_illegal_call_as_the_pass_it_becomes():
    """A call below the one it follows cannot be made, so the net plays
    PASS. Scoring the row as skipped would flatter the model that emits
    the illegal call."""
    r = _row(["2S"], TRICKS)
    assert call_value("1S", r.ctx, r.dealer, r.vul, r.tricks, r.ref) is None
    assert leaf_ceiling._model_value("1S", r) == call_value(
        "PASS", r.ctx, r.dealer, r.vul, r.tricks, r.ref)


def test_model_value_passes_a_legal_call_through():
    r = _row(["2S"], TRICKS)
    v = leaf_ceiling._model_value("3S", r)
    assert v is not None
    assert v == call_value("3S", r.ctx, r.dealer, r.vul, r.tricks, r.ref)


def test_model_value_is_from_the_callers_side():
    """PASS over NORTH's 2S is a minus for the EAST caller."""
    r = _row(["2S"], TRICKS)
    assert leaf_ceiling._model_value("PASS", r) == -110.0


# ---------------------------------------------------------------------- emit

def _tot():
    return {("P_low", 0): {"PASS": [0.0, 30], "2H": [10.0, 30]},
            ("P_low", 1): {"PASS": [0.0, 30], "2H": [10.0, 30]}}


def test_emit_rewrites_only_the_chosen_leaf(dsl, tmpdir):
    """The point of `--emit` is to make the bound playable: a match knows
    nothing about how the calls were chosen."""
    out = os.path.join(tmpdir, "o.dsl")
    args = _FakeArgs(dsl=dsl, emit=out)
    n = leaf_ceiling.emit(args, {("P_low", 1): "2H"}, _tot())
    assert n == 1
    calls = {rid: c for rid, _conds, c in leaf_ceiling.leaf_rules(out, "P_")}
    assert calls == {"P_low": "2H", "P_high": "2H"}


def test_emit_leaves_unsupported_leaves_alone(dsl, tmpdir):
    """The guard is §6.84's: without it the retarget would be fitted to
    two rows and shipped as if it were knowledge."""
    out = os.path.join(tmpdir, "o.dsl")
    args = _FakeArgs(dsl=dsl, emit=out, emit_min=100)
    n = leaf_ceiling.emit(args, {("P_low", 1): "2H"}, _tot())
    assert n == 0
    calls = {rid: c for rid, _conds, c in leaf_ceiling.leaf_rules(out, "P_")}
    assert calls == {"P_low": "PASS", "P_high": "2H"}


def test_emit_support_is_legality_not_observation(dsl, tmpdir):
    """A call Brill never made in the leaf still has support if it is
    legal there. Counting observations instead would silently turn
    `--candidates all` into `--candidates observed` (407 vs 404 leaves)."""
    out = os.path.join(tmpdir, "o.dsl")
    args = _FakeArgs(dsl=dsl, emit=out, emit_min=12)
    tot = {("P_low", 0): {"7NT": [0.0, 30], "PASS": [0.0, 30]},
           ("P_low", 1): {"7NT": [0.0, 30], "PASS": [0.0, 30]}}
    leaf_ceiling.emit(args, {("P_low", 1): "7NT"}, tot)
    calls = {rid: c for rid, _conds, c in leaf_ceiling.leaf_rules(out, "P_")}
    assert calls["P_low"] == "7NT"


def test_emit_preserves_conditions_and_priority(dsl, tmpdir):
    out = os.path.join(tmpdir, "o.dsl")
    args = _FakeArgs(dsl=dsl, emit=out)
    leaf_ceiling.emit(args, {("P_low", 1): "2H"}, _tot())
    text = open(out).read()
    assert "CONDITION: hcp <= 10.5" in text
    assert "PRIORITY: 10" in text
    assert text.count("RULE ") == 3
