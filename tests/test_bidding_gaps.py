import os
import unittest
import random
from collections import Counter, defaultdict
from bid.translator import SystemTranslator
from bid.engine import Engine
from bid.models import Hand, Call, CallType, Strain, Suit

class BiddingGapDetector:
    """Harness to detect gaps in bidding system rules across deal scenarios."""
    
    SYSTEM_FILES = {
        "GIB": "system/gib.dsl",
        "BlueClub": "system/blue_club.dsl",
        "Precision": "system/precision.dsl"
    }

    def __init__(self, base_dir=None):
        if base_dir is None:
            base_dir = os.path.join(os.path.dirname(__file__), "..")
        self.base_dir = base_dir
        self.translator = SystemTranslator()
        self.engines = {}
        
        for name, rel_path in self.SYSTEM_FILES.items():
            full_path = os.path.join(self.base_dir, rel_path)
            if os.path.exists(full_path):
                with open(full_path, "r") as f:
                    dsl_text = f.read()
                system = self.translator.parse(dsl_text)
                self.engines[name] = Engine(system)

    def find_opening_gaps(self, system_name, num_deals=2000, seed=42):
        """Find hands with opening strength (HCP >= 12, or HCP >= 11 with 5+ card suit) that PASS."""
        if system_name not in self.engines:
            return []
        
        engine = self.engines[system_name]
        rng = random.Random(seed)
        gaps = []

        for _ in range(num_deals):
            hand = Hand.random()
            
            # Criteria for opening strength:
            # - HCP >= 12
            # - HCP >= 11 and max suit length >= 5
            # - Rule of 20: HCP + length of 2 longest suits >= 20
            longest_2 = sorted([hand.length(s) for s in Suit], reverse=True)[:2]
            rule_of_20 = (hand.hcp + sum(longest_2)) >= 20
            
            is_opening_strength = (hand.hcp >= 12) or (hand.hcp >= 11 and longest_2[0] >= 5) or rule_of_20
            
            if is_opening_strength:
                bid = engine.get_bid([], hand)
                if str(bid) == "PASS":
                    gaps.append({
                        'hand': hand,
                        'hcp': hand.hcp,
                        'shape': [hand.length(s) for s in Suit],
                        'rule_of_20': rule_of_20
                    })
                    
        return gaps

    def find_response_gaps(self, system_name, opening_bid_str, num_deals=2000, seed=42):
        """Find responder hands (6+ HCP) following an opening bid that result in an unhandled PASS."""
        if system_name not in self.engines:
            return []

        engine = self.engines[system_name]
        rng = random.Random(seed)
        
        # Build opening bid history [OpeningBid, Pass]
        op_call = self.translator._parse_call(opening_bid_str)
        history = [op_call, Call(CallType.PASS)]
        
        gaps = []

        for _ in range(num_deals):
            hand = Hand.random()
            # Responder has 6+ HCP (standard threshold to respond to 1-level openings)
            if hand.hcp >= 6:
                bid = engine.get_bid(history, hand)
                if str(bid) == "PASS":
                    gaps.append({
                        'hand': hand,
                        'hcp': hand.hcp,
                        'opening': opening_bid_str
                    })
                    
        return gaps

    def find_rebid_gaps(self, system_name, history_bid_strs, min_hcp=6, num_deals=2000, seed=42):
        """Find gaps in rebid auctions for a specified history sequence."""
        if system_name not in self.engines:
            return []

        engine = self.engines[system_name]
        rng = random.Random(seed)
        
        history = []
        for s in history_bid_strs:
            history.append(self.translator._parse_call(s))
            
        gaps = []
        for _ in range(num_deals):
            hand = Hand.random()
            if hand.hcp >= min_hcp:
                bid = engine.get_bid(history, hand)
                if str(bid) == "PASS":
                    gaps.append({
                        'hand': hand,
                        'hcp': hand.hcp,
                        'history': history_bid_strs
                    })
                    
        return gaps

    def generate_full_report(self, num_deals=2000):
        report = {}
        for sys_name in self.engines:
            sys_report = {
                'opening_gaps': self.find_opening_gaps(sys_name, num_deals=num_deals),
                'response_gaps': {}
            }
            
            # Common 1-level openings to test responses for
            test_openings = ["1C", "1D", "1H", "1S", "1NT"]
            for op in test_openings:
                gaps = self.find_response_gaps(sys_name, op, num_deals=num_deals)
                sys_report['response_gaps'][op] = gaps
                
            report[sys_name] = sys_report
        return report


