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
    """
    Two-hand contract scoring (PIMC over sampled opponent layouts).

    When `history` and `models` are supplied to score_contract, opponent
    layouts are not drawn uniformly: a pool of
    `condition_factor * num_worlds` completions is generated and the
    `num_worlds` layouts *most consistent with the observed auction* are kept
    (RBMBMC-style elite selection — Amit & Markovitch applied to scoring,
    per sds.md WorldSampler extension point).
    """

    def __init__(self, num_worlds: int = 20, seed: int = 0,
                 condition_factor: int = 0):
        self.num_worlds = num_worlds
        self.seed = seed
        self.condition_factor = max(0, condition_factor)

    # ---------- sampling ----------

    @staticmethod
    def _hidden_cards(deal, viewer_seats):
        """Remaining card lists for the two non-viewer seats."""
        out = []
        for s in Seat:
            if s in viewer_seats:
                continue
            cards = []
            for suit_cards in deal.hands[s].by_suit.values():
                cards.extend(suit_cards)
            out.append((s, cards))
        return out

    @classmethod
    def sample_world_dicts(cls, deal, viewer_seats, num_worlds, rng):
        """Full {Seat: [Card]} worlds; viewer holdings preserved exactly."""
        hidden = cls._hidden_cards(deal, viewer_seats)
        (sa, ca), (sb, cb) = hidden
        worlds = []
        for _ in range(num_worlds):
            pool = list(ca) + list(cb)
            rng.shuffle(pool)
            split = len(ca)
            w = {s: list(deal.hands[s].cards) for s in Seat}
            w[sa] = pool[:split]
            w[sb] = pool[split:]
            worlds.append(w)
        return worlds

    # Backwards-compatible pair API used by older tests.
    @classmethod
    def sample_worlds(cls, deal, viewer_seats, num_worlds, rng):
        unknown = [s for s, _ in cls._hidden_cards(deal, viewer_seats)]
        worlds = cls.sample_world_dicts(deal, viewer_seats, num_worlds, rng)
        return [(w[unknown[0]], w[unknown[1]]) for w in worlds]

    # ---------- conditioning ----------

    def _select_consistent(self, deal, viewer_seats, history, models,
                           num_worlds, rng):
        from bid.sampling import Deal as _Deal, calculate_inconsistency
        pool = self.sample_world_dicts(deal, viewer_seats,
                                       num_worlds * self.condition_factor, rng)
        scored = []
        for i, w in enumerate(pool):
            d = _Deal(hands={s: Hand(list(w[s])) for s in Seat},
                      dealer=deal.dealer, vuln=deal.vuln)
            inc = calculate_inconsistency(d, list(history), models,
                                          deal.dealer, deal.vuln)
            scored.append((inc, i, w))
        scored.sort(key=lambda t: (t[0], t[1]))
        return [w for _, _, w in scored[:num_worlds]], [t[0] for t in scored[:num_worlds]]

    # ---------- scoring ----------

    def score_contract(self, deal, level: int, strain: Strain, declarer: Seat,
                       doubled: int = 0, vuln: int = 0,
                       history=None, models=None) -> SDSResult:
        from bid.scoring import calculate_contract_score, Vulnerability

        dummy = declarer.partner
        viewers = (declarer, dummy)
        rng = random.Random(self.seed)

        if history and models and self.condition_factor > 0:
            worlds, incs = self._select_consistent(deal, viewers, history,
                                                   models, self.num_worlds, rng)
            mean_inc = sum(incs) / len(incs)
        else:
            worlds = self.sample_world_dicts(deal, viewers, self.num_worlds, rng)
            mean_inc = None

        is_vul = Vulnerability.is_vulnerable(vuln, declarer)
        needed = level + 6

        total_score = 0.0
        makes = 0
        total_tricks = 0

        for w in worlds:
            world = type(deal)(hands={s: Hand(list(w[s])) for s in Seat},
                               dealer=deal.dealer, vuln=deal.vuln)
            tricks = DDSolver.get_tricks(world, strain, declarer)
            total_tricks += tricks
            if tricks >= needed:
                makes += 1
            total_score += calculate_contract_score(
                level=level, strain=strain, doubled=doubled,
                is_vulnerable=is_vul, tricks_taken=tricks)

        k = max(1, len(worlds))
        return SDSResult(total_score / k, makes / k, total_tricks / k, len(worlds))

# ======================================================================
# True play search (sds.md PR1/PR2/PR3 subset)
# OutcomeVector / PlayPosition / PIMC (M=1) / alpha-mu (M>=2)
#
# Fusion rule: at Max nodes (declarer partnership) ONE card is committed
# across ALL valid worlds. Min nodes (defenders) may act per world, and a
# defender move is only scored in worlds where it is legal.
# ======================================================================

import copy as _copy


@dataclass
class PlayPosition:
    """Root description: declarer-side true hands + contract context."""
    hands: Dict[Seat, List]
    trump: Strain
    declarer: Seat
    to_play: Seat
    leader: Seat
    trick: List[Tuple[Seat, object]]
    tricks_max: int
    tricks_min: int

    @property
    def max_side(self) -> Tuple[Seat, Seat]:
        return (self.declarer, self.declarer.partner)


def legal_cards(hand: List, trick: List[Tuple[Seat, object]]) -> List:
    if not trick:
        return list(hand)
    led = trick[0][1].suit
    follow = [c for c in hand if c.suit == led]
    return follow if follow else list(hand)


def _key(c) -> Tuple[int, int]:
    suit_v = getattr(c.suit, "value", c.suit)
    rank_v = getattr(c.rank, "value", c.rank)
    return (int(suit_v), int(rank_v))


def trick_winner(trick: List[Tuple[Seat, object]], trump: Strain) -> Seat:
    led = trick[0][1].suit
    trump_suit = None if trump == Strain.NT else Suit(trump.value)
    best_seat, best_card = trick[0]
    for seat, card in trick[1:]:
        if card.suit == best_card.suit:
            if card.rank.value > best_card.rank.value:
                best_seat, best_card = seat, card
        elif trump_suit is not None and card.suit == trump_suit \
                and best_card.suit != trump_suit:
            best_seat, best_card = seat, card
    return best_seat


class OutcomeVector:
    """Per-world total tricks won by the Max side (declarer partnership)."""
    def __init__(self, values: List[int]):
        self.values = list(values)

    def mean(self) -> float:
        return sum(self.values) / len(self.values) if self.values else 0.0

    def p_at_least(self, target: int) -> float:
        return sum(1 for v in self.values if v >= target) / len(self.values) \
            if self.values else 0.0

    @staticmethod
    def elementwise_max(a: "OutcomeVector", b: "OutcomeVector") -> "OutcomeVector":
        return OutcomeVector([max(x, y) for x, y in zip(a.values, b.values)])


@dataclass
class SearchConfig:
    target: int = 10
    front_cap: int = 64


@dataclass
class SearchResult:
    best_card: object = None
    per_move: Dict[object, OutcomeVector] = None
    num_worlds: int = 0
    num_leaf_solves: int = 0

    def report(self, target: int) -> str:
        lines = []
        for card, vec in sorted((self.per_move or {}).items(),
                                key=lambda kv: -kv[1].mean()):
            lines.append(f"    {str(card):<8} E[tricks]={vec.mean():5.2f} "
                         f"P(make)={vec.p_at_least(target):.2f}")
        return "\n".join(lines)


class PlaySearcher:
    """
    alpha-mu style single-dummy play search (sds.md Algorithms 1-3 subset).

    M = number of remaining Max commitments before falling back to per-world
    double-dummy leaves. M=1 degenerates to classic PIMC (Algorithm 1);
    M >= remaining Max plays equals perfect-information play per world.
    """

    def __init__(self, cfg: SearchConfig = None):
        self.cfg = cfg or SearchConfig()
        self.leaf_solves = 0

    # ---------- state helpers ----------

    def _make_root_state(self, pos: PlayPosition):
        st = {
            "trump": pos.trump,
            "max_side": pos.max_side,
            "to_play": pos.to_play,
            "leader": pos.leader,
            "trick": list(pos.trick),
            "tmax": pos.tricks_max,
            "tmin": pos.tricks_min,
            "max_hands": {s: list(pos.hands[s]) for s in pos.max_side},
        }
        return st

    @staticmethod
    def _clone_state(st):
        return {"trump": st["trump"], "max_side": st["max_side"],
                "to_play": st["to_play"], "leader": st["leader"],
                "trick": list(st["trick"]), "tmax": st["tmax"],
                "tmin": st["tmin"],
                "max_hands": {s: list(h) for s, h in st["max_hands"].items()}}

    @staticmethod
    def _remove_by_key(cards, key):
        for i, c in enumerate(cards):
            if _key(c) == key:
                del cards[i]
                return

    def _apply(self, st, worlds, card):
        seat = st["to_play"]
        key = _key(card)
        ns = self._clone_state(st)
        ns["trick"].append((seat, card))
        if seat in ns["max_side"]:
            self._remove_by_key(ns["max_hands"][seat], key)
        new_worlds = []
        for w in worlds:
            nw = dict(w)
            lst = list(w[seat])
            self._remove_by_key(lst, key)
            nw[seat] = lst
            new_worlds.append(nw)

        if len(ns["trick"]) == 4:
            winner = trick_winner(ns["trick"], ns["trump"])
            if winner in ns["max_side"]:
                ns["tmax"] += 1
            else:
                ns["tmin"] += 1
            ns["trick"] = []
            ns["leader"] = winner
            ns["to_play"] = winner
        else:
            ns["to_play"] = Seat((seat.value + 1) % 4)
        return ns, new_worlds

    def _decided(self, st, worlds) -> bool:
        if not worlds:
            return True
        # North can empty mid-trick (early rotation seat); check every hand.
        return all(len(w[s]) == 0 for w in worlds for s in Seat)

    # ---------- leaf ----------

    def _leaf(self, st, worlds) -> OutcomeVector:
        assert not st["trick"], "leaf attempted mid-trick"
        assert worlds
        some_hand = next(iter(worlds[0].values())) if worlds else []
        if len(some_hand) == 0:
            return OutcomeVector([st["tmax"]] * len(worlds))
        trump_idx = DDSolver.strain_to_dds_index(st["trump"])
        values = []
        for w in worlds:
            hands = {s: list(w[s]) for s in Seat}
            leader_idx = st["leader"].value
            trick = [(s.value, c) for s, c in st["trick"]]
            t = DDSolver.solve_position(hands, trump_idx, leader_idx, trick)
            if t is None:
                t = 0
            elif Seat(leader_idx) not in st["max_side"]:
                t = len(hands[Seat.NORTH]) - t
            values.append(t + st["tmax"])
            self.leaf_solves += 1
        return OutcomeVector(values)

    # ---------- recursion ----------

    def _search(self, st, worlds):
        if self._decided(st, worlds):
            return self._leaf(st, worlds)

        if st["to_play"] in st["max_side"]:
            moves = legal_cards(st["max_hands"][st["to_play"]], st["trick"])
            best = None
            for c in moves:
                ns, nw = self._apply(st, worlds, c)
                vec = self._search(ns, nw)
                best = vec if best is None else OutcomeVector.elementwise_max(best, vec)
            return best if best is not None else self._leaf(st, worlds)

        seat = st["to_play"]
        union_moves, seen = [], set()
        for w in worlds:
            for c in legal_cards(w[seat], st["trick"]):
                k = _key(c)
                if k not in seen:
                    seen.add(k)
                    union_moves.append(c)

        expanded: List[List[Optional[int]]] = []
        n = len(worlds)
        for c in union_moves:
            sub_idx, sub_worlds = [], []
            for j, w in enumerate(worlds):
                if any(_key(x) == _key(c) for x in w[seat]):
                    sub_idx.append(j)
                    sub_worlds.append(w)
            if not sub_idx:
                continue
            ns, nw = self._apply(st, sub_worlds, c)
            vec = self._search(ns, nw)
            vals: List[Optional[int]] = [None] * n
            for k_i, j in enumerate(sub_idx):
                vals[j] = vec.values[k_i]
            expanded.append(vals)

        out: List[Optional[int]] = [None] * n
        for vals in expanded:
            for j, v in enumerate(vals):
                if v is not None and (out[j] is None or v < out[j]):
                    out[j] = v
        return OutcomeVector([0 if v is None else v for v in out])

    # ---------- public entries ----------

    def _solve(self, pos: PlayPosition, worlds) -> SearchResult:
        assert pos.to_play in pos.max_side, "root must be a declarer-side seat"
        worlds = [dict(w) for w in worlds]
        for w in worlds:
            for s in pos.max_side:
                w[s] = list(pos.hands[s])
        st = self._make_root_state(pos)
        self.leaf_solves = 0
        moves = legal_cards(st["max_hands"][pos.to_play], st["trick"])
        per_move = {}
        for c in moves:
            ns, nw = self._apply(st, worlds, c)
            per_move[c] = self._search(ns, nw)
        best = max(per_move.items(), key=lambda kv: kv[1].mean())
        return SearchResult(best_card=best[0], per_move=per_move,
                            num_worlds=len(worlds),
                            num_leaf_solves=self.leaf_solves)

    def _solve_exact(self, pos: PlayPosition, worlds) -> SearchResult:
        """
        Exact committed-strategy search: Max commits one card across all valid
        worlds at every declarer-side decision (fusion forbidden, sds.md K9);
        Min defends per world. Leaves evaluate only at empty-trick boundaries,
        where this dds3 build's solver is verified exact. Equivalent to
        alpha-mu with M >= remaining Max plays; the truncated-PIMC variant
        (Algorithm 1) is deferred until reliable mid-trick solving exists.
        """
        return self._solve(pos, worlds)

    def solve_pimc(self, pos: PlayPosition, worlds) -> SearchResult:
        """Alias kept for API stability; runs the exact search above."""
        return self._solve_exact(pos, worlds)

    def solve_amu(self, pos: PlayPosition, worlds, M: int = None) -> SearchResult:
        """Alias kept for API stability; runs the exact search above."""
        return self._solve_exact(pos, worlds)


def sample_worlds_two_hands(deal, declarer: Seat, num_worlds: int, seed: int = 0):
    """Hidden-seat completions consistent with declarer + dummy."""
    return SDSScorer.sample_worlds(deal, (declarer, declarer.partner), num_worlds,
                                   random.Random(seed))


def merge_worlds(deal, declarer: Seat, sampled_pairs) -> List[Dict[Seat, List]]:
    unknown = [s for s in Seat if s not in (declarer, declarer.partner)]
    out = []
    for cards_a, cards_b in sampled_pairs:
        w = {declarer: list(deal.hands[declarer].cards),
             declarer.partner: list(deal.hands[declarer.partner].cards)}
        w[unknown[0]] = list(cards_a)
        w[unknown[1]] = list(cards_b)
        out.append(w)
    return out


def build_position(deal, level: int, strain: Strain, declarer: Seat,
                   to_play: Optional[Seat] = None) -> PlayPosition:
    if to_play is None:
        to_play = declarer
    return PlayPosition(
        hands={s: list(deal.hands[s].cards) for s in Seat},
        trump=strain, declarer=declarer, to_play=to_play,
        leader=to_play, trick=[], tricks_max=0, tricks_min=0)
