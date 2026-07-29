import unittest
from bid.lin import LinParser, LinDeal
from bid.models import Seat, Suit, Rank, CallType, Strain

class TestLinParser(unittest.TestCase):

    def setUp(self):
        self.parser = LinParser()

    def test_parse_hand_str(self):
        hand_str = "SAK92HKQJDJT9CKQ"
        hand = self.parser.parse_hand_str(hand_str)
        self.assertEqual(hand.length(Suit.SPADES), 4)
        self.assertEqual(hand.length(Suit.HEARTS), 3)
        self.assertEqual(hand.length(Suit.DIAMONDS), 3)
        self.assertEqual(hand.length(Suit.CLUBS), 2)
        self.assertEqual(hand.hcp, 19)

    def test_parse_mb_calls(self):
        self.assertEqual(str(self.parser._parse_mb_tag("1C")), "1C")
        self.assertEqual(str(self.parser._parse_mb_tag("1N")), "1NT")
        self.assertEqual(str(self.parser._parse_mb_tag("1NT")), "1NT")
        self.assertEqual(str(self.parser._parse_mb_tag("p")), "PASS")
        self.assertEqual(str(self.parser._parse_mb_tag("d")), "X")
        self.assertEqual(str(self.parser._parse_mb_tag("r")), "XX")
        self.assertEqual(str(self.parser._parse_mb_tag("4S!")), "4S")

    def test_parse_full_lin(self):
        sample_lin = (
            "qx|o1|pn|SouthPlayer,WestPlayer,NorthPlayer,EastPlayer|"
            "st||md|1SAK92HKQJDJT9CKQ3,ST876H543DA87CT98,SQJ54HAT92DKQ5CJ2|"
            "sv|o|mb|1N|an|15-17|mb|p|mb|2C|mb|p|mb|2S|mb|p|mb|4S|mb|p|mb|p|mb|p|"
            "pc|C9|pc|C2|pc|CA|pc|CK|mc|10|"
        )
        deals = self.parser.parse(sample_lin)
        self.assertEqual(len(deals), 1)
        deal = deals[0]
        
        self.assertEqual(deal.board_id, "o1")
        self.assertEqual(deal.dealer, Seat.SOUTH)
        self.assertEqual(deal.vulnerability, "NONE")
        self.assertEqual(deal.players[Seat.SOUTH], "SouthPlayer")
        self.assertEqual(deal.players[Seat.NORTH], "NorthPlayer")
        
        # Check hands (South, West, North explicitly parsed; East inferred)
        self.assertIsNotNone(deal.hands[Seat.SOUTH])
        self.assertIsNotNone(deal.hands[Seat.WEST])
        self.assertIsNotNone(deal.hands[Seat.NORTH])
        self.assertIsNotNone(deal.hands[Seat.EAST])
        self.assertEqual(len(deal.hands[Seat.EAST].cards), 13)
        
        # Check bidding
        bids = [str(b) for b in deal.bidding_history]
        self.assertEqual(bids, ["1NT", "PASS", "2C", "PASS", "2S", "PASS", "4S", "PASS", "PASS", "PASS"])
        self.assertIn("15-17", deal.bidding_alerts)
        
        # Check play & claim
        self.assertEqual(deal.play_history, ["C9", "C2", "CA", "CK"])
        self.assertEqual(deal.claim, 10)

    def test_parse_user_sample_lin(self):
        sample_lin = (
            "pn|Dale57,~Mwest,~Mnorth,~Meast|st||"
            "md|2SAJ93HA8543DAK93C,S8HKJ972DQJ8CKT63,ST7542HQTD2CAQ752,SKQ6H6DT7654CJ984|"
            "sv|n|rh||ah|Board 12|"
            "mb|P|mb|P|mb|P|"
            "mb|1H|an|Major suit opening -- 5+ !H; 11-21 HCP; 12-22 total points|mb|P|"
            "mb|1S|an|One over one -- 4+ !S; 11- HCP; 6-12 total points|"
            "mb|P|mb|4C|an|Splinter -- 1- !C; 5+ !H; 4+ !S; 21- HCP; 19-22 total points|mb|P|"
            "mb|4H|an|Cue bid -- 1+ !D; 4+ !S; 11- HCP; no !DA; !HA; 11-12 total points|mb|P|"
            "mb|6S|an|1- !C; 5+ !H; 4+ !S; 21- HCP; 21-22 total points|mb|P|mb|P|mb|P|"
            "pc|H6|pc|HA|pc|H2|pc|HT|pc|DA|pc|D8|pc|D2|pc|D4|pc|DK|pc|DJ|pc|HQ|pc|D5|"
            "pc|D3|pc|DQ|pc|S2|pc|D6|pc|CA|pc|C4|pc|D9|pc|C3|pc|S4|pc|SQ|pc|SA|pc|S8|"
            "pc|H3|pc|H7|pc|S5|pc|S6|pc|SK|pc|S3|pc|C6|pc|S7|pc|DT|pc|S9|pc|CT|pc|C2|"
            "pc|H4|pc|H9|pc|ST|pc|D7|pc|C5|pc|C8|pc|SJ|pc|CK|pc|H8|pc|HJ|pc|C7|pc|C9|"
            "pc|HK|pc|CQ|pc|CJ|pc|H5|"
        )
        deals = self.parser.parse(sample_lin)
        self.assertEqual(len(deals), 1)
        deal = deals[0]

        self.assertEqual(deal.board_id, "Board 12")
        self.assertEqual(deal.dealer, Seat.WEST)
        self.assertEqual(deal.vulnerability, "NS")
        self.assertEqual(deal.players[Seat.SOUTH], "Dale57")
        self.assertEqual(deal.players[Seat.WEST], "~Mwest")

        # Verify South hand: SAJ93 HA8543 DAK93 C (void in clubs!)
        south_hand = deal.hands[Seat.SOUTH]
        self.assertIsNotNone(south_hand)
        self.assertEqual(south_hand.length(Suit.SPADES), 4)
        self.assertEqual(south_hand.length(Suit.HEARTS), 5)
        self.assertEqual(south_hand.length(Suit.DIAMONDS), 4)
        self.assertEqual(south_hand.length(Suit.CLUBS), 0) # Void in clubs!
        self.assertEqual(south_hand.hcp, 16)

        # Verify bidding sequence
        bids = [str(b) for b in deal.bidding_history]
        self.assertEqual(bids, ["PASS", "PASS", "PASS", "1H", "PASS", "1S", "PASS", "4C", "PASS", "4H", "PASS", "6S", "PASS", "PASS", "PASS"])

        # Verify played cards count
        self.assertEqual(len(deal.play_history), 52)

if __name__ == "__main__":
    unittest.main()
