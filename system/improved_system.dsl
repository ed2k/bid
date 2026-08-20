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

RULE COMP_BALANCING_1NT:
  CALL: 1NT
  PRIORITY: 24
  CONDITION: is_balancing == True
  CONDITION: hcp >= 11
  CONDITION: is_balanced == True
  # Competitive: Balance 1NT to prevent opponents from buying contract cheaply

RULE COMP_TAKEOUT_DBL:
  CALL: X
  PRIORITY: 25
  CONDITION: is_competitive == True
  CONDITION: hcp >= 12
  CONDITION: heart_len >= 3
  CONDITION: spade_len >= 3
  # Competitive: Aggressive Takeout Double on 12+ HCP

RULE COMP_1S_OVERCALL:
  CALL: 1S
  PRIORITY: 23
  CONDITION: is_competitive == True
  CONDITION: hcp >= 9
  CONDITION: spade_len >= 5
  # Competitive: Direct 1S Overcall to contest auction

RULE GAME_ACCEPT_4S_OVER_3S:
  CALL: 4S
  PRIORITY: 33
  CONDITION: partner_last_call in ['2S', '3S']
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 13
  # Game Maximizer: Accept limit raise and bid 4S game with 13+ HCP

RULE GAME_ACCEPT_4H_OVER_3H:
  CALL: 4H
  PRIORITY: 33
  CONDITION: partner_last_call in ['2H', '3H']
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 13
  # Game Maximizer: Accept limit raise and bid 4H game with 13+ HCP

RULE GAME_ACCEPT_3NT_OVER_2NT:
  CALL: 3NT
  PRIORITY: 32
  CONDITION: partner_last_call == 2NT
  CONDITION: hcp >= 14
  # Game Maximizer: Accept 2NT invite and bid 3NT with 14+ HCP

