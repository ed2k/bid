import unittest
from bid.translator import SystemTranslator
from bid.engine import Engine
from bid.models import Hand, Call, CallType, Strain, Seat

class TestBlueClubDefensive(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        dsl_path = "bid/system/blue_club.dsl"
        with open(dsl_path, "r") as f:
            dsl_text = f.read()
        translator = SystemTranslator()
        cls.system = translator.parse(dsl_text)
        print(f"DEBUG: Parsed {len(cls.system.rules)} rules.")
        # Find 1NT rules
        nt_rules = [r for r in cls.system.rules if str(r.call) == '1NT']
        print(f"DEBUG: Found {len(nt_rules)} 1NT rules.")
        for r in nt_rules:
             print(f"  - 1NT Rule: {r.description} Prio={r.priority}")
             # We can't easily inspect trigger closure, but description helps.
        
        cls.engine = Engine(cls.system)

    def assertBid(self, hand_str, expected_bid_str, history=None):
        if history is None:
            history = []
        hand = Hand.from_string(hand_str)
        print(f"DEBUG TEST: Hand {hand_str} HCP={hand.hcp} Controls={hand.controls}")
        bid = self.engine.get_bid(history, hand)
        self.assertEqual(str(bid), expected_bid_str, 
            f"Hand {hand_str} should bid {expected_bid_str} but got {bid}. Hist={history}")

    def test_direct_overcalls(self):
        # 1. (1C) - 1D
        # Opponent bids 1C. I bid ?
        hist_1c = [Call(CallType.BID, 1, Strain.CLUBS)] # No Pass!
        
        # Hand: A432 H432 DAQJ98 C2 (12 HCP, 5+ D)
        self.assertBid("SA432 H432 DAQJ98 C2", "1D", hist_1c)
        
        # 2. (1D) - 1S
        hist_1d = [Call(CallType.BID, 1, Strain.DIAMONDS)]
        # Hand: AKQJ98 H432 D2 C432 (13 HCP, 6S)
        self.assertBid("SAKQJ98 H432 D2 C432", "1S", hist_1d)

    def test_nt_overcall(self):
        # (1H) - 1NT (16-18)
        hist_1h = [Call(CallType.BID, 1, Strain.HEARTS)]
        # Hand: KQJ2 H A32 D KQJ2 C Q2 (18 HCP Bal)
        self.assertBid("SKQJ2 HA32 DKQJ2 CQ2", "1NT", hist_1h)

    def test_doubles(self):
        # (1D) - X (Takeout)
        hist_1d = [Call(CallType.BID, 1, Strain.DIAMONDS)]
        # Hand: AKJ2 H AKJ2 D 2 C 5432 (16 HCP, Short D)
        self.assertBid("SAKJ2 HAKJ2 D2 C5432", "X", hist_1d)

    def test_standard_response_still_works(self):
        # Verify 1C - 1D (Response) with Pass
        # Partner 1C, Opp Pass, Me ?
        # 1C - 1D rule implies pass.
        hist_part_1c = [Call(CallType.BID, 1, Strain.CLUBS), Call(CallType.PASS)]
        
        # Hand: 432 432 432 4321 (0 HCP)
        # Should bid 1D (Negative response) NOT 1D (Overcall 8+)
        # If triggers are confused, both might match.
        # But Overcall 1D requires 8+ HCP.
        # Response 1D requires 0-5 HCP.
        # So even if trigger matches, constraints will disambiguate.
        self.assertBid("S432 H432 D432 C4321", "1D", hist_part_1c)

if __name__ == "__main__":
    unittest.main()
