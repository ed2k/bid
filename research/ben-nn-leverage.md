# Answering `questions.md`: BEN's Neural Approach × Our Symbolic System

*Questions: (1) Evaluate BEN's NN approach — can we patch it to be explainable?
(2) How do we leverage BEN's NN *training approach* when our rule-set finding is not
GPU-friendly but is explainable? Can ML accelerate rule discovery?*

---

## 1. What BEN actually does (from source inspection)

`../ben/src/botbidder.py` + `../ben/src/nn/bidder_tf2.py`:

| Component | Mechanism |
| --- | --- |
| Input | Binary encoding of own hand + full auction history |
| Network | TF2 model → **softmax over all 38 bids** (+ optional alert head) |
| Candidate generation | argmax-walk the softmax, keep legal bids above per-bid-number `min_candidate_score` thresholds |
| Evaluation | Sample hands consistent with auction → rollout each candidate → **native DD expected score** (`expected_score`, `decl_tricks_softmax`) |
| Explanation | `explain(auction)` delegates to **BBA**, a separate rule-based convention engine, for keycard sequences & alerts |
| Training | Self-play logs (`save_for_training`) → supervised fits of the policy softmax |

So BEN = **learned policy prior (GPU) + DD oracle (CPU) + symbolic sidecar (BBA) for explanation**.
It is structurally *our* architecture with the DecisionNet replaced by a softmax — and notably,
BEN already patches in a rule engine (BBA) precisely because the net cannot explain itself.

### Verdict on the NN approach

**Strong:** the softmax prior compresses millions of auction outcomes; it generalizes to
auctions no rule author anticipated; it makes DD-evaluation cheap by pruning candidates;
it trains on GPU while inference is one matrix multiply.

**Weak for our goal:** a 38-way softmax gives no reason for any bid; conventions are
diffuse across weights; the "alert" head is binary flagging, not justification; and the
net cannot *state* the constraint it is honoring ("5+ spades, 8+ HCP") even though that
knowledge demonstrably lives inside it.

## 2. Can we patch it to be explainable? Yes — four concrete paths

All four operate post-hoc on a trained BEN bidder; none require retraining.

1. **Input attribution per bid** — the input is structured and sparse (52 card bits +
   auction-history bits). Integrated gradients / SHAP on the chosen bid yields per-card,
   per-call attributions. Rendered as sentences: *"3NT driven by: balanced shape (+0.31),
   HCP 17 (+0.28), partner's 1NT call (+0.22)."* Cheap to prototype against
   `next_bid_np`.
2. **Surrogate distillation into our DSL** — run the BEN bidder over ~100k sampled
   deals; label every state with its chosen bid; fit shallow trees/GBMs using **our**
   `BridgeFeatures` vocabulary (HCP bands, suit lengths, `partner_last_call`…).
   Each tree path *is* a `RuleCondition` list; report fidelity (% states where tree ==
   net). High-fidelity paths become candidate DecisionNet rules — GPU knowledge,
   human-readable output.
3. **Constraint inversion per auction-cluster** — group states by auction prefix; for
   each cluster regress *which hand properties make the net accept the bid*. Output =
   constraint tables in exactly the format our control-ask ladder already emits.
4. **Symbolic veto layer** — keep the NN as candidate generator but require our
   DecisionNet to approve each accepted bid; disagreements are logged and become
   flywheel targets. This is BEN's BBA pattern generalized, and it doubles as a
   legality/consistency audit.

## 3. Leveraging BEN's *training approach* to accelerate our rule finding

The key realization: **we don't need their GPU to find rules — we need their GPU to
manufacture labeled data, then extract symbols from it.**

| Mechanism | What it accelerates | Where it lands in this repo |
| --- | --- | --- |
| **BEN-as-labeler → rule mining** | Flywheel's biggest cost is *discovering which rules matter*. A BEN-labeled corpus (state → bid, plus DD-par contract) lets a tree/GBM propose complete rule sets offline | Mined rules enter `PoolBuilder` as a new `mined:*` family; existing paired-validation gates unchanged |
| **Learned proposal ranking** | Train a tiny model on flywheel history (patch signature features → accepted?) to order `PoolBuilder` output; bandit over generator families | `autoloop.py` screening order; rejects stay cached as today |
| **Surrogate delta predictor** | Predict 64-board delta from cheap 8-board signals to pre-screen before ladder escalation | Cuts `autoloop.py` cost ~4× at equal precision; escalation logic already built |
| **BEN as league opponent** | Their ONNX/TF bidders become 2–3 diverse defenders in `arena.py` — kills the mirror-self-play exploitation we measured without hand-authoring archetypes | League scaffolding (planned §7); needs an adapter bridging their binary auction format to our `Call` lists |
| **BC warm-start of a ranker** | Behavior-clone our v11 choices, fine-tune with the DD oracle, then re-distill to DSL | The full loop from the strategy discussion; BEN's `save_for_training` shows the data-collection pattern |

### Caveats

- **License/provenance:** BEN's models carry their own license; mined *rules* are ours,
  but shipping their weights inside our toolchain needs a check.
- **Domain shift:** their training distribution ≠ our deal seeds/systems; mined rules
  must pass our paired gates regardless (which they will — that machinery is the point).
- **Encoding adapter:** their binary auction vector ↔ our `Call` lists needs one
  translation module (~a day).

## 4. Recommended sequence

1. **Adapter + BEN-as-opponent** (league diversity; immediate anti-mirror win).
2. **Corpus generation**: run BEN bidder over 100k deals, store `(features, bid, dd-par)`
   rows — this dataset serves every mechanism below.
3. **Tree-distillation → `mined:*` flywheel family** with fidelity thresholds.
4. **Attribution explainer** as the human-facing "why" for any BEN-influenced decision.
5. Only then consider training anything ourselves; by then the labeled corpus makes it
   a fine-tune, not a cold start.

Every step keeps the invariant the project was founded on: **the artifacts that play
bridge are rules a human can read; the neural net only ever proposes or explains.**
