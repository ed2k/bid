#!/usr/bin/env python3
"""
Python wrapper around Gerrit A. van der Velde's `SuitC` single-dummy suit-combination
analyzer (`bin/SuitC`).

Provides exact single-dummy expected tricks (`R`), safety-play probabilities (`N<k>`),
stopper analysis (`-D`), outside-entry limits (`-l{n,s}<n>`), and vacant-places
hypergeometric weighting (`-wv<n>`, `-ev<n>`).
"""

import os
import re
import subprocess
from dataclasses import dataclass
from functools import lru_cache
from typing import Dict, Iterable, Optional, Sequence

from bid.models import Card, Hand, Rank, Seat, Suit

_ALL_RANKS = "AKQJT98765432"
_RANK_TO_CHAR = {
    Rank.ACE: "A",
    Rank.KING: "K",
    Rank.QUEEN: "Q",
    Rank.JACK: "J",
    Rank.TEN: "T",
    Rank.NINE: "9",
    Rank.EIGHT: "8",
    Rank.SEVEN: "7",
    Rank.SIX: "6",
    Rank.FIVE: "5",
    Rank.FOUR: "4",
    Rank.THREE: "3",
    Rank.TWO: "2",
}

_MIN_RE = re.compile(r"min number of tricks:\s*(\d+)")
_MAX_RE = re.compile(r"max number of tricks:\s*(\d+)")
_TRICK_PCT_RE = re.compile(r"^\s*(\d+)\s+tricks:\s*([0-9.]+)")
_RESULT_RE = re.compile(r"^\s*Result\s*:\s*([0-9.]+)")


def _default_binary_path() -> str:
    repo_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    candidates = [
        os.environ.get("SUITC_BIN", ""),
        os.path.join(repo_root, "bin", "SuitC"),
        os.path.join(os.path.dirname(repo_root), "SuitC", "bin", "SuitC"),
    ]
    for path in candidates:
        if path and os.path.isfile(path) and os.access(path, os.X_OK):
            return path
    return os.path.join(repo_root, "bin", "SuitC")


@dataclass(frozen=True)
class SuitCResult:
    """Single-dummy suit combination analysis result from SuitC."""
    expected_tricks: float
    trick_probs: Dict[int, float]  # k -> P(tricks >= k) in [0.0, 1.0]
    min_tricks: int
    max_tricks: int

    def p_at_least(self, k: int) -> float:
        """Probability in [0.0, 1.0] of winning at least `k` tricks with optimal play."""
        if k <= self.min_tricks:
            return 1.0
        if k > self.max_tricks:
            return 0.0
        return float(self.trick_probs.get(k, 0.0))


