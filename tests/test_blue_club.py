import unittest
from bid.translator import SystemTranslator
from bid.engine import Engine
from bid.models import Hand, Call, CallType, Strain
from bid.system import BiddingSystem

class TestBlueClub(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        dsl_path = "bid/system/blue_club.dsl"
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
            f"Hand {hand_str} (HCP={hand.hcp}, Ctrl={hand.controls}) with history {history} should bid {expected_bid_str} but got {bid}.")

    def test_openings(self):
        # 1. Strong 1C (17+)
        # S: AKQJ H: KQJ D: QJ432 C: 2 (19 HCP)
        self.assertBid("SAKQJ HKQJ DQJ432 C2", "1C")
        
        # 2. Natural 1D (11-16, 3+ D)
        # S: KQJ (5) H: QJ3 (3) D: QJ32 (3) C: J2 (1). Total 12. 
        # Needs to be 1D. No 4M.
        self.assertBid("SKQJ HQJ3 DQJ32 CJ2", "1D")
        
        # 3. Natural 1H (11-16, 4+ H)
        # S: 432 H: AKJ32 (8) D: K432 (3) C: 43. Total 11.
        self.assertBid("S432 HAKJ32 DK432 C43", "1H")
        
        # 4. Natural 1S (11-16, 4+ S)
        # S: AKJ32 (8) H: 432 D: K432 (3) C: 43. Total 11.
        self.assertBid("SAKJ32 H432 DK432 C43", "1S")
        
        # 5. 1NT (16-17 Balanced)
        # S: KQJ2 (6) H: KQJ2 (6) D: KJ2 (4) C: 32 (0). Total 16.
        self.assertBid("SKQJ2 HKQJ2 DKJ2 C32", "1NT")
        
        # 6. 2C (11-16, 5+ C)
        # S: 432 H: 432 D: K32 (3) C: AKJ32 (8). Total 11.
        self.assertBid("S432 H432 DK32 CAKJ32", "2C")
        
        # 7. 2D (17-24 Unbalanced) - Skipped specific check logic for now

        # 8. Weak 2H (6-11, 6+ H)
        # S: 32 H: KQJ987 D: 432 C: 32 (6 HCP, 6H)
        self.assertBid("S32 HKQJ987 D432 C32", "2H")

        # 9. Weak 2S (6-11, 6+ S)
        # S: KQJ987 H: 32 D: 432 C: 32 (6 HCP, 6S)
        self.assertBid("SKQJ987 H32 D432 C32", "2S")
        
        # 10. 2NT (21-22 Balanced)
        # S: AKQ H: AKQ D: KJ32 C: 432 (22 HCP)
        self.assertBid("SAKQ HAKQ DKJ32 C432", "2NT")

    def test_high_level_openings(self):
        # 3C (11-16, 7+ C)
        # S: 43 H: 43 D: 32 C: AKQJ432 (10 HCP + Dist?). 
        # Need 11-16 HCP. C: AKQJ432 = 10 HCP in suit. Add King elsewhere.
        # S: K2 H: 32 D: 432 C: AKQJ432 (13 HCP).
        self.assertBid("SK2 H32 D432 CAKQJ432", "3C")

        # 3D Weak (6-11, 7+ D)
        # S: 32 H: 32 D: KQJ9876 C: 32 (6 HCP).
        self.assertBid("S32 H32 DKQJ9876 C32", "3D")
        
        # 3S Weak (6-11, 7+ S)
        # S: KQJ9876 H: 32 D: 32 C: 32 (6 HCP).
        self.assertBid("SKQJ9876 H32 D32 C32", "3S")

        # 4H Weak (6-11, 8+ H)
        # S: 2 H: KQJ98765 D: 432 C: 2 (6 HCP, 8H).
        self.assertBid("S2 HKQJ98765 D432 C2", "4H")

    def test_responses_to_1c(self):
        # 1C opened
        history = [Call(CallType.BID, 1, Strain.CLUBS), Call(CallType.PASS)]
        
        # 1. 1D (0-5 HCP)
        # S: 432 H: 432 D: 432 C: 4321 (0 HCP)
        self.assertBid("S432 H432 D432 C4321", "1D", history)
        
        # 2. 1H (6+ HCP, 0-2 Controls)
        # S: QJ32 H: QJ32 D: QJ32 C: 2 (8 HCP). Queens/Jacks = 0 Controls.
        self.assertBid("SQJ32 HQJ32 DQJ32 C2", "1H", history)
        
        # 3. 1S (3 Controls)
        # S: A32 H: K32 D: 432 C: 432 (A=2, K=1 = 3 Controls). 7 HCP.
        self.assertBid("SA32 HK32 D432 C432", "1S", history)
        
        # 4. 1NT (4 Controls)
        # S: A32 H: A32 D: 432 C: 432 (A=2, A=2 = 4 Controls). 8 HCP.
        self.assertBid("SA32 HA32 D432 C432", "1NT", history)
        
        # 5. 2C (5 Controls)
        # S: A32 H: A32 D: K32 C: 432 (A=2, A=2, K=1 = 5). 11 HCP.
        self.assertBid("SA32 HA32 DK32 C432", "2C", history)
        
        # 6. 2D (6 Controls)
        # S: A32 H: A32 D: A32 C: 432 (A=2x3 = 6). 12 HCP.
        self.assertBid("SA32 HA32 DA32 C432", "2D", history)
        
        # 7. 2NT (7 Controls)
        # S: A32 H: A32 D: A32 C: K432 (2x3 + 1 = 7). 13 HCP.
        self.assertBid("SA32 HA32 DA32 CK432", "2NT", history)

    def test_other_responses(self):
        # 1H Responses
        hist_1h = [Call(CallType.BID, 1, Strain.HEARTS), Call(CallType.PASS)]
        
        # 1H - 1S (6+, 4S)
        self.assertBid("SKQJ2 H432 D432 C43", "1S", hist_1h)
        # 1H - 1NT (8-10)
        # S: 432 H: 43 D: KQJ2 (6) C: K432 (3). Total 9 HCP.
        self.assertBid("S432 H43 DKQJ2 CK432", "1NT", hist_1h)
        # 1H - 2C (11+, 3+ C) - 2/1 GF
        # S: K32 H: 43 D: 43 C: AKQJ32 (13 HCP).
        self.assertBid("SK32 H43 D43 CAKQJ32", "2C", hist_1h)
        # 1H - 2H (6-10, 3+ H) - Raise
        # S: J43 (1) H: KQ3 (5) D: 4321 C: 432. Total 6 HCP. No 4 Spades.
        self.assertBid("SJ43 HKQ3 D4321 C432", "2H", hist_1h)

        # 1NT Responses
        hist_1nt = [Call(CallType.BID, 1, Strain.NT), Call(CallType.PASS)]
        
        # 1NT - 2C (8-11 Relay)
        self.assertBid("S432 H432 D432 CAKJ2", "2C", hist_1nt)
        # 1NT - 2D (12+ Stayman)
        # Needs 4-card major to trigger Stayman
        self.assertBid("S432 HKQ32 DAKJ C32", "2D", hist_1nt)
        # 1NT - 2H (0-7 Weak 5H)
        self.assertBid("S432 HQJ987 D432 C2", "2H", hist_1nt)

    def test_rebids(self):
        # 1C - 1D - 1NT (18-20 Bal)
        # S: KQJ H: KQJ D: QJ432 C: A2 (18 HCP Balanced)
        # Sequence: 1C (Open), 1D (Resp), 1NT (Rebid)
        hist_1c_1d = [Call(CallType.BID, 1, Strain.CLUBS), Call(CallType.BID, 1, Strain.DIAMONDS)]
        self.assertBid("SKQJ HKQJ DQJ432 CA2", "1NT", hist_1c_1d)

        # 1H - 1S - 1NT (11-14 Bal)
        # S: QJ2 H: KQJ2 D: QJ32 C: 32 (12 HCP Bal)
        hist_1h_1s = [Call(CallType.BID, 1, Strain.HEARTS), Call(CallType.BID, 1, Strain.SPADES)]
        self.assertBid("SQJ2 HKQJ2 DQJ32 C32", "1NT", hist_1h_1s)
        
        # 1H - 1S - 2H (11-14, 5+H)
        # S: 2 H: KQJ32 D: QJ32 C: 432 (9 HCP? Needs 11-14)
        # S: 2 H: AKJ32 D: QJ32 C: 432 (11 HCP)
        self.assertBid("S2 HAKJ32 DQJ32 C432", "2H", hist_1h_1s)

    def test_ace_asking_responses(self):
        # History: 1C -> 1S -> 4NT (Ace Ask)
        hist = [Call(CallType.BID, 1, Strain.CLUBS), 
                Call(CallType.BID, 1, Strain.SPADES), 
                Call(CallType.BID, 4, Strain.NT)]
        
        # 1. 5C (1 or 4 Aces) -> 1 Ace
        # S: A432 (A) H: KQ3 D: KQJ2 C: 432. (1 Ace)
        self.assertBid("SA432 HKQ3 DKQJ2 C432", "5C", hist)
        
        # 2. 5D (0 or 3 Aces) -> 0 Aces
        # S: KQ43 H: KQ3 D: KQJ2 C: 432. (0 Aces)
        self.assertBid("SKQ43 HKQ3 DKQJ2 C432", "5D", hist)
        
        # 3. 5D (0 or 3 Aces) -> 3 Aces
        # S: AK43 H: AQ3 D: KQJ2 C: A32 (3 Aces: S, H, C)
        self.assertBid("SAK43 HAQ3 DKQJ2 CA32", "5D", hist)

        # 4. 5H (2 Aces, Same Rank) -> Both Majors (S+H)
        # S: A432 H: A43 D: KQJ2 C: K32. (Aces: S, H -> Rank)
        self.assertBid("SA432 HA43 DKQJ2 CK32", "5H", hist)
        
        # 5. 5H (2 Aces, Same Rank) -> Both Minors (D+C)
        # S: K432 H: K43 D: A432 C: A32. (Aces: D, C -> Rank)
        self.assertBid("SK432 HK43 DA432 CA32", "5H", hist)
        
        # 6. 5S (2 Aces, Mixed) -> S(Black) + D(Red) = Mixed?
        # S: A432 H: K43 D: A432 C: K32. (Aces: S, D).
        # S(Major, Black). D(Minor, Red).
        # Rank: Maj != Min. Color: Black != Red. -> Mixed.
        self.assertBid("SA432 HK43 DA432 CK32", "5S", hist)

        # 7. 5NT (2 Aces, Same Color) -> S + C (Black)
        # S: A432 H: K43 D: K432 C: A32. (Aces: S, C).
        # Rank: Maj != Min. Color: Black == Black. -> Same Color.
        self.assertBid("SA432 HK43 DK432 CA32", "5NT", hist)

    def test_1c_1s_sequences(self):
        # History: 1C -> 1S (3 Controls)
        hist = [Call(CallType.BID, 1, Strain.CLUBS), Call(CallType.BID, 1, Strain.SPADES)]
        
        # 1. 1NT Rebid (18-20 Balanced)
        # Opener: S: KQJ H: KQJ D: QJ432 C: A2 (18 HCP Balanced)
        self.assertBid("SKQJ HKQJ DQJ432 CA2", "1NT", hist)

        # 2. 2H Rebid (Natural 5+)
        # S: A2 H: AKQJ2 D: QJ32 C: 432 (18 HCP, 5H)
        self.assertBid("SA2 HAKQJ2 DQJ32 C432", "2H", hist)
        
        # 3. 2D Rebid (Natural 5+)
        # S: A2 H: K32 D: AKQJ2 C: 432 (17 HCP, 5D)
        self.assertBid("SA2 HK32 DAKQJ2 C432", "2D", hist)

    def test_game_quant_sequences(self):
        # 1. 1S - 4S (Fast Arrival)
        hist_1s = [Call(CallType.BID, 1, Strain.SPADES)]
        # S: QJ987 H: K32 D: 432 C: 32 (6 HCP, 5S). Weak.
        self.assertBid("SQJ987 HK32 D432 C32", "4S", hist_1s)
        
        # 2. 1NT - 3NT (To Play)
        hist_1nt = [Call(CallType.BID, 1, Strain.NT)]
        # S: K32 H: K32 D: K32 C: K432 (12 HCP Bal). 16+12=28. Game.
        self.assertBid("SK32 HK32 DK32 CK432", "3NT", hist_1nt)
        
        # 3. 1NT - 4NT (Quant)
        # S: KQ2 H: KQ2 D: KQ2 C: Q432 (17 HCP). 16+17=33. Slam Invite.
        self.assertBid("SKQ2 HKQ2 DKQ2 CQ432", "4NT", hist_1nt)
        
        # 4. 2NT - 3NT (To Play)
        hist_2nt = [Call(CallType.BID, 2, Strain.NT)]
        # S: Q32 H: Q32 D: Q32 C: Q432 (8 HCP). 21+8=29. Game.
        self.assertBid("SQ32 HQ32 DQ32 CQ432", "3NT", hist_2nt)

if __name__ == "__main__":
    unittest.main()
