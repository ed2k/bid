import unittest

from bid.coverage_gap import (BANDS, LegacyAdapter, aggregate_cells, parse_history,
                              sample_hand, sample_cell, scan_cells, shape_family,
                              shapes_13, max_hcp, min_hcp, history_str)
from bid.models import Call, CallType, Strain
from bid.translator import SystemTranslator

TINY_NT = """
OPEN 1NT:
  HCP: 15-17
  SHAPE: BALANCED
"""

TINY_1D = """
OPEN 1C:
  HCP: 16+

1C - 1D:
  HCP: 0-7
"""


def _legacy(dsl: str):
    return LegacyAdapter(SystemTranslator().parse(dsl))


class TestCellMath(unittest.TestCase):
    def test_shapes_13_count(self):
        self.assertEqual(len(shapes_13()), 560)

    def test_impossible_bounds(self):
        # 4-3-3-3 can hold every HCP 0-37 (37 = AKQJ + AKQ + AKQ + AKQ)
        self.assertEqual(max_hcp((4, 3, 3, 3)), 37)
        self.assertEqual(min_hcp((4, 3, 3, 3)), 0)
        # a 13-card suit is exactly AKQJT98765432 = 10 HCP, nothing else
        self.assertEqual(min_hcp((13, 0, 0, 0)), 10)
        self.assertEqual(max_hcp((13, 0, 0, 0)), 10)

    def test_families(self):
        self.assertEqual(shape_family((3, 3, 3, 4)), "balanced")
        self.assertEqual(shape_family((2, 3, 3, 5)), "balanced")
        self.assertEqual(shape_family((7, 3, 2, 1)), "one-suited 7+")
        self.assertEqual(shape_family((5, 5, 2, 1)), "5-5 two-suiter")
        self.assertEqual(shape_family((4, 4, 4, 1)), "4-4-4-1/0 three-suiter")
        self.assertEqual(shape_family((5, 4, 3, 1)), "5-4")


class TestSampler(unittest.TestCase):
    def test_exact_construction(self):
        import random
        rng = random.Random(7)
        for hcp in (0, 5, 11, 19, 27):
            h = sample_hand(rng, hcp, (4, 3, 3, 3))
            self.assertIsNotNone(h)
            self.assertEqual(h.hcp, hcp)
            self.assertEqual(len(h.cards), 13)

    def test_impossible_returns_none(self):
        import random
        # a 13-card suit is always exactly 10 HCP; nothing else exists
        self.assertIsNone(sample_hand(random.Random(1), 9, (13, 0, 0, 0)))
        self.assertIsNone(sample_hand(random.Random(1), 11, (13, 0, 0, 0)))

    def test_sample_cell_distinct(self):
        import random
        hands = sample_cell(random.Random(3), 13, (5, 3, 3, 2), 4)
        self.assertEqual(len(hands), 4)
        keys = {tuple(sorted((c.suit, c.rank) for c in h.cards)) for h in hands}
        self.assertEqual(len(keys), 4)


class TestOpeningScan(unittest.TestCase):
    def test_nt_only_system(self):
        adapter = _legacy(TINY_NT)
        shapes = [(3, 3, 3, 4), (5, 3, 3, 2), (5, 4, 2, 2), (6, 3, 3, 1)]
        res = scan_cells(adapter, [], [14, 15, 16, 17], shapes, samples=3, seed=1)
        by = {(r["hcp"], tuple(r["shape"])): r["status"] for r in res}
        # balanced 15-17 covered
        for hcp in (15, 16, 17):
            for shp in ((3, 3, 3, 4), (5, 3, 3, 2)):
                self.assertEqual(by[(hcp, shp)], "covered", (hcp, shp))
        # 14 balanced and unbalanced shapes are gaps
        self.assertEqual(by[(14, (3, 3, 3, 4))], "gap")
        self.assertEqual(by[(15, (5, 4, 2, 2))], "gap")
        self.assertEqual(by[(15, (6, 3, 3, 1))], "gap")


class TestHistoryScan(unittest.TestCase):
    def test_negative_response_gap(self):
        adapter = _legacy(TINY_1D)
        history = parse_history("1C P")
        self.assertEqual(history_str(history), "1C P")
        shapes = [(4, 3, 3, 3), (5, 3, 3, 2)]
        res = scan_cells(adapter, history, [3, 12], shapes, samples=3, seed=1)
        by = {(r["hcp"], tuple(r["shape"])): r["status"] for r in res}
        self.assertEqual(by[(3, (4, 3, 3, 3))], "covered")   # 0-7 negative
        self.assertEqual(by[(12, (4, 3, 3, 3))], "gap")      # 8+ has no rule in TINY_1D

    def test_own_call_consistency_excludes_impossible_cells(self):
        # After "1C P 1D P" the actor is the 1C opener, who must hold 16+.
        adapter = _legacy(TINY_1D)
        history = parse_history("1C P 1D P")
        res = scan_cells(adapter, history, [3, 12, 17], [(4, 3, 3, 3)],
                         samples=3, seed=1)
        by = {(r["hcp"], tuple(r["shape"])): r["status"] for r in res}
        self.assertEqual(by[(3, (4, 3, 3, 3))], "excluded")   # cannot have opened 1C
        self.assertEqual(by[(12, (4, 3, 3, 3))], "excluded")
        # 17 HCP is a possible opener, but TINY_1D defines no rebid -> gap
        self.assertEqual(by[(17, (4, 3, 3, 3))], "gap")


class TestAggregation(unittest.TestCase):
    def test_rows_grouped_by_band_family(self):
        res = [
            {"hcp": 9, "shape": [5, 5, 2, 1], "status": "gap"},
            {"hcp": 10, "shape": [5, 5, 1, 2], "status": "gap"},
            {"hcp": 25, "shape": [4, 3, 3, 3], "status": "gap"},
            {"hcp": 9, "shape": [4, 3, 3, 3], "status": "covered"},
        ]
        rows, counts = aggregate_cells(res)
        self.assertEqual(counts["gap"], 3)
        self.assertEqual(counts["covered"], 1)
        self.assertEqual(len(rows), 2)
        top = rows[0]
        self.assertEqual((top["band"], top["family"]), ("8-11", "5-5 two-suiter"))
        self.assertEqual(top["cells"], 2)

    def test_bands_defined(self):
        self.assertEqual(BANDS[0][0], 0)
        self.assertEqual(BANDS[-1][1], 37)


if __name__ == "__main__":
    unittest.main()
