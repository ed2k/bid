# Bid: Research Foundations & Implementation Status

*Current implementation status, empirical results, and open issues for this repo. Complements [`bid-invention.md`](bid-invention.md) (BIDI theory reconstruction) and [`sds-explained.md`](sds-explained.md) (SDS deep-dive).*

---

## 1. Mission

An autonomous, self-improving contract bridge **bidding** platform that reconstructs and extends Amit & Markovitch's BIDI architecture ("Learning to Bid in Bridge", MLJ 2006):

> rule-based candidate pruning → model-conditioned world sampling (RBMBMC) → recursive search (PIDM) → expensive-search-as-teacher speedup learning (ID3 on rule intersections) → parallel partner co-training → convention invention scored by Value of Information.

Extensions beyond the 2006 paper: stratified rare-state discovery, structural bidding diagnostics against native DDS par, a continuous-improvement flywheel with auto-generated patches and versioned persistence, single-dummy (SDS) scoring, and a strategy-fusion-correct card-play search core.

---

## 2. Architecture map

```
                    ┌────────────────────────────────────────────┐
                    │            improvement flywheel             │
                    │  flaws → patches → paired confirm → save    │
                    └───────▲────────────────────────▲───────────┘
                            │                        │
     ┌──────────────────────┴─────────┐   ┌──────────┴────────────┐
     │        evaluation harness      │   │  diagnostics engine   │
     │  eval_vs_dds.py (--sds dual)   │   │ ParDiagnosticEngine   │
     │  arena.py tournaments          │   │ structural-first      │
     └──────────────┬─────────────────┘   └──────────┬────────────┘
                    │                                │
     ┌──────────────▼────────────────────────────────▼────────────┐
     │                   bidding / play engines                   │
     │  DecisionNet (rules+ID3) → PIDM (RBMBMC + lookahead)       │
     │  SDSScorer (two-hand contract scoring)                     │
     │  PlaySearcher (PIMC M=1 / αμ M≥2 card-play search)         │
     └──────────────┬─────────────────────────────────────────────┘
                    │
     ┌──────────────▼──────────────┐   ┌────────────────────────────┐
     │  native DDS (dds3 binding)  │   │ domain models / features   │
     │  dd tables · par · leaves   │   │ models · features · scoring│
     └─────────────────────────────┘   └────────────────────────────┘
```

---

## 3. Implemented & verified

Test suite: **98 tests green** (1 `expectedFailure` = tracked deep-M issue, §6).

| Layer | Module(s) | Status |
| --- | --- | --- |
| Domain models, 250+ bridge features, duplicate/IMP scoring | `models.py` `features.py` `scoring.py` | stable |
| Native DDS: double-dummy tables (20 strains×declarers), par | `dds.py` via BEN's libdds (`CalcDDtablePBN`, `Par`) | stable |
| Native DDS: mid-play leaf solving | `dds.py` via dds3 `SolverContext.solve_board_pbn` | new, verified |
| RBMBMC auction-consistent world sampling | `sampling.py` | stable |
| PIDM bidding search (sample → nested model rollout → DD leaf) | `pidm.py` | stable; rollout-to-terminal fix landed (see §5) |
| DecisionNet selection strategy φ(s), legality filter, ID3 intersection refinements | `decision_net.py` `learner.py` | stable |
| Partner co-training loop | `cotrain.py` | stable |
| Stratified deal generation, experience buffer, exploration | `experience.py` | stable |
| Convention synthesis + VOI evaluator | `protocol.py` | stable |
| Traditional rule engine + DSL translator + system corpus (BlueClub, Precision, GIB, SAYC, cuebid library) | `engine.py` `system.py` `translator.py` `system/` | stable |
| Structural par diagnostics (flaw taxonomy below) + corrective-rule synthesis | `diagnostics.py` | upgraded this cycle |
| Tournament arena + head-to-head comparisons | `arena.py` | stable |
| Evaluation harness vs native DDS par, seeded/paired protocol | `eval_vs_dds.py` | stable |
| **SDS two-hand contract scoring** (PIMC over sampled opponent layouts) | `sds.py::SDSScorer` | new, verified |
| **True play search**: trick mechanics, `OutcomeVector`, PIMC (M=1), αμ M≥2 with fusion-forbidden Max commitments | `sds.py::PlaySearcher` | experimental (§6) |
| Flywheel: auto-generated patch pools, paired hill-climb, validation gates, state cache, versioned history | `flywheel.py` (+ `improve_*.py` lineage) | stable |

