#!/usr/bin/env python3
"""
convention_search.py — automated convention invention via hill-climbing (#5).

Until now protocols only came from hand-written factories (Stayman, Blackwood,
...). This script SEARCHES protocol space automatically:

  1. Seeds: every built-in ConventionProtocol factory in protocol.py.
  2. Mutations over protocol steps:
       - retarget the encoded feature (heart_len -> spade_len, ace_count -> ...)
       - shift range boundaries +/-1 (tighten/loosen the encoding bands)
       - swap two mapped responses (alternative encodings)
       - priority bump/truncate (change conflict resolution)
       - drop a step (prune the convention)
  3. Each candidate compiles to DecisionNetRules and is added (dedup by
     rule_id) to a clone of the current improved_system.dsl.
  4. Paired evaluation vs the unmodified system on a fixed train tier
     (greedy hill-climb), survivors confirmed on a disjoint validation seed.
  5. Accepted conventions are reported with their rule diffs and saved to
     data/conventions/search_report.json. Nothing is written into
     improved_system.dsl automatically -- promote manually or via flywheel.

Usage:
  PYTHONPATH=.. python3 convention_search.py [--boards 24] [--rounds 3]
      [--pool-cap 8] [--seed 42]
"""

import argparse
import copy
import json
import os
import time

from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler
from bid.models import Strain, Call, CallType

from eval_vs_dds import build_deals, load_decision_net_dsl, evaluate_system, SYSTEM_DIR
from improve_improved_system import precompute
from autoloop import paired_z, classify
from protocol import ConventionProtocol, ProtocolStep, ProtocolOpType

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")

RETARGET_FEATURES = ["heart_len", "spade_len", "diamond_len", "club_len",
                     "hcp", "ace_count", "king_count", "controls",
                     "longest_suit_len", "is_balanced"]

TRAIN_SEED = 42
VAL_SEED = 7


def _range_val(v, shift):
    """Shift a range-encoded mapping value (tuple) by `shift` on both ends."""
    if isinstance(v, tuple) and len(v) == 2:
        lo, hi = v
        return (max(0, lo + shift), min(13 if "len" not in str(v) else 13,
                                        hi + shift))
    return v


def mutate_protocol(proto, rng):
    """Yield (mutation_name, mutated_protocol) variants of one seed."""
    for i, step in enumerate(proto.steps):
        # 1. retarget feature
        for feat in RETARGET_FEATURES:
            if feat != step.target_feature:
                p = copy.deepcopy(proto)
                p.steps[i].target_feature = feat
                p.name = f"{proto.name}_ret{i}_{feat}"
                yield (f"retarget[{i}]{step.target_feature}->{feat}", p)
        # 2. range shifts
        for shift in (-1, 1):
            p = copy.deepcopy(proto)
            p.steps[i].call_mapping = {
                _range_val(k, shift): v
                for k, v in p.steps[i].call_mapping.items()}
            p.name = f"{proto.name}_shift{i}{shift:+d}"
            yield (f"range-shift[{i}]{shift:+d}", p)
        # 3. swap two mapped responses
        items = list(p.steps[i].call_mapping.items()) if p.steps[i] else []
        if len(proto.steps[i].call_mapping) >= 2:
            keys = list(proto.steps[i].call_mapping.keys())
            p = copy.deepcopy(proto)
            m = p.steps[i].call_mapping
            m[keys[0]], m[keys[1]] = m[keys[1]], m[keys[0]]
            p.name = f"{proto.name}_swap{i}"
            yield (f"swap-responses[{i}]", p)
        # 4. drop step
        if len(proto.steps) > 1:
            p = copy.deepcopy(proto)
            del p.steps[i]
            p.name = f"{proto.name}_drop{i}"
            yield (f"drop-step[{i}]", p)


def compile_into(net, proto, base_priority=32):
    """Add the protocol's rules to a DecisionNet clone (dedup by rule_id)."""
    existing = {r.rule_id for r in net.rules}
    added = []
    for rule in proto.compile_to_rules(base_priority=base_priority):
        if rule.rule_id not in existing:
            net.add_rule(rule)
            existing.add(rule.rule_id)
            added.append(rule.rule_id)
    return added

