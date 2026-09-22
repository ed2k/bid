#!/usr/bin/env python3
"""Distil remote Brill into a compact DSL system from /bid traces.

    python3 research/brill_distill.py --traces data/brill_traces_train.jsonl
    python3 research/brill_distill.py --group none --max-depth 10
    python3 research/brill_distill.py --no-eval

WHY
---
§6.57 established that remote Brill beats champion_system by +0.98 abs
IMP/board (t 3.74), while the rule-capture conversion (`system/brill.dsl`) is
1.03 abs *worse* than champion — a ~2.0 IMP/board loss. Capturing the tree
deeper would need ~26k positions (§6.57) and would still emit rule-shaped
output the DSL cannot express.

Distillation avoids both problems: `/bid` answers ANY position, so a trace is
just (position -> the call a strong engine makes). Fit ID3 to those pairs and
emit ordinary DSL rules. No unpublished atoms, no tree crawl, and the result
round-trips through the repo's own `export_dsl` / `load_decision_net_dsl`.

HOW
---
1. Featurise each trace with `BridgeFeatures.extract_all` — the same 121-key
   vector `DecisionNet.actions()` uses, so learned rules are directly
   executable.
2. Group by `auction_len` (number of calls already made) by default. ID3
   splits only on numeric/bool features, so it cannot partition on the *call
   identity* features (`opp_last_call`, `my_last_call` are strings).
   `auction_len` is the cheapest proxy that separates "opener" from
   "responder" from "opener's second turn" — which is exactly the distinction
   the rule capture lost.
3. Fit an ID3 tree per group and compile it with `id3_tree_to_rules`, using
   `auction_len == k` as the guard. The guard is what stops a tree trained on
   openings from firing in a competitive auction (see that function's note).
4. Write DSL, then optionally score it against DDS par and champion.

DATA
----
Traces come from `brill_remote_eval.py --traces`. Keep the training seed
different from the evaluation seed or the distilled system is scored on
boards it trained on.
"""
import argparse
import json
import os
import random
import sys
from collections import Counter
from typing import Any, Dict, List, Optional, Tuple

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))

from bid.brill.convert import (deal_pbn as deal_pbn_of, hand_from_pbn,  # noqa: E402
                               parse_call, seat_from_letter)
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition  # noqa: E402
from bid.features import BridgeFeatures                        # noqa: E402
from bid.learner import ID3DecisionTree, id3_tree_to_rules    # noqa: E402
from bid.models import CallType, Seat, Strain                  # noqa: E402
from bid.scoring import (Vulnerability, calculate_contract_score,  # noqa: E402
                         diff_to_imps)

SYSTEM_DIR = os.path.join(REPO, "system")


_ROW_CLASS: Any = None
_ROW_NAMES: Optional[Tuple[str, ...]] = None


def _row_class(names: Tuple[str, ...]) -> Any:
    """A ``__slots__`` row that quacks like the feature dict.

    ID3 touches a row only through ``row.get(k, default)`` and
    ``row.keys()``, so a slots object is a drop-in replacement -- and it is
    **3.2x smaller**: measured at 1.19 kB/row against 3.76 kB for the
    129-key dict, over 200k rows in a fresh process. Per-row memory is what
    decides whether the largest slice fits at all (a 330k single-process
    fit thrashed this machine at 21 MB free), so this buys roughly a 3x
    bigger training set for the same peak RSS.
    """
    def keys(self) -> Tuple[str, ...]:
        return names

    def get(self, k: str, default: Any = None) -> Any:
        return getattr(self, k, default)

    return type("FeatureRow", (), {"__slots__": tuple(names),
                                   "keys": keys, "get": get})


def leaf_of(root: Any, feats: Any) -> Any:
    """Walk one row to the leaf the tree actually puts it in.

    Mirrors `ID3Node.predict` but returns the node, not the call, because
    `--relabel outcome` needs to mutate the leaf's prediction in place.
    """
    node = root
    while node is not None and not node.is_leaf:
        val = feats.get(node.feature_name)
        if val is None:
            return node
        if node.is_continuous:
            go_left = (val is not None and val <= node.threshold)
        else:
            go_left = (val == node.threshold)
        nxt = node.left_child if go_left else node.right_child
        if nxt is None:
            return node
        node = nxt
    return node


def load_outcomes(patterns: List[str]) -> Dict[str, List[float]]:
    """deal -> [outcome of call 0, call 1, ...] from `brill_outcomes.py`."""
    import glob as _glob
    out: Dict[str, List[float]] = {}
    for pat in patterns:
        for path in sorted(_glob.glob(pat)) or ([pat] if os.path.exists(pat)
                                                else []):
            for line in open(path):
                line = line.strip()
                if not line:
                    continue
                r = json.loads(line)
                if r.get("deal"):
                    out[r["deal"]] = r["out"]
    return out


def relabel_outcome_leaves(tree: Any,
                           gx: List[Any],
                           rows: List[Dict[str, Any]],
                           outcomes: Dict[str, List[float]],
                           min_support: int,
                           margin: float) -> Tuple[int, int]:
    """Replace each leaf's call with the best-scoring call *observed there*.

    The tree is still fitted to imitate Brill, so the leaves are the ones
    the imitation objective chose. This only changes what each leaf emits,
    and it chooses by **on-policy outcome**: within a leaf the hand is
    (by construction) homogeneous, so the mean score achieved after each
    call is a usable estimate of what that call is worth from there.

    Only calls Brill actually made in the leaf are candidates — there is no
    data for anything else, and inventing a call the tree has never seen
    its continuation for would be guessing. So this is one step of policy
    improvement over Brill, choosing the best of the actions it explored.

    `min_support` (rows behind a call) and `margin` (score advantage over
    the current call) are the guards against relabelling on noise: a leaf
    with 3 rows where 4S happened to make is not evidence.
    """
    from bid.brill.convert import parse_call
    acc: Dict[int, Tuple[Any, Dict[str, List[float]]]] = {}
    for feats, row in zip(gx, rows):
        outs = outcomes.get(row.get("deal") or "")
        if not outs:
            continue
        i = len([t for t in (row.get("ctx") or "").split("-") if t.strip()])
        if i >= len(outs):
            continue
        node = leaf_of(tree.root, feats)
        if node is None or not node.is_leaf:
            continue
        slot = acc.get(id(node))
        if slot is None:
            slot = acc[id(node)] = (node, {})
        slot[1].setdefault(str(row.get("call")), []).append(outs[i])

    changed = 0
    for node, by_call in acc.values():
        means = {c: sum(v) / len(v) for c, v in by_call.items()
                 if len(v) >= min_support}
        if not means:
            continue
        best = max(means, key=lambda c: means[c])
        cur = str(node.prediction)
        if best == cur:
            continue
        cur_mean = means.get(cur)
        if cur_mean is not None and means[best] < cur_mean + margin:
            continue
        node.prediction = parse_call(best)
        changed += 1
    return changed, len(acc)


