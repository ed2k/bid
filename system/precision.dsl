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

# Explicit PASS: everything below the openings above (0-10 HCP without a
# 6-card major, 7+ carder or balanced 10).  Judgment: txt openings start at
# 5-10 (weak two), 6-10 (preempt) and 10-12 (1NT) - weaker hands pass by
# design; made explicit so the engine never falls through silently.
OPEN PASS:
  HCP: 0-10

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

# Opener Splinter rebid after 1C - 1S (4+ Spades, 5+ Hearts, Club shortness 0-1, 16+ HCP)
1C - 1S - 4C:
  CONVENTION: Opener_Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  HCP: 16+
  LEN H: 5+
  LEN S: 4+
  LEN C: 0-1
  SHAPE: UNBALANCED

# RKCB 4NT after Opener Splinter 1C - 1S - 4C (MAJOR_HCP 8+ working values)
1C - 1S - 4C - 4NT:
  CONVENTION: RKCB
  PRIORITY_BONUS: 15
  MAJOR_HCP: 8+
  LEN S: 5+

# Opener RKCB response to 4NT: 5C (3 keycards: SA, HA, DA)
1C - 1S - 4C - 4NT - 5C:
  CONVENTION: RKCB_Response_03
  PRIORITY_BONUS: 10
  ACES: 3

# Responder 5NT Grand Slam Ask
1C - 1S - 4C - 4NT - 5C - 5NT:
  CONVENTION: GrandSlam_Ask
  PRIORITY_BONUS: 10
  MAJOR_HCP: 8+

# Opener 7S Grand Slam bid
1C - 1S - 4C - 4NT - 5C - 5NT - 7S:
  CONVENTION: GrandSlam_Bid
  PRIORITY_BONUS: 10
  HCP: 16+
  LEN S: 4+
  LEN H: 5+

# Responder Cuebid after Opener Splinter (MAJOR_HCP 6-7 working values)
1C - 1S - 4C - 4H:
  BID_CLASS: CUEBID
  CUEBID_TYPE: ControlCue
  CUE_TARGET: AGREED_SUIT
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 10
  MAJOR_HCP: 6-7
  LEN S: 4+

# Opener Slam jump after 1C - 1S - 4C - 4H
1C - 1S - 4C - 4H - 6S:
  CONVENTION: Slam_Jump
  PRIORITY_BONUS: 5
  HCP: 16+
  LEN S: 4+
  LEN H: 5+

# Responder Sign-off in 4S after Opener Splinter 1C - 1S - 4C (wasted club values / MAJOR_HCP 0-5)
1C - 1S - 4C - 4S:
  CONVENTION: Splinter_Signoff
  PRIORITY_BONUS: 5
  MAJOR_HCP: 0-5
  LEN S: 4+

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

# 1C - 2NT: 14+ HCP Balanced and 4+ Controls
# Text: "14+ HCP, balanced and 4+ controls"
1C - 2NT:
  HCP: 14+
  SHAPE: BALANCED
  CONTROLS: 4+

# 1C - 3C: Black shortage (1=4=4=4 or 4=4=4=1), < 4 controls
# Text: "mostly < 12 HCP" - 0-7 always bids the 1D negative (rule above wins ties)
1C - 3C:
  HCP: 8+
  CONTROLS: 0-3
  LEN C: 0-1
  LEN H: 4
  LEN S: 4
  LEN D: 4

# 1C - 3D: Red shortage (D or H singleton), < 4 controls
1C - 3D:
  HCP: 8+
  CONTROLS: 0-3
  LEN D: 0-1
  LEN H: 4
  LEN S: 4
  LEN C: 4
1C - 3D:
  HCP: 8+
  CONTROLS: 0-3
  LEN H: 0-1
  LEN S: 4
  LEN D: 4
  LEN C: 4

# 1C - 3H: Spade shortage (1=4=4=4), 12+ HCP, 4+ controls
1C - 3H:
  HCP: 12+
  CONTROLS: 4+
  LEN S: 0-1
  LEN H: 4
  LEN D: 4
  LEN C: 4

# 1C - 3S: Club shortage (4=4=4=1), 12+ HCP, 4+ controls
1C - 3S:
  HCP: 12+
  CONTROLS: 4+
  LEN C: 0-1
  LEN H: 4
  LEN S: 4
  LEN D: 4

