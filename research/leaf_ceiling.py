#!/usr/bin/env python3
"""How much of the loss is the leaf's fault, rather than the target's?

    python3 research/leaf_ceiling.py \
        --dsl system/brill_distilled_control.dsl \
        --prefix BD_later_uncont_ --dd data/brill_dd.0 data/brill_dd.1 \
        data/brill_dd.2

WHY
---
§6.82–6.85 tried four training targets on the same tree and all of them
landed at zero or worse, including one that knows exactly what every
contract on the board is worth. The explanation offered was structural: a
leaf is a conjunction of ~10 features, the double-dummy best call *varies
among the hands that satisfy it*, so the best any per-leaf target can do
is name the call that is best on average — and Brill's majority call is
already close to that average.

That is a story until it is measured. This measures it, using the DD tables
already committed (no new solves) and one featurisation pass:

    brill       mean value of the call Brill actually made
    leaf_best   mean value of the best SINGLE call per leaf, chosen
                out-of-fold — the best any relabelling could achieve
    oracle      mean value of the best call for that actual deal

`oracle − leaf_best` is what the feature representation costs, and no
training target can beat it. `leaf_best − brill` is the most that
relabelling this tree could ever have been worth. If the first is large and
the second small, the lever is the feature space; if both are small, then
even a perfect model over these features cannot help.

OUT-OF-FOLD
-----------
`leaf_best` is chosen on one half of the deals and scored on the other, so
it is not credited with the noise it was fitted to — the same trap that
made §6.82's in-leaf argmax behave like a winner's curse.

CIRCULARITY — READ THIS BEFORE QUOTING ANY NUMBER ABOVE (§6.86)
---------------------------------------------------------------
This metric is the same one-step valuation that `--relabel-dd` maximises.
Scoring a DD-retargeted model with it cannot disagree: measured here, `dd`
is +0.667 over the control while a team match puts it at −0.062 ± 0.075.
`relab`, whose labels come from a *different* target, is graded correctly
(−0.910 here, −1.887 in the match). The rule generalises: an objective
cannot be graded by its own training signal.

So the numbers above are usable only as upper bounds on models the metric
is independent of, and the one genuinely robust output is the structural
one — within-leaf agreement on the best call, which asks whether the leaf
*identifies* a call at all. For anything else, use `--emit` and play it.

SCORING A MODEL YOU ALREADY BUILT  (`--against LABEL=path`)
-----------------------------------------------------------
`--against` values the calls of a *shipped* .dsl in the same per-row
metric, so the bound and the thing it bounds are stated in the same units:

    --against control=system/brill_distilled_control.dsl
    --against dd=system/brill_distilled_dd.dsl

Its main use is the one above: exposing the circularity by showing the
metric agreeing with a DD target and disagreeing with the match.

Two details the comparison needs to be honest:

-- a call that is illegal where it lands is dropped by `DecisionNet.actions`
   and falls back to PASS, so an illegal leaf call is scored as PASS rather
   than skipped — skipping would flatter exactly the models that emit them;

-- Brill's own call is scored per row, but a model plays one call per leaf,
   so `brill` is the stronger baseline and `leaf_best − brill` understates
   what a retarget would have been worth against the control tree.
"""
import argparse
import json
import os
import sys
from collections import Counter, defaultdict
from typing import Any, Dict, List, Optional, Tuple

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO, "src"))
sys.path.insert(0, os.path.join(REPO, "research"))

from bid.brill.convert import seat_from_letter                       # noqa: E402
from bid.eval_vs_dds import load_decision_net_dsl                    # noqa: E402
from bid.models import Seat, Strain                                  # noqa: E402
from brill_dd_value import load_dd_tables                            # noqa: E402
from brill_distill import (best_side_score, call_value, featurise)  # noqa: E402

BIDS = ["%d%s" % (lvl, st) for lvl in range(1, 8) for st in Strain]
CANDS = ["PASS"] + BIDS


def leaf_rules(path: str, prefix: str) -> List[Tuple[str, List[Any], str]]:
    """The slice's leaves, as (rule_id, conditions, call).

    The id has to be the rule, not the call: two different leaves routinely
    emit the same call, and keying on the call collapses them into one
    group -- which is exactly the mistake that makes a 'best call per leaf'
    look like it applies to hands it never sees.
    """
    net = load_decision_net_dsl(path)
    return [(r.rule_id, r.conditions, str(r.call))
            for r in net.rules if r.rule_id.startswith(prefix)]


