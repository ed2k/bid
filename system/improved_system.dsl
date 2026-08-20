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

RULE R_WEAK_2H:
  CALL: 2H
  PRIORITY: 19
  CONDITION: heart_len == 6
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10
  CONDITION: is_balanced == False

RULE R_WEAK_2S:
  CALL: 2S
  PRIORITY: 19
  CONDITION: spade_len == 6
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10
  CONDITION: is_balanced == False

RULE R_SLAM_6H:
  CALL: 6H
  PRIORITY: 28
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 19

RULE R_SLAM_6S:
  CALL: 6S
  PRIORITY: 28
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 19

RULE R_2OVER1_2C:
  CALL: 2C
  PRIORITY: 23
  CONDITION: club_len >= 4
  CONDITION: hcp >= 13

RULE R_2OVER1_2D:
  CALL: 2D
  PRIORITY: 23
  CONDITION: diamond_len >= 4
  CONDITION: hcp >= 13

RULE R_TAKEOUT_DBL:
  CALL: X
  PRIORITY: 21
  CONDITION: hcp >= 12
  CONDITION: heart_len >= 3
  CONDITION: spade_len >= 3

RULE Gambling_3NT_(7, 13)_3NT:
  CALL: 3NT
  PRIORITY: 30
  CONDITION: longest_suit_len >= 7
  CONDITION: longest_suit_len <= 13
  # POOL longest_suit_len=(7, 13) -> 3NT

RULE R_JACOBY_2NT:
  CALL: 2NT
  PRIORITY: 24
  CONDITION: hcp >= 13
  CONDITION: heart_len >= 4

RULE R_SPLINTER_4D:
  CALL: 4D
  PRIORITY: 27
  CONDITION: diamond_len <= 1
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 11

RULE Blackwood_Ace_Encoding_0_5C:
  CALL: 5C
  PRIORITY: 30
  CONDITION: ace_count == 0
  # ENCODE ace_count=0 -> 5C

RULE Blackwood_Ace_Encoding_1_5D:
  CALL: 5D
  PRIORITY: 30
  CONDITION: ace_count == 1
  # ENCODE ace_count=1 -> 5D

RULE Blackwood_Ace_Encoding_2_5H:
  CALL: 5H
  PRIORITY: 30
  CONDITION: ace_count == 2
  # ENCODE ace_count=2 -> 5H

RULE Blackwood_Ace_Encoding_3_5S:
  CALL: 5S
  PRIORITY: 30
  CONDITION: ace_count == 3
  # ENCODE ace_count=3 -> 5S

RULE Blackwood_Ace_Encoding_4_5C:
  CALL: 5C
  PRIORITY: 30
  CONDITION: ace_count == 4
  # ENCODE ace_count=4 -> 5C

RULE R_FOURTH_SUIT_GF:
  CALL: 3C
  PRIORITY: 25
  CONDITION: hcp >= 11
  CONDITION: is_balanced == False

RULE Texas_Transfer_4D_True_4H:
  CALL: 4H
  PRIORITY: 30
  CONDITION: is_balanced == True
  # TRANSFER is_balanced=True -> 4H

RULE Texas_Transfer_4D_False_4H:
  CALL: 4H
  PRIORITY: 30
  CONDITION: is_balanced == False
  # TRANSFER is_balanced=False -> 4H

RULE Reverse_Drury_Rebid_(12, 14)_2H:
  CALL: 2H
  PRIORITY: 30
  CONDITION: hcp >= 12
  CONDITION: hcp <= 14
  # ENCODE hcp=(12, 14) -> 2H

RULE Reverse_Drury_Rebid_(15, 21)_4H:
  CALL: 4H
  PRIORITY: 30
  CONDITION: hcp >= 15
  CONDITION: hcp <= 21
  # ENCODE hcp=(15, 21) -> 4H

RULE Michaels_Response_(3, 13)_2H:
  CALL: 2H
  PRIORITY: 30
  CONDITION: heart_len >= 3
  CONDITION: heart_len <= 13
  # COMMAND heart_len=(3, 13) -> 2H

RULE Michaels_Response_(0, 2)_2S:
  CALL: 2S
  PRIORITY: 30
  CONDITION: heart_len >= 0
  CONDITION: heart_len <= 2
  # COMMAND heart_len=(0, 2) -> 2S

RULE Unusual_2NT_Response_(3, 13)_3D:
  CALL: 3D
  PRIORITY: 30
  CONDITION: diamond_len >= 3
  CONDITION: diamond_len <= 13
  # COMMAND diamond_len=(3, 13) -> 3D

RULE Unusual_2NT_Response_(0, 2)_3C:
  CALL: 3C
  PRIORITY: 30
  CONDITION: diamond_len >= 0
  CONDITION: diamond_len <= 2
  # COMMAND diamond_len=(0, 2) -> 3C

RULE Cappelletti_2D_Response_(3, 13)_2H:
  CALL: 2H
  PRIORITY: 30
  CONDITION: heart_len >= 3
  CONDITION: heart_len <= 13
  # COMMAND heart_len=(3, 13) -> 2H

RULE Cappelletti_2D_Response_(0, 2)_2S:
  CALL: 2S
  PRIORITY: 30
  CONDITION: heart_len >= 0
  CONDITION: heart_len <= 2
  # COMMAND heart_len=(0, 2) -> 2S

RULE Smolen_Transfer_True_4H:
  CALL: 4H
  PRIORITY: 30
  CONDITION: is_balanced == True
  # TRANSFER is_balanced=True -> 4H

RULE Smolen_Transfer_False_4H:
  CALL: 4H
  PRIORITY: 30
  CONDITION: is_balanced == False
  # TRANSFER is_balanced=False -> 4H


# --- Refined ID3 Exception Trees (Speedup Learning Splits) ---

INTERSECTION R_1C_unbalanced ^ R_1S:
  RESOLVED_CALL: 1C

INTERSECTION R_1C_balanced ^ R_1D:
  RESOLVED_CALL: 1C

INTERSECTION R_1C_unbalanced ^ R_1D ^ R_1H:
  RESOLVED_CALL: 1C

INTERSECTION R_1D ^ R_1NT:
  RESOLVED_CALL: 1D

INTERSECTION R_1D ^ R_1H:
  RESOLVED_CALL: 1D

INTERSECTION R_RESP_2H ^ R_RESP_2S:
  RESOLVED_CALL: 2S

INTERSECTION R_1D ^ R_1S:
  RESOLVED_CALL: 1D

INTERSECTION R_1C_unbalanced ^ R_1D:
  RESOLVED_CALL: 1C

INTERSECTION R_1C_balanced ^ R_1S ^ R_RESP_3NT:
  RESOLVED_CALL: 1C

INTERSECTION R_1C_unbalanced ^ R_RESP_4H:
  RESOLVED_CALL: 1C

INTERSECTION R_1C_unbalanced ^ R_1H ^ R_REBID_4H ^ R_RESP_4H:
  RESOLVED_CALL: 4H

INTERSECTION R_1C_unbalanced ^ R_1H ^ R_RESP_4H:
  RESOLVED_CALL: 4H

INTERSECTION R_1NT ^ R_RESP_3NT ^ R_RESP_4H:
  RESOLVED_CALL: 3NT

INTERSECTION R_RESP_2S ^ R_RESP_3NT ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2S

INTERSECTION R_RESP_3NT ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 3NT

INTERSECTION R_1C_unbalanced ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 1C

INTERSECTION R_RESP_2H ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION R_RESP_2S ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2S

INTERSECTION R_1C_unbalanced ^ R_1S ^ R_4S ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 1C

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_RESP_2H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 2H

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_1H ^ R_REBID_4H ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4H

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_RESP_2D_WAITING ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_1C_balanced ^ R_1H ^ R_RESP_3NT ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 1H

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_1C_balanced ^ R_RESP_3NT ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4H

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_RESP_2D_WAITING ^ R_RESP_2H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_1D ^ R_RESP_3NT ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4H

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_RESP_2H ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_OPEN_2C_STRONG ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_1D ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 1D

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_RESP_3NT ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 3NT

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_1H ^ R_1S ^ R_REBID_4H ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 1H

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_RESP_2D_WAITING ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_OPEN_2C_STRONG ^ R_REBID_4H ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 2C

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_1H ^ R_4H ^ R_REBID_4H ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4H

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_1H ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4H

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_1H ^ R_1S ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 1H

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_1S ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4H

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_RESP_2D_WAITING ^ R_RESP_2S ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2S

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_OPEN_2C_STRONG ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4H

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_1NT ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 2H

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_1NT ^ R_2OVER1_2C ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 1NT

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_RESP_2D_WAITING ^ R_RESP_2H ^ R_RESP_2S ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 2S

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_1C_balanced ^ R_2OVER1_2C ^ R_RESP_3NT ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 3NT

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_1D ^ R_2OVER1_2D ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_2OVER1_2C ^ R_2OVER1_2D ^ R_OPEN_2C_STRONG ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 2C

