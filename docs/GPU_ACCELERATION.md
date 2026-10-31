# GPU-Accelerated Bridge Bidding Arena & Search (`research/gpu_arena.py`)

On CPU (`src/bid/arena.py`), running a 500-board duplicate team match takes **~120 seconds** (~4 boards/sec). On an NVIDIA A100 GPU (`research/gpu_arena.py`), 500 boards take **0.37 seconds** and 10,000 boards take **0.59 seconds** (**16,817 boards/sec** — a **300x–4,000x speedup**) with **100% bit-exact call and feature parity** against the Python `DecisionNet` and `BridgeFeatures` implementation.

This document explains why the CPU pipeline is bottlenecked, how each stage is transformed into dense PyTorch tensor operations, and how to run `research/gpu_arena.py` locally (Apple Silicon MPS / CUDA / CPU) or on a remote Google Colab A100 via the `colab` CLI.

---

## 1. Benchmark Comparison

Verified on `data/colab_bundle_500.pt` (seed 7) with **0 call/feature mismatches** across 537 auction decisions:

| Workload | CPU (`arena.py`) | Apple Silicon (`mps`) | Colab `NVIDIA A100-SXM4-40GB` (`cuda`) |
| --- | ---: | ---: | ---: |
| **500-board duplicate match** (1,000 tables) | ~120,000 ms | 5,817 ms | **371.0 ms** (1,348 boards/sec) |
| **10,000-board duplicate match** (20,000 tables) | ~40 min | ~95 s | **594.6 ms** (16,817 boards/sec) |
| **Continuation rollout Q-table** (`500 boards × 38 calls` = 17,420 legal rollouts) | ~35 min | ~65 s | **4,151.7 ms** (4,196 rollouts/sec) |
| **32-candidate rule ablation sweep** (16,000 duplicate boards / 32,000 tables) | ~64 min | ~185 s | **12,400 ms** (1,290 boards/sec) |

### Head-to-Head Results on `data/colab_bundle_500.pt` (500 Boards)

| Matchup | A100 Time | Net IMP / Board | W / L / T |
| --- | ---: | ---: | --- |
| `brill_distilled_shipdd` vs `brill_distilled` | 371.0 ms | `-0.032 ± 0.154` (`t = -0.21`) | 46 / 59 / 395 |
| `brill_distilled_shipdd` vs `champion_system` | 382.5 ms | **`+1.052 ± 0.314`** (`t = +3.35`) | 224 / 164 / 112 |
| `brill_distilled_shipdd` vs `improved_system` | 430.9 ms | **`+2.112 ± 0.386`** (`t = +5.47`) | 285 / 168 / 47 |

### Colab GPU Tier Comparison (`A100` vs `L4` vs `T4`)

Measured live on Google Colab (`colab usage` + 3-run averages after warmup):

| Metric | `NVIDIA A100-SXM4-40GB` | `NVIDIA L4` (24 GB) | `Tesla T4` (16 GB) |
| --- | ---: | ---: | ---: |
| **Compute Unit Burn Rate** (`colab usage`) | `6.73 CU / hr` | `1.94 CU / hr` (**3.5x cheaper**) | `1.15 CU / hr` (**5.9x cheaper**) |
| **Runtime on `399.73` Compute Units** | **59.4 hours** | **206.0 hours** | **347.6 hours** |
| **500-Board Match** (`B = 500`) | 380.5 ms (1,314 bd/s) | 359.0 ms (1,393 bd/s) | **345.9 ms (1,446 bd/s)** |
| **10,000-Board Match** (`B = 10,000`) | **592.3 ms (16,883 bd/s)** | 888.3 ms (11,258 bd/s) | 1,325.6 ms (7,544 bd/s) |
| **Continuation Q-Table** (`500 × 38` = 17,420 rollouts) | 4,259.4 ms (4,090/s) | **4,061.1 ms (4,289/s)** | 4,186.6 ms (4,161/s) |
| **Cost Efficiency @ `B = 500`** (boards / CU) | 0.70M bd / CU (1.0x) | 2.58M bd / CU (**3.7x**) | **4.53M bd / CU (6.4x)** |
| **Cost Efficiency @ `B = 10,000`** (boards / CU) | 9.03M bd / CU (1.0x) | 20.89M bd / CU (**2.3x**) | **23.62M bd / CU (2.6x)** |
| **Cost Efficiency on Q-Table** (rollouts / CU) | 2.19M / CU (1.0x) | 7.96M / CU (**3.6x**) | **13.03M / CU (6.0x)** |

