# Learning LLMs & Chain-of-Thought Reasoning Through Contract Bridge

Can a neural network learn to reason like a human bridge expert?

In standard machine learning, a model predicts an output directly from an input:
$$\text{Hand} \implies \text{Bid}$$

In modern Large Language Model (LLM) research, **Chain-of-Thought (CoT)** reasoning demonstrates that models achieve dramatically higher accuracy when they emit step-by-step intermediate thoughts before producing their final answer:
$$\text{Hand} \implies \text{Intermediate Reasoning Steps (HCP, shape, rule matching)} \implies \text{Bid}$$

This repository implements a complete, self-contained Transformer from scratch in PyTorch ([`src/bid/cot_model.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/cot_model.py)) and a neuro-symbolic reasoning engine ([`src/bid/cot_bidder.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/cot_bidder.py)).

---

## 1. The Transformer Architecture from Scratch

Rather than importing black-box third-party libraries, [`src/bid/cot_model.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/cot_model.py) implements a clean GPT-style decoder-only Transformer in under 300 lines of standard PyTorch.

### 1.1 Structural Overview
```text
Input Tokens (IDs)
      │
      ├─── Token Embeddings: tok_emb(x) [B, T, d_model]
      └─── Learned Positional Embeddings: pos_emb(positions) [1, T, d_model]
      │
      ▼
   Sum: x = tok_emb + pos_emb
      │
      ▼
┌─────────────────────────────────────────────────┐
│ Transformer Block (Repeated N Layers)           │
│                                                 │
│   x ─── LayerNorm ─── CausalSelfAttention ─── + │ (Residual Connection 1)
│                                               │ │
│   x ─── LayerNorm ─── MLP (GELU) ─────────────+ │ (Residual Connection 2)
└─────────────────────────┬───────────────────────┘
                          │
                          ▼
                     LayerNorm
                          │
                          ▼
             Language Modeling Head (Linear)
                          │
                          ▼
                 Token Logits [B, T, V]
```

### 1.2 Multi-Head Causal Self-Attention
Self-attention allows every token in the sequence to look back at earlier tokens to extract context:

$$\text{Attention}(Q, K, V) = \text{softmax}\left(\frac{Q K^T}{\sqrt{d_k}} + M\right) V$$

- **Causal Mask ($M$)**: An upper-triangular matrix filled with $-\infty$. It ensures that token at position $t$ cannot look ahead at future tokens $t+1, t+2$ during training.
- **Multi-Head**: Linearly projects Queries, Keys, and Values into $H$ heads so the model can simultaneously attend to suit lengths, vulnerability, and partner's earlier calls.

---

## 2. Why Chain-of-Thought (CoT) Works

Transformers do not have recurrent hidden states or internal memory registers; they compute a fixed amount of feed-forward depth per token.

### 2.1 The Direct Prediction Failure Mode
If you force a transformer to predict the bid immediately:
```text
Input:  [DEALER N VUL None SEAT S HAND SA432 HKQJ2 D432 C32 AUCTION 1NT PASS]
Output: 2C
```
The model must compute hand evaluation, shape categorization, and convention rule retrieval in a single forward pass. Complex reasoning frequently fails.

### 2.2 The Chain-of-Thought Solution
In this repository, [`src/bid/trace_factory.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/trace_factory.py) formats training examples with explicit intermediate thoughts:

```text
Input:
[DEALER N VUL None SEAT S HAND SA432 HKQJ2 D432 C32 AUCTION 1NT PASS]

Chain-of-Thought Reasoning:
= EVAL hcp:12 controls:4 spades:4 hearts:4 diamonds:3 clubs:2 balanced:True
= CONVENTION Stayman response to 1NT: 8+ HCP with 4-card major
= RULE R_STAYMAN_2C matched priority 30

Final Output:
= BID 2C
```

When predicting `= BID 2C`, the self-attention mechanism attends back to its own emitted tokens (`spades:4 hearts:4`, `hcp:12`, `Stayman`). The reasoning tokens serve as an **external computational working memory**.

---

## 3. Knowledge Distillation: Symbolic Oracle $\to$ Neural Student

How do we train the neural network?

```text
┌────────────────────────────────────────┐
│  Symbolic Bidding System (DSL / Rules) │
│  Deterministic, 100% accurate oracle   │
└──────────────────┬─────────────────────┘
                   │  trace_factory.py: Simulates 10,000 auctions
                   ▼
┌────────────────────────────────────────┐
│  Structured CoT Traces (traces.jsonl)  │
│  Hand + Auction + Thoughts + Bid       │
└──────────────────┬─────────────────────┘
                   │  cot_model.py train (Causal Cross-Entropy)
                   ▼
┌────────────────────────────────────────┐
│  Neural Student Model (ckpt.pt)        │
│  Fast, smooth, probabilistic bidder    │
└────────────────────────────────────────┘
```

The symbolic system acts as the **Teacher**, generating thousands of rich, transparent training examples. The neural network acts as the **Student**, distilling those symbolic rules into learned vector weights.

---

## 4. Inference Optimization & Uncertainty Estimation

### 4.1 Vectorized Batched Decoding (`generate_batch`)
During inference, naive single-sequence generation is bound by GPU memory transfer latency. In [`src/bid/cot_model.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/cot_model.py), `generate_batch`:
1. Packs $B$ sequences into a right-padded 2D tensor on CPU.
2. Transfers the entire batch to the device (Apple Silicon `mps` or NVIDIA `cuda`) in a single transfer.
3. Steps forward autoregressively, computing softmax probabilities, Shannon entropy, and greedy/multinomial next tokens simultaneously across all batch elements.
4. Eliminates `.item()` synchronization stalls on Apple Silicon MPS.

### 4.2 Shannon Entropy & Hallucination Detection
For every token $t$, the model calculates its Shannon entropy across vocabulary logits:

$$H_t = -\sum_{i=1}^V P(w_i) \log P(w_i)$$

- If $H_t < 0.2$: The model is supremely confident in its reasoning step.
- If $H_t > 1.5$: The model is encountering an ambiguous hand that falls between multiple rules.

This entropy signal is used by `mine_disagreements.py` to trigger active learning.

---

## 5. Neuro-Symbolic Verification: Eliminating Hallucinations

A notorious flaw of pure deep learning models is **hallucination**: a neural network might output an illegal bid (e.g. bidding `1H` after `2S`) or invent hand features it does not actually possess.

In [`src/bid/cot_bidder.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/cot_bidder.py), this repository implements **Neuro-Symbolic Verification**:

```text
                     Neural Model Generates:
               "= EVAL hcp:16 ... = BID 1NT"
                             │
                             ▼
               ┌───────────────────────────┐
               │ Deterministic Verifier    │
               │ (verify_constraints)      │
               └─────────────┬─────────────┘
                             │
            ┌────────────────┴────────────────┐
            │                                 │
      Valid Reasoning                  Invalid / Hallucination
            │                                 │
            ▼                                 ▼
       Execute Bid                    Fallback to Symbolic
                                      Decision Network
```

1. **Feature Consistency Check**: The verifier computes the true hand bitmasks and checks whether the neural model's claimed HCP and suit lengths match the actual cards in hand.
2. **Auction Legality Check**: Verifies that the proposed bid is strictly higher than the current auction contract.
3. **Fallback**: If the neural model fails any symbolic sanity check, the system safely falls back to the deterministic symbolic rule engine.

This neuro-symbolic architecture guarantees that the agent enjoys the generalization flexibility of deep learning without ever committing an illegal or impossible bridge action.
