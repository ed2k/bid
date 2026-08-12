# GIB System (Subset)

# ==========================================
# OPENING BIDS
# ==========================================

# 1NT Opening: 15-17 Balanced
OPEN 1NT:
  HCP: 15-17
  SHAPE: BALANCED

# 1H Opening: 5+ Hearts, 12-21 HCP
OPEN 1H:
  HCP: 12-21
  LEN H: 5+

# 1S Opening: 5+ Spades, 12-21 HCP
OPEN 1S:
  HCP: 12-21
  LEN S: 5+

# 1C Opening: 3+ Clubs (Better Minor), 12-21 HCP
OPEN 1C:
  HCP: 12-21
  LEN C: 3+

# 1D Opening: 4+ Diamonds (3+ if 4432)
OPEN 1D:
  HCP: 12-21
  LEN D: 3+

# 2C Opening: Strong, Artificial, 22+ HCP
OPEN 2C:
  HCP: 22+

# Weak 2 Bids: 6-10 HCP, 6+ suit
OPEN 2D:
  HCP: 6-10
  LEN D: 6+
  SHAPE: UNBALANCED

OPEN 2H:
  HCP: 6-10
  LEN H: 6+
  SHAPE: UNBALANCED

OPEN 2S:
  HCP: 6-10
  LEN S: 6+
  SHAPE: UNBALANCED

# 2NT Opening: 20-21 Balanced
OPEN 2NT:
  HCP: 20-21
  SHAPE: BALANCED

# ==========================================
# RESPONSES TO 1NT
# ==========================================

# Stayman: 1NT - 2C
1NT - 2C:
  TP: 8+

# Opener Rebids to Stayman
1NT - 2C - 2D:
  LEN H: 0-3
  LEN S: 0-3

1NT - 2C - 2H:
  LEN H: 4+

1NT - 2C - 2S:
  LEN S: 4+
  LEN H: 0-3

# Splinters after Stayman
1NT - 2C - 2H - 4C:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 10+
  LEN H: 4+
  LEN C: 0-1
  SHAPE: UNBALANCED

1NT - 2C - 2H - 4D:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 10+
  LEN H: 4+
  LEN D: 0-1
  SHAPE: UNBALANCED

1NT - 2C - 2S - 4C:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 10+
  LEN S: 4+
  LEN C: 0-1
  SHAPE: UNBALANCED

1NT - 2C - 2S - 4D:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 10+
  LEN S: 4+
  LEN D: 0-1
  SHAPE: UNBALANCED

1NT - 2C - 2S - 4H:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 10+
  LEN S: 4+
  LEN H: 0-1
  SHAPE: UNBALANCED

# Jacoby Transfer to Hearts: 1NT - 2D
1NT - 2D:
  LEN H: 5+
  TP: 0-99

# Opener Accept Transfer
1NT - 2D - 2H:
  LEN H: 2+ 

# Splinters after Transfer to Hearts (6+ Hearts)
1NT - 2D - 2H - 3S:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 10+
  LEN H: 6+
  LEN S: 0-1
  SHAPE: UNBALANCED

1NT - 2D - 2H - 4C:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 10+
  LEN H: 6+
  LEN C: 0-1
  SHAPE: UNBALANCED

1NT - 2D - 2H - 4D:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 10+
  LEN H: 6+
  LEN D: 0-1
  SHAPE: UNBALANCED

# Jacoby Transfer to Spades: 1NT - 2H
1NT - 2H:
  LEN S: 5+
  TP: 0-99

# Opener Accept Transfer
1NT - 2H - 2S:
  LEN S: 2+

# Splinters after Transfer to Spades (6+ Spades)
1NT - 2H - 2S - 4C:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 10+
  LEN S: 6+
  LEN C: 0-1
  SHAPE: UNBALANCED

1NT - 2H - 2S - 4D:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 10+
  LEN S: 6+
  LEN D: 0-1
  SHAPE: UNBALANCED

1NT - 2H - 2S - 4H:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 10+
  LEN S: 6+
  LEN H: 0-1
  SHAPE: UNBALANCED

# Minor Suit Stayman: 1NT - 2S
1NT - 2S:
  LEN C: 4+
  LEN D: 4+
  TP: 10+

# ==========================================
# RESPONSES TO 1-MAJOR (2/1 System)
# ==========================================

# --- Responses to 1H ---

# 1H Splinters (4+ Hearts, Shortness 0-1, Game Forcing / Slam Interest)
1H - 3S:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 15
  HCP: 10-14
  LEN H: 4+
  LEN S: 0-1
  SHAPE: UNBALANCED