INTERSECTION Gambling_3NT_(7, 13)_3NT ^ Jacoby_Transfer_Hearts_False_2H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 3NT

INTERSECTION Gambling_3NT_(7, 13)_3NT ^ Jacoby_Transfer_Hearts_False_2H ^ R_RESP_2D_WAITING ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_True_2H ^ R_OPEN_2C_STRONG ^ R_SLAM_6S ^ R_TAKEOUT_DBL ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_2OVER1_2C ^ R_JACOBY_2NT ^ R_OPEN_2C_STRONG ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 2NT

INTERSECTION Gambling_3NT_(7, 13)_3NT ^ Jacoby_Transfer_Hearts_False_2H ^ R_1S ^ R_4S ^ R_JACOBY_2NT ^ R_RESP_4H ^ R_TAKEOUT_DBL ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4H

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_2OVER1_2D ^ R_JACOBY_2NT ^ R_OPEN_2C_STRONG ^ R_REBID_4H ^ R_RESP_4H ^ R_SLAM_6H ^ R_TAKEOUT_DBL ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 2C

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_SPLINTER_4D ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4D

INTERSECTION Gambling_3NT_(7, 13)_3NT ^ Jacoby_Transfer_Hearts_False_2H ^ R_1H ^ R_4H ^ R_JACOBY_2NT ^ R_REBID_4H ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4H

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_2OVER1_2D ^ R_OPEN_2C_STRONG ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Blackwood_Ace_Encoding_1_5D ^ Jacoby_Transfer_Hearts_False_2H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 5D

INTERSECTION Blackwood_Ace_Encoding_2_5H ^ Jacoby_Transfer_Hearts_False_2H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 5H

INTERSECTION Blackwood_Ace_Encoding_2_5H ^ Gambling_3NT_(7, 13)_3NT ^ Jacoby_Transfer_Hearts_False_2H ^ R_1D ^ R_2OVER1_2D ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Blackwood_Ace_Encoding_1_5D ^ Jacoby_Transfer_Hearts_True_2H ^ R_RESP_2D_WAITING ^ R_RESP_2S ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2S

INTERSECTION Blackwood_Ace_Encoding_2_5H ^ Jacoby_Transfer_Hearts_True_2H ^ R_RESP_2H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 5H

INTERSECTION Blackwood_Ace_Encoding_1_5D ^ Jacoby_Transfer_Hearts_True_2H ^ R_RESP_2H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 5D

INTERSECTION Blackwood_Ace_Encoding_0_5C ^ Jacoby_Transfer_Hearts_True_2H ^ R_RESP_2H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 5C

INTERSECTION Blackwood_Ace_Encoding_0_5C ^ Jacoby_Transfer_Hearts_False_2H ^ R_FOURTH_SUIT_GF ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 3C

INTERSECTION Blackwood_Ace_Encoding_0_5C ^ Gambling_3NT_(7, 13)_3NT ^ Jacoby_Transfer_Hearts_False_2H ^ R_RESP_2D_WAITING ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Blackwood_Ace_Encoding_4_5C ^ Jacoby_Transfer_Hearts_True_2H ^ R_OPEN_2C_STRONG ^ R_TAKEOUT_DBL ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Blackwood_Ace_Encoding_0_5C ^ Gambling_3NT_(7, 13)_3NT ^ Jacoby_Transfer_Hearts_False_2H ^ R_RESP_2H ^ R_RESP_2S ^ Stayman_Response_(0, 3)_2D ^ Texas_Transfer_4D_False_4H:
  RESOLVED_CALL: 2S

INTERSECTION Blackwood_Ace_Encoding_3_5S ^ Jacoby_Transfer_Hearts_False_2H ^ R_1D ^ R_1S ^ R_2OVER1_2D ^ R_FOURTH_SUIT_GF ^ R_SLAM_6S ^ Stayman_Response_(0, 3)_2D ^ Texas_Transfer_4D_False_4H:
  RESOLVED_CALL: 1D

