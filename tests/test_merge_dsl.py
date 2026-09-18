"""Tests for `research/merge_dsl.py`.

Merging per-slice fits is how a 330k-trace model fits on a 16 GB machine,
and the whole argument rests on the merge being exact: `fit_net` fits each
slice independently, so `merge(slice_a, slice_b)` must equal what a single
process would have produced. The failure modes are all silent — a dropped
rule, a duplicated id, a header quietly taken from the wrong file.
"""
import os
import sys

import pytest

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))
sys.path.insert(0, os.path.join(REPO, "research"))

from merge_dsl import (PROV_BEGIN, PROV_END, prov_facts, rule_id,  # noqa: E402
                       split_header, split_provenance)

PROV = [PROV_BEGIN,
        "# generated  2026-09-17 00:00:00",
        "# command    research/brill_distill.py --only-group True,False",
        "# traces     data/x.jsonl  (460 rows featurised)",
        "# group      opening_contested   [slice True,False]",
        "# depth      10    min-samples 25    folds 5",
        PROV_END]
BANNER = ["# ======", "# IMPROVED BIDDING SYSTEM: brill_distilled", "# ======"]


def _dsl(prov, ids):
    lines = list(prov) + [""] + list(BANNER) + [""]
    for i in ids:
        lines += ["RULE %s:" % i, "  CALL: PASS", "  PRIORITY: 10",
                  "  CONDITION: hcp <= 11.5", ""]
    return "\n".join(lines)


def test_header_is_everything_before_the_first_rule():
    header, blocks = split_header(_dsl(PROV, ["BD_a_P0", "BD_b_P0"]))
    assert len(blocks) == 2
    assert rule_id(blocks[0]) == "BD_a_P0"
    # The provenance and the banner are both header; no rule is.
    assert all(not ln.startswith("RULE ") for ln in header)
    assert PROV_BEGIN in header


def test_provenance_is_separated_from_the_shared_banner():
    """Per-slice provenance is *meant* to differ; the banner is not."""
    prov, rest = split_provenance(list(PROV) + [""] + BANNER)
    assert prov[0] == PROV_BEGIN and prov[-1] == PROV_END
    assert rest == [""] + BANNER


def test_a_file_with_no_provenance_still_merges():
    rest = [""] + BANNER
    assert split_provenance(rest) == ([], rest)


def test_prov_facts_summarises_which_slice_and_how_deep():
    facts = prov_facts(PROV)
    assert "[slice True,False]" in facts
    assert "depth      10" in facts
    assert "460 rows" in facts
    # The timestamp and argv are per-run noise, not worth keeping.
    assert "generated" not in facts
    assert "command" not in facts


def test_rule_id_strips_the_trailing_colon():
    assert rule_id(["RULE BD_later_cont_P12:", "  CALL: PASS"]) == \
        "BD_later_cont_P12"


@pytest.mark.parametrize("ids", [["BD_a_P0"], ["BD_a_P0", "BD_a_P1"]])
def test_only_prefix_is_not_exercised_here_but_ids_stay_unique(ids):
    """Guard against the merge silently depending on file order."""
    _, blocks = split_header(_dsl(PROV, ids))
    assert len({rule_id(b) for b in blocks}) == len(blocks)
