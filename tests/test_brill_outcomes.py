"""Tests for the resume path in `research/brill_outcomes.py`.

The tool costs one DDS solve per board — ~21 min for 33,450 boards on six
workers — and it is run in shards in the background, which is exactly the
kind of job that gets killed part-way (the first run died at 62%). Without
`--resume` the only way forward is to re-solve everything, so the resume
bookkeeping is worth pinning.

`labelled_deals` is the whole of it, and it is pure file parsing, so these
tests need no solver. The failure mode that matters is the torn line: a
killed process leaves a partial JSON record at the end of the shard file
it was appending to. Treating that as fatal would make the file
un-resumable, which is worse than losing one board.
"""
import os
import shutil
import sys
import tempfile

import pytest

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))
sys.path.insert(0, os.path.join(REPO, "research"))

from brill_outcomes import labelled_deals, shard_of                  # noqa: E402

GOOD = '{"deal": "N:Q.AK.QT.AKQJT2", "n": 1, "out": [420.0]}\n'


def test_reads_the_deals_a_shard_has_already_scored():
    d = tempfile.mkdtemp()
    try:
        p = os.path.join(d, "out.0")
        with open(p, "w") as fh:
            fh.write(GOOD)
            fh.write('{"deal": "N:K.Q.J.AKQJT987", "n": 2, "out": [0.0, 0.0]}\n')
        assert labelled_deals(p) == {"N:Q.AK.QT.AKQJT2",
                                     "N:K.Q.J.AKQJT987"}
    finally:
        shutil.rmtree(d, ignore_errors=True)


def test_a_torn_line_from_a_kill_is_skipped_not_fatal():
    d = tempfile.mkdtemp()
    try:
        p = os.path.join(d, "out.0")
        with open(p, "w") as fh:
            fh.write(GOOD)
            fh.write('{"deal": "N:A.A.A.AKQJT9876", "n": 1, "o')   # killed
        assert labelled_deals(p) == {"N:Q.AK.QT.AKQJT2"}
    finally:
        shutil.rmtree(d, ignore_errors=True)


def test_blank_lines_are_ignored():
    d = tempfile.mkdtemp()
    try:
        p = os.path.join(d, "out.0")
        with open(p, "w") as fh:
            fh.write(GOOD + "\n")
        assert labelled_deals(p) == {"N:Q.AK.QT.AKQJT2"}
    finally:
        shutil.rmtree(d, ignore_errors=True)


def test_a_missing_shard_file_means_nothing_is_done_yet():
    assert labelled_deals("/nonexistent/out.0") == set()


def test_sharding_is_stable_so_a_resume_cannot_duplicate_a_deal():
    """A deal must land in the same shard on every run, or resuming would
    re-solve some boards and silently miss others."""
    deals = ["N:Q.AK.QT.AKQJT2", "N:K.Q.J.AKQJT987", "N:A.A.A.AKQJT9876"]
    for shards in (1, 3, 6):
        first = [shard_of(d, shards) for d in deals]
        assert first == [shard_of(d, shards) for d in deals]
        assert all(0 <= s < shards for s in first)
    # and the 3-shard run must partition the 6-shard one, which is why the
    # stale .3/.4/.5 leftovers are a subset of the .0/.1/.2 in use.
    for d in deals:
        assert shard_of(d, 3) == shard_of(d, 6) % 3


if __name__ == "__main__":
    pytest.main([__file__])
