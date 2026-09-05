#!/usr/bin/env python3
"""
web_export.py — export a review snapshot of the Bid repository to a static
JS data module for the browser review UI (web/index.html).

Pattern follows ../ben/web/export_models_to_json.py: a Python exporter that
bridges repository artifacts into browser-consumable data.  Everything the
review UI shows is embedded, so the site is fully static and even works
from file:// — no server, no fetch.

Artifacts exported:
  * system/improved_system.dsl       -> parsed live by the in-browser engine
  * system/flywheel_state.json       -> version, anchor ledger, applied patches
  * data/cot_model/student_state.json -> student gate history
  * data/traces/disagreements.*      -> arbitration rows (teacher-bug candidates)
  * data/traces/traces.jsonl         -> sampled corpus rows for replay review
  * system/champion_system.dsl       -> when present

Usage:
  python3 -m bid.web_export [--traces 150] [--out web/review_data.js]
"""

import argparse
import hashlib
import json
import os
import re
import sys
import time

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
sys.path.insert(0, os.path.join(REPO_ROOT, "src"))

from bid.models import Card, Hand, Rank, Seat, Strain, Suit          # noqa: E402
from bid.sampling import Deal                                  # noqa: E402
from bid.dds import DDSolver                                   # noqa: E402

DSL_PATH = os.path.join(REPO_ROOT, "system", "improved_system.dsl")
CHAMPION_PATH = os.path.join(REPO_ROOT, "system", "champion_system.dsl")
FLYWHEEL_STATE = os.path.join(REPO_ROOT, "system", "flywheel_state.json")
STUDENT_STATE = os.path.join(REPO_ROOT, "data", "cot_model", "student_state.json")
DISAGREEMENTS = os.path.join(REPO_ROOT, "data", "traces", "disagreements.jsonl")
DISAGREEMENTS_META = os.path.join(REPO_ROOT, "data", "traces", "disagreements.meta.json")
TRACES = os.path.join(REPO_ROOT, "data", "traces", "traces.jsonl")
DEFAULT_OUT = os.path.join(REPO_ROOT, "web", "review_data.js")


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def load_json(path):
    if not os.path.exists(path):
        return None
    with open(path) as f:
        return json.load(f)


def read_jsonl(path, limit=None, stride=1):
    rows = []
    if not os.path.exists(path):
        return rows
    with open(path) as f:
        for i, line in enumerate(f):
            line = line.strip()
            if not line:
                continue
            if stride > 1 and i % stride:
                continue
            try:
                rows.append(json.loads(line))
            except ValueError:
                continue
            if limit and len(rows) >= limit:
                break
    return rows


