import random
from bid.models import Hand
from bid.translator import SystemTranslator
from bid.engine import Engine
from bid.models import Call, CallType
from collections import Counter

def run_coverage_verification(num_hands=1000):
    print(f"Running coverage verification on {num_hands} random hands...")
    
    # Load System
    dsl_path = "system/precision.dsl"
    try:
        with open(dsl_path, "r") as f:
            dsl_text = f.read()
    except FileNotFoundError:
        print(f"Error: Could not find {dsl_path}")
        return

    translator = SystemTranslator()
    system = translator.parse(dsl_text)
    engine = Engine(system)
    
    results = []
    missed_opportunities = []
    
    for _ in range(num_hands):
        hand = Hand.random()
        # Empty history for opening bid
        bid = engine.get_bid([], hand)
        
        results.append(str(bid))
        
        if str(bid) == "PASS":
            # Check for missed opportunities (HCP > 11)
            # Standard Precision usually opens most 11+ hands
            if hand.hcp >= 11:
                missed_opportunities.append(hand)

    # Analysis
    counts = Counter(results)
    
    print("\n=== Opening Bid Distribution ===")
    for bid, count in counts.most_common():
        percentage = (count / num_hands) * 100
        print(f"{bid}: {count} ({percentage:.1f}%)")
        
    print(f"\nTotal Opened: {num_hands - counts['PASS']} ({(1 - counts['PASS']/num_hands)*100:.1f}%)")
    print(f"Total Passed: {counts['PASS']} ({counts['PASS']/num_hands*100:.1f}%)")
    
    print("\n=== Missed Opportunities (Passed with 11+ HCP) ===")
    if missed_opportunities:
        print(f"Found {len(missed_opportunities)} hands with 11+ HCP that Passed.")
        # Show top 5 examples
        for i, hand in enumerate(missed_opportunities[:5]):
            print(f"{i+1}. {hand} (HCP: {hand.hcp})")
            
        print("\nDistribution of Missed HCP:")
        missed_hcp = [h.hcp for h in missed_opportunities]
        hcp_counts = Counter(missed_hcp)
        for hcp in sorted(hcp_counts.keys()):
            print(f"HCP {hcp}: {hcp_counts[hcp]} hands")
    else:
        print("Great! No hands with 11+ HCP were passed.")

if __name__ == "__main__":
    run_coverage_verification()
