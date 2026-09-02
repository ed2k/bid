# Bridge AI Learning Curriculum: Game Theory, Machine Learning & LLMs

Contract bridge is widely considered one of the holy grails of artificial intelligence because it combines:
1. **Imperfect Information & Cooperative-Competitive Game Theory** (two teams of two players with asymmetric, private information).
2. **Monte Carlo Tree Search & Heuristic Learning** (sampling plausible hidden worlds under constraints).
3. **Natural Language Processing & Chain-of-Thought (CoT) Reasoning** (bidding as an explicit symbolic dialogue where reasoning steps precede decisions).

This repository is designed not only as a high-performance research engine, but also as an interactive laboratory to master these core computer science and AI disciplines through code.

---

## 📚 Curriculum Tracks

```text
                               ┌────────────────────────┐
                               │ Bridge AI Laboratory   │
                               └───────────┬────────────┘
                                           │
         ┌─────────────────────────────────┼─────────────────────────────────┐
         │                                 │                                 │
         ▼                                 ▼                                 ▼
┌───────────────────┐             ┌───────────────────┐             ┌───────────────────┐
│ 1. Game Theory    │             │ 2. Machine Learn. │             │ 3. LLM & CoT      │
│ • Imperfect Info  │             │ • RBMBMC Sampling │             │ • Transformer DSL │
│ • Bayesian Belief │             │ • PIDM Lookahead  │             │ • CoT Reasoning   │
│ • Signaling & VOI │             │ • ID3 Rule Trees  │             │ • Neuro-Symbolic  │
│ • Zero-Sum Par    │             │ • Active Learning │             │ • Entropy/Conf.   │
└───────────────────┘             └───────────────────┘             └───────────────────┘
```

### Track 1: [Game Theory & Information Dynamics](LEARNING_GAME_THEORY.md)
Learn how rational agents communicate, deceive, and optimize outcomes when the world is only partially visible:
- **Imperfect Information & State Estimation**: How bridge differs from chess/Go (Bayesian belief states vs fully observable boards).
- **Signaling Theory**: The cooperative dilemma—telling partner what you have while concealing information from defenders.
- **Competitive Value of Information (VOI)**: Mathematically quantifying partner information gain minus defender leakage plus preemption space disruption.
- **Minimax, Par & Duplicate Scoring**: The mathematics of International Match Points (IMPs) and zero-sum equilibria.

### Track 2: [Machine Learning & Search Algorithms](LEARNING_MACHINE_LEARNING.md)
Explore probabilistic search, decision trees, and evolutionary reinforcement loops:
- **Rule-Based Model-Based Monte Carlo (RBMBMC)**: Generating plausible hidden worlds conditioned on historical bids.
- **Partial Information Decision Making (PIDM)**: Recursive expectation maximization search trees.
- **Symbolic Speedup Learning (ID3)**: Compiling expensive search rollouts into fast $O(1)$ decision networks.
- **Active Learning & Disagreement Mining**: Sampling edge-cases near decision boundaries using Shannon entropy.
- **Autonomous Evolutionary Flywheel**: Multi-tier screening, hypothesis testing, and paired-$z$ gating.

### Track 3: [Large Language Models & Chain-of-Thought Reasoning](LEARNING_LLM_AND_COT.md)
Understand modern neural transformers and neuro-symbolic reasoning from scratch:
- **Transformers from the Ground Up**: Multi-head self-attention, positional encodings, and causal decoding in PyTorch (`src/bid/cot_model.py`).
- **Chain-of-Thought (CoT) Distillation**: Teaching models to "think out loud" (emitting hand features and rule justifications before producing a final bid).
- **Inference Optimization**: Batched decoding on Apple Silicon MPS and GPU with right-padding.
- **Model Uncertainty & Entropy**: Measuring token confidence and perplexity to detect hallucinations.
- **Neuro-Symbolic Safeguards**: Using deterministic symbolic verifiers to gate neural outputs.

---

## 🛠️ Hands-On Exploration

Each concept in these guides maps directly to runnable Python code in this repository:

| Concept | Python Entrypoint / Source Code |
| :--- | :--- |
| **Bidding System Design** | [`docs/DESIGNING_A_BID_SYSTEM.md`](DESIGNING_A_BID_SYSTEM.md) |
| **Double Dummy Par Evaluation** | `python3 -m bid.eval_vs_dds --system system/base_system.dsl --boards 50` |
| **A/B Head-to-Head Arena** | `python3 -m bid.ab_engine --system-a system/improved_system.dsl --system-b system/base_system.dsl` |
| **Convention Search with VOI** | `python3 -m bid.convention_search --generations 2 --use-voi` |
| **Autonomous Staged Flywheel**| `python3 -m bid.autoloop --tiers 4,8 --pool-cap 2 --sds-gate` |
| **Neural CoT Model Training** | `python3 -m bid.cot_model train --dataset data/cot_dataset/dataset.json --epochs 2` |
| **Active Learning Mining** | `python3 -m bid.mine_disagreements --boards 20 --min-confidence 0.6` |
