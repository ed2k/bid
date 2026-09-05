#!/usr/bin/env python3
"""
continuous.py — meta-orchestrator chaining the runbook loops into one
unattended self-improvement cycle:

    ┌─────────────────────────────────────────────────────────────┐
    │  Loop A  teacher   (autoloop.py, bounded cycles)            │
    │     ↓  improved_system.dsl changes (val/SDS-gated)          │
    │  Loop B  student   (refresh_student.py)                     │
    │     ↓  fresh ckpt.pt (+ player model retrained on change)   │
    │  Loop C  mining    (mine_disagreements.py)                  │
    │     ↓  disagreements.jsonl -> merged into the next corpus   │
    │  (opt)   Loop D    (rl_finetune.py, every --rl-every cycles)│
    │     ↑_______________________________________________________│
    └─────────────────────────────────────────────────────────────┘

Every stage runs as a SUBPROCESS of the corresponding runbook script, so all
per-loop gates (val-seed, SDS, eval-val floor) still apply unchanged.  The
orchestrator only sequences them, persists which stage comes next, and
resumes there after a crash or Ctrl-C:

    system/continuous_state.json   {"cycle": n, "next_stage": i, ...}
    debug/continuous.log           consolidated stage output

A stage that fails is retried on the next cycle; after
--max-stage-fails consecutive failures of the same stage the orchestrator
aborts so the problem does not spin unattended.

Usage:
  python3 -m bid.continuous                        # run until stopped
  python3 -m bid.continuous --max-cycles 5         # five full A->B->C cycles
  python3 -m bid.continuous --rl-every 3 --sds-gate
"""

import argparse
import json
import os
import subprocess
import sys
import time

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SYSTEM_DIR = os.path.join(REPO_ROOT, "system")
STATE_PATH = os.path.join(SYSTEM_DIR, "continuous_state.json")
LOG_PATH = os.path.join(REPO_ROOT, "debug", "continuous.log")
MINE_META = os.path.join(REPO_ROOT, "data", "traces", "disagreements.meta.json")


def load_run_state(path=STATE_PATH):
    if os.path.exists(path):
        try:
            with open(path) as f:
                st = json.load(f)
            if isinstance(st, dict) and "cycle" in st:
                st.setdefault("next_stage", 0)
                st.setdefault("stage_fails", {})
                return st
        except ValueError:
            pass
    return {"cycle": 1, "next_stage": 0, "stage_fails": {}}


def save_run_state(st, path=STATE_PATH):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    st["ts"] = time.strftime("%Y-%m-%d %H:%M:%S")
    with open(path, "w") as f:
        json.dump(st, f, indent=2)


def plan_cycle(cycle_no, rl_every):
    """Ordered stages for one improvement cycle (pure; unit-tested)."""
    stages = ["teacher", "student", "mine"]
    if rl_every and cycle_no % rl_every == 0:
        stages.append("rl")
    return stages


def stage_cmd(stage, args, python):
    if stage == "teacher":
        cmd = [python, "-u", "-m", "bid.autoloop",
               "--tiers", args.tiers, "--max-cycles", str(args.teacher_cycles)]
        if args.sds_gate:
            cmd.append("--sds-gate")
        if args.policy_prior:
            cmd += ["--policy-prior", args.policy_prior]
    elif stage == "student":
        cmd = [python, "-u", "-m", "bid.refresh_student",
               "--boards", str(args.boards), "--epochs", str(args.epochs)]
    elif stage == "mine":
        cmd = [python, "-u", "-m", "bid.mine_disagreements",
               "--boards", str(args.mine_boards)]
    elif stage == "rl":
        cmd = [python, "-u", "-m", "bid.rl_finetune",
               "--boards", str(args.rl_boards), "--epochs", str(args.rl_epochs),
               "--tolerance", str(args.rl_tolerance)]
    else:
        raise ValueError(f"unknown stage {stage!r}")
    return cmd


def run_stage(stage, cmd, log):
    """Stream one stage's output to console + shared log. True on exit 0."""
    print(f"\n=== [stage: {stage}] {' '.join(cmd[1:])}", flush=True)
    log.write(f"\n=== [{time.strftime('%Y-%m-%d %H:%M:%S')}] {stage}: "
              f"{' '.join(cmd)}\n")
    log.flush()
    t0 = time.time()
    proc = subprocess.Popen(cmd, cwd=REPO_ROOT, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True)
    for line in proc.stdout:
        sys.stdout.write("  | " + line)
        log.write(line)
    rc = proc.wait()
    log.flush()
    print(f"=== [{stage}] exit={rc} ({time.time() - t0:.1f}s)", flush=True)
    return rc == 0


