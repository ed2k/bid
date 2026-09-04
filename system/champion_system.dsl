# Auto-Generated Bridge Bidding System DSL: Singularity_Ultra_Precision
# Optimized with Strategic Defense, Sacrifice Protocols, and Native Bo Haglund DDSolver

RULE SUP_1C_STRONG                    PRIORITY 37 ACTION 1C    WHEN is_opening == True, hcp >= 16
RULE SUP_REBID_6S_OVER_1S             PRIORITY 37 ACTION 6S    WHEN partner_last_call == 1S, spade_len >= 3, hcp >= 20
RULE SUP_REBID_6H_OVER_1H             PRIORITY 37 ACTION 6H    WHEN partner_last_call == 1H, heart_len >= 3, hcp >= 20
RULE SUP_REBID_6NT_OVER_1NT           PRIORITY 37 ACTION 6NT   WHEN partner_last_call == 1NT, is_balanced == True, hcp >= 20
RULE SUP_SACRIFICE_4S_OVER_4H         PRIORITY 36 ACTION 4S    WHEN opp_last_call in ['4H', '3H'], spade_len >= 5, is_vulnerable == False
RULE SUP_SACRIFICE_5C_OVER_4M         PRIORITY 35 ACTION 5C    WHEN opp_last_call in ['4H', '4S'], club_len >= 6, is_vulnerable == False
RULE SUP_SACRIFICE_5D_OVER_4M         PRIORITY 35 ACTION 5D    WHEN opp_last_call in ['4H', '4S'], diamond_len >= 6, is_vulnerable == False
RULE SUP_REBID_4S_OVER_1S             PRIORITY 34 ACTION 4S    WHEN partner_last_call == 1S, spade_len >= 3, hcp >= 16
RULE SUP_REBID_4H_OVER_1H             PRIORITY 34 ACTION 4H    WHEN partner_last_call == 1H, heart_len >= 3, hcp >= 16
RULE SUP_RESP_3NT_POS                 PRIORITY 33 ACTION 3NT   WHEN partner_last_call == 1C, hcp >= 14, is_balanced == True
RULE SUP_REBID_3NT_OVER_POS           PRIORITY 33 ACTION 3NT   WHEN partner_last_call in ['1NT', '2C', '2D'], hcp >= 16
RULE SUP_RESP_1H_POS                  PRIORITY 32 ACTION 1H    WHEN partner_last_call == 1C, hcp >= 8, heart_len >= 5
RULE SUP_RESP_1S_POS                  PRIORITY 32 ACTION 1S    WHEN partner_last_call == 1C, hcp >= 8, spade_len >= 5
RULE SUP_REBID_3NT_OVER_1S            PRIORITY 31 ACTION 3NT   WHEN partner_last_call == 1S, spade_len <= 2, hcp >= 16
RULE SUP_REBID_3NT_OVER_1H            PRIORITY 31 ACTION 3NT   WHEN partner_last_call == 1H, heart_len <= 2, hcp >= 16
RULE SUP_RESP_1NT_POS                 PRIORITY 30 ACTION 1NT   WHEN partner_last_call == 1C, hcp >= 8, hcp <= 13, is_balanced == True
RULE SUP_OPEN_2NT                     PRIORITY 29 ACTION 2NT   WHEN is_opening == True, hcp >= 20, hcp <= 21, is_balanced == True
RULE SUP_2NT_RESP_6NT                 PRIORITY 29 ACTION 6NT   WHEN partner_last_call == 2NT, is_balanced == True, hcp >= 12
RULE SUP_RESP_1D_NEG                  PRIORITY 28 ACTION 1D    WHEN partner_last_call == 1C, hcp <= 7
RULE SUP_RESP_2C_POS                  PRIORITY 28 ACTION 2C    WHEN partner_last_call == 1C, hcp >= 8, club_len >= 5
RULE SUP_RESP_2D_POS                  PRIORITY 28 ACTION 2D    WHEN partner_last_call == 1C, hcp >= 8, diamond_len >= 5
RULE SUP_REBID_3NT                    PRIORITY 28 ACTION 3NT   WHEN partner_last_call == 1D, is_balanced == True, hcp >= 22
RULE SUP_GAME_4H_AFTER_RAISE          PRIORITY 29 ACTION 4H    WHEN partner_last_call in ['2H', '3H'], heart_len >= 5, hcp >= 16, hcp <= 22
RULE SUP_GAME_4H_WITH_LONG_SUIT      PRIORITY 29 ACTION 4H    WHEN my_last_call == 1H, partner_last_call == 2H, heart_len >= 6, hcp >= 13
RULE SUP_GAME_4S_AFTER_RAISE          PRIORITY 29 ACTION 4S    WHEN partner_last_call in ['2S', '3S'], spade_len >= 5, hcp >= 16, hcp <= 22
RULE SUP_GAME_4S_WITH_LONG_SUIT      PRIORITY 29 ACTION 4S    WHEN my_last_call == 1S, partner_last_call == 2S, spade_len >= 6, hcp >= 13
RULE SUP_SLAM_6H                      PRIORITY 28 ACTION 6H    WHEN partner_last_call in ['1H', '2H', '3H', '4H'], heart_len >= 5, hcp >= 23
RULE SUP_SLAM_6S                      PRIORITY 28 ACTION 6S    WHEN partner_last_call in ['1S', '2S', '3S', '4S'], spade_len >= 5, hcp >= 23
RULE SUP_REBID_1H                     PRIORITY 27 ACTION 1H    WHEN partner_last_call == 1D, heart_len >= 4, hcp >= 16
RULE SUP_REBID_1S                     PRIORITY 27 ACTION 1S    WHEN partner_last_call == 1D, spade_len >= 4, hcp >= 16
RULE SUP_1NT_RESP_4NT_QUANT           PRIORITY 27 ACTION 4NT   WHEN partner_last_call == 1NT, is_balanced == True, hcp >= 15, hcp <= 16
RULE SUP_REBID_2NT                    PRIORITY 26 ACTION 2NT   WHEN partner_last_call == 1D, is_balanced == True, hcp >= 19, hcp <= 21
RULE SUP_SPLINTER_4C_H                PRIORITY 26 ACTION 4C    WHEN partner_last_call == 1H, heart_len >= 4, club_len <= 1, hcp >= 11, hcp <= 14
RULE SUP_SPLINTER_4D_H                PRIORITY 26 ACTION 4D    WHEN partner_last_call == 1H, heart_len >= 4, diamond_len <= 1, hcp >= 11, hcp <= 14
RULE SUP_SPLINTER_4C_S                PRIORITY 26 ACTION 4C    WHEN partner_last_call == 1S, spade_len >= 4, club_len <= 1, hcp >= 11, hcp <= 14
RULE SUP_SPLINTER_4D_S                PRIORITY 26 ACTION 4D    WHEN partner_last_call == 1S, spade_len >= 4, diamond_len <= 1, hcp >= 11, hcp <= 14
RULE SUP_ACCEPT_4H_MAX                PRIORITY 26 ACTION 4H    WHEN partner_last_call in ['3C', '3H'], heart_len >= 5, hcp >= 13
RULE SUP_ACCEPT_4S_MAX                PRIORITY 26 ACTION 4S    WHEN partner_last_call in ['3C', '3S'], spade_len >= 5, hcp >= 13
RULE SUP_REBID_1NT                    PRIORITY 25 ACTION 1NT   WHEN partner_last_call == 1D, is_balanced == True, hcp >= 16, hcp <= 18
RULE SUP_1NT_MINI                     PRIORITY 25 ACTION 1NT   WHEN is_opening == True, hcp >= 14, hcp <= 16, is_balanced == True
RULE SUP_FLANNERY_RESP_4H             PRIORITY 25 ACTION 4H    WHEN partner_last_call == 2D, heart_len >= 3, hcp >= 11
RULE SUP_JACOBY_2NT_H                 PRIORITY 25 ACTION 2NT   WHEN my_last_call == NONE, partner_last_call == 1H, heart_len >= 4, hcp >= 12
RULE SUP_JACOBY_2NT_S                 PRIORITY 25 ACTION 2NT   WHEN my_last_call == NONE, partner_last_call == 1S, spade_len >= 4, hcp >= 12
RULE SUP_COMPETITIVE_TAKEOUT_DBL      PRIORITY 25 ACTION X     WHEN is_competitive == True, hcp >= 12, heart_len >= 3, spade_len >= 3
RULE SUP_OPEN_FLANNERY_2D             PRIORITY 24 ACTION 2D    WHEN is_opening == True, hcp >= 11, hcp <= 15, heart_len == 5, spade_len == 4
RULE SUP_RESP_4H                      PRIORITY 24 ACTION 4H    WHEN partner_last_call == 1H, heart_len >= 3, hcp >= 12
RULE SUP_RESP_4S                      PRIORITY 24 ACTION 4S    WHEN partner_last_call == 1S, spade_len >= 3, hcp >= 12
RULE SUP_BALANCING_1NT                PRIORITY 24 ACTION 1NT   WHEN is_balancing == True, hcp >= 11, is_balanced == True
RULE SUP_2NT_RESP_3NT                 PRIORITY 23 ACTION 3NT   WHEN partner_last_call == 2NT, hcp >= 4, hcp <= 11
RULE SUP_BERGEN_3C_H                  PRIORITY 23 ACTION 3C    WHEN partner_last_call == 1H, heart_len >= 4, hcp >= 10, hcp <= 11
RULE SUP_BERGEN_3C_S                  PRIORITY 23 ACTION 3C    WHEN partner_last_call == 1S, spade_len >= 4, hcp >= 10, hcp <= 11
RULE SUP_BERGEN_3D_H                  PRIORITY 23 ACTION 3D    WHEN partner_last_call == 1H, heart_len >= 4, hcp >= 6, hcp <= 9
RULE SUP_BERGEN_3D_S                  PRIORITY 23 ACTION 3D    WHEN partner_last_call == 1S, spade_len >= 4, hcp >= 6, hcp <= 9
RULE SUP_PREEMPT_3H                   PRIORITY 23 ACTION 3H    WHEN is_opening == True, heart_len >= 7, hcp >= 6, hcp <= 10
RULE SUP_PREEMPT_3S                   PRIORITY 23 ACTION 3S    WHEN is_opening == True, spade_len >= 7, hcp >= 6, hcp <= 10
RULE SUP_BALANCING_1S                 PRIORITY 23 ACTION 1S    WHEN is_balancing == True, spade_len >= 5, hcp >= 8
RULE SUP_BALANCING_1H                 PRIORITY 23 ACTION 1H    WHEN is_balancing == True, heart_len >= 5, hcp >= 8
RULE SUP_OVERCALL_1S                  PRIORITY 23 ACTION 1S    WHEN is_competitive == True, opp_last_call in ['1C', '1D', '1H'], spade_len >= 5, hcp >= 8, hcp <= 18
RULE SUP_OVERCALL_1H                  PRIORITY 23 ACTION 1H    WHEN is_competitive == True, opp_last_call in ['1C', '1D'], heart_len >= 5, hcp >= 8, hcp <= 18
RULE SUP_RESP_2H_WEAK_OVER_1D         PRIORITY 19 ACTION 2H    WHEN partner_last_call == 1D, heart_len >= 6, hcp <= 5
RULE SUP_1NT_RESP_3NT                 PRIORITY 22 ACTION 3NT   WHEN partner_last_call == 1NT, is_balanced == True, hcp >= 10, hcp <= 14
RULE SUP_FLANNERY_RESP_2H             PRIORITY 22 ACTION 2H    WHEN partner_last_call == 2D, heart_len >= 3, hcp <= 10
RULE SUP_PREEMPT_3C                   PRIORITY 22 ACTION 3C    WHEN is_opening == True, club_len >= 7, hcp >= 6, hcp <= 10
RULE SUP_PREEMPT_3D                   PRIORITY 22 ACTION 3D    WHEN is_opening == True, diamond_len >= 7, hcp >= 6, hcp <= 10
RULE SUP_2C_PREC                      PRIORITY 21 ACTION 2C    WHEN is_opening == True, hcp >= 11, hcp <= 15, club_len >= 6
RULE SUP_1H_LIM                       PRIORITY 20 ACTION 1H    WHEN is_opening == True, hcp >= 11, hcp <= 15, heart_len >= 5
RULE SUP_1S_LIM                       PRIORITY 20 ACTION 1S    WHEN is_opening == True, hcp >= 11, hcp <= 15, spade_len >= 5
RULE SUP_RESP_1S_OVER_1H              PRIORITY 22 ACTION 1S    WHEN partner_last_call == 1H, spade_len >= 4, heart_len <= 2, hcp >= 6
RULE SUP_REBID_2S_OVER_1S             PRIORITY 21 ACTION 2S    WHEN my_last_call == 1H, partner_last_call == 1S, spade_len >= 3
RULE SUP_INVITE_OR_BID_4S             PRIORITY 25 ACTION 4S    WHEN my_last_call == 1S, partner_last_call == 2S, spade_len >= 5, hcp >= 8
RULE SUP_RESP_3S_LIMIT                PRIORITY 23 ACTION 3S    WHEN partner_last_call == 1S, spade_len >= 3, hcp >= 10, hcp <= 11
RULE SUP_ACCEPT_4S_AFTER_LIMIT        PRIORITY 26 ACTION 4S    WHEN my_last_call == 1S, partner_last_call == 3S, spade_len >= 5, hcp >= 11
RULE SUP_WEAK_2H                      PRIORITY 19 ACTION 2H    WHEN is_opening == True, heart_len == 6, hcp >= 6, hcp <= 10, is_balanced == False
RULE SUP_WEAK_2S                      PRIORITY 19 ACTION 2S    WHEN is_opening == True, spade_len == 6, hcp >= 6, hcp <= 10, is_balanced == False
RULE SUP_RESP_2H                      PRIORITY 18 ACTION 2H    WHEN partner_last_call == 1H, heart_len >= 3, hcp >= 6, hcp <= 9
RULE SUP_RESP_2S                      PRIORITY 18 ACTION 2S    WHEN partner_last_call == 1S, spade_len >= 3, hcp >= 6, hcp <= 9
RULE SUP_RESP_1S_OVER_1D              PRIORITY 22 ACTION 1S    WHEN partner_last_call == 1D, spade_len >= 4, hcp >= 6, hcp <= 15
RULE SUP_RESP_1H_OVER_1D              PRIORITY 22 ACTION 1H    WHEN partner_last_call == 1D, heart_len >= 4, spade_len <= 3, hcp >= 6, hcp <= 15
RULE SUP_REBID_2S_OVER_1S_1D          PRIORITY 21 ACTION 2S    WHEN my_last_call == 1D, partner_last_call == 1S, spade_len >= 4
RULE SUP_REBID_2C_OVER_1S_1D          PRIORITY 21 ACTION 2C    WHEN my_last_call == 1D, partner_last_call in ['1S', '1H'], spade_len <= 3, club_len >= 5, hcp >= 11
RULE SUP_RESP_2S_OVER_1S_REBID        PRIORITY 22 ACTION 2S    WHEN partner_last_call == 1S, my_last_call == 1D, spade_len >= 3, hcp >= 3, hcp <= 7
RULE SUP_RESP_2H_OVER_1H_REBID        PRIORITY 22 ACTION 2H    WHEN partner_last_call == 1H, my_last_call == 1D, heart_len >= 3, hcp >= 3, hcp <= 7
RULE SUP_RESP_X_4S_JUMP               PRIORITY 24 ACTION 4S    WHEN partner_last_call == X, spade_len >= 4, hcp >= 11
RULE SUP_RESP_X_1S                    PRIORITY 21 ACTION 1S    WHEN partner_last_call == X, spade_len >= 4, hcp <= 10
RULE SUP_RESP_X_2S                    PRIORITY 22 ACTION 2S    WHEN partner_last_call == X, spade_len >= 4, hcp >= 8, hcp <= 10
RULE SUP_RESP_X_1H                    PRIORITY 21 ACTION 1H    WHEN partner_last_call == X, heart_len >= 4, spade_len <= 3, hcp <= 10
RULE SUP_RESP_X_2C                    PRIORITY 20 ACTION 2C    WHEN partner_last_call == X, club_len >= 4, spade_len <= 3, heart_len <= 3
RULE SUP_RESP_X_2D                    PRIORITY 20 ACTION 2D    WHEN partner_last_call == X, diamond_len >= 4, spade_len <= 3, heart_len <= 3
RULE SUP_RAISE_4S_AFTER_1D_1S         PRIORITY 26 ACTION 4S    WHEN my_last_call == 1D, partner_last_call == 1S, spade_len >= 4, hcp >= 14
RULE SUP_1D_LIM                       PRIORITY 15 ACTION 1D    WHEN is_opening == True, hcp >= 11, hcp <= 15, diamond_len >= 2, spade_len <= 4, heart_len <= 4



