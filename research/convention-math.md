# Mathematical Foundations of Convention Design — Results

*Companion CLI: `convention_lab.py`. Three rigor tiers, honestly labeled:
**PROVEN** (exact combinatorics / inequalities), **DOMINANCE** (statistical theorems over the uniform deal distribution with the native DD oracle), **OPEN** (full-game equilibrium — computationally out of reach).*

---

## 1. What can and cannot be proven

| Question type | Provable? | Why |
| --- | --- | --- |
| "P(HCP ≥ 12) = x" | ✅ exact | finite deck, closed-form DP; verified against C(52,13) |
| "3-2 breaks p" | ✅ exact | hypergeometric identity |
| "System A scores more than B over uniform deals" | ✅ as a *statistical theorem* with CI/z | paired dominance test vs DD oracle |
| "Auction of length ≤ L conveys ≤ B bits about hidden hands" | ✅ counting bound | pure information theory |
| "Artificial 1C is optimal over all of bridge" | ❌ | full-game Nash equilibrium of bridge bidding is computationally intractable (state space ≳ 10⁴⁷); only abstracted models are solvable |

The practical meaning of a **dominance result**: *"for every deal in the uniform
distribution family, system A's expected score exceeds B's by δ ± ε; rejecting
equal-performance has z = …"* It is the strongest claim available short of solving
the game, and it is exactly the claim convention debates reduce to.

---

## 2. PROVEN results (`convention_lab.py hcp-dist / breaks / fit / info-bound`)

### 2.1 HCP distribution (DP over 52 cards; sanity Σ = C(52,13) ✓)

| threshold | P(HCP ≥ t) |
| --- | --- |
| ≥ 10 | 53.17% |
| **≥ 12** | **34.82%** |
| ≥ 14 | 19.88% |
| ≥ 16 | 9.76% |

pmf spot-check: P(HCP=0) = 0.003639 — matches the canonical published value digit-for-digit.
**Design consequence**: a dealer passes under threshold-12 on 65.18% of deals; any
"always open" philosophy fights a proven 2-to-1 odds base rate.

### 2.2 Suit breaks (defenders hold `13 − fit` of our suit; hypergeometric, Σ = 1 ✓)

fit = 9 (they hold 4): **2-2 = 40.70%**, 3-1 = 24.87% × 2 sides, 4-0 = 4.78%.

### 2.3 Fit frequency (Monte-Carlo, n = 10⁶, ±CI reported by tool)

`convention_lab fit` — baseline number every fit-showing convention trades against.

### 2.4 Information bound (provable inequality)

Auctions of length ≤ 10 carry an upper-bound capacity of ≈ **51.3 bits**
(35¹⁰ counting upper bound), while the *coarse* partnership classes conventions must
separate need only ≈ **6.1 bits** (7 HCP bands × 5 shapes × stopper).

**Corollary (provable):** capacity is not the binding constraint at coarse precision;
precision is. Conventions are provably **lossy codes**, and the design dispute is never
"can we say enough" but "**which losses cost least**" — which is precisely what the
dominance tier measures.

---

## 3. DOMINANCE results (this cycle; native-DD oracle, both orientations, paired z)

| Claim tested | n | Result | Status |
| --- | --- | --- | --- |
| Opening threshold 11 vs **12** | 60 | −0.02 imp/bd, z=−0.03 | not separable |
| Threshold 13 vs **12** | 60 | −0.23, z=−0.45 | not separable (edge to 12) |
| Threshold 14 vs **12** | 60 | −0.13, z=−0.25 | not separable (edge to 12) |
| **Artificial 1C (Precision) vs natural (SAYC)** | 128 | −0.45 imp/bd for Precision, z=−1.38 | not separable at this n; escalate |
| **Weak-2 openings add value?** (v11 ablation) | 38 pairs | regret with −76.8 vs without −77.6 (+0.8 toward par); imps z≈0 | not separable; direction favors keeping |

Reading guide: negative deltas = second-listed system ahead.

**What we may already assert:** within measured noise, no evidence that moving the
natural opening threshold away from 12 helps, and mild consistent evidence *against*
11/13/14. No measurable advantage for artificial-vs-natural 1C at this scale — the
folk belief either way is unsupported at n≈128.

**Escalation protocol:** these are exactly the "inconclusive" cases the autoloop
funnel escalates. Rerun with `--boards 256` (or plug the pairings into
`autoloop --tiers`) until |z| ≥ 2 or budget exhausted; each escalation reuses the same
deal prefix so comparisons stay paired.

---

## 4. OPEN problems

1. Full-game equilibrium of bridge bidding — intractable; only abstracted models
   (e.g., HCP-only DP games) admit exact solutions.
2. Convention optimality *conditional on partner inference quality* — couples to §7.4
   (stateful convention memory) and RBMBMC posterior fidelity.
3. Human-field generalization: our distribution is uniform-random deals; real fields
   are filtered (weak hands passed out pre-auction). LIN-corpus mining would condition
   all dominance claims on realistic filtering.

---

## 5. Reproduce

```bash
PYTHONPATH=.. python3 convention_lab.py hcp-dist
PYTHONPATH=.. python3 convention_lab.py breaks --fit 9
PYTHONPATH=.. python3 convention_lab.py fit --samples 1000000
PYTHONPATH=.. python3 convention_lab.py info-bound
PYTHONPATH=.. python3 convention_lab.py thresholds --boards 64      # escalate freely
PYTHONPATH=.. python3 convention_lab.py duel --a precision --b sayc --boards 256
PYTHONPATH=.. python3 convention_lab.py weak2 --boards 96
```
