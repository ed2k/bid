# Integrating Ideas from `JPS` (`../../jps`) into `bid`

## Overview

The sibling repository [`../../jps`](../../jps/README.md) is the official C++/PyTorch implementation of **Joint Policy Search (JPS)** (Yuandong Tian, Qucheng Gong, Tina Jiang, NeurIPS 2020: *"Joint Policy Search for Multi-agent Collaboration with Imperfect Information"*). While `jps` targets neural policy tabular lookahead over C++ `rela` actors, its core algorithmic solutions directly address the exact bottlenecks in our GPU DSL evolution ([`research/gpu_evolve_dsl.py`](../research/gpu_evolve_dsl.py)), vectorized arena ([`research/gpu_arena.py`](../research/gpu_arena.py)), hand/auction feature extraction ([`src/bid/features.py`](../src/bid/features.py)), and single-dummy search ([`src/bid/sds.py`](../src/bid/sds.py)).

Below are the **5 highest-leverage components** we can borrow from `../../jps`, ordered by expected IMP/board impact and implementation simplicity, followed by our implemented [`DiffDSLNet`](../src/bid/diff_dsl_net.py) + [`research/jps_search.py`](../research/jps_search.py) benchmark results in Section 6.

---

## 1. Coupled `(Opener, Responder)` Joint Policy Search for GPU DSL Evolution

### What `../../jps` Does
- **Source**: [`simple_game/search.h`](../../jps/simple_game/search.h#L1304-L1494) (`TabularSearch::search` & `search_recursive`) and [`rela/rollouts_new.h`](../../jps/rela/rollouts_new.h#L142-L300) (`SearchFrame` & `RolloutNew`).
- **Problem**: In cooperative imperfect-information games like Bridge bidding, unilateral (1-step coordinate ascent) policy updates get trapped in **partnership local equilibria**:
  1. If Opener changes a forcing/conventional rule $r_1: a_1 \to a_1'$ while Responder's rules remain frozen, Responder misinterprets $a_1'$ and the partnership scores terribly.
  2. Conversely, if we try to mutate Responder's response rule $r_2$ after $a_1'$ first, $a_1'$ is never bid under the current policy (`alterReach = 0`), so $r_2$ has zero active boards and zero gradient/payoff change.
- **JPS Solution**: During depth-$d$ policy change search, when evaluating an action override $a_1 \to a_1'$ at information set $I_1$, JPS tracks all downstream partner information sets $I_2 \in \text{succ}(I_1, a_1')$ whose reachability (`alterReach`) changes under $a_1'$, and **jointly optimizes** the depth-2 policy change pair $(I_1: a_1 \to a_1',\; I_2: a_2 \to a_2')$ before deciding whether to commit the edit.

