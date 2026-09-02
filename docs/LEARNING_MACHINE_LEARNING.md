# Learning Machine Learning & Search Algorithms Through Contract Bridge

Bidding AI in bridge cannot rely on standard supervised learning alone. Because bridge is a game of hidden information with exponential combinatorial states ($3.45 \times 10^{16}$ deals), state-of-the-art bidding systems combine:
1. **Constraint-Conditioned Monte Carlo Sampling**
2. **Partial Information Decision-Making (PIDM) Tree Search**
3. **Symbolic Decision Tree Induction (ID3) for Speedup Learning**
4. **Active Learning via Uncertainty Disagreement Mining**
5. **Evolutionary Staged Optimization with Statistical Hypothesis Testing**

This document explains how each of these core machine learning and search techniques is implemented in this codebase.

---

## 1. Constraint-Conditioned Monte Carlo Sampling (RBMBMC)

In fully observable games (chess), search algorithms know the exact state. In bridge, when making a bid, you hold 13 cards and must reason about the 39 hidden cards across partner and two opponents.

### 1.1 The Rejection Sampling Bottleneck
A naive Monte Carlo approach randomly deals 39 cards to the remaining 3 players, checks if their bidding actions match what happened in the auction, and rejects deals that violate history.
- **Problem**: As an auction grows longer, the probability that a random deal matches all four players' previous bids drops to $< 10^{-7}$. Rejection sampling will freeze your computer.

### 1.2 Rule-Based Model-Based Monte Carlo (RBMBMC)
In [`src/bid/sampling.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/sampling.py), the `RBMBMCSampler` uses **Constraint Satisfaction and Soft Player Models**:
1. It maintains intervals for High Card Points (e.g., North opened 1NT $\implies$ HCP $\in [15, 17]$) and suit lengths (spades $\in [2, 5]$).
2. It assigns cards using a prioritized bipartite card assignment algorithm that satisfies known hard constraints directly.
3. For soft style traits, it scores deals using a trained logistic model (`SoftInconsistencyScorer` in [`src/bid/player_model.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/player_model.py)).

```python
from bid.sampling import RBMBMCSampler, Deal
from bid.models import Seat

sampler = RBMBMCSampler(sample_size=10, max_iterations=20)
# Draws 10 distinct, fully consistent 4-player deals matching auction constraints
sample_worlds = sampler.sample_consistent_deals(partial_state)
```

---

## 2. Partial Information Decision Making (PIDM)

Standard Minimax search assumes the opponent will choose the move that minimizes your score in a deterministic state. In bridge, the engine must solve an **Expectation-Maximization Tree Search**:

$$\text{Action}^* = \arg\max_{a \in \mathcal{A}} \mathbb{E}_{w \sim \mathcal{W}} [ \text{Utility}(a, w) ]$$

In [`src/bid/pidm.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/pidm.py), the `PIDMEngine`:
1. Samples $K$ plausible worlds $w_1, \dots, w_K$ from the belief distribution.
2. For each legal candidate call $a \in \mathcal{A}$, simulates the forward progression of the auction:
   - Partner's response in world $w_i$.
   - Opponents' competitive overcalls or passes.
3. Evaluates the resulting terminal contracts using Double Dummy trick solving ([`src/bid/dds.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/dds.py)).
4. Converts score outcomes to IMP payoffs and selects the action with the highest expected value.

---

## 3. Symbolic Speedup Learning (ID3 & Decision Trees)

Running a deep PIDM search with 20 Monte Carlo worlds takes **0.5 to 2.0 seconds per decision**. While acceptable for deep offline analysis, it is too slow for real-time play, large-scale simulations, or training loops.

This is the classic AI problem of **Speedup Learning** (Mitchell, 1983): converting expensive run-time search into fast compiled execution.

```text
┌────────────────────────────────────────┐
│  Expensive PIDM Search (0.5s - 2.0s)   │
└──────────────────┬─────────────────────┘
                   │  Distills 10,000 board rollouts
                   ▼
┌────────────────────────────────────────┐
│   ID3 Decision Tree Induction Engine   │
│  (Calculates Information Gain on HCP,  │
│   suit lengths, stoppers, controls)    │
└──────────────────┬─────────────────────┘
                   │  Compiles into readable AST rules
                   ▼
┌────────────────────────────────────────┐
│ Declarative Decision Network (< 0.1ms) │
│ OPEN 1NT IF hcp >= 15 AND balanced     │
└────────────────────────────────────────┘
```

### 3.1 Information Gain (ID3)
In [`src/bid/learner.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/learner.py), the learner extracts features $f \in \mathcal{F}$ (e.g. `spades >= 5`, `hcp >= 12`) and computes Shannon Information Gain:

$$\text{Gain}(S, f) = H(S) - \sum_{v \in \{\text{True}, \text{False}\}} \frac{|S_v|}{|S|} H(S_v)$$

Splits that maximize classification accuracy are converted directly into human-readable DSL rules:
```dsl
OPEN 1S PRIO 15 IF hcp >= 12 AND spades >= 5 AND spades >= hearts
```
Executing this rule table takes **less than 0.05 milliseconds**, yielding a **10,000x speedup** over runtime search.

---

## 4. Active Learning & Disagreement Mining

Supervised learning typically samples training examples uniformly from a dataset. However, in contract bridge, 80% of dealt hands are mundane (e.g., flat 4-4-3-2 hands with 8 HCP that pass routinely). Uniform sampling wastes 80% of your training compute.

**Active Learning** focuses computational budget on the most informative training points—those near the decision boundary.

```text
                  Sample Random Deal
                          │
                          ▼
            ┌───────────────────────────┐
            │ Neural Student Model      │
            │ Predicts bid & confidence │
            └─────────────┬─────────────┘
                          │
         ┌────────────────┴────────────────┐
         │                                 │
High Confidence                   Low Confidence / High Entropy
(e.g., Conf > 0.95)               (e.g., Conf < 0.60 or Entropy > 1.2)
         │                                 │
         ▼                                 ▼
   Skip (Already known)           Query Symbolic Oracle (PIDM)
                                           │
                                           ▼
                                 Label & Add to Retraining Set
```

### 4.1 Shannon Entropy as Uncertainty Metric
In [`src/bid/cot_model.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/cot_model.py), the student model computes the Shannon entropy across token logits:

$$H(p) = -\sum_{i=1}^V p_i \log p_i$$

- $H(p) \approx 0$: The model is completely certain of its choice.
- $H(p) > 1.5$: The model is guessing between multiple plausible calls.

In [`src/bid/mine_disagreements.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/mine_disagreements.py), deals where the student exhibits high uncertainty or disagrees with the oracle are automatically mined, labeled, and appended to `data/traces/disagreements.jsonl`.

---

## 5. Autonomous Evolutionary Optimization (The Flywheel)

How do we systematically discover improvements to our bidding system without human intervention?

[`src/bid/autoloop.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/autoloop.py) implements a staged genetic/evolutionary search:

### 5.1 The Mutation Operators
The engine generates mutant rule variants:
- **Tighten**: Narrows a bound (`hcp in [15, 17] -> [15, 16]`).
- **Loosen**: Expands a bound (`spades >= 5 -> spades >= 4`).
- **Gate**: Adds contextual conditions (`not_opening`, `partner`).
- **Drop**: Prunes ineffective or overlapping rules.
- **Diagnostic Repair**: Generates rules targeting specific gap hands flagged by `ParDiagnosticEngine`.

### 5.2 Multi-Tier Screening with Paired-$z$ Statistic
Evaluating every candidate mutation on 1,000 boards is computationally prohibitive. `autoloop.py` uses a **ladder of tiers** (e.g., 8 boards $\to$ 24 boards $\to$ 96 boards $\to$ 384 boards):

1. **Tier 1 (Smallest: 8 boards)**:
   Screen all 15 candidate mutations. Only candidates with positive average delta ($\bar{\delta} > 0$) survive.
2. **Tier 2 (Escalation)**:
   Only inconclusive survivors are evaluated on 24 and 96 boards.
3. **Statistical Significance Test**:
   The decision whether to accept, reject, or escalate is governed by the paired-$z$ statistic:
   $$z = \frac{\bar{\delta}}{\sigma / \sqrt{N}}$$
   - If $\bar{\delta} > 0$ and $z \ge 2.0$ ($p < 0.05$): **Accept**.
   - If $\bar{\delta} < 0$ and $z \le -2.0$: **Reject**.
   - Otherwise: **Escalate** to a higher tier.

### 5.3 The SDS Two-Hand Realism Gate
Before any accepted candidate is promoted, it must pass the **Simultaneous Double Dummy (SDS)** gate:
- Candidate systems that achieve high scores by assuming impossible double-dummy clairvoyance are rejected if their two-hand score with hidden information regresses.
- Winning systems challenge the reigning champion head-to-head in duplicate matches across both seat orientations.