1H - 4C:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 15
  HCP: 10-14
  LEN H: 4+
  LEN C: 0-1
  SHAPE: UNBALANCED

1H - 4D:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 15
  HCP: 10-14
  LEN H: 4+
  LEN D: 0-1
  SHAPE: UNBALANCED

# 1H - 1NT: Forcing (Semi-forcing)
1H - 1NT:
  HCP: 6-12
  LEN S: 0-3
  LEN H: 0-2

# 1H - 1S: Natural, 4+ Spades
1H - 1S:
  HCP: 6+
  LEN S: 4+

# Opener Splinter rebid after 1H - 1S (4+ Spades, 5+ Hearts, Club shortness 0-1, 16+ HCP)
1H - 1S - 4C:
  CONVENTION: Opener_Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 16+
  LEN H: 5+
  LEN S: 4+
  LEN C: 0-1
  SHAPE: UNBALANCED

# RKCB 4NT after Opener Splinter 1H - 1S - 4C (MAJOR_HCP 8+ working values)
1H - 1S - 4C - 4NT:
  CONVENTION: RKCB
  PRIORITY_BONUS: 15
  MAJOR_HCP: 8+
  LEN S: 5+

# Opener RKCB response to 4NT: 5C (3 keycards: SA, HA, DA)
1H - 1S - 4C - 4NT - 5C:
  CONVENTION: RKCB_Response_03
  PRIORITY_BONUS: 10
  ACES: 3

# Responder 5NT Grand Slam Ask
1H - 1S - 4C - 4NT - 5C - 5NT:
  CONVENTION: GrandSlam_Ask
  PRIORITY_BONUS: 10
  MAJOR_HCP: 8+

# Opener 7S Grand Slam bid
1H - 1S - 4C - 4NT - 5C - 5NT - 7S:
  CONVENTION: GrandSlam_Bid
  PRIORITY_BONUS: 10
  HCP: 16+
  LEN S: 4+
  LEN H: 5+

# Responder Cuebid after Opener Splinter (MAJOR_HCP 6-7 working values)
1H - 1S - 4C - 4H:
  BID_CLASS: CUEBID
  CUEBID_TYPE: ControlCue
  CUE_TARGET: AGREED_SUIT
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 10
  MAJOR_HCP: 6-7
  LEN S: 4+

# Opener Slam jump after 1H - 1S - 4C - 4H
1H - 1S - 4C - 4H - 6S:
  CONVENTION: Slam_Jump
  PRIORITY_BONUS: 5
  HCP: 16+
  LEN S: 4+
  LEN H: 5+

# Responder Sign-off in 4S after Opener Splinter 1H - 1S - 4C (wasted club values / MAJOR_HCP 0-5)
1H - 1S - 4C - 4S:
  CONVENTION: Splinter_Signoff
  PRIORITY_BONUS: 5
  MAJOR_HCP: 0-5
  LEN S: 4+

# 1H - 2C: 2/1 Game Force
1H - 2C:
  HCP: 12+
  LEN C: 3+

# 1H - 2D: 2/1 Game Force
1H - 2D:
  HCP: 12+
  LEN D: 3+

# 1H - 2H: Simple Raise
1H - 2H:
  HCP: 6-9
  TP: 6-10
  LEN H: 3+

# --- Responses to 1S ---

# 1S Splinters (4+ Spades, Shortness 0-1, Game Forcing / Slam Interest)
1S - 4C:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 15
  HCP: 10-14
  LEN S: 4+
  LEN C: 0-1
  SHAPE: UNBALANCED

1S - 4D:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 15
  HCP: 10-14
  LEN S: 4+
  LEN D: 0-1
  SHAPE: UNBALANCED

1S - 4H:
  CONVENTION: Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 15
  HCP: 10-14
  LEN S: 4+
  LEN H: 0-1
  SHAPE: UNBALANCED

# 1S - 1NT: Forcing
1S - 1NT:
  HCP: 6-12
  LEN S: 0-2

# 1S - 2C: 2/1 Game Force
1S - 2C:
  HCP: 12+
  LEN C: 3+

# 1S - 2D: 2/1 Game Force
1S - 2D:
  HCP: 12+
  LEN D: 3+

# 1S - 2H: 2/1 Game Force (5+ Hearts)
1S - 2H:
  HCP: 12+
  LEN H: 5+

# 1S - 2S: Simple Raise
1S - 2S:
  HCP: 6-9
  TP: 6-10
  LEN S: 3+

# ==========================================
# RESPONSES TO 1-MINOR
# ==========================================

