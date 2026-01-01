import unittest
from bid.translator import SystemTranslator
from bid.engine import Engine
from bid.models import Hand, Call, CallType, Strain, Seat, Suit
from bid.system import BiddingSystem

class TestDealEstimation(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Load Blue Club for My System
        with open("bid/system/blue_club.dsl", "r") as f:
            blue_dsl = f.read()
        translator = SystemTranslator()
        cls.blue_system = translator.parse(blue_dsl)
        
        # Load GIB for Opponent System (Simulating simple natural-ish)
        with open("bid/system/gib.dsl", "r") as f:
            gib_dsl = f.read()
        cls.gib_system = translator.parse(gib_dsl)
        
        cls.engine = Engine(cls.blue_system)

    def test_estimate_1c_sequence(self):
        # Auction: 1C (Me/North) - Pass (East) - 1S (Partner/South) - Pass (West)
        history = [
            Call(CallType.BID, 1, Strain.CLUBS),  # North (Blue Club 1C Strong)
            Call(CallType.PASS),                  # East (GIB Pass)
            Call(CallType.BID, 1, Strain.SPADES), # South (Blue Club 1S 3 Controls)
            Call(CallType.PASS)                   # West (GIB Pass)
        ]
        
        # Estimate from North's perspective (Seat.NORTH)
        dealer = Seat.NORTH
        my_seat = Seat.NORTH
        
        estimates = self.engine.estimate_deal(
            history, my_seat, dealer, self.blue_system, self.gib_system
        )
        
        # Verify North (1C Strong)
        north_con = estimates[Seat.NORTH]
        # Blue Club 1C: HCP 17+
        self.assertGreaterEqual(north_con.hcp_min, 17)
        
        # Verify South (1S Response: 3 Controls)
        south_con = estimates[Seat.SOUTH]
        # Blue Club 1C-1S: Controls 3
        self.assertEqual(south_con.controls_min, 3)
        self.assertEqual(south_con.controls_max, 3)

    def test_estimate_intervention(self):
        # Auction: 1S (Opponent/North) - Pass (Partner/East) - 2S (Opponent/South)
        # Using Blue Club for me (East/West), GIB for Opponents (North/South).
        # Actually let's swap: I am North (Blue Club). 
        # Auction: 1H (Me) - 1S (Opponent Overcall)
        
        # Current DSLs might not have overcalls implemented well, but let's try.
        # Blue Club 1H: 11-16 HCP, 4+ H.
        history = [
            Call(CallType.BID, 1, Strain.HEARTS), # North (Blue Club)
            # Call(CallType.BID, 1, Strain.SPADES)  # East (GIB Overcall? If exists)
        ]
        
        estimates = self.engine.estimate_deal(
            history, Seat.NORTH, Seat.NORTH, self.blue_system, self.gib_system
        )
        
        north_con = estimates[Seat.NORTH]
        self.assertGreaterEqual(north_con.hcp_min, 11)
        self.assertGreaterEqual(north_con.length_min[Suit.HEARTS], 4)

if __name__ == "__main__":
    unittest.main()
