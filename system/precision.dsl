# Precision Big Club (Based on Precision.txt)

# ==========================================
# OPENING BIDS
# ==========================================

# 1C: Strong (16+ HCP)
# Note: Text says 16+ or very good 15. We'll stick to 16+ for simplicity or 16-37.
OPEN 1C:
  HCP: 16+

# 2N: 22-23 HCP Balanced
OPEN 2NT:
  HCP: 22-23
  SHAPE: BALANCED

# 2C: 11-15 HCP, 6+ Clubs
# Text: "11-15 HCP with 6+ Clubs maybe with 4-5 card major"
OPEN 2C:
  HCP: 11-15
  LEN C: 6+

# 2D: 11-15 HCP, Three Suiter with Short Diamonds
# Text: "11-15 HCP with a three suited hand with shortness in Diamonds"
# Usually 4-4-1-4, 4-4-0-5, 4-3-1-5, 3-4-1-5.
# We will approximate as 11-15, Unbalanced, 0-1 Diamonds, 3+ Support in others?
# Or just exclude balanced and ensure short Diamonds.
OPEN 2D:
  HCP: 11-15
  LEN D: 0-1
  SHAPE: UNBALANCED

# 1NT: 10-12 HCP Balanced (1st/2nd/3rd seat)
OPEN 1NT:
  HCP: 10-12
  SHAPE: BALANCED

# 1H/1S: 11-15 HCP, 5+ Major
OPEN 1H:
  HCP: 11-15
  LEN H: 5+

OPEN 1S:
  HCP: 11-15
  LEN S: 5+

# 1D: 11-15 HCP, 2+ Diamonds
# "11-15 HCP with 2+ Diamonds" - Catch-all for hands not opening 1H/1S/1N/2C/2D
OPEN 1D:
  HCP: 11-15
  LEN D: 2+

# 2H/2S: Weak Two (5-10 HCP, 6+ Suit)
OPEN 2H:
  HCP: 5-10
  LEN H: 6+

OPEN 2S:
  HCP: 5-10
  LEN S: 6+

# 3-Level Preempts (Standard)
OPEN 3C:
  HCP: 6-10
  LEN C: 7+

OPEN 3D:
  HCP: 6-10
  LEN D: 7+

OPEN 3H:
  HCP: 6-10
  LEN H: 7+

OPEN 3S:
  HCP: 6-10
  LEN S: 7+

# ==========================================
# RESPONSES TO 1C
# ==========================================

# 1C - 1D: Negative (0-7 HCP)
1C - 1D:
  HCP: 0-7

# 1C - 1H/1S: Positive (8+ HCP, 5+ Suit)
1C - 1H:
  HCP: 8+
  LEN H: 5+

1C - 1S:
  HCP: 8+
  LEN S: 5+

# 1C - 1NT: Positive Balanced (8-13 HCP)
# Text: "8-13 HCP, balanced (5 in minor okay but not major)"
1C - 1NT:
  HCP: 8-13
  SHAPE: BALANCED

# 1C - 2C/2D: Positive (8+ HCP, 5+ Suit)
1C - 2C:
  HCP: 8+
  LEN C: 5+

1C - 2D:
  HCP: 8+
  LEN D: 5+

# 1C - 2H/2S: Weak (4-6 HCP, 6+ Suit) - "Disciplined Preemptive"
1C - 2H:
  HCP: 4-6
  LEN H: 6+

1C - 2S:
  HCP: 4-6
  LEN S: 6+

# 1C - 2NT: 14+ HCP Balanced
1C - 2NT:
  HCP: 14+
  SHAPE: BALANCED

# ==========================================
# RESPONSES TO 1NT (10-12)
# ==========================================

# 1NT - 2D: Forcing Stayman (Game Force)
1NT - 2D:
  HCP: 13+
  LEN H: 4+ # Asking for major
1NT - 2D:
  HCP: 13+
  LEN S: 4+

# 1NT - 2C: Invitational / Garbage Stayman
# Handling "Game Invitational, denies 4 major" AND "Crawling Stayman" is complex.
# We'll define it as 8-12 HCP general check or weak with shortness.
# For simplicity in this DSL: 7-12 HCP range (Invite+).
1NT - 2C:
  HCP: 7-12

# 1NT - 2H/2S: To Play (Weak)
1NT - 2H:
  HCP: 0-7
  LEN H: 5+

1NT - 2S:
  HCP: 0-7
  LEN S: 5+

# 1NT - 3H/3S: Game Forcing 5-carder
1NT - 3H:
  HCP: 13+
  LEN H: 5+

1NT - 3S:
  HCP: 13+
  LEN S: 5+

# ==========================================
# REBIDS AFTER 1C - 1D (Negative)
# ==========================================

# 1C - 1D - 1NT: 16-19 Balanced
1C - 1D - 1NT:
  HCP: 16-19
  SHAPE: BALANCED