def main():
    ap = argparse.ArgumentParser(description="Automated convention invention")
    ap.add_argument("--boards", type=int, default=24)
    ap.add_argument("--rounds", type=int, default=3)
    ap.add_argument("--pool-cap", type=int, default=8)
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--dsl", default=TARGET)
    ap.add_argument("--report", default="data/conventions/search_report.json")
    args = ap.parse_args()

    base_net = load_decision_net_dsl(args.dsl)
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2,
                                              max_iterations=6,
                                              timeout_sec=0.06),
                        max_lookahead_depth=1)
    arena = BiddingArena(engine=engine)

    train_deals, train_dd = (lambda d: (d, precompute(d)))(
        build_deals(args.boards, seed=TRAIN_SEED))
    val_deals, val_dd = (lambda d: (d, precompute(d)))(
        build_deals(args.boards, seed=VAL_SEED))

    def evl(net, deals, dd):
        return evaluate_system(arena, "cand", net, deals, dd,
                               seed=EVAL_SEED_C)

    EVAL_SEED_C = 777
    base_tr = evl(base_net, train_deals, train_dd)
    base_va = evl(base_net, val_deals, val_dd)
    base_train, base_val = base_tr["avg_score"], base_va["avg_score"]
    print(f"base system: train {base_train:+.1f} | val {base_val:+.1f}")

    seeds = []
    for name in ("create_stayman", "create_jacoby_transfer",
                 "create_texas_transfer", "create_blackwood",
                 "create_cappelletti", "create_michaels_cuebid"):
        factory = getattr(ConventionProtocol, name, None)
        if factory is not None:
            try:
                seeds.append(factory())
            except Exception:
                pass
    print(f"seed protocols: {[p.name for p in seeds]}")

    import random as _r
    rng = _r.Random(args.seed)
    best = {"score": base_train, "protocols": [], "names": []}
    history = []
    t0 = time.time()

    for rnd in range(1, args.rounds + 1):
        # ---- generate mutant pool from current best protocol set ----------
        pool = []
        seen_names = set(best["names"])
        for proto in seeds:
            for mut_name, mut in mutate_protocol(proto, rng):
                if mut.name in seen_names:
                    continue
                seen_names.add(mut.name)
                pool.append((mut_name, mut))
        rng.shuffle(pool)
        pool = pool[:args.pool_cap]

        # ---- screen each mutant on the train tier -------------------------
        screened = []
        for mut_name, mut in pool:
            cand_net = base_net.clone()
            for prev in best["protocols"]:
                compile_into(cand_net, prev)
            added = compile_into(cand_net, mut)
            if not added:
                continue  # everything already present in the DSL
            res = evl(cand_net, train_deals, train_dd)
            delta = res["avg_score"] - base_train
            screened.append((delta, mut_name, mut, cand_net, added))
            print(f"  r{rnd} {mut_name:<40} delta {delta:+.2f} "
                  f"({len(added)} rules)", flush=True)

        if not screened:
            print(f"  r{rnd}: no applicable mutants")
            continue
        screened.sort(key=lambda x: -x[0])
        delta, mut_name, mut, cand_net, added = screened[0]
        if delta <= 0:
            print(f"  r{rnd}: best mutant {delta:+.2f} <= 0 - converged")
            break

        # ---- validation gate on disjoint seed ------------------------------
        val_res = evl(cand_net, val_deals, val_dd)
        val_delta = val_res["avg_score"] - base_val
        z = paired_z([b - a for b, a in
                      zip(val_res["scores"], base_va["scores"])])
        verdict = classify(val_delta, z)
        print(f"  r{rnd} BEST {mut_name}: train {delta:+.2f} | "
              f"val {val_delta:+.2f} z={z:.2f} -> {verdict}")
        if verdict == "reject":
            print("  rejected on validation - stopping")
            break

        best = {"score": base_train + delta, "protocols": best["protocols"] + [mut],
                "names": best["names"] + [mut_name]}
        history.append({"round": rnd, "mutation": mut_name,
                        "train_delta": round(delta, 2),
                        "val_delta": round(val_delta, 2), "z": round(z, 2),
                        "verdict": verdict, "rules_added": added,
                        "steps": [{"name": s.name, "op": s.op_type,
                                   "feature": s.target_feature,
                                   "mapping": {str(k): str(v) for k, v in
                                               s.call_mapping.items()}}
                                  for s in mut.steps]})

    report = {"ts": time.strftime("%Y-%m-%d %H:%M:%S"),
              "base_train": round(base_train, 2),
              "base_val": round(base_val, 2),
              "final_train": round(best["score"], 2),
              "gain": round(best["score"] - base_train, 2),
              "accepted": history, "elapsed_sec": round(time.time() - t0, 1)}
    os.makedirs(os.path.dirname(args.report), exist_ok=True)
    with open(args.report, "w") as f:
        json.dump(report, f, indent=2)
    print(f"\n==== convention search done ====")
    print(f"  accepted {len(history)} convention(s) | "
          f"total gain {report['gain']:+.2f} "
          f"| {report['elapsed_sec']}s")
    print(f"  report -> {args.report}")
    print("  NOTE: rules are NOT auto-installed into improved_system.dsl;")
    print("  promote manually (or via flywheel patches) after review.")


if __name__ == "__main__":
    main()

