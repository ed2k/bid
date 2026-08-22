#!/usr/bin/env python3
"""
SDS: Single Dummy Solver scoring for Bid.

Python-side equivalent of ../dds/sds.md: given a played contract, re-scores it
from the declarer partnership's TWO-HAND view (declarer + dummy known,
opponents hidden) by sampling N worlds consistent with the known cards,
double-dummy solving each world, and reporting P(make) / mean tricks /
expected duplicate score.

Constraints honored (sds.md WorldSampler v1):
  - known seats fixed (declarer + dummy holdings preserved exactly)
  - card conservation across remaining seats
  - hand lengths preserved
  - uniform sampling among accepted worlds
"""

import random
from dataclasses import dataclass
from typing import Dict, List, Tuple

from bid.models import Seat, Strain, Suit, Rank, Card, Hand
from bid.dds import DDSolver


@dataclass
class SDSResult:
    mean_score: float          # expected duplicate points, declarer partnership view
    p_make: float              # P(tricks >= needed)
    mean_tricks: float
    num_worlds: int

    def __repr__(self):
        return (f"SDS(score {self.mean_score:+.1f}, P(make) {self.p_make:.2f}, "
                f"tricks {self.mean_tricks:.2f}, n={self.num_worlds})")


class SDSScorer:
    def __init__(self, num_worlds: int = 20, seed: int = 0):
        self.num_worlds = num_worlds
        self.seed = seed

    @staticmethod
    def sample_worlds(deal, viewer_seats: Tuple[Seat, Seat], num_worlds: int,
                      rng: random.Random) -> List[Tuple[List[Card], List[Card]]]:
        """
        Samples num_worlds assignments of the hidden cards between the two
        non-viewer seats. Known seats are never touched.
        Returns list of (cards_seat_a, cards_seat_b) as Card lists.
        """
        unknown = [s for s in Seat if s not in viewer_seats]
        pools = []
        for s in unknown:
            cards = []
            for suit, cards_of_suit in deal.hands[s].by_suit.items():
                cards.extend(cards_of_suit)
            pools.append(cards)

        worlds = []
        for _ in range(num_worlds):
            combined = pools[0] + pools[1]
            rng.shuffle(combined)
            n0 = len(pools[0])
            worlds.append((combined[:n0], combined[n0:]))
        return worlds

    def score_contract(self, deal, level: int, strain: Strain, declarer: Seat,
                       doubled: int = 0, vuln: int = 0) -> SDSResult:
        from bid.scoring import calculate_contract_score, Vulnerability

        dummy = declarer.partner
        rng = random.Random(self.seed)
        worlds = self.sample_worlds(deal, (declarer, dummy), self.num_worlds, rng)

        is_vul = Vulnerability.is_vulnerable(vuln, declarer)
        needed = level + 6
        unknown = [s for s in Seat if s not in (declarer, dummy)]

        total_score = 0.0
        makes = 0
        total_tricks = 0

        for cards_a, cards_b in worlds:
            hands = dict(deal.hands)
            hands[unknown[0]] = Hand(list(cards_a))
            hands[unknown[1]] = Hand(list(cards_b))
            world = type(deal)(hands=hands, dealer=deal.dealer, vuln=deal.vuln)

            tricks = DDSolver.get_tricks(world, strain, declarer)
            total_tricks += tricks
            if tricks >= needed:
                makes += 1
            total_score += calculate_contract_score(
                level=level, strain=strain, doubled=doubled,
                is_vulnerable=is_vul, tricks_taken=tricks)

        n = max(1, len(worlds))
        return SDSResult(total_score / n, makes / n, total_tricks / n, len(worlds))
