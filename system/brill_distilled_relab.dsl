# ---- merged from 3 slice files ----
#   only_open.dsl                (no provenance)
#   s330_laterU_relab.dsl        traces     data/brill_traces_330k.jsonl  (77882 rows featurised)  |  group      opening_contested   [slice False,False]  |  depth      10    min-samples 25    folds 2
#   only_cont.dsl                (no provenance)
# --------------------------------

# ==========================================
# IMPROVED BIDDING SYSTEM: brill_distilled
# Generated via Continuous Self-Improvement Pipeline
# ==========================================

# --- Active Rules & Conventions ---

RULE BD_open_uncont_P0:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total <= 19.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P1:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total <= 19.5
  CONDITION: auction_len > 2.5
  CONDITION: spade_len <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P2:
  CALL: PASS
  PRIORITY: 10
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
  # distilled from Brill /bid

RULE BD_open_uncont_P3:
  CALL: 1S
  PRIORITY: 10
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
  # distilled from Brill /bid

RULE BD_open_uncont_P4:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P5:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P6:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_vulnerable <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P7:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P8:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 4.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: auction_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P9:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P10:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len > 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: auction_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P11:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: hcp <= 10.5
  # distilled from Brill /bid

RULE BD_open_uncont_P12:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: hcp > 10.5
  # distilled from Brill /bid

RULE BD_open_uncont_P13:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P14:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: rule20_total > 19.5
  CONDITION: spade_len > 4.5
  CONDITION: heart_len > 3.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: auction_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P15:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len <= 4.0
  CONDITION: heart_len <= 4.0
  # distilled from Brill /bid

RULE BD_open_uncont_P16:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len <= 4.0
  CONDITION: heart_len > 4.0
  # distilled from Brill /bid

RULE BD_open_uncont_P17:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls <= 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len > 4.0
  # distilled from Brill /bid

RULE BD_open_uncont_P18:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: club_len <= 2.5
  CONDITION: is_favorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P19:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: club_len <= 2.5
  CONDITION: is_favorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P20:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten <= 0.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: heart_len <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P21:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten <= 0.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: heart_len > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P22:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten <= 0.5
  CONDITION: is_favorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P23:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten > 0.5
  CONDITION: shape_pattern == '5332'
  # distilled from Brill /bid

RULE BD_open_uncont_P24:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: major_hcp <= 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P25:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: club_len > 2.5
  CONDITION: h_has_ten > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: major_hcp > 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P26:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: h_has_king <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P27:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: h_has_king > 0.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: h_has_ten <= 0.5
  CONDITION: d_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P28:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: h_has_king > 0.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: h_has_ten <= 0.5
  CONDITION: d_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P29:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: h_has_king > 0.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: h_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P30:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: h_has_king > 0.5
  CONDITION: c_is_best_minor > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P31:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len > 4.5
  CONDITION: club_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P32:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len > 4.5
  CONDITION: club_len > 2.5
  CONDITION: major_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P33:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len > 4.5
  CONDITION: club_len > 2.5
  CONDITION: major_hcp > 5.5
  CONDITION: s_has_ten <= 0.5
  CONDITION: my_seat == 'E'
  # distilled from Brill /bid

RULE BD_open_uncont_P34:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len > 4.5
  CONDITION: club_len > 2.5
  CONDITION: major_hcp > 5.5
  CONDITION: s_has_ten <= 0.5
  CONDITION: my_seat != 'E'
  CONDITION: h_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P35:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len > 4.5
  CONDITION: club_len > 2.5
  CONDITION: major_hcp > 5.5
  CONDITION: s_has_ten <= 0.5
  CONDITION: my_seat != 'E'
  CONDITION: h_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P36:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len > 4.5
  CONDITION: club_len > 2.5
  CONDITION: major_hcp > 5.5
  CONDITION: s_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P37:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: club_len <= 3.5
  CONDITION: spade_len <= 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P38:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: club_len <= 3.5
  CONDITION: spade_len > 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P39:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: club_len > 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P40:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: is_vulnerable <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P41:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: c_stopper <= 1.0
  CONDITION: spade_len <= 1.5
  CONDITION: major_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P42:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: c_stopper <= 1.0
  CONDITION: spade_len <= 1.5
  CONDITION: major_hcp > 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P43:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: c_stopper <= 1.0
  CONDITION: spade_len > 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P44:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: c_stopper > 1.0
  CONDITION: h_has_king <= 0.5
  CONDITION: heart_len <= 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P45:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: c_stopper > 1.0
  CONDITION: h_has_king <= 0.5
  CONDITION: heart_len > 1.5
  CONDITION: shortest_suit_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P46:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: c_stopper > 1.0
  CONDITION: h_has_king <= 0.5
  CONDITION: heart_len > 1.5
  CONDITION: shortest_suit_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P47:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: controls > 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: c_stopper > 1.0
  CONDITION: h_has_king > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P48:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len <= 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: quick_tricks <= 2.75
  # distilled from Brill /bid

RULE BD_open_uncont_P49:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len <= 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: quick_tricks > 2.75
  CONDITION: spade_len <= 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P50:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len <= 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: quick_tricks > 2.75
  CONDITION: spade_len > 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P51:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len <= 6.5
  CONDITION: rule20_total > 20.5
  # distilled from Brill /bid

RULE BD_open_uncont_P52:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P53:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: is_favorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P54:
  CALL: 4C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: is_favorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P55:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: club_hcp <= 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P56:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: club_hcp > 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P57:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: club_len <= 7.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P58:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: club_len <= 7.5
  CONDITION: auction_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P59:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: club_len > 7.5
  CONDITION: major_hcp <= 3.5
  CONDITION: auction_len <= 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P60:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: club_len > 7.5
  CONDITION: major_hcp <= 3.5
  CONDITION: auction_len > 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P61:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: club_len > 7.5
  CONDITION: major_hcp > 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P62:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: d_top3_honors <= 1.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P63:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: d_top3_honors <= 1.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P64:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: d_top3_honors <= 1.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_favorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P65:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: d_top3_honors <= 1.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_favorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P66:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: d_top3_honors > 1.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: controls <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P67:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: d_top3_honors > 1.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: controls > 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P68:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: d_top3_honors > 1.5
  CONDITION: second_longest_len > 4.5
  CONDITION: club_len <= 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P69:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: d_top3_honors > 1.5
  CONDITION: second_longest_len > 4.5
  CONDITION: club_len > 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P70:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len <= 6.5
  CONDITION: rule20_total > 20.5
  # distilled from Brill /bid

RULE BD_open_uncont_P71:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P72:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: is_favorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P73:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: is_favorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P74:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: diamond_len <= 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P75:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: diamond_len > 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P76:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: diamond_len <= 7.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P77:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: diamond_len <= 7.5
  CONDITION: auction_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P78:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: diamond_len > 7.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: minor_hcp <= 9.5
  # distilled from Brill /bid

RULE BD_open_uncont_P79:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: diamond_len > 7.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: minor_hcp > 9.5
  # distilled from Brill /bid

RULE BD_open_uncont_P80:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: diamond_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: diamond_len > 7.5
  CONDITION: is_favorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P81:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total <= 19.5
  CONDITION: h_top3_honors <= 1.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: spade_len <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P82:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total <= 19.5
  CONDITION: h_top3_honors <= 1.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: spade_len > 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P83:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total <= 19.5
  CONDITION: h_top3_honors <= 1.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: losing_trick_count <= 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P84:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total <= 19.5
  CONDITION: h_top3_honors <= 1.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: losing_trick_count > 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P85:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total <= 19.5
  CONDITION: h_top3_honors <= 1.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P86:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total <= 19.5
  CONDITION: h_top3_honors <= 1.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: auction_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P87:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total <= 19.5
  CONDITION: h_top3_honors <= 1.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: total_points <= 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P88:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total <= 19.5
  CONDITION: h_top3_honors <= 1.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: total_points > 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P89:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total <= 19.5
  CONDITION: h_top3_honors > 1.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P90:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total <= 19.5
  CONDITION: h_top3_honors > 1.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_unfavorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P91:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total <= 19.5
  CONDITION: h_top3_honors > 1.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: is_unfavorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P92:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total <= 19.5
  CONDITION: h_top3_honors > 1.5
  CONDITION: spade_len > 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P93:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total > 19.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: hcp <= 10.5
  # distilled from Brill /bid

RULE BD_open_uncont_P94:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total > 19.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: hcp > 10.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P95:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total > 19.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: hcp > 10.5
  CONDITION: auction_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P96:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total > 19.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: controls <= 4.5
  CONDITION: losing_trick_count <= 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P97:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total > 19.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: controls <= 4.5
  CONDITION: losing_trick_count > 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P98:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total > 19.5
  CONDITION: rule20_total <= 20.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: controls > 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P99:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total > 19.5
  CONDITION: rule20_total > 20.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P100:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: rule20_total > 19.5
  CONDITION: rule20_total > 20.5
  CONDITION: auction_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P101:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P102:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P103:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count > 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P104:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: hcp <= 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P105:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: hcp > 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P106:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count > 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P107:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len <= 1.5
  CONDITION: major_hcp <= 9.5
  CONDITION: rule20_total <= 21.5
  CONDITION: is_unfavorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P108:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len <= 1.5
  CONDITION: major_hcp <= 9.5
  CONDITION: rule20_total <= 21.5
  CONDITION: is_unfavorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P109:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len <= 1.5
  CONDITION: major_hcp <= 9.5
  CONDITION: rule20_total > 21.5
  # distilled from Brill /bid

RULE BD_open_uncont_P110:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len <= 1.5
  CONDITION: major_hcp > 9.5
  # distilled from Brill /bid

RULE BD_open_uncont_P111:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len > 1.5
  CONDITION: heart_len <= 8.5
  CONDITION: club_len <= 3.5
  CONDITION: h_has_queen <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P112:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len > 1.5
  CONDITION: heart_len <= 8.5
  CONDITION: club_len <= 3.5
  CONDITION: h_has_queen > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P113:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len > 1.5
  CONDITION: heart_len <= 8.5
  CONDITION: club_len > 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P114:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: spade_len > 1.5
  CONDITION: heart_len > 8.5
  # distilled from Brill /bid

RULE BD_open_uncont_P115:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 10.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: hcp <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P116:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 10.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: hcp > 4.5
  CONDITION: heart_len <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P117:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 10.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: hcp > 4.5
  CONDITION: heart_len > 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P118:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 10.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: losing_trick_count <= 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P119:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 10.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: losing_trick_count > 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P120:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 10.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: s_top3_honors > 1.5
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P121:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 10.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: s_top3_honors > 1.5
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P122:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 10.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P123:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 10.5
  CONDITION: is_vulnerable <= 0.5
  CONDITION: auction_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P124:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 10.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: is_unfavorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P125:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 10.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: is_unfavorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P126:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 10.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: s_top3_honors > 1.5
  CONDITION: controls <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P127:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 10.5
  CONDITION: is_vulnerable > 0.5
  CONDITION: s_top3_honors > 1.5
  CONDITION: controls > 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P128:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total > 20.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P129:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: rule20_total > 20.5
  CONDITION: auction_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P130:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: quick_tricks <= 2.25
  # distilled from Brill /bid

RULE BD_open_uncont_P131:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: quick_tricks > 2.25
  # distilled from Brill /bid

RULE BD_open_uncont_P132:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: total_points <= 7.5
  CONDITION: hcp <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P133:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: total_points <= 7.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count <= 8.5
  # distilled from Brill /bid

RULE BD_open_uncont_P134:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: total_points <= 7.5
  CONDITION: hcp > 4.5
  CONDITION: losing_trick_count > 8.5
  # distilled from Brill /bid

RULE BD_open_uncont_P135:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: total_points > 7.5
  CONDITION: hcp <= 10.5
  CONDITION: losing_trick_count <= 8.5
  # distilled from Brill /bid

RULE BD_open_uncont_P136:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: total_points > 7.5
  CONDITION: hcp <= 10.5
  CONDITION: losing_trick_count > 8.5
  # distilled from Brill /bid

RULE BD_open_uncont_P137:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_top3_honors <= 1.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: total_points > 7.5
  CONDITION: hcp > 10.5
  # distilled from Brill /bid

RULE BD_open_uncont_P138:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_top3_honors > 1.5
  CONDITION: hcp <= 10.5
  # distilled from Brill /bid

RULE BD_open_uncont_P139:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: s_top3_honors > 1.5
  CONDITION: hcp > 10.5
  # distilled from Brill /bid

RULE BD_open_uncont_P140:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P141:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: hcp <= 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P142:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_unfavorable_vuln <= 0.5
  CONDITION: hcp > 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P143:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: hcp <= 8.0
  # distilled from Brill /bid

RULE BD_open_uncont_P144:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: hcp > 8.0
  # distilled from Brill /bid

RULE BD_open_uncont_P145:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: major_hcp <= 10.5
  # distilled from Brill /bid

RULE BD_open_uncont_P146:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: major_hcp > 10.5
  # distilled from Brill /bid

RULE BD_open_uncont_P147:
  CALL: 5S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: hcp <= 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P148:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: hcp > 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P149:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: minor_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P150:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total <= 20.5
  CONDITION: hcp > 4.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: minor_hcp > 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P151:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_unfavorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P152:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: diamond_hcp <= 3.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P153:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: diamond_hcp <= 3.5
  CONDITION: auction_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P154:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: is_unfavorable_vuln > 0.5
  CONDITION: diamond_hcp > 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P155:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P156:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P157:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp <= 11.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: s_is_longest > 0.5
  CONDITION: spade_len > 6.5
  CONDITION: rule20_total > 20.5
  CONDITION: is_favorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P158:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp <= 14.5
  CONDITION: club_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P159:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp <= 14.5
  CONDITION: club_len > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P160:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points <= 17.5
  CONDITION: is_semi_balanced <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P161:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points <= 17.5
  CONDITION: is_semi_balanced > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P162:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: club_len <= 2.5
  CONDITION: hcp <= 17.5
  # distilled from Brill /bid

RULE BD_open_uncont_P163:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: club_len <= 2.5
  CONDITION: hcp > 17.5
  # distilled from Brill /bid

RULE BD_open_uncont_P164:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: club_len > 2.5
  CONDITION: hcp <= 17.5
  CONDITION: is_semi_balanced <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P165:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: club_len > 2.5
  CONDITION: hcp <= 17.5
  CONDITION: is_semi_balanced > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P166:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: club_len > 2.5
  CONDITION: hcp > 17.5
  CONDITION: losing_trick_count <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P167:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: club_len > 2.5
  CONDITION: hcp > 17.5
  CONDITION: losing_trick_count > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P168:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: diamond_hcp <= 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P169:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: diamond_hcp > 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P170:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P171:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5
  CONDITION: hcp <= 24.5
  # distilled from Brill /bid

RULE BD_open_uncont_P172:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5
  CONDITION: hcp > 24.5
  # distilled from Brill /bid

RULE BD_open_uncont_P173:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp <= 14.5
  CONDITION: diamond_len <= 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P174:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp <= 14.5
  CONDITION: diamond_len > 6.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P175:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp <= 14.5
  CONDITION: diamond_len > 6.5
  CONDITION: auction_len > 2.5
  CONDITION: hcp <= 12.5
  CONDITION: heart_len <= 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P176:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp <= 14.5
  CONDITION: diamond_len > 6.5
  CONDITION: auction_len > 2.5
  CONDITION: hcp <= 12.5
  CONDITION: heart_len > 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P177:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp <= 14.5
  CONDITION: diamond_len > 6.5
  CONDITION: auction_len > 2.5
  CONDITION: hcp > 12.5
  # distilled from Brill /bid

RULE BD_open_uncont_P178:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points <= 17.5
  CONDITION: is_semi_balanced <= 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P179:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points <= 17.5
  CONDITION: is_semi_balanced > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P180:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 17.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: total_points <= 20.5
  # distilled from Brill /bid

RULE BD_open_uncont_P181:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 17.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: total_points > 20.5
  # distilled from Brill /bid

RULE BD_open_uncont_P182:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp <= 17.5
  CONDITION: is_semi_balanced > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P183:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp <= 19.5
  CONDITION: hcp > 17.5
  # distilled from Brill /bid

RULE BD_open_uncont_P184:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: losing_trick_count <= 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P185:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: losing_trick_count > 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P186:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced > 0.5
  # distilled from Brill /bid

RULE BD_open_uncont_P187:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5
  CONDITION: hcp <= 24.5
  # distilled from Brill /bid

RULE BD_open_uncont_P188:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5
  CONDITION: hcp > 24.5
  CONDITION: total_points <= 27.5
  # distilled from Brill /bid

RULE BD_open_uncont_P189:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 14.5
  CONDITION: total_points > 17.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5
  CONDITION: hcp > 24.5
  CONDITION: total_points > 27.5
  # distilled from Brill /bid

RULE BD_open_uncont_P190:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp <= 14.5
  # distilled from Brill /bid

RULE BD_open_uncont_P191:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 16.5
  # distilled from Brill /bid

RULE BD_open_uncont_P192:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp > 14.5
  CONDITION: hcp > 16.5
  # distilled from Brill /bid

RULE BD_open_uncont_P193:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len <= 4.0
  CONDITION: club_len <= 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P194:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len <= 4.0
  CONDITION: club_len > 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P195:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len > 4.0
  CONDITION: losing_trick_count <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P196:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len > 4.0
  CONDITION: losing_trick_count > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P197:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest > 0.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total <= 27.5
  # distilled from Brill /bid

RULE BD_open_uncont_P198:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest > 0.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total > 27.5
  CONDITION: minor_hcp <= 9.5
  CONDITION: hcp <= 17.5
  # distilled from Brill /bid

RULE BD_open_uncont_P199:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest > 0.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total > 27.5
  CONDITION: minor_hcp <= 9.5
  CONDITION: hcp > 17.5
  # distilled from Brill /bid

RULE BD_open_uncont_P200:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest > 0.5
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total > 27.5
  CONDITION: minor_hcp > 9.5
  # distilled from Brill /bid

RULE BD_open_uncont_P201:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest > 0.5
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P202:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest > 0.5
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len > 2.5
  CONDITION: hcp <= 12.5
  CONDITION: heart_len <= 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P203:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest > 0.5
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len > 2.5
  CONDITION: hcp <= 12.5
  CONDITION: heart_len > 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P204:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest > 0.5
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len > 2.5
  CONDITION: hcp > 12.5
  CONDITION: heart_len <= 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P205:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: shape_pattern != '5332'
  CONDITION: h_is_longest > 0.5
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len > 2.5
  CONDITION: hcp > 12.5
  CONDITION: heart_len > 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P206:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: total_points <= 21.5
  CONDITION: heart_len <= 5.5
  CONDITION: shortest_suit_len <= 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P207:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: total_points <= 21.5
  CONDITION: heart_len <= 5.5
  CONDITION: shortest_suit_len > 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P208:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: total_points <= 21.5
  CONDITION: heart_len > 5.5
  CONDITION: losing_trick_count <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P209:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: total_points <= 21.5
  CONDITION: heart_len > 5.5
  CONDITION: losing_trick_count > 4.5
  CONDITION: major_hcp <= 10.0
  # distilled from Brill /bid

RULE BD_open_uncont_P210:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: total_points <= 21.5
  CONDITION: heart_len > 5.5
  CONDITION: losing_trick_count > 4.5
  CONDITION: major_hcp > 10.0
  # distilled from Brill /bid

RULE BD_open_uncont_P211:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: total_points > 21.5
  CONDITION: hcp <= 21.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: losing_trick_count <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P212:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: total_points > 21.5
  CONDITION: hcp <= 21.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: losing_trick_count > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P213:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: total_points > 21.5
  CONDITION: hcp <= 21.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: shortest_suit_len > 1.5
  # distilled from Brill /bid

RULE BD_open_uncont_P214:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: total_points > 21.5
  CONDITION: hcp <= 21.5
  CONDITION: longest_suit_len > 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P215:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: total_points > 21.5
  CONDITION: hcp > 21.5
  # distilled from Brill /bid

RULE BD_open_uncont_P216:
  CALL: 1C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 4.0
  CONDITION: diamond_len <= 4.0
  # distilled from Brill /bid

RULE BD_open_uncont_P217:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len <= 4.0
  CONDITION: diamond_len > 4.0
  # distilled from Brill /bid

RULE BD_open_uncont_P218:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: heart_len > 4.0
  # distilled from Brill /bid

RULE BD_open_uncont_P219:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp <= 14.5
  # distilled from Brill /bid

RULE BD_open_uncont_P220:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 16.5
  # distilled from Brill /bid

RULE BD_open_uncont_P221:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp > 14.5
  CONDITION: hcp > 16.5
  # distilled from Brill /bid

RULE BD_open_uncont_P222:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total <= 28.5
  CONDITION: auction_len <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P223:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total <= 28.5
  CONDITION: auction_len > 2.5
  CONDITION: major_hcp <= 9.0
  # distilled from Brill /bid

RULE BD_open_uncont_P224:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total <= 28.5
  CONDITION: auction_len > 2.5
  CONDITION: major_hcp > 9.0
  # distilled from Brill /bid

RULE BD_open_uncont_P225:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total > 28.5
  CONDITION: second_longest_len <= 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P226:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total > 28.5
  CONDITION: second_longest_len > 4.5
  CONDITION: losing_trick_count <= 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P227:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count <= 3.5
  CONDITION: rule20_total > 28.5
  CONDITION: second_longest_len > 4.5
  CONDITION: losing_trick_count > 2.5
  # distilled from Brill /bid

RULE BD_open_uncont_P228:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len <= 2.5
  CONDITION: shape_pattern == '7321'
  CONDITION: hcp <= 17.5
  # distilled from Brill /bid

RULE BD_open_uncont_P229:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len <= 2.5
  CONDITION: shape_pattern == '7321'
  CONDITION: hcp > 17.5
  CONDITION: total_points <= 19.5
  # distilled from Brill /bid

RULE BD_open_uncont_P230:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len <= 2.5
  CONDITION: shape_pattern == '7321'
  CONDITION: hcp > 17.5
  CONDITION: total_points > 19.5
  # distilled from Brill /bid

RULE BD_open_uncont_P231:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len <= 2.5
  CONDITION: shape_pattern != '7321'
  # distilled from Brill /bid

RULE BD_open_uncont_P232:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len > 2.5
  CONDITION: hcp <= 12.5
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P233:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len > 2.5
  CONDITION: hcp <= 12.5
  CONDITION: spade_len > 5.5
  CONDITION: spade_len <= 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P234:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len > 2.5
  CONDITION: hcp <= 12.5
  CONDITION: spade_len > 5.5
  CONDITION: spade_len > 6.5
  # distilled from Brill /bid

RULE BD_open_uncont_P235:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len > 2.5
  CONDITION: hcp > 12.5
  CONDITION: shape_pattern == '8221'
  # distilled from Brill /bid

RULE BD_open_uncont_P236:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: s_is_longest > 0.5
  CONDITION: shape_pattern != '5332'
  CONDITION: losing_trick_count > 3.5
  CONDITION: auction_len > 2.5
  CONDITION: hcp > 12.5
  CONDITION: shape_pattern != '8221'
  # distilled from Brill /bid

RULE BD_open_uncont_P237:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: quick_tricks <= 4.25
  CONDITION: club_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P238:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: quick_tricks <= 4.25
  CONDITION: club_hcp > 3.5
  CONDITION: club_hcp <= 6.0
  # distilled from Brill /bid

RULE BD_open_uncont_P239:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: quick_tricks <= 4.25
  CONDITION: club_hcp > 3.5
  CONDITION: club_hcp > 6.0
  # distilled from Brill /bid

RULE BD_open_uncont_P240:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: quick_tricks > 4.25
  # distilled from Brill /bid

RULE BD_open_uncont_P241:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: spade_len > 5.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: shape_pattern == '7321'
  CONDITION: hcp <= 20.5
  # distilled from Brill /bid

RULE BD_open_uncont_P242:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: spade_len > 5.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: shape_pattern == '7321'
  CONDITION: hcp > 20.5
  # distilled from Brill /bid

RULE BD_open_uncont_P243:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: spade_len > 5.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: shape_pattern != '7321'
  # distilled from Brill /bid

RULE BD_open_uncont_P244:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced <= 0.5
  CONDITION: spade_len > 5.5
  CONDITION: losing_trick_count > 4.5
  # distilled from Brill /bid

RULE BD_open_uncont_P245:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_open_uncont_P246:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: spade_len > 5.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: controls <= 7.5
  # distilled from Brill /bid

RULE BD_open_uncont_P247:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: spade_len > 5.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: controls > 7.5
  CONDITION: major_hcp <= 8.5
  # distilled from Brill /bid

RULE BD_open_uncont_P248:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: spade_len > 5.5
  CONDITION: losing_trick_count <= 4.5
  CONDITION: controls > 7.5
  CONDITION: major_hcp > 8.5
  # distilled from Brill /bid

RULE BD_open_uncont_P249:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: spade_len > 5.5
  CONDITION: losing_trick_count > 4.5
  CONDITION: ace_count <= 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P250:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp <= 21.5
  CONDITION: is_semi_balanced > 0.5
  CONDITION: spade_len > 5.5
  CONDITION: losing_trick_count > 4.5
  CONDITION: ace_count > 3.5
  # distilled from Brill /bid

RULE BD_open_uncont_P251:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == True
  CONDITION: opponents_bid == False
  CONDITION: hcp > 11.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 19.5
  CONDITION: hcp > 21.5
  # distilled from Brill /bid

RULE BD_later_uncont_P0:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: competition_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: shortest_suit_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P1:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: competition_level <= 1.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: shortest_suit_len > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P2:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: competition_level <= 1.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P3:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: competition_level <= 1.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P4:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max <= 20.5
  CONDITION: longest_suit_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P5:
  CALL: XX
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max <= 20.5
  CONDITION: longest_suit_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P6:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max > 20.5
  CONDITION: total_points <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P7:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max <= 25.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_max > 20.5
  CONDITION: total_points > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P8:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: heart_len <= 3.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: h_is_best_major <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P9:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: heart_len <= 3.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: h_is_best_major > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P10:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: heart_len <= 3.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P11:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: heart_len <= 3.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: support_in_partner_suit > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P12:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: auction_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P13:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: auction_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P14:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'H'
  # distilled from Brill /bid

RULE BD_later_uncont_P15:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: combined_hcp_max > 25.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'H'
  # distilled from Brill /bid

RULE BD_later_uncont_P16:
  CALL: XX
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len <= 5.0
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P17:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len <= 5.0
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: club_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P18:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len <= 5.0
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: club_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P19:
  CALL: XX
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len > 5.0
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P20:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len > 5.0
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P21:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len > 5.0
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: shape_pattern == '6520'
  # distilled from Brill /bid

RULE BD_later_uncont_P22:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid == '1NT'
  CONDITION: club_len > 5.0
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: shape_pattern != '6520'
  # distilled from Brill /bid

RULE BD_later_uncont_P23:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: auction_len <= 5.5
  CONDITION: diamond_len <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P24:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: auction_len <= 5.5
  CONDITION: diamond_len > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P25:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P26:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P27:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P28:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P29:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: opening_bid == '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P30:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: opening_bid != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: opening_bid != '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P31:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: heart_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P32:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: heart_len > 5.5
  CONDITION: total_points <= 7.5
  # distilled from Brill /bid