> **Optimal Tier Recommendation**:
> - **Use `T4` (`--gpu T4`, `1.15 CU/hr`) for `B <= 2,000` matches, rule ablation sweeps, and `gpu_continuation_q_values`**: At `B = 500`, each auction step is Python/CUDA kernel-launch latency bound rather than SXM4 bandwidth bound, so `T4` matches `A100` wall-clock speed (`346 ms` vs `381 ms`) at **5.85x lower compute-unit cost** (~348 hours of runtime on 400 CU).
> - **Use `L4` (`--gpu L4`, `1.94 CU/hr`) as the sweet spot for large-batch (`B = 10,000+`) searches and neural/soft-tree training**: `L4` delivers **67% of A100 throughput** at **29% of the cost** (`2.3x` more boards per CU than A100) while supporting `bfloat16`/Ada Tensor Cores and 22 GB VRAM.
> - **Reserve `A100` (`--gpu A100`, `6.73 CU/hr`)** only for massive batch sizes (`B >= 25,000`) or large-batch Transformer RL fine-tuning where 40 GB HBM2e bandwidth is saturated.

---

## 2. How the GPU Speeds Up Bidding Evaluation

The CPU evaluation loop has four main bottlenecks. `research/gpu_arena.py` replaces each of them with vectorized tensor primitives.

### 2.1 Rule Matching: Python Loops → Matrix Multiplication (`TensorDecisionNet`)

* **CPU Bottleneck (`DecisionNet.select_call` in `src/bid/decision_net.py`)**:
  `system/brill_distilled.dsl` contains **1,833 rules** with **21,338 condition checks** (`hcp >= 12`, `partner_last_call == "1H"`, `last_bid_strain in (2, 3)`, etc.). On every turn of every auction, Python loops over all 1,833 rules and evaluates dictionary lookups and `if/else` comparisons sequentially:
  $$\text{10,000 boards} \times 2\text{ tables} \times 10\text{ turns} \times 21,338\text{ conditions} \approx 4.2 \times 10^9 \text{ Python operations}$$