# 1C - 4C: Diamond shortage (4=4=1=4), 12+ HCP, 4+ controls
1C - 4C:
  HCP: 12+
  CONTROLS: 4+
  LEN D: 0-1
  LEN H: 4
  LEN S: 4
  LEN C: 4

# 1C - 4D: Heart shortage (4=1=4=4), 12+ HCP, 4+ controls
1C - 4D:
  HCP: 12+
  CONTROLS: 4+
  LEN H: 0-1
  LEN S: 4
  LEN D: 4
  LEN C: 4

# 1C - 1D: "Impossible negative" (txt Mark London: 8-pt 4441 hands respond 1D).
# Judgment: generalised to the uncovered 8-11 HCP region with no 5-carder -
# the shortage responses above need 12+ HCP (or <= 3 controls), so these
# 4-4-4-1 shapes would otherwise fall through.  Kept AFTER the shortage
# responses so they keep their 8-11 / <= 3-control hands.
1C - 1D:
  HCP: 8-11
  LEN C: 1-4
  LEN D: 1-4
  LEN H: 1-4
  LEN S: 1-4

# 1C - 3NT: Solid running 7+ card suit (opener may pass for NT)
# Approximation: "solid AKQ" honors are not expressible in this DSL;
# approximated by 7+ length + 8+ HCP, priority-raised above suit positives.
1C - 3NT:
  HCP: 8+
  LEN C: 7+
  PRIORITY_BONUS: 5
1C - 3NT:
  HCP: 8+
  LEN D: 7+
  PRIORITY_BONUS: 5
1C - 3NT:
  HCP: 8+
  LEN H: 7+
  PRIORITY_BONUS: 5
1C - 3NT:
  HCP: 8+
  LEN S: 7+
  PRIORITY_BONUS: 5

# ==========================================
# RESPONSES TO 1NT (10-12)
# ==========================================

# 1NT - 2D: Forcing Stayman (Game Force)
# Priority-raised so 4-card-major game forces outrank the 3NT signoff below.
1NT - 2D:
  HCP: 13+
  LEN H: 4+ # Asking for major
  PRIORITY_BONUS: 5
1NT - 2D:
  HCP: 13+
  LEN S: 4+
  PRIORITY_BONUS: 5

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
# Priority-raised so 5-carder game forces outrank the 3NT signoff below.
1NT - 3H:
  HCP: 13+
  LEN H: 5+
  PRIORITY_BONUS: 5

1NT - 3S:
  HCP: 13+
  LEN S: 5+
  PRIORITY_BONUS: 5

# Note (txt): forcing Stayman "may not have 4 card major". A no-major game
# force is simplified away here; balanced no-major hands route to the 3NT
# signoff / 4C Gerber rules below.

# 1NT - 2NT: Game invitational, denies a 4 card major
1NT - 2NT:
  HCP: 9-11

# 1NT - 2NT - 3NT: opener accepts with the top of the 10-12 range
1NT - 2NT - 3NT:
  HCP: 12-12

# 1NT - 3NT: Signoff (12-17 balanced, Mark London section)
1NT - 3NT:
  HCP: 12-17
  SHAPE: BALANCED

# 1NT - 3C/3D: To play (signoff in a long minor)
1NT - 3C:
  HCP: 0-9
  LEN C: 6+
1NT - 3D:
  HCP: 0-9
  LEN D: 6+

# ==========================================
# 2D OPENING DEVELOPMENT (11-15, short Diamonds)
# ==========================================

# 2D - 2H/2S/3C: To play, 0-11
2D - 2H:
  HCP: 0-11
  LEN H: 4+
2D - 2S:
  HCP: 0-11
  LEN S: 4+
2D - 3C:
  HCP: 0-11
  LEN C: 4+

# 2D - 2NT: Query; responder has 11+ HCP with shortness
2D - 2NT:
  HCP: 11+

# Opener shape answers (txt: 3C=3=4=1=5, 3D=4=3=1=5, 3H/3S=4=4=1=4,
# 3N=4=4=1=4 with DA/DK, 4C/4D=4=4=0=5)
2D - 2NT - 3C:
  HCP: 11-15
  LEN S: 3
  LEN H: 4
  LEN D: 1
  LEN C: 5