### How `bid` Can Use It
Currently, [`research/gpu_evolve_dsl.py`](../research/gpu_evolve_dsl.py#L72-L165) mutates or splits **one rule at a time** (`ov_rule[k]`, `ov_call[k]`). However, [`TensorDecisionNet`](../research/gpu_arena.py#L209-L425) and [`DiffDSLNet`](../src/bid/diff_dsl_net.py) can accept **paired overrides** `(ov_r1, ov_c1, ov_r2, ov_c2)`:
1. **Reachability Coupling Graph**: In a single baseline rollout over our training bundle, record for each board $b$ the sequence of firing partnership rules $(r_{b,t}, r_{b,t+2})$ (North then South, or Opener then Responder).
2. **Depth-2 Coupled Candidate Sweep**:
   - When evaluating a candidate action change $r_1 \to a_1'$ on Opener's rule $r_1$, identify the top-$M$ downstream Responder rules $\{r_2^{(1)}, \dots, r_2^{(M)}\}$ that fire on those boards when $r_1$ outputs $a_1'$.
   - Construct the Cartesian product of `(r_1 -> a_1', r_2 -> a_2')` pairs and evaluate all pairs simultaneously in packed mega-batches ([`run_packed_coupled_override_batch`](../research/jps_search.py#L204-L287)).
   - Commit the joint pair `(r_1 -> a_1', r_2 -> a_2')` when its multi-opponent train + validation IMP gain exceeds any single-rule edit.

---

## 2. Explicit Partner Hand & Fit Belief Features (Law of Total Tricks)

### What `../../jps` Does
- **Source**: [`python/a2c/model.py`](../../jps/python/a2c/model.py#L83-L190) (`BridgeA2CModel`), [`cpp/game_state.cc`](../../jps/cpp/game_state.cc#L34-L50) (`p_hand_hcp`), and [`python/main_belief_mean_trick.py`](../../jps/python/main_belief_mean_trick.py#L40-L68) (`BeliefModel` / `TrickModel`).
- **Mechanism**: Instead of mapping raw auction history + private hand directly to bids, `BridgeA2CModel` routes the state through an explicit **Partner Belief Bottleneck**:
  1. `enn_partner` predicts `infer_p_hand = sigmoid(linear2(enn_partner(s)))` — either the full 52-bit partner card ownership vector or the 16-bit partner high-card vector (`A, K, Q, J` in each of the 4 suits, `p_hand_hcp` in [`cpp/game_state.cc`](../../jps/cpp/game_state.cc#L34-L50)).
  2. The policy network receives `torch.cat((s, infer_p_hand), dim=1)` so every bidding decision conditions directly on inferred partner honors and suit lengths.
  3. An auxiliary head `prob_trick` predicts the 14-way Double-Dummy trick distribution `[0..13]` for each strain.

### How `bid` Can Use It
1. **Symbolic Partner Suit-Length & Combined Fit Features in [`src/bid/features.py`](../src/bid/features.py) & [`research/gpu_arena.py`](../research/gpu_arena.py)**:
   - Extend [`_partner_hcp_window`](../src/bid/features.py#L140-L176) and `BatchedAuctionEnv` with partner's promised suit lengths (`partner_spade_min`, `partner_heart_min`, `partner_diamond_min`, `partner_club_min`, `partner_trump_len_min`, and `combined_trump_len_min`), directly unlocking **Law of Total Tricks (LoTT)** rules in our DSL.
2. **Auxiliary Partner-Honor & DD-Trick Head in [`src/bid/diff_dsl_net.py`](../src/bid/diff_dsl_net.py) & [`src/bid/cot_model.py`](../src/bid/cot_model.py)**:
   - Add JPS's partner-belief trunk (`partner_belief_net`) and value head (`value_head`).

---

## 3. Cross-Bidding Hard-Negative Mining for Single-Dummy World Sampling

### What `../../jps` Does
- **Source**: [`cpp/cross_bidding_actor.h`](../../jps/cpp/cross_bidding_actor.h#L86-L235) (`CrossBiddingEnvActor`) and [`python/analyze_cross_bidding.py`](../../jps/python/analyze_cross_bidding.py).
- **Mechanism**: Given a ground-truth deal $s_{\text{gt}}$ that produced auction $b$, and an alternative unseen-card deal $s_{\text{alt}}$ sharing the player's private hand, JPS replays auction $b$ on $s_{\text{alt}}$ (`env.step(actionGt)`) to compute the log-likelihood $\log P_\pi(b \mid s_{\text{alt}})$ and mines **deceptive / high-variance consistent worlds** where:
  $$\log P_\pi(b \mid s_{\text{alt}}) \ge \log P_\pi(b \mid s_{\text{gt}}) - \log(10) \quad \text{and} \quad \text{DDT}(s_{\text{alt}}, b) \ne \text{DDT}(s_{\text{gt}}, b)$$

### How `bid` Can Use It
In [`src/bid/sds.py`](../src/bid/sds.py#L462-L545) (`SDSScorer._select_consistent`), stratifying candidate consistent deals across optimistic, median, and pessimistic (`4-1` split / wasted value) auction-consistent worlds gives `SDSScorer` much more accurate tail-risk estimation on vulnerable games and slams.

---

## 4. Reachability-Weighted Empirical Bayes Edge Shrinkage

### What `../../jps` Does
- **Source**: [`rela/search_actor_refactored_new.h`](../../jps/rela/search_actor_refactored_new.h#L343-L382) (`SearchRolloutCtrlNew::getEdges`).
- **Mechanism**: JPS regularizes every candidate action's empirical rollout estimate `childV` back toward the prior value `a.Q` using sample reachability:
  $$\text{coeff} = \text{baselineRatio} \cdot \text{sampleReach}, \qquad \hat{V}(a) = (1 - \text{coeff})\,\text{childV} + \text{coeff}\,Q(a)$$

### How `bid` Can Use It
In [`research/jps_search.py`](../research/jps_search.py#L290-L301) and [`research/gpu_evolve_dsl.py`](../research/gpu_evolve_dsl.py), we compute:
$$\text{ShrunkGain}(c) = \frac{N_{\text{active}}(c)}{N_{\text{active}}(c) + \lambda} \cdot \overline{\Delta \text{IMP}}(c), \qquad t(c) = \frac{\overline{\Delta \text{IMP}}_{\text{active}}(c)}{\text{SE}_{\text{active}}(c) + \epsilon} \ge t_{\min}$$
preventing rare rules from overfitting to 1–2 swing boards.

---

## 5. WBridge5 / JPS 1,000-Board Benchmark Suite & Pre-Trained Checkpoints

### What `../../jps` Has on Disk
1. **1,000 Solved WBridge5 vs JPS Duplicate Boards**:
   - [`../../jps/logs/jps_14days.log`](../../jps/logs/jps_14days.log) and [`../../jps/logs/against_WBridge5.raw`](../../jps/logs/against_WBridge5.raw) contain **1,000 complete duplicate deals** in PBN format with 20-entry Double-Dummy trick tables (`DDT: ...`), par scores, and both Table 0 (JPS NS vs WBridge5 EW) and Table 1 (WBridge5 NS vs JPS EW) full bidding histories.
2. **5 Pre-Trained Neural Checkpoints (`../../jps/bridge_models/`)**:
   - [`agent-1610-0.63.pth`](../../jps/bridge_models/agent-1610-0.63.pth) and 4 other `.pth` checkpoints contain `BridgeA2CModel` weights (`input_dim=268`, `hid_dim=200`, `num_blocks=2`, `num_action=39`) using the `FeatureExtractorOld` feature layout from [`cpp/game_state.cc`](../../jps/cpp/game_state.cc#L224-L270).

---

## 6. Implemented `DiffDSLNet` & Joint Policy Search (`JPS`) Results

We implemented the neuro-symbolic differentiable DSL model and JPS search in:
- [`src/bid/diff_dsl_net.py`](../src/bid/diff_dsl_net.py): **[`DiffDSLNet(nn.Module)`](../src/bid/diff_dsl_net.py#L148-L779)** & **[`BidExplanation`](../src/bid/diff_dsl_net.py#L121-L145)** (detailed architecture in [`docs/DIFF_DSL_NET.md`](./DIFF_DSL_NET.md))
  - Compiles all `1,840` rules and `955` unique condition atoms of [`system/brill_gpu_evolved.dsl`](../system/brill_gpu_evolved.dsl) directly into PyTorch `nn.Parameter` weights (`atom_val`, `rule_atom_logits`, `rule_prio_param`, `rule_call_logits`) plus a JPS partner-belief (`partner_belief_net`) and state-value (`value_head`) bottleneck.
  - Achieves **100.0% bit-exact forward parity** (`0` mismatches across `4,113` decisions on `colab_bundle_500.pt`) in hard mode and end-to-end Straight-Through Estimator (STE) gradients in soft mode.
  - **100% Explainable Bid Output**: Every decision emits a [`BidExplanation`](../src/bid/diff_dsl_net.py#L121-L145) with the winning rule ID, priority, satisfied condition atoms `(feature op threshold [actual=val])`, any negative-rule vetoes, and a canonical Chain-of-Thought string (`EXPLANATION RULE <id> ... -> BID <call>`).
- [`research/jps_search.py`](../research/jps_search.py): **Multi-Generation 3-Stage Joint Policy Search over `DiffDSLNet` (`--generations 3 --gpu-scale`)**
  0. **Stage 0 (Online Partner-Belief & Value-Head Training)**: Trains `diff_net.partner_belief_net` and `diff_net.value_head` on ~`8,100` active self-play decisions per generation so STE gradients reflect learned state values.
  1. **Stage 1 (Depth-2 Coupled `(Opener, Responder)` JPS Search + `alterReach` Discovery)**: Evaluates `~5,400` coupled `(r_1 -> c_1, r_2 -> c_2)` pairs per generation simultaneously with Empirical Bayes reachability shrinkage ($\lambda = 15$), discovering 4 coupled partnership adjustments across 3 generations (including cross-generation `alterReach` chaining where Gen 2 discovered a joint convention on top of a rule split created in Gen 1).
  2. **Stage 2 (STE Gradient-Guided `atom_val` Threshold Shifts)**: Uses STE gradients $\nabla_{\theta_u}$ on `DiffDSLNet.atom_val` to prioritize continuous threshold shifts across the top 64 atoms (`delta in {-2, -1, +1, +2}`), validating 9 threshold refinements across 3 generations.
  3. **Stage 3 (JPS Partner-Belief & `SuitC` Condition Splits)**: Appends 15 multi-opponent-validated condition splits across 3 generations via [`DiffDSLNet.clone_and_split_rule()`](../src/bid/diff_dsl_net.py#L636-L706) and exports the learned weights back to [`system/brill_jps_diff.dsl`](../system/brill_jps_diff.dsl) (`1,855` rules).

### Held-Out Duplicate Team Match Results ([`system/brill_jps_diff.dsl`](../system/brill_jps_diff.dsl))

Evaluated on the **2,500 untouched Held-Out Test boards** (`boards 7500..9999` of `data/colab_bundle_10k.pt`) and the independent **500-board Seed-7 benchmark** (`data/colab_bundle_500.pt`) after the 3-generation Colab `NVIDIA L4` GPU self-improvement run:

| Opponent System | Held-Out Test (`2,500` bds) Net IMP/bd | Held-Out Test $t$-stat (Total IMPs) | Independent `colab_bundle_500` (`500` bds) |
| :--- | :--- | :--- | :--- |
| vs. [`brill_distilled.dsl`](../system/brill_distilled.dsl) | **`+0.9624 ± 0.0920`** (up from `+0.3584`) | **`t = +10.46`** (`+2,406 IMPs`) | **`+0.6540 ± 0.2473`** (`t = +2.64`, `+327 IMPs`) |
| vs. [`brill_distilled_shipdd.dsl`](../system/brill_distilled_shipdd.dsl) | **`+0.9184 ± 0.0854`** (up from `+0.3320`) | **`t = +10.75`** (`+2,296 IMPs`) | **`+0.6220 ± 0.2314`** (`t = +2.69`, `+311 IMPs`) |
| vs. [`brill_gpu_evolved.dsl`](../system/brill_gpu_evolved.dsl) *(prior best)* | **`+0.5028 ± 0.0739`** | **`t = +6.80`** (`+1,257 IMPs`) | **`+0.4260 ± 0.2046`** (`t = +2.08`, `+213 IMPs`) |
| vs. [`champion_system.dsl`](../system/champion_system.dsl) | **`+0.8872 ± 0.1331`** | **`t = +6.67`** (`+2,218 IMPs`) | **`+1.0780 ± 0.3282`** (`t = +3.28`, `+539 IMPs`) |
