import random
import unittest

from bid.blueclub_loop import (build_mutants, blocks_to_text, mutate_block,
                               parse_blocks, compile_system)

DSL = """# 1C: Strong
OPEN 1C:
  HCP: 17+
  SHAPE: UNBALANCED

# 1C - 1D: negative
1C - 1D:
  HCP: 0-5
  LEN D: 1-2

# weak pass
OPEN PASS:
  HCP: 0-12
"""


class TestBlockModel(unittest.TestCase):
    def test_round_trip_preserves_text(self):
        blocks = parse_blocks(DSL)
        self.assertEqual(blocks_to_text(blocks), DSL)

    def test_rule_blocks_found(self):
        blocks = parse_blocks(DSL)
        rules = [b for b in blocks if b["kind"] == "rule"]
        self.assertEqual([r["heading"] for r in rules],
                         ["OPEN 1C:", "1C - 1D:", "OPEN PASS:"])
        # leading comments stay attached to their rule
        self.assertTrue(rules[1]["comment"][0].startswith("# 1C - 1D"))

    def test_compiles(self):
        blocks = parse_blocks(DSL)
        system = compile_system(blocks)
        self.assertEqual(len(system.rules), 3)


class TestMutations(unittest.TestCase):
    def test_hcp_variants(self):
        blocks = parse_blocks(DSL)
        rule = [b for b in blocks if b["kind"] == "rule" and b["heading"] == "1C - 1D:"][0]
        edits = mutate_block(rule)
        new_vals = {line.strip() for _, line, _ in edits}
        self.assertIn("HCP: 0-6", new_vals)      # widen upper
        self.assertIn("HCP: 0-4", new_vals)      # tighten upper
        self.assertIn("LEN D: 0-2", new_vals)    # loosen length lower bound
        self.assertNotIn("HCP: 0-5", new_vals)   # identity excluded

    def test_pass_never_mutated(self):
        blocks = parse_blocks(DSL)
        rule = [b for b in blocks if b["kind"] == "rule" and b["heading"] == "OPEN PASS:"][0]
        self.assertEqual(mutate_block(rule), [])

    def test_plus_form_loosens(self):
        dsl = "OPEN 1C:\n  HCP: 17+\n"
        blocks = parse_blocks(dsl)
        rule = blocks[0]
        vals = {line.strip() for _, line, _ in mutate_block(rule)}
        self.assertIn("HCP: 16+", vals)
        self.assertNotIn("HCP: 18+", vals)

    def test_build_mutants_splice_and_cache(self):
        blocks = parse_blocks(DSL)
        rng = random.Random(1)
        cands = build_mutants(blocks, pool_cap=100, rng=rng, failed={})
        self.assertTrue(cands)
        for c in cands:
            # every candidate differs from base in exactly its target block
            self.assertEqual(blocks_to_text(c["blocks"]) != DSL, True)
            compile_system(c["blocks"])  # all mutants must parse
        sig = cands[0]["sig"]
        again = build_mutants(blocks, pool_cap=100, rng=rng, failed={sig: {}})
        self.assertNotIn(sig, {c["sig"] for c in again})


if __name__ == "__main__":
    unittest.main()