def sample_trace_rows(max_boards=40):
    """Sample whole boards (all recorded decisions) so each exported board
    carries every seat's hand — needed for replay review and the DD table.
    Picks up to `max_boards` boards evenly across the corpus file."""
    if not os.path.exists(TRACES):
        return []
    groups, order = {}, []
    with open(TRACES) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                row = json.loads(line)
            except ValueError:
                continue
            key = f"{row['board'].get('seed')}:{row['board'].get('index')}"
            if key not in groups:
                groups[key] = []
                order.append(key)
            groups[key].append(row)
    if not order:
        return []
    stride = max(1, len(order) // max_boards)
    picked = []
    for key in order[::stride][:max_boards]:
        rows = sorted(groups[key], key=lambda r: r.get("call_index") or 0)
        picked.extend(rows)
    return picked


def compact_student_history(history, limit=40):
    out = []
    for rec in (history or [])[-limit:]:
        out.append({
            "ts": rec.get("ts"),
            "promoted": rec.get("promoted"),
            "reason": rec.get("reason"),
            "candidate": rec.get("candidate"),
            "incumbent": rec.get("incumbent"),
            "boards": rec.get("boards"),
            "epochs": rec.get("epochs"),
            "player_model_retrained": rec.get("player_model_retrained"),
        })
    return out


# ---- native double-dummy tables for recorded boards ------------------------
# The vendored pure-JS DDS is far too slow for full 52-card deals (a single
# 36-card table takes ~60s), so boards are solved at export time with the
# repo's native libdds and embedded in the snapshot.

_RANK = {"A": 14, "K": 13, "Q": 12, "J": 11, "T": 10, "10": 10,
         "9": 9, "8": 8, "7": 7, "6": 6, "5": 5, "4": 4, "3": 3, "2": 2}
_SUIT = {"S": 3, "H": 2, "D": 1, "C": 0}       # Suit enum values
_SEAT = {"NORTH": 0, "EAST": 1, "SOUTH": 2, "WEST": 3}


def parse_trace_hand(text):
    """Parse the corpus hand format 'S : 9 2 H : A 9 D : ... C : ...'."""
    cards = []
    for suit_ch, ranks in re.findall(r"([SHDC])\s*:\s*([^SHDC]+)", text):
        for tok in ranks.split():
            rank = _RANK.get(tok.strip())
            if rank:
                cards.append(Card(Suit(_SUIT[suit_ch]), Rank(rank)))
    if len(cards) != 13:
        raise ValueError(f"expected 13 cards, got {len(cards)}: {text!r}")
    return Hand(cards)


def board_dd_table(rows):
    """Reconstruct a full deal from a board's trace rows and solve the
    5x4 double-dummy table (strains S,H,D,C,NT x declarers N,E,S,W) plus
    par with the native solver.  Returns None when hands are incomplete."""
    hands = {}
    dealer = vuln = None
    for r in rows:
        seat = str(r["seat"]).replace("Seat.", "")
        if seat not in hands:
            try:
                hands[_SEAT[seat]] = parse_trace_hand(r["input"]["hand"])
            except (ValueError, KeyError):
                return None
        dealer = dealer or _SEAT.get(str(r["board"]["dealer"]).replace("Seat.", ""))
        vuln = r["board"].get("vuln", 0)
    if len(hands) < 4 or dealer is None:
        return None
    deal = Deal(hands, Seat(dealer), vuln)
    strains = [Strain.SPADES, Strain.HEARTS, Strain.DIAMONDS,
               Strain.CLUBS, Strain.NT]
    table = [[int(DDSolver.get_tricks(deal, st, Seat(decl)))
              for decl in range(4)] for st in strains]
    try:
        par_score, par_contract = DDSolver.calculate_par(deal, vuln)
    except Exception:
        par_score, par_contract = 0, "N/A"
    return {"dd_table": table, "par_contract": par_contract,
            "par_score": par_score}


def export_board_solutions(trace_rows):
    """DD solutions for every sampled corpus board (keyed 'seed:index')."""
    boards = {}
    groups = {}
    for row in trace_rows:
        key = f"{row['board'].get('seed')}:{row['board'].get('index')}"
        groups.setdefault(key, []).append(row)
    for key, rows in groups.items():
        try:
            sol = board_dd_table(rows)
        except Exception:
            sol = None
        if sol:
            boards[key] = sol
    return boards


def build_snapshot(boards=40):
    dsl = open(DSL_PATH).read() if os.path.exists(DSL_PATH) else ""
    champion = open(CHAMPION_PATH).read() if os.path.exists(CHAMPION_PATH) else None
    fw = load_json(FLYWHEEL_STATE) or {}
    st = load_json(STUDENT_STATE) or {}
    mine_meta = load_json(DISAGREEMENTS_META) or {}
    sampled = sample_trace_rows(boards)

    return {
        "generated_ts": time.strftime("%Y-%m-%d %H:%M:%S"),
        "repo": os.path.basename(REPO_ROOT),
        "dsl": dsl,
        "dsl_sha256": sha256_file(DSL_PATH)[:12] if os.path.exists(DSL_PATH) else None,
        "champion_dsl": champion,
        "teacher": {
            "version": fw.get("version"),
            "applied": (fw.get("applied") or [])[-40:],
            "failed_count": len(fw.get("failed") or []),
            "champion_swaps": fw.get("champion_swaps", 0),
            "champion_holds": fw.get("champion_holds", 0),
            "anchor": fw.get("anchor", {}),
        },
        "student": {
            "history": compact_student_history(st.get("history")),
        },
        "mining": {
            "meta": {k: mine_meta.get(k) for k in
                     ("decisions", "forced", "agreements", "disagreements",
                      "arb_system_right", "arb_student_right", "arb_new_call",
                      "rows_written", "elapsed_sec", "dsl_sha256")},
            "rows": read_jsonl(DISAGREEMENTS),
        },
        "traces": sampled,
        # native-DDS solutions for sampled boards; the browser UI uses the
        # vendored WASM DDS live and falls back to these when it can't load
        "boards": export_board_solutions(sampled),
    }


def main():
    ap = argparse.ArgumentParser(description="Export review snapshot for the browser UI")
    ap.add_argument("--boards", type=int, default=40,
                    help="number of corpus boards to sample (all recorded calls each)")
    ap.add_argument("--out", default=DEFAULT_OUT)
    args = ap.parse_args()

    snap = build_snapshot(args.boards)
    payload = json.dumps(snap, ensure_ascii=False)
    # keep the data module safe to inline via <script src=...>
    payload = payload.replace("</", "<\\/")

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w") as f:
        f.write("/* Generated by `python3 -m bid.web_export` — do not edit. */\n"
                f"/* Snapshot: {snap['generated_ts']} | dsl {snap['dsl_sha256']} */\n"
                "globalThis.BID_REVIEW_DATA = ")
        f.write(payload)
        f.write(";\n")
    size_kb = os.path.getsize(args.out) / 1024.0
    print(f"exported -> {args.out} ({size_kb:.0f} KB) | "
          f"dsl {snap['dsl_sha256']} v{snap['teacher']['version']} | "
          f"{len(snap['traces'])} trace rows on {len(snap['boards'])} solved boards | "
          f"{len(snap['mining']['rows'])} disagreement rows")


if __name__ == "__main__":
    main()
