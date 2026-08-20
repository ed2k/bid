# ==========================================
# IMPROVED BIDDING SYSTEM: Apex_Omega_Precision
# Generated via Continuous Self-Improvement Pipeline
# ==========================================

# --- Active Rules & Conventions ---

RULE AOP_1C_STRONG:
  CALL: 1C
  PRIORITY: 36
  CONDITION: is_opening == True
  CONDITION: hcp >= 16

RULE AOP_RESP_1D_NEG:
  CALL: 1D
  PRIORITY: 28
  CONDITION: partner_last_call == 1C
  CONDITION: hcp <= 7

RULE AOP_RESP_1H_POS:
  CALL: 1H
  PRIORITY: 31
  CONDITION: partner_last_call == 1C
  CONDITION: hcp >= 8
  CONDITION: heart_len >= 5

RULE AOP_RESP_1S_POS:
  CALL: 1S
  PRIORITY: 31
  CONDITION: partner_last_call == 1C
  CONDITION: hcp >= 8
  CONDITION: spade_len >= 5

RULE AOP_RESP_1NT_POS:
  CALL: 1NT
  PRIORITY: 29
  CONDITION: partner_last_call == 1C
  CONDITION: hcp >= 8
  CONDITION: hcp <= 13
  CONDITION: is_balanced == True

RULE AOP_RESP_2C_POS:
  CALL: 2C
  PRIORITY: 27
  CONDITION: partner_last_call == 1C
  CONDITION: hcp >= 8
  CONDITION: club_len >= 5

RULE AOP_RESP_2D_POS:
  CALL: 2D
  PRIORITY: 27
  CONDITION: partner_last_call == 1C
  CONDITION: hcp >= 8
  CONDITION: diamond_len >= 5

RULE AOP_RESP_3NT_POS:
  CALL: 3NT
  PRIORITY: 32
  CONDITION: partner_last_call == 1C
  CONDITION: hcp >= 14
  CONDITION: is_balanced == True

RULE AOP_REBID_1H:
  CALL: 1H
  PRIORITY: 27
  CONDITION: partner_last_call == 1D
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 16

RULE AOP_REBID_1S:
  CALL: 1S
  PRIORITY: 27
  CONDITION: partner_last_call == 1D
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 16

RULE AOP_REBID_1NT:
  CALL: 1NT
  PRIORITY: 25
  CONDITION: partner_last_call == 1D
  CONDITION: is_balanced == True
  CONDITION: hcp >= 16
  CONDITION: hcp <= 18

RULE AOP_REBID_2NT:
  CALL: 2NT
  PRIORITY: 26
  CONDITION: partner_last_call == 1D
  CONDITION: is_balanced == True
  CONDITION: hcp >= 19
  CONDITION: hcp <= 21

RULE AOP_REBID_3NT:
  CALL: 3NT
  PRIORITY: 28
  CONDITION: partner_last_call == 1D
  CONDITION: is_balanced == True
  CONDITION: hcp >= 22

RULE AOP_1NT_MINI:
  CALL: 1NT
  PRIORITY: 25
  CONDITION: is_opening == True
  CONDITION: hcp >= 14
  CONDITION: hcp <= 16
  CONDITION: is_balanced == True

RULE AOP_1NT_RESP_3NT:
  CALL: 3NT
  PRIORITY: 22
  CONDITION: partner_last_call == 1NT
  CONDITION: is_balanced == True
  CONDITION: hcp >= 10

RULE AOP_OPEN_2NT:
  CALL: 2NT
  PRIORITY: 29
  CONDITION: is_opening == True
  CONDITION: hcp >= 20
  CONDITION: hcp <= 21
  CONDITION: is_balanced == True

RULE AOP_2NT_RESP_3NT:
  CALL: 3NT
  PRIORITY: 23
  CONDITION: partner_last_call == 2NT
  CONDITION: hcp >= 4

RULE AOP_OPEN_FLANNERY_2D:
  CALL: 2D
  PRIORITY: 24
  CONDITION: is_opening == True
  CONDITION: hcp >= 11
  CONDITION: hcp <= 15
  CONDITION: heart_len == 5
  CONDITION: spade_len == 4

RULE AOP_FLANNERY_RESP_2H:
  CALL: 2H
  PRIORITY: 22
  CONDITION: partner_last_call == 2D
  CONDITION: heart_len >= 3
  CONDITION: hcp <= 10

RULE AOP_FLANNERY_RESP_4H:
  CALL: 4H
  PRIORITY: 25
  CONDITION: partner_last_call == 2D
  CONDITION: heart_len >= 3
  CONDITION: hcp >= 11

RULE AOP_1H_LIM:
  CALL: 1H
  PRIORITY: 20
  CONDITION: is_opening == True
  CONDITION: hcp >= 11
  CONDITION: hcp <= 15
  CONDITION: heart_len >= 5

