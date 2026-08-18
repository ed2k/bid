import unittest
from bid.models import Hand, Card, Suit, Strain, Rank, Seat, Call, CallType
from bid.features import BridgeFeatures
from bid.sampling import Deal, PartialState

class TestFeaturesAndState(unittest.TestCase):

    def test_hand_feature_extraction(self):
        # 16 HCP, 5 spades, 3 hearts, 3 diamonds, 2 clubs, balanced, 4 controls (A=2, K=1, K=1)
        hand = Hand.from_string("SAKQ32 HK32 DA32 C43")
        feats = BridgeFeatures.extract_hand_features(hand)

        self.assertEqual(feats["hcp"], 16)
        self.assertEqual(feats["spade_len"], 5)
        self.assertEqual(feats["heart_len"], 3)
        self.assertEqual(feats["diamond_len"], 3)
        self.assertEqual(feats["club_len"], 2)
        self.assertTrue(feats["is_balanced"])
        self.assertFalse(feats["has_void"])
        self.assertFalse(feats["has_singleton"])
        self.assertEqual(feats["controls"], 6) # SA=2, SK=1, HK=1, DA=2
        self.assertEqual(feats["ace_count"], 2)
        self.assertEqual(feats["king_count"], 2)
        self.assertEqual(feats["queen_count"], 1)

    def test_auction_feature_extraction(self):
        history = [
            Call(CallType.BID, 1, Strain.HEARTS),
            Call(CallType.PASS),
            Call(CallType.BID, 2, Strain.HEARTS),
            Call(CallType.PASS)
        ]
        # South is deciding next
        feats = BridgeFeatures.extract_auction_features(history, my_seat=Seat.SOUTH, dealer=Seat.NORTH)
        self.assertEqual(feats["auction_len"], 4)
        self.assertFalse(feats["is_opening"])
        self.assertEqual(feats["last_bid_level"], 2)
        self.assertEqual(feats["last_bid_strain"], "H")

    def test_partial_state_contract_determination(self):
        # North 1H - East Pass - South 4H - West Pass - North Pass - East Pass (Over!)
        history = [
            Call(CallType.BID, 1, Strain.HEARTS),
            Call(CallType.PASS),
            Call(CallType.BID, 4, Strain.HEARTS),
            Call(CallType.PASS),
            Call(CallType.PASS),
            Call(CallType.PASS)
        ]
        hand = Hand.random()
        ps = PartialState(Seat.SOUTH, hand, history, dealer=Seat.NORTH)

        self.assertTrue(ps.is_auction_over())
        contract = ps.get_contract()
        self.assertIsNotNone(contract)
        level, strain, declarer, doubled = contract
        self.assertEqual(level, 4)
        self.assertEqual(strain, Strain.HEARTS)
        self.assertEqual(declarer, Seat.NORTH) # First bidder of hearts
        self.assertEqual(doubled, 0)

if __name__ == "__main__":
    unittest.main()