RULE BD_later_uncont_P33:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: heart_len > 5.5
  CONDITION: total_points > 7.5
  CONDITION: quick_tricks <= 0.75
  CONDITION: queen_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P34:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: heart_len > 5.5
  CONDITION: total_points > 7.5
  CONDITION: quick_tricks <= 0.75
  CONDITION: queen_count > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P35:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: heart_len > 5.5
  CONDITION: total_points > 7.5
  CONDITION: quick_tricks > 0.75
  # distilled from Brill /bid

RULE BD_later_uncont_P36:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 4.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: jack_count <= 0.5
  CONDITION: hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P37:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 4.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: jack_count <= 0.5
  CONDITION: hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P38:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 4.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: jack_count > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P39:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 4.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: competition_level <= 1.5
  CONDITION: jack_count <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P40:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 4.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: competition_level <= 1.5
  CONDITION: jack_count > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P41:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 4.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: competition_level > 1.5
  CONDITION: total_points <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P42:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 4.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: competition_level > 1.5
  CONDITION: total_points > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P43:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: auction_len <= 5.5
  CONDITION: spade_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P44:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: auction_len <= 5.5
  CONDITION: spade_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P45:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: auction_len > 5.5
  CONDITION: spade_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P46:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: auction_len > 5.5
  CONDITION: spade_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P47:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len <= 5.5
  CONDITION: last_bid_strain == 'H'
  # distilled from Brill /bid

RULE BD_later_uncont_P48:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len <= 5.5
  CONDITION: last_bid_strain != 'H'
  # distilled from Brill /bid

RULE BD_later_uncont_P49:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len > 5.5
  CONDITION: last_bid_seat == 'E'
  # distilled from Brill /bid

RULE BD_later_uncont_P50:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: auction_len > 5.5
  CONDITION: last_bid_seat != 'E'
  # distilled from Brill /bid

RULE BD_later_uncont_P51:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 1.5
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P52:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len <= 1.5
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P53:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: spade_len > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P54:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: minor_hcp <= 3.5
  CONDITION: spade_len <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P55:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: minor_hcp <= 3.5
  CONDITION: spade_len > 0.5
  CONDITION: spade_hcp <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P56:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: minor_hcp <= 3.5
  CONDITION: spade_len > 0.5
  CONDITION: spade_hcp > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P57:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: minor_hcp > 3.5
  CONDITION: total_points <= 8.5
  # distilled from Brill /bid

RULE BD_later_uncont_P58:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: minor_hcp > 3.5
  CONDITION: total_points > 8.5
  CONDITION: d_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P59:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: minor_hcp > 3.5
  CONDITION: total_points > 8.5
  CONDITION: d_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P60:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len > 5.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: diamond_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P61:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len > 5.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: diamond_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P62:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len > 5.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: heart_hcp <= 3.5
  CONDITION: hcp <= 8.5
  # distilled from Brill /bid

RULE BD_later_uncont_P63:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len > 5.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: heart_hcp <= 3.5
  CONDITION: hcp > 8.5
  # distilled from Brill /bid

RULE BD_later_uncont_P64:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len > 5.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: heart_hcp > 3.5
  CONDITION: heart_hcp <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P65:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: auction_len > 5.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: heart_hcp > 3.5
  CONDITION: heart_hcp > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P66:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: heart_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P67:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: heart_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P68:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: auction_len > 5.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: spade_hcp <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P69:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: auction_len > 5.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: spade_hcp > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P70:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: auction_len > 5.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: shape_pattern == '5422'
  CONDITION: hcp <= 8.5
  # distilled from Brill /bid

RULE BD_later_uncont_P71:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: auction_len > 5.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: shape_pattern == '5422'
  CONDITION: hcp > 8.5
  # distilled from Brill /bid

RULE BD_later_uncont_P72:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 4.5
  CONDITION: auction_len > 5.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: shape_pattern != '5422'
  # distilled from Brill /bid

RULE BD_later_uncont_P73:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp <= 9.5
  CONDITION: club_len <= 4.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P74:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp <= 9.5
  CONDITION: club_len <= 4.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P75:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp <= 9.5
  CONDITION: club_len <= 4.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P76:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp <= 9.5
  CONDITION: club_len > 4.5
  CONDITION: club_len <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P77:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp <= 9.5
  CONDITION: club_len > 4.5
  CONDITION: club_len <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P78:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp <= 9.5
  CONDITION: club_len > 4.5
  CONDITION: club_len > 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P79:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp <= 10.5
  CONDITION: club_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P80:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp <= 10.5
  CONDITION: club_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P81:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp > 10.5
  CONDITION: spade_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P82:
  CALL: XX
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp > 10.5
  CONDITION: spade_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P83:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: singleton_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P84:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: singleton_count > 0.5
  CONDITION: hcp <= 12.0
  # distilled from Brill /bid

RULE BD_later_uncont_P85:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: singleton_count > 0.5
  CONDITION: hcp > 12.0
  # distilled from Brill /bid

RULE BD_later_uncont_P86:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: third_longest_len <= 2.5
  CONDITION: second_longest_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P87:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: third_longest_len <= 2.5
  CONDITION: second_longest_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P88:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: third_longest_len > 2.5
  CONDITION: hcp <= 11.5
  # distilled from Brill /bid

RULE BD_later_uncont_P89:
  CALL: XX
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: third_longest_len > 2.5
  CONDITION: hcp > 11.5
  # distilled from Brill /bid

RULE BD_later_uncont_P90:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: rule20_total <= 24.5
  # distilled from Brill /bid

RULE BD_later_uncont_P91:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: rule20_total > 24.5
  CONDITION: shape_pattern == '6322'
  # distilled from Brill /bid

RULE BD_later_uncont_P92:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: rule20_total > 24.5
  CONDITION: shape_pattern != '6322'
  # distilled from Brill /bid

RULE BD_later_uncont_P93:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len > 6.5
  CONDITION: hcp <= 10.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P94:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len > 6.5
  CONDITION: hcp <= 10.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P95:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len > 6.5
  CONDITION: hcp > 10.5
  CONDITION: hcp <= 17.5
  # distilled from Brill /bid

RULE BD_later_uncont_P96:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: heart_len > 6.5
  CONDITION: hcp > 10.5
  CONDITION: hcp > 17.5
  # distilled from Brill /bid

RULE BD_later_uncont_P97:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp <= 9.5
  CONDITION: diamond_len <= 8.0
  # distilled from Brill /bid

RULE BD_later_uncont_P98:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp <= 9.5
  CONDITION: diamond_len > 8.0
  # distilled from Brill /bid

RULE BD_later_uncont_P99:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: second_longest_len <= 3.5
  CONDITION: hcp <= 12.5
  CONDITION: is_semi_balanced <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P100:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: second_longest_len <= 3.5
  CONDITION: hcp <= 12.5
  CONDITION: is_semi_balanced > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P101:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: second_longest_len <= 3.5
  CONDITION: hcp > 12.5
  CONDITION: total_points <= 15.5
  # distilled from Brill /bid

RULE BD_later_uncont_P102:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: second_longest_len <= 3.5
  CONDITION: hcp > 12.5
  CONDITION: total_points > 15.5
  # distilled from Brill /bid

RULE BD_later_uncont_P103:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: second_longest_len > 3.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P104:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: second_longest_len > 3.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P105:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: second_longest_len > 3.5
  CONDITION: c_is_longest > 0.5
  CONDITION: spade_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P106:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: hcp > 9.5
  CONDITION: second_longest_len > 3.5
  CONDITION: c_is_longest > 0.5
  CONDITION: spade_len > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P107:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len <= 5.5
  CONDITION: hcp <= 9.5
  CONDITION: diamond_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P108:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len <= 5.5
  CONDITION: hcp <= 9.5
  CONDITION: diamond_hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P109:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len <= 5.5
  CONDITION: hcp > 9.5
  CONDITION: hcp <= 11.5
  # distilled from Brill /bid

RULE BD_later_uncont_P110:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len <= 5.5
  CONDITION: hcp > 9.5
  CONDITION: hcp > 11.5
  # distilled from Brill /bid

RULE BD_later_uncont_P111:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len > 5.5
  CONDITION: king_count <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P112:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len > 5.5
  CONDITION: king_count > 1.5
  CONDITION: hcp <= 13.5
  # distilled from Brill /bid

RULE BD_later_uncont_P113:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: diamond_len > 5.5
  CONDITION: king_count > 1.5
  CONDITION: hcp > 13.5
  # distilled from Brill /bid

RULE BD_later_uncont_P114:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest > 0.5
  CONDITION: c_has_jack <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P115:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: second_longest_len > 4.5
  CONDITION: h_is_longest > 0.5
  CONDITION: c_has_jack > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P116:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len <= 3.5
  CONDITION: hcp <= 9.5
  CONDITION: club_len <= 7.5
  # distilled from Brill /bid

RULE BD_later_uncont_P117:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len <= 3.5
  CONDITION: hcp <= 9.5
  CONDITION: club_len > 7.5
  # distilled from Brill /bid

RULE BD_later_uncont_P118:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: total_points <= 11.5
  CONDITION: competition_level <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P119:
  CALL: XX
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: total_points <= 11.5
  CONDITION: competition_level > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P120:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: total_points > 11.5
  CONDITION: rule20_total <= 24.5
  # distilled from Brill /bid

RULE BD_later_uncont_P121:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: total_points > 11.5
  CONDITION: rule20_total > 24.5
  # distilled from Brill /bid

RULE BD_later_uncont_P122:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: hcp <= 9.5
  CONDITION: diamond_len <= 4.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P123:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: hcp <= 9.5
  CONDITION: diamond_len <= 4.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P124:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: hcp <= 9.5
  CONDITION: diamond_len > 4.5
  CONDITION: hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P125:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: hcp <= 9.5
  CONDITION: diamond_len > 4.5
  CONDITION: hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P126:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: hcp > 9.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: diamond_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P127:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: hcp > 9.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: diamond_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P128:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: hcp > 9.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: is_balanced <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P129:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: hcp > 9.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: is_balanced > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P130:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 17.5
  CONDITION: heart_len <= 5.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: hcp <= 11.5
  # distilled from Brill /bid

RULE BD_later_uncont_P131:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 17.5
  CONDITION: heart_len <= 5.5
  CONDITION: h_is_longest <= 0.5
  CONDITION: hcp > 11.5
  # distilled from Brill /bid

RULE BD_later_uncont_P132:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 17.5
  CONDITION: heart_len <= 5.5
  CONDITION: h_is_longest > 0.5
  CONDITION: opp_first_call == 'PASS'
  # distilled from Brill /bid

RULE BD_later_uncont_P133:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 17.5
  CONDITION: heart_len <= 5.5
  CONDITION: h_is_longest > 0.5
  CONDITION: opp_first_call != 'PASS'
  # distilled from Brill /bid

RULE BD_later_uncont_P134:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 17.5
  CONDITION: heart_len > 5.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp <= 10.5
  # distilled from Brill /bid

RULE BD_later_uncont_P135:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 17.5
  CONDITION: heart_len > 5.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp > 10.5
  # distilled from Brill /bid

RULE BD_later_uncont_P136:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 17.5
  CONDITION: heart_len > 5.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: heart_len <= 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P137:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 17.5
  CONDITION: heart_len > 5.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: heart_len > 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P138:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 17.5
  CONDITION: auction_len <= 3.5
  CONDITION: club_len <= 3.5
  CONDITION: is_balanced <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P139:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 17.5
  CONDITION: auction_len <= 3.5
  CONDITION: club_len <= 3.5
  CONDITION: is_balanced > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P140:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 17.5
  CONDITION: auction_len <= 3.5
  CONDITION: club_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P141:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 17.5
  CONDITION: auction_len > 3.5
  CONDITION: shortest_suit_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P142:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call == '1D'
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 17.5
  CONDITION: auction_len > 3.5
  CONDITION: shortest_suit_len > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P143:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp <= 9.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P144:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp <= 9.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level > 1.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: opening_bid == '1C'
  # distilled from Brill /bid

RULE BD_later_uncont_P145:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp <= 9.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level > 1.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: opening_bid != '1C'
  # distilled from Brill /bid

RULE BD_later_uncont_P146:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp <= 9.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level > 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: my_last_call == '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P147:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp <= 9.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level > 1.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: my_last_call != '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P148:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp <= 9.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid == '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P149:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp <= 9.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: auction_len <= 5.5
  CONDITION: heart_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P150:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp <= 9.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: auction_len <= 5.5
  CONDITION: heart_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P151:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp <= 9.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: auction_len > 5.5
  CONDITION: support_in_partner_suit <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P152:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp <= 9.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: opening_bid != '1S'
  CONDITION: auction_len > 5.5
  CONDITION: support_in_partner_suit > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P153:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced <= 0.5
  CONDITION: club_len <= 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: support_in_partner_suit <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P154:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced <= 0.5
  CONDITION: club_len <= 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: support_in_partner_suit > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P155:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced <= 0.5
  CONDITION: club_len <= 3.5
  CONDITION: heart_len > 5.5
  CONDITION: opening_bid == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P156:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced <= 0.5
  CONDITION: club_len <= 3.5
  CONDITION: heart_len > 5.5
  CONDITION: opening_bid != '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P157:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced <= 0.5
  CONDITION: club_len > 3.5
  CONDITION: competition_level <= 1.5
  CONDITION: combined_hcp_min <= 22.5
  # distilled from Brill /bid

RULE BD_later_uncont_P158:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced <= 0.5
  CONDITION: club_len > 3.5
  CONDITION: competition_level <= 1.5
  CONDITION: combined_hcp_min > 22.5
  # distilled from Brill /bid

RULE BD_later_uncont_P159:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced <= 0.5
  CONDITION: club_len > 3.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp <= 16.5
  # distilled from Brill /bid

RULE BD_later_uncont_P160:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced <= 0.5
  CONDITION: club_len > 3.5
  CONDITION: competition_level > 1.5
  CONDITION: hcp > 16.5
  # distilled from Brill /bid

RULE BD_later_uncont_P161:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: heart_len <= 3.5
  CONDITION: competition_level <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P162:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: heart_len <= 3.5
  CONDITION: competition_level > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P163:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: heart_len > 3.5
  CONDITION: competition_level <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P164:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: heart_len > 3.5
  CONDITION: competition_level > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P165:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: support_in_partner_suit <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P166:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: support_in_partner_suit > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P167:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: my_side_bid_count <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P168:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len <= 3.5
  CONDITION: combined_hcp_max > 26.5
  CONDITION: partner_last_call != '1C'
  CONDITION: partner_last_call != '1D'
  CONDITION: hcp > 9.5
  CONDITION: is_balanced > 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: my_side_bid_count > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P169:
  CALL: XX
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: heart_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P170:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: heart_len > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P171:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P172:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: club_len <= 3.0
  # distilled from Brill /bid

RULE BD_later_uncont_P173:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: club_len > 3.0
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P174:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: club_len > 3.0
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P175:
  CALL: XX
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P176:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: diamond_len <= 4.0
  CONDITION: jack_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P177:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: diamond_len <= 4.0
  CONDITION: jack_count > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P178:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len <= 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: diamond_len > 4.0
  # distilled from Brill /bid

RULE BD_later_uncont_P179:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: shape_pattern == '6421'
  CONDITION: controls <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P180:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: shape_pattern == '6421'
  CONDITION: controls > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P181:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: auction_len <= 5.5
  CONDITION: shape_pattern != '6421'
  # distilled from Brill /bid

RULE BD_later_uncont_P182:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 7.5
  CONDITION: heart_len > 4.5
  CONDITION: auction_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P183:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: heart_len <= 1.5
  CONDITION: third_longest_len <= 2.5
  CONDITION: major_hcp <= 2.0
  # distilled from Brill /bid

RULE BD_later_uncont_P184:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: heart_len <= 1.5
  CONDITION: third_longest_len <= 2.5
  CONDITION: major_hcp > 2.0
  # distilled from Brill /bid

RULE BD_later_uncont_P185:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: heart_len <= 1.5
  CONDITION: third_longest_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P186:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: heart_len > 1.5
  CONDITION: heart_len <= 4.5
  CONDITION: third_longest_len <= 3.5
  CONDITION: diamond_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P187:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: heart_len > 1.5
  CONDITION: heart_len <= 4.5
  CONDITION: third_longest_len <= 3.5
  CONDITION: diamond_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P188:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: heart_len > 1.5
  CONDITION: heart_len <= 4.5
  CONDITION: third_longest_len > 3.5
  CONDITION: diamond_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P189:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: heart_len > 1.5
  CONDITION: heart_len <= 4.5
  CONDITION: third_longest_len > 3.5
  CONDITION: diamond_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P190:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: heart_len > 1.5
  CONDITION: heart_len > 4.5
  CONDITION: rule20_total <= 18.5
  CONDITION: heart_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P191:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: heart_len > 1.5
  CONDITION: heart_len > 4.5
  CONDITION: rule20_total <= 18.5
  CONDITION: heart_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P192:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: heart_len > 1.5
  CONDITION: heart_len > 4.5
  CONDITION: rule20_total > 18.5
  CONDITION: heart_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P193:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: heart_len > 1.5
  CONDITION: heart_len > 4.5
  CONDITION: rule20_total > 18.5
  CONDITION: heart_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P194:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced <= 0.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 30.5
  CONDITION: support_in_partner_suit <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P195:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced <= 0.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 30.5
  CONDITION: support_in_partner_suit > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P196:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced <= 0.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 30.5
  CONDITION: competition_level <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P197:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced <= 0.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 30.5
  CONDITION: competition_level > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P198:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp <= 10.5
  # distilled from Brill /bid

RULE BD_later_uncont_P199:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp > 10.5
  # distilled from Brill /bid

RULE BD_later_uncont_P200:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 5.5
  CONDITION: hcp <= 15.5
  # distilled from Brill /bid

RULE BD_later_uncont_P201:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced <= 0.5
  CONDITION: heart_len > 4.5
  CONDITION: heart_len > 5.5
  CONDITION: hcp > 15.5
  # distilled from Brill /bid

RULE BD_later_uncont_P202:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced > 0.5
  CONDITION: combined_hcp_min <= 26.5
  CONDITION: combined_hcp_min <= 24.5
  CONDITION: support_in_partner_suit <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P203:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced > 0.5
  CONDITION: combined_hcp_min <= 26.5
  CONDITION: combined_hcp_min <= 24.5
  CONDITION: support_in_partner_suit > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P204:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced > 0.5
  CONDITION: combined_hcp_min <= 26.5
  CONDITION: combined_hcp_min > 24.5
  CONDITION: support_in_partner_suit <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P205:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced > 0.5
  CONDITION: combined_hcp_min <= 26.5
  CONDITION: combined_hcp_min > 24.5
  CONDITION: support_in_partner_suit > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P206:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced > 0.5
  CONDITION: combined_hcp_min > 26.5
  CONDITION: my_first_call == '1S'
  CONDITION: hcp <= 18.0
  # distilled from Brill /bid

RULE BD_later_uncont_P207:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced > 0.5
  CONDITION: combined_hcp_min > 26.5
  CONDITION: my_first_call == '1S'
  CONDITION: hcp > 18.0
  # distilled from Brill /bid

RULE BD_later_uncont_P208:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced > 0.5
  CONDITION: combined_hcp_min > 26.5
  CONDITION: my_first_call != '1S'
  CONDITION: hcp <= 14.5
  # distilled from Brill /bid

RULE BD_later_uncont_P209:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 1.5
  CONDITION: is_balanced > 0.5
  CONDITION: combined_hcp_min > 26.5
  CONDITION: my_first_call != '1S'
  CONDITION: hcp > 14.5
  # distilled from Brill /bid

RULE BD_later_uncont_P210:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: partner_opened <= 0.5
  CONDITION: diamond_hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P211:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: partner_opened <= 0.5
  CONDITION: diamond_hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P212:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len <= 3.5
  CONDITION: partner_opened > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P213:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 9.5
  # distilled from Brill /bid

RULE BD_later_uncont_P214:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 4.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 9.5
  # distilled from Brill /bid

RULE BD_later_uncont_P215:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 4.5
  CONDITION: rule20_total <= 19.5
  CONDITION: heart_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P216:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 4.5
  CONDITION: rule20_total <= 19.5
  CONDITION: heart_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P217:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: heart_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P218:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 4.5
  CONDITION: rule20_total > 19.5
  CONDITION: heart_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P219:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: rule20_total <= 15.5
  CONDITION: total_points <= 7.5
  CONDITION: heart_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P220:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: rule20_total <= 15.5
  CONDITION: total_points <= 7.5
  CONDITION: heart_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P221:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: rule20_total <= 15.5
  CONDITION: total_points > 7.5
  CONDITION: c_has_ten <= 0.5
  CONDITION: controls <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P222:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: rule20_total <= 15.5
  CONDITION: total_points > 7.5
  CONDITION: c_has_ten <= 0.5
  CONDITION: controls > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P223:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: rule20_total <= 15.5
  CONDITION: total_points > 7.5
  CONDITION: c_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P224:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: rule20_total > 15.5
  CONDITION: total_points <= 7.5
  CONDITION: hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P225:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: rule20_total > 15.5
  CONDITION: total_points <= 7.5
  CONDITION: hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P226:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: rule20_total > 15.5
  CONDITION: total_points > 7.5
  # distilled from Brill /bid

RULE BD_later_uncont_P227:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 3.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: hcp <= 16.5
  CONDITION: competition_level <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P228:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 3.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: hcp <= 16.5
  CONDITION: competition_level > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P229:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 3.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: hcp > 16.5
  CONDITION: rule20_total <= 26.5
  # distilled from Brill /bid

RULE BD_later_uncont_P230:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 3.5
  CONDITION: c_is_best_minor <= 0.5
  CONDITION: hcp > 16.5
  CONDITION: rule20_total > 26.5
  # distilled from Brill /bid

RULE BD_later_uncont_P231:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 3.5
  CONDITION: c_is_best_minor > 0.5
  CONDITION: hcp <= 10.5
  CONDITION: hcp <= 9.5
  # distilled from Brill /bid

RULE BD_later_uncont_P232:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 3.5
  CONDITION: c_is_best_minor > 0.5
  CONDITION: hcp <= 10.5
  CONDITION: hcp > 9.5
  # distilled from Brill /bid

RULE BD_later_uncont_P233:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 3.5
  CONDITION: c_is_best_minor > 0.5
  CONDITION: hcp > 10.5
  CONDITION: hcp <= 16.5
  # distilled from Brill /bid

RULE BD_later_uncont_P234:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 3.5
  CONDITION: c_is_best_minor > 0.5
  CONDITION: hcp > 10.5
  CONDITION: hcp > 16.5
  # distilled from Brill /bid

RULE BD_later_uncont_P235:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: rule20_total <= 25.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P236:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: rule20_total <= 25.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P237:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: rule20_total > 25.5
  CONDITION: rule20_total <= 26.5
  # distilled from Brill /bid

RULE BD_later_uncont_P238:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: rule20_total > 25.5
  CONDITION: rule20_total > 26.5
  # distilled from Brill /bid

RULE BD_later_uncont_P239:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp <= 10.5
  CONDITION: heart_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P240:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp <= 10.5
  CONDITION: heart_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P241:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 10.5
  CONDITION: opening_bid == '1D'
  # distilled from Brill /bid

RULE BD_later_uncont_P242:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 10.5
  CONDITION: opening_bid != '1D'
  # distilled from Brill /bid

RULE BD_later_uncont_P243:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp <= 13.5
  CONDITION: second_longest_len <= 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: losing_trick_count <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P244:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp <= 13.5
  CONDITION: second_longest_len <= 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: losing_trick_count > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P245:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp <= 13.5
  CONDITION: second_longest_len <= 3.5
  CONDITION: competition_level > 2.5
  CONDITION: rule20_total <= 19.5
  # distilled from Brill /bid

RULE BD_later_uncont_P246:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp <= 13.5
  CONDITION: second_longest_len <= 3.5
  CONDITION: competition_level > 2.5
  CONDITION: rule20_total > 19.5
  # distilled from Brill /bid

RULE BD_later_uncont_P247:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp <= 13.5
  CONDITION: second_longest_len > 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P248:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp <= 13.5
  CONDITION: second_longest_len > 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P249:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp <= 13.5
  CONDITION: second_longest_len > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: hcp <= 10.5
  # distilled from Brill /bid

RULE BD_later_uncont_P250:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp <= 13.5
  CONDITION: second_longest_len > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: hcp > 10.5
  # distilled from Brill /bid

RULE BD_later_uncont_P251:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 13.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len <= 6.5
  CONDITION: competition_level <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P252:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 13.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len <= 6.5
  CONDITION: competition_level > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P253:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 13.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len > 6.5
  CONDITION: club_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P254:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 13.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: spade_len > 6.5
  CONDITION: club_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P255:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 13.5
  CONDITION: second_longest_len > 4.5
  CONDITION: diamond_hcp <= 3.5
  CONDITION: minor_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P256:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 13.5
  CONDITION: second_longest_len > 4.5
  CONDITION: diamond_hcp <= 3.5
  CONDITION: minor_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P257:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 13.5
  CONDITION: second_longest_len > 4.5
  CONDITION: diamond_hcp > 3.5
  CONDITION: jack_count <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P258:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '1NT'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 13.5
  CONDITION: second_longest_len > 4.5
  CONDITION: diamond_hcp > 3.5
  CONDITION: jack_count > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P259:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points <= 5.5
  CONDITION: club_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P260:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points <= 5.5
  CONDITION: club_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P261:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points > 5.5
  CONDITION: combined_hcp_min <= 13.5
  CONDITION: spade_len <= 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P262:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points > 5.5
  CONDITION: combined_hcp_min <= 13.5
  CONDITION: spade_len > 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P263:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points > 5.5
  CONDITION: combined_hcp_min > 13.5
  CONDITION: quick_tricks <= 2.75
  # distilled from Brill /bid

RULE BD_later_uncont_P264:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points > 5.5
  CONDITION: combined_hcp_min > 13.5
  CONDITION: quick_tricks > 2.75
  # distilled from Brill /bid

RULE BD_later_uncont_P265:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call == '1S'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: losing_trick_count <= 8.5
  # distilled from Brill /bid

RULE BD_later_uncont_P266:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call == '1S'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: losing_trick_count > 8.5
  # distilled from Brill /bid

RULE BD_later_uncont_P267:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call == '1S'
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P268:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call != '1S'
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: s_has_king <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P269:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call != '1S'
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: s_has_king > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P270:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call != '1S'
  CONDITION: combined_hcp_min > 17.5
  CONDITION: hcp <= 13.0
  # distilled from Brill /bid

RULE BD_later_uncont_P271:
  CALL: XX
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_first_call != '1S'
  CONDITION: combined_hcp_min > 17.5
  CONDITION: hcp > 13.0
  # distilled from Brill /bid

RULE BD_later_uncont_P272:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: rule20_total <= 11.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: shape_pattern == '5422'
  # distilled from Brill /bid

RULE BD_later_uncont_P273:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: rule20_total <= 11.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: shape_pattern != '5422'
  # distilled from Brill /bid

RULE BD_later_uncont_P274:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: rule20_total <= 11.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P275:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: rule20_total > 11.5
  CONDITION: auction_len <= 6.5
  CONDITION: total_points <= 9.5
  # distilled from Brill /bid

RULE BD_later_uncont_P276:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: rule20_total > 11.5
  CONDITION: auction_len <= 6.5
  CONDITION: total_points > 9.5
  CONDITION: heart_hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P277:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: rule20_total > 11.5
  CONDITION: auction_len <= 6.5
  CONDITION: total_points > 9.5
  CONDITION: heart_hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P278:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: rule20_total > 11.5
  CONDITION: auction_len > 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P279:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp <= 11.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: hcp <= 9.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P280:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp <= 11.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: hcp <= 9.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P281:
  CALL: 4C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp <= 11.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: hcp > 9.5
  CONDITION: club_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P282:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp <= 11.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: hcp > 9.5
  CONDITION: club_len > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P283:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp <= 11.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp <= 9.5
  # distilled from Brill /bid

