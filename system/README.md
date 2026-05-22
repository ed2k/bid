# Bid System Definitions

This directory contains the definitions for bidding systems used by the engine.

## File Types

- **`*.txt` (Source Truth)**: Human-readable documentation of the bidding system (e.g., `BlueClub.txt`). These contain the official rules, logic, and reasoning used by players.
- **`*.dsl` (System Logic)**: The machine-readable Domain Specific Language files (e.g., `blue_club.dsl`) parsed by `bid/translator.py`. These drive the bidding engine.

## Process: Translating TXT to DSL

The process of converting the text descriptions into executable DSL rules is currently a **manual/LLM translation workflow**. 

### 1. Identify the Trigger
Find a specific bidding sequence in the `.txt` file.

*Example (Text):*
> "Opener rebid of 1NT shows 18-20 HCP and a balanced hand."

### 2. Map to DSL Syntax
Create a rule block in the `.dsl` file. The header defines the triggering sequence or simplified trigger.

**Syntax:**
```dsl
PREVIOUS_BIDS - CALL:
  CONSTRAINT: VALUE
  ...
```

### 3. Define Constraints
Map the textual requirements to DSL constraints:
- **HCP**: High Card Points (e.g., `18-20`, `12+`).
- **SHAPE**: `BALANCED`, `UNBALANCED`, `SEMIBALANCED`.
- **LEN <SUIT>**: Suit length (e.g., `5+`, `4-5`).
- **CONTROLS**: Blue Club Controls (e.g., `3`, `4+`).
- **ACES**: Specific Ace count (e.g., `2`).
- **ACE_TOPOLOGY**: `RANK`, `COLOR`, `MIXED`.

### Example Translation

**Source (`BlueClub.txt`)**:
> REBID BY OPENER AFTER 1C - 1S RESPONSE:
> 2H: Shows 17+ HCP and at least 5 Hearts.

**Target (`blue_club.dsl`)**:
```dsl
# 1C - 1S - 2H: Natural 5+ Hearts (17+)
1C - 1S - 2H:
  HCP: 17+
  LEN H: 5+
```

## Defensive Bidding Notation
For overcalls (defensive bidding), use parentheses `()` to denote opponent bids in the trigger.

**Example**:
- Text: "Overcall 1D over opponent's 1C"
- DSL:
  ```dsl
  (1C) - 1D:
    HCP: 8-16
    LEN D: 5+
  ```

## Plan: Introduce Multiple Cuebid Types in Bidding Conversion

Goal: support different cuebid meanings (for example Michaels, stopper ask, control cuebids, and cue-raises) in a way that survives conversion from text notes to DSL and can be interpreted consistently by the engine.

### Phase 1: Define a Cuebid Taxonomy

Add a small, explicit set of cuebid categories to use in `.txt` annotations and `.dsl` rules.

- `Michaels`: direct cuebid over opponent suit showing two-suiters.
- `WesternCue`: cuebid asking stopper for notrump.
- `ControlCue`: first/second-round control in slam auctions.
- `CueRaise`: cuebid showing support plus values after interference.
- `NaturalCue`: cuebid used as natural/fit-showing by partnership agreement.

Keep this list short initially and extend only when at least one system file needs the new type.

### Phase 2: Extend DSL Surface (Backward Compatible)

Introduce optional metadata keys. Existing rules continue to work unchanged.

Suggested keys:

- `BID_CLASS: CUEBID`
- `CUEBID_TYPE: Michaels|WesternCue|ControlCue|CueRaise|NaturalCue`
- `CUE_TARGET: OPP_SUIT|AGREED_SUIT|LAST_BID_SUIT`
- `FORCING: NONE|ONE_ROUND|GAME_FORCE`
- `CONVENTION: <free text>`
- `PRIORITY_BONUS: <int>`

Example (Michaels over 1D):

```dsl
(1D) - 2D:
  BID_CLASS: CUEBID
  CUEBID_TYPE: Michaels
  CUE_TARGET: OPP_SUIT
  FORCING: ONE_ROUND
  HCP: 10+
  LEN H: 5+
  LEN S: 5+
```

Example (control cuebid in slam):

```dsl
1S - 3S - 4C:
  BID_CLASS: CUEBID
  CUEBID_TYPE: ControlCue
  CUE_TARGET: AGREED_SUIT
  FORCING: GAME_FORCE
  CONTROLS: 1+
```

### Phase 3: Converter Updates (TXT -> DSL)

Update the manual/LLM conversion checklist to classify cuebids before writing constraints.

