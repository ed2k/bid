#!/usr/bin/env python3
"""
refresh_student.py — closes the flywheel -> CoT-student loop.

When flywheel.py/autoloop.py accept a new improved_system.dsl version, this
script propagates the improved teacher into the neural student:

  1. Freshness check: sha256(improved_system.dsl) vs traces.meta.json.
     Regenerate corpus (trace_factory.py) and dataset (build_cot_dataset.py)
     only when the DSL actually changed (or --force).
  2. Train a CANDIDATE student with cot_model.py train
     -> data/cot_model/ckpt_candidate.pt  (incumbent ckpt.pt is never touched)
  3. Apples-to-apples gate: run cot_model.py eval-val for BOTH the candidate
     and the incumbent on the NEW dataset's val split.
     Promote the candidate only if its BID accuracy is not worse than the
     incumbent's by more than --tolerance percentage points.
  4. On promotion replace ckpt.pt (+ .vocab.json); otherwise archive the
     rejected candidate under data/cot_model/rejected/.
     Every decision is recorded in data/cot_model/student_state.json.

Usage:
  PYTHONPATH=.. python3 refresh_student.py [--boards 200] [--epochs 5]
      [--force] [--tolerance 0.0] [--seed 42]
"""

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import time

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
HERE = REPO_ROOT

DSL_PATH = os.path.join(REPO_ROOT, "system", "improved_system.dsl")
TRACES = os.path.join(REPO_ROOT, "data", "traces", "traces.jsonl")
TRACES_META = os.path.join(REPO_ROOT, "data", "traces", "traces.meta.json")
DISAGREEMENTS = os.path.join(REPO_ROOT, "data", "traces",
                             "disagreements.jsonl")
COMBINED = os.path.join(REPO_ROOT, "data", "traces", "corpus_combined.jsonl")
DATASET = os.path.join(REPO_ROOT, "data", "cot_dataset", "dataset.json")
MODEL_DIR = os.path.join(REPO_ROOT, "data", "cot_model")
INCUMBENT = os.path.join(MODEL_DIR, "ckpt.pt")
CANDIDATE = os.path.join(MODEL_DIR, "ckpt_candidate.pt")
STATE_PATH = os.path.join(MODEL_DIR, "student_state.json")


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def load_state():
    if os.path.exists(STATE_PATH):
        with open(STATE_PATH) as f:
            return json.load(f)
    return {"history": []}


def save_state(st):
    os.makedirs(os.path.dirname(STATE_PATH), exist_ok=True)
    with open(STATE_PATH, "w") as f:
        json.dump(st, f, indent=2)


def run(stage, cmd, log_path):
    """Run one pipeline stage as a subprocess; stream to console + log."""
    env = dict(os.environ)
    print(f"\n=== [{stage}] {' '.join(cmd[1:])}", flush=True)
    with open(log_path, "a") as log:
        log.write(f"\n=== [{stage}] {' '.join(cmd)}\n")
        t0 = time.time()
        proc = subprocess.Popen(cmd, cwd=REPO_ROOT, env=env,
                                stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT, text=True)
        for line in proc.stdout:
            sys.stdout.write("  | " + line)
            log.write(line)
        rc = proc.wait()
    print(f"=== [{stage}] exit={rc} ({time.time() - t0:.1f}s)", flush=True)
    if rc != 0:
        raise SystemExit(f"stage '{stage}' failed (exit {rc}); "
                         f"see {log_path}")


def parse_eval(text):
    """Pull (exact_pct, bid_pct) out of cot_model.py eval-val output.
    Uses the LAST match so appended/older eval blocks can't shadow us."""
    ex = re.findall(r"exact sequence match:\s*\d+/\d+\s*\(([\d.]+)%\)", text)
    bi = re.findall(r"BID correct\s*:\s*\d+/\d+\s*\(([\d.]+)%\)", text)
    if not bi:
        raise ValueError("could not parse eval-val output:\n" + text[-400:])
    return (float(ex[-1]) if ex else 0.0), float(bi[-1])