RULE BD_later_uncont_P284:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp <= 11.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp > 9.5
  # distilled from Brill /bid

RULE BD_later_uncont_P285:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp <= 11.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: auction_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P286:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp <= 11.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: auction_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P287:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp > 11.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: hcp <= 14.5
  CONDITION: diamond_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P288:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp > 11.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: hcp <= 14.5
  CONDITION: diamond_len > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P289:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp > 11.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: hcp > 14.5
  # distilled from Brill /bid

RULE BD_later_uncont_P290:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid == '1S'
  CONDITION: hcp > 11.5
  CONDITION: shortest_suit_len > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P291:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: is_balanced <= 0.5
  CONDITION: heart_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P292:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: is_balanced <= 0.5
  CONDITION: heart_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P293:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: is_balanced > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P294:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: heart_hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P295:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: heart_hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_uncont_P296:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: hcp > 9.5
  CONDITION: my_first_call == '1C'
  # distilled from Brill /bid

RULE BD_later_uncont_P297:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: hcp > 9.5
  CONDITION: my_first_call != '1C'
  # distilled from Brill /bid

RULE BD_later_uncont_P298:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 17.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: hcp <= 16.5
  # distilled from Brill /bid

RULE BD_later_uncont_P299:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 17.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: hcp > 16.5
  # distilled from Brill /bid

RULE BD_later_uncont_P300:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 17.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: heart_hcp <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P301:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 14.5
  CONDITION: hcp <= 17.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: heart_hcp > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P302:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 14.5
  CONDITION: hcp > 17.5
  CONDITION: diamond_len <= 1.5
  CONDITION: heart_hcp <= 6.0
  # distilled from Brill /bid

RULE BD_later_uncont_P303:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 14.5
  CONDITION: hcp > 17.5
  CONDITION: diamond_len <= 1.5
  CONDITION: heart_hcp > 6.0
  # distilled from Brill /bid

RULE BD_later_uncont_P304:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 14.5
  CONDITION: hcp > 17.5
  CONDITION: diamond_len > 1.5
  CONDITION: shape_pattern == '5431'
  # distilled from Brill /bid

RULE BD_later_uncont_P305:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opening_bid != '1S'
  CONDITION: hcp > 14.5
  CONDITION: hcp > 17.5
  CONDITION: diamond_len > 1.5
  CONDITION: shape_pattern != '5431'
  # distilled from Brill /bid

RULE BD_later_uncont_P306:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points <= 5.5
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P307:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points <= 5.5
  CONDITION: spade_len > 5.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'H'
  # distilled from Brill /bid

RULE BD_later_uncont_P308:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points <= 5.5
  CONDITION: spade_len > 5.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'H'
  # distilled from Brill /bid

RULE BD_later_uncont_P309:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points <= 5.5
  CONDITION: spade_len > 5.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P310:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points > 5.5
  CONDITION: opening_bid == '1H'
  CONDITION: heart_len <= 2.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P311:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points > 5.5
  CONDITION: opening_bid == '1H'
  CONDITION: heart_len <= 2.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P312:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points > 5.5
  CONDITION: opening_bid == '1H'
  CONDITION: heart_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P313:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points > 5.5
  CONDITION: opening_bid != '1H'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P314:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points > 5.5
  CONDITION: opening_bid != '1H'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: spade_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P315:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points > 5.5
  CONDITION: opening_bid != '1H'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: total_points <= 13.5
  # distilled from Brill /bid

RULE BD_later_uncont_P316:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: total_points > 5.5
  CONDITION: opening_bid != '1H'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: total_points > 13.5
  # distilled from Brill /bid

RULE BD_later_uncont_P317:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P318:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P319:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len > 6.5
  CONDITION: hcp <= 10.5
  # distilled from Brill /bid

RULE BD_later_uncont_P320:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest <= 0.5
  CONDITION: spade_len > 6.5
  CONDITION: hcp > 10.5
  # distilled from Brill /bid

RULE BD_later_uncont_P321:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp <= 5.5
  CONDITION: s_is_longest <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P322:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp <= 5.5
  CONDITION: s_is_longest > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P323:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 5.5
  CONDITION: spade_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P324:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call == '1C'
  CONDITION: d_is_longest > 0.5
  CONDITION: hcp > 5.5
  CONDITION: spade_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P325:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call != '1C'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P326:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call != '1C'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: competition_level > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P327:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call != '1C'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain == 'H'
  # distilled from Brill /bid

RULE BD_later_uncont_P328:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call != '1C'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: last_bid_strain != 'H'
  # distilled from Brill /bid

RULE BD_later_uncont_P329:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call != '1C'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: hcp <= 17.5
  CONDITION: partner_first_call == '1C'
  # distilled from Brill /bid

RULE BD_later_uncont_P330:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call != '1C'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: hcp <= 17.5
  CONDITION: partner_first_call != '1C'
  # distilled from Brill /bid

RULE BD_later_uncont_P331:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call != '1C'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: hcp > 17.5
  CONDITION: is_semi_balanced <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P332:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major <= 0.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: partner_last_call != '1C'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: hcp > 17.5
  CONDITION: is_semi_balanced > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P333:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid == '1H'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: support_in_partner_suit <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P334:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid == '1H'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: support_in_partner_suit > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P335:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid == '1H'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: heart_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P336:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid == '1H'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: heart_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P337:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid == '1H'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: total_points <= 12.5
  CONDITION: singleton_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P338:
  CALL: 4C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid == '1H'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: total_points <= 12.5
  CONDITION: singleton_count > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P339:
  CALL: 4C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid == '1H'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: total_points > 12.5
  CONDITION: doubleton_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P340:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid == '1H'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: total_points > 12.5
  CONDITION: doubleton_count > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P341:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len <= 3.5
  CONDITION: hcp <= 16.0
  CONDITION: partner_first_call == '1C'
  # distilled from Brill /bid

RULE BD_later_uncont_P342:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len <= 3.5
  CONDITION: hcp <= 16.0
  CONDITION: partner_first_call != '1C'
  # distilled from Brill /bid

RULE BD_later_uncont_P343:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len <= 3.5
  CONDITION: hcp > 16.0
  # distilled from Brill /bid

RULE BD_later_uncont_P344:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len > 3.5
  CONDITION: total_points <= 14.5
  CONDITION: h_top2_honors <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P345:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len > 3.5
  CONDITION: total_points <= 14.5
  CONDITION: h_top2_honors > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P346:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len > 3.5
  CONDITION: total_points > 14.5
  CONDITION: hcp <= 17.5
  # distilled from Brill /bid

RULE BD_later_uncont_P347:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: opening_bid != '1H'
  CONDITION: third_longest_len > 3.5
  CONDITION: total_points > 14.5
  CONDITION: hcp > 17.5
  # distilled from Brill /bid

RULE BD_later_uncont_P348:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: heart_len <= 5.5
  CONDITION: total_points <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P349:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: heart_len <= 5.5
  CONDITION: total_points > 5.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P350:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: heart_len <= 5.5
  CONDITION: total_points > 5.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P351:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: heart_len > 5.5
  CONDITION: c_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P352:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: heart_len > 5.5
  CONDITION: c_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P353:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp <= 17.5
  # distilled from Brill /bid

RULE BD_later_uncont_P354:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len <= 4.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: hcp > 17.5
  # distilled from Brill /bid

RULE BD_later_uncont_P355:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: partner_last_call == '1D'
  # distilled from Brill /bid

RULE BD_later_uncont_P356:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len <= 4.5
  CONDITION: d_is_longest > 0.5
  CONDITION: partner_last_call != '1D'
  # distilled from Brill /bid

RULE BD_later_uncont_P357:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len > 4.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P358:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len > 4.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P359:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level <= 1.5
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: h_is_best_major > 0.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len > 4.5
  CONDITION: s_is_longest > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P360:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp <= 7.5
  # distilled from Brill /bid

RULE BD_later_uncont_P361:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: my_last_call == '2H'
  # distilled from Brill /bid

RULE BD_later_uncont_P362:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: my_last_call != '2H'
  CONDITION: rule20_total <= 24.5
  CONDITION: rule20_total <= 23.5
  # distilled from Brill /bid

RULE BD_later_uncont_P363:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: my_last_call != '2H'
  CONDITION: rule20_total <= 24.5
  CONDITION: rule20_total > 23.5
  # distilled from Brill /bid

RULE BD_later_uncont_P364:
  CALL: 6D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: my_last_call != '2H'
  CONDITION: rule20_total > 24.5
  CONDITION: hcp <= 16.5
  # distilled from Brill /bid

RULE BD_later_uncont_P365:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: my_last_call != '2H'
  CONDITION: rule20_total > 24.5
  CONDITION: hcp > 16.5
  # distilled from Brill /bid

RULE BD_later_uncont_P366:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: club_len <= 1.5
  CONDITION: major_hcp <= 11.5
  # distilled from Brill /bid

RULE BD_later_uncont_P367:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: club_len <= 1.5
  CONDITION: major_hcp > 11.5
  # distilled from Brill /bid

RULE BD_later_uncont_P368:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: club_len > 1.5
  CONDITION: heart_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P369:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: shortest_suit_len <= 1.5
  CONDITION: club_len > 1.5
  CONDITION: heart_len > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P370:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: hcp <= 15.0
  # distilled from Brill /bid

RULE BD_later_uncont_P371:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: hcp > 15.0
  CONDITION: diamond_hcp <= 5.0
  # distilled from Brill /bid

RULE BD_later_uncont_P372:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level <= 2.5
  CONDITION: shortest_suit_len > 1.5
  CONDITION: hcp > 15.0
  CONDITION: diamond_hcp > 5.0
  # distilled from Brill /bid

RULE BD_later_uncont_P373:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level > 2.5
  CONDITION: hcp <= 7.5
  # distilled from Brill /bid

RULE BD_later_uncont_P374:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level > 2.5
  CONDITION: hcp > 7.5
  CONDITION: hcp <= 9.5
  # distilled from Brill /bid

RULE BD_later_uncont_P375:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level > 2.5
  CONDITION: hcp > 7.5
  CONDITION: hcp > 9.5
  CONDITION: my_last_call == '2H'
  # distilled from Brill /bid

RULE BD_later_uncont_P376:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level > 2.5
  CONDITION: hcp > 7.5
  CONDITION: hcp > 9.5
  CONDITION: my_last_call != '2H'
  # distilled from Brill /bid

RULE BD_later_uncont_P377:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total <= 10.5
  CONDITION: hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P378:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total <= 10.5
  CONDITION: hcp > 2.5
  CONDITION: heart_hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P379:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total <= 10.5
  CONDITION: hcp > 2.5
  CONDITION: heart_hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P380:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total > 10.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P381:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total > 10.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P382:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total > 10.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp <= 12.5
  # distilled from Brill /bid

RULE BD_later_uncont_P383:
  CALL: 6NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: rule20_total > 10.5
  CONDITION: heart_len > 3.5
  CONDITION: hcp > 12.5
  # distilled from Brill /bid

RULE BD_later_uncont_P384:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: hcp <= 13.5
  # distilled from Brill /bid

RULE BD_later_uncont_P385:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: hcp > 13.5
  # distilled from Brill /bid

RULE BD_later_uncont_P386:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: our_fit_shown <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P387:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: our_fit_shown > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P388:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: hcp <= 17.5
  CONDITION: our_fit_shown <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P389:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: hcp <= 17.5
  CONDITION: our_fit_shown > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P390:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: hcp > 17.5
  CONDITION: quick_tricks <= 4.75
  # distilled from Brill /bid

RULE BD_later_uncont_P391:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: opening_bid != '2NT'
  CONDITION: combined_hcp_max > 35.5
  CONDITION: hcp > 17.5
  CONDITION: quick_tricks > 4.75
  # distilled from Brill /bid

RULE BD_later_uncont_P392:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len <= 4.5
  CONDITION: rule20_total <= 25.5
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P393:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len <= 4.5
  CONDITION: rule20_total <= 25.5
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P394:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len <= 4.5
  CONDITION: rule20_total > 25.5
  CONDITION: keycard_count_agreed <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P395:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len <= 4.5
  CONDITION: rule20_total > 25.5
  CONDITION: keycard_count_agreed > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P396:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P397:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid == '2NT'
  CONDITION: spade_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P398:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '2NT'
  CONDITION: combined_hcp_max <= 36.5
  # distilled from Brill /bid

RULE BD_later_uncont_P399:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: spade_len > 4.5
  CONDITION: opening_bid != '2NT'
  CONDITION: combined_hcp_max > 36.5
  # distilled from Brill /bid

RULE BD_later_uncont_P400:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid == '1H'
  CONDITION: spade_len <= 1.5
  CONDITION: competition_level <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P401:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid == '1H'
  CONDITION: spade_len <= 1.5
  CONDITION: competition_level > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P402:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid == '1H'
  CONDITION: spade_len > 1.5
  CONDITION: hcp <= 16.5
  # distilled from Brill /bid

RULE BD_later_uncont_P403:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid == '1H'
  CONDITION: spade_len > 1.5
  CONDITION: hcp > 16.5
  # distilled from Brill /bid

RULE BD_later_uncont_P404:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1H'
  CONDITION: my_last_call == '2H'
  CONDITION: hcp <= 8.5
  # distilled from Brill /bid

RULE BD_later_uncont_P405:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1H'
  CONDITION: my_last_call == '2H'
  CONDITION: hcp > 8.5
  # distilled from Brill /bid

RULE BD_later_uncont_P406:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1H'
  CONDITION: my_last_call != '2H'
  CONDITION: opening_bid == '1D'
  # distilled from Brill /bid

RULE BD_later_uncont_P407:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level <= 3.5
  CONDITION: opening_bid != '1S'
  CONDITION: longest_suit_len > 4.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1H'
  CONDITION: my_last_call != '2H'
  CONDITION: opening_bid != '1D'
  # distilled from Brill /bid

RULE BD_later_uncont_P408:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid == '1NT'
  CONDITION: combined_hcp_min <= 21.5
  CONDITION: my_last_call == '2H'
  CONDITION: heart_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P409:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid == '1NT'
  CONDITION: combined_hcp_min <= 21.5
  CONDITION: my_last_call == '2H'
  CONDITION: heart_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P410:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid == '1NT'
  CONDITION: combined_hcp_min <= 21.5
  CONDITION: my_last_call != '2H'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp <= 7.5
  # distilled from Brill /bid

RULE BD_later_uncont_P411:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid == '1NT'
  CONDITION: combined_hcp_min <= 21.5
  CONDITION: my_last_call != '2H'
  CONDITION: spade_len <= 2.5
  CONDITION: hcp > 7.5
  # distilled from Brill /bid

RULE BD_later_uncont_P412:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid == '1NT'
  CONDITION: combined_hcp_min <= 21.5
  CONDITION: my_last_call != '2H'
  CONDITION: spade_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P413:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid == '1NT'
  CONDITION: combined_hcp_min > 21.5
  # distilled from Brill /bid

RULE BD_later_uncont_P414:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: spade_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: my_last_call == '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P415:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: spade_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: my_last_call != '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P416:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: spade_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: c_is_best_minor <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P417:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: spade_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: c_is_best_minor > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P418:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: spade_len > 5.5
  CONDITION: major_hcp <= 9.5
  CONDITION: my_last_call == '2S'
  # distilled from Brill /bid

RULE BD_later_uncont_P419:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: spade_len > 5.5
  CONDITION: major_hcp <= 9.5
  CONDITION: my_last_call != '2S'
  # distilled from Brill /bid

RULE BD_later_uncont_P420:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: spade_len > 5.5
  CONDITION: major_hcp > 9.5
  CONDITION: heart_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P421:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 13.5
  CONDITION: spade_len > 5.5
  CONDITION: major_hcp > 9.5
  CONDITION: heart_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P422:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: spade_len <= 5.5
  CONDITION: partner_hcp_min <= 21.0
  CONDITION: my_last_call == '2H'
  # distilled from Brill /bid

RULE BD_later_uncont_P423:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: spade_len <= 5.5
  CONDITION: partner_hcp_min <= 21.0
  CONDITION: my_last_call != '2H'
  # distilled from Brill /bid

RULE BD_later_uncont_P424:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: spade_len <= 5.5
  CONDITION: partner_hcp_min > 21.0
  CONDITION: d_is_best_minor <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P425:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: spade_len <= 5.5
  CONDITION: partner_hcp_min > 21.0
  CONDITION: d_is_best_minor > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P426:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp <= 15.5
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 13.5
  CONDITION: spade_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P427:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call == '2S'
  CONDITION: spade_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P428:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call == '2S'
  CONDITION: spade_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P429:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call != '2S'
  CONDITION: heart_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P430:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call != '2S'
  CONDITION: heart_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P431:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len <= 3.5
  CONDITION: club_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P432:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len <= 3.5
  CONDITION: club_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P433:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: hcp <= 17.0
  # distilled from Brill /bid

RULE BD_later_uncont_P434:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: heart_len <= 3.5
  CONDITION: diamond_len > 3.5
  CONDITION: hcp > 17.0
  # distilled from Brill /bid

RULE BD_later_uncont_P435:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: heart_len > 3.5
  CONDITION: diamond_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P436:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: heart_len > 3.5
  CONDITION: diamond_len > 2.5
  CONDITION: second_longest_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P437:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min <= 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: heart_len > 3.5
  CONDITION: diamond_len > 2.5
  CONDITION: second_longest_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P438:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: opening_bid == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P439:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: my_side_bid_count <= 4.5
  CONDITION: d_is_best_minor <= 0.5
  CONDITION: hcp <= 17.5
  # distilled from Brill /bid

RULE BD_later_uncont_P440:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: my_side_bid_count <= 4.5
  CONDITION: d_is_best_minor <= 0.5
  CONDITION: hcp > 17.5
  # distilled from Brill /bid

RULE BD_later_uncont_P441:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: my_side_bid_count <= 4.5
  CONDITION: d_is_best_minor > 0.5
  CONDITION: my_last_call == '2H'
  # distilled from Brill /bid

RULE BD_later_uncont_P442:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: my_side_bid_count <= 4.5
  CONDITION: d_is_best_minor > 0.5
  CONDITION: my_last_call != '2H'
  # distilled from Brill /bid

RULE BD_later_uncont_P443:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: my_side_bid_count > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: rule20_total <= 25.5
  # distilled from Brill /bid

RULE BD_later_uncont_P444:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: my_side_bid_count > 4.5
  CONDITION: hcp <= 19.5
  CONDITION: rule20_total > 25.5
  # distilled from Brill /bid

RULE BD_later_uncont_P445:
  CALL: 5NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: my_side_bid_count > 4.5
  CONDITION: hcp > 19.5
  CONDITION: support_in_partner_suit <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P446:
  CALL: 6NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: competition_level > 3.5
  CONDITION: hcp > 15.5
  CONDITION: partner_hcp_min > 10.0
  CONDITION: opening_bid != '1NT'
  CONDITION: my_side_bid_count > 4.5
  CONDITION: hcp > 19.5
  CONDITION: support_in_partner_suit > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P447:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid == '2S'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: jack_count <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P448:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid == '2S'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: jack_count > 2.5
  CONDITION: spade_hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P449:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid == '2S'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: jack_count > 2.5
  CONDITION: spade_hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P450:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid == '2S'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: is_equal_non_vuln <= 0.5
  CONDITION: is_unfavorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P451:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid == '2S'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: is_equal_non_vuln <= 0.5
  CONDITION: is_unfavorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P452:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid == '2S'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: is_equal_non_vuln > 0.5
  CONDITION: spade_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P453:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid == '2S'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: is_equal_non_vuln > 0.5
  CONDITION: spade_len > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P454:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid != '2S'
  CONDITION: diamond_len <= 5.5
  CONDITION: my_first_call == '2H'
  # distilled from Brill /bid

RULE BD_later_uncont_P455:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid != '2S'
  CONDITION: diamond_len <= 5.5
  CONDITION: my_first_call != '2H'
  CONDITION: opening_bid == '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P456:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid != '2S'
  CONDITION: diamond_len <= 5.5
  CONDITION: my_first_call != '2H'
  CONDITION: opening_bid != '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P457:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid != '2S'
  CONDITION: diamond_len > 5.5
  CONDITION: hcp <= 9.5
  CONDITION: opening_bid == '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P458:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid != '2S'
  CONDITION: diamond_len > 5.5
  CONDITION: hcp <= 9.5
  CONDITION: opening_bid != '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P459:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid != '2S'
  CONDITION: diamond_len > 5.5
  CONDITION: hcp > 9.5
  CONDITION: d_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P460:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opening_bid != '2S'
  CONDITION: diamond_len > 5.5
  CONDITION: hcp > 9.5
  CONDITION: d_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P461:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call == '1NT'
  CONDITION: competition_level <= 3.5
  CONDITION: hcp <= 9.5
  CONDITION: opening_bid == '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P462:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call == '1NT'
  CONDITION: competition_level <= 3.5
  CONDITION: hcp <= 9.5
  CONDITION: opening_bid != '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P463:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call == '1NT'
  CONDITION: competition_level <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid == '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P464:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call == '1NT'
  CONDITION: competition_level <= 3.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid != '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P465:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call == '1NT'
  CONDITION: competition_level > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P466:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call != '1NT'
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: controls <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P467:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call != '1NT'
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: controls > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P468:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call != '1NT'
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: partner_opened <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P469:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call != '1NT'
  CONDITION: combined_hcp_max <= 26.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: partner_opened > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P470:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call != '1NT'
  CONDITION: combined_hcp_max > 26.5
  CONDITION: competition_level <= 3.5
  CONDITION: heart_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P471:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call != '1NT'
  CONDITION: combined_hcp_max > 26.5
  CONDITION: competition_level <= 3.5
  CONDITION: heart_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P472:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call != '1NT'
  CONDITION: combined_hcp_max > 26.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_first_call == '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P473:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_last_call != '1NT'
  CONDITION: combined_hcp_max > 26.5
  CONDITION: competition_level > 3.5
  CONDITION: partner_first_call != '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P474:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: opening_bid == '1NT'
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern == '6421'
  # distilled from Brill /bid

RULE BD_later_uncont_P475:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: opening_bid == '1NT'
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern != '6421'
  # distilled from Brill /bid

RULE BD_later_uncont_P476:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: opening_bid == '1NT'
  CONDITION: heart_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P477:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len <= 5.5
  CONDITION: total_points <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P478:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len <= 5.5
  CONDITION: total_points > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P479:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len > 5.5
  CONDITION: agreed_trump == 'S'
  # distilled from Brill /bid

RULE BD_later_uncont_P480:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len > 5.5
  CONDITION: agreed_trump != 'S'
  # distilled from Brill /bid

RULE BD_later_uncont_P481:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: partner_hcp_min <= 18.5
  # distilled from Brill /bid

RULE BD_later_uncont_P482:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len <= 3.5
  CONDITION: partner_hcp_min > 18.5
  # distilled from Brill /bid

RULE BD_later_uncont_P483:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P484:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: spade_len <= 4.5
  CONDITION: spade_len > 3.5
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P485:
  CALL: 4C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: spade_len > 4.5
  CONDITION: my_last_call == '2D'
  CONDITION: minor_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P486:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: spade_len > 4.5
  CONDITION: my_last_call == '2D'
  CONDITION: minor_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P487:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: spade_len > 4.5
  CONDITION: my_last_call != '2D'
  # distilled from Brill /bid

RULE BD_later_uncont_P488:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call == '2C'
  CONDITION: spade_len <= 3.5
  CONDITION: hcp <= 15.5
  # distilled from Brill /bid

RULE BD_later_uncont_P489:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call == '2C'
  CONDITION: spade_len <= 3.5
  CONDITION: hcp > 15.5
  # distilled from Brill /bid

RULE BD_later_uncont_P490:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call == '2C'
  CONDITION: spade_len > 3.5
  CONDITION: total_points <= 15.5
  # distilled from Brill /bid

RULE BD_later_uncont_P491:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call == '2C'
  CONDITION: spade_len > 3.5
  CONDITION: total_points > 15.5
  # distilled from Brill /bid

RULE BD_later_uncont_P492:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call != '2C'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp <= 15.5
  # distilled from Brill /bid

RULE BD_later_uncont_P493:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call != '2C'
  CONDITION: spade_len <= 4.5
  CONDITION: hcp > 15.5
  # distilled from Brill /bid

RULE BD_later_uncont_P494:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call != '2C'
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 14.5
  # distilled from Brill /bid

RULE BD_later_uncont_P495:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call != '2C'
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 14.5
  # distilled from Brill /bid

RULE BD_later_uncont_P496:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len <= 7.5
  CONDITION: total_points <= 15.5
  CONDITION: opening_bid == '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P497:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len <= 7.5
  CONDITION: total_points <= 15.5
  CONDITION: opening_bid != '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P498:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len <= 7.5
  CONDITION: total_points > 15.5
  CONDITION: combined_hcp_max <= 31.5
  # distilled from Brill /bid

RULE BD_later_uncont_P499:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len <= 7.5
  CONDITION: total_points > 15.5
  CONDITION: combined_hcp_max > 31.5
  # distilled from Brill /bid

RULE BD_later_uncont_P500:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len > 7.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_balanced <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P501:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len > 7.5
  CONDITION: spade_len <= 3.5
  CONDITION: is_balanced > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P502:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len > 7.5
  CONDITION: spade_len > 3.5
  CONDITION: my_side_bid_count <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P503:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid != '1NT'
  CONDITION: auction_len > 7.5
  CONDITION: spade_len > 3.5
  CONDITION: my_side_bid_count > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P504:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call == '1NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: spade_len <= 3.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P505:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call == '1NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: spade_len <= 3.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P506:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call == '1NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp <= 15.5
  # distilled from Brill /bid

RULE BD_later_uncont_P507:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call == '1NT'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: spade_len > 3.5
  CONDITION: hcp > 15.5
  # distilled from Brill /bid

RULE BD_later_uncont_P508:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call == '1NT'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: combined_hcp_max <= 30.5
  CONDITION: club_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P509:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call == '1NT'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: combined_hcp_max <= 30.5
  CONDITION: club_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P510:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call == '1NT'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: combined_hcp_max > 30.5
  CONDITION: spade_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P511:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call == '1NT'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: combined_hcp_max > 30.5
  CONDITION: spade_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P512:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call != '1NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: opening_bid == '2H'
  CONDITION: hcp <= 12.5
  # distilled from Brill /bid

RULE BD_later_uncont_P513:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call != '1NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: opening_bid == '2H'
  CONDITION: hcp > 12.5
  # distilled from Brill /bid

RULE BD_later_uncont_P514:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call != '1NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: opening_bid != '2H'
  CONDITION: competition_level <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P515:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call != '1NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: opening_bid != '2H'
  CONDITION: competition_level > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P516:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min <= 22.5
  # distilled from Brill /bid

RULE BD_later_uncont_P517:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: combined_hcp_min > 22.5
  # distilled from Brill /bid

RULE BD_later_uncont_P518:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P519:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_first_call != '1NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 9.5
  CONDITION: opening_bid != '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P520:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: hcp <= 9.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P521:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: hcp <= 9.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P522:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: hcp <= 9.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: my_side_bid_count <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P523:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: hcp <= 9.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: my_side_bid_count > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P524:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: hcp > 9.5
  CONDITION: my_last_call == '1NT'
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P525:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: hcp > 9.5
  CONDITION: my_last_call == '1NT'
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P526:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: hcp > 9.5
  CONDITION: my_last_call != '1NT'
  CONDITION: is_balanced <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P527:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: hcp > 9.5
  CONDITION: my_last_call != '1NT'
  CONDITION: is_balanced > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P528:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: competition_level <= 3.5
  CONDITION: my_first_call == '1NT'
  CONDITION: hcp <= 14.0
  # distilled from Brill /bid

RULE BD_later_uncont_P529:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: competition_level <= 3.5
  CONDITION: my_first_call == '1NT'
  CONDITION: hcp > 14.0
  # distilled from Brill /bid

RULE BD_later_uncont_P530:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: competition_level <= 3.5
  CONDITION: my_first_call != '1NT'
  CONDITION: longest_suit_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P531:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: competition_level <= 3.5
  CONDITION: my_first_call != '1NT'
  CONDITION: longest_suit_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P532:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: competition_level > 3.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: partner_first_call == '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P533:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: competition_level > 3.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: partner_first_call != '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P534:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: competition_level > 3.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: my_last_call == '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P535:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min <= 18.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: competition_level > 3.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: my_last_call != '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P536:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len <= 3.5
  CONDITION: my_last_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P537:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len <= 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp <= 7.5
  CONDITION: auction_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P538:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len <= 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp <= 7.5
  CONDITION: auction_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P539:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len <= 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp > 7.5
  CONDITION: shortest_suit_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P540:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len <= 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp > 7.5
  CONDITION: shortest_suit_len > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P541:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len > 3.5
  CONDITION: my_last_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P542:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len > 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp <= 7.5
  CONDITION: auction_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P543:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len > 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp <= 7.5
  CONDITION: auction_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P544:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len > 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P545:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len > 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp > 7.5
  CONDITION: is_balanced > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P546:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len > 3.5
  CONDITION: my_last_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P547:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len > 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp <= 7.5
  CONDITION: auction_len <= 5.5
  CONDITION: controls <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P548:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len > 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp <= 7.5
  CONDITION: auction_len <= 5.5
  CONDITION: controls > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P549:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len > 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp <= 7.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P550:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len > 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp <= 7.5
  CONDITION: auction_len > 5.5
  CONDITION: hcp > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P551:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len > 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  CONDITION: auction_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P552:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len > 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp > 7.5
  CONDITION: is_balanced <= 0.5
  CONDITION: auction_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P553:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len > 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp > 7.5
  CONDITION: is_balanced > 0.5
  CONDITION: auction_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P554:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: partner_hcp_min > 18.5
  CONDITION: heart_len > 3.5
  CONDITION: my_last_call != '1NT'
  CONDITION: hcp > 7.5
  CONDITION: is_balanced > 0.5
  CONDITION: auction_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P555:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: hcp <= 14.5
  # distilled from Brill /bid

RULE BD_later_uncont_P556:
  CALL: 4C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: hcp > 14.5
  CONDITION: heart_len <= 2.5
  CONDITION: losing_trick_count <= 2.5
  CONDITION: major_hcp <= 9.0
  # distilled from Brill /bid

RULE BD_later_uncont_P557:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: hcp > 14.5
  CONDITION: heart_len <= 2.5
  CONDITION: losing_trick_count <= 2.5
  CONDITION: major_hcp > 9.0
  # distilled from Brill /bid

RULE BD_later_uncont_P558:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: hcp > 14.5
  CONDITION: heart_len <= 2.5
  CONDITION: losing_trick_count > 2.5
  CONDITION: second_longest_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P559:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: hcp > 14.5
  CONDITION: heart_len <= 2.5
  CONDITION: losing_trick_count > 2.5
  CONDITION: second_longest_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P560:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: hcp > 14.5
  CONDITION: heart_len > 2.5
  CONDITION: my_last_call == '2NT'
  CONDITION: king_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P561:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: hcp > 14.5
  CONDITION: heart_len > 2.5
  CONDITION: my_last_call == '2NT'
  CONDITION: king_count > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P562:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: hcp > 14.5
  CONDITION: heart_len > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P563:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: hcp > 14.5
  CONDITION: heart_len > 2.5
  CONDITION: my_last_call != '2NT'
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P564:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid == '2H'
  CONDITION: heart_len <= 1.5
  CONDITION: hcp <= 18.0
  # distilled from Brill /bid

RULE BD_later_uncont_P565:
  CALL: 6NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid == '2H'
  CONDITION: heart_len <= 1.5
  CONDITION: hcp > 18.0
  # distilled from Brill /bid

RULE BD_later_uncont_P566:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid == '2H'
  CONDITION: heart_len > 1.5
  CONDITION: heart_len <= 2.5
  CONDITION: hcp <= 20.0
  # distilled from Brill /bid

RULE BD_later_uncont_P567:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid == '2H'
  CONDITION: heart_len > 1.5
  CONDITION: heart_len <= 2.5
  CONDITION: hcp > 20.0
  # distilled from Brill /bid

RULE BD_later_uncont_P568:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid == '2H'
  CONDITION: heart_len > 1.5
  CONDITION: heart_len > 2.5
  CONDITION: hcp <= 15.0
  # distilled from Brill /bid

RULE BD_later_uncont_P569:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid == '2H'
  CONDITION: heart_len > 1.5
  CONDITION: heart_len > 2.5
  CONDITION: hcp > 15.0
  # distilled from Brill /bid

RULE BD_later_uncont_P570:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: my_last_call == '3D'
  CONDITION: losing_trick_count <= 2.5
  CONDITION: hcp <= 21.0
  # distilled from Brill /bid

RULE BD_later_uncont_P571:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: my_last_call == '3D'
  CONDITION: losing_trick_count <= 2.5
  CONDITION: hcp > 21.0
  # distilled from Brill /bid

RULE BD_later_uncont_P572:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: my_last_call == '3D'
  CONDITION: losing_trick_count > 2.5
  CONDITION: king_count <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P573:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: my_last_call == '3D'
  CONDITION: losing_trick_count > 2.5
  CONDITION: king_count > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P574:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: my_last_call != '3D'
  CONDITION: hcp <= 19.5
  CONDITION: spade_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P575:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: my_last_call != '3D'
  CONDITION: hcp <= 19.5
  CONDITION: spade_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P576:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: my_last_call != '3D'
  CONDITION: hcp > 19.5
  CONDITION: major_hcp <= 13.5
  # distilled from Brill /bid

RULE BD_later_uncont_P577:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: opening_bid != '2H'
  CONDITION: my_last_call != '3D'
  CONDITION: hcp > 19.5
  CONDITION: major_hcp > 13.5
  # distilled from Brill /bid

RULE BD_later_uncont_P578:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call == '1H'
  CONDITION: auction_len <= 5.5
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp <= 16.5
  # distilled from Brill /bid

RULE BD_later_uncont_P579:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call == '1H'
  CONDITION: auction_len <= 5.5
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp > 16.5
  # distilled from Brill /bid

RULE BD_later_uncont_P580:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call == '1H'
  CONDITION: auction_len <= 5.5
  CONDITION: shape_pattern != '5332'
  CONDITION: rule20_total <= 24.5
  # distilled from Brill /bid

RULE BD_later_uncont_P581:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call == '1H'
  CONDITION: auction_len <= 5.5
  CONDITION: shape_pattern != '5332'
  CONDITION: rule20_total > 24.5
  CONDITION: h_has_king <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P582:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call == '1H'
  CONDITION: auction_len <= 5.5
  CONDITION: shape_pattern != '5332'
  CONDITION: rule20_total > 24.5
  CONDITION: h_has_king > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P583:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call == '1H'
  CONDITION: auction_len > 5.5
  CONDITION: diamond_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P584:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call == '1H'
  CONDITION: auction_len > 5.5
  CONDITION: diamond_hcp > 5.5
  CONDITION: major_hcp <= 5.0
  # distilled from Brill /bid

RULE BD_later_uncont_P585:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call == '1H'
  CONDITION: auction_len > 5.5
  CONDITION: diamond_hcp > 5.5
  CONDITION: major_hcp > 5.0
  # distilled from Brill /bid

RULE BD_later_uncont_P586:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid == '1S'
  CONDITION: competition_level <= 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: shape_pattern == '5332'
  # distilled from Brill /bid

RULE BD_later_uncont_P587:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid == '1S'
  CONDITION: competition_level <= 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: shape_pattern != '5332'
  # distilled from Brill /bid

RULE BD_later_uncont_P588:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid == '1S'
  CONDITION: competition_level <= 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: major_hcp <= 7.5
  # distilled from Brill /bid

RULE BD_later_uncont_P589:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid == '1S'
  CONDITION: competition_level <= 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: major_hcp > 7.5
  # distilled from Brill /bid

RULE BD_later_uncont_P590:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid == '1S'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: longest_suit_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P591:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid == '1S'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max <= 35.5
  CONDITION: longest_suit_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P592:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid == '1S'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max > 35.5
  CONDITION: partner_hcp_min <= 13.0
  # distilled from Brill /bid

RULE BD_later_uncont_P593:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid == '1S'
  CONDITION: competition_level > 2.5
  CONDITION: combined_hcp_max > 35.5
  CONDITION: partner_hcp_min > 13.0
  # distilled from Brill /bid

RULE BD_later_uncont_P594:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid != '1S'
  CONDITION: my_last_call == '2NT'
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P595:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid != '1S'
  CONDITION: my_last_call == '2NT'
  CONDITION: hcp <= 7.5
  CONDITION: support_in_partner_suit > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P596:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid != '1S'
  CONDITION: my_last_call == '2NT'
  CONDITION: hcp > 7.5
  CONDITION: opening_bid == '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P597:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid != '1S'
  CONDITION: my_last_call == '2NT'
  CONDITION: hcp > 7.5
  CONDITION: opening_bid != '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P598:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid != '1S'
  CONDITION: my_last_call != '2NT'
  CONDITION: my_first_call == '1NT'
  CONDITION: my_last_call == '2H'
  # distilled from Brill /bid

RULE BD_later_uncont_P599:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid != '1S'
  CONDITION: my_last_call != '2NT'
  CONDITION: my_first_call == '1NT'
  CONDITION: my_last_call != '2H'
  # distilled from Brill /bid

RULE BD_later_uncont_P600:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid != '1S'
  CONDITION: my_last_call != '2NT'
  CONDITION: my_first_call != '1NT'
  CONDITION: combined_hcp_min <= 30.5
  # distilled from Brill /bid

RULE BD_later_uncont_P601:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: my_last_call != '1H'
  CONDITION: opening_bid != '1S'
  CONDITION: my_last_call != '2NT'
  CONDITION: my_first_call != '1NT'
  CONDITION: combined_hcp_min > 30.5
  # distilled from Brill /bid

RULE BD_later_uncont_P602:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: opening_bid == '2S'
  # distilled from Brill /bid

RULE BD_later_uncont_P603:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: opening_bid != '2S'
  CONDITION: partner_first_call == '2S'
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P604:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: opening_bid != '2S'
  CONDITION: partner_first_call == '2S'
  CONDITION: spade_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P605:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: opening_bid != '2S'
  CONDITION: partner_first_call != '2S'
  CONDITION: spade_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P606:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump == 'S'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: opening_bid != '2S'
  CONDITION: partner_first_call != '2S'
  CONDITION: spade_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P607:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: partner_first_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P608:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: partner_first_call != '1NT'
  CONDITION: rule20_total <= 25.5
  # distilled from Brill /bid

RULE BD_later_uncont_P609:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: partner_first_call != '1NT'
  CONDITION: rule20_total > 25.5
  # distilled from Brill /bid

RULE BD_later_uncont_P610:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: my_side_bid_count <= 3.5
  CONDITION: combined_hcp_max <= 35.5
  # distilled from Brill /bid

RULE BD_later_uncont_P611:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: my_side_bid_count <= 3.5
  CONDITION: combined_hcp_max > 35.5
  # distilled from Brill /bid

RULE BD_later_uncont_P612:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: my_side_bid_count > 3.5
  CONDITION: my_side_bid_count <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P613:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump == 'S'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: my_side_bid_count > 3.5
  CONDITION: my_side_bid_count > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P614:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len <= 1.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: longest_suit_len <= 6.5
  CONDITION: partner_first_call == '2S'
  # distilled from Brill /bid

RULE BD_later_uncont_P615:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len <= 1.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: longest_suit_len <= 6.5
  CONDITION: partner_first_call != '2S'
  # distilled from Brill /bid

RULE BD_later_uncont_P616:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len <= 1.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: longest_suit_len > 6.5
  CONDITION: my_last_call == '3D'
  # distilled from Brill /bid

RULE BD_later_uncont_P617:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len <= 1.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: longest_suit_len > 6.5
  CONDITION: my_last_call != '3D'
  # distilled from Brill /bid

RULE BD_later_uncont_P618:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len <= 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: combined_hcp_max <= 24.5
  CONDITION: auction_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P619:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len <= 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: combined_hcp_max <= 24.5
  CONDITION: auction_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P620:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len <= 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: combined_hcp_max > 24.5
  CONDITION: d_top2_honors <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P621:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len <= 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: combined_hcp_max > 24.5
  CONDITION: d_top2_honors > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P622:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len > 1.5
  CONDITION: hcp <= 10.5
  CONDITION: my_last_call == '3C'
  CONDITION: spade_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P623:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len > 1.5
  CONDITION: hcp <= 10.5
  CONDITION: my_last_call == '3C'
  CONDITION: spade_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P624:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len > 1.5
  CONDITION: hcp <= 10.5
  CONDITION: my_last_call != '3C'
  CONDITION: combined_hcp_max <= 28.5
  # distilled from Brill /bid

RULE BD_later_uncont_P625:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len > 1.5
  CONDITION: hcp <= 10.5
  CONDITION: my_last_call != '3C'
  CONDITION: combined_hcp_max > 28.5
  # distilled from Brill /bid

RULE BD_later_uncont_P626:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len > 1.5
  CONDITION: hcp > 10.5
  CONDITION: opening_bid == '3S'
  CONDITION: hcp <= 21.5
  # distilled from Brill /bid

RULE BD_later_uncont_P627:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len > 1.5
  CONDITION: hcp > 10.5
  CONDITION: opening_bid == '3S'
  CONDITION: hcp > 21.5
  # distilled from Brill /bid

RULE BD_later_uncont_P628:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len > 1.5
  CONDITION: hcp > 10.5
  CONDITION: opening_bid != '3S'
  CONDITION: partner_first_call == '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P629:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3S'
  CONDITION: agreed_trump != 'S'
  CONDITION: spade_len > 1.5
  CONDITION: hcp > 10.5
  CONDITION: opening_bid != '3S'
  CONDITION: partner_first_call != '1S'
  # distilled from Brill /bid

RULE BD_later_uncont_P630:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'
  CONDITION: rule20_total <= 23.5
  CONDITION: opening_bid == '2H'
  # distilled from Brill /bid

RULE BD_later_uncont_P631:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'
  CONDITION: rule20_total <= 23.5
  CONDITION: opening_bid != '2H'
  CONDITION: opening_bid == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P632:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'
  CONDITION: rule20_total <= 23.5
  CONDITION: opening_bid != '2H'
  CONDITION: opening_bid != '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P633:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'
  CONDITION: rule20_total > 23.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 38.5
  # distilled from Brill /bid

RULE BD_later_uncont_P634:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'
  CONDITION: rule20_total > 23.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 38.5
  # distilled from Brill /bid

RULE BD_later_uncont_P635:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'
  CONDITION: rule20_total > 23.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid == '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P636:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump == 'H'
  CONDITION: rule20_total > 23.5
  CONDITION: heart_len > 4.5
  CONDITION: opening_bid != '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P637:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'
  CONDITION: hcp <= 15.5
  CONDITION: combined_hcp_max <= 24.5
  CONDITION: heart_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P638:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'
  CONDITION: hcp <= 15.5
  CONDITION: combined_hcp_max <= 24.5
  CONDITION: heart_len > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P639:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'
  CONDITION: hcp <= 15.5
  CONDITION: combined_hcp_max > 24.5
  CONDITION: partner_first_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P640:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'
  CONDITION: hcp <= 15.5
  CONDITION: combined_hcp_max > 24.5
  CONDITION: partner_first_call != '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P641:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'
  CONDITION: hcp > 15.5
  CONDITION: opening_bid == '2NT'
  CONDITION: spade_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P642:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'
  CONDITION: hcp > 15.5
  CONDITION: opening_bid == '2NT'
  CONDITION: spade_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P643:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'
  CONDITION: hcp > 15.5
  CONDITION: opening_bid != '2NT'
  CONDITION: my_first_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P644:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call == '3H'
  CONDITION: agreed_trump != 'H'
  CONDITION: hcp > 15.5
  CONDITION: opening_bid != '2NT'
  CONDITION: my_first_call != '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P645:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: opening_bid == '3D'
  CONDITION: rule20_total <= 19.5
  # distilled from Brill /bid

RULE BD_later_uncont_P646:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: opening_bid == '3D'
  CONDITION: rule20_total > 19.5
  # distilled from Brill /bid

RULE BD_later_uncont_P647:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: opening_bid != '3D'
  CONDITION: opening_bid == '3C'
  # distilled from Brill /bid

RULE BD_later_uncont_P648:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: opening_bid != '3D'
  CONDITION: opening_bid != '3C'
  # distilled from Brill /bid

RULE BD_later_uncont_P649:
  CALL: 4C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: my_side_bid_count <= 3.5
  CONDITION: support_in_partner_suit <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P650:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: my_side_bid_count <= 3.5
  CONDITION: support_in_partner_suit > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P651:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: my_side_bid_count > 3.5
  CONDITION: agreed_trump_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P652:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: my_side_bid_count > 3.5
  CONDITION: agreed_trump_len > 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P653:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp > 14.5
  CONDITION: my_last_call == '2NT'
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P654:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp > 14.5
  CONDITION: my_last_call == '2NT'
  CONDITION: heart_len <= 3.5
  CONDITION: spade_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P655:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp > 14.5
  CONDITION: my_last_call == '2NT'
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain == 'C'
  # distilled from Brill /bid

RULE BD_later_uncont_P656:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp > 14.5
  CONDITION: my_last_call == '2NT'
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain != 'C'
  # distilled from Brill /bid

RULE BD_later_uncont_P657:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp > 14.5
  CONDITION: my_last_call != '2NT'
  CONDITION: my_last_call == '1NT'
  CONDITION: last_bid_strain == 'C'
  # distilled from Brill /bid

RULE BD_later_uncont_P658:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp > 14.5
  CONDITION: my_last_call != '2NT'
  CONDITION: my_last_call == '1NT'
  CONDITION: last_bid_strain != 'C'
  # distilled from Brill /bid

RULE BD_later_uncont_P659:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp > 14.5
  CONDITION: my_last_call != '2NT'
  CONDITION: my_last_call != '1NT'
  CONDITION: last_bid_strain == 'C'
  # distilled from Brill /bid

RULE BD_later_uncont_P660:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3S'
  CONDITION: partner_last_call != '3H'
  CONDITION: hcp > 14.5
  CONDITION: my_last_call != '2NT'
  CONDITION: my_last_call != '1NT'
  CONDITION: last_bid_strain != 'C'
  # distilled from Brill /bid

RULE BD_later_uncont_P661:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call == '2NT'
  CONDITION: minor_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P662:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call == '2NT'
  CONDITION: minor_hcp > 5.5
  CONDITION: combined_hcp_min <= 37.5
  # distilled from Brill /bid

RULE BD_later_uncont_P663:
  CALL: 6NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call == '2NT'
  CONDITION: minor_hcp > 5.5
  CONDITION: combined_hcp_min > 37.5
  # distilled from Brill /bid

RULE BD_later_uncont_P664:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call != '2NT'
  CONDITION: controls <= 1.5
  CONDITION: minor_hcp <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P665:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call != '2NT'
  CONDITION: controls <= 1.5
  CONDITION: minor_hcp > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P666:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call != '2NT'
  CONDITION: controls > 1.5
  CONDITION: shape_pattern == '5431'
  # distilled from Brill /bid

RULE BD_later_uncont_P667:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call != '2NT'
  CONDITION: controls > 1.5
  CONDITION: shape_pattern != '5431'
  # distilled from Brill /bid

RULE BD_later_uncont_P668:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: support_in_partner_suit <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P669:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P670:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: hcp > 3.5
  CONDITION: major_hcp <= 5.0
  # distilled from Brill /bid

RULE BD_later_uncont_P671:
  CALL: 6D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed <= 0.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: hcp > 3.5
  CONDITION: major_hcp > 5.0
  # distilled from Brill /bid

RULE BD_later_uncont_P672:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call == '2NT'
  CONDITION: is_balanced <= 0.5
  CONDITION: jack_count <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P673:
  CALL: 5NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call == '2NT'
  CONDITION: is_balanced <= 0.5
  CONDITION: jack_count > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P674:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call == '2NT'
  CONDITION: is_balanced > 0.5
  CONDITION: total_points <= 10.5
  # distilled from Brill /bid

RULE BD_later_uncont_P675:
  CALL: 6NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call == '2NT'
  CONDITION: is_balanced > 0.5
  CONDITION: total_points > 10.5
  # distilled from Brill /bid

RULE BD_later_uncont_P676:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call != '2NT'
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: heart_hcp <= 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P677:
  CALL: 5NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call != '2NT'
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: heart_hcp > 1.5
  # distilled from Brill /bid

RULE BD_later_uncont_P678:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call != '2NT'
  CONDITION: shortest_suit_len > 0.5
  CONDITION: combined_hcp_min <= 42.5
  # distilled from Brill /bid

RULE BD_later_uncont_P679:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call != '2NT'
  CONDITION: shortest_suit_len > 0.5
  CONDITION: combined_hcp_min > 42.5
  # distilled from Brill /bid

RULE BD_later_uncont_P680:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: hcp <= 11.5
  # distilled from Brill /bid

RULE BD_later_uncont_P681:
  CALL: 6D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: hcp > 11.5
  CONDITION: diamond_hcp <= 1.0
  # distilled from Brill /bid

RULE BD_later_uncont_P682:
  CALL: 6H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: hcp > 11.5
  CONDITION: diamond_hcp > 1.0
  # distilled from Brill /bid

RULE BD_later_uncont_P683:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: shortest_suit_len > 0.5
  CONDITION: my_first_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P684:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed <= 1.5
  CONDITION: keycard_count_agreed > 0.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: shortest_suit_len > 0.5
  CONDITION: my_first_call != '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P685:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: combined_hcp_min <= 41.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: total_points <= 20.5
  # distilled from Brill /bid

RULE BD_later_uncont_P686:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: combined_hcp_min <= 41.5
  CONDITION: losing_trick_count <= 5.5
  CONDITION: total_points > 20.5
  # distilled from Brill /bid

RULE BD_later_uncont_P687:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: combined_hcp_min <= 41.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: partner_first_call == '1D'
  # distilled from Brill /bid

RULE BD_later_uncont_P688:
  CALL: 5S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: combined_hcp_min <= 41.5
  CONDITION: losing_trick_count > 5.5
  CONDITION: partner_first_call != '1D'
  # distilled from Brill /bid

RULE BD_later_uncont_P689:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: combined_hcp_min > 41.5
  CONDITION: hcp <= 15.5
  CONDITION: major_hcp <= 11.5
  # distilled from Brill /bid

RULE BD_later_uncont_P690:
  CALL: 5NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: combined_hcp_min > 41.5
  CONDITION: hcp <= 15.5
  CONDITION: major_hcp > 11.5
  # distilled from Brill /bid

RULE BD_later_uncont_P691:
  CALL: 6C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: combined_hcp_min > 41.5
  CONDITION: hcp > 15.5
  CONDITION: is_balanced <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P692:
  CALL: 6NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: combined_hcp_min > 41.5
  CONDITION: hcp > 15.5
  CONDITION: is_balanced > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P693:
  CALL: 5NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: has_trump_queen <= 0.5
  CONDITION: shortest_suit_len <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P694:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: has_trump_queen <= 0.5
  CONDITION: shortest_suit_len > 0.5
  CONDITION: my_last_call == '2NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P695:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: has_trump_queen <= 0.5
  CONDITION: shortest_suit_len > 0.5
  CONDITION: my_last_call != '2NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P696:
  CALL: 5NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: has_trump_queen > 0.5
  CONDITION: shortest_suit_len <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P697:
  CALL: 6C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: has_trump_queen > 0.5
  CONDITION: shortest_suit_len > 0.5
  CONDITION: my_last_call == '3NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P698:
  CALL: 5S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: has_trump_queen > 0.5
  CONDITION: shortest_suit_len > 0.5
  CONDITION: my_last_call != '3NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P699:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed <= 3.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call == '3NT'
  CONDITION: second_longest_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P700:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed <= 3.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call == '3NT'
  CONDITION: second_longest_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P701:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed <= 3.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call != '3NT'
  CONDITION: my_last_call == '2NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P702:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed <= 3.5
  CONDITION: our_fit_shown <= 0.5
  CONDITION: my_last_call != '3NT'
  CONDITION: my_last_call != '2NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P703:
  CALL: 6C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed <= 3.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: hcp <= 15.0
  # distilled from Brill /bid

RULE BD_later_uncont_P704:
  CALL: 6D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed <= 3.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: hcp > 15.0
  # distilled from Brill /bid

RULE BD_later_uncont_P705:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed <= 3.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: shortest_suit_len > 0.5
  CONDITION: shape_pattern == '5332'
  # distilled from Brill /bid

RULE BD_later_uncont_P706:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed <= 3.5
  CONDITION: our_fit_shown > 0.5
  CONDITION: shortest_suit_len > 0.5
  CONDITION: shape_pattern != '5332'
  # distilled from Brill /bid

RULE BD_later_uncont_P707:
  CALL: 6C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed > 3.5
  CONDITION: my_last_call == '3NT'
  CONDITION: heart_len <= 3.5
  CONDITION: hcp <= 24.0
  # distilled from Brill /bid

RULE BD_later_uncont_P708:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed > 3.5
  CONDITION: my_last_call == '3NT'
  CONDITION: heart_len <= 3.5
  CONDITION: hcp > 24.0
  # distilled from Brill /bid

RULE BD_later_uncont_P709:
  CALL: 6NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed > 3.5
  CONDITION: my_last_call == '3NT'
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P710:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed > 3.5
  CONDITION: my_last_call != '3NT'
  CONDITION: spade_len <= 4.5
  CONDITION: d_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P711:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed > 3.5
  CONDITION: my_last_call != '3NT'
  CONDITION: spade_len <= 4.5
  CONDITION: d_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P712:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed > 3.5
  CONDITION: my_last_call != '3NT'
  CONDITION: spade_len > 4.5
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P713:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: keycard_count_agreed > 1.5
  CONDITION: keycard_count_agreed > 2.5
  CONDITION: keycard_count_agreed > 3.5
  CONDITION: my_last_call != '3NT'
  CONDITION: spade_len > 4.5
  CONDITION: spade_len > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P714:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P715:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call != '1NT'
  CONDITION: diamond_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_uncont_P716:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call != '1NT'
  CONDITION: diamond_len > 2.5
  CONDITION: h_is_best_major <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P717:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: opening_bid == '1NT'
  CONDITION: my_last_call != '1NT'
  CONDITION: diamond_len > 2.5
  CONDITION: h_is_best_major > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P718:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: opening_bid != '1NT'
  CONDITION: my_last_call == '1S'
  CONDITION: hcp <= 17.0
  # distilled from Brill /bid

RULE BD_later_uncont_P719:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: opening_bid != '1NT'
  CONDITION: my_last_call == '1S'
  CONDITION: hcp > 17.0
  CONDITION: major_hcp <= 8.0
  # distilled from Brill /bid

RULE BD_later_uncont_P720:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: opening_bid != '1NT'
  CONDITION: my_last_call == '1S'
  CONDITION: hcp > 17.0
  CONDITION: major_hcp > 8.0
  # distilled from Brill /bid

RULE BD_later_uncont_P721:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: opening_bid != '1NT'
  CONDITION: my_last_call != '1S'
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: my_last_call == '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P722:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: opening_bid != '1NT'
  CONDITION: my_last_call != '1S'
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: my_last_call != '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P723:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: opening_bid != '1NT'
  CONDITION: my_last_call != '1S'
  CONDITION: combined_hcp_min > 22.5
  CONDITION: agreed_trump_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P724:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call == '4D'
  CONDITION: opening_bid != '1NT'
  CONDITION: my_last_call != '1S'
  CONDITION: combined_hcp_min > 22.5
  CONDITION: agreed_trump_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P725:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'
  CONDITION: my_first_call == '1S'
  CONDITION: heart_len <= 0.5
  CONDITION: major_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P726:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'
  CONDITION: my_first_call == '1S'
  CONDITION: heart_len <= 0.5
  CONDITION: major_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P727:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'
  CONDITION: my_first_call == '1S'
  CONDITION: heart_len > 0.5
  CONDITION: auction_len <= 8.5
  # distilled from Brill /bid

RULE BD_later_uncont_P728:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'
  CONDITION: my_first_call == '1S'
  CONDITION: heart_len > 0.5
  CONDITION: auction_len > 8.5
  # distilled from Brill /bid

RULE BD_later_uncont_P729:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'
  CONDITION: my_first_call != '1S'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: my_last_call == '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P730:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'
  CONDITION: my_first_call != '1S'
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: my_last_call != '1H'
  # distilled from Brill /bid

RULE BD_later_uncont_P731:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'
  CONDITION: my_first_call != '1S'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: club_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P732:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call == '4C'
  CONDITION: my_first_call != '1S'
  CONDITION: combined_hcp_min > 20.5
  CONDITION: club_len > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P733:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: my_last_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P734:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: my_last_call == '2NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P735:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: my_last_call != '1NT'
  CONDITION: my_last_call != '2NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P736:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: combined_hcp_min <= 26.5
  CONDITION: rule20_total <= 21.5
  # distilled from Brill /bid

RULE BD_later_uncont_P737:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: combined_hcp_min <= 26.5
  CONDITION: rule20_total > 21.5
  # distilled from Brill /bid

RULE BD_later_uncont_P738:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: combined_hcp_min > 26.5
  CONDITION: my_side_bid_count <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P739:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: partner_last_call != '4D'
  CONDITION: partner_last_call != '4C'
  CONDITION: my_side_bid_count > 2.5
  CONDITION: combined_hcp_min > 26.5
  CONDITION: my_side_bid_count > 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P740:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: h_is_longest <= 0.5
  CONDITION: s_has_queen <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P741:
  CALL: 6S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: h_is_longest <= 0.5
  CONDITION: s_has_queen > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P742:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: h_is_longest > 0.5
  CONDITION: h_has_queen <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P743:
  CALL: 6H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: h_is_longest > 0.5
  CONDITION: h_has_queen > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P744:
  CALL: 6H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: agreed_trump == 'H'
  # distilled from Brill /bid

RULE BD_later_uncont_P745:
  CALL: 6S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: agreed_trump != 'H'
  # distilled from Brill /bid

RULE BD_later_uncont_P746:
  CALL: 6H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: heart_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P747:
  CALL: 6H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level <= 5.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: heart_len > 4.5
  # distilled from Brill /bid

RULE BD_later_uncont_P748:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level > 5.5
  CONDITION: last_bid_strain == 'NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P749:
  CALL: 6NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: partner_first_call == '1D'
  # distilled from Brill /bid

RULE BD_later_uncont_P750:
  CALL: 6NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: partner_first_call != '1D'
  # distilled from Brill /bid

RULE BD_later_uncont_P751:
  CALL: 6S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: partner_hcp_min <= 13.0
  # distilled from Brill /bid

RULE BD_later_uncont_P752:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: last_bid_level > 5.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: partner_hcp_min > 13.0
  # distilled from Brill /bid

RULE BD_later_uncont_P753:
  CALL: 6NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: my_last_call == '2NT'
  CONDITION: spade_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_uncont_P754:
  CALL: 6NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: my_last_call == '2NT'
  CONDITION: spade_len > 3.5
  CONDITION: minor_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P755:
  CALL: 7NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: my_last_call == '2NT'
  CONDITION: spade_len > 3.5
  CONDITION: minor_hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_uncont_P756:
  CALL: 6NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: my_last_call != '2NT'
  CONDITION: my_last_call == '3NT'
  # distilled from Brill /bid

RULE BD_later_uncont_P757:
  CALL: 6H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: my_last_call != '2NT'
  CONDITION: my_last_call != '3NT'
  CONDITION: c_has_king <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P758:
  CALL: 6C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call == '5NT'
  CONDITION: my_last_call != '2NT'
  CONDITION: my_last_call != '3NT'
  CONDITION: c_has_king > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P759:
  CALL: 6H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: partner_last_call == '5H'
  CONDITION: s_has_queen <= 0.5
  CONDITION: agreed_trump == 'H'
  # distilled from Brill /bid

RULE BD_later_uncont_P760:
  CALL: 5S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: partner_last_call == '5H'
  CONDITION: s_has_queen <= 0.5
  CONDITION: agreed_trump != 'H'
  # distilled from Brill /bid

RULE BD_later_uncont_P761:
  CALL: 6D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: partner_last_call == '5H'
  CONDITION: s_has_queen > 0.5
  CONDITION: c_top2_honors <= 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P762:
  CALL: 6C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: partner_last_call == '5H'
  CONDITION: s_has_queen > 0.5
  CONDITION: c_top2_honors > 0.5
  # distilled from Brill /bid

RULE BD_later_uncont_P763:
  CALL: 6H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: partner_last_call != '5H'
  CONDITION: my_last_call == '5C'
  CONDITION: partner_last_call == '5D'
  # distilled from Brill /bid

RULE BD_later_uncont_P764:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: partner_last_call != '5H'
  CONDITION: my_last_call == '5C'
  CONDITION: partner_last_call != '5D'
  # distilled from Brill /bid

RULE BD_later_uncont_P765:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: partner_last_call != '5H'
  CONDITION: my_last_call != '5C'
  CONDITION: partner_last_call == '6C'
  # distilled from Brill /bid

RULE BD_later_uncont_P766:
  CALL: 6H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == False
  CONDITION: last_bid_level > 1.5
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: partner_last_call != '5NT'
  CONDITION: partner_last_call != '5H'
  CONDITION: my_last_call != '5C'
  CONDITION: partner_last_call != '6C'
  # distilled from Brill /bid

RULE BD_later_cont_P0:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: heart_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P1:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: heart_len > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P2:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: last_bid_strain == 'C'
  # distilled from Brill /bid

RULE BD_later_cont_P3:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len <= 3.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: last_bid_strain != 'C'
  # distilled from Brill /bid

RULE BD_later_cont_P4:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: minor_hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P5:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: minor_hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P6:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'H'
  # distilled from Brill /bid

RULE BD_later_cont_P7:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest <= 0.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'H'
  # distilled from Brill /bid

RULE BD_later_cont_P8:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest > 0.5
  CONDITION: total_points <= 5.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: hcp <= 1.0
  # distilled from Brill /bid

RULE BD_later_cont_P9:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest > 0.5
  CONDITION: total_points <= 5.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: hcp > 1.0
  # distilled from Brill /bid

RULE BD_later_cont_P10:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest > 0.5
  CONDITION: total_points <= 5.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: major_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P11:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest > 0.5
  CONDITION: total_points <= 5.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: major_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P12:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest > 0.5
  CONDITION: total_points > 5.5
  CONDITION: heart_len <= 3.5
  CONDITION: losing_trick_count <= 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P13:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest > 0.5
  CONDITION: total_points > 5.5
  CONDITION: heart_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P14:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest > 0.5
  CONDITION: total_points > 5.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain == 'S'
  # distilled from Brill /bid

RULE BD_later_cont_P15:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_is_longest > 0.5
  CONDITION: total_points > 5.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain != 'S'
  # distilled from Brill /bid

RULE BD_later_cont_P16:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid == '1D'
  CONDITION: club_len <= 3.5
  CONDITION: heart_hcp <= 5.0
  CONDITION: h_is_longest <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P17:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid == '1D'
  CONDITION: club_len <= 3.5
  CONDITION: heart_hcp <= 5.0
  CONDITION: h_is_longest > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P18:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid == '1D'
  CONDITION: club_len <= 3.5
  CONDITION: heart_hcp > 5.0
  CONDITION: hcp <= 8.5
  # distilled from Brill /bid

RULE BD_later_cont_P19:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid == '1D'
  CONDITION: club_len <= 3.5
  CONDITION: heart_hcp > 5.0
  CONDITION: hcp > 8.5
  # distilled from Brill /bid

RULE BD_later_cont_P20:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid == '1D'
  CONDITION: club_len > 3.5
  CONDITION: minor_hcp <= 4.5
  CONDITION: heart_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P21:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid == '1D'
  CONDITION: club_len > 3.5
  CONDITION: minor_hcp <= 4.5
  CONDITION: heart_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P22:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid == '1D'
  CONDITION: club_len > 3.5
  CONDITION: minor_hcp > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P23:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid != '1D'
  CONDITION: diamond_len <= 3.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: second_longest_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P24:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid != '1D'
  CONDITION: diamond_len <= 3.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: second_longest_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P25:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid != '1D'
  CONDITION: diamond_len <= 3.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: heart_hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P26:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid != '1D'
  CONDITION: diamond_len <= 3.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: heart_hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P27:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid != '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: hcp <= 5.5
  CONDITION: auction_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P28:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid != '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: hcp <= 5.5
  CONDITION: auction_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P29:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid != '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: hcp > 5.5
  CONDITION: opp_bid_count <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P30:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: opening_bid != '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: hcp > 5.5
  CONDITION: opp_bid_count > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P31:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid == '1S'
  CONDITION: heart_hcp <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P32:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid == '1S'
  CONDITION: heart_hcp > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P33:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp <= 7.5
  CONDITION: opening_bid != '1S'
  # distilled from Brill /bid

RULE BD_later_cont_P34:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp > 7.5
  CONDITION: hcp <= 8.5
  # distilled from Brill /bid

RULE BD_later_cont_P35:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: hcp > 7.5
  CONDITION: hcp > 8.5
  # distilled from Brill /bid

RULE BD_later_cont_P36:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid == '1D'
  CONDITION: heart_hcp <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P37:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid == '1D'
  CONDITION: heart_hcp > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P38:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid != '1D'
  CONDITION: diamond_len <= 3.5
  CONDITION: hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P39:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid != '1D'
  CONDITION: diamond_len <= 3.5
  CONDITION: hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P40:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid != '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P41:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: opening_bid != '1D'
  CONDITION: diamond_len > 3.5
  CONDITION: hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P42:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: rule20_total <= 14.5
  CONDITION: diamond_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P43:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: rule20_total <= 14.5
  CONDITION: diamond_len > 3.5
  CONDITION: shortest_suit_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P44:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: rule20_total <= 14.5
  CONDITION: diamond_len > 3.5
  CONDITION: shortest_suit_len > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P45:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: rule20_total > 14.5
  CONDITION: h_has_queen <= 0.5
  CONDITION: s_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P46:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: rule20_total > 14.5
  CONDITION: h_has_queen <= 0.5
  CONDITION: s_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P47:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: rule20_total > 14.5
  CONDITION: h_has_queen > 0.5
  CONDITION: major_hcp <= 4.0
  # distilled from Brill /bid

RULE BD_later_cont_P48:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: rule20_total > 14.5
  CONDITION: h_has_queen > 0.5
  CONDITION: major_hcp > 4.0
  # distilled from Brill /bid

RULE BD_later_cont_P49:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_len <= 3.5
  CONDITION: major_hcp <= 4.5
  CONDITION: opp_bid_count <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P50:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_len <= 3.5
  CONDITION: major_hcp <= 4.5
  CONDITION: opp_bid_count > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P51:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_len <= 3.5
  CONDITION: major_hcp > 4.5
  CONDITION: passes_since_last_bid <= 2.0
  # distilled from Brill /bid

RULE BD_later_cont_P52:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_len <= 3.5
  CONDITION: major_hcp > 4.5
  CONDITION: passes_since_last_bid > 2.0
  # distilled from Brill /bid

RULE BD_later_cont_P53:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: auction_len <= 6.0
  # distilled from Brill /bid

RULE BD_later_cont_P54:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: auction_len > 6.0
  # distilled from Brill /bid

RULE BD_later_cont_P55:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: rule20_total <= 16.5
  # distilled from Brill /bid

RULE BD_later_cont_P56:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: rule20_total > 16.5
  # distilled from Brill /bid

RULE BD_later_cont_P57:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len <= 5.5
  CONDITION: shape_pattern == '5521'
  CONDITION: is_unfavorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P58:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len <= 5.5
  CONDITION: shape_pattern == '5521'
  CONDITION: is_unfavorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P59:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len <= 5.5
  CONDITION: shape_pattern != '5521'
  CONDITION: last_bid_strain == 'C'
  # distilled from Brill /bid

RULE BD_later_cont_P60:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len <= 5.5
  CONDITION: shape_pattern != '5521'
  CONDITION: last_bid_strain != 'C'
  # distilled from Brill /bid

RULE BD_later_cont_P61:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 5.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P62:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 5.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: losing_trick_count > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P63:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 5.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: diamond_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P64:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len <= 5.5
  CONDITION: club_len > 5.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: diamond_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P65:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len > 5.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: hcp <= 7.5
  CONDITION: d_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P66:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len > 5.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: hcp <= 7.5
  CONDITION: d_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P67:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len > 5.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: hcp > 7.5
  CONDITION: total_points <= 11.5
  # distilled from Brill /bid

RULE BD_later_cont_P68:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len > 5.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: hcp > 7.5
  CONDITION: total_points > 11.5
  # distilled from Brill /bid

RULE BD_later_cont_P69:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len > 5.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: diamond_len <= 6.5
  CONDITION: opp_suit_stoppers <= 0.75
  # distilled from Brill /bid

RULE BD_later_cont_P70:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len > 5.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: diamond_len <= 6.5
  CONDITION: opp_suit_stoppers > 0.75
  # distilled from Brill /bid

RULE BD_later_cont_P71:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len > 5.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: diamond_len > 6.5
  CONDITION: is_unfavorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P72:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: diamond_len > 5.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: diamond_len > 6.5
  CONDITION: is_unfavorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P73:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len <= 4.5
  CONDITION: rule20_total <= 16.5
  CONDITION: auction_len <= 11.5
  # distilled from Brill /bid

RULE BD_later_cont_P74:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len <= 4.5
  CONDITION: rule20_total <= 16.5
  CONDITION: auction_len > 11.5
  CONDITION: diamond_hcp <= 1.0
  # distilled from Brill /bid

RULE BD_later_cont_P75:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len <= 4.5
  CONDITION: rule20_total <= 16.5
  CONDITION: auction_len > 11.5
  CONDITION: diamond_hcp > 1.0
  # distilled from Brill /bid

RULE BD_later_cont_P76:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len <= 4.5
  CONDITION: rule20_total > 16.5
  CONDITION: third_longest_len <= 3.5
  CONDITION: total_points <= 10.5
  # distilled from Brill /bid

RULE BD_later_cont_P77:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len <= 4.5
  CONDITION: rule20_total > 16.5
  CONDITION: third_longest_len <= 3.5
  CONDITION: total_points > 10.5
  # distilled from Brill /bid

RULE BD_later_cont_P78:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len <= 4.5
  CONDITION: rule20_total > 16.5
  CONDITION: third_longest_len > 3.5
  CONDITION: c_has_jack <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P79:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len <= 4.5
  CONDITION: rule20_total > 16.5
  CONDITION: third_longest_len > 3.5
  CONDITION: c_has_jack > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P80:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len > 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: hcp <= 7.5
  CONDITION: diamond_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P81:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len > 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: hcp <= 7.5
  CONDITION: diamond_len > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P82:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len > 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: hcp > 7.5
  CONDITION: d_stopper <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P83:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len > 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: hcp > 7.5
  CONDITION: d_stopper > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P84:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len > 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: total_points <= 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P85:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len > 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: total_points > 9.5
  CONDITION: king_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P86:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: diamond_len > 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: total_points > 9.5
  CONDITION: king_count > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P87:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp <= 7.5
  CONDITION: club_hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P88:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp <= 7.5
  CONDITION: club_hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P89:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: heart_hcp <= 2.5
  CONDITION: h_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P90:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: heart_hcp <= 2.5
  CONDITION: h_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P91:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: heart_hcp > 2.5
  CONDITION: rule20_total <= 18.5
  # distilled from Brill /bid

RULE BD_later_cont_P92:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: heart_hcp > 2.5
  CONDITION: rule20_total > 18.5
  # distilled from Brill /bid

RULE BD_later_cont_P93:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: last_bid_strain == 'C'
  CONDITION: h_stopper <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P94:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: last_bid_strain == 'C'
  CONDITION: h_stopper > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P95:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: last_bid_strain != 'C'
  CONDITION: second_longest_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P96:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: last_bid_strain != 'C'
  CONDITION: second_longest_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P97:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: opp_suit_stoppers <= 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P98:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len <= 6.5
  CONDITION: opp_suit_stoppers > 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P99:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len > 6.5
  CONDITION: losing_trick_count <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P100:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len > 6.5
  CONDITION: losing_trick_count > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P101:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid == '1S'
  # distilled from Brill /bid

RULE BD_later_cont_P102:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid != '1S'
  CONDITION: club_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P103:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid != '1S'
  CONDITION: club_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P104:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: hcp <= 5.5
  CONDITION: shape_pattern == '8221'
  # distilled from Brill /bid

RULE BD_later_cont_P105:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: hcp <= 5.5
  CONDITION: shape_pattern != '8221'
  CONDITION: s_has_king <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P106:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: hcp <= 5.5
  CONDITION: shape_pattern != '8221'
  CONDITION: s_has_king > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P107:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: hcp > 5.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: h_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P108:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: hcp > 5.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: h_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P109:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: hcp > 5.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: last_bid_strain == 'C'
  # distilled from Brill /bid

RULE BD_later_cont_P110:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: hcp > 5.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: last_bid_strain != 'C'
  # distilled from Brill /bid

RULE BD_later_cont_P111:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain == 'S'
  CONDITION: jack_count <= 0.5
  CONDITION: c_is_best_minor <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P112:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain == 'S'
  CONDITION: jack_count <= 0.5
  CONDITION: c_is_best_minor > 0.5
  CONDITION: major_hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P113:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain == 'S'
  CONDITION: jack_count <= 0.5
  CONDITION: c_is_best_minor > 0.5
  CONDITION: major_hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P114:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain == 'S'
  CONDITION: jack_count > 0.5
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P115:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain == 'S'
  CONDITION: jack_count > 0.5
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P116:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points <= 7.5
  CONDITION: competition_level <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: last_bid_strain == 'NT'
  # distilled from Brill /bid

RULE BD_later_cont_P117:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points <= 7.5
  CONDITION: competition_level <= 3.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: last_bid_strain != 'NT'
  # distilled from Brill /bid

RULE BD_later_cont_P118:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points <= 7.5
  CONDITION: competition_level <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: total_points <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P119:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points <= 7.5
  CONDITION: competition_level <= 3.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: total_points > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P120:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points <= 7.5
  CONDITION: competition_level > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P121:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain == 'D'
  # distilled from Brill /bid

RULE BD_later_cont_P122:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: heart_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P123:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 7.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: heart_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P124:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: auction_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P125:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: auction_len > 4.5
  CONDITION: major_hcp <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P126:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call == 'X'
  CONDITION: last_bid_strain != 'S'
  CONDITION: total_points > 7.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: auction_len > 4.5
  CONDITION: major_hcp > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P127:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len <= 5.5
  CONDITION: rule20_total <= 16.5
  CONDITION: heart_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P128:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len <= 5.5
  CONDITION: rule20_total <= 16.5
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P129:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len <= 5.5
  CONDITION: rule20_total <= 16.5
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P130:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len <= 5.5
  CONDITION: rule20_total > 16.5
  CONDITION: my_seat == 'N'
  CONDITION: major_hcp <= 4.5
  CONDITION: major_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P131:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len <= 5.5
  CONDITION: rule20_total > 16.5
  CONDITION: my_seat == 'N'
  CONDITION: major_hcp <= 4.5
  CONDITION: major_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P132:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len <= 5.5
  CONDITION: rule20_total > 16.5
  CONDITION: my_seat == 'N'
  CONDITION: major_hcp > 4.5
  CONDITION: major_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P133:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len <= 5.5
  CONDITION: rule20_total > 16.5
  CONDITION: my_seat == 'N'
  CONDITION: major_hcp > 4.5
  CONDITION: major_hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P134:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len <= 5.5
  CONDITION: rule20_total > 16.5
  CONDITION: my_seat != 'N'
  CONDITION: total_points <= 10.5
  CONDITION: is_favorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P135:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len <= 5.5
  CONDITION: rule20_total > 16.5
  CONDITION: my_seat != 'N'
  CONDITION: total_points <= 10.5
  CONDITION: is_favorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P136:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len <= 5.5
  CONDITION: rule20_total > 16.5
  CONDITION: my_seat != 'N'
  CONDITION: total_points > 10.5
  CONDITION: opp_suit_stoppers <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P137:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len <= 5.5
  CONDITION: rule20_total > 16.5
  CONDITION: my_seat != 'N'
  CONDITION: total_points > 10.5
  CONDITION: opp_suit_stoppers > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P138:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len > 5.5
  CONDITION: hcp <= 5.5
  CONDITION: spade_len <= 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P139:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len > 5.5
  CONDITION: hcp <= 5.5
  CONDITION: spade_len > 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P140:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: spade_hcp <= 5.5
  CONDITION: is_favorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P141:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: spade_hcp <= 5.5
  CONDITION: is_favorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P142:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: spade_hcp > 5.5
  CONDITION: last_bid_strain == 'D'
  # distilled from Brill /bid

RULE BD_later_cont_P143:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: spade_hcp > 5.5
  CONDITION: last_bid_strain != 'D'
  # distilled from Brill /bid

RULE BD_later_cont_P144:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: opp_suit_stoppers <= 1.5
  CONDITION: spade_hcp <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P145:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: opp_suit_stoppers <= 1.5
  CONDITION: spade_hcp > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P146:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: opp_suit_stoppers > 1.5
  CONDITION: auction_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P147:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 7.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_len > 5.5
  CONDITION: hcp > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: opp_suit_stoppers > 1.5
  CONDITION: auction_len > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P148:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == 'X'
  CONDITION: minor_hcp <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P149:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == 'X'
  CONDITION: minor_hcp > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P150:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern == '7321'
  CONDITION: major_hcp <= 7.0
  # distilled from Brill /bid

RULE BD_later_cont_P151:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern == '7321'
  CONDITION: major_hcp > 7.0
  # distilled from Brill /bid

RULE BD_later_cont_P152:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern != '7321'
  CONDITION: club_hcp <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P153:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern != '7321'
  CONDITION: club_hcp > 4.5
  CONDITION: spade_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P154:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len <= 4.5
  CONDITION: shape_pattern != '7321'
  CONDITION: club_hcp > 4.5
  CONDITION: spade_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P155:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp <= 8.5
  CONDITION: d_has_queen <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P156:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp <= 8.5
  CONDITION: d_has_queen > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P157:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != 'X'
  CONDITION: heart_len > 4.5
  CONDITION: major_hcp > 8.5
  # distilled from Brill /bid

RULE BD_later_cont_P158:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len <= 5.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: spade_hcp <= 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P159:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len <= 5.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: spade_hcp > 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P160:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len <= 5.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: s_stopper <= 0.5
  CONDITION: opening_bid == '1H'
  CONDITION: d_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P161:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len <= 5.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: s_stopper <= 0.5
  CONDITION: opening_bid == '1H'
  CONDITION: d_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P162:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len <= 5.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: s_stopper <= 0.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P163:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len <= 5.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: s_stopper <= 0.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P164:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len <= 5.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: s_stopper > 0.5
  CONDITION: heart_len <= 4.5
  CONDITION: partner_last_call == 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P165:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len <= 5.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: s_stopper > 0.5
  CONDITION: heart_len <= 4.5
  CONDITION: partner_last_call != 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P166:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len <= 5.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: s_stopper > 0.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'D'
  # distilled from Brill /bid

RULE BD_later_cont_P167:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len <= 5.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: s_stopper > 0.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'D'
  # distilled from Brill /bid

RULE BD_later_cont_P168:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: my_seat == 'S'
  # distilled from Brill /bid

RULE BD_later_cont_P169:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: my_seat != 'S'
  CONDITION: vuln_pressure == 'equal'
  # distilled from Brill /bid

RULE BD_later_cont_P170:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: my_seat != 'S'
  CONDITION: vuln_pressure != 'equal'
  # distilled from Brill /bid

RULE BD_later_cont_P171:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len > 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_hcp <= 4.0
  # distilled from Brill /bid

RULE BD_later_cont_P172:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len > 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_hcp > 4.0
  # distilled from Brill /bid

RULE BD_later_cont_P173:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len > 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: diamond_hcp <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P174:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count <= 6.5
  CONDITION: second_longest_len > 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: diamond_hcp > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P175:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: last_bid_strain == 'S'
  # distilled from Brill /bid

RULE BD_later_cont_P176:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: s_stopper <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P177:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: s_stopper > 0.5
  CONDITION: competition_level <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P178:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min <= 9.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 7.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: longest_suit_len > 5.5
  CONDITION: losing_trick_count > 6.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: s_stopper > 0.5
  CONDITION: competition_level > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P179:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: opp_suit_stoppers <= 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P180:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len <= 3.5
  CONDITION: opp_suit_stoppers > 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P181:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain == 'H'
  # distilled from Brill /bid

RULE BD_later_cont_P182:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len <= 3.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_strain != 'H'
  # distilled from Brill /bid

RULE BD_later_cont_P183:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P184:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P185:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opp_suit_stoppers <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P186:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call == 'X'
  CONDITION: spade_len > 3.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: opp_suit_stoppers > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P187:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call != 'X'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: total_points <= 11.5
  CONDITION: my_seat == 'N'
  # distilled from Brill /bid

RULE BD_later_cont_P188:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call != 'X'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: total_points <= 11.5
  CONDITION: my_seat != 'N'
  # distilled from Brill /bid

RULE BD_later_cont_P189:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call != 'X'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: total_points > 11.5
  CONDITION: opp_suit_stoppers <= 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P190:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call != 'X'
  CONDITION: longest_suit_len <= 4.5
  CONDITION: total_points > 11.5
  CONDITION: opp_suit_stoppers > 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P191:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call != 'X'
  CONDITION: longest_suit_len > 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: diamond_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P192:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call != 'X'
  CONDITION: longest_suit_len > 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: diamond_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P193:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call != 'X'
  CONDITION: longest_suit_len > 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: club_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P194:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: partner_last_call != 'X'
  CONDITION: longest_suit_len > 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: club_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P195:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P196:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: rule20_total <= 20.5
  CONDITION: is_favorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P197:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: rule20_total > 20.5
  CONDITION: club_len <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P198:
  CALL: 1D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: rule20_total > 20.5
  CONDITION: club_len > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P199:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P200:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P201:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp <= 11.5
  # distilled from Brill /bid

RULE BD_later_cont_P202:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len <= 4.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: opening_bid != '1NT'
  CONDITION: hcp > 11.5
  # distilled from Brill /bid

RULE BD_later_cont_P203:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len > 4.5
  CONDITION: diamond_len <= 4.5
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total <= 20.5
  # distilled from Brill /bid

RULE BD_later_cont_P204:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len > 4.5
  CONDITION: diamond_len <= 4.5
  CONDITION: hcp <= 11.5
  CONDITION: rule20_total > 20.5
  # distilled from Brill /bid

RULE BD_later_cont_P205:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len > 4.5
  CONDITION: diamond_len <= 4.5
  CONDITION: hcp > 11.5
  CONDITION: partner_last_call == 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P206:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len > 4.5
  CONDITION: diamond_len <= 4.5
  CONDITION: hcp > 11.5
  CONDITION: partner_last_call != 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P207:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len > 4.5
  CONDITION: diamond_len > 4.5
  CONDITION: major_hcp <= 2.5
  CONDITION: club_hcp <= 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P208:
  CALL: 4C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len > 4.5
  CONDITION: diamond_len > 4.5
  CONDITION: major_hcp <= 2.5
  CONDITION: club_hcp > 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P209:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len > 4.5
  CONDITION: diamond_len > 4.5
  CONDITION: major_hcp > 2.5
  CONDITION: spade_hcp <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P210:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: club_len > 4.5
  CONDITION: diamond_len > 4.5
  CONDITION: major_hcp > 2.5
  CONDITION: spade_hcp > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P211:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max <= 24.5
  CONDITION: longest_suit_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P212:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max <= 24.5
  CONDITION: longest_suit_len > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P213:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max > 24.5
  CONDITION: partner_first_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_cont_P214:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: combined_hcp_max > 24.5
  CONDITION: partner_first_call != '1NT'
  # distilled from Brill /bid

RULE BD_later_cont_P215:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P216:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level <= 2.5
  CONDITION: hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P217:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P218:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: competition_level > 2.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P219:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: is_semi_balanced <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P220:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: is_semi_balanced > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P221:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_side_bid_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P222:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: competition_level <= 2.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: my_side_bid_count > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P223:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: competition_level > 2.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: last_bid_strain == 'NT'
  # distilled from Brill /bid

RULE BD_later_cont_P224:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: competition_level > 2.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: last_bid_strain != 'NT'
  # distilled from Brill /bid

RULE BD_later_cont_P225:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: competition_level > 2.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: diamond_len <= 5.0
  # distilled from Brill /bid

RULE BD_later_cont_P226:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: competition_level > 2.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: diamond_len > 5.0
  # distilled from Brill /bid

RULE BD_later_cont_P227:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max <= 27.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: partner_first_call == '1H'
  CONDITION: last_bid_strain == 'H'
  # distilled from Brill /bid

RULE BD_later_cont_P228:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max <= 27.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: partner_first_call == '1H'
  CONDITION: last_bid_strain != 'H'
  # distilled from Brill /bid

RULE BD_later_cont_P229:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max <= 27.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: partner_first_call != '1H'
  CONDITION: opening_bid == '1S'
  # distilled from Brill /bid

RULE BD_later_cont_P230:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max <= 27.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: partner_first_call != '1H'
  CONDITION: opening_bid != '1S'
  # distilled from Brill /bid

RULE BD_later_cont_P231:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max <= 27.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: opening_bid == '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P232:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max <= 27.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain == 'D'
  CONDITION: opening_bid != '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P233:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max <= 27.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: partner_first_call == '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P234:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max <= 27.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain != 'D'
  CONDITION: partner_first_call != '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P235:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max > 27.5
  CONDITION: partner_last_call == '1S'
  CONDITION: hcp <= 9.5
  CONDITION: spade_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P236:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max > 27.5
  CONDITION: partner_last_call == '1S'
  CONDITION: hcp <= 9.5
  CONDITION: spade_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P237:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max > 27.5
  CONDITION: partner_last_call == '1S'
  CONDITION: hcp > 9.5
  CONDITION: opp_last_call == '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P238:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max > 27.5
  CONDITION: partner_last_call == '1S'
  CONDITION: hcp > 9.5
  CONDITION: opp_last_call != '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P239:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max > 27.5
  CONDITION: partner_last_call != '1S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: partner_last_call == '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P240:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max > 27.5
  CONDITION: partner_last_call != '1S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: partner_last_call != '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P241:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max > 27.5
  CONDITION: partner_last_call != '1S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P242:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_max > 27.5
  CONDITION: partner_last_call != '1S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P243:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P244:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: hcp > 3.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: s_has_queen <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P245:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: hcp > 3.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: s_has_queen > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P246:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: hcp > 3.5
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P247:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P248:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: major_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P249:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: major_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P250:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P251:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp > 2.5
  CONDITION: shortest_suit_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P252:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp > 2.5
  CONDITION: shortest_suit_len > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P253:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: my_side_bid_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P254:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: combined_hcp_min <= 20.5
  CONDITION: my_side_bid_count > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P255:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: combined_hcp_min > 20.5
  CONDITION: my_last_call == '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P256:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: combined_hcp_min > 20.5
  CONDITION: my_last_call != '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P257:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid == '1S'
  CONDITION: passes_since_last_bid <= 1.0
  # distilled from Brill /bid

RULE BD_later_cont_P258:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid == '1S'
  CONDITION: passes_since_last_bid > 1.0
  # distilled from Brill /bid

RULE BD_later_cont_P259:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid != '1S'
  CONDITION: partner_first_call == 'PASS'
  # distilled from Brill /bid

RULE BD_later_cont_P260:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len <= 5.5
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid != '1S'
  CONDITION: partner_first_call != 'PASS'
  # distilled from Brill /bid

RULE BD_later_cont_P261:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: last_bid_seat == 'E'
  CONDITION: diamond_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P262:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: last_bid_seat == 'E'
  CONDITION: diamond_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P263:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: last_bid_seat != 'E'
  CONDITION: last_bid_seat == 'W'
  # distilled from Brill /bid

RULE BD_later_cont_P264:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len <= 6.5
  CONDITION: last_bid_seat != 'E'
  CONDITION: last_bid_seat != 'W'
  # distilled from Brill /bid

RULE BD_later_cont_P265:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: c_has_queen <= 0.5
  CONDITION: s_has_king <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P266:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: c_has_queen <= 0.5
  CONDITION: s_has_king > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P267:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: c_has_queen > 0.5
  CONDITION: hcp <= 12.5
  # distilled from Brill /bid

RULE BD_later_cont_P268:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain == 'S'
  CONDITION: hcp > 7.5
  CONDITION: heart_len > 5.5
  CONDITION: heart_len > 6.5
  CONDITION: c_has_queen > 0.5
  CONDITION: hcp > 12.5
  # distilled from Brill /bid

RULE BD_later_cont_P269:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call == 'PASS'
  CONDITION: hcp <= 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P270:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call == 'PASS'
  CONDITION: hcp > 9.5
  CONDITION: major_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P271:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call == 'PASS'
  CONDITION: hcp > 9.5
  CONDITION: major_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P272:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call != 'PASS'
  CONDITION: heart_len <= 5.5
  CONDITION: rule20_total <= 16.5
  # distilled from Brill /bid

RULE BD_later_cont_P273:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call != 'PASS'
  CONDITION: heart_len <= 5.5
  CONDITION: rule20_total > 16.5
  # distilled from Brill /bid

RULE BD_later_cont_P274:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call != 'PASS'
  CONDITION: heart_len > 5.5
  CONDITION: second_longest_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P275:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_last_call != 'PASS'
  CONDITION: heart_len > 5.5
  CONDITION: second_longest_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P276:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: heart_len <= 5.5
  CONDITION: opening_bid == '1NT'
  CONDITION: losing_trick_count <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P277:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: heart_len <= 5.5
  CONDITION: opening_bid == '1NT'
  CONDITION: losing_trick_count > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P278:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: heart_len <= 5.5
  CONDITION: opening_bid != '1NT'
  CONDITION: combined_hcp_min <= 19.5
  # distilled from Brill /bid

RULE BD_later_cont_P279:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: heart_len <= 5.5
  CONDITION: opening_bid != '1NT'
  CONDITION: combined_hcp_min > 19.5
  # distilled from Brill /bid

RULE BD_later_cont_P280:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: heart_len > 5.5
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P281:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: heart_len > 5.5
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P282:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: heart_len > 5.5
  CONDITION: opening_bid != '1NT'
  CONDITION: my_seat == 'E'
  # distilled from Brill /bid

RULE BD_later_cont_P283:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: heart_len > 5.5
  CONDITION: opening_bid != '1NT'
  CONDITION: my_seat != 'E'
  # distilled from Brill /bid

RULE BD_later_cont_P284:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'H'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: my_seat == 'N'
  CONDITION: opening_bid == '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P285:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'H'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: my_seat == 'N'
  CONDITION: opening_bid != '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P286:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'H'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: my_seat != 'N'
  CONDITION: second_longest_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P287:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'H'
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: my_seat != 'N'
  CONDITION: second_longest_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P288:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'H'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P289:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'H'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P290:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'H'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: competition_level > 2.5
  CONDITION: c_stopper <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P291:
  CALL: XX
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'H'
  CONDITION: combined_hcp_min > 15.5
  CONDITION: competition_level > 2.5
  CONDITION: c_stopper > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P292:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'H'
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp <= 17.5
  # distilled from Brill /bid

RULE BD_later_cont_P293:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'H'
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len <= 5.5
  CONDITION: hcp > 17.5
  # distilled from Brill /bid

RULE BD_later_cont_P294:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'H'
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len > 5.5
  CONDITION: rule20_total <= 20.5
  # distilled from Brill /bid

RULE BD_later_cont_P295:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'H'
  CONDITION: second_longest_len <= 4.5
  CONDITION: heart_len > 5.5
  CONDITION: rule20_total > 20.5
  # distilled from Brill /bid

RULE BD_later_cont_P296:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'H'
  CONDITION: second_longest_len > 4.5
  CONDITION: heart_hcp <= 0.5
  CONDITION: hcp <= 7.0
  # distilled from Brill /bid

RULE BD_later_cont_P297:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'H'
  CONDITION: second_longest_len > 4.5
  CONDITION: heart_hcp <= 0.5
  CONDITION: hcp > 7.0
  # distilled from Brill /bid

RULE BD_later_cont_P298:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'H'
  CONDITION: second_longest_len > 4.5
  CONDITION: heart_hcp > 0.5
  CONDITION: opp_suit_stoppers <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P299:
  CALL: 1H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'H'
  CONDITION: second_longest_len > 4.5
  CONDITION: heart_hcp > 0.5
  CONDITION: opp_suit_stoppers > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P300:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: major_hcp <= 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P301:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: major_hcp > 7.5
  CONDITION: hcp <= 12.5
  # distilled from Brill /bid

RULE BD_later_cont_P302:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: major_hcp > 7.5
  CONDITION: hcp > 12.5
  CONDITION: hcp <= 17.0
  # distilled from Brill /bid

RULE BD_later_cont_P303:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: major_hcp > 7.5
  CONDITION: hcp > 12.5
  CONDITION: hcp > 17.0
  # distilled from Brill /bid

RULE BD_later_cont_P304:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: partner_first_call == 'X'
  CONDITION: hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P305:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: partner_first_call == 'X'
  CONDITION: hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P306:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: partner_first_call != 'X'
  CONDITION: minor_hcp <= 8.5
  # distilled from Brill /bid

RULE BD_later_cont_P307:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count <= 2.5
  CONDITION: partner_first_call != 'X'
  CONDITION: minor_hcp > 8.5
  # distilled from Brill /bid

RULE BD_later_cont_P308:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: minor_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P309:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: minor_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P310:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp <= 10.5
  # distilled from Brill /bid

RULE BD_later_cont_P311:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points <= 14.5
  CONDITION: my_side_bid_count > 2.5
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: hcp > 10.5
  # distilled from Brill /bid

RULE BD_later_cont_P312:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points > 14.5
  CONDITION: ace_count <= 1.5
  CONDITION: major_hcp <= 10.0
  CONDITION: major_hcp <= 6.0
  # distilled from Brill /bid

RULE BD_later_cont_P313:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points > 14.5
  CONDITION: ace_count <= 1.5
  CONDITION: major_hcp <= 10.0
  CONDITION: major_hcp > 6.0
  # distilled from Brill /bid

RULE BD_later_cont_P314:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points > 14.5
  CONDITION: ace_count <= 1.5
  CONDITION: major_hcp > 10.0
  # distilled from Brill /bid

RULE BD_later_cont_P315:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points > 14.5
  CONDITION: ace_count > 1.5
  CONDITION: partner_opened <= 0.5
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P316:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points > 14.5
  CONDITION: ace_count > 1.5
  CONDITION: partner_opened <= 0.5
  CONDITION: spade_len > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P317:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call == '1NT'
  CONDITION: my_side_bid_count > 1.5
  CONDITION: total_points > 14.5
  CONDITION: ace_count > 1.5
  CONDITION: partner_opened > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P318:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp <= 15.5
  CONDITION: minor_hcp <= 10.5
  CONDITION: partner_last_call == 'XX'
  # distilled from Brill /bid

RULE BD_later_cont_P319:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp <= 15.5
  CONDITION: minor_hcp <= 10.5
  CONDITION: partner_last_call != 'XX'
  CONDITION: my_seat == 'E'
  # distilled from Brill /bid

RULE BD_later_cont_P320:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp <= 15.5
  CONDITION: minor_hcp <= 10.5
  CONDITION: partner_last_call != 'XX'
  CONDITION: my_seat != 'E'
  # distilled from Brill /bid

RULE BD_later_cont_P321:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp <= 15.5
  CONDITION: minor_hcp > 10.5
  # distilled from Brill /bid

RULE BD_later_cont_P322:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp > 15.5
  CONDITION: club_hcp <= 2.5
  CONDITION: hcp <= 18.5
  # distilled from Brill /bid

RULE BD_later_cont_P323:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp > 15.5
  CONDITION: club_hcp <= 2.5
  CONDITION: hcp > 18.5
  # distilled from Brill /bid

RULE BD_later_cont_P324:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern == '5332'
  CONDITION: hcp > 15.5
  CONDITION: club_hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P325:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: spade_len <= 6.5
  CONDITION: hcp <= 16.0
  # distilled from Brill /bid

RULE BD_later_cont_P326:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: spade_len <= 6.5
  CONDITION: hcp > 16.0
  # distilled from Brill /bid

RULE BD_later_cont_P327:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: spade_len > 6.5
  CONDITION: controls <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P328:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len <= 3.5
  CONDITION: spade_len > 6.5
  CONDITION: controls > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P329:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len > 3.5
  CONDITION: total_points <= 11.5
  # distilled from Brill /bid

RULE BD_later_cont_P330:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len > 3.5
  CONDITION: total_points > 11.5
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P331:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid == '1NT'
  CONDITION: second_longest_len > 3.5
  CONDITION: total_points > 11.5
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P332:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid != '1NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: spade_len <= 5.5
  CONDITION: hcp <= 11.5
  # distilled from Brill /bid

RULE BD_later_cont_P333:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid != '1NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: spade_len <= 5.5
  CONDITION: hcp > 11.5
  # distilled from Brill /bid

RULE BD_later_cont_P334:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid != '1NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: spade_len > 5.5
  CONDITION: third_longest_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P335:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid != '1NT'
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: spade_len > 5.5
  CONDITION: third_longest_len > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P336:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid != '1NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_has_queen <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P337:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid != '1NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opp_bid_count <= 1.5
  CONDITION: c_has_queen > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P338:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid != '1NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: jack_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P339:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: partner_last_call != '1NT'
  CONDITION: shape_pattern != '5332'
  CONDITION: opening_bid != '1NT'
  CONDITION: combined_hcp_min > 19.5
  CONDITION: opp_bid_count > 1.5
  CONDITION: jack_count > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P340:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 16.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: my_last_call == '1S'
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P341:
  CALL: XX
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 16.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: my_last_call == '1S'
  CONDITION: spade_len > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P342:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 16.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: my_last_call != '1S'
  CONDITION: shape_pattern == '5332'
  # distilled from Brill /bid

RULE BD_later_cont_P343:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 16.5
  CONDITION: second_longest_len <= 4.5
  CONDITION: my_last_call != '1S'
  CONDITION: shape_pattern != '5332'
  # distilled from Brill /bid

RULE BD_later_cont_P344:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 16.5
  CONDITION: second_longest_len > 4.5
  CONDITION: d_has_king <= 0.5
  CONDITION: vuln_pressure == 'equal'
  # distilled from Brill /bid

RULE BD_later_cont_P345:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 16.5
  CONDITION: second_longest_len > 4.5
  CONDITION: d_has_king <= 0.5
  CONDITION: vuln_pressure != 'equal'
  # distilled from Brill /bid

RULE BD_later_cont_P346:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 16.5
  CONDITION: second_longest_len > 4.5
  CONDITION: d_has_king > 0.5
  CONDITION: major_hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P347:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 16.5
  CONDITION: second_longest_len > 4.5
  CONDITION: d_has_king > 0.5
  CONDITION: major_hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P348:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 16.5
  CONDITION: opening_bid == '1H'
  CONDITION: heart_hcp <= 1.5
  CONDITION: hcp <= 10.0
  # distilled from Brill /bid

RULE BD_later_cont_P349:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 16.5
  CONDITION: opening_bid == '1H'
  CONDITION: heart_hcp <= 1.5
  CONDITION: hcp > 10.0
  # distilled from Brill /bid

RULE BD_later_cont_P350:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 16.5
  CONDITION: opening_bid == '1H'
  CONDITION: heart_hcp > 1.5
  CONDITION: hcp <= 8.0
  # distilled from Brill /bid

RULE BD_later_cont_P351:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 16.5
  CONDITION: opening_bid == '1H'
  CONDITION: heart_hcp > 1.5
  CONDITION: hcp > 8.0
  # distilled from Brill /bid

RULE BD_later_cont_P352:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 16.5
  CONDITION: opening_bid != '1H'
  CONDITION: major_hcp <= 5.5
  CONDITION: ace_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P353:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 16.5
  CONDITION: opening_bid != '1H'
  CONDITION: major_hcp <= 5.5
  CONDITION: ace_count > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P354:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 16.5
  CONDITION: opening_bid != '1H'
  CONDITION: major_hcp > 5.5
  CONDITION: is_unfavorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P355:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 16.5
  CONDITION: opening_bid != '1H'
  CONDITION: major_hcp > 5.5
  CONDITION: is_unfavorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P356:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: heart_hcp <= 2.0
  CONDITION: c_stopper <= 0.5
  CONDITION: spade_hcp <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P357:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: heart_hcp <= 2.0
  CONDITION: c_stopper <= 0.5
  CONDITION: spade_hcp > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P358:
  CALL: 1NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: heart_hcp <= 2.0
  CONDITION: c_stopper > 0.5
  CONDITION: heart_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P359:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: heart_hcp <= 2.0
  CONDITION: c_stopper > 0.5
  CONDITION: heart_len > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P360:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: heart_hcp > 2.0
  CONDITION: opening_bid == '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P361:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: heart_hcp > 2.0
  CONDITION: opening_bid != '1H'
  CONDITION: hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P362:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp <= 8.5
  CONDITION: heart_hcp > 2.0
  CONDITION: opening_bid != '1H'
  CONDITION: hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P363:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp > 8.5
  CONDITION: opening_bid == '1D'
  CONDITION: controls <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P364:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp > 8.5
  CONDITION: opening_bid == '1D'
  CONDITION: controls > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P365:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp > 8.5
  CONDITION: opening_bid != '1D'
  CONDITION: club_hcp <= 6.0
  # distilled from Brill /bid

RULE BD_later_cont_P366:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain == 'S'
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: hcp > 8.5
  CONDITION: opening_bid != '1D'
  CONDITION: club_hcp > 6.0
  # distilled from Brill /bid

RULE BD_later_cont_P367:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call == '1H'
  CONDITION: heart_len <= 2.5
  CONDITION: hcp <= 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P368:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call == '1H'
  CONDITION: heart_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P369:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call == '1H'
  CONDITION: heart_len <= 2.5
  CONDITION: hcp > 7.5
  CONDITION: competition_level > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P370:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call == '1H'
  CONDITION: heart_len > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P371:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call == '1H'
  CONDITION: heart_len > 2.5
  CONDITION: hcp <= 9.5
  CONDITION: hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P372:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call == '1H'
  CONDITION: heart_len > 2.5
  CONDITION: hcp > 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P373:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call != '1H'
  CONDITION: spade_len <= 5.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_suit_stoppers <= 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P374:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call != '1H'
  CONDITION: spade_len <= 5.5
  CONDITION: partner_last_call == 'X'
  CONDITION: opp_suit_stoppers > 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P375:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call != '1H'
  CONDITION: spade_len <= 5.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P376:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call != '1H'
  CONDITION: spade_len <= 5.5
  CONDITION: partner_last_call != 'X'
  CONDITION: spade_hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P377:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call != '1H'
  CONDITION: spade_len > 5.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: rule20_total <= 20.5
  # distilled from Brill /bid

RULE BD_later_cont_P378:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call != '1H'
  CONDITION: spade_len > 5.5
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: rule20_total > 20.5
  # distilled from Brill /bid

RULE BD_later_cont_P379:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call != '1H'
  CONDITION: spade_len > 5.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: hcp <= 16.5
  # distilled from Brill /bid

RULE BD_later_cont_P380:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len <= 4.5
  CONDITION: partner_last_call != '1H'
  CONDITION: spade_len > 5.5
  CONDITION: combined_hcp_min > 11.5
  CONDITION: hcp > 16.5
  # distilled from Brill /bid

RULE BD_later_cont_P381:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid == '1H'
  CONDITION: heart_len <= 4.0
  CONDITION: passes_since_last_bid <= 1.0
  # distilled from Brill /bid

RULE BD_later_cont_P382:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid == '1H'
  CONDITION: heart_len <= 4.0
  CONDITION: passes_since_last_bid > 1.0
  CONDITION: hcp <= 10.5
  # distilled from Brill /bid

RULE BD_later_cont_P383:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid == '1H'
  CONDITION: heart_len <= 4.0
  CONDITION: passes_since_last_bid > 1.0
  CONDITION: hcp > 10.5
  # distilled from Brill /bid

RULE BD_later_cont_P384:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid == '1H'
  CONDITION: heart_len > 4.0
  # distilled from Brill /bid

RULE BD_later_cont_P385:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len <= 4.0
  CONDITION: opp_bid_count <= 1.5
  CONDITION: s_is_longest <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P386:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len <= 4.0
  CONDITION: opp_bid_count <= 1.5
  CONDITION: s_is_longest > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P387:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len <= 4.0
  CONDITION: opp_bid_count > 1.5
  CONDITION: total_points <= 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P388:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len <= 4.0
  CONDITION: opp_bid_count > 1.5
  CONDITION: total_points > 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P389:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len > 4.0
  CONDITION: last_bid_strain == 'C'
  CONDITION: total_points <= 11.5
  # distilled from Brill /bid

RULE BD_later_cont_P390:
  CALL: 2C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len > 4.0
  CONDITION: last_bid_strain == 'C'
  CONDITION: total_points > 11.5
  # distilled from Brill /bid

RULE BD_later_cont_P391:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len > 4.0
  CONDITION: last_bid_strain != 'C'
  CONDITION: competition_level <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P392:
  CALL: 1S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level <= 1.5
  CONDITION: combined_hcp_min > 9.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: last_bid_strain != 'S'
  CONDITION: second_longest_len > 4.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len > 4.0
  CONDITION: last_bid_strain != 'C'
  CONDITION: competition_level > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P393:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: total_points <= 12.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: opening_bid == '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P394:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: total_points <= 12.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: opening_bid != '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P395:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: total_points <= 12.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P396:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: total_points <= 12.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: losing_trick_count > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P397:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: total_points > 12.5
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: last_bid_level <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P398:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: total_points > 12.5
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: last_bid_level > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P399:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: total_points > 12.5
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: opp_first_call == '3S'
  # distilled from Brill /bid

RULE BD_later_cont_P400:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: total_points > 12.5
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: opp_first_call != '3S'
  # distilled from Brill /bid

RULE BD_later_cont_P401:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 5.5
  CONDITION: opp_fit_shown <= 0.5
  CONDITION: heart_hcp <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P402:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 5.5
  CONDITION: opp_fit_shown <= 0.5
  CONDITION: heart_hcp > 4.5
  CONDITION: losing_trick_count <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P403:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 5.5
  CONDITION: opp_fit_shown <= 0.5
  CONDITION: heart_hcp > 4.5
  CONDITION: losing_trick_count > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P404:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 5.5
  CONDITION: opp_fit_shown > 0.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: c_has_king <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P405:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 5.5
  CONDITION: opp_fit_shown > 0.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: c_has_king > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P406:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 5.5
  CONDITION: opp_fit_shown > 0.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: spade_hcp <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P407:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len <= 5.5
  CONDITION: heart_len > 5.5
  CONDITION: opp_fit_shown > 0.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: spade_hcp > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P408:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid == '1H'
  CONDITION: hcp <= 9.0
  CONDITION: heart_len <= 0.5
  CONDITION: hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P409:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid == '1H'
  CONDITION: hcp <= 9.0
  CONDITION: heart_len <= 0.5
  CONDITION: hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P410:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid == '1H'
  CONDITION: hcp <= 9.0
  CONDITION: heart_len > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P411:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid == '1H'
  CONDITION: hcp > 9.0
  CONDITION: major_hcp <= 6.5
  CONDITION: major_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P412:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid == '1H'
  CONDITION: hcp > 9.0
  CONDITION: major_hcp <= 6.5
  CONDITION: major_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P413:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid == '1H'
  CONDITION: hcp > 9.0
  CONDITION: major_hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P414:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid != '1H'
  CONDITION: competition_level <= 1.5
  CONDITION: s_has_king <= 0.5
  CONDITION: hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P415:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid != '1H'
  CONDITION: competition_level <= 1.5
  CONDITION: s_has_king <= 0.5
  CONDITION: hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P416:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid != '1H'
  CONDITION: competition_level <= 1.5
  CONDITION: s_has_king > 0.5
  CONDITION: singleton_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P417:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid != '1H'
  CONDITION: competition_level <= 1.5
  CONDITION: s_has_king > 0.5
  CONDITION: singleton_count > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P418:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid != '1H'
  CONDITION: competition_level > 1.5
  CONDITION: spade_len <= 7.5
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P419:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid != '1H'
  CONDITION: competition_level > 1.5
  CONDITION: spade_len <= 7.5
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P420:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 2.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid != '1H'
  CONDITION: competition_level > 1.5
  CONDITION: spade_len > 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P421:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: third_longest_len <= 2.5
  CONDITION: my_seat == 'N'
  CONDITION: club_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P422:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: third_longest_len <= 2.5
  CONDITION: my_seat == 'N'
  CONDITION: club_len > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P423:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: third_longest_len <= 2.5
  CONDITION: my_seat != 'N'
  CONDITION: partner_first_call == 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P424:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: third_longest_len <= 2.5
  CONDITION: my_seat != 'N'
  CONDITION: partner_first_call != 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P425:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: third_longest_len > 2.5
  CONDITION: my_last_call == '2C'
  CONDITION: c_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P426:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: third_longest_len > 2.5
  CONDITION: my_last_call == '2C'
  CONDITION: c_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P427:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: third_longest_len > 2.5
  CONDITION: my_last_call != '2C'
  CONDITION: competition_level <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P428:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: third_longest_len > 2.5
  CONDITION: my_last_call != '2C'
  CONDITION: competition_level > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P429:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level <= 4.5
  CONDITION: doubleton_count <= 0.5
  CONDITION: major_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P430:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level <= 4.5
  CONDITION: doubleton_count <= 0.5
  CONDITION: major_hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P431:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level <= 4.5
  CONDITION: doubleton_count > 0.5
  CONDITION: my_seat == 'E'
  # distilled from Brill /bid

RULE BD_later_cont_P432:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level <= 4.5
  CONDITION: doubleton_count > 0.5
  CONDITION: my_seat != 'E'
  # distilled from Brill /bid

RULE BD_later_cont_P433:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level > 4.5
  CONDITION: major_hcp <= 5.5
  CONDITION: major_hcp <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P434:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level > 4.5
  CONDITION: major_hcp <= 5.5
  CONDITION: major_hcp > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P435:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level > 4.5
  CONDITION: major_hcp > 5.5
  CONDITION: major_hcp <= 8.5
  # distilled from Brill /bid

RULE BD_later_cont_P436:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: competition_level > 4.5
  CONDITION: major_hcp > 5.5
  CONDITION: major_hcp > 8.5
  # distilled from Brill /bid

RULE BD_later_cont_P437:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call == 'PASS'
  CONDITION: opp_last_call == '5C'
  CONDITION: club_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P438:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call == 'PASS'
  CONDITION: opp_last_call == '5C'
  CONDITION: club_hcp > 3.5
  CONDITION: minor_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P439:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call == 'PASS'
  CONDITION: opp_last_call == '5C'
  CONDITION: club_hcp > 3.5
  CONDITION: minor_hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P440:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call == 'PASS'
  CONDITION: opp_last_call != '5C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: diamond_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P441:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call == 'PASS'
  CONDITION: opp_last_call != '5C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: diamond_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P442:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call == 'PASS'
  CONDITION: opp_last_call != '5C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opp_first_call == '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P443:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call == 'PASS'
  CONDITION: opp_last_call != '5C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opp_first_call != '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P444:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call != 'PASS'
  CONDITION: diamond_len <= 1.5
  CONDITION: major_hcp <= 7.5
  CONDITION: partner_first_call == '3S'
  # distilled from Brill /bid

RULE BD_later_cont_P445:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call != 'PASS'
  CONDITION: diamond_len <= 1.5
  CONDITION: major_hcp <= 7.5
  CONDITION: partner_first_call != '3S'
  # distilled from Brill /bid

RULE BD_later_cont_P446:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call != 'PASS'
  CONDITION: diamond_len <= 1.5
  CONDITION: major_hcp > 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P447:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call != 'PASS'
  CONDITION: diamond_len > 1.5
  CONDITION: partner_first_call == '2S'
  CONDITION: opp_last_call == '4H'
  # distilled from Brill /bid

RULE BD_later_cont_P448:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call != 'PASS'
  CONDITION: diamond_len > 1.5
  CONDITION: partner_first_call == '2S'
  CONDITION: opp_last_call != '4H'
  # distilled from Brill /bid

RULE BD_later_cont_P449:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 2.5
  CONDITION: last_bid_level > 2.5
  CONDITION: partner_first_call != 'PASS'
  CONDITION: diamond_len > 1.5
  CONDITION: partner_first_call != '2S'
  # distilled from Brill /bid

RULE BD_later_cont_P450:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid == '1H'
  CONDITION: opp_last_call == '2H'
  CONDITION: total_points <= 11.5
  CONDITION: diamond_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P451:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid == '1H'
  CONDITION: opp_last_call == '2H'
  CONDITION: total_points <= 11.5
  CONDITION: diamond_len > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P452:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid == '1H'
  CONDITION: opp_last_call == '2H'
  CONDITION: total_points > 11.5
  # distilled from Brill /bid

RULE BD_later_cont_P453:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid == '1H'
  CONDITION: opp_last_call != '2H'
  CONDITION: opp_last_call == '2S'
  CONDITION: hcp <= 8.0
  # distilled from Brill /bid

RULE BD_later_cont_P454:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid == '1H'
  CONDITION: opp_last_call != '2H'
  CONDITION: opp_last_call == '2S'
  CONDITION: hcp > 8.0
  # distilled from Brill /bid

RULE BD_later_cont_P455:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid == '1H'
  CONDITION: opp_last_call != '2H'
  CONDITION: opp_last_call != '2S'
  # distilled from Brill /bid

RULE BD_later_cont_P456:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len <= 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: auction_len <= 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P457:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len <= 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: auction_len > 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P458:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len <= 5.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid == '2C'
  # distilled from Brill /bid

RULE BD_later_cont_P459:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len <= 5.5
  CONDITION: spade_len > 5.5
  CONDITION: opening_bid != '2C'
  # distilled from Brill /bid

RULE BD_later_cont_P460:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len > 5.5
  CONDITION: hcp <= 10.5
  CONDITION: partner_first_call == 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P461:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len > 5.5
  CONDITION: hcp <= 10.5
  CONDITION: partner_first_call != 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P462:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len > 5.5
  CONDITION: hcp > 10.5
  CONDITION: major_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P463:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: opening_bid != '1H'
  CONDITION: heart_len > 5.5
  CONDITION: hcp > 10.5
  CONDITION: major_hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P464:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count > 2.5
  CONDITION: opp_last_call == '2S'
  CONDITION: my_last_call == '2C'
  CONDITION: hcp <= 8.5
  # distilled from Brill /bid

RULE BD_later_cont_P465:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count > 2.5
  CONDITION: opp_last_call == '2S'
  CONDITION: my_last_call == '2C'
  CONDITION: hcp > 8.5
  # distilled from Brill /bid

RULE BD_later_cont_P466:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count > 2.5
  CONDITION: opp_last_call == '2S'
  CONDITION: my_last_call != '2C'
  CONDITION: diamond_len <= 5.5
  CONDITION: partner_first_call == 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P467:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count > 2.5
  CONDITION: opp_last_call == '2S'
  CONDITION: my_last_call != '2C'
  CONDITION: diamond_len <= 5.5
  CONDITION: partner_first_call != 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P468:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count > 2.5
  CONDITION: opp_last_call == '2S'
  CONDITION: my_last_call != '2C'
  CONDITION: diamond_len > 5.5
  CONDITION: heart_hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P469:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count > 2.5
  CONDITION: opp_last_call == '2S'
  CONDITION: my_last_call != '2C'
  CONDITION: diamond_len > 5.5
  CONDITION: heart_hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P470:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level <= 4.5
  CONDITION: opp_bid_count > 2.5
  CONDITION: opp_last_call != '2S'
  # distilled from Brill /bid

RULE BD_later_cont_P471:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_suit_stoppers <= 0.75
  CONDITION: my_last_call == '5C'
  CONDITION: hcp <= 8.0
  # distilled from Brill /bid

RULE BD_later_cont_P472:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_suit_stoppers <= 0.75
  CONDITION: my_last_call == '5C'
  CONDITION: hcp > 8.0
  # distilled from Brill /bid

RULE BD_later_cont_P473:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_suit_stoppers <= 0.75
  CONDITION: my_last_call != '5C'
  # distilled from Brill /bid

RULE BD_later_cont_P474:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 5.5
  CONDITION: doubleton_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P475:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 5.5
  CONDITION: doubleton_count > 0.5
  CONDITION: queen_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P476:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count <= 5.5
  CONDITION: doubleton_count > 0.5
  CONDITION: queen_count > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P477:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 5.5
  CONDITION: spade_len <= 1.5
  CONDITION: d_top3_honors <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P478:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 5.5
  CONDITION: spade_len <= 1.5
  CONDITION: d_top3_honors > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P479:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: spade_len <= 3.5
  CONDITION: opp_bid_count > 5.5
  CONDITION: spade_len > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P480:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min <= 11.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: opp_contract_level > 4.5
  CONDITION: opp_suit_stoppers > 0.75
  CONDITION: spade_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P481:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len <= 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: losing_trick_count <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P482:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len <= 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: losing_trick_count > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P483:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len <= 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P484:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len <= 3.5
  CONDITION: heart_len <= 5.5
  CONDITION: spade_len > 4.5
  CONDITION: major_hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P485:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len <= 3.5
  CONDITION: heart_len > 5.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: heart_hcp <= 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P486:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len <= 3.5
  CONDITION: heart_len > 5.5
  CONDITION: last_bid_strain == 'D'
  CONDITION: heart_hcp > 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P487:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len <= 3.5
  CONDITION: heart_len > 5.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: c_is_best_minor <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P488:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len <= 3.5
  CONDITION: heart_len > 5.5
  CONDITION: last_bid_strain != 'D'
  CONDITION: c_is_best_minor > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P489:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len > 3.5
  CONDITION: partner_first_call == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_strain == 'C'
  # distilled from Brill /bid

RULE BD_later_cont_P490:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len > 3.5
  CONDITION: partner_first_call == '1S'
  CONDITION: spade_len <= 2.5
  CONDITION: last_bid_strain != 'C'
  # distilled from Brill /bid

RULE BD_later_cont_P491:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len > 3.5
  CONDITION: partner_first_call == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P492:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len > 3.5
  CONDITION: partner_first_call == '1S'
  CONDITION: spade_len > 2.5
  CONDITION: competition_level > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P493:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len > 3.5
  CONDITION: partner_first_call != '1S'
  CONDITION: spade_len <= 5.5
  CONDITION: support_in_partner_suit <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P494:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len > 3.5
  CONDITION: partner_first_call != '1S'
  CONDITION: spade_len <= 5.5
  CONDITION: support_in_partner_suit > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P495:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len > 3.5
  CONDITION: partner_first_call != '1S'
  CONDITION: spade_len > 5.5
  CONDITION: opp_first_call == '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P496:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: auction_len > 3.5
  CONDITION: partner_first_call != '1S'
  CONDITION: spade_len > 5.5
  CONDITION: opp_first_call != '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P497:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len <= 3.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: competition_level <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P498:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len <= 3.5
  CONDITION: is_favorable_vuln <= 0.5
  CONDITION: competition_level > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P499:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len <= 3.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: competition_level <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P500:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len <= 3.5
  CONDITION: is_favorable_vuln > 0.5
  CONDITION: competition_level > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P501:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: controls <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P502:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: controls > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P503:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len > 3.5
  CONDITION: d_is_longest > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P504:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: d_is_longest <= 0.5
  CONDITION: competition_level <= 4.5
  CONDITION: rule20_total <= 17.5
  # distilled from Brill /bid

RULE BD_later_cont_P505:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: d_is_longest <= 0.5
  CONDITION: competition_level <= 4.5
  CONDITION: rule20_total > 17.5
  # distilled from Brill /bid

RULE BD_later_cont_P506:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: d_is_longest <= 0.5
  CONDITION: competition_level > 4.5
  CONDITION: club_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P507:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: d_is_longest <= 0.5
  CONDITION: competition_level > 4.5
  CONDITION: club_hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P508:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: d_is_longest > 0.5
  CONDITION: partner_first_call == '1C'
  CONDITION: combined_hcp_max <= 30.0
  # distilled from Brill /bid

RULE BD_later_cont_P509:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: d_is_longest > 0.5
  CONDITION: partner_first_call == '1C'
  CONDITION: combined_hcp_max > 30.0
  # distilled from Brill /bid

RULE BD_later_cont_P510:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: d_is_longest > 0.5
  CONDITION: partner_first_call != '1C'
  CONDITION: diamond_hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P511:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total <= 22.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: d_is_longest > 0.5
  CONDITION: partner_first_call != '1C'
  CONDITION: diamond_hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P512:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp <= 18.5
  CONDITION: spade_len <= 4.5
  CONDITION: opp_suit_stoppers <= 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P513:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp <= 18.5
  CONDITION: spade_len <= 4.5
  CONDITION: opp_suit_stoppers > 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P514:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp <= 18.5
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P515:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp <= 18.5
  CONDITION: spade_len > 4.5
  CONDITION: second_longest_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P516:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 18.5
  CONDITION: doubleton_count <= 0.5
  CONDITION: club_len <= 2.0
  # distilled from Brill /bid

RULE BD_later_cont_P517:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 18.5
  CONDITION: doubleton_count <= 0.5
  CONDITION: club_len > 2.0
  # distilled from Brill /bid

RULE BD_later_cont_P518:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 18.5
  CONDITION: doubleton_count > 0.5
  CONDITION: diamond_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P519:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level <= 1.5
  CONDITION: hcp > 18.5
  CONDITION: doubleton_count > 0.5
  CONDITION: diamond_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P520:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opp_fit_shown <= 0.5
  CONDITION: my_first_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_cont_P521:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opp_fit_shown <= 0.5
  CONDITION: my_first_call != '1NT'
  # distilled from Brill /bid

RULE BD_later_cont_P522:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opp_fit_shown > 0.5
  CONDITION: my_last_call == '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P523:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: opp_fit_shown > 0.5
  CONDITION: my_last_call != '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P524:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: competition_level <= 3.5
  CONDITION: s_stopper <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P525:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: competition_level <= 3.5
  CONDITION: s_stopper > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P526:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: competition_level > 3.5
  CONDITION: support_in_partner_suit <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P527:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: competition_level > 3.5
  CONDITION: support_in_partner_suit > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P528:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: auction_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P529:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: heart_len <= 5.5
  CONDITION: auction_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P530:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: heart_len > 5.5
  CONDITION: losing_trick_count <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P531:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: diamond_len <= 5.5
  CONDITION: heart_len > 5.5
  CONDITION: losing_trick_count > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P532:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: doubleton_count <= 1.5
  CONDITION: shape_pattern == '6520'
  # distilled from Brill /bid

RULE BD_later_cont_P533:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: doubleton_count <= 1.5
  CONDITION: shape_pattern != '6520'
  # distilled from Brill /bid

RULE BD_later_cont_P534:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: doubleton_count > 1.5
  CONDITION: heart_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P535:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 5.5
  CONDITION: diamond_len > 5.5
  CONDITION: doubleton_count > 1.5
  CONDITION: heart_len > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P536:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: s_has_jack <= 0.5
  CONDITION: is_unfavorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P537:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: s_has_jack <= 0.5
  CONDITION: is_unfavorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P538:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: s_has_jack > 0.5
  CONDITION: hcp <= 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P539:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: s_has_jack > 0.5
  CONDITION: hcp > 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P540:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: opp_bid_count > 2.5
  CONDITION: last_bid_seat == 'S'
  CONDITION: second_longest_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P541:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: opp_bid_count > 2.5
  CONDITION: last_bid_seat == 'S'
  CONDITION: second_longest_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P542:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level <= 2.5
  CONDITION: rule20_total > 22.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 5.5
  CONDITION: opp_bid_count > 2.5
  CONDITION: last_bid_seat != 'S'
  # distilled from Brill /bid

RULE BD_later_cont_P543:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: diamond_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P544:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level <= 1.5
  CONDITION: diamond_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P545:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min <= 19.5
  # distilled from Brill /bid

RULE BD_later_cont_P546:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count <= 7.5
  CONDITION: competition_level > 1.5
  CONDITION: combined_hcp_min > 19.5
  # distilled from Brill /bid

RULE BD_later_cont_P547:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: my_first_call == '1H'
  CONDITION: opp_first_call == '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P548:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: my_first_call == '1H'
  CONDITION: opp_first_call != '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P549:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: my_first_call != '1H'
  CONDITION: partner_last_bid_strain == 'S'
  # distilled from Brill /bid

RULE BD_later_cont_P550:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len <= 3.5
  CONDITION: losing_trick_count > 7.5
  CONDITION: my_first_call != '1H'
  CONDITION: partner_last_bid_strain != 'S'
  # distilled from Brill /bid

RULE BD_later_cont_P551:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len > 3.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: my_last_call == '2S'
  CONDITION: combined_hcp_max <= 26.5
  # distilled from Brill /bid

RULE BD_later_cont_P552:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len > 3.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: my_last_call == '2S'
  CONDITION: combined_hcp_max > 26.5
  # distilled from Brill /bid

RULE BD_later_cont_P553:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len > 3.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: my_last_call != '2S'
  CONDITION: partner_last_bid_strain == 'S'
  # distilled from Brill /bid

RULE BD_later_cont_P554:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len > 3.5
  CONDITION: combined_hcp_max <= 29.5
  CONDITION: my_last_call != '2S'
  CONDITION: partner_last_bid_strain != 'S'
  # distilled from Brill /bid

RULE BD_later_cont_P555:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len > 3.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: partner_first_call == '1C'
  CONDITION: club_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P556:
  CALL: 4C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len > 3.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: partner_first_call == '1C'
  CONDITION: club_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P557:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len > 3.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: partner_first_call != '1C'
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P558:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: spade_len > 3.5
  CONDITION: combined_hcp_max > 29.5
  CONDITION: partner_first_call != '1C'
  CONDITION: spade_len > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P559:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: my_last_call == '1S'
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P560:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: my_last_call == '1S'
  CONDITION: spade_len > 5.5
  CONDITION: second_longest_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P561:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: my_last_call == '1S'
  CONDITION: spade_len > 5.5
  CONDITION: second_longest_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P562:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: my_last_call != '1S'
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: support_in_partner_suit <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P563:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: my_last_call != '1S'
  CONDITION: shortest_suit_len <= 0.5
  CONDITION: support_in_partner_suit > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P564:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: my_last_call != '1S'
  CONDITION: shortest_suit_len > 0.5
  CONDITION: opening_bid == '4S'
  # distilled from Brill /bid

RULE BD_later_cont_P565:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min <= 14.5
  CONDITION: my_last_call != '1S'
  CONDITION: shortest_suit_len > 0.5
  CONDITION: opening_bid != '4S'
  # distilled from Brill /bid

RULE BD_later_cont_P566:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: total_points <= 7.5
  CONDITION: my_last_call == '4S'
  CONDITION: hcp <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P567:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: total_points <= 7.5
  CONDITION: my_last_call == '4S'
  CONDITION: hcp > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P568:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: total_points <= 7.5
  CONDITION: my_last_call != '4S'
  CONDITION: opp_first_call == '3H'
  # distilled from Brill /bid

RULE BD_later_cont_P569:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: total_points <= 7.5
  CONDITION: my_last_call != '4S'
  CONDITION: opp_first_call != '3H'
  # distilled from Brill /bid

RULE BD_later_cont_P570:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: total_points > 7.5
  CONDITION: my_last_call == '4H'
  CONDITION: c_is_best_minor <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P571:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: total_points > 7.5
  CONDITION: my_last_call == '4H'
  CONDITION: c_is_best_minor > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P572:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: total_points > 7.5
  CONDITION: my_last_call != '4H'
  CONDITION: opp_first_bid_level <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P573:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total <= 24.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: combined_hcp_min > 14.5
  CONDITION: total_points > 7.5
  CONDITION: my_last_call != '4H'
  CONDITION: opp_first_bid_level > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P574:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: auction_len <= 3.5
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: club_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P575:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: auction_len <= 3.5
  CONDITION: opp_suit_stoppers <= 0.25
  CONDITION: club_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P576:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: auction_len <= 3.5
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: last_bid_level <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P577:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: auction_len <= 3.5
  CONDITION: opp_suit_stoppers > 0.25
  CONDITION: last_bid_level > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P578:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: auction_len > 3.5
  CONDITION: hcp <= 16.5
  CONDITION: h_top2_honors <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P579:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: auction_len > 3.5
  CONDITION: hcp <= 16.5
  CONDITION: h_top2_honors > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P580:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: auction_len > 3.5
  CONDITION: hcp > 16.5
  CONDITION: jack_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P581:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len <= 5.5
  CONDITION: auction_len > 3.5
  CONDITION: hcp > 16.5
  CONDITION: jack_count > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P582:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: diamond_len <= 4.5
  CONDITION: heart_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P583:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: diamond_len <= 4.5
  CONDITION: heart_len > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P584:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: diamond_len > 4.5
  CONDITION: last_bid_strain == 'C'
  # distilled from Brill /bid

RULE BD_later_cont_P585:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len <= 4.5
  CONDITION: diamond_len > 4.5
  CONDITION: last_bid_strain != 'C'
  # distilled from Brill /bid

RULE BD_later_cont_P586:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 16.5
  CONDITION: c_top2_honors <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P587:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp <= 16.5
  CONDITION: c_top2_honors > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P588:
  CALL: 7H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 16.5
  CONDITION: s_is_longest <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P589:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level <= 3.5
  CONDITION: longest_suit_len > 5.5
  CONDITION: spade_len > 4.5
  CONDITION: hcp > 16.5
  CONDITION: s_is_longest > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P590:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: diamond_len <= 5.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P591:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: diamond_len <= 5.5
  CONDITION: opp_bid_count <= 2.5
  CONDITION: spade_len > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P592:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: diamond_len <= 5.5
  CONDITION: opp_bid_count > 2.5
  CONDITION: shape_pattern == '6430'
  # distilled from Brill /bid

RULE BD_later_cont_P593:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: diamond_len <= 5.5
  CONDITION: opp_bid_count > 2.5
  CONDITION: shape_pattern != '6430'
  # distilled from Brill /bid

RULE BD_later_cont_P594:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: diamond_len > 5.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: hcp <= 15.5
  # distilled from Brill /bid

RULE BD_later_cont_P595:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: diamond_len > 5.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: hcp > 15.5
  # distilled from Brill /bid

RULE BD_later_cont_P596:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min <= 17.5
  CONDITION: diamond_len > 5.5
  CONDITION: last_bid_level > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P597:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: heart_hcp <= 1.5
  CONDITION: club_len <= 2.5
  CONDITION: controls <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P598:
  CALL: 4D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: heart_hcp <= 1.5
  CONDITION: club_len <= 2.5
  CONDITION: controls > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P599:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: heart_hcp <= 1.5
  CONDITION: club_len > 2.5
  CONDITION: spade_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P600:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: heart_hcp <= 1.5
  CONDITION: club_len > 2.5
  CONDITION: spade_len > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P601:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: heart_hcp > 1.5
  CONDITION: heart_len <= 5.5
  CONDITION: s_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P602:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: heart_hcp > 1.5
  CONDITION: heart_len <= 5.5
  CONDITION: s_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P603:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: heart_hcp > 1.5
  CONDITION: heart_len > 5.5
  CONDITION: last_bid_strain == 'D'
  # distilled from Brill /bid

RULE BD_later_cont_P604:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call == 'PASS'
  CONDITION: combined_hcp_min > 11.5
  CONDITION: last_bid_level > 2.5
  CONDITION: rule20_total > 24.5
  CONDITION: competition_level > 3.5
  CONDITION: combined_hcp_min > 17.5
  CONDITION: heart_hcp > 1.5
  CONDITION: heart_len > 5.5
  CONDITION: last_bid_strain != 'D'
  # distilled from Brill /bid

RULE BD_later_cont_P605:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: partner_hcp_max <= 13.5
  CONDITION: partner_first_call == '2H'
  CONDITION: opp_preempted <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P606:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: partner_hcp_max <= 13.5
  CONDITION: partner_first_call == '2H'
  CONDITION: opp_preempted > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P607:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: partner_hcp_max <= 13.5
  CONDITION: partner_first_call != '2H'
  CONDITION: shortest_suit_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P608:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: partner_hcp_max <= 13.5
  CONDITION: partner_first_call != '2H'
  CONDITION: shortest_suit_len > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P609:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: partner_hcp_max > 13.5
  CONDITION: opening_bid == '1NT'
  CONDITION: longest_suit_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P610:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: partner_hcp_max > 13.5
  CONDITION: opening_bid == '1NT'
  CONDITION: longest_suit_len > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P611:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: partner_hcp_max > 13.5
  CONDITION: opening_bid != '1NT'
  CONDITION: my_last_call == '1S'
  # distilled from Brill /bid

RULE BD_later_cont_P612:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min <= 15.5
  CONDITION: partner_hcp_max > 13.5
  CONDITION: opening_bid != '1NT'
  CONDITION: my_last_call != '1S'
  # distilled from Brill /bid

RULE BD_later_cont_P613:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_first_call == '1S'
  CONDITION: spade_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P614:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_first_call == '1S'
  CONDITION: spade_len > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P615:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_first_call != '1S'
  CONDITION: opp_last_call == '2C'
  # distilled from Brill /bid

RULE BD_later_cont_P616:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_first_call != '1S'
  CONDITION: opp_last_call != '2C'
  # distilled from Brill /bid

RULE BD_later_cont_P617:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_seat == 'E'
  # distilled from Brill /bid

RULE BD_later_cont_P618:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain == 'H'
  CONDITION: my_seat != 'E'
  # distilled from Brill /bid

RULE BD_later_cont_P619:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_max <= 22.5
  # distilled from Brill /bid

RULE BD_later_cont_P620:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: combined_hcp_min > 15.5
  CONDITION: spade_len > 4.5
  CONDITION: last_bid_strain != 'H'
  CONDITION: combined_hcp_max > 22.5
  # distilled from Brill /bid

RULE BD_later_cont_P621:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: total_points <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P622:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: total_points > 4.5
  CONDITION: opp_last_call == '2S'
  CONDITION: shape_pattern == '5431'
  # distilled from Brill /bid

RULE BD_later_cont_P623:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: total_points > 4.5
  CONDITION: opp_last_call == '2S'
  CONDITION: shape_pattern != '5431'
  # distilled from Brill /bid

RULE BD_later_cont_P624:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: total_points > 4.5
  CONDITION: opp_last_call != '2S'
  CONDITION: last_bid_strain == 'NT'
  # distilled from Brill /bid

RULE BD_later_cont_P625:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: total_points > 4.5
  CONDITION: opp_last_call != '2S'
  CONDITION: last_bid_strain != 'NT'
  # distilled from Brill /bid

RULE BD_later_cont_P626:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len <= 4.5
  CONDITION: hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P627:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len <= 4.5
  CONDITION: hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P628:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len > 4.5
  CONDITION: combined_hcp_max <= 23.5
  # distilled from Brill /bid

RULE BD_later_cont_P629:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len > 4.5
  CONDITION: combined_hcp_max > 23.5
  # distilled from Brill /bid

RULE BD_later_cont_P630:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: partner_first_call == '1D'
  CONDITION: singleton_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P631:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: partner_first_call == '1D'
  CONDITION: singleton_count > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P632:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: partner_first_call != '1D'
  CONDITION: my_side_bid_count <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P633:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: partner_first_call != '1D'
  CONDITION: my_side_bid_count > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P634:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == 'X'
  CONDITION: competition_level <= 2.5
  CONDITION: opp_first_call == '2D'
  CONDITION: hcp <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P635:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == 'X'
  CONDITION: competition_level <= 2.5
  CONDITION: opp_first_call == '2D'
  CONDITION: hcp > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P636:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == 'X'
  CONDITION: competition_level <= 2.5
  CONDITION: opp_first_call != '2D'
  # distilled from Brill /bid

