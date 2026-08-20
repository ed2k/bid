#!/usr/bin/env python3
"""
Bridge Calculation Engine for Bid.
Directly ported from BEN (../ben/src/calculate.py).
Provides Matchpoint (MP) scoring, IMP round-robin calculation, EV analysis,
and probability-weighted evaluation against double dummy tables.
"""

from typing import Dict, List, Any, Optional, Callable
from bid.scoring import diff_to_imps

def check_array_lengths(dictionary: Dict[Any, List[Any]]) -> int:
    lengths = [len(value) for value in dictionary.values()]
    return min(lengths) if lengths else 0

def _round_robin_score(data: Dict[Any, List[float]], value_fn: Callable[[float], float], weights: Optional[List[float]] = None) -> Dict[Any, float]:
    """
    Round-robin comparison of each candidate against every other candidate.
    Shared engine behind Matchpoints and IMP scoring across sampled worlds.
    """
    keys = list(data.keys())
    n = len(keys)
    if n == 0:
        return {}
    if n == 1:
        return {keys[0]: 0.0}

    num_samples = len(data[keys[0]])
    for key in keys:
        if len(data[key]) != num_samples:
            raise ValueError(
                f"All score lists must have the same length and be aligned by sample/world; "
                f"'{key}' has {len(data[key])}, expected {num_samples}."
            )

    if weights is None:
        weights = [1.0] * num_samples
    elif len(weights) != num_samples:
        raise ValueError(f"weights length ({len(weights)}) must match samples ({num_samples}).")

    cols = {key: [float(v) for v in data[key]] for key in keys}
    w = [float(x) for x in weights]
    total_weight = sum(w)
    if total_weight <= 0:
        return {key: 0.0 for key in keys}

    norm = total_weight * (n - 1)
    scores: Dict[Any, float] = {}
    for i in range(n):
        di = cols[keys[i]]
        acc = 0.0
        for j in range(n):
            if i == j:
                continue
            dj = cols[keys[j]]
            for k in range(num_samples):
                acc += value_fn(di[k] - dj[k]) * w[k]
        scores[keys[i]] = acc / norm
    return scores

def _mp_value(diff: float) -> float:
    """Matchpoint contribution for paired comparison: +1 win, -1 loss, 0 tie."""
    if diff > 0:
        return 1.0
    if diff < 0:
        return -1.0
    return 0.0

def _imp_value(diff: float) -> float:
    """Signed IMP contribution for paired comparison."""
    imps = float(diff_to_imps(int(diff)))
    return imps if diff >= 0 else -imps

def calculate_mp_score(data: Dict[Any, List[float]], weights: Optional[List[float]] = None) -> Dict[Any, float]:
    """Matchpoint score per candidate on a -1 .. +1 scale."""
    return {key: round(v, 4) for key, v in _round_robin_score(data, _mp_value, weights).items()}

def calculate_imp_score(data: Dict[Any, List[float]], weights: Optional[List[float]] = None) -> Dict[Any, float]:
    """IMP score per candidate on a -24 .. +24 scale (average IMPs vs field)."""
    return {key: round(v, 2) for key, v in _round_robin_score(data, _imp_value, weights).items()}

def calculate_imp_score_probability(data: Dict[Any, List[float]], probabilities_list: List[float]) -> Dict[Any, float]:
    """Probability-weighted IMP scoring against multiple candidate actions."""
    scores = {key: 0.0 for key in data}
    keys = list(data.keys())
    num_plays = len(keys)
    num_samples = check_array_lengths(data)
    probs = [float(p) for p in probabilities_list[:num_samples]]
    data_lists = {k: [float(v) for v in vals[:num_samples]] for k, vals in data.items()}

    if num_plays <= 1:
        return {k: 0.0 for k in keys}

    for i in range(num_plays):
        for j in range(num_plays):
            if i != j:
                di = data_lists[keys[i]]
                dj = data_lists[keys[j]]
                for k in range(num_samples):
                    diff = di[k] - dj[k]
                    imp_score = diff_to_imps(int(diff)) * probs[k] * num_samples
                    if diff >= 0:
                        scores[keys[i]] += imp_score
                    else:
                        scores[keys[i]] -= imp_score

    num_scores = num_samples * (num_plays - 1)
    for key in scores:
        scores[key] = round(scores[key] / num_scores, 2) if num_scores else 0.0
    return scores

def get_action_ev(dd_solved_tricks: Dict[Any, List[int]],
                  n_tricks_taken: int,
                  player_i: int,
                  score_by_tricks_taken: List[float]) -> Dict[Any, float]:
    """Computes Expected Value (EV) score for actions given Double Dummy tricks."""
    action_ev: Dict[Any, float] = {}
    sign = 1 if player_i % 2 == 1 else -1

    for action, future_tricks in dd_solved_tricks.items():
        ev_sum = 0.0
        valid_cnt = 0
        for ft in future_tricks:
            if ft < 0:
                continue
            tot_tricks = n_tricks_taken + ft
            tot_decl_tricks = tot_tricks if player_i % 2 == 1 else 13 - tot_tricks
            ev_sum += sign * score_by_tricks_taken[min(13, max(0, tot_decl_tricks))]
            valid_cnt += 1
        action_ev[action] = round(ev_sum / valid_cnt, 2) if valid_cnt > 0 else 0.0

    return action_ev
