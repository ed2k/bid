import unittest
from bid.translator import SystemTranslator
from bid.engine import Engine
from bid.models import Hand, Call, CallType, Strain

class TestBlueClubSlam(unittest.TestCase):
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
            f"Hand {hand_str} (Aces={hand.ace_count}, Topo={hand.ace_topology}) should bid {expected_bid_str} but got {bid}. Hist={history}")

    def test_ace_asking_responses(self):
        # History: 1C -> 1S -> 4NT (Ace Ask)
        # History: 1C -> Pass -> 1S -> Pass -> 4NT (Ace Ask) -> Pass
        hist = [Call(CallType.BID, 1, Strain.CLUBS), Call(CallType.PASS),
                Call(CallType.BID, 1, Strain.SPADES), Call(CallType.PASS),
                Call(CallType.BID, 4, Strain.NT), Call(CallType.PASS)]
        
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
        # History: 1C -> Pass -> 1S -> Pass
        hist = [Call(CallType.BID, 1, Strain.CLUBS), Call(CallType.PASS),
                Call(CallType.BID, 1, Strain.SPADES), Call(CallType.PASS)]
        
        # 1. 1NT Rebid (18-20 Balanced)
        # S: KQJ H: KQJ D: QJ432 C: A2 (18 HCP Balanced, 1 Ace=2+K=1+K=1=4 Ctrl? No.
        # Wait, Opener is the one bidding 1NT. Opener has 17+.
        # Hand: S KQJ H KQJ D QJ432 C A2 (18 HCP). 
        # Controls: A(2), K(1), K(1), K(1) = 5 Controls?
        # 1C opening needs 17+ HCP.
        # This hand counts controls for response, but opener just needs HCP.
        self.assertBid("SKQJ HKQJ DQJ432 CA2", "1NT", hist)

        # 2. 2H Rebid (Natural 5+)
        # S: A2 H: AKQJ2 D: QJ32 C: 432 (18 HCP, 5H)
        self.assertBid("SA2 HAKQJ2 DQJ32 C432", "2H", hist)
        
        # 3. 2D Rebid (Natural 5+)
        # S: A2 H: K32 D: AKQJ2 C: 432 (17 HCP, 5D)
        self.assertBid("SA2 HK32 DAKQJ2 C432", "2D", hist)

        # 3. 2D Rebid (Natural 5+)
        # S: A2 H: K32 D: AKQJ2 C: 432 (17 HCP, 5D)
        self.assertBid("SA2 HK32 DAKQJ2 C432", "2D", hist)

    def test_game_quant_sequences(self):
        # 1. 1S - 4S (Fast Arrival)
        # 1. 1S - 4S (Fast Arrival)
        hist_1s = [Call(CallType.BID, 1, Strain.SPADES), Call(CallType.PASS)]
        # S: QJ987 H: K32 D: 432 C: 32 (6 HCP, 5S). Weak.
        self.assertBid("SQJ987 HK32 D432 C32", "4S", hist_1s)
        
        # 2. 1NT - 3NT (To Play)
        # 2. 1NT - 3NT (To Play)
        hist_1nt = [Call(CallType.BID, 1, Strain.NT), Call(CallType.PASS)]
        # S: K32 H: K32 D: K32 C: K432 (12 HCP Bal). 16+12=28. Game.
        self.assertBid("SK32 HK32 DK32 CK432", "3NT", hist_1nt)
        
        # 3. 1NT - 4NT (Quant)
        # S: KQ2 H: KQ2 D: KQ2 C: Q432 (17 HCP). 16+17=33. Slam Invite.
        self.assertBid("SKQ2 HKQ2 DKQ2 CQ432", "4NT", hist_1nt)
        
        # 4. 2NT - 3NT (To Play)
        # 4. 2NT - 3NT (To Play)
        hist_2nt = [Call(CallType.BID, 2, Strain.NT), Call(CallType.PASS)]
        # S: Q32 H: Q32 D: Q32 C: Q432 (8 HCP). 21+8=29. Game.
        self.assertBid("SQ32 HQ32 DQ32 CQ432", "3NT", hist_2nt)

if __name__ == "__main__":
    unittest.main()
