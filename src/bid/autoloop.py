#!/usr/bin/env python3
"""
autoloop.py — long-running autonomous bidding-system improver.

Policy (per user spec):
  * Start SMALL: candidates are screened on a tiny tier; more boards are only
    spent when the result is statistically inconclusive (escalation driven by
    measured uncertainty, not by default). 1000 boards is the final tier and
    is reached only via escalation.
  * Champion promotion is AUTOMATIC: an accepted version challenges the
    incumbent champion head-to-head (both seat orientations) at the largest
    tier; a significance-gated win replaces champion_system.dsl (old one
    archived).
  * Checkpoints + progress report roughly every --progress-secs seconds, plus
    a rolling JSON snapshot under debug/ (gitignored).

State/cache compatible with flywheel.py's system/flywheel_state.json.
"""

import argparse
import json
import os
import random
import shutil
import statistics
import sys
import time
from typing import Callable, Dict, List, Optional, Tuple

from bid.models import Seat
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler
from bid.diagnostics import ParDiagnosticEngine
from bid.scoring import score_to_imp

from bid.eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR, precompute
from bid.dds import DDSolver
from bid.sampling import Deal

import bid.flywheel as fw

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
CHAMPION = os.path.join(SYSTEM_DIR, "champion_system.dsl")
STATE_PATH = os.path.join(SYSTEM_DIR, "flywheel_state.json")
HISTORY_DIR = os.path.join(SYSTEM_DIR, "history")
PROGRESS_PATH = os.path.join(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..")), "debug", "autoloop_progress.json")

TRAIN_SEED = 42
EVAL_SEED = 777

CONFIRM_Z = 2.0        # |z| >= this at a tier => conclusive
MIN_BOARDS_FINAL = 64  # never promote off fewer paired boards than this


# ---------------- stats helpers (pure; unit-tested) ----------------

def paired_z(deltas: List[float]) -> float:
    """z statistic of paired per-board deltas (mean / stderr)."""
    n = len(deltas)
    if n == 0:
        return 0.0
    mean = sum(deltas) / n
    if n < 2:
        return float("inf") if mean > 0 else (float("-inf") if mean < 0 else 0.0)
    sd = statistics.stdev(deltas)
    if sd == 0:
        return float("inf") if mean > 0 else (float("-inf") if mean < 0 else 0.0)
    return mean / (sd / (n ** 0.5))


def classify(delta_mean: float, z: float) -> str:
    """accept / reject / escalate decision for one tier.
    Acceptance requires a strictly positive mean, not just significance:
    constant-delta zero-effect patches produce |z|=inf and must NOT pass."""
    if delta_mean > 0 and z >= CONFIRM_Z:
        return "accept"
    if delta_mean < 0 and z <= -CONFIRM_Z:
        return "reject"
    return "escalate"


# ---------------- persistence ----------------

def load_state() -> dict:
    if os.path.exists(STATE_PATH):
        with open(STATE_PATH) as f:
            st = json.load(f)
    else:
        st = {}
    st.setdefault("version", 11)
    st.setdefault("failed", [])
    st.setdefault("applied", [])
    st.setdefault("champion_swaps", 0)
    st.setdefault("champion_holds", 0)
    return st


def save_state(st: dict) -> None:
    with open(STATE_PATH, "w") as f:
        json.dump(st, f, indent=2)


def write_progress(payload: dict) -> None:
    try:
        os.makedirs(os.path.dirname(PROGRESS_PATH), exist_ok=True)
        payload["ts"] = time.strftime("%Y-%m-%d %H:%M:%S")
        with open(PROGRESS_PATH, "w") as f:
            json.dump(payload, f, indent=2, default=str)
    except OSError:
        pass


# ---------------- candidate pool (reuses flywheel generators) ----------------

class PoolBuilder:
    def __init__(self, state: dict, rng_seed_base: int = 2024):
        self.state = state
        self.cycle = 0

    def build(self, net, diagnostics) -> List[Tuple[str, str, Callable]]:
        rng = random.Random(2024 + self.cycle * 7 + 1)
        entries: List[Tuple[str, str, Callable]] = []

        for name, fn in fw.CURATED.items():
            sig = f"curated:{name}"
            if sig not in self.state["failed"]:
                entries.append((sig, name, fn))

        fams: Dict[str, List] = {}
        for r in ParDiagnosticEngine.generate_corrective_rules_for_diagnostics(diagnostics):
            fams.setdefault(r.rule_id.split("_")[0], []).append(r)
        for fam, rules in sorted(fams.items()):
            sig = f"diag:{fam}"
            if sig not in self.state["failed"]:
                entries.append((sig, f"DIAG_{fam}",
                                (lambda rl: (lambda n: fw.add_rules(n, rl)))(rules)))

        for r in fw.scan_ungated(net)[:6]:
            for mode in ("not_opening", "partner"):
                g = fw.gate_variant(r, mode)
                sig = f"gate:{r.rule_id}:{mode}"
                if sig not in self.state["failed"]:
                    entries.append((sig, f"GATE_{r.rule_id}_{mode}",
                                    (lambda rr: (lambda n: fw.replace_rule(n, rr)))(g)))

        for r in fw.scan_broad_rules(net)[:6]:
            sig = f"drop:{r.rule_id}"
            if sig not in self.state["failed"]:
                entries.append((sig, f"DROP_{r.rule_id}",
                                (lambda rid: (lambda n: fw.remove_ids({rid})))(r.rule_id)))

        mutatable = [r for r in net.rules
                     if any(c.key in fw.NUMERIC_KEYS for c in r.conditions)]
        rng.shuffle(mutatable)
        for r in mutatable[:6]:
            m = fw.mutate_bounds(r, "tighten")
            if m is not None:
                sig = f"tighten:{r.rule_id}"
                if sig not in self.state["failed"]:
                    entries.append((sig, f"TIGHTEN_{r.rule_id}",
                                    (lambda rr: (lambda n: fw.replace_rule(n, rr)))(m)))
        for r in mutatable[:4]:
            m = fw.mutate_bounds(r, "loosen")
            if m is not None:
                sig = f"loosen:{r.rule_id}", f"LOOSEN_{r.rule_id}"
                if sig not in self.state["failed"]:
                    entries.append((sig, f"LOOSEN_{r.rule_id}",
                                    (lambda rr: (lambda n: fw.replace_rule(n, rr)))(m)))
        self.cycle += 1

        seen, capped = set(), []
        for e in entries:
            if e[0] in seen:
                continue
            seen.add(e[0])
            capped.append(e)
        return capped


# ---------------- main loop ----------------

def main():
    ap = argparse.ArgumentParser(description="Autonomous staged improvement loop")
    ap.add_argument("--tiers", type=str, default="24,96",
                    help="comma board counts, small->large (e.g. '24,96,384,1000')")
    ap.add_argument("--pool-cap", type=int, default=12)
    ap.add_argument("--top-k", type=int, default=3, help="candidates escalated per cycle")
    ap.add_argument("--progress-secs", type=float, default=300.0)
    ap.add_argument("--max-minutes", type=float, default=0.0,
                    help="0 = run until two consecutive empty cycles")
    ap.add_argument("--sds-gate", action="store_true",
                    help="reject accepted patches whose SDS two-hand score regresses")
    ap.add_argument("--idle-limit", type=int, default=3,
                    help="empty-pool cycles before declaring converged")
    ap.add_argument("--policy-prior", type=str, default=None,
                    help="ckpt path; enables policy-guided PIDM pruning "
                         "(requires torch; adds ~0.5s/decision overhead)")
    ap.add_argument("--min-final-boards", type=int, default=MIN_BOARDS_FINAL,
                    help="minimum boards required for final champion challenge")
    args = ap.parse_args()

    tiers = [int(x) for x in args.tiers.split(",") if int(x) > 0]
    assert tiers == sorted(tiers), "tiers must ascend"

    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6,
                                              timeout_sec=0.06),
                        max_lookahead_depth=1)

    # ---- learned-model integration (#4/#5), opt-in / auto when artifacts --
    # soft world-consistency: attach whenever a trained player model exists
    soft_path = "data/player_models/call_model.json"
    if os.path.exists(soft_path):
        try:
            from bid.player_model import CallModel, SoftInconsistencyScorer
            engine.sampler.soft_scorer = SoftInconsistencyScorer(
                CallModel.load(soft_path))
            print("soft player-model attached to RBMBMC sampler "
                  f"({soft_path})")
        except Exception as ex:
            print(f"soft player-model unavailable: {type(ex).__name__}: {ex}")
    # policy-guided candidate pruning: only with --policy-prior (torch);
    # on the ultra-light screening engine the prior overhead can exceed the
    # search savings — intended for the escalated/big-tier runs.
    if args.policy_prior:
        try:
            from bid.mine_disagreements import StudentPolicy
            from bid.trace_factory import hand_str
            _student = StudentPolicy(args.policy_prior)

            def _prior(ps, actions, _s=_student):
                res = _s.bid(ps.dealer.name, ps.vuln, ps.my_seat.name,
                             len(ps.history),
                             [str(c) for c in ps.history],
                             hand_str(ps.my_hand), max_new=24)
                bid = res[0]
                return {str(a): (1.0 if str(a) == bid else 0.35)
                        for a in actions}

            engine.action_prior = _prior
            print(f"policy-guided pruning enabled ({args.policy_prior})")
        except Exception as ex:
            print(f"policy prior unavailable: {type(ex).__name__}: {ex}")

    arena = BiddingArena(engine=engine)

    sds_scorer = None
    if args.sds_gate:
        from bid.sds import SDSScorer
        sds_scorer = SDSScorer(num_worlds=20, seed=2024, condition_factor=4)

    state = load_state()
    pool_builder = PoolBuilder(state)
    tier_cache: Dict[int, Tuple[List[Deal], list]] = {}

    def tier_data(n):
        if n not in tier_cache:
            deals = build_deals(n, seed=TRAIN_SEED)
            tier_cache[n] = (deals, precompute(deals))
        return tier_cache[n]

    deadline = time.time() + args.max_minutes * 60 if args.max_minutes > 0 else None
    start = time.time()
    last_report = 0.0
    cycles_empty = 0
    cycle_no = 0
    progress = {"cycles": 0, "screened": 0, "versions": state["version"],
                "champ_swaps": state["champion_swaps"], "last_event": "start"}

    def maybe_report(force=False, note=""):
        nonlocal last_report
        now = time.time()
        if force or (now - last_report) >= args.progress_secs:
            el = (now - start) / 60
            print(f"[{el:6.1f}m] cyc {cycle_no} | screened {progress['screened']} "
                  f"| v{state['version']} swaps {state['champion_swaps']} "
                  f"holds {state['champion_holds']} | {note or progress['last_event']}")
            progress.update({"elapsed_min": round(el, 1), "cycle": cycle_no,
                             "version": state["version"],
                             "champion_swaps": state["champion_swaps"],
                             "note": note or progress["last_event"]})
            write_progress(progress)
            last_report = now

    print(f"AUTOLOOP tiers={tiers} topk={args.top_k} sds_gate={bool(sds_scorer)} "
          f"max_minutes={args.max_minutes or '∞'}")

    while True:
        now = time.time()
        if deadline and now >= deadline:
            print("Time budget reached.")
            break

        cycle_no += 1
        base_net = load_decision_net_dsl(TARGET)
        d0, dd0 = tier_data(tiers[0])
        base_res = evaluate_system(arena, "base", base_net, d0, dd0,
                                   run_diagnostics=True, seed=EVAL_SEED)
        base_scores = base_res["scores"]
        base_scores_by_tier = {tiers[0]: base_scores}

        pool = pool_builder.build(base_net, base_res["diagnostics"])
        if args.pool_cap:
            pool = pool[:args.pool_cap]
        if not pool:
            cycles_empty += 1
            maybe_report(force=True, note=f"empty pool ({cycles_empty}/{args.idle_limit})")
            if cycles_empty >= args.idle_limit:
                print("Converged: no generable candidates remain un-failed.", flush=True)
                break
            time.sleep(5)
            continue
        cycles_empty = 0
        progress["last_event"] = f"cyc{cycle_no} screening {len(pool)} @t{tiers[0]}"
        print(f"  [{progress['last_event']}]", flush=True)

        # ---- stage 1: screen everything on the smallest tier ----
        screened = []
        for i, (sig, name, fn) in enumerate(pool):
            cand = base_net.clone()
            try:
                fn(cand)
            except Exception as ex:
                print(f"    !! {name} failed to apply: {type(ex).__name__}: {ex}", flush=True)
                state["failed"].append(sig)
                continue
            res = evaluate_system(arena, "cand", cand, d0, dd0, seed=EVAL_SEED)
            deltas = [b - a for b, a in zip(res["scores"], base_scores)]
            dm = sum(deltas) / len(deltas)
            z = paired_z(deltas)
            verdict = classify(dm, z)
            acc_ok = res["par_accuracy"] >= base_res["par_accuracy"] - 5
            imp_ok = res["avg_imp_loss"] <= base_res["avg_imp_loss"] + 0.15
            screened.append(dict(sig=sig, name=name, fn=fn, net=cand, delta=dm,
                                 z=z, verdict=verdict, acc_ok=acc_ok, imp_ok=imp_ok))
            progress["screened"] += 1
            print(f"    cand {i+1}/{len(pool)} {name:<24} Δ{dm:+.2f} z={z:.2f} -> {verdict}", flush=True)
            if verdict == "reject" or not acc_ok or not imp_ok:
                state["failed"].append(sig)
            maybe_report(note=f"cyc{cycle_no} screening {i+1}/{len(pool)}")

        survivors = [c for c in screened
                     if c["verdict"] != "reject" and c["acc_ok"] and c["imp_ok"]]
        survivors.sort(key=lambda c: -c["delta"])

        # ---- stage 2: escalate top-k through bigger tiers ----
        winner = None
        for cand in survivors[:args.top_k]:
            cur_delta, ok = cand["delta"], True
            for t in tiers[1:]:
                deals_t, dd_t = tier_data(t)
                res_t = evaluate_system(arena, "esc", cand["net"], deals_t, dd_t,
                                        seed=EVAL_SEED)
                if t not in base_scores_by_tier:
                    base_t = evaluate_system(arena, "base_esc", base_net, deals_t, dd_t,
                                             seed=EVAL_SEED)
                    base_scores_by_tier[t] = base_t["scores"]
                deltas = [b - a for b, a in zip(res_t["scores"], base_scores_by_tier[t])]
                dm = sum(deltas) / len(deltas)
                z = paired_z(deltas)
                verdict = classify(dm, z)
                cand["delta"], cand["z"] = dm, z
                if verdict == "accept":
                    continue
                if verdict == "reject":
                    ok = False
                break  # inconclusive -> stop escalating this candidate
            if ok and cand["delta"] > 0:
                # final SDS gate (two-hand realism), cheap tier
                if sds_scorer is not None:
                    rb = evaluate_system(arena, "b", base_net, d0, dd0,
                                         seed=EVAL_SEED, sds_scorer=sds_scorer)
                    rf = evaluate_system(arena, "f", cand["net"], d0, dd0,
                                         seed=EVAL_SEED, sds_scorer=sds_scorer)
                    if rf["avg_score_sds"] - rb["avg_score_sds"] < -5:
                        state["failed"].append(cand["sig"])
                        maybe_report(force=True,
                                     note=f"{cand['name']} rejected by SDS gate")
                        ok = False
            if ok:
                winner = cand
                break
            state["failed"].append(cand["sig"])

        if winner is None:
            maybe_report(force=True, note=f"cyc{cycle_no}: no candidate survived ladder")
            save_state(state)
            continue

        # ---- apply winner to improved lineage ----
        v = state["version"]
        os.makedirs(HISTORY_DIR, exist_ok=True)
        shutil.copy(TARGET, os.path.join(HISTORY_DIR, f"improved_system_v{v}.dsl"))
        state["version"] = v + 1
        winner["net"].name = f"ImprovedSystem_v{v + 1}"
        winner["net"].save_dsl(TARGET)
        state["applied"].append({"sig": winner["sig"], "name": winner["name"],
                                 "delta": round(winner["delta"], 1)})
        save_state(state)
        progress["version"] = state["version"]
        maybe_report(force=True,
                     note=f"APPLIED {winner['name']} Δ{winner['delta']:+.1f}@final")

        # ---- automatic champion challenge (both orientations) ----
        champ_net = (load_decision_net_dsl(CHAMPION)
                     if os.path.exists(CHAMPION) else base_net.clone())
        champ_name = "champion"
        imp_diffs = []
        champ_boards = tiers[-1]
        min_final = args.min_final_boards
        if champ_boards < min_final:
            champ_boards = min(max(tiers[-1], min_final), 384)
        boards_c, _ = tier_data(champ_boards)
        for deal in boards_c:
            _, sc_new_ns = arena.play_board(deal, winner["net"], champ_net)
            imp_diffs.append(score_to_imp(int(sc_new_ns)))
            _, sc_champ_ns = arena.play_board(deal, champ_net, winner["net"])
            imp_diffs.append(-score_to_imp(int(sc_champ_ns)))
        total_imps = sum(imp_diffs)
        z = paired_z([float(x) for x in imp_diffs])
        n_boards = len(boards_c)
        promoted = False
        if total_imps > 0 and z >= CONFIRM_Z and n_boards >= min_final:
            cv = state.get("champion_version", 1)
            os.makedirs(HISTORY_DIR, exist_ok=True)
            if os.path.exists(CHAMPION):
                shutil.copy(CHAMPION, os.path.join(HISTORY_DIR, f"champion_v{cv}.dsl"))
                state["champion_version"] = cv + 1
            winner["net"].save_dsl(CHAMPION)
            state["champion_swaps"] += 1
            promoted = True
        else:
            state["champion_holds"] += 1
        save_state(state)
        maybe_report(force=True,
                     note=(f"CHAMPION {'PROMOTED' if promoted else 'HELD'} "
                           f"(imps {total_imps:+d}, z={z:.1f}, {n_boards} bd)"))
        progress["last_event"] = "champion resolved"

    save_state(state)
    maybe_report(force=True, note="loop finished")
    print(f"Final version v{state['version']} | swaps {state['champion_swaps']} "
          f"| holds {state['champion_holds']}")


if __name__ == "__main__":
    main()