class SuitCSolver:
    """Interface to the native `bin/SuitC` suit-combination solver."""

    _BIN_PATH: str = _default_binary_path()

    @classmethod
    def is_available(cls) -> bool:
        return os.path.isfile(cls._BIN_PATH) and os.access(cls._BIN_PATH, os.X_OK)

    @staticmethod
    def normalize_holding(holding: str) -> str:
        """Normalize a holding string into canonical descending rank order (or '.' for void)."""
        s = (holding or "").strip().upper()
        if not s or s in (".", "-"):
            return "."
        present = {ch for ch in s if ch in _ALL_RANKS}
        ordered = "".join(ch for ch in _ALL_RANKS if ch in present)
        return ordered if ordered else "."

    @staticmethod
    def cards_to_suitc_str(cards: Sequence[Card]) -> str:
        """Convert a sequence of Card objects from one suit into a SuitC holding string."""
        if not cards:
            return "."
        chars = {_RANK_TO_CHAR[c.rank] for c in cards}
        ordered = "".join(ch for ch in _ALL_RANKS if ch in chars)
        return ordered if ordered else "."

    @classmethod
    def complement_cards(cls, north_str: str, south_str: str) -> str:
        """Compute the combined East-West cards as the complement in AKQJT98765432."""
        n_norm = cls.normalize_holding(north_str)
        s_norm = cls.normalize_holding(south_str)
        used = set()
        if n_norm != ".":
            used.update(n_norm)
        if s_norm != ".":
            used.update(s_norm)
        rem = "".join(ch for ch in _ALL_RANKS if ch not in used)
        return rem if rem else "."

    @classmethod
    @lru_cache(maxsize=4096)
    def _run_cached(
        cls,
        north_norm: str,
        south_norm: str,
        west_vacant: Optional[int],
        east_vacant: Optional[int],
        north_entries: Optional[int],
        south_entries: Optional[int],
        leader: Optional[str],
        defense: bool,
        use_suit_entries: bool,
        cutoff: str,
    ) -> SuitCResult:
        if north_norm == "." and south_norm == ".":
            return SuitCResult(
                expected_tricks=0.0,
                trick_probs={0: 1.0},
                min_tricks=0,
                max_tricks=0,
            )

        ew_norm = cls.complement_cards(north_norm, south_norm)
        if not cls.is_available():
            return cls._fallback_estimate(north_norm, south_norm)

        cmd = [cls._BIN_PATH, "-r"]
        if use_suit_entries:
            cmd.append("-u")
        if cutoff:
            cmd.append(f"-c{cutoff}")
        if defense:
            cmd.append("-D")
        if west_vacant is not None:
            cmd.append(f"-wv{int(west_vacant)}")
        if east_vacant is not None:
            cmd.append(f"-ev{int(east_vacant)}")
        if north_entries is not None:
            cmd.append(f"-ln{int(north_entries)}")
        if south_entries is not None:
            cmd.append(f"-ls{int(south_entries)}")
        if leader is not None:
            ld = leader.strip().lower()[:1]
            if ld in ("n", "e", "s", "w"):
                cmd.append(f"-L{ld}")

        cmd.extend([north_norm, south_norm, ew_norm])

        proc = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=10.0,
            check=False,
        )
        if proc.returncode != 0 or not proc.stdout:
            return cls._fallback_estimate(north_norm, south_norm)

        return cls._parse_output(proc.stdout)

    @staticmethod
    def _parse_output(stdout: str) -> SuitCResult:
        min_m = _MIN_RE.search(stdout)
        max_m = _MAX_RE.search(stdout)
        min_tricks = int(min_m.group(1)) if min_m else 0
        max_tricks = int(max_m.group(1)) if max_m else min_tricks

        trick_probs: Dict[int, float] = {k: 1.0 for k in range(min_tricks + 1)}
        expected_tricks = float(min_tricks)

        in_optimal = False
        for line in stdout.splitlines():
            if "The optimal results" in line:
                in_optimal = True
                continue
            if in_optimal:
                if line.startswith("The optimum play for:"):
                    break
                m_tr = _TRICK_PCT_RE.match(line)
                if m_tr:
                    k = int(m_tr.group(1))
                    pct = float(m_tr.group(2))
                    trick_probs[k] = min(1.0, max(0.0, pct / 100.0))
                    continue
                m_res = _RESULT_RE.match(line)
                if m_res:
                    expected_tricks = float(m_res.group(1))

        return SuitCResult(
            expected_tricks=expected_tricks,
            trick_probs=trick_probs,
            min_tricks=min_tricks,
            max_tricks=max_tricks,
        )

    @staticmethod
    def _fallback_estimate(north_norm: str, south_norm: str) -> SuitCResult:
        """Fast heuristic fallback if the native binary is unavailable."""
        n_len = 0 if north_norm == "." else len(north_norm)
        s_len = 0 if south_norm == "." else len(south_norm)
        max_len = max(n_len, s_len)
        combined = ("" if north_norm == "." else north_norm) + ("" if south_norm == "." else south_norm)
        top = sum(1.0 for ch in ("A", "K", "Q") if ch in combined)
        est = min(float(max_len), top + max(0.0, max_len - 3.0) * 0.7)
        fl = int(est)
        return SuitCResult(
            expected_tricks=est,
            trick_probs={k: 1.0 for k in range(fl + 1)},
            min_tricks=fl,
            max_tricks=max_len,
        )

    @classmethod
    def analyze_cards(
        cls,
        north_cards: str,
        south_cards: str,
        *,
        west_vacant: Optional[int] = None,
        east_vacant: Optional[int] = None,
        north_entries: Optional[int] = None,
        south_entries: Optional[int] = None,
        leader: Optional[str] = None,
        defense: bool = False,
        use_suit_entries: bool = True,
        cutoff: str = "20k",
    ) -> SuitCResult:
        """Analyze a single-suit combination held by North (dummy) and South (declarer)."""
        n_norm = cls.normalize_holding(north_cards)
        s_norm = cls.normalize_holding(south_cards)
        return cls._run_cached(
            n_norm,
            s_norm,
            west_vacant,
            east_vacant,
            north_entries,
            south_entries,
            leader,
            defense,
            use_suit_entries,
            cutoff,
        )

    @classmethod
    def analyze_hands_suit(
        cls,
        north_hand: Hand,
        south_hand: Hand,
        suit: Suit,
        **kwargs,
    ) -> SuitCResult:
        """Analyze `suit` given North and South `Hand` objects."""
        n_str = cls.cards_to_suitc_str(north_hand.by_suit.get(suit, []))
        s_str = cls.cards_to_suitc_str(south_hand.by_suit.get(suit, []))
        return cls.analyze_cards(n_str, s_str, **kwargs)

    @classmethod
    def analyze_deal_suit(
        cls,
        deal,
        declarer: Seat,
        suit: Suit,
        **kwargs,
    ) -> SuitCResult:
        """Analyze `suit` for `(dummy=declarer.partner, declarer)` on a `Deal`."""
        dummy = declarer.partner
        return cls.analyze_hands_suit(
            deal.hands[dummy],
            deal.hands[declarer],
            suit,
            **kwargs,
        )

    @classmethod
    def stopper_tricks(
        cls,
        north_cards: str,
        south_cards: str,
        leader: str = "e",
        **kwargs,
    ) -> SuitCResult:
        """Evaluate NT stopper probability in a suit when an opponent leads (`-D -L<e|w>`)."""
        return cls.analyze_cards(
            north_cards,
            south_cards,
            leader=leader,
            defense=True,
            **kwargs,
        )