RULE AOP_1S_LIM:
  CALL: 1S
  PRIORITY: 20
  CONDITION: is_opening == True
  CONDITION: hcp >= 11
  CONDITION: hcp <= 15
  CONDITION: spade_len >= 5

RULE AOP_1D_LIM:
  CALL: 1D
  PRIORITY: 15
  CONDITION: is_opening == True
  CONDITION: hcp >= 11
  CONDITION: hcp <= 15
  CONDITION: diamond_len >= 2

RULE AOP_BERGEN_3C_H:
  CALL: 3C
  PRIORITY: 23
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 10
  CONDITION: hcp <= 11

RULE AOP_BERGEN_3C_S:
  CALL: 3C
  PRIORITY: 23
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 10
  CONDITION: hcp <= 11

RULE AOP_BERGEN_3D_H:
  CALL: 3D
  PRIORITY: 23
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 6
  CONDITION: hcp <= 9

RULE AOP_BERGEN_3D_S:
  CALL: 3D
  PRIORITY: 23
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 6
  CONDITION: hcp <= 9

RULE AOP_JACOBY_2NT_H:
  CALL: 2NT
  PRIORITY: 25
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 12

RULE AOP_JACOBY_2NT_S:
  CALL: 2NT
  PRIORITY: 25
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 12

RULE AOP_ACCEPT_4H_MAX:
  CALL: 4H
  PRIORITY: 26
  CONDITION: partner_last_call in ['3C', '3H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 13

RULE AOP_ACCEPT_4S_MAX:
  CALL: 4S
  PRIORITY: 26
  CONDITION: partner_last_call in ['3C', '3S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 13

RULE AOP_RESP_2H:
  CALL: 2H
  PRIORITY: 18
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 3
  CONDITION: hcp >= 6
  CONDITION: hcp <= 9

RULE AOP_RESP_4H:
  CALL: 4H
  PRIORITY: 24
  CONDITION: partner_last_call == 1H
  CONDITION: heart_len >= 4
  CONDITION: hcp >= 12

RULE AOP_RESP_2S:
  CALL: 2S
  PRIORITY: 18
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 3
  CONDITION: hcp >= 6
  CONDITION: hcp <= 9

RULE AOP_RESP_4S:
  CALL: 4S
  PRIORITY: 24
  CONDITION: partner_last_call == 1S
  CONDITION: spade_len >= 4
  CONDITION: hcp >= 12

RULE AOP_2C_PREC:
  CALL: 2C
  PRIORITY: 21
  CONDITION: is_opening == True
  CONDITION: hcp >= 11
  CONDITION: hcp <= 15
  CONDITION: club_len >= 6

RULE AOP_WEAK_2H:
  CALL: 2H
  PRIORITY: 19
  CONDITION: is_opening == True
  CONDITION: heart_len == 6
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10
  CONDITION: is_balanced == False

RULE AOP_WEAK_2S:
  CALL: 2S
  PRIORITY: 19
  CONDITION: is_opening == True
  CONDITION: spade_len == 6
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10
  CONDITION: is_balanced == False

RULE AOP_PREEMPT_3C:
  CALL: 3C
  PRIORITY: 22
  CONDITION: is_opening == True
  CONDITION: club_len >= 7
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE AOP_PREEMPT_3D:
  CALL: 3D
  PRIORITY: 22
  CONDITION: is_opening == True
  CONDITION: diamond_len >= 7
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE AOP_PREEMPT_3H:
  CALL: 3H
  PRIORITY: 23
  CONDITION: is_opening == True
  CONDITION: heart_len >= 7
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE AOP_PREEMPT_3S:
  CALL: 3S
  PRIORITY: 23
  CONDITION: is_opening == True
  CONDITION: spade_len >= 7
  CONDITION: hcp >= 6
  CONDITION: hcp <= 10

RULE AOP_SLAM_6H:
  CALL: 6H
  PRIORITY: 28
  CONDITION: partner_last_call in ['1H', '2H', '3H', '4H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 18

RULE AOP_SLAM_6S:
  CALL: 6S
  PRIORITY: 28
  CONDITION: partner_last_call in ['1S', '2S', '3S', '4S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 18

RULE AOP_SLAM_6NT:
  CALL: 6NT
  PRIORITY: 28
  CONDITION: partner_last_call in ['1NT', '2NT', '3NT']
  CONDITION: is_balanced == True
  CONDITION: hcp >= 17

RULE AOP_GRAND_7H:
  CALL: 7H
  PRIORITY: 34
  CONDITION: partner_last_call in ['4H', '6H']
  CONDITION: heart_len >= 5
  CONDITION: hcp >= 22
  CONDITION: controls >= 8

RULE AOP_GRAND_7S:
  CALL: 7S
  PRIORITY: 34
  CONDITION: partner_last_call in ['4S', '6S']
  CONDITION: spade_len >= 5
  CONDITION: hcp >= 22
  CONDITION: controls >= 8
