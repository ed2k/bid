# CoT-Bidder: LLM-Style Explainability for Neural Bidding

*Extends [`ben-nn-leverage.md`](ben-nn-leverage.md). Goal: a bidder whose explanations are faithful **by construction** — LLM-style generated reasoning, but grounded in bridge's small formal vocabulary and verified symbolically at inference time.*

---

## 1. Why this is tractable here

LLM-style explainability requires reasoning traces. Normally the bottleneck is authoring them. This repo owns a **perfect automatic trace generator**: every DecisionNet call already yields (matched rules → conditions → EV comparison) — exactly what `explain_board.py` prints. Unlimited free `(position → explanation → bid)` triples whose explanations are correct by construction, plus a DD oracle for outcome labels.

Bridge's explanation vocabulary is also tiny and formal (convention statements = constraint lists), unlike open-domain chat. So the hard part of CoT quality mostly disappears.

---

## 2. Architecture

```
serialized position (hand + auction + features)
        ↓
reasoner emits structured trace:
    CONTEXT ... | HAND ... | RULE <id>(conds...) | BID <call>
        ↓
CONSTRAINED DECODE: bid must satisfy the emitted conditions
    (checked against the actual hand features)
        ↓
symbolic verifier: legality vs auction + constraint-vs-hand consistency
        → reject & fall through to next candidate / fallback policy
```

Faithfulness is **by construction**: the bid is only playable if it satisfies the emitted constraints, which were checked against the real features.

### Reasoner back-ends (staged)

| Stage | Back-end | Notes |
| --- | --- | --- |
| P0 (built) | Nearest-neighbor retrieval over the trace corpus | transfers the closest stored trace's constraints; verifies before playing. No training needed; demonstrates the full decode/verify loop |
| P1 | Small seq2seq (10–50M params) trained on the corpus | supervised on `(STATE… → EXPLANATION… BID x)`; the real "tiny LLM" |
| P2 | RL/process refinement | prefer traces whose bid scores better under the DD oracle; penalize verifier rejections |

---

## 3. Trace schema (JSONL, one object per CALL)

```json
{
  "board": {"seed": 42, "index": 1, "dealer": "NORTH", "vuln": 0},
  "call_index": 0,
  "seat": "NORTH",
  "input": {
    "auction": ["1C"],
    "hand": "S:K6 H:A D:A94 C:AKQ84",
    "features": {"hcp": 19, "spade_len": 2, "...": "..."}
  },
  "explanation": {
    "rule": "R_1C_STRONG_BAL",
    "constraints": [["hcp", ">=", 15], ["is_balanced", "==", True]],
    "text": "RULE R_1C_STRONG_BAL(cond=hcp>=15,...)"
  },
  "bid": "1C",
  "forced": false,
  "ev": {}
}
```

Invariants enforced by the factory:
- `bid` is the system's actual choice (legal by construction)
- `constraints`, when parsed and evaluated against `input.features`, all hold
  (they come from the rules that actually fired)
- `forced == (len(legal candidates) == 1)`

---

## 4. Faithfulness metrics

| Metric | Definition | Target |
| --- | --- | --- |
| Constraint satisfaction rate | % emitted traces whose conditions hold on the true features | 100% (factory-guaranteed; measured again at decode time) |
| Legality violation rate | bids illegal vs auction | 0% |
| Agreement rate (vs DecisionNet) | same bid on same positions | reported, not gated — divergence is signal |
| Intervention sensitivity | flip one card → does the emitted constraint set change sensibly? | manual audit suite |
| Hallucination rate | references to features/rules not present in the vocabulary | 0% |

---

## 5. Components in this repo

| File | Role |
| --- | --- |
| `trace_factory.py` | generates the JSONL corpus from self-play (CLI) |
| `cot_bidder.py` | constraint verifier + retrieval reasoner + constrained decode (CLI: play/evaluate) |
| `tests/test_trace_factory.py` | schema/invariant tests |
| `tests/test_cot_bidder.py` | verifier + retrieval legality tests |
| `data/traces/*.jsonl` | corpora (gitignored) |

---

## 5b. P1 model architecture & size

**Decision**: decoder-only transformer trained **from scratch** on the formal
trace grammar — not a fine-tuned general LM.

Why from-scratch / small:
- Corpus is 5k–50k examples near-term; a 5M-param model saturates it, a 135M+
  LM undertrains without heavy augmentation.
- Vocabulary is tiny and closed (~600–800 field tokens); no language priors needed.
- Constrained decoding is easiest over our own tokenizer (bid tokens are first-class).
- Inference stays dependency-light (one small checkpoint; no HF stack).

### Config ladder

| Tier | layers × d_model | heads | ctx | params | when |
| --- | --- | --- | --- | --- | --- |
| XS (smoke) | 2 × 128 | 4 | 256 | ≈ 0.5M | pipeline debugging |
| **S (default)** | **6 × 256** | **4** | **512** | **≈ 5M** | corpus ≥ 5k traces |
| M | 8 × 512 | 8 | 1024 | ≈ 19M | corpus ≥ 100k traces |
| L (LoRA on SmolLM-135M-class) | pretrained | — | 2048+ | 135M+ backbone | only if S/M plateau AND corpus ≥ 500k |

Param math (S): per-layer ≈ 12·d² = 12·65 536 ≈ 0.79M ⇒ 6 layers ≈ 4.7M;
embeddings ≈ V·d (V≈800 ⇒ 0.20M) + positional 512·256 ≈ 0.13M ⇒ **≈ 5.0M total**.

### Tokenizer
Field-level regex `\w+|[^\w\s]` over trace lines (keeps `R_1D`, `>=` intact,
splits parens/commas/pipes). Specials: `<pad>` `<bos>` `<sep>` `<eot>`.
Expected vocab ≈ 600–800.

### Sequence layout & loss masking

```
<bos> STATE dealer=N vuln=3 seat=NORTH turn=3
AUCTION 1C P 1S X
HAND S:K6 H:A D:A94 C:AKQ84
<sep>
EXPLANATION RULE R_1C_STRONG_BAL( is_opening == True )( hcp >= 15 )...
BID 1C
<eot>
```
Loss computed **only after `<sep>`** (the reasoning + bid); the state prefix is
conditioning. This is what makes the CoT load-bearing: the bid attends to the
emitted explanation.

### Training hyperparameters (S)
AdamW β=(0.9,0.95), lr 3e-4 cosine → 3e-5, warmup 200 steps, batch 32,
dropout 0.1, grad-clip 1.0. CPU-feasible (hours) for ≤10M tokens; GPU = minutes.

### Inference integration
Greedy decode by default. After `<eot>`: parse `EXPLANATION` constraints →
`verify_constraints` vs real features → `bid_legal` vs auction → on failure,
resample at T=0.7 (≤3 tries) → else fall back to DecisionNet (existing chain).

## 6. Deferred / risks

- Seq2seq training (P1/P2): needs the corpus at scale + a training env; the retrieval back-end stands in until then and defines the exact interface.
- Boilerplate traces: mitigated by intervention audits and by only trusting verifier-passed decodes.
- Mid-trick dds3 unreliability (see status.md §6.1) does NOT affect this component — bidding leaves never call the solver mid-trick.
