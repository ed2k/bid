# ==========================================
# IMPROVED BIDDING SYSTEM: champion_system
# Generated via Continuous Self-Improvement Pipeline
# ==========================================

# --- Active Rules & Conventions ---

RULE SUP_1C_STRONG:
  CALL: 1C
  PRIORITY: 37
  CONDITION: is_opening == True
  CONDITION: hcp >= 16

RULE SUP_REBID_6S_OVER_1S:
  CALL: 6S
  PRIORITY: 37
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 3
  CONDITION: hcp >= 20

RULE SUP_REBID_6H_OVER_1H:
  CALL: 6H
  PRIORITY: 37
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 3
  CONDITION: hcp >= 20

RULE SUP_REBID_6NT_OVER_1NT:
  CALL: 6NT
  PRIORITY: 37
  CONDITION: partner_last_call == 1NT
  CONDITION: is_balanced == True
  CONDITION: hcp >= 20

RULE SUP_SACRIFICE_4S_OVER_4H:
  CALL: 4S
  PRIORITY: 36
  CONDITION: opp_last_call in ['4H', '3H']
  CONDITION: spade_len >= 5
  CONDITION: is_vulnerable == False

RULE SUP_SACRIFICE_5C_OVER_4M:
  CALL: 5C
  PRIORITY: 35
  CONDITION: opp_last_call in ['4H', '4S']
  CONDITION: club_len >= 6
  CONDITION: is_vulnerable == False

RULE SUP_SACRIFICE_5D_OVER_4M:
  CALL: 5D
  PRIORITY: 35
  CONDITION: opp_last_call in ['4H', '4S']
  CONDITION: diamond_len >= 6
  CONDITION: is_vulnerable == False

RULE SUP_REBID_4S_OVER_1S:
  CALL: 4S
  PRIORITY: 34
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 3
  CONDITION: hcp >= 16

RULE SUP_REBID_4H_OVER_1H:
  CALL: 4H
  PRIORITY: 34
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 3
  CONDITION: hcp >= 16

RULE SUP_RESP_3NT_POS:
  CALL: 3NT
  PRIORITY: 33
  CONDITION: partner_last_call == 1C
  CONDITION: hcp >= 14
  CONDITION: is_balanced == True

RULE SUP_REBID_3NT_OVER_POS:
  CALL: 3NT
  PRIORITY: 33
  CONDITION: partner_last_call in ['1NT', '2C', '2D']
  CONDITION: hcp >= 16

RULE SUP_RESP_1H_POS:
  CALL: 1H
  PRIORITY: 32
  CONDITION: partner_last_call == 1C
  CONDITION: hcp >= 8
  CONDITION: heart_len >= 5

RULE SUP_RESP_1S_POS:
  CALL: 1S
  PRIORITY: 32
  CONDITION: partner_last_call == 1C
  CONDITION: hcp >= 8
  CONDITION: spade_len >= 5

RULE SUP_REBID_3NT_OVER_1S:
  CALL: 3NT
  PRIORITY: 31
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len <= 2
  CONDITION: hcp >= 16

RULE SUP_REBID_3NT_OVER_1H:
  CALL: 3NT
  PRIORITY: 31
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len <= 2
  CONDITION: hcp >= 16

RULE SUP_RESP_1NT_POS:
  CALL: 1NT
  PRIORITY: 30
  CONDITION: partner_last_call == 1C
  CONDITION: hcp >= 8
  CONDITION: hcp <= 13
  CONDITION: is_balanced == True

RULE SUP_OPEN_2NT:
  CALL: 2NT
  PRIORITY: 29
  CONDITION: is_opening == True
  CONDITION: hcp >= 20
  CONDITION: hcp <= 21
  CONDITION: is_balanced == True

RULE SUP_2NT_RESP_6NT:
  CALL: 6NT
  PRIORITY: 29
  CONDITION: partner_last_call == 2NT
  CONDITION: is_balanced == True
  CONDITION: hcp >= 12

RULE SUP_RESP_1D_NEG:
  CALL: 1D
  PRIORITY: 28
  CONDITION: partner_last_call == 1C
  CONDITION: hcp <= 7

RULE SUP_RESP_2C_POS:
  CALL: 2C
  PRIORITY: 28
  CONDITION: partner_last_call == 1C
  CONDITION: hcp >= 8
  CONDITION: club_len >= 5

RULE SUP_RESP_2D_POS:
  CALL: 2D
  PRIORITY: 28
  CONDITION: partner_last_call == 1C
  CONDITION: hcp >= 8
  CONDITION: diamond_len >= 5

RULE SUP_REBID_3NT:
  CALL: 3NT
  PRIORITY: 28
  CONDITION: partner_last_call == 1D
  CONDITION: is_balanced == True
  CONDITION: hcp >= 22