# --- Responses to 1C ---

# 1C - 1D: Natural, 4+ Diamonds, 6+ HCP
1C - 1D:
  HCP: 6+
  LEN D: 4+
  LEN H: 0-3
  LEN S: 0-3

# 1C - 1H: Natural, 4+ Hearts, 6+ HCP
1C - 1H:
  HCP: 6+
  LEN H: 4+

# 1C - 1S: Natural, 4+ Spades, 6+ HCP
1C - 1S:
  HCP: 6+
  LEN S: 4+

# 1C - 1NT: Balanced, 6-10 HCP, No major
1C - 1NT:
  HCP: 6-10
  LEN H: 0-3
  LEN S: 0-3
  SHAPE: BALANCED

# 1C - 2C: Inverted Minor (Forcing, 10+ HCP)
1C - 2C:
  HCP: 10+
  LEN C: 4+
  LEN H: 0-3
  LEN S: 0-3

# --- Responses to 1D ---

# 1D - 1H: Natural, 4+ Hearts
1D - 1H:
  HCP: 6+
  LEN H: 4+

# 1D - 1S: Natural, 4+ Spades
1D - 1S:
  HCP: 6+
  LEN S: 4+

# 1D - 1NT: Balanced, 6-10 HCP, No major
1D - 1NT:
  HCP: 6-10
  LEN H: 0-3
  LEN S: 0-3
  SHAPE: BALANCED

# 1D - 2C: Game Forcing (12+ HCP, 4+ Clubs)
1D - 2C:
  HCP: 13+
  LEN C: 4+

# 1D - 2D: Inverted Minor (Forcing, 10+ HCP)
1D - 2D:
  HCP: 10+
  LEN D: 4+
  LEN H: 0-3
  LEN S: 0-3

# ==========================================
# RESPONSES TO 2NT
# ==========================================

# 2NT - 3C: Stayman
2NT - 3C:
  TP: 5+

# 2NT - 3D: Transfer to Hearts
2NT - 3D:
  LEN H: 5+

# 2NT - 3H: Transfer to Spades
2NT - 3H:
  LEN S: 5+

# ==========================================
# ACTIVE CONVENTIONS & EXPANDED GIB STRUCTURES
# ==========================================

# 1M - 3M Inviting (Limit Raise)
1H - 3H:
  CONVENTION: Limit_Raise
  HCP: 10-12
  LEN H: 3+

1S - 3S:
  CONVENTION: Limit_Raise
  HCP: 10-12
  LEN S: 3+

# Jacoby 2NT (Game Forcing Major Raise)
1H - 2NT:
  CONVENTION: Jacoby_2NT
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 13+
  LEN H: 4+
  LEN C: 2+
  LEN D: 2+
  LEN S: 2+

1S - 2NT:
  CONVENTION: Jacoby_2NT
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 13+
  LEN S: 4+
  LEN C: 2+
  LEN D: 2+
  LEN H: 2+

# Reverse Drury by Passed Hand
(P) - 1H - 2C:
  CONVENTION: Reverse_Drury
  HCP: 10-12
  LEN H: 3+

(P) - 1S - 2C:
  CONVENTION: Reverse_Drury
  HCP: 10-12
  LEN S: 3+

(P) - 1H - 2C - 2H:
  CONVENTION: Drury_Subminimum
  HCP: 12-13

(P) - 1H - 2C - 2D:
  CONVENTION: Drury_FullOpening
  HCP: 14+

# Soloway Jump Shifts (Level 2, 17+ HCP)
1C - 2H:
  CONVENTION: Soloway_Jump_Shift
  FORCING: GAME_FORCING
  HCP: 17+
  LEN H: 5+

1C - 2S:
  CONVENTION: Soloway_Jump_Shift
  FORCING: GAME_FORCING
  HCP: 17+
  LEN S: 5+

1D - 2S:
  CONVENTION: Soloway_Jump_Shift
  FORCING: GAME_FORCING
  HCP: 17+
  LEN S: 5+

1H - 2S:
  CONVENTION: Soloway_Jump_Shift
  FORCING: GAME_FORCING
  HCP: 17+
  LEN S: 5+

# Inviting Jump Shifts (Level 3, 9-11 HCP)
1H - 3C:
  CONVENTION: Inviting_Jump_Shift
  HCP: 9-11
  LEN C: 6+

1H - 3D:
  CONVENTION: Inviting_Jump_Shift
  HCP: 9-11
  LEN D: 6+

1S - 3C:
  CONVENTION: Inviting_Jump_Shift
  HCP: 9-11
  LEN C: 6+

1S - 3D:
  CONVENTION: Inviting_Jump_Shift
  HCP: 9-11
  LEN D: 6+

# Mixed Raise (6-8 HCP, 4 trumps)
1H - 3C:
  CONVENTION: Mixed_Raise
  HCP: 6-8
  LEN H: 4+
  SHAPE: UNBALANCED

1S - 3C:
  CONVENTION: Mixed_Raise
  HCP: 6-8
  LEN S: 4+
  SHAPE: UNBALANCED

# Checkback & New Minor Forcing (NMF)
1C - 1H - 1NT - 2D:
  CONVENTION: New_Minor_Forcing
  FORCING: ONE_ROUND
  HCP: 11+

1C - 1S - 1NT - 2D:
  CONVENTION: New_Minor_Forcing
  FORCING: ONE_ROUND
  HCP: 11+

1D - 1H - 1NT - 2C:
  CONVENTION: Checkback
  FORCING: ONE_ROUND
  HCP: 11+

1D - 1S - 1NT - 2C:
  CONVENTION: Checkback
  FORCING: ONE_ROUND
  HCP: 11+

# NMF after 2NT Rebid
1C - 1H - 2NT - 3D:
  CONVENTION: NMF_After_2NT
  FORCING: GAME_FORCING
  HCP: 6+

1D - 1H - 2NT - 3C:
  CONVENTION: NMF_After_2NT
  FORCING: GAME_FORCING
  HCP: 6+

# Fourth Suit Game Force
1C - 1D - 1H - 1S:
  CONVENTION: Fourth_Suit_GF
  FORCING: GAME_FORCING
  HCP: 12+

1D - 1H - 1S - 2C:
  CONVENTION: Fourth_Suit_GF
  FORCING: GAME_FORCING
  HCP: 12+

# Gerber 4C Ace Ask
1NT - 4C:
  CONVENTION: Gerber
  FORCING: GAME_FORCING
  HCP: 15+

2NT - 4C:
  CONVENTION: Gerber
  FORCING: GAME_FORCING
  HCP: 13+

1NT - 4C - 4D:
  CONVENTION: Gerber_Response_04
  ACES: 0

1NT - 4C - 4H:
  CONVENTION: Gerber_Response_1
  ACES: 1

1NT - 4C - 4S:
  CONVENTION: Gerber_Response_2
  ACES: 2

1NT - 4C - 4NT:
  CONVENTION: Gerber_Response_3
  ACES: 3

# Quantitative 4NT
1NT - 4NT:
  CONVENTION: Quantitative_4NT
  HCP: 16-17

2NT - 4NT:
  CONVENTION: Quantitative_4NT
  HCP: 11-12

# Texas Transfers
1NT - 4C:
  CONVENTION: Texas_Transfer
  LEN H: 6+
  TP: 10+

1NT - 4D:
  CONVENTION: Texas_Transfer
  LEN S: 6+
  TP: 10+

# 1NT - 3C Transfer to Diamonds
1NT - 3C:
  CONVENTION: Transfer_To_Diamonds
  LEN D: 6+
  TP: 10+

# SMOLEN (5-4 Majors)
1NT - 2C - 2D - 3H:
  CONVENTION: Smolen
  FORCING: GAME_FORCING
  LEN S: 5+
  LEN H: 4

1NT - 2C - 2D - 3S:
  CONVENTION: Smolen
  FORCING: GAME_FORCING
  LEN H: 5+
  LEN S: 4

# Super Acceptance
1NT - 2D - 3H:
  CONVENTION: Super_Acceptance
  HCP: 17
  LEN H: 4+

1NT - 2H - 3S:
  CONVENTION: Super_Acceptance
  HCP: 17
  LEN S: 4+

# Michaels Cuebid
(1C) - 2C:
  CONVENTION: Michaels_Cuebid
  HCP: 8+
  LEN H: 5+
  LEN S: 5+

(1D) - 2D:
  CONVENTION: Michaels_Cuebid
  HCP: 8+
  LEN H: 5+
  LEN S: 5+

(1H) - 2H:
  CONVENTION: Michaels_Cuebid
  HCP: 8+
  LEN S: 5+
  LEN C: 5+

(1S) - 2S:
  CONVENTION: Michaels_Cuebid
  HCP: 8+
  LEN H: 5+
  LEN C: 5+

# Unusual 2NT
(1C) - 2NT:
  CONVENTION: Unusual_2NT
  HCP: 8+
  LEN D: 5+
  LEN H: 5+

(1D) - 2NT:
  CONVENTION: Unusual_2NT
  HCP: 8+
  LEN C: 5+
  LEN H: 5+

