from bid.translator import SystemTranslator
from bid.engine import Engine
from bid.models import Hand, Call, CallType, Strain
import random

# 1. Define Rule System
sayc_text = """
OPEN 1NT:
  HCP: 15-17
  SHAPE: BALANCED

OPEN 1H:
  HCP: 12-21
  LEN H: 5+

OPEN 1S:
  HCP: 12-21
  LEN S: 5+

OPEN 1C:
  HCP: 12-21
  LEN C: 3+
  
OPEN 1D:
  HCP: 12-21
  LEN D: 3+
"""

def main():
    print("=== Bridge Bidding Framework Demo ===")
    
    # 2. Parse System
    dsl_path = "bid/system/gib.dsl"
    print(f"Parsing System from {dsl_path}...")
    
    with open(dsl_path, "r") as f:
        dsl_text = f.read()
        
    translator = SystemTranslator()
    system = translator.parse(dsl_text)
    print(f"Loaded {len(system.rules)} rules.")
    
    engine = Engine(system)

    # 3. Generate Hand & Bid
    print("\n--- Hand Evaluation ---")
    hand = Hand.random()
    print(f"Hand: {hand.cards}")
    print(f"HCP: {hand.hcp}")
    print(f"Dist: {hand.distribution}")
    
    bid = engine.get_bid([], hand) # Opening bid
    print(f"Opening Bid: {bid}")
    
    # 4. Inference Demo
    print("\n--- Inference (Auction Analysis) ---")
    # Simulate an auction: 1NT - Pass - Pass - ?
    auction = [
        Call(CallType.BID, 1, Strain.NT),
        Call(CallType.PASS),
        Call(CallType.PASS)
    ]
    print(f"Auction: {[str(c) for c in auction]}")
    
    # Assume Dealer is North (Seat 0)
    estimates = engine.explain_auction(auction, dealer_seat_index=0)
    
    print("Estimates:")
    seats = ["North", "East", "South", "West"]
    for i, est in estimates.items():
        print(f"{seats[i]}: {engine.format_estimate(est)}")

if __name__ == "__main__":
    main()
