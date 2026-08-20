# Bid: Autonomous Self-Improving Contract Bridge Bidding Engine

**Bid** is a contract bridge AI and research platform designed to **continuously discover, refine, and invent bidding conventions**. 

Rather than relying on static, brittle rule tables or black-box policies, `bid` implements a closed-loop **continuous improvement pipeline**: it starts from baseline bidding rules, actively hunts for ambiguous or unhandled states, uses high-budget model-conditioned Monte Carlo search (RBMBMC + PIDM) as a teacher, distills those insights into localized decision-net refinements (ID3), co-trains the partnership in parallel, and synthesizes new communication protocols using Value of Information (VOI) and adversarial signaling theory.

---

## 🔄 The Continuous Improvement Pipeline

The core goal of `bid` is to run an autonomous flywheel that iteratively improves both bidding policy and belief-state inference:

```
                            ┌─────────────────────────────────┐
                            │    1. Active State Discovery    │
                            │  • Rule Ambiguities (|φ(s)| > 1)│
                            │  • Rare/Stratified Distributions│
                            │  • Policy-Search Disagreements  │
                            └────────────────┬────────────────┘
                                             │
                                             ▼
┌──────────────────────────────┐   ┌─────────────────────────────────┐
│  3. Speedup Rule Refinement  │   │   2. Expensive PIDM Teacher     │
│  • ID3 Information Gain      │◄──┤ • RBMBMC World Sampling         │
│  • Local Intersection Nodes  │   │ • Nested Opponent/Partner Sims  │
│  • Fast O(1) Policy Execution│   │ • Duplicate Bridge / DD Scoring │
└──────────────┬───────────────┘   └─────────────────────────────────┘
               │
               ▼
┌──────────────────────────────┐   ┌─────────────────────────────────┐
│   4. Partner Co-Training     │   │   5. Convention Invention & VOI │
│ • Parallel Model Exchange    │──►│ • Protocol State Machines       │
│ • Tighter Belief Filtering   │   │ • Value of Information (VOI)    │
│ • Speed & Accuracy Feedback  │   │ • Adversarial Signal Concealment│
└──────────────────────────────┘   └─────────────────────────────────┘
```

---

## 🌟 How the Pipeline Works

### 1. Active State Discovery & Stratified Generation
Standard random dealing rarely encounters critical rare shapes (e.g. 9-card suits, 22+ HCP, extreme singletons). The pipeline actively finds states worth learning:
- **`StratifiedDealGenerator`**: Deliberately samples underrepresented hand strata (suit length, HCP bands, freak distributions).
- **`ExperienceBuffer`**: Prioritizes states where rules disagree, policy confidence is low, or high-value utility gaps exist.
- **`ExploratoryCandidateGenerator`**: Expands candidate actions beyond expert rules with adaptive exploration ($\epsilon$).

### 2. Model-Conditioned Teacher: RBMBMC + PIDM
When a decision is uncertain ($|\phi(s)| > 1$), the engine launches a high-budget search:
- **Resource-Bounded Model-Based Monte Carlo (RBMBMC)**: Replays the auction backwards, filtering out worlds that are inconsistent with historical calls according to player behavioral models.
- **Partial Information Decision Making (PIDM)**: Recursively simulates partner and opponent reactions in each sampled world, evaluating outcomes with double-dummy trick estimation and duplicate bridge scoring.

### 3. Local Speedup Learning & Exception Refinement
The expensive search acts as a teacher to refine the fast rule net:
- **`ID3DecisionTree`**: Calculates Shannon Information Gain across 250+ bridge features (HCP, suit lengths, controls, LTC, honor topology) to find the exact feature that separates competing actions.
- **Intersection Nodes**: The learned classifier is attached *locally* to the intersection of the conflicting rules (e.g., $R_{\text{1NT}} \cap R_{\text{1H}}$ for 16 HCP 5-heart balanced hands). The general rules outside the conflict remain intact.

### 4. Partner Co-Training Loop
North and South learn in parallel and periodically exchange their refined decision nets:
- When South learns a more precise rule, South's refined model constrains North's RBMBMC world sampling.
- Fewer inconsistent worlds mean North's search becomes both **faster** and **more accurate**, creating a compounding feedback loop.