(1H) - 2NT:
  CONVENTION: Unusual_2NT
  HCP: 8+
  LEN C: 5+
  LEN D: 5+

(1S) - 2NT:
  CONVENTION: Unusual_2NT
  HCP: 8+
  LEN C: 5+
  LEN D: 5+

# Unusual 1NT / 3NT / 4NT
(1H) - 1NT:
  CONVENTION: Unusual_1NT
  HCP: 10-15
  LEN C: 5+
  LEN D: 5+

(1S) - 1NT:
  CONVENTION: Unusual_1NT
  HCP: 10-15
  LEN C: 5+
  LEN D: 5+

(1H) - 3NT:
  CONVENTION: Unusual_3NT
  LEN C: 5+
  LEN D: 5+

(1S) - 4NT:
  CONVENTION: Unusual_4NT
  LEN C: 5+
  LEN D: 5+

# Unusual vs Unusual
(1H) - (2NT) - 3C:
  CONVENTION: Unusual_vs_Unusual
  FORCING: GAME_FORCING
  LEN H: 3+

(1H) - (2NT) - 3D:
  CONVENTION: Unusual_vs_Unusual
  FORCING: GAME_FORCING
  LEN S: 5+

# Cappelletti vs 1NT
(1NT) - Dbl:
  CONVENTION: Cappelletti_Penalty
  HCP: 15+

(1NT) - 2C:
  CONVENTION: Cappelletti_SingleSuit
  HCP: 10+
  LEN C: 6+

(1NT) - 2D:
  CONVENTION: Cappelletti_BothMajors
  HCP: 10+
  LEN H: 4+
  LEN S: 4+

(1NT) - 2H:
  CONVENTION: Cappelletti_MajorMinor
  HCP: 10+
  LEN H: 5+
  LEN C: 5+

(1NT) - 2S:
  CONVENTION: Cappelletti_MajorMinor
  HCP: 10+
  LEN S: 5+
  LEN C: 5+

(1NT) - 2NT:
  CONVENTION: Cappelletti_BothMinors
  HCP: 10+
  LEN C: 5+
  LEN D: 5+

# Lebensohl after Double of Weak Two
(2H) - Dbl - 2NT:
  CONVENTION: Lebensohl_Relay
  HCP: 0-7

(2H) - Dbl - 2NT - 3C:
  CONVENTION: Lebensohl_Relay_Accept
  HCP: 12+

(2H) - Dbl - 3C:
  CONVENTION: Lebensohl_Direct_Constructive
  HCP: 8-11
  LEN C: 4+

# Support Double
1C - 1H - (1S) - Dbl:
  CONVENTION: Support_Double
  HCP: 12-17
  LEN H: 3

1D - 1H - (1S) - Dbl:
  CONVENTION: Support_Double
  HCP: 12-17
  LEN H: 3

# Responsive Double & Snapdragon Double
(1D) - Dbl - (2D) - Dbl:
  CONVENTION: Responsive_Double
  HCP: 8+
  LEN H: 4+
  LEN S: 4+

1C - (1D) - 1H - (1S) - Dbl:
  CONVENTION: Snapdragon_Double
  HCP: 8+
  LEN S: 5+

# DOPI & ROPI
1H - 4NT - (5C) - Dbl:
  CONVENTION: DOPI
  ACES: 0

1H - 4NT - (5C) - Pass:
  CONVENTION: DOPI
  ACES: 1

1H - 4NT - (Dbl) - Rdbl:
  CONVENTION: ROPI
  ACES: 0

1H - 4NT - (Dbl) - Pass:
  CONVENTION: ROPI
  ACES: 1

# Exclusion RKCB
1H - 5C:
  CONVENTION: Exclusion_RKCB
  PRIORITY_BONUS: 10
  LEN H: 4+
  LEN C: 0

# Minor Direct Jump Cuebid Gambling
(1C) - 3C:
  CONVENTION: Jump_Cuebid_Gambling
  HCP: 15+
  LEN C: 7+

(1D) - 3D:
  CONVENTION: Jump_Cuebid_Gambling
  HCP: 15+
  LEN D: 7+

# 1X-(1Y)-2Z Strong
1C - (1D) - 2S:
  CONVENTION: Jump_Shift_Strong
  FORCING: GAME_FORCING
  HCP: 16+
  LEN S: 5+

# Natural 3NT Overcall
(1H) - 3NT:
  CONVENTION: Natural_3NT_Overcall
  HCP: 16-18
  SHAPE: BALANCED
  LEN H: 2+

