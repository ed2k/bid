# ==========================================
# IMPROVED BIDDING SYSTEM: System_S
# Generated via Continuous Self-Improvement Pipeline
# ==========================================

# --- Active Rules & Conventions ---

RULE R_1NT:
  CALL: 1NT
  PRIORITY: 20
  CONDITION: hcp >= 15
  CONDITION: hcp <= 17
  CONDITION: is_balanced == True
  # 1NT Opening: 15-17 HCP balanced

RULE R_1H:
  CALL: 1H
  PRIORITY: 20
  CONDITION: hcp >= 12
  CONDITION: hcp <= 21
  CONDITION: heart_len >= 5
  # 1H Opening: 12-21 HCP, 5+ hearts

RULE R_1S:
  CALL: 1S
  PRIORITY: 20
  CONDITION: hcp >= 12
  CONDITION: hcp <= 21
  CONDITION: spade_len >= 5
  # 1S Opening: 12-21 HCP, 5+ spades

RULE R_1D:
  CALL: 1D
  PRIORITY: 15
  CONDITION: hcp >= 12
  CONDITION: hcp <= 21
  CONDITION: diamond_len >= 4
  # 1D Opening: 12-21 HCP, 4+ diamonds

RULE R_1C_unbalanced:
  CALL: 1C
  PRIORITY: 10
  CONDITION: hcp >= 12
  CONDITION: hcp <= 21
  CONDITION: club_len >= 3
  CONDITION: is_balanced == False
  # 1C Opening: 12-21 HCP, 3+ clubs unbalanced

RULE R_1C_balanced:
  CALL: 1C
  PRIORITY: 10
  CONDITION: hcp >= 12
  CONDITION: hcp <= 14
  CONDITION: club_len >= 3
  CONDITION: is_balanced == True
  # 1C Opening: 12-14 HCP balanced

RULE R_4H:
  CALL: 4H
  PRIORITY: 25
  CONDITION: heart_len >= 6
  CONDITION: hcp >= 13
  # 4H Game bid

RULE R_4S:
  CALL: 4S
  PRIORITY: 25
  CONDITION: spade_len >= 6
  CONDITION: hcp >= 13
  # 4S Game bid

RULE R_RESP_2H:
  CALL: 2H
  PRIORITY: 18
  CONDITION: heart_len >= 3
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE R_RESP_2S:
  CALL: 2S
  PRIORITY: 18
  CONDITION: spade_len >= 3
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE R_RESP_4H:
  CALL: 4H
  PRIORITY: 24
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 12

RULE R_RESP_3NT:
  CALL: 3NT
  PRIORITY: 22
  CONDITION: is_balanced == True
  CONDITION: hcp >= 10
  CONDITION: hcp <= 15

RULE R_REBID_4H:
  CALL: 4H
  PRIORITY: 26
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 16

RULE Stayman_Response_(4, 13)_2H:
  CALL: 2H
  PRIORITY: 30
  CONDITION: heart_len >= 4
  CONDITION: heart_len <= 13
  # ENCODE heart_len=(4, 13) -> 2H

RULE Stayman_Response_(0, 3)_2D:
  CALL: 2D
  PRIORITY: 30
  CONDITION: heart_len >= 0
  CONDITION: heart_len <= 3
  # ENCODE heart_len=(0, 3) -> 2D

RULE Jacoby_Transfer_Hearts_True_2H:
  CALL: 2H
  PRIORITY: 30
  CONDITION: is_balanced == True
  # TRANSFER is_balanced=True -> 2H

RULE Jacoby_Transfer_Hearts_False_2H:
  CALL: 2H
  PRIORITY: 30
  CONDITION: is_balanced == False
  # TRANSFER is_balanced=False -> 2H

RULE R_OPEN_2C_STRONG:
  CALL: 2C
  PRIORITY: 29
  CONDITION: hcp >= 22

RULE R_RESP_2D_WAITING:
  CALL: 2D
  PRIORITY: 28
  CONDITION: hcp <= 7


# --- Refined ID3 Exception Trees (Speedup Learning Splits) ---

INTERSECTION R_1C_unbalanced ^ R_1D:
  RESOLVED_CALL: 1D

INTERSECTION R_1C_unbalanced ^ R_1S:
  RESOLVED_CALL: 1S

INTERSECTION R_1D ^ R_1H ^ R_RESP_4H:
  RESOLVED_CALL: 1D

INTERSECTION R_RESP_2H ^ R_RESP_2S:
  RESOLVED_CALL: 2H

INTERSECTION R_1C_balanced ^ R_RESP_4H:
  RESOLVED_CALL: 4H

INTERSECTION R_1D ^ R_RESP_4H:
  RESOLVED_CALL: 1D

INTERSECTION R_1D ^ R_1S:
  RESOLVED_CALL: 1D

INTERSECTION R_1C_balanced ^ R_RESP_3NT:
  RESOLVED_CALL: 3NT

INTERSECTION R_1C_unbalanced ^ R_RESP_4H:
  RESOLVED_CALL: 4H

INTERSECTION R_1H ^ R_1NT ^ R_REBID_4H ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 1H

INTERSECTION R_RESP_2S ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION R_RESP_3NT ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 3NT

INTERSECTION R_1S ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 1S

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_1NT ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_RESP_2H ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_1S ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 1S

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_4S ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D
