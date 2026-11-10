# Todo — Next Steps

### 1. Promote `brill_gpu_evolved.dsl` (or `brill_distilled_shipdd.dsl`) to Shipped Default
- `system/brill_distilled_shipdd.dsl` retargets 148 `later_uncont` leaves on the shipped tree using one-step DD IMP value with doubles/redoubles excluded (`research/status.md` §6.88–6.90, **+0.082 ± 0.020 IMP/board** over 9,000 boards).
- `system/brill_gpu_evolved.dsl` (produced by a 6-minute Colab `L4` full-continuation coordinate-ascent run via `research/gpu_evolve_dsl.py` across 5,000 Train + 2,500 multi-opponent Validation boards; 54 rules retargeted, 7 noisy rules ablated across all three slices `BD_open_uncont_`, `BD_later_uncont_`, `BD_later_cont_`) beats both systems on 2,500 untouched Held-Out Test boards:
  - vs `system/brill_distilled.dsl`: **`+0.333 ± 0.077 IMP/board` (`t = +4.31`, `+833 IMP`)**
  - vs `system/brill_distilled_shipdd.dsl`: **`+0.302 ± 0.055 IMP/board` (`t = +5.54`, `+755 IMP`)**
  - vs `system/champion_system.dsl` (third-party transfer): **`+1.267 ± 0.131 IMP/board`** (vs `shipdd`'s `+0.941 IMP/board`, a **`+0.326 IMP/board` transfer gain**).
- **Action**: Promote `system/brill_gpu_evolved.dsl` to `system/brill_distilled.dsl` and refresh the browser assets via `web/build_default_student.mjs` / `src/bid/web_export.py`.

### 2. Break the Representation Bottleneck in Distillation
Data scaling (up to 578k traces, §6.80), tree depth sweeps (§6.62), and one-step leaf relabelling on the existing feature partition (§6.89) have reached their ceiling: within each leaf (~10 conditions), deals still want **7.7–8.2 distinct best calls** and agree on a single best call only **45.3%** of the time in `later_uncont` and **28.6%** in `open_uncont` (§6.86, §6.89).
- **Encode bridge evaluation heuristics from `system/cuebids/rules.txt` as first-class features in `src/bid/features.py` (`BridgeFeatures`)**:
  - **Rule of 15**: 4th-seat opening test (`hcp + spade_len >= 15`).
  - **Rule of 17**: Responder over partner's weak-two (`hcp + support_in_partner_suit >= 17`).
  - **Rule of 24 (LTC)**: Partnership trick projection (`24 - 7 - losing_trick_count`).
  - **Rule of 44**: Strong 2♣ suit-hand gate (`losing_trick_count <= 4 and quick_tricks >= 4`).
  - **Rule of 64**: 6–4 major suit selection comparing HCP in the 4-card vs 6-card suit.
- **Use the new `SuitC` hand-valuation features in tree distillation (`docs/SUITC_INTEGRATION.md` §1)**:
  - `long_suit_intermediates`, `trump_intermediates`, `long_suit_hcp`, and `short_suit_wasted_hcp` are now implemented in `src/bid/features.py` and `research/gpu_arena.py`; re-distill `later_uncont` / `open_uncont` trees to allow splits on them.
- **Continuation-aware (2-step) counterfactual target for `open_uncont`**:
  - One-step DD relabelling failed on `open_uncont` (ceiling +0.021 vs oracle +4.309, §6.89) because an opening bid is never the final contract. Score opening candidates by rolling out 1–2 partner/responder steps with `brill_distilled` before reading the DD table.

### 3. Complete the Slam / RKCB 0314 Layer (`research/brill_slam.md`)
- Wire the 148 RKCB 0314 response rules in `research/brill_slam.md` into `research/brill_to_dsl.py` (or as a high-priority slam layer on top of `brill_distilled`) using the `agreed_trump`, `has_trump_queen`, and `keycard_count_agreed` features, and remove the stale blocker note in `research/brill_slam.md`.

### 4. Refresh the CoT Student on the Distilled Teacher
- `data/cot_model/ckpt.pt` was trained on the earlier 404-token vocabulary and 1,635 traces (§6.10), predating the 27 newest features (`agreed_trump*`, `combined_hcp_*`, `rule_of_21`, etc.) and `brill_distilled_shipdd.dsl`.
- **Action**: Regenerate traces from the promoted teacher (`src/bid/trace_factory.py`), retrain the seq2seq student on the 431-token vocabulary (`src/bid/cot_model.py` / `src/bid/refresh_student.py`), and re-export weights to `web/models/cot/` via `src/bid/cot_export_web.py`.

### 5. Code & Hygiene Fixes
- **Seed `Hand.random()` in `BiddingGapDetector`** (`tests/test_bidding_gaps.py:39-118`): Pass `rng` into `Hand.random(rng)` in `find_opening_gaps`, `find_response_gaps`, and `find_rebid_gaps` so gap counts are reproducible.
- **Port the 31 newer `BridgeFeatures` keys to `web/features.js`**: Add `agreed_trump*`, `*_is_longest`, `*_realsolid`, `partner_hcp_*`, `combined_hcp_*`, `*_first_call`, `opening_bid`, `rule20_total`, `rule_of_21`, `keycard_count_agreed`, `has_trump_*`, `long_suit_intermediates`, `trump_intermediates`, `long_suit_hcp`, and `short_suit_wasted_hcp` so the browser engine matches all 133 Python features (and remove the stale `total_points`/`quick_tricks`/`losing_trick_count` caveat in `web/README.md:54`).

### 6. Colab A100 GPU Acceleration Plan (`research/gpu_arena.py`)
`research/gpu_arena.py` (`TensorDecisionNet`, `DealBundle`, `BatchedAuctionEnv`, `gpu_team_match`, `gpu_continuation_q_values`) and `data/colab_bundle_500.pt` are implemented and verified on a Colab **NVIDIA A100-SXM4-40GB** (`0` call/feature mismatches vs Python `DecisionNet`; **371 ms** for a 500-board duplicate match, **595 ms** / **16,817 boards/sec** for a 10,000-board match, and **4.15 s** for 17,420 full continuation rollouts). Next steps using the GPU arena:
- **6.1 Full-Continuation Leaf Retargeting on A100 (`open_uncont` & `later_cont`)**:
  - Use `gpu_continuation_q_values` in `research/gpu_arena.py` to replace 1-step "stopped here" DD valuation (`research/leaf_ceiling.py`) with multi-step on-policy continuation rollouts $Q^{\pi}(s, a)$ to `PASS-PASS-PASS` and screen leaf retargets over 10,000+ paired boards on Colab A100.
- **6.2 Differentiable Soft / Oblique Decision Trees → `.dsl` Export**:
  - Train temperature-annealed soft decision trees ($\sigma((x_f - \tau_f)/T)$) on A100 directly optimizing expected continuation DD IMP score $\sum_a p_\ell(a) Q(s, a)$, then snap thresholds $\tau_f$ back to standard `RULE BD_*` blocks.
- **6.3 FlashAttention + Batched RL (`src/bid/cot_model.py`, `src/bid/rl_finetune.py`)**:
  - Upgrade `CausalSelfAttention` to `F.scaled_dot_product_attention`, vectorize `rl_finetune.py` across batched boards/trajectories using `BatchedAuctionEnv`, and distill winning trajectories back into `.dsl` via `src/bid/mine_disagreements.py`.

