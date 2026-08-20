#!/usr/bin/env python3
"""
Duplicate Bridge Scoring Engine for Bid.
Directly ported from BEN (../ben/src/scoring.py).
Provides official ACBL / WBF contract score calculation, undertrick penalties,
vulnerability modifiers, overtrick bonuses, and IMP conversions.
"""

import functools
from typing import Optional, Dict, Tuple, List
from bid.models import Suit, Strain, Seat, Rank, Hand, Call, CallType

class Vulnerability:
    NONE = 0
    NS = 1
    EW = 2
    BOTH = 3

    @staticmethod
    def is_vulnerable(vuln: int, seat: Seat) -> bool:
        if vuln == Vulnerability.BOTH:
            return True
        if vuln == Vulnerability.NONE:
            return False
        if vuln == Vulnerability.NS:
            return seat in (Seat.NORTH, Seat.SOUTH)
        if vuln == Vulnerability.EW:
            return seat in (Seat.EAST, Seat.WEST)
        return False

TRICK_VAL = {'C': 20, 'D': 20, 'H': 30, 'S': 30, 'N': 30}

def score(contract: str, is_vulnerable: bool, n_tricks: int) -> int:
    """
    Computes exact duplicate bridge score for a contract.
    contract format: '1N', '4H', '4SX', '3NXX', 'Pass'
    Direct port from BEN (../ben/src/scoring.py).
    """
    if contract.lower() in ("pass", "p", ""):
        return 0

    level = int(contract[0])
    strain = contract[1].upper()
    doubled = 'X' in contract and 'XX' not in contract
    redoubled = 'XX' in contract

    target = 6 + level

    if n_tricks >= target:
        # Contract Made
        base_score = level * TRICK_VAL.get(strain, 30)
        if strain == 'N':
            base_score += 10
        bonus = 0

        # Doubles and redoubles
        if redoubled:
            base_score *= 4
            bonus += 100
        elif doubled:
            base_score *= 2
            bonus += 50

        # Game bonus
        if base_score < 100:
            bonus += 50
        else:
            bonus += 500 if is_vulnerable else 300

        # Slam bonus
        if level == 6:
            bonus += 750 if is_vulnerable else 500
        elif level == 7:
            bonus += 1500 if is_vulnerable else 1000

        n_overtricks = n_tricks - target
        if redoubled:
            overtrick_score = n_overtricks * (400 if is_vulnerable else 200)
        elif doubled:
            overtrick_score = n_overtricks * (200 if is_vulnerable else 100)
        else:
            overtrick_score = n_overtricks * TRICK_VAL.get(strain, 30)

        return base_score + overtrick_score + bonus
    else:
        # Contract Failed
        n_undertricks = target - n_tricks
        if is_vulnerable:
            if redoubled:
                undertrick_values = [400] + [600] * 12
            elif doubled:
                undertrick_values = [200] + [300] * 12
            else:
                undertrick_values = [100] * 13
        else:
            if redoubled:
                undertrick_values = [200, 400, 400] + [600] * 10
            elif doubled:
                undertrick_values = [100, 200, 200] + [300] * 10
            else:
                undertrick_values = [50] * 13

        return -sum(undertrick_values[:n_undertricks])

def diff_to_imps(diff: int) -> int:
    """
    Converts points difference to International Match Points (IMPs).
    Standard WBF scale ported from BEN.
    """
    abs_diff = abs(diff)

    if abs_diff <= 10:
        return 0
    elif abs_diff <= 40:
        return 1
    elif abs_diff <= 80:
        return 2
    elif abs_diff <= 120:
        return 3
    elif abs_diff <= 160:
        return 4
    elif abs_diff <= 210:
        return 5
    elif abs_diff <= 260:
        return 6
    elif abs_diff <= 310:
        return 7
    elif abs_diff <= 360:
        return 8
    elif abs_diff <= 420:
        return 9
    elif abs_diff <= 490:
        return 10
    elif abs_diff <= 590:
        return 11
    elif abs_diff <= 740:
        return 12
    elif abs_diff <= 890:
        return 13
    elif abs_diff <= 1090:
        return 14
    elif abs_diff <= 1290:
        return 15
    elif abs_diff <= 1490:
        return 16
    elif abs_diff <= 1740:
        return 17
    elif abs_diff <= 1990:
        return 18
    elif abs_diff <= 2240:
        return 19
    elif abs_diff <= 2490:
        return 20
    elif abs_diff <= 2990:
        return 21
    elif abs_diff <= 3490:
        return 22
    elif abs_diff <= 3990:
        return 23
    else:
        return 24

def score_to_imp(diff: int) -> int:
    """Signed IMP conversion."""
    sign = 1 if diff >= 0 else -1
    return sign * diff_to_imps(diff)

def contract_scores_by_trick(contract: str, is_vulnerable: bool) -> List[int]:
    """Returns a list of length 14 containing scores for taking 0..13 tricks."""
    return [score(contract, is_vulnerable, t) for t in range(14)]

def estimate_double_dummy_tricks(hands: Dict[Seat, Hand], strain: Strain, declarer: Seat) -> int:
    """Estimates double dummy tricks from hands using DDSolver."""
    from bid.sampling import Deal
    deal = Deal(hands, dealer=declarer)
    from bid.dds import DDSolver
    return DDSolver.get_tricks(deal, strain, declarer)

def calculate_contract_score(*args, **kwargs) -> int:
    """
    Flexible wrapper for duplicate contract score calculation.
    Supports:
      calculate_contract_score(level, strain, declarer, tricks, is_vul, doubled)
      calculate_contract_score(level=4, strain=Strain.HEARTS, doubled=0, is_vulnerable=False, tricks_taken=10)
    """
    level = kwargs.get("level", 1)
    strain = kwargs.get("strain", Strain.NT)
    doubled = kwargs.get("doubled", 0)
    is_vul = kwargs.get("is_vulnerable", False)
    tricks = kwargs.get("tricks_taken", 0)

    if len(args) >= 1:
        level = args[0]
    if len(args) >= 2:
        strain = args[1]
    if len(args) == 5:
        # (level, strain, declarer, tricks, is_vul)
        tricks = args[3]
        is_vul = args[4]
    elif len(args) == 6:
        # (level, strain, declarer, tricks, is_vul, doubled)
        tricks = args[3]
        is_vul = args[4]
        doubled = args[5]
    elif len(args) == 4:
        # (level, strain, tricks, is_vul)
        tricks = args[2]
        is_vul = args[3]

    strain_map = {
        Strain.CLUBS: 'C',
        Strain.DIAMONDS: 'D',
        Strain.HEARTS: 'H',
        Strain.SPADES: 'S',
        Strain.NT: 'N'
    }
    c_str = f"{level}{strain_map.get(strain, 'N')}"
    if doubled == 1:
        c_str += "X"
    elif doubled == 2:
        c_str += "XX"
    return score(c_str, is_vul, tricks)
