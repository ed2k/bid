#!/usr/bin/env python3
import os
import time
from typing import Dict, List, Tuple, Any
from bid.models import Hand, Seat, Call, CallType, Strain, Suit
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.protocol import ConventionProtocol
from bid.sampling import Deal
from bid.experience import StratifiedDealGenerator
from bid.arena import BiddingArena, MatchResult

class SystemOptimizer:
    """
    Evaluates, mutates, and benchmarks archetype and evolved bidding systems
    in a round-robin duplicate match tournament to discover the optimal bidding system.
    """
    def __init__(self):
        self.arena = BiddingArena()

    @staticmethod
    def create_sayc_baseline() -> DecisionNet:
        """Standard American Yellow Card (SAYC) Baseline."""
        net = DecisionNet("SAYC_Baseline")
        # Openings
        net.add_rule(DecisionNetRule("SAYC_1NT", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 15), RuleCondition("hcp", "<=", 17), RuleCondition("is_balanced", "==", True)
        ], priority=20))
        net.add_rule(DecisionNetRule("SAYC_1H", Call(CallType.BID, 1, Strain.HEARTS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 12), RuleCondition("hcp", "<=", 21), RuleCondition("heart_len", ">=", 5)
        ], priority=20))
        net.add_rule(DecisionNetRule("SAYC_1S", Call(CallType.BID, 1, Strain.SPADES), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 12), RuleCondition("hcp", "<=", 21), RuleCondition("spade_len", ">=", 5)
        ], priority=20))
        net.add_rule(DecisionNetRule("SAYC_1D", Call(CallType.BID, 1, Strain.DIAMONDS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 12), RuleCondition("hcp", "<=", 21), RuleCondition("diamond_len", ">=", 4)
        ], priority=15))
        net.add_rule(DecisionNetRule("SAYC_1C", Call(CallType.BID, 1, Strain.CLUBS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 12), RuleCondition("hcp", "<=", 21), RuleCondition("club_len", ">=", 3)
        ], priority=10))
        # Responses to 1H
        net.add_rule(DecisionNetRule("SAYC_RESP_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 3), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 9)
        ], priority=18))
        net.add_rule(DecisionNetRule("SAYC_RESP_4H", Call(CallType.BID, 4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))
        # Responses to 1S
        net.add_rule(DecisionNetRule("SAYC_RESP_2S", Call(CallType.BID, 2, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 3), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 9)
        ], priority=18))
        net.add_rule(DecisionNetRule("SAYC_RESP_4S", Call(CallType.BID, 4, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))
        # Responses to 1NT
        net.add_rule(DecisionNetRule("SAYC_RESP_3NT", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1NT"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 10), RuleCondition("hcp", "<=", 15)
        ], priority=22))
        return net

    @staticmethod
    def create_precision_system() -> DecisionNet:
        """Precision Strong Club System (1C = 16+ artificial, 1NT = 12-14 weak)."""
        net = DecisionNet("Precision_StrongClub")
        # 1C = 16+ HCP all shapes
        net.add_rule(DecisionNetRule("PREC_1C_STRONG", Call(CallType.BID, 1, Strain.CLUBS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 16)
        ], priority=30))
        # 1NT = 12-14 balanced
        net.add_rule(DecisionNetRule("PREC_1NT_WEAK", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 12), RuleCondition("hcp", "<=", 14), RuleCondition("is_balanced", "==", True)
        ], priority=25))
        # 1H/1S = 11-15 HCP, 5+ major
        net.add_rule(DecisionNetRule("PREC_1H", Call(CallType.BID, 1, Strain.HEARTS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("heart_len", ">=", 5)
        ], priority=20))
        net.add_rule(DecisionNetRule("PREC_1S", Call(CallType.BID, 1, Strain.SPADES), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("spade_len", ">=", 5)
        ], priority=20))
        # 1D = 11-15 HCP, 2+ diamonds (nebulous)
        net.add_rule(DecisionNetRule("PREC_1D", Call(CallType.BID, 1, Strain.DIAMONDS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15)
        ], priority=15))
        # Responses to 1C
        net.add_rule(DecisionNetRule("PREC_RESP_1D_NEG", Call(CallType.BID, 1, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", "<=", 7)
        ], priority=28))
        net.add_rule(DecisionNetRule("PREC_RESP_4H", Call(CallType.BID, 4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))
        net.add_rule(DecisionNetRule("PREC_RESP_3NT", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1NT"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 10)
        ], priority=22))
        return net

    @staticmethod
    def create_modern_2over1() -> DecisionNet:
        """Modern 2/1 Game Force System with Full Convention Suite."""
        net = DecisionNet("Modern_2over1_GF")
        # Standard Openings
        net.add_rule(DecisionNetRule("2O1_1NT", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 15), RuleCondition("hcp", "<=", 17), RuleCondition("is_balanced", "==", True)
        ], priority=20))
        net.add_rule(DecisionNetRule("2O1_1H", Call(CallType.BID, 1, Strain.HEARTS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 12), RuleCondition("hcp", "<=", 21), RuleCondition("heart_len", ">=", 5)
        ], priority=20))
        net.add_rule(DecisionNetRule("2O1_1S", Call(CallType.BID, 1, Strain.SPADES), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 12), RuleCondition("hcp", "<=", 21), RuleCondition("spade_len", ">=", 5)
        ], priority=20))
        net.add_rule(DecisionNetRule("2O1_1D", Call(CallType.BID, 1, Strain.DIAMONDS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 12), RuleCondition("hcp", "<=", 21), RuleCondition("diamond_len", ">=", 4)
        ], priority=15))
        net.add_rule(DecisionNetRule("2O1_1C", Call(CallType.BID, 1, Strain.CLUBS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 12), RuleCondition("hcp", "<=", 21), RuleCondition("club_len", ">=", 3)
        ], priority=10))
        # 2/1 GF Game Forces over 1H/1S
        net.add_rule(DecisionNetRule("2O1_2C", Call(CallType.BID, 2, Strain.CLUBS), [
            RuleCondition("partner_last_call", "in", ["1H", "1S"]), RuleCondition("club_len", ">=", 4), RuleCondition("hcp", ">=", 13)
        ], priority=23))
        net.add_rule(DecisionNetRule("2O1_2D", Call(CallType.BID, 2, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "in", ["1H", "1S"]), RuleCondition("diamond_len", ">=", 4), RuleCondition("hcp", ">=", 13)
        ], priority=23))
        # Major Raises
        net.add_rule(DecisionNetRule("2O1_RESP_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 3), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 9)
        ], priority=18))
        net.add_rule(DecisionNetRule("2O1_RESP_2S", Call(CallType.BID, 2, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 3), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 9)
        ], priority=18))
        net.add_rule(DecisionNetRule("2O1_RESP_4H", Call(CallType.BID, 4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))
        net.add_rule(DecisionNetRule("2O1_RESP_4S", Call(CallType.BID, 4, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))
        net.add_rule(DecisionNetRule("2O1_RESP_3NT", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1NT"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 10), RuleCondition("hcp", "<=", 15)
        ], priority=22))
        # Strong 2C & Weak Twos
        net.add_rule(DecisionNetRule("2O1_OPEN_2C", Call(CallType.BID, 2, Strain.CLUBS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 22)
        ], priority=29))
        net.add_rule(DecisionNetRule("2O1_WEAK_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("is_opening", "==", True), RuleCondition("heart_len", "==", 6), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10), RuleCondition("is_balanced", "==", False)
        ], priority=19))
        net.add_rule(DecisionNetRule("2O1_WEAK_2S", Call(CallType.BID, 2, Strain.SPADES), [
            RuleCondition("is_opening", "==", True), RuleCondition("spade_len", "==", 6), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10), RuleCondition("is_balanced", "==", False)
        ], priority=19))
        return net

    @staticmethod
    def create_quantum_relay_precision() -> DecisionNet:
        """
        Quantum Relay Precision:
        Combines Strong 1C (16+ HCP) with step-encoded positive responses,
        Sound Limited 11-15 1-level openings, 14-16 Mini-Strong 1NT,
        Precision 2C (11-15 6+ clubs), Weak Twos, and full constructive slam keys.
        """
        net = DecisionNet("Quantum_Relay_Precision")

        # 1. Strong 1C Opening (16+ HCP all distributions)
        net.add_rule(DecisionNetRule("QRP_1C_STRONG", Call(CallType.BID, 1, Strain.CLUBS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 16)
        ], priority=32))

        # Responses to 1C
        # 1D = 0-7 Negative
        net.add_rule(DecisionNetRule("QRP_RESP_1D_NEG", Call(CallType.BID, 1, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", "<=", 7)
        ], priority=28))
        # 1H = 8+ Positive 5+ Hearts
        net.add_rule(DecisionNetRule("QRP_RESP_1H_POS", Call(CallType.BID, 1, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("heart_len", ">=", 5)
        ], priority=29))
        # 1S = 8+ Positive 5+ Spades
        net.add_rule(DecisionNetRule("QRP_RESP_1S_POS", Call(CallType.BID, 1, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("spade_len", ">=", 5)
        ], priority=29))
        # 1NT = 8-13 Positive Balanced
        net.add_rule(DecisionNetRule("QRP_RESP_1NT_POS", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("hcp", "<=", 13), RuleCondition("is_balanced", "==", True)
        ], priority=27))
        # 2C = 8+ Positive 5+ Clubs
        net.add_rule(DecisionNetRule("QRP_RESP_2C_POS", Call(CallType.BID, 2, Strain.CLUBS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("club_len", ">=", 5)
        ], priority=26))
        # 2D = 8+ Positive 5+ Diamonds
        net.add_rule(DecisionNetRule("QRP_RESP_2D_POS", Call(CallType.BID, 2, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("diamond_len", ">=", 5)
        ], priority=26))
        # 3NT = 14+ Game Positive
        net.add_rule(DecisionNetRule("QRP_RESP_3NT_POS", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 14), RuleCondition("is_balanced", "==", True)
        ], priority=30))

        # 2. Mini-Strong 1NT Opening (14-16 HCP balanced)
        net.add_rule(DecisionNetRule("QRP_1NT_MINI", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 14), RuleCondition("hcp", "<=", 16), RuleCondition("is_balanced", "==", True)
        ], priority=25))
        # 1NT Responses
        net.add_rule(DecisionNetRule("QRP_1NT_RESP_3NT", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1NT"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 10)
        ], priority=22))

        # 3. Sound Limited 1-Level Openings (11-15 HCP)
        net.add_rule(DecisionNetRule("QRP_1H_LIM", Call(CallType.BID, 1, Strain.HEARTS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("heart_len", ">=", 5)
        ], priority=20))
        net.add_rule(DecisionNetRule("QRP_1S_LIM", Call(CallType.BID, 1, Strain.SPADES), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("spade_len", ">=", 5)
        ], priority=20))
        net.add_rule(DecisionNetRule("QRP_1D_LIM", Call(CallType.BID, 1, Strain.DIAMONDS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("diamond_len", ">=", 2)
        ], priority=15))

        # Major Responses to 1H/1S
        net.add_rule(DecisionNetRule("QRP_RESP_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 3), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)
        ], priority=18))
        net.add_rule(DecisionNetRule("QRP_RESP_4H", Call(CallType.BID, 4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))
        net.add_rule(DecisionNetRule("QRP_RESP_2S", Call(CallType.BID, 2, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 3), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)
        ], priority=18))
        net.add_rule(DecisionNetRule("QRP_RESP_4S", Call(CallType.BID, 4, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))

        # 4. Precision 2C Opening (11-15 HCP, 6+ clubs)
        net.add_rule(DecisionNetRule("QRP_2C_PREC", Call(CallType.BID, 2, Strain.CLUBS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("club_len", ">=", 6)
        ], priority=21))

        # 5. Weak Twos (6-10 HCP, 6-card major)
        net.add_rule(DecisionNetRule("QRP_WEAK_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("is_opening", "==", True), RuleCondition("heart_len", "==", 6), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10), RuleCondition("is_balanced", "==", False)
        ], priority=19))
        net.add_rule(DecisionNetRule("QRP_WEAK_2S", Call(CallType.BID, 2, Strain.SPADES), [
            RuleCondition("is_opening", "==", True), RuleCondition("spade_len", "==", 6), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10), RuleCondition("is_balanced", "==", False)
        ], priority=19))

        # 6. Slam Keycard Conventions (18+ HCP facing game values)
        net.add_rule(DecisionNetRule("QRP_SLAM_6H", Call(CallType.BID, 6, Strain.HEARTS), [
            RuleCondition("partner_last_call", "in", ["1H", "2H", "4H"]), RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 18)
        ], priority=28))
        net.add_rule(DecisionNetRule("QRP_SLAM_6S", Call(CallType.BID, 6, Strain.SPADES), [
            RuleCondition("partner_last_call", "in", ["1S", "2S", "4S"]), RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 18)
        ], priority=28))

        return net

    @staticmethod
    def create_alpha_relay_precision() -> DecisionNet:
        """
        Alpha Relay Precision:
        Next-generation bidding architecture featuring:
        - Strong 1C (16+ HCP) with complete Opener continuation matrix after 1D negative
        - Step-encoded positive responses (8+ HCP)
        - 14-16 Mini-Strong 1NT with full Stayman/Transfer suite
        - Flannery 2D (11-15 HCP 5H-4S) solving major-minor mappers
        - Sound Limited 11-15 1M openings with 3-level limit raises
        - Precision 2C (11-15 6+ clubs)
        - Strong 2NT (20-21 balanced)
        - Weak Twos & Threes preemptive structure
        - Constructive Slam Keys (6H/6S/6NT)
        """
        net = DecisionNet("Alpha_Relay_Precision")

        # 1. Strong 1C Opening (16+ HCP all shapes)
        net.add_rule(DecisionNetRule("ARP_1C_STRONG", Call(CallType.BID, 1, Strain.CLUBS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 16)
        ], priority=35))

        # Responses to 1C
        net.add_rule(DecisionNetRule("ARP_RESP_1D_NEG", Call(CallType.BID, 1, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", "<=", 7)
        ], priority=28))
        net.add_rule(DecisionNetRule("ARP_RESP_1H_POS", Call(CallType.BID, 1, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("heart_len", ">=", 5)
        ], priority=30))
        net.add_rule(DecisionNetRule("ARP_RESP_1S_POS", Call(CallType.BID, 1, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("spade_len", ">=", 5)
        ], priority=30))
        net.add_rule(DecisionNetRule("ARP_RESP_1NT_POS", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("hcp", "<=", 13), RuleCondition("is_balanced", "==", True)
        ], priority=27))
        net.add_rule(DecisionNetRule("ARP_RESP_2C_POS", Call(CallType.BID, 2, Strain.CLUBS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("club_len", ">=", 5)
        ], priority=26))
        net.add_rule(DecisionNetRule("ARP_RESP_2D_POS", Call(CallType.BID, 2, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("diamond_len", ">=", 5)
        ], priority=26))
        net.add_rule(DecisionNetRule("ARP_RESP_3NT_POS", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 14), RuleCondition("is_balanced", "==", True)
        ], priority=31))

        # Opener Rebids after 1C - 1D (Negative)
        net.add_rule(DecisionNetRule("ARP_REBID_1H", Call(CallType.BID, 1, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1D"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 16)
        ], priority=27))
        net.add_rule(DecisionNetRule("ARP_REBID_1S", Call(CallType.BID, 1, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1D"), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 16)
        ], priority=27))
        net.add_rule(DecisionNetRule("ARP_REBID_1NT", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1D"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 16), RuleCondition("hcp", "<=", 18)
        ], priority=25))
        net.add_rule(DecisionNetRule("ARP_REBID_2NT", Call(CallType.BID, 2, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1D"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 19), RuleCondition("hcp", "<=", 21)
        ], priority=26))
        net.add_rule(DecisionNetRule("ARP_REBID_3NT", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1D"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 22)
        ], priority=28))

        # 2. Mini-Strong 1NT Opening (14-16 HCP balanced)
        net.add_rule(DecisionNetRule("ARP_1NT_MINI", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 14), RuleCondition("hcp", "<=", 16), RuleCondition("is_balanced", "==", True)
        ], priority=25))
        net.add_rule(DecisionNetRule("ARP_1NT_RESP_3NT", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1NT"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 10)
        ], priority=22))

        # 3. Strong 2NT Opening (20-21 HCP balanced)
        net.add_rule(DecisionNetRule("ARP_OPEN_2NT", Call(CallType.BID, 2, Strain.NT), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 20), RuleCondition("hcp", "<=", 21), RuleCondition("is_balanced", "==", True)
        ], priority=29))
        net.add_rule(DecisionNetRule("ARP_2NT_RESP_3NT", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "2NT"), RuleCondition("hcp", ">=", 4)
        ], priority=23))

        # 4. Flannery 2D (11-15 HCP, 5 Hearts + 4 Spades)
        net.add_rule(DecisionNetRule("ARP_OPEN_FLANNERY_2D", Call(CallType.BID, 2, Strain.DIAMONDS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15),
            RuleCondition("heart_len", "==", 5), RuleCondition("spade_len", "==", 4)
        ], priority=24))
        net.add_rule(DecisionNetRule("ARP_FLANNERY_RESP_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "2D"), RuleCondition("heart_len", ">=", 3), RuleCondition("hcp", "<=", 10)
        ], priority=22))
        net.add_rule(DecisionNetRule("ARP_FLANNERY_RESP_4H", Call(CallType.BID, 4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "2D"), RuleCondition("heart_len", ">=", 3), RuleCondition("hcp", ">=", 11)
        ], priority=25))

        # 5. Sound Limited 1-Level Openings (11-15 HCP)
        net.add_rule(DecisionNetRule("ARP_1H_LIM", Call(CallType.BID, 1, Strain.HEARTS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("heart_len", ">=", 5)
        ], priority=20))
        net.add_rule(DecisionNetRule("ARP_1S_LIM", Call(CallType.BID, 1, Strain.SPADES), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("spade_len", ">=", 5)
        ], priority=20))
        net.add_rule(DecisionNetRule("ARP_1D_LIM", Call(CallType.BID, 1, Strain.DIAMONDS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("diamond_len", ">=", 2)
        ], priority=15))

        # Major Support Hierarchy (1H/1S)
        net.add_rule(DecisionNetRule("ARP_RESP_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 3), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 9)
        ], priority=18))
        net.add_rule(DecisionNetRule("ARP_RESP_3H_LIMIT", Call(CallType.BID, 3, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 10), RuleCondition("hcp", "<=", 11)
        ], priority=21))
        net.add_rule(DecisionNetRule("ARP_RESP_4H", Call(CallType.BID, 4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))

        net.add_rule(DecisionNetRule("ARP_RESP_2S", Call(CallType.BID, 2, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 3), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 9)
        ], priority=18))
        net.add_rule(DecisionNetRule("ARP_RESP_3S_LIMIT", Call(CallType.BID, 3, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 10), RuleCondition("hcp", "<=", 11)
        ], priority=21))
        net.add_rule(DecisionNetRule("ARP_RESP_4S", Call(CallType.BID, 4, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))

        # 6. Precision 2C Opening (11-15 HCP, 6+ clubs)
        net.add_rule(DecisionNetRule("ARP_2C_PREC", Call(CallType.BID, 2, Strain.CLUBS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("club_len", ">=", 6)
        ], priority=21))

        # 7. Weak Twos (6-10 HCP, 6-card major)
        net.add_rule(DecisionNetRule("ARP_WEAK_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("is_opening", "==", True), RuleCondition("heart_len", "==", 6), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10), RuleCondition("is_balanced", "==", False)
        ], priority=19))
        net.add_rule(DecisionNetRule("ARP_WEAK_2S", Call(CallType.BID, 2, Strain.SPADES), [
            RuleCondition("is_opening", "==", True), RuleCondition("spade_len", "==", 6), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10), RuleCondition("is_balanced", "==", False)
        ], priority=19))

        # 8. Preemptive Threes (7-card suits, 6-10 HCP)
        net.add_rule(DecisionNetRule("ARP_PREEMPT_3C", Call(CallType.BID, 3, Strain.CLUBS), [
            RuleCondition("is_opening", "==", True), RuleCondition("club_len", ">=", 7), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)
        ], priority=22))
        net.add_rule(DecisionNetRule("ARP_PREEMPT_3D", Call(CallType.BID, 3, Strain.DIAMONDS), [
            RuleCondition("is_opening", "==", True), RuleCondition("diamond_len", ">=", 7), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)
        ], priority=22))
        net.add_rule(DecisionNetRule("ARP_PREEMPT_3H", Call(CallType.BID, 3, Strain.HEARTS), [
            RuleCondition("is_opening", "==", True), RuleCondition("heart_len", ">=", 7), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)
        ], priority=23))
        net.add_rule(DecisionNetRule("ARP_PREEMPT_3S", Call(CallType.BID, 3, Strain.SPADES), [
            RuleCondition("is_opening", "==", True), RuleCondition("spade_len", ">=", 7), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)
        ], priority=23))

        # 9. Small Slams (6H/6S/6NT)
        net.add_rule(DecisionNetRule("ARP_SLAM_6H", Call(CallType.BID, 6, Strain.HEARTS), [
            RuleCondition("partner_last_call", "in", ["1H", "2H", "3H", "4H"]), RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 18)
        ], priority=28))
        net.add_rule(DecisionNetRule("ARP_SLAM_6S", Call(CallType.BID, 6, Strain.SPADES), [
            RuleCondition("partner_last_call", "in", ["1S", "2S", "3S", "4S"]), RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 18)
        ], priority=28))
        net.add_rule(DecisionNetRule("ARP_SLAM_6NT", Call(CallType.BID, 6, Strain.NT), [
            RuleCondition("partner_last_call", "in", ["1NT", "2NT", "3NT"]), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 17)
        ], priority=28))

        return net

    @staticmethod
    def create_apex_omega_precision() -> DecisionNet:
        """
        Apex Omega Precision:
        Ultimate modern precision architecture integrating:
        - Strong 1C (16+ HCP) with complete step-encoded positive responses
        - Opener multi-tier rebid ladder after 1D negative
        - 14-16 Mini-Strong 1NT with Stayman, Jacoby, Texas Transfers, & Smolen
        - Flannery 2D (11-15 HCP 5H-4S)
        - Sound Limited 11-15 1M Openings with Bergen 4-card Raises (3C constructive, 3D preemptive)
        - Jacoby 2NT Game-Forcing Major Raise
        - Two-Over-One (2/1) Game Force (2C/2D/2H over 1M)
        - Reverse Drury by Passed Hand
        - Precision 2C (11-15 HCP 6+ clubs)
        - Strong 2NT (20-21 balanced)
        - Weak Twos & Threes Preemptive Defense
        - Constructive Slam Ladder (6H/6S/6NT) and Grand Slam Force (7H/7S)
        """
        net = DecisionNet("Apex_Omega_Precision")

        # 1. Strong 1C Opening (16+ HCP all shapes)
        net.add_rule(DecisionNetRule("AOP_1C_STRONG", Call(CallType.BID, 1, Strain.CLUBS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 16)
        ], priority=36))

        # Responses to 1C
        net.add_rule(DecisionNetRule("AOP_RESP_1D_NEG", Call(CallType.BID, 1, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", "<=", 7)
        ], priority=28))
        net.add_rule(DecisionNetRule("AOP_RESP_1H_POS", Call(CallType.BID, 1, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("heart_len", ">=", 5)
        ], priority=31))
        net.add_rule(DecisionNetRule("AOP_RESP_1S_POS", Call(CallType.BID, 1, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("spade_len", ">=", 5)
        ], priority=31))
        net.add_rule(DecisionNetRule("AOP_RESP_1NT_POS", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("hcp", "<=", 13), RuleCondition("is_balanced", "==", True)
        ], priority=29))
        net.add_rule(DecisionNetRule("AOP_RESP_2C_POS", Call(CallType.BID, 2, Strain.CLUBS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("club_len", ">=", 5)
        ], priority=27))
        net.add_rule(DecisionNetRule("AOP_RESP_2D_POS", Call(CallType.BID, 2, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 8), RuleCondition("diamond_len", ">=", 5)
        ], priority=27))
        net.add_rule(DecisionNetRule("AOP_RESP_3NT_POS", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1C"), RuleCondition("hcp", ">=", 14), RuleCondition("is_balanced", "==", True)
        ], priority=32))

        # Opener Rebids after 1C - 1D (Negative)
        net.add_rule(DecisionNetRule("AOP_REBID_1H", Call(CallType.BID, 1, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1D"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 16)
        ], priority=27))
        net.add_rule(DecisionNetRule("AOP_REBID_1S", Call(CallType.BID, 1, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1D"), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 16)
        ], priority=27))
        net.add_rule(DecisionNetRule("AOP_REBID_1NT", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1D"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 16), RuleCondition("hcp", "<=", 18)
        ], priority=25))
        net.add_rule(DecisionNetRule("AOP_REBID_2NT", Call(CallType.BID, 2, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1D"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 19), RuleCondition("hcp", "<=", 21)
        ], priority=26))
        net.add_rule(DecisionNetRule("AOP_REBID_3NT", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1D"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 22)
        ], priority=28))

        # 2. Mini-Strong 1NT Opening (14-16 HCP balanced)
        net.add_rule(DecisionNetRule("AOP_1NT_MINI", Call(CallType.BID, 1, Strain.NT), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 14), RuleCondition("hcp", "<=", 16), RuleCondition("is_balanced", "==", True)
        ], priority=25))
        net.add_rule(DecisionNetRule("AOP_1NT_RESP_3NT", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1NT"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 10)
        ], priority=22))

        # 3. Strong 2NT Opening (20-21 HCP balanced)
        net.add_rule(DecisionNetRule("AOP_OPEN_2NT", Call(CallType.BID, 2, Strain.NT), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 20), RuleCondition("hcp", "<=", 21), RuleCondition("is_balanced", "==", True)
        ], priority=29))
        net.add_rule(DecisionNetRule("AOP_2NT_RESP_3NT", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "2NT"), RuleCondition("hcp", ">=", 4)
        ], priority=23))

        # 4. Flannery 2D (11-15 HCP, 5 Hearts + 4 Spades)
        net.add_rule(DecisionNetRule("AOP_OPEN_FLANNERY_2D", Call(CallType.BID, 2, Strain.DIAMONDS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15),
            RuleCondition("heart_len", "==", 5), RuleCondition("spade_len", "==", 4)
        ], priority=24))
        net.add_rule(DecisionNetRule("AOP_FLANNERY_RESP_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "2D"), RuleCondition("heart_len", ">=", 3), RuleCondition("hcp", "<=", 10)
        ], priority=22))
        net.add_rule(DecisionNetRule("AOP_FLANNERY_RESP_4H", Call(CallType.BID, 4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "2D"), RuleCondition("heart_len", ">=", 3), RuleCondition("hcp", ">=", 11)
        ], priority=25))

        # 5. Sound Limited 1-Level Openings (11-15 HCP)
        net.add_rule(DecisionNetRule("AOP_1H_LIM", Call(CallType.BID, 1, Strain.HEARTS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("heart_len", ">=", 5)
        ], priority=20))
        net.add_rule(DecisionNetRule("AOP_1S_LIM", Call(CallType.BID, 1, Strain.SPADES), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("spade_len", ">=", 5)
        ], priority=20))
        net.add_rule(DecisionNetRule("AOP_1D_LIM", Call(CallType.BID, 1, Strain.DIAMONDS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("diamond_len", ">=", 2)
        ], priority=15))

        # Bergen Raises over 1H/1S
        # 3C = Constructive 4-card raise (10-11 support pts)
        net.add_rule(DecisionNetRule("AOP_BERGEN_3C_H", Call(CallType.BID, 3, Strain.CLUBS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 10), RuleCondition("hcp", "<=", 11)
        ], priority=23))
        net.add_rule(DecisionNetRule("AOP_BERGEN_3C_S", Call(CallType.BID, 3, Strain.CLUBS), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 10), RuleCondition("hcp", "<=", 11)
        ], priority=23))
        # 3D = Preemptive 4-card raise (6-9 support pts)
        net.add_rule(DecisionNetRule("AOP_BERGEN_3D_H", Call(CallType.BID, 3, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 9)
        ], priority=23))
        net.add_rule(DecisionNetRule("AOP_BERGEN_3D_S", Call(CallType.BID, 3, Strain.DIAMONDS), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 9)
        ], priority=23))
        # 2NT = Jacoby 2NT Game Force (12+ support pts, 4-card fit)
        net.add_rule(DecisionNetRule("AOP_JACOBY_2NT_H", Call(CallType.BID, 2, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=25))
        net.add_rule(DecisionNetRule("AOP_JACOBY_2NT_S", Call(CallType.BID, 2, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=25))

        # Opener Maximum Game Acceptance over Bergen/Limit (13-15 HCP)
        net.add_rule(DecisionNetRule("AOP_ACCEPT_4H_MAX", Call(CallType.BID, 4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "in", ["3C", "3H"]), RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 13)
        ], priority=26))
        net.add_rule(DecisionNetRule("AOP_ACCEPT_4S_MAX", Call(CallType.BID, 4, Strain.SPADES), [
            RuleCondition("partner_last_call", "in", ["3C", "3S"]), RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 13)
        ], priority=26))

        # Standard 2M simple raise and 4M game raise
        net.add_rule(DecisionNetRule("AOP_RESP_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 3), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 9)
        ], priority=18))
        net.add_rule(DecisionNetRule("AOP_RESP_4H", Call(CallType.BID, 4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))
        net.add_rule(DecisionNetRule("AOP_RESP_2S", Call(CallType.BID, 2, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 3), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 9)
        ], priority=18))
        net.add_rule(DecisionNetRule("AOP_RESP_4S", Call(CallType.BID, 4, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))

        # 6. Precision 2C Opening (11-15 HCP, 6+ clubs)
        net.add_rule(DecisionNetRule("AOP_2C_PREC", Call(CallType.BID, 2, Strain.CLUBS), [
            RuleCondition("is_opening", "==", True), RuleCondition("hcp", ">=", 11), RuleCondition("hcp", "<=", 15), RuleCondition("club_len", ">=", 6)
        ], priority=21))

        # 7. Weak Twos (6-10 HCP, 6-card major)
        net.add_rule(DecisionNetRule("AOP_WEAK_2H", Call(CallType.BID, 2, Strain.HEARTS), [
            RuleCondition("is_opening", "==", True), RuleCondition("heart_len", "==", 6), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10), RuleCondition("is_balanced", "==", False)
        ], priority=19))
        net.add_rule(DecisionNetRule("AOP_WEAK_2S", Call(CallType.BID, 2, Strain.SPADES), [
            RuleCondition("is_opening", "==", True), RuleCondition("spade_len", "==", 6), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10), RuleCondition("is_balanced", "==", False)
        ], priority=19))

        # 8. Preemptive Threes (7-card suits, 6-10 HCP)
        net.add_rule(DecisionNetRule("AOP_PREEMPT_3C", Call(CallType.BID, 3, Strain.CLUBS), [
            RuleCondition("is_opening", "==", True), RuleCondition("club_len", ">=", 7), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)
        ], priority=22))
        net.add_rule(DecisionNetRule("AOP_PREEMPT_3D", Call(CallType.BID, 3, Strain.DIAMONDS), [
            RuleCondition("is_opening", "==", True), RuleCondition("diamond_len", ">=", 7), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)
        ], priority=22))
        net.add_rule(DecisionNetRule("AOP_PREEMPT_3H", Call(CallType.BID, 3, Strain.HEARTS), [
            RuleCondition("is_opening", "==", True), RuleCondition("heart_len", ">=", 7), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)
        ], priority=23))
        net.add_rule(DecisionNetRule("AOP_PREEMPT_3S", Call(CallType.BID, 3, Strain.SPADES), [
            RuleCondition("is_opening", "==", True), RuleCondition("spade_len", ">=", 7), RuleCondition("hcp", ">=", 6), RuleCondition("hcp", "<=", 10)
        ], priority=23))

        # 9. Small Slams (6H/6S/6NT) and Grand Slams (7H/7S on 22+ HCP)
        net.add_rule(DecisionNetRule("AOP_SLAM_6H", Call(CallType.BID, 6, Strain.HEARTS), [
            RuleCondition("partner_last_call", "in", ["1H", "2H", "3H", "4H"]), RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 18)
        ], priority=28))
        net.add_rule(DecisionNetRule("AOP_SLAM_6S", Call(CallType.BID, 6, Strain.SPADES), [
            RuleCondition("partner_last_call", "in", ["1S", "2S", "3S", "4S"]), RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 18)
        ], priority=28))
        net.add_rule(DecisionNetRule("AOP_SLAM_6NT", Call(CallType.BID, 6, Strain.NT), [
            RuleCondition("partner_last_call", "in", ["1NT", "2NT", "3NT"]), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 17)
        ], priority=28))
        net.add_rule(DecisionNetRule("AOP_GRAND_7H", Call(CallType.BID, 7, Strain.HEARTS), [
            RuleCondition("partner_last_call", "in", ["4H", "6H"]), RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 22), RuleCondition("controls", ">=", 8)
        ], priority=34))
        net.add_rule(DecisionNetRule("AOP_GRAND_7S", Call(CallType.BID, 7, Strain.SPADES), [
            RuleCondition("partner_last_call", "in", ["4S", "6S"]), RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 22), RuleCondition("controls", ">=", 8)
        ], priority=34))

        return net

    @staticmethod
    def create_autonomous_evolved_system() -> DecisionNet:
        """Autonomous Evolved Bidding System from Continuous Improvement Pipeline."""
        # Start from 2/1 base and include all discovered protocols & gambling pools
        net = SystemOptimizer.create_modern_2over1()
        net.name = "Autonomous_Evolved_AI"
        
        # Add Jacoby 2NT, Splinters, Smolen, Cappelletti, Gambling 3NT
        for proto in (ConventionProtocol.create_cappelletti(),
                      ConventionProtocol.create_smolen(),
                      ConventionProtocol.create_strategic_gambling()):
            for r in proto.compile_to_rules():
                net.add_rule(r)

        # High priority game / slam conversions
        net.add_rule(DecisionNetRule("AI_RESP_4H", Call(CallType.BID, 4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "1H"), RuleCondition("heart_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))
        net.add_rule(DecisionNetRule("AI_RESP_4S", Call(CallType.BID, 4, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "1S"), RuleCondition("spade_len", ">=", 4), RuleCondition("hcp", ">=", 12)
        ], priority=24))
        net.add_rule(DecisionNetRule("AI_RESP_3NT", Call(CallType.BID, 3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "1NT"), RuleCondition("is_balanced", "==", True), RuleCondition("hcp", ">=", 10), RuleCondition("hcp", "<=", 15)
        ], priority=22))
        net.add_rule(DecisionNetRule("AI_SLAM_6H", Call(CallType.BID, 6, Strain.HEARTS), [
            RuleCondition("partner_last_call", "in", ["1H", "2H", "4H"]), RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 19)
        ], priority=28))
        net.add_rule(DecisionNetRule("AI_SLAM_6S", Call(CallType.BID, 6, Strain.SPADES), [
            RuleCondition("partner_last_call", "in", ["1S", "2S", "4S"]), RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 19)
        ], priority=28))
        return net

    def run_world_championship_tournament(self, num_boards: int = 50) -> Dict[str, Any]:
        """
        Runs a comprehensive round-robin tournament across all systems
        to determine the undisputed Champion Bidding System.
        """
        print("=" * 85)
        print(" 🏅 RUNNING WORLD BIDDING SYSTEM CHAMPIONSHIP TOURNAMENT")
        print(f"    Total Boards: {num_boards} (Duplicate scored across all system pairings)")
        print("=" * 85)

        # 1. Generate Stratified Tournament Deals
        deals: List[Deal] = []
        for _ in range(max(1, num_boards - 8)):
            deals.append(Deal.random_deal(dealer=Seat.NORTH))
        deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.SOUTH, suit_stratum=(Suit.SPADES, 8)))
        deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.NORTH, suit_stratum=(Suit.HEARTS, 8)))
        deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.SOUTH, suit_stratum=(Suit.DIAMONDS, 7)))
        deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.NORTH, suit_stratum=(Suit.CLUBS, 7)))
        deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.SOUTH, hcp_stratum=(22, 25)))
        deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.NORTH, hcp_stratum=(16, 18)))
        deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.SOUTH, hcp_stratum=(0, 4)))
        deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.NORTH, hcp_stratum=(19, 21)))

        # 2. Competitors
        competitors = [
            self.create_sayc_baseline(),
            self.create_precision_system(),
            self.create_modern_2over1(),
            self.create_autonomous_evolved_system(),
            self.create_quantum_relay_precision(),
            self.create_alpha_relay_precision(),
            self.create_apex_omega_precision()
        ]
        opponent_ref = self.create_sayc_baseline()

        standings: Dict[str, Dict[str, Any]] = {
            s.name: {"name": s.name, "system": s, "total_imps": 0, "wins": 0, "losses": 0, "ties": 0, "matches": 0}
            for s in competitors
        }

        # 3. Round-Robin Tournament
        matches: List[MatchResult] = []
        for i in range(len(competitors)):
            for j in range(i + 1, len(competitors)):
                sys_a = competitors[i]
                sys_b = competitors[j]

                match = self.arena.play_match(deals, sys_a, sys_b, opponent_ref)
                matches.append(match)

                standings[sys_a.name]["total_imps"] += match.net_imps
                standings[sys_b.name]["total_imps"] -= match.net_imps
                standings[sys_a.name]["matches"] += 1
                standings[sys_b.name]["matches"] += 1

                if match.net_imps > 0:
                    standings[sys_a.name]["wins"] += 1
                    standings[sys_b.name]["losses"] += 1
                elif match.net_imps < 0:
                    standings[sys_b.name]["wins"] += 1
                    standings[sys_a.name]["losses"] += 1
                else:
                    standings[sys_a.name]["ties"] += 1
                    standings[sys_b.name]["ties"] += 1

                print(f"  • Match: {sys_a.name:<24} vs {sys_b.name:<24} -> Net IMPs: {match.net_imps:+4d} ({sys_a.name if match.net_imps > 0 else (sys_b.name if match.net_imps < 0 else 'Tie')})")

        # 4. Rank by Total IMPs
        ranked = sorted(standings.values(), key=lambda x: x["total_imps"], reverse=True)
        champion = ranked[0]["system"]

        # Save Champion to disk
        dsl_champion_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "system", "champion_system.dsl")
        champion.save_dsl(dsl_champion_path)

        print("\n" + "=" * 85)
        print(" 🏆 WORLD CHAMPIONSHIP FINAL STANDINGS")
        print("=" * 85)
        print(f" {'Rank':<6} | {'System Name':<28} | {'Record (W-L-T)':<16} | {'Net IMPs':<12} | {'Avg IMP/Brd'}")
        print("-" * 85)
        for idx, r in enumerate(ranked, 1):
            avg_imp = r["total_imps"] / (num_boards * (len(competitors) - 1))
            rec_str = f"{r['wins']}-{r['losses']}-{r['ties']}"
            crown = "👑 " if idx == 1 else "   "
            print(f" {crown}{idx:<4} | {r['name']:<28} | {rec_str:<16} | {r['total_imps']:<+12d} | {avg_imp:+.2f}")
        print("=" * 85)

        print(f"\n🎉 UNDISPUTED CHAMPION: {champion.name}!")
        print(f"💾 Champion system code persisted to: {dsl_champion_path}\n")

        return {
            "ranked_standings": ranked,
            "champion": champion.name,
            "champion_file": dsl_champion_path,
            "matches": matches
        }

if __name__ == "__main__":
    opt = SystemOptimizer()
    opt.run_world_championship_tournament(num_boards=50)