def leaf_of_row(rules: List[Tuple[str, List[Any], str]],
                feats: Any) -> Optional[str]:
    """The rule_id of the leaf whose conditions this row satisfies.

    Tree paths are mutually exclusive, so exactly one should match; if
    several do the net resolves by priority, and so do we (first wins).
    """
    for rid, conds, _call in rules:
        if all(c.evaluate(feats) for c in conds):
            return rid
    return None


def _candidates(ctx: List[str], dealer: Any, vul: int,
                tricks: Dict[str, int],
                ref: Optional[float]) -> Dict[str, float]:
    """IMP value of every legal call at this position."""
    out: Dict[str, float] = {}
    for c in CANDS:
        v = call_value(c, ctx, dealer, vul, tricks, ref)
        if v is not None:
            out[c] = v
    return out


def _play(rules: List[Tuple[str, List[Any], str]],
          feats: Dict[str, Any]) -> str:
    """The call a shipped model emits here: its leaf's call, else PASS."""
    for rid, conds, call in rules:
        if all(c.evaluate(feats) for c in conds):
            return call
    return "PASS"


def _model_value(call: str, row: Any) -> Optional[float]:
    """Value `call` on `row`, with the net's own illegal-call fallback.

    `DecisionNet.actions` silently drops a call that is illegal where it
    lands and falls back to PASS. Scoring those rows as skipped would
    flatter exactly the models that emit illegal calls, so they are scored
    as the PASS the net would actually play.
    """
    v = call_value(call, row.ctx, row.dealer, row.vul, row.tricks, row.ref)
    if v is None:
        v = call_value("PASS", row.ctx, row.dealer, row.vul, row.tricks,
                       row.ref)
    return v


