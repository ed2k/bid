# Bid: Autonomous Self-Improving Contract Bridge Bidding Engine

**Bid** is a contract bridge AI and research platform designed to **continuously discover, refine, and invent bidding conventions**. 

Rather than relying on static, brittle rule tables or black-box policies, `bid` implements a closed-loop **continuous improvement pipeline**: it starts from baseline bidding rules, actively hunts for ambiguous or unhandled states, uses high-budget model-conditioned Monte Carlo search (RBMBMC + PIDM) as a teacher, distills those insights into localized decision-net refinements (ID3), co-trains the partnership in parallel, and synthesizes new communication protocols using Value of Information (VOI) and adversarial signaling theory.

---

### 🎓 Learning Curriculum & System Design Guides
Whether you are designing a custom bidding system or studying the computer science behind bridge AI:
- 📖 **[Bidding System Design Guide](docs/DESIGNING_A_BID_SYSTEM.md)**: Step-by-step tutorial on drafting DSL rules, diagnosing gaps, A/B benchmarking, SDS two-hand validation, and neural distillation.
- ♟️ **[Track 1: Game Theory & Signaling](docs/LEARNING_GAME_THEORY.md)**: Imperfect information, Bayesian updating, cooperative-adversarial signaling, competitive VOI, and scoring math.
- 🌲 **[Track 2: Machine Learning & Search](docs/LEARNING_MACHINE_LEARNING.md)**: RBMBMC Monte Carlo sampling, PIDM lookahead, ID3 speedup learning, and active learning.
- 🧠 **[Track 3: LLMs & Chain-of-Thought](docs/LEARNING_LLM_AND_COT.md)**: Decoder-only Transformers from scratch, knowledge distillation, CoT reasoning, batched decoding, and neuro-symbolic verification.
- ⚡ **[Double Dummy Solver (DDS) Guide](docs/BUILDING_AND_USING_DDS.md)**: Building and using Bo Haglund's native C++ solver (`libdds`) for exact trick calculations and par analysis.
- 🗺️ **[Full Curriculum Roadmap](docs/CURRICULUM.md)**: Complete learning track index and code walkthroughs.

---
## 🔄 The Continuous Improvement Pipeline

The core goal of `bid` is to run an autonomous flywheel that iteratively improves both bidding policy and belief-state inference:

```
                            ┌─────────────────────────────────┐
                            │    1. Active State Discovery    │
                            │  • Rule Ambiguities (|φ(s)| > 1)│
                            │  • Rare/Stratified Distributions│
                            │  • Policy-Search Disagreements  │
                            └────────────────┬────────────────┘
                                             │
                                             ▼
┌──────────────────────────────┐   ┌─────────────────────────────────┐
│  3. Speedup Rule Refinement  │   │   2. Expensive PIDM Teacher     │
│  • ID3 Information Gain      │◄──┤ • RBMBMC World Sampling         │
│  • Local Intersection Nodes  │   │ • Nested Opponent/Partner Sims  │
│  • Fast O(1) Policy Execution│   │ • Duplicate Bridge / DD Scoring │
└──────────────┬───────────────┘   └─────────────────────────────────┘
               │
               ▼
┌──────────────────────────────┐   ┌─────────────────────────────────┐
│   4. Partner Co-Training     │   │   5. Convention Invention & VOI │
│ • Parallel Model Exchange    │──►│ • Protocol State Machines       │
│ • Tighter Belief Filtering   │   │ • Value of Information (VOI)    │
│ • Speed & Accuracy Feedback  │   │ • Adversarial Signal Concealment│
└──────────────────────────────┘   └─────────────────────────────────┘
```

---

## 🌟 How the Pipeline Works

### 1. Active State Discovery & Stratified Generation
Standard random dealing rarely encounters critical rare shapes (e.g. 9-card suits, 22+ HCP, extreme singletons). The pipeline actively finds states worth learning:
- **`StratifiedDealGenerator`**: Deliberately samples underrepresented hand strata (suit length, HCP bands, freak distributions).
- **`ExperienceBuffer`**: Prioritizes states where rules disagree, policy confidence is low, or high-value utility gaps exist.
- **`ExploratoryCandidateGenerator`**: Expands candidate actions beyond expert rules with adaptive exploration ($\epsilon$).

### 2. Model-Conditioned Teacher: RBMBMC + PIDM
When a decision is uncertain ($|\phi(s)| > 1$), the engine launches a high-budget search:
- **Resource-Bounded Model-Based Monte Carlo (RBMBMC)**: Replays the auction backwards, filtering out worlds that are inconsistent with historical calls according to player behavioral models.
- **Partial Information Decision Making (PIDM)**: Recursively simulates partner and opponent reactions in each sampled world, evaluating outcomes with double-dummy trick estimation and duplicate bridge scoring.