def mine_summary(path=MINE_META):
    """One-line mining report; arb_student_right>0 flags candidate teacher bugs."""
    try:
        with open(path) as f:
            m = json.load(f)
    except (OSError, ValueError):
        return ""
    return (f"decisions {m.get('decisions', 0)}"
            f" | arb: system right {m.get('arb_system_right', 0)},"
            f" student right {m.get('arb_student_right', 0)},"
            f" new calls {m.get('arb_new_call', 0)}")


def main():
    ap = argparse.ArgumentParser(
        description="Run the full teacher->student->mining improvement "
                    "flywheel unattended")
    ap.add_argument("--max-cycles", type=int, default=0,
                    help="stop after this many full cycles (0 = run until stopped)")
    ap.add_argument("--tiers", default="24,96",
                    help="teacher screening tiers, passed to autoloop")
    ap.add_argument("--teacher-cycles", type=int, default=2,
                    help="autoloop screening cycles per round")
    ap.add_argument("--sds-gate", action="store_true",
                    help="pass --sds-gate to the teacher loop")
    ap.add_argument("--policy-prior", default=None,
                    help="student ckpt for policy-guided PIDM pruning")
    ap.add_argument("--boards", type=int, default=200,
                    help="student corpus boards (refresh_student)")
    ap.add_argument("--epochs", type=int, default=3,
                    help="student training epochs")
    ap.add_argument("--mine-boards", type=int, default=100,
                    help="boards for disagreement mining")
    ap.add_argument("--rl-every", type=int, default=0,
                    help="run RL fine-tune every N cycles (0 = never; output "
                         "is off-teacher — A/B in the arena before adopting)")
    ap.add_argument("--rl-boards", type=int, default=64)
    ap.add_argument("--rl-epochs", type=int, default=3)
    ap.add_argument("--rl-tolerance", type=float, default=0.5)
    ap.add_argument("--max-stage-fails", type=int, default=3,
                    help="abort after a stage fails this many consecutive cycles")
    args = ap.parse_args()

    os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)
    st = load_run_state()
    python = sys.executable
    print(f"CONTINUOUS loop from cycle {st['cycle']} stage {st['next_stage']} "
          f"(state: {STATE_PATH})")

    try:
        while args.max_cycles == 0 or st["cycle"] <= args.max_cycles:
            stages = plan_cycle(st["cycle"], args.rl_every)
            with open(LOG_PATH, "a") as log:
                completed = True
                for idx in range(st["next_stage"], len(stages)):
                    stage = stages[idx]
                    st["next_stage"] = idx
                    save_run_state(st)
                    ok = run_stage(stage, stage_cmd(stage, args, python), log)
                    if ok:
                        st.setdefault("stage_fails", {})[stage] = 0
                        if stage == "mine":
                            summary = mine_summary()
                            if summary:
                                print(f"  mining: {summary}", flush=True)
                    else:
                        fails = st.setdefault("stage_fails", {}).get(stage, 0) + 1
                        st["stage_fails"][stage] = fails
                        print(f"  !! stage '{stage}' failed "
                              f"({fails}/{args.max_stage_fails} consecutive)",
                              flush=True)
                        if fails >= args.max_stage_fails:
                            raise SystemExit(
                                f"stage '{stage}' failed {fails} consecutive "
                                f"cycles; aborting. Fix and rerun "
                                f"`python3 -m bid.continuous` to resume.")
                        completed = False
                        break
                if completed:
                    st["next_stage"] = 0
                    st["cycle"] += 1
            save_run_state(st)
            if completed:
                print(f"--- cycle {st['cycle'] - 1} complete ---", flush=True)
    except KeyboardInterrupt:
        print("\nInterrupted — state saved; rerun to resume at the "
              "interrupted stage.", flush=True)
    save_run_state(st)
    print(f"Stopped at cycle {st['cycle']} stage {st['next_stage']}.")


if __name__ == "__main__":
    main()
