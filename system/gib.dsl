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

# Jacoby Transfer to Hearts: 1NT - 2D
1NT - 2D:
  LEN H: 5+
  TP: 0-99

# Opener Accept Transfer
1NT - 2D - 2H:
  LEN H: 2+ 

# Jacoby Transfer to Spades: 1NT - 2H
1NT - 2H:
  LEN S: 5+
  TP: 0-99

# Opener Accept Transfer
1NT - 2H - 2S:
  LEN S: 2+

# Minor Suit Stayman: 1NT - 2S
1NT - 2S:
  LEN C: 4+
  LEN D: 4+
  TP: 10+

# ==========================================
# RESPONSES TO 1-MAJOR (2/1 System)
# ==========================================

# --- Responses to 1H ---

# 1H - 1NT: Forcing (Semi-forcing)
1H - 1NT:
  HCP: 6-12
  LEN S: 0-3
  LEN H: 0-2

# 1H - 1S: Natural, 4+ Spades
1H - 1S:
  HCP: 6+
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