### 3. Local Speedup Learning & Exception Refinement
The expensive search acts as a teacher to refine the fast rule net:
- **`ID3DecisionTree`**: Calculates Shannon Information Gain across 250+ bridge features (HCP, suit lengths, controls, LTC, honor topology) to find the exact feature that separates competing actions.
- **Intersection Nodes**: The learned classifier is attached *locally* to the intersection of the conflicting rules (e.g., $R_{\text{1NT}} \cap R_{\text{1H}}$ for 16 HCP 5-heart balanced hands). The general rules outside the conflict remain intact.

### 4. Partner Co-Training Loop
North and South learn in parallel and periodically exchange their refined decision nets:
- When South learns a more precise rule, South's refined model constrains North's RBMBMC world sampling.
- Fewer inconsistent worlds mean North's search becomes both **faster** and **more accurate**, creating a compounding feedback loop.

### 5. Convention Invention & Information Protocols
The system treats bridge conventions as **imperative communication programs**:
- **Semantic Primitives**: Synthesizes sequences using `SHOW`, `ASK`, `COMMAND`, `TRANSFER`, `ENCODE`, `CONCEAL`, `AMBIGUATE`, and `POOL`.
- **Value of Information (VOI)**: Evaluates whether a question (like Stayman major query or Blackwood ace ask) provides positive expected payoff:
  $$\text{VOI}(Q) = \mathbb{E}[\max_a V(a \mid Q)] - \max_a \mathbb{E}[V(a)]$$
- **Adversarial Signaling**: Measures net information payoff against defenders $(\Delta V_{\text{partner}} - \Delta V_{\text{opponent}})$, allowing the system to discover strategic pooling, concealment, and gambling bids.

### 6. Opponent-Aggressiveness Awareness
Competitiveness is conditioned on **how the opponents behave**, not merely whether they have bid. `BridgeFeatures.extract_auction_features` computes a seat-correct opponent-style profile on every decision:

| Feature | Meaning |
|---|---|
| `opp_bid_count`, `competition_level` | intensity of the contested auction |
| `opp_preempted`, `opp_first_bid_level` | opponents opened pre-emptively (weak-hand signal; first opp bid at level ≥ 3, or a 2-suit opening early in the auction) |
| `opp_strength_class` | `weak` / `unknown` / `strong`, inferred from opponents' bidding shape |
| `auction_altitude`, `auction_contested` | how high the auction has escalated and whether both sides are in |
| `opp_fit_shown`, `our_fit_shown` | fit inference: a side is "shown a fit" when **both** of its members bid the same suit |
| `is_unfavorable_vuln`, `vuln_pressure` | the previously missing unfavorable-vulnerability case (`favorable` / `unfavorable` / `equal`) |
| `partner_rebid` | partner voluntarily re-entered the auction |
| `opp_suit_stoppers`, `has_stopper` | NT stopper quality (A=2.0, guarded K=1.0, guarded Q=0.5) in every suit the opponents have bid |
| `partner_last_bid_strain`, `support_in_partner_suit` | partner's most recent suit bid and my holding length in it — the basis for support raises |

These feed the symbolic system two ways:

1. **Curated rules** — the flywheel's `AGGRESSION` patch family (`flywheel.py`) uses them for vuln-gated preempt pushes (`FW_PREEMPT_PUSH_*`), altitude discipline against strong opponents at unfavorable vulnerability (`FW_ALTITUDE_DISCIPLINE`), and light competition against detected weak pre-empters with a shown fit (`FW_VS_WEAK_COMPETE`).
2. **Automatic propagation** — `serialize_features` copies all of them into every trace row, so the CoT student's tokenizer vocabulary and training distribution pick them up on the next `refresh_student` cycle with zero extra work; the threshold values themselves are auto-tuned by the flywheel's `tighten`/`loosen` mutation operators like any other numeric bound.


---

## 🔁 Operating the Teacher ↔ Student Loops (Runbook)

This section documents the *actual* self-improvement loops as implemented —
exact commands, what each stage does automatically, which decisions stay with
a human, and where every artifact lands.

### The loops at a glance

```
   ┌─────────────────────────── TEACHER (symbolic) ───────────────────────────┐
   │  flywheel.py / autoloop.py                                               │
   │  patch pool → paired hill-climb vs DDS par → val-seed gate → SDS gate    │
   │  → SAVED v(n+1) in system/improved_system.dsl (+ archive, state JSON)    │
   └──────────────┬───────────────────────────────────────────▲───────────────┘
                  │ new DSL hash                               │ arb_student_right
                  ▼                                            │ (student found a
   ┌─────────────────────────── STUDENT (neural) ─────────────┴───────────┐   │
   │  refresh_student.py                                                  │   │
   │  trace_factory → build_cot_dataset (merged w/ disagreements)         │   │
   │  → train candidate → eval-val gate vs incumbent → promote/archive    │   │
   └──────────────┬───────────────────────────────────────────────────────┘   │
                  │ disagreements.jsonl ──────────────────────────────────────┘
   ┌──────────────▼──────────── RL / SEARCH (break the imitation ceiling) ───┐
   │  rl_finetune.py        (REINFORCE on DDS-scored self-play, gated)       │
   │  convention_search.py  (protocol mutation hill-climb, report only)      │
   │  player_model.py       (soft P(call|ctx) for RBMBMC world filtering)    │
   └─────────────────────────────────────────────────────────────────────────┘
```

