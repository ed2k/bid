# Borrowing from `../SuitC`: Hand Valuation, Single-Dummy Scoring, and Pareto-Front Play Search

This document outlines what the `bid` repository can borrow from Gerrit A. van der Velde's [`../SuitC`](../../SuitC/README.md) repository (containing the `SuitC` single-dummy suit-combination analyzer, the multi-layout `dds` solver, the `playc` combination enumerator, and Gerrit's hand-valuation studies).

---

## 1. Hand Valuation Features from Gerrit's Suit-Combination Studies

### Background (`../SuitC/docs/hand-valuation.md` & `../SuitC/examples/strength/`)

In [`hand-valuation.md`](../../SuitC/docs/hand-valuation.md) and [`examples/strength/KQ`](../../SuitC/examples/strength/KQ), Gerrit analyzed all 105 partnership suit-length splits (`11.xp` … `b1.xp`) using exact single-dummy play to measure where standard Milton Work `hcp` + length evaluation breaks down. Even with the **exact same partnership card count (7 cards) and the exact same high-card points (5 HCP: K and Q)**, expected playing strength ranges from **1.73 tricks to 3.43 tricks** (**1.70 tricks difference**) due to three factors:

1. **Intermediate Cards (`T`, `9`, `8`) in Long Suits Are Worth Nearly a Full Trick**:
   - In a 2–5 fit with divided honors (`Kx` opposite `Qxxxx`), adding `T, 9, 8` increases expected tricks from **2.37** (`Q5432`, 46.8% chance of 3 tricks) to **3.30** (`QT982`, 100.0% chance of 3 tricks) — **+0.93 tricks with 0 additional HCP**.
   - In a 3–4 fit (`Kxx` opposite `Qxxx`), `QT92` (2.53 tricks) beats `KQ32` (1.96 tricks) by **+0.57 tricks**.
2. **Honor Concentration in Long Suits vs. Wasted Honors in Short Suits**:
   - In a 2–5 fit, holding both honors in the 5-card hand (`KQ432` opposite `xx`: **2.72 tricks**) beats divided honors (`Q5432` opposite `Kx`: **2.37 tricks**) by **+0.35 tricks**.
   - Conversely, holding both honors tight in the **2-card** hand (`KQ` doubleton opposite `xxxxx`: **2.64 tricks**, only 5.8% for 4 tricks) is **weaker** than divided honors (`Q2` opposite `Kxxxx`: **2.72 tricks**, 12.4% for 4 tricks) because one honor crashes under the Ace.
3. **Bayesian Partner Suit Weighting (`../SuitC/scripts/sc-weight`)**:
   - `sc-weight` weights North's possible holdings in the target suit by `(a)` North's overall HCP range (`partner_hcp_min..max`) and `(b)` how many honors South holds in the *other* three suits: the more side-suit honors South holds, the more likely North's announced HCP sit inside the target suit.

### Proposed Changes in `src/bid/features.py` (`BridgeFeatures`) & `research/gpu_arena.py`

Currently, `BridgeFeatures` tracks `tens_count` across the whole hand and `*_honors` (`A, K, Q, J`), which treats `Q982` + `KT543` identically to `Q432` + `KT985` and treats `KQ` doubleton as a full 5 HCP. To break the within-leaf representation bottleneck (`research/todo.md` §2):

| New Feature Key | Definition | Purpose |
| --- | --- | --- |
| `long_suit_intermediates` | Count of `T, 9, 8` in suits of length $\ge 5$ (or in `longest_suit`) | Captures the +0.6 to +0.9 trick boost from `T98` body in 5+ card suits (`hand-valuation.md`). |
| `trump_intermediates` | Count of `T, 9, 8` in `agreed_trump` (or `partner_last_bid_strain`) | Distinguishes `QJT9x` / `QT9xx` trump support from `Qxxxx` in game/slam decisions. |
| `long_suit_hcp` | Total HCP located inside suits of length $\ge 5$ | Rewards concentrated honors (`KQxxx`, `AJTxx`) in long suits. |
| `short_suit_wasted_hcp` | HCP from `K, Q, J` in singleton or doubleton suits lacking the Ace (`K`, `Q`, `J`, `KQ`, `KJ`, `QJ`, `Qx`, `Jx`) | Penalizes crashing/unprotected short honors (`KQ` sec, `Qx`, `J` singleton) unless partner has bid that suit. |

