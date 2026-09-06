# Bid Review UI — parity with the Python engine

Static browser review UI. This file records what the web version implements
and, just as importantly, what it does **not**.

## Implemented (parity with Python, cross-validated)

| Capability | Python source | Web module |
|---|---|---|
| DSL parsing (block + one-line RULE, INTERSECTION) | `eval_vs_dds.load_decision_net_dsl` | `bid_dsl.js` |
| Legacy translator DSL + SEQUENCE triggers + constraint matcher | `translator.py`, `system.py`, `constraints.py` | `system_dsl.js` |
| DecisionNet evaluation (priority-ordered φ(s), legality, X/XX rules) | `decision_net.py` | `bid_net.js` |
| Feature extraction (99 of 102 serialized keys) | `features.py` | `features.js` |
| Auction driver, auction-over, contract/declarer extraction | `sampling.py`, `arena.py` | `auction.js` |
| Duplicate bridge scoring (making/doubled/undertricks, exact) | `scoring.py::score` | `sds.js::contractScore` |
| SDS two-hand PIMC (uniform world sampling + DD solves) | `sds.py::SDSScorer` (uniform path) | `sds.js::analyze` |
| Double-dummy tables + par | `dds.py` (native libdds) | vendored WASM DDS / embedded native tables |
| Rule priority semantics, duplicate-rule protection, export round-trip | `decision_net.py` | `bid_dsl.js`, `bid_net.js` |
| Lint checks (duplicates, contradictions, shadowing) | `lint_dsl.py` | mirrored in `engine_test.mjs` |
| IMP scale (`diff_to_imps`) | `scoring.py` | `sds.js::scoreToImp` |
| Flaw diagnostics (OVERBID_DOWN, MISSED_GAME/SLAM, SOFT_DEFENSE, TAKEOUT_PASS) | `diagnostics.py` | `diagnostics.js` (per-board panel + advice) |
| Dual-room duplicate-scored match with IMPs | `arena.py::play_match` | Lab "A/B vs teacher" + **"Team contest"** round robin over all systems (Python-computed boards, exact-DD scoring, WBF IMP scale) |
| Belief inference (`estimate_deal` + pass carving) | `engine.py`, `constraints.py` | `belief.js` (legacy systems; shown per hidden seat) |
| ID3 speedup learning (ambiguity resolution) | `learner.py` | `id3.js` (Lab button; refinements attach to the live net) |
| Stratified dealing (rare shapes) | `experience.py` | Lab "Dealing" select (22+ HCP / 8+ suit / void) |
| PIMC bid selection (PIDM-lite) | `pidm.py` | `pidm.js` — opt-in "PIDM pick" toggle (WASM DDS required) |
| SDS auction-conditioned elite worlds | `sds.py::_select_consistent` | `sds.js::analyze({history, engineFor, factor})` |
| Features (all 102 serialized keys) | `features.py` | `features.js` |

Parity is enforced by `tests/web/engine_test.mjs`: feature-by-feature equality
and candidate-set equality against recorded Python ground truth, rule-count
equality against `python_rule_count`, and scoring parity against
`scoring.score`.

## Partially implemented (simplified on purpose)

* **Automatic bid selection** — the web's "system pick" is a deterministic
  priority heuristic (`bid_net.autoSelect`). Python auctions are decided by
  the **PIDM search** (`pidm.py`: RBMBMC world sampling + lookahead + DDS
  evaluation), so Python's actual chosen calls can differ wherever more than
  one candidate is viable. This is the single biggest behavioural gap.
* **SDS world conditioning** — Python's `SDSScorer` can select worlds most
  consistent with the observed auction (RBMBMC-style elite filtering via
  `calculate_inconsistency`, `condition_factor`). The web samples worlds
  uniformly from the declarer+dummy view.
* **Corpus generation for the Student Lab** — labels come from the priority
  pick, not PIDM; Python's `trace_factory.py` labels with PIDM. Also no
  stratified dealing (`experience.py` rare-shape generator) — web deals are
  uniform.
* **`Engine.estimate_deal` belief inference** (incl. pass inference via
  `lower_bounds`/`cap_above`) — Python-only; the web does not build per-seat
  constraint estimates from the auction.
* **Features**: 99/102 keys — `total_points`, `quick_tricks`,
  `losing_trick_count` are not in the JS feature dict (legacy TP constraints
  still match exactly via their own ported `totalPoints`).

## Still not implemented in the web version

* **Automated improvement loops** — `flywheel.py`/`autoloop.py` patch-pool
  hill-climbing with val-seed/SDS gates and champion promotion, and
  `continuous.py` orchestration. The browser covers the human half (review,
  edit, export) but not unattended mutation search.
* **CoT transformer TRAINING** (`cot_model.py` train,
  `build_cot_dataset.py`, `refresh_student.py` gating) — training stays in
  Python, but the **trained transformer itself now RUNS in the browser**:
  `python3 -m bid.web_export` (or `python3 -m bid.cot_export_web`) exports
  the checkpoint's weights to `web/models/cot/` (FP32, ~20 MB) and
  `cot_model.js` runs the real 5M-param student as a seatable system
  ("CoT student" in the team selects) with its generated chain of thought
  shown per decision, legality-constrained like `cot_bidder.py`. Weight
  parity is enforced against the Python forward in `engine_test.mjs`.
* **RL fine-tuning** (`rl_finetune.py`) and **convention invention/VOI**
  (`protocol.py`, `invention.py`, `convention_search.py`) — research loops,
  not review surfaces.
* **CLI/plumbing** — BBO LIN import (`lin.py`), `export_results.py`,
  `system_identifier.py`, `calculate.py`, `optimizer.py` preset generators
  (their DSL outputs are loadable), `pipeline.py`/`main.py` demos,
  `engine_budget.py`, `ab_engine.py` (the web A/B supersedes it),
  `explain_board.py` (the web UI supersedes it).

## Deliberately out of scope

Training or running the production CoT transformer, unattended system
mutation, and native-library dependency: the browser stays static, seeded,
and dependency-free (WASM DDS vendored; everything else hand-ported and
cross-validated).