INTERSECTION Blackwood_Ace_Encoding_0_5C ^ Gambling_3NT_(7, 13)_3NT ^ Jacoby_Transfer_Hearts_False_2H ^ R_RESP_2D_WAITING ^ R_RESP_2H ^ Stayman_Response_(4, 13)_2H ^ Texas_Transfer_4D_False_4H:
  RESOLVED_CALL: 2H

INTERSECTION Blackwood_Ace_Encoding_2_5H ^ Jacoby_Transfer_Hearts_False_2H ^ R_2OVER1_2C ^ R_FOURTH_SUIT_GF ^ R_OPEN_2C_STRONG ^ R_SLAM_6S ^ Stayman_Response_(0, 3)_2D ^ Texas_Transfer_4D_False_4H:
  RESOLVED_CALL: 2D

INTERSECTION Blackwood_Ace_Encoding_1_5D ^ Gambling_3NT_(7, 13)_3NT ^ Jacoby_Transfer_Hearts_False_2H ^ Michaels_Response_(3, 13)_2H ^ R_1D ^ R_2OVER1_2D ^ R_FOURTH_SUIT_GF ^ Reverse_Drury_Rebid_(12, 14)_2H ^ Stayman_Response_(0, 3)_2D ^ Texas_Transfer_4D_False_4H:
  RESOLVED_CALL: 2D

INTERSECTION Blackwood_Ace_Encoding_2_5H ^ Jacoby_Transfer_Hearts_True_2H ^ Michaels_Response_(3, 13)_2H ^ R_2OVER1_2D ^ R_OPEN_2C_STRONG ^ Stayman_Response_(0, 3)_2D ^ Texas_Transfer_4D_True_4H:
  RESOLVED_CALL: 2D

INTERSECTION Blackwood_Ace_Encoding_3_5S ^ Jacoby_Transfer_Hearts_False_2H ^ Michaels_Response_(3, 13)_2H ^ R_2OVER1_2D ^ R_FOURTH_SUIT_GF ^ R_JACOBY_2NT ^ R_OPEN_2C_STRONG ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H ^ Texas_Transfer_4D_False_4H ^ Unusual_2NT_Response_(3, 13)_3D:
  RESOLVED_CALL: 2H

INTERSECTION Blackwood_Ace_Encoding_1_5D ^ Gambling_3NT_(7, 13)_3NT ^ Jacoby_Transfer_Hearts_False_2H ^ Michaels_Response_(3, 13)_2H ^ R_RESP_2D_WAITING ^ Stayman_Response_(0, 3)_2D ^ Texas_Transfer_4D_False_4H ^ Unusual_2NT_Response_(0, 2)_3C:
  RESOLVED_CALL: 2D

INTERSECTION Blackwood_Ace_Encoding_1_5D ^ Jacoby_Transfer_Hearts_False_2H ^ Michaels_Response_(0, 2)_2S ^ R_RESP_2D_WAITING ^ R_RESP_2S ^ Stayman_Response_(0, 3)_2D ^ Texas_Transfer_4D_False_4H ^ Unusual_2NT_Response_(3, 13)_3D:
  RESOLVED_CALL: 2S

INTERSECTION Blackwood_Ace_Encoding_1_5D ^ Cappelletti_2D_Response_(0, 2)_2S ^ Gambling_3NT_(7, 13)_3NT ^ Jacoby_Transfer_Hearts_False_2H ^ Michaels_Response_(0, 2)_2S ^ R_RESP_2S ^ Stayman_Response_(0, 3)_2D ^ Texas_Transfer_4D_False_4H ^ Unusual_2NT_Response_(0, 2)_3C:
  RESOLVED_CALL: 2S

INTERSECTION Blackwood_Ace_Encoding_3_5S ^ Cappelletti_2D_Response_(3, 13)_2H ^ Jacoby_Transfer_Hearts_True_2H ^ Michaels_Response_(3, 13)_2H ^ R_1D ^ R_2OVER1_2D ^ R_TAKEOUT_DBL ^ Reverse_Drury_Rebid_(15, 21)_4H ^ Stayman_Response_(0, 3)_2D ^ Texas_Transfer_4D_True_4H ^ Unusual_2NT_Response_(3, 13)_3D:
  RESOLVED_CALL: 2D
