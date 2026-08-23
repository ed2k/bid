# SDS: Single Dummy Scoring — How It Works

*Companion to [`../dds/sds.md`](../../dds/sds.md) (C++ solver design). This document explains the concept, the Python implementation in [`bid/sds.py`](../sds.py), how it is wired into the evaluation harness, and what it revealed empirically about our bidding systems.*

---

## 1. The problem: perfect information is a lie

Bridge is a game of incomplete information. During the play of a hand, declarer sees exactly **two hands**: their own and dummy's. The defenders' 26 cards are hidden.

Yet every score our evaluation harness produced before SDS was computed like this:

```python
tricks = DDSolver.get_tricks(deal, strain, declarer)   # deal = all four hands
score  = duplicate_score(contract, tricks)
```

The double-dummy solver (DDS) is omniscient. It plays finesses that must win, drops singleton kings offside, and never loses tempo to a hidden break. A contract that "makes" under DDS may be a normal-play loser most of the time.

Consequence we measured: a system whose contracts only make with four-hand omniscience looks as strong as one whose contracts make honestly. Perfect-information scoring **rewards luck disguised as skill**.

---

## 2. The idea: PIMC (Perfect Information Monte Carlo)

SDS replaces the single omniscient answer with an expectation over possible worlds:

```
score(contract) = E_worlds [ duplicate_score(contract, DD_tricks(world)) ]
```

Algorithmically (paper Algorithm 1, Cazenave & Ventos):

```
for i in 1..N:
    w        ← sample a completion of the hidden cards consistent with what is known
    t        ← double_dummy_tricks(w, contract)     # exact solve inside the world
    score[i] ← duplicate_points(contract, t)
return mean(score), P(make) = mean(t >= needed), mean(t)
```

This is exactly how strong real-world programs (GIB lineage) evaluate positions, and it is the depth-M=1 special case of the αμ search algorithm. The deeper αμ machinery (M ≥ 2, Pareto fronts of outcome vectors, strategy-fusion repair) layers on later; PIMC is the honest baseline.

Key framing from the design doc:

- **Known seats stay fixed.** Declarer + dummy holdings are copied into every world untouched.
- **Each world is solved exactly.** Inside a world, everyone has perfect information — that is the accepted PIMC approximation ("strategy fusion" is its known defect; see §6).
- **The expectation across worlds is where realism enters.** A finesse that wins in this world and loses in that world nets out to ~50%, which is what a real declarer faces.

---

## 3. World sampling constraints (`WorldSampler` v1)

`SDSScorer.sample_worlds(deal, viewer_seats, n, rng)` generates completions satisfying:

| Constraint | Implementation |
| --- | --- |
| Known seats fixed | viewer pair (declarer + dummy) holdings never touched |
| Card conservation | the two hidden hands' actual cards are pooled and re-dealt — every rank appears exactly once |
| Hand lengths preserved | each hidden seat receives back exactly as many cards as it held |
| Uniform acceptance | plain shuffle; no reweighting (v1) |

