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

    def test_clean_alert_suit_symbols(self):
        from bid.lin import clean_alert
        self.assertEqual(clean_alert("Strong 2 !C opening"), "Strong 2 ♣ opening")
        self.assertEqual(clean_alert("!S transfer over 1!N"), "♠ transfer over 1NT")
        self.assertEqual(clean_alert("5+ !H; 4+ !D"), "5+ ♥; 4+ ♦")

    def test_parse_bbo_handviewer_url_and_identify(self):
        from bid.lin import clean_alert
        from bid.system_identifier import BiddingSystemIdentifier
        url = (
            "https://www.bridgebase.com/tools/handviewer.html?lin="
            "pn%7CBrill,Lia,Brill,Lia%7Cst%7C%7Cmd%7C1SK9654HT95DJ73C62,SATHADAKQT9862CKJ,"
            "S3HKQJ763DCA97543,SQJ872H842D54CQT8%7Csv%7C0%7Cah%7CBoard%2059%20(Open)%7C"
            "mb%7CP%7Can%7COpening%20Bid,%20HCP-12,%20RuleOf-21%7C"
            "mb%7C2C%7Can%7C*%20Artificial%20-%20Strong%202%20!C%20Opening%20-%2022+%20hcp%7C"
            "mb%7C2H%7Can%7CResponses%20to%202C,%20H+6,%20LoserLevel+2%7C"
            "mb%7C2S%7Can%7CNatural%20-%204+%20hcp%20%20-%20Game%20Forcing%20-%20At%20least%205%E2%99%A0%7C"
            "mb%7CP%7Can%7CLast%20resort%20-%20defensive,%20Sensible%7C"
            "mb%7C4D%7Can%7CNatural%20-%20Slam%20Try%20-%2024+%20hcp%20%20-%20Forcing%20-%20At%20least%208%E2%99%A6%7C"
            "mb%7CP%7Can%7CLast%20resort%20-%20defensive,%20Sensible%7C"
            "mb%7C5D%7Can%7CTo%20play%20-%20Maximum%202%20cards%20among%20aces%20+%20K/Q%20of%20trump%7C"
            "mb%7CP%7Can%7CLast%20resort%20-%20defensive,%20Sensible%7C"
            "mb%7C6D%7Can%7CNatural%20-%2026+%20hcp%7C"
            "mb%7CP%7Can%7CLast%20resort%20-%20defensive,%20Sensible%7C"
            "mb%7CP%7Can%7CNo%20new%20information%20-%204-5%20hcp%7C"
            "mb%7CP%7Can%7CLast%20resort%20-%20defensive,%20Sensible%7C"
            "pc%7ChK%7Cpc%7Ch2%7Cpc%7Ch9%7Cpc%7ChA%7Cpc%7CdQ%7Cpc%7Cc5%7Cpc%7Cd4%7Cpc%7Cd3%7C"
        )
        deals = self.parser.parse(url)
        self.assertEqual(len(deals), 1)
        deal = deals[0]

        # Check 1-to-1 alert mapping
        self.assertEqual(len(deal.bidding_history), len(deal.bidding_alerts))
        self.assertEqual(len(deal.bidding_history), 13)

        # Check alert on 2C
        self.assertIn("22+ hcp", deal.bidding_alerts[1])
        cleaned_2c = clean_alert(deal.bidding_alerts[1])
        self.assertIn("Strong 2 ♣ Opening", cleaned_2c)

        # Identify system
        sys_res = BiddingSystemIdentifier.identify(deal)
        self.assertTrue(sys_res.is_bbo_gib)
        self.assertIn("BBO GIB", sys_res.ew.system_name)
        self.assertEqual(sys_res.ew.confidence, "High")
        self.assertIn("Strong 2♣ Opening", sys_res.ew.key_conventions)
        self.assertIn("Slam Try", sys_res.ew.key_conventions)

    def test_identify_system_precision(self):
        from bid.system_identifier import BiddingSystemIdentifier
        precision_lin = (
            "pn|N,E,S,W|st||"
            "md|3SAK2HAQ3DAKJ2CKQ2,S87H8754D874C8765,SQJT9HKJT9D965CAT,S6543H62DQT3CJ943|"
            "sv|o|mb|1C|an|Artificial 16+ HCP|mb|P|mb|1D|an|0-7 HCP negative|mb|P|mb|1N|mb|P|mb|3N|mb|P|mb|P|mb|P|"
        )
        deal = self.parser.parse(precision_lin)[0]
        sys_res = BiddingSystemIdentifier.identify(deal)
        self.assertEqual(sys_res.ns.system_name, "Precision Club")
        self.assertEqual(sys_res.ns.confidence, "High")
        self.assertIn("Strong 1♣ Opening", sys_res.ns.key_conventions)

    def test_identify_system_acol(self):
        from bid.system_identifier import BiddingSystemIdentifier
        acol_lin = (
            "pn|N,E,S,W|st||"
            "md|1SAKJ2H874DA87CK98,S87HKQJT9DQJ5CT76,SQ65HA532DK43CQJ4,ST943H6DT962CA532|"
            "sv|o|mb|1N|an|Weak 1NT 12-14|mb|P|mb|3N|mb|P|mb|P|mb|P|"
        )
        deal = self.parser.parse(acol_lin)[0]
        sys_res = BiddingSystemIdentifier.identify(deal)
        self.assertEqual(sys_res.ns.system_name, "Acol")
        self.assertEqual(sys_res.ns.confidence, "High")

    def test_select_reference_dsl(self):
        from bid.system_identifier import BiddingSystemIdentifier
        from bid.explain_board import select_reference_dsl
        url = "https://www.bridgebase.com/tools/handviewer.html?lin=pn%7CBrill,Lia,Brill,Lia%7Cst%7C%7Cmd%7C1SK9654HT95DJ73C62,SATHADAKQT9862CKJ,S3HKQJ763DCA97543,SQJ872H842D54CQT8%7Csv%7C0%7Cah%7CBoard%2059%20(Open)%7Cmb%7CP%7Can%7COpening%20Bid,%20HCP-12,%20RuleOf-21%7Cmb%7C2C%7Can%7C*%20Artificial%20-%20Strong%202%20!C%20Opening%20-%2022+%20hcp%7C"
        deal = self.parser.parse(url)[0]
        sys_res = BiddingSystemIdentifier.identify(deal)
        dsl_path, reason = select_reference_dsl(sys_res, "system/champion_system.dsl")
        self.assertTrue(dsl_path.endswith("gib.dsl"))
        self.assertIn("auto-selected", reason)


if __name__ == "__main__":
    unittest.main()


