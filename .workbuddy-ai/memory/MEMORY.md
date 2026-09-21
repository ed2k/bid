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
with them on. Do not retry this without a *counterfactual* target (DDS par
on the actual hand, or off-policy per-position scoring); on-policy
outcome labels answer "what did Brill's line earn on the deals where he
chose it", not "what is this call worth here".

Central number: Brill's edge is **+1.780 ± 0.140** IMP/board on held-out
boards. The live hypothesis is a level/aggression calibration, not
fidelity and not data.
