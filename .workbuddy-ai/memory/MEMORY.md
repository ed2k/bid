# Project notes — bid (bridge bidding engine)

Curated from the daily logs. `research/status.md` is the authoritative
record; this file is the short list of things that change how to work.

## How a result is measured here

- **The mixed measure is the only one that decides matches.** `team_match
  --a X --b Y` plays each deal at two tables, so both systems hold the same
  cards. 5 seeds x 1,500–2,200 boards is the house instrument (~±0.04
  pooled for a one-component swap).
- **Self-play attribution (`where_lost.py`, `brill_gap_where.py`) is blind
  to symmetric level bias** (§6.81): a uniform "we bid one level lower"
  error cancels when everyone plays the same system. Confirm any gap found
  there with the mixed measure.
- **One-component swaps.** Change exactly one slice (`open_uncont`,
  `later_uncont`, `later_cont`); the untouched slices then give the
  instrument its null reading. If a candidate also changes fit settings,
  run the control — §6.82 nearly reported a confounded number.
- Reproducing a fit: `--group opening_contested --max-depth 10`, slices by
  `--only-group True,False` etc. `--folds > 1` trains on everything;
  `--folds 1` leaves a 20% holdout. That difference alone changes a slice
  (752 vs 767 rules) without anyone intending it.

## Levers already exhausted (do not re-pull without a new idea)

Data (§6.80: 330k→578k buys +0.01 ± 0.03), tree capacity (§6.62), DAgger
(§6.61), pass-cap/stakes boosting (§6.68, −1.31 to −2.10), leaf margin,
vulnerability splits, per-slice specialisation (§6.73), fidelity itself
(five interventions raised it and bought nothing).

**The outcome objective is dead, not mis-tuned (§6.82, §6.83).** Relabelling
each leaf with the best-scoring call observed in it costs −1.95 ± 0.04
(−1.89 ± 0.07 against a control with the identical tree): argmax over
per-leaf sample means with `--relabel-margin 0` is a winner's curse, and
every decision in a deal shares the same |score|, so the leaf compares
*which deals* a call was made on. Turning the guards on (`--relabel-min 40
--relabel-margin 300`) drops 69 flips to 15 and the effect to
**−0.016 ± 0.043** — so the loudest, best-supported differences in that
signal are worth nothing either. Per flip: −0.027 with guards off, −0.001
with them on. Do not retry this without a *counterfactual* target; on-policy
outcome labels answer "what did Brill's line earn on the deals where he
chose it", not "what is this call worth here".

**And the counterfactual replacement is inert too (§6.84).** `--relabel-dd`
scores a call by the double-dummy value of the contract it names
(`research/brill_dd_value.py`: one `CalcDDtable` per board, ~55 ms). It is
deterministic, so no winner's curse: 204 leaves flip instead of 69, for
**−0.062 ± 0.075** instead of −1.887. Agreement with Brill falls 74.7% →
58.4% (it stopped imitating) and the mix rises a level, and it buys
nothing. Three targets are now tested — imitation, on-policy outcome, DD
counterfactual — so the ceiling is not "the wrong objective we could
compute": a leaf's ~10 features do not determine the hand, the DD-best call
varies *within* a leaf, and Brill's majority call is already the
average-best.

**IMP units instead of points did nothing either (§6.85): −0.050 ± 0.065,**
against −0.062 ± 0.075 for points — the currency was not the problem.

**§6.86/§6.87 withdraw the "objective is flat" conclusion — and the
mechanism is neither of the two obvious suspects.** `dd` was worth
**+0.212 ± 0.041** (6 seeds, 9,000 boards, 6 up / 0 down) and measured
−0.050 because **12 of its 163 retargeted leaves were relabelled to
DOUBLE/REDOUBLE**. Reverting exactly those 12 (`ddimp_nox`, other 140
untouched): paired on identical boards, `ddimp − ddimp_nox` =
**+0.331 ± 0.040, t +8.30**. Twelve calls, a third of an IMP per board.

Both suspects were tested and cleared, so do not re-pull them:
- **the fold**: `--emit-train all` reproduces `--relabel-dd`'s estimator,
  so a fold run and an all run can be tuned to flip the same number of
  calls (111 vs 116). Paired: −0.011 ± 0.029, t −0.38.
- **the support guard**: holding the fold fixed, 162 / 145 / 116 / 88
  flips give +0.107 / +0.107 / +0.110 / +0.100. Flat. (§6.83's guard
  lesson applies to the *outcome* label, not this one.)

Why: `relabel_dd_leaves` draws candidates from the calls Brill made in the
leaf, and Brill doubles, so X/XX are candidates. In `later_uncont` the
opponents have not bid, so an X is illegal at most of those positions and
is silently played as PASS; where legal it is a penalty double.