### 5. Convention Invention & Information Protocols
The system treats bridge conventions as **imperative communication programs**:
- **Semantic Primitives**: Synthesizes sequences using `SHOW`, `ASK`, `COMMAND`, `TRANSFER`, `ENCODE`, `CONCEAL`, `AMBIGUATE`, and `POOL`.
- **Value of Information (VOI)**: Evaluates whether a question (like Stayman major query or Blackwood ace ask) provides positive expected payoff:
  $$\text{VOI}(Q) = \mathbb{E}[\max_a V(a \mid Q)] - \max_a \mathbb{E}[V(a)]$$
- **Adversarial Signaling**: Measures net information payoff against defenders $(\Delta V_{\text{partner}} - \Delta V_{\text{opponent}})$, allowing the system to discover strategic pooling, concealment, and gambling bids.

---

## 🚀 Quick Start

### Installation

No external dependencies are required beyond Python 3.8+.

```bash
git clone https://github.com/ed2k/bid.git
cd bid
```

### Running the Continuous Improvement Pipeline

Run the multi-iteration self-improving pipeline directly from CLI:

```bash
PYTHONPATH=.. python3 main.py --iterations 3 --states 8 --deals 20
```

Options:
- `--iterations`: Number of continuous improvement cycles (default: 3).
- `--states`: Number of ambiguous/rare states to sample & refine per cycle (default: 8).
- `--deals`: Number of benchmark deals for evaluation (default: 20).

---

## 🧪 Pipeline Usage Examples

### 1. Running the Continuous Co-Training Loop

```python
from bid.invention import BidInventionEngine

# Initialize engine with RBMBMC sampler and PIDM lookahead
engine = BidInventionEngine(sample_size=3, max_lookahead_depth=2)

# Run iterative parallel co-training rounds between North and South
results = engine.run_co_training(rounds=3, states_per_round=10)

for round_info in results["rounds"]:
    print(f"Round {round_info['round']}: "
          f"North refined {round_info['north_refinements']} conflict nodes, "
          f"South refined {round_info['south_refinements']} conflict nodes.")
```

### 2. Active Ambiguity Discovery and ID3 Refinement

```python
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.learner import DecisionNetLearner, ID3DecisionTree
from bid.pidm import PIDMEngine
from bid.models import Call, CallType, Strain, Hand

# 1. Base Decision Net with overlapping rules (1NT vs 1H on 15-17 HCP 5-heart balanced)
net = DecisionNet("PartnerNet")
net.add_rule(DecisionNetRule("R_1NT", Call(CallType.BID, 1, Strain.NT), [
    RuleCondition("hcp", ">=", 15), RuleCondition("hcp", "<=", 17), RuleCondition("is_balanced", "==", True)
]))
net.add_rule(DecisionNetRule("R_1H", Call(CallType.BID, 1, Strain.HEARTS), [
    RuleCondition("hcp", ">=", 12), RuleCondition("hcp", "<=", 21), RuleCondition("heart_len", ">=", 5)
]))

# 2. Learner finds ambiguous states where |φ(s)| > 1 and tags with expensive PIDM teacher
teacher = PIDMEngine()
learner = DecisionNetLearner(teacher)
models = {s: net for s in Seat}

ambiguous_states = learner.find_ambiguous_states(net, target_count=15)
tagged_data = learner.tag_states(ambiguous_states, models)

# 3. ID3 builds local decision tree and attaches directly to intersection node
learner.refine_decision_net(net, tagged_data)

# Now ambiguous hands evaluate in O(1) time without search!
hand = Hand.from_string("SAK4 H76543 DAQ3 CK2")
resolved_call = net.actions(hand, history=[])
print(f"Resolved call: {resolved_call}")
```

### 3. Stratified Rare-Hand Sampling & Experience Buffer

