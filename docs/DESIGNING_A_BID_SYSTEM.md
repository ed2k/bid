# Designing a New Bidding System: End-to-End Guide

This guide walks you through designing, benchmarking, synthesizing, and optimizing a custom contract bridge bidding system using the tools in this repository.

---

## 1. System Architecture & Mental Model

The repository provides a complete pipeline from declarative system specification to autonomous search and neural distillation:

```text
  ┌────────────────────────────────────────────────────────┐
  │ 1. DSL Specification (system/my_system.dsl)            │
  │    Declarative rules: OPEN, RESPONSE, SEQUENCE, DEFENSE│
  └──────────────────────────┬─────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────┐
  │ 2. Compilation & Linting (SystemTranslator)            │
  │    Parses AST, checks priority, diagnoses bid gaps     │
  └──────────────────────────┬─────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────┐
  │ 3. Rigorous Evaluation                                 │
  │    • Double Dummy Par: eval_vs_dds (IMP loss vs par)   │
  │    • Head-to-Head Match: ab_engine (duplicate pairs)   │
  │    • Imperfect Information: sds (two-hand realism)     │
  └──────────────────────────┬─────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────┐
  │ 4. Search & Autonomous Optimization                    │
  │    • Convention Search with Competitive VOI            │
  │    • Autonomous Flywheel (autoloop.py / flywheel.py)   │
  └──────────────────────────┬─────────────────────────────┘
                             │
                             ▼
  ┌────────────────────────────────────────────────────────┐
  │ 5. Neural Reasoning Distillation (CoT Student)         │
  │    • Symbolic Trace Generation (trace_factory)         │
  │    • Transformer Training & Active Learning Gating     │
  └────────────────────────────────────────────────────────┘
```

---

## 2. Step 1: Writing Your System in DSL

Bidding systems in this repository are specified using an expressive Domain-Specific Language (DSL) stored in `system/*.dsl` files.

### 2.1 Rule Structure
Every rule defines an action (`OPEN`, `RESPONSE`, `SEQUENCE`, or `DEFENSE`), a priority integer (higher executes first), and logical conditions.

```dsl
SYSTEM "MyCustomSystem"

# 1. Opening Bids
OPEN 1NT PRIO 20 IF hcp >= 15 AND hcp <= 17 AND balanced == True
OPEN 1S  PRIO 15 IF hcp >= 12 AND spades >= 5 AND spades >= hearts
OPEN 1H  PRIO 15 IF hcp >= 12 AND hearts >= 5
OPEN 1D  PRIO 10 IF hcp >= 12 AND diamonds >= 4
OPEN 1C  PRIO 5  IF hcp >= 12
OPEN PASS PRIO 1 IF True

# 2. Responses to Openings
RESPONSE 2C TO 1NT PRIO 30 IF hcp >= 8 AND (hearts == 4 OR spades == 4)  # Stayman
RESPONSE 2D TO 1NT PRIO 25 IF hearts >= 5                               # Jacoby Transfer to Hearts
RESPONSE 2H TO 1NT PRIO 25 IF spades >= 5                               # Jacoby Transfer to Spades
RESPONSE 3NT TO 1NT PRIO 10 IF hcp >= 10 AND hcp <= 15 AND balanced == True

# 3. Specific Sequences
SEQUENCE 2H AFTER "1NT - 2D" PRIO 50 IF True                            # Complete Transfer
SEQUENCE 2S AFTER "1NT - 2H" PRIO 50 IF True                            # Complete Transfer

# 4. Competitive / Defensive Bids
DEFENSE X OVER 1S PRIO 25 IF hcp >= 12 AND spades <= 2 AND hearts >= 3 AND diamonds >= 3 AND clubs >= 3
DEFENSE PASS OVER ANY PRIO 1 IF True
```

