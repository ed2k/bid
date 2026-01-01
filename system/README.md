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
