# ==========================================
# IMPROVED BIDDING SYSTEM: ImprovedSystem_v17
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

RULE GAME_ACCEPT_4S_OVER_3S:
  CALL: 4S
  PRIORITY: 33
  CONDITION: partner_last_call in ['2S', '3S']
  CONDITION: spade_len >= 4
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

RULE GAME_ACCEPT_4S_OVER_3S:
  CALL: 4S
  PRIORITY: 33
  CONDITION: partner_last_call in ['2S', '3S']
  CONDITION: spade_len >= 4
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

RULE X_LIFT_2H:
  CALL: 2H
  PRIORITY: 26
  CONDITION: partner_last_call == X
  CONDITION: hcp >= 6
  CONDITION: hearts_len >= 4

RULE X_LIFT_2S:
  CALL: 2S
  PRIORITY: 26
  CONDITION: partner_last_call == X
  CONDITION: hcp >= 6
  CONDITION: spades_len >= 4

RULE X_LIFT_3D:
  CALL: 3D
  PRIORITY: 27
  CONDITION: partner_last_call == X
  CONDITION: hcp >= 11
  CONDITION: diamond_len >= 5

RULE X_RESP_2NT:
  CALL: 2NT
  PRIORITY: 25
  CONDITION: partner_last_call == X
  CONDITION: hcp >= 10
  CONDITION: is_balanced == True

RULE R_RESP_2H:
  CALL: 2H
  PRIORITY: 18
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 3
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE R_RESP_2S:
  CALL: 2S
  PRIORITY: 18
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 3
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE SLAM_REBID_3D:
  CALL: 3D
  PRIORITY: 28
  CONDITION: my_last_call in ['1C', '1D']
  CONDITION: partner_last_call in ['1H', '1S']
  CONDITION: diamond_len >= 6
  CONDITION: hcp >= 17

RULE SLAM_FIT_6D:
  CALL: 6D
  PRIORITY: 30
  CONDITION: partner_last_call == 3D
  CONDITION: diamond_len >= 2
  CONDITION: hcp >= 12

RULE SLAM_FIT_3NT_D:
  CALL: 3NT
  PRIORITY: 24
  CONDITION: partner_last_call == 3D
  CONDITION: is_balanced == True
  CONDITION: hcp >= 11

RULE FW_2NT_FORCE_H:
  CALL: 2NT
  PRIORITY: 24
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 3
  CONDITION: hcp >= 11

RULE FW_2NT_FORCE_S:
  CALL: 2NT
  PRIORITY: 24
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 3
  CONDITION: hcp >= 11

RULE FW_2NT_DECLINE:
  CALL: 3NT
  PRIORITY: 20
  CONDITION: partner_last_call == 2NT
  CONDITION: hcp <= 12

RULE ASK_4NT_ACES:
  CALL: 4NT
  PRIORITY: 29
  CONDITION: partner_last_call == 3NT
  CONDITION: hcp >= 15

RULE BW_RESP_C:
  CALL: 5C
  PRIORITY: 31
  CONDITION: partner_last_call == 4NT
  CONDITION: ace_count == 0
  CONDITION: ace_count <= 0

RULE BW_RESP_D:
  CALL: 5D
  PRIORITY: 31
  CONDITION: partner_last_call == 4NT
  CONDITION: ace_count == 1
  CONDITION: ace_count <= 1

RULE BW_RESP_H:
  CALL: 5H
  PRIORITY: 31
  CONDITION: partner_last_call == 4NT
  CONDITION: ace_count == 2
  CONDITION: ace_count <= 2

RULE BW_RESP_S:
  CALL: 5S
  PRIORITY: 31
  CONDITION: partner_last_call == 4NT
  CONDITION: ace_count == 3

RULE SIGNOFF_5NT_NOACE:
  CALL: 5NT
  PRIORITY: 32
  CONDITION: my_last_call == 4NT
  CONDITION: partner_last_call == 5C

RULE ASK_5NT_KINGS:
  CALL: 5NT
  PRIORITY: 33
  CONDITION: my_last_call == 4NT
  CONDITION: partner_last_call in ['5D', '5H', '5S']
  CONDITION: hcp >= 16

RULE PLACE_6NT_ACES:
  CALL: 6NT
  PRIORITY: 32
  CONDITION: my_last_call == 4NT
  CONDITION: partner_last_call in ['5D', '5H', '5S']
  CONDITION: hcp <= 15

RULE KW_RESP_0_6C:
  CALL: 6C
  PRIORITY: 34
  CONDITION: partner_last_call == 5NT
  CONDITION: my_last_call in ['5D', '5H', '5S']
  CONDITION: king_count == 0

RULE KW_RESP_1_6D:
  CALL: 6D
  PRIORITY: 34
  CONDITION: partner_last_call == 5NT
  CONDITION: my_last_call in ['5D', '5H', '5S']
  CONDITION: king_count == 1

RULE KW_RESP_2_6H:
  CALL: 6H
  PRIORITY: 34
  CONDITION: partner_last_call == 5NT
  CONDITION: my_last_call in ['5D', '5H', '5S']
  CONDITION: king_count >= 2

RULE GRAND_7NT_ONE_K:
  CALL: 7NT
  PRIORITY: 36
  CONDITION: my_last_call == 5NT
  CONDITION: partner_last_call == 6D
  CONDITION: hcp >= 19