def eval_ckpt(python, ckpt, log_path):
    """eval-val of one checkpoint against the CURRENT dataset val split."""
    sub_log = log_path + f".eval.{os.path.basename(ckpt)}.txt"
    try:
        with open(sub_log, "w") as trunc:
            trunc.write("")  # per-run log, never append stale blocks
        run("eval",
            [python, "-u", "-m", "bid.cot_model", "eval-val",
             "--dataset", DATASET, "--ckpt", ckpt], sub_log)
        with open(sub_log) as f:
            return parse_eval(f.read())
    except (SystemExit, ValueError) as e:
        print(f"  ! could not evaluate {os.path.basename(ckpt)}: {e}",
              flush=True)
        return None



def corpus_sha256():
    """sha256 of the effective training corpus (base + disagreements)."""
    h = hashlib.sha256()
    for src in (TRACES, DISAGREEMENTS if os.path.exists(DISAGREEMENTS)
                else None):
        if src and os.path.exists(src):
            with open(src, "rb") as f:
                for chunk in iter(lambda: f.read(1 << 16), b""):
                    h.update(chunk)
    return h.hexdigest()


def dataset_corpus_fresh():
    """True if dataset.json was built from the current corpus bytes."""
    if not os.path.exists(DATASET):
        return False
    try:
        with open(DATASET) as f:
            meta = json.load(f).get("meta", {})
        return meta.get("corpus_sha256") == corpus_sha256()
    except Exception:
        return False


def dsl_changed():
    cur = sha256_file(DSL_PATH) if os.path.exists(DSL_PATH) else None
    if not os.path.exists(TRACES_META):
        return True
    with open(TRACES_META) as f:
        prev = json.load(f).get("dsl_sha256")
    return cur != prev


