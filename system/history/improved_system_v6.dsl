# ==========================================
# IMPROVED BIDDING SYSTEM: ImprovedSystem_v6
# Generated via Continuous Self-Improvement Pipeline
# ==========================================

# --- Active Rules & Conventions ---

RULE R_1NT:
  CALL: 1NT
  PRIORITY: 20
  CONDITION: hcp >= 15
  CONDITION: hcp <= 17
  CONDITION: is_balanced == True

RULE R_1H:
  CALL: 1H
  PRIORITY: 20
  CONDITION: hcp >= 12
  CONDITION: hcp <= 21
  CONDITION: heart_len >= 5

RULE R_1S:
  CALL: 1S
  PRIORITY: 20
  CONDITION: hcp >= 12
  CONDITION: hcp <= 21
  CONDITION: spade_len >= 5

RULE R_1D:
  CALL: 1D
  PRIORITY: 15
  CONDITION: hcp >= 12
  CONDITION: hcp <= 21
  CONDITION: diamond_len >= 4

RULE R_1C_unbalanced:
  CALL: 1C
  PRIORITY: 10
  CONDITION: hcp >= 12
  CONDITION: hcp <= 21
  CONDITION: club_len >= 3
  CONDITION: is_balanced == False

RULE R_1C_balanced:
  CALL: 1C
  PRIORITY: 10
  CONDITION: hcp >= 12
  CONDITION: hcp <= 14
  CONDITION: club_len >= 3
  CONDITION: is_balanced == True