RULE BD_later_cont_P637:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == 'X'
  CONDITION: competition_level > 2.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: king_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P638:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == 'X'
  CONDITION: competition_level > 2.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: s_is_longest <= 0.5
  CONDITION: king_count > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P639:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == 'X'
  CONDITION: competition_level > 2.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: c_has_ace <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P640:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == 'X'
  CONDITION: competition_level > 2.5
  CONDITION: d_is_longest <= 0.5
  CONDITION: s_is_longest > 0.5
  CONDITION: c_has_ace > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P641:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == 'X'
  CONDITION: competition_level > 2.5
  CONDITION: d_is_longest > 0.5
  CONDITION: partner_first_call == '1H'
  CONDITION: hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P642:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == 'X'
  CONDITION: competition_level > 2.5
  CONDITION: d_is_longest > 0.5
  CONDITION: partner_first_call == '1H'
  CONDITION: hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P643:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == 'X'
  CONDITION: competition_level > 2.5
  CONDITION: d_is_longest > 0.5
  CONDITION: partner_first_call != '1H'
  CONDITION: is_favorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P644:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == 'X'
  CONDITION: competition_level > 2.5
  CONDITION: d_is_longest > 0.5
  CONDITION: partner_first_call != '1H'
  CONDITION: is_favorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P645:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain == 'NONE'
  CONDITION: my_seat == 'E'
  CONDITION: opp_fit_shown <= 0.5
  CONDITION: quick_tricks <= 0.75
  # distilled from Brill /bid

RULE BD_later_cont_P646:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain == 'NONE'
  CONDITION: my_seat == 'E'
  CONDITION: opp_fit_shown <= 0.5
  CONDITION: quick_tricks > 0.75
  # distilled from Brill /bid

RULE BD_later_cont_P647:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain == 'NONE'
  CONDITION: my_seat == 'E'
  CONDITION: opp_fit_shown > 0.5
  CONDITION: d_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P648:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain == 'NONE'
  CONDITION: my_seat == 'E'
  CONDITION: opp_fit_shown > 0.5
  CONDITION: d_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P649:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain == 'NONE'
  CONDITION: my_seat != 'E'
  CONDITION: losing_trick_count <= 9.5
  CONDITION: jack_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P650:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain == 'NONE'
  CONDITION: my_seat != 'E'
  CONDITION: losing_trick_count <= 9.5
  CONDITION: jack_count > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P651:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain == 'NONE'
  CONDITION: my_seat != 'E'
  CONDITION: losing_trick_count > 9.5
  CONDITION: auction_len <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P652:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain == 'NONE'
  CONDITION: my_seat != 'E'
  CONDITION: losing_trick_count > 9.5
  CONDITION: auction_len > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P653:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain != 'NONE'
  CONDITION: last_bid_strain == 'C'
  CONDITION: opening_bid == '1NT'
  # distilled from Brill /bid

RULE BD_later_cont_P654:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain != 'NONE'
  CONDITION: last_bid_strain == 'C'
  CONDITION: opening_bid != '1NT'
  CONDITION: c_has_ten <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P655:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain != 'NONE'
  CONDITION: last_bid_strain == 'C'
  CONDITION: opening_bid != '1NT'
  CONDITION: c_has_ten > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P656:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain != 'NONE'
  CONDITION: last_bid_strain != 'C'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: rule20_total <= 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P657:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain != 'NONE'
  CONDITION: last_bid_strain != 'C'
  CONDITION: partner_hcp_min <= 8.0
  CONDITION: rule20_total > 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P658:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain != 'NONE'
  CONDITION: last_bid_strain != 'C'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: last_bid_strain == 'D'
  # distilled from Brill /bid

RULE BD_later_cont_P659:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp <= 6.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  CONDITION: partner_last_bid_strain != 'NONE'
  CONDITION: last_bid_strain != 'C'
  CONDITION: partner_hcp_min > 8.0
  CONDITION: last_bid_strain != 'D'
  # distilled from Brill /bid

RULE BD_later_cont_P660:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: hcp <= 9.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: club_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P661:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: hcp <= 9.5
  CONDITION: my_side_bid_count <= 1.5
  CONDITION: club_len > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P662:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: hcp <= 9.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_first_call == '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P663:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: hcp <= 9.5
  CONDITION: my_side_bid_count > 1.5
  CONDITION: partner_first_call != '1C'
  # distilled from Brill /bid

RULE BD_later_cont_P664:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: hcp > 9.5
  CONDITION: my_last_call == 'X'
  CONDITION: diamond_hcp <= 6.0
  # distilled from Brill /bid

RULE BD_later_cont_P665:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: hcp > 9.5
  CONDITION: my_last_call == 'X'
  CONDITION: diamond_hcp > 6.0
  # distilled from Brill /bid

RULE BD_later_cont_P666:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: hcp > 9.5
  CONDITION: my_last_call != 'X'
  CONDITION: my_last_call == '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P667:
  CALL: 2D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: hcp > 9.5
  CONDITION: my_last_call != 'X'
  CONDITION: my_last_call != '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P668:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain != 'C'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: heart_len <= 3.5
  CONDITION: combined_hcp_max <= 27.5
  # distilled from Brill /bid

RULE BD_later_cont_P669:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain != 'C'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: heart_len <= 3.5
  CONDITION: combined_hcp_max > 27.5
  # distilled from Brill /bid

RULE BD_later_cont_P670:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain != 'C'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_seat == 'N'
  # distilled from Brill /bid

RULE BD_later_cont_P671:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain != 'C'
  CONDITION: support_in_partner_suit <= 2.5
  CONDITION: heart_len > 3.5
  CONDITION: last_bid_seat != 'N'
  # distilled from Brill /bid

RULE BD_later_cont_P672:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain != 'C'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: partner_last_call == '1S'
  # distilled from Brill /bid

RULE BD_later_cont_P673:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain != 'C'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min <= 22.5
  CONDITION: partner_last_call != '1S'
  # distilled from Brill /bid

RULE BD_later_cont_P674:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain != 'C'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: my_last_call == 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P675:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len <= 3.5
  CONDITION: partner_last_bid_strain != 'C'
  CONDITION: support_in_partner_suit > 2.5
  CONDITION: combined_hcp_min > 22.5
  CONDITION: my_last_call != 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P676:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: competition_level <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P677:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_bid_strain == 'C'
  CONDITION: competition_level > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P678:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_bid_strain != 'C'
  CONDITION: combined_hcp_min <= 19.5
  # distilled from Brill /bid

RULE BD_later_cont_P679:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: spade_len <= 4.5
  CONDITION: partner_last_bid_strain != 'C'
  CONDITION: combined_hcp_min > 19.5
  # distilled from Brill /bid

RULE BD_later_cont_P680:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: spade_len > 4.5
  CONDITION: total_points <= 13.5
  CONDITION: last_bid_seat == 'N'
  # distilled from Brill /bid

RULE BD_later_cont_P681:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: spade_len > 4.5
  CONDITION: total_points <= 13.5
  CONDITION: last_bid_seat != 'N'
  # distilled from Brill /bid

RULE BD_later_cont_P682:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: spade_len > 4.5
  CONDITION: total_points > 13.5
  CONDITION: heart_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P683:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit <= 3.5
  CONDITION: spade_len > 4.5
  CONDITION: total_points > 13.5
  CONDITION: heart_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P684:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: club_len <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P685:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: support_in_partner_suit <= 4.5
  CONDITION: club_len > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P686:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: heart_len <= 4.0
  # distilled from Brill /bid

RULE BD_later_cont_P687:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: support_in_partner_suit > 4.5
  CONDITION: heart_len > 4.0
  # distilled from Brill /bid

RULE BD_later_cont_P688:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: hcp <= 16.5
  CONDITION: queen_count <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P689:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: hcp <= 16.5
  CONDITION: queen_count > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P690:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: hcp > 16.5
  CONDITION: opp_suit_stoppers <= 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P691:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: spade_len > 3.5
  CONDITION: support_in_partner_suit > 3.5
  CONDITION: competition_level > 2.5
  CONDITION: hcp > 16.5
  CONDITION: opp_suit_stoppers > 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P692:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_max <= 19.5
  CONDITION: opening_bid == '1D'
  # distilled from Brill /bid

RULE BD_later_cont_P693:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_max <= 19.5
  CONDITION: opening_bid != '1D'
  # distilled from Brill /bid

RULE BD_later_cont_P694:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_max > 19.5
  CONDITION: my_last_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_cont_P695:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len <= 4.5
  CONDITION: combined_hcp_max > 19.5
  CONDITION: my_last_call != '1NT'
  # distilled from Brill /bid

RULE BD_later_cont_P696:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: partner_last_call == '1S'
  CONDITION: spade_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P697:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: partner_last_call == '1S'
  CONDITION: spade_len > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P698:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: partner_last_call != '1S'
  CONDITION: rule_of_21 <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P699:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len <= 4.5
  CONDITION: heart_len > 4.5
  CONDITION: partner_last_call != '1S'
  CONDITION: rule_of_21 > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P700:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P701:
  CALL: 2H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: partner_last_bid_strain == 'H'
  CONDITION: heart_len > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P702:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: opp_last_call == '1D'
  # distilled from Brill /bid

RULE BD_later_cont_P703:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: partner_last_bid_strain != 'H'
  CONDITION: opp_last_call != '1D'
  # distilled from Brill /bid

RULE BD_later_cont_P704:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: opp_last_call == '1D'
  # distilled from Brill /bid

RULE BD_later_cont_P705:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: opp_last_call != '1D'
  CONDITION: heart_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P706:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: opp_last_call != '1D'
  CONDITION: heart_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P707:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call == '2NT'
  CONDITION: competition_level <= 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: opp_contract_level <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P708:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call == '2NT'
  CONDITION: competition_level <= 3.5
  CONDITION: competition_level <= 2.5
  CONDITION: opp_contract_level > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P709:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call == '2NT'
  CONDITION: competition_level <= 3.5
  CONDITION: competition_level > 2.5
  CONDITION: hcp <= 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P710:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call == '2NT'
  CONDITION: competition_level <= 3.5
  CONDITION: competition_level > 2.5
  CONDITION: hcp > 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P711:
  CALL: 3C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call == '2NT'
  CONDITION: competition_level > 3.5
  CONDITION: diamond_len <= 1.5
  CONDITION: competition_level <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P712:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call == '2NT'
  CONDITION: competition_level > 3.5
  CONDITION: diamond_len <= 1.5
  CONDITION: competition_level > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P713:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call == '2NT'
  CONDITION: competition_level > 3.5
  CONDITION: diamond_len > 1.5
  CONDITION: opp_contract_level <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P714:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call == '2NT'
  CONDITION: competition_level > 3.5
  CONDITION: diamond_len > 1.5
  CONDITION: opp_contract_level > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P715:
  CALL: 2NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call == '2S'
  CONDITION: opp_last_call == '1S'
  CONDITION: heart_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P716:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call == '2S'
  CONDITION: opp_last_call == '1S'
  CONDITION: heart_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P717:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call == '2S'
  CONDITION: opp_last_call != '1S'
  CONDITION: spade_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P718:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call == '2S'
  CONDITION: opp_last_call != '1S'
  CONDITION: spade_len > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P719:
  CALL: 2S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call != '2S'
  CONDITION: partner_last_call == '2H'
  CONDITION: opp_last_call == '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P720:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call != '2S'
  CONDITION: partner_last_call == '2H'
  CONDITION: opp_last_call != '1H'
  # distilled from Brill /bid

RULE BD_later_cont_P721:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call != '2S'
  CONDITION: partner_last_call != '2H'
  CONDITION: support_in_partner_suit <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P722:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level <= 2.5
  CONDITION: hcp > 6.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: partner_last_call != '2NT'
  CONDITION: partner_last_call != '2S'
  CONDITION: partner_last_call != '2H'
  CONDITION: support_in_partner_suit > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P723:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown <= 0.5
  CONDITION: hcp <= 9.5
  CONDITION: my_last_call == '2NT'
  CONDITION: opp_suit_stoppers <= 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P724:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown <= 0.5
  CONDITION: hcp <= 9.5
  CONDITION: my_last_call == '2NT'
  CONDITION: opp_suit_stoppers > 0.25
  # distilled from Brill /bid

RULE BD_later_cont_P725:
  CALL: 4C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown <= 0.5
  CONDITION: hcp <= 9.5
  CONDITION: my_last_call != '2NT'
  CONDITION: opening_bid == '2S'
  # distilled from Brill /bid

RULE BD_later_cont_P726:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown <= 0.5
  CONDITION: hcp <= 9.5
  CONDITION: my_last_call != '2NT'
  CONDITION: opening_bid != '2S'
  # distilled from Brill /bid

RULE BD_later_cont_P727:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown <= 0.5
  CONDITION: hcp > 9.5
  CONDITION: my_last_call == '1H'
  CONDITION: hcp <= 15.0
  # distilled from Brill /bid

RULE BD_later_cont_P728:
  CALL: 4NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown <= 0.5
  CONDITION: hcp > 9.5
  CONDITION: my_last_call == '1H'
  CONDITION: hcp > 15.0
  # distilled from Brill /bid

RULE BD_later_cont_P729:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown <= 0.5
  CONDITION: hcp > 9.5
  CONDITION: my_last_call != '1H'
  CONDITION: opp_bid_count <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P730:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown <= 0.5
  CONDITION: hcp > 9.5
  CONDITION: my_last_call != '1H'
  CONDITION: opp_bid_count > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P731:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown > 0.5
  CONDITION: combined_hcp_min <= 18.5
  CONDITION: rule20_total <= 21.5
  CONDITION: opp_bid_count <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P732:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown > 0.5
  CONDITION: combined_hcp_min <= 18.5
  CONDITION: rule20_total <= 21.5
  CONDITION: opp_bid_count > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P733:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown > 0.5
  CONDITION: combined_hcp_min <= 18.5
  CONDITION: rule20_total > 21.5
  CONDITION: ace_count <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P734:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown > 0.5
  CONDITION: combined_hcp_min <= 18.5
  CONDITION: rule20_total > 21.5
  CONDITION: ace_count > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P735:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown > 0.5
  CONDITION: combined_hcp_min > 18.5
  CONDITION: opp_contract_level <= 2.5
  CONDITION: club_len <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P736:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown > 0.5
  CONDITION: combined_hcp_min > 18.5
  CONDITION: opp_contract_level <= 2.5
  CONDITION: club_len > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P737:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown > 0.5
  CONDITION: combined_hcp_min > 18.5
  CONDITION: opp_contract_level > 2.5
  CONDITION: spade_len <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P738:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain == 'S'
  CONDITION: our_fit_shown > 0.5
  CONDITION: combined_hcp_min > 18.5
  CONDITION: opp_contract_level > 2.5
  CONDITION: spade_len > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P739:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: partner_last_call == 'X'
  CONDITION: hcp <= 10.0
  CONDITION: hcp <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P740:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: partner_last_call == 'X'
  CONDITION: hcp <= 10.0
  CONDITION: hcp > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P741:
  CALL: 4C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: partner_last_call == 'X'
  CONDITION: hcp > 10.0
  CONDITION: hcp <= 12.5
  # distilled from Brill /bid

RULE BD_later_cont_P742:
  CALL: 3D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: partner_last_call == 'X'
  CONDITION: hcp > 10.0
  CONDITION: hcp > 12.5
  # distilled from Brill /bid

RULE BD_later_cont_P743:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: partner_last_call != 'X'
  CONDITION: opening_bid == '2S'
  CONDITION: king_count <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P744:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: partner_last_call != 'X'
  CONDITION: opening_bid == '2S'
  CONDITION: king_count > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P745:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: partner_last_call != 'X'
  CONDITION: opening_bid != '2S'
  CONDITION: losing_trick_count <= 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P746:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len <= 2.5
  CONDITION: partner_last_call != 'X'
  CONDITION: opening_bid != '2S'
  CONDITION: losing_trick_count > 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P747:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: opp_preempted <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: club_len <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P748:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: opp_preempted <= 0.5
  CONDITION: last_bid_strain == 'NT'
  CONDITION: club_len > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P749:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: opp_preempted <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: passes_since_last_bid <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P750:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: opp_preempted <= 0.5
  CONDITION: last_bid_strain != 'NT'
  CONDITION: passes_since_last_bid > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P751:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: opp_preempted > 0.5
  CONDITION: combined_hcp_max <= 32.5
  CONDITION: hcp <= 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P752:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: opp_preempted > 0.5
  CONDITION: combined_hcp_max <= 32.5
  CONDITION: hcp > 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P753:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: opp_preempted > 0.5
  CONDITION: combined_hcp_max > 32.5
  CONDITION: losing_trick_count <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P754:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: last_bid_strain != 'S'
  CONDITION: spade_len > 2.5
  CONDITION: opp_preempted > 0.5
  CONDITION: combined_hcp_max > 32.5
  CONDITION: losing_trick_count > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P755:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_min <= 27.5
  CONDITION: hcp <= 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P756:
  CALL: X
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_min <= 27.5
  CONDITION: hcp > 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P757:
  CALL: 4C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_min > 27.5
  CONDITION: heart_len <= 2.5
  CONDITION: hcp <= 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P758:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_min > 27.5
  CONDITION: heart_len <= 2.5
  CONDITION: hcp > 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P759:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: combined_hcp_min > 27.5
  CONDITION: heart_len > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P760:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: partner_first_call == '2H'
  CONDITION: major_hcp <= 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P761:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: partner_first_call == '2H'
  CONDITION: major_hcp > 6.5
  # distilled from Brill /bid

RULE BD_later_cont_P762:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: partner_first_call != '2H'
  CONDITION: my_last_call == 'PASS'
  # distilled from Brill /bid

RULE BD_later_cont_P763:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: spade_len <= 5.5
  CONDITION: partner_first_call != '2H'
  CONDITION: my_last_call != 'PASS'
  # distilled from Brill /bid

RULE BD_later_cont_P764:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: spade_len > 5.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp <= 14.0
  # distilled from Brill /bid

RULE BD_later_cont_P765:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: spade_len > 5.5
  CONDITION: auction_len <= 5.5
  CONDITION: hcp > 14.0
  # distilled from Brill /bid

RULE BD_later_cont_P766:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain == 'NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: spade_len > 5.5
  CONDITION: auction_len > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P767:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3H'
  CONDITION: heart_len <= 3.5
  CONDITION: opp_last_call == '2H'
  CONDITION: h_stopper <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P768:
  CALL: 3NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3H'
  CONDITION: heart_len <= 3.5
  CONDITION: opp_last_call == '2H'
  CONDITION: h_stopper > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P769:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3H'
  CONDITION: heart_len <= 3.5
  CONDITION: opp_last_call != '2H'
  CONDITION: opp_bid_count <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P770:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3H'
  CONDITION: heart_len <= 3.5
  CONDITION: opp_last_call != '2H'
  CONDITION: opp_bid_count > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P771:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3H'
  CONDITION: heart_len > 3.5
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: my_side_bid_count <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P772:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3H'
  CONDITION: heart_len > 3.5
  CONDITION: combined_hcp_min <= 19.5
  CONDITION: my_side_bid_count > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P773:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3H'
  CONDITION: heart_len > 3.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: auction_len <= 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P774:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call == '3H'
  CONDITION: heart_len > 3.5
  CONDITION: combined_hcp_min > 19.5
  CONDITION: auction_len > 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P775:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3H'
  CONDITION: spade_len <= 4.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: total_points <= 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P776:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3H'
  CONDITION: spade_len <= 4.5
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: total_points > 9.5
  # distilled from Brill /bid

RULE BD_later_cont_P777:
  CALL: 3H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3H'
  CONDITION: spade_len <= 4.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P778:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3H'
  CONDITION: spade_len <= 4.5
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != 'X'
  # distilled from Brill /bid

RULE BD_later_cont_P779:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3H'
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: passes_since_last_bid <= 2.0
  # distilled from Brill /bid

RULE BD_later_cont_P780:
  CALL: 3S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3H'
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total <= 20.5
  CONDITION: passes_since_last_bid > 2.0
  # distilled from Brill /bid

RULE BD_later_cont_P781:
  CALL: 4S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3H'
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: competition_level <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P782:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level <= 3.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: last_bid_strain != 'NT'
  CONDITION: partner_last_call != '3H'
  CONDITION: spade_len > 4.5
  CONDITION: rule20_total > 20.5
  CONDITION: competition_level > 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P783:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king <= 0.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: minor_hcp <= 5.5
  CONDITION: jack_count <= 1.5
  CONDITION: minor_hcp <= 2.0
  # distilled from Brill /bid

RULE BD_later_cont_P784:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king <= 0.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: minor_hcp <= 5.5
  CONDITION: jack_count <= 1.5
  CONDITION: minor_hcp > 2.0
  # distilled from Brill /bid

RULE BD_later_cont_P785:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king <= 0.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: minor_hcp <= 5.5
  CONDITION: jack_count > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P786:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king <= 0.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: minor_hcp > 5.5
  CONDITION: spade_hcp <= 3.5
  CONDITION: d_has_jack <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P787:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king <= 0.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: minor_hcp > 5.5
  CONDITION: spade_hcp <= 3.5
  CONDITION: d_has_jack > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P788:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king <= 0.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: minor_hcp > 5.5
  CONDITION: spade_hcp > 3.5
  CONDITION: hcp <= 10.5
  # distilled from Brill /bid

RULE BD_later_cont_P789:
  CALL: 6H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king <= 0.5
  CONDITION: rule_of_21 <= 0.5
  CONDITION: minor_hcp > 5.5
  CONDITION: spade_hcp > 3.5
  CONDITION: hcp > 10.5
  # distilled from Brill /bid

RULE BD_later_cont_P790:
  CALL: 5NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king <= 0.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: auction_len <= 7.5
  CONDITION: minor_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P791:
  CALL: 5S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king <= 0.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: auction_len <= 7.5
  CONDITION: minor_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P792:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king <= 0.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: keycard_count_agreed <= 2.5
  CONDITION: auction_len > 7.5
  # distilled from Brill /bid

RULE BD_later_cont_P793:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king <= 0.5
  CONDITION: rule_of_21 > 0.5
  CONDITION: keycard_count_agreed > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P794:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king > 0.5
  CONDITION: hcp <= 14.5
  # distilled from Brill /bid

RULE BD_later_cont_P795:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king > 0.5
  CONDITION: hcp > 14.5
  CONDITION: club_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P796:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call == '4NT'
  CONDITION: h_has_king > 0.5
  CONDITION: hcp > 14.5
  CONDITION: club_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P797:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level <= 3.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: club_len <= 3.5
  CONDITION: opp_first_bid_level <= 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P798:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level <= 3.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: club_len <= 3.5
  CONDITION: opp_first_bid_level > 1.5
  # distilled from Brill /bid

RULE BD_later_cont_P799:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level <= 3.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: club_len > 3.5
  CONDITION: combined_hcp_max <= 31.5
  # distilled from Brill /bid

RULE BD_later_cont_P800:
  CALL: 5C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level <= 3.5
  CONDITION: last_bid_strain == 'C'
  CONDITION: club_len > 3.5
  CONDITION: combined_hcp_max > 31.5
  # distilled from Brill /bid

RULE BD_later_cont_P801:
  CALL: 4H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level <= 3.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: my_last_call == '1NT'
  # distilled from Brill /bid

RULE BD_later_cont_P802:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level <= 3.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain == 'D'
  CONDITION: my_last_call != '1NT'
  # distilled from Brill /bid

RULE BD_later_cont_P803:
  CALL: 5D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level <= 3.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opening_bid == '3S'
  # distilled from Brill /bid

RULE BD_later_cont_P804:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level <= 3.5
  CONDITION: last_bid_strain != 'C'
  CONDITION: last_bid_strain != 'D'
  CONDITION: opening_bid != '3S'
  # distilled from Brill /bid

RULE BD_later_cont_P805:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level > 3.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: losing_trick_count <= 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P806:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level > 3.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: partner_last_bid_strain == 'S'
  CONDITION: losing_trick_count > 5.5
  # distilled from Brill /bid

RULE BD_later_cont_P807:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level > 3.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: s_is_best_major <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P808:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level > 3.5
  CONDITION: opp_is_in_game <= 0.5
  CONDITION: partner_last_bid_strain != 'S'
  CONDITION: s_is_best_major > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P809:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level > 3.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: hcp <= 8.5
  CONDITION: is_favorable_vuln <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P810:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level > 3.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: hcp <= 8.5
  CONDITION: is_favorable_vuln > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P811:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level > 3.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: hcp > 8.5
  CONDITION: last_bid_strain == 'H'
  # distilled from Brill /bid

RULE BD_later_cont_P812:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level <= 4.5
  CONDITION: opp_contract_level > 3.5
  CONDITION: opp_is_in_game > 0.5
  CONDITION: hcp > 8.5
  CONDITION: last_bid_strain != 'H'
  # distilled from Brill /bid

RULE BD_later_cont_P813:
  CALL: 6D
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: singleton_count <= 0.5
  CONDITION: club_hcp <= 3.5
  CONDITION: hcp <= 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P814:
  CALL: 5S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: singleton_count <= 0.5
  CONDITION: club_hcp <= 3.5
  CONDITION: hcp > 13.5
  # distilled from Brill /bid

RULE BD_later_cont_P815:
  CALL: 5NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: singleton_count <= 0.5
  CONDITION: club_hcp > 3.5
  CONDITION: h_has_king <= 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P816:
  CALL: 6S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: singleton_count <= 0.5
  CONDITION: club_hcp > 3.5
  CONDITION: h_has_king > 0.5
  # distilled from Brill /bid

RULE BD_later_cont_P817:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: singleton_count > 0.5
  CONDITION: h_has_king <= 0.5
  CONDITION: spade_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P818:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: singleton_count > 0.5
  CONDITION: h_has_king <= 0.5
  CONDITION: spade_len > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P819:
  CALL: 6H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: singleton_count > 0.5
  CONDITION: h_has_king > 0.5
  CONDITION: third_longest_len <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P820:
  CALL: 5NT
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call == '4NT'
  CONDITION: singleton_count > 0.5
  CONDITION: h_has_king > 0.5
  CONDITION: third_longest_len > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P821:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: total_points <= 14.5
  CONDITION: minor_hcp <= 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P822:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: total_points <= 14.5
  CONDITION: minor_hcp > 2.5
  # distilled from Brill /bid

RULE BD_later_cont_P823:
  CALL: 5H
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: total_points > 14.5
  CONDITION: partner_last_call == '4H'
  # distilled from Brill /bid

RULE BD_later_cont_P824:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: passes_since_last_bid <= 0.5
  CONDITION: total_points > 14.5
  CONDITION: partner_last_call != '4H'
  # distilled from Brill /bid

RULE BD_later_cont_P825:
  CALL: 6C
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == '5NT'
  CONDITION: diamond_hcp <= 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P826:
  CALL: 6S
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call == '5NT'
  CONDITION: diamond_hcp > 3.5
  # distilled from Brill /bid

RULE BD_later_cont_P827:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != '5NT'
  CONDITION: my_side_bid_count <= 4.5
  # distilled from Brill /bid

RULE BD_later_cont_P828:
  CALL: PASS
  PRIORITY: 10
  CONDITION: is_opening == False
  CONDITION: opponents_bid == True
  CONDITION: last_bid_level > 1.5
  CONDITION: partner_last_call != 'PASS'
  CONDITION: last_bid_level > 2.5
  CONDITION: last_bid_level > 3.5
  CONDITION: partner_last_call != '4NT'
  CONDITION: last_bid_level > 4.5
  CONDITION: my_last_call != '4NT'
  CONDITION: passes_since_last_bid > 0.5
  CONDITION: partner_last_call != '5NT'
  CONDITION: my_side_bid_count > 4.5
  # distilled from Brill /bid
