import os
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from bid.lint_dsl import lint_file, lint_rules, parse_rules

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

BAD_DSL = """
RULE R_GOOD:
  CALL: 1NT
  PRIORITY: 20
  CONDITION: hcp >= 15
  CONDITION: hcp <= 17

RULE R_DUP:
  CALL: 1H
  PRIORITY: 10
  CONDITION: heart_len >= 5

RULE R_DUP:
  CALL: 1H
  PRIORITY: 10
  CONDITION: heart_len >= 5

RULE R_CONTRA:
  CALL: 2C
  PRIORITY: 10
  CONDITION: hcp >= 15
  CONDITION: hcp <= 14

RULE R_STRONG:
  CALL: 3D
  PRIORITY: 30
  CONDITION: hcp >= 16
  CONDITION: diamond_len >= 6

RULE R_SHADOWED:
  CALL: 3D
  PRIORITY: 10
  CONDITION: hcp >= 16
  CONDITION: diamond_len >= 6
  CONDITION: spade_len >= 2
"""


class TestLintDetection(unittest.TestCase):
    def setUp(self):
        self.rules = parse_rules(BAD_DSL)
        self.issues, self.warnings = lint_rules(self.rules)

    def test_detects_exact_duplicates(self):
        self.assertTrue(any("duplicate rule x2: R_DUP" in i for i in self.issues))

    def test_detects_contradicted_conditions(self):
        self.assertTrue(any("R_CONTRA" in i and "contradicted" in i
                            for i in self.issues))

    def test_detects_priority_shadowing(self):
        self.assertTrue(any("R_SHADOWED" in i and "R_STRONG" in i
                            for i in self.issues))

    def test_clean_rule_not_flagged(self):
        self.assertFalse(any("R_GOOD" in i for i in self.issues))


class TestLiveSystemsAreClean(unittest.TestCase):
    """The enforcement the todo asked for: the live systems never regress
    into the duplicate-riddled state that motivated the linter."""

    def test_improved_system_lint_clean(self):
        issues, _ = lint_file(os.path.join(REPO, "system", "improved_system.dsl"))
        self.assertEqual(issues, [])

    def test_champion_system_lint_clean(self):
        issues, _ = lint_file(os.path.join(REPO, "system", "champion_system.dsl"))
        self.assertEqual(issues, [])


class TestRoundTripStability(unittest.TestCase):
    def test_save_load_save_is_stable(self):
        """The exporter double-write bug squared duplicates every cycle;
        a save->load->save cycle must now be byte-stable."""
        from bid.eval_vs_dds import load_decision_net_dsl
        import tempfile
        path = os.path.join(REPO, "system", "improved_system.dsl")
        net = load_decision_net_dsl(path)
        with tempfile.NamedTemporaryFile("w", suffix=".dsl", delete=False) as f:
            out1 = f.name
        net.save_dsl(out1)
        net2 = load_decision_net_dsl(out1)
        net2.name = net.name     # name is derived from the file basename
        with tempfile.NamedTemporaryFile("w", suffix=".dsl", delete=False) as f:
            out2 = f.name
        net2.save_dsl(out2)
        try:
            with open(out1) as f:
                a = f.read()
            with open(out2) as f:
                b = f.read()
            self.assertEqual(a, b)
            self.assertEqual(len(net.rules), len(net2.rules))
        finally:
            os.unlink(out1)
            os.unlink(out2)


if __name__ == "__main__":
    unittest.main()
