# Todo — implementation status

All items from the original list are now implemented (2026-09-05). The
original analysis is preserved below each status line.

## ✅ 1. priority was dead code in DecisionNet — FIXED

`DecisionNet.actions()` now returns a **priority-ordered list**: per call,
the max matched rule priority wins; candidates sort by (-priority, call
string). Deterministic consumers can take `actions()[0]` (or the new
`DecisionNet.best_call()`), so `PRIORITY:` fields finally bite on the
DecisionNet path. The full candidate frontier is still returned — PIDM's
value search is unchanged, only arbitrary ordering is gone. Mirrored in the
browser engine (`web/bid_net.js`), asserted by `tests/web/engine_test.mjs`.

> Original: 🔴 1. priority is dead code in DecisionNet (critical correctness bug) DecisionNetRule.priority is stored and exported, but DecisionNet.actions() never reads it — all matched rules' calls go into a set, and tie-breaking among multiple candidates is arbitrary. Compare with BiddingSystem.get_bid (engine.py), which does sort by priority. So the same DSL behaves differently depending on which path evaluates it, and all your flywheel PRIORITY: 30/35 tuning is silently ignored on the DecisionNet path. Fix: return highest-priority matched call per call, or order candidates by priority.

## ✅ 2. Negative rules were exported twice — FIXED + DSL cleaned

The missing `continue` in `export_dsl()` is in; a save→load→save cycle is now
byte-stable (regression test in `tests/test_lint_dsl.py`). `DecisionNet.add_rule`
also skips exact duplicate bodies, so squared duplicates can never come back.
One-time cleanup applied: **improved_system.dsl went from 159 RULE blocks to
78** (81 squared duplicates removed; champion was already clean at 90). Lint
over the live systems: 0 issues.

> Original: 🔴 2. Negative rules are exported twice — this is why SLAM_EXPLORE_6S appears 5× and NO_D_WITH_MAJOR_HEA 24× In export_dsl() the if r.is_negative: block prints the rule, then the code falls through and prints the same rule again (missing continue). Each save→load→save cycle squares the duplicates. Your improved_system.dsl is currently 145 blocks where ~⅓ are floaters from this bug. Fix is one continue; then clean the DSL once.

## ✅ 3. Duplicate-rule linting — IMPLEMENTED

`src/bid/lint_dsl.py` (CLI: `python3 -m bid.lint_dsl <files>`) checks exact
duplicate bodies, rule-id reuse (informational warning), contradicted
conditions (`hcp >= 15` + `hcp <= 14`, `==` clashes), and priority shadowing
(same call, superset guard, not-higher priority). Enforced as tests in
`tests/test_lint_dsl.py` — the live systems must stay lint-clean.

> Original: 🔴 3. Duplicate-rule linting is absent BiddingSystem.add_rule dedupes common rules but DecisionNet dedupes nothing — you have 24 identical NO_D_WITH_MAJOR_HEA rules and 7 NEGATIVE blocks in the DSL. A 20-line lint_dsl.py (duplicate ID, contradicted conditions e.g. hcp >= 15 + hcp <= 14, unreachable priority shadowing) run as a test catches this whole class.

## ✅ 4. Pass inference in Engine.estimate_deal — IMPLEMENTED

A PASS now carves declined lower-bound system rules out of the seat's
constraint estimate: for every triggered, bridge-legal non-pass call the
player declined whose constraints have exactly one binding `X+` lower bound,
the matching upper bound is capped (`cap_above` in constraints.py, e.g.
passing over "1C: HCP 16+" bounds the hand at hcp <= 15). Multi-field rules
are skipped (negating a conjunction is ambiguous). Tested in
`tests/test_pass_inference.py`.

> Original: 🟡 4. Engine.estimate_deal is intentionally weak on passes "PASS implies no rule matched" → currently pass ("do nothing if no explicit rule matches"), so your belief inference gives zero information from partner passing. Even a crude "constraints = complement of opening rules" would materially improve RBMBMC world filtering — and the player model's job gets easier.

## ✅ 5. Opponent-aggression features — ALREADY LANDED (item was stale)

The todo's grep predated the feature work: `features.py` now has
`opp_bid_count`, `opp_first_bid_level`, `opp_preempted`, `opp_strength_class`,
`competition_level`, `auction_altitude`, `opp_fit_shown`, `our_fit_shown`,
`vuln_pressure`, `opp_suit_stoppers` — all numeric/stratified and documented
in the README. They propagate into traces and the flywheel's AGGRESSION
patch family.

> Original: 🟡 5. Still missing from the last conversation, now confirmed against actually-landed code: No opponent-aggression features (nothing matching opp_*count*, competitive_*, preempt* in features.py — only opponents_bid, is_competitive booleans). Validation: grep -c "opp_" features.py = a handful of strings, none numeric. Rules can't yet count how much the opponents bid.

## Order-of-work note (from the original list)

> (1) priority dead-code fix — correctness; (2) export-dsl double-write — one continue; (3) lint + cleans the DSL down to a sane size; then the design-level stuff (opponent-aggression features, PASS inference). The first three are bugs; fixing them will change evaluation numbers, so do them before any retraining or DSL cleanup of conventions.

Followed in that order. Evaluation numbers DID change: the cleaned 78-rule
system is what future flywheel rounds, trace regeneration, and student
refreshes build on (snapshot hash `c2a60a063f27…`).