def last_bid(ctx: List[str], dealer: Any) -> Optional[Tuple[int, Any, Any, int]]:
    """(level, strain, bidder's seat, doubled) of the auction's last bid.

    Doubles attach to the bid they follow, which is why this walks the
    whole prefix rather than taking the last token: a PASS value is the
    score of the contract that is standing, and `4H X` is not `4H`.
    """
    out: Optional[Tuple[int, Any, Any, int]] = None
    for i, tok in enumerate(ctx):
        try:
            c = parse_call(tok)
        except Exception:                      # noqa: BLE001
            continue
        if c.type == CallType.BID:
            out = (c.level, c.strain, Seat((dealer.value + i) % 4), 0)
        elif c.type == CallType.DOUBLE and out:
            out = (out[0], out[1], out[2], 1)
        elif c.type == CallType.REDOUBLE and out:
            out = (out[0], out[1], out[2], 2)
    return out


def bid_beats(level: int, strain: Any, last: Optional[Tuple[int, Any, Any, int]]
              ) -> bool:
    """Bridge legality for a bid over `last` (None = no bid yet).

    A call that is illegal where it lands is dropped silently by
    `DecisionNet.actions` and falls back to PASS, so a relabelling that
    ignored this would be quietly training passes.
    """
    if last is None:
        return True
    return level > last[0] or (level == last[0] and strain.value > last[1].value)


def side_tricks(tricks: Dict[str, int], strain: Any, seat: Any) -> int:
    """Tricks the partnership can take in `strain`, best of the two seats.

    Which partner declares is a later decision the label cannot see, so
    take the better of them: that is what the side would choose, and the
    alternative (picking the caller's own seat) would penalise hands whose
    partner is the right declarer.
    """
    return max(tricks.get("%s:%s" % (strain.name, seat.name), 0),
               tricks.get("%s:%s" % (strain.name, seat.partner.name), 0))


def signed_imps(points: float) -> float:
    """`diff_to_imps` is magnitude only; a team match score is signed."""
    n = int(round(points))
    mag = diff_to_imps(abs(n))
    return -mag if n < 0 else mag


def best_side_score(tricks: Dict[str, int], seats: Tuple[Any, ...],
                    vul: int) -> float:
    """The best contract score this partnership could reach on the deal.

    This is the reference an IMP target needs. A team match does not pay
    for the contract you reach, it pays for the *difference* between your
    result and the other table's — and the other table holds the same
    cards, so the opponents' best contract is the natural yardstick.
    """
    best = -10 ** 9
    for strain in Strain:
        for level in range(1, 8):
            for decl in seats:
                t = tricks.get("%s:%s" % (strain.name, decl.name), 0)
                s = calculate_contract_score(
                    level, strain, t, Vulnerability.is_vulnerable(vul, decl))
                if s > best:
                    best = s
    return float(max(best, 0.0))


def _call_points(call: str, ctx: List[str], dealer: Any, vul: int,
                 tricks: Dict[str, int]) -> Optional[float]:
    """Points for the caller's side if the auction stopped with `call`.

    This is the counterfactual label §6.83 asked for. `tricks` is one
    deal's double-dummy table, so the value of every candidate call is
    computed on the **same** deal, and nothing in it depends on what Brill
    did next — which is exactly what the on-policy outcome label could not
    do (§6.82: within a leaf it compares which *deals* each call was made
    on, not what the call achieved).

    "Stopped there" is the one approximation: a bid is scored as if it
    became the final contract. It is one step of lookahead, not a solved
    continuation, and it is the same approximation for every candidate, so
    it does not bias the comparison — only the absolute level.

    Returns None where the call is illegal at this position.
    """
    try:
        c = parse_call(call)
    except Exception:                          # noqa: BLE001
        return None
    seat = Seat((dealer.value + len(ctx)) % 4)
    last = last_bid(ctx, dealer)

    if c.type == CallType.BID:
        if not bid_beats(c.level, c.strain, last):
            return None
        t = side_tricks(tricks, c.strain, seat)
        return float(calculate_contract_score(
            c.level, c.strain, t, Vulnerability.is_vulnerable(vul, seat)))

    if c.type == CallType.DOUBLE:
        # Only an opponent's bid can be doubled; own-side is illegal.
        if last is None or last[2] in (seat, seat.partner):
            return None
        lvl, st, decl, _dbl = last
        t = side_tricks(tricks, st, decl)
        return -float(calculate_contract_score(
            lvl, st, t, Vulnerability.is_vulnerable(vul, decl), doubled=1))

    if c.type == CallType.REDOUBLE:
        if last is None or last[2] not in (seat, seat.partner) or last[3] != 1:
            return None
        lvl, st, decl, _dbl = last
        t = side_tricks(tricks, st, decl)
        return float(calculate_contract_score(
            lvl, st, t, Vulnerability.is_vulnerable(vul, decl), doubled=2))

    # PASS: the contract that is standing, or nothing at all.
    if last is None:
        return 0.0
    lvl, st, decl, dbl = last
    t = side_tricks(tricks, st, decl)
    s = float(calculate_contract_score(
        lvl, st, t, Vulnerability.is_vulnerable(vul, decl), doubled=dbl))
    return s if decl in (seat, seat.partner) else -s


def call_value(call: str, ctx: List[str], dealer: Any, vul: int,
               tricks: Dict[str, int],
               ref: Optional[float] = None) -> Optional[float]:
    """The value of `call`, in points, or in IMPs against `ref`.

    `ref` is what the other table is expected to score (typically the
    opponents' best contract). Matches are scored in IMPs and the IMP
    scale is kinked — 30 points is 1 IMP, 500 is 11 — so an argmax over
    mean *points* and an argmax over mean *IMPs* pick different calls once
    the margin varies within a leaf, even though both are monotone in the
    score of any single deal. Averaging happens inside the leaf, so the
    units have to be the ones the match pays in.
    """
    pts = _call_points(call, ctx, dealer, vul, tricks)
    if pts is None:
        return None
    return signed_imps(pts - ref) if ref is not None else pts