```python
from bid.experience import StratifiedDealGenerator, ExperienceBuffer, PrioritizedExperience
from bid.models import Suit, Seat, Call, CallType, Strain
from bid.sampling import PartialState

# Generate a rare 9-card spade hand directly to avoid Monte Carlo blindspots
rare_hand = StratifiedDealGenerator.generate_hand_with_suit_length(Suit.SPADES, min_length=9)

buffer = ExperienceBuffer(max_capacity=500)
ps = PartialState(Seat.SOUTH, rare_hand, [])

# Calculate priority based on rarity and search disagreement
priority, reason = buffer.calculate_priority(
    rare_hand,
    policy_actions={Call(CallType.BID, 1, Strain.SPADES)},
    teacher_call=Call(CallType.BID, 4, Strain.SPADES),
    value_gap=120.0
)

buffer.add(PrioritizedExperience(ps, {Call(CallType.BID, 1, Strain.SPADES)}, Call(CallType.BID, 4, Strain.SPADES), priority, reason))
print(f"Added state to replay buffer (priority={priority}, reason={reason})")
```

### 4. Synthesizing Conventions & Measuring Value of Information (VOI)

```python
from bid.protocol import ConventionProtocol, ValueOfInformationEvaluator
from bid.pidm import PIDMEngine

# Compile a synthesized Stayman protocol (2C ask -> 2D/2H/2S step responses)
stayman = ConventionProtocol.create_stayman()
rules = stayman.compile_to_rules()

# Evaluate Value of Information (VOI) over sample states
engine = PIDMEngine()
voi_eval = ValueOfInformationEvaluator(engine)
voi_score = voi_eval.evaluate_voi(stayman.steps[0], sample_states, models)
print(f"Stayman query VOI: +{voi_score:.2f} IMP-equivalent")
```

---

## 🧪 Running Tests

Run the complete test suite:

```bash
PYTHONPATH=.. python3 -m unittest discover -s tests
```

Individual test suites:
```bash
PYTHONPATH=.. python3 -m unittest tests/test_features_and_state.py
PYTHONPATH=.. python3 -m unittest tests/test_scoring.py
PYTHONPATH=.. python3 -m unittest tests/test_rbmbmc_sampling.py
PYTHONPATH=.. python3 -m unittest tests/test_pidm_lookahead.py
PYTHONPATH=.. python3 -m unittest tests/test_id3_refinement.py
PYTHONPATH=.. python3 -m unittest tests/test_cotraining.py
PYTHONPATH=.. python3 -m unittest tests/test_experience_and_stratified.py
PYTHONPATH=.. python3 -m unittest tests/test_protocol_synthesis_and_voi.py
PYTHONPATH=.. python3 -m unittest tests/test_bid_invention_e2e.py
```

---

## 📂 Project Structure

```
bid/
├── __init__.py
├── models.py            # Core domain models: Hand, Card, Call, Seat, Strain, Rank
├── features.py          # BridgeFeatures extractor (250+ numerical & auction features)
├── scoring.py           # Contract scoring, 24-band IMP scale, Double Dummy trick estimator
├── decision_net.py      # DecisionNet, RuleCondition, IntersectionNode, legality filtering
├── sampling.py          # Deal, PartialState, RBMBMCSampler, backwards inconsistency scoring
├── pidm.py              # PIDMEngine with Monte Carlo lookahead & nested player simulation
├── learner.py           # ID3DecisionTree, DecisionNetLearner, intersection refinement
├── cotrain.py           # CoTrainer for parallel partner learning & model exchange
├── experience.py        # StratifiedDealGenerator, ExperienceBuffer, exploration generator
├── protocol.py          # ConventionProtocol (Stayman, Jacoby, Blackwood), VOI & signaling
├── invention.py         # BidInventionEngine facade
├── engine.py            # Traditional rule-matching engine
├── system.py            # BiddingSystem rule engine & convention manager
├── translator.py        # DSL rule parser & compiler
├── lin.py               # BBO LIN file parser
├── constraints.py       # HandConstraints representation
├── system/              # Bidding system definitions & DSL files (BlueClub, Precision, GIB, SAYC)
├── research/            # Research document (bid-invention.md)
└── tests/               # Unit and integration test suite (83 tests)
```

---

## 📚 References & Background

- **Amit & Markovitch (2006)**: *"Learning to Bid in Bridge"*, Machine Learning 63(3), 287–327.
- **[research/bid-invention.md](file:///Users/admin/Documents/GitHub/bid/research/bid-invention.md)**: In-depth analysis of BIDI reconstruction, RBMBMC vs PIMC, speedup learning, active/stratified state discovery, and convention protocol synthesis.
