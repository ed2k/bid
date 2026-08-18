import unittest
from bid.models import Seat, Strain, Hand, Card, Suit, Rank
from bid.scoring import calculate_contract_score, score_to_imp, estimate_double_dummy_tricks, Vulnerability

class TestScoring(unittest.TestCase):

    def test_making_contract_scores(self):
        # 1NT making exactly (7 tricks) non-vul: 40 + 50 (partscore) = 90
        self.assertEqual(calculate_contract_score(1, Strain.NT, Seat.SOUTH, 7, False), 90)

        # 1NT making +1 (8 tricks) non-vul: 40 + 30 + 50 = 120
        self.assertEqual(calculate_contract_score(1, Strain.NT, Seat.SOUTH, 8, False), 120)

        # 3NT making exactly (9 tricks) non-vul: (40 + 60) + 300 (game) = 400
        self.assertEqual(calculate_contract_score(3, Strain.NT, Seat.SOUTH, 9, False), 400)

        # 3NT making exactly (9 tricks) vulnerable: 100 + 500 (game) = 600
        self.assertEqual(calculate_contract_score(3, Strain.NT, Seat.SOUTH, 9, True), 600)

        # 4H making exactly (10 tricks) non-vul: 120 + 300 = 420
        self.assertEqual(calculate_contract_score(4, Strain.HEARTS, Seat.SOUTH, 10, False), 420)

        # 4H making exactly (10 tricks) vul: 120 + 500 = 620
        self.assertEqual(calculate_contract_score(4, Strain.HEARTS, Seat.SOUTH, 10, True), 620)

        # 6S (small slam) making exactly (12 tricks) vul: 180 + 500 (game) + 750 (slam) = 1430
        self.assertEqual(calculate_contract_score(6, Strain.SPADES, Seat.SOUTH, 12, True), 1430)

        # 7NT (grand slam) making 13 tricks vul: 220 + 500 + 1500 = 2220
        self.assertEqual(calculate_contract_score(7, Strain.NT, Seat.SOUTH, 13, True), 2220)

    def test_down_contract_scores(self):
        # 3NT down 1 non-vul undoubled: -50
        self.assertEqual(calculate_contract_score(3, Strain.NT, Seat.SOUTH, 8, False), -50)

        # 3NT down 2 vul undoubled: -200
        self.assertEqual(calculate_contract_score(3, Strain.NT, Seat.SOUTH, 7, True), -200)

        # 4S doubled down 1 non-vul: -100
        self.assertEqual(calculate_contract_score(4, Strain.SPADES, Seat.SOUTH, 9, False, doubled=1), -100)

        # 4S doubled down 2 non-vul: -300
        self.assertEqual(calculate_contract_score(4, Strain.SPADES, Seat.SOUTH, 8, False, doubled=1), -300)

        # 4S doubled down 1 vul: -200
        self.assertEqual(calculate_contract_score(4, Strain.SPADES, Seat.SOUTH, 9, True, doubled=1), -200)

    def test_imp_conversion(self):
        self.assertEqual(score_to_imp(0), 0)
        self.assertEqual(score_to_imp(10), 0)
        self.assertEqual(score_to_imp(30), 1)
        self.assertEqual(score_to_imp(420), 9)
        self.assertEqual(score_to_imp(-420), -9)
        self.assertEqual(score_to_imp(1430), 16)

    def test_double_dummy_estimation(self):
        # North-South strong hand
        north_hand = Hand.from_string("SAK432 HA32 DAK2 C43")
        south_hand = Hand.from_string("SQJ98 HK4 D432 CAKJ2")
        east_hand = Hand.from_string("ST7 HQJ5 DQT98 CT987")
        west_hand = Hand.from_string("S65 HT9876 DJ765 C65")

        hands = {
            Seat.NORTH: north_hand,
            Seat.SOUTH: south_hand,
            Seat.EAST: east_hand,
            Seat.WEST: west_hand
        }

        # 9 spade fit with 33 combined HCP should estimate at least 11-12 tricks in Spades
        tricks_s = estimate_double_dummy_tricks(hands, Strain.SPADES, Seat.NORTH)
        self.assertGreaterEqual(tricks_s, 11)

        # 33 combined HCP in NT should estimate at least 11-12 tricks
        tricks_nt = estimate_double_dummy_tricks(hands, Strain.NT, Seat.SOUTH)
        self.assertGreaterEqual(tricks_nt, 11)

if __name__ == "__main__":
    unittest.main()