* **GPU Transformation (`TensorDecisionNet` in `research/gpu_arena.py`)**:
  1. **Condition Atom Deduplication**: Across all 21,338 conditions in `brill_distilled.dsl`, there are only **$U = 950$ unique condition atoms** `(feature_col, operator, threshold_or_mask)`.
  2. **Broadcast Atom Evaluation (`evaluate_atoms`)**: Given a batch of $B$ active positions with feature matrix $X \in \mathbb{R}^{B \times 129}$, the GPU gathers `vals = X[:, atom_feat]` of shape $(B, U)$ and evaluates all 950 atoms in a single elementwise kernel (`==`, `!=`, `>=`, `<=`, `>`, `<`, and `in`/`not in` via a precomputed boolean lookup table `atom_in_lut` of shape $(U, 64)$), producing a binary satisfaction matrix:
     $$A \in \{0, 1\}^{B \times U}$$
  3. **Tensor-Core MatMul (`match_rules`)**: Rule conjunction (`AND` over a rule's conditions) is computed as a single matrix multiplication against the sparse-as-dense rule–atom incidence matrix $M \in \{0, 1\}^{R \times U}$:
     $$\text{hits} = A \, M^\top \in \mathbb{R}^{B \times R}$$
     Rule $r$ matches on board $b$ if and only if $|\text{hits}_{b, r} - \text{num\_atoms}_r| < 0.5$. On an A100, a `(10000, 950) @ (950, 1833)` matrix multiplication completes in **< 0.2 ms**.

### 2.2 Priority, Negative Rules (`~Call`), and Tie-Breaking: Sorting → Masked `max`

* **CPU Bottleneck**:
  For each decision, Python collects all matched positive rules, builds a set of calls vetoed by negative rules (`~1NT`), checks each call against `AuctionState.is_legal()`, and sorts candidates by `(-priority, str(call))`.

* **GPU Transformation (`TensorDecisionNet.call_scores`)**:
  - At model compilation time, every positive rule $r$ is assigned a combined scalar score:
    $$\text{rule\_score}_r = 64 \times \text{priority}_r - \text{lex\_rank}(\text{call}_r)$$
    Because there are only 38 calls (`lex_rank` $\in [0, 37]$), scaling priority by $64$ guarantees that higher-priority rules strictly dominate and equal-priority rules break ties in exact ASCII lexicographical order (`str(call)`), matching `DecisionNet.select_call` without sorting or `scatter_reduce`.
  - Negative rules (`~Call`) are evaluated via `neg_matched @ neg_rule_call_mat` to produce a `(B, 38)` veto mask.
  - Any rule whose target call is illegal or vetoed is masked to $-\infty$, and a single `max(dim=1)` over `(B, R)` selects the winning rule and call for all $B$ boards at once. If no positive rule matches, the fallback call `PASS` (index `0`) is selected.

### 2.3 Auction State & Feature Extraction: Object Allocation → Lockstep Tensor State (`BatchedAuctionEnv`)

* **CPU Bottleneck (`BridgeFeatures.extract_all` in `src/bid/features.py`)**:
  At every turn of the auction, Python re-scans the auction `history` from turn 0 to recompute partner's HCP window, agreed trump suit, stopper quality in opponents' suits, vulnerability flags, and hand shape features—even though a player's 13 cards never change during the auction.

* **GPU Transformation (`BatchedAuctionEnv`)**:
  - **Static vs. Dynamic Feature Split**: Roughly **90 of the 129 `BridgeFeatures`** depend only on a player's 13 cards, seat, dealer, and vulnerability (`hcp`, `spades_len`, `losing_trick_count`, `quick_tricks`, `shape_class`, etc.). These are precomputed once per deal into `bundle.hand_features` of shape `(B, 4, 129)`.
  - **Incremental GPU State**: Only the **~39 dynamic auction features** (`last_bid_level`, `partner_hcp_min`, `combined_hcp_min`, `agreed_trump`, `opp_suit_stoppers`, `balancing_seat`, `is_sacrifice_zone`, etc.) are updated incrementally in-place using tensor bitmasks (`seat_suits_mask`, `side_suits_mask`, `last_suit_turn`) as all $B$ auctions step forward in lockstep (`turn = 0..19`).

### 2.4 Contract Scoring: Per-Board `libdds` Calls → $O(1)$ Lookup Tensors (`DealBundle` + `SCORE_LUT`)

* **CPU Bottleneck (`DDSolver` in `src/bid/dds.py`)**:
  Calling the C++ double-dummy solver during matches or rule searches either bottlenecks on native C++ FFI calls or requires compiling `libdds` on the target machine.

* **GPU Transformation (`DealBundle` & `_build_score_lut`)**:
  - Each deal has only $4 \text{ declarers} \times 5 \text{ strains} = 20$ possible double-dummy trick outcomes, stored in `bundle.dd_tricks` of shape `(B, 4, 5)` inside a portable `.pt` file (`data/colab_bundle_500.pt`).
  - All possible duplicate bridge contract scores are precomputed into a 4D GPU lookup tensor `score_lut[contract_idx, doubled, is_vulnerable, tricks]` of shape `(36, 3, 2, 14)`.
  - When $B$ auctions terminate, computing declarer (the first partner on the winning side to bid the final contract's strain), looking up the duplicate score, and converting point differences to WBF IMPs (`points_to_imps_tensor`) is a single vectorized indexing operation taking **< 0.05 ms**.

### 2.5 What Are `data/colab_bundle_*.pt` (`DealBundle` Format)?

`data/colab_bundle_500.pt` (1.2 MB) and `data/colab_bundle_10k.pt` (24 MB) are serialized PyTorch `DealBundle` archives created for `research/gpu_arena.py` and `research/gpu_evolve_dsl.py` (git-ignored as regenerable research intermediates).

Normally, scoring a bridge auction requires calling the native C++ Double-Dummy solver (`bin/libdds.dylib`, macOS ARM64) via `DDSolver`. On a remote Linux Colab GPU VM (or during millions of GPU rollouts), calling C++ `libdds` on the fly would either fail (wrong OS/architecture) or bottleneck the GPU. A `DealBundle` precomputes everything that depends only on the 52 cards of each deal so the GPU can simulate and score **any** possible auction in pure PyTorch with zero `libdds` calls:

| Tensor Key | Shape | Dtype | Contents |
| --- | --- | --- | --- |
| `hand_features` | `(B, 4, 129)` | `float32` | Static initial `BridgeFeatures` for all 4 seats (`N, E, S, W`) before any bids are made (`hcp`, suit lengths, `losing_trick_count`, `quick_tricks`, shape class, vulnerability flags, etc.). |
| `dd_tricks` | `(B, 4, 5)` | `int64` | The **20-entry Double-Dummy trick table** for each board: how many tricks (`0..13`) each of the 4 declarers (`N, E, S, W`) makes in each of the 5 strains (`C, D, H, S, NT`). |
| `dealers` | `(B,)` | `int64` | Dealer seat index (`0=N, 1=E, 2=S, 3=W`). |
| `vulns` | `(B,)` | `int64` | Board vulnerability (`0=NONE, 1=NS, 2=EW, 3=BOTH`). |
| `suit_lengths` | `(B, 4, 4)` | `int64` | Suit lengths `(C, D, H, S)` per seat, used by `BatchedAuctionEnv` to compute `support_in_partner_suit` and `agreed_trump_len` dynamically as the auction unfolds. |
| `suit_has_king` / `suit_has_queen` | `(B, 4, 4)` | `bool` | Whether each seat holds the King / Queen of each suit, used to compute `has_trump_king`, `has_trump_queen`, and `keycard_count_agreed` once a trump fit is agreed. |
| `suit_stopper_q` | `(B, 4, 4)` | `float32` | Per-suit stopper quality (`2.0` for A, `1.0` for Kx+, `0.5` for Qxx+, `0.0` otherwise), used to compute `opp_suit_stoppers` and `has_stopper` in suits bid by opponents. |
| `ace_counts` | `(B, 4)` | `int64` | Number of Aces held by each seat (`0..4`) for RKCB keycard calculation. |

- **`data/colab_bundle_500.pt` (1.2 MB, 500 boards)**: Generated via `python research/gpu_arena.py bundle --boards 500 --seed 7 --out data/colab_bundle_500.pt` using `seed_board(7)` and local `DDSolver.solve_dd_table`. Used for fast 500-board benchmarks and as an independent held-out test set.
- **`data/colab_bundle_10k.pt` (24 MB, 10,000 boards)**: Built from the first 10,000 pre-solved Double-Dummy deals in git commit `c380b29~1:data/brill_dd.0` + `data/brill_traces_330k.jsonl`. Used by `research/gpu_evolve_dsl.py` as the 3-way split (`0..4999` Train, `5000..7499` Validation, `7500..9999` Held-Out Test).

---

## 3. How This Accelerates Bidding Improvement Search

1. **Zero-Recompile Rule Mutation & Ablation Sweeps**:
   Modifying a rule's priority (`net.rule_score[r]`), changing its target call (`net.rule_call[r]`), or ablating a rule (`net.rule_score[r] = -1e9`) mutates a single GPU tensor entry in-place with zero `.dsl` re-parsing. On an A100, screening 32 candidate rule modifications across 500 duplicate boards (32,000 full auctions) takes **12.4 seconds**.
2. **Full-Continuation Counterfactual Rollout Q-Values (`gpu_continuation_q_values`)**:
   One-step double-dummy relabelling (`research/leaf_ceiling.py`) fails on opening bids (`open_uncont`) because an opening bid is never the final contract. `gpu_continuation_q_values` forks all 38 candidate calls across $B$ boards ($38 \times B$ parallel trajectories), forces candidate call $c$ at the target turn, rolls the remainder of the auction out to `PASS-PASS-PASS` under the partnership policy, and returns the exact `(B, 38)` continuation DD score matrix in ~4 seconds per 500 boards.
3. **Full-Continuation Coordinate Ascent (`research/gpu_evolve_dsl.py` → `system/brill_gpu_evolved.dsl`)**:
   Using active-board subsetting (`active_mask[r]`) and mega-batch candidate packing (`run_packed_override_batch`), `research/gpu_evolve_dsl.py` ran a 3-pass full-continuation coordinate-ascent search across 10,000 DD boards on a Colab **NVIDIA L4** in **6.0 minutes** (`0.24 compute units`), with a multi-opponent Validation filter (`brill_distilled_shipdd` + `champion_system`):
   - Exported `system/brill_gpu_evolved.dsl` (**54 rules retargeted, 7 noisy rules ablated** across `BD_open_uncont_`, `BD_later_uncont_`, and `BD_later_cont_`).
   - **Held-Out Test (`2,500` untouched boards)**:
     - vs `brill_distilled.dsl`: **`+0.3332 ± 0.0773 IMP/board` (`t = +4.31`, `+833 IMP`)** (vs `shipdd`'s `+0.0484 IMP/board`)
     - vs `brill_distilled_shipdd.dsl`: **`+0.3020 ± 0.0545 IMP/board` (`t = +5.54`, `+755 IMP`)**
     - vs `champion_system.dsl`: **`+1.2668 ± 0.1311 IMP/board` (`t = +9.66`, `+3,167 IMP`)** (vs `shipdd`'s `+0.9412 IMP/board`, a **`+0.3256 IMP/board` transfer gain**)
   - **Seed-7 Held-Out Bundle (`500` untouched boards)**:
     - vs `brill_distilled.dsl`: **`+0.1440 ± 0.1705 IMP/board` (`+72 IMP`)**
     - vs `brill_distilled_shipdd.dsl`: **`+0.1600 ± 0.1222 IMP/board` (`+80 IMP`)**
     - vs `champion_system.dsl`: **`+1.3320 ± 0.3124 IMP/board` (`+666 IMP`)** (vs `shipdd`'s `+1.0520 IMP/board`, **`+0.2800 IMP/board` transfer gain**)

---

## 4. Usage Guide

### 4.1 Local CLI Commands (MPS / CUDA / CPU)

```bash
# 1. Run unit & parity tests (verifies all 129 features and call parity across systems)
.venv/bin/python -m unittest tests/test_gpu_arena.py -v

# 2. Export a self-contained DealBundle (.pt) with precomputed DD tables
.venv/bin/python research/gpu_arena.py bundle \
  --boards 500 --seed 7 --out data/colab_bundle_500.pt

# 3. Run a GPU/MPS duplicate team match using a precomputed bundle
.venv/bin/python research/gpu_arena.py match \
  --a system/brill_distilled_shipdd.dsl \
  --b system/brill_distilled.dsl \
  --bundle data/colab_bundle_500.pt

# 4. Run a match from scratch with bit-exact Python parity verification
.venv/bin/python research/gpu_arena.py match \
  --a system/brill_distilled_shipdd.dsl \
  --b system/brill_distilled.dsl \
  --boards 64 --seed 7 --verify-parity
```

### 4.2 Running on Google Colab A100 via `colab` CLI

Because `data/colab_bundle_500.pt` includes precomputed `dd_tricks`, the remote Colab VM does **not** need `libdds` compiled—only standard PyTorch (`torch`).

```bash
# 1. Provision an A100 session
colab new -s bid-gpu --gpu A100

# 2. Package and upload code + DSL systems + precomputed DD bundle
tar -czf /tmp/bid_colab_payload.tar.gz \
  src/bid research/gpu_arena.py \
  system/brill_distilled.dsl system/brill_distilled_shipdd.dsl \
  system/champion_system.dsl system/improved_system.dsl \
  data/colab_bundle_500.pt
colab upload -s bid-gpu /tmp/bid_colab_payload.tar.gz /content/bid_colab_payload.tar.gz

# 3. Execute match or search on the remote A100 kernel
colab exec -s bid-gpu << 'EOF'
import sys, tarfile, torch
with tarfile.open("/content/bid_colab_payload.tar.gz", "r:gz") as tar:
    tar.extractall("/content")
sys.path.insert(0, "/content/src")
sys.path.insert(0, "/content/research")

import gpu_arena as ga
dev = torch.device("cuda")
bundle = ga.DealBundle.load("/content/data/colab_bundle_500.pt", device=dev)
net_a = ga.TensorDecisionNet.from_dsl("/content/system/brill_distilled_shipdd.dsl", device=dev)
net_b = ga.TensorDecisionNet.from_dsl("/content/system/brill_distilled.dsl", device=dev)
print(ga.gpu_team_match(bundle, net_a, net_b))
EOF

# 4. Always stop the Colab VM when finished to avoid burning idle compute units
colab stop -s bid-gpu
```

