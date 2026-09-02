# Repository Roadmap & Pending Improvements

## 1. Performance & Engine Optimizations
- [x] **Hand Bitmask Acceleration & Feature Caching (`models.py`, `features.py`)**:
  - Implemented 13-bit integer bitmasks per suit on `Hand` for $O(1)$ HCP, honor counts, stoppers, and distribution checks.
  - Cached static hand features on `Hand` instances to eliminate redundant feature extraction across Monte Carlo rollouts.
- [x] **Batched Neural Inference (`cot_model.py`, `cot_bidder.py`, `mine_disagreements.py`)**:
  - Implemented `generate_batch` in `cot_model.py` with CPU buffer construction, right-padding, and vectorized multi-sequence sampling.
  - Added `StudentPolicy.bid_batch` in `mine_disagreements.py` and `NeuralCotReasoner` in `cot_bidder.py`.
  - Accelerated `eval-val` validation pipeline with `--batch-size` parameter.

## 2. Research & Modeling
- [x] **Integrate Competitive VOI into Convention Search (`convention_search.py`)**:
  - Wired `evaluate_competitive_voi` into the hill-climbing search loop with `--use-voi`, `--leakage-penalty`, `--preemption-bonus`, and `--voi-weight`.
  - Added sample partial state generator and integrated VOI metrics (`net_voi`, `leakage`, `disruption`) into mutant ranking and `search_report.json`.

## 3. Continuous Improvement Pipeline
- [x] **Active Learning & Student Refresh Cycle**:
  - Fixed auction progression bug in `mine_disagreements.py` where confidence filtering previously skipped history advancement.
  - Successfully ran `mine_disagreements.py` with active learning filtering (`--temp 0.2 --min-confidence 0.6`) to mine high-uncertainty oracle disagreements.
  - Ran `refresh_student.py` to merge active learning traces, retrain candidate student on Apple MPS, and execute gated `eval-val` validation against the incumbent.
- [x] **Flywheel Staged Autonomous Loop**:
  - Fixed candidate escalation tier comparison in `autoloop.py` so escalated candidates evaluate against matching-tier base scores rather than being truncated against tier 0 base scores.
  - Added `--min-final-boards` flag to allow custom final champion challenge board counts.
  - Added `args.pool_cap` slice enforcement to `PoolBuilder` candidate lists.
  - Successfully ran `autoloop.py` with multi-tier screening, SDS two-hand realism gate, automatic champion challenge, history archiving, and progress reporting.