---

## 2. Single-Dummy Suit & Contract Valuation vs. Double-Dummy Over-Optimism

### Background (`../SuitC/examples/dds/TA` & `../SuitC/docs/database.md`)

In [`examples/dds/TA`](../../SuitC/examples/dds/TA), Gerrit compares Double-Dummy (`DDS`) against Single-Dummy (`SuitC`) across 14 layouts of the same ending:
- **Double-Dummy** claims declarer wins 4 tricks on **7 of 14 layouts** (because DD peeks at East–West's cards on each layout and picks the line that works for that specific layout).
- **Single-Dummy** shows that any single declarer strategy wins 4 tricks on **at most 4 of 14 layouts**.

In our codebase, both `research/leaf_ceiling.py` and `research/gpu_arena.py` evaluate contracts using 20-entry Double-Dummy tables (`dd_tricks`). As a result:
- Contracts requiring a two-way finesse, a backward finesse, or peeking at a stiff King offside are credited with making 100% of the time on the layouts where the card sits favorably, inflating the apparent value of thin games (`3NT`, `4M`) and 50% or 25% slams (`6M` missing `Qxx` or `Kx`).

### Proposed Integration

1. **Compile `SuitC` as a Local CLI / Helper (`bin/SuitC`)**:
   - `../SuitC` is pure dependency-free C (`cmake -S ../SuitC -B ../SuitC/build && cmake --build ../SuitC/build --config Release`).
   - With `-DSUITCAPP=YES` (used by `BEN` and `SuitCWinLib`), `SuitC` outputs compact machine-readable expected tricks (`MAX`) and safety-play probabilities (`N<k>`).
2. **Single-Dummy Trump Loser & Safety-Play Lookup for Slam / Game Auditing**:
   - When evaluating slam candidates (`6C..6NT`, `7C..7NT`) or auditing `brill_gpu_evolved.dsl` vs `brill_distilled.dsl`, query `SuitC` on the partnership's combined trump holding (`N_trump`, `S_trump`) to get:
     - `E[trump_tricks]`: true single-dummy expected tricks in the trump suit.
     - `P(0 trump losers)` and `P(<= 1 trump loser)`: exact single-dummy probability (`N<len>` and `N<len-1>`), replacing double-dummy peeking on the trump queen/king.

---

## 3. Fixing Strategy Fusion in `src/bid/sds.py` via `SuitC`'s `QUIRK` Pareto-Front Algorithm

### The Strategy-Fusion Bug in `src/bid/sds.py`

In [`src/bid/sds.py`](../src/bid/sds.py#L353-L360) (`PlaySearcher._search`), interior Max nodes (declarer/dummy turns after trick 1) currently do:

```python
        if st["to_play"] in st["max_side"]:
            moves = legal_cards(st["max_hands"][st["to_play"]], st["trick"])
            best = None
            for c in moves:
                ns, nw = self._apply(st, worlds, c)
                vec = self._search(ns, nw)
                best = vec if best is None else OutcomeVector.elementwise_max(best, vec)
            return best if best is not None else self._leaf(st, worlds)
```

Calling `OutcomeVector.elementwise_max(best, vec)` at an interior Max node commits **strategy fusion** (Frank & Basin 1998; Cazenave & Ventos 2019): it assumes declarer can choose card $c_1$ in world $w_1$ and card $c_2$ in world $w_2$ at an interior node even when both worlds belong to the same information set (i.e., defenders played identical cards).

### How `SuitC` Solves This (`../SuitC/src/merge_quirk.c`, `clean_quirk.c`, `use_suit_entries.c`)

In [`../SuitC/docs/algorithm.md`](../../SuitC/docs/algorithm.md#L41-L54), `SuitC` eliminates strategy fusion by propagating a **Pareto front of non-dominated strategy outcome vectors** (`QUIRK` tree) bottom-up:

1. **Representation (`Front = List[OutcomeVector]`)**:
   - A strategy vector $v = (v_1, \dots, v_W)$ dominates $u = (u_1, \dots, u_W)$ iff $v_w \ge u_w$ for all worlds $w$ and $v_w > u_w$ for at least one $w$ (`add_quirk.c` / `check_quirk.c`).
   - Weak domination (`check_zermelo.c`, `-z1`) also prunes strategies with identical outcome profiles.
2. **At a Max Node (Declarer / Dummy)**:
   - Declarer must choose **one** strategy from the available moves. Therefore, a Max node takes the **Pareto-pruned set union** of its children's fronts (`Front.union`), **never** `elementwise_max` across moves.
3. **At a Min Node (Defenders)**:
   - Because each defender move $c$ is legal on a subset of worlds $W_c \subseteq \{1, \dots, W\}$ (and partitions the worlds when defenders' plays reveal information or when defenders choose best responses per world), `merge_quirk.c` combines child fronts across world subsets (`elementwise_min` where a world has multiple legal defender responses, Cartesian combination across disjoint world partitions) followed by Pareto pruning (`clean_quirk.c`).
4. **Entry-Preserving Tie-Breaking (`../SuitC/src/use_suit_entries.c`)**:
   - When multiple non-dominated strategies tie on objective value (e.g. `P(make)` or `E[tricks]`), `use_suit_entries.c` (`-u` flag, designed for `BEN`) selects the strategy that wins tricks earliest and preserves entries inside the suit (`e_up`).
5. **IMP / Matchpoint Minimax Solver (`../SuitC/src/minimax.c`)**:
   - When defenders' optimal defense requires a mixed strategy (so declarer's best response at MP or IMPs is also a mixed strategy), `minimax.c` solves the zero-sum matrix game over the Pareto front via a 160-line Simplex routine.

---

## 4. Card-Sequence Equivalence & Vacant-Places World Conditioning

### Background (`../SuitC/src/create_all_boards.c` & `../SuitC/dds/build_seqc.c`)

In `src/bid/sds.py`:
- `legal_cards()` expands every spot card (`♠5`, `♠4`, `♠2`) as a separate branch in the search tree.
- `SDSScorer.sample_world_dicts()` shuffles the 26 unknown cards uniformly across East and West.

In `../SuitC`:
1. **Touching-Card / Sequence Compression (`build_seqc.c`, `join_scard.c`, `playc/determine_sequences.c`)**:
   - Touching cards held by the same seat (or small cards equivalent after removing North–South cards) are merged into a single canonical move with multiplicity `dupl[i]`.
   - Borrowing this into `legal_cards()` in `src/bid/sds.py` reduces the branching factor of `PlaySearcher` by **3x–5x** without changing exactness.
2. **Vacant-Places Hypergeometric Weighting (`create_all_boards.c` lines 51–70)**:
   - `SuitC` weights each East–West split of $ic$ missing cards across $wc$ West vacant places and $ec$ East vacant places using the exact hypergeometric ratio:
     $$P(\text{East holds } k \text{ of } ic) = \frac{\binom{wc}{ic - k} \binom{ec}{k}}{\binom{wc + ec}{ic}}$$
   - When an opponent has bid a 5+ card suit (or preempted a 6–7 card suit) during the auction, setting `westvac` / `eastvac` in `SDSScorer` weights single-dummy worlds by vacant places directly in $O(1)$ without rejection-sampling thousands of deals.

---

## 5. Implementation Roadmap

1. **Phase 1 — Hand Valuation Features (`src/bid/features.py` + `research/gpu_arena.py`)**:
   - Add `long_suit_intermediates`, `trump_intermediates`, `long_suit_hcp`, and `short_suit_wasted_hcp` to `BridgeFeatures` (alongside the `system/cuebids/rules.txt` heuristics in `research/todo.md` §2).
   - Re-distill and run `research/gpu_evolve_dsl.py` to measure out-of-sample IMP/board gain on the 3,000 held-out test boards.
2. **Phase 2 — Pareto-Front (`QUIRK`) & Sequence Pruning in `src/bid/sds.py`**:
   - Add touching-card equivalence pruning to `legal_cards()` in `src/bid/sds.py`.
   - Replace `OutcomeVector.elementwise_max` at interior Max nodes in `PlaySearcher._search` with a non-dominated Pareto `Front` (`union` at Max nodes, cross-world merge at Min nodes, bounded by `SearchConfig.front_cap`), and implement `M`-depth stopping (`research/todo.md` §5).
3. **Phase 3 — Vacant-Places Weighting & `SuitC` Single-Dummy Slam Audit**:
   - Add vacant-places hypergeometric world weighting to `SDSScorer` when opponents have shown length during the auction.
   - Build `../SuitC` (`bin/SuitC`) and add an optional single-dummy trump-suit evaluator for slam (`6M`/`7M`) leaf auditing.

---

## 6. Implemented Architecture & Measured Results

All three phases above have been implemented and verified across [`src/bid/suitc.py`](../src/bid/suitc.py), [`src/bid/sds.py`](../src/bid/sds.py), [`src/bid/features.py`](../src/bid/features.py), [`research/gpu_arena.py`](../research/gpu_arena.py), [`system/brill_gpu_evolved.dsl`](../system/brill_gpu_evolved.dsl), and [`tests/test_suitc.py`](../tests/test_suitc.py).

### 6.1 Empirical Validation of `SuitC` Hand-Valuation Features on 40,000 Solved Hands

To verify whether Gerrit's single-suit findings transfer to full 52-card Double-Dummy play, we evaluated the 4 new `SuitC` features across all **40,000 hands** (`10,000` deals $\times$ `4` seats in `data/colab_bundle_10k.pt`). Holding **Milton Work HCP (`12–14`) and suit length (a single `5`-card suit) strictly constant** ($n = 3,308$ opening-strength hands), the `SuitC` features separate actual Double-Dummy trick production by up to **nearly half a trick**:

| `SuitC` Feature (at fixed `12–14 HCP`, single `5`-card suit) | Bucket | Hands ($n$) | Mean DD Tricks (5-Card Suit) | Mean DD Tricks (NT) | Effect at Identical HCP |
| :--- | :--- | ---: | ---: | ---: | :--- |
| **`long_suit_intermediates`** (`T, 9, 8`) | `0` intermediates | 808 | `8.219` | `6.819` | Baseline |
| | `1` intermediate | 1,616 | `8.447` | `7.093` | `+0.228` suit / `+0.274` NT |
| | `2` intermediates | 809 | **`8.507`** | **`7.096`** | **`+0.288` suit / `+0.277` NT** |
| **`long_suit_hcp`** (working honours in 5+ suit) | `0–2` HCP in 5-suit | 401 | `8.035` | `6.828` | Baseline |
| | `3–5` HCP in 5-suit | 1,630 | `8.404` | `7.013` | `+0.369` suit / `+0.185` NT |
| | `6+` HCP in 5-suit | 1,277 | **`8.503`** | **`7.082`** | **`+0.468` suit / `+0.254` NT** |
| **`short_suit_wasted_hcp`** (`K/Q/J` in $\le 2$-card suit w/o `A`) | `0` wasted HCP | 1,880 | **`8.574`** | **`7.088`** | Baseline |
| | `1–2` wasted HCP | 728 | `8.217` | `6.901` | `-0.357` suit / `-0.187` NT |
| | `3+` wasted HCP | 700 | `8.111` | `6.949` | **`-0.463` suit / `-0.139` NT** |

### 6.2 Duplicate Bidding Improvement on Held-Out Test Boards (`+0.067` to `+0.069 IMP/board`)

Using the 3-way split on `data/colab_bundle_10k.pt` (`5,000` Train / `2,500` Validation / `2,500` untouched Held-Out Test), we screened candidate rule splits on `short_suit_wasted_hcp`, `long_suit_hcp`, `long_suit_intermediates`, and `trump_intermediates` and greedily accepted **14 rule splits** ([`system/brill_gpu_evolved.dsl`](../system/brill_gpu_evolved.dsl#L30479-L30690)) that improved Validation scores across all three benchmark opponents (`brill_distilled.dsl`, `brill_distilled_shipdd.dsl`, and `champion_system.dsl`).

On the **2,500 untouched Held-Out Test boards**, adding the 14 `SuitC`-feature rule splits improves duplicate IMP/board against every opponent:

| Opponent System (`2,500` Held-Out Test Boards) | Before `SuitC` Splits | After `SuitC` Splits | Additional Gain from `SuitC` | Total Held-Out Edge |
| :--- | ---: | ---: | ---: | ---: |
| vs [`system/brill_distilled.dsl`](../system/brill_distilled.dsl) | `+0.2896 IMP/bd` (`+724 IMP`) | **`+0.3584 ± 0.0737 IMP/bd`** (`t = +4.86`) | **`+0.0688 IMP/bd` (`+172 IMP`)** | **`+896 IMP`** |
| vs [`system/brill_distilled_shipdd.dsl`](../system/brill_distilled_shipdd.dsl) | `+0.2652 IMP/bd` (`+663 IMP`) | **`+0.3320 ± 0.0544 IMP/bd`** (`t = +6.10`) | **`+0.0668 IMP/bd` (`+167 IMP`)** | **`+830 IMP`** |
| vs [`system/champion_system.dsl`](../system/champion_system.dsl) | `+1.2596 IMP/bd` (`+3,149 IMP`) | **`+1.3016 ± 0.1217 IMP/bd`** (`t = +10.69`) | **`+0.0420 IMP/bd` (`+105 IMP`)** | **`+3,254 IMP`** |

### 6.3 Single-Dummy Play Search Speedup & Strategy-Fusion Elimination (`src/bid/sds.py`)

1. **`2.06x` Search Speedup from Touching-Card Sequence Pruning ([`canonical_legal_cards`](../src/bid/sds.py#L358-L384))**:
   - Across 25 4-trick, 4-world single-dummy endgames, collapsing contiguous touching cards held in the same hand (`Q-J-T`, `5-4`, etc.) reduces [`PlaySearcher.solve_amu`](../src/bid/sds.py#L714-L716) wall-clock runtime from **`182.7s` to `88.7s` (`2.06x` speedup, `-51.5%` search time)** with zero loss of exactness.
2. **Elimination of Interior Max-Node Strategy Fusion ([`Front`](../src/bid/sds.py#L420-L542) / `QUIRK`)**:
   - Propagating non-dominated Pareto fronts (`Front.union` at Max nodes, `Front.min_merge` at Min nodes) eliminates interior declarer-side strategy fusion, which previously inflated expected trick counts on **`5.0%` of random 3-trick, 6-world endgames** and by up to **`+0.50` fake tricks** on two-way discard/guess positions ([`test_front_prevents_strategy_fusion_at_interior_max_node`](../tests/test_suitc.py#L94-L173)).

### 6.4 Native `SuitC` Solver & Vacant-Places Weighting (`src/bid/suitc.py`, `src/bid/sds.py`)

- **[`SuitCSolver`](../src/bid/suitc.py#L67-L280)** wraps [`bin/SuitC`](../bin/SuitC) with `@lru_cache(maxsize=4096)`, solving single-dummy expected tricks (`expected_tricks`), safety-play probabilities ([`p_at_least`](../src/bid/suitc.py#L57-L63)), entry limits (`north_entries`, `south_entries`), and defensive NT stoppers ([`stopper_tricks`](../src/bid/suitc.py#L266-L280)) in **`~2 ms` uncached / `<1 µs` cached**.
- **[`SDSScorer.infer_vacant_places`](../src/bid/sds.py#L114-L148)** and **[`SDSScorer.hypergeometric_suit_weight`](../src/bid/sds.py#L151-L179)** apply `SuitC`'s exact hypergeometric vacant-places weighting when opponents have bid or preempted a suit during the auction (e.g., shifting `AQ2` opposite `543` from `50.48%` a priori to `33.34%` when West has shown 7 cards in another suit).

