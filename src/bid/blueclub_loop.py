#!/usr/bin/env python3
"""
blueclub_loop.py — improvement flywheel for legacy-format bidding DSLs.

The autoloop/flywheel machinery mutates DecisionNet rules and saves via
`net.save_dsl`, which would DESTROY a legacy (SystemTranslator) file like
system/blue_club.dsl: its rules live in `wrapped_system`, the net itself has
none, and exporting would write an empty rule list back.

This loop brings the same protocol to legacy files at the TEXT level:

  * the DSL is parsed into ordered blocks (comments + heading + constraints)
  * a mutant = one constraint edit inside one block
      HCP: 11-15  ->  10-15 / 12-15 / 11-16     (loosen / tighten / widen)
      LEN D: 3+   ->  2+                        (loosen)
  * mutants compile through SystemTranslator and are wrapped in a
    DecisionNet (attach_system) so evaluate_system bids exactly like the
    legacy system
  * screening mirrors autoloop: paired per-board deltas on the same random
    boards, paired-z significance gate (mean > 0 and z >= 2), escalation to
    the next tier when inconclusive, par-accuracy / IMP-loss guardrails
  * accepted mutants become the new base; the previous version is archived
    to system/history/<stem>_v<n>.dsl

Usage:
  python3 -m bid.blueclub_loop --system system/blue_club.dsl \
      --max-minutes 12 --tiers 24,96 --pool-cap 12
"""

import argparse
import hashlib
import json
import os
import random
import re
import shutil
import sys
import time
from typing import Dict, List, Optional, Tuple

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
if REPO_ROOT not in sys.path:
    sys.path.insert(0, os.path.join(REPO_ROOT, "src"))

from bid.arena import BiddingArena                                    # noqa: E402
from bid.decision_net import DecisionNet                              # noqa: E402
from bid.eval_vs_dds import build_deals, evaluate_system, precompute  # noqa: E402
from bid.translator import SystemTranslator                           # noqa: E402
from bid.autoloop import CONFIRM_Z, classify, paired_z                # noqa: E402

CONSTRAINT_RE = re.compile(r"^(HCP|LEN [CDHS]):\s*(.+)$")
HEADING_RE = re.compile(r"^(OPEN|RESPONSE|SEQUENCE|DEFENSE|PREVIOUS_BIDS)?\s*\S.*:$")
PASS_HEADING = re.compile(r"^OPEN PASS:")

# ---------------------------------------------------------------------------
# DSL block model
# ---------------------------------------------------------------------------

def parse_blocks(text: str) -> List[dict]:
    """Split the DSL into ordered items: ('passthrough', lines) for pure
    comment/section paragraphs and ('rule', block) for rule blocks.
    A block carries its leading comments so round-trips are stable."""
    paragraphs, buf = [], []
    for line in text.splitlines():
        if line.strip():
            buf.append(line)
        elif buf:
            paragraphs.append(buf)
            buf = []
    if buf:
        paragraphs.append(buf)

    blocks: List[dict] = []
    pending_comments: List[str] = []
    for para in paragraphs:
        head_idx = next((i for i, l in enumerate(para)
                         if not l.lstrip().startswith("#") and l.rstrip().endswith(":")),
                        None)
        if head_idx is None:
            blocks.append({"kind": "passthrough", "lines": para})
            continue
        # comment lines above the heading belong to the rule block itself
        blocks.append({"kind": "rule", "heading": para[head_idx].rstrip(),
                       "comment": para[:head_idx], "body": para[head_idx + 1:]})
    return blocks


def blocks_to_text(blocks: List[dict]) -> str:
    out: List[str] = []
    for b in blocks:
        if b["kind"] == "passthrough":
            out.extend(b["lines"])
        else:
            out.extend(b.get("comment", []))
            out.append(b["heading"])
            out.extend(b["body"])
        out.append("")
    return "\n".join(out).rstrip() + "\n"


def compile_system(blocks: List[dict]):
    system = SystemTranslator().parse(blocks_to_text(blocks))
    if not system.rules:
        raise SystemExit("block text compiled to zero rules - refusing to continue")
    return system


def evaluate(blocks: List[dict], name: str, deals, dds, arena, seed: int) -> dict:
    system = compile_system(blocks)
    net = DecisionNet(name)
    net.attach_system(system)
    return evaluate_system(arena, name, net, deals, dds, seed=seed)


# ---------------------------------------------------------------------------
# Mutations: one constraint edit per mutant
# ---------------------------------------------------------------------------

def _bounds(val: str) -> Optional[Tuple[int, int, bool]]:
    """'11-15' -> (11, 15, False); '17+' -> (17, None, True); else None."""
    val = val.strip()
    if val.endswith("+"):
        try:
            return int(val[:-1]), None, True
        except ValueError:
            return None
    m = re.match(r"^(\d+)-(\d+)$", val)
    if m:
        return int(m.group(1)), int(m.group(2)), False
    return None