# Every contract call, for `--relabel-dd-candidates legal|bids`. 7 levels x
# 5 strains plus PASS; level 7 is only ever legal after an insane auction
# but including it costs one call_value() per row and keeps the list
# obviously complete rather than subtly truncated.
#
# Spelling matters. These are spelled through parse_call on purpose: the
# candidate set has to be comparable with `str(node.prediction)` and with
# the observed calls, both of which are in the canonical short form ("1S",
# not "1SPADES"). A long-form candidate is never == the current call, so it
# would look like a change even when it is the same call — and because
# `means.get(cur)` then misses, the margin guard would be skipped too.
DD_BID_CALLS = ["PASS"] + [str(parse_call("%d%s" % (lvl, st.name)))
                           for lvl in range(1, 8) for st in Strain]
DD_PENALTY_CALLS = ("X", "XX")


def dd_candidates(mode: str, observed: set, ctx: List[str], dealer: Any,
                  vul: int, tricks: Dict[str, int],
                  ref: Optional[float] = None,
                  cache: Optional[Dict[Any, List[str]]] = None) -> List[str]:
    """The calls a leaf is allowed to choose between, for one row.

    `observed` is the historical behaviour -- the calls Brill happened to
    make in this leaf. §6.87 found that this default is not neutral: it is
    the only reason X and XX were ever candidates, and twelve leaves
    relabelled to a double cost +0.331 ± 0.040 IMP/board because in
    `later_uncont` an X is illegal at most positions and
    `DecisionNet.actions` silently plays it as PASS. A candidate set that
    is an accident of the training data cannot be audited, so declare it.

    `legal` and `bids` enumerate instead, keeping only the calls
    `_call_points` accepts at this position (it returns None for an
    insufficient bid, and for a double of your own side's bid).

    `cache` is worth having: whether a call is *legal* depends on the
    auction alone, not on the deal, so it is the same for every row that
    shares a position. Without it `legal` mode pays 37 `call_value` calls
    per row instead of the handful `observed` costs.
    """
    if mode == "observed":
        return sorted(observed)
    key = (tuple(ctx), dealer)
    if cache is not None and key in cache:
        return cache[key]
    pool = list(DD_BID_CALLS)
    if mode == "legal":
        pool.extend(DD_PENALTY_CALLS)
    out = []
    for c in pool:
        if call_value(c, ctx, dealer, vul, tricks, ref) is not None:
            out.append(c)
    if cache is not None:
        cache[key] = out
    return out


def relabel_dd_leaves(tree: Any,
                      gx: List[Any],
                      rows: List[Dict[str, Any]],
                      tables: Dict[str, Dict[str, int]],
                      min_support: int,
                      margin: float,
                      units: str = "points",
                      candidates: str = "observed") -> Tuple[int, int]:
    """Replace each leaf's call with the highest-value call it may choose.

    Same shape as `relabel_outcome_leaves`, including the default
    restriction to calls Brill actually made in the leaf, so the two differ
    in exactly one thing: where the score comes from.

    The value is a deterministic function of the deal, so a leaf's mean for
    a call is an expectation over the deals the leaf covers rather than a
    sample of what happened to work out. That is the whole point — the
    argmax is no longer mining noise (§6.83), which is why the guards can
    stay loose here without reproducing the winner's curse.

    `candidates` is that restriction, and it is a declared argument rather
    than a hardcoded choice because §6.87 showed it is not neutral: it is
    the only reason X and XX were ever reachable, and twelve leaves
    relabelled to a double cost +0.331 ± 0.040 IMP/board. `observed`
    reproduces the historical behaviour; `bids` and `legal` enumerate
    instead. See dd_candidates().
    """
    acc: Dict[int, Tuple[Any, List[Tuple[Dict[str, Any], Dict[str, int]]]]] = {}
    for feats, row in zip(gx, rows):
        tricks = tables.get(row.get("deal") or "")
        if not tricks:
            continue
        node = leaf_of(tree.root, feats)
        if node is None or not node.is_leaf:
            continue
        acc.setdefault(id(node), (node, []))[1].append((row, tricks))

    changed = 0
    cache: Dict[Any, List[str]] = {}
    for node, rs in acc.values():
        observed = {str(r.get("call")) for r, _ in rs}
        vals: Dict[str, List[float]] = {}
        for row, tricks in rs:
            ctx = [t for t in (row.get("ctx") or "").split("-") if t.strip()]
            try:
                dealer = seat_from_letter(str(row.get("dealer", "N")).strip())
            except Exception:                  # noqa: BLE001
                continue
            vul = int(row.get("vul", 0))
            ref = None
            if units == "imp":
                mine = Seat((dealer.value + len(ctx)) % 4)
                theirs = tuple(s for s in Seat if s not in (mine, mine.partner))
                ref = best_side_score(tricks, theirs, vul)
            for c in dd_candidates(candidates, observed, ctx, dealer, vul,
                                   tricks, ref, cache):
                v = call_value(c, ctx, dealer, vul, tricks, ref)
                if v is None:
                    continue
                vals.setdefault(c, []).append(v)
        means = {c: sum(v) / len(v) for c, v in vals.items()
                 if len(v) >= min_support}
        if not means:
            continue
        best = max(means, key=lambda c: means[c])
        cur = str(node.prediction)
        if best == cur:
            continue
        cur_mean = means.get(cur)
        if cur_mean is not None and means[best] < cur_mean + margin:
            continue
        node.prediction = parse_call(best)
        changed += 1
    return changed, len(acc)


def _provenance(args: Any, n_rows: int) -> str:
    """A comment block recording how this file was produced.

    §6.79: nothing in the repo recorded the configuration behind the
    shipped models -- the header said only "Generated via Continuous
    Self-Improvement Pipeline". That matters because a one-component slice
    swap (§6.76's instrument) is only one-component if the refit uses the
    same configuration as the slice it replaces. Recovering `--max-depth
    10` from the artifact took two independent calibrations and most of
    an hour. Emit it instead.
    """
    import datetime
    stamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return "\n".join([
        "# ---- distillation provenance ----",
        "# generated  %s" % stamp,
        "# command    %s" % " ".join(sys.argv),
        "# traces     %s  (%d rows featurised)" % (args.traces, n_rows),
        "# group      %s%s" % (args.group,
                               "   [slice %s]" % args.only_group
                               if args.only_group else ""),
        "# depth      %d    min-samples %d    folds %d"
        % (args.max_depth, args.min_samples, args.folds),
        "# --------------------------------",
        "",
    ]) + "\n"


