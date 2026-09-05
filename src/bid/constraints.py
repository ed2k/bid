from typing import Dict, Tuple, Optional, Set
from bid.models import Hand, Suit

class HandConstraints:
    def __init__(self, 
                 hcp_min: int = 0, hcp_max: int = 37,
                 major_hcp_min: int = 0, major_hcp_max: int = 37,
                 tp_min: int = 0, tp_max: int = 50,
                 controls_min: int = 0, controls_max: int = 12,
                 length_min: Dict[Suit, int] = None,
                 length_max: Dict[Suit, int] = None,
                 aces: Optional[Set[int]] = None,
                 ace_topology: Optional[Set[str]] = None,
                 balanced: Optional[bool] = None):
        self.hcp_min = hcp_min
        self.hcp_max = hcp_max
        self.major_hcp_min = major_hcp_min
        self.major_hcp_max = major_hcp_max
        self.tp_min = tp_min
        self.tp_max = tp_max
        self.controls_min = controls_min
        self.controls_max = controls_max
        self.length_min = length_min or {s: 0 for s in Suit}
        self.length_max = length_max or {s: 13 for s in Suit}
        self.aces = aces
        self.ace_topology = ace_topology
        self.balanced = balanced  # None = don't care, True = required, False = forbidden

    def matches(self, hand: Hand) -> bool:
        if not (self.hcp_min <= hand.hcp <= self.hcp_max):
            return False

        if not (self.major_hcp_min <= hand.major_hcp <= self.major_hcp_max):
            return False
        
        if not (self.tp_min <= hand.total_points <= self.tp_max):
            return False
            
        if not (self.controls_min <= hand.controls <= self.controls_max):
            return False
            
        if self.aces is not None and hand.ace_count not in self.aces:
            return False

        if self.ace_topology is not None and hand.ace_topology not in self.ace_topology:
            return False
        
        if self.balanced is not None:
            if hand.is_balanced != self.balanced:
                return False

        for suit in Suit:
            l = hand.length(suit)
            if not (self.length_min[suit] <= l <= self.length_max[suit]):
                return False
        
        return True

    def intersect(self, other: 'HandConstraints') -> 'HandConstraints':
        """Combine two constraints (e.g., previous specific knowledge + new bid info)."""
        new_min = {s: max(self.length_min[s], other.length_min[s]) for s in Suit}
        new_max = {s: min(self.length_max[s], other.length_max[s]) for s in Suit}
        
        new_bal = self.balanced
        if other.balanced is not None:
            if self.balanced is not None and self.balanced != other.balanced:
                # Contradiction - strictly this is impossible state, but we'll accept the new restriction
                pass # In a real engine, we'd flag contradiction
            new_bal = other.balanced

        new_aces = self._intersect_sets(self.aces, other.aces)
        new_topology = self._intersect_sets(self.ace_topology, other.ace_topology)

        return HandConstraints(
            hcp_min=max(self.hcp_min, other.hcp_min),
            hcp_max=min(self.hcp_max, other.hcp_max),
            tp_min=max(self.tp_min, other.tp_min),
            tp_max=min(self.tp_max, other.tp_max),
            controls_min=max(self.controls_min, other.controls_min),
            controls_max=min(self.controls_max, other.controls_max),
            length_min=new_min,
            length_max=new_max,
            aces=new_aces,
            ace_topology=new_topology,
            balanced=new_bal
        )

    def _intersect_sets(self, s1, s2):
        if s1 is None: return s2
        if s2 is None: return s1
        return s1.intersection(s2)

    _SUIT_BY_NAME = {s.name.lower(): s for s in Suit}

    def lower_bounds(self):
        """Binding lower bounds only: fields with min above the default whose
        max is still the default (pure 'X+' style requirements)."""
        out = []
        if self.hcp_min > 0 and self.hcp_max >= 37:
            out.append(("hcp", self.hcp_min))
        if self.major_hcp_min > 0 and self.major_hcp_max >= 37:
            out.append(("major_hcp", self.major_hcp_min))
        if self.tp_min > 0 and self.tp_max >= 50:
            out.append(("tp", self.tp_min))
        if self.controls_min > 0 and self.controls_max >= 12:
            out.append(("controls", self.controls_min))
        for s in Suit:
            if self.length_min[s] > 0 and self.length_max[s] >= 13:
                out.append((s.name.lower(), self.length_min[s]))
        return out

    def cap_above(self, field: str, new_max: int) -> 'HandConstraints':
        """Copy of these constraints with one field's upper bound lowered.
        Used to carve declined lower-bound requirements out of a pass
        inference (passing over '1C: 16+' implies hcp <= 15)."""
        suit = self._SUIT_BY_NAME.get(field)
        kw = dict(
            hcp_min=self.hcp_min, hcp_max=self.hcp_max,
            major_hcp_min=self.major_hcp_min, major_hcp_max=self.major_hcp_max,
            tp_min=self.tp_min, tp_max=self.tp_max,
            controls_min=self.controls_min, controls_max=self.controls_max,
            length_min=dict(self.length_min), length_max=dict(self.length_max),
            aces=self.aces, ace_topology=self.ace_topology,
            balanced=self.balanced,
        )
        if suit is not None:
            kw["length_max"][suit] = min(kw["length_max"][suit], new_max)
        elif field in ("hcp", "major_hcp", "tp", "controls"):
            key = f"{field}_max"
            kw[key] = min(kw[key], new_max)
        else:
            return self
        return HandConstraints(**kw)

    def __str__(self):
        parts = [f"HCP: {self.hcp_min}-{self.hcp_max}"]
        if self.tp_min > 0 or self.tp_max < 50:
            parts.append(f"TP: {self.tp_min}-{self.tp_max}")
        if self.controls_min > 0 or self.controls_max < 12:
            parts.append(f"CTRL: {self.controls_min}-{self.controls_max}")
        if self.balanced is not None:
            parts.append("BAL" if self.balanced else "UNBAL")
        for s in Suit:
            if self.length_min[s] > 0 or self.length_max[s] < 13:
                parts.append(f"{s}:{self.length_min[s]}-{self.length_max[s]}")
        return ", ".join(parts)