2D - 2NT - 3D:
  HCP: 11-15
  LEN S: 4
  LEN H: 3
  LEN D: 1
  LEN C: 5
2D - 2NT - 3H:
  HCP: 11-13
  LEN S: 4
  LEN H: 4
  LEN D: 1
  LEN C: 4
2D - 2NT - 3S:
  HCP: 14-15
  LEN S: 4
  LEN H: 4
  LEN D: 1
  LEN C: 4
# 3NT: 4=4=1=4 with DA or DK (approximated by controls + top range)
2D - 2NT - 3NT:
  HCP: 14-15
  CONTROLS: 4+
  LEN S: 4
  LEN H: 4
  LEN D: 1
  LEN C: 4
  PRIORITY_BONUS: 5
2D - 2NT - 4C:
  HCP: 11-13
  LEN S: 4
  LEN H: 4
  LEN D: 0
  LEN C: 5
2D - 2NT - 4D:
  HCP: 14-15
  LEN S: 4
  LEN H: 4
  LEN D: 0
  LEN C: 5

# 2D - 3H/3S: Responder sets game force, 5+ major
2D - 3H:
  HCP: 10+
  LEN H: 5+
  FORCING: GAME_FORCE
2D - 3S:
  HCP: 10+
  LEN S: 5+
  FORCING: GAME_FORCE

# ==========================================
# 2C OPENING DEVELOPMENT (11-15, 6+ Clubs)
# ==========================================

# Responder: 3H/3S game forcing, 6+ pieces, 14+ TP
2C - 3H:
  HCP: 14+
  LEN H: 6+
  FORCING: GAME_FORCE
2C - 3S:
  HCP: 14+
  LEN S: 6+
  FORCING: GAME_FORCE

# Responder: 2H/2S invitational, 5-carder, 11-13 TP
2C - 2H:
  HCP: 11-13
  LEN H: 5+
2C - 2S:
  HCP: 11-13
  LEN S: 5+

# Responder: 2NT invitational
2C - 2NT:
  HCP: 11-13

# Responder: 3C competitive raise
2C - 3C:
  HCP: 6-10
  LEN C: 4+

# Responder: 3D inviting 3NT, no 4-card major, forcing to 4m
2C - 3D:
  HCP: 11-13
  LEN D: 4+

# Responder: 2D waiting/query relay (catch-all, kept last)
2C - 2D:
  HCP: 0-37

# Opener answers to the 2D relay (txt: 2H/S=4 & 11-13, 2N=bal, 3C=Clubs,
# 3D=4D & 5C, 3H/S=4 & 14-15, 3N=Solid Clubs & 14-15)
2C - 2D - 2H:
  HCP: 11-13
  LEN H: 4
  PRIORITY_BONUS: 5
2C - 2D - 2S:
  HCP: 11-13
  LEN S: 4
  PRIORITY_BONUS: 5
2C - 2D - 2NT:
  HCP: 11-15
  SHAPE: BALANCED
2C - 2D - 3C:
  HCP: 11-15
  LEN C: 6+
2C - 2D - 3D:
  HCP: 11-15
  LEN D: 4
  LEN C: 5
2C - 2D - 3H:
  HCP: 14-15
  LEN H: 4
2C - 2D - 3S:
  HCP: 14-15
  LEN S: 4
# 3NT: solid clubs 14-15 (approximation: "solid" not expressible)
2C - 2D - 3NT:
  HCP: 14-15
  LEN C: 7+
  PRIORITY_BONUS: 5

# ==========================================
# REBIDS AFTER 1C - 1D (Negative)
# ==========================================

# 1C - 1D - 1NT: 16-19 Balanced
1C - 1D - 1NT:
  HCP: 16-19
  SHAPE: BALANCED

# 1C - 1D - 1H/1S: Non-Forcing natural rebid
# Text: "Usually 5+ card suit (could be 4=4=4=1 or 4=4=1=4), 5+ LTC" - so 4+
# card suits are allowed; this also gives the otherwise-unmapped 4441 openers
# (no 5-carder) a natural rebid.
1C - 1D - 1H:
  HCP: 16+
  LEN H: 4+