def _compact_row(feats: Dict[str, Any]) -> Any:
    """Convert one feature dict to a compact row, fixing the key set once."""
    global _ROW_CLASS, _ROW_NAMES
    if _ROW_CLASS is None:
        # Insertion order, NOT sorted: ID3 breaks information-gain ties by
        # taking the first feature it sees, so reordering `keys()` silently
        # changes which of two equally good splits wins. Verified: sorted
        # order moved held-out agreement 71.1% -> 71.5% on the same data.
        _ROW_NAMES = tuple(feats)
        _ROW_CLASS = _row_class(_ROW_NAMES)
    elif set(feats) != set(_ROW_NAMES):
        # One extractor, one key set. If that ever stops being true, fail
        # loudly: silently differing key sets would drop features.
        raise ValueError("feature keys changed: %d -> %d keys"
                         % (len(_ROW_NAMES), len(feats)))
    row = _ROW_CLASS()
    for k, v in feats.items():
        setattr(row, k, v)
    return row


def featurise(rows: List[Dict[str, Any]],
              only_group: Any = None,
              group_mode: str = "auction_len",
              ) -> Tuple[List[Dict[str, Any]], List[Any], List[str],
                         List[Any], List[str]]:
    """(features, target calls, skip reasons, contexts) for each trace.

    `contexts` keeps enough to re-create each position so a fitted net can
    be scored against held-out traces later. It stores the **raw row**, not
    a parsed (Hand, history, ...) tuple: at 330k traces the parsed form
    pins ~4.3m Card objects in memory for the whole run, and only the
    held-out slice is ever actually scored. Parsing is deferred to
    :func:`_context`.

    `only_group` drops every row outside one slice of `group_mode` as it is
    featurised. `fit_net` fits each slice independently, so running the
    slices in separate processes produces a bit-identical model at a
    fraction of the peak memory — which is what makes 330k traces fit on a
    16 GB machine. `deals` is returned alongside, because once rows are
    dropped the caller can no longer recover the deal for row *i* from
    `rows`, and the split must stay deal-level (see main).
    """
    X, y, skipped, ctxs, deals = [], [], [], [], []
    for r in rows:
        try:
            hand = hand_from_pbn(r["hand"])
            history = [parse_call(t) for t in (r.get("ctx") or "").split("-")
                       if t.strip()]
            call = parse_call(r["call"])
            seat = seat_from_letter(r["seat"])
            dealer = seat_from_letter(r["dealer"])
            vuln = int(r.get("vul", 0))
            feats = BridgeFeatures.extract_all(hand, history, seat, dealer,
                                               vuln)
        except Exception as exc:                                # noqa: BLE001
            skipped.append("%s: %s" % (type(exc).__name__, exc))
            continue
        if (only_group is not None
                and group_key(feats, group_mode) != only_group):
            continue
        X.append(_compact_row(feats))
        y.append(call)
        ctxs.append(r)
        deals.append(r.get("deal", ""))
    return X, y, skipped, ctxs, deals


def _literal(tok: str) -> Any:
    """'True' -> True, 'None' -> None, '3' -> 3. For --only-group parsing."""
    import ast
    try:
        return ast.literal_eval(tok.strip())
    except (ValueError, SyntaxError):
        return tok.strip()


def _context(row: Any) -> Tuple:
    """(hand, history, seat, dealer, vuln) from a raw trace row."""
    return (hand_from_pbn(row["hand"]),
            [parse_call(t) for t in (row.get("ctx") or "").split("-")
             if t.strip()],
            seat_from_letter(row["seat"]),
            seat_from_letter(row["dealer"]),
            int(row.get("vul", 0)))


def fidelity(net: DecisionNet, ctxs: List[Any],
             y: List[Any]) -> Tuple[float, int]:
    """How often the distilled net reproduces Brill's call on held-out traces.

    This is the same question `brill_live_check.py` asks of the rule capture
    (71.1%), so it is directly comparable — and unlike the board-level
    evaluation it is not dominated by deal-to-deal variance, which is why it
    is reported even when the board sample is too small to resolve.
    """
    if not ctxs:
        return 0.0, 0
    ok = 0
    for row, want in zip(ctxs, y):
        hand, history, seat, dealer, vuln = _context(row)
        acts = net.actions(hand, history, seat, dealer, vuln)
        pred = acts[0] if acts else None
        if pred is not None and str(pred) == str(want):
            ok += 1
    return 100.0 * ok / len(ctxs), len(ctxs)