def _variants(key: str, val: str, hi: int) -> List[str]:
    b = _bounds(val)
    if b is None:
        return []
    lo, up, plus = b
    out = []
    if plus:
        if lo > 0:
            out.append(f"{lo - 1}+")
    else:
        if lo > 0:
            out.append(f"{lo - 1}-{up}")     # loosen lower bound
        if lo + 1 <= up:
            out.append(f"{lo + 1}-{up}")     # tighten lower bound
        if up + 1 <= hi:
            out.append(f"{lo}-{up + 1}")     # widen upper bound
        if up - 1 >= lo:
            out.append(f"{lo}-{up - 1}")     # tighten upper bound
    return [f"{key}: {v}" for v in out]


def mutate_block(block: dict) -> List[Tuple[int, str, str]]:
    """All single-line constraint edits for one rule block.
    Returns [(body_index, new_line, description), ...]."""
    if PASS_HEADING.match(block["heading"]):
        return []  # keep the explicit pass catch-all honest
    variants: List[Tuple[int, str, str]] = []
    for i, line in enumerate(block["body"]):
        m = CONSTRAINT_RE.match(line.strip())
        if not m:
            continue
        key, val = m.group(1), m.group(2)
        hi = 37 if key == "HCP" else 13
        indent = line[:len(line) - len(line.lstrip())]
        for new in _variants(key, val, hi):
            variants.append((i, indent + new,
                             f"{block['heading']} :: {line.strip()} -> {new}"))
    return variants


def build_mutants(blocks: List[dict], pool_cap: int, rng: random.Random,
                  failed: Dict[str, dict]) -> List[dict]:
    """One candidate per (block, single-constraint-edit).  Rules that fire
    often (openings, then shorter sequences) are ordered first; shuffled
    within groups and capped."""
    cands = []
    for bi, b in enumerate(blocks):
        if b["kind"] != "rule":
            continue
        is_open = b["heading"].startswith("OPEN")
        n_steps = b["heading"].count("-")
        for src, new_line, desc in mutate_block(b):
            new_body = list(b["body"])
            new_body[src] = new_line
            sig = hashlib.sha1(f"{b['heading']}|{new_line}".encode()).hexdigest()[:10]
            if sig in failed:
                continue
            nb = {"kind": "rule", "heading": b["heading"],
                  "comment": b["comment"], "body": new_body}
            cands.append({"sig": sig, "desc": desc, "blocks": _splice(blocks, bi, nb),
                          "order": (0 if is_open else 1, n_steps)})
    opened = [c for c in cands if c["order"][0] == 0]
    rest = [c for c in cands if c["order"][0] == 1]
    rng.shuffle(opened)
    opened.sort(key=lambda c: c["order"][1])          # openings: 1-level first
    rest.sort(key=lambda c: (c["order"][1], rng.random()))
    return (opened + rest)[:pool_cap]


def _splice(blocks: List[dict], idx: int, new_block: dict) -> List[dict]:
    out = list(blocks)
    out[idx] = new_block
    return out


# ---------------------------------------------------------------------------
# The loop
# ---------------------------------------------------------------------------

def load_state(path: str) -> dict:
    if os.path.exists(path):
        with open(path) as f:
            return json.load(f)
    return {"version": 1, "applied": [], "failed": {}}