Conversion steps for any cuebid sentence:

1. Detect that the bid is a cuebid (same strain as opponent/opening suit, or explicit "cue" language).
2. Assign one `CUEBID_TYPE` from taxonomy.
3. Identify target semantics (`OPP_SUIT`, `AGREED_SUIT`, or `LAST_BID_SUIT`).
4. Translate meaning to hand constraints (`HCP`, suit lengths, `CONTROLS`, shape).
5. Add `FORCING` level when text implies non-passable or game force.
6. Keep fallback natural constraints if text is ambiguous, and annotate with `CONVENTION`.

### Phase 4: Translator Parsing Updates

In `bid/translator.py`, parse new optional keys and store them in the rule object metadata.

Recommended implementation:

- Add `meta: Dict[str, str|int|set]` to each rule payload during parsing.
- Parse and normalize:
  - `BID_CLASS`
  - `CUEBID_TYPE`
  - `CUE_TARGET`
  - `FORCING`
  - `CONVENTION`
  - `PRIORITY_BONUS`
- Keep trigger logic unchanged for first pass; cuebid behavior remains sequence-driven.
- Apply `PRIORITY_BONUS` to existing computed priority to resolve cue-vs-natural collisions.

### Phase 5: Rule Selection and Estimation Behavior

Enhance matching and deal estimation to use cuebid metadata where useful.

- If two rules match same sequence/call, prefer:
  1. Higher `priority`
  2. `BID_CLASS: CUEBID` when history indicates convention context
  3. Narrower constraints (smaller HCP/shape ranges)
- In estimation output, preserve cuebid tag so downstream explanation can say "Michaels" vs generic overcall.

### Phase 6: Rollout Per System File

Adopt progressively across system definitions:

1. `precision.dsl`: already contains direct cuebid patterns; tag these first.
2. `blue_club.dsl`: add control cuebid tags for slam sequences.
3. `gib.dsl` and others: only tag where text explicitly defines cuebid meanings.

Avoid mass rewrites. Convert a small batch, run tests, then continue.

### Phase 7: Validation and Tests

Add targeted tests per cuebid family.

- Parser tests: new keys parsed without breaking old DSL.
- Trigger tests: cuebid triggers still match intended history with/without interference.
- Priority tests: cuebid and non-cuebid competing rules choose expected call.
- Estimation tests: constraints + cuebid classification are retained.

Suggested new test modules:

- `tests/test_cuebid_parsing.py`
- `tests/test_cuebid_priority.py`
- `tests/test_cuebid_sequences.py`

### Practical Migration Rules

- Never change existing bid meaning unless source `.txt` explicitly supports it.
- If a source is ambiguous, mark `CONVENTION: UNKNOWN_CUE_CONTEXT` and keep conservative constraints.
- Prefer additive metadata over trigger rewrites to reduce regression risk.
- Keep all new cuebid fields optional so old `.dsl` files continue to parse.

## Architecture Decision: Shared Cuebid Library

Short answer: yes, use a common file for reusable cuebids.

Recommended shape:

- Keep all cuebid assets under a dedicated directory: `system/cuebids/`.
- Store reusable shared convention rules in `system/cuebids/common.dsl`.
- Store cuebid raw/source notes in `system/cuebids/raw/`.
- Keep system-specific tuning inside each system file (`precision.dsl`, `blue_club.dsl`, etc.).
- Prefer "shared defaults + local override" instead of duplicating convention rules.

Because the current translator parses one text blob and has no include syntax, use one of these integration patterns:

1. Pre-merge at load time (preferred):
  - Read `cuebids/common.dsl`.
  - Read target system file.
  - Concatenate in deterministic order before `SystemTranslator.parse(...)`.
2. Build-time generation:
  - Generate per-system composed files (for example `precision.composed.dsl`) from common + local.
  - Parse only composed file in runtime/tests.

Ordering rule (important for priority collisions):

- Put common rules first.
- Put system-specific rules second.
- Let local rules carry higher `PRIORITY_BONUS` when they intentionally override shared behavior.

What belongs in the common file:

- Stable conventions with near-identical meaning across systems (for example standard Michaels skeletons, generic control-cue metadata schema).

What should stay local:

- Partnership-specific ranges, forcing levels, or suit-quality promises.
- Any convention whose meaning changes materially by system.

Minimal migration path:

1. Move only one family first (for example Michaels over 1-level openings).
2. Compose common + `precision.dsl` and run tests.
3. Compose common + `blue_club.dsl` and run tests.
4. Move additional families only after parity is confirmed.