def emit(args: Any, leaf_best: Dict[Tuple[str, int], str],
         tot: Dict[Tuple[str, int], Dict[str, List[float]]],
         tot_all: Optional[Dict[str, Dict[str, List[float]]]] = None,
         seen_all: Optional[Dict[str, Dict[str, int]]] = None) -> int:
    """Write a playable .dsl carrying the out-of-fold leaf choice.

    The whole point is to break the circularity: scoring a DD-retargeted
    model with the one-step valuation that produced its labels can only
    agree with itself. A team match scores it by what the board pays, and
    knows nothing about how the calls were chosen.

    The call is taken from `leaf_best[(leaf, 1)]`, which was fitted on
    fold-0 rows only, so the model can be scored on fold 1 without ever
    seeing its own training rows — and a match uses fresh deals anyway.
    Leaves without enough fold-0 support keep Brill's call, which is the
    same guard §6.84 applied.
    """
    import re as _re

    # Support is the number of fold-0 rows in which the chosen call is
    # LEGAL, which is what §6.84's `min_support` counted. Counting rows in
    # which Brill happened to make the call instead would silently drop
    # every unobserved call and reduce `--candidates all` to `observed`.
    support: Dict[str, int] = {}
    chosen: Dict[str, str] = {}

    if args.emit_train == "all":
        # Every row is a selection row, which is --relabel-dd's estimator.
        # The emitted model is then only fit to be PLAYED -- there is no
        # held-out half, and the diagnostic cannot score it without
        # grading the target by its own signal.
        for leaf, by_call in (tot_all or {}).items():
            for c, s in by_call.items():
                support[(leaf, c)] = s[1]
            pool = by_call
            if args.candidates == "observed":
                obs = (seen_all or {}).get(leaf) or {}
                pool = {c: v for c, v in by_call.items() if c in obs}
            if pool:
                chosen[leaf] = max(pool,
                                   key=lambda c: pool[c][0] / max(1, pool[c][1]))
    else:
        for (leaf, f), by_call in tot.items():
            if f != 0:
                continue
            for c, s in by_call.items():
                support[(leaf, c)] = s[1]
        for (leaf, f), call in leaf_best.items():
            if f != 1:
                continue
            chosen[leaf] = call

    chosen = {leaf: c for leaf, c in chosen.items()
              if support.get((leaf, c), 0) >= args.emit_min}

    out: List[str] = []
    cur = None
    n_changed = 0
    for line in open(args.dsl).read().split("\n"):
        m = _re.match(r"RULE\s+(\S+):", line)
        if m:
            cur = m.group(1)
        if cur in chosen and line.strip().startswith("CALL:"):
            was = line.split("CALL:", 1)[1].strip()
            if was != chosen[cur]:
                n_changed += 1
            line = "  CALL: %s" % chosen[cur]
        out.append(line)

    # `len(chosen)` counts leaves the retarget had an opinion about, which
    # is not the number of calls that moved: a leaf often re-selects the
    # call it already had. Only the moved ones change how the model plays,
    # and only they are comparable with §6.84's "204 of 767 leaves flip".
    out[:0] = ["# out-of-fold DD retarget of later_uncont",
               "#   source   %s" % args.dsl,
               "#   fitted on fold-0 rows only, guard %d observations"
               % args.emit_min,
               "#   candidates: %s   units: %s" % (args.candidates, args.units),
               "#   %d of %d leaves retargeted, %d calls actually changed"
               % (len(chosen), len(leaf_best) // 2, n_changed),
               ""]
    with open(args.emit, "w") as fh:
        fh.write("\n".join(out))
    return n_changed


def main() -> int:
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--traces", default=os.path.join("data",
                                                     "brill_traces_330k.jsonl"))
    ap.add_argument("--dsl", default=os.path.join("system",
                                                  "brill_distilled_control.dsl"))
    ap.add_argument("--prefix", default="BD_later_uncont_")
    ap.add_argument("--dd", nargs="*",
                    default=[os.path.join("data", "brill_dd.*")])
    ap.add_argument("--group", default="opening_contested")
    ap.add_argument("--only-group", default="False,False")
    ap.add_argument("--units", default="imp", choices=("imp", "points"))
    ap.add_argument("--candidates", default="all", choices=("all", "observed"),
                    help="'observed' restricts the leaf's choice to calls "
                         "Brill actually made in that leaf, which is what "
                         "--relabel-dd does; 'all' allows every legal call, "
                         "which is what tells you whether the restriction "
                         "is what cost you the gain.")
    ap.add_argument("--against", nargs="*", default=[],
                    metavar="LABEL=path",
                    help="also score the calls of these shipped .dsl files, "
                         "in the same metric")
    ap.add_argument("--emit", default="",
                    help="write a .dsl whose leaf calls are the out-of-fold "
                         "choice, so the ceiling can be PLAYED instead of "
                         "scored by the metric that produced it")
    ap.add_argument("--emit-train", default="fold", choices=("fold", "all"),
                    help="'fold' (default) chooses each leaf's call on "
                         "fold-0 rows only; 'all' chooses it on every row, "
                         "which is what --relabel-dd does. Use 'all' to "
                         "isolate the fold: tuning --emit-min until an "
                         "'all' run changes the same number of calls as a "
                         "'fold' run leaves the choice's data as the only "
                         "difference between them.")
    ap.add_argument("--emit-min", type=int, default=12,
                    help="minimum observations of the chosen call among the "
                         "SELECTION rows (default 12). Counted on fold 0 of "
                         "2, so the effective total-row threshold is about "
                         "twice this -- use 6 to match §6.84's --relabel-dd-"
                         "min 12, which counted every row in the leaf. The "
                         "guard and the fold are confounded otherwise: an "
                         "out-of-fold run at 12 is stricter than an in-fold "
                         "one at 12, and changes half as many calls.")
    ap.add_argument("--dump", default="")
    args = ap.parse_args()

    against = []
    for spec in args.against:
        if "=" not in spec:
            ap.error("--against wants LABEL=path, got %r" % spec)
        label, path = spec.split("=", 1)
        against.append((label, path))

    only = tuple(t.strip() == "True" for t in args.only_group.split(","))
    rows = [json.loads(l) for l in open(args.traces) if l.strip()]
    X, y, skipped, ctxs, deals = featurise(rows, only, args.group)
    print("rows in slice: %d (skipped %d)" % (len(X), len(skipped)),
          file=sys.stderr)

    tables = load_dd_tables(list(args.dd))
    rules = leaf_rules(args.dsl, args.prefix)
    print("leaves %d, dd tables %d" % (len(rules), len(tables)), file=sys.stderr)
    # Every candidate was cut from the same tree -- relabelling walks
    # `id3_leaf_paths`, which is structural, so it cannot move a split --
    # so one leaf match per row serves all of them and the rest is a dict
    # lookup on the rule id. The fallback is for a .dsl that does differ,
    # where the honest thing is to walk its conditions.
    against_rules = []
    for lbl, p in against:
        rules2 = leaf_rules(p, args.prefix)
        ids2 = {rid for rid, _c, _call in rules2}
        by_id = None
        if ids2 == {rid for rid, _c, _call in rules}:
            by_id = {rid: call for rid, _c, call in rules2}
        against_rules.append((lbl, rules2, by_id))
        print("  %s: %d leaves, %s" % (lbl, len(rules2), "id-matched"
                                       if by_id else "walked"),
              file=sys.stderr)

    fold = {d: i % 2 for i, d in enumerate(sorted(set(deals)))}
    # (leaf, fold) -> call -> (sum, count), for the out-of-fold argmax
    tot: Dict[Tuple[str, int], Dict[str, List[float]]] = defaultdict(
        lambda: defaultdict(lambda: [0.0, 0]))
    seen: Dict[Tuple[str, int], Dict[str, int]] = defaultdict(
        lambda: defaultdict(int))
    # leaf -> call -> (sum, count) over EVERY row, for `--emit-train all`
    tot_all: Dict[str, Dict[str, List[float]]] = defaultdict(
        lambda: defaultdict(lambda: [0.0, 0]))
    seen_all: Dict[str, Dict[str, int]] = defaultdict(lambda: defaultdict(int))

    class Row:
        """Everything pass 2 needs, without holding 35 candidate values."""
        __slots__ = ("leaf", "f", "mine", "v_b", "v_o", "oracle", "played",
                     "ctx", "dealer", "vul", "tricks", "ref")

    kept: List[Row] = []
    n_noleaf = n_nodd = n_ill = 0

    for feats, call, row, deal in zip(X, y, ctxs, deals):
        # RuleCondition.evaluate wants a real dict; the rows are the
        # compact slots objects the fit uses to save memory.
        cols = {k: feats.get(k) for k in feats.keys()}
        leaf = leaf_of_row(rules, cols)
        if leaf is None:
            n_noleaf += 1
            continue
        tricks = tables.get(deal or "")
        if not tricks:
            n_nodd += 1
            continue
        ctx = [t for t in (row.get("ctx") or "").split("-") if t.strip()]
        dealer = seat_from_letter(str(row.get("dealer", "N")).strip())
        vul = int(row.get("vul", 0))
        mine = Seat((dealer.value + len(ctx)) % 4)
        theirs = tuple(s for s in Seat if s not in (mine, mine.partner))
        ref = best_side_score(tricks, theirs, vul) if args.units == "imp" \
            else None
        vals = _candidates(ctx, dealer, vul, tricks, ref)
        mine_str = str(call)
        if mine_str not in vals or not vals:
            n_ill += 1
            continue
        slot = tot[(leaf, fold[deal])]
        seen[(leaf, fold[deal])][mine_str] += 1
        all_slot = tot_all[leaf]
        seen_all[leaf][mine_str] += 1
        for c, v in vals.items():
            acc = slot[c]
            acc[0] += v
            acc[1] += 1
            acc = all_slot[c]
            acc[0] += v
            acc[1] += 1
        r = Row()
        r.leaf, r.f, r.mine = leaf, fold[deal], mine_str
        r.v_b = vals[mine_str]
        r.oracle = max(vals, key=lambda c: vals[c])
        r.v_o = vals[r.oracle]
        # what each shipped model would actually play here
        r.played = tuple(
            by_id.get(leaf, "PASS") if by_id is not None else _play(r2, cols)
            for _lbl, r2, by_id in against_rules)
        r.ctx, r.dealer, r.vul, r.tricks, r.ref = ctx, dealer, vul, tricks, ref
        kept.append(r)

    print("scored %d rows (%d no leaf, %d no dd table, %d Brill call illegal)"
          % (len(kept), n_noleaf, n_nodd, n_ill), file=sys.stderr)
    if not kept:
        print("\nnothing scored: check --dd (glob) and --prefix",
              file=sys.stderr)
        return 1

    leaf_best: Dict[Tuple[str, int], str] = {}
    for (leaf, f), by_call in tot.items():
        other = tot.get((leaf, 1 - f))
        if not other:
            continue
        pool = other
        if args.candidates == "observed":
            obs = seen.get((leaf, 1 - f)) or {}
            pool = {c: v for c, v in other.items() if c in obs}
        if pool:
            leaf_best[(leaf, f)] = max(
                pool, key=lambda c: pool[c][0] / max(1, pool[c][1]))

    # Do the deals inside one leaf agree on the best call? This is free of
    # the confound in `oracle`: it asks whether the leaf IDENTIFIES the
    # right call, not whether the bidder could know it. A leaf whose deals
    # want four different calls cannot be served by any single call, and
    # no training target can fix that -- only a finer partition can.
    oracle_by_leaf: Dict[str, Dict[str, int]] = defaultdict(
        lambda: defaultdict(int))
    for r in kept:
        oracle_by_leaf[r.leaf][r.oracle] += 1
    agree = sum(max(c.values()) for c in oracle_by_leaf.values())
    tot_rows = sum(sum(c.values()) for c in oracle_by_leaf.values())
    n_calls = sum(len(c) for c in oracle_by_leaf.values())
    print("\n  within-leaf agreement on the best call: %.1f%% of rows "
          "(%d leaves, %.1f distinct best calls per leaf)"
          % (100.0 * agree / tot_rows, len(oracle_by_leaf),
             n_calls / max(1, len(oracle_by_leaf))), file=sys.stderr)

    tot_b = tot_l = tot_o = 0.0
    n = changed = 0
    tot_p = [0.0] * len(against_rules)
    calls_b: Counter = Counter()
    calls_l: Counter = Counter()
    calls_o: Counter = Counter()
    for r in kept:
        lb = leaf_best.get((r.leaf, r.f))
        if lb is None:
            continue
        v_l = _model_value(lb, r)
        played = [_model_value(c, r) for c in r.played]
        if v_l is None or any(v is None for v in played):
            continue
        tot_b += r.v_b
        tot_l += v_l
        tot_o += r.v_o
        for i, v in enumerate(played):
            tot_p[i] += v
        n += 1
        if lb != r.mine:
            changed += 1
        calls_b[r.mine] += 1
        calls_l[lb] += 1
        calls_o[r.oracle] += 1

    if not n:
        print("nothing scored")
        return 1
    unit = "IMPs/board" if args.units == "imp" else "points/board"
    print("\n  value of the call, %s, over %d rows" % (unit, n))
    print("    Brill's own call   %+8.3f" % (tot_b / n))
    print("    best call per leaf %+8.3f   (%+.3f vs Brill)"
          % (tot_l / n, (tot_l - tot_b) / n))
    print("    per-deal oracle    %+8.3f   (%+.3f vs Brill)"
          % (tot_o / n, (tot_o - tot_b) / n))
    for (lbl, _p), v in zip(against, tot_p):
        print("    %-19s %+8.3f   (%+.3f vs Brill)"
              % (lbl, v / n, (v - tot_b) / n))
    print("\n    representation cost, oracle - leaf_best  %+.3f"
          % ((tot_o - tot_l) / n))
    print("    most a retarget could win, leaf_best - brill %+.3f"
          % ((tot_l - tot_b) / n))
    print("    leaf_best differs from Brill's call on %d/%d rows (%.0f%%)"
          % (changed, n, 100.0 * changed / n))

    print("\n  what they choose (share of rows)")
    for name, c in (("Brill", calls_b), ("leaf_best", calls_l),
                    ("oracle", calls_o)):
        top = ", ".join("%s %.0f%%" % (k, 100.0 * v / n)
                        for k, v in c.most_common(5))
        print("    %-10s PASS %.0f%%   top: %s"
              % (name, 100.0 * c.get("PASS", 0) / n, top))

    if args.emit:
        n_ch = emit(args, leaf_best, tot, tot_all, seen_all)
        print("\n  emitted %s: %d of %d leaves changed call"
              % (args.emit, n_ch, len(rules)))

    if args.dump:
        with open(args.dump, "w") as fh:
            json.dump({"rows": n, "units": args.units,
                       "brill": tot_b / n, "leaf_best": tot_l / n,
                       "oracle": tot_o / n,
                       "models": {lbl: v / n
                                  for (lbl, _p), v in zip(against, tot_p)}},
                      fh)
        print("    dumped to %s" % args.dump)
    return 0


if __name__ == "__main__":
    sys.exit(main())
