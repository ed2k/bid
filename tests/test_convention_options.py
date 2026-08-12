import unittest
from bid.translator import SystemTranslator
from bid.system import BiddingSystem
from bid.models import Hand, Call, CallType

class TestConventionOptions(unittest.TestCase):
    def setUp(self):
        self.translator = SystemTranslator()

    def test_load_standalone_convention(self):
        system = BiddingSystem("TestSystem")
        self.translator.load_convention("cappelletti", system)
        
        self.assertTrue(system.has_convention("cappelletti"))
        self.assertGreater(len(system.rules), 0)
        
        # Check for Cappelletti 2D rule in system
        capp_rules = [r for r in system.rules if r.metadata.get('convention') == 'Cappelletti_BothMajors']
        self.assertEqual(len(capp_rules), 1)

    def test_load_system_with_conventions_directive(self):
        dsl_text = """
CONVENTIONS:
  - jacoby_2nt
  - drury

OPEN 1H:
  HCP: 12-21
  LEN H: 5+
"""
        system = self.translator.parse(dsl_text)
        self.assertTrue(system.has_convention("jacoby_2nt"))
        self.assertTrue(system.has_convention("drury"))
        
        jacoby_rules = [r for r in system.rules if r.metadata.get('convention') == 'Jacoby_2NT']
        self.assertEqual(len(jacoby_rules), 2)

    def test_load_system_with_custom_options(self):
        system = self.translator.load_system_with_conventions(
            "system/gib.dsl",
            convention_options=["cappelletti", "michaels"]
        )
        self.assertTrue(system.has_convention("cappelletti"))
        self.assertTrue(system.has_convention("michaels"))
        
        michaels_rules = [r for r in system.rules if r.metadata.get('convention') == 'Michaels_Cuebid']
        self.assertGreater(len(michaels_rules), 0)

if __name__ == '__main__':
    unittest.main()
