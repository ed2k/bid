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

**BUT §6.86 withdraws the "objective is flat" conclusion.** Those four
targets were all selected by an argmax taken **in-fold**. Taken
out-of-fold (`leaf_ceiling.py --emit`, leaf call chosen on fold-0 rows
only) the same DD target on the same tree measures **+0.083 ± 0.035, t
+2.34, 6 up / 2 down, 12,000 boards** — the first positive result in the
whole thread. Data (§6.80) and capacity (§6.62) are still flat; the
objective is **not**, and §6.82's outcome label should be re-run
out-of-fold too before it is written off (it failed hardest, −1.887, on
the same winner's-curse diagnosis). Cheapest next step: sweep the fold
count (2 / 5 / cross-fit) before touching anything else.

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
- **Fewer changed calls can be better.** The out-of-fold retarget changed
  111 of 767 calls and won; the in-fold one changed 204 and lost. A leaf
  often re-selects the call it already had, so count *changed* calls, not
  "retargeted" leaves.

## Environment quirks (this repo, this box)

- pytest's `tmp_path` cannot mkdir `/private/var/folders/.../pytest-of-`
  under this sandbox — use `tempfile.mkdtemp()` + `shutil.rmtree`.
- Foreground bash >120 s is SIGTERMed, and a full `pytest tests/` takes
  ~4 min: run it with `run_in_background=true`.

Central number: Brill's edge is **+1.780 ± 0.140** IMP/board on held-out
boards.
