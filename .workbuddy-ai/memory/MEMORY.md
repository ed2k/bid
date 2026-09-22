# Project notes — bid (bridge bidding engine)

`research/status.md` is the authoritative record. This file is the short
list of things that change how to work; `§6.8x` refs point there.

## How a result is measured

- **The mixed measure decides matches.** `team_match --a X --b Y` plays each
  deal at two tables (same cards). 5 seeds x 1,500–2,200 boards is the house
  instrument (~±0.04 pooled for a one-component swap).
- **One-component swaps.** Change exactly one slice (`open_uncont`,
  `later_uncont`, `later_cont`); the untouched slices give the null reading.
- **`team_match` prints A's net (A − B).** status.md tables are
  candidate − control, so `--a control --b candidate` must be negated.
- **Pooling:** `pooled = mean(per-seed nets)`,
  `se = sample_sd(nets)/sqrt(n_seeds)` — between-seed dispersion, *not*
  per-seed SEs. Report both when they disagree.
- **Paired beats pooled by ~10x.** Two matches on the same seed share deals;
  differencing per-board `imps` cancels board noise (±0.03 vs ±0.10 unpaired).
- **Self-play attribution (`where_lost.py`, `brill_gap_where.py`) is blind to
  symmetric level bias** (§6.81). Confirm any gap with the mixed measure.
- Reproducing a fit: `--group opening_contested --max-depth 10`, slices via
  `--only-group`. `--folds > 1` trains on everything; `--folds 1` leaves a
  20% holdout — that alone changes a slice (752 vs 767 rules).

## Where the headroom is (§6.88–§6.90)

One-step DD retargeting, `later_uncont` only:
`system/brill_distilled_shipdd.dsl` = **+0.082 ± 0.020** vs shipped
(6 seeds, 9,000 boards, 6 up / 0 down), and it **transfers** to a different
opponent (+0.076 ± 0.059, §6.90). ~4.6% of Brill's +1.780 ± 0.140 edge.

Recipe (validated):

    leaf_ceiling.py --dsl system/brill_distilled.dsl --candidates observed \
        --with-penalties --emit-no-doubles --emit-train all --emit-min 12 \
        --emit <out.dsl>

`--with-penalties` adds X/XX so the argmax matches `--relabel-dd`;
`--emit-no-doubles` leaves a leaf at Brill's call where the best call is a
double — **leaving them alone beats relabelling them** (+0.212 vs +0.107).

**Do not extend to the other slices (§6.89).** `shipdd_c` (279/829 contested
leaves) = **+0.005 ± 0.049**. Ceilings: later_uncont +0.396, later_cont
+0.092, open_uncont +0.021. Realised tracks the ceiling, and the ceiling is
only valid where the chosen call *is* the contract. Believe the **oracle**
column: openings have the largest real headroom and the smallest reachable
ceiling, so the binding constraint is the **partition**, not the label.

**`leaf_ceiling.py` flag trap:** `--prefix` selects which RULES are rewritten,
`--only-group` which ROWS are featurised — independent flags. Default
`False,False` = `later_uncont`, so `--prefix BD_later_cont_` scores **0 rows**
and prints "no leaf" instead of failing. Mapping: later_cont `False,True`;
open_uncont `True,False`.

## Exhausted — do not re-pull without a new idea

Data (§6.80: 330k→578k buys +0.01 ± 0.03), tree capacity (§6.62), DAgger
(§6.61), pass-cap/stakes boosting (§6.68), leaf margin, vulnerability splits,
per-slice specialisation (§6.73), fidelity itself.

**The objective is not the problem (§6.82–§6.87).** Three targets tested —
imitation, on-policy outcome (−1.95 ± 0.04), DD counterfactual (−0.062 ±
0.075) — all flat. `dd` was actually worth **+0.212 ± 0.041** and measured
−0.050 because **12 of its 163 retargeted leaves became DOUBLE/REDOUBLE**;
reverting exactly those 12 (`ddimp_nox`) = +0.331 ± 0.040, t +8.30. Fold and
support-guard suspects both cleared; IMP units changed nothing (§6.85).

**Standing lesson: a pooled net is a property of the MODEL, not of the
objective.** One bad component in a 767-leaf slice is invisible in it. Before
concluding "the objective is flat", diff the emitted calls.

**Never grade an objective with its own training signal.** `--relabel-dd`
scores +0.667 in its own metric where a team match says −0.062.

**Always run `--swap` once** — a harness favouring `b` would manufacture the
whole result. It mirrored exactly (−0.09 / +0.09).

Within a leaf the deals want **7.7 distinct best calls** and agree on one only
**45.3%** of the time — that is what a finer partition has to beat. Within-leaf
agreement alone is not a signal: `open_uncont` has the lowest agreement (28.6%)
and the smallest ceiling.

## Environment quirks

- pytest's `tmp_path` cannot mkdir under this sandbox — use
  `tempfile.mkdtemp()` + `shutil.rmtree`.
- Foreground bash >120 s is SIGTERMed; full `pytest tests/` (~4 min) must run
  in background.
- `grep "a\|b"` alternation silently fails; `grep --include=` is unsupported
  on this BSD grep. Use the Grep tool.
- Cap sustained parallel work at ~4 workers (no swap; this box has hard-reset
  under all-core load).

## Repo layout: load-bearing vs by-product

**Never assume "unreferenced by path" means "unused".** Three loaders read
whole directories:

- `cot_tokenizer.build_frozen_vocab()` globs `system/*.dsl` **and**
  `system/history/*.dsl` for `RULE <id>`; exclusion is
  `_VOCAB_EXCLUDED_DSL_GLOBS = ("brill*.dsl",)` and `fnmatch` makes that cover
  every `brill_distilled*.dsl`. → `system/history/improved_system_v5..v27.dsl`
  supply 4 rule ids found nowhere else; untracking them breaks the shipped CoT
  checkpoint.
- `translator.py:147-150` resolves `system/conventions/<name>.dsl` and
  `system/cuebids/<name>.dsl` by name (~230 files, a live library).
- `leaf_ceiling.py` / `team_match.py` take DSL paths as CLI defaults, so a file
  can be a default without being mentioned anywhere else.

Vocab is **431**; the shipped `manifest.json` says **404**. **By design** —
431 (`data/cot_dataset/vocab.json`, guarded by
`test_frozen_vocab_file_integrity`) is canonical; 404 is a stale
training-time sidecar (`cot_model.py:194`) that 431 strictly supersets (27
added, 0 removed). `cmd_generate` reads the dataset vocab and
`_grow_vocab_tensors` grows a smaller checkpoint to fit.

**Residual hazard (unfixed, deliberate):** `mine_disagreements.prefix_ids`
does `if t in V` — it *silently drops* unknown atoms where
`encode_line(strict=True)` would raise. Worth a strict check if
`format_state_prefix` ever emits a feature name.

## Git state (2026-09-22)

- Untracked 113 regenerable intermediates (596 MB), then 13 inert DSL variants
  (11.5 MB). **Files still on disk.**
- `data/brill_traces_578k.jsonl` (147 MiB) exceeded GitHub's 100 MB cap and
  was reachable **only from unpushed commits**; fixed by rewriting just
  `origin/main..main`, so the push stays a fast-forward.
- `origin/main` already carries 88/52/35 MB traces (accepted by GitHub).
- `backup/pre-rewrite-20260922` holds the pre-rewrite history.
- `.git` is still large — untracking does not reclaim history; shrinking it
  needs a force-push that breaks clones (not authorized).
