Q: is there open source code from https://csaws.cs.technion.ac.il/~shaulm/papers/pdf/Amit-Markovitch-mlj2005.pdf
A:
Yes—I checked the paper you linked. It is **Asaf Amit and Shaul Markovitch, “Learning to Bid in Bridge,” Machine Learning 63(3), 287–327 (2006)**; the PDF filename contains `mlj2005` because the manuscript was received/revised in 2005. ([CSAWS][1])

### Is the source code open source?

**I cannot find an openly published source-code repository for this paper.** I checked:

* [Shaul Markovitch's publication list](https://csaws.cs.technion.ac.il/~shaulm/publications-by-keyword.html?utm_source=chatgpt.com) — it provides the paper/PDF, but no source-code link. ([CSAWS][2])
* The paper's dedicated page also only provides the publication information and PDF; there is no GitHub/source-code link. ([CSAWS][1])
* DBLP lists an unpaywalled version, but not an implementation repository. ([DBLP][3])
* I also searched for repositories/code using the paper title and authors and did not find a credible original implementation.

So **the paper appears to have been published without an openly available implementation**.

### But there is an important possibility

This paper is particularly interesting for what you've been working on with bridge AI because its algorithm is quite concrete. The authors describe:

1. **Model-based bidding**

   * models both the **partner** and **opponents**
2. **Monte Carlo sampling of hidden hands**
3. A decision-making algorithm for four-player, partially observable bridge
4. **Co-training of partners**
5. Learning from states where competing bids produce conflicting results. ([CiteSeerX][4])

The paper says their pair of agents improved enough to surpass the then state-of-the-art bidding algorithm. ([CSAWS][1])

If your goal is **to reproduce their algorithm**, I can go one step further: I can inspect the paper and reconstruct the actual algorithm—including the **world-generation/sampling procedure, partner/opponent models, bid evaluation, and learning procedure**—and then look for **modern open-source bridge code that implements something equivalent**, even if it isn't the authors' original code. That may be more useful than finding the original repository.

[1]: https://csaws.cs.technion.ac.il/~shaulm/papers/abstracts/Amit-2006-LBB.html?utm_source=chatgpt.com "Learning to Bid in Bridge"
[2]: https://csaws.cs.technion.ac.il/~shaulm/publications-by-keyword.html?utm_source=chatgpt.com "Publications of Shaul Markovitch"
[3]: https://dblp.org/pid/m/ShaulMarkovitch?utm_source=chatgpt.com "dblp: Shaul Markovitch"
[4]: https://citeseerx.ist.psu.edu/document?doi=7c0cb6972dfa285461d2827abd312539503efe67&repid=rep1&type=pdf&utm_source=chatgpt.com "Mach Learn () :"


Q: inspect the paper and reconstruct the actual algorithm—including the **world-generation/sampling procedure, partner/opponent models, bid evaluation, and learning procedure**—and then look for **modern open-source bridge code that implements something equivalent**
A:
Yes. I went through the paper in detail, and the algorithm is much more concrete than the abstract makes it sound. I would describe it as:

> **rule-based action pruning + model-conditioned Monte Carlo belief sampling + recursive opponent/partner simulation + lookahead + offline speedup learning + partner co-training.**

The original implementation is **BIDI**, but I still cannot find its source code. The paper does, however, give enough pseudocode and architectural detail to reconstruct a substantial implementation. ([CSAWS][1])

## 1. Overall architecture

The key idea is this pipeline:

```text
                    current auction + own hand
                              │
                              ▼
                    ┌────────────────────┐
                    │ Selection strategy │
                    │   φ(state)          │
                    └─────────┬──────────┘
                              │
                  candidate bids, usually 1–N
                              │
                         if N = 1
                              │
                              ▼
                           BID
                              │
                         if N > 1
                              ▼
                 ┌────────────────────────┐
                 │ RBMBMC world sampling  │
                 └───────────┬────────────┘
                             │
                    K plausible worlds
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
            world 1        world 2        world K
              │              │              │
              ▼              ▼              ▼
          LookAhead       LookAhead       LookAhead
              │              │              │
              └──────────────┼──────────────┘
                             ▼
                    average utility/bid
                             │
                             ▼
                       best candidate
```

The important conceptual departure from ordinary Monte Carlo bidding is that **the worlds are not sampled uniformly from all deals compatible with your hand**.

They preferentially sample worlds in which the observed auction is **compatible with the learned behavior models of the other players**. 

---

# 2. The "player model" is unusual

This is one of the most interesting parts of the paper.

They don't primarily try to predict:

> "What exact bid will West make?"

Instead, they model:

> **What bids would be reasonable for West to consider in this state?**

They call this a **selection strategy**:

[
\phi_i(s)\rightarrow 2^A
]

where (A) is the set of legal calls.

So for example:

```text
West hand:
  15–17 HCP
  balanced
  5 hearts

φWest(state) =
    {1NT, 1H}
```

rather than

```text
P(West bids 1NT) = 0.73
P(West bids 1H)  = 0.27
```

This distinction is extremely important.

The model is essentially a **constraint generator**.

The paper explicitly says its contribution is to predict the "reasonable" actions rather than trying to predict the single action the other agent will take. 

---

# 3. Initial selection strategy = bidding rules

Their original BIDI system starts with approximately **2,000 human-style bidding rules**. 

A rule looks roughly like:

```text
auction pattern
        +
hand constraints
        →
candidate bid
```

For example:

```text
if:
    HCP ∈ [12,23]
    hearts ≥ 5

then:
    1H
```

The system converts these rules into a **decision net**.

The paper's implementation uses about **250 bridge-specific features**, including:

* HCP
* length of each suit
* distribution/balance
* controls
* HCP in a particular suit
* etc.



So:

```text
φ(state)
```

is basically:

```text
run the partial hand through the decision net
→ collect all applicable actions
```

---

# 4. The really clever part: RBMBMC

This is the core algorithm I think is most worth reproducing.

Suppose South knows:

```text
South = known

North = ?
East  = ?
West  = ?
```

A conventional Monte Carlo algorithm would do:

```python
while len(samples) < K:
    deal_remaining_cards_randomly()
```

The paper does something more sophisticated.

## Step 1 — Generate a completely random world

Deal the remaining 39 cards randomly:

[
s\sim CFS(p,i)
]

where (CFS) is the set of complete states compatible with the current player's information.

The paper explicitly says that for bridge this is simply randomly dealing the 39 unseen cards. 

---

## Step 2 — Replay the auction backward

Suppose the current auction is:

```text
South 1H
West 1S
North 2H
East Pass
South 3H
```

Given a complete deal, they reconstruct the earlier states by applying **inverse actions**.

Conceptually:

```text
current full deal
       ↓ inverse(3H)
state after 2H
       ↓ inverse(Pass)
state after 2H
       ↓ inverse(2H)
state after 1S
       ↓ inverse(1S)
state after 1H
       ↓ inverse(1H)
initial state
```

At each historical state they ask:

[
a_t \in \phi_{player}(state_t)?
]

If not, that world is considered inconsistent with the player's learned model.

This is explicitly specified in their `Inconsistent()` procedure. ([CiteSeerX][2])

---

# 5. They don't simply reject inconsistent worlds

This is another subtle point.

Suppose we want 10 worlds.

A naive approach would be:

```text
generate world
if consistent:
    keep
else:
    discard
```

But the authors found this too expensive.

Instead every sampled world gets an:

[
\text{InconsistencyCount}
]

For example:

```text
World A: 0 inconsistencies
World B: 0
World C: 1
World D: 1
World E: 2
...
```

They maintain the **K best worlds** according to this number.

Then they continue generating random worlds and replace the worst ones whenever they find a better one.

So the sample gradually becomes:

```text
best worlds seen so far
```

rather than:

```text
random worlds satisfying every constraint
```

The algorithm stops when the resource/time budget is exhausted. ([CiteSeerX][2])

This is why the name is:

**Resource-Bounded Model-Based Monte Carlo Sampling (RBMBMC).**

---

# 6. Why this is better than ordinary PIMC

This connects directly to the bridge-search questions you asked previously.

Ordinary PIMC:

[
s\sim P(s\mid\text{known cards})
]

Amit–Markovitch:

[
s\sim
\text{approximately best worlds under }
P(s\mid\text{known cards + behavioral models})
]

More precisely, they are searching for worlds where:

[
a_t\in\phi_i(PS(s_t,i))
]

for as many historical actions as possible.

So the auction itself becomes a **filter on the world distribution**.

This is not merely sampling more worlds.

It is trying to sample **more informative worlds**.

That is a very important connection to the "representative worlds" issue you raised earlier.

---

# 7. PIDM decision making

Once they have K worlds, the actual decision is straightforward.

Suppose candidate actions are:

[
A={1NT,1H}.
]

For every candidate action (a), run lookahead in every sampled world:

[
V(a)=
\frac{1}{K}
\sum_{s\in S}
V_{\text{lookahead}}(a,s)
]

and choose:

[
a^*=\arg\max_a V(a)
]

The paper's PIDM pseudocode does exactly this. 

---

# 8. But the other players are also simulated

This is where PIDM becomes more interesting than ordinary PIMC.

Suppose we evaluate:

```text
South considers 3NT
```

and then the search reaches a state where North has to bid.

South doesn't simply assume:

```text
North = random
```

Instead it invokes North's model.

Conceptually:

```python
def lookahead(state, player):

    if player == me:
        search_my_actions()

    else:
        partial_state = observe(state, player)

        north_bid = PIDM(
            partial_state,
            North_model
        )

        apply(north_bid)
        continue()
```

The paper explicitly says that when another agent's turn occurs, PIDM computes that agent's observable partial state and invokes PIDM using that agent's model. 

So the search tree is roughly:

```text
                   South
                     │
          ┌──────────┴──────────┐
         1NT                    1H
          │                      │
        North                  North
       model                   model
       /   \                   /   \
     2C    2H                 2C    2H
      │      │                 │      │
    South  South             South  South
```

This is essentially **nested decision models**.

---

# 9. Partner and opponent are treated differently during learning

This is particularly clever.

During actual play:

```text
Partner:
    model what partner will do

Opponent:
    model what opponent will do
```

But during **offline training**, the partner can provide a "simulation service."

Instead of guessing:

> What would my partner have bid in this hypothetical state?

the learner can simply ask the partner.

Thus the training simulation becomes much more accurate.

The paper explicitly describes this mechanism. 

---

# 10. Learning is not neural-network learning

This is an important distinction.

The 2006 system is not learning a neural network.

It starts with:

```text
~2000 expert rules
        ↓
decision net
```

and learns to **refine the decision net**.

The learning loop is:

### Stage A — find ambiguous states

Generate random bridge states and keep states where:

[
|\phi(s)|\ge2
]

That means the current bidding system doesn't know which bid to select.



For example:

```text
current rules say:

1H
1NT
```

Both are plausible.

That is an **informative training state**.

---

# 11. Tag the ambiguous state using expensive search

Now use PIDM with a **much larger computational budget**.

For example:

```text
real-time:
    0.5 sec

training:
    5 sec
```

or potentially much more.

The expensive search decides:

```text
state X → 1NT
```

That becomes a training example:

[
(X,1NT)
]

This is classic **speedup learning**:

> use expensive reasoning offline to learn a cheap approximation.

The paper explicitly characterizes it this way. 

---

# 12. Then use ID3 to learn the distinction

Suppose the ambiguous states look like:

```text
15–17 HCP
balanced
5 hearts
```

and the expensive search produces:

```text
state 1 → 1NT
state 2 → 1NT
state 3 → 1H
state 4 → 1NT
state 5 → 1H
```

The system looks for additional features that distinguish them.

For example:

```text
                    HCP 15–17
                         │
                    balanced
                         │
                     5 hearts
                         │
                 HCP in hearts?
                  /             \
               <5              >=5
                │                │
               1NT          Controls?
                              /     \
                           >=3      <3
                            │         │
                           1NT        1H
```

That's essentially what Figure 7 demonstrates.

They use **ID3** to produce the decision tree. 

---

# 13. The decision net is incrementally refined

They don't throw away the original bidding system.

Suppose two old rules conflict:

```text
Rule A → 1NT

Rule B → 1H
```

and a new training example falls into both.

They create an **intersection node**:

[
SC(n_{\text{new}})
==================

SC(n_A)\cap SC(n_B)
]

Then they learn a specialized classifier inside that intersection.

So the original general rules remain, while the new learned rule handles the exceptional region.

This is a very nice form of **exception learning**. 

---

# 14. Negative rules

The original BIDI system also has negative bidding rules.

For example:

```text
positive rules:
    {1H, 1NT}

negative rules:
    don't bid 1NT
```

The negative actions are removed from the candidate set.

The paper describes the final default action set as:

[
A_{\text{default}}
==================

## A_{\text{legal}}

A_{\text{prohibited}}
]



---

# 15. Co-training

Now we get to the most interesting part for bridge.

Imagine:

```text
South model       North model
     │                 │
     └──────┬──────────┘
            │
       joint training
```

Both partners independently encounter ambiguous situations.

Each partner:

1. generates informative states
2. performs expensive PIDM search
3. obtains training labels
4. refines its decision net

Then they **exchange their refined decision nets**.

The exchange is repeated frequently.

The paper says the learning should happen **in parallel**, not:

```text
North learns everything
then South learns
```

because otherwise North is modeling an obsolete South.

Instead:

```text
round 1:
   North learns       South learns

exchange

round 2:
   North learns       South learns

exchange

round 3:
   ...
```



---

# 16. This creates a feedback loop

The really elegant consequence is:

```text
better South model
       ↓
better North world sampling
       ↓
better North search
       ↓
better North bidding model
       ↓
better South world sampling
       ↓
...
```

The paper explicitly notes that after co-training, the partner's refined decision net constrains Monte Carlo sampling, making the possible-world set smaller and search more accurate. 

So learning improves **both**:

### Policy

```text
which bid should I make?
```

and

### Belief

```text
which hidden worlds should I consider?
```

That second effect is easy to overlook.

---

# 17. The actual experimental parameters

The authors' BIDI experiment is surprisingly reproducible.

They used:

* **2,000 random deals** for initial co-training
* approximately **2,000 initial bidding rules**
* **ID3**
* **100 refined decision nets**
* **5 seconds per tagging process**
* **sample size = 10** during training
* standard **2/1** system with common conventions. 

For testing they used:

* **0.5 sec per call**
* **sample size = 3**
* 100 bidding challenges
* repeated tests and averaged results. 

One of their striking results is that learning with only **3 samples** could outperform a non-learning system using **10 samples**; the paper reports a better result after learning with 15,000 generated instances versus 90,000 without learning. 

That is a strong demonstration of **speedup learning**, rather than simply brute-force sampling.

---

# 18. What would the implementation look like today?

I would reconstruct BIDI approximately as:

```text
bridge/
│
├── state.py
│     Deal
│     Auction
│     PartialState
│
├── features.py
│     HCP
│     suit_length
│     balance
│     controls
│     ...
│
├── bidding_rules.py
│     rule representation
│
├── decision_net.py
│     StateActions()
│     rule matching
│     intersection nodes
│
├── model.py
│     φ(player_state)
│
├── sampling.py
│     RBMBMC()
│     inconsistency()
│
├── pidm.py
│     PIDM()
│     LookAhead()
│
├── learner.py
│     generate_informative_states()
│     tag_with_PIDM()
│     ID3()
│     refine_decision_net()
│
├── cotrain.py
│     exchange_partner_models()
│
└── evaluation.py
      IMP scoring
```

The core pseudocode would be approximately:

```python
def bid(state, agent, budget):

    actions = agent.selection_strategy(state)

    if len(actions) == 1:
        return next(iter(actions))

    sample_budget = GAMMA * budget

    worlds = rbmbmc(
        state,
        history(state),
        agent,
        sample_budget,
        sample_size=K
    )

    values = {}

    for action in actions:
        values[action] = mean(
            lookahead(
                apply(world, action),
                agent,
                remaining_budget / len(actions) / len(worlds)
            )
            for world in worlds
        )

    return max(values, key=values.get)
```

And:

```python
def rbmbmc(state, history, agent, budget, K):

    sample = []

    # initial K random worlds
    for _ in range(K):
        world = random_completion(state)
        score = inconsistency(world, history, agent)
        sample.append((score, world))

    while budget_remaining() and max_score(sample) > 0:

        world = random_completion(state)

        score = inconsistency(
            world,
            history,
            agent,
            cutoff=max_score(sample)
        )

        if score < max_score(sample):
            replace_worst(sample, (score, world))

    return sample
```

This is remarkably close to the actual paper algorithm. ([CiteSeerX][2])

---

# 19. What open-source code exists today?

There are now several much better starting points than existed in 2006.

### A. BEN — probably the most useful implementation base

[lorserker/ben on GitHub](https://github.com/lorserker/ben?utm_source=chatgpt.com)

This is an open-source bridge engine with:

* neural-network bidding
* double-dummy solver
* hand/world sampling
* bidding analysis
* APIs/tutorials for bidding
* PIMC-related functionality

The repository explicitly provides a **bidding tutorial showing how to sample hands consistent with an auction**. ([GitHub][3])

This makes BEN particularly interesting if your objective is to implement **Amit–Markovitch-style model-conditioned sampling**, because much of the bridge infrastructure already exists.

---

### B. pons — excellent infrastructure

[jdh8/pons on GitHub](https://github.com/jdh8/pons?utm_source=chatgpt.com)

This is a newer open-source contract-bridge library. It contains:

* bidding infrastructure
* AI-bidder tooling
* deal generation
* diagnostics
* benchmarking against BBA/EPBot
* an Apache-2.0 license. ([GitHub][4])

For building a clean research implementation, I actually like **pons** as the underlying bridge engine.

---

### C. 2024 neural bridge bidder

[harukaki/brl on GitHub](https://github.com/harukaki/brl?utm_source=chatgpt.com)

This is the implementation accompanying:

**"A Simple, Solid, and Reproducible Baseline for Bridge Bidding AI."**

The authors explicitly released both code and trained models. ([arXiv][5])

This is much more modern than BIDI: it uses supervised learning / reinforcement-learning techniques rather than the 2006 decision-net approach.

But conceptually it solves a different problem.

---

# 20. How close are these to Amit–Markovitch?

I'd rank them like this:

| Component                        | Amit–Markovitch 2006  | BEN                           | pons                 | 2024 BRL      |
| -------------------------------- | --------------------- | ----------------------------- | -------------------- | ------------- |
| Hidden-world sampling            | **Yes**               | **Yes**                       | infrastructure       | yes           |
| Auction-conditioned sampling     | **Yes**               | **Yes**                       | possible             | yes           |
| Behavioral model of partner      | **Yes**               | partly                        | infrastructure       | neural policy |
| Behavioral opponent model        | **Yes**               | partly                        | infrastructure       | neural policy |
| Recursive lookahead              | **Yes**               | yes                           | infrastructure       | different     |
| Rule-based candidate pruning     | **Yes**               | partly                        | yes                  | no            |
| Learned selection strategy       | **ID3 decision net**  | neural                        | configurable         | neural        |
| Co-training partners             | **Yes**               | related ideas                 | not the same         | RL/self-play  |
| Model-conditioned world sampling | **Core contribution** | closest modern starting point | needs implementation | different     |
| Original algorithm               | **exact**             | no                            | no                   | no            |

So there is **not** a modern repository that I would call "Amit–Markovitch implemented."

But there is a very good path to reproduce it.

---

# 21. The most important modern equivalent

If your goal is specifically to investigate the idea from this paper rather than merely build a strong bridge bidder, I would combine:

```text
              pons / BEN
                  │
       bridge state + DDS
                  │
                  ▼
       Amit–Markovitch layer
       ┌──────────────────┐
       │ selection model  │
       │       φ(s)       │
       ├──────────────────┤
       │ RBMBMC sampler   │
       ├──────────────────┤
       │ PIDM search      │
       ├──────────────────┤
       │ partner model    │
       ├──────────────────┤
       │ ID3 learner      │
       └──────────────────┘
```

This would let you directly compare:

[
\text{uniform PIMC}
]

vs.

[
\text{RBMBMC}
]

vs.

[
\text{RBMBMC + learned policy}
]

vs.

[
\text{neural belief sampling}
]

That would be a **very interesting experiment**, especially given your earlier question about whether one can select more representative worlds.

---

## 22. One particularly important insight for your previous PIMC question

I think the paper gives a strong answer to the question you were asking earlier about **"same number of samples, but more representative worlds."**

Amit–Markovitch are effectively doing:

[
\boxed{
\text{sample quality} >
\text{sample quantity}
}
]

Their RBMBMC does **not** try to approximate the posterior distribution perfectly.

Instead, with a limited budget, it tries to obtain a small set of worlds that are **maximally consistent with the observed behavior**.

That's why their sample of **3 worlds after learning** can outperform a non-learning system using **10 worlds**. 

In modern terminology, I would describe the method as something like:

> **behavior-conditioned importance/elite sampling over hidden bridge states, coupled with nested policy simulation.**

That terminology isn't theirs, but it makes the connection to modern belief-state search much clearer.

And I think **this part of the 2006 paper is still quite relevant to current bridge AI research**—even though the ID3 decision-net machinery itself is dated.

If you want, the next useful step would be to take **one concrete auction** and walk through RBMBMC numerically—e.g. generate 10 hypothetical worlds, calculate each world's inconsistency count from the auction, show which worlds survive, and then show exactly how PIDM evaluates two competing bids. That would make the algorithm completely implementable rather than just conceptual.

[1]: https://csaws.cs.technion.ac.il/~shaulm/papers/abstracts/Amit-2006-LBB.html?utm_source=chatgpt.com "Learning to Bid in Bridge"
[2]: https://citeseerx.ist.psu.edu/document?doi=350d9d00eb75d393cec9c21df768cb7c366ec4ae&repid=rep1&type=pdf&utm_source=chatgpt.com "Learning to Bid in Bridge"
[3]: https://github.com/lorserker/ben "GitHub - lorserker/ben: a game engine for bridge · GitHub"
[4]: https://github.com/jdh8/pons?utm_source=chatgpt.com "GitHub - jdh8/pons: Open-source library for contract bridge · GitHub"
[5]: https://arxiv.org/abs/2406.10306?utm_source=chatgpt.com "A Simple, Solid, and Reproducible Baseline for Bridge Bidding AI"


Q: go through the paper's algorithm with one example iteration
A:
Yes. Let’s do **one complete toy iteration** of the paper's algorithm, using a small bridge auction. I’ll keep the cards and numbers concrete, but I’ll simplify the utility/search portion so we can see the mechanism clearly.

The important correction to my previous answer is that **RBMBMC does not initially sample only "consistent" worlds**. It first samples `K` arbitrary worlds compatible with your known hand, scores them by the **number of auction actions inconsistent with the models**, and then spends its remaining sampling budget replacing the worst worlds. That is exactly what Figure 2 specifies. 

---

# Example: South is deciding what to bid

Suppose we have this auction:

```text
North     East      South     West
1♠        Pass      2♠        Pass
3♠        Pass      ?
```

South now has to decide.

For the example, suppose South's hand is:

```text
♠ K 9 4
♥ A 7 3
♦ Q 8 5 2
♣ K 6 4
```

South knows only his own 13 cards.

The other 39 cards are unknown.

The paper represents the full state as:

[
s=(\text{four hands},\text{auction},\text{dealer},\text{vulnerability},\text{bidding systems})
]

while South's partial state hides the other three hands. 

---

# Step 1: Selection strategy chooses candidate bids

The first thing PIDM does is **not** consider all 38 legal calls.

It calls:

[
\phi_{\text{South}}(s)
]

the selection strategy.

Suppose the decision net says:

```text
Actions = {Pass, 4♠}
```

This is the first major search reduction.

The paper's actual system has about 250 bridge-specific features, including HCP and suit lengths. A rule might look like:

[
12\le HCP\le23,\qquad
5\le \text{HEARTLEN}\le13
\Rightarrow 1H
]

and the selection strategy returns the actions from the most-specific matching nodes. 

So PIDM now has only:

```text
Pass
4♠
```

to compare.

If there were only one candidate, PIDM would immediately return it without Monte Carlo search. 

---

# Step 2: Allocate the time budget

Suppose South has:

[
T=1.0\text{ second}
]

The paper allocates a fraction (gT) to world sampling.

Let's choose, purely for illustration:

[
g=0.30
]

so:

[
G=0.30\text{ sec}
]

goes to RBMBMC.

The remaining:

[
0.70\text{ sec}
]

is used for lookahead.

This follows the structure of Figure 3. 

---

# Step 3: Generate the first random world

South knows 13 cards, so 39 cards remain.

RBMBMC randomly deals those 39 cards to North/East/West.

Suppose it happens to produce:

```text
World W1

North:
♠ A J 8 7 6
♥ K Q 5
♦ 7 4
♣ 9 3

East:
♠ Q 10 5 3 2
♥ J 10 9
♦ K 10 6
♣ A 8

West:
remaining cards
```

The precise cards aren't important yet.

The important point is:

> **W1 is completely random subject only to South's known hand.**

That is explicitly how RBMBMC begins. 

---

# Step 4: Ask whether W1 explains the auction

Now comes the clever part.

We know the historical auction:

```text
1♠   Pass   2♠   Pass   3♠
```

But W1 gives us complete hands.

So we can reconstruct what each player knew when they made each historical bid.

The algorithm starts at the **end** of the auction.

The current full state is:

```text
W1 + auction through 3♠
```

It applies the inverse of `3♠`, recovering the previous state.

Then it asks:

> Given West's actual hand in W1 and the auction before 3♠, would West's model consider 3♠ a reasonable action?

Formally:

[
3\spadesuit
\in
\phi_{\text{North}}
(PS(s,\text{North}))
]

If yes:

```text
consistent
```

If no:

```text
inconsistent +1
```

The paper's `Inconsistent()` function does exactly this, working **backwards through the auction**. 

---

# Step 5: Continue backwards

Suppose for W1 we get:

| Historical call | Model says reasonable? |
| --------------- | ---------------------- |
| North 1♠        | Yes                    |
| East Pass       | Yes                    |
| South 2♠        | Yes                    |
| West Pass       | **No**                 |
| North 3♠        | Yes                    |

Therefore:

[
\operatorname{InconsistCount}(W1)=1.
]

So we store:

```text
W1 → inconsistency = 1
```

---

# Step 6: Repeat until we have K worlds

Suppose the paper's `SampleSize` is:

[
K=3.
]

The initial three random worlds might be:

```text
W1 → 1 inconsistency
W2 → 2 inconsistencies
W3 → 1 inconsistency
```

So our current sample is:

```text
┌──────┬───────────────┐
│ World│ Inconsistency │
├──────┼───────────────┤
│ W1   │      1        │
│ W2   │      2        │
│ W3   │      1        │
└──────┴───────────────┘

MaxInconsist = 2
```

This is exactly the initial phase of Figure 2. 

---

# Step 7: Spend the remaining sampling time

This is the part that's easy to misunderstand.

We **don't stop**.

We still have sampling time.

The worst current world has:

[
2
]

inconsistencies.

So generate another random world:

```text
W4 → 0 inconsistencies
```

Since:

[
0 < 2,
]

W4 replaces the worst world W2.

Now:

```text
W1 → 1
W3 → 1
W4 → 0
```

and:

[
MaxInconsist=1.
]

This replacement rule is explicitly in the paper's pseudocode. 

---

# Step 8: Another random world

Suppose:

```text
W5 → 2
```

Since:

[
2 \not< 1,
]

we throw W5 away.

Nothing changes:

```text
W1 → 1
W3 → 1
W4 → 0
```

---

# Step 9: Another random world

Suppose:

```text
W6 → 0
```

Now:

[
0<1.
]

Replace one of the inconsistency-1 worlds:

```text
W3 removed

W1 → 1
W4 → 0
W6 → 0
```

Now:

[
MaxInconsist=1.
]

We continue until the 0.30-second sampling budget is exhausted **or** all K worlds have zero inconsistencies.

The actual algorithm also uses the current maximum inconsistency as a cutoff while evaluating a new world: if a candidate has already accumulated that many inconsistencies, it can stop checking the remaining historical bids. 

---

# Step 10: We now have the "representative" worlds

Suppose the final sample is:

```text
W1 → 1
W4 → 0
W6 → 0
```

Notice something important.

These are **not necessarily random samples from**

[
P(W\mid\text{auction}).
]

Instead they are the **K best worlds found under the behavioral model**.

The paper calls them the K most consistent states found within the resource limit. 

That's the fundamental difference from ordinary PIMC.

---

# Step 11: Evaluate Pass

Now PIDM evaluates:

```text
candidate = Pass
```

in each world.

For W1:

```text
South → Pass
```

and then the lookahead proceeds.

Suppose after recursively simulating the future auction, the resulting utility is:

[
U(\text{Pass},W1)=20
]

For W4:

[
U(\text{Pass},W4)=25
]

For W6:

[
U(\text{Pass},W6)=15
]

Therefore:

[
V(\text{Pass})
==============

\frac{20+25+15}{3}
=20.
]

The paper's PIDM algorithm literally computes the average of the `LookAhead` values over the sampled states. 

---

# Step 12: Evaluate 4♠

Now do the same thing:

```text
candidate = 4♠
```

Suppose:

[
U(4\spadesuit,W1)=45
]

[
U(4\spadesuit,W4)=50
]

[
U(4\spadesuit,W6)=40
]

so:

[
V(4\spadesuit)
==============

\frac{45+50+40}{3}
=45.
]

Therefore:

```text
V(Pass) = 20
V(4♠)   = 45
```

and PIDM chooses:

[
\boxed{4\spadesuit}
]

---

# But there's an important second level

Here's where PIDM becomes substantially different from ordinary PIMC.

Suppose after South bids 4♠, **North** is the next player.

The algorithm doesn't assume North will:

* maximize South's utility,
* minimize South's utility,
* or make a random bid.

Instead it does:

[
PS(s,\text{North})
]

which hides East, South and West's hands from North.

Then it calls:

[
PIDM(PS(s,\text{North}),M_{\text{North}},R_{\text{sim}})
]

using **North's model**.

The resulting North bid is then inserted into the current world and the search continues. 

So one branch looks like:

```text
South considers 4♠
       │
       ▼
      W4
       │
       ▼
 North's turn
       │
       ├── hide South/East/West hands
       │
       ▼
 North's partial state
       │
       ▼
 PIDM using North's model
       │
       ▼
 North chooses 4NT
       │
       ▼
 South's next decision
       │
       ▼
 ...
```

This is **recursive model-based search**.

---

# And this is where the bidding information matters

Imagine instead that South has two possible bids:

```text
3♠
4♠
```

The difference isn't merely:

> Which contract is better given the current cards?

It can also be:

> Which bid gives North useful information?

Suppose:

```text
3♠
```

leaves North's model considering 20,000 possible hands, whereas:

```text
4♠
```

communicates enough information that North considers only 2,000.

Then after 4♠, North's subsequent RBMBMC search has a much better-defined sample.

The paper explicitly points out this mechanism: a bid that conveys information to the partner produces a smaller set of states considered consistent by the partner, improving the partner's model-based Monte Carlo search. 

So:

```text
South's bid
     ↓
changes North's belief
     ↓
changes North's sampled worlds
     ↓
changes North's simulated bid
     ↓
changes South's future utility
```

That's how **communication through bidding gets incorporated into the search automatically**, rather than requiring a special "information value" term.

---

# The entire single iteration

Putting everything together:

```text
                South's partial state
                         │
                         ▼
                 Selection strategy φ
                         │
                    {Pass, 4♠}
                         │
                         ▼
                   RBMBMC sampling
                         │
       ┌─────────────────┼─────────────────┐
       ▼                 ▼                 ▼
      W1                W4                W6
      1 bad             0 bad             0 bad
       │                 │                 │
       └─────────────────┼─────────────────┘
                         │
             ┌───────────┴───────────┐
             ▼                       ▼
          evaluate Pass           evaluate 4♠
             │                       │
             ▼                       ▼
       LookAhead(W1)           LookAhead(W1)
       LookAhead(W4)           LookAhead(W4)
       LookAhead(W6)           LookAhead(W6)
             │                       │
             │                       │
       ┌─────┴─────┐           ┌─────┴─────┐
       │ North turn│           │ North turn│
       ▼           │           ▼           │
   North PIDM      │       North PIDM      │
       │           │           │           │
       ▼           │           ▼           │
   continue       ...       continue       ...
       │                       │
       ▼                       ▼
   average utility          average utility
       │                       │
       ▼                       ▼
       20                      45
       └───────────┬───────────┘
                   ▼
                 4♠
```

This is essentially the algorithm in Figures 2 and 3 of the paper, with the concrete numbers filled in. 

---

## One subtle point: what exactly does "inconsistent" mean?

This is perhaps the most important thing to understand if you want to implement it.

It **doesn't mean the bid is impossible given the cards**.

It means:

> **Given this hypothetical complete deal, the model of the player who made the bid does not consider that bid to be one of the reasonable actions for the player's information state.**

So:

```text
Impossible bid
     ≠
Model inconsistency
```

A player can make a bad/unusual bid.

The paper deliberately allows that possibility. That's why it doesn't simply discard every inconsistent world. Instead it counts inconsistencies and searches for worlds with **fewest** inconsistencies. 

This is a very nice robustness property.

---

## And the learning loop sits *outside* this iteration

After many such PIDM decisions, the learning system finds states where:

[
|\phi(s)|>1.
]

For example:

```text
state X
     │
     ▼
current decision net
     │
     ├── 3NT
     └── 4NT
```

The expensive PIDM search determines which is better:

[
X\rightarrow3NT.
]

That becomes a labeled training example.

ID3 then tries to discover a feature that separates these ambiguous states and refines the decision net. The paper describes this as learning from classes of states with conflicting actions. 

So the full system is actually:

```text
              INITIAL RULES
                   │
                   ▼
             Decision Net φ
                   │
                   ▼
               PIDM search
                   │
                   ▼
          find ambiguous states
                   │
                   ▼
          expensive PIDM labels
                   │
                   ▼
                 ID3
                   │
                   ▼
            refined φ
                   │
                   └──────────┐
                              │
                              ▼
                     faster PIDM
                              │
                              ▼
                       better training
```

### The key idea

The paper isn't really trying to make Monte Carlo itself smarter.

It is doing **three separate things**:

1. **Selection strategy** reduces the branching factor.
2. **RBMBMC** uses those strategies to find better hidden worlds.
3. **PIDM** searches those worlds while recursively modeling the other players.

Then learning improves the selection strategy, which simultaneously improves **both #1 and #2**.

That coupling is the most interesting part of the paper. 


Q: more details on how to refine the decision net, how to try to discover a features that separates these ambiguous states 
A:
Yes. This is actually the part of the paper where the 2005-era ML machinery becomes quite interesting. The key is that **ID3 is not learning a general bidding policy from scratch**. It is learning a *local refinement* of an existing rule-based decision net, specifically in regions where the existing rules disagree.

I’ll reconstruct the mechanism carefully.

## 1. Start with a decision net, not a flat rule list

Suppose the existing system has rules such as:

```text
R1:  HCP ∈ [15,17] AND balanced
     → 1NT

R2:  HCP ∈ [12,21] AND hearts ≥ 5
     → 1H
```

For a hand

```text
HCP = 16
balanced = true
hearts = 5
```

both rules fire.

So the decision net returns:

[
\phi(s)={1NT,1H}.
]

This is an **ambiguous state**.

The important point is that the system doesn't regard this as an error in either rule. Both rules are still useful over their broader regions.

It needs to learn:

> **Inside the intersection of R1 and R2, what additional feature tells us which rule should win?**

That is what the refinement procedure is trying to discover.

---

# 2. Generate many ambiguous states

Suppose we generate 10,000 random deals and run the current decision net.

Most states might look like:

```text
state A → {1NT}
state B → {1H}
state C → {Pass}
```

Those aren't useful for this particular learning step.

We retain states where:

[
|\phi(s)|>1.
]

Suppose we obtain:

| State | HCP | balanced | hearts | controls | ... | current actions |
| ----- | --: | -------- | -----: | -------: | --- | --------------- |
| S1    |  15 | yes      |      5 |        3 | ... | {1NT, 1H}       |
| S2    |  16 | yes      |      5 |        4 | ... | {1NT, 1H}       |
| S3    |  16 | yes      |      6 |        4 | ... | {1NT, 1H}       |
| S4    |  17 | yes      |      5 |        2 | ... | {1NT, 1H}       |
| S5    |  15 | yes      |      6 |        3 | ... | {1NT, 1H}       |
| ...   |     |          |        |          |     |                 |

At this point **the ML algorithm doesn't yet know which bid is correct**.

---

# 3. Use expensive PIDM to label them

This is critical.

For each ambiguous state (s_i), run the expensive version of PIDM.

For example:

[
PIDM(s_1)\rightarrow1NT
]

[
PIDM(s_2)\rightarrow1NT
]

[
PIDM(s_3)\rightarrow1H
]

[
PIDM(s_4)\rightarrow1NT
]

[
PIDM(s_5)\rightarrow1H
]

Now the training set becomes:

| State | Candidate actions | PIDM's choice |
| ----- | ----------------- | ------------- |
| S1    | {1NT,1H}          | **1NT**       |
| S2    | {1NT,1H}          | **1NT**       |
| S3    | {1NT,1H}          | **1H**        |
| S4    | {1NT,1H}          | **1NT**       |
| S5    | {1NT,1H}          | **1H**        |

Now we have a supervised-learning problem.

The expensive search has effectively become a **teacher**.

---

# 4. What features are available?

The paper uses a large set of bridge-specific features—roughly 250.

Think of the feature vector as:

[
X(s)=
(x_1,x_2,\ldots,x_{250}).
]

Examples include:

* HCP
* length of each suit
* number of controls
* suit-specific HCP
* distribution
* balanced/unbalanced
* high-card structure
* information derived from the auction
* etc.

So for our examples we might have:

| State | HCP | ♠ len | ♥ len | ♦ len | ♣ len | ♥ HCP | controls | ... | teacher |
| ----- | --: | ----: | ----: | ----: | ----: | ----: | -------: | --- | ------- |
| S1    |  15 |     3 |     5 |     3 |     2 |     9 |        3 | ... | 1NT     |
| S2    |  16 |     3 |     5 |     3 |     2 |     8 |        4 | ... | 1NT     |
| S3    |  16 |     2 |     6 |     3 |     2 |    10 |        4 | ... | 1H      |
| S4    |  17 |     3 |     5 |     2 |     3 |     7 |        2 | ... | 1NT     |
| S5    |  15 |     2 |     6 |     3 |     2 |     9 |        3 | ... | 1H      |

The question now becomes:

> Which feature best separates the PIDM-labeled 1NT states from the 1H states?

---

# 5. This is where ID3 comes in

ID3 evaluates candidate features using **information gain**.

Suppose the training set contains:

```text
10 states

6 → 1NT
4 → 1H
```

Before splitting, the entropy is:

[
H(S)
====

-\frac6{10}\log_2\frac6{10}
-\frac4{10}\log_2\frac4{10}.
]

Approximately:

[
H(S)=0.971.
]

Now consider the feature:

```text
♥ HCP
```

Suppose it divides the examples:

```text
♥ HCP <= 8:

    5 states
    5 → 1NT
    0 → 1H

♥ HCP > 8:

    5 states
    1 → 1NT
    4 → 1H
```

That's an excellent split.

The conditional entropy is almost zero, so the information gain is very high.

ID3 therefore chooses:

[
\boxed{\text{heart HCP}}
]

as the new feature.

---

# 6. It recursively repeats the process

Suppose the first split isn't perfect:

```text
heart HCP <= 8
    → 5 states
       5 × 1NT

heart HCP > 8
    → 5 states
       1 × 1NT
       4 × 1H
```

The first branch is already pure:

```text
heart HCP <= 8
        ↓
       1NT
```

The second branch is still ambiguous:

```text
heart HCP > 8
        ↓
     {1NT,1H}
```

ID3 now asks:

> Among the remaining features, which one best separates these five states?

Maybe:

```text
controls
```

gives:

```text
controls >= 4 → 1NT
controls <= 3 → 1H
```

Then the learned tree becomes:

```text
                  ♥ HCP
                 /      \
             <= 8        > 8
              │           │
             1NT       controls
                       /       \
                    >=4        <=3
                     │           │
                    1NT         1H
```

This is the **new refinement**.

---

# 7. But where does this tree get inserted?

This is a particularly important detail.

It doesn't replace the entire decision net.

Suppose the two original rules correspond to regions:

[
C_1={s:R_1(s)}
]

and

[
C_2={s:R_2(s)}.
]

The ambiguous region is:

[
C=C_1\cap C_2.
]

The learned tree is attached **inside this intersection**.

So conceptually:

```text
Original decision net

                   State
                     │
             ┌───────┴────────┐
             │                │
          Rule R1           Rule R2
             │                │
             └───────┬────────┘
                     │
                intersection
                     │
              ┌──────┴──────┐
              │ learned ID3 │
              └──────┬──────┘
                 /        \
               1NT         1H
```

This is why the paper describes creating a **new node corresponding to the intersection of the applicable nodes**.

The original rules remain intact.

---

# 8. Why intersection is important

Consider:

```text
R1:
HCP 15–17
balanced
→ 1NT

R2:
HCP 12–21
hearts ≥ 5
→ 1H
```

Suppose ID3 discovers:

```text
♥ HCP <= 8 → 1NT
♥ HCP > 8 → 1H
```

We **must not** turn R2 globally into:

```text
hearts ≥ 5 AND ♥HCP > 8 → 1H
```

because that would incorrectly change states where R1 doesn't apply.

For example:

```text
HCP = 12
hearts = 5
♥HCP = 9
```

might still need the original 1H rule.

The learned feature only resolves the conflict **where R1 and R2 overlap**.

That's why the learned classifier is local.

---

# 9. Think of it as "exception learning"

A useful modern interpretation is:

[
\boxed{
\text{Expert rules}
+
\text{learned local exceptions}
}
]

rather than:

[
\text{learned policy from scratch}.
]

For example:

```text
General rule:
15–17 balanced → 1NT

General rule:
12–21 with 5+ hearts → 1H

Conflict:
15–17 balanced AND 5+ hearts

             ↓

        learn local rule

             ↓

       ♥HCP <= 8 → 1NT
       ♥HCP > 8  → 1H
```

This preserves the human knowledge encoded in the original bidding system.

---

# 10. How does ID3 know which features to try?

This is the nice part: **it doesn't need a manually selected feature**.

It considers each available feature at the current node.

For feature (F), calculate:

[
Gain(S,F)
=========

## H(S)

\sum_v
\frac{|S_v|}{|S|}
H(S_v)
]

where (S_v) is the subset having feature value (v).

Then:

[
F^*
===

\arg\max_F Gain(S,F).
]

So if the feature set contains:

```text
HCP
♠ length
♥ length
♦ length
♣ length
♠ HCP
♥ HCP
♦ HCP
♣ HCP
controls
balanced
...
```

ID3 automatically searches them.

The feature doesn't have to be something the original bridge expert specifically identified as important.

That is one of the benefits of using machine learning to refine the expert rules.

---

# 11. What if the feature is continuous?

This is an important implementation detail if you're reproducing this today.

Suppose:

```text
♥ HCP =
5, 6, 7, 8, 9, 10, 11
```

You don't necessarily create seven branches.

You can consider thresholds:

[
\text{♥HCP}\le5
]

[
\text{♥HCP}\le6
]

[
\ldots
]

and choose the threshold with maximum information gain.

For example:

```text
♥ HCP ≤ 8
♥ HCP > 8
```

could be the best split.

The paper's actual decision-net implementation has bridge-specific feature representations, so if reproducing it exactly, you'd want to follow its feature-value representation rather than assuming a generic modern CART implementation.

---

# 12. What if there are three candidate bids?

Suppose:

[
\phi(s)={1H,1NT,2H}.
]

The PIDM labels could be:

```text
S1 → 1H
S2 → 1NT
S3 → 2H
S4 → 1NT
S5 → 1H
...
```

ID3 is then simply a **three-class classifier**:

[
Y\in{1H,1NT,2H}.
]

The same information-gain procedure works.

The resulting local tree might be:

```text
                  HCP
              /    |     \
           12-14 15-17   18+
             │      │      │
            1H    ♥HCP     2H
                  /   \
                <9    ≥9
                 │     │
                1NT    1H
```

---

# 13. What if there are many different conflicts?

This is where the decision-net representation becomes more useful than a simple global decision tree.

Suppose:

```text
Region A:
    {1H, 1NT}

Region B:
    {2C, 2D}

Region C:
    {3NT, 4NT}
```

You don't train one giant classifier over all states.

Instead:

```text
              Decision net
             /      |       \
        Region A  Region B  Region C
           │         │         │
          ID3       ID3       ID3
           │         │         │
       1H / 1NT   2C / 2D   3NT / 4NT
```

Each ambiguous region gets its own refinement.

This keeps the learned model much smaller and more interpretable.

---

# 14. There is a subtle question: what examples does ID3 receive?

This is where the paper's learning procedure becomes more interesting than simply:

> generate random hands → ask PIDM → train ID3.

The paper specifically seeks **states where the current decision net gives conflicting actions**.

Why?

Because states where:

```text
φ(s) = {1H}
```

already have an unambiguous decision.

There is no need for learning there.

The expensive PIDM computation should instead be spent on:

[
|\phi(s)|>1.
]

So the learning algorithm concentrates computational effort exactly where the existing rule system is weak.

This is a form of **active learning / selective sampling**, although the paper doesn't use today's terminology as prominently.

---

# 15. And there's a second filter

Suppose the current net says:

```text
{1H,1NT}
```

but PIDM also says:

```text
1H ≈ 1NT
```

Then the state isn't particularly useful for learning.

But suppose:

```text
PIDM:
1H → utility 53
1NT → utility 37
```

Then it provides a strong label:

[
s\rightarrow1H.
]

So conceptually, useful training states are:

```text
current model uncertain
             +
expensive search can resolve uncertainty
             ↓
         good example
```

That's a very efficient way to spend the expensive search budget.

---

# 16. Why the expensive PIDM doesn't need to be perfect

This is another subtle but important idea.

The learned rule isn't trying to reproduce the **true optimal bridge strategy**.

It's trying to reproduce:

[
PIDM_{\text{large budget}}(s).
]

That is, the expensive search is the **teacher**.

Then during actual bidding:

[
\text{learned decision net}
\approx
\text{expensive PIDM}.
]

So:

```text
Expensive:
   search many worlds
   recursive model simulation
   → good decision

Cheap:
   evaluate a few features
   → approximate that decision
```

That's exactly the classic **speedup learning** architecture.

---

# 17. A concrete miniature example

Let's make the whole refinement numerical.

Suppose the conflict region contains 12 examples:

| State | ♥HCP | controls | ♦ length | PIDM |
| ----- | ---: | -------: | -------: | ---- |
| 1     |    6 |        3 |        3 | 1NT  |
| 2     |    7 |        3 |        3 | 1NT  |
| 3     |    8 |        4 |        2 | 1NT  |
| 4     |    8 |        3 |        3 | 1NT  |
| 5     |    9 |        2 |        3 | 1H   |
| 6     |    9 |        3 |        3 | 1H   |
| 7     |   10 |        2 |        3 | 1H   |
| 8     |   10 |        4 |        2 | 1H   |
| 9     |   11 |        2 |        4 | 1H   |
| 10    |   11 |        3 |        3 | 1H   |
| 11    |    8 |        4 |        3 | 1NT  |
| 12    |    9 |        4 |        2 | 1H   |

Overall:

[
7\times1H,\quad5\times1NT.
]

ID3 tests:

```text
HCP
♥HCP
controls
♦length
...
```

Suppose `♥HCP <= 8` gives:

```text
5 examples → 5 × 1NT
```

while `♥HCP > 8` gives:

```text
7 examples → 7 × 1H
```

Then:

[
Gain(\text{♥HCP})
]

is extremely high—indeed the split perfectly classifies the examples.

The learned refinement is simply:

```text
if ♥HCP <= 8:
    1NT
else:
    1H
```

attached to the intersection node.

That's a complete learned refinement.

---

# 18. What happens to a new hand?

Suppose later we get:

```text
HCP = 16
balanced = true
♥ length = 5
♥ HCP = 7
```

The original rules still both fire:

```text
R1 → 1NT
R2 → 1H
```

So we reach their intersection.

Then the learned classifier says:

```text
♥HCP = 7 <= 8
             ↓
            1NT
```

Therefore:

[
\phi(s)={1NT}.
]

Now PIDM **doesn't need to run at all**.

That is where the computational speedup comes from.

---

# 19. Why this can improve the Monte Carlo sampler too

This is the really important connection to your earlier question.

Before learning:

```text
South's model:
φSouth(s) = {1NT, 1H}
```

When RBMBMC examines a hypothetical world, either bid is considered plausible.

After learning:

```text
φSouth(s) = {1NT}
```

for many states.

Therefore, when checking historical auctions, there are fewer worlds considered behaviorally consistent.

The same happens for North and West.

So the learned decision net simultaneously gives:

[
\boxed{\text{faster action selection}}
]

and:

[
\boxed{\text{more selective world sampling}}.
]

That's why the paper's learning improvement is larger than merely replacing a search with a classifier.

---

## 20. The whole refinement algorithm in pseudocode

A faithful modern reconstruction would look approximately like:

```python
def refine_decision_net(net, pidm, N):

    # 1. Generate states where current net is ambiguous
    training_states = []

    while len(training_states) < N:

        state = generate_random_state()

        actions = net.actions(state)

        if len(actions) <= 1:
            continue

        # 2. Expensive teacher
        best_action = pidm(state, actions)

        training_states.append(
            (state.features, best_action)
        )

    # 3. Group examples by the conflicting
    #    decision-net region
    groups = group_by_intersection_node(
        training_states, net
    )

    # 4. Refine each ambiguous region separately
    for node, examples in groups.items():

        tree = ID3(
            examples,
            available_features=ALL_FEATURES
        )

        # 5. Insert tree into the intersection
        net.attach_refinement(node, tree)

    return net
```

The critical line is:

```python
group_by_intersection_node(...)
```

because this is **not** just ordinary ID3 over all bidding states.

The learned classifier is inserted into the particular region where the original rules conflict.

---

## One thing I would verify before implementing it

There is a distinction between **what the paper explicitly specifies** and what I reconstructed above as a natural implementation detail. In particular, the paper's description of the decision-net refinement and ID3 procedure is somewhat compressed; I would not want to claim that every detail of a modern implementation—such as exactly how continuous feature thresholds are enumerated—is literally what their original code did.

But the conceptual sequence is clear:

[
\boxed{
\begin{array}{c}
\text{existing rules}\
\downarrow\
\text{find overlapping/ambiguous region}\
\downarrow\
\text{generate examples in that region}\
\downarrow\
\text{PIDM gives expensive labels}\
\downarrow\
\text{ID3 searches the available features}\
\downarrow\
\text{choose maximum-information feature}\
\downarrow\
\text{recursively split}\
\downarrow\
\text{insert learned tree into the intersection}\
\end{array}}
]

And **that last "insert into the intersection" step is the distinctive part**. It prevents the learned classifier from destroying the original expert bidding rules outside the region where they actually conflict.

If you're interested in reproducing this, the next thing I'd examine is **exactly how their "intersection of two decision-net nodes" is represented and how multiple overlapping rules are handled**. That's the part that determines whether we can make a faithful implementation rather than merely an ID3 approximation.


Q: what if the initial rule has no conflict, can this refine process discover totally different approach, like precision vs sayc
A:
Not with the refinement procedure **as described in the paper**—at least not directly. This is an important limitation.

The paper's learning mechanism is primarily **conflict resolution**, not **system discovery**.

### 1. If the initial rule has no conflict

Suppose your initial bidding system says:

```text
1NT opening:
15–17 HCP, balanced
```

For every hand satisfying that rule,

[
\phi(s)={1NT}.
]

There is no ambiguity:

[
|\phi(s)|=1.
]

The paper's learning procedure generally has no reason to send these states through the expensive PIDM labeling process.

So it doesn't discover:

> "Actually, 15–17 balanced should sometimes open 1♣ under Precision."

The state isn't an **ambiguous state**, so the refinement mechanism doesn't get an opportunity to change it.

---

# 2. This means it cannot discover Precision from SAYC

Imagine the initial system is SAYC:

```text
1♣ = natural, 3+ clubs
1♦ = natural, 4+ diamonds
1NT = 15–17 balanced
```

Suppose the optimal system were Precision:

```text
1♣ = 16+ HCP
1♦ = 11–15, 2+ diamonds
...
```

The two systems have fundamentally different **action spaces**.

The paper's learning algorithm assumes approximately:

[
\text{initial expert rules}
\quad\rightarrow\quad
\text{refinement}
]

rather than:

[
\text{nothing}
\quad\rightarrow\quad
\text{discover an entirely new bidding system}.
]

So it is much closer to:

> **"Learn when an existing rule should be overridden."**

than:

> **"Invent a new convention."**

---

# 3. Why?

Consider:

```text
SAYC rule:

15–17 balanced → 1NT
```

The decision net gives:

[
\phi(s)={1NT}.
]

The learner never sees:

```text
{1NT, 1♣}
```

because `1♣` isn't an action generated by the current rules.

Therefore ID3 cannot learn:

[
1NT \rightarrow 1♣.
]

The candidate action has effectively been excluded **before the learning stage**.

This is a fundamental consequence of the architecture.

---

# 4. However, there is a way to extend it

You could change the system from:

[
\phi(s)=\text{actions allowed by expert rules}
]

to something like:

[
\phi(s)=
\text{expert actions}
\cup
\text{candidate alternative actions}.
]

For example:

```text
SAYC:
    {1NT}

candidate alternatives:
    {1C, 1D}
```

Then the state becomes:

```text
{1NT, 1C, 1D}
```

and PIDM can evaluate all three.

Now the learning process could discover:

```text
15–17 balanced
    ├── ordinary case → 1NT
    └── special case → 1C
```

But this is **no longer the original Amit–Markovitch algorithm**. You've turned their local refinement learner into a policy-improvement mechanism.

---

# 5. You could go much further: discover Precision vs SAYC

If you want the computer to actually discover a bidding system, I would change the architecture.

Instead of:

```text
Expert rules
      ↓
Find conflicts
      ↓
ID3 refinement
```

use:

```text
Candidate bidding system
        ↓
Generate candidate actions
        ↓
Search / simulation
        ↓
Evaluate actions
        ↓
Learn policy
        ↓
Modify bidding system
        ↓
repeat
```

Then **1♣ can be considered even if the original SAYC rules never suggested it.**

For example:

[
\phi(s)=A_{\rm legal}
]

initially, or a much larger candidate set.

The expensive PIDM becomes the teacher.

---

# 6. But there is an even bigger problem

Suppose you let PIDM choose among **all legal bids**.

You get:

[
38
]

possible calls at every position.

The branching factor explodes.

This is exactly why Amit–Markovitch introduced the selection strategy in the first place.

Their architecture is effectively:

[
\boxed{
\text{expert knowledge}
\rightarrow
\text{small candidate set}
\rightarrow
\text{Monte Carlo search}
}
]

If you remove the expert knowledge:

[
\text{all legal bids}
\rightarrow
\text{Monte Carlo search}
]

becomes much more expensive.

So there's a fundamental exploration/exploitation tradeoff.

---

# 7. A modern solution: separate "candidate generation" from "candidate pruning"

I think this is the interesting way to extend their idea.

Instead of one decision net, have two:

### Generator

[
G(s)
]

generates plausible bids.

### Evaluator

[
V(s,a)
]

determines which is best.

Initially:

```text
G(s) = expert rules
```

but periodically add exploratory actions:

```text
G(s) =
expert actions
+
high-value alternatives
+
random exploration
```

Then PIDM evaluates them.

Eventually you might get:

```text
SAYC initially:

15–17 balanced
    ↓
{1NT}

exploration
    ↓
{1NT, 1C}

PIDM
    ↓
1C wins in some states

learned rule
    ↓
15–17 balanced + condition X
       → 1C
```

Now the system can actually **move away from SAYC**.

---

# 8. Even better: learn the bidding system itself

For something like Precision vs SAYC, I'd represent a bidding system as a parameterized policy:

[
\pi_\theta(a\mid s)
]

where (\theta) contains the bidding rules.

For example:

[
\theta =
{
\text{1NT range},
\text{1♣ range},
\text{1♦ range},
\ldots
}.
]

Then optimize:

[
\theta^*
========

\arg\max_\theta
E[\text{score}(\pi_\theta)].
]

Now Precision isn't a special hard-coded convention.

It's simply one possible region of the policy space.

You could start with:

```text
SAYC
```

and discover that changing:

```text
1♣: 12+ natural
```

to:

```text
1♣: 16+ artificial
```

improves the expected score.

---

# 9. This actually fits very well with the Amit–Markovitch idea

Their strongest idea isn't really ID3.

It's:

[
\boxed{
\text{learn a cheap policy from an expensive search}
}
]

You could modernize it:

```text
                EXPENSIVE TEACHER
                       │
              RBMBMC + PIDM
                       │
                       ▼
               best bid/action
                       │
                       ▼
              policy improvement
                       │
                       ▼
                neural/tree model
                       │
                       ▼
             candidate generation
                       │
                       └──────────────┐
                                      │
                                      ▼
                               next iteration
```

The original paper restricts the policy-improvement step to **resolving conflicts within the existing decision net**.

A modern version could allow:

[
\boxed{\text{new actions}}
]

to enter the policy.

---

# 10. This also explains why Precision vs SAYC is a much harder problem

There are actually **three levels of learning**:

| Level   | Question                                                   | Amit–Markovitch |
| ------- | ---------------------------------------------------------- | --------------- |
| Level 1 | Which existing bid should I choose?                        | **Yes**         |
| Level 2 | When should an existing rule have an exception?            | **Yes**         |
| Level 3 | Should I invent a completely different bidding convention? | **No**          |

Precision vs SAYC is primarily **Level 3**.

The paper is very good at Levels 1–2.

---

## 11. And there is a particularly interesting research direction

You could combine their 2006 approach with modern neural bridge models:

[
\boxed{
\text{Expert system}
+
\text{exploration}
+
\text{RBMBMC}
+
\text{PIDM}
+
\text{policy learning}
}
]

Then run an experiment:

```text
Start: SAYC
       │
       ▼
allow 1–2 exploratory alternatives
       │
       ▼
RBMBMC/PIDM evaluates them
       │
       ▼
learn improved policy
       │
       ▼
repeat 1000s of iterations
```

and see whether the system independently discovers recognizable structures such as:

* strong 1♣
* artificial 1♦
* 2/1 game forcing
* 5-card major openings
* 15–17 vs 14–16 1NT
* preemptive changes
* transfer responses

In other words, **you could turn Amit–Markovitch's "refine the rules" mechanism into "evolve the bidding system."**

And I think that is much closer to the research question you were getting at earlier about whether representative-world search can outperform PIMC with the same samples: the **world model and the bidding policy can be learned together**, rather than treating the bidding system as fixed.


Q: what if the hand at play is rare case like 9 spades at one hand, the chance is so low that it can never randomly generated again within reasonable time.
A:
Exactly. This exposes a **fundamental weakness** of the paper's learning procedure.

If the training state generator is purely random, a rare hand can effectively be invisible to learning.

### Example: 9 spades

Suppose the current rule system has learned:

> With 9 spades and a particular high-card structure, bid X.

But the training process generates random deals. A 9-card suit is rare enough that you might need an enormous number of random deals before seeing a useful example.

Worse, the *specific* 9-spade hand patterns that matter can be vastly rarer.

So:

[
P(\text{rare state}) \ll 1
]

and with (N) random training states,

[
P(\text{never see it})
=(1-p)^N
\approx e^{-Np}.
]

If (p=10^{-7}), even one million random examples gives only

[
1-e^{-0.1}\approx9.5%
]

chance of seeing it.

So yes: **the Amit–Markovitch learner can simply fail to learn a rule for a rare but strategically important state.**

---

# But there is an important distinction

There are actually two different problems.

### Problem A — rare *hand*

You happen to receive:

```text
♠ 9 cards
♥ 1
♦ 2
♣ 1
```

The state itself is rare.

### Problem B — rare *decision region*

The hand might not be astronomically rare, but the **particular auction + hand combination** where the existing rules conflict might be.

The second problem can be even worse.

The paper's learning procedure is essentially sampling:

[
s\sim \text{random bridge states}
]

and looking for:

[
|\phi(s)|>1.
]

Therefore the probability of finding a useful example is roughly:

[
P(
\text{rare hand}
\cap
\text{ambiguous rule}
).
]

That can become extremely small.

---

# There is an even more serious problem

Suppose your actual hand is:

```text
♠ AKQJxxxxx
```

and the current decision net gives:

[
\phi(s)={3S}.
]

No conflict.

The learning system doesn't even consider this an interesting training state.

But suppose the expensive PIDM discovers:

[
4S
]

would actually be dramatically better.

The original learning mechanism won't discover this because:

[
4S\notin\phi(s).
]

So we have **two filters**:

```text
randomly generate state
        ↓
is it rare?
        ↓
does current rule system have a conflict?
        ↓
if not → ignored
        ↓
PIDM
```

A rare but important state can therefore fall through the entire system.

---

# How I would fix this

The natural solution is **experience-driven sampling** rather than purely random state generation.

Instead of:

[
s\sim Uniform(\text{all deals})
]

use something closer to:

[
s\sim
\text{distribution of states actually encountered}
]

and then deliberately oversample unusual states.

For example:

```text
                 Training-state generator
                         │
          ┌──────────────┼──────────────┐
          │              │              │
       random        real deals      rare-state
       deals          database        generator
          │              │              │
          └──────────────┼──────────────┘
                         ▼
                   candidate states
                         │
                         ▼
                  expensive PIDM
                         │
                         ▼
                    new policy
```

---

# 1. Use the actual deal distribution, but stratify it

Instead of asking:

> "Give me a random deal."

ask:

> "Give me a random deal conditioned on having 8–9 spades."

For example:

[
s\sim P(s\mid \text{spades}=9).
]

Now the rare state isn't rare **inside the training bucket**.

You can have buckets:

```text
0–4 spades
5 spades
6 spades
7 spades
8 spades
9 spades
10+ spades
```

and deliberately allocate training samples to each bucket.

This is essentially **stratified sampling**.

---

# 2. Even better: sample conditional on the current hand

Suppose you are actually playing:

```text
9 spades
```

You can immediately trigger a special training/search mode:

```text
current hand
    ↓
rare-state detector
    ↓
"9 spades"
    ↓
retrieve/generate similar historical states
    ↓
PIDM
```

This is much better than hoping a random generator eventually produces another 9-spade hand.

---

# 3. Use nearest-neighbor / similarity search

Suppose the current hand is:

```text
♠ AKQJ98765
♥ 4
♦ 82
♣ 3
```

There may be no identical training example.

But you can search for:

```text
8–10 spades
similar HCP
similar controls
similar auction
similar vulnerability
```

Then use those states to seed additional learning.

This gives:

[
\text{rare state}
\rightarrow
\text{nearby common states}
\rightarrow
\text{learn local policy}.
]

---

# 4. But the really powerful approach is adversarial / active state generation

Instead of randomly searching for difficult states, ask:

> **What states does my current policy look uncertain or wrong on?**

For example:

```text
current policy
      ↓
generate candidate state
      ↓
cheap policy says 3♠
      ↓
expensive PIDM says 4♠
      ↓
large disagreement
      ↓
HIGH-VALUE TRAINING STATE
```

Now the probability of encountering the state doesn't matter.

You're deliberately looking for it.

This is much closer to modern **active learning**.

---

# 5. You can search directly in feature space

For the 9-spade problem, you don't even need to generate complete deals blindly.

Say we want:

[
\text{SpadeLength}=9.
]

Generate the hand structure first:

```text
9 spades
1 heart
2 diamonds
1 club
```

then randomly assign actual cards satisfying that structure.

In other words:

```text
ordinary:
random deal
   ↓
check spade length
   ↓
usually reject

conditional:
choose spade length = 9
   ↓
generate valid deal
```

This can improve sampling by many orders of magnitude.

---

# 6. There is a subtle issue with doing this

You **cannot train directly on the artificially oversampled distribution** and then interpret the frequencies as real-world frequencies.

Suppose you deliberately make:

```text
50% of training states = 9-spade hands
```

when in reality:

```text
P(9 spades) ≪ 50%.
```

That's fine for **learning a policy**, but not fine if you're estimating expected utility by simply averaging these samples.

You need to distinguish:

### Training distribution

Can be heavily biased toward difficult/rare states.

### Evaluation distribution

Should reflect the actual bridge distribution.

So:

[
P_{\text{train}}(s)
\neq
P_{\text{real}}(s)
]

is perfectly acceptable.

But evaluation should use:

[
P_{\text{test}}(s)=P_{\text{real}}(s).
]

---

# 7. This suggests a much better successor to the paper

I would modify their learning loop to:

```text
                    Policy π
                       │
          ┌────────────┴────────────┐
          │                         │
     normal states             difficult states
          │                         │
     random sample           active generation
          │                         │
          └────────────┬────────────┘
                       ▼
                 expensive PIDM
                       │
                       ▼
             teacher's preferred bid
                       │
                       ▼
                  replay buffer
                       │
                       ▼
                policy refinement
```

The replay buffer could contain:

```text
state
features
current policy
PIDM action
PIDM utility
uncertainty
rarity
```

Then prioritize examples with high:

[
\text{priority}
===============

f(
\text{rarity},
\text{policy disagreement},
\text{utility difference}
).
]

---

# 8. And this connects to your earlier "representative worlds" question

There are actually **two levels of representative sampling**.

### Inside a single decision

Find representative hidden worlds:

[
\boxed{\text{RBMBMC}}
]

rather than blindly doing PIMC.

### Across the lifetime of the learner

Find representative **training states**:

[
\boxed{\text{active / stratified state sampling}}
]

rather than blindly generating random deals.

The 2006 paper is sophisticated about the **first** but relatively primitive about the **second**.

That gives a very natural modern architecture:

[
\boxed{
\text{Active state sampling}
+
\text{RBMBMC}
+
\text{PIDM}
+
\text{policy learning}
}
]

---

## And for your 9-spade example, I would absolutely not wait for random generation

If the agent actually receives a 9-spade hand, I would treat that event as an **experience worth saving**.

Something like:

```text
PLAY
 │
 ├─ ordinary hand → normal inference
 │
 └─ unusual hand
       │
       ├─ cache state
       ├─ run expensive analysis
       ├─ compare alternatives
       └─ add to training buffer
```

Then the learner can later discover:

> "The existing bidding system has no special rule for this region, but the expensive search consistently prefers a different action."

That is precisely the mechanism needed to move from **rule refinement** toward **discovering new conventions**.

And there's an even deeper consequence: if you allow these newly discovered actions back into the candidate-generation policy, the system can gradually **escape its original SAYC/Precision rule set**, rather than merely refine it.


Q: think of changes that can solve the above two problems
A:
Yes. I think the two problems are really two different failure modes:

1. **Rare-state problem:** random training never encounters an important state.
2. **Closed-action-space problem:** even if the state is encountered, the current decision net may never consider the action that would be better, so the learner cannot discover a fundamentally different bidding rule.

I would modify Amit–Markovitch in several layers rather than simply replacing ID3.

---

# 1. Problem 1: rare states

The original learner roughly does:

[
s\sim P_{\text{deal}}(s)
\rightarrow
\text{keep if }|\phi(s)|>1
\rightarrow
PIDM(s)
]

This is problematic because the probability of obtaining a useful rare state may be tiny.

### Change 1: maintain a persistent experience buffer

Every state actually encountered during play should go into a replay buffer:

[
\mathcal D =
{(s,\phi(s),PIDM(s),\ldots)}.
]

Especially save states where:

* unusual distribution;
* unusual auction;
* very high/low HCP;
* long suit;
* singleton/void;
* current policy has low confidence;
* competing actions have close values;
* current policy and expensive search disagree.

For example:

```text
9-spade hand
     ↓
actual game
     ↓
save state
     ↓
expensive analysis
     ↓
training example
```

Now the probability of seeing that particular rare hand again is irrelevant.

---

# 2. Change 2: conditional state generation

Don't rely entirely on unconditional random deals.

If you want examples with 9 spades, generate:

[
s\sim P(s\mid L_\spades=9).
]

More generally, define strata:

[
\mathcal S_1,\mathcal S_2,\ldots
]

such as:

```text
5-card major
6-card major
7-card major
8-card major
9+ card major

balanced
semi-balanced
extreme distribution

0–7 HCP
8–11
12–14
15–17
18–20
21+
```

Then deliberately sample from underrepresented strata.

This is much better than hoping ordinary Monte Carlo discovers them.

---

# 3. But don't just enumerate hand patterns

There's a more powerful approach.

Generate states **conditioned on the current policy's weaknesses**.

For example:

[
s\sim P(s\mid \text{policy uncertain}).
]

A state becomes interesting if:

[
|\phi(s)|>1
]

or, more generally, if two models disagree:

[
\left|
V_{\text{PIDM}}(a_1)-V_{\text{PIDM}}(a_2)
\right|
]

is large.

So the training generator becomes an **active learner**.

---

# 4. Problem 2: closed action space

This is more serious.

Original:

[
A(s)=\phi(s).
]

If:

[
\phi(s)={1NT},
]

PIDM never evaluates:

[
1C.
]

Therefore it cannot discover that 1C is better.

I would change this to:

[
A(s)=
A_{\text{expert}}(s)
\cup
A_{\text{explore}}(s).
]

The expert system supplies safe candidates; exploration supplies alternatives.

---

# 5. Don't explore all 38 bids

That would destroy the computational advantage.

Instead use a **hierarchical candidate generator**.

For example:

```text
                 Candidate generation
                         │
          ┌──────────────┼──────────────┐
          │              │              │
       Expert         Neural         Exploration
        rules          model           model
          │              │              │
          └──────────────┼──────────────┘
                         ▼
                  3–8 candidate bids
                         │
                         ▼
                       PIDM
```

So if SAYC says:

```text
1NT
```

the exploration mechanism might add:

```text
1C
```

but not necessarily every legal call.

---

# 6. Where should exploratory bids come from?

I see three increasingly powerful choices.

### A. Local perturbation

Take an existing rule and modify it.

If:

```text
15–17 balanced → 1NT
```

generate alternatives:

```text
15–16 balanced → 1NT
17 balanced → 1C
15–17 balanced → 1C
```

This can discover small changes.

### B. Other bidding systems

Maintain several prior policies:

```text
SAYC
Precision
2/1
ACOL
...
```

and use their bids as exploration candidates.

This is extremely useful for the Precision-vs-SAYC question.

### C. Learned policy

Train a neural policy:

[
\pi_\theta(a|s)
]

to predict potentially good actions.

Then use its top-(k) bids as exploration candidates.

---

# 7. I would explicitly separate "policy" from "candidate generator"

This is one of the biggest architectural changes I'd make.

The original system essentially conflates:

[
\text{what I know how to bid}
]

with:

[
\text{what I should consider}.
]

Instead:

### Policy

[
\pi(a|s)
]

represents what we currently believe is best.

### Candidate generator

[
G(s)
]

tries to ensure potentially good actions aren't omitted.

Then:

[
A(s)=G(s)
]

and PIDM evaluates them.

This solves the closed-action-space problem.

---

# 8. Add an "escape mechanism"

Suppose the current model is extremely confident:

```text
φ(s) = {1NT}
```

Normally we'd skip PIDM.

But periodically force exploration:

[
P(\text{explore})=\epsilon.
]

For example:

```text
99%:
    trust current rule

1%:
    ask "could something else be better?"
```

For unusual states, increase it:

```text
normal state:
    ε = 0.01

rare state:
    ε = 0.10

model disagreement:
    ε = 0.50
```

This is essentially an **adaptive exploration rate**.

---

# 9. Make rarity itself a feature of the training priority

I'd assign every training state a priority such as:

[
Priority(s)
===========

\alpha U(s)
+\beta D(s)
+\gamma R(s)
+\delta I(s)
]

where:

* (U) = uncertainty
* (D) = disagreement between current policy and PIDM
* (R) = rarity
* (I) = potential impact

For example:

```text
9-spade hand
current policy: 3S
PIDM: 4S
utility difference: 200 IMP-equivalent
```

gets extremely high priority.

Whereas:

```text
ordinary 15 HCP hand
current policy = PIDM
```

gets low priority.

---

# 10. But rarity shouldn't automatically mean "learn a new rule"

This is important.

A 9-spade hand is rare.

If the correct action is always obvious and the original system already handles it correctly, there is little reason to modify the policy.

So I'd require something like:

[
\text{rare}
+
\text{policy weakness}
]

before spending substantial computation.

---

# 11. Replace the binary "conflict/no conflict" condition

The original mechanism focuses heavily on:

[
|\phi(s)|>1.
]

I'd replace this with a much broader **learning trigger**.

A state is interesting if any of these occur:

### Rule conflict

[
|\phi(s)|>1
]

### Search disagreement

[
\arg\max_a V_{\text{PIDM}}(a)
\neq
\pi(s)
]

### Large value gap

[
V(a^*)-V(\pi(s))>\epsilon
]

### Model uncertainty

[
H(\pi(\cdot|s))>\tau
]

### Rare state

[
P(s)<\tau_r
]

### Out-of-distribution state

[
s\not\approx \mathcal D_{\text{train}}.
]

That dramatically improves coverage.

---

# 12. Now the learning target changes

The original learner mostly sees:

```text
{1NT, 1H} → 1NT
```

and learns a separator.

The new learner can see:

```text
current policy:
    1NT

candidate actions:
    1NT, 1C

PIDM:
    1C

training target:
    1C
```

That means the learner can actually **create a new action region**.

For example:

```text
Before:

15–17 balanced
       ↓
      1NT


After:

15–17 balanced
       │
       ├── normal → 1NT
       │
       └── condition X → 1C
```

Now we have genuine policy expansion.

---

# 13. To discover something as radical as Precision

Local refinement alone may still not be enough.

I'd add **macro-actions / convention mutations**.

Instead of modifying only individual decisions, allow mutations such as:

```text
Change:
1C = natural

to:

1C = strong artificial
```

or:

```text
1NT:
15–17

→

14–16
```

or:

```text
2D:
weak

→

multi
```

Then evaluate the entire convention package over many deals.

This becomes a higher-level optimization problem:

[
\theta^*
========

\arg\max_\theta
E_{s\sim P_{\rm bridge}}
[Score(\pi_\theta,s)].
]

Here (\theta) describes the bidding system itself.

That's how you get from:

> "refine SAYC"

to:

> **"discover a better bidding system."**

---

# 14. There is a danger with this: incompatible conventions

You can't independently optimize:

```text
1C
1D
1H
1S
```

because changing one affects the meaning of subsequent bids.

So I'd represent a bidding system as a **grammar / convention configuration**, not independent rules.

For example:

```text
System θ
├── Opening structure
│   ├── 1C
│   ├── 1D
│   ├── 1H
│   └── 1S
├── 1NT range
├── 2-level openings
├── responses
├── rebids
└── competition
```

Then mutations operate on coherent subtrees.

This makes "discover Precision" much more realistic.

---

# 15. The modified architecture

I would therefore build:

```text
                         Current system θ
                               │
                               ▼
                       Candidate generator
                               │
              ┌────────────────┼────────────────┐
              │                │                │
          expert rules    learned policy     exploration
              │                │                │
              └────────────────┼────────────────┘
                               ▼
                         candidate bids
                               │
                               ▼
                       RBMBMC + PIDM
                               │
                    ┌──────────┴──────────┐
                    │                     │
              best action            value estimates
                    │                     │
                    ▼                     ▼
               play action          experience buffer
                                          │
                              ┌───────────┼───────────┐
                              │           │           │
                           rare       disagreement  OOD
                              │           │           │
                              └───────────┼───────────┘
                                          ▼
                                  expensive analysis
                                          │
                                          ▼
                                   policy learning
                                          │
                                          ▼
                                   system mutation
                                          │
                                          ▼
                                      θ'
```

---

# 16. One thing I would *not* change

I would retain RBMBMC.

That's actually the part of the 2006 architecture that I think remains valuable.

Once you have an exploratory candidate bid, you still need to evaluate it under uncertain partner/opponent hands.

And the behavioral model gives you:

[
P(\text{world}\mid\text{auction + behavior})
]

or at least a useful approximation to it.

So I'd preserve:

[
\boxed{\text{RBMBMC + nested PIDM}}
]

and replace primarily the **training-state generation and candidate-action generation**.

---

# 17. The resulting learning loop

The final algorithm I'd propose is:

### Phase 1 — initialize

Start with SAYC, Precision, or any expert system.

### Phase 2 — play/sample

Generate both ordinary and deliberately difficult states.

### Phase 3 — detect opportunities

Look for:

[
\begin{aligned}
&\text{rule conflict}\
&\text{policy/PIDM disagreement}\
&\text{rare state}\
&\text{OOD state}\
&\text{high-value alternative}
\end{aligned}
]

### Phase 4 — expand candidate set

Allow alternatives outside the existing decision net.

### Phase 5 — expensive teacher

Use RBMBMC + PIDM to determine the better action.

### Phase 6 — learn

Add either:

* a local refinement, or
* a genuinely new rule.

### Phase 7 — periodically mutate the convention system

Allow larger structural changes.

### Phase 8 — evaluate on an unbiased deal set

This is critical:

[
\boxed{\text{training can be biased; evaluation cannot.}}
]

---

# 18. The key conceptual change

The original paper has:

[
\boxed{
\text{Search improves rules}
}
]

I'd make it:

[
\boxed{
\text{Search improves rules}
+
\text{search challenges rules}
}
]

The second part is what prevents the system from becoming permanently trapped inside its initial assumptions.

And for your two examples:

| Problem                                | Original paper          | Proposed change                                 |
| -------------------------------------- | ----------------------- | ----------------------------------------------- |
| 9-spade hand never sampled             | Random state generation | Experience replay + conditional/active sampling |
| State has no rule conflict             | Ignore it               | Search/PIDM disagreement trigger                |
| Better bid isn't in candidate set      | Cannot discover it      | Exploratory candidate generator                 |
| New local convention                   | Limited                 | Policy expansion                                |
| Precision vs SAYC                      | Essentially impossible  | Convention-level mutations                      |
| Rare state overrepresented in training | Potential bias          | Biased training + unbiased evaluation           |

**The most important modification, in my view, is to remove the assumption that `φ(s)` defines the complete action space.** Keep it as the *default candidate generator*, but occasionally let the expensive search challenge it. That turns the original "rule refinement" system into a genuine **open-ended policy improvement system** while preserving its biggest advantage: using expensive reasoning only where it is actually informative.


Q:how can the convention bid be found, or designed
A:
Yes — I think that's the key insight. A **bridge convention is not fundamentally a classifier**. It is closer to an **imperative protocol/program**.

A classifier says:

> Given this hand, output `1♣`.

A convention says:

> **If I bid `1♣`, you must interpret it this way; given your response, I will interpret that response this way; then I will continue according to these rules.**

So there is a stateful flow.

### 1. Convention as a state machine

A useful abstraction is:

[
\boxed{C=(S,A,T,M)}
]

where:

* (S) = auction states
* (A) = bids
* (T) = transition rules
* (M) = meanings attached to transitions

For example:

```text
                 1♣
                  │
          "16+ artificial"
                  │
                  ▼
             1♦ response
                  │
          "negative / waiting"
                  │
                  ▼
            opener rebids
             /         \
           1NT          1♥
            │             │
       balanced        hearts
```

The convention isn't just the nodes. **The arrows are the convention.**

---

# 2. This changes how I would search for conventions

Previously I described:

[
\text{hand}\rightarrow\text{bid}
]

as the basic unit.

I think that's too weak.

The basic unit should be:

[
\boxed{
(\text{auction state},\text{private information})
\rightarrow
(\text{bid},\text{new state})
}
]

So the learned object is essentially a **program**.

For example:

```text
OPEN 1C
    REQUIRE HCP >= 16
    SET MEANING = STRONG

    ON RESPONSE 1D:
        MEANING = NEGATIVE
        CONTINUE ...

    ON RESPONSE 1H:
        MEANING = POSITIVE
        CONTINUE ...
```

That's much closer to how real conventions are written.

---

# 3. And this gives us a much better way to discover conventions

Instead of inventing complete conventions, let the system discover **subroutines**.

For example:

### Step 1

Search discovers:

[
16+\text{ HCP}
\rightarrow 1C
]

This by itself isn't yet a convention.

### Step 2

The optimizer asks:

> What information should partner provide after 1♣?

It discovers that a simple natural response wastes too much information.

So it discovers:

[
1C-1D=\text{negative}.
]

### Step 3

Then:

> Given 1♣–1♦, what should opener communicate next?

It discovers:

[
1C-1D-1NT
=========

\text{balanced}.
]

### Step 4

Then it discovers another branch:

[
1C-1D-2H
========

\text{strong hearts}.
]

Eventually:

```text
1♣
 └─ artificial strong
     │
     ├─ 1♦ = negative
     │    └─ 1NT = balanced
     │    └─ 2♥ = hearts
     │
     ├─ 1♥ = positive hearts
     └─ 1♠ = positive spades
```

**The convention grows as a protocol.**

---

# 4. This also solves an important chicken-and-egg problem

Suppose you want to discover Precision.

You don't want the system to search:

> "What should 1♣ mean?"

in isolation.

Because changing 1♣ creates a requirement:

> "Now where do the hands that used to open 1♣ go?"

So the system should reason about **capacity**.

If:

[
1C=16+
]

then the remaining 11–15 hands need somewhere to go.

The optimizer might discover:

[
1D=11-15,\ 2+D.
]

Now a new problem appears:

> What happens to 1♦ responses?

And the flow continues.

Thus convention discovery becomes something like:

[
\boxed{
\text{change one transition}
\rightarrow
\text{propagate consequences}
\rightarrow
\text{repair protocol}
}
]

That's much more natural than independently optimizing bids.

---

# 5. I would represent it as a typed imperative language

Something like:

```text
CONVENTION PrecisionLike {

    OPEN 1C {
        IF HCP >= 16:
            MEANING strong_artificial
            FORCE response
    }

    RESPONSE 1C-1D {
        MEANING negative
    }

    RESPONSE 1C-1H {
        MEANING positive_hearts
    }

    REBID 1C-1D-1NT {
        IF balanced:
            MEANING balanced_16_18
    }

}
```

The important thing is that every statement changes the **interpretation of future states**.

This is essentially a domain-specific programming language for bridge.

---

# 6. Then convention discovery becomes program synthesis

We can write:

[
C' = mutate(C)
]

where mutations are things like:

```text
ADD rule
DELETE rule
CHANGE predicate
CHANGE bid
CHANGE meaning
ADD response branch
MERGE branches
SPLIT branch
```

But every mutation must pass a set of constraints.

For example:

[
\text{valid}(C') =
\begin{cases}
1 & \text{if all auctions have coherent meanings}\
0 & \text{otherwise}.
\end{cases}
]

Then evaluate:

[
Score(C').
]

So:

[
\boxed{
\text{Program synthesis}
+
\text{bridge simulation}
}
]

is probably the right conceptual framework.

---

# 7. There is another important property: conventions are compositional

Real conventions are built from smaller modules.

For example:

```text
Strong Club
+
Negative responses
+
Relay structure
+
Control-bidding module
```

Or:

```text
1NT opening
+
Stayman
+
Transfers
+
Smolen
```

Each is a little protocol.

So instead of evolving an entire convention from scratch, have a library:

```text
Convention modules
├── Strong club
├── Multi 2♦
├── Transfers
├── Stayman
├── Relays
├── Negative doubles
├── 2/1 GF
└── ...
```

Then the optimizer can **compose modules**.

This dramatically reduces the search space.

---

# 8. But modules have interfaces

This is where the programming analogy becomes particularly strong.

A module could specify:

```text
StrongClub:

INPUT:
    auction begins with 1♣

PROVIDES:
    interpretation of 1♣
    response protocol
    opener rebid protocol

REQUIRES:
    available bids 1♦–2♠

CONFLICTS:
    natural 1♣
```

Then the system can determine whether two modules can coexist.

For example:

```text
Strong Club
+
Transfers
```

might be compatible.

But:

```text
Strong Club
+
Natural 1♣
```

obviously isn't.

---

# 9. This gives us a hierarchy

I would model the entire thing as:

[
\boxed{
\text{Convention system}
}
]

contains

[
\downarrow
]

**modules**

which contain

[
\downarrow
]

**protocols**

which contain

[
\downarrow
]

**transition rules**

which contain

[
\downarrow
]

**hand predicates / meanings**.

So:

```text
System
 │
 ├── Opening structure
 │     ├── 1♣ protocol
 │     ├── 1♦ protocol
 │     └── 1NT protocol
 │
 ├── Responses
 │     ├── Stayman
 │     └── Transfers
 │
 └── Competitive bidding
       ├── doubles
       └── overcalls
```

This is much closer to an actual bridge bidding system.

---

# 10. And now the Amit–Markovitch learner has a natural place

Their ID3-style learning can remain useful, but it becomes a **compiler optimization**, not the convention designer.

For example:

```text
Convention program
       │
       ▼
  protocol rules
       │
       ▼
 decision net
       │
       ▼
 fast bidding policy
```

ID3 can discover:

> Within this protocol, this feature determines which branch should be taken.

So:

[
\boxed{
\text{program synthesis}
\rightarrow
\text{decision-net compilation}
}
]

rather than trying to make ID3 invent the entire convention.

I think that's a much cleaner architecture.

---

# 11. Most importantly, the search objective changes

You don't want:

[
\max_C Score(C)
]

alone.

You want something like:

[
\boxed{
\max_C
\left[
E(Score\mid C)
-\lambda Complexity(C)
-\mu Ambiguity(C)
-\nu Memory(C)
\right]
}
]

subject to:

[
C\text{ is a valid protocol}.
]

That makes the system search for **simple, learnable, high-performing conventions**.

---

### So I agree with your observation

The right mental model is not:

> **"AI discovers a mapping from hands to bids."**

It is:

> **"AI synthesizes an imperative communication protocol between two agents under partial information."**

And that is substantially more interesting.

Once you formulate it this way, **Precision vs SAYC becomes a program-synthesis problem over communication protocols**, with RBMBMC/PIDM acting as the expensive semantic evaluator and the learned decision net acting as the compiled fast execution layer.


Q: question is how new convention can be invented by this approach
A:
Yes—but **not all conventions are equally discoverable by the mechanism we described**. The distinction is important.

I would divide them into three classes:

1. **Classification conventions** — relatively easy.
2. **Information-routing conventions** — harder, but discoverable.
3. **Multi-stage query protocols** such as Blackwood/RKCB — hardest, but still possible if we explicitly give the system the ability to invent *questions and encoded answers*.

Jacoby transfers, Stayman, and slam-control asks are excellent tests because they demonstrate progressively more sophisticated forms of invention. Jacoby transfers are specifically designed to make the stronger NT hand declarer, while Stayman asks for a 4-card major; Blackwood uses a step-coded response to an artificial 4NT question. ([Wikipedia][1])

## 1. Can it discover Jacoby transfers?

**Yes, quite plausibly.**

Suppose the system has only natural bidding after 1NT:

```text
1NT — 2♥ = natural hearts
1NT — 2♠ = natural spades
```

Now its counterfactual search notices a recurring problem.

Consider:

```text
North: strong 1NT hand
South: weak 5♥ hand
```

There are two possibilities:

```text
1NT — 2♥
```

where South declares 2♥, versus somehow making North declare the eventual heart contract.

The search can discover that:

[
\text{North as declarer}

>

\text{South as declarer}
]

on a significant class of deals.

That produces a very interesting counterfactual:

> "What if South's 2♥-level bid did **not** mean hearts, but instead instructed North to bid hearts?"

Now introduce an **instruction-generation operator**:

[
\operatorname{Request}(b,\text{action})
]

and search over:

[
1NT-2D-2H.
]

It may discover:

```text
2♦ = "please bid 2♥"
```

because this creates:

```text
1NT – 2♦ – 2♥
```

with **North as declarer**.

That's essentially Jacoby transfer.

The actual convention is indeed 2♦ → 2♥ and 2♥ → 2♠. ([Wikipedia][1])

### But there is a crucial missing capability

The system must be allowed to invent:

> **a bid whose meaning is an instruction rather than a description of the bidder's hand.**

That's a fundamental extension to our previous framework.

---

# 2. The system needs two kinds of meanings

Currently we have:

[
\text{bid} \rightarrow \text{information about my hand}.
]

We need to add:

[
\text{bid} \rightarrow \text{instruction to partner}.
]

For example:

```text
2♦
    TYPE: COMMAND
    TARGET: opener
    ACTION: bid 2♥
```

This is much more powerful.

Now the search space contains:

```text
SHOW(hearts)
SHOW(spades)
ASK(has_4_card_major)
REQUEST(bid_hearts)
REQUEST(bid_spades)
ASK(number_of_aces)
...
```

This is starting to look like a **programming language for communication**.

---

# 3. Can it discover Stayman?

**Yes, and this is an even better test.**

Suppose after 1NT the system discovers:

> Sometimes I need to know whether partner has four hearts or four spades.

But responder doesn't have enough bidding space to simply say:

```text
"I have four hearts."
```

because responder doesn't yet know whether opener has four hearts/spades.

So the system can invent a **query**:

[
Q=\operatorname{Ask}(\text{four-card major?})
]

implemented by:

```text
1NT – 2♣
```

Then it needs to synthesize the response protocol:

```text
2♦ = no
2♥ = hearts
2♠ = spades
```

That is essentially Stayman. ([Wikipedia][2])

Notice how different this is from ordinary supervised learning.

The learner has invented:

[
\boxed{
\text{question}
\rightarrow
\text{answer code}
}
]

rather than simply:

[
\text{hand}\rightarrow\text{bid}.
]

---

# 4. The really interesting part: why would it invent an ASK?

We need to put **information value** into the objective.

Suppose after 1NT there are two possible contracts:

[
3NT
]

and

[
4H/4S.
]

The best choice depends strongly on whether opener has a 4-card major.

Without knowing that information:

[
E[V]
]

is mediocre.

If responder can ask:

[
Q=\text{has 4-card major?}
]

then after receiving the answer:

[
E[V\mid Q]
]

is much higher.

The value of the question is approximately:

[
VOI(Q)
======

## E[\max_a V(a\mid Q)]

\max_a E[V(a)].
]

This is **value of information**.

Now the system has a principled reason to invent an asking convention.

---

# 5. This is actually a major extension I would make

Give every possible convention action a semantic type:

[
\boxed{
\begin{array}{ll}
SHOW(x) & \text{tell partner something}\
ASK(x) & \text{ask partner something}\
COMMAND(x) & \text{tell partner to do something}\
TRANSFER(x) & \text{request partner to bid something}\
RELAY & \text{request structured description}\
ENCODE(x) & \text{communicate information through bid levels}
\end{array}}
]

Then convention discovery becomes much more interesting.

---

# 6. Jacoby = COMMAND

The system discovers:

[
2D = COMMAND(\text{bid hearts}).
]

Then:

[
2H = COMMAND(\text{bid spades}).
]

That's a transfer.

---

# 7. Stayman = ASK + ENCODE

The system discovers:

[
2C=ASK(\text{four-card major?})
]

and then must design an answer code:

[
2D=\text{neither}
]

[
2H=\text{hearts}
]

[
2S=\text{spades}.
]

The responses aren't arbitrary—they are an **encoding scheme**.

---

# 8. Blackwood is even more interesting

Now consider slam bidding.

The system identifies a recurring failure:

```text
We reach 6♥
but don't know whether partner has enough key controls.
```

It discovers that asking:

[
\text{How many aces do you have?}
]

has positive value of information.

So it invents:

```text
4NT = ASK(number of aces)
```

But now there is a new problem:

> How can partner answer?

There aren't enough bids to have:

```text
5♣ = 0
5♦ = 1
5♥ = 2
5♠ = 3
```

which is exactly the step-coded structure of Blackwood. ([Wikipedia][3])

So the AI needs to invent an **encoding protocol**.

---

# 9. This is where the problem becomes genuinely interesting

Suppose the information is:

[
X\in{0,1,2,3,4}.
]

The responder has available actions:

[
A={5C,5D,5H,5S,5NT}.
]

The AI can synthesize an encoding:

[
f:X\rightarrow A.
]

For example:

[
0\rightarrow5C
]

[
1\rightarrow5D
]

[
2\rightarrow5H
]

[
3\rightarrow5S.
]

That's Blackwood.

But the AI could discover **other encodings** if they produce better downstream results.

---

# 10. And RKCB becomes a more sophisticated optimization

Now suppose the AI discovers that "number of aces" isn't actually the most useful variable.

Instead:

[
X=
(\text{keycards},\text{trump queen},\ldots)
]

has greater decision value.

Then it can synthesize:

[
ASK(X)
]

and an encoding function:

[
f(X)\rightarrow{\text{available bids}}.
]

That's conceptually how you could get something like Roman Key Card rather than merely rediscovering Blackwood.

The important point is that the AI isn't told:

> "invent Blackwood."

It discovers:

> **"I need information of type X, and the most efficient way to transmit it is this step-coded protocol."**

---

# 11. But there's a huge obstacle

A naive search will discover terrible conventions.

For example:

```text
4NT = ask keycards

5♣ = 0
5♦ = 1
5♥ = 2
5♠ = 3
```

looks great locally.

But maybe:

```text
5♣
```

interferes with the natural auction.

Or maybe the partnership reaches 5♠ and can't stop safely.

Or maybe the answer consumes too much bidding space.

So the evaluator must look **several bids into the future**.

This is where your RBMBMC/PIDM idea becomes important.

The convention's value is:

[
V(C)
====

E[
\text{final contract quality}
\mid C
].
]

Not:

[
V(C)=\text{information transmitted}.
]

Information is only valuable if it improves the final contract.

---

# 12. There is an even deeper problem: invented conventions need common knowledge

Suppose North invents:

```text
2♦ = transfer
```

but South doesn't know it.

It is useless.

So the optimization cannot be:

[
\max_{\pi_N}V.
]

It must be:

[
\boxed{
\max_C V(\pi_C,\pi_C)
}
]

where **both partners execute the same synthesized protocol**.

This makes convention synthesis naturally different from ordinary policy learning.

---

# 13. I would therefore change our architecture again

Instead of just:

```text
rule
→ new rule
```

use:

```text
                 Convention synthesizer
                         │
             ┌───────────┼────────────┐
             │           │            │
           SHOW         ASK        COMMAND
             │           │            │
             └───────────┼────────────┘
                         ▼
                  Protocol generator
                         │
                         ▼
                 response encoder
                         │
                         ▼
                  complete branch
                         │
                         ▼
                  bridge simulator
                         │
                         ▼
                    fitness
```

This can potentially produce:

```text
1NT
 ├── 2♣ ASK(major)
 │     ├── 2♦ NONE
 │     ├── 2♥ HEARTS
 │     └── 2♠ SPADES
 │
 ├── 2♦ COMMAND(bid hearts)
 │     └── ...
 │
 └── 2♥ COMMAND(bid spades)
       └── ...
```

That's already remarkably close to the architecture of modern NT conventions. Stayman and Jacoby transfers are both widely used after 1NT, but they solve different information-routing problems. ([Bridge.com][4])

---

# 14. Can it discover a slam-control convention?

**Yes, but only if we add one more capability: discovering what information is worth asking for.**

For every possible hidden variable (X), estimate:

[
VOI(X)
======

## E[\max_a V(a\mid X)]

\max_aE[V(a)].
]

Potential (X)'s include:

```text
number of aces
number of keycards
trump queen
void
specific king
control in a particular suit
number of losers
exact HCP
distribution
```

If:

[
VOI(\text{keycards})
]

is high, invent an ASK.

Then optimize the encoding.

Then evaluate the complete auction.

That's enough machinery to potentially discover:

[
4NT\rightarrow\text{keycard ask}
]

rather than having Blackwood hard-coded.

---

# 15. There is an important limitation, though

**It will not spontaneously discover "Jacoby" from nothing unless the search space contains the concept of a transfer.**

This is crucial.

If the available operations are only:

```text
SHOW(hand feature)
ASK(hand feature)
```

then it may discover Stayman and Blackwood, but **not necessarily Jacoby**, because Jacoby's fundamental idea is:

[
\boxed{
\text{I want you to become declarer}
}
]

That's a **COMMAND / ROLE-ASSIGNMENT** concept.

So the primitive language must be sufficiently expressive.

I'd give it:

```text
SHOW
ASK
COMMAND
TRANSFER
RELAY
ENCODE
```

rather than hard-coding individual conventions.

---

# 16. And this gives us a nice hierarchy of invention

| Convention type      | What AI has to discover                 | Difficulty |
| -------------------- | --------------------------------------- | ---------- |
| Strong 2♣            | new hand partition                      | ★          |
| Stayman              | question + answer encoding              | ★★         |
| Jacoby transfer      | command/role reassignment               | ★★★        |
| Blackwood            | question + step encoding                | ★★★        |
| RKCB                 | optimal information variable + encoding | ★★★★       |
| Complex relay system | recursive protocol synthesis            | ★★★★★      |

So **yes, the mechanism can in principle discover all three classes**, but only after we explicitly promote "communication operations" to first-class objects.

And I think this is the crucial conceptual breakthrough:

> **A bridge convention is an information-transfer program.**

The AI doesn't need to be told "invent Jacoby Transfer." It needs to be able to discover that, for a particular state, **telling partner what to do is more valuable than telling partner what you have**, and then discover the cheapest bid sequence for transmitting that instruction. That is a genuinely general mechanism rather than a collection of hard-coded convention templates.

[1]: https://en.wikipedia.org/wiki/Jacoby_transfer?utm_source=chatgpt.com "Jacoby transfer"
[2]: https://en.wikipedia.org/wiki/Stayman_convention?utm_source=chatgpt.com "Stayman convention"
[3]: https://en.wikipedia.org/wiki/Blackwood_convention?utm_source=chatgpt.com "Blackwood convention"
[4]: https://bridge.com/en/learn/bridge-basics/rules/bridge-basics/?utm_source=chatgpt.com "🃏 Common Conventions: Standard Bidding Systems - Bridge.com"



Q: how about gambling behavior, like I would rather bid to a deal directly without telling opponent too much, as the chance of winning is higher than opponent know my hand then make the right defense/lead. 

A:
Yes. And this is actually a **very important extension**. What you're describing is not merely "information value"; it is **information value under an adversarial opponent**.

A convention can be good precisely because it **prevents the opponents from learning information**, even if it also gives your partner less information.

That changes the convention-discovery objective substantially.

## 1. The key idea: information has asymmetric value

Suppose you have two possible bids.

### Bid A — descriptive

```text
2♥ = "I have exactly 6 hearts and 8–10 HCP"
```

Partner gets a lot of information.

But the opponents get it too.

### Bid B — ambiguous

```text
2♥ = could represent several hand types
```

Partner knows less, but opponents also know less.

If the auction is competitive, Bid B might actually produce a higher expected score.

So the relevant quantity isn't simply:

[
\text{value of information to partner}.
]

It's:

[
\boxed{
\text{value of information to partner}
--------------------------------------

\text{value of information to opponents}
}
]

with the opponent's response explicitly included.

---

# 2. The evaluator must model the opponent's reaction

Suppose your action is (a).

Previously we might evaluate:

[
V(a)
====

E[\text{final score}\mid a].
]

Instead, we need:

[
V(a)
====

E[
\text{score after partner and opponents react optimally}
\mid a
].
]

More explicitly:

[
V(a)
====

E_w
\left[
U(
a,\pi_P(a,w),
\pi_O(a,w)
)
\right].
]

The opponent policy

[
\pi_O
]

is crucial.

If your bid reveals that you have a singleton diamond, the opponent may choose a diamond lead.

The *cost of revealing the singleton* is therefore not just informational—it appears as an actual loss in the subsequent play.

---

# 3. This means the AI can discover "gambling" naturally

Suppose two candidate conventions are:

### Convention A

```text
1NT
→ very precise description
→ opponents know exactly what you have
```

### Convention B

```text
1NT
→ deliberately ambiguous
→ partner has less information
→ opponents also have less information
```

The simulator evaluates complete auctions and play.

Suppose:

[
E[Score(A)] = +0.20
]

but:

[
E[Score(B)] = +0.35.
]

Then B wins.

The AI doesn't need a rule saying:

> "Sometimes conceal information."

It discovers it because **the downstream game result rewards concealment**.

---

# 4. Your "I'd rather bid directly" example is even more interesting

Suppose you have:

```text
North: strong hand
South: long major
```

There are two possible approaches.

### Information-rich approach

```text
1NT
2♦  transfer
2♥
...
```

This gives partner a structured picture.

But it also gives defenders information about the hand.

### Direct approach

```text
1NT
4♥
```

Now you've effectively said:

> "We're playing 4♥."

but you may have **not described the intermediate distribution**.

The opponents know less about:

* exact HCP;
* side-suit distribution;
* controls;
* whether you have a slam interest;
* which player has which feature.

If the direct route produces better results because the defense becomes harder, the optimizer can discover it.

---

# 5. This suggests an important quantity: information leakage

For an auction (A), define something like:

[
L_O(A)
======

I(H;A\mid I_O)
]

where:

* (H) = hidden hands;
* (A) = observed auction;
* (I_O) = information already available to opponents.

This measures how much the auction reveals about hidden information.

But we don't actually need to explicitly minimize (L_O).

We can let the opponent model learn from the auction and measure the **actual defensive damage**.

That is better.

---

# 6. Because information itself isn't inherently bad

For example:

> Telling partner you have a void may be extremely valuable.

The opponent learns it too.

But perhaps partner exploits that information much more effectively than the opponents do.

So:

[
\Delta V_{\text{partner}}

>

\Delta V_{\text{opponent}}
]

and disclosure is worthwhile.

Conversely, in another situation:

[
\Delta V_{\text{opponent}}

>

\Delta V_{\text{partner}},
]

so concealment wins.

This gives a beautiful criterion:

[
\boxed{
\text{Reveal information iff its net strategic value is positive}
}
]

---

# 7. This also changes how we should model a convention

Previously we had:

```text
SHOW
ASK
COMMAND
TRANSFER
RELAY
ENCODE
```

We should add:

```text
CONCEAL
AMBIGUATE
POOL
```

### CONCEAL

Don't communicate a feature that isn't necessary.

### AMBIGUATE

Make one bid represent multiple hand classes.

### POOL

Intentionally put strategically different hands into the same bidding class.

For example:

```text
2♥ =
    weak 6 hearts
    OR
    strong 6 hearts
```

provided the resulting protocol remains useful.

That can be a genuinely rational convention.

---

# 8. This gets particularly interesting with "gambling"

Imagine two hands:

[
H_1,\ H_2
]

that are very different.

Normally the convention separates them:

[
H_1\rightarrow2H
]

[
H_2\rightarrow2S.
]

But suppose the opponent's defense becomes much stronger if they know which one you have.

The optimizer can discover:

[
H_1,H_2\rightarrow2H
]

because **pooling** them prevents the opponent from distinguishing the states.

This is essentially **strategic signaling**.

---

# 9. There is a very nice analogy to poker

Poker strategy doesn't always maximize information for your own side.

You deliberately **mix strategies**.

For example, you might want the opponent to be unable to distinguish:

[
\text{strong hand}
]

from

[
\text{bluff}.
]

Bridge convention discovery could have a similar phenomenon.

The system might deliberately make:

[
P(H\mid bid)
]

broad rather than concentrated.

The purpose isn't randomness for its own sake.

It's:

[
\boxed{\text{preventing the opponent from exploiting the signal}}
]

---

# 10. And bridge has an unusual complication: partner also sees the signal

Your partner needs to understand the convention.

So there are three information channels:

```text
                Bid
                 │
       ┌─────────┼─────────┐
       ▼         ▼         ▼
    Partner   Opponent  Opponent
```

You want:

[
I(H;A\mid P)
]

to be useful,

while minimizing:

[
I(H;A\mid O).
]

But because the same bid is observed by everyone, this seems contradictory.

The trick is that **partner has different prior information**.

Partner knows:

* their own hand;
* previous bids;
* convention agreement;
* partnership context.

The opponent has different information.

Therefore the same bid can be much more informative to partner than to opponents.

---

# 11. This gives us a powerful convention-design objective

For a candidate convention (C):

[
\boxed{
F(C)=
E[\text{score}]
-\lambda Complexity(C)
}
]

where score is generated by the full game:

[
\text{bid}
\rightarrow
\text{opponent inference}
\rightarrow
\text{defense}
\rightarrow
\text{play}.
]

We don't need to separately say:

> maximize partner information.

The complete simulation automatically determines whether a particular communication strategy is useful.

---

# 12. But there is another fascinating possibility

The convention might deliberately choose **different levels of disclosure depending on the opponent**.

Suppose:

```text
Opponent A:
very good at inference
```

versus:

```text
Opponent B:
weak inference
```

Then the optimal convention could differ.

For opponent A:

[
\text{concealment} \uparrow
]

For opponent B:

[
\text{information exchange} \uparrow
]

This means the learned policy could potentially become:

[
\pi(a\mid H,Auction,\text{opponent model}).
]

That is much more sophisticated than a fixed SAYC-like system.

---

# 13. However, there's an important bridge-rule constraint

There is a boundary here.

Some forms of intentional ambiguity are perfectly legitimate strategy; but the convention still has to be **partnership-agreed and properly disclosed** under the applicable rules.

You cannot have:

> "Partner knows that 2♥ means either X or Y depending on a secret signal that opponents aren't told."

That's not merely a clever convention.

So the optimizer should operate on **publicly specified convention programs**.

The opponents can know the convention itself.

What they don't know is the private hand state.

That is actually a much more interesting problem:

[
\boxed{
\text{Can a publicly known protocol still strategically conceal private information?}
}
]

Absolutely yes.

---

# 14. This makes convention discovery a signaling game

We now have:

[
\boxed{
\text{private hand}
\rightarrow
\text{public signal}
\rightarrow
\text{partner inference}
\rightarrow
\text{opponent inference}
\rightarrow
\text{actions}
}
]

The convention is the **signaling protocol**.

The optimizer searches for a protocol that maximizes partnership payoff against an opponent.

That is a much more general framework than "learn bidding rules."

---

# 15. And this changes the answer to your earlier question about invention

Now the system could invent something genuinely surprising.

It might discover:

> "For this particular class of hands, telling partner exactly what I have is less valuable than keeping the opponents uncertain."

Then it could synthesize:

```text
IF situation X:

    do NOT reveal feature Y

    use bid B

    partner interprets B using
    their own hand + previous auction

    opponents are left with
    several plausible worlds
```

That is a **new convention based on deliberate information asymmetry**.

And the most interesting part is that the convention may look *worse* if you evaluate only the bidding stage.

It could be:

[
\text{less partner information}
]

but:

[
\text{much harder defense}
]

and therefore:

[
\boxed{\text{higher total score}}.
]

---

## So I'd add one more layer to our architecture

We started with:

[
\text{rule refinement}
]

then moved to:

[
\text{protocol synthesis}
]

and now I think the full system should be:

[
\boxed{
\text{Protocol synthesis}
+
\text{information economics}
+
\text{adversarial opponent modeling}
}
]

with candidate operations:

```text
SHOW(x)
ASK(x)
COMMAND(x)
TRANSFER(x)
RELAY(x)
ENCODE(x)

CONCEAL(x)
AMBIGUATE(x)
POOL(x)
```

and the only ultimate judge is:

[
\boxed{
E[\text{score after the entire auction and play}]
}
]

against a sufficiently strong opponent.

That would allow the system to discover not just **Jacoby/Stayman/Blackwood-like information protocols**, but potentially a convention whose central idea is something like:

> **"Don't tell them what we have; force them to defend against several plausible worlds."**

That is, in my view, a much more interesting target for automated convention invention than simply trying to rediscover existing human conventions.