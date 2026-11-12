# Exported from DiffDSLNet (brill_gpu_evolved) — 1855 active rules

RULE BD_open_uncont_P0:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total <= 19.5
  CONDITION: auction_len <= 2.5

RULE BD_open_uncont_P1:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total <= 19.5
  CONDITION: auction_len > 2.5
  CONDITION: spade_len <= 4.5

RULE BD_open_uncont_P2:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total <= 19.5
  CONDITION: auction_len > 2.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 9.5

RULE BD_open_uncont_P3:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total <= 19.5
  CONDITION: auction_len > 2.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 9.5

RULE BD_open_uncont_P4:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len <= 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len <= 3.5

RULE BD_open_uncont_P5:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len <= 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5

RULE BD_open_uncont_P6:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len <= 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_vulnerable <= 0.5

RULE BD_open_uncont_P7:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: auction_len <= 2.5
  CONDITION: spade_len <= 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_vulnerable > 0.5

RULE BD_open_uncont_P8:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: auction_len > 2.5
  CONDITION: spade_len <= 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_vulnerable > 0.5

RULE BD_open_uncont_P9:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: auction_len <= 2.5
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: heart_len <= 3.5

RULE BD_open_uncont_P10:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: auction_len > 2.5
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: heart_len <= 3.5

RULE BD_open_uncont_P11:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 10.5

RULE BD_open_uncont_P12:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 10.5

RULE BD_open_uncont_P13:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: auction_len <= 2.5
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: heart_len > 3.5

RULE BD_open_uncont_P14:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: auction_len > 2.5
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: heart_len > 3.5

RULE BD_open_uncont_P15:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len <= 4.0
  CONDITION: heart_len <= 4.0

RULE BD_open_uncont_P16:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len <= 4.0
  CONDITION: heart_len > 4.0

RULE BD_open_uncont_P17:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len > 4.0

RULE BD_open_uncont_P18:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len <= 2.5
  CONDITION: is_favorable_vuln <= 0.5

RULE BD_open_uncont_P19:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len <= 2.5
  CONDITION: is_favorable_vuln > 0.5

RULE BD_open_uncont_P20:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten <= 0.5
  CONDITION: heart_len <= 0.5

RULE BD_open_uncont_P21:
  PRIORITY: 10
  CALL: 1C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten <= 0.5
  CONDITION: heart_len > 0.5

RULE BD_open_uncont_P22:
  PRIORITY: 10
  CALL: 1C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten <= 0.5

RULE BD_open_uncont_P23:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten > 0.5
  CONDITION: shape_pattern == '5332'

RULE BD_open_uncont_P24:
  PRIORITY: 10
  CALL: 1C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: major_hcp <= 7.5

RULE BD_open_uncont_P25:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: major_hcp > 7.5

RULE BD_open_uncont_P26:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: h_has_king <= 0.5

RULE BD_open_uncont_P27:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: h_has_ten <= 0.5
  CONDITION: h_has_king > 0.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: d_has_ten <= 0.5

RULE BD_open_uncont_P28:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: h_has_ten <= 0.5
  CONDITION: h_has_king > 0.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: d_has_ten > 0.5

RULE BD_open_uncont_P29:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: h_has_ten > 0.5
  CONDITION: h_has_king > 0.5
  CONDITION: c_is_best_minor <= 0.5

RULE BD_open_uncont_P30:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: h_has_king > 0.5
  CONDITION: c_is_best_minor > 0.5

RULE BD_open_uncont_P31:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len <= 2.5

RULE BD_open_uncont_P32:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: major_hcp <= 5.5

RULE BD_open_uncont_P33:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: major_hcp > 5.5
  CONDITION: s_has_ten <= 0.5
  CONDITION: my_seat == 'E'

RULE BD_open_uncont_P34:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten <= 0.5
  CONDITION: major_hcp > 5.5
  CONDITION: s_has_ten <= 0.5
  CONDITION: my_seat != 'E'

RULE BD_open_uncont_P35:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten > 0.5
  CONDITION: major_hcp > 5.5
  CONDITION: s_has_ten <= 0.5
  CONDITION: my_seat != 'E'

RULE BD_open_uncont_P36:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: major_hcp > 5.5
  CONDITION: s_has_ten > 0.5

RULE BD_open_uncont_P37:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: club_len <= 3.5

RULE BD_open_uncont_P38:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 3.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: club_len <= 3.5

RULE BD_open_uncont_P39:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: club_len > 3.5

RULE BD_open_uncont_P40:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5

RULE BD_open_uncont_P41:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: controls > 4.5
  CONDITION: major_hcp <= 5.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: c_stopper <= 1.0
  CONDITION: spade_len <= 1.5

RULE BD_open_uncont_P42:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: controls > 4.5
  CONDITION: major_hcp > 5.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: c_stopper <= 1.0
  CONDITION: spade_len <= 1.5

RULE BD_open_uncont_P43:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: c_stopper <= 1.0
  CONDITION: spade_len > 1.5

RULE BD_open_uncont_P44:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: controls > 4.5
  CONDITION: h_has_king <= 0.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: c_stopper > 1.0
  CONDITION: heart_len <= 1.5

RULE BD_open_uncont_P45:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: controls > 4.5
  CONDITION: h_has_king <= 0.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: c_stopper > 1.0
  CONDITION: heart_len > 1.5
  CONDITION: shortest_suit_len <= 2.5

RULE BD_open_uncont_P46:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: controls > 4.5
  CONDITION: h_has_king <= 0.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: c_stopper > 1.0
  CONDITION: heart_len > 1.5
  CONDITION: shortest_suit_len > 2.5

RULE BD_open_uncont_P47:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: controls > 4.5
  CONDITION: h_has_king > 0.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: c_stopper > 1.0

RULE BD_open_uncont_P48:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len <= 6.5
  CONDITION: quick_tricks <= 2.75

RULE BD_open_uncont_P49:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len <= 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len <= 6.5
  CONDITION: quick_tricks > 2.75

RULE BD_open_uncont_P50:
  PRIORITY: 10
  CALL: 1C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len > 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len <= 6.5
  CONDITION: quick_tricks > 2.75

RULE BD_open_uncont_P51:
  PRIORITY: 10
  CALL: 3C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len <= 6.5

RULE BD_open_uncont_P52:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: hcp <= 4.5

RULE BD_open_uncont_P53:
  PRIORITY: 10
  CALL: 3C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: hcp > 4.5

RULE BD_open_uncont_P54:
  PRIORITY: 10
  CALL: 4C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: hcp > 4.5

RULE BD_open_uncont_P55:
  PRIORITY: 10
  CALL: 3C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: hcp > 4.5
  CONDITION: club_hcp <= 7.5

RULE BD_open_uncont_P56:
  PRIORITY: 10
  CALL: 3C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: hcp > 4.5
  CONDITION: club_hcp > 7.5

RULE BD_open_uncont_P57:
  PRIORITY: 10
  CALL: 4C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: auction_len <= 2.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: club_len <= 7.5

RULE BD_open_uncont_P58:
  PRIORITY: 10
  CALL: 3C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: auction_len > 2.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: club_len <= 7.5

RULE BD_open_uncont_P59:
  PRIORITY: 10
  CALL: 5C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: club_len > 7.5
  CONDITION: major_hcp <= 3.5
  CONDITION: auction_len <= 1.5

RULE BD_open_uncont_P60:
  PRIORITY: 10
  CALL: 1C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: club_len > 7.5
  CONDITION: major_hcp <= 3.5
  CONDITION: auction_len > 1.5

RULE BD_open_uncont_P61:
  PRIORITY: 10
  CALL: 1C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: club_len > 7.5
  CONDITION: major_hcp > 3.5

RULE BD_open_uncont_P62:
  PRIORITY: 10
  CALL: 2D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: d_top3_honors <= 1.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln <= 0.5

RULE BD_open_uncont_P63:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: d_top3_honors <= 1.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5

RULE BD_open_uncont_P64:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: d_top3_honors <= 1.5
  CONDITION: losing_trick_count > 7.5

RULE BD_open_uncont_P65:
  PRIORITY: 10
  CALL: 2D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: d_top3_honors <= 1.5
  CONDITION: losing_trick_count > 7.5

RULE BD_open_uncont_P66:
  PRIORITY: 10
  CALL: 2D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: d_top3_honors > 1.5
  CONDITION: second_longest_len <= 4.5

RULE BD_open_uncont_P67:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: controls > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: d_top3_honors > 1.5
  CONDITION: second_longest_len <= 4.5

RULE BD_open_uncont_P68:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: club_len <= 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: d_top3_honors > 1.5
  CONDITION: second_longest_len > 4.5

RULE BD_open_uncont_P69:
  PRIORITY: 10
  CALL: 2D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: club_len > 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: d_top3_honors > 1.5
  CONDITION: second_longest_len > 4.5

RULE BD_open_uncont_P70:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5

RULE BD_open_uncont_P71:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp <= 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5

RULE BD_open_uncont_P72:
  PRIORITY: 10
  CALL: 3D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp > 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5

RULE BD_open_uncont_P73:
  PRIORITY: 10
  CALL: 2D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp > 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5

RULE BD_open_uncont_P74:
  PRIORITY: 10
  CALL: 2D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp > 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: diamond_len <= 7.5

RULE BD_open_uncont_P75:
  PRIORITY: 10
  CALL: 4D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp > 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: diamond_len > 7.5

RULE BD_open_uncont_P76:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: auction_len <= 2.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: diamond_len <= 7.5

RULE BD_open_uncont_P77:
  PRIORITY: 10
  CALL: 3D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: auction_len > 2.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: diamond_len <= 7.5

RULE BD_open_uncont_P78:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: diamond_len > 7.5
  CONDITION: minor_hcp <= 9.5

RULE BD_open_uncont_P79:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: diamond_len > 7.5
  CONDITION: minor_hcp > 9.5

RULE BD_open_uncont_P80:
  PRIORITY: 10
  CALL: 5D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: diamond_len > 7.5

RULE BD_open_uncont_P81:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 19.5
  CONDITION: spade_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: h_top3_honors <= 1.5

RULE BD_open_uncont_P82:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 19.5
  CONDITION: spade_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: h_top3_honors <= 1.5

RULE BD_open_uncont_P83:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 19.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: h_top3_honors <= 1.5

RULE BD_open_uncont_P84:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 19.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: h_top3_honors <= 1.5

RULE BD_open_uncont_P85:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 19.5
  CONDITION: auction_len <= 2.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: h_top3_honors <= 1.5

RULE BD_open_uncont_P86:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 19.5
  CONDITION: auction_len > 2.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: h_top3_honors <= 1.5

RULE BD_open_uncont_P87:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 19.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: h_top3_honors <= 1.5
  CONDITION: total_points <= 7.5

RULE BD_open_uncont_P88:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 19.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: h_top3_honors <= 1.5
  CONDITION: total_points > 7.5

RULE BD_open_uncont_P89:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 19.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: h_top3_honors > 1.5

RULE BD_open_uncont_P90:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 19.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: h_top3_honors > 1.5

RULE BD_open_uncont_P91:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 19.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: h_top3_honors > 1.5

RULE BD_open_uncont_P92:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 19.5
  CONDITION: spade_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: h_top3_honors > 1.5

RULE BD_open_uncont_P93:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: hcp <= 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5

RULE BD_open_uncont_P94:
  PRIORITY: 10
  CALL: 3H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: auction_len <= 2.5
  CONDITION: rule20_total > 19.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: hcp > 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5

RULE BD_open_uncont_P95:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: auction_len > 2.5
  CONDITION: rule20_total > 19.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: hcp > 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5

RULE BD_open_uncont_P96:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5

RULE BD_open_uncont_P97:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5

RULE BD_open_uncont_P98:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: controls > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5

RULE BD_open_uncont_P99:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: auction_len <= 2.5
  CONDITION: rule20_total > 19.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5

RULE BD_open_uncont_P100:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: auction_len > 2.5
  CONDITION: rule20_total > 19.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5

RULE BD_open_uncont_P101:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: hcp <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5

RULE BD_open_uncont_P102:
  PRIORITY: 10
  CALL: 4H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: hcp > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: losing_trick_count <= 5.5

RULE BD_open_uncont_P103:
  PRIORITY: 10
  CALL: 3H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: hcp > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: losing_trick_count > 5.5

RULE BD_open_uncont_P104:
  PRIORITY: 10
  CALL: 3H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: hcp > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: hcp <= 5.5

RULE BD_open_uncont_P105:
  PRIORITY: 10
  CALL: 4H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: hcp > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: hcp > 5.5

RULE BD_open_uncont_P106:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: hcp > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5

RULE BD_open_uncont_P107:
  PRIORITY: 10
  CALL: 4H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len <= 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: major_hcp <= 9.5
  CONDITION: rule20_total <= 21.5

RULE BD_open_uncont_P108:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len <= 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: major_hcp <= 9.5
  CONDITION: rule20_total <= 21.5

RULE BD_open_uncont_P109:
  PRIORITY: 10
  CALL: 4H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len <= 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: major_hcp <= 9.5
  CONDITION: rule20_total > 21.5

RULE BD_open_uncont_P110:
  PRIORITY: 10
  CALL: 3H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len <= 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: major_hcp > 9.5

RULE BD_open_uncont_P111:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: club_len <= 3.5
  CONDITION: spade_len > 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: heart_len <= 8.5
  CONDITION: h_has_queen <= 0.5

RULE BD_open_uncont_P112:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: club_len <= 3.5
  CONDITION: spade_len > 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: heart_len <= 8.5
  CONDITION: h_has_queen > 0.5

RULE BD_open_uncont_P113:
  PRIORITY: 10
  CALL: 4H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: club_len > 3.5
  CONDITION: spade_len > 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: heart_len <= 8.5

RULE BD_open_uncont_P114:
  PRIORITY: 10
  CALL: 5H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len > 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: heart_len > 8.5

RULE BD_open_uncont_P115:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5

RULE BD_open_uncont_P116:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: heart_len <= 4.5
  CONDITION: hcp <= 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5

RULE BD_open_uncont_P117:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5

RULE BD_open_uncont_P118:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 10.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors <= 1.5

RULE BD_open_uncont_P119:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 10.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors <= 1.5

RULE BD_open_uncont_P120:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp <= 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors > 1.5

RULE BD_open_uncont_P121:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors > 1.5

RULE BD_open_uncont_P122:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: auction_len <= 2.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: hcp > 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5

RULE BD_open_uncont_P123:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: auction_len > 2.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: hcp > 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5

RULE BD_open_uncont_P124:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: hcp > 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors <= 1.5

RULE BD_open_uncont_P125:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: hcp > 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors <= 1.5

RULE BD_open_uncont_P126:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: hcp > 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors > 1.5

RULE BD_open_uncont_P127:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: hcp > 10.5
  CONDITION: controls > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors > 1.5

RULE BD_open_uncont_P128:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: auction_len <= 2.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5

RULE BD_open_uncont_P129:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: auction_len > 2.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5

RULE BD_open_uncont_P130:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: quick_tricks <= 2.25

RULE BD_open_uncont_P131:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: quick_tricks > 2.25

RULE BD_open_uncont_P132:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: total_points <= 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors <= 1.5

RULE BD_open_uncont_P133:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: total_points <= 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: losing_trick_count <= 8.5

RULE BD_open_uncont_P134:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: total_points <= 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: losing_trick_count > 8.5

RULE BD_open_uncont_P135:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: hcp <= 10.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: total_points > 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: losing_trick_count <= 8.5

RULE BD_open_uncont_P136:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: hcp <= 10.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: total_points > 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: losing_trick_count > 8.5

RULE BD_open_uncont_P137:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: hcp > 10.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: total_points > 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors <= 1.5

RULE BD_open_uncont_P138:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: hcp <= 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors > 1.5

RULE BD_open_uncont_P139:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: hcp > 10.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: s_top3_honors > 1.5

RULE BD_open_uncont_P140:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp <= 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5

RULE BD_open_uncont_P141:
  PRIORITY: 10
  CALL: 3S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: hcp <= 6.5

RULE BD_open_uncont_P142:
  PRIORITY: 10
  CALL: 4S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: hcp > 6.5

RULE BD_open_uncont_P143:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: hcp <= 8.0

RULE BD_open_uncont_P144:
  PRIORITY: 10
  CALL: 3S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: hcp > 8.0

RULE BD_open_uncont_P145:
  PRIORITY: 10
  CALL: 3S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: major_hcp <= 10.5

RULE BD_open_uncont_P146:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: major_hcp > 10.5

RULE BD_open_uncont_P147:
  PRIORITY: 10
  CALL: 5S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: hcp <= 6.5

RULE BD_open_uncont_P148:
  PRIORITY: 10
  CALL: 4S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: hcp > 6.5

RULE BD_open_uncont_P149:
  PRIORITY: 10
  CALL: 3S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: minor_hcp <= 5.5

RULE BD_open_uncont_P150:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: minor_hcp > 5.5

RULE BD_open_uncont_P151:
  PRIORITY: 10
  CALL: 4S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5

RULE BD_open_uncont_P152:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: auction_len <= 2.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: diamond_hcp <= 3.5

RULE BD_open_uncont_P153:
  PRIORITY: 10
  CALL: 3S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: auction_len > 2.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: diamond_hcp <= 3.5

RULE BD_open_uncont_P154:
  PRIORITY: 10
  CALL: 4S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: diamond_hcp > 3.5

RULE BD_open_uncont_P155:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: heart_len <= 3.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5

RULE BD_open_uncont_P156:
  PRIORITY: 10
  CALL: 3S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: heart_len > 3.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5

RULE BD_open_uncont_P157:
  PRIORITY: 10
  CALL: 4S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5

RULE BD_open_uncont_P159:
  PRIORITY: 10
  CALL: 1C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 14.5

RULE BD_open_uncont_P160:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points <= 17.5
  CONDITION: is_semi_balanced <= 0.5

RULE BD_open_uncont_P161:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points <= 17.5
  CONDITION: is_semi_balanced > 0.5

RULE BD_open_uncont_P162:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len <= 2.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 17.5

RULE BD_open_uncont_P163:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len <= 2.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 17.5

RULE BD_open_uncont_P164:
  PRIORITY: 10
  CALL: 1C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 17.5

RULE BD_open_uncont_P165:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 17.5

RULE BD_open_uncont_P166:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 17.5
  CONDITION: losing_trick_count <= 2.5

RULE BD_open_uncont_P167:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 2.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 17.5
  CONDITION: losing_trick_count > 2.5

RULE BD_open_uncont_P168:
  PRIORITY: 10
  CALL: 1C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: diamond_hcp <= 1.5

RULE BD_open_uncont_P169:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: diamond_hcp > 1.5

RULE BD_open_uncont_P170:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5

RULE BD_open_uncont_P171:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5
  CONDITION: hcp <= 24.5

RULE BD_open_uncont_P172:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5
  CONDITION: hcp > 24.5

RULE BD_open_uncont_P173:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: diamond_len <= 6.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 14.5

RULE BD_open_uncont_P174:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len <= 2.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: diamond_len > 6.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 14.5

RULE BD_open_uncont_P175:
  PRIORITY: 10
  CALL: 4D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: heart_len <= 1.5
  CONDITION: diamond_len > 6.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 14.5
  CONDITION: hcp <= 12.5

RULE BD_open_uncont_P176:
  PRIORITY: 10
  CALL: 3D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: heart_len > 1.5
  CONDITION: diamond_len > 6.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 14.5
  CONDITION: hcp <= 12.5

RULE BD_open_uncont_P177:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: diamond_len > 6.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 14.5
  CONDITION: hcp > 12.5

RULE BD_open_uncont_P178:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points <= 17.5
  CONDITION: is_semi_balanced <= 0.5

RULE BD_open_uncont_P179:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points <= 17.5
  CONDITION: is_semi_balanced > 0.5

RULE BD_open_uncont_P180:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 17.5
  CONDITION: total_points <= 20.5

RULE BD_open_uncont_P181:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 17.5
  CONDITION: total_points > 20.5

RULE BD_open_uncont_P182:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 17.5

RULE BD_open_uncont_P183:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 17.5

RULE BD_open_uncont_P184:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: losing_trick_count <= 3.5

RULE BD_open_uncont_P185:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: losing_trick_count > 1.5

RULE BD_open_uncont_P186:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5

RULE BD_open_uncont_P187:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5
  CONDITION: hcp <= 24.5

RULE BD_open_uncont_P188:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5
  CONDITION: hcp > 24.5
  CONDITION: total_points <= 27.5

RULE BD_open_uncont_P189:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5
  CONDITION: hcp > 24.5
  CONDITION: total_points > 27.5

RULE BD_open_uncont_P190:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 14.5
  CONDITION: hcp <= 19.5

RULE BD_open_uncont_P191:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 16.5

RULE BD_open_uncont_P192:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 16.5

RULE BD_open_uncont_P193:
  PRIORITY: 10
  CALL: 1C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: club_len <= 6.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len <= 4.0

RULE BD_open_uncont_P194:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: club_len > 6.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len <= 4.0

RULE BD_open_uncont_P195:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: losing_trick_count <= 2.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len > 4.0

RULE BD_open_uncont_P196:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: losing_trick_count > 2.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len > 4.0

RULE BD_open_uncont_P197:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: h_is_longest > 0.5
  CONDITION: rule20_total <= 27.5

RULE BD_open_uncont_P198:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: minor_hcp <= 9.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 17.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: h_is_longest > 0.5
  CONDITION: rule20_total > 27.5

RULE BD_open_uncont_P199:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: minor_hcp <= 9.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 17.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: h_is_longest > 0.5
  CONDITION: rule20_total > 27.5

RULE BD_open_uncont_P200:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: minor_hcp > 9.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: h_is_longest > 0.5
  CONDITION: rule20_total > 27.5

RULE BD_open_uncont_P201:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len <= 2.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: h_is_longest > 0.5

RULE BD_open_uncont_P202:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: heart_len <= 5.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 12.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: h_is_longest > 0.5

RULE BD_open_uncont_P203:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 12.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: h_is_longest > 0.5

RULE BD_open_uncont_P204:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 12.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: h_is_longest > 0.5
  CONDITION: heart_len <= 7.5

RULE BD_open_uncont_P205:
  PRIORITY: 10
  CALL: 4H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 12.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: h_is_longest > 0.5
  CONDITION: heart_len > 7.5

RULE BD_open_uncont_P206:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 19.5
  CONDITION: total_points <= 21.5
  CONDITION: shortest_suit_len <= 1.5

RULE BD_open_uncont_P207:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 19.5
  CONDITION: total_points <= 21.5
  CONDITION: shortest_suit_len > 1.5

RULE BD_open_uncont_P208:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 19.5
  CONDITION: total_points <= 21.5
  CONDITION: losing_trick_count <= 4.5

RULE BD_open_uncont_P209:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 19.5
  CONDITION: total_points <= 21.5
  CONDITION: losing_trick_count > 4.5
  CONDITION: major_hcp <= 10.0

RULE BD_open_uncont_P210:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 19.5
  CONDITION: total_points <= 21.5
  CONDITION: losing_trick_count > 4.5
  CONDITION: major_hcp > 10.0

RULE BD_open_uncont_P211:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: losing_trick_count <= 2.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: total_points > 21.5

RULE BD_open_uncont_P212:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: losing_trick_count > 2.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: total_points > 21.5

RULE BD_open_uncont_P213:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: total_points > 21.5

RULE BD_open_uncont_P214:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: total_points > 21.5

RULE BD_open_uncont_P215:
  PRIORITY: 10
  CALL: 3H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5
  CONDITION: total_points > 21.5

RULE BD_open_uncont_P216:
  PRIORITY: 10
  CALL: 1C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.0
  CONDITION: s_is_longest <= 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: diamond_len <= 4.0

RULE BD_open_uncont_P217:
  PRIORITY: 10
  CALL: 1D
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.0
  CONDITION: s_is_longest <= 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: diamond_len > 4.0

RULE BD_open_uncont_P218:
  PRIORITY: 10
  CALL: 1H
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.0
  CONDITION: s_is_longest <= 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5

RULE BD_open_uncont_P219:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 14.5
  CONDITION: hcp <= 19.5

RULE BD_open_uncont_P220:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 16.5

RULE BD_open_uncont_P221:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 16.5

RULE BD_open_uncont_P222:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len <= 2.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total <= 28.5

RULE BD_open_uncont_P223:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total <= 28.5
  CONDITION: major_hcp <= 9.0

RULE BD_open_uncont_P224:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total <= 28.5
  CONDITION: major_hcp > 9.0

RULE BD_open_uncont_P225:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: second_longest_len <= 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total > 28.5

RULE BD_open_uncont_P226:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: second_longest_len > 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: losing_trick_count <= 2.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total > 28.5

RULE BD_open_uncont_P227:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: second_longest_len > 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: losing_trick_count > 2.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total > 28.5

RULE BD_open_uncont_P228:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len <= 2.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 17.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: shape_pattern == '7321'

RULE BD_open_uncont_P229:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len <= 2.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 17.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: shape_pattern == '7321'
  CONDITION: total_points <= 19.5

RULE BD_open_uncont_P230:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len <= 2.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 17.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: shape_pattern == '7321'
  CONDITION: total_points > 19.5

RULE BD_open_uncont_P231:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len <= 2.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: shape_pattern != '7321'

RULE BD_open_uncont_P232:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 12.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: spade_len <= 5.5

RULE BD_open_uncont_P233:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 12.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: spade_len > 5.5

RULE BD_open_uncont_P234:
  PRIORITY: 10
  CALL: 3S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 12.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: spade_len > 5.5

RULE BD_open_uncont_P235:
  PRIORITY: 10
  CALL: 4S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 12.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: shape_pattern == '8221'

RULE BD_open_uncont_P236:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: auction_len > 2.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 12.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: shape_pattern != '8221'

RULE BD_open_uncont_P237:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: spade_len <= 5.5
  CONDITION: quick_tricks <= 4.25
  CONDITION: club_hcp <= 3.5

RULE BD_open_uncont_P238:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: spade_len <= 5.5
  CONDITION: quick_tricks <= 4.25
  CONDITION: club_hcp > 3.5
  CONDITION: club_hcp <= 6.0

RULE BD_open_uncont_P239:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: spade_len <= 5.5
  CONDITION: quick_tricks <= 4.25
  CONDITION: club_hcp > 3.5
  CONDITION: club_hcp > 6.0

RULE BD_open_uncont_P240:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: spade_len <= 5.5
  CONDITION: quick_tricks > 4.25

RULE BD_open_uncont_P241:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: shape_pattern == '7321'
  CONDITION: spade_len > 5.5
  CONDITION: hcp <= 20.5

RULE BD_open_uncont_P242:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: shape_pattern == '7321'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 20.5

RULE BD_open_uncont_P243:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: shape_pattern != '7321'
  CONDITION: spade_len > 5.5

RULE BD_open_uncont_P244:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: losing_trick_count > 4.5
  CONDITION: spade_len > 5.5

RULE BD_open_uncont_P245:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: spade_len <= 5.5

RULE BD_open_uncont_P246:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: spade_len > 5.5
  CONDITION: controls <= 7.5

RULE BD_open_uncont_P247:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: spade_len > 5.5
  CONDITION: controls > 7.5
  CONDITION: major_hcp <= 8.5

RULE BD_open_uncont_P248:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: spade_len > 5.5
  CONDITION: controls > 7.5
  CONDITION: major_hcp > 8.5

RULE BD_open_uncont_P249:
  PRIORITY: 10
  CALL: 1S
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: losing_trick_count > 4.5
  CONDITION: spade_len > 5.5
  CONDITION: ace_count <= 3.5

RULE BD_open_uncont_P250:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: losing_trick_count > 4.5
  CONDITION: spade_len > 5.5
  CONDITION: ace_count > 3.5

RULE BD_open_uncont_P251:
  PRIORITY: 10
  CALL: 2C
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5

RULE BD_later_uncont_P0:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: passes_since_last_bid <= 2.5

RULE BD_later_uncont_P1:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: passes_since_last_bid <= 2.5

RULE BD_later_uncont_P2:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: passes_since_last_bid > 2.5
  CONDITION: club_len <= 4.5

RULE BD_later_uncont_P3:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: passes_since_last_bid > 2.5
  CONDITION: club_len > 3.5

RULE BD_later_uncont_P4:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: hcp <= 3.5

RULE BD_later_uncont_P5:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: club_len <= 4.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: hcp > 3.5

RULE BD_later_uncont_P6:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: club_len > 3.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: hcp > 3.5

RULE BD_later_uncont_P7:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: last_bid_strain == 'H'

RULE BD_later_uncont_P8:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: last_bid_strain != 'H'

RULE BD_later_uncont_P9:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: passes_since_last_bid <= 0.5

RULE BD_later_uncont_P10:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: passes_since_last_bid > 0.5

RULE BD_later_uncont_P11:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: my_first_call == '1H'

RULE BD_later_uncont_P12:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: my_first_call != '1H'

RULE BD_later_uncont_P13:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'

RULE BD_later_uncont_P14:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'

RULE BD_later_uncont_P15:
  PRIORITY: 10
  CALL: XX
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len <= 5.0

RULE BD_later_uncont_P16:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len <= 5.0
  CONDITION: total_points <= 9.5

RULE BD_later_uncont_P17:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len <= 5.0
  CONDITION: total_points > 9.5

RULE BD_later_uncont_P18:
  PRIORITY: 10
  CALL: XX
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len > 5.0

RULE BD_later_uncont_P19:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len > 5.0

RULE BD_later_uncont_P20:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len > 5.0
  CONDITION: shape_pattern == '6520'

RULE BD_later_uncont_P21:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len > 5.0
  CONDITION: shape_pattern != '6520'

RULE BD_later_uncont_P22:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: auction_len <= 5.5
  CONDITION: diamond_len <= 0.5

RULE BD_later_uncont_P23:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: auction_len <= 5.5
  CONDITION: diamond_len > 0.5

RULE BD_later_uncont_P24:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: auction_len > 5.5

RULE BD_later_uncont_P25:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: auction_len > 5.5

RULE BD_later_uncont_P26:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: hcp <= 3.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid == '1S'

RULE BD_later_uncont_P27:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: hcp > 3.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid == '1S'

RULE BD_later_uncont_P28:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: competition_level <= 1.5

RULE BD_later_uncont_P29:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: competition_level > 1.5

RULE BD_later_uncont_P30:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid == '1NT'

RULE BD_later_uncont_P31:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: total_points <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid == '1NT'

RULE BD_later_uncont_P32:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid == '1NT'
  CONDITION: auction_len <= 3.5

RULE BD_later_uncont_P33:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid == '1NT'
  CONDITION: auction_len > 3.5
  CONDITION: hcp <= 5.0

RULE BD_later_uncont_P34:
  PRIORITY: 10
  CALL: 4D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid == '1NT'
  CONDITION: auction_len > 3.5
  CONDITION: hcp > 5.0

RULE BD_later_uncont_P35:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: competition_level <= 1.5
  CONDITION: jack_count <= 1.5

RULE BD_later_uncont_P36:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: competition_level <= 1.5
  CONDITION: jack_count > 1.5

RULE BD_later_uncont_P37:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: competition_level > 1.5
  CONDITION: total_points <= 5.5

RULE BD_later_uncont_P38:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: competition_level > 1.5
  CONDITION: total_points > 5.5

RULE BD_later_uncont_P39:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: spade_len <= 1.5
  CONDITION: hcp <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: opening_bid != '1NT'

RULE BD_later_uncont_P40:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: spade_len > 1.5
  CONDITION: hcp <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: heart_hcp <= 0.5

RULE BD_later_uncont_P41:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: spade_len > 1.5
  CONDITION: hcp <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: heart_hcp > 0.5

RULE BD_later_uncont_P42:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len <= 5.5
  CONDITION: spade_len <= 2.5

RULE BD_later_uncont_P43:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len <= 5.5
  CONDITION: spade_len > 2.5

RULE BD_later_uncont_P44:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len > 5.5
  CONDITION: spade_len <= 2.5

RULE BD_later_uncont_P45:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len > 5.5
  CONDITION: spade_len > 2.5

RULE BD_later_uncont_P46:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len <= 5.5

RULE BD_later_uncont_P47:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len <= 5.5

RULE BD_later_uncont_P48:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len > 5.5
  CONDITION: last_bid_seat == 'E'

RULE BD_later_uncont_P49:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len > 5.5
  CONDITION: last_bid_seat != 'E'

RULE BD_later_uncont_P50:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5

RULE BD_later_uncont_P51:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: spade_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5

RULE BD_later_uncont_P52:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5

RULE BD_later_uncont_P53:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_has_ten <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: club_hcp <= 4.5
  CONDITION: c_has_ten <= 0.5

RULE BD_later_uncont_P54:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_has_ten <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: club_hcp <= 4.5
  CONDITION: c_has_ten > 0.5

RULE BD_later_uncont_P55:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_has_ten > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: club_hcp <= 4.5
  CONDITION: heart_hcp <= 4.5

RULE BD_later_uncont_P56:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_has_ten > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: club_hcp <= 4.5
  CONDITION: heart_hcp > 4.5

RULE BD_later_uncont_P57:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: club_hcp > 4.5
  CONDITION: diamond_len <= 5.0

RULE BD_later_uncont_P58:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: club_hcp > 4.5
  CONDITION: diamond_len > 5.0

RULE BD_later_uncont_P59:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit <= 3.5

RULE BD_later_uncont_P60:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit <= 3.5

RULE BD_later_uncont_P61:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: heart_hcp <= 3.5
  CONDITION: hcp <= 8.5

RULE BD_later_uncont_P62:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: heart_hcp <= 3.5
  CONDITION: hcp > 8.5

RULE BD_later_uncont_P63:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: heart_hcp <= 4.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: heart_hcp > 3.5

RULE BD_later_uncont_P64:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: heart_hcp > 4.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: heart_hcp > 3.5

RULE BD_later_uncont_P65:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5

RULE BD_later_uncont_P66:
  PRIORITY: 10
  CALL: 4D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5

RULE BD_later_uncont_P67:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: spade_hcp <= 0.5

RULE BD_later_uncont_P68:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: spade_hcp > 0.5

RULE BD_later_uncont_P69:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit <= 3.5

RULE BD_later_uncont_P70:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5

RULE BD_later_uncont_P71:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp > 8.5

RULE BD_later_uncont_P72:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P73:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P74:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P75:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 3.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P76:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 3.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P77:
  PRIORITY: 10
  CALL: 5C
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: club_len > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P78:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp <= 10.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: spade_hcp <= 3.5

RULE BD_later_uncont_P79:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp <= 10.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: spade_hcp > 3.5

RULE BD_later_uncont_P80:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 10.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: spade_len <= 2.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P81:
  PRIORITY: 10
  CALL: XX
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 10.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: spade_len > 2.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P82:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: singleton_count <= 0.5

RULE BD_later_uncont_P83:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: singleton_count > 0.5
  CONDITION: hcp <= 12.0

RULE BD_later_uncont_P84:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: singleton_count > 0.5
  CONDITION: hcp > 12.0

RULE BD_later_uncont_P85:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: third_longest_len <= 2.5
  CONDITION: major_hcp <= 4.5

RULE BD_later_uncont_P86:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: third_longest_len <= 2.5
  CONDITION: major_hcp > 4.5

RULE BD_later_uncont_P87:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: third_longest_len > 2.5

RULE BD_later_uncont_P88:
  PRIORITY: 10
  CALL: XX
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 6.5
  CONDITION: hcp > 11.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: third_longest_len > 2.5

RULE BD_later_uncont_P89:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: rule20_total <= 24.5

RULE BD_later_uncont_P90:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: rule20_total > 24.5

RULE BD_later_uncont_P91:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: rule20_total > 24.5

RULE BD_later_uncont_P92:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P93:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: d_has_ten <= 0.5
  CONDITION: heart_len > 6.5
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P94:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: d_has_ten > 0.5
  CONDITION: heart_len > 6.5
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P95:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 6.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P96:
  PRIORITY: 10
  CALL: 1D
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'

RULE BD_later_uncont_P97:
  PRIORITY: 10
  CALL: 1D
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: hcp <= 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: second_longest_len <= 3.5

RULE BD_later_uncont_P98:
  PRIORITY: 10
  CALL: 1D
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: hcp <= 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: second_longest_len <= 3.5

RULE BD_later_uncont_P99:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: second_longest_len <= 3.5
  CONDITION: total_points <= 15.5

RULE BD_later_uncont_P100:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: second_longest_len <= 3.5
  CONDITION: total_points > 15.5

RULE BD_later_uncont_P101:
  PRIORITY: 10
  CALL: 1D
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: second_longest_len > 3.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len <= 2.5

RULE BD_later_uncont_P102:
  PRIORITY: 10
  CALL: 1D
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: second_longest_len > 3.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len > 2.5

RULE BD_later_uncont_P103:
  PRIORITY: 10
  CALL: 1D
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: spade_len <= 1.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: second_longest_len > 3.5
  CONDITION: c_is_longest > 0.5

RULE BD_later_uncont_P104:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: spade_len > 1.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: second_longest_len > 3.5
  CONDITION: c_is_longest > 0.5

RULE BD_later_uncont_P105:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: diamond_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: total_points <= 11.5

RULE BD_later_uncont_P106:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: diamond_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: total_points > 9.5

RULE BD_later_uncont_P107:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: diamond_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: hcp > 11.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: total_points > 9.5

RULE BD_later_uncont_P108:
  PRIORITY: 10
  CALL: 1D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: diamond_len > 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: king_count <= 1.5

RULE BD_later_uncont_P109:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: diamond_len > 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: king_count > 1.5
  CONDITION: hcp <= 13.5

RULE BD_later_uncont_P110:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: diamond_len > 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: king_count > 1.5
  CONDITION: hcp > 13.5

RULE BD_later_uncont_P111:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: c_has_jack <= 0.5

RULE BD_later_uncont_P112:
  PRIORITY: 10
  CALL: 1D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: c_has_jack > 0.5

RULE BD_later_uncont_P113:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: club_len <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len <= 3.5

RULE BD_later_uncont_P114:
  PRIORITY: 10
  CALL: 5C
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: club_len > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len <= 3.5

RULE BD_later_uncont_P115:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: total_points <= 11.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len <= 3.5

RULE BD_later_uncont_P116:
  PRIORITY: 10
  CALL: XX
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: total_points <= 11.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len <= 3.5

RULE BD_later_uncont_P117:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: auction_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: total_points > 9.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len <= 3.5

RULE BD_later_uncont_P118:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: auction_len > 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: total_points > 9.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len <= 3.5

RULE BD_later_uncont_P119:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: diamond_len <= 4.5

RULE BD_later_uncont_P120:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: diamond_len <= 4.5

RULE BD_later_uncont_P121:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: diamond_len > 3.5

RULE BD_later_uncont_P122:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: diamond_len > 3.5

RULE BD_later_uncont_P123:
  PRIORITY: 10
  CALL: XX
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: diamond_len <= 4.5

RULE BD_later_uncont_P124:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: diamond_len > 3.5

RULE BD_later_uncont_P125:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: is_balanced <= 0.5

RULE BD_later_uncont_P126:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: is_balanced > 0.5

RULE BD_later_uncont_P127:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp <= 17.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'

RULE BD_later_uncont_P128:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp <= 17.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'

RULE BD_later_uncont_P129:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp <= 17.5
  CONDITION: h_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: opp_first_call == 'X'

RULE BD_later_uncont_P130:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp <= 17.5
  CONDITION: h_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: opp_first_call != 'X'

RULE BD_later_uncont_P131:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'

RULE BD_later_uncont_P132:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'

RULE BD_later_uncont_P133:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'

RULE BD_later_uncont_P134:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: club_len <= 2.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: auction_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: major_hcp <= 12.5

RULE BD_later_uncont_P135:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: club_len <= 2.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: auction_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: major_hcp > 12.5

RULE BD_later_uncont_P136:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: club_len > 2.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: auction_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'

RULE BD_later_uncont_P137:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 17.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: auction_len > 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'

RULE BD_later_uncont_P138:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 17.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: auction_len > 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'

RULE BD_later_uncont_P139:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'

RULE BD_later_uncont_P140:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: opening_bid == '1C'

RULE BD_later_uncont_P141:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: opening_bid != '1C'

RULE BD_later_uncont_P142:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: my_last_call == '1H'

RULE BD_later_uncont_P143:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: my_last_call != '1H'

RULE BD_later_uncont_P144:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid == '1S'
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'

RULE BD_later_uncont_P145:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: auction_len <= 5.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'

RULE BD_later_uncont_P146:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: auction_len <= 5.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'

RULE BD_later_uncont_P147:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: auction_len > 5.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'

RULE BD_later_uncont_P148:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: auction_len > 5.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'

RULE BD_later_uncont_P149:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len <= 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced <= 0.5
  CONDITION: partner_last_call != '1D'

RULE BD_later_uncont_P150:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len <= 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced <= 0.5
  CONDITION: partner_last_call != '1D'

RULE BD_later_uncont_P151:
  PRIORITY: 10
  CALL: 4D
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced <= 0.5
  CONDITION: partner_last_call != '1D'

RULE BD_later_uncont_P152:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced <= 0.5
  CONDITION: partner_last_call != '1D'

RULE BD_later_uncont_P153:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced <= 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: combined_hcp_min <= 22.5

RULE BD_later_uncont_P154:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced <= 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: combined_hcp_min > 22.5

RULE BD_later_uncont_P155:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len > 3.5
  CONDITION: hcp <= 16.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced <= 0.5
  CONDITION: partner_last_call != '1D'

RULE BD_later_uncont_P156:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len > 3.5
  CONDITION: hcp > 16.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced <= 0.5
  CONDITION: partner_last_call != '1D'

RULE BD_later_uncont_P157:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced > 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P158:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced > 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P159:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced > 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P160:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced > 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P161:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced > 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_max <= 35.5

RULE BD_later_uncont_P162:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced > 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_max <= 35.5

RULE BD_later_uncont_P163:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced > 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: my_side_bid_count <= 1.5

RULE BD_later_uncont_P164:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced > 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: my_side_bid_count > 1.5

RULE BD_later_uncont_P165:
  PRIORITY: 10
  CALL: XX
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P166:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P167:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P168:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: club_len <= 3.0

RULE BD_later_uncont_P169:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: club_len > 3.0

RULE BD_later_uncont_P170:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: club_len > 3.0

RULE BD_later_uncont_P171:
  PRIORITY: 10
  CALL: XX
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P172:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: diamond_len <= 4.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: jack_count <= 0.5

RULE BD_later_uncont_P173:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: diamond_len <= 4.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: jack_count > 0.5

RULE BD_later_uncont_P174:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: diamond_len > 4.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P175:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: auction_len <= 5.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: shape_pattern == '6421'

RULE BD_later_uncont_P176:
  PRIORITY: 10
  CALL: 4D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: auction_len <= 5.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: shape_pattern == '6421'

RULE BD_later_uncont_P177:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: auction_len <= 5.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: shape_pattern != '6421'

RULE BD_later_uncont_P178:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: auction_len > 5.5
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P179:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: third_longest_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: major_hcp <= 2.0

RULE BD_later_uncont_P180:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: third_longest_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: major_hcp > 2.0

RULE BD_later_uncont_P181:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: third_longest_len > 2.5
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P182:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: heart_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: diamond_len <= 1.5

RULE BD_later_uncont_P183:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: diamond_len <= 1.5

RULE BD_later_uncont_P184:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: shape_pattern == '6421'
  CONDITION: diamond_len > 1.5

RULE BD_later_uncont_P185:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: shape_pattern != '6421'
  CONDITION: diamond_len > 1.5

RULE BD_later_uncont_P186:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 1.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 18.5

RULE BD_later_uncont_P187:
  PRIORITY: 10
  CALL: 4D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 1.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 18.5

RULE BD_later_uncont_P188:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 1.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 18.5

RULE BD_later_uncont_P189:
  PRIORITY: 10
  CALL: 4D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 1.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 18.5

RULE BD_later_uncont_P190:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 25.5

RULE BD_later_uncont_P191:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 25.5

RULE BD_later_uncont_P192:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 25.5

RULE BD_later_uncont_P193:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 25.5

RULE BD_later_uncont_P194:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 16.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 25.5
  CONDITION: competition_level <= 2.5

RULE BD_later_uncont_P195:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 16.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 25.5
  CONDITION: competition_level <= 2.5

RULE BD_later_uncont_P196:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 25.5
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max <= 34.5

RULE BD_later_uncont_P197:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 25.5
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max > 34.5

RULE BD_later_uncont_P198:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min <= 26.5
  CONDITION: combined_hcp_min <= 24.5

RULE BD_later_uncont_P199:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min <= 26.5
  CONDITION: combined_hcp_min <= 24.5

RULE BD_later_uncont_P200:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min <= 26.5
  CONDITION: combined_hcp_min > 24.5

RULE BD_later_uncont_P201:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min <= 26.5
  CONDITION: combined_hcp_min > 24.5

RULE BD_later_uncont_P202:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min > 26.5
  CONDITION: my_first_call == '1S'
  CONDITION: hcp <= 18.0

RULE BD_later_uncont_P203:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min > 26.5
  CONDITION: my_first_call == '1S'
  CONDITION: hcp > 18.0

RULE BD_later_uncont_P204:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min > 26.5
  CONDITION: my_first_call != '1S'

RULE BD_later_uncont_P205:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min > 26.5
  CONDITION: my_first_call != '1S'

RULE BD_later_uncont_P206:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: major_hcp <= 9.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_opened <= 0.5

RULE BD_later_uncont_P207:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: major_hcp > 9.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_opened <= 0.5

RULE BD_later_uncont_P208:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_opened > 0.5

RULE BD_later_uncont_P209:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P210:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 9.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P211:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P212:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 9.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P213:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: total_points <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 15.5

RULE BD_later_uncont_P214:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: total_points <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 15.5

RULE BD_later_uncont_P215:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: c_has_ten <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 15.5
  CONDITION: controls <= 1.5

RULE BD_later_uncont_P216:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: c_has_ten <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 15.5
  CONDITION: controls > 1.5

RULE BD_later_uncont_P217:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: c_has_ten > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 15.5

RULE BD_later_uncont_P218:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 15.5
  CONDITION: heart_hcp <= 1.5

RULE BD_later_uncont_P219:
  PRIORITY: 10
  CALL: 4D
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 15.5
  CONDITION: heart_hcp > 1.5

RULE BD_later_uncont_P220:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 15.5

RULE BD_later_uncont_P221:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: hcp <= 16.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5

RULE BD_later_uncont_P222:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: hcp <= 16.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5

RULE BD_later_uncont_P223:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: hcp > 16.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 26.5

RULE BD_later_uncont_P224:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: hcp > 16.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 26.5

RULE BD_later_uncont_P225:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp <= 10.5
  CONDITION: c_is_best_minor > 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P226:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 9.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp <= 10.5
  CONDITION: c_is_best_minor > 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P227:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 10.5
  CONDITION: c_is_best_minor > 0.5
  CONDITION: hcp <= 16.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P228:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 10.5
  CONDITION: c_is_best_minor > 0.5
  CONDITION: hcp > 16.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P229:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: diamond_len <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 25.5
  CONDITION: competition_level <= 2.5

RULE BD_later_uncont_P230:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: diamond_len > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 25.5
  CONDITION: competition_level <= 2.5

RULE BD_later_uncont_P231:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 25.5
  CONDITION: competition_level <= 2.5
  CONDITION: rule20_total <= 26.5

RULE BD_later_uncont_P232:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 25.5
  CONDITION: competition_level <= 2.5
  CONDITION: rule20_total > 26.5

RULE BD_later_uncont_P233:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 10.5
  CONDITION: heart_len <= 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5

RULE BD_later_uncont_P234:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 10.5
  CONDITION: heart_len > 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5

RULE BD_later_uncont_P235:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 10.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: opening_bid == '1D'

RULE BD_later_uncont_P236:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 10.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: opening_bid != '1D'

RULE BD_later_uncont_P237:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: major_hcp <= 6.5

RULE BD_later_uncont_P238:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: major_hcp > 6.5

RULE BD_later_uncont_P239:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5

RULE BD_later_uncont_P240:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5

RULE BD_later_uncont_P241:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: second_longest_len > 3.5
  CONDITION: hcp <= 13.5
  CONDITION: diamond_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5

RULE BD_later_uncont_P242:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: second_longest_len > 3.5
  CONDITION: hcp <= 13.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5

RULE BD_later_uncont_P243:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: second_longest_len > 3.5
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: total_points <= 13.5

RULE BD_later_uncont_P244:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: second_longest_len > 3.5
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: total_points > 13.5

RULE BD_later_uncont_P245:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len <= 6.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5

RULE BD_later_uncont_P246:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len <= 6.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5

RULE BD_later_uncont_P247:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: second_longest_len > 4.5
  CONDITION: spade_len <= 6.5
  CONDITION: diamond_hcp <= 3.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P248:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: second_longest_len > 4.5
  CONDITION: spade_len <= 6.5
  CONDITION: diamond_hcp > 3.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'

RULE BD_later_uncont_P249:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: spade_len > 6.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: total_points <= 14.5

RULE BD_later_uncont_P250:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: spade_len > 6.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: total_points > 14.5

RULE BD_later_uncont_P251:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: total_points <= 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: club_len <= 5.5

RULE BD_later_uncont_P252:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: total_points <= 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: club_len > 5.5

RULE BD_later_uncont_P253:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: spade_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: total_points > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: combined_hcp_min <= 13.5

RULE BD_later_uncont_P254:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: spade_len > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: total_points > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: combined_hcp_min <= 13.5

RULE BD_later_uncont_P255:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: quick_tricks <= 2.75
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: total_points > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: combined_hcp_min > 13.5

RULE BD_later_uncont_P256:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: quick_tricks > 2.75
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: total_points > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: combined_hcp_min > 13.5

RULE BD_later_uncont_P257:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: losing_trick_count <= 8.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call == '1S'

RULE BD_later_uncont_P258:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: losing_trick_count > 8.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call == '1S'

RULE BD_later_uncont_P259:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call == '1S'

RULE BD_later_uncont_P260:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call != '1S'
  CONDITION: combined_hcp_min <= 17.5

RULE BD_later_uncont_P261:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call != '1S'
  CONDITION: combined_hcp_min <= 17.5

RULE BD_later_uncont_P262:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call != '1S'
  CONDITION: combined_hcp_min > 17.5
  CONDITION: hcp <= 13.0

RULE BD_later_uncont_P263:
  PRIORITY: 10
  CALL: XX
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call != '1S'
  CONDITION: combined_hcp_min > 17.5
  CONDITION: hcp > 13.0

RULE BD_later_uncont_P264:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: total_points <= 4.5
  CONDITION: shape_pattern == '5422'

RULE BD_later_uncont_P265:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: total_points <= 4.5
  CONDITION: shape_pattern != '5422'

RULE BD_later_uncont_P266:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: total_points <= 4.5

RULE BD_later_uncont_P267:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: club_hcp <= 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: total_points > 4.5
  CONDITION: auction_len <= 6.5

RULE BD_later_uncont_P268:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: club_hcp <= 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: total_points > 4.5
  CONDITION: auction_len > 6.5

RULE BD_later_uncont_P269:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: club_hcp > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: total_points > 4.5

RULE BD_later_uncont_P270:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len > 3.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5

RULE BD_later_uncont_P271:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len > 3.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5

RULE BD_later_uncont_P272:
  PRIORITY: 10
  CALL: 4C
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: hcp > 9.5
  CONDITION: spade_len > 3.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: club_len <= 1.5

RULE BD_later_uncont_P273:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: hcp > 9.5
  CONDITION: spade_len > 3.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: club_len > 1.5

RULE BD_later_uncont_P274:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len > 3.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5

RULE BD_later_uncont_P275:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: hcp > 9.5
  CONDITION: spade_len > 3.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5

RULE BD_later_uncont_P276:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: spade_len > 3.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: auction_len <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5

RULE BD_later_uncont_P277:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: spade_len > 3.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: auction_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5

RULE BD_later_uncont_P278:
  PRIORITY: 10
  CALL: 4D
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 14.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: diamond_len <= 1.5
  CONDITION: combined_hcp_min > 19.5

RULE BD_later_uncont_P279:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 14.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: diamond_len > 1.5
  CONDITION: combined_hcp_min > 19.5

RULE BD_later_uncont_P280:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5

RULE BD_later_uncont_P281:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 11.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5

RULE BD_later_uncont_P282:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: my_side_bid_count <= 2.5

RULE BD_later_uncont_P283:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: my_side_bid_count <= 2.5

RULE BD_later_uncont_P284:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: my_side_bid_count <= 2.5

RULE BD_later_uncont_P285:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: my_side_bid_count > 2.5

RULE BD_later_uncont_P286:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: hcp > 9.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: my_side_bid_count > 2.5

RULE BD_later_uncont_P287:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: my_side_bid_count > 2.5

RULE BD_later_uncont_P288:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 17.5
  CONDITION: hcp <= 16.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: my_side_bid_count <= 2.5

RULE BD_later_uncont_P289:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 17.5
  CONDITION: hcp > 16.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: my_side_bid_count <= 2.5

RULE BD_later_uncont_P290:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: heart_hcp <= 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: my_side_bid_count > 2.5

RULE BD_later_uncont_P291:
  PRIORITY: 10
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: heart_hcp > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: my_side_bid_count > 2.5

RULE BD_later_uncont_P292:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: diamond_len <= 1.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: heart_hcp <= 6.0

RULE BD_later_uncont_P293:
  PRIORITY: 10
  CALL: 4D
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: diamond_len <= 1.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: heart_hcp > 6.0

RULE BD_later_uncont_P294:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: diamond_len > 1.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: shape_pattern == '5431'

RULE BD_later_uncont_P295:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: diamond_len > 1.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: shape_pattern != '5431'

RULE BD_later_uncont_P296:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points <= 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P297:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: club_len <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points <= 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P298:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: club_len > 2.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points <= 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P299:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points <= 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P300:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 5.5
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P301:
  PRIORITY: 10
  CALL: 1S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 5.5
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P302:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 5.5
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P303:
  PRIORITY: 10
  CALL: 1S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P304:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P305:
  PRIORITY: 10
  CALL: 1S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P306:
  PRIORITY: 10
  CALL: 1S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P307:
  PRIORITY: 10
  CALL: 1S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_last_call == '1C'
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P308:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_last_call == '1C'
  CONDITION: rule20_total > 24.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P309:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 10.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_last_call == '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P310:
  PRIORITY: 10
  CALL: 1S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 10.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_last_call == '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5

RULE BD_later_uncont_P311:
  PRIORITY: 10
  CALL: 1D
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_last_call == '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: shape_pattern == '5521'

RULE BD_later_uncont_P312:
  PRIORITY: 10
  CALL: 1S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_last_call == '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: shape_pattern == '5521'

RULE BD_later_uncont_P313:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_last_call == '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: shape_pattern != '5521'

RULE BD_later_uncont_P314:
  PRIORITY: 10
  CALL: 1D
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_last_call == '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: shape_pattern != '5521'

RULE BD_later_uncont_P315:
  PRIORITY: 10
  CALL: 1S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level <= 1.5
  CONDITION: partner_last_call != '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 20.5

RULE BD_later_uncont_P316:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level > 1.5
  CONDITION: partner_last_call != '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 20.5

RULE BD_later_uncont_P317:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: partner_last_call != '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 20.5

RULE BD_later_uncont_P318:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: partner_last_call != '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 20.5

RULE BD_later_uncont_P319:
  PRIORITY: 10
  CALL: 1S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_last_call != '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 20.5

RULE BD_later_uncont_P320:
  PRIORITY: 10
  CALL: 1S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_last_call != '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 20.5

RULE BD_later_uncont_P321:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_last_call != '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 20.5

RULE BD_later_uncont_P322:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_last_call != '1C'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 20.5

RULE BD_later_uncont_P323:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid == '1H'

RULE BD_later_uncont_P324:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid == '1H'

RULE BD_later_uncont_P325:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid == '1H'

RULE BD_later_uncont_P326:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid == '1H'

RULE BD_later_uncont_P327:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: spade_len > 3.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid == '1H'

RULE BD_later_uncont_P328:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: spade_len > 3.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid == '1H'

RULE BD_later_uncont_P329:
  PRIORITY: 10
  CALL: 4C
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 11.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid == '1H'
  CONDITION: doubleton_count <= 0.5

RULE BD_later_uncont_P330:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 11.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid == '1H'
  CONDITION: doubleton_count > 0.5

RULE BD_later_uncont_P331:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len <= 3.5
  CONDITION: hcp <= 16.0
  CONDITION: partner_first_call == '1C'

RULE BD_later_uncont_P332:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len <= 3.5
  CONDITION: hcp <= 16.0
  CONDITION: partner_first_call != '1C'

RULE BD_later_uncont_P333:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len <= 3.5
  CONDITION: hcp > 16.0

RULE BD_later_uncont_P334:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: total_points <= 14.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len > 3.5
  CONDITION: hcp <= 9.0

RULE BD_later_uncont_P335:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: total_points <= 14.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len > 3.5
  CONDITION: hcp > 9.0

RULE BD_later_uncont_P336:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: total_points > 14.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len > 3.5

RULE BD_later_uncont_P337:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: total_points > 14.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len > 3.5

RULE BD_later_uncont_P338:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_hcp <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: shape_pattern == '6421'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major > 0.5

RULE BD_later_uncont_P339:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_hcp > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: shape_pattern == '6421'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major > 0.5

RULE BD_later_uncont_P340:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points <= 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: shape_pattern != '6421'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major > 0.5

RULE BD_later_uncont_P341:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: shape_pattern != '6421'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major > 0.5

RULE BD_later_uncont_P342:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: shape_pattern != '6421'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: h_is_best_major > 0.5

RULE BD_later_uncont_P343:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major > 0.5

RULE BD_later_uncont_P344:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major > 0.5

RULE BD_later_uncont_P345:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'C'

RULE BD_later_uncont_P346:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'C'

RULE BD_later_uncont_P347:
  PRIORITY: 10
  CALL: 1S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major > 0.5

RULE BD_later_uncont_P348:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: heart_hcp <= 1.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major > 0.5

RULE BD_later_uncont_P349:
  PRIORITY: 10
  CALL: 1H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: heart_hcp > 1.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: h_is_best_major > 0.5

RULE BD_later_uncont_P350:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5

RULE BD_later_uncont_P351:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: my_last_call == '2H'

RULE BD_later_uncont_P352:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: total_points <= 15.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: my_last_call != '2H'
  CONDITION: rule20_total <= 25.0

RULE BD_later_uncont_P353:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: total_points > 15.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: my_last_call != '2H'
  CONDITION: rule20_total <= 25.0

RULE BD_later_uncont_P354:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: my_last_call != '2H'
  CONDITION: rule20_total > 25.0
  CONDITION: heart_hcp <= 5.0

RULE BD_later_uncont_P355:
  PRIORITY: 10
  CALL: 6D
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: my_last_call != '2H'
  CONDITION: rule20_total > 25.0
  CONDITION: heart_hcp > 5.0

RULE BD_later_uncont_P356:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: club_len <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: spade_hcp <= 7.5

RULE BD_later_uncont_P357:
  PRIORITY: 10
  CALL: 4D
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: club_len <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: spade_hcp > 7.5

RULE BD_later_uncont_P358:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: club_len > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: diamond_len <= 2.5

RULE BD_later_uncont_P359:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: club_len > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: diamond_len > 2.5

RULE BD_later_uncont_P360:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: hcp <= 15.0

RULE BD_later_uncont_P361:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: hcp > 15.0
  CONDITION: diamond_hcp <= 5.0

RULE BD_later_uncont_P362:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: hcp > 15.0
  CONDITION: diamond_hcp > 5.0

RULE BD_later_uncont_P363:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5

RULE BD_later_uncont_P364:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5

RULE BD_later_uncont_P365:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: rule_of_21 <= 0.5

RULE BD_later_uncont_P366:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: rule_of_21 > 0.5

RULE BD_later_uncont_P367:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total <= 10.5
  CONDITION: heart_hcp <= 2.5

RULE BD_later_uncont_P368:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total <= 10.5
  CONDITION: heart_hcp > 2.5

RULE BD_later_uncont_P369:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total > 10.5

RULE BD_later_uncont_P370:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total > 10.5

RULE BD_later_uncont_P371:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 12.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total > 10.5

RULE BD_later_uncont_P372:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 12.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total > 10.5

RULE BD_later_uncont_P373:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'

RULE BD_later_uncont_P374:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'

RULE BD_later_uncont_P375:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'
  CONDITION: our_fit_shown <= 0.5

RULE BD_later_uncont_P376:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'
  CONDITION: our_fit_shown > 0.5

RULE BD_later_uncont_P377:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: opening_bid == '1D'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'

RULE BD_later_uncont_P378:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: opening_bid != '1D'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'

RULE BD_later_uncont_P379:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'

RULE BD_later_uncont_P380:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 17.5
  CONDITION: hcp > 19.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'

RULE BD_later_uncont_P381:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: s_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 25.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5

RULE BD_later_uncont_P382:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: s_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total <= 25.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5

RULE BD_later_uncont_P383:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 4.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: second_longest_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 25.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5

RULE BD_later_uncont_P384:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 4.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: second_longest_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: rule20_total > 25.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5

RULE BD_later_uncont_P385:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5
  CONDITION: my_last_call == '1S'

RULE BD_later_uncont_P386:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5
  CONDITION: my_last_call != '1S'

RULE BD_later_uncont_P387:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5
  CONDITION: my_last_call == '2S'

RULE BD_later_uncont_P388:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5
  CONDITION: my_last_call != '2S'

RULE BD_later_uncont_P389:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: spade_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5

RULE BD_later_uncont_P390:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: spade_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: opening_bid == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5

RULE BD_later_uncont_P391:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: spade_len > 1.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opening_bid == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5

RULE BD_later_uncont_P392:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: spade_len > 1.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opening_bid == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5

RULE BD_later_uncont_P393:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5
  CONDITION: partner_last_bid_strain == 'D'

RULE BD_later_uncont_P394:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 4.5
  CONDITION: partner_last_bid_strain != 'D'

RULE BD_later_uncont_P395:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: my_last_call == '2H'
  CONDITION: longest_suit_len > 4.5

RULE BD_later_uncont_P396:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: my_last_call != '2H'
  CONDITION: longest_suit_len > 4.5

RULE BD_later_uncont_P397:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1NT'
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '2H'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: combined_hcp_min <= 21.5

RULE BD_later_uncont_P398:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1NT'
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '2H'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: combined_hcp_min <= 21.5

RULE BD_later_uncont_P399:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '2H'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: combined_hcp_min <= 21.5

RULE BD_later_uncont_P400:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '2H'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: combined_hcp_min <= 21.5

RULE BD_later_uncont_P401:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '2H'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: combined_hcp_min <= 21.5

RULE BD_later_uncont_P402:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: combined_hcp_min > 21.5

RULE BD_later_uncont_P403:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_first_call == '2D'

RULE BD_later_uncont_P404:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_first_call == '2D'

RULE BD_later_uncont_P405:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: total_points <= 13.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_first_call == '2D'

RULE BD_later_uncont_P406:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: total_points > 13.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_first_call == '2D'

RULE BD_later_uncont_P407:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_first_call != '2D'
  CONDITION: partner_hcp_min <= 21.0
  CONDITION: competition_level <= 4.5

RULE BD_later_uncont_P408:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_first_call != '2D'
  CONDITION: partner_hcp_min <= 21.0
  CONDITION: competition_level > 4.5

RULE BD_later_uncont_P409:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: diamond_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_first_call != '2D'
  CONDITION: partner_hcp_min > 21.0

RULE BD_later_uncont_P410:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_first_call != '2D'
  CONDITION: partner_hcp_min > 21.0

RULE BD_later_uncont_P411:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: major_hcp <= 10.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_hcp_min <= 21.0
  CONDITION: partner_hcp_min <= 10.0

RULE BD_later_uncont_P412:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: major_hcp > 10.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_hcp_min <= 21.0
  CONDITION: partner_hcp_min <= 10.0

RULE BD_later_uncont_P413:
  PRIORITY: 10
  CALL: 5D
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_hcp_min <= 21.0
  CONDITION: partner_hcp_min > 10.0
  CONDITION: third_longest_len <= 1.5

RULE BD_later_uncont_P414:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_hcp_min <= 21.0
  CONDITION: partner_hcp_min > 10.0
  CONDITION: third_longest_len > 1.5

RULE BD_later_uncont_P415:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_hcp_min > 21.0

RULE BD_later_uncont_P416:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_hcp_min > 21.0

RULE BD_later_uncont_P417:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_hcp_min > 21.0
  CONDITION: spade_hcp <= 4.5

RULE BD_later_uncont_P418:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_hcp_min > 21.0
  CONDITION: spade_hcp > 4.5

RULE BD_later_uncont_P419:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '2S'
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: hcp > 15.5

RULE BD_later_uncont_P420:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '2S'
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: hcp > 15.5

RULE BD_later_uncont_P421:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1NT'
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '2S'
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: hcp > 15.5

RULE BD_later_uncont_P422:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1NT'
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '2S'
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: hcp > 15.5

RULE BD_later_uncont_P423:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: heart_len <= 2.5
  CONDITION: diamond_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: hcp > 15.5

RULE BD_later_uncont_P424:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: heart_len > 2.5
  CONDITION: diamond_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: hcp > 15.5

RULE BD_later_uncont_P425:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: hcp > 15.5
  CONDITION: hcp <= 17.0

RULE BD_later_uncont_P426:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: hcp > 15.5
  CONDITION: hcp > 17.0

RULE BD_later_uncont_P427:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: hcp > 15.5
  CONDITION: quick_tricks <= 4.75

RULE BD_later_uncont_P428:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: hcp > 15.5
  CONDITION: quick_tricks > 4.75

RULE BD_later_uncont_P429:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: hcp > 15.5
  CONDITION: quick_tricks > 4.75

RULE BD_later_uncont_P430:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: total_points <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: hcp > 15.5

RULE BD_later_uncont_P431:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: total_points > 17.5
  CONDITION: is_opening == False
  CONDITION: c_has_ten <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: hcp > 15.5
  CONDITION: my_side_bid_count <= 4.5
  CONDITION: controls <= 5.5

RULE BD_later_uncont_P432:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: total_points > 17.5
  CONDITION: is_opening == False
  CONDITION: c_has_ten <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: hcp > 15.5
  CONDITION: my_side_bid_count <= 4.5
  CONDITION: controls > 5.5

RULE BD_later_uncont_P433:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: total_points > 17.5
  CONDITION: is_opening == False
  CONDITION: c_has_ten > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: hcp > 15.5
  CONDITION: my_side_bid_count <= 4.5
  CONDITION: combined_hcp_min <= 37.5

RULE BD_later_uncont_P434:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: total_points > 17.5
  CONDITION: is_opening == False
  CONDITION: c_has_ten > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: hcp > 15.5
  CONDITION: my_side_bid_count <= 4.5
  CONDITION: combined_hcp_min > 37.5

RULE BD_later_uncont_P435:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: hcp > 15.5
  CONDITION: my_side_bid_count > 4.5
  CONDITION: s_has_queen <= 0.5

RULE BD_later_uncont_P436:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: hcp > 15.5
  CONDITION: my_side_bid_count > 4.5
  CONDITION: s_has_queen > 0.5

RULE BD_later_uncont_P437:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: hcp > 15.5
  CONDITION: my_side_bid_count > 4.5
  CONDITION: d_has_jack <= 0.5

RULE BD_later_uncont_P438:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: hcp > 15.5
  CONDITION: my_side_bid_count > 4.5
  CONDITION: d_has_jack > 0.5

RULE BD_later_uncont_P439:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid == '2S'

RULE BD_later_uncont_P440:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 1.5
  CONDITION: hcp <= 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid == '2S'

RULE BD_later_uncont_P441:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 1.5
  CONDITION: hcp <= 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid == '2S'

RULE BD_later_uncont_P442:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: controls <= 4.5
  CONDITION: hcp <= 14.5
  CONDITION: hcp > 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid == '2S'

RULE BD_later_uncont_P443:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: controls <= 4.5
  CONDITION: hcp > 14.5
  CONDITION: hcp > 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid == '2S'

RULE BD_later_uncont_P444:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: controls > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp > 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid == '2S'

RULE BD_later_uncont_P445:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: controls > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid == '2S'

RULE BD_later_uncont_P446:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid != '2S'
  CONDITION: my_last_call == '1NT'

RULE BD_later_uncont_P447:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid != '2S'
  CONDITION: my_last_call == '1NT'

RULE BD_later_uncont_P448:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid != '2S'
  CONDITION: my_last_call == '1NT'

RULE BD_later_uncont_P449:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '2H'
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid != '2S'
  CONDITION: my_last_call != '1NT'

RULE BD_later_uncont_P450:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '2H'
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid != '2S'
  CONDITION: my_last_call != '1NT'

RULE BD_later_uncont_P451:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 4.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid != '2S'
  CONDITION: my_last_call != '1NT'

RULE BD_later_uncont_P452:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 4.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: opening_bid != '2S'
  CONDITION: my_last_call != '1NT'

RULE BD_later_uncont_P453:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min > 13.0
  CONDITION: my_last_call == '2C'

RULE BD_later_uncont_P454:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min > 13.0
  CONDITION: my_last_call != '2C'
  CONDITION: hcp <= 6.0

RULE BD_later_uncont_P455:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min > 13.0
  CONDITION: my_last_call != '2C'
  CONDITION: hcp > 6.0

RULE BD_later_uncont_P456:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: diamond_len <= 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min > 13.0
  CONDITION: combined_hcp_max <= 39.0

RULE BD_later_uncont_P457:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: diamond_len <= 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min > 13.0
  CONDITION: combined_hcp_max > 39.0

RULE BD_later_uncont_P458:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min > 13.0
  CONDITION: diamond_hcp <= 5.5

RULE BD_later_uncont_P459:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min > 13.0
  CONDITION: diamond_hcp > 5.5

RULE BD_later_uncont_P460:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 4.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min > 13.0
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P461:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min > 13.0
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P462:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_hcp_min > 13.0
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P463:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min > 13.0
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P464:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: shape_pattern == '6421'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5

RULE BD_later_uncont_P465:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: shape_pattern != '6421'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5

RULE BD_later_uncont_P466:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5

RULE BD_later_uncont_P467:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len <= 5.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: total_points <= 5.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5

RULE BD_later_uncont_P469:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len > 5.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: agreed_trump == 'S'

RULE BD_later_uncont_P470:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len > 5.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: agreed_trump != 'S'

RULE BD_later_uncont_P471:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P472:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P473:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5

RULE BD_later_uncont_P474:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5

RULE BD_later_uncont_P475:
  PRIORITY: 10
  CALL: 4C
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '2D'
  CONDITION: minor_hcp <= 3.5

RULE BD_later_uncont_P476:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '2D'
  CONDITION: minor_hcp > 3.5

RULE BD_later_uncont_P477:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '2D'

RULE BD_later_uncont_P478:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 15.5
  CONDITION: my_last_call == '2C'

RULE BD_later_uncont_P479:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 15.5
  CONDITION: my_last_call == '2C'

RULE BD_later_uncont_P480:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: total_points <= 15.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '2C'

RULE BD_later_uncont_P481:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: total_points > 15.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '2C'

RULE BD_later_uncont_P482:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: club_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '2C'

RULE BD_later_uncont_P483:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: club_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '2C'

RULE BD_later_uncont_P484:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 9.5
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '2C'

RULE BD_later_uncont_P485:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 9.5
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '2C'

RULE BD_later_uncont_P486:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opening_bid == '2S'
  CONDITION: auction_len <= 7.5

RULE BD_later_uncont_P487:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opening_bid != '2S'
  CONDITION: auction_len <= 7.5

RULE BD_later_uncont_P488:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: auction_len <= 7.5

RULE BD_later_uncont_P489:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: auction_len <= 7.5

RULE BD_later_uncont_P490:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: auction_len > 7.5

RULE BD_later_uncont_P491:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: auction_len > 7.5

RULE BD_later_uncont_P492:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: auction_len > 7.5

RULE BD_later_uncont_P493:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: auction_len > 7.5

RULE BD_later_uncont_P494:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call == '1NT'

RULE BD_later_uncont_P495:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call == '1NT'

RULE BD_later_uncont_P496:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 15.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call == '1NT'

RULE BD_later_uncont_P497:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call == '1NT'

RULE BD_later_uncont_P498:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: club_len <= 5.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call == '1NT'
  CONDITION: combined_hcp_max <= 30.5

RULE BD_later_uncont_P499:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: club_len > 5.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call == '1NT'
  CONDITION: combined_hcp_max <= 30.5

RULE BD_later_uncont_P500:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call == '1NT'
  CONDITION: combined_hcp_max > 30.5

RULE BD_later_uncont_P501:
  PRIORITY: 10
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call == '1NT'
  CONDITION: combined_hcp_max > 30.5

RULE BD_later_uncont_P502:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call != '1NT'
  CONDITION: opening_bid == '2H'

RULE BD_later_uncont_P503:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp > 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call != '1NT'
  CONDITION: opening_bid == '2H'

RULE BD_later_uncont_P504:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call != '1NT'
  CONDITION: opening_bid != '2H'

RULE BD_later_uncont_P505:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call != '1NT'
  CONDITION: opening_bid != '2H'

RULE BD_later_uncont_P506:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call != '1NT'

RULE BD_later_uncont_P507:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call != '1NT'

RULE BD_later_uncont_P508:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call != '1NT'

RULE BD_later_uncont_P509:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: my_first_call != '1NT'

RULE BD_later_uncont_P510:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P511:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P512:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P513:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P514:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '1NT'
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P515:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '1NT'
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P516:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P517:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P518:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 21.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 20.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '1NT'
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P519:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 21.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 20.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P520:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 21.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 20.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P521:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 21.5
  CONDITION: losing_trick_count > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 20.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P522:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_min <= 24.5
  CONDITION: combined_hcp_min > 20.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P523:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_min > 24.5
  CONDITION: combined_hcp_min > 20.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5

RULE BD_later_uncont_P524:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_min > 20.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: auction_len <= 7.5

RULE BD_later_uncont_P525:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_min > 20.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: auction_len > 7.5

RULE BD_later_uncont_P526:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P527:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len <= 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P528:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P529:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P530:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P531:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P532:
  PRIORITY: 10
  CALL: 2S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len <= 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P533:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P534:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P535:
  PRIORITY: 10
  CALL: 3C
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P536:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P537:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: auction_len <= 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: controls <= 2.5

RULE BD_later_uncont_P538:
  PRIORITY: 10
  CALL: 2D
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: auction_len <= 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: controls > 2.5

RULE BD_later_uncont_P539:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 4.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: auction_len > 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P540:
  PRIORITY: 10
  CALL: 3H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 4.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: auction_len > 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P541:
  PRIORITY: 10
  CALL: 2H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P542:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P543:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P544:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 7.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: partner_hcp_min > 18.5

RULE BD_later_uncont_P545:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0

RULE BD_later_uncont_P546:
  PRIORITY: 10
  CALL: 4C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: major_hcp <= 0.5

RULE BD_later_uncont_P547:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: major_hcp > 0.5

RULE BD_later_uncont_P548:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: second_longest_len > 4.5
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: major_hcp > 0.5

RULE BD_later_uncont_P549:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: my_last_call == '2NT'
  CONDITION: king_count <= 0.5

RULE BD_later_uncont_P550:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: my_last_call == '2NT'
  CONDITION: king_count > 0.5

RULE BD_later_uncont_P551:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: my_last_call != '2NT'

RULE BD_later_uncont_P552:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: my_last_call != '2NT'

RULE BD_later_uncont_P553:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid == '2H'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0

RULE BD_later_uncont_P554:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: heart_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid == '2H'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0

RULE BD_later_uncont_P555:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 1.5
  CONDITION: hcp > 11.5
  CONDITION: hcp <= 19.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid == '2H'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0

RULE BD_later_uncont_P556:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 1.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 19.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid == '2H'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0

RULE BD_later_uncont_P557:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: my_last_call == '3D'
  CONDITION: king_count <= 3.5

RULE BD_later_uncont_P558:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: my_last_call == '3D'
  CONDITION: king_count > 3.5
  CONDITION: hcp <= 18.5

RULE BD_later_uncont_P559:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: my_last_call == '3D'
  CONDITION: king_count > 3.5
  CONDITION: hcp > 18.5

RULE BD_later_uncont_P560:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: total_points <= 19.5
  CONDITION: is_opening == False
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: my_last_call != '3D'

RULE BD_later_uncont_P561:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: total_points <= 19.5
  CONDITION: is_opening == False
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: my_last_call != '3D'

RULE BD_later_uncont_P562:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: total_points > 19.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: my_last_call != '3D'
  CONDITION: minor_hcp <= 6.5

RULE BD_later_uncont_P563:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: total_points > 19.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: my_last_call != '3D'
  CONDITION: minor_hcp > 6.5

RULE BD_later_uncont_P564:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: is_balanced <= 0.5
  CONDITION: my_last_call == '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: auction_len <= 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0
  CONDITION: total_points <= 16.5

RULE BD_later_uncont_P565:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: is_balanced <= 0.5
  CONDITION: my_last_call == '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: auction_len <= 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: spade_hcp <= 4.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0
  CONDITION: total_points > 16.5

RULE BD_later_uncont_P566:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: is_balanced <= 0.5
  CONDITION: my_last_call == '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: auction_len <= 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: spade_hcp > 4.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0
  CONDITION: total_points > 16.5

RULE BD_later_uncont_P567:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 16.5
  CONDITION: is_opening == False
  CONDITION: is_balanced > 0.5
  CONDITION: my_last_call == '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: auction_len <= 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P568:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 16.5
  CONDITION: is_opening == False
  CONDITION: is_balanced > 0.5
  CONDITION: my_last_call == '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: auction_len <= 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P569:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: my_last_call == '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: auction_len > 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P570:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: shape_pattern == '5332'
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: rule20_total <= 24.5
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P571:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: shape_pattern != '5332'
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: rule20_total <= 24.5
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P572:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: major_hcp <= 7.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: rule20_total > 24.5
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P573:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: major_hcp > 7.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: rule20_total > 24.5
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P574:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0
  CONDITION: partner_last_bid_strain == 'S'

RULE BD_later_uncont_P575:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0
  CONDITION: partner_last_bid_strain != 'S'

RULE BD_later_uncont_P576:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: competition_level > 2.5
  CONDITION: h_is_best_major <= 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P577:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1S'
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: competition_level > 2.5
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P578:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid != '1S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call == '2NT'
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P579:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid != '1S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call == '2NT'
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P580:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 7.5
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call == '2NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: partner_first_call == '1H'

RULE BD_later_uncont_P581:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 7.5
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call == '2NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: partner_first_call != '1H'

RULE BD_later_uncont_P582:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '2H'
  CONDITION: my_first_call == '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call != '2NT'
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P583:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '2H'
  CONDITION: my_first_call == '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call != '2NT'
  CONDITION: partner_hcp_min > 8.0

RULE BD_later_uncont_P584:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: my_first_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call != '2NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: combined_hcp_max <= 33.5

RULE BD_later_uncont_P585:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1S'
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: my_first_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call != '2NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: combined_hcp_max > 33.5

RULE BD_later_uncont_P586:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opening_bid == '2S'
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'

RULE BD_later_uncont_P587:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opening_bid != '2S'
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: partner_first_call == '2S'
  CONDITION: rule20_total <= 22.5

RULE BD_later_uncont_P588:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opening_bid != '2S'
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: partner_first_call == '2S'
  CONDITION: rule20_total > 22.5

RULE BD_later_uncont_P589:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: total_points <= 13.5
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opening_bid != '2S'
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: partner_first_call != '2S'

RULE BD_later_uncont_P590:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: total_points > 13.5
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opening_bid != '2S'
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: partner_first_call != '2S'

RULE BD_later_uncont_P591:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: rule20_total <= 25.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_side_bid_count <= 4.5
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: my_side_bid_count <= 3.5

RULE BD_later_uncont_P592:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: rule20_total <= 25.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_side_bid_count <= 4.5
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: my_side_bid_count > 3.5

RULE BD_later_uncont_P593:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: rule20_total <= 25.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_side_bid_count > 4.5
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: partner_first_call == '1D'

RULE BD_later_uncont_P594:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: rule20_total <= 25.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_side_bid_count > 4.5
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: partner_first_call != '1D'

RULE BD_later_uncont_P595:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: h_has_king <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: rule20_total > 25.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: partner_hcp_max <= 19.0

RULE BD_later_uncont_P596:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: h_has_king <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: rule20_total > 25.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: partner_hcp_max > 19.0

RULE BD_later_uncont_P597:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: h_has_king > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: rule20_total > 25.5
  CONDITION: opening_bid == '1D'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'

RULE BD_later_uncont_P598:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: h_has_king > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: rule20_total > 25.5
  CONDITION: opening_bid != '1D'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump == 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'

RULE BD_later_uncont_P599:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: my_last_call == '2D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: longest_suit_len <= 6.5

RULE BD_later_uncont_P600:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: my_last_call != '2D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: longest_suit_len <= 6.5

RULE BD_later_uncont_P601:
  PRIORITY: 10
  CALL: 4C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 1.5
  CONDITION: minor_hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: longest_suit_len > 6.5

RULE BD_later_uncont_P602:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 1.5
  CONDITION: minor_hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: longest_suit_len > 6.5

RULE BD_later_uncont_P603:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: combined_hcp_max <= 24.5
  CONDITION: auction_len <= 4.5

RULE BD_later_uncont_P604:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: combined_hcp_max <= 24.5
  CONDITION: auction_len > 4.5

RULE BD_later_uncont_P605:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: combined_hcp_max > 24.5
  CONDITION: d_top2_honors <= 1.5

RULE BD_later_uncont_P606:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: combined_hcp_max > 24.5
  CONDITION: d_top2_honors > 1.5

RULE BD_later_uncont_P607:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 3.5
  CONDITION: spade_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: total_points <= 12.5
  CONDITION: my_last_call == '3C'

RULE BD_later_uncont_P608:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 3.5
  CONDITION: spade_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: total_points <= 12.5
  CONDITION: my_last_call == '3C'

RULE BD_later_uncont_P609:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: agreed_trump != 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: total_points <= 12.5
  CONDITION: my_last_call != '3C'

RULE BD_later_uncont_P610:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: agreed_trump != 'S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: total_points <= 12.5
  CONDITION: my_last_call != '3C'

RULE BD_later_uncont_P611:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: my_first_call == '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: total_points > 12.5
  CONDITION: my_last_call == '3H'

RULE BD_later_uncont_P612:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: my_first_call == '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: total_points > 12.5
  CONDITION: my_last_call != '3H'

RULE BD_later_uncont_P613:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: my_first_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: total_points > 12.5

RULE BD_later_uncont_P614:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: agreed_trump != 'S'
  CONDITION: my_first_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call == '3S'
  CONDITION: total_points > 12.5

RULE BD_later_uncont_P615:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_first_call == '2D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'

RULE BD_later_uncont_P616:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_first_call == '2D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'

RULE BD_later_uncont_P617:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: my_last_call == '1H'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_first_call != '2D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'

RULE BD_later_uncont_P618:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_first_call != '2D'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'

RULE BD_later_uncont_P619:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: total_points <= 16.5
  CONDITION: my_side_bid_count <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'

RULE BD_later_uncont_P620:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: total_points <= 16.5
  CONDITION: my_side_bid_count > 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'

RULE BD_later_uncont_P621:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: total_points > 16.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'

RULE BD_later_uncont_P622:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: total_points > 16.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'

RULE BD_later_uncont_P623:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: hcp <= 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: combined_hcp_max <= 24.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'

RULE BD_later_uncont_P624:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: hcp <= 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: combined_hcp_max <= 24.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'

RULE BD_later_uncont_P625:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: hcp <= 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_first_call == '1H'
  CONDITION: combined_hcp_max > 24.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'

RULE BD_later_uncont_P626:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: hcp <= 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_first_call != '1H'
  CONDITION: combined_hcp_max > 24.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'

RULE BD_later_uncont_P627:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: auction_len <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: hcp > 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'
  CONDITION: hcp <= 24.0

RULE BD_later_uncont_P628:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: auction_len <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: hcp > 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'
  CONDITION: hcp > 24.0

RULE BD_later_uncont_P629:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: opening_bid == '2NT'
  CONDITION: hcp > 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'

RULE BD_later_uncont_P630:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: opening_bid != '2NT'
  CONDITION: hcp > 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'

RULE BD_later_uncont_P631:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: rule20_total <= 19.5
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: opening_bid == '3D'

RULE BD_later_uncont_P632:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: rule20_total > 19.5
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: opening_bid == '3D'

RULE BD_later_uncont_P633:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: opening_bid != '3D'
  CONDITION: opening_bid == '3C'

RULE BD_later_uncont_P634:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: opening_bid != '3D'
  CONDITION: opening_bid != '3C'

RULE BD_later_uncont_P635:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_side_bid_count <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: support_in_partner_suit <= 5.5

RULE BD_later_uncont_P636:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_side_bid_count <= 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: support_in_partner_suit > 5.5

RULE BD_later_uncont_P637:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_side_bid_count > 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: agreed_trump_len <= 2.5

RULE BD_later_uncont_P638:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_side_bid_count > 3.5
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: agreed_trump_len > 2.5

RULE BD_later_uncont_P639:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call == '2NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'

RULE BD_later_uncont_P640:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call == '2NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'

RULE BD_later_uncont_P641:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call == '2NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'

RULE BD_later_uncont_P642:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call == '2NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'

RULE BD_later_uncont_P643:
  PRIORITY: 10
  CALL: 3D
  CONDITION: opponents_bid == False
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call != '2NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'

RULE BD_later_uncont_P644:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call != '2NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'

RULE BD_later_uncont_P645:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call != '2NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'

RULE BD_later_uncont_P646:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: opponents_bid == False
  CONDITION: hcp > 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call != '2NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'

RULE BD_later_uncont_P647:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: minor_hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call == '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5

RULE BD_later_uncont_P648:
  PRIORITY: 10
  CALL: 5C
  CONDITION: opponents_bid == False
  CONDITION: minor_hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: diamond_len <= 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call == '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5

RULE BD_later_uncont_P649:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: minor_hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call == '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5

RULE BD_later_uncont_P650:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: quick_tricks <= 0.75
  CONDITION: minor_hcp <= 0.5

RULE BD_later_uncont_P651:
  PRIORITY: 10
  CALL: 5C
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: quick_tricks <= 0.75
  CONDITION: minor_hcp > 0.5

RULE BD_later_uncont_P652:
  PRIORITY: 10
  CALL: 5D
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: auction_len <= 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: quick_tricks > 0.75

RULE BD_later_uncont_P653:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: auction_len > 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: quick_tricks > 0.75

RULE BD_later_uncont_P654:
  PRIORITY: 10
  CALL: 5C
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: shape_pattern == '5431'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5

RULE BD_later_uncont_P655:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: shape_pattern == '5431'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5

RULE BD_later_uncont_P656:
  PRIORITY: 10
  CALL: 5C
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: shape_pattern != '5431'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5

RULE BD_later_uncont_P657:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call == '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: c_has_king <= 0.5
  CONDITION: quick_tricks <= 1.75

RULE BD_later_uncont_P658:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call == '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: c_has_king <= 0.5
  CONDITION: quick_tricks > 1.75

RULE BD_later_uncont_P659:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call == '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: c_has_king > 0.5

RULE BD_later_uncont_P660:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call == '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: c_has_king > 0.5

RULE BD_later_uncont_P661:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: shortest_suit_len <= 0.5

RULE BD_later_uncont_P662:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: shortest_suit_len > 0.5

RULE BD_later_uncont_P663:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: losing_trick_count > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: combined_hcp_min <= 43.5

RULE BD_later_uncont_P664:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: losing_trick_count > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: combined_hcp_min > 43.5

RULE BD_later_uncont_P665:
  PRIORITY: 10
  CALL: 6D
  CONDITION: opponents_bid == False
  CONDITION: diamond_hcp <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: spade_hcp <= 3.0

RULE BD_later_uncont_P666:
  PRIORITY: 10
  CALL: 6C
  CONDITION: opponents_bid == False
  CONDITION: diamond_hcp > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: spade_hcp <= 3.0

RULE BD_later_uncont_P667:
  PRIORITY: 10
  CALL: 5D
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: spade_hcp > 3.0

RULE BD_later_uncont_P668:
  PRIORITY: 10
  CALL: 6H
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: spade_hcp > 3.0

RULE BD_later_uncont_P669:
  PRIORITY: 10
  CALL: 5H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: my_first_call == '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: shortest_suit_len > 0.5

RULE BD_later_uncont_P670:
  PRIORITY: 10
  CALL: 5D
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: my_first_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: shortest_suit_len > 0.5

RULE BD_later_uncont_P671:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: combined_hcp_min <= 41.5
  CONDITION: queen_count <= 1.5

RULE BD_later_uncont_P672:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: combined_hcp_min <= 41.5
  CONDITION: queen_count > 1.5

RULE BD_later_uncont_P673:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: losing_trick_count > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call == '1D'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: combined_hcp_min <= 41.5

RULE BD_later_uncont_P674:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: losing_trick_count > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call != '1D'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: combined_hcp_min <= 41.5

RULE BD_later_uncont_P675:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: hcp <= 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: combined_hcp_min > 41.5
  CONDITION: major_hcp <= 11.5

RULE BD_later_uncont_P676:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: hcp <= 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: combined_hcp_min > 41.5
  CONDITION: major_hcp > 11.5

RULE BD_later_uncont_P677:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: hcp > 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: combined_hcp_min > 41.5

RULE BD_later_uncont_P678:
  PRIORITY: 10
  CALL: 6C
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: club_len > 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: hcp > 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: combined_hcp_min > 41.5

RULE BD_later_uncont_P679:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: has_trump_queen <= 0.5

RULE BD_later_uncont_P680:
  PRIORITY: 10
  CALL: 5H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call == '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len > 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: has_trump_queen <= 0.5

RULE BD_later_uncont_P681:
  PRIORITY: 10
  CALL: 5S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len > 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: has_trump_queen <= 0.5

RULE BD_later_uncont_P682:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: has_trump_queen > 0.5

RULE BD_later_uncont_P683:
  PRIORITY: 10
  CALL: 6C
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len > 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: has_trump_queen > 0.5

RULE BD_later_uncont_P684:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len > 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: has_trump_queen > 0.5

RULE BD_later_uncont_P685:
  PRIORITY: 10
  CALL: 6C
  CONDITION: opponents_bid == False
  CONDITION: controls <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: controls <= 6.5
  CONDITION: spade_hcp <= 6.5

RULE BD_later_uncont_P686:
  PRIORITY: 10
  CALL: 6H
  CONDITION: opponents_bid == False
  CONDITION: controls <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: controls <= 6.5
  CONDITION: spade_hcp > 6.5

RULE BD_later_uncont_P687:
  PRIORITY: 10
  CALL: 5D
  CONDITION: opponents_bid == False
  CONDITION: controls <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: controls > 6.5
  CONDITION: club_hcp <= 5.5

RULE BD_later_uncont_P688:
  PRIORITY: 10
  CALL: 6D
  CONDITION: opponents_bid == False
  CONDITION: controls <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: controls > 6.5
  CONDITION: club_hcp > 5.5

RULE BD_later_uncont_P689:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: controls <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len > 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: controls <= 6.5
  CONDITION: combined_hcp_min <= 44.5

RULE BD_later_uncont_P690:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: controls <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len > 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: controls > 6.5
  CONDITION: combined_hcp_min <= 44.5

RULE BD_later_uncont_P691:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 17.5
  CONDITION: controls <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len > 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: combined_hcp_min > 44.5

RULE BD_later_uncont_P692:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp > 17.5
  CONDITION: controls <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: shortest_suit_len > 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: combined_hcp_min > 44.5

RULE BD_later_uncont_P693:
  PRIORITY: 10
  CALL: 6C
  CONDITION: opponents_bid == False
  CONDITION: major_hcp <= 9.5
  CONDITION: controls > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: my_last_call == '3NT'

RULE BD_later_uncont_P694:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: major_hcp > 9.5
  CONDITION: controls > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: my_last_call == '3NT'
  CONDITION: diamond_hcp <= 4.5

RULE BD_later_uncont_P695:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: major_hcp > 9.5
  CONDITION: controls > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: my_last_call == '3NT'
  CONDITION: diamond_hcp > 4.5

RULE BD_later_uncont_P696:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: controls > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call == '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: my_last_call != '3NT'
  CONDITION: major_hcp <= 12.0

RULE BD_later_uncont_P697:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: controls > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call == '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: my_last_call != '3NT'
  CONDITION: major_hcp > 12.0

RULE BD_later_uncont_P698:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: controls > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: c_has_king <= 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: my_last_call != '3NT'

RULE BD_later_uncont_P699:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: controls > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: c_has_king > 0.5
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: my_last_call != '3NT'

RULE BD_later_uncont_P700:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_first_call == '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: agreed_trump_len <= 3.0

RULE BD_later_uncont_P701:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_first_call == '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: agreed_trump_len > 3.0
  CONDITION: hcp <= 11.0

RULE BD_later_uncont_P702:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_first_call == '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: agreed_trump_len > 3.0
  CONDITION: hcp > 11.0

RULE BD_later_uncont_P703:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1S'
  CONDITION: my_first_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: quick_tricks <= 3.75

RULE BD_later_uncont_P704:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1S'
  CONDITION: my_first_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: quick_tricks > 3.75

RULE BD_later_uncont_P705:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: my_last_call == '1H'
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1S'
  CONDITION: my_first_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'

RULE BD_later_uncont_P706:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: my_last_call != '1H'
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1S'
  CONDITION: my_first_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'

RULE BD_later_uncont_P707:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: combined_hcp_min > 22.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1S'
  CONDITION: my_first_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: agreed_trump_len <= 3.5

RULE BD_later_uncont_P708:
  PRIORITY: 10
  CALL: 5D
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: combined_hcp_min > 22.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1S'
  CONDITION: my_first_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: agreed_trump_len > 3.5

RULE BD_later_uncont_P709:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: shape_pattern == '5530'

RULE BD_later_uncont_P710:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: shape_pattern != '5530'

RULE BD_later_uncont_P711:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'
  CONDITION: combined_hcp_max > 29.5
  CONDITION: major_hcp <= 1.5

RULE BD_later_uncont_P712:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'
  CONDITION: combined_hcp_max > 29.5
  CONDITION: major_hcp > 1.5

RULE BD_later_uncont_P713:
  PRIORITY: 10
  CALL: 4H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: my_last_call == '1H'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'

RULE BD_later_uncont_P714:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: my_last_call != '1H'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'

RULE BD_later_uncont_P715:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: agreed_trump_len <= 3.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'

RULE BD_later_uncont_P716:
  PRIORITY: 10
  CALL: 5C
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: agreed_trump_len > 3.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'

RULE BD_later_uncont_P717:
  PRIORITY: 10
  CALL: 4S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'

RULE BD_later_uncont_P719:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'

RULE BD_later_uncont_P720:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: rule20_total <= 21.5
  CONDITION: is_opening == False
  CONDITION: combined_hcp_min <= 26.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'

RULE BD_later_uncont_P721:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: rule20_total > 21.5
  CONDITION: is_opening == False
  CONDITION: combined_hcp_min <= 26.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'

RULE BD_later_uncont_P722:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: combined_hcp_min > 26.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_side_bid_count <= 3.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'

RULE BD_later_uncont_P723:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: combined_hcp_min > 26.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: my_side_bid_count > 3.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'

RULE BD_later_uncont_P724:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: h_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: s_has_queen <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5

RULE BD_later_uncont_P725:
  PRIORITY: 10
  CALL: 6S
  CONDITION: opponents_bid == False
  CONDITION: h_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: s_has_queen > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5

RULE BD_later_uncont_P726:
  PRIORITY: 10
  CALL: 5H
  CONDITION: opponents_bid == False
  CONDITION: h_has_queen <= 0.5
  CONDITION: h_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5

RULE BD_later_uncont_P727:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: h_has_queen > 0.5
  CONDITION: h_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5

RULE BD_later_uncont_P728:
  PRIORITY: 10
  CALL: 5H
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: agreed_trump == 'H'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain == 'D'

RULE BD_later_uncont_P729:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: agreed_trump != 'H'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain == 'D'

RULE BD_later_uncont_P730:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: s_is_best_major <= 0.5

RULE BD_later_uncont_P731:
  PRIORITY: 10
  CALL: 5S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: s_is_best_major > 0.5

RULE BD_later_uncont_P732:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level > 5.5

RULE BD_later_uncont_P733:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: club_len <= 2.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level > 5.5

RULE BD_later_uncont_P734:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: club_len > 2.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level > 5.5

RULE BD_later_uncont_P735:
  PRIORITY: 10
  CALL: 6S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_hcp_min <= 13.0
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level > 5.5

RULE BD_later_uncont_P736:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_hcp_min > 13.0
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level > 5.5

RULE BD_later_uncont_P737:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: c_has_king <= 0.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: partner_hcp_min <= 29.5
  CONDITION: d_has_king <= 0.5

RULE BD_later_uncont_P738:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: c_has_king <= 0.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: partner_hcp_min <= 29.5
  CONDITION: d_has_king > 0.5

RULE BD_later_uncont_P739:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: c_has_king > 0.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: partner_hcp_min <= 29.5
  CONDITION: king_count <= 2.5

RULE BD_later_uncont_P740:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: c_has_king > 0.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: partner_hcp_min <= 29.5
  CONDITION: king_count > 2.5

RULE BD_later_uncont_P741:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: c_has_jack <= 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: partner_hcp_min > 29.5
  CONDITION: major_hcp <= 11.0

RULE BD_later_uncont_P742:
  PRIORITY: 10
  CALL: 6NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: c_has_jack > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: partner_hcp_min > 29.5
  CONDITION: major_hcp <= 11.0

RULE BD_later_uncont_P743:
  PRIORITY: 10
  CALL: 6S
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: partner_hcp_min > 29.5
  CONDITION: major_hcp > 11.0

RULE BD_later_uncont_P744:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: my_last_call == '5C'

RULE BD_later_uncont_P745:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: my_last_call == '5C'

RULE BD_later_uncont_P746:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: last_bid_level <= 5.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: my_last_call != '5C'
  CONDITION: my_last_call == '5D'

RULE BD_later_uncont_P747:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: last_bid_level <= 5.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: my_last_call != '5C'
  CONDITION: my_last_call != '5D'

RULE BD_later_uncont_P748:
  PRIORITY: 10
  CALL: 6S
  CONDITION: opponents_bid == False
  CONDITION: club_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: last_bid_level > 5.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: partner_last_call == '6C'

RULE BD_later_uncont_P749:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: club_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: last_bid_level > 5.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: partner_last_call == '6C'

RULE BD_later_uncont_P750:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: last_bid_level > 5.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: partner_last_call != '6C'
  CONDITION: partner_last_call == '6D'

RULE BD_later_uncont_P751:
  PRIORITY: 10
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: last_bid_level > 5.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: partner_last_call != '6C'
  CONDITION: partner_last_call != '6D'

RULE BD_later_cont_P0:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P1:
  PRIORITY: 10
  CALL: 1H
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P2:
  PRIORITY: 10
  CALL: 1D
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P3:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P4:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5
  CONDITION: minor_hcp <= 2.5

RULE BD_later_cont_P5:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5
  CONDITION: minor_hcp > 2.5

RULE BD_later_cont_P6:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: c_is_longest <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P7:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: c_is_longest <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P8:
  PRIORITY: 10
  CALL: 1D
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points <= 5.5
  CONDITION: c_is_longest > 0.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5
  CONDITION: hcp <= 1.0

RULE BD_later_cont_P9:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points <= 5.5
  CONDITION: c_is_longest > 0.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5
  CONDITION: hcp > 1.0

RULE BD_later_cont_P10:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: major_hcp <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points <= 5.5
  CONDITION: c_is_longest > 0.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P11:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: major_hcp > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points <= 5.5
  CONDITION: c_is_longest > 0.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P12:
  PRIORITY: 10
  CALL: 3C
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points > 5.5
  CONDITION: c_is_longest > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P13:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points > 5.5
  CONDITION: c_is_longest > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P14:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: total_points > 5.5
  CONDITION: c_is_longest > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P15:
  PRIORITY: 10
  CALL: 1H
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 5.5
  CONDITION: c_is_longest > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P16:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len <= 3.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1D'
  CONDITION: heart_hcp <= 5.0
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P17:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len <= 3.5
  CONDITION: h_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1D'
  CONDITION: heart_hcp <= 5.0
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P18:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 8.5
  CONDITION: opening_bid == '1D'
  CONDITION: heart_hcp > 5.0
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P19:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 8.5
  CONDITION: opening_bid == '1D'
  CONDITION: heart_hcp > 5.0
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P20:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: heart_hcp <= 3.5
  CONDITION: opening_bid == '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5
  CONDITION: minor_hcp <= 4.5

RULE BD_later_cont_P21:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: heart_hcp > 3.5
  CONDITION: opening_bid == '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5
  CONDITION: minor_hcp <= 4.5

RULE BD_later_cont_P22:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5
  CONDITION: minor_hcp > 4.5

RULE BD_later_cont_P23:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: second_longest_len <= 3.5
  CONDITION: diamond_len <= 3.5
  CONDITION: opening_bid != '1D'
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P24:
  PRIORITY: 10
  CALL: 1H
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: second_longest_len > 3.5
  CONDITION: diamond_len <= 3.5
  CONDITION: opening_bid != '1D'
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P25:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len <= 3.5
  CONDITION: opening_bid != '1D'
  CONDITION: heart_hcp <= 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P26:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len <= 3.5
  CONDITION: opening_bid != '1D'
  CONDITION: heart_hcp > 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P27:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len > 3.5
  CONDITION: opening_bid != '1D'
  CONDITION: auction_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P28:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len > 3.5
  CONDITION: opening_bid != '1D'
  CONDITION: auction_len > 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P29:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len > 3.5
  CONDITION: opening_bid != '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5
  CONDITION: opp_bid_count <= 2.5

RULE BD_later_cont_P30:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len > 3.5
  CONDITION: opening_bid != '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5
  CONDITION: opp_bid_count > 2.5

RULE BD_later_cont_P31:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: opening_bid == '1S'
  CONDITION: heart_hcp <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P32:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: opening_bid == '1S'
  CONDITION: heart_hcp > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P33:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: opening_bid != '1S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P34:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp > 7.5
  CONDITION: hcp <= 8.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P35:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp > 7.5
  CONDITION: hcp > 8.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P36:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: heart_hcp <= 1.5
  CONDITION: opening_bid == '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P37:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: heart_hcp > 1.5
  CONDITION: opening_bid == '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P38:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: diamond_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opening_bid != '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P39:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: diamond_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opening_bid != '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P40:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opening_bid != '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P41:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opening_bid != '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P42:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: diamond_len <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: rule20_total <= 14.5

RULE BD_later_cont_P43:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: rule20_total <= 14.5

RULE BD_later_cont_P44:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: rule20_total <= 14.5

RULE BD_later_cont_P45:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: s_has_ten <= 0.5
  CONDITION: h_has_queen <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: rule20_total > 14.5

RULE BD_later_cont_P46:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: s_has_ten > 0.5
  CONDITION: h_has_queen <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: rule20_total > 14.5

RULE BD_later_cont_P47:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: h_has_queen > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: rule20_total > 14.5
  CONDITION: major_hcp <= 4.0

RULE BD_later_cont_P48:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: h_has_queen > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: rule20_total > 14.5
  CONDITION: major_hcp > 4.0

RULE BD_later_cont_P49:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: major_hcp <= 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P50:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: major_hcp <= 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P51:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: major_hcp > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: passes_since_last_bid <= 2.0

RULE BD_later_cont_P52:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: major_hcp > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: passes_since_last_bid > 2.0

RULE BD_later_cont_P53:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: auction_len <= 6.0

RULE BD_later_cont_P54:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: auction_len > 6.0

RULE BD_later_cont_P55:
  PRIORITY: 10
  CALL: 1H
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: rule20_total <= 16.5

RULE BD_later_cont_P56:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: rule20_total > 16.5

RULE BD_later_cont_P57:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 5.5
  CONDITION: shape_pattern == '5521'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P58:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 5.5
  CONDITION: shape_pattern == '5521'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P59:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 5.5
  CONDITION: shape_pattern != '5521'
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P60:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 5.5
  CONDITION: shape_pattern != '5521'
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P61:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: diamond_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 5.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P62:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: diamond_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 5.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P63:
  PRIORITY: 10
  CALL: 3C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: diamond_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len <= 4.5
  CONDITION: club_len > 5.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P64:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: diamond_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len > 3.5
  CONDITION: club_len > 5.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P65:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_has_ten <= 0.5
  CONDITION: diamond_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P66:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_has_ten > 0.5
  CONDITION: diamond_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P67:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: total_points <= 11.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P68:
  PRIORITY: 10
  CALL: 4D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: total_points > 9.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P69:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_suit_stoppers <= 0.75

RULE BD_later_cont_P70:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_suit_stoppers > 0.75

RULE BD_later_cont_P71:
  PRIORITY: 10
  CALL: 4D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: diamond_len > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P72:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: diamond_len > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P73:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total <= 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: auction_len <= 11.5

RULE BD_later_cont_P74:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total <= 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: auction_len > 11.5
  CONDITION: diamond_hcp <= 1.0

RULE BD_later_cont_P75:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total <= 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: auction_len > 11.5
  CONDITION: diamond_hcp > 1.0

RULE BD_later_cont_P76:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len <= 4.5
  CONDITION: third_longest_len <= 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: total_points <= 10.5

RULE BD_later_cont_P77:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len <= 4.5
  CONDITION: third_longest_len <= 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: total_points > 10.5

RULE BD_later_cont_P78:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: c_has_jack <= 0.5
  CONDITION: diamond_len <= 4.5
  CONDITION: third_longest_len > 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P79:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: c_has_jack > 0.5
  CONDITION: diamond_len <= 4.5
  CONDITION: third_longest_len > 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P80:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len <= 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P81:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: diamond_len > 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P82:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: d_stopper <= 0.5

RULE BD_later_cont_P83:
  PRIORITY: 10
  CALL: 1D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: d_stopper > 0.5

RULE BD_later_cont_P84:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points <= 9.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P85:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points > 9.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: king_count <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P86:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points > 9.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: king_count > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P87:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: club_hcp <= 6.5

RULE BD_later_cont_P88:
  PRIORITY: 10
  CALL: 2S
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: club_hcp > 6.5

RULE BD_later_cont_P89:
  PRIORITY: 10
  CALL: 1H
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: h_has_ten <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: heart_hcp <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P90:
  PRIORITY: 10
  CALL: 1H
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: h_has_ten > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: heart_hcp <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P91:
  PRIORITY: 10
  CALL: 1H
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: rule20_total <= 18.5
  CONDITION: heart_hcp > 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P92:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: rule20_total > 18.5
  CONDITION: heart_hcp > 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P93:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: h_stopper <= 0.5

RULE BD_later_cont_P94:
  PRIORITY: 10
  CALL: 1H
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: h_stopper > 0.5

RULE BD_later_cont_P95:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P96:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P97:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_suit_stoppers <= 0.25

RULE BD_later_cont_P98:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_suit_stoppers > 0.25

RULE BD_later_cont_P99:
  PRIORITY: 10
  CALL: 4H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len > 6.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P100:
  PRIORITY: 10
  CALL: 3H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len > 6.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P101:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1S'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P102:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: club_hcp <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1S'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P103:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: club_hcp > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1S'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P104:
  PRIORITY: 10
  CALL: 4H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp <= 5.5
  CONDITION: shape_pattern == '8221'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P105:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp <= 5.5
  CONDITION: shape_pattern != '8221'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: s_has_king <= 0.5

RULE BD_later_cont_P106:
  PRIORITY: 10
  CALL: 3H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp <= 5.5
  CONDITION: shape_pattern != '8221'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: s_has_king > 0.5

RULE BD_later_cont_P107:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: h_has_ten <= 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P108:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: h_has_ten > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P109:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P110:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P111:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len > 4.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: jack_count <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P112:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: spade_len > 4.5
  CONDITION: c_is_best_minor > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: jack_count <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: major_hcp <= 2.5

RULE BD_later_cont_P113:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len > 4.5
  CONDITION: c_is_best_minor > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: jack_count <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: major_hcp > 2.5

RULE BD_later_cont_P114:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: jack_count > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P115:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: jack_count > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P116:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: total_points <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count <= 1.5

RULE BD_later_cont_P118:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: total_points <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points <= 4.5
  CONDITION: competition_level <= 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P119:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: total_points <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 4.5
  CONDITION: competition_level <= 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_bid_count > 1.5

RULE BD_later_cont_P120:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: total_points <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: competition_level > 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P121:
  PRIORITY: 10
  CALL: 1H
  CONDITION: spade_len > 4.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P122:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_hcp <= 3.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P123:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_hcp > 3.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P124:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P125:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len > 4.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: major_hcp <= 4.5
  CONDITION: auction_len > 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P126:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len > 4.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: major_hcp > 4.5
  CONDITION: auction_len > 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P127:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total <= 16.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P128:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp <= 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total <= 16.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P129:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total <= 16.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P130:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp <= 3.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: major_hcp <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: my_seat == 'N'

RULE BD_later_cont_P131:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp > 3.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: major_hcp <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: my_seat == 'N'

RULE BD_later_cont_P132:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp <= 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: major_hcp > 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: my_seat == 'N'

RULE BD_later_cont_P133:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: major_hcp > 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: my_seat == 'N'

RULE BD_later_cont_P134:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: total_points <= 10.5
  CONDITION: my_seat != 'N'

RULE BD_later_cont_P135:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: total_points <= 10.5
  CONDITION: my_seat != 'N'

RULE BD_later_cont_P136:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len > 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: total_points > 10.5
  CONDITION: my_seat != 'N'
  CONDITION: opp_suit_stoppers <= 0.5

RULE BD_later_cont_P137:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: total_points > 10.5
  CONDITION: my_seat != 'N'
  CONDITION: opp_suit_stoppers > 0.5

RULE BD_later_cont_P138:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len <= 7.5

RULE BD_later_cont_P139:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len > 7.5

RULE BD_later_cont_P140:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: hcp > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_hcp <= 5.5

RULE BD_later_cont_P141:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 4.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: hcp > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_hcp <= 5.5

RULE BD_later_cont_P142:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: hcp > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_hcp > 5.5

RULE BD_later_cont_P143:
  PRIORITY: 10
  CALL: 3S
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: hcp > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_hcp > 5.5

RULE BD_later_cont_P144:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: hcp > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_suit_stoppers <= 1.5
  CONDITION: spade_hcp <= 1.5

RULE BD_later_cont_P145:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: hcp > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_suit_stoppers <= 1.5
  CONDITION: spade_hcp > 1.5

RULE BD_later_cont_P146:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: auction_len <= 1.5
  CONDITION: hcp > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_suit_stoppers > 1.5

RULE BD_later_cont_P147:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: auction_len > 1.5
  CONDITION: hcp > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_suit_stoppers > 1.5

RULE BD_later_cont_P148:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: minor_hcp <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P149:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: minor_hcp > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'

RULE BD_later_cont_P150:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern == '7321'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: major_hcp <= 7.0

RULE BD_later_cont_P151:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern == '7321'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: major_hcp > 7.0

RULE BD_later_cont_P152:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern != '7321'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: club_hcp <= 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P153:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern != '7321'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: club_hcp > 4.5
  CONDITION: spade_hcp <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P154:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern != '7321'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: club_hcp > 4.5
  CONDITION: spade_hcp > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P155:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp <= 8.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: d_has_queen <= 0.5

RULE BD_later_cont_P156:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp <= 8.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: d_has_queen > 0.5

RULE BD_later_cont_P157:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp > 8.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'

RULE BD_later_cont_P158:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: spade_hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5

RULE BD_later_cont_P159:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: spade_hcp > 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5

RULE BD_later_cont_P160:
  PRIORITY: 10
  CALL: 1S
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: d_has_ten <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: s_stopper <= 0.5

RULE BD_later_cont_P161:
  PRIORITY: 10
  CALL: 2S
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: d_has_ten > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: s_stopper <= 0.5

RULE BD_later_cont_P162:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: s_stopper <= 0.5

RULE BD_later_cont_P163:
  PRIORITY: 10
  CALL: 2D
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: s_stopper <= 0.5

RULE BD_later_cont_P164:
  PRIORITY: 10
  CALL: 2S
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call == 'X'
  CONDITION: s_stopper > 0.5

RULE BD_later_cont_P165:
  PRIORITY: 10
  CALL: 1S
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: s_stopper > 0.5

RULE BD_later_cont_P166:
  PRIORITY: 10
  CALL: 2D
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: s_stopper > 0.5

RULE BD_later_cont_P167:
  PRIORITY: 10
  CALL: 2C
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: s_stopper > 0.5

RULE BD_later_cont_P168:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: my_seat == 'S'

RULE BD_later_cont_P169:
  PRIORITY: 10
  CALL: 3S
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: my_seat != 'S'
  CONDITION: vuln_pressure == 'equal'

RULE BD_later_cont_P170:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: my_seat != 'S'
  CONDITION: vuln_pressure != 'equal'

RULE BD_later_cont_P171:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_hcp <= 4.0

RULE BD_later_cont_P172:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_hcp > 4.0

RULE BD_later_cont_P173:
  PRIORITY: 10
  CALL: 4H
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: diamond_hcp <= 0.5

RULE BD_later_cont_P174:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: diamond_hcp > 0.5

RULE BD_later_cont_P175:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5

RULE BD_later_cont_P176:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: s_stopper <= 0.5

RULE BD_later_cont_P177:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: s_stopper > 0.5

RULE BD_later_cont_P178:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: s_stopper > 0.5

RULE BD_later_cont_P179:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P180:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P181:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P182:
  PRIORITY: 10
  CALL: 2H
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P183:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P184:
  PRIORITY: 10
  CALL: 2H
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P185:
  PRIORITY: 10
  CALL: 2S
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_suit_stoppers <= 1.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P186:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_suit_stoppers > 1.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P187:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points <= 11.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: my_seat == 'N'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P188:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points <= 11.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: my_seat != 'N'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P189:
  PRIORITY: 10
  CALL: X
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points > 9.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P190:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points > 9.5
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P191:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len <= 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: longest_suit_len > 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P192:
  PRIORITY: 10
  CALL: 1D
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: longest_suit_len > 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P193:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: longest_suit_len > 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P194:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 3.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: longest_suit_len > 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P195:
  PRIORITY: 10
  CALL: 2D
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P196:
  PRIORITY: 10
  CALL: 3D
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P197:
  PRIORITY: 10
  CALL: 1D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: club_len <= 0.5

RULE BD_later_cont_P198:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: club_len > 0.5

RULE BD_later_cont_P199:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P200:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len > 3.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P201:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P202:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 11.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P203:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 3.5
  CONDITION: diamond_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P204:
  PRIORITY: 10
  CALL: 3C
  CONDITION: hcp <= 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 3.5
  CONDITION: diamond_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P205:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 11.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 3.5
  CONDITION: diamond_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P206:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 11.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 3.5
  CONDITION: diamond_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P207:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: opponents_bid == True
  CONDITION: major_hcp <= 2.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: club_hcp <= 9.5

RULE BD_later_cont_P208:
  PRIORITY: 10
  CALL: 4C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: opponents_bid == True
  CONDITION: major_hcp <= 2.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: club_hcp > 9.5

RULE BD_later_cont_P209:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: opponents_bid == True
  CONDITION: major_hcp > 2.5
  CONDITION: spade_hcp <= 1.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P210:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len > 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: opponents_bid == True
  CONDITION: major_hcp > 2.5
  CONDITION: spade_hcp > 1.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5

RULE BD_later_cont_P211:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max <= 24.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5

RULE BD_later_cont_P212:
  PRIORITY: 10
  CALL: 3C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max <= 24.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5

RULE BD_later_cont_P213:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max > 24.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: partner_first_call == '1NT'

RULE BD_later_cont_P214:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max > 24.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: partner_first_call != '1NT'

RULE BD_later_cont_P215:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5

RULE BD_later_cont_P216:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5

RULE BD_later_cont_P217:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5

RULE BD_later_cont_P218:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5

RULE BD_later_cont_P219:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5

RULE BD_later_cont_P220:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5

RULE BD_later_cont_P221:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: my_side_bid_count <= 0.5

RULE BD_later_cont_P222:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: my_side_bid_count > 0.5

RULE BD_later_cont_P223:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5

RULE BD_later_cont_P224:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5

RULE BD_later_cont_P225:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: diamond_len <= 5.0
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5

RULE BD_later_cont_P226:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: diamond_len > 5.0
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5

RULE BD_later_cont_P227:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: partner_first_call == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max <= 27.5

RULE BD_later_cont_P228:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: partner_first_call == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max <= 27.5

RULE BD_later_cont_P229:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid == '1S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: partner_first_call != '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max <= 27.5

RULE BD_later_cont_P230:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: partner_first_call != '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max <= 27.5

RULE BD_later_cont_P231:
  PRIORITY: 10
  CALL: 3D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: opening_bid == '1C'
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max <= 27.5

RULE BD_later_cont_P232:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: opening_bid != '1C'
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max <= 27.5

RULE BD_later_cont_P233:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_first_call == '1C'
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max <= 27.5

RULE BD_later_cont_P234:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_first_call != '1C'
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max <= 27.5

RULE BD_later_cont_P235:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1S'

RULE BD_later_cont_P236:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 9.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1S'

RULE BD_later_cont_P237:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1S'
  CONDITION: opp_last_call == '1C'

RULE BD_later_cont_P238:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1S'
  CONDITION: opp_last_call != '1C'

RULE BD_later_cont_P239:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1S'
  CONDITION: partner_last_call == '1H'

RULE BD_later_cont_P240:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1S'
  CONDITION: partner_last_call != '1H'

RULE BD_later_cont_P242:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1S'

RULE BD_later_cont_P243:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: hcp <= 3.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: competition_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P244:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: hcp > 3.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: competition_level <= 2.5
  CONDITION: s_has_queen <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P245:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: hcp > 3.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: competition_level <= 2.5
  CONDITION: s_has_queen > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P246:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: hcp > 3.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: competition_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P247:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: competition_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P248:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: competition_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P249:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: competition_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P250:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: hcp <= 2.5

RULE BD_later_cont_P251:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: hcp > 2.5

RULE BD_later_cont_P252:
  PRIORITY: 10
  CALL: 3H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: hcp > 2.5

RULE BD_later_cont_P253:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: my_side_bid_count <= 0.5

RULE BD_later_cont_P254:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: my_side_bid_count > 0.5

RULE BD_later_cont_P255:
  PRIORITY: 10
  CALL: 4H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: my_last_call == '1H'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P256:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: my_last_call != '1H'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P257:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: hcp > 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: passes_since_last_bid <= 1.0

RULE BD_later_cont_P258:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid == '1S'
  CONDITION: hcp > 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: passes_since_last_bid > 1.0

RULE BD_later_cont_P259:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_first_call == 'PASS'

RULE BD_later_cont_P260:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_first_call != 'PASS'

RULE BD_later_cont_P261:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_seat == 'E'
  CONDITION: hcp > 7.5
  CONDITION: diamond_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P262:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_seat == 'E'
  CONDITION: hcp > 7.5
  CONDITION: diamond_len > 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P263:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_seat != 'E'
  CONDITION: hcp > 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: last_bid_seat == 'W'

RULE BD_later_cont_P264:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_seat != 'E'
  CONDITION: hcp > 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: last_bid_seat != 'W'

RULE BD_later_cont_P265:
  PRIORITY: 10
  CALL: 4H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: opponents_bid == True
  CONDITION: s_has_king <= 0.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: c_has_queen <= 0.5

RULE BD_later_cont_P266:
  PRIORITY: 10
  CALL: 4H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: opponents_bid == True
  CONDITION: s_has_king > 0.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: c_has_queen <= 0.5

RULE BD_later_cont_P267:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: hcp <= 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: c_has_queen > 0.5

RULE BD_later_cont_P268:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 6.5
  CONDITION: hcp > 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: c_has_queen > 0.5

RULE BD_later_cont_P269:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 9.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call == 'PASS'

RULE BD_later_cont_P270:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call == 'PASS'

RULE BD_later_cont_P271:
  PRIORITY: 10
  CALL: 4D
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call == 'PASS'

RULE BD_later_cont_P272:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: rule20_total <= 16.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call != 'PASS'

RULE BD_later_cont_P273:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: rule20_total > 16.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call != 'PASS'

RULE BD_later_cont_P274:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call != 'PASS'

RULE BD_later_cont_P275:
  PRIORITY: 10
  CALL: 4H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call != 'PASS'

RULE BD_later_cont_P277:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P278:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P279:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P280:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P281:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P282:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: my_seat == 'E'
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P283:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: my_seat != 'E'
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P284:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: opening_bid == '1H'
  CONDITION: opponents_bid == True
  CONDITION: my_seat == 'N'
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P285:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: my_seat == 'N'
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P286:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: opponents_bid == True
  CONDITION: my_seat != 'N'
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P287:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: opponents_bid == True
  CONDITION: my_seat != 'N'
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P288:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P289:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P290:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: c_stopper <= 0.5

RULE BD_later_cont_P291:
  PRIORITY: 10
  CALL: XX
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: c_stopper > 0.5

RULE BD_later_cont_P292:
  PRIORITY: 10
  CALL: 1H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp <= 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P293:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 17.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P294:
  PRIORITY: 10
  CALL: 2H
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P295:
  PRIORITY: 10
  CALL: 1H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P296:
  PRIORITY: 10
  CALL: 3C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_hcp <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: hcp <= 7.0

RULE BD_later_cont_P297:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_hcp <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: hcp > 7.0

RULE BD_later_cont_P298:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_hcp > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers <= 1.5
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P299:
  PRIORITY: 10
  CALL: 1H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_hcp > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 1.5
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P300:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'

RULE BD_later_cont_P301:
  PRIORITY: 10
  CALL: 4H
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp > 7.5
  CONDITION: hcp <= 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'

RULE BD_later_cont_P302:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp > 7.5
  CONDITION: hcp > 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: hcp <= 17.0
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'

RULE BD_later_cont_P303:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp > 7.5
  CONDITION: hcp > 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: hcp > 17.0
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'

RULE BD_later_cont_P304:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: partner_first_call == 'X'

RULE BD_later_cont_P305:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: partner_first_call == 'X'

RULE BD_later_cont_P306:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: partner_first_call != 'X'
  CONDITION: minor_hcp <= 8.5

RULE BD_later_cont_P307:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: partner_first_call != 'X'
  CONDITION: minor_hcp > 8.5

RULE BD_later_cont_P308:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: minor_hcp <= 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'

RULE BD_later_cont_P309:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: minor_hcp > 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'

RULE BD_later_cont_P310:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 10.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'

RULE BD_later_cont_P311:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 10.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'

RULE BD_later_cont_P312:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp <= 10.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points > 14.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: ace_count <= 1.5
  CONDITION: major_hcp <= 6.0

RULE BD_later_cont_P313:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp <= 10.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points > 14.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: ace_count <= 1.5
  CONDITION: major_hcp > 6.0

RULE BD_later_cont_P314:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp > 10.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points > 14.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: ace_count <= 1.5

RULE BD_later_cont_P315:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: spade_len > 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_opened <= 0.5
  CONDITION: total_points > 14.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: ace_count > 1.5

RULE BD_later_cont_P316:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_opened <= 0.5
  CONDITION: total_points > 14.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: ace_count > 1.5

RULE BD_later_cont_P317:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_opened > 0.5
  CONDITION: total_points > 14.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1NT'
  CONDITION: ace_count > 1.5

RULE BD_later_cont_P318:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: hcp <= 15.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'
  CONDITION: minor_hcp <= 10.5
  CONDITION: partner_last_call == 'XX'

RULE BD_later_cont_P319:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: my_seat == 'E'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: hcp <= 15.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'
  CONDITION: minor_hcp <= 10.5
  CONDITION: partner_last_call != 'XX'

RULE BD_later_cont_P320:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: my_seat != 'E'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: hcp <= 15.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'
  CONDITION: minor_hcp <= 10.5
  CONDITION: partner_last_call != 'XX'

RULE BD_later_cont_P321:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: hcp <= 15.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'
  CONDITION: minor_hcp > 10.5

RULE BD_later_cont_P322:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: hcp > 15.5
  CONDITION: hcp <= 18.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'
  CONDITION: club_hcp <= 2.5

RULE BD_later_cont_P323:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: hcp > 15.5
  CONDITION: hcp > 18.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'
  CONDITION: club_hcp <= 2.5

RULE BD_later_cont_P324:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: hcp > 15.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'
  CONDITION: club_hcp > 2.5

RULE BD_later_cont_P325:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: spade_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: hcp <= 16.0
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P326:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: spade_len <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: hcp > 16.0
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P327:
  PRIORITY: 10
  CALL: 3S
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: spade_len > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'
  CONDITION: controls <= 3.5

RULE BD_later_cont_P328:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: spade_len > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'
  CONDITION: controls > 3.5

RULE BD_later_cont_P329:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len > 3.5
  CONDITION: total_points <= 11.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P330:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: shape_pattern != '5332'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len > 3.5
  CONDITION: total_points > 9.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P331:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 3.5
  CONDITION: shape_pattern != '5332'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len > 3.5
  CONDITION: total_points > 9.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P332:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 11.5
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P333:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P334:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: third_longest_len <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P335:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: third_longest_len > 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P336:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 1.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: c_has_queen <= 0.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P337:
  PRIORITY: 10
  CALL: 3S
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 1.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: c_has_queen > 0.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P338:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: jack_count <= 0.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 1.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P339:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: jack_count > 0.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 1.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1NT'

RULE BD_later_cont_P340:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_last_call == '1S'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 16.5

RULE BD_later_cont_P341:
  PRIORITY: 10
  CALL: XX
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_last_call == '1S'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 16.5

RULE BD_later_cont_P342:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern == '5332'
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_last_call != '1S'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 16.5

RULE BD_later_cont_P343:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: shape_pattern != '5332'
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: my_last_call != '1S'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 16.5

RULE BD_later_cont_P344:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: d_has_king <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: vuln_pressure == 'equal'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 16.5

RULE BD_later_cont_P345:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: d_has_king <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: vuln_pressure != 'equal'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 16.5

RULE BD_later_cont_P346:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: major_hcp <= 6.5
  CONDITION: d_has_king > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 16.5

RULE BD_later_cont_P347:
  PRIORITY: 10
  CALL: 4H
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: major_hcp > 6.5
  CONDITION: d_has_king > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 16.5

RULE BD_later_cont_P348:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: heart_hcp <= 1.5
  CONDITION: opening_bid == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 16.5
  CONDITION: hcp <= 10.0

RULE BD_later_cont_P349:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: heart_hcp <= 1.5
  CONDITION: opening_bid == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 16.5
  CONDITION: hcp > 10.0

RULE BD_later_cont_P350:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 8.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: heart_hcp > 1.5
  CONDITION: opening_bid == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 16.5

RULE BD_later_cont_P351:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 8.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: heart_hcp > 1.5
  CONDITION: opening_bid == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 16.5

RULE BD_later_cont_P352:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 16.5
  CONDITION: ace_count <= 0.5

RULE BD_later_cont_P353:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 16.5
  CONDITION: ace_count > 0.5

RULE BD_later_cont_P354:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp > 5.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 16.5

RULE BD_later_cont_P355:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp > 5.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 16.5

RULE BD_later_cont_P356:
  PRIORITY: 10
  CALL: 3S
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: spade_hcp <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: c_stopper <= 0.5
  CONDITION: heart_hcp <= 2.0

RULE BD_later_cont_P357:
  PRIORITY: 10
  CALL: 3D
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: spade_hcp > 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: c_stopper <= 0.5
  CONDITION: heart_hcp <= 2.0

RULE BD_later_cont_P358:
  PRIORITY: 10
  CALL: 1NT
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: c_stopper > 0.5
  CONDITION: heart_hcp <= 2.0

RULE BD_later_cont_P359:
  PRIORITY: 10
  CALL: 3D
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: c_stopper > 0.5
  CONDITION: heart_hcp <= 2.0

RULE BD_later_cont_P360:
  PRIORITY: 10
  CALL: 3H
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: heart_hcp > 2.0

RULE BD_later_cont_P361:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: heart_hcp > 2.0

RULE BD_later_cont_P362:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: heart_hcp > 2.0

RULE BD_later_cont_P363:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp > 8.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid == '1D'
  CONDITION: controls <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P364:
  PRIORITY: 10
  CALL: 2D
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp > 8.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid == '1D'
  CONDITION: controls > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P365:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len > 4.5
  CONDITION: club_hcp <= 6.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp > 8.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P366:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len > 4.5
  CONDITION: club_hcp > 6.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp > 8.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P367:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1H'

RULE BD_later_cont_P368:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1H'

RULE BD_later_cont_P369:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1H'

RULE BD_later_cont_P370:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 9.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1H'

RULE BD_later_cont_P371:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 9.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1H'

RULE BD_later_cont_P372:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 9.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call == '1H'

RULE BD_later_cont_P373:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1H'

RULE BD_later_cont_P374:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1H'

RULE BD_later_cont_P375:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1H'
  CONDITION: spade_hcp <= 2.5

RULE BD_later_cont_P376:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1H'
  CONDITION: spade_hcp > 2.5

RULE BD_later_cont_P377:
  PRIORITY: 10
  CALL: 2S
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1H'
  CONDITION: combined_hcp_min <= 11.5

RULE BD_later_cont_P378:
  PRIORITY: 10
  CALL: 3S
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1H'
  CONDITION: combined_hcp_min <= 11.5

RULE BD_later_cont_P379:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp <= 16.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1H'
  CONDITION: combined_hcp_min > 11.5

RULE BD_later_cont_P380:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 16.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: partner_last_call != '1H'
  CONDITION: combined_hcp_min > 11.5

RULE BD_later_cont_P381:
  PRIORITY: 10
  CALL: 3S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.0
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: passes_since_last_bid <= 1.0

RULE BD_later_cont_P382:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 10.5
  CONDITION: heart_len <= 4.0
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: passes_since_last_bid > 1.0

RULE BD_later_cont_P383:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 10.5
  CONDITION: heart_len <= 4.0
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: passes_since_last_bid > 1.0

RULE BD_later_cont_P384:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.0
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid == '1H'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P385:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.0
  CONDITION: s_is_longest <= 0.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 1.5
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P386:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.0
  CONDITION: second_longest_len > 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 1.5
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P387:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.0
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: total_points <= 13.5
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 1.5
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P388:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.0
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: total_points > 13.5
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 1.5
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P389:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.0
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points <= 11.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P390:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.0
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 9.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_strain == 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P391:
  PRIORITY: 10
  CALL: 1H
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.0
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: competition_level <= 1.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P392:
  PRIORITY: 10
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.0
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: competition_level > 1.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5

RULE BD_later_cont_P393:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: total_points <= 12.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P394:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: total_points <= 12.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P395:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: total_points <= 12.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P396:
  PRIORITY: 10
  CALL: 2D
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: total_points <= 12.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P397:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: total_points > 12.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P398:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: total_points > 12.5
  CONDITION: last_bid_level > 3.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P399:
  PRIORITY: 10
  CALL: 4D
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: total_points > 12.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_first_call == '3S'

RULE BD_later_cont_P400:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: total_points > 12.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_first_call != '3S'

RULE BD_later_cont_P401:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: heart_hcp <= 4.5
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_fit_shown <= 0.5

RULE BD_later_cont_P402:
  PRIORITY: 10
  CALL: 4H
  CONDITION: losing_trick_count <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: heart_hcp > 4.5
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_fit_shown <= 0.5

RULE BD_later_cont_P403:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count > 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: heart_hcp > 4.5
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_fit_shown <= 0.5

RULE BD_later_cont_P404:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: c_has_king <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_fit_shown > 0.5

RULE BD_later_cont_P405:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: c_has_king > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_fit_shown > 0.5

RULE BD_later_cont_P406:
  PRIORITY: 10
  CALL: 4H
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: spade_hcp <= 1.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_fit_shown > 0.5

RULE BD_later_cont_P407:
  PRIORITY: 10
  CALL: 2H
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: spade_hcp > 1.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_fit_shown > 0.5

RULE BD_later_cont_P408:
  PRIORITY: 10
  CALL: 4S
  CONDITION: heart_len <= 0.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: hcp <= 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid == '1H'
  CONDITION: hcp <= 9.0
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P409:
  PRIORITY: 10
  CALL: 3S
  CONDITION: heart_len <= 0.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: hcp > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid == '1H'
  CONDITION: hcp <= 9.0
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P410:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len > 0.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid == '1H'
  CONDITION: hcp <= 9.0
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P411:
  PRIORITY: 10
  CALL: 3S
  CONDITION: major_hcp <= 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: major_hcp <= 6.5
  CONDITION: opening_bid == '1H'
  CONDITION: hcp > 9.0
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P412:
  PRIORITY: 10
  CALL: 2S
  CONDITION: major_hcp > 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: major_hcp <= 6.5
  CONDITION: opening_bid == '1H'
  CONDITION: hcp > 9.0
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P413:
  PRIORITY: 10
  CALL: 3S
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: major_hcp > 6.5
  CONDITION: opening_bid == '1H'
  CONDITION: hcp > 9.0
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P414:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: hcp <= 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: s_has_king <= 0.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P415:
  PRIORITY: 10
  CALL: 2S
  CONDITION: losing_trick_count <= 7.5
  CONDITION: hcp > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: s_has_king <= 0.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P416:
  PRIORITY: 10
  CALL: 3S
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: singleton_count <= 0.5
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: s_has_king > 0.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P417:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: singleton_count > 0.5
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: s_has_king > 0.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P418:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len <= 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 1.5
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: spade_len <= 7.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P419:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len > 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 1.5
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: spade_len <= 7.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P420:
  PRIORITY: 10
  CALL: 4S
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 1.5
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: spade_len > 7.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P421:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: third_longest_len <= 2.5
  CONDITION: competition_level > 2.5
  CONDITION: club_len <= 5.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: my_seat == 'N'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P422:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: third_longest_len <= 2.5
  CONDITION: competition_level > 2.5
  CONDITION: club_len > 5.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: my_seat == 'N'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P423:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: third_longest_len <= 2.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: my_seat != 'N'
  CONDITION: partner_first_call == 'X'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P424:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: third_longest_len <= 2.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: my_seat != 'N'
  CONDITION: partner_first_call != 'X'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P425:
  PRIORITY: 10
  CALL: 3C
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: c_has_ten <= 0.5
  CONDITION: third_longest_len > 2.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: my_last_call == '2C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P426:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: c_has_ten > 0.5
  CONDITION: third_longest_len > 2.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: my_last_call == '2C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P427:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: third_longest_len > 2.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: my_last_call != '2C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P428:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: third_longest_len > 2.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: competition_level > 3.5
  CONDITION: my_last_call != '2C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P429:
  PRIORITY: 10
  CALL: X
  CONDITION: major_hcp <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: doubleton_count <= 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P430:
  PRIORITY: 10
  CALL: PASS
  CONDITION: major_hcp > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: doubleton_count <= 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P431:
  PRIORITY: 10
  CALL: PASS
  CONDITION: my_seat == 'E'
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: doubleton_count > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P432:
  PRIORITY: 10
  CALL: PASS
  CONDITION: my_seat != 'E'
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: doubleton_count > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P433:
  PRIORITY: 10
  CALL: PASS
  CONDITION: major_hcp <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level > 4.5
  CONDITION: major_hcp <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P434:
  PRIORITY: 10
  CALL: 3C
  CONDITION: major_hcp <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level > 4.5
  CONDITION: major_hcp > 1.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P435:
  PRIORITY: 10
  CALL: 3D
  CONDITION: major_hcp > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: major_hcp <= 8.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level > 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P436:
  PRIORITY: 10
  CALL: 3H
  CONDITION: major_hcp > 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: major_hcp > 8.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level > 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P437:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: club_hcp <= 3.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_last_call == '5C'

RULE BD_later_cont_P438:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: minor_hcp <= 5.5
  CONDITION: club_hcp > 3.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_last_call == '5C'

RULE BD_later_cont_P439:
  PRIORITY: 10
  CALL: X
  CONDITION: losing_trick_count <= 7.5
  CONDITION: minor_hcp > 5.5
  CONDITION: club_hcp > 3.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_last_call == '5C'

RULE BD_later_cont_P440:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: diamond_len <= 4.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_last_call != '5C'

RULE BD_later_cont_P441:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: diamond_len > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_last_call != '5C'

RULE BD_later_cont_P442:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_last_call != '5C'
  CONDITION: opp_first_call == '1C'

RULE BD_later_cont_P443:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_last_call != '5C'
  CONDITION: opp_first_call != '1C'

RULE BD_later_cont_P444:
  PRIORITY: 10
  CALL: X
  CONDITION: major_hcp <= 7.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: diamond_len <= 1.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call != 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_first_call == '3S'

RULE BD_later_cont_P445:
  PRIORITY: 10
  CALL: PASS
  CONDITION: major_hcp <= 7.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: diamond_len <= 1.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call != 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_first_call != '3S'

RULE BD_later_cont_P446:
  PRIORITY: 10
  CALL: 3S
  CONDITION: major_hcp > 7.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: diamond_len <= 1.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call != 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P447:
  PRIORITY: 10
  CALL: 4S
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: diamond_len > 1.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call == '2S'
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call != 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_last_call == '4H'

RULE BD_later_cont_P448:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: diamond_len > 1.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call == '2S'
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call != 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_last_call != '4H'

RULE BD_later_cont_P449:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: diamond_len > 1.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call != '2S'
  CONDITION: opponents_bid == True
  CONDITION: partner_first_call != 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P450:
  PRIORITY: 10
  CALL: 2S
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: total_points <= 11.5
  CONDITION: diamond_len <= 1.5
  CONDITION: opening_bid == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call == '2H'

RULE BD_later_cont_P451:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: total_points <= 11.5
  CONDITION: diamond_len > 1.5
  CONDITION: opening_bid == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call == '2H'

RULE BD_later_cont_P452:
  PRIORITY: 10
  CALL: X
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: total_points > 9.5
  CONDITION: opening_bid == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call == '2H'

RULE BD_later_cont_P453:
  PRIORITY: 10
  CALL: 3D
  CONDITION: losing_trick_count > 7.5
  CONDITION: hcp <= 8.0
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call != '2H'
  CONDITION: opp_last_call == '2S'

RULE BD_later_cont_P454:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count > 7.5
  CONDITION: hcp > 8.0
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call != '2H'
  CONDITION: opp_last_call == '2S'

RULE BD_later_cont_P455:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call != '2H'
  CONDITION: opp_last_call != '2S'

RULE BD_later_cont_P456:
  PRIORITY: 10
  CALL: 2D
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: auction_len <= 9.5

RULE BD_later_cont_P457:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: auction_len > 9.5

RULE BD_later_cont_P458:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opening_bid == '2C'

RULE BD_later_cont_P459:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opening_bid != '2C'

RULE BD_later_cont_P460:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 10.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: partner_first_call == 'X'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5

RULE BD_later_cont_P461:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 10.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: partner_first_call != 'X'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5

RULE BD_later_cont_P462:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp > 10.5
  CONDITION: major_hcp <= 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5

RULE BD_later_cont_P463:
  PRIORITY: 10
  CALL: X
  CONDITION: hcp > 10.5
  CONDITION: major_hcp > 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5

RULE BD_later_cont_P464:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 8.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '2C'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call == '2S'

RULE BD_later_cont_P465:
  PRIORITY: 10
  CALL: 3C
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: hcp > 8.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '2C'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call == '2S'

RULE BD_later_cont_P466:
  PRIORITY: 10
  CALL: PASS
  CONDITION: diamond_len <= 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '2C'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: partner_first_call == 'X'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call == '2S'

RULE BD_later_cont_P467:
  PRIORITY: 10
  CALL: PASS
  CONDITION: diamond_len <= 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '2C'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: partner_first_call != 'X'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call == '2S'

RULE BD_later_cont_P468:
  PRIORITY: 10
  CALL: PASS
  CONDITION: diamond_len > 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: heart_hcp <= 2.5
  CONDITION: my_last_call != '2C'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call == '2S'

RULE BD_later_cont_P469:
  PRIORITY: 10
  CALL: 3D
  CONDITION: diamond_len > 5.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: heart_hcp > 2.5
  CONDITION: my_last_call != '2C'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call == '2S'

RULE BD_later_cont_P470:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_last_call != '2S'

RULE BD_later_cont_P471:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count > 7.5
  CONDITION: hcp <= 8.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '5C'
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers <= 0.75
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level > 4.5

RULE BD_later_cont_P472:
  PRIORITY: 10
  CALL: X
  CONDITION: losing_trick_count > 7.5
  CONDITION: hcp > 8.0
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '5C'
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers <= 0.75
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level > 4.5

RULE BD_later_cont_P473:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '5C'
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers <= 0.75
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level > 4.5

RULE BD_later_cont_P474:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: doubleton_count <= 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_bid_count <= 5.5

RULE BD_later_cont_P475:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: doubleton_count > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_bid_count <= 5.5
  CONDITION: queen_count <= 0.5

RULE BD_later_cont_P476:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: doubleton_count > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_bid_count <= 5.5
  CONDITION: queen_count > 0.5

RULE BD_later_cont_P477:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: spade_len <= 1.5
  CONDITION: d_top3_honors <= 1.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_bid_count > 5.5

RULE BD_later_cont_P478:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 3.5
  CONDITION: spade_len <= 1.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: d_top3_honors > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_bid_count > 5.5

RULE BD_later_cont_P479:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: spade_len > 1.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_bid_count > 5.5

RULE BD_later_cont_P480:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level > 4.5

RULE BD_later_cont_P481:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: auction_len <= 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P482:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: auction_len <= 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P483:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: auction_len <= 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: major_hcp <= 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P484:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: auction_len <= 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: major_hcp > 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P485:
  PRIORITY: 10
  CALL: 2H
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: auction_len <= 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: heart_hcp <= 9.5

RULE BD_later_cont_P486:
  PRIORITY: 10
  CALL: 4H
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: auction_len <= 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: heart_hcp > 9.5

RULE BD_later_cont_P487:
  PRIORITY: 10
  CALL: PASS
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: auction_len <= 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P488:
  PRIORITY: 10
  CALL: 3H
  CONDITION: c_is_best_minor > 0.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: auction_len <= 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P489:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: spade_len <= 2.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: partner_first_call == '1S'
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P490:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: spade_len <= 2.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: partner_first_call == '1S'
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P491:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: spade_len > 2.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: partner_first_call == '1S'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P492:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: spade_len > 2.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: partner_first_call == '1S'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P493:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: auction_len > 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: partner_first_call != '1S'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P494:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: auction_len > 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: partner_first_call != '1S'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P495:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: partner_first_call != '1S'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_first_call == '1C'

RULE BD_later_cont_P496:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: partner_first_call != '1S'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_first_call != '1C'

RULE BD_later_cont_P497:
  PRIORITY: 10
  CALL: 3H
  CONDITION: heart_len <= 3.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain == 'H'

RULE BD_later_cont_P498:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len <= 3.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain == 'H'

RULE BD_later_cont_P499:
  PRIORITY: 10
  CALL: 3H
  CONDITION: heart_len <= 3.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 4.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain == 'H'

RULE BD_later_cont_P500:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len <= 3.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 4.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain == 'H'

RULE BD_later_cont_P501:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: controls <= 3.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain == 'H'

RULE BD_later_cont_P502:
  PRIORITY: 10
  CALL: 3H
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: controls > 3.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain == 'H'

RULE BD_later_cont_P503:
  PRIORITY: 10
  CALL: 3H
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain == 'H'

RULE BD_later_cont_P504:
  PRIORITY: 10
  CALL: PASS
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 4.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: rule20_total <= 17.5

RULE BD_later_cont_P505:
  PRIORITY: 10
  CALL: PASS
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 4.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: rule20_total > 17.5

RULE BD_later_cont_P506:
  PRIORITY: 10
  CALL: PASS
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 4.5
  CONDITION: rule20_total <= 22.5
  CONDITION: club_hcp <= 5.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain != 'H'

RULE BD_later_cont_P507:
  PRIORITY: 10
  CALL: 2S
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 4.5
  CONDITION: rule20_total <= 22.5
  CONDITION: club_hcp > 5.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain != 'H'

RULE BD_later_cont_P508:
  PRIORITY: 10
  CALL: PASS
  CONDITION: d_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_first_call == '1C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: combined_hcp_max <= 30.0

RULE BD_later_cont_P509:
  PRIORITY: 10
  CALL: 3H
  CONDITION: d_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_first_call == '1C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: combined_hcp_max > 30.0

RULE BD_later_cont_P510:
  PRIORITY: 10
  CALL: PASS
  CONDITION: d_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_first_call != '1C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: diamond_hcp <= 5.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain != 'H'

RULE BD_later_cont_P511:
  PRIORITY: 10
  CALL: PASS
  CONDITION: d_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_first_call != '1C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: diamond_hcp > 5.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain != 'H'

RULE BD_later_cont_P512:
  PRIORITY: 10
  CALL: X
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 18.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P513:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 18.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P514:
  PRIORITY: 10
  CALL: 2S
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 18.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P515:
  PRIORITY: 10
  CALL: 3D
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len > 4.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 18.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P516:
  PRIORITY: 10
  CALL: 2S
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: doubleton_count <= 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 18.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: club_len <= 2.0

RULE BD_later_cont_P517:
  PRIORITY: 10
  CALL: X
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: doubleton_count <= 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 18.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: club_len > 2.0

RULE BD_later_cont_P518:
  PRIORITY: 10
  CALL: 3S
  CONDITION: longest_suit_len <= 5.5
  CONDITION: diamond_hcp <= 3.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: doubleton_count > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 18.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P519:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: longest_suit_len <= 5.5
  CONDITION: diamond_hcp > 3.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: doubleton_count > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 18.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P520:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_first_call == '1NT'
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_fit_shown <= 0.5

RULE BD_later_cont_P521:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_first_call != '1NT'
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_fit_shown <= 0.5

RULE BD_later_cont_P522:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_fit_shown > 0.5
  CONDITION: my_last_call == '1C'

RULE BD_later_cont_P523:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_fit_shown > 0.5
  CONDITION: my_last_call != '1C'

RULE BD_later_cont_P524:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: s_stopper <= 0.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P525:
  PRIORITY: 10
  CALL: X
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: s_stopper > 0.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P526:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P527:
  PRIORITY: 10
  CALL: 3D
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P528:
  PRIORITY: 10
  CALL: 3C
  CONDITION: longest_suit_len > 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: auction_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P529:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len > 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: auction_len > 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P530:
  PRIORITY: 10
  CALL: 4H
  CONDITION: longest_suit_len > 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P531:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len > 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count > 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P532:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: longest_suit_len > 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: shape_pattern == '6520'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: doubleton_count <= 1.5

RULE BD_later_cont_P533:
  PRIORITY: 10
  CALL: 3D
  CONDITION: longest_suit_len > 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: shape_pattern != '6520'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: doubleton_count <= 1.5

RULE BD_later_cont_P534:
  PRIORITY: 10
  CALL: 5D
  CONDITION: heart_len <= 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: doubleton_count > 1.5

RULE BD_later_cont_P535:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len > 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: doubleton_count > 1.5

RULE BD_later_cont_P536:
  PRIORITY: 10
  CALL: 2S
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: s_has_jack <= 0.5

RULE BD_later_cont_P537:
  PRIORITY: 10
  CALL: 2H
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: s_has_jack <= 0.5

RULE BD_later_cont_P538:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: s_has_jack > 0.5

RULE BD_later_cont_P539:
  PRIORITY: 10
  CALL: 2S
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: hcp > 13.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: s_has_jack > 0.5

RULE BD_later_cont_P540:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: second_longest_len <= 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: last_bid_seat == 'S'

RULE BD_later_cont_P541:
  PRIORITY: 10
  CALL: 2S
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: second_longest_len > 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: last_bid_seat == 'S'

RULE BD_later_cont_P542:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: last_bid_seat != 'S'

RULE BD_later_cont_P543:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: rule20_total <= 24.5
  CONDITION: diamond_len <= 4.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P544:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 1.5
  CONDITION: rule20_total <= 24.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P545:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 1.5
  CONDITION: rule20_total <= 24.5
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P546:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: competition_level > 1.5
  CONDITION: rule20_total <= 24.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P547:
  PRIORITY: 10
  CALL: 3H
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: my_first_call == '1H'
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_first_call == '1C'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P548:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: my_first_call == '1H'
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_first_call != '1C'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P549:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: my_first_call != '1H'
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P550:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: my_first_call != '1H'
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P551:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '2S'
  CONDITION: last_bid_level > 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P552:
  PRIORITY: 10
  CALL: 3S
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: combined_hcp_max > 26.5
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '2S'
  CONDITION: last_bid_level > 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P553:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '2S'
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P554:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 3.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '2S'
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P555:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 3.5
  CONDITION: club_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: partner_first_call == '1C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P556:
  PRIORITY: 10
  CALL: 4C
  CONDITION: spade_len > 3.5
  CONDITION: club_len > 3.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: partner_first_call == '1C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P557:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 3.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: partner_first_call != '1C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P558:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 3.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: partner_first_call != '1C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game <= 0.5

RULE BD_later_cont_P559:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5

RULE BD_later_cont_P560:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: second_longest_len <= 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5

RULE BD_later_cont_P561:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: second_longest_len > 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5

RULE BD_later_cont_P562:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5

RULE BD_later_cont_P563:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5

RULE BD_later_cont_P564:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: shortest_suit_len > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5
  CONDITION: opening_bid == '4S'

RULE BD_later_cont_P565:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1S'
  CONDITION: last_bid_level > 2.5
  CONDITION: shortest_suit_len > 0.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5
  CONDITION: opening_bid != '4S'

RULE BD_later_cont_P566:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 4.5
  CONDITION: total_points <= 7.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5
  CONDITION: my_last_call == '4S'

RULE BD_later_cont_P567:
  PRIORITY: 10
  CALL: X
  CONDITION: hcp > 4.5
  CONDITION: total_points <= 7.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5
  CONDITION: my_last_call == '4S'

RULE BD_later_cont_P568:
  PRIORITY: 10
  CALL: 5C
  CONDITION: total_points <= 7.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5
  CONDITION: my_last_call != '4S'
  CONDITION: opp_first_call == '3H'

RULE BD_later_cont_P569:
  PRIORITY: 10
  CALL: PASS
  CONDITION: total_points <= 7.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5
  CONDITION: my_last_call != '4S'
  CONDITION: opp_first_call != '3H'

RULE BD_later_cont_P570:
  PRIORITY: 10
  CALL: PASS
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5
  CONDITION: my_last_call == '4H'

RULE BD_later_cont_P571:
  PRIORITY: 10
  CALL: X
  CONDITION: c_is_best_minor > 0.5
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5
  CONDITION: my_last_call == '4H'

RULE BD_later_cont_P572:
  PRIORITY: 10
  CALL: PASS
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5
  CONDITION: my_last_call != '4H'
  CONDITION: opp_first_bid_level <= 3.5

RULE BD_later_cont_P573:
  PRIORITY: 10
  CALL: PASS
  CONDITION: total_points > 7.5
  CONDITION: is_opening == False
  CONDITION: rule20_total <= 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_is_in_game > 0.5
  CONDITION: my_last_call != '4H'
  CONDITION: opp_first_bid_level > 3.5

RULE BD_later_cont_P574:
  PRIORITY: 10
  CALL: X
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: club_len <= 4.5
  CONDITION: auction_len <= 3.5
  CONDITION: rule20_total > 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P575:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: club_len > 3.5
  CONDITION: auction_len <= 3.5
  CONDITION: rule20_total > 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P576:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: auction_len <= 3.5
  CONDITION: rule20_total > 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P577:
  PRIORITY: 10
  CALL: X
  CONDITION: longest_suit_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: auction_len <= 3.5
  CONDITION: rule20_total > 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P578:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp <= 16.5
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: rule20_total > 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: h_top2_honors <= 0.5

RULE BD_later_cont_P579:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp <= 16.5
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: rule20_total > 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: h_top2_honors > 0.5

RULE BD_later_cont_P580:
  PRIORITY: 10
  CALL: X
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp > 16.5
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: rule20_total > 24.5
  CONDITION: jack_count <= 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P581:
  PRIORITY: 10
  CALL: X
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp > 16.5
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: rule20_total > 24.5
  CONDITION: jack_count > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P582:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: diamond_len <= 4.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P583:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: diamond_len <= 4.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P584:
  PRIORITY: 10
  CALL: 3D
  CONDITION: spade_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P585:
  PRIORITY: 10
  CALL: 4D
  CONDITION: spade_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P586:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp <= 16.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: c_top2_honors <= 0.5

RULE BD_later_cont_P587:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp <= 16.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: c_top2_honors > 0.5

RULE BD_later_cont_P588:
  PRIORITY: 10
  CALL: 7H
  CONDITION: spade_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: hcp > 16.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P589:
  PRIORITY: 10
  CALL: 3S
  CONDITION: spade_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp > 16.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P590:
  PRIORITY: 10
  CALL: PASS
  CONDITION: diamond_len <= 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P591:
  PRIORITY: 10
  CALL: 3S
  CONDITION: diamond_len <= 5.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P592:
  PRIORITY: 10
  CALL: PASS
  CONDITION: diamond_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: shape_pattern == '6430'

RULE BD_later_cont_P593:
  PRIORITY: 10
  CALL: PASS
  CONDITION: diamond_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: shape_pattern != '6430'

RULE BD_later_cont_P594:
  PRIORITY: 10
  CALL: 4D
  CONDITION: diamond_len > 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P595:
  PRIORITY: 10
  CALL: 3D
  CONDITION: diamond_len > 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P596:
  PRIORITY: 10
  CALL: PASS
  CONDITION: diamond_len > 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P597:
  PRIORITY: 10
  CALL: 5D
  CONDITION: club_len <= 2.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: heart_hcp <= 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: controls <= 5.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P598:
  PRIORITY: 10
  CALL: 4D
  CONDITION: club_len <= 2.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: heart_hcp <= 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: controls > 5.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P599:
  PRIORITY: 10
  CALL: PASS
  CONDITION: club_len > 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: heart_hcp <= 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P600:
  PRIORITY: 10
  CALL: 4S
  CONDITION: club_len > 2.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: heart_hcp <= 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P601:
  PRIORITY: 10
  CALL: PASS
  CONDITION: s_has_ten <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: heart_hcp > 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P602:
  PRIORITY: 10
  CALL: PASS
  CONDITION: s_has_ten > 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: heart_hcp > 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P603:
  PRIORITY: 10
  CALL: 4H
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: heart_hcp > 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P604:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: rule20_total > 24.5
  CONDITION: heart_hcp > 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'

RULE BD_later_cont_P605:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_hcp_max <= 13.5
  CONDITION: partner_first_call == '2H'
  CONDITION: opp_preempted <= 0.5

RULE BD_later_cont_P606:
  PRIORITY: 10
  CALL: 3H
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_hcp_max <= 13.5
  CONDITION: partner_first_call == '2H'
  CONDITION: opp_preempted > 0.5

RULE BD_later_cont_P607:
  PRIORITY: 10
  CALL: PASS
  CONDITION: shortest_suit_len <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_hcp_max <= 13.5
  CONDITION: partner_first_call != '2H'

RULE BD_later_cont_P608:
  PRIORITY: 10
  CALL: PASS
  CONDITION: shortest_suit_len > 2.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_hcp_max <= 13.5
  CONDITION: partner_first_call != '2H'

RULE BD_later_cont_P609:
  PRIORITY: 10
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_hcp_max > 13.5

RULE BD_later_cont_P610:
  PRIORITY: 10
  CALL: 3C
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: opening_bid == '1NT'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_hcp_max > 13.5

RULE BD_later_cont_P611:
  PRIORITY: 10
  CALL: 2S
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '1S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_hcp_max > 13.5

RULE BD_later_cont_P612:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_hcp_max > 13.5

RULE BD_later_cont_P613:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: spade_len <= 2.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call == '1S'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P614:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: spade_len > 2.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call == '1S'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P615:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call != '1S'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_last_call == '2C'

RULE BD_later_cont_P616:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call != '1S'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_last_call != '2C'

RULE BD_later_cont_P617:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: my_seat == 'E'
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P618:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: my_seat != 'E'
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P619:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_max <= 22.5

RULE BD_later_cont_P620:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_max > 22.5

RULE BD_later_cont_P621:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: total_points <= 4.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P622:
  PRIORITY: 10
  CALL: 4S
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: total_points > 4.5
  CONDITION: shape_pattern == '5431'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: opp_last_call == '2S'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P623:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: total_points > 4.5
  CONDITION: shape_pattern != '5431'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: opp_last_call == '2S'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P624:
  PRIORITY: 10
  CALL: 4S
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: total_points > 4.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: opp_last_call != '2S'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P625:
  PRIORITY: 10
  CALL: 3S
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: total_points > 4.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: opp_last_call != '2S'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P626:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len <= 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 3.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P628:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_max <= 23.5

RULE BD_later_cont_P629:
  PRIORITY: 10
  CALL: 4H
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_max > 23.5

RULE BD_later_cont_P630:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: singleton_count <= 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_first_call == '1D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P631:
  PRIORITY: 10
  CALL: 3D
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: singleton_count > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_first_call == '1D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P632:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_first_call != '1D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P633:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_first_call != '1D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P634:
  PRIORITY: 10
  CALL: 2S
  CONDITION: hcp <= 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_first_call == '2D'

RULE BD_later_cont_P635:
  PRIORITY: 10
  CALL: 2H
  CONDITION: hcp > 4.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_first_call == '2D'

RULE BD_later_cont_P636:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_first_call != '2D'

RULE BD_later_cont_P637:
  PRIORITY: 10
  CALL: 2S
  CONDITION: d_is_longest <= 0.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: king_count <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P638:
  PRIORITY: 10
  CALL: 3C
  CONDITION: d_is_longest <= 0.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: king_count > 0.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P639:
  PRIORITY: 10
  CALL: 2S
  CONDITION: d_is_longest <= 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: c_has_ace <= 0.5

RULE BD_later_cont_P640:
  PRIORITY: 10
  CALL: 3S
  CONDITION: d_is_longest <= 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: c_has_ace > 0.5

RULE BD_later_cont_P641:
  PRIORITY: 10
  CALL: 3H
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_first_call == '1H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: hcp <= 2.5
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P642:
  PRIORITY: 10
  CALL: 2D
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_first_call == '1H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: hcp > 2.5
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P643:
  PRIORITY: 10
  CALL: 2S
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_first_call != '1H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P644:
  PRIORITY: 10
  CALL: 3D
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_first_call != '1H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P645:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: my_seat == 'E'
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: quick_tricks <= 0.75
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_fit_shown <= 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'NONE'

RULE BD_later_cont_P646:
  PRIORITY: 10
  CALL: 3H
  CONDITION: my_seat == 'E'
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: quick_tricks > 0.75
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_fit_shown <= 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'NONE'

RULE BD_later_cont_P647:
  PRIORITY: 10
  CALL: 3S
  CONDITION: d_has_ten <= 0.5
  CONDITION: my_seat == 'E'
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_fit_shown > 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'NONE'

RULE BD_later_cont_P648:
  PRIORITY: 10
  CALL: 3H
  CONDITION: d_has_ten > 0.5
  CONDITION: my_seat == 'E'
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: opp_fit_shown > 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'NONE'

RULE BD_later_cont_P649:
  PRIORITY: 10
  CALL: 3H
  CONDITION: my_seat != 'E'
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: jack_count <= 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'NONE'
  CONDITION: losing_trick_count <= 9.5

RULE BD_later_cont_P650:
  PRIORITY: 10
  CALL: PASS
  CONDITION: my_seat != 'E'
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: jack_count > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'NONE'
  CONDITION: losing_trick_count <= 9.5

RULE BD_later_cont_P651:
  PRIORITY: 10
  CALL: 3C
  CONDITION: my_seat != 'E'
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: auction_len <= 5.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'NONE'
  CONDITION: losing_trick_count > 9.5

RULE BD_later_cont_P652:
  PRIORITY: 10
  CALL: PASS
  CONDITION: my_seat != 'E'
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: auction_len > 5.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'NONE'
  CONDITION: losing_trick_count > 9.5

RULE BD_later_cont_P653:
  PRIORITY: 10
  CALL: 2D
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid == '1NT'
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'NONE'

RULE BD_later_cont_P654:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid != '1NT'
  CONDITION: c_has_ten <= 0.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'NONE'

RULE BD_later_cont_P655:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid != '1NT'
  CONDITION: c_has_ten > 0.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'NONE'

RULE BD_later_cont_P656:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'NONE'
  CONDITION: rule20_total <= 13.5

RULE BD_later_cont_P657:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'NONE'
  CONDITION: rule20_total > 13.5

RULE BD_later_cont_P658:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min > 8.0
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'NONE'

RULE BD_later_cont_P659:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 6.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: partner_hcp_min > 8.0
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'NONE'

RULE BD_later_cont_P660:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'C'

RULE BD_later_cont_P661:
  PRIORITY: 10
  CALL: 3C
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len > 2.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'C'

RULE BD_later_cont_P662:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_first_call == '1C'
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'C'

RULE BD_later_cont_P663:
  PRIORITY: 10
  CALL: 2D
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_first_call != '1C'
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'C'

RULE BD_later_cont_P664:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: my_last_call == 'X'
  CONDITION: diamond_hcp <= 6.0

RULE BD_later_cont_P665:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: my_last_call == 'X'
  CONDITION: diamond_hcp > 6.0

RULE BD_later_cont_P666:
  PRIORITY: 10
  CALL: 2H
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: my_last_call == '1H'
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: my_last_call != 'X'

RULE BD_later_cont_P667:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: my_last_call != 'X'

RULE BD_later_cont_P668:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_max <= 27.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'C'

RULE BD_later_cont_P669:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'C'

RULE BD_later_cont_P670:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'C'
  CONDITION: last_bid_seat == 'N'

RULE BD_later_cont_P671:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'C'
  CONDITION: last_bid_seat != 'N'

RULE BD_later_cont_P672:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == '1S'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'C'

RULE BD_later_cont_P673:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != '1S'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'C'

RULE BD_later_cont_P674:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: my_last_call == 'X'
  CONDITION: partner_last_bid_strain != 'C'

RULE BD_later_cont_P675:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: my_last_call != 'X'
  CONDITION: partner_last_bid_strain != 'C'

RULE BD_later_cont_P676:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'C'

RULE BD_later_cont_P677:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain == 'C'

RULE BD_later_cont_P678:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'C'

RULE BD_later_cont_P679:
  PRIORITY: 10
  CALL: X
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_bid_strain != 'C'

RULE BD_later_cont_P680:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: total_points <= 13.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_seat == 'N'

RULE BD_later_cont_P681:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: total_points <= 13.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_seat != 'N'

RULE BD_later_cont_P682:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: total_points > 13.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P683:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: total_points > 13.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P684:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 3.5
  CONDITION: club_len <= 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P685:
  PRIORITY: 10
  CALL: 3C
  CONDITION: spade_len > 3.5
  CONDITION: club_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P686:
  PRIORITY: 10
  CALL: 3C
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.0
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P687:
  PRIORITY: 10
  CALL: 4H
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.0
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P688:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: hcp <= 16.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: queen_count <= 1.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P689:
  PRIORITY: 10
  CALL: 3S
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: hcp <= 16.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: queen_count > 1.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P690:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: hcp > 16.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P691:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 6.5
  CONDITION: hcp > 16.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P692:
  PRIORITY: 10
  CALL: 3H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: opening_bid == '1D'
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_max <= 19.5

RULE BD_later_cont_P693:
  PRIORITY: 10
  CALL: 3D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1D'
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_max <= 19.5

RULE BD_later_cont_P694:
  PRIORITY: 10
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call == '1NT'
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_max > 19.5

RULE BD_later_cont_P695:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_max > 19.5

RULE BD_later_cont_P696:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == '1S'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P697:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == '1S'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P698:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != '1S'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P699:
  PRIORITY: 10
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != '1S'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P700:
  PRIORITY: 10
  CALL: 2S
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P701:
  PRIORITY: 10
  CALL: 2H
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P702:
  PRIORITY: 10
  CALL: 2S
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_last_call == '1D'

RULE BD_later_cont_P703:
  PRIORITY: 10
  CALL: PASS
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_last_call != '1D'

RULE BD_later_cont_P704:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_last_call == '1D'

RULE BD_later_cont_P705:
  PRIORITY: 10
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_last_call != '1D'

RULE BD_later_cont_P706:
  PRIORITY: 10
  CALL: 3D
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_last_call != '1D'

RULE BD_later_cont_P707:
  PRIORITY: 10
  CALL: 3C
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call == '2NT'
  CONDITION: opp_contract_level <= 1.5

RULE BD_later_cont_P708:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call == '2NT'
  CONDITION: opp_contract_level > 1.5

RULE BD_later_cont_P709:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 13.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call == '2NT'

RULE BD_later_cont_P710:
  PRIORITY: 10
  CALL: 3C
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: hcp > 13.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 3.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call == '2NT'

RULE BD_later_cont_P711:
  PRIORITY: 10
  CALL: 3C
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: diamond_len <= 1.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: competition_level <= 4.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call == '2NT'

RULE BD_later_cont_P712:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: diamond_len <= 1.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: competition_level > 4.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call == '2NT'

RULE BD_later_cont_P713:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: diamond_len > 1.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call == '2NT'
  CONDITION: opp_contract_level <= 1.5

RULE BD_later_cont_P714:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: diamond_len > 1.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call == '2NT'
  CONDITION: opp_contract_level > 1.5

RULE BD_later_cont_P715:
  PRIORITY: 10
  CALL: 2NT
  CONDITION: heart_len <= 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call == '2S'
  CONDITION: opp_last_call == '1S'

RULE BD_later_cont_P716:
  PRIORITY: 10
  CALL: 4H
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call == '2S'
  CONDITION: opp_last_call == '1S'

RULE BD_later_cont_P717:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call == '2S'
  CONDITION: opp_last_call != '1S'

RULE BD_later_cont_P718:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call == '2S'
  CONDITION: opp_last_call != '1S'

RULE BD_later_cont_P719:
  PRIORITY: 10
  CALL: 2S
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call != '2S'
  CONDITION: partner_last_call == '2H'
  CONDITION: opp_last_call == '1H'

RULE BD_later_cont_P720:
  PRIORITY: 10
  CALL: 2D
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call != '2S'
  CONDITION: partner_last_call == '2H'
  CONDITION: opp_last_call != '1H'

RULE BD_later_cont_P721:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call != '2S'
  CONDITION: partner_last_call != '2H'

RULE BD_later_cont_P722:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call != '2S'
  CONDITION: partner_last_call != '2H'

RULE BD_later_cont_P723:
  PRIORITY: 10
  CALL: 4H
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call == '2NT'
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P724:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call == '2NT'
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P725:
  PRIORITY: 10
  CALL: 4C
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: opening_bid == '2S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call != '2NT'
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P726:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: opening_bid != '2S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: my_last_call != '2NT'
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P727:
  PRIORITY: 10
  CALL: 4H
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: my_last_call == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: hcp <= 15.0
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P728:
  PRIORITY: 10
  CALL: 4NT
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: my_last_call == '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: hcp > 15.0
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P729:
  PRIORITY: 10
  CALL: 4S
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 1.5
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P730:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: my_last_call != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 1.5
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P731:
  PRIORITY: 10
  CALL: PASS
  CONDITION: rule20_total <= 21.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min <= 18.5

RULE BD_later_cont_P732:
  PRIORITY: 10
  CALL: PASS
  CONDITION: rule20_total <= 21.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 2.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min <= 18.5

RULE BD_later_cont_P733:
  PRIORITY: 10
  CALL: PASS
  CONDITION: rule20_total > 21.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: ace_count <= 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min <= 18.5

RULE BD_later_cont_P734:
  PRIORITY: 10
  CALL: 4S
  CONDITION: rule20_total > 21.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: ace_count > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min <= 18.5

RULE BD_later_cont_P735:
  PRIORITY: 10
  CALL: 4S
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: club_len <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min > 18.5
  CONDITION: opp_contract_level <= 2.5

RULE BD_later_cont_P736:
  PRIORITY: 10
  CALL: 4S
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: club_len > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min > 18.5
  CONDITION: opp_contract_level <= 2.5

RULE BD_later_cont_P737:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min > 18.5
  CONDITION: opp_contract_level > 2.5

RULE BD_later_cont_P738:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'S'
  CONDITION: last_bid_level > 1.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min > 18.5
  CONDITION: opp_contract_level > 2.5

RULE BD_later_cont_P739:
  PRIORITY: 10
  CALL: 3S
  CONDITION: hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: hcp <= 10.0
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P740:
  PRIORITY: 10
  CALL: 4S
  CONDITION: hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: hcp <= 10.0
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P741:
  PRIORITY: 10
  CALL: 4C
  CONDITION: hcp <= 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: hcp > 10.0
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P742:
  PRIORITY: 10
  CALL: 3D
  CONDITION: hcp > 12.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: hcp > 10.0
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P743:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opening_bid == '2S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: king_count <= 0.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P744:
  PRIORITY: 10
  CALL: 3S
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opening_bid == '2S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: king_count > 0.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P745:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opening_bid != '2S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P746:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: opening_bid != '2S'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P747:
  PRIORITY: 10
  CALL: 4S
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: club_len <= 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_preempted <= 0.5

RULE BD_later_cont_P748:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: club_len > 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_preempted <= 0.5

RULE BD_later_cont_P749:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_preempted <= 0.5

RULE BD_later_cont_P750:
  PRIORITY: 10
  CALL: 3S
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_preempted <= 0.5

RULE BD_later_cont_P751:
  PRIORITY: 10
  CALL: 4S
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_preempted > 0.5
  CONDITION: combined_hcp_max <= 32.5

RULE BD_later_cont_P752:
  PRIORITY: 10
  CALL: 4S
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: hcp > 13.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_preempted > 0.5
  CONDITION: combined_hcp_max <= 32.5

RULE BD_later_cont_P753:
  PRIORITY: 10
  CALL: 3S
  CONDITION: losing_trick_count <= 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_preempted > 0.5
  CONDITION: combined_hcp_max > 32.5

RULE BD_later_cont_P754:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count > 6.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_preempted > 0.5
  CONDITION: combined_hcp_max > 32.5

RULE BD_later_cont_P755:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min <= 27.5

RULE BD_later_cont_P756:
  PRIORITY: 10
  CALL: X
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min <= 27.5

RULE BD_later_cont_P757:
  PRIORITY: 10
  CALL: 4C
  CONDITION: hcp <= 9.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min > 27.5

RULE BD_later_cont_P758:
  PRIORITY: 10
  CALL: PASS
  CONDITION: hcp > 9.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: heart_len <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min > 27.5

RULE BD_later_cont_P759:
  PRIORITY: 10
  CALL: 4H
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: heart_len > 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: combined_hcp_min > 27.5

RULE BD_later_cont_P760:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: major_hcp <= 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_first_call == '2H'

RULE BD_later_cont_P761:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: major_hcp > 6.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_first_call == '2H'

RULE BD_later_cont_P762:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: my_last_call == 'PASS'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_first_call != '2H'

RULE BD_later_cont_P763:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: my_last_call != 'PASS'
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_first_call != '2H'

RULE BD_later_cont_P764:
  PRIORITY: 10
  CALL: 4S
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: auction_len <= 5.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: hcp <= 14.0

RULE BD_later_cont_P765:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: auction_len <= 5.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: hcp > 14.0

RULE BD_later_cont_P766:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: auction_len > 5.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P767:
  PRIORITY: 10
  CALL: 3S
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call == '3H'
  CONDITION: opponents_bid == True
  CONDITION: h_stopper <= 0.5
  CONDITION: opp_last_call == '2H'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P768:
  PRIORITY: 10
  CALL: 3NT
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call == '3H'
  CONDITION: opponents_bid == True
  CONDITION: h_stopper > 0.5
  CONDITION: opp_last_call == '2H'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P769:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call == '3H'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 1.5
  CONDITION: opp_last_call != '2H'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P770:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call == '3H'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count > 1.5
  CONDITION: opp_last_call != '2H'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P771:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: my_side_bid_count <= 3.5
  CONDITION: partner_last_call == '3H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P772:
  PRIORITY: 10
  CALL: 4H
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: my_side_bid_count > 3.5
  CONDITION: partner_last_call == '3H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P773:
  PRIORITY: 10
  CALL: 4H
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: auction_len <= 7.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call == '3H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P774:
  PRIORITY: 10
  CALL: PASS
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: last_bid_level > 1.5
  CONDITION: auction_len > 7.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call == '3H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P775:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: total_points <= 9.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call != '3H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P776:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: total_points > 9.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call != '3H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P777:
  PRIORITY: 10
  CALL: 3H
  CONDITION: spade_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call != '3H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call == 'X'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P778:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call != '3H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P779:
  PRIORITY: 10
  CALL: PASS
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call != '3H'
  CONDITION: opponents_bid == True
  CONDITION: passes_since_last_bid <= 2.0
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P780:
  PRIORITY: 10
  CALL: 3S
  CONDITION: rule20_total <= 20.5
  CONDITION: spade_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call != '3H'
  CONDITION: opponents_bid == True
  CONDITION: passes_since_last_bid > 2.0
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P781:
  PRIORITY: 10
  CALL: 3S
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level <= 4.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call != '3H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P782:
  PRIORITY: 10
  CALL: PASS
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_level > 1.5
  CONDITION: competition_level > 4.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_call != '3H'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P783:
  PRIORITY: 10
  CALL: PASS
  CONDITION: h_has_king <= 0.5
  CONDITION: minor_hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: jack_count <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: minor_hcp <= 2.0

RULE BD_later_cont_P784:
  PRIORITY: 10
  CALL: 5C
  CONDITION: h_has_king <= 0.5
  CONDITION: minor_hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: jack_count <= 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: minor_hcp > 2.0

RULE BD_later_cont_P785:
  PRIORITY: 10
  CALL: 5D
  CONDITION: h_has_king <= 0.5
  CONDITION: minor_hcp <= 5.5
  CONDITION: is_opening == False
  CONDITION: jack_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P786:
  PRIORITY: 10
  CALL: 5D
  CONDITION: h_has_king <= 0.5
  CONDITION: minor_hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: spade_hcp <= 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: d_has_jack <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P787:
  PRIORITY: 10
  CALL: 5H
  CONDITION: h_has_king <= 0.5
  CONDITION: minor_hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: spade_hcp <= 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: d_has_jack > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P788:
  PRIORITY: 10
  CALL: 5H
  CONDITION: hcp <= 10.5
  CONDITION: h_has_king <= 0.5
  CONDITION: minor_hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: spade_hcp > 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P789:
  PRIORITY: 10
  CALL: 6H
  CONDITION: hcp > 10.5
  CONDITION: h_has_king <= 0.5
  CONDITION: minor_hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: spade_hcp > 3.5
  CONDITION: last_bid_level > 1.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P790:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: h_has_king <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: minor_hcp <= 3.5
  CONDITION: auction_len <= 7.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P791:
  PRIORITY: 10
  CALL: 5S
  CONDITION: h_has_king <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: minor_hcp > 3.5
  CONDITION: auction_len <= 7.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P792:
  PRIORITY: 10
  CALL: 5H
  CONDITION: h_has_king <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: auction_len > 7.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P793:
  PRIORITY: 10
  CALL: 5C
  CONDITION: h_has_king <= 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P794:
  PRIORITY: 10
  CALL: 5H
  CONDITION: h_has_king > 0.5
  CONDITION: hcp <= 14.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P795:
  PRIORITY: 10
  CALL: 5H
  CONDITION: h_has_king > 0.5
  CONDITION: hcp > 14.5
  CONDITION: club_hcp <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P796:
  PRIORITY: 10
  CALL: 5D
  CONDITION: h_has_king > 0.5
  CONDITION: hcp > 14.5
  CONDITION: club_hcp > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P797:
  PRIORITY: 10
  CALL: PASS
  CONDITION: club_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level <= 3.5
  CONDITION: opp_first_bid_level <= 1.5

RULE BD_later_cont_P798:
  PRIORITY: 10
  CALL: PASS
  CONDITION: club_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level <= 3.5
  CONDITION: opp_first_bid_level > 1.5

RULE BD_later_cont_P799:
  PRIORITY: 10
  CALL: PASS
  CONDITION: club_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level <= 3.5
  CONDITION: combined_hcp_max <= 31.5

RULE BD_later_cont_P800:
  PRIORITY: 10
  CALL: 5C
  CONDITION: club_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level <= 3.5
  CONDITION: combined_hcp_max > 31.5

RULE BD_later_cont_P801:
  PRIORITY: 10
  CALL: 4H
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call == '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level <= 3.5

RULE BD_later_cont_P802:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: my_last_call != '1NT'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level <= 3.5

RULE BD_later_cont_P803:
  PRIORITY: 10
  CALL: 5D
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level <= 3.5
  CONDITION: opening_bid == '3S'

RULE BD_later_cont_P804:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level <= 3.5
  CONDITION: opening_bid != '3S'

RULE BD_later_cont_P805:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level > 3.5

RULE BD_later_cont_P806:
  PRIORITY: 10
  CALL: PASS
  CONDITION: losing_trick_count > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level > 3.5

RULE BD_later_cont_P807:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: s_is_best_major <= 0.5
  CONDITION: opponents_bid == True
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level > 3.5

RULE BD_later_cont_P808:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: s_is_best_major > 0.5
  CONDITION: opponents_bid == True
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level > 3.5

RULE BD_later_cont_P809:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 8.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: opp_is_in_game > 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level > 3.5

RULE BD_later_cont_P810:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: is_opening == False
  CONDITION: hcp <= 8.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: opp_is_in_game > 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level > 3.5

RULE BD_later_cont_P811:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: last_bid_strain == 'H'
  CONDITION: hcp > 8.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: opp_is_in_game > 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level > 3.5

RULE BD_later_cont_P812:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: last_bid_strain != 'H'
  CONDITION: hcp > 8.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: opp_is_in_game > 0.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: opp_contract_level > 3.5

RULE BD_later_cont_P813:
  PRIORITY: 10
  CALL: 6D
  CONDITION: club_hcp <= 3.5
  CONDITION: is_opening == False
  CONDITION: singleton_count <= 0.5
  CONDITION: hcp <= 13.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P814:
  PRIORITY: 10
  CALL: 5S
  CONDITION: club_hcp <= 3.5
  CONDITION: is_opening == False
  CONDITION: singleton_count <= 0.5
  CONDITION: hcp > 13.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P815:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: h_has_king <= 0.5
  CONDITION: club_hcp > 3.5
  CONDITION: is_opening == False
  CONDITION: singleton_count <= 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P816:
  PRIORITY: 10
  CALL: 6S
  CONDITION: h_has_king > 0.5
  CONDITION: club_hcp > 3.5
  CONDITION: is_opening == False
  CONDITION: singleton_count <= 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P817:
  PRIORITY: 10
  CALL: PASS
  CONDITION: h_has_king <= 0.5
  CONDITION: is_opening == False
  CONDITION: spade_len <= 2.5
  CONDITION: singleton_count > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P818:
  PRIORITY: 10
  CALL: 5H
  CONDITION: h_has_king <= 0.5
  CONDITION: is_opening == False
  CONDITION: spade_len > 2.5
  CONDITION: singleton_count > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P819:
  PRIORITY: 10
  CALL: 6H
  CONDITION: h_has_king > 0.5
  CONDITION: is_opening == False
  CONDITION: singleton_count > 0.5
  CONDITION: third_longest_len <= 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P820:
  PRIORITY: 10
  CALL: 5NT
  CONDITION: h_has_king > 0.5
  CONDITION: is_opening == False
  CONDITION: singleton_count > 0.5
  CONDITION: third_longest_len > 2.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P821:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: total_points <= 14.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: opponents_bid == True
  CONDITION: minor_hcp <= 2.5
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P822:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: total_points <= 14.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: opponents_bid == True
  CONDITION: minor_hcp > 2.5
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P823:
  PRIORITY: 10
  CALL: 5H
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: total_points > 14.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call == '4H'

RULE BD_later_cont_P824:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: total_points > 14.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call != '4H'

RULE BD_later_cont_P825:
  PRIORITY: 10
  CALL: 6C
  CONDITION: diamond_hcp <= 3.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P826:
  PRIORITY: 10
  CALL: 6S
  CONDITION: diamond_hcp > 3.5
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P827:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_side_bid_count <= 4.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P828:
  PRIORITY: 10
  CALL: PASS
  CONDITION: is_opening == False
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: last_bid_level > 1.5
  CONDITION: my_side_bid_count > 4.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'

RULE BD_later_cont_P110_suitc:
  PRIORITY: 11
  CALL: 2H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: short_suit_wasted_hcp == 0

RULE BD_open_uncont_P183_suitc:
  PRIORITY: 11
  CALL: 1NT
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 11.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 17.5
  CONDITION: short_suit_wasted_hcp >= 3

RULE BD_later_uncont_P139_suitc:
  PRIORITY: 11
  CALL: PASS
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level <= 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: short_suit_wasted_hcp == 0

RULE BD_later_cont_P240_suitc:
  PRIORITY: 11
  CALL: 1NT
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1S'
  CONDITION: partner_last_call != '1H'
  CONDITION: short_suit_wasted_hcp == 0

RULE BD_later_cont_P722_suitc:
  PRIORITY: 11
  CALL: 2S
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call != '2S'
  CONDITION: partner_last_call != '2H'
  CONDITION: short_suit_wasted_hcp == 0

RULE BD_later_cont_P224_suitc:
  PRIORITY: 11
  CALL: PASS
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: short_suit_wasted_hcp == 0

RULE BD_later_uncont_P52_suitc:
  PRIORITY: 11
  CALL: 2NT
  CONDITION: opponents_bid == False
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len > 1.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: short_suit_wasted_hcp == 0

RULE BD_later_cont_P504_suitc:
  PRIORITY: 11
  CALL: 2S
  CONDITION: d_is_longest <= 0.5
  CONDITION: is_opening == False
  CONDITION: my_side_bid_count > 1.5
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level <= 4.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: rule20_total <= 17.5
  CONDITION: short_suit_wasted_hcp >= 2

RULE BD_later_cont_P386_suitc:
  PRIORITY: 11
  CALL: 2S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.0
  CONDITION: second_longest_len > 4.5
  CONDITION: s_is_longest > 0.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: opening_bid != '1H'
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 1.5
  CONDITION: combined_hcp_min > 3.5
  CONDITION: short_suit_wasted_hcp >= 2

RULE BD_later_uncont_P160_suitc:
  PRIORITY: 11
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced > 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: short_suit_wasted_hcp == 0

RULE BD_later_cont_P492_suitc:
  PRIORITY: 11
  CALL: 2S
  CONDITION: is_opening == False
  CONDITION: auction_len > 3.5
  CONDITION: spade_len > 2.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: partner_first_call == '1S'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: competition_level > 3.5
  CONDITION: rule20_total <= 22.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: long_suit_hcp <= 2

RULE BD_later_cont_P239_suitc:
  PRIORITY: 11
  CALL: 3H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1S'
  CONDITION: partner_last_call == '1H'
  CONDITION: long_suit_hcp >= 6

RULE BD_later_cont_P238_suitc:
  PRIORITY: 11
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1S'
  CONDITION: opp_last_call != '1C'
  CONDITION: short_suit_wasted_hcp == 0

RULE BD_later_uncont_P245_suitc:
  PRIORITY: 11
  CALL: 3S
  CONDITION: opponents_bid == False
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 3.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len <= 6.5
  CONDITION: spade_len > 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: short_suit_wasted_hcp >= 3

RULE BD_later_cont_P73_JPS_G1_combined_hcp_min_21_1D:
  PRIORITY: 11
  CALL: 1D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total <= 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: auction_len <= 11.5
  CONDITION: combined_hcp_min <= 21

RULE BD_later_uncont_P161_JPS_G1_support_in_partner_suit_2_2C:
  PRIORITY: 11
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced > 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: support_in_partner_suit <= 2

RULE BD_later_cont_P394_JPS_G1_combined_hcp_min_21_2D:
  PRIORITY: 11
  CALL: 2D
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: competition_level <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: total_points <= 12.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 21

RULE BD_later_cont_P84_JPS_G1_short_suit_wasted_hcp_0_2D:
  PRIORITY: 11
  CALL: 2D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: total_points <= 9.5
  CONDITION: diamond_len > 3.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: short_suit_wasted_hcp == 0

RULE BD_later_cont_P722_suitc_JPS_G1_support_in_partner_suit_3_PASS:
  PRIORITY: 12
  CALL: 1NT
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call != '2S'
  CONDITION: partner_last_call != '2H'
  CONDITION: short_suit_wasted_hcp == 0
  CONDITION: support_in_partner_suit >= 3

RULE BD_later_cont_P87_JPS_G1_long_suit_intermediates_2_1H:
  PRIORITY: 11
  CALL: 1H
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: partner_last_call != 'X'
  CONDITION: club_hcp <= 6.5
  CONDITION: long_suit_intermediates >= 2

RULE BD_later_cont_P461_JPS_G1_combined_hcp_min_21_2D:
  PRIORITY: 11
  CALL: 2D
  CONDITION: hcp <= 10.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: is_opening == False
  CONDITION: opening_bid != '1H'
  CONDITION: last_bid_level > 1.5
  CONDITION: opponents_bid == True
  CONDITION: opp_bid_count <= 2.5
  CONDITION: partner_first_call != 'X'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: opp_contract_level <= 4.5
  CONDITION: combined_hcp_min <= 21

RULE BD_later_cont_P76_JPS_G1_combined_hcp_min_21_1D:
  PRIORITY: 11
  CALL: 1D
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len <= 4.5
  CONDITION: third_longest_len <= 3.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total > 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: total_points <= 10.5
  CONDITION: combined_hcp_min <= 21

RULE BD_later_cont_P127_JPS_G1_combined_hcp_min_21_1S:
  PRIORITY: 11
  CALL: 1S
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: hcp <= 7.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total <= 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: combined_hcp_min <= 21

RULE BD_later_uncont_P149_JPS_G1_partner_hcp_min_12_2C:
  PRIORITY: 11
  CALL: 2C
  CONDITION: opponents_bid == False
  CONDITION: hcp > 9.5
  CONDITION: spade_len <= 3.5
  CONDITION: club_len <= 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: is_balanced <= 0.5
  CONDITION: partner_last_call != '1D'
  CONDITION: partner_hcp_min >= 12

RULE BD_later_cont_P73_JPS_G2_combined_hcp_min_21_1H:
  PRIORITY: 11
  CALL: 1H
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: diamond_len <= 4.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: rule20_total <= 16.5
  CONDITION: partner_last_call != 'X'
  CONDITION: auction_len <= 11.5
  CONDITION: combined_hcp_min <= 21

RULE BD_later_cont_P722_suitc_JPS_G1_support_in_partner_suit_3_PASS_JPS_G2_partner_hcp_min_12_PASS:
  PRIORITY: 13
  CALL: PASS
  CONDITION: hcp > 6.5
  CONDITION: is_opening == False
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'PASS'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call != '2S'
  CONDITION: partner_last_call != '2H'
  CONDITION: short_suit_wasted_hcp == 0
  CONDITION: support_in_partner_suit >= 3
  CONDITION: partner_hcp_min >= 12

RULE BD_later_cont_P193_JPS_G2_long_suit_intermediates_2_2D:
  PRIORITY: 11
  CALL: 2D
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: longest_suit_len > 4.5
  CONDITION: opponents_bid == True
  CONDITION: partner_last_call != 'X'
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: long_suit_intermediates >= 2

RULE BD_later_cont_P222_JPS_G2_combined_hcp_min_26_2C:
  PRIORITY: 11
  CALL: 2C
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: my_side_bid_count > 0.5
  CONDITION: combined_hcp_min >= 26

RULE BD_later_cont_P222_JPS_G3_combined_hcp_min_24_PASS:
  PRIORITY: 11
  CALL: PASS
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: is_opening == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: opponents_bid == True
  CONDITION: combined_hcp_min > 3.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: my_side_bid_count > 0.5
  CONDITION: combined_hcp_min >= 24
