import unittest
from bid.translator import SystemTranslator
from bid.engine import Engine
from bid.models import Hand, Call, CallType, Strain
from bid.system import BiddingSystem

class TestGIBCompliance(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        dsl_path = "bid/system/gib.dsl"
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
        self.assertEqual(str(bid), expected_bid_str, f"Hand {hand_str} with history {history} should bid {expected_bid_str} but got {bid}. HCP={hand.hcp}, TP={hand.total_points}")

    def test_1nt_responses(self):
        # Partner opened 1NT (and Opp passed) 
        # History: [1NT, Pass] (assuming we are 3rd to act, or just 1NT in history)
        # Our engine history usually implies [Partner, Opp, Me, Opp] context?
        # The engine.get_bid logic takes a history list.
        # If I pass [1NT], it simulates the next bid.
        # But wait, `translator.py` `SEQUENCE` logic checks:
        # "Match parsed_sequence against the end of history"
        # 1NT - 2C. Sequence: [1NT]. History: [1NT, Pass].
        # real_calls in history: [1NT]. Matches [1NT].
        
        history = [Call(CallType.BID, 1, Strain.NT), Call(CallType.PASS)]

        # Stayman: 8+ TP, 4-card Major?
        # GIB note: "Promise at least one 4-card major unless inviting 3NT", 8+ HCP.
        # DSL: 1NT - 2C: TP 8+.
        # Hand: 10 HCP. 4 Spades.
        # S: KJ98 (4) H: 432 D: 432 C: A32 (3).
        self.assertBid("SKJ98 H432 D432 CA32", "2C", history) # Stayman

        # Transfer to Hearts: 5+ Hearts.
        # DSL: 1NT - 2D: Len H 5+.
        # Hand: 5 Hearts.
        # S: 43 H: KQJ98 (5) D: 432 C: 432.
        self.assertBid("S43 HKQJ98 D432 C432", "2D", history) # Transfer to Hearts

        # Transfer to Spades: 5+ Spades.
        # DSL: 1NT - 2H: Len S 5+.
        self.assertBid("SQJ987 H43 D432 C432", "2H", history) # Transfer to Spades

        self.assertBid("SQJ987 H43 D432 C432", "2H", history) # Transfer to Spades

    def test_stayman_rebids(self):
        # 1NT - 2C - ?
        history = [Call(CallType.BID, 1, Strain.NT), Call(CallType.PASS), Call(CallType.BID, 2, Strain.CLUBS), Call(CallType.PASS)]
        
        # Opener: No Major -> 2D
        # S: KJ432 H: K3 D: A432 C: K2 (14 HCP? Need 15-17).
        # S: K32 H: K32 D: AK32 C: A32. 4333. 17 HCP. No 4M.
        hand_no_major = Hand.from_string("SK32 HK32 DAK32 CA32")
        self.assertBid("SK32 HK32 DAK32 CA32", "2D", history)

        # Opener: 4 Hearts -> 2H
        # S: K32 H: KQ32 D: A32 C: A32. 
        self.assertBid("SK32 HKQ32 DA32 CA32", "2H", history)

    def test_major_responses(self):
        # 1H - ?
        history = [Call(CallType.BID, 1, Strain.HEARTS), Call(CallType.PASS)]
        
        # 1S Response (4+ Spades, 6+ HCP)
        # S: AJ43 (5 HCP). need 6+. Add Q to Hearts (2 HCP). Total 7.
        self.assertBid("SAJ43 HQ3 D432 C432", "1S", history)
        
        # 1NT Forcing (6-12 HCP, No Spades, No Hearts)
        # S: K43 (3 HCP). H: 43. D: Q9876 (2 HCP). C: J432 (1 HCP). Total 6. 3 Spades.
        self.assertBid("SK43 H43 DQ9876 CJ432", "1NT", history)
        
        # 2H Raise (6-9 HCP, 3+ Hearts)
        # S: 43. H: K987 (3 HCP). D: J9876 (1 HCP). C: Q43 (2 HCP). Total 6 HCP.
        self.assertBid("S43 HK987 DJ9876 CQ43", "2H", history)

    def test_minor_responses(self):
        # 1. Test 1C Responses
        history = [Call(CallType.BID, 1, Strain.CLUBS), Call(CallType.PASS)]
        
        # 1H Response (6+, 4H)
        # S: K432 (3 HCP). H: KJ43 (4 HCP). D: 432. C: 432. Total 7.
        self.assertBid("SK432 HKJ43 D432 C432", "1H", history)
        
        # 2C Inverted Minor (10+, 4C, No Major)
        # S: K32 H: K32 D: K32 C: K432 (12 HCP).
        self.assertBid("SK32 HK32 DK32 CK432", "2C", history)
        
        # 2. Test 1D Responses
        history_d = [Call(CallType.BID, 1, Strain.DIAMONDS), Call(CallType.PASS)]
        
        # 2C Game Force (12+ HCP, 4+ C)
        # S: K32 H: K32 D: 32 C: AKQJ2 (15 HCP).
        self.assertBid("SK32 HK32 D32 CAKQJ2", "2C", history_d)
        
        # 2D Inverted Minor (10+, 4D)
        # S: K32 H: 32 D: KQJ32 C: A32 (13 HCP).
        self.assertBid("SK32 H32 DKQJ32 CA32", "2D", history_d)

    def test_1nt_opening(self):
        # 16 HCP, 4333 -> 1NT
        self.assertBid("SAK43 HK43 DK43 CA43", "1NT") 
        # 15 HCP -> 1NT
        self.assertBid("SAK43 HK43 DK43 CK43", "1NT") # A=4, K=3. 4+3+3+3 = 13? Wait. 
        # Ace=4, King=3. A K 4 3 = 7. H K 4 3 = 3. D K 4 3 = 3. C K 4 3 = 3. Total = 16.
        # "SAK43" -> S A K 4 3.
        
        # Test 17 HCP
        # SA K Q J H K 4 3 D 4 3 2 C 4 3 2 -> 4+3+2+1 + 3 = 13.
        # Let's use simple high cards
        # S: AKQJ (10), H: K (3), D: K (3), C: J (1) = 17.
        # Shape: 4333
        self.assertBid("SAKQJ HK43 DK43 CJ43", "1NT")

    def test_not_1nt(self):
        # 18 HCP Balanced -> Not 1NT (should be 1C/1D?)
        # S: AKQJ(10) H:KQ(5) D:K(3) C:J(1) = 19. No.
        # S: AKQJ(10) H:KQ(5) D:Q(2) C:J(1) = 18.
        self.assertBid("SAKQJ HKQ3 DQ43 CJ43", "1C") # Or 1D. With 3C 3D, GIB says 1C.

        # 16 HCP Unbalanced -> Not 1NT
        # S: AKQJ(10) H:KQJ(6) D:-(0) C:432(0) = 16. Singleton D.
        self.assertBid("SAKQJ HKQJ54 D2 C54", "1H") # 5H, 4S (Total 13: 4+5+1+3). Unbalanced.

    def test_major_openings(self):
        # 1H: 5+ Hearts, 12-21
        # 13 HCP, 5H
        # S: K432 H: AQxxx D: xxx C: x -> K=3, AQ=6. 9. Need 12.
        # S: KJ43 H: AQJxx D: Kxx C: x -> KJ=4, AQJ=7, K=3 = 14.
        self.assertBid("SKJ43 HAQJ54 DK43 C2", "1H")

        # 1S: 5+ Spades
        self.assertBid("SAQJ54 HKJ43 DK43 C2", "1S")

    def test_minor_openings(self):
        # 1C: 3+ Clubs
        # 18 HCP Balanced (Too strong for 1NT)
        # S: AKQ2 H: KQ32 D: A32 C: 32 -> 9+5+4 = 18. Shape 4432.
        # With 3D 2C, 4432. GIB says "1D usually 4 unless 4432. Opens 1D with 4-4 in minors".
        # If 4432 (2C), likely 1D? But let's check our DSL rules.
        # Our DSL: 1C len 3+.
        # So 4432 with 2C doesn't fit 1C (3+). Does it fit 1D (3+)? Yes. So 1D.
        # Wait, our DSL says "1C LEN 3+". So with 2 Clubs, 1C is invalid.
        # So 18 HCP 4432 (2C) -> 1D.
        self.assertBid("SAKQ2 HKQ32 DA32 C32", "1D")
        
        # 4333 with 3C 3D. 1C vs 1D?
        # DSL rules are ordered 1NT, 1H, 1S, 1C, 1D.
        # If not 1NT range, check majors.
        # Then check 1C. If 3 clubs, matches 1C.
        # Logic: First matching rule wins.
        # To make "Better Minor" work (1C vs 1D), we rely on rule ordering or constraints.
        # Typically 1C (3+) is before 1D (3+)? Or vice versa?
        # In gib.dsl I put 1C before 1D. So equal length 3-3 -> 1C.
        # This matches GIB "1C could be 3 if 4333...".
        # S: AKQ2 (4) H: KQ32 (4) D: A32 (3) C: 32 (2). 13 Cards.
        # HCP: 9 + 5 + 4 + 0 = 18.
        # Shape: 4432. Balanced.
        # 18 HCP > 17 (1NT range). So should bid suit.
        # 4S, 4H. No 5 card major.
        # 3D, 2C.
        # GIB: "Opens 1D with 4-4 in minors". Here we have 3D 2C.
        # But we have 4S 4H.
        # DSL order: 1NT, 1H, 1S, 1C, 1D.
        # 1H/1S require 5+.
        # 1C require 3+. (We have 2C).
        # 1D require 3+. (We have 3D).
        # So should be 1D.
        # Wait, if 1C requires 3+, and we have 2, we can't bid 1C.
        # So 1D is forced.
        self.assertBid("SAKQ2 HKQ32 DA32 C32", "1D") # 18 HCP

    def test_strong_2c(self):
        # 2C: 22+ HCP
        # S: AKQJ(10) H: AKQ(9) D: K(3) C: 432 -> 22 HCP.
        self.assertBid("SAKQJ HAKQ2 DK32 C43", "2C")

    def test_weak_two(self):
        # 2H: 6-10 HCP, 6+ Hearts.
        # S: 432 H: KQT987 D: 432 C: 2 -> KQT=6. 6 HCP.
        # Unbalanced (Singleton C).
        # KQTJ92 (6 cards). HCP=6.
        # S:43(2) H:KQTJ92(6) D:432(3) C:43(2) = 13 cards.
        self.assertBid("S43 HKQTJ92 D432 C43", "2H") # HCP: 6. 6H. Unbal.

if __name__ == "__main__":
    unittest.main()