RULE R_RESP_2H:
  CALL: 2H
  PRIORITY: 18
  CONDITION: heart_len >= 3
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE SLAM_EXPLORE_6S:
  CALL: 6S
  PRIORITY: 35
  CONDITION: partner_last_call in ['3S', '4S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6

RULE SLAM_EXPLORE_6H:
  CALL: 6H
  PRIORITY: 35
  CONDITION: partner_last_call in ['3H', '4H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6

RULE COMP_BALANCING_1NT:
  CALL: 1NT
  PRIORITY: 24
  CONDITION: is_balancing == True
  CONDITION: hcp >= 11
  CONDITION: is_balanced == True

RULE COMP_TAKEOUT_DBL:
  CALL: X
  PRIORITY: 25
  CONDITION: is_competitive == True
  CONDITION: hcp >= 12
  CONDITION: heart_len >= 3
  CONDITION: spade_len >= 3

RULE COMP_1S_OVERCALL:
  CALL: 1S
  PRIORITY: 23
  CONDITION: is_competitive == True
  CONDITION: hcp >= 9
  CONDITION: spade_len >= 5

RULE SLAM_EXPLORE_6S:
  CALL: 6S
  PRIORITY: 35
  CONDITION: partner_last_call in ['3S', '4S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6

RULE SLAM_EXPLORE_6H:
  CALL: 6H
  PRIORITY: 35
  CONDITION: partner_last_call in ['3H', '4H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6

RULE COMP_BALANCING_1NT:
  CALL: 1NT
  PRIORITY: 24
  CONDITION: is_balancing == True
  CONDITION: hcp >= 11
  CONDITION: is_balanced == True

RULE COMP_TAKEOUT_DBL:
  CALL: X
  PRIORITY: 25
  CONDITION: is_competitive == True
  CONDITION: hcp >= 12
  CONDITION: heart_len >= 3
  CONDITION: spade_len >= 3

RULE COMP_1S_OVERCALL:
  CALL: 1S
  PRIORITY: 23
  CONDITION: is_competitive == True
  CONDITION: hcp >= 9
  CONDITION: spade_len >= 5

RULE SLAM_EXPLORE_6S:
  CALL: 6S
  PRIORITY: 35
  CONDITION: partner_last_call in ['3S', '4S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6

RULE SLAM_EXPLORE_6H:
  CALL: 6H
  PRIORITY: 35
  CONDITION: partner_last_call in ['3H', '4H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6

RULE COMP_BALANCING_1NT:
  CALL: 1NT
  PRIORITY: 24
  CONDITION: is_balancing == True
  CONDITION: hcp >= 11
  CONDITION: is_balanced == True

RULE COMP_TAKEOUT_DBL:
  CALL: X
  PRIORITY: 25
  CONDITION: is_competitive == True
  CONDITION: hcp >= 12
  CONDITION: heart_len >= 3
  CONDITION: spade_len >= 3

RULE COMP_1S_OVERCALL:
  CALL: 1S
  PRIORITY: 23
  CONDITION: is_competitive == True
  CONDITION: hcp >= 9
  CONDITION: spade_len >= 5

RULE GAME_ACCEPT_4S_OVER_3S:
  CALL: 4S
  PRIORITY: 33
  CONDITION: partner_last_call in ['2S', '3S']
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 13

RULE GAME_ACCEPT_4H_OVER_3H:
  CALL: 4H
  PRIORITY: 33
  CONDITION: partner_last_call in ['2H', '3H']
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 13

RULE GAME_ACCEPT_3NT_OVER_2NT:
  CALL: 3NT
  PRIORITY: 32
  CONDITION: partner_last_call == 2NT
  CONDITION: hcp >= 14

RULE SLAM_EXPLORE_6S:
  CALL: 6S
  PRIORITY: 35
  CONDITION: partner_last_call in ['3S', '4S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6

RULE SLAM_EXPLORE_6H:
  CALL: 6H
  PRIORITY: 35
  CONDITION: partner_last_call in ['3H', '4H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6

RULE R_OPEN_2C_STRONG:
  CALL: 2C
  PRIORITY: 29
  CONDITION: hcp >= 22

RULE COMP_BALANCING_1NT:
  CALL: 1NT
  PRIORITY: 24
  CONDITION: is_balancing == True
  CONDITION: hcp >= 11
  CONDITION: is_balanced == True

RULE COMP_TAKEOUT_DBL:
  CALL: X
  PRIORITY: 25
  CONDITION: is_competitive == True
  CONDITION: hcp >= 12
  CONDITION: heart_len >= 3
  CONDITION: spade_len >= 3

RULE COMP_1S_OVERCALL:
  CALL: 1S
  PRIORITY: 23
  CONDITION: is_competitive == True
  CONDITION: hcp >= 9
  CONDITION: spade_len >= 5

RULE GAME_ACCEPT_4S_OVER_3S:
  CALL: 4S
  PRIORITY: 33
  CONDITION: partner_last_call in ['2S', '3S']
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 13

RULE GAME_ACCEPT_4H_OVER_3H:
  CALL: 4H
  PRIORITY: 33
  CONDITION: partner_last_call in ['2H', '3H']
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 13

RULE GAME_ACCEPT_3NT_OVER_2NT:
  CALL: 3NT
  PRIORITY: 32
  CONDITION: partner_last_call == 2NT
  CONDITION: hcp >= 14

RULE SLAM_EXPLORE_6S:
  CALL: 6S
  PRIORITY: 35
  CONDITION: partner_last_call in ['3S', '4S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6

RULE SLAM_EXPLORE_6H:
  CALL: 6H
  PRIORITY: 35
  CONDITION: partner_last_call in ['3H', '4H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 19
  CONDITION: controls >= 6

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

RULE R_RESP_3NT:
  CALL: 3NT
  PRIORITY: 22
  CONDITION: partner_last_call in ['1C', '1D', '1H', '1S', '1NT']
  CONDITION: is_balanced == True
  CONDITION: hcp >= 10
  CONDITION: hcp <= 15

RULE R_4H:
  CALL: 4H
  PRIORITY: 25
  CONDITION: partner_last_call in ['1H', '2H', '3H']
  CONDITION: heart_len >= 6
  CONDITION: hcp >= 13

RULE R_4S:
  CALL: 4S
  PRIORITY: 25
  CONDITION: partner_last_call in ['1S', '2S', '3S']
  CONDITION: spade_len >= 6
  CONDITION: hcp >= 13

RULE R_RESP_4H:
  CALL: 4H
  PRIORITY: 24
  CONDITION: partner_last_call in ['1H', '2H', '3H']
  CONDITION: hearts_len >= 4
  CONDITION: hcp >= 12

RULE R_REBID_4H:
  CALL: 4H
  PRIORITY: 26
  CONDITION: partner_last_call in ['1H', '2H', '3H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 16

RULE FW_TKO_VS_S:
  CALL: X
  PRIORITY: 25
  CONDITION: is_competitive == True
  CONDITION: last_bid_strain == S
  CONDITION: spade_len <= 2
  CONDITION: hcp >= 11
  CONDITION: heart_len >= 4

RULE FW_TKO_VS_H:
  CALL: X
  PRIORITY: 25
  CONDITION: is_competitive == True
  CONDITION: last_bid_strain == H
  CONDITION: heart_len <= 2
  CONDITION: hcp >= 11
  CONDITION: spade_len >= 4

RULE FW_2NT_FORCE:
  CALL: 2NT
  PRIORITY: 24
  CONDITION: partner_last_call in ['1H', '1S']
  CONDITION: hcp >= 11

RULE FW_2NT_ACCEPT_H:
  CALL: 4H
  PRIORITY: 26
  CONDITION: partner_last_call == 2NT
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 13

RULE FW_2NT_ACCEPT_S:
  CALL: 4S
  PRIORITY: 26
  CONDITION: partner_last_call == 2NT
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 13

RULE FW_2NT_DECLINE:
  CALL: 3NT
  PRIORITY: 20
  CONDITION: partner_last_call == 2NT
  CONDITION: hcp <= 12

RULE R_RESP_2S:
  CALL: 2S
  PRIORITY: 18
  CONDITION: spade_len >= 3
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10
  CONDITION: is_opening == False

RULE FW_OVERCALL_1H:
  CALL: 1H
  PRIORITY: 22
  CONDITION: opp_last_call in ['1C', '1D', '1S']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 8

RULE FW_OVERCALL_1S:
  CALL: 1S
  PRIORITY: 22
  CONDITION: opp_last_call in ['1C', '1D', '1H']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 8
