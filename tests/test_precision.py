import unittest
from bid.translator import SystemTranslator
from bid.engine import Engine
from bid.models import Hand, Call, CallType, Strain
from bid.system import BiddingSystem

class TestPrecision(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        dsl_path = "system/precision.dsl"
        with open(dsl_path, "r") as f:
            dsl_text = f.read()
        translator = SystemTranslator()
        cls.system = translator.parse(dsl_text)
        cls.engine = Engine(cls.system)

    def assertBid(self, hand_str, expected_bid_str, history=None):
        if history is None:
            history = []
        hand = Hand.from_string(hand_str)
        bid = self.engine.get_bid(history, hand)
        self.assertEqual(str(bid), expected_bid_str, 
            f"Hand {hand_str} (HCP={hand.hcp}) with history {history} should bid {expected_bid_str} but got {bid}.")

    def test_openings(self):
        # 1. Strong 1C (16+)
        # S: AKQJ H: KQJ D: QJ432 C: 2 (19 HCP)
        self.assertBid("SAKQJ HKQJ DQJ432 C2", "1C")
        
        # 2. 1N (10-12 Balanced)
        # S: QJ2 H: QJ2 D: QJ32 C: Q32 (10 HCP Bal)
        self.assertBid("SQJ2 HQJ2 DQJ32 CQ32", "1NT")

        # 3. 2C (11-15, 6+ C)
        # S: 43 H: 43 D: 432 C: KQJ987 (10 HCP? No, need 11-15).
        # S: K3 H: 43 D: 432 C: AKQJ98 (14 HCP)
        self.assertBid("SK3 H43 D432 CAKQJ98", "2C")
        
        # 4. 2D (11-15, Short D)
        # 4-4-1-4 Dist. S: KQJ2 H: KQJ2 D: 2 C: K432 (14 HCP)
        self.assertBid("SKQJ2 HKQJ2 D2 CK432", "2D")

        # 5. 1H (11-15, 5+ H)
        # S: 432 H: AKJ43 D: K43 C: A3 (11+4=15 HCP)
        self.assertBid("S432 HAKJ43 DK43 CA3", "1H")

        # 6. 1S (11-15, 5+ S)
        self.assertBid("SAKJ43 H432 DK43 CA3", "1S")

        # 7. 1D (11-15 Catch-all, 2+ D)
        # 5 Clubs but only 5 (so not 2C), Not 5M, Not Bal (13-15 range?)
        # Text 1D: "11-15 HCP with 2+ Diamonds"
        # If 4-4-3-2 and 13 HCP? 1N is 10-12. So 1D covers 13-15 Bal?
        # Let's try 13 HCP Bal.
        # S: K32 H: K32 D: K32 C: KJ32 (13 HCP).
        # Should NOT be 1C (16+). NOT 1N (10-12).
        # NOT 1H/S. NOT 2C/D.
        # Fallback to 1D.
        self.assertBid("SK32 HK32 DK32 CKJ32", "1D")

    def test_responses_to_1c(self):
        history = [Call(CallType.BID, 1, Strain.CLUBS), Call(CallType.PASS)]
        
        # 1. 1D Negative (0-7)
        # S: 432 H: 432 D: 432 C: 4321 (0 HCP)
        self.assertBid("S432 H432 D432 C4321", "1D", history)
        
        # 2. 1H Positive (8+, 5+ H)
        # S: 3 H: KQJ43 D: A32 C: 432 (6+4=10 HCP, Unbal)
        self.assertBid("S3 HKQJ43 DA32 C432", "1H", history)

        # 3. 1N Positive Bal (8-13)
        # S: K32 H: Q32 D: Q32 C: Q432 (9 HCP, Bal)
        self.assertBid("SK32 HQ32 DQ32 CQ432", "1NT", history)

        # 4. 2N Balanced Positive (14+)
        # S: AK2 H: K32 D: Q32 C: Q432 (14 HCP)
        self.assertBid("SAK2 HK32 DQ32 CQ432", "2NT", history)

    def test_responses_to_1n(self):
        # 1N (10-12)
        history = [Call(CallType.BID, 1, Strain.NT), Call(CallType.PASS)]
        
        # 1. 2D Forcing Stayman (13+, 4M)
        # S: AKQ2 H: A32 D: K32 C: 432 (9+4+3=16 HCP).
        self.assertBid("SAKQ2 HA32 DK32 C432", "2D", history)

        # 2. 2H To Play (0-7, 5+H)
        # S: 432 H: QJ982 D: 432 C: 32 (5 HCP)
        self.assertBid("S432 HQJ982 D432 C32", "2H", history)

    def test_rebids_1c_1d(self):
        # Sequence: 1C - Pass - 1D - Pass
        history = [Call(CallType.BID, 1, Strain.CLUBS), Call(CallType.PASS),
                   Call(CallType.BID, 1, Strain.DIAMONDS), Call(CallType.PASS)]
                   
        # 1. 1N Rebid (16-19 Bal)
        # S: KJ32 H: AQ2 D: K32 C: K32 (3+1 + 4+2 + 3 + 3 = 16 HCP Bal)
        self.assertBid("SKJ32 HAQ2 DK32 CK32", "1NT", history)

        # 2. 2N Rebid (20-21 Bal)
        # S: AKJ3 H: AQ2 D: K32 C: A32 (8+6+3+4 = 21 HCP Bal)
        self.assertBid("SAKJ3 HAQ2 DK32 CA32", "2NT", history)

        # 3. 3N Rebid (24-26 Bal)
        # S: AKQJ H: AKQ D: K32 C: Q32 (25 HCP Bal)
        self.assertBid("SAKQJ HAKQ DK32 CQ32", "3NT", history)

    def test_defensive_bidding(self):
        # 1. Simple Overcall: (1D) - 1H (11-15 HCP, 5+H)
        history_1d = [Call(CallType.BID, 1, Strain.DIAMONDS)]
        # S: 432 H: AKJ32 D: 432 C: 32 (4+3+1 = 8 in H. NEED 11+. Add K in S).
        # S: K432 H: AKJ32 D: 432 C: 3 (3+8=11 HCP)
        self.assertBid("SK432 HAKJ32 D432 C3", "1H", history_1d)

        # 2. 1NT Overcall: (1D) - 1NT (16-18)
        # S: AKJ2 H: KQJ2 D: Q32 C: 32 (8+6+2=16 HCP Bal)
        self.assertBid("SAKJ2 HKQJ2 DQ32 C32", "1NT", history_1d)

        # 3. Takeout Double: (1C) - X (13+, Shortness)
        history_1c = [Call(CallType.BID, 1, Strain.CLUBS)]
        # S: AK32 H: A432 D: A432 C: 2 (7+4+4=15 HCP)
        self.assertBid("SAK32 HA432 DA432 C2", "X", history_1c)

        # 4. Michaels Cuebid: (1C) - 2C (14+, 5-5 Majors)
        # S: KQJ32 H: KQJ32 D: 32 C: 2 (14 HCP? 6+6 = 12. Need more).
        # S: AKJ32 H: AKJ32 D: 32 C: 2 (18 HCP)
        self.assertBid("SAKJ32 HAKJ32 D32 C2", "2C", history_1c)

    def test_nt_defense(self):
        # (1NT)
        history_1nt = [Call(CallType.BID, 1, Strain.NT)]
        
        # 1. 2C (5-5 Minors)
        # S: 2 H: 32 D: KQJ43 CKQJ32 (12 HCP, 5-5 Minors. 1+2+5+5=13 cards)
        self.assertBid("S2 H32 DKQJ43 CKQJ32", "2C", history_1nt)

        # 2. 2D (5-5 Majors)
        # S: KQJ32 H: KQJ32 D: 32 C: 2 (12 HCP)
        self.assertBid("SKQJ32 HKQJ32 D32 C2", "2D", history_1nt)

        # 3. Double (16+ Balanced)
        # S: AKJ2 H: KQ32 D: A32 C: 32 (8+5+4 = 17 HCP)
        self.assertBid("SAKJ2 HKQ32 DA32 C32", "X", history_1nt)

if __name__ == "__main__":
    unittest.main()
