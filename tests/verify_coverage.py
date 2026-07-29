from tests.test_bidding_gaps import BiddingGapDetector

def run_coverage_verification(num_hands=1000):
    print(f"Running multi-system coverage and gap verification ({num_hands} deals per system)...")
    detector = BiddingGapDetector()
    report = detector.generate_full_report(num_deals=num_hands)
    
    print("\n" + "="*60)
    print("        MULTI-SYSTEM BIDDING GAP REPORT")
    print("="*60)
    
    for sys_name, data in report.items():
        op_gaps = data['opening_gaps']
        print(f"\nSystem: {sys_name}")
        print(f"  Opening Bid Gaps (HCP>=12 or 11+5card/Rule20): {len(op_gaps)}")
        if op_gaps:
            for i, g in enumerate(op_gaps[:3]):
                print(f"    Sample {i+1}: {g['hand']} (HCP: {g['hcp']})")
        
        print("  Response Gaps (Responder 6+ HCP):")
        for op_bid, resp_gaps in data['response_gaps'].items():
            print(f"    After {op_bid}: {len(resp_gaps)} missed responses")

if __name__ == "__main__":
    run_coverage_verification()