Notably, our sampler can be upgraded later to use the RBMBMC auction-consistent sampler instead of uniform shuffling — the same interface, strictly tighter worlds (model-conditioned sampling is the repo's own core research idea applied inside scoring).

---

## 4. The objectives

For each played contract `(level, strain, declarer, doubled)` we report three aggregates over N=20 worlds:

- **P(make)** — fraction of worlds where DD tricks ≥ level+6 (the sds.md K7 default objective).
- **Mean tricks** — raw trick expectation.
- **Expected duplicate score** — mean duplicate points (vulnerability-aware, doubles honored), signed to the declarer partnership. This is the headline number used in rankings because it matches how bidding decisions are actually scored at the table.

All three are cheap: each world costs one native DDS table call (~1 ms), so a contract costs ~20–40 ms.

---

## 5. Wiring in this repo

```
bid/sds.py                 SDSScorer, SDSResult
eval_vs_dds.py --sds       dual columns: true-DD score AND SDS score per system
flywheel.py --sds          save-gate: reject patches whose DD gain is SDS-negative
flywheel.py --sds-primary  hill-climb directly on the SDS objective
tests/test_sds_scoring.py  known-seat preservation, determinism, bounds
```

Evaluation flow per board when `--sds` is enabled:

```
auction simulated by system under test
        ↓
final contract extracted
        ↓
DD score   = exact tricks on the true deal          (old metric)
SDS score  = ± mean over 20 sampled worlds          (new metric,
             declarer-partnership two-hand view      signed NS-perspective)
```

Both numbers come from the *same auctions*, so per-system comparisons between them are paired and noise-free.

---

## 6. What it revealed (measured, 48-board set)

Dual-scoring run across all repo systems:

| System | True-DD score | SDS score | Δ | Reading |
| --- | --- | --- | --- | --- |
| AOP archetype | +115.8 | +112.1 | −3.7 | robust: contracts make honestly |
| SUP archetype | +108.1 | +108.6 | +0.5 | robust |
| champion (SUP copy) | +106.2 | +104.6 | −1.6 | robust |
| **improved_system v11** | +85.8 | **+64.5** | **−21.3** | aggressive style partly omniscience-luck |
| Pipeline Baseline | +41.0 | +49.3 | +8.3 | solid partscores upgraded |
| ARP archetype | +35.2 | +47.7 | +12.5 | biggest upgrade |

Three lessons:

1. **Aggressive systems were flattered by omniscient declarers.** v11's slam drives and penalty doubles make far less often when declarer sees two hands. Its apparent parity with the conservative archetypes was partly an artifact.
2. **Conservative archetypes are robust.** AOP/SUP/champion lose almost nothing — their contracts do not require seeing the full deal.
3. **Underbidding systems get partially forgiven.** ARP/Pipeline missed games under DD accounting, but their partscores are sound under realistic play, so SDS upgrades them.

A concrete example: a doubled contract set 4 with DDS showing down-4 may average much worse across worlds if the set depended on a defensive position visible only with all four hands — or better, if the set was robust. SDS distinguishes these; raw DD cannot.

### Known limitations inherited from PIMC

Two defects are well understood in the incomplete-information search literature (Frank & Basin) and motivate the αμ algorithm:

- **Strategy fusion**: within each world, declarer may take different lines for different worlds — impossible in reality. This biases P(make) optimistically for lines that need world-specific play (the paper's spade-finesse example).
- **Non-locality**: locally best expectations can mislead globally. Also deferred to αμ.

#### What strategy fusion actually is

Consider a two-stage spade ending. Dummy (North) holds ♠ A J 10; declarer's hand is low; the hidden five spades — K Q and three smalls — sit with the defenders, three in East and two in West. The goal is three spade tricks.

In **any single real deal**, declarer must commit: either play for the double finesse (J into East's K/Q region, then repeat through 10) or for the drop. The honest chance of winning all three tricks with one committed strategy is modest — the double finesse needs *both* majors in East (roughly 30% for a 3–2 hidden split), while the drop needs K Q doubleton in West (10%), and no single plan captures both.

PIMC, however, evaluates each world separately, and inside each world the omniscient solver simply takes whichever line works *there*: the double finesse in worlds where K and Q are both in East, the drop in worlds where West holds K Q tight, partial measures elsewhere. Every world reports success, so the averaged value approaches ~100%.

The error has a precise name: the search **fuses incompatible strategies**. It assumes declarer will play the J-finesse *and* the drop — two mutually exclusive plans — depending on which world he turns out to be in. A real declarer cannot condition his play on information he does not have. PIMC grants him exactly that clairvoyance at every future decision point, which inflates the value of flexible-looking lines.

#### Why a single-decision finesse has exactly zero bias

Fusion requires **at least two sequential Max decisions**. The inflation mechanism is: choose line L1 in worlds where L1 works, line L2 elsewhere — possible only if there *is* a later decision point where the choice can diverge per world.

With exactly one non-forced decision remaining, the mechanism cannot engage:

1. Each candidate card `c` is scored as `V(c) = E_w[ u(c, w) ]`, where `u` is the DD-optimal *continuation*. If everything after the card is technical (forced winners, established tricks), the continuation contains no further choices to fuse.
2. A real declarer who commits to `c` earns exactly `u(c, w_true)` in the true world. The expected value of the commitment policy "always play c" is therefore `E_w[u(c, w)] = V(c)` — identical to what PIMC computes.
3. `argmax_c V(c)` is thus the genuinely best fixed commitment, and its reported probability equals its true probability. Sampling contributes variance, not bias.

So for the classic single finesse — lead toward the A Q once, K onside or not — PIMC's number is the *correct* number. The 50/50 measured in the previous section is not approximately right; it is right.

Two boundary conditions keep this guarantee honest:

- The continuation after the last decision must be choice-free. If "win the finesse, then decide whether to repeat" hides a second decision inside the rollout, we are back in two-decision territory and mild fusion returns.
- The DD continuation assumes perfect defense. That is a separate, conservative assumption (best-defense baseline), not a fusion effect.

**Where our repo stands:** `SDSScorer.score_contract` performs *zero* declarer decisions — it scores a finished auction by DD trick counts per world, so it carries no fusion exposure at all. Fusion risk only enters if we later adopt card-play search (`sds::solve_pimc`, design-doc PR2) over multi-stage lines such as endplays and suit establishment. The bidding engine's own model-based rollouts have an analogous (milder) flavor: each seat bids per-world via its rule net, which is itself a per-world adaptation — acceptable today, worth revisiting if rollouts grow deeper.

#### How αμ M ≥ 2 removes the bias

αμ (paper Algorithms 2–6) replaces scalar averaging with **strategy-consistent search over outcome vectors**:

| Mechanism | Effect |
| --- | --- |
| Max nodes force **one move across all valid worlds** | the clairvoyance PIMC grants is removed; the search can no longer fuse incompatible plans |
| Outcomes tracked as `OutcomeVector` (one entry per world), aggregated into `ParetoFront`s | keeps full per-world information instead of collapsing to a mean too early |
| Min nodes use `min_join`; each defender may still act per-world | defenders are genuinely independent adversaries, so their flexibility is preserved |
| `M` = number of remaining Max commitments before falling back to per-world leaves | explicit knob on how much fusion is forbidden |
| Iterative deepening M = 1, 2, 3, … with root cuts and an αμ transposition table | converges toward the honest game value while keeping compute bounded |

At M = 1 αμ *is* PIMC (the biased-but-cheap baseline). As M grows, the search is forced to commit to earlier lines before seeing which world materializes, and the reported values descend from the fused fantasy toward the achievable truth. In the A-J-10 ending above, an M ≥ 2 αμ search discovers that no single opening lead secures three tricks in all surviving worlds, and returns the realistic ~30–40% rather than ~100%.

This is why the design doc stages delivery as PIMC-first (`max_depth_ = 1`) with the αμ types (`OutcomeVector`, `ParetoFront`, `WorldSet`) defined from day one: the upgrade path changes search internals without changing the API, and golden tests encode the documented PIMC failure so the correction can be flipped on deliberately.
- **Uniform worlds ignore the auction.** Opponents who bid weak two-bids presumably do not hold 18 HCP; RBMBMC-conditioned sampling would tighten this. Extension point noted in sds.md (`Constraint.accepts(Deal)`).

---

## 7. Using it

```bash
# leaderboard with both metrics
PYTHONPATH=.. python3 eval_vs_dds.py --boards 48 --no-stratified --sds

# flywheel that refuses luck-based saves
PYTHONPATH=.. python3 flywheel.py --deals 40 --rounds 3 --pool-cap 12 --sds

# hill-climb directly on realistic-information EV
PYTHONPATH=.. python3 flywheel.py --deals 32 --rounds 2 --pool-cap 8 --sds-primary
```

Python API:

```python
from bid.sds import SDSScorer
scorer = SDSScorer(num_worlds=20, seed=2024)
res = scorer.score_contract(deal, level=6, strain=Strain.NT,
                            declarer=Seat.SOUTH, doubled=0, vuln=0)
print(res.p_make, res.mean_tricks, res.mean_score)
```

Determinism: results are reproducible for a fixed `seed`; production runs should pass distinct seeds per board to avoid correlated worlds.

---

## 8. Path forward

1. **RBMBMC-conditioned worlds** — replace uniform shuffle with model-consistent sampling for tighter posteriors (unique strength of this repo vs generic SDS).
2. **αμ M≥2** — port Algorithm 2–6 semantics into Python for strategy-fusion-aware leaf evaluation once PIMC-based tuning stabilizes.
3. **Score-aware objectives in search** — currently bidding lookahead uses expected duplicate points already; aligning its world count/budget with the SDS scorer would unify training and evaluation signals.
4. **Grand-slam verification ladders** — combine the control-ask bidding structure with SDS thresholds (e.g., require SDS P(make) ≥ 0.55 before driving slams).

---

## References

- Cazenave & Ventos, *The αμ Search Algorithm for the Game of Bridge*, arXiv:1911.07960
- `../dds/sds.md` — SDS integration design for DDS3 (types, TT lifecycle, PR plan)
- Frank & Basin, *Search in games with incomplete information* (strategy fusion, non-locality)
- Ginsberg, GIB — original PIMC in competitive bridge