RULE PLACE_6NT_AFTER_K_ASK:
  CALL: 6NT
  PRIORITY: 30
  CONDITION: my_last_call == 5NT
  CONDITION: partner_last_call in ['6C', '6D', '6H']

RULE R_WEAK_2H:
  CALL: 2H
  PRIORITY: 19
  CONDITION: heart_len == 6
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10
  CONDITION: is_balanced == False
  CONDITION: partner_last_call != NONE

RULE GAME_ACCEPT_4H_OVER_3H:
  CALL: 4H
  PRIORITY: 33
  CONDITION: partner_last_call in ['2H', '3H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 14

RULE GRAND_7NT_TWO_K:
  CALL: 7NT
  PRIORITY: 36
  CONDITION: my_last_call == 5NT
  CONDITION: partner_last_call in ['6H', '6S']
  CONDITION: hcp >= 16

RULE COMP_1S_OVERCALL:
  CALL: 1S
  PRIORITY: 23
  CONDITION: is_competitive == True
  CONDITION: hcp >= 8
  CONDITION: spade_len >= 4

RULE NO_C_WITH_MAJOR_SPA:
  CALL: 1C
  PRIORITY: 30
  NEGATIVE: True
  CONDITION: is_opening == True
  CONDITION: spade_len >= 5
  # Never open a minor holding a 5-card major

RULE NO_C_WITH_MAJOR_SPA:
  CALL: 1C
  PRIORITY: 30
  CONDITION: is_opening == True
  CONDITION: spade_len >= 5
  # Never open a minor holding a 5-card major

RULE NO_C_WITH_MAJOR_HEA:
  CALL: 1C
  PRIORITY: 30
  NEGATIVE: True
  CONDITION: is_opening == True
  CONDITION: heart_len >= 5
  # Never open a minor holding a 5-card major

RULE NO_C_WITH_MAJOR_HEA:
  CALL: 1C
  PRIORITY: 30
  CONDITION: is_opening == True
  CONDITION: heart_len >= 5
  # Never open a minor holding a 5-card major

RULE NO_D_WITH_MAJOR_SPA:
  CALL: 1D
  PRIORITY: 30
  NEGATIVE: True
  CONDITION: is_opening == True
  CONDITION: spade_len >= 5
  # Never open a minor holding a 5-card major

RULE NO_D_WITH_MAJOR_SPA:
  CALL: 1D
  PRIORITY: 30
  CONDITION: is_opening == True
  CONDITION: spade_len >= 5
  # Never open a minor holding a 5-card major

RULE NO_D_WITH_MAJOR_HEA:
  CALL: 1D
  PRIORITY: 30
  NEGATIVE: True
  CONDITION: is_opening == True
  CONDITION: heart_len >= 5
  # Never open a minor holding a 5-card major

RULE NO_D_WITH_MAJOR_HEA:
  CALL: 1D
  PRIORITY: 30
  CONDITION: is_opening == True
  CONDITION: heart_len >= 5
  # Never open a minor holding a 5-card major

RULE SELF_REBID_2S:
  CALL: 2S
  PRIORITY: 21
  CONDITION: my_last_call == 1S
  CONDITION: partner_last_call in ['PASS', 'NONE']
  CONDITION: spade_len >= 6
  CONDITION: hcp >= 10
  # Rebid own 6-card S while partner silent

RULE SELF_REBID_3S:
  CALL: 3S
  PRIORITY: 21
  CONDITION: my_last_call == 2S
  CONDITION: partner_last_call in ['PASS', 'NONE']
  CONDITION: spade_len >= 6
  CONDITION: hcp >= 10
  # Rebid own 6-card S while partner silent

RULE SELF_REBID_2H:
  CALL: 2H
  PRIORITY: 21
  CONDITION: my_last_call == 1H
  CONDITION: partner_last_call in ['PASS', 'NONE']
  CONDITION: heart_len >= 6
  CONDITION: hcp >= 10
  # Rebid own 6-card H while partner silent

RULE SELF_REBID_3H:
  CALL: 3H
  PRIORITY: 21
  CONDITION: my_last_call == 2H
  CONDITION: partner_last_call in ['PASS', 'NONE']
  CONDITION: heart_len >= 6
  CONDITION: hcp >= 10
  # Rebid own 6-card H while partner silent

RULE SELF_GAME_4S:
  CALL: 4S
  PRIORITY: 33
  CONDITION: my_last_call in ['1S', '2S', '3S']
  CONDITION: spade_len >= 6
  CONDITION: spade_has_ace == True
  CONDITION: spade_has_king == True
  CONDITION: spade_has_queen == True
  CONDITION: hcp >= 11
  # Self-sufficient S suit (A K Q, 6+): drive to game

RULE SELF_GAME_4H:
  CALL: 4H
  PRIORITY: 33
  CONDITION: my_last_call in ['1H', '2H', '3H']
  CONDITION: heart_len >= 6
  CONDITION: heart_has_ace == True
  CONDITION: heart_has_king == True
  CONDITION: heart_has_queen == True
  CONDITION: hcp >= 11
  # Self-sufficient H suit (A K Q, 6+): drive to game
