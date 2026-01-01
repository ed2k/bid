import unittest
from bid.engine import Engine
from bid.system import BiddingSystem, Rule
from bid.models import Call, CallType, Strain, Hand, Seat
from bid.constraints import HandConstraints

class TestEngineSystemSwitching(unittest.TestCase):
    def setUp(self):
        # Create System A (Mine): Always bids 1C
        self.sys_mine = BiddingSystem("Mine")
        # Trigger always true for empty history or specific setup
        rule_mine = Rule(
            priority=10, 
            trigger=lambda h: True, 
            constraints=HandConstraints(), 
            call=Call(CallType.BID, 1, Strain.CLUBS), 
            description="Mine 1C"
        )
        self.sys_mine.add_rule(rule_mine)
        
        # Create System B (Opp): Always bids 1S
        self.sys_opp = BiddingSystem("Opp")
        rule_opp = Rule(
            priority=10, 
            trigger=lambda h: True, 
            constraints=HandConstraints(), 
            call=Call(CallType.BID, 1, Strain.SPADES), 
            description="Opp 1S"
        )
        self.sys_opp.add_rule(rule_opp)
        
        self.engine = Engine(self.sys_mine)
        self.hand = Hand.from_string("SAKJ2 HAKJ2 DAQJ2 C2") # Strong hand

    def test_default_behavior(self):
        # If no context, uses self.system (Mine -> 1C)
        bid = self.engine.get_bid([], self.hand)
        self.assertEqual(str(bid), "1C")

    def test_my_turn_north_dealer_north(self):
        # Me = North, Dealer = North. Turn = North (0 calls). My System.
        bid = self.engine.get_bid([], self.hand, 
                                  my_seat=Seat.NORTH, 
                                  dealer_seat=Seat.NORTH, 
                                  opp_system=self.sys_opp)
        self.assertEqual(str(bid), "1C")

    def test_partner_turn_north_dealer_south_pass(self):
        # Me = North, Dealer = South. History=[Pass]. 
        # Dealer(S) -> Pass. Next is West.
        # Wait. Dealer S (2). S->W->N->E.
        # History [Pass]. 1 call. 
        # Current = (2 + 1) % 4 = 3 (West).
        # Me=North (0). West is Opponent.
        # Should use Opp System (1S).
        
        bid = self.engine.get_bid([Call(CallType.PASS)], self.hand,
                                  my_seat=Seat.NORTH,
                                  dealer_seat=Seat.SOUTH,
                                  opp_system=self.sys_opp)
        
        self.assertEqual(str(bid), "1S")

    def test_partner_turn(self):
        # Me = North. Dealer = West. History = [Pass, Pass].
        # W(Pass) -> N(Pass). Next is E.
        # Wait, I want Partner turn.
        # Me = North. Partner = South.
        # Dealer = North. N(Pass) -> E(Pass) -> S(?).
        # History = [Pass, Pass] (2 calls).
        # Current = (0 + 2) % 4 = 2 (South).
        # South is Partner. Should use My System (1C).
        
        bid = self.engine.get_bid([Call(CallType.PASS), Call(CallType.PASS)], self.hand,
                                  my_seat=Seat.NORTH,
                                  dealer_seat=Seat.NORTH,
                                  opp_system=self.sys_opp)
                                  
        self.assertEqual(str(bid), "1C")

if __name__ == "__main__":
    unittest.main()