# 1C - 1D - 1H/1S: Non-Forcing 17+ (5+ Suit)
# Text says: "1H/S ... 5+ card suit ... Non-forcing"
# Note: 1C is 16+. 1D is 0-7.
# If play is NF, range is probably capped? Or just describing hand.
# We'll assume standard natural rebid showing the suit.
1C - 1D - 1H:
  HCP: 16+
  LEN H: 5+

1C - 1D - 1S:
  HCP: 16+
  LEN S: 5+

# 1C - 1D - 2C/2D: Non-Forcing 17+ (5+ Suit)
1C - 1D - 2C:
  HCP: 16+
  LEN C: 5+

1C - 1D - 2D:
  HCP: 16+
  LEN D: 5+

# 1C - 1D - 2NT: 20-21 Balanced
1C - 1D - 2NT:
  HCP: 20-21
  SHAPE: BALANCED

# 1C - 1D - 2H/2S: Forcing (Very Strong, 0-4 LTC, 5+ Suit)
# "Equivalent to 2C opener in normal systems"
# We'll put high HCP requirement or just assume Jump Shift nature.
# Since DSL parses in order, Jumps must be distinct.
# If 1C-1D-1H is 16+, 1C-1D-2H (Jump) must be stronger/distinct.
# Text says "Forcing".
1C - 1D - 2H:
  HCP: 22+
  LEN H: 5+

1C - 1D - 2S:
  HCP: 22+
  LEN S: 5+

# 1C - 1D - 3NT: 24-26 Balanced
1C - 1D - 3NT:
  HCP: 24-26
  SHAPE: BALANCED

# ==========================================
# OTHER OPENING RESPONSES (Simple Natural)
# ==========================================

# 1D - 1H/1S: 6+ HCP, 4+ Suit
1D - 1H:
  HCP: 6+
  LEN H: 4+

1D - 1S:
  HCP: 6+
  LEN S: 4+

# 1D - 1NT: 8-10 HCP (Standard-ish)
# Text for 1D responses not explicitly detailed in full list but implied standard positive.
# 1N (10-12) -> 1D opening handles 11-15 unbal or 2+D.
# Responder 6+ bids suit. 
1D - 1NT:
  HCP: 6-10
  SHAPE: BALANCED

# ==========================================
# DEFENSIVE BIDDING (Opponent Opened Suit)
# ==========================================

# (1x) - Simple Overcall: 11-15 HCP, 5+ Major
(1C) - 1H:
  HCP: 11-15
  LEN H: 5+
(1C) - 1S:
  HCP: 11-15
  LEN S: 5+

(1D) - 1H:
  HCP: 11-15
  LEN H: 5+
(1D) - 1S:
  HCP: 11-15
  LEN S: 5+

(1H) - 1S:
  HCP: 11-15
  LEN S: 5+

# (1x) - 1NT: 16-18 Balanced, Stopper (approximated as balanced strength in DSL)
(1C) - 1NT:
  HCP: 16-18
  SHAPE: BALANCED
(1D) - 1NT:
  HCP: 16-18
  SHAPE: BALANCED
(1H) - 1NT:
  HCP: 16-18
  SHAPE: BALANCED
(1S) - 1NT:
  HCP: 16-18
  SHAPE: BALANCED

# (1x) - Cuebid: 14+ HCP, 5-5 Two Suiter (Michaels)
# (1C) - 2C
(1C) - 2C:
  HCP: 14+
  LEN H: 5+
  LEN S: 5+

# (1D) - 2D
(1D) - 2D:
  HCP: 14+
  LEN H: 5+
  LEN S: 5+

# (1H) - 2H (5-5 Spades + Minor)
(1H) - 2H:
  HCP: 14+
  LEN S: 5+

# (1S) - 2S (5-5 Hearts + Minor)
(1S) - 2S:
  HCP: 14+
  LEN H: 5+

# (1x) - Double: Takeout (13+ HCP)
# DSL doesn't support complex takeout logic (shortness check) easily without custom predicates.
# We will use basic HCP and Support assumption logic or just HCP 13+.
# Text says "13 pts, support in all other suits".
(1C) - X:
  HCP: 13+
  LEN C: 0-2
(1D) - X:
  HCP: 13+
  LEN D: 0-2
(1H) - X:
  HCP: 13+
  LEN H: 0-2
(1S) - X:
  HCP: 13+
  LEN S: 0-2

# ==========================================
# DEFENSIVE BIDDING (Opponent Opened 1NT)
# ==========================================

# (1NT) - X: Balanced, same strength or penalty (16+)
# Assuming strong NT opponent (15-17).
(1NT) - X:
  HCP: 16+

# (1NT) - 2C: 5-5 Minors
(1NT) - 2C:
  LEN C: 5+
  LEN D: 5+

# (1NT) - 2D: 5-5 Majors
(1NT) - 2D:
  LEN H: 5+
  LEN S: 5+

# (1NT) - 2H/2S: Natural 6+
(1NT) - 2H:
  LEN H: 6+
(1NT) - 2S:
  LEN S: 6+