class TestBiddingGaps(unittest.TestCase):
    """Automated unittest integration for bidding gap detection across systems."""

    @classmethod
    def setUpClass(cls):
        cls.detector = BiddingGapDetector()

    def test_opening_bid_gaps_gib(self):
        gaps = self.detector.find_opening_gaps("GIB", num_deals=1000)
        gap_count = len(gaps)
        print(f"\n[GIB] Opening Bid Gaps (HCP>=12 or 11+5card/Rule20): {gap_count} / 1000 deals")
        if gaps:
            print("Sample GIB Opening Gap:", gaps[0]['hand'], f"HCP={gaps[0]['hcp']}")
        self.assertLessEqual(gap_count, 100, f"GIB has {gap_count} opening gaps out of 1000 deals")

    def test_opening_bid_gaps_blue_club(self):
        gaps = self.detector.find_opening_gaps("BlueClub", num_deals=1000)
        gap_count = len(gaps)
        print(f"\n[BlueClub] Opening Bid Gaps: {gap_count} / 1000 deals")
        if gaps:
            print("Sample BlueClub Opening Gap:", gaps[0]['hand'], f"HCP={gaps[0]['hcp']}")
        self.assertLessEqual(gap_count, 50, f"BlueClub has {gap_count} opening gaps out of 1000 deals")

    def test_opening_bid_gaps_precision(self):
        gaps = self.detector.find_opening_gaps("Precision", num_deals=1000)
        gap_count = len(gaps)
        print(f"\n[Precision] Opening Bid Gaps: {gap_count} / 1000 deals")
        if gaps:
            print("Sample Precision Opening Gap:", gaps[0]['hand'], f"HCP={gaps[0]['hcp']}")
        self.assertLessEqual(gap_count, 50, f"Precision has {gap_count} opening gaps out of 1000 deals")

    def test_response_gaps_gib(self):
        gaps_1h = self.detector.find_response_gaps("GIB", "1H", num_deals=500)
        gaps_1s = self.detector.find_response_gaps("GIB", "1S", num_deals=500)
        print(f"\n[GIB] 1H Response Gaps (HCP>=6): {len(gaps_1h)} / 500 deals")
        print(f"[GIB] 1S Response Gaps (HCP>=6): {len(gaps_1s)} / 500 deals")
        self.assertLessEqual(len(gaps_1h), 100)
        self.assertLessEqual(len(gaps_1s), 100)

if __name__ == "__main__":
    detector = BiddingGapDetector()
    report = detector.generate_full_report(num_deals=2000)
    
    print("\n" + "="*60)
    print("        BIDDING GAP ANALYSIS REPORT (2,000 deals per system)")
    print("="*60)
    
    for sys_name, data in report.items():
        op_gaps = data['opening_gaps']
        print(f"\nSystem: {sys_name}")
        print(f"  Unopened Deal Opening Gaps (HCP>=12 or 11+5card/Rule20): {len(op_gaps)}")
        if op_gaps:
            hcp_dist = Counter([g['hcp'] for g in op_gaps])
            print(f"    HCP distribution of missed hands: {dict(sorted(hcp_dist.items()))}")
            print(f"    Example missed hand: {op_gaps[0]['hand']} (HCP: {op_gaps[0]['hcp']})")
        
        print("  Response Gaps (Responder 6+ HCP):")
        for op_bid, resp_gaps in data['response_gaps'].items():
            print(f"    After {op_bid}: {len(resp_gaps)} missed responses")
            if resp_gaps:
                example = resp_gaps[0]['hand']
                print(f"      Example missed: {example} (HCP: {example.hcp})")