**Standing lesson: a pooled net is a property of the MODEL, not of the
objective.** One bad component in a 767-leaf slice is invisible in it.
Before concluding "the objective is flat", diff the emitted calls —
`dd` vs `ddimp` vs a control is a 3-line script and it is what found this.

**§6.88: it beats what actually ships, +0.082 ± 0.020.** Note the
baseline: `brill_distilled_control` is NOT the shipped system — it is a
refit (**--folds 2**, 767 rules) that costs **−0.120** vs shipped. So a
result measured against the control overstates by ~0.12. Measured
directly against `brill_distilled.dsl`, 6 seeds, 9,000 boards:
**+0.082 ± 0.020, t +4.17, 6 up / 0 down** (`brill_distilled_shipdd.dsl`,
148 of 752 later_uncont leaf calls). ~4.6% of the Brill gap.

Recipe (validated — reproduces `ddimp_nox` with 134 identical changes, 0
conflicts, when run on the control tree):

    leaf_ceiling.py --dsl system/brill_distilled.dsl --candidates observed \
        --with-penalties --emit-no-doubles --emit-train all --emit-min 12 \
        --emit <out.dsl>

`--with-penalties` adds X/XX so the argmax matches `--relabel-dd`'s;
`--emit-no-doubles` then leaves any leaf whose best call is a double at
Brill's call. **Leaving them alone beats relabelling them to the best
non-double call** (+0.212 vs +0.107).

**Always run `--swap` once.** Every comparison above puts the baseline as
`--a` and the candidate as `--b`; a harness favouring `b` would
manufacture the whole result. `--swap` mirrored exactly (−0.09 / +0.09,
totals ∓133).

Still open: not measured against Brill, so **not promoted to default** —
needs `team_match --remote-a` on a board count that resolves 0.08. Also:
make `--relabel-dd`'s candidate set a declared argument; re-run §6.82's
outcome label with X/XX excluded (same defect, failed hardest at −1.887).

Structural part of §6.85 still stands and is now measured: within a leaf
the deals want **7.7 distinct best calls** and agree on one only **45.3%**
of the time. That is what a finer partition has to beat.

## Evaluation discipline (learned the hard way)

- **Never grade an objective with its own training signal.** `--relabel-dd`
  picks a leaf's call by maximising the one-step DD valuation; scoring the
  result with that same valuation says +0.667 where a team match says
  −0.062. The same metric grades `relab` (a different target) correctly:
  −0.910 predicted vs −1.887 measured. A metric that is independent of the
  target is the only one that counts.
- **One-step value is a biased estimator of board value.** Over 77,880
  rows it is +198 pts where the board paid +299 and the best contract was
  +540; it matches the outcome on only 50.9% of rows. It rewards ending
  the auction in a making contract now (94% of Brill's bids here *do*
  become the final contract — the bias is that a call before any standing
  contract scores 0). It also mis-ranks: `--candidates all` scores nearly
  twice `observed` in the metric and nothing when played.
- **Pooling convention in status.md:** `pooled = mean(per-seed nets)`,
  `se = sample_sd(per-seed nets) / sqrt(n_seeds)` — the between-seed
  dispersion, *not* the per-seed standard errors. Report both when they
  disagree; when they agree there is no seed heterogeneity.
- **`team_match` prints A's net (A − B).** status.md's tables report
  *candidate − control*, so if you run `--a control --b candidate` you
  must negate. Check against §6.84 seed 7 = −0.030.
- **Fewer changed calls can be better.** §6.86's retarget changed 111 of
  767 calls and §6.84's changed 163 — but that was not why they differed,
  and the flip count alone predicted nothing (88–162 flips all measured
  the same). Count *changed* calls, not "retargeted" leaves, and then
  diff **which** calls, not how many.
- **Paired beats pooled, by ~10x.** Two matches on the same seeds share the
  same deals, so differencing their per-board `imps` arrays cancels the
  control's board noise: per-board sd of the difference 0.40–2.7 against
  3.8 unpaired, and a 0.1 IMP/board effect resolves at ±0.03 instead of
  ±0.10. Use `--dump` and pair whenever two variants are being compared to
  each other rather than to the control.

## Environment quirks (this repo, this box)

- pytest's `tmp_path` cannot mkdir `/private/var/folders/.../pytest-of-`
  under this sandbox — use `tempfile.mkdtemp()` + `shutil.rmtree`.
- Foreground bash >120 s is SIGTERMed, and a full `pytest tests/` takes
  ~4 min: run it with `run_in_background=true`.

Central number: Brill's edge is **+1.780 ± 0.140** IMP/board on held-out
boards.