def main(argv: Optional[List[str]] = None) -> int:
    ap = argparse.ArgumentParser(description="Legacy-DSL improvement flywheel")
    ap.add_argument("--system", default=os.path.join(REPO_ROOT, "system", "blue_club.dsl"))
    ap.add_argument("--state", default=os.path.join(REPO_ROOT, "debug", "blueclub_loop_state.json"))
    ap.add_argument("--tiers", default="24,96")
    ap.add_argument("--pool-cap", type=int, default=12)
    ap.add_argument("--max-cycles", type=int, default=3)
    ap.add_argument("--max-minutes", type=float, default=12.0)
    ap.add_argument("--seed", type=int, default=4242)
    ap.add_argument("--progress-secs", type=float, default=120.0)
    args = ap.parse_args(argv)

    tiers = [int(t) for t in args.tiers.split(",")]
    deadline = time.time() + args.max_minutes * 60 if args.max_minutes > 0 else None
    os.makedirs(os.path.join(REPO_ROOT, "system", "history"), exist_ok=True)
    os.makedirs(os.path.dirname(args.state), exist_ok=True)

    with open(args.system) as f:
        base_text = f.read()
    # safety snapshot of the pre-loop system (idempotent)
    snap = os.path.join(REPO_ROOT, "system", "history",
                        f"{os.path.splitext(os.path.basename(args.system))[0]}_base_preloop.dsl")
    if not os.path.exists(snap):
        shutil.copy(args.system, snap)

    state = load_state(args.state)
    rng = random.Random(args.seed)
    arena = BiddingArena()
    tier_cache: Dict[int, tuple] = {}

    def tier_data(n):
        if n not in tier_cache:
            deals = build_deals(n, seed=args.seed)
            tier_cache[n] = (deals, precompute(deals))
        return tier_cache[n]

    blocks = parse_blocks(base_text)
    print(f"BLUECLUB LOOP system={args.system} tiers={tiers} "
          f"pool_cap={args.pool_cap} v{state['version']} "
          f"max_minutes={args.max_minutes or 'inf'}")

    for cycle in range(1, args.max_cycles + 1):
        if deadline and time.time() >= deadline:
            print("Time budget reached.")
            break
        print(f"\n--- cycle {cycle} (base v{state['version']}) ---")
        base_res = {}
        mutants = build_mutants(blocks, args.pool_cap, rng, state["failed"])
        if not mutants:
            print("  no unexplored mutants left")
            break

        applied_any = False
        for i, cand in enumerate(mutants):
            if deadline and time.time() >= deadline:
                print("Time budget reached mid-cycle.")
                break
            verdict, last, acc_ok, imp_ok = "reject", None, True, True
            for n in tiers:
                deals, dds = tier_data(n)
                if n not in base_res:
                    t0 = time.time()
                    base_res[n] = evaluate(blocks, "base", deals, dds, arena, args.seed)
                    print(f"  [tier {n}] base score {base_res[n]['avg_score']:+.2f} "
                          f"par {base_res[n]['par_accuracy']:.1f}% "
                          f"imp {base_res[n]['avg_imp_loss']:.2f} ({time.time() - t0:.0f}s)")
                res = evaluate(cand["blocks"], "cand", deals, dds, arena, args.seed)
                deltas = [b - a for b, a in zip(res["scores"], base_res[n]["scores"])]
                dm = sum(deltas) / len(deltas) if deltas else 0.0
                z = paired_z(deltas)
                if not any(d != 0.0 for d in deltas):
                    # the edited constraint never changed a contract on this
                    # tier - conclusively a no-op here, no escalation value
                    verdict = "no-effect"
                    last = (n, dm, z)
                    print(f"  [{i + 1}/{len(mutants)}] {cand['desc']:<64} "
                          f"tier {n:>3} no-effect")
                    break
                verdict = classify(dm, z)
                acc_ok = res["par_accuracy"] >= base_res[n]["par_accuracy"] - 5
                imp_ok = res["avg_imp_loss"] <= base_res[n]["avg_imp_loss"] + 0.15
                last = (n, dm, z)
                print(f"  [{i + 1}/{len(mutants)}] {cand['desc']:<64} "
                      f"tier {n:>3} d={dm:+7.2f} z={z:+5.2f} -> {verdict}"
                      + ("" if acc_ok and imp_ok else "  [guardrail fail]"))
                if verdict == "accept" and acc_ok and imp_ok:
                    break
                if verdict == "reject" or not acc_ok or not imp_ok:
                    break
                # escalate to next tier

            if verdict == "accept" and acc_ok and imp_ok:
                n, dm, z = last
                v = state["version"]
                archive = os.path.join(REPO_ROOT, "system", "history",
                                       f"{os.path.splitext(os.path.basename(args.system))[0]}_v{v}.dsl")
                shutil.copy(args.system, archive)
                with open(args.system, "w") as f:
                    f.write(blocks_to_text(cand["blocks"]))
                blocks = cand["blocks"]
                base_res = {}  # new baseline on every tier
                state["version"] = v + 1
                state["applied"].append({"sig": cand["sig"], "desc": cand["desc"],
                                         "tier": n, "delta": round(dm, 2),
                                         "z": round(z, 2), "version": v + 1})
                with open(args.state, "w") as f:
                    json.dump(state, f, indent=1)
                print(f"  APPLIED {cand['sig']} d={dm:+.2f}@t{n} z={z:.2f} -> v{v + 1} "
                      f"(archived v{v})")
                applied_any = True
            else:
                # cache every non-acceptance (reject / no-effect / inconclusive)
                # so bounded runs never re-explore the same edit
                state["failed"][cand["sig"]] = {"desc": cand["desc"],
                                                "cycle": cycle, "verdict": verdict}
        with open(args.state, "w") as f:
            json.dump(state, f, indent=1)
        if not applied_any:
            print("  cycle produced no accepted patch")
        # keep going: the next cycle mutates the (possibly new) base

    print(f"\nBLUECLUB LOOP done: v{state['version']}, "
          f"{len(state['applied'])} lifetime patches, "
          f"{len(state['failed'])} failed signatures")
    return 0


if __name__ == "__main__":
    sys.exit(main())