### 2.2 Available Condition Primitives
The feature engine ([`src/bid/features.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/features.py)) provides bitmask-accelerated features:

| Feature Key | Type | Description | Example |
| :--- | :--- | :--- | :--- |
| `hcp` | `int` | High Card Points (A=4, K=3, Q=2, J=1) | `hcp >= 12 AND hcp <= 14` |
| `spades`, `hearts`, `diamonds`, `clubs` | `int` | Suit lengths (0 to 13) | `spades >= 5`, `hearts == 4` |
| `balanced` | `bool` | True if shape is 4-3-3-3, 4-4-3-2, or 5-3-3-2 | `balanced == True` |
| `controls` | `int` | Ace=2, King=1 (0 to 12) | `controls >= 4` |
| `quick_tricks` | `float`| Defensive quick tricks | `quick_tricks >= 2.5` |
| `rule_of_20` | `bool` | True if `hcp + length(longest) + length(2nd longest) >= 20` | `rule_of_20 == True` |
| `losers` | `int` | Losing Trick Count (LTC) | `losers <= 6` |
| `stopper_spades`, etc. | `bool` | Suit stopper for No Trump | `stopper_spades == True` |

Save your system file to `system/my_system.dsl`.

---

## 3. Step 2: Compiling & Diagnosing Gaps

Before running matches, verify that your DSL compiles without syntax errors and has no unhandled hands (gaps).

### 3.1 Validate DSL Compilation
Run a quick Python check using `SystemTranslator`:

```python
from bid.translator import SystemTranslator

translator = SystemTranslator.from_dsl_file("system/my_system.dsl")
decision_net = translator.to_decision_net()
print(f"Successfully compiled system '{decision_net.name}' with {len(decision_net.rules)} rules.")
```

### 3.2 Detect Unhandled Hands (Gap Diagnostics)
Use [`ParDiagnosticEngine`](file:///Users/admin/Documents/GitHub/bid/src/bid/diagnostics.py) to simulate 1,000 random hands and detect auctions where the system falls through without an appropriate bid:

```bash
.venv/bin/python3 -c "
from bid.diagnostics import ParDiagnosticEngine
from bid.translator import SystemTranslator
net = SystemTranslator.from_dsl_file('system/my_system.dsl').to_decision_net()
report = ParDiagnosticEngine.analyze_coverage(net, num_deals=1000)
print(f'Gaps found: {report.gap_count} / 1000 deals')
for gap in report.sample_gaps[:3]:
    print('  Sample gap:', gap)
"
```

---

## 4. Step 3: Benchmarking Against Double Dummy Par

Use [`eval_vs_dds.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/eval_vs_dds.py) to evaluate how close your contracts are to theoretical double-dummy par over hundreds of randomized boards.

```bash
.venv/bin/python3 -m bid.eval_vs_dds --system system/my_system.dsl --boards 100 --seed 42
```

### Understanding the Metrics
- **Par Accuracy (`par_acc %`)**: Percentage of boards where your system reached the exact optimal contract or optimal score.
- **Average IMP Loss (`avg_imp_loss`)**: Average International Match Points lost per board compared to perfect double dummy play. Lower is better ($< 2.0$ is strong).
- **Make Rate (`make_rate %`)**: Percentage of declared contracts that actually make.
- **Contract Distribution**: Breakdown of Pass, Partscore, Game, and Slam contracts reached.

---

## 5. Step 4: Head-to-Head Duplicate Match (A/B Arena)

To test whether `my_system.dsl` beats an established benchmark (like Standard American or 2/1):

```bash
.venv/bin/python3 -m bid.ab_engine \
    --system-a system/my_system.dsl \
    --system-b system/base_system.dsl \
    --boards 50 \
    --seed 777
```

### How the Arena Works
- Every deal is played **twice** in a duplicate bridge setup:
  - Round 1: System A sits North-South, System B sits East-West.
  - Round 2: System B sits North-South, System A sits East-West.
- This eliminates deal luck and measures net IMPs directly.
- The output displays the net IMP delta and statistical $z$-score.

---

## 6. Step 5: Two-Hand Realism with SDS (Simultaneous Double Dummy)

Double Dummy Solver (DDS) evaluates contracts assuming all four hands are visible during card play. In real bidding, you must make decisions under partial information.

[`SDSScorer`](file:///Users/admin/Documents/GitHub/bid/src/bid/sds.py) uses Monte Carlo belief sampling:
- It samples $N$ hidden partner and opponent hands consistent with the auction history.
- It computes the expected score distribution across hidden worlds.

To test your system under SDS:
```bash
.venv/bin/python3 -c "
from bid.sds import SDSScorer
from bid.eval_vs_dds import load_decision_net_dsl, build_deals, precompute, evaluate_system
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine

net = load_decision_net_dsl('system/my_system.dsl')
deals = build_deals(20, seed=42)
dds_tables = precompute(deals)
arena = BiddingArena(engine=PIDMEngine())
scorer = SDSScorer(num_worlds=20, seed=42)

res = evaluate_system(arena, 'my_system', net, deals, dds_tables, sds_scorer=scorer)
print('Avg Score:', res['avg_score'])
print('SDS Realistic Score:', res.get('avg_score_sds'))
"
```

---

## 7. Step 6: Automated Convention Synthesis & Competitive VOI

If you want to discover new conventions or optimize thresholds (e.g. 1NT HCP bounds, Bergen raises, Stayman variations), use [`convention_search.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/convention_search.py).

```bash
.venv/bin/python3 -m bid.convention_search \
    --system system/my_system.dsl \
    --generations 3 \
    --population 8 \
    --eval-boards 24 \
    --use-voi \
    --leakage-penalty 0.2 \
    --preemption-bonus 0.3 \
    --out-dir data/conventions
```

### Competitive Value of Information (VOI)
When `--use-voi` is enabled, the search engine screens mutations by computing:
$$\text{Net VOI} = \text{VOI}_{\text{partner}} - \lambda_{\text{leak}} \cdot \text{Leakage}_{\text{defenders}} + \lambda_{\text{preempt}} \cdot \text{Disruption}_{\text{opponents}}$$
- **Partner VOI**: Information entropy reduction for partner's decision-making.
- **Information Leakage**: Penalizes bids that reveal too much shape/strength to the defenders.
- **Preemption Disruption**: Rewards bids that remove opponent bidding space.

Results and ranked candidate systems are saved to `data/conventions/search_report.json`.

---

## 8. Step 7: Autonomous Continuous Improvement (The Flywheel)

Run [`autoloop.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/autoloop.py) to let the system improve itself autonomously:

```bash
.venv/bin/python3 -m bid.autoloop \
    --tiers 8,24,96 \
    --pool-cap 6 \
    --top-k 2 \
    --sds-gate \
    --max-minutes 30
```

### How the Autoloop Operates
1. **Tiered Screening**: Generates candidate rule mutations (tighten, loosen, gate, drop, diagnostic-driven repairs) and screens them on a tiny tier (8 boards).
2. **Escalation**: Statistically inconclusive candidates are escalated to 24 and 96 boards.
3. **SDS Gate**: Promoted candidates must maintain or improve the SDS two-hand realism score.
4. **Automatic Champion Challenge**: Challenging candidates play duplicate matches against `system/champion_system.dsl` across both seat orientations.
5. **Promotion & History**: Winning systems replace `improved_system.dsl`, and previous iterations are archived to `system/history/`. Real-time progress is written to `debug/autoloop_progress.json`.

---

## 9. Step 8: Distilling to a Neural Chain-of-Thought Student

Once your symbolic system is optimized, you can train a neural student model to predict bids along with explainable chain-of-thought reasoning:

### 1. Generate Symbolic Traces
```bash
.venv/bin/python3 -m bid.trace_factory --boards 100 --seed 42 --out data/traces/traces.jsonl
```

### 2. Build Dataset
```bash
.venv/bin/python3 -m bid.build_cot_dataset data/traces/traces.jsonl
```

### 3. Train Transformer Student
```bash
.venv/bin/python3 -m bid.cot_model train \
    --dataset data/cot_dataset/dataset.json \
    --epochs 10 \
    --batch 32 \
    --lr 0.0003 \
    --out data/cot_model/ckpt.pt
```

### 4. Active Learning Disagreement Mining
Mine edge cases where the neural student's predictions diverge from the symbolic oracle:
```bash
.venv/bin/python3 -m bid.mine_disagreements \
    --boards 50 \
    --temp 0.2 \
    --min-confidence 0.6 \
    --out data/traces/disagreements.jsonl
```

### 5. Automated Refresh Cycle
Run the automated refresh pipeline to merge disagreement traces, retrain the student, and evaluate candidate vs incumbent:
```bash
.venv/bin/python3 -m bid.refresh_student --boards 60 --epochs 5
```

---

## 10. Summary Checklist for Designing a System

1. [ ] **Draft**: Create `system/my_system.dsl` with openings, responses, sequences, and defenses.
2. [ ] **Lint**: Run `SystemTranslator` and `ParDiagnosticEngine` to catch syntax errors and gap coverage.
3. [ ] **Par Benchmark**: Run `eval_vs_dds` to measure average IMP loss against double-dummy par.
4. [ ] **Match Play**: Run `ab_engine` duplicate matches against `system/base_system.dsl`.
5. [ ] **Two-Hand Realism**: Test with `SDSScorer` to verify imperfect-information performance.
6. [ ] **Optimize**: Run `convention_search` or `autoloop` with SDS gating.
7. [ ] **Distill**: Export traces with `trace_factory` and train a neural CoT bidder.
