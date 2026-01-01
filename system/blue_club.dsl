# Italian Blue Club

# ==========================================
# OPENING BIDS
# ==========================================

# 1C: Strong (17+ Unbal or 18+ Bal)
# Top Priority
OPEN 1C:
  HCP: 17+

# 4C: Weak 6-11, 8+ Clubs
OPEN 4C:
  HCP: 6-11
  LEN C: 8+

# 4D: Weak 6-11, 8+ Diamonds
OPEN 4D:
  HCP: 6-11
  LEN D: 8+

# 4H: Weak 6-11, 8+ Hearts
OPEN 4H:
  HCP: 6-11
  LEN H: 8+

# 4S: Weak 6-11, 8+ Spades
OPEN 4S:
  HCP: 6-11
  LEN S: 8+

# 3C: Normal Opening 11-16, 7+ Clubs (Very Good Suit)
OPEN 3C:
  HCP: 11-16
  LEN C: 7+

# 3D: Weak 6-11, 7+ Diamonds (Preempt)
OPEN 3D:
  HCP: 6-11
  LEN D: 7+
  SHAPE: UNBALANCED

# 3H: Weak 6-11, 7+ Hearts (Preempt)
OPEN 3H:
  HCP: 6-11
  LEN H: 7+
  SHAPE: UNBALANCED

# 3S: Weak 6-11, 7+ Spades (Preempt)
OPEN 3S:
  HCP: 6-11
  LEN S: 7+
  SHAPE: UNBALANCED

# 2D: 17-24, 4-4-4-1 (Strong Three Suiter)
OPEN 2D:
  HCP: 17-24
  SHAPE: UNBALANCED

# 2H: 6-11, Weak with 6-7 Hearts
OPEN 2H:
  HCP: 6-11
  LEN H: 6+
  SHAPE: UNBALANCED

# 2S: 6-11, Weak with 6-7 Spades
OPEN 2S:
  HCP: 6-11
  LEN S: 6+
  SHAPE: UNBALANCED

# 2NT: 21-22 Balanced
OPEN 2NT:
  HCP: 21-22
  SHAPE: BALANCED

# 2C: 11-16, Very good 5+ Clubs (Good 6 carder)
OPEN 2C:
  HCP: 11-16
  LEN C: 5+

# 1S: 11-16, 4+ Spades
OPEN 1S:
  HCP: 11-16
  LEN S: 4+

# 1H: 11-16, 4+ Hearts
OPEN 1H:
  HCP: 11-16
  LEN H: 4+

# 1D: 11-16 (May be 3 carder with C suit)
OPEN 1D:
  HCP: 11-16
  LEN D: 3+

# 1NT: 16-17 Balanced
OPEN 1NT:
  HCP: 16-17
  SHAPE: BALANCED

# ==========================================
# RESPONSES TO 1C (Control Showing)
# A=2, K=1
# ==========================================

# 1C - 1D: 0-5 HCP
1C - 1D:
  HCP: 0-5
  CONTROLS: 0-2

# 1C - 1H: 6+, Max 2 controls
1C - 1H:
  HCP: 6+
  CONTROLS: 0-2

# 1C - 1S: 3 Controls (Game Force)
1C - 1S:
  CONTROLS: 3
  HCP: 6+

# 1C - 1NT: 4 Controls (Game Force)
1C - 1NT:
  CONTROLS: 4

# 1C - 2C: 5 Controls (Game Force)
1C - 2C:
  CONTROLS: 5

# 1C - 2D: 6 Controls (Game Force)
1C - 2D:
  CONTROLS: 6

# 1C - 2NT: 7 Controls (Game Force)
1C - 2NT:
  CONTROLS: 7

# ==========================================
# RESPONSES TO 1H
# ==========================================

# 1H - 1S: 6+ HCP, 4+ Spades
1H - 1S:
  HCP: 6+
  LEN S: 4+