def group_key(feats: Dict[str, Any], mode: str) -> Any:
    """Partition traces into positions a single ID3 tree can model.

    ID3 here splits only on numeric/bool features, so it cannot partition on
    call *identity* (`opp_last_call` is a string). These keys are the numeric
    proxies. Finer keys separate more positions but need proportionally more
    traces — `bid` is only usable once the trace set is in the tens of
    thousands.
    """
    if mode == "none":
        return "all"
    if mode == "opening":
        return bool(feats.get("is_opening"))
    if mode == "opening_contested":
        # Same split as `opening`, crossed with whether the opponents have
        # entered the auction. Gives competitive positions their OWN tree
        # instead of making them share one with uncontested auctions.
        #
        # Direction-neutral on purpose: this adds capacity, it does not push
        # any rate up or down. That matters because section 6.68 showed the
        # direct approach -- forcing the model to stop passing -- costs
        # -0.76 to -2.85 IMP/board, and 6.69 measures a -10.21pp (t -12.15)
        # competitiveness deficit that is very tempting to "fix" the same
        # way. If contested decisions are under-modelled because they share
        # a tree with uncontested ones, this fixes it; if they are simply
        # hard, it changes nothing.
        return (bool(feats.get("is_opening")),
                bool(feats.get("opponents_bid")))
    if mode == "opening_contested_vul":
        # `opening_contested` is the only modelling intervention in this
        # repo that has ever produced a replicated, significant IMP gain:
        # +0.27 (t +2.43) on seed 7 and +0.33 (t +2.96) on seed 42, both
        # at 2,200 boards, and in BOTH cases the entire effect sat in
        # UNCONTESTED auctions (+0.46 / +0.43) with contested at ~0.
        #
        # The tree could always split on `opponents_bid` -- it is a bool
        # feature -- so this is not new information. It is specialisation:
        # each slice gets a whole tree instead of sharing one. That the
        # gain landed on the slice that was previously being diluted says
        # the lever is capacity per slice, so try another slice dimension.
        #
        # Vulnerability is the natural next one. It is the textbook input
        # to game and sacrifice decisions, it is binary so it fragments
        # the data gently (8 groups, ~16.6k traces each at 133k), and it
        # is exactly the kind of thing a shared tree spends its budget on
        # last.
        return (bool(feats.get("is_opening")),
                bool(feats.get("opponents_bid")),
                bool(feats.get("is_vulnerable")))
    if mode == "opening_contested_rebid":
        # The remaining lump, and the biggest one. `opening_contested` has
        # only three non-empty groups, because is_opening=True implies
        # opponents_bid=False -- and "later + uncontested" still contains
        # the responder's first call, the opener's rebid, the responder's
        # rebid and everything after, all sharing one tree. That is most
        # of a ~10-call auction collapsed into a single model.
        #
        # "Have I already bid?" is the interaction that separates them: a
        # hand means something completely different on your first turn
        # (describing) than on your second (narrowing or placing the
        # contract). It is an interaction rather than an additive input,
        # which is the property that made `opponents_bid` pay and that
        # `is_vulnerable` lacked.
        return (bool(feats.get("is_opening")),
                bool(feats.get("opponents_bid")),
                str(feats.get("my_first_call", "NONE")) != "NONE")
    if mode == "uncont_rebid":
        # Concentrate the split where the win actually was.
        #
        # `opening_contested_rebid` spread the rebid split over all four
        # groups and returned +0.06 +/- 0.15 -- a null. But the
        # `opening_contested` gain was measured entirely in UNCONTESTED
        # auctions, so a split that also fragments the contested slice may
        # simply be spending its budget in the wrong place. This applies
        # the rebid split to the uncontested slice only, leaving contested
        # as one group.
        #
        # Result is 4 non-empty groups, the same count as the model that
        # won -- so if this pays it is the placement of the split that
        # matters, not the number of groups.
        is_open = bool(feats.get("is_opening"))
        opp = bool(feats.get("opponents_bid"))
        if is_open or opp:
            return (is_open, opp, None)
        return (is_open, opp,
                str(feats.get("my_first_call", "NONE")) != "NONE")
    if mode == "bid":
        # last_bid_strain is a STRING ('NONE'/'C'/'D'/'H'/'S'/'NT'), so key on
        # it directly — RuleCondition handles string equality fine (brill.dsl
        # is full of `partner_last_call == 'NONE'`).
        return (_num(feats.get("auction_len")),
                _num(feats.get("last_bid_level")),
                str(feats.get("last_bid_strain", "NONE")))
    return _num(feats.get("auction_len"))


def guard_for(key: Any, mode: str) -> List[DecisionNetRule]:
    """Conditions that pin a learned tree to the position it was trained on."""
    if mode == "none":
        return []
    if mode == "opening":
        conds = [RuleCondition("is_opening", "==", bool(key))]
    elif mode == "opening_contested":
        conds = [RuleCondition("is_opening", "==", bool(key[0])),
                 RuleCondition("opponents_bid", "==", bool(key[1]))]
    elif mode == "opening_contested_vul":
        conds = [RuleCondition("is_opening", "==", bool(key[0])),
                 RuleCondition("opponents_bid", "==", bool(key[1])),
                 RuleCondition("is_vulnerable", "==", bool(key[2]))]
    elif mode == "opening_contested_rebid":
        conds = [RuleCondition("is_opening", "==", bool(key[0])),
                 RuleCondition("opponents_bid", "==", bool(key[1])),
                 RuleCondition("my_first_call",
                               "!=" if key[2] else "==", "NONE")]
    elif mode == "uncont_rebid":
        # key[2] is None for the groups this mode deliberately leaves
        # unsplit, so no third condition is emitted for them.
        conds = [RuleCondition("is_opening", "==", bool(key[0])),
                 RuleCondition("opponents_bid", "==", bool(key[1]))]
        if key[2] is not None:
            conds.append(RuleCondition("my_first_call",
                                       "!=" if key[2] else "==", "NONE"))
    elif mode == "bid":
        conds = [RuleCondition("auction_len", "==", int(key[0])),
                 RuleCondition("last_bid_level", "==", int(key[1])),
                 RuleCondition("last_bid_strain", "==", str(key[2]))]
    else:
        conds = [RuleCondition("auction_len", "==", int(key))]
    return [DecisionNetRule("guard", None, conds)]


def _num(v: Any, default: int = 0) -> int:
    try:
        return int(v)
    except (TypeError, ValueError):
        return default