### 3.1 Diagnostics flaw taxonomy

Structural checks run **before** any score comparison, so lucky results cannot mask bad auctions:

`OPTIMAL_PAR` · `MISSED_SLAM` · `MISSED_GAME` · `SOFT_DEFENSE` · `OVERBID_DOWN` · `TAKEOUT_PASS` (passed partner's takeout double holding 10+) · `LUCKY_MASKED_MISS` · `MISSED_PENALTY_DOUBLE`.

Each family feeds `generate_corrective_rules_for_diagnostics`, closing the loop back into the flywheel.

### 3.2 Bidding system lineage (current: v11)

Verified progression on seeded deal sets, all patches accepted only after paired cross-validation:

| Version | Change | Measured effect |
| --- | --- | --- |
| v2 | removed always-firing synthesized "junk" rules | +27 to +52 pts/board |
| v3 | gated contextless 3NT and direct games | −16 → −4.5 regret vs par |
| v4 | isolated + gated the four contextless raise/game rules | +34.6 avg; Boards 21/22 flipped to optimal |
| v5 | shaped takeout doubles, forcing raises (flywheel round) | +20.9 train, +10.1 val |
| v7–v8 | advancer rules over takeout X; sound raise gates (partner-context required) | Board 1 sanity restored; EV cost accepted as policy |
| v9 | slam ladder (strong 6-card rebid → fit drive → 6NT drive) | MISSED_SLAM 17→10; verification case 4S=+450 → 6NT=+1020 |
| v10–v11 | Blackwood ace ask + king ask (RKCB-style verification ladders) | EV-neutral, capability-completing; grand slams now reachable *verified* |

---

## 4. Key empirical findings

1. **DD-par flaw labels ≠ expected value.** Three independent episodes showed "obviously buggy" aggressive rules were EV-positive in self-play, while "obvious" discipline gates lost points. All acceptance decisions therefore run through paired, seeded, within-process confirmation across ≥3 disjoint deal sets.
2. **Perfect-information scoring flatters luck.** Under SDS two-hand scoring the repo's aggressive system drops ≈21 pts/board while conservative archetypes hold steady — contracts that need omniscient declarer play no longer earn full credit. See [`sds-explained.md`](sds-explained.md) §6.
3. **The dead-search bug class is real.** The original lookahead evaluated non-terminal states as literal 0.0, making every multi-candidate decision an arbitrary tie-break. Post-fix, values are real DDS-backed expectations.
4. **Cross-process noise exists** (set-iteration tie-breaks under hash randomization). Protocol: never compare numbers across processes; use within-process paired deltas, or fix `PYTHONHASHSEED`.
5. **Self-play defense is structurally weak** (both sides share one system): penalty doubles print money against mirror-pathologies, so SOFT_DEFENSE/OVERBID_DOWN counts must be read with care.

---

## 5. Notable bugs fixed (patterns worth remembering)

| Bug | Root cause | Fix / guardrail |
| --- | --- | --- |
| All-zero lookahead values | `evaluate_terminal_deal` returned 0.0 for non-terminal states at depth cap | greedy rollout-to-terminal then DD-eval (`pidm.py`) |
| Junk conventions firing everywhere | pipeline-synthesized ENCODE/TRANSFER rules without auction conditions | DROP scan in flywheel; gating generator |
| Contextless raises/games | pipeline rules lost `partner_last_call` guards | auto-gate variants + isolation testing before adoption |
| Suit-order scrambling in PBN | repo enums are alphabetical (C,D,H,S); DDS expects S,H,D,C | explicit order mapping in `_cards_to_pbn_suits` and current-trick arrays (`3 - value`) |
| Cross-world TT pollution (-13 errors) | shared SolverContext transposition table across deals | `mode=2` (clear per solve) per sds.md K6 |
| Phantom 0-trick leaves | `_leaf` invoked on exhausted positions | empty-hands shortcut returning accumulated tricks |

---

## 6. Known issues / experimental status

1. **Deep-M αμ accounting** (`PlaySearcher`, tracked as `expectedFailure` in `tests/test_play_search.py::test_full_depth_single_world_equals_dd`): at M beyond ~remaining tricks, values diverge from native DD because `_finish_trick` grants an uncounted Max commitment at the M-exhaustion boundary. Verified correct for **M ≤ remaining tricks**, which covers the theoretically clean regime. TODO: implement paper-exact `stop()` semantics (Algorithm 3) so M counts every Max node including in-flight tricks.
2. **Strategy fusion analog in bidding rollouts**: PIDM rollouts let each seat act per world. Bounded by shallow depth + shared deterministic models; revisit if rollouts deepen. Full discussion: [`sds-explained.md`](sds-explained.md).
3. ~~champion_system.dsl double-counts~~ — RESOLVED at harness level: `eval_vs_dds` signature-compares the snapshot against archetypes and skips identical entries (logged); the file remains as a historical artifact.
4. **Exported DSL loses ID3 refinements**: `export_dsl` skips classifiers without `.root`; measured impact ≈0 today but blocks faithful round-trip.
5. ~~Uniform SDS worlds ignore the auction~~ — RESOLVED: `SDSScorer(condition_factor=k)` generates a k× pool and keeps the num_worlds layouts least inconsistent with the played auction (elite selection via `calculate_inconsistency` with the system's own models). Wired through `eval_vs_dds --sds --sds-condition`; test `test_conditioned_sampling_prefers_consistent_worlds` proves West's 1S-overcall holding survives conditioning vs uniform.

---

## 6.5 Autonomous loop (`autoloop.py`) — NEW

Long-running driver implementing the agreed policy:
- **Staged funnel, start small**: candidates screen on the smallest tier; escalation to bigger boards happens only when the paired result is statistically inconclusive (`|z| < 2`). 1000-board tier is reachable via `--tiers 24,96,384,1000`.
- **Significance-gated acceptance**: accept requires strictly positive mean delta AND z ≥ 2 (sign guard rejects constant-zero patches that produce |z|=∞).
- **Automatic champion promotion**: accepted versions challenge the incumbent champion head-to-head over both seat orientations at ≥64 boards; a win (positive IMPs, z ≥ 2) auto-replaces `champion_system.dsl` (old archived to `system/history/champion_v*.dsl`).
- **Checkpoints & progress**: report + rolling JSON snapshot (`debug/autoloop_progress.json`, gitignored) every `--progress-secs` (default 300s) and on every major event.
- State/cache shared with flywheel (`flywheel_state.json`: failed-signature cache, version counter, applied log).

### 6.7 Solver silent-failure masking + true diagnosis of reported "missed game" board

**Fixed (permanent)**: `CalcDDtablePBN` failures were silently masked by
`get_tricks`' hardcoded default of 7 — a broken table looked like "down exactly
nothing" or similar nonsense. Now: loud stderr on failure + exact per-contract
fallback via dds3 (`_exact_fallback_table`) + never return magic defaults.
Two independent code paths (ctypes table / dds3 boards) now cross-validate.

**Board diagnosis corrected** (user-reported ♠QJ9652 ♥A ♦KT3 ♣Q96 opposite
♠A3 ♥JT ♦AQ875): dual-solver consensus = NS make **11 tricks in NT**, 7 in
spades. Optimal = 3NT/6NT by N-S. System's failure is NOT "didn't raise
spades" (4♠ is down 3!) — it lacks an **NT-detection path after a minor
opening with a misfit-major responder** (responder's ♦AQ875 + stopperless
hand wants 3NT, not a major race). Logged as next design item rather than
patched blind: candidate = responder 3NT rule over partner's minor opening
when holding 11+ HCP, unbalanced-but-notrump-playable (requires stopper
feature check — `*_stopper` features exist).

Lineage decision: reverted improved_system.dsl to v15 archive (v16's 4♠
attempt scored worse than the passed-out baseline on this board); v16 kept
in history for reference.

### 6.6 Vulnerability awareness — investigated, negative result (kept honest)

**Discovery**: the deal generator never varied vulnerability (`Deal.random_deal` defaults
to NONE) — every prior evaluation ran non-vulnerable only. Fixed: `build_deals(vuln_mode="random")`
now rotates all four cells; new `convention_lab vuln-cells` shows per-cell regret
(unfavorable cell was −158/board, favorable −98 — real pain).

**Three policy variants tested** (paired, seeds 42/7/13 × 64 boards):
| Variant | Result |
| --- | --- |
| Light favorable overcalls (hcp≥7) + discipline | **−12.5 avg, 0/3** (light entries backfired −91→−108) |
| Unfavorable discipline only (red seats need 11+) | **−3.0 avg, 0/3** (neutral) |

**Conclusion**: with *symmetric* self-play opponents, vuln-gating competitive calls is
EV-neutral-to-negative — the mirror system adapts identically, so effects cancel.
Asymmetric value requires heterogeneous opposition (league play, roadmap §7). The
harness vuln fix stands regardless; PIDM's DD leaf scoring was already vuln-aware,
so no engine change was needed.

### 6.9 Core-guard rot + response-side coverage holes — RESOLVED (v19)

Two reported cases, one combined fix (`improve_softresp.py`, saved as v19):

| Case | Symptom | Root cause | Fix |
| --- | --- | --- | --- |
| 19 HCP balanced w/ 5-card minor **passed out** | every opening rule missed | `is_balanced` counts 5-card minors as balanced; rules covered only 12–14 bal / 15–17 NT / unbalanced | `R_1C/D_STRONG_BAL` (15+ bal → longer minor) + `R_2NT_2021` |
| Board 35: 13 HCP + 6-card clubs silent | no competitive/response rule for minors existed at all | response-side coverage hole (minor overcalls/responses never authored) | `MC_OVERCALL_2m` (11+, 6-card), `MC_RESP_2m_OVER_1M` (10+, 5-card), `MC_REBID_3m` ladder |
| (root rot) opponents "opening" our hands | all `is_opening` guards stripped by historical patch cycles | guard-loss during repeated rule replacements | `stage_repair` re-inserts guards idempotently |

**Verification**: reported 19-HCP board now opens 1C and drives to 6NT (DD-consistent:
12 tricks available); board 35 South actively competes to game level.

**Honest cost**: paired deltas −57.0/−2.9/−8.3 (avg −22.7, accepted via
verification-case override per project policy — coverage completeness outranks
short-term EV here; the autoloop will police regressions on future cycles).
Watch seed 42 specifically next cycles.

## 7. Roadmap (prioritized)

0. ~~Autonomous staged loop~~ — DONE (§6.5); run with `PYTHONPATH=.. python3 autoloop.py --tiers 24,96 --progress-secs 300`.
1. ~~Fix deep-M αμ accounting~~ — DONE (§6.1): exact boundary-only leaf architecture; searcher == native DD across seed sweeps.
2. **Flywheel on the SDS objective at scale** — `--sds-primary` exists; needs larger deal sets + faster leaves (batching per design doc K10).
3. ~~RBMBMC-conditioned SDS worlds~~ — DONE (§6.5). Next level: weight worlds by inconsistency (soft posterior) instead of hard elite cut.
4. **Stateful convention memory in DecisionNet** — multi-step conventions (RKCB continuations) currently rely on fragile feature chains; a small protocol-state stack would remove the context-leakage class entirely.
5. ~~DSL round-trip fidelity~~ — DONE: `RESOLVED_CALL` export/import verified.
6. **Defense-side roots** for play search (design-doc open question #1).
7. **Truncated-PIMC speed knob** — needs reliable mid-trick solving (own alpha-beta or upstream dds3 fix); earlier budget sweep was invalidated by the dead-search bug.
8. **Differentiate or retire champion_system.dsl**.

---

## 8. Usage quick reference

```bash
# leaderboard with true-DD and SDS two-hand columns
PYTHONPATH=.. python3 eval_vs_dds.py --boards 48 --no-stratified --sds

# continuous improvement (auto-generates patches, caches failures, versions saves)
PYTHONPATH=.. python3 flywheel.py --deals 48 --rounds 3 --pool-cap 14 --sds
PYTHONPATH=.. python3 flywheel.py --deals 32 --rounds 2 --pool-cap 8 --sds-primary

# board-level report (hands, auctions, DDS par)
PYTHONPATH=.. python3 export_results.py --deals 64 --seed 42 --out report.txt

# targeted board replay
PYTHONPATH=.. python3 show_bids.py 1 16 21 22
```

---

## 9. References

- Amit & Markovitch, *Learning to Bid in Bridge*, MLJ 63(3), 2006 — BIDI/RBMBMC/PIDM/ID3/co-training foundations.
- Cazenave & Ventos, *The αμ Search Algorithm for the Game of Bridge*, arXiv:1911.07960 — PIMC/αμ, strategy fusion, Pareto fronts.
- Frank & Basin, *Search in Games with Incomplete Information* — fusion/non-locality formalization.
- Ginsberg, GIB — PIMC in competitive bridge.
- Bo Haglund & Søren Hein, DDS 3.x — native solver; `SolverContext` lifecycle guidance in `../dds/sds.md` (K5/K6/K10).
- [`research/sds-explained.md`](sds-explained.md) — SDS theory-to-implementation walkthrough and measurements.