1C - 1D - 1S:
  HCP: 16+
  LEN S: 4+

# 1C - 1D - 2C/2D: Non-Forcing 17+ (5+ Suit)
1C - 1D - 2C:
  HCP: 16+
  LEN C: 5+

1C - 1D - 2D:
  HCP: 16+
  LEN D: 5+

# 1C - 1D - 2NT: 20-23 Balanced
# Text: "20-21" - extended to 23 by judgment so the otherwise-unmapped
# 22-23 balanced opener (3NT starts at 24-26) has a rebid.
1C - 1D - 2NT:
  HCP: 20-23
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

# 1C - 1D - 3NT: 24+ Balanced
# Text: "24-26" - uncapped by judgment: 27+ balanced openers otherwise had
# no rebid at all; 3NT is the practical destination opposite a 0-7 negative.
1C - 1D - 3NT:
  HCP: 24+
  SHAPE: BALANCED

# 1C - 1D - 3C/3D/3H/3S: 6+ card suit, 0-3 LTC, Forcing
# Approximation: LTC is not expressible in this DSL; mapped as very strong hands.
1C - 1D - 3C:
  HCP: 24+
  LEN C: 6+
  FORCING: GAME_FORCE
1C - 1D - 3D:
  HCP: 24+
  LEN D: 6+
  FORCING: GAME_FORCE
1C - 1D - 3H:
  HCP: 24+
  LEN H: 6+
  FORCING: GAME_FORCE
1C - 1D - 3S:
  HCP: 24+
  LEN S: 6+
  FORCING: GAME_FORCE

# 1C - 1D - 4H/4S: 8+ card suit, above NAMYATS
1C - 1D - 4H:
  HCP: 22+
  LEN H: 8+
1C - 1D - 4S:
  HCP: 22+
  LEN S: 8+

# ==========================================
# 1C - 1NT DEVELOPMENT (8-13 balanced positive)
# ==========================================

# 1C - 1NT - 2C: Stayman (transfer-approach rebids simplified)
1C - 1NT - 2C:
  HCP: 8-10

# 1C - 1NT - 2D/2H/2S: Natural 4-carder (opener 16+)
1C - 1NT - 2D:
  HCP: 16+
  LEN D: 4+
1C - 1NT - 2H:
  HCP: 16+
  LEN H: 4+
1C - 1NT - 2S:
  HCP: 16+
  LEN S: 4+

# 1C - 1NT - 2NT: Artificial, shows 5+ Clubs
1C - 1NT - 2NT:
  HCP: 16+
  LEN C: 5+

# 1C - 2NT - 3C: Baron (bid 4-card suits up the line)
1C - 2NT - 3C:
  HCP: 16+

# 1C - 2NT - 3D/3H/3S: Natural 5+ carder (Suit AB context)
1C - 2NT - 3D:
  HCP: 16+
  LEN D: 5+
1C - 2NT - 3H:
  HCP: 16+
  LEN H: 5+
1C - 2NT - 3S:
  HCP: 16+
  LEN S: 5+

# ==========================================
# OTHER OPENING RESPONSES (Simple Natural)
# ==========================================

# 1D - 1H/1S: 8-15 HCP, 4+ Suit (txt Mark London section: "8-15, 4 carder")
1D - 1H:
  HCP: 8-15
  LEN H: 4+

1D - 1S:
  HCP: 8-15
  LEN S: 4+

# 1D - 1NT: 8-10 Balanced (txt Mark London section)
# 1N (10-12) -> 1D opening handles 11-15 unbal or 2+D.
1D - 1NT:
  HCP: 8-10
  SHAPE: BALANCED

# 1D - 2NT: Invitational balanced (txt: 11-13 simplified / 16+ Goren variant)
1D - 2NT:
  HCP: 11-13
  SHAPE: BALANCED

# 1D - 3NT: 14-15 balanced, 4 card major
1D - 3NT:
  HCP: 14-15
  SHAPE: BALANCED

# ==========================================
# 1H/1S RESPONSES (txt Mark London section)
# ==========================================

# Single raise: 8-10, 3+ card support
1H - 2H:
  HCP: 8-10
  LEN H: 3+
1S - 2S:
  HCP: 8-10
  LEN S: 3+

# Jump raise: 11-13, 3 card support (txt: Qxx or better simplified to HCP)
1H - 3H:
  HCP: 11-13
  LEN H: 3+
1S - 3S:
  HCP: 11-13
  LEN S: 3+

# 1NT: 8-15 Forcing one round (no good suit, no support)
1H - 1NT:
  HCP: 8-15
  FORCING: ONE_ROUND
1S - 1NT:
  HCP: 8-15
  FORCING: ONE_ROUND

# 3NT: 14-15 with good 3-card support (signoff)
1H - 3NT:
  HCP: 14-15
  LEN H: 3+
1S - 3NT:
  HCP: 14-15
  LEN S: 3+

# ==========================================
# 2NT RESPONSES (22-23 balanced; txt Mark London section)
# ==========================================

# 2NT - 3C: Stayman (txt simplified: "3 pts, stayman")
2NT - 3C:
  HCP: 0-9

# 2NT - 3D/3H: Jacoby transfers (3D to H, 3H to S)
2NT - 3D:
  HCP: 0-9
  LEN H: 5+
2NT - 3H:
  HCP: 0-9
  LEN S: 5+

# Transfer completions (opener, mandatory)
2NT - 3D - 3H:
  HCP: 22-23
2NT - 3H - 3S:
  HCP: 22-23

# 2NT - 3NT: Signoff, no major, balanced
2NT - 3NT:
  HCP: 0-9
  SHAPE: BALANCED

# ==========================================
# SLAM BIDDING
# ==========================================

# --- Quantitative 4NT ---
# 1NT - 4NT: Quantitative (Invite to 6NT)
# Opener 10-12. Responder needs ~21-22 total for 33.
# So Responder needs ~11-12+ to invite? No, 1NT is 10-12.
# Standard Quant is when sum is ~32-33.
# If Opener 10-12, Responder needs 21+.
1NT - 4NT:
  HCP: 21-22
  SHAPE: BALANCED

# 2NT - 4NT: Quantitative
# Opener 22-23. Responder needs ~10-11 for 33.
2NT - 4NT:
  HCP: 10-11
  SHAPE: BALANCED

# 4NT - PASS (Opener Minimum)
1NT - 4NT - PASS:
  HCP: 10-11

2NT - 4NT - PASS:
  HCP: 22

# 4NT - 6NT (Opener Maximum)
1NT - 4NT - 6NT:
  HCP: 12

2NT - 4NT - 6NT:
  HCP: 23

# --- Gerber (4C) after NT ---
# 1NT - 4C: Gerber Ace Ask
1NT - 4C:
  HCP: 13-20

# 2NT - 4C: Gerber Ace Ask
2NT - 4C:
  HCP: 13-20

# --- 4NT Ace Asking (Blackwood/Beta) ---
# 1C (Strong) sequences leading to 4NT
# 1C - 1S (Positive) - 4NT
1C - 1S - 4NT:
  HCP: 18+

# Responses (Standard 0314 assumed as placeholder or Beta)
# Beta: 1st=0-2, 2nd=3, 3rd=4, 4th=5.
# Let's implement Beta as per Text (Line 533)
# 1st step (5C) = 0-2 Controls
1C - 1S - 4NT - 5C:
  CONTROLS: 0-2

# 2nd step (5D) = 3 Controls
1C - 1S - 4NT - 5D:
  CONTROLS: 3

# 3rd step (5H) = 4 Controls
1C - 1S - 4NT - 5H:
  CONTROLS: 4

# 4th step (5S) = 5 Controls
1C - 1S - 4NT - 5S:
  CONTROLS: 5

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
# INTERFERENCE OVER 1C (txt: general approach)
# Parenthesized steps so the chain matches directly after the double.
# ==========================================

# 1C - (X) - PASS: 0-4 HCP
(1C) - (X) - PASS:
  HCP: 0-4

# 1C - (X) - 1D: 5-7 HCP
(1C) - (X) - 1D:
  HCP: 5-7

# 1C - (X) - XX: Game Forcing, usually balanced
(1C) - (X) - XX:
  HCP: 8+

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
