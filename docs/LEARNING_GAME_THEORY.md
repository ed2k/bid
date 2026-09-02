# Learning Game Theory Through Contract Bridge

Contract bridge is widely considered by game theorists to be the ultimate testbed for **imperfect-information games with asymmetric communication**. 

Unlike chess or Go (where both players see the entire board) and unlike poker (which is purely competitive individual play), bridge is a **cooperative-adversarial game**:
- Two partnerships (North-South vs East-West) compete in a zero-sum contest.
- Teammates must communicate privately held information to reach the highest scoring contract.
- **The catch**: All communication must be conducted via a public auction where opponents hear every single bid.

---

## 1. Perfect vs. Imperfect Information Games

| Property | Chess / Go | Poker | Contract Bridge |
| :--- | :--- | :--- | :--- |
| **Information** | Perfect (complete board visible) | Imperfect (private hole cards) | Imperfect (39 private cards out of 52) |
| **Agents** | 2 players (Zero-Sum) | $N$ players (Zero-Sum) | 2 teams of 2 players (Cooperative-Adversarial) |
| **Communication**| None | Implicit (Betting amounts) | Explicit symbolic language (Bids) |
| **Eavesdropping** | N/A | N/A | Total (Opponents hear all signals) |
| **Game State** | Deterministic position | Hidden card probability | Joint 4-hand hidden distribution |

In chess, Minimax search or AlphaZero can evaluate a move by traversing deterministic game states. In bridge, when North opens `1NT`, North does not know South's hand, East's hand, or West's hand. Any decision must evaluate an entire **belief distribution** over hidden states.

---

## 2. Bayesian Belief Updating

Every player starts with private knowledge of their own 13 cards. Out of the remaining 39 cards in the deck, there are:

$$\binom{39}{13, 13, 13} = \frac{39!}{(13!)^3} \approx 3.45 \times 10^{16} \text{ possible deals}$$

### 2.1 The Prior Distribution
Before any bidding occurs, every remaining card is equally likely to be in any of the three hidden hands. 

### 2.2 Bayesian Evidence Updating
When an opponent or partner bids, that call carries semantic meaning defined by their system. If North opens `1NT` showing 15–17 HCP and a balanced hand:

$$P(\text{Deal } D \mid \text{Call } b) = \frac{P(b \mid D) \cdot P(D)}{P(b)}$$

Where:
- $P(D)$ is the combinatorial prior.
- $P(b \mid D) = 1$ if hand $H_{\text{North}}$ satisfies the rule conditions (`hcp in [15, 17]` and `balanced == True`), and $0$ otherwise.
- $P(b)$ is the total probability mass of hands satisfying `1NT`.

In this codebase, [`src/bid/sampling.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/sampling.py) implements **RBMBMC (Rule-Based Model-Based Monte Carlo)** sampling: instead of computing all $3.45 \times 10^{16}$ deals, it draws representative sample worlds consistent with the accumulated constraints.

---

## 3. The Cooperative Dilemma & Signaling Theory

Signaling theory (Nobel Prize in Economics, Michael Spence) studies how parties convey information when incentives are partially aligned or conflicted.

In bridge bidding, a partnership faces a fundamental trade-off:

```text
                  ┌─────────────────────────────────────────┐
                  │            Bidding a Call               │
                  └────────────────────┬────────────────────┘
                                       │
                    ┌──────────────────┴──────────────────┐
                    ▼                                     ▼
      ┌───────────────────────────┐         ┌───────────────────────────┐
      │   Information to Partner  │         │   Information Leakage     │
      │  (Clarifies fit & honors) │         │  (Helps defenders defend) │
      └───────────────────────────┘         └───────────────────────────┘
```

### 3.1 Cooperative Information Gain
If partner opens `1H` (showing 5+ hearts, 12–21 HCP) and you hold 4 hearts and 13 HCP, bidding `3H` or `4H` conveys vital information:
- The partnership has a 9-card golden fit ($5 + 4 = 9$).
- Combined strength is at least $12 + 13 = 25$ HCP (enough for game).

### 3.2 Adversarial Information Leakage
However, bridge auctions are public. If you use five rounds of scientific convention bids to pinpoint that your partner has precisely a singleton diamond:
- **Partner knows**: To avoid diamond contracts.
- **Defenders know**: Exactly how to lead and defend to defeat your contract.

### 3.3 Preemption & Space Denial
A core game-theoretic weapon in bridge is **preemption**: jumping to a high level (e.g. opening `3S` or `4H`) with a weak hand that has extreme suit length.
- Preemption conveys negative information (weak hand, many trumps).
- **Primary Game-Theoretic Function**: It consumes opponent bidding space. Opponents who might have had 26 combined HCP can no longer exchange information at the 1- or 2-level; they must guess whether to pass, double, or overcall at the 4-level under extreme uncertainty.

---

## 4. Competitive Value of Information (VOI)

In this repository, [`src/bid/convention_search.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/convention_search.py) models the exact mathematical trade-off of any proposed bidding convention using **Competitive VOI**:

$$\text{Net VOI}(b) = \text{VOI}_{\text{partner}}(b) - \lambda_{\text{leak}} \cdot \text{Leakage}_{\text{defenders}}(b) + \lambda_{\text{preempt}} \cdot \text{Disruption}_{\text{opponents}}(b)$$

### 4.1 Shannon Entropy Reduction
Let $H(X)$ be the Shannon entropy of partner's belief over our hand $X$:

$$H(X) = -\sum_{x \in \mathcal{X}} P(x) \log_2 P(x)$$

When we make bid $b$, partner updates their belief to posterior distribution $P(X \mid b)$. The information gained by partner is the reduction in uncertainty:

$$\text{VOI}_{\text{partner}}(b) = H(X) - H(X \mid b)$$

### 4.2 Adversarial Penalty & Preemption Bonus
- **$\text{Leakage}_{\text{defenders}}$**: The entropy reduction of our hand from the perspective of the two defenders.
- **$\text{Disruption}_{\text{opponents}}$**: The reduction in the number of legal, informative calls available to the opponents:
  $$\text{Disruption}(b) = \log_2 \left( \frac{|\text{LegalCalls}_{\text{before}}| + 1}{|\text{LegalCalls}_{\text{after}}| + 1} \right)$$

This formula explains mathematically why conventions like **Weak Two Bids** and **Multi-2D** are so powerful in modern tournament bridge: they maximize partner coordination while inflicting high disruption on opponents.

---

## 5. Duplicate Scoring & Game-Theoretic Par

### 5.1 Why Duplicate Scoring Eliminates Deal Luck
In casual rubber bridge, receiving good cards wins the game. In competitive bridge, **Duplicate Scoring** is used:
- The exact same 52 cards are dealt to multiple tables.
- If you hold 20 HCP, your counterpart sitting in the same chair at the other table also holds 20 HCP.
- Your score is compared against the counterpart. Winning or losing depends entirely on making superior strategic decisions on the identical board.

### 5.2 The IMP Conversion Function
Scores are converted to **International Match Points (IMPs)** via a non-linear concave function ([`src/bid/scoring.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/scoring.py)):

| Point Difference | IMPs | Strategic Implication |
| :---: | :---: | :--- |
| 20 – 40 | 1 | Overtricks in partscores matter very little. |
| 270 – 310 | 7 | Making a vulnerable game (+600) vs missing game (+140) swings 10 IMPs. |
| 750 – 890 | 13 | Bidding a vulnerable small slam (+1430) vs game (+680) swings 13 IMPs. |

Because the payoff curve heavily rewards games and slams, optimal game-theoretic bidding is **risk-seeking for game contracts** (bidding game even with a 40% chance of making is mathematically +EV at IMP scoring).

### 5.3 Double Dummy Par
The theoretical game-theoretic equilibrium of a bridge deal is its **Par**:
- The contract and score reached if all four players could see all 52 cards and played minimax card play.
- Calculated via the Double Dummy Solver ([`src/bid/dds.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/dds.py)).

When benchmarking a bidding system (`eval_vs_dds.py`), we measure **Average IMP Loss vs Par**:
$$\text{Average IMP Loss} = \frac{1}{N} \sum_{i=1}^N \text{ScoreToIMP}(\text{ParScore}_i - \text{SystemScore}_i)$$
A system that loses fewer than 2.0 IMPs per board against theoretical clairvoyant par is competing at world-class levels.