RULE SLAM_EXPLORE_6S:
  CALL: 6S
  PRIORITY: 35
  CONDITION: partner_last_call in ['3S', '4S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6
  # Slam Protocol: Jump to 6S on 19+ HCP and 6+ Controls

RULE SLAM_EXPLORE_6H:
  CALL: 6H
  PRIORITY: 35
  CONDITION: partner_last_call in ['3H', '4H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6
  # Slam Protocol: Jump to 6H on 19+ HCP and 6+ Controls

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

RULE COMP_BALANCING_1NT:
  CALL: 1NT
  PRIORITY: 24
  CONDITION: is_balancing == True
  CONDITION: hcp >= 11
  CONDITION: is_balanced == True
  # Competitive: Balance 1NT to prevent opponents from buying contract cheaply

RULE COMP_TAKEOUT_DBL:
  CALL: X
  PRIORITY: 25
  CONDITION: is_competitive == True
  CONDITION: hcp >= 12
  CONDITION: heart_len >= 3
  CONDITION: spade_len >= 3
  # Competitive: Aggressive Takeout Double on 12+ HCP

RULE COMP_1S_OVERCALL:
  CALL: 1S
  PRIORITY: 23
  CONDITION: is_competitive == True
  CONDITION: hcp >= 9
  CONDITION: spade_len >= 5
  # Competitive: Direct 1S Overcall to contest auction

RULE GAME_ACCEPT_4S_OVER_3S:
  CALL: 4S
  PRIORITY: 33
  CONDITION: partner_last_call in ['2S', '3S']
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 13
  # Game Maximizer: Accept limit raise and bid 4S game with 13+ HCP

RULE GAME_ACCEPT_4H_OVER_3H:
  CALL: 4H
  PRIORITY: 33
  CONDITION: partner_last_call in ['2H', '3H']
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 13
  # Game Maximizer: Accept limit raise and bid 4H game with 13+ HCP

RULE GAME_ACCEPT_3NT_OVER_2NT:
  CALL: 3NT
  PRIORITY: 32
  CONDITION: partner_last_call == 2NT
  CONDITION: hcp >= 14
  # Game Maximizer: Accept 2NT invite and bid 3NT with 14+ HCP

RULE SLAM_EXPLORE_6S:
  CALL: 6S
  PRIORITY: 35
  CONDITION: partner_last_call in ['3S', '4S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6
  # Slam Protocol: Jump to 6S on 19+ HCP and 6+ Controls

RULE SLAM_EXPLORE_6H:
  CALL: 6H
  PRIORITY: 35
  CONDITION: partner_last_call in ['3H', '4H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6
  # Slam Protocol: Jump to 6H on 19+ HCP and 6+ Controls

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

RULE COMP_BALANCING_1NT:
  CALL: 1NT
  PRIORITY: 24
  CONDITION: is_balancing == True
  CONDITION: hcp >= 11
  CONDITION: is_balanced == True
  # Competitive: Balance 1NT to prevent opponents from buying contract cheaply

RULE COMP_TAKEOUT_DBL:
  CALL: X
  PRIORITY: 25
  CONDITION: is_competitive == True
  CONDITION: hcp >= 12
  CONDITION: heart_len >= 3
  CONDITION: spade_len >= 3
  # Competitive: Aggressive Takeout Double on 12+ HCP

RULE COMP_1S_OVERCALL:
  CALL: 1S
  PRIORITY: 23
  CONDITION: is_competitive == True
  CONDITION: hcp >= 9
  CONDITION: spade_len >= 5
  # Competitive: Direct 1S Overcall to contest auction

RULE GAME_ACCEPT_4S_OVER_3S:
  CALL: 4S
  PRIORITY: 33
  CONDITION: partner_last_call in ['2S', '3S']
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 13
  # Game Maximizer: Accept limit raise and bid 4S game with 13+ HCP

RULE GAME_ACCEPT_4H_OVER_3H:
  CALL: 4H
  PRIORITY: 33
  CONDITION: partner_last_call in ['2H', '3H']
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 13
  # Game Maximizer: Accept limit raise and bid 4H game with 13+ HCP

RULE GAME_ACCEPT_3NT_OVER_2NT:
  CALL: 3NT
  PRIORITY: 32
  CONDITION: partner_last_call == 2NT
  CONDITION: hcp >= 14
  # Game Maximizer: Accept 2NT invite and bid 3NT with 14+ HCP

RULE SLAM_EXPLORE_6S:
  CALL: 6S
  PRIORITY: 35
  CONDITION: partner_last_call in ['3S', '4S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6
  # Slam Protocol: Jump to 6S on 19+ HCP and 6+ Controls

RULE SLAM_EXPLORE_6H:
  CALL: 6H
  PRIORITY: 35
  CONDITION: partner_last_call in ['3H', '4H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6
  # Slam Protocol: Jump to 6H on 19+ HCP and 6+ Controls

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

RULE COMP_BALANCING_1NT:
  CALL: 1NT
  PRIORITY: 24
  CONDITION: is_balancing == True
  CONDITION: hcp >= 11
  CONDITION: is_balanced == True
  # Competitive: Balance 1NT to prevent opponents from buying contract cheaply

RULE COMP_TAKEOUT_DBL:
  CALL: X
  PRIORITY: 25
  CONDITION: is_competitive == True
  CONDITION: hcp >= 12
  CONDITION: heart_len >= 3
  CONDITION: spade_len >= 3
  # Competitive: Aggressive Takeout Double on 12+ HCP

RULE COMP_1S_OVERCALL:
  CALL: 1S
  PRIORITY: 23
  CONDITION: is_competitive == True
  CONDITION: hcp >= 9
  CONDITION: spade_len >= 5
  # Competitive: Direct 1S Overcall to contest auction

RULE GAME_ACCEPT_4S_OVER_3S:
  CALL: 4S
  PRIORITY: 33
  CONDITION: partner_last_call in ['2S', '3S']
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 13
  # Game Maximizer: Accept limit raise and bid 4S game with 13+ HCP

RULE GAME_ACCEPT_4H_OVER_3H:
  CALL: 4H
  PRIORITY: 33
  CONDITION: partner_last_call in ['2H', '3H']
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 13
  # Game Maximizer: Accept limit raise and bid 4H game with 13+ HCP

RULE GAME_ACCEPT_3NT_OVER_2NT:
  CALL: 3NT
  PRIORITY: 32
  CONDITION: partner_last_call == 2NT
  CONDITION: hcp >= 14
  # Game Maximizer: Accept 2NT invite and bid 3NT with 14+ HCP

RULE SLAM_EXPLORE_6S:
  CALL: 6S
  PRIORITY: 35
  CONDITION: partner_last_call in ['3S', '4S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6
  # Slam Protocol: Jump to 6S on 19+ HCP and 6+ Controls

RULE SLAM_EXPLORE_6H:
  CALL: 6H
  PRIORITY: 35
  CONDITION: partner_last_call in ['3H', '4H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6
  # Slam Protocol: Jump to 6H on 19+ HCP and 6+ Controls

RULE R_OPEN_2C_STRONG:
  CALL: 2C
  PRIORITY: 29
  CONDITION: hcp >= 22

RULE R_RESP_2D_WAITING:
  CALL: 2D
  PRIORITY: 28
  CONDITION: hcp <= 7


# --- Refined ID3 Exception Trees (Speedup Learning Splits) ---

INTERSECTION R_1C_balanced ^ R_1D:
  RESOLVED_CALL: 1C

INTERSECTION R_1C_unbalanced ^ R_1S ^ R_4S:
  RESOLVED_CALL: 1S

INTERSECTION R_1D ^ R_1H:
  RESOLVED_CALL: 1H

INTERSECTION R_RESP_2H ^ R_RESP_2S:
  RESOLVED_CALL: 2H

INTERSECTION R_1H ^ R_RESP_4H:
  RESOLVED_CALL: 1H

INTERSECTION R_1C_balanced ^ R_RESP_3NT ^ R_RESP_4H:
  RESOLVED_CALL: 4H

INTERSECTION R_1C_balanced ^ R_RESP_3NT:
  RESOLVED_CALL: 3NT

INTERSECTION R_1S ^ R_RESP_3NT:
  RESOLVED_CALL: 3NT

INTERSECTION R_1D ^ R_RESP_3NT ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4H

INTERSECTION R_RESP_2H ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION R_1NT ^ R_RESP_3NT ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4H

INTERSECTION R_1S ^ R_4S ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 1S

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_RESP_2S ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_1S ^ R_RESP_4H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 4H

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ Stayman_Response_(4, 13)_2H:
  RESOLVED_CALL: 2H

INTERSECTION Jacoby_Transfer_Hearts_False_2H ^ R_1C_unbalanced ^ R_1D ^ R_1S ^ Stayman_Response_(0, 3)_2D:
  RESOLVED_CALL: 2D