# 1H - 4H: To Play (Fast Arrival)
1H - 4H:
  HCP: 6-15
  LEN H: 5+

# 1H - 1NT: 8-10 HCP
1H - 1NT:
  HCP: 8-10

# 1H - 2C: 11+ HCP, 3+ Clubs (Text: "3 carder with values")
1H - 2C:
  HCP: 11+
  LEN C: 3+

# 1H - 2D: 11+ HCP, 3+ Diamonds
1H - 2D:
  HCP: 11+
  LEN D: 3+

# 1H - 2H: 6-10 HCP, 3+ Hearts (Raise)
1H - 2H:
  HCP: 6-10
  LEN H: 3+

# 1H - 2NT: 11-12 Balanced
1H - 2NT:
  HCP: 11-12
  SHAPE: BALANCED

# ==========================================
# RESPONSES TO 1S
# ==========================================

# 1S - 1NT: 8-10 HCP
1S - 1NT:
  HCP: 8-10

# 1S - 4S: To Play (Fast Arrival)
1S - 4S:
  HCP: 6-15
  LEN S: 5+

# 1S - 2C: 11+ HCP, 3+ Clubs
1S - 2C:
  HCP: 11+
  LEN C: 3+

# 1S - 2D: 11+ HCP, 3+ Diamonds
1S - 2D:
  HCP: 11+
  LEN D: 3+

# 1S - 2H: 11+ HCP, 4+ Hearts (Text: "11+ min 4 card forcing")
1S - 2H:
  HCP: 11+
  LEN H: 4+

# 1S - 2S: 6-10 HCP, 3+ Spades
1S - 2S:
  HCP: 6-10
  LEN S: 3+

# 1S - 2NT: 11-12 Balanced
1S - 2NT:
  HCP: 11-12
  SHAPE: BALANCED

# ==========================================
# RESPONSES TO 1D
# ==========================================

# 1D - 1H: 6+ HCP, 4+ Hearts
1D - 1H:
  HCP: 6+
  LEN H: 4+

# 1D - 1S: 6+ HCP, 4+ Spades
1D - 1S:
  HCP: 6+
  LEN S: 4+

# 1D - 1NT: 8-10 HCP
1D - 1NT:
  HCP: 8-10

# 1D - 2C: 11+ HCP, 3+ Clubs
1D - 2C:
  HCP: 11+
  LEN C: 3+

# 1D - 2D: 6-10 HCP, 3+ Diamonds (Raise)
1D - 2D:
  HCP: 6-10
  LEN D: 3+

# ==========================================
# RESPONSES TO 1NT
# ==========================================

# 1NT - 2C: 8-11 HCP (Relay asking range)
1NT - 2C:
  HCP: 8-11

# 1NT - 2D: 12+ Stayman (Needs 4+ Major)
# Split into H and S checks to allow skipping if no major
1NT - 2D:
  HCP: 12+
  LEN H: 4+

1NT - 2D:
  HCP: 12+
  LEN S: 4+

# 1NT - 2H: 0-7 HCP, 5+ Hearts (Weak To Play)
1NT - 2H:
  HCP: 0-7
  LEN H: 5+

# 1NT - 2S: 0-7 HCP, 5+ Spades (Weak To Play)
1NT - 2S:
  HCP: 0-7
  LEN S: 5+

# 1NT - 2NT: 10-11 Balanced
1NT - 2NT:
  HCP: 10-11
  SHAPE: BALANCED

# ==========================================
# REBIDS (Development)
# ==========================================

# --- 1C Opener Rebids ---

# 1C - 1D - 1NT: 18-20 Balanced
1C - 1D - 1NT:
  HCP: 18-20
  SHAPE: BALANCED

# 1C - 1D - 1H: Natural, 4+ (Unbalanced implied by 1C open)
1C - 1D - 1H:
  HCP: 17+
  LEN H: 4+

# 1C - 1D - 1S: Natural, 4+
1C - 1D - 1S:
  HCP: 17+
  LEN S: 4+

# 1C - 1D - 2C: 5+ Clubs (Unbalanced)
1C - 1D - 2C:
  HCP: 17+
  LEN C: 5+

# --- 1C - 1S (3 Controls) Rebids ---

# 1C - 1S - 1NT: 18-20 Balanced
# Text: "1S... 3 Controls... Opener rebids... 1NT(18-20) balanced"
1C - 1S - 1NT:
  HCP: 18-20
  SHAPE: BALANCED

# 1C - 1S - 2H: Natural 5+ (Text says "Suits are natural")
1C - 1S - 2H:
  HCP: 17+
  LEN H: 5+

# 1C - 1S - 2S: Natural 5+
1C - 1S - 2S:
  HCP: 17+
  LEN S: 5+

# 1C - 1S - 2C: Natural 5+
1C - 1S - 2C:
  HCP: 17+
  LEN C: 5+

# 1C - 1S - 2D: Natural 5+
1C - 1S - 2D:
  HCP: 17+
  LEN D: 5+

# --- 1H Opener Rebids (after 1S response) ---

# 1H - 1S - 1NT: 11-14 Balanced (Minimum)
1H - 1S - 1NT:
  HCP: 11-14
  SHAPE: BALANCED

# 1H - 1S - 2H: 11-14, 5+ Hearts (Minimum Rebid)
1H - 1S - 2H:
  HCP: 11-14
  LEN H: 5+

# 1H - 1S - 2S: 11-14, 4+ Spades (Raise)
1H - 1S - 2S:
  HCP: 11-14
  LEN S: 4+

# --- NT Game/Slam Sequences ---

# 1NT - 3NT: To Play
1NT - 3NT:
  HCP: 10-15
  SHAPE: BALANCED

# 1NT - 4NT: Quantitative (Invite 6NT)
1NT - 4NT:
  HCP: 16-17
  SHAPE: BALANCED

# 1NT - 4NT - PASS: Minimum (16) - Hand evaluates 1NT range
1NT - 4NT - PASS:
  HCP: 16

# 1NT - 4NT - 6NT: Maximum (17)
1NT - 4NT - 6NT:
  HCP: 17

# 2NT - 3NT: To Play
2NT - 3NT:
  HCP: 4-10
  SHAPE: BALANCED

# 2NT - 4NT: Quantitative
2NT - 4NT:
  HCP: 11-12
  SHAPE: BALANCED

# 1NT - 2C - 2S: 16-17 Balanced (Showing Max/Range)
1NT - 2C - 2S:
  # 2C is Relay 8-11. 2S shows 16-17.
  HCP: 16-17

# ==========================================
# SLAM BIDDING (4NT Ace Asking)
# Sequence: 1C (Strong) -> 1S (3 Controls GF) -> 4NT (Ace Ask)
# ==========================================

# 1C - 1S - 4NT: Ace Asking
1C - 1S - 4NT:
  HCP: 12+ 
  # Matches any strong hand that wants to ask aces

# 1C - 1S - 4NT - 5C: 1 or 4 Aces
1C - 1S - 4NT - 5C:
  ACES: 1,4

# 1C - 1S - 4NT - 5D: 0 or 3 Aces
1C - 1S - 4NT - 5D:
  ACES: 0,3

# 1C - 1S - 4NT - 5H: 2 Aces, Same Rank (Both Major or Both Minor)
1C - 1S - 4NT - 5H:
  ACES: 2
  ACE_TOPOLOGY: RANK

# 1C - 1S - 4NT - 5S: 2 Aces, Mixed (One Major, One Minor)
1C - 1S - 4NT - 5S:
  ACES: 2
  ACE_TOPOLOGY: MIXED

# 1C - 1S - 4NT - 5NT: 2 Aces, Same Color (Black or Red)
1C - 1S - 4NT - 5NT:
  ACES: 2
  ACE_TOPOLOGY: COLOR
