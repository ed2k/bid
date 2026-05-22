import os
import unittest
from bid.translator import SystemTranslator
from bid.engine import Engine
from bid.models import Hand, Call, CallType, Strain, Seat
from bid.system import BiddingSystem

class TestCuebidsAndConventions(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Load and parse common.dsl
        translator = SystemTranslator()
        
        common_path = os.path.join(os.path.dirname(__file__), "..", "system", "cuebids", "common.dsl")
        with open(common_path, "r") as f:
            common_dsl = f.read()
            
        cls.common_system = translator.parse(common_dsl)
        cls.engine = Engine(cls.common_system)
        
    def test_metadata_parsing(self):
        # Find Michaels over 1C
        rule = None
        for r in self.common_system.rules:
            if r.call == Call(CallType.BID, 2, Strain.CLUBS) and r.sequence_history == ['(1C)']:
                rule = r
                break
        self.assertIsNotNone(rule, "Should find Michaels rule over 1C")
        self.assertEqual(rule.metadata.get('bid_class'), 'CUEBID')
        self.assertEqual(rule.metadata.get('cuebid_type'), 'Michaels')
        self.assertEqual(rule.metadata.get('cue_target'), 'OPP_SUIT')
        self.assertEqual(rule.metadata.get('forcing'), 'ONE_ROUND')
        
    def test_michaels_overcall(self):
        # History: opponent opens 1C. Next turn is me (East).
        # In history: [1C].
        history = [Call(CallType.BID, 1, Strain.CLUBS)]
        
        # Hand with 5-5 in Majors, 10 HCP (HCP=10, controls=3)
        hand_michaels = Hand.from_string("SKQ932 HKQ932 D32 C2")
        bid = self.engine.get_bid(history, hand_michaels)
        self.assertEqual(str(bid), "2C")
        
        # Hand with 4-4 in Majors, 10 HCP (should not trigger Michaels)
        hand_weak = Hand.from_string("SAKJ3 HKQ32 DA32 C42")
        bid_weak = self.engine.get_bid(history, hand_weak)
        self.assertEqual(str(bid_weak), "PASS")

    def test_drury_passed_hand(self):
        # Drury requires responder to have passed, and opener opened in 3rd/4th seat.
        # Dealer: North. 
        # North: Pass (0)
        # East: Pass (1)
        # South: 1H (2) - 3rd seat opening!
        # West: Pass (3)
        # North: bids 2C (Drury response)
        
        history = [
            Call(CallType.PASS),                  # North
            Call(CallType.PASS),                  # East
            Call(CallType.BID, 1, Strain.HEARTS), # South (Opener in 3rd seat)
            Call(CallType.PASS)                   # West
        ]
        
        # Hand: 9 HCP, 3 Hearts fit
        hand_fit = Hand.from_string("SJ32 HQ42 D432 CAQ32")
        
        # North is current player. North passed on turn 0, so North is a passed hand.
        # Partner (South) opened in 3rd seat (first bid index is 2).
        # Drury should trigger.
        bid = self.engine.get_bid(history, hand_fit)
        self.assertEqual(str(bid), "2C")

    def test_drury_not_passed_hand(self):
        # North (Dealer) opens 1H. East passes. South (not passed hand) responds 2C.
        # This is NOT Drury because South did not pass.
        history = [
            Call(CallType.BID, 1, Strain.HEARTS), # North
            Call(CallType.PASS)                   # East
        ]
        hand_fit = Hand.from_string("SJ32 HQ42 D432 CAQ32")
        bid = self.engine.get_bid(history, hand_fit)
        self.assertNotEqual(str(bid), "2C")

    def test_drury_not_3rd_4th_seat(self):
        # North (Dealer) opens 1H in 1st seat. North did not pass.
        # Drury should NOT trigger.
        history = [
            Call(CallType.PASS),                  # North
            Call(CallType.BID, 1, Strain.HEARTS), # East (2nd seat)
            Call(CallType.PASS),                  # South
            Call(CallType.PASS)                   # West
        ]
        hand_fit = Hand.from_string("SJ32 HQ42 D432 CAQ32")
        bid = self.engine.get_bid(history, hand_fit)
        self.assertNotEqual(str(bid), "2C")

    def test_drury_rebids(self):
        # Test Drury subminimum rebid (2H after 1H-2C)
        # History: Pass - Pass - 1H - Pass - 2C - Pass -> Opener to bid.
        history = [
            Call(CallType.PASS),                  # North
            Call(CallType.PASS),                  # East
            Call(CallType.BID, 1, Strain.HEARTS), # South (Opener)
            Call(CallType.PASS),                  # West
            Call(CallType.BID, 2, Strain.CLUBS),  # North (Drury responder)
            Call(CallType.PASS)                   # East
        ]
        
        # South (opener) has subminimum hand (11 HCP)
        hand_submin = Hand.from_string("SAKJ2 H65432 DK32 C2")
        bid_submin = self.engine.get_bid(history, hand_submin)
        self.assertEqual(str(bid_submin), "2H")
        
        # South (opener) has full opening hand (15 HCP)
        hand_full = Hand.from_string("SAKJ2 HAK432 DQ32 C2")
        bid_full = self.engine.get_bid(history, hand_full)
        self.assertEqual(str(bid_full), "2D")

    def test_override_strategy(self):
        # We parse common.dsl, and then parse a custom dsl that overrides Michaels (1C) - 2C.
        translator = SystemTranslator()
        
        common_path = os.path.join(os.path.dirname(__file__), "..", "system", "cuebids", "common.dsl")
        with open(common_path, "r") as f:
            dsl_text = f.read()
            
        custom_dsl = """
# Overriding Michaels over 1C with high HCP requirement
(1C) - 2C:
  BID_CLASS: CUEBID
  CUEBID_TYPE: Michaels
  HCP: 16+
  LEN H: 5+
  LEN S: 5+
"""
        # Load and parse by first parsing common as common, then custom as override
        system = translator.parse(dsl_text, is_common=True)
        translator.parse(custom_dsl, system=system, is_common=False)
        engine = Engine(system)
        
        # Hand with 12 HCP, 5-5 majors (matches common Michaels, but NOT overridden Michaels)
        hand_12 = Hand.from_string("SKQJ32 HQJ932 D42 C2")
        history = [Call(CallType.BID, 1, Strain.CLUBS)]
        
        bid = engine.get_bid(history, hand_12)
        self.assertNotEqual(str(bid), "2C")
        
        # Hand with 16 HCP, 5-5 majors (matches overridden Michaels)
        hand_16 = Hand.from_string("SAKJ32 HAKJ32 D42 C2")
        bid_16 = engine.get_bid(history, hand_16)
        self.assertEqual(str(bid_16), "2C")

if __name__ == "__main__":
    unittest.main()