RULE SUP_GAME_4H_AFTER_RAISE:
  CALL: 4H
  PRIORITY: 29
  CONDITION: partner_last_call in ['2H', '3H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 16
  CONDITION: hcp <= 22

RULE SUP_GAME_4H_WITH_LONG_SUIT:
  CALL: 4H
  PRIORITY: 29
  CONDITION: my_last_call == 1H
  CONDITION: partner_last_call == 2H
  CONDITION: heart_len >= 6
  CONDITION: hcp >= 13

RULE SUP_GAME_4S_AFTER_RAISE:
  CALL: 4S
  PRIORITY: 29
  CONDITION: partner_last_call in ['2S', '3S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 16
  CONDITION: hcp <= 22

RULE SUP_GAME_4S_WITH_LONG_SUIT:
  CALL: 4S
  PRIORITY: 29
  CONDITION: my_last_call == 1S
  CONDITION: partner_last_call == 2S
  CONDITION: spade_len >= 6
  CONDITION: hcp >= 13

RULE SUP_SLAM_6H:
  CALL: 6H
  PRIORITY: 28
  CONDITION: partner_last_call in ['1H', '2H', '3H', '4H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 23

RULE SUP_SLAM_6S:
  CALL: 6S
  PRIORITY: 28
  CONDITION: partner_last_call in ['1S', '2S', '3S', '4S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 23

RULE SUP_REBID_1H:
  CALL: 1H
  PRIORITY: 27
  CONDITION: partner_last_call == 1D
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 16

RULE SUP_REBID_1S:
  CALL: 1S
  PRIORITY: 27
  CONDITION: partner_last_call == 1D
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 16

RULE SUP_1NT_RESP_4NT_QUANT:
  CALL: 4NT
  PRIORITY: 27
  CONDITION: partner_last_call == 1NT
  CONDITION: is_balanced == True
  CONDITION: hcp >= 15
  CONDITION: hcp <= 16

RULE SUP_REBID_2NT:
  CALL: 2NT
  PRIORITY: 26
  CONDITION: partner_last_call == 1D
  CONDITION: is_balanced == True
  CONDITION: hcp >= 19
  CONDITION: hcp <= 21

RULE SUP_SPLINTER_4C_H:
  CALL: 4C
  PRIORITY: 26
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 4
  CONDITION: club_len <= 1
  CONDITION: hcp >= 11
  CONDITION: hcp <= 14

RULE SUP_SPLINTER_4D_H:
  CALL: 4D
  PRIORITY: 26
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 4
  CONDITION: diamond_len <= 1
  CONDITION: hcp >= 11
  CONDITION: hcp <= 14

RULE SUP_SPLINTER_4C_S:
  CALL: 4C
  PRIORITY: 26
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 4
  CONDITION: club_len <= 1
  CONDITION: hcp >= 11
  CONDITION: hcp <= 14

RULE SUP_SPLINTER_4D_S:
  CALL: 4D
  PRIORITY: 26
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 4
  CONDITION: diamond_len <= 1
  CONDITION: hcp >= 11
  CONDITION: hcp <= 14

RULE SUP_ACCEPT_4H_MAX:
  CALL: 4H
  PRIORITY: 26
  CONDITION: partner_last_call in ['3C', '3H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 13

RULE SUP_ACCEPT_4S_MAX:
  CALL: 4S
  PRIORITY: 26
  CONDITION: partner_last_call in ['3C', '3S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 13

RULE SUP_REBID_1NT:
  CALL: 1NT
  PRIORITY: 25
  CONDITION: partner_last_call == 1D
  CONDITION: is_balanced == True
  CONDITION: hcp >= 16
  CONDITION: hcp <= 18

RULE SUP_1NT_MINI:
  CALL: 1NT
  PRIORITY: 25
  CONDITION: is_opening == True
  CONDITION: hcp >= 14
  CONDITION: hcp <= 16
  CONDITION: is_balanced == True

RULE SUP_FLANNERY_RESP_4H:
  CALL: 4H
  PRIORITY: 25
  CONDITION: partner_last_call == 2D
  CONDITION: heart_len >= 3
  CONDITION: hcp >= 11

RULE SUP_JACOBY_2NT_H:
  CALL: 2NT
  PRIORITY: 25
  CONDITION: my_last_call == NONE
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 12

RULE SUP_JACOBY_2NT_S:
  CALL: 2NT
  PRIORITY: 25
  CONDITION: my_last_call == NONE
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 12

RULE SUP_COMPETITIVE_TAKEOUT_DBL:
  CALL: X
  PRIORITY: 25
  CONDITION: is_competitive == True
  CONDITION: hcp >= 12
  CONDITION: heart_len >= 3
  CONDITION: spade_len >= 3

RULE SUP_OPEN_FLANNERY_2D:
  CALL: 2D
  PRIORITY: 24
  CONDITION: is_opening == True
  CONDITION: hcp >= 11
  CONDITION: hcp <= 15
  CONDITION: heart_len == 5
  CONDITION: spade_len == 4

RULE SUP_RESP_4H:
  CALL: 4H
  PRIORITY: 24
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 3
  CONDITION: hcp >= 12

RULE SUP_RESP_4S:
  CALL: 4S
  PRIORITY: 24
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 3
  CONDITION: hcp >= 12

RULE SUP_BALANCING_1NT:
  CALL: 1NT
  PRIORITY: 24
  CONDITION: is_balancing == True
  CONDITION: hcp >= 11
  CONDITION: is_balanced == True

RULE SUP_2NT_RESP_3NT:
  CALL: 3NT
  PRIORITY: 23
  CONDITION: partner_last_call == 2NT
  CONDITION: hcp >= 4
  CONDITION: hcp <= 11

RULE SUP_BERGEN_3C_H:
  CALL: 3C
  PRIORITY: 23
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 10
  CONDITION: hcp <= 11

RULE SUP_BERGEN_3C_S:
  CALL: 3C
  PRIORITY: 23
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 10
  CONDITION: hcp <= 11

RULE SUP_BERGEN_3D_H:
  CALL: 3D
  PRIORITY: 23
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 6
  CONDITION: hcp <= 9

RULE SUP_BERGEN_3D_S:
  CALL: 3D
  PRIORITY: 23
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 6
  CONDITION: hcp <= 9

RULE SUP_PREEMPT_3H:
  CALL: 3H
  PRIORITY: 23
  CONDITION: is_opening == True
  CONDITION: heart_len >= 7
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE SUP_PREEMPT_3S:
  CALL: 3S
  PRIORITY: 23
  CONDITION: is_opening == True
  CONDITION: spade_len >= 7
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE SUP_BALANCING_1S:
  CALL: 1S
  PRIORITY: 23
  CONDITION: is_balancing == True
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 8

RULE SUP_BALANCING_1H:
  CALL: 1H
  PRIORITY: 23
  CONDITION: is_balancing == True
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 8

RULE SUP_OVERCALL_1S:
  CALL: 1S
  PRIORITY: 23
  CONDITION: is_competitive == True
  CONDITION: opp_last_call in ['1C', '1D', '1H']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 8
  CONDITION: hcp <= 18

RULE SUP_OVERCALL_1H:
  CALL: 1H
  PRIORITY: 23
  CONDITION: is_competitive == True
  CONDITION: opp_last_call in ['1C', '1D']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 8
  CONDITION: hcp <= 18

RULE SUP_RESP_2H_WEAK_OVER_1D:
  CALL: 2H
  PRIORITY: 19
  CONDITION: partner_last_call == 1D
  CONDITION: heart_len >= 6
  CONDITION: hcp <= 5

RULE SUP_1NT_RESP_3NT:
  CALL: 3NT
  PRIORITY: 22
  CONDITION: partner_last_call == 1NT
  CONDITION: is_balanced == True
  CONDITION: hcp >= 10
  CONDITION: hcp <= 14

RULE SUP_FLANNERY_RESP_2H:
  CALL: 2H
  PRIORITY: 22
  CONDITION: partner_last_call == 2D
  CONDITION: heart_len >= 3
  CONDITION: hcp <= 10

RULE SUP_PREEMPT_3C:
  CALL: 3C
  PRIORITY: 22
  CONDITION: is_opening == True
  CONDITION: club_len >= 7
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE SUP_PREEMPT_3D:
  CALL: 3D
  PRIORITY: 22
  CONDITION: is_opening == True
  CONDITION: diamond_len >= 7
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE SUP_2C_PREC:
  CALL: 2C
  PRIORITY: 21
  CONDITION: is_opening == True
  CONDITION: hcp >= 11
  CONDITION: hcp <= 15
  CONDITION: club_len >= 6

RULE SUP_1H_LIM:
  CALL: 1H
  PRIORITY: 20
  CONDITION: is_opening == True
  CONDITION: hcp >= 11
  CONDITION: hcp <= 15
  CONDITION: heart_len >= 5

RULE SUP_1S_LIM:
  CALL: 1S
  PRIORITY: 20
  CONDITION: is_opening == True
  CONDITION: hcp >= 11
  CONDITION: hcp <= 15
  CONDITION: spade_len >= 5

RULE SUP_RESP_1S_OVER_1H:
  CALL: 1S
  PRIORITY: 22
  CONDITION: partner_last_call == 1H
  CONDITION: spade_len >= 4
  CONDITION: heart_len <= 2
  CONDITION: hcp >= 6

RULE SUP_REBID_2S_OVER_1S:
  CALL: 2S
  PRIORITY: 21
  CONDITION: my_last_call == 1H
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 3

RULE SUP_INVITE_OR_BID_4S:
  CALL: 4S
  PRIORITY: 25
  CONDITION: my_last_call == 1S
  CONDITION: partner_last_call == 2S
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 8

RULE SUP_RESP_3S_LIMIT:
  CALL: 3S
  PRIORITY: 23
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 3
  CONDITION: hcp >= 10
  CONDITION: hcp <= 11

RULE SUP_ACCEPT_4S_AFTER_LIMIT:
  CALL: 4S
  PRIORITY: 26
  CONDITION: my_last_call == 1S
  CONDITION: partner_last_call == 3S
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 11

RULE SUP_WEAK_2H:
  CALL: 2H
  PRIORITY: 19
  CONDITION: is_opening == True
  CONDITION: heart_len == 6
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10
  CONDITION: is_balanced == False

RULE SUP_WEAK_2S:
  CALL: 2S
  PRIORITY: 19
  CONDITION: is_opening == True
  CONDITION: spade_len == 6
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10
  CONDITION: is_balanced == False

RULE SUP_RESP_2H:
  CALL: 2H
  PRIORITY: 18
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 3
  CONDITION: hcp >= 6
  CONDITION: hcp <= 9

RULE SUP_RESP_2S:
  CALL: 2S
  PRIORITY: 18
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 3
  CONDITION: hcp >= 6
  CONDITION: hcp <= 9

RULE SUP_RESP_1S_OVER_1D:
  CALL: 1S
  PRIORITY: 22
  CONDITION: partner_last_call == 1D
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 6
  CONDITION: hcp <= 15

RULE SUP_RESP_1H_OVER_1D:
  CALL: 1H
  PRIORITY: 22
  CONDITION: partner_last_call == 1D
  CONDITION: heart_len >= 4
  CONDITION: spade_len <= 3
  CONDITION: hcp >= 6
  CONDITION: hcp <= 15

RULE SUP_REBID_2S_OVER_1S_1D:
  CALL: 2S
  PRIORITY: 21
  CONDITION: my_last_call == 1D
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 4

RULE SUP_REBID_2C_OVER_1S_1D:
  CALL: 2C
  PRIORITY: 21
  CONDITION: my_last_call == 1D
  CONDITION: partner_last_call in ['1S', '1H']
  CONDITION: spade_len <= 3
  CONDITION: club_len >= 5
  CONDITION: hcp >= 11

RULE SUP_RESP_2S_OVER_1S_REBID:
  CALL: 2S
  PRIORITY: 22
  CONDITION: partner_last_call == 1S
  CONDITION: my_last_call == 1D
  CONDITION: spade_len >= 3
  CONDITION: hcp >= 3
  CONDITION: hcp <= 7

RULE SUP_RESP_2H_OVER_1H_REBID:
  CALL: 2H
  PRIORITY: 22
  CONDITION: partner_last_call == 1H
  CONDITION: my_last_call == 1D
  CONDITION: heart_len >= 3
  CONDITION: hcp >= 3
  CONDITION: hcp <= 7

RULE SUP_RESP_X_4S_JUMP:
  CALL: 4S
  PRIORITY: 24
  CONDITION: partner_last_call == X
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 11

RULE SUP_RESP_X_1S:
  CALL: 1S
  PRIORITY: 21
  CONDITION: partner_last_call == X
  CONDITION: spade_len >= 4
  CONDITION: hcp <= 10

RULE SUP_RESP_X_2S:
  CALL: 2S
  PRIORITY: 22
  CONDITION: partner_last_call == X
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 8
  CONDITION: hcp <= 10

RULE SUP_RESP_X_1H:
  CALL: 1H
  PRIORITY: 21
  CONDITION: partner_last_call == X
  CONDITION: heart_len >= 4
  CONDITION: spade_len <= 3
  CONDITION: hcp <= 10

RULE SUP_RESP_X_2C:
  CALL: 2C
  PRIORITY: 20
  CONDITION: partner_last_call == X
  CONDITION: club_len >= 4
  CONDITION: spade_len <= 3
  CONDITION: heart_len <= 3

RULE SUP_RESP_X_2D:
  CALL: 2D
  PRIORITY: 20
  CONDITION: partner_last_call == X
  CONDITION: diamond_len >= 4
  CONDITION: spade_len <= 3
  CONDITION: heart_len <= 3

RULE SUP_RAISE_4S_AFTER_1D_1S:
  CALL: 4S
  PRIORITY: 26
  CONDITION: my_last_call == 1D
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 14

RULE SUP_1D_LIM:
  CALL: 1D
  PRIORITY: 15
  CONDITION: is_opening == True
  CONDITION: hcp >= 11
  CONDITION: hcp <= 15
  CONDITION: diamond_len >= 2
  CONDITION: spade_len <= 4
  CONDITION: heart_len <= 4