def key_label(key: Any, mode: Optional[str] = None) -> str:
    if not isinstance(key, tuple):
        return str(key)
    if len(key) in (2, 3) and isinstance(key[0], bool):
        # opening_contested:        (is_opening, opponents_bid)
        # opening_contested_vul:    (..., is_vulnerable)
        # opening_contested_rebid:  (..., have I already bid)
        # Both 3-tuples are all-bool, so the third element is
        # distinguished by mode -- rule ids are only labels, but a
        # "_vul"/"_nv" suffix on a rebid split would be actively
        # misleading when reading an exported system.
        out = "%s_%s" % ("open" if key[0] else "later",
                         "cont" if key[1] else "uncont")
        if len(key) == 3:
            if key[2] is None:
                pass                      # uncont_rebid: deliberately unsplit
            elif mode == "opening_contested_rebid":
                out += "_rebid" if key[2] else "_first"
            elif mode == "uncont_rebid":
                out += "_rebid" if key[2] else "_first"
            else:
                out += "_vul" if key[2] else "_nv"
        return out
    return "L%d/%d/%s" % (key[0], key[1], key[2])


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--traces", default=os.path.join("data",
                                                     "brill_traces_train.jsonl"))
    ap.add_argument("--out", default=os.path.join(SYSTEM_DIR,
                                                  "brill_distilled.dsl"))
    ap.add_argument("--group", default="auction_len",
                    choices=["auction_len", "bid", "opening",
                             "opening_contested", "opening_contested_vul",
                             "opening_contested_rebid", "uncont_rebid",
                             "none"])
    ap.add_argument("--only-group", default="",
                    help="fit one slice only, as its key tuple, e.g. "
                         "'True,False' for opening_contested. Slices are "
                         "fit independently, so running them in separate "
                         "processes yields an identical model while keeping "
                         "peak memory proportional to the largest slice "
                         "rather than the whole trace set. Merge the result "
                         "with research/merge_dsl.py.")
    ap.add_argument("--max-depth", type=int, default=8)
    ap.add_argument("--min-samples", type=int, default=25,
                    help="below this a group gets a single majority rule")
    ap.add_argument("--holdout", type=float, default=0.2,
                    help="fraction held out when --folds 1")
    ap.add_argument("--folds", type=int, default=1,
                    help="k-fold CV for the fidelity estimate (1 = single "
                         "holdout). Use >1 before comparing configurations: "
                         "a 488-trace holdout carries ~2pp of noise.")
    ap.add_argument("--eval-boards", type=int, default=250)
    ap.add_argument("--eval-seed", type=int, default=101,
                    help="was 42, which is ALSO a harvest seed, so 250 of "
                         "600 eval boards were in the training set and the "
                         "headline number was quietly optimistic. Use a seed "
                         "no harvest has ever used; the run now warns anyway.")
    ap.add_argument("--no-eval", action="store_true")
    ap.add_argument("--stakes-boost", type=float, default=0.0,
                    help="duplicate high-stakes calls (level 2/3/4+, doubles) "
                         "by their IMP-at-stake weight. Trades raw agreement "
                         "-- which the tree maximises by acing PASS -- for "
                         "accuracy on the game and slam decisions that "
                         "actually decide boards. See brill_miss_stakes.py.")
    ap.add_argument("--stakes-scope", default="all",
                    choices=["all", "uncontested"],
                    help="with 'uncontested', amplify only auctions the "
                         "opponents have not entered (opponents_bid false)")
    ap.add_argument("--pass-cap", type=float, default=0.0,
                    help="keep at most this many PASS traces per non-PASS "
                         "trace (0 = off). Trades fidelity for willingness "
                         "to bid; see cap_passes().")
    ap.add_argument("--relabel", default="", nargs="*",
                    help="outcome files/globs from research/brill_outcomes.py. "
                         "With any, each leaf is relabelled with the "
                         "best-scoring call actually observed in it, instead "
                         "of the majority call. See relabel_outcome_leaves().")
    ap.add_argument("--relabel-min", type=int, default=20,
                    help="rows a call needs behind it in a leaf before it can "
                         "be chosen")
    ap.add_argument("--relabel-margin", type=float, default=0.0,
                    help="score advantage a challenger needs over the "
                         "majority call before the leaf is flipped")
    ap.add_argument("--relabel-dd", default="", nargs="*",
                    help="DD tables from research/brill_dd_value.py. With "
                         "any, each leaf is relabelled with the "
                         "highest-VALUED call observed in it, where value "
                         "is the double-dummy score if the auction stopped "
                         "there -- a counterfactual target, unlike "
                         "--relabel's record of what Brill's line earned.")
    ap.add_argument("--relabel-dd-min", type=int, default=20,
                    help="rows a call needs behind it in a leaf before it "
                         "can be chosen")
    ap.add_argument("--relabel-dd-margin", type=float, default=0.0,
                    help="value advantage a challenger needs over the "
                         "majority call before the leaf is flipped")
    ap.add_argument("--relabel-dd-candidates", default="observed",
                    choices=("observed", "bids", "legal"),
                    help="which calls a leaf may choose between. "
                         "'observed' (the historical default) is the calls "
                         "Brill actually made in that leaf; 'bids' is every "
                         "legal bid plus PASS; 'legal' adds X and XX. "
                         "§6.87: the default is what let twelve leaves be "
                         "relabelled to a double, worth +0.331 +/- 0.040 "
                         "IMP/board against. Declare it rather than inherit "
                         "it from the training data.")
    ap.add_argument("--relabel-dd-units", default="points",
                    choices=("points", "imp"),
                    help="score in duplicate points, or in IMPs against the "
                         "other table (the opponents' best contract). The "
                         "match pays in IMPs and the scale is kinked, so "
                         "the two rank calls differently within a leaf.")
    ap.add_argument("--learning-curve", action="store_true",
                    help="fidelity vs training size; answers 'is another "
                         "harvest worth it?' — a still-rising curve says "
                         "data-limited, a flat one says model-limited")
    args = ap.parse_args()

    if not os.path.exists(args.traces):
        sys.exit("no traces at %s — run:\n  python3 research/"
                 "brill_remote_eval.py --boards N --traces %s"
                 % (args.traces, args.traces))

    only_group = None
    if args.only_group:
        only_group = tuple(_literal(p) for p in args.only_group.split(","))
        print("only group: %r" % (only_group,))

    rows = [json.loads(l) for l in open(args.traces) if l.strip()]
    print("traces: %d" % len(rows))
    X, y, skipped, ctxs, deal_of = featurise(rows, only_group, args.group)
    if skipped:
        print("skipped %d (%s)" % (len(skipped), skipped[0]))
    print("featurised: %d" % len(X))

    # Deterministic holdout for fidelity. Board-level evaluation is far too
    # noisy to grade a fit on small samples (60 boards resolves ~1.0 IMP),
    # so this is the primary signal until the trace set is large.
    #
    # With k-fold the estimate is averaged over folds; a single 20% holdout of
    # 2,442 traces is only ~488 examples, i.e. ~2.1pp of standard error at
    # 70% accuracy — wide enough that the spread between groupings could be
    # noise, so do not tune on it without folds.
    folds = max(1, int(args.folds))
    # Split by DEAL, not by trace. One board contributes ~10 traces, so a
    # trace-level split puts several decisions from the same hand on both
    # sides of the split: the tree is then tested on a different auction
    # state but a hand it has already seen. That is leakage, and it makes
    # the CV figure optimistic in absolute terms. (Measured: 80.3% by trace
    # vs 80.6% by deal at 44k/depth 10 -- close, because the tree
    # generalises over hands reasonably, but the deal split is the honest
    # one and costs nothing.)
    order = list(range(len(X)))          # also used by the CV loop below
    if len(deal_of) == len(X):
        deal_ids = sorted(set(deal_of))
        random.Random(0).shuffle(deal_ids)
        deal_fold = {d: pos % folds for pos, d in enumerate(deal_ids)}
        fold_of = {i: deal_fold[deal_of[i]] for i in order}
        print("split by deal (%d boards across %d folds)" % (len(deal_ids),
                                                             folds))
    else:
        print("WARNING: %d rows skipped, so X is not index-aligned with the "
              "traces; falling back to a TRACE-level split (leaky)"
              % len(skipped))
        random.Random(0).shuffle(order)
        fold_of = {i: pos % folds for pos, i in enumerate(order)}

    relabel = load_outcomes(list(args.relabel)) if args.relabel else None
    if relabel is not None:
        print("outcome relabel: %d boards loaded" % len(relabel))

    dd: Dict[str, Dict[str, int]] = {}
    if args.relabel_dd:
        from brill_dd_value import load_dd_tables
        dd = load_dd_tables(list(args.relabel_dd))
        print("dd relabel: %d board tables loaded" % len(dd))

    def cap_passes(idx: List[int]) -> List[int]:
        """Thin out PASS traces so the tree cannot win by always passing.

        PASS is ~61% of every trace set and by far the easiest label, so a
        tree scored on plain accuracy reaches for it constantly -- leaves
        collapse to PASS and the distilled system lets auctions die that a
        real system would open. That is expensive: a passed-out board scores
        0 against a par that is usually worth 9+ IMP.

        Capping at `r` keeps at most r PASS traces per non-PASS trace. It
        trades fidelity (which falls, and should be reported as falling)
        for a willingness to bid.
        """
        r = args.pass_cap
        if not r or r <= 0:
            return idx
        passes = [i for i in idx if str(y[i]) == "PASS"]
        others = [i for i in idx if str(y[i]) != "PASS"]
        keep = int(r * len(others))
        if keep >= len(passes):
            return idx
        random.Random(1).shuffle(passes)
        return sorted(others + passes[:keep])

    def stakes_weight(call: Any) -> int:
        """Rough IMP at stake in getting this call right.

        Measured, not guessed: `brill_miss_stakes.py` shows held-out
        agreement is 96.5% on PASS and 92.6% on 1-level calls but **22-27%
        on level 3 / 4+** -- game and slam decisions, worth 6-13 IMP. 84% of
        all disagreement mass sits on level-2+ calls, which are only 25% of
        the data. The tree is excellent at the cheap decisions and wrong
        four times out of five on the expensive ones, because plain accuracy
        weights a PASS exactly as much as a slam bid.
        """
        s = str(call).strip()
        if s in ("X", "XX"):
            return 2
        if s and s[0].isdigit():
            return {"1": 1, "2": 2, "3": 3}.get(s[0], 4)
        return 1

    def boost_stakes(idx: List[int]) -> List[int]:
        """Duplicate high-stakes traces so they are not outvoted by PASS.

        Deliberately NOT the same as --pass-cap: that thins PASS everywhere,
        including openings where passing is simply correct, and it made
        things much worse (-1.91). This leaves PASS alone and only amplifies
        the calls whose errors are expensive.

        `--stakes-scope uncontested` restricts the amplification to auctions
        the opponents have not entered. Unrestricted boosting cost -1.31 to
        -2.10 IMP/board and the damage was almost entirely in contested
        auctions (+1.23 -> -2.49), while the diagnosed weakness -- under-
        bidding game -- is an UNcontested problem. So the two effects may be
        separable: bid more when nobody is competing, bid as before when
        they are.
        """
        b = args.stakes_boost
        if not b or b <= 0:
            return idx
        out: List[int] = []
        for i in idx:
            w = stakes_weight(y[i])
            if args.stakes_scope == "uncontested" and X[i].get("opponents_bid"):
                w = 1
            out.extend([i] * max(1, int(round(1 + (w - 1) * b))))
        return out

    def fit_net(train_idx: List[int]) -> DecisionNet:
        net = DecisionNet("brill_distilled")
        train_idx = boost_stakes(cap_passes(train_idx))
        groups: Dict[Any, Tuple[List[Dict[str, Any]], List[Any]]] = {}
        gidx: Dict[Any, List[int]] = {}
        for i in train_idx:
            k = group_key(X[i], args.group)
            gx, gy = groups.setdefault(k, ([], []))
            gx.append(X[i])
            gy.append(y[i])
            gidx.setdefault(k, []).append(i)
        for k in sorted(groups, key=lambda v: (isinstance(v, str), v)):
            gx, gy = groups[k]
            maj_call = Counter(gy).most_common(1)[0][0]
            guard = guard_for(k, args.group)
            if len(gx) < args.min_samples or len(set(map(str, gy))) < 2:
                conds = [RuleCondition(c.key, c.op, c.value)
                         for r in guard for c in r.conditions]
                net.add_rule(DecisionNetRule(
                    "BD_%s_maj" % key_label(k, args.group), maj_call, conds, priority=1,
                    description="majority call (n=%d)" % len(gx)))
                continue
            tree = ID3DecisionTree(max_depth=args.max_depth)
            tree.fit(gx, gy)
            if relabel:
                n_ch, n_lf = relabel_outcome_leaves(
                    tree, gx, [ctxs[i] for i in gidx[k]], relabel,
                    args.relabel_min, args.relabel_margin)
                if n_ch:
                    print("    outcome relabel: %d/%d leaves changed "
                          "(min support %d, margin %.0f)"
                          % (n_ch, n_lf, args.relabel_min,
                             args.relabel_margin))
            if dd:
                n_ch, n_lf = relabel_dd_leaves(
                    tree, gx, [ctxs[i] for i in gidx[k]], dd,
                    args.relabel_dd_min, args.relabel_dd_margin,
                    args.relabel_dd_units, args.relabel_dd_candidates)
                if n_ch:
                    print("    dd relabel: %d/%d leaves changed "
                          "(min support %d, margin %.0f, candidates %s)"
                          % (n_ch, n_lf, args.relabel_dd_min,
                             args.relabel_dd_margin,
                             args.relabel_dd_candidates))
            for r in id3_tree_to_rules(tree, guard, "BD_%s" % key_label(k, args.group),
                                       base_priority=10,
                                       description="distilled from Brill /bid"):
                net.add_rule(r)
        return net

    if args.learning_curve:
        # Fixed 20% test pool, trained on increasing fractions of the rest.
        # A curve still climbing at 100% says buy more traces; a flat one
        # says the model (depth / grouping / features) is binding and a
        # bigger harvest is a waste of wall-clock.
        n_test = max(1, len(order) // 5)
        test = order[:n_test]
        pool = order[n_test:]
        print("\nlearning curve (held-out %d traces):" % len(test))
        print("  %8s %6s %10s %8s" % ("train", "frac", "fidelity", "rules"))
        prev = None
        for frac in (0.1, 0.2, 0.4, 0.6, 0.8, 1.0):
            k = max(1, int(len(pool) * frac))
            n = fit_net(pool[:k])
            acc, _ = fidelity(n, [ctxs[i] for i in test],
                              [y[i] for i in test])
            delta = "" if prev is None else "   (%+.1f)" % (acc - prev)
            prev = acc
            print("  %8d %5.0f%% %9.1f%% %8d%s"
                  % (k, 100.0 * frac, acc, len(n.rules), delta))
        return 0

    if folds > 1:
        accs = []
        for f in range(folds):
            tr = [i for i in order if fold_of[i] != f]
            te = [i for i in order if fold_of[i] == f]
            n = fit_net(tr)
            acc, _ = fidelity(n, [ctxs[i] for i in te], [y[i] for i in te])
            accs.append(acc)
        base = Counter(str(c) for c in y).most_common(1)[0]
        mean = sum(accs) / len(accs)
        sd = (sum((a - mean) ** 2 for a in accs) / (len(accs) - 1)) ** 0.5 \
            if len(accs) > 1 else 0.0
        print("%d-fold CV agreement with Brill: %.1f%% (fold sd %.1f, "
              "folds %s)" % (folds, mean, sd,
                             " ".join("%.0f" % a for a in accs)))
        print("  majority-class baseline %.1f%% (%s)"
              % (100.0 * base[1] / len(y), base[0]))
        print("  NOTE: sd across folds measures fold variance, not the "
              "standard error of the mean; se ~= sd/sqrt(%d)." % folds)

    # Final model: train on everything (or the holdout split if requested).
    n_test = int(len(X) * args.holdout) if folds == 1 else 0
    test_idx = set(range(len(X))[-n_test:]) if n_test else set()
    train_idx = [i for i in range(len(X)) if i not in test_idx]
    net = fit_net(train_idx)
    if n_test:
        print("train %d / held-out %d" % (len(train_idx), n_test))

    # (the per-group fit now lives in fit_net above, so it can be re-run
    #  once per CV fold; this is the single final fit on all training data)

    print("\ndistilled rules: %d" % len(net.rules))
    if n_test:
        test_ctx = [ctxs[i] for i in sorted(test_idx)]
        test_y = [y[i] for i in sorted(test_idx)]
        acc, n = fidelity(net, test_ctx, test_y)
        base = Counter(str(c) for c in test_y).most_common(1)[0]
        print("held-out agreement with Brill: %.1f%% (%d traces); "
              "majority-class baseline %.1f%% (%s)"
              % (acc, n, 100.0 * base[1] / n, base[0]))
    with open(args.out, "w") as fh:
        fh.write(_provenance(args, len(X)))
        fh.write(net.export_dsl())
    print("wrote %s" % args.out)

    if args.no_eval or args.eval_boards <= 0:
        return 0

    # Score the distilled system exactly like any other system.
    from bid.arena import BiddingArena
    from bid.eval_vs_dds import (build_deals, imp_diff, imp_loss,
                                 load_decision_net_dsl, precompute,
                                 resolution_of, seed_board)
    distilled = load_decision_net_dsl(args.out)
    distilled.name = "brill_distilled"
    champ = load_decision_net_dsl(os.path.join(SYSTEM_DIR,
                                               "champion_system.dsl"))
    champ.name = "champion_system"

    deals = build_deals(args.eval_boards, seed=args.eval_seed,
                        include_stratified=False)
    arena = BiddingArena()
    dd = precompute(deals)
    print("\nevaluating on %d boards (seed %d, resolution ~%.2f)"
          % (len(deals), args.eval_seed, resolution_of(len(deals))))

    # A board-level evaluation is only meaningful on boards the model has
    # never seen. This is easy to get wrong: the harvest seed and the eval
    # seed look like unrelated knobs, and --eval-seed used to default to 42,
    # which is also a harvest seed -- so 250 of 600 eval boards were in the
    # training set and the headline number was quietly optimistic. Fail loud.
    train_boards = set()
    for _r in rows:
        _d = _r.get("deal", "")
        if ":" in _d:
            train_boards.add(_d.split(":", 1)[1])
    eval_boards = {deal_pbn_of(dict(d.hands), d.dealer).split(":", 1)[1]
                   for d in deals}
    overlap = train_boards & eval_boards
    if overlap:
        print("  !! CONTAMINATED: %d/%d eval boards are in the training set "
              "-- this number is optimistic, use a different --eval-seed"
              % (len(overlap), len(deals)))

    res = {}
    for name, netx in (("brill_distilled", distilled),
                       ("champion_system", champ)):
        diffs, losses, passed = [], [], 0
        live_losses = []        # boards that actually produced a contract
        for i, deal in enumerate(deals):
            par_score, _pc, _ddt = dd[i]
            seed_board(args.eval_seed, i)
            hist, score = arena.play_board(deal, netx, netx)
            diffs.append(imp_diff(score, par_score))
            losses.append(imp_loss(score, par_score))
            if not any(str(c) != "PASS" for c in hist):
                passed += 1
            else:
                live_losses.append(imp_loss(score, par_score))
        n = len(deals)
        res[name] = (diffs, losses)
        # A passed-out board scores 0 against a par that is often hundreds,
        # so it is worth ~9 IMP on its own. Reporting the pass-out-free
        # average separates "the system bids badly" from "the system never
        # bids" — two failures with very different fixes.
        live = sum(live_losses) / len(live_losses) if live_losses else 0.0
        print("  %-18s signed %+6.2f | abs %5.2f | passed_out %d/%d "
              "| abs excl. pass-outs %5.2f"
              % (name, sum(diffs) / n, sum(losses) / n, passed, n, live))

    d_diffs, d_losses = res["brill_distilled"]
    c_diffs, c_losses = res["champion_system"]

    def paired(base, cand, higher_is_better):
        d = [cand[i] - base[i] for i in range(len(base))] if higher_is_better \
            else [base[i] - cand[i] for i in range(len(base))]
        m = sum(d) / len(d)
        sd = (sum((x - m) ** 2 for x in d) / (len(d) - 1)) ** 0.5
        se = sd / (len(d) ** 0.5)
        return m, se, (m / se if se else 0.0)

    a_m, a_se, a_t = paired(c_losses, d_losses, False)
    s_m, s_se, s_t = paired(c_diffs, d_diffs, True)
    print("\n  distilled vs champion (positive = distilled better):")
    print("    abs dev from par : %+.2f  se %.2f  t %+.2f" % (a_m, a_se, a_t))
    print("    signed vs par    : %+.2f  se %.2f  t %+.2f" % (s_m, s_se, s_t))
    return 0


if __name__ == "__main__":
    sys.exit(main())
