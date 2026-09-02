import unittest
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from bid.autoloop import paired_z, classify


class TestStatsHelpers(unittest.TestCase):
    def test_paired_z_constant_delta_is_infinite(self):
        self.assertEqual(paired_z([5.0] * 10), float("inf"))

    def test_paired_z_zero_is_zero(self):
        self.assertEqual(paired_z([0.0] * 10), 0.0)

    def test_paired_z_sign(self):
        self.assertGreater(paired_z([3.0, -1.0, 5.0, 2.0, -2.0]), 0)
        self.assertLess(paired_z([-d for d in [3.0, -1.0, 5.0, 2.0, -2.0]]), 0)

    def test_classify_thresholds(self):
        self.assertEqual(classify(5.0, 2.5), "accept")
        self.assertEqual(classify(0.0, float("inf")), "escalate")
        self.assertEqual(classify(-1.0, float("-inf")), "reject")
        self.assertEqual(classify(-5.0, -2.5), "reject")
        self.assertEqual(classify(0.1, 0.9), "escalate")
        self.assertEqual(classify(-0.1, -0.9), "escalate")


if __name__ == "__main__":
    unittest.main()