### Loop A — improve the teacher (symbolic DSL)

```bash
python3 -m bid.flywheel --deals 96 --rounds 2 --sds
# or CLI script: bid-flywheel --deals 96 --rounds 2 --sds
```

Per round, automatically:
1. Plays the deal set vs native DDS par, dumps worst flaws (`OVERBID_DOWN`,
   `MISSED_SLAM`, `SOFT_DEFENSE`, ...) via `ParDiagnosticEngine`.
2. Builds a patch pool: curated families (`CURATED` dict in `flywheel.py`),
   diagnostic-corrective rules, ungated-rule gating variants, broad-rule
   drops, and `tighten`/`loosen` threshold mutations of every numeric bound.
3. Greedy hill-climb: applies the best measured patch, re-screens, repeats.
4. **Validation gate** on two disjoint val seeds (7 and 13): any val
   regression → the round is *not saved* and the failed patch signature is
   cached (won't be retried).
5. **SDS two-hand gate** (`--sds`): re-scores accepted auctions from the
   declarer+dummy two-hand view; rejects patches whose realistic-info score
   regressed.
6. On success: `improved_system.dsl` saved, previous version archived to
   `system/history/improved_system_vN.dsl`, `flywheel_state.json` bumped
   (version, applied list, failed-signature cache).

Variants:
```bash
python3 -m bid.autoloop --tiers 24,96,384        # long-running:
# tiered screening with statistical escalation, automatic champion
# promotion to system/champion_system.dsl, progress JSON under debug/
python3 -m bid.flywheel --deals 96 --rounds 2 --sds-primary
# hill-climb directly on the SDS objective instead of DDS-par score
python3 -m bid.autoloop --policy-prior data/cot_model/ckpt.pt
# policy-guided PIDM pruning using the trained student as a prior
```

Long-run hygiene (both `flywheel.py` and `autoloop.py`):
- **Eval-seed rotation** — screening/validation seeds derive from the current
  system version, so different saved versions are gated on different random
  draws (within one cycle base and candidate still share a seed, keeping the
  paired deltas honest).
- **Anchor ledger** — every version is also scored on a frozen, never-reused
  anchor deal set (`anchor` map in `flywheel_state.json`); a flat or falling
  anchor ledger means gains were seed-fitting, not real.
- **Failure-signature expiry** — failed patch candidates are cached with the
  version they failed at and become retryable after `FAIL_EXPIRY_VERSIONS`
  (8) saved versions; the system underneath them changed, so the pool never
  permanently empties.

**Human involvement:** choosing the deal budget (24 deals ≈ 10 min,
96 deals + SDS ≈ 3.3 h); occasionally re-running with fresh eval seeds to
confirm gains generalize; writing *new idea families* (see
"Adding an idea to the teacher" below).

---

### Loop B — refresh the student (neural CoT model)

```bash
python3 -m bid.refresh_student                  # auto-detects changes
python3 -m bid.refresh_student --boards 500 --epochs 5   # production scale
```

Automatically, in order:
1. **Freshness check**: `sha256(improved_system.dsl)` vs
   `data/traces/traces.meta.json` (→ regenerate traces when the teacher
   changed) and corpus sha vs `dataset.json` meta (→ rebuild dataset when
   mined rows arrived). Skips cleanly when nothing changed.
2. **Regenerate** the corpus with `trace_factory.py` (PIDM-labeled auctions
   of the *current* DSL; constraint-invariant asserted per row), then merge
   `data/traces/disagreements.jsonl` (Loop C output) into
   `corpus_combined.jsonl` and build the tokenized dataset.
3. **Train a candidate** (`python3 -m bid.cot_model train`, MPS/CUDA auto) — the
   incumbent `ckpt.pt` is never touched during training.
4. **Gate**: eval-val the candidate *and* the incumbent on the new val
   split; promote only if BID accuracy doesn't regress beyond
   `--tolerance`. Incompatible incumbent (vocab change) → the absolute
   `--min-bid` floor (default 25%) decides; weaker candidates are archived
   instead of promoted.
5. Record every decision in `data/cot_model/student_state.json`
   (hashes, scores, promoted/rejected, elapsed).

Typical durations: 200 boards end-to-end ≈ 12 min; 500 boards + 5 epochs ≈ 32 min.
Artifacts: `ckpt.pt` (+`.vocab.json`), `rejected/…` archives,
`refresh_last.log`, `student_state.json`.

**Human involvement:** choosing scale (`--boards`, `--epochs`); interpreting
a promotion that happened via the "no comparable incumbent" fallback
(vocabulary grew — old scores aren't comparable; spot-check with
`python3 -m bid.cot_model eval-val` or an arena h2h).

### Loop C — mine student ↔ teacher disagreements (feedback into both)

```bash
python3 -m bid.mine_disagreements --boards 200
```

Automatically: replays DSL-system auctions, queries the student at every
non-forced decision, and where they disagree runs a **high-budget PIDM
referee**; the verdict is written as a schema-identical trace row (tagged
`ARB_SYSTEM` / `ARB_STUDENT_LEGAL` / `ARB_THIRD` in `all_matched`), deduped
and appended to `data/traces/disagreements.jsonl` with stats in
`disagreements.meta.json`.

How to read the stats:
- `arb_system_right` — student was wrong; the row relabels it (better-than-
  corpus labels: the referee has a bigger search budget than the corpus
  labeler).
- `arb_student_right` — **the student flagged a position where the deep
  search agrees with it against the DSL** → a candidate *teacher bug*;
  feed those boards to the flywheel (or add a curated patch family) for the
  next teacher round.
- `arb_new_call` — neither player's choice survived deeper search; these
  labels are new information.

Rows are consumed automatically by `refresh_student.py` on the next cycle.
**Human involvement:** sizing the run; inspecting `arb_student_right` boards
(`explanation.all_matched` tag) for teacher improvements.

### Loop D — RL fine-tuning (student beyond its teacher)

```bash
python3 -m bid.rl_finetune --boards 64 --epochs 3 --tolerance 0.5
```

Automatically: student plays N/S against the DSL's E/W; each decision is
*samples* (temperature) with a legality check (illegal → teacher fallback,
no gradient); terminal contracts are scored by native DDS from N/S's
perspective and converted to IMPs; REINFORCE updates
(`loss = -advantage · Σ log π`) with batch-normalized advantages; the
resulting candidate is **eval-val gated** against the base checkpoint
(`--tolerance`, `--no-gate` to skip) and archived under `rejected_rl/` on
failure.

**Human involvement:** this is the only loop whose output *intentionally
diverges* from the teacher — always A/B the gated checkpoint in
`arena.py`/`ab_engine.py` at 100+ boards before adopting it as `ckpt.pt`.

### Loop E — convention invention search

```bash
python3 -m bid.convention_search --boards 96 --rounds 3
```

Automatically: mutates seed protocols (Stayman, Transfers, Blackwood, ...) —
feature retargeting, range shifts, response swaps, step drops — compiles each
candidate into DSL clones, hill-climbs on a train tier, and confirms on a
disjoint validation seed. Writes `data/conventions/search_report.json`.

**Human involvement (required):** accepted conventions are **never**
auto-installed into `improved_system.dsl`. Review the report (watch the
validation z-score — small boards produce inconclusive `escalate` verdicts),
then either promote the rules by hand, or express them as a curated flywheel
family so the standard gates apply.

### Loop F — unattended continuous operation (the meta-loop)

```bash
python3 -m bid.continuous                      # run until stopped
python3 -m bid.continuous --max-cycles 5 --sds-gate --rl-every 3
```

`continuous.py` chains the loops above into one repeating cycle — this is
what makes improvement actually *continuous* instead of five scripts a human
must schedule:

1. **teacher**: a bounded `autoloop` run (`--teacher-cycles` screening cycles).
2. **student**: `refresh_student` (auto-detects the new DSL hash, regenerates
   corpus/dataset, retrains + gates the student, and retrains the player
   model when the corpus changed).
3. **mine**: `mine_disagreements` — its `disagreements.jsonl` is merged into
   the *next* student corpus by step 2, closing the loop.
4. every `--rl-every` cycles: `rl_finetune` (off-teacher; A/B before adopting).

Each stage runs as a subprocess of the runbook script, so every per-loop gate
still applies. State persists in `system/continuous_state.json`
(`{"cycle", "next_stage"}`); a crash or Ctrl-C resumes at the interrupted
stage, and a stage failing `--max-stage-fails` consecutive cycles aborts the
loop so nothing spins unattended. Consolidated log: `debug/continuous.log`.

**Human involvement:** only budgets (`--boards`, `--tiers`, `--rl-every`),
and watching the mining summary — when `arb_student_right > 0` the student
found a position where deep search contradicts the teacher (candidate
teacher bug worth a curated patch family).

### Supporting tooling

```bash
python3 -m bid.player_model train    # soft P(call|ctx) -> data/player_models/
# auto-attached to the RBMBMC sampler by autoloop.py when present;
# refresh_student.py re-trains it automatically whenever the corpus changes
# (recorded corpus sha in call_model.json meta drives the freshness check)
```

### Human review UI (static browser app)

```bash
python3 -m bid.web_export          # snapshot repo state -> web/review_data.js
python3 -m http.server 8765 -d web # then open http://127.0.0.1:8765/
```

`web/` is a fully static, no-build review UI (pattern follows `../dds/web`
and `../ben/web`): vanilla JS modules, no framework, no server-side logic.

- **Auction Review** — generate a deal, **paste your own four hands**
  (`Load board…` accepts `SAK2 HKQJ DQJ9 C432`, dotted `AKQJ.T98.765.432`,
  or the corpus `S : A K 2 …` format, with 13-card/duplicate validation), or
  step through every decision of the *current* DSL system in the browser.
  **Pick the bidding system per team** (`N/S system` / `E/W system` selects:
  the evolved Improved system, the auto-evolved Champion, Precision, Blue
  Club, or GIB) and review partnerships against each other, arena-style.
  The inspector shows the extracted
  features, every matched rule with per-condition ✓/✗, the candidate set
  φ(s), legality filtering, and the deterministic system pick; you can bid
  manually from the bidding box (any bridge-legal call) to probe the system.
  Both engine families are ported: the DecisionNet DSL (improved/champion)
  and the legacy translator engine with its constraint matcher and SEQUENCE
  trigger algorithm (precision/blue_club/gib, conventions inlined by the
  exporter); JS rule counts are asserted equal to Python's own parsers in
  `tests/web/engine_test.mjs`.
- **Replay review** — load any sampled corpus board or student↔teacher
  disagreement; each recorded call is re-verified live against the re-computed
  candidate set and feature values (`in φ(s) ✓`, `features match Python ✓`),
  with `ARB_STUDENT_LEGAL` teacher-bug rows one click away.
- **Rules Editor** — view and edit any embedded system's DSL in the browser,
  apply the edited version to a team (the auction review restarts with your
  rules, so you can probe behaviour changes decision-by-decision), and
  **download the edited DSL as a `.dsl` file** to drop into `system/` — a
  human-in-the-loop path back into the flywheel. Edits are validated by the
  same parsers; broken DSL is reported, never applied.
- **Student Lab** — an in-browser student loop at demo scale: generate a
  corpus by letting any loaded (or hand-edited) system bid N boards with the
  JS engine, train a small seeded MLP (27 features → 64 → 32 → bid vocab,
  pure JS, no dependencies) to imitate the teacher, inspect held-out accuracy
  vs the majority baseline, and **save the student locally** as
  `student.json`. A **default student ships with the UI**
  (`web/student_default.js`, auto-loaded at boot, ~74% vs 61% baseline on the
  snapshot teacher) — regenerate it against a refreshed snapshot with
  `node web/build_default_student.mjs`. Saved students can be reloaded and
  evaluated against fresh corpora at any time. This complements (not
  replaces) the production 5.5M-param CoT student, which still trains via
  `refresh_student.py` (Loop B).
- **Loop Data** — the teacher's anchor ledger and applied patches, the
  student's gate history, and mining statistics.
- **Double-dummy tables** come from the vendored WASM DDS
  (`../dds/web` build, MIT) — solved live in ~0.4 s per deal; the snapshot
  also embeds export-time native-`libdds` tables as a fallback for
  environments where the WASM module can't load (no `SharedArrayBuffer`).

The browser engine (`web/objects.js`, `features.js`, `bid_dsl.js`,
`bid_net.js`, `auction.js`) is a hand-ported, behaviour-exact copy of
`src/bid`'s DSL parser, feature extractor, DecisionNet evaluation, and
auction rules. It is cross-validated against Python-recorded ground truth by
`tests/web/engine_test.mjs` (feature parity + candidate-set equality on every
recorded corpus row), so what you review in the browser is what the Python
loops actually compute.

### Adding an idea to the teacher

The flywheel can only hill-climb over rules that are *expressible* and
*families that exist*. New capability enters the loop in two steps:

1. **Feature** (agent/human): add a deterministic computation to
   `BridgeFeatures.extract_auction_features` in `bid/features.py`
   (e.g., `support_in_partner_suit`, `opp_suit_stoppers`). Sanity-check it
   against a synthetic auction and `tests/test_features_and_state.py`.
   Features propagate to traces/dataset automatically.
2. **Patch family** (agent/human): write a `p_<name>(net)` function in
   `flywheel.py` that emits `DecisionNetRule`s gated on the new features,
   and register it in the `CURATED` dict. From then on the flywheel
   screens, tunes thresholds, and val/SDS-gates it like any other patch.

Campaign record so far: `SUPPORT` accepted (v23, +23.7), `NT_SAFETY`
rejected (−40.4), `AGGRESSION` positive standalone but subsumed by TKO
patches — every rejection is cached by signature and never retried.

### What stays with a human

| Decision | Why |
|---|---|
| Run budgets (deals/rounds/tiers, hours) | statistics-vs-time tradeoff |
| New features & curated families | domain judgment; the loop can't invent features itself |
| Fresh-eval-seed spot checks | guards against seed-fitting across many saved versions |
| Convention promotions from `search_report.json` | statistical gate is the script's, but adoption is a system-design choice |
| RL checkpoint adoption | intentionally off-teacher; A/B in the arena first |
| Interpreting "no comparable incumbent" promotions | vocab changed → run an arena h2h to confirm |

### Command cheat sheet

| Script | Loop | Purpose | Typical run | Key artifacts |
|---|---|---|---|---|
| `continuous.py` | F | unattended A→B→C chaining with stage resume | days/weeks | `continuous_state.json`, `debug/continuous.log` |
| `flywheel.py --deals N --rounds R --sds` | A | patch hill-climb on the DSL | 10 min – 3.3 h | `improved_system.dsl`, `history/`, `flywheel_state.json` |
| `autoloop.py --tiers 24,96,384 [--policy-prior ckpt]` | A | unattended staged loop + champion promotion | hours | `champion_system.dsl`, `debug/progress.json` |
| `refresh_student.py [--boards B --epochs E]` | B | regen corpus/dataset, train + gate student | 12–32 min | `ckpt.pt`, `student_state.json` |
| `mine_disagreements.py --boards N` | C | student-vs-teacher arbitration rows | ~3 s/board | `disagreements.jsonl` |
| `rl_finetune.py --boards N [--tolerance t]` | D | REINFORCE beyond the teacher | ~1 min/4 boards | `ckpt_rl.pt` + gate |
| `convention_search.py --boards N` | E | protocol mutation search | ~2 min/12 boards | `search_report.json` |
| `player_model.py train` | support | soft world-consistency model | seconds | `call_model.json` |
| `web_export.py [--boards N]` | review | snapshot repo state for the browser UI | ~1–2 min (native DD solves) | `web/review_data.js` |

---

## 🚀 Quick Start

### Installation

Python 3.9+ is required. Clone the repository and install in editable mode:

```bash
git clone https://github.com/ed2k/bid.git
cd bid
python3 -m venv .venv && source .venv/bin/activate
pip install -e .
```

This installs all dependencies (`torch`, `numpy<2`) and registers CLI console scripts (`bid-flywheel`, `bid-autoloop`, `bid-continuous`, `bid-refresh-student`, `bid-mine-disagreements`, `bid-rl-finetune`, `bid-convention-search`).

You can execute any loop using `python3 -m bid.<module>` or directly via CLI aliases:

```bash
python3 -m bid.flywheel --deals 96 --rounds 2 --sds
# or CLI script:
bid-flywheel --deals 96 --rounds 2 --sds
```

### The self-improvement loops

The primary workflow is the six-loop system documented in the
**[Runbook](#-operating-the-teacher--student-loops-runbook)** above:
`continuous.py` (unattended chaining of everything below) or manually:
flywheel (teacher) → `refresh_student` (student) →
`mine_disagreements` (feedback) → `rl_finetune` /
`convention_search` (beyond-imitation). Start there.

### Legacy: co-training pipeline demo

`main.py` drives the older invention/co-training path directly:

```bash
python3 -m bid.main --iterations 10 --duration 120 --states 8 --deals 25
```

This demonstrates `BidInventionEngine` co-training and diagnostic refinement
in one process, but the runbook loops supersede it for real improvement
work (they add validation gates, versioning, and the neural student).

### Finding the Best Bidding System (World Championship Tournament)

Run a multi-board round-robin tournament (evaluating competing archetypes like Precision Strong Club, Modern 2/1 GF, SAYC, and Autonomous Evolved AI) to find the champion system:

```bash
python3 -m bid.main --tournament --boards 50
```

The champion bidding system code is automatically persisted to `system/champion_system.dsl`.

---

## 🧪 Pipeline Usage Examples

These are **component-level API examples** — the building blocks the runbook
loops orchestrate. For the full automated workflow, use the runbook scripts
(`flywheel.py`, `refresh_student.py`, `mine_disagreements.py`, ...).

### 1. Running the Continuous Co-Training Loop

> Loop A (`flywheel.py`/`autoloop.py`) automates this at system scale with
> validation gates; the API below shows the underlying mechanism.

```python
from bid.invention import BidInventionEngine

# Initialize engine with RBMBMC sampler and PIDM lookahead
engine = BidInventionEngine(sample_size=3, max_lookahead_depth=2)

# Run iterative parallel co-training rounds between North and South
results = engine.run_co_training(rounds=3, states_per_round=10)

for round_info in results["rounds"]:
    print(f"Round {round_info['round']}: "
          f"North refined {round_info['north_refinements']} conflict nodes, "
          f"South refined {round_info['south_refinements']} conflict nodes.")
```

### 2. Active Ambiguity Discovery and ID3 Refinement

```python
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.learner import DecisionNetLearner, ID3DecisionTree
from bid.pidm import PIDMEngine
from bid.models import Seat, Call, CallType, Strain, Hand

# 1. Base Decision Net with overlapping rules (1NT vs 1H on 15-17 HCP 5-heart balanced)
net = DecisionNet("PartnerNet")
net.add_rule(DecisionNetRule("R_1NT", Call(CallType.BID, 1, Strain.NT), [
    RuleCondition("hcp", ">=", 15), RuleCondition("hcp", "<=", 17), RuleCondition("is_balanced", "==", True)
]))
net.add_rule(DecisionNetRule("R_1H", Call(CallType.BID, 1, Strain.HEARTS), [
    RuleCondition("hcp", ">=", 12), RuleCondition("hcp", "<=", 21), RuleCondition("heart_len", ">=", 5)
]))

# 2. Learner finds ambiguous states where |φ(s)| > 1 and tags with expensive PIDM teacher
teacher = PIDMEngine()
learner = DecisionNetLearner(teacher)
models = {s: net for s in Seat}

ambiguous_states = learner.find_ambiguous_states(net, target_count=15)
tagged_data = learner.tag_states(ambiguous_states, models)

# 3. ID3 builds local decision tree and attaches directly to intersection node
learner.refine_decision_net(net, tagged_data)

# Now ambiguous hands evaluate in O(1) time without search!
hand = Hand.from_string("SAK4 H76543 DAQ3 CK2")
resolved_call = net.actions(hand, history=[])
print(f"Resolved call: {resolved_call}")
```

### 3. Stratified Rare-Hand Sampling & Experience Buffer

```python
from bid.experience import StratifiedDealGenerator, ExperienceBuffer, PrioritizedExperience
from bid.models import Suit, Seat, Call, CallType, Strain
from bid.sampling import PartialState

# Generate a rare 9-card spade hand directly to avoid Monte Carlo blindspots
rare_hand = StratifiedDealGenerator.generate_hand_with_suit_length(Suit.SPADES, min_length=9)

buffer = ExperienceBuffer(max_capacity=500)
ps = PartialState(Seat.SOUTH, rare_hand, [])

# Calculate priority based on rarity and search disagreement
priority, reason = buffer.calculate_priority(
    rare_hand,
    policy_actions={Call(CallType.BID, 1, Strain.SPADES)},
    teacher_call=Call(CallType.BID, 4, Strain.SPADES),
    value_gap=120.0
)

buffer.add(PrioritizedExperience(ps, {Call(CallType.BID, 1, Strain.SPADES)}, Call(CallType.BID, 4, Strain.SPADES), priority, reason))
print(f"Added state to replay buffer (priority={priority}, reason={reason})")
```

### 4. Synthesizing Conventions & Measuring Value of Information (VOI)

> Loop E (`convention_search.py`) automates search over this protocol space
> with paired arena evaluation; the API below measures a single protocol.

```python
from bid.protocol import ConventionProtocol, ValueOfInformationEvaluator
from bid.pidm import PIDMEngine
from bid.models import Seat, Call, CallType, Strain
from bid.sampling import Deal, PartialState
from bid.eval_vs_dds import load_decision_net_dsl

# Compile a synthesized Stayman protocol (2C ask -> 2D/2H/2S step responses)
stayman = ConventionProtocol.create_stayman()
rules = stayman.compile_to_rules()

# Sample decision points for the opener after partner's Stayman 2C ask:
#   W passes, N opens 1NT, E passes, S bids 2C  ->  it's North's turn
engine = PIDMEngine()
net = load_decision_net_dsl("system/improved_system.dsl")
models = {s: net for s in Seat}
sample_states = []
for _ in range(20):
    deal = Deal.random_deal(dealer=Seat.WEST)
    hist = [Call(CallType.PASS),
            Call(CallType.BID, 1, Strain.NT),     # North opens 1NT
            Call(CallType.PASS),
            Call(CallType.BID, 2, Strain.CLUBS)]  # South asks Stayman
    sample_states.append(PartialState(
        Seat.NORTH, deal.hands[Seat.NORTH], hist,
        deal.dealer, deal.vuln))

voi_eval = ValueOfInformationEvaluator(engine)
voi_score = voi_eval.evaluate_voi(stayman.steps[0], sample_states, models)
print(f"Stayman query VOI: +{voi_score:.2f} IMP-equivalent")
```

---

## 🧪 Running Tests

Install the package in editable mode:
```bash
pip install -e .
```

Run the complete test suite:
```bash
python3 -m unittest discover tests
```

Individual test suites:
```bash
python3 -m unittest tests/test_features_and_state.py
python3 -m unittest tests/test_scoring.py
python3 -m unittest tests/test_rbmbmc_sampling.py
python3 -m unittest tests/test_pidm_lookahead.py
python3 -m unittest tests/test_id3_refinement.py
python3 -m unittest tests/test_cotraining.py
python3 -m unittest tests/test_experience_and_stratified.py
python3 -m unittest tests/test_protocol_synthesis_and_voi.py
python3 -m unittest tests/test_bid_invention_e2e.py
python3 -m unittest tests/test_cot_bidder.py
python3 -m unittest tests/test_sds_scoring.py
python3 -m unittest tests/test_trace_manifest.py
```

> Note: the loop scripts (`bid.flywheel`, `bid.refresh_student`,
> `bid.mine_disagreements`, `bid.rl_finetune`, `bid.convention_search`) are
> validated by their built-in gates (val-seed, SDS, eval-val) rather than
> unit tests; `tests/test_autoloop.py` and `tests/test_trace_manifest.py`
> cover their state/manifest plumbing.

---

## 📂 Project Structure

```
bid/
├── pyproject.toml       # Modern Python packaging & CLI console scripts
├── README.md            # Comprehensive architecture guide & runbook
├── system/              # Bidding system definitions & DSL files (SAYC, Precision, Improved)
├── data/                # traces/, cot_dataset/, cot_model/, player_models/, conventions/
├── web/                 # Static browser review UI (JS engine port + WASM DDS + snapshot)
├── tests/               # Unit and integration test suite (155 tests)
├── research/
│   ├── bid-invention.md # Research document on BIDI, RBMBMC, VOI, and CoT distillation
│   └── experiments/     # Archived diagnostic and one-off experimental scripts
│
└── src/bid/             # Core Python package
    ├── __init__.py
    ├── models.py        # Core domain models: Hand, Card, Call, Seat, Strain, Rank
    ├── features.py      # BridgeFeatures extractor (250+ numerical & auction features)
    ├── scoring.py       # Contract scoring, 24-band IMP scale, trick estimators
    ├── decision_net.py  # DecisionNet, RuleCondition, IntersectionNode, legality filtering
    ├── sampling.py      # Deal, PartialState, RBMBMCSampler, inconsistency scoring
    ├── pidm.py          # PIDMEngine with Monte Carlo lookahead & nested player simulation
    ├── learner.py       # ID3DecisionTree, DecisionNetLearner, intersection refinement
    ├── cotrain.py       # CoTrainer for parallel partner learning & model exchange
    ├── experience.py    # StratifiedDealGenerator, ExperienceBuffer, exploration generator
    ├── protocol.py      # ConventionProtocol, bidirectional & competitive VOI
    ├── invention.py     # BidInventionEngine facade
    ├── engine.py        # Traditional rule-matching engine
    ├── system.py        # BiddingSystem rule engine & convention manager
    ├── translator.py    # DSL rule parser & compiler
    ├── lin.py           # BBO LIN file parser
    ├── constraints.py   # HandConstraints representation
    ├── eval_vs_dds.py   # Deal generation, DSL loading, arena-vs-par evaluation
    ├── diagnostics.py   # ParDiagnosticEngine flaw classification
    ├── sds.py / dds.py  # SDS two-hand scorer & native double-dummy solver interface
    │
    │   # --- Neural Student & Active Learning (CoT) ---
    ├── cot_model.py     # 5.5M decoder-only CoT transformer reasoner
    ├── cot_tokenizer.py # Field-level tokenizer for CoT traces
    ├── cot_bidder.py    # Constrained decoding + verification
    ├── trace_factory.py # PIDM-labeled trace generator from current DSL
    ├── build_cot_dataset.py # Trace corpus -> tokenized dataset
    ├── player_model.py  # Learned soft P(call|ctx) for RBMBMC world filtering
    │
    │   # --- Self-Improvement Loops (Orchestrators) ---
    ├── flywheel.py      # Loop A: DSL patch hill-climb (curated/diag/gate/mutation pool)
    ├── autoloop.py      # Loop A: unattended staged loop + champion promotion
    ├── continuous.py    # Loop F: meta-orchestrator chaining A→B→C with stage resume
    ├── refresh_student.py # Loop B: freshness -> regen -> train -> gate -> promote
    ├── mine_disagreements.py # Loop C: student-vs-teacher disputes arbitrated by heavy PIDM
    ├── rl_finetune.py   # Loop D: REINFORCE self-play fine-tuning with eval gate
    ├── convention_search.py # Loop E: protocol mutation hill-climb
    └── web_export.py    # Human-review UI snapshot exporter (repo state -> web/)
```

---

## 📚 References & Background

- **Amit & Markovitch (2006)**: *"Learning to Bid in Bridge"*, Machine Learning 63(3), 287–327.
- **[research/bid-invention.md](file:///Users/admin/Documents/GitHub/bid/research/bid-invention.md)**: In-depth analysis of BIDI reconstruction, RBMBMC vs PIMC, speedup learning, active/stratified state discovery, and convention protocol synthesis.