def main():
    ap = argparse.ArgumentParser(
        description="Regenerate traces/dataset and refresh the CoT student "
                    "when the teacher (improved_system.dsl) changes.")
    ap.add_argument("--boards", type=int, default=None,
                    help="boards for trace generation (default: previous "
                         "count from traces.meta.json, else 200)")
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--epochs", type=int, default=5)
    ap.add_argument("--batch", type=int, default=32)
    ap.add_argument("--lr", type=float, default=3e-4)
    ap.add_argument("--tolerance", type=float, default=0.0,
                    help="max allowed BID-accuracy regression to still promote "
                         "(percentage points)")
    ap.add_argument("--force", action="store_true",
                    help="regenerate corpus even if the DSL hash is unchanged")
    ap.add_argument("--scratch", action="store_true",
                    help="train candidate from scratch rather than warm-starting from incumbent")
    args = ap.parse_args()

    log_path = os.path.join(MODEL_DIR, "refresh_last.log")
    os.makedirs(MODEL_DIR, exist_ok=True)
    python = sys.executable
    st = load_state()
    t_start = time.time()

    # ---- stage 1: corpus freshness --------------------------------------
    need_traces = args.force or dsl_changed()
    need_dataset = need_traces or not dataset_corpus_fresh()
    boards = args.boards
    if boards is None:
        boards = 200
        if os.path.exists(TRACES_META):
            with open(TRACES_META) as f:
                boards = int(json.load(f).get("boards", boards))
    if not need_traces and not need_dataset:
        print(f"corpus + dataset fresh "
              f"(dsl {sha256_file(DSL_PATH)[:12]}…, "
              f"corpus {corpus_sha256()[:12]}…) - skipping regeneration.")
    else:
        if need_traces:
            run("traces", [python, "-u", "-m", "bid.trace_factory",
                           "--boards", str(boards), "--seed", str(args.seed),
                           "--out", TRACES], log_path)
        # merge base corpus + mined disagreement rows -> effective corpus
        if os.path.exists(DISAGREEMENTS):
            with open(COMBINED, "wb") as w:
                for src in (TRACES, DISAGREEMENTS):
                    with open(src, "rb") as r:
                        shutil.copyfileobj(r, w)
            print(f"merged corpus: {TRACES} + {DISAGREEMENTS} -> {COMBINED}")
            run("dataset", [python, "-u", "-m", "bid.build_cot_dataset", COMBINED],
                log_path)
        else:
            run("dataset", [python, "-u", "-m", "bid.build_cot_dataset", TRACES],
                log_path)

    # ---- stage 2: train candidate ----------------------------------------
    train_cmd = [
        python, "-u", "-m", "bid.cot_model", "train",
        "--dataset", DATASET, "--epochs", str(args.epochs),
        "--batch", str(args.batch), "--lr", str(args.lr),
        "--out", CANDIDATE,
    ]
    if os.path.exists(INCUMBENT) and not getattr(args, "scratch", False):
        train_cmd += ["--init-from", INCUMBENT]
    run("train", train_cmd, log_path)

    # ---- stage 3: gated comparison on the NEW val split ------------------
    new_ex, new_bi = eval_ckpt(python, CANDIDATE, log_path)
    old_ex = old_bi = None
    if os.path.exists(INCUMBENT):
        res = eval_ckpt(python, INCUMBENT, log_path)
        if res:
            old_ex, old_bi = res

    promote = old_bi is None or new_bi >= old_bi - args.tolerance
    reason = ("no comparable incumbent" if old_bi is None else
              f"new {new_bi:.1f}% vs incumbent {old_bi:.1f}% "
              f"(tolerance {args.tolerance})")

    # ---- stage 4: promote / reject + bookkeeping --------------------------
    record = {
        "ts": time.strftime("%Y-%m-%d %H:%M:%S"),
        "dsl_sha256": sha256_file(DSL_PATH) if os.path.exists(DSL_PATH) else None,
        "corpus_sha256": sha256_file(TRACES) if os.path.exists(TRACES) else None,
        "boards": boards, "epochs": args.epochs,
        "candidate": {"exact": new_ex, "bid": new_bi},
        "incumbent": ({"exact": old_ex, "bid": old_bi}
                      if old_bi is not None else "not evaluable"),
        "promoted": bool(promote), "reason": reason,
        "elapsed_sec": round(time.time() - t_start, 1),
    }

    if promote:
        backup = None
        if os.path.exists(INCUMBENT):
            backup = INCUMBENT + ".prev"
            shutil.move(INCUMBENT, backup)
        shutil.move(CANDIDATE, INCUMBENT)
        side = CANDIDATE + ".vocab.json"
        if os.path.exists(side):
            shutil.move(side, INCUMBENT + ".vocab.json")
        print(f"\nPROMOTED new student: {reason}")
        record["checkpoint"] = INCUMBENT
        if backup and os.path.exists(backup):
            os.remove(backup)
    else:
        rej_dir = os.path.join(MODEL_DIR, "rejected/")
        os.makedirs(rej_dir, exist_ok=True)
        dest = os.path.join(rej_dir,
                            f"{time.strftime('%Y%m%d_%H%M%S')}_ckpt.pt")
        shutil.move(CANDIDATE, dest)
        side = CANDIDATE + ".vocab.json"
        if os.path.exists(side):
            shutil.move(side, dest + ".vocab.json")
        print(f"\nKEPT incumbent student: {reason} "
              f"(candidate archived -> {dest})")
        record["rejected_to"] = dest

    st.setdefault("history", []).append(record)
    st["last"] = record
    save_state(st)

    print("\n==== refresh summary ====")
    print(f"  candidate : exact {new_ex:.1f}% | bid {new_bi:.1f}%")
    print(f"  incumbent : " +
          (f"exact {old_ex:.1f}% | bid {old_bi:.1f}%"
           if old_bi is not None else "not comparable"))
    print(f"  decision  : {'PROMOTED' if promote else 'kept incumbent'}")
    print(f"  state     : {STATE_PATH}")


if __name__ == "__main__":
    main()
