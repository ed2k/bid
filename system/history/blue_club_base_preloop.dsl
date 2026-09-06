# Italian Blue Club

# ==========================================
# OPENING BIDS
# ==========================================

# Strong shape-specific openings come FIRST: at equal priority the earlier
# rule wins ties, so 2NT/2D must precede 1C or they could never fire.
# 2NT: 21-22 Balanced (txt Part I.1)
OPEN 2NT:
  HCP: 21-22
  SHAPE: BALANCED

# 2D: 17-24, 4-4-4-1, any singleton (txt Part I.1; void tolerated)
OPEN 2D:
  HCP: 17-24
  LEN D: 0-1
  LEN H: 4
  LEN S: 4
  LEN C: 4
OPEN 2D:
  HCP: 17-24
  LEN H: 0-1
  LEN D: 4
  LEN S: 4
  LEN C: 4
OPEN 2D:
  HCP: 17-24
  LEN S: 0-1
  LEN H: 4
  LEN D: 4
  LEN C: 4
OPEN 2D:
  HCP: 17-24
  LEN C: 0-1
  LEN H: 4
  LEN D: 4
  LEN S: 4

# 1C: Strong — 17+ unbalanced; 18+ balanced (txt Part I.1)
OPEN 1C:
  HCP: 17+
  SHAPE: UNBALANCED
OPEN 1C:
  HCP: 18+
  SHAPE: BALANCED

# 1NT: 16-17 any suit Balanced (txt Part I.3)
OPEN 1NT:
  HCP: 16-17
  SHAPE: BALANCED

# 1NT second range (txt Part I.3): 13-15 with C suit and 3-carder H and S
OPEN 1NT:
  HCP: 13-15
  LEN C: 4+
  LEN H: 3
  LEN S: 3

# 5C/5D: Weak 8+ carder, rule of 2 and 3 (txt Part I.2)
# Approximation: vulnerability dependence is not expressible; 9+ length
# distinguishes these from the 4-level 8+ preempts.
OPEN 5C:
  HCP: 6-11
  LEN C: 9+
OPEN 5D:
  HCP: 6-11
  LEN D: 9+

# 4C/4D/4H/4S: Weak 6-11, 8+ carder (rule of 2 and 3)
OPEN 4C:
  HCP: 6-11
  LEN C: 8+
OPEN 4D:
  HCP: 6-11
  LEN D: 8+
OPEN 4H:
  HCP: 6-11
  LEN H: 8+
OPEN 4S:
  HCP: 6-11
  LEN S: 8+

# 3NT: Weak gambit — 7 carder minor with AKQ, nothing much else (txt Part I.2)
# Approximation: "AKQ + nothing else" is not expressible; approximated by
# 9-11 HCP (AKQ alone is 9) + 7+ minor, placed above the weak 3D preempt.
OPEN 3NT:
  HCP: 9-11
  LEN C: 7+
OPEN 3NT:
  HCP: 9-11
  LEN D: 7+

# 3C: 13-16, 7+ Clubs very good suit, 7-8 playing tricks (txt Part I.3)
OPEN 3C:
  HCP: 13-16
  LEN C: 7+

# 3D/3H/3S: Weak 6-11, 7+ suit preempt (rule of 2 and 3; txt Part I.2)
OPEN 3D:
  HCP: 6-11
  LEN D: 7+
  SHAPE: UNBALANCED
OPEN 3H:
  HCP: 6-11
  LEN H: 7+
  SHAPE: UNBALANCED
OPEN 3S:
  HCP: 6-11
  LEN S: 7+
  SHAPE: UNBALANCED

# 2H/2S: Weak 6-11, 6-7 carder (rule of 2 and 3)
OPEN 2H:
  HCP: 6-11
  LEN H: 6+
  SHAPE: UNBALANCED
OPEN 2S:
  HCP: 6-11
  LEN S: 6+
  SHAPE: UNBALANCED

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

# Explicit PASS: everything below the openings above.  Judgment: txt opens
# 11-16 normal, 6-11 weak, 17+ strong and 13-15/16-17 1NT - weaker hands
# pass by design; made explicit so the engine never falls through silently.
OPEN PASS:
  HCP: 0-12

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

# Opener Splinter rebid after 1C - 1H (4+ Spades, 5+ Hearts, Club shortness 0-1, 7+ Controls or 16+ HCP)
1C - 1H - 4C:
  CONVENTION: Opener_Splinter
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 5
  CONTROLS: 7+
  LEN H: 5+
  LEN S: 4+
  LEN C: 0-1
  SHAPE: UNBALANCED

# RKCB 4NT after Opener Splinter 1C - 1H - 4C (MAJOR_HCP 8+ working values)
1C - 1H - 4C - 4NT:
  CONVENTION: RKCB
  PRIORITY_BONUS: 15
  MAJOR_HCP: 8+
  LEN S: 5+

# Opener RKCB response to 4NT: 5C (3 keycards: SA, HA, DA)
1C - 1H - 4C - 4NT - 5C:
  CONVENTION: RKCB_Response_03
  PRIORITY_BONUS: 10
  ACES: 3

# Responder 5NT Grand Slam Ask
1C - 1H - 4C - 4NT - 5C - 5NT:
  CONVENTION: GrandSlam_Ask
  PRIORITY_BONUS: 10
  MAJOR_HCP: 8+

# Opener 7S Grand Slam bid
1C - 1H - 4C - 4NT - 5C - 5NT - 7S:
  CONVENTION: GrandSlam_Bid
  PRIORITY_BONUS: 10
  CONTROLS: 7+
  LEN S: 4+
  LEN H: 5+

# Responder Cuebid after Opener Splinter (MAJOR_HCP 6-7 working values)
1C - 1H - 4C - 4H:
  BID_CLASS: CUEBID
  CUEBID_TYPE: ControlCue
  CUE_TARGET: AGREED_SUIT
  FORCING: GAME_FORCING
  PRIORITY_BONUS: 10
  MAJOR_HCP: 6-7
  LEN S: 4+

# Opener Slam jump after 1C - 1H - 4C - 4H
1C - 1H - 4C - 4H - 6S:
  CONVENTION: Slam_Jump
  PRIORITY_BONUS: 5
  CONTROLS: 7+
  LEN S: 4+
  LEN H: 5+

# Responder Sign-off in 4S after Opener Splinter 1C - 1H - 4C (wasted club values / MAJOR_HCP 0-5)
1C - 1H - 4C - 4S:
  CONVENTION: Splinter_Signoff
  PRIORITY_BONUS: 5
  MAJOR_HCP: 0-5
  LEN S: 4+

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

# 1C - 2NT: 7+ Controls (Game Force)
# Text: "7 controls ... and then you will not believe us" - extended to 7+
# by judgment: 8+-control hands (e.g. four aces) had no rung at all.
1C - 2NT:
  CONTROLS: 7+

# 1C - 2H/2S: 4-5 points, six carder mostly in the suit (txt Part II.1)
# Priority-raised above the 1D negative (0-5) for the 4-5 HCP overlap.
1C - 2H:
  HCP: 4-5
  LEN H: 6+
  PRIORITY_BONUS: 5
1C - 2S:
  HCP: 4-5
  LEN S: 6+
  PRIORITY_BONUS: 5

# 1C - 1D catch-all: 0-5 HCP regardless of honors.  Judgment: the txt caps
# the negative at 2 controls; a 4-HCP hand holding the AK has 3 controls and
# no other rung - passing (or ignoring) a forcing 1C is worse than 1D.
1C - 1D:
  HCP: 0-5

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
  FORCING: ONE_ROUND  # txt: forcing to 2NT

# 1H - 2D: 11+ HCP, 3+ Diamonds
1H - 2D:
  HCP: 11+
  LEN D: 3+
  FORCING: ONE_ROUND  # txt: forcing to 2NT

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
  FORCING: ONE_ROUND  # txt: forcing to 2NT

# 1S - 2D: 11+ HCP, 3+ Diamonds
1S - 2D:
  HCP: 11+
  LEN D: 3+
  FORCING: ONE_ROUND  # txt: forcing to 2NT

# 1S - 2H: 11+ HCP, 4+ Hearts (Text: "11+ min 4 card forcing")
1S - 2H:
  HCP: 11+
  LEN H: 4+
  FORCING: ONE_ROUND  # txt: forcing to 2NT

# 1S - 2S: 6-10 HCP, 3+ Spades
1S - 2S:
  HCP: 6-10
  LEN S: 3+

# 1S - 2NT: 11-12 Balanced
1S - 2NT:
  HCP: 11-12
  SHAPE: BALANCED

# Jump raises in opener's major: 10-11 limit bid (txt Part VI.4)
1H - 3H:
  HCP: 10-11
  LEN H: 3+
1S - 3S:
  HCP: 10-11
  LEN S: 3+

# Jump to 4C over 1H/1S: Gerber Ace asking (txt Part VI.4)
1H - 4C:
  HCP: 11+
  CONVENTION: Gerber
1S - 4C:
  HCP: 11+
  CONVENTION: Gerber

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
  FORCING: ONE_ROUND  # txt: forcing to 2NT

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

# 1NT - 3C/3D/3H/3S: Natural 6-carder with two top honors, nothing else
# (txt Part V.1; honor requirement approximated by 0-9 HCP + 6+ length)
1NT - 3C:
  HCP: 0-9
  LEN C: 6+
1NT - 3D:
  HCP: 0-9
  LEN D: 6+
1NT - 3H:
  HCP: 0-9
  LEN H: 6+
1NT - 3S:
  HCP: 0-9
  LEN S: 6+

# ==========================================
# REBIDS (Development)
# ==========================================

# --- 1C Opener Rebids ---

# 1C - 1D - 1NT: 18-22 Balanced
# Text: "18-20" - upper edge stretched by judgment: 21-22 balanced openers
# otherwise had no rebid (2NT starts at 23-24 per txt).
1C - 1D - 1NT:
  HCP: 18-22
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

# Natural six-carder rebids.  Judgment: txt gives "six carder with K or Q"
# only inside the 2D/1NT branches; these natural fills stop self-sufficient
# one-suiters (no other rung) from falling through.
1C - 1D - 2D:
  HCP: 17+
  LEN D: 5+  # judgment: 5+ like 2C, so 5-card diamonds have a rebid
1C - 1D - 2H:
  HCP: 17+
  LEN H: 6+
1C - 1D - 2S:
  HCP: 17+
  LEN S: 6+
1C - 1D - 3C:
  HCP: 17+
  LEN C: 6+

# 1C - 1D - 2NT: 23-24 Balanced (txt Part II.3); 1NT stops at 18-22
1C - 1D - 2NT:
  HCP: 23-24
  SHAPE: BALANCED

# 1C - 1D - 3NT: 25+ Balanced
# Text: "25-26" - uncapped by judgment (27+ had no rebid).
1C - 1D - 3NT:
  HCP: 25+
  SHAPE: BALANCED

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

# 2NT - 3NT: To Play (no major; any non-slam-strength hand)
2NT - 3NT:
  HCP: 0-20
  SHAPE: BALANCED

# ==========================================
# 2NT DEVELOPMENT (21-22 balanced; txt Part II.5)
# ==========================================

# 2NT - 3C: Gladiator relay (possible 0-3 signoff in 3D)
2NT - 3C:
  HCP: 0-10

# 2NT - 3C - 3D: opener completes the relay
2NT - 3C - 3D:
  HCP: 21-22

# 2NT - 3D: Stayman
2NT - 3D:
  HCP: 5+
  LEN H: 4+
2NT - 3D:
  HCP: 5+
  LEN S: 4+

# Opener's Stayman answers: 3H 4+ major, 3S 5-carder, 3NT no major
2NT - 3D - 3H:
  LEN H: 4+
2NT - 3D - 3S:
  LEN S: 5+
2NT - 3D - 3NT:
  HCP: 21-22
  SHAPE: BALANCED

# 2NT - 3H/3S: natural 5-carder
2NT - 3H:
  HCP: 5-10
  LEN H: 5+
2NT - 3S:
  HCP: 5-10
  LEN S: 5+

# 2NT - 4C/4D: Texas transfers (4C to D, 4D to H)
2NT - 4C:
  LEN D: 6+
2NT - 4D:
  LEN H: 6+

# 2NT - 4H/4S: very good 6-carder, to play
2NT - 4H:
  LEN H: 6+
2NT - 4S:
  LEN S: 6+

# 2NT - 4NT: Quantitative
2NT - 4NT:
  HCP: 11-12
  SHAPE: BALANCED

# 1NT - 2C - 2S: 16-17 Balanced (Showing Max/Range)
1NT - 2C - 2S:
  # 2C is Relay 8-11. 2S shows 16-17.
  HCP: 16-17

# Opener's answers to the 2C relay, 13-15 C-suit branch (txt Part V.1):
# 2D: C suit 13 w/5 or 14 w/4;  2H: C suit 14 w/5 or 15 w/4;  2NT: C suit 15 w/5
1NT - 2C - 2D:
  HCP: 13-13
  LEN C: 5+
1NT - 2C - 2D:
  HCP: 14-14
  LEN C: 4
1NT - 2C - 2H:
  HCP: 14-14
  LEN C: 5+
1NT - 2C - 2H:
  HCP: 15-15
  LEN C: 4
1NT - 2C - 2NT:
  HCP: 15-15
  LEN C: 5+

# ==========================================
# 2C DEVELOPMENT (11-16 good Clubs; txt Part V.3)
# ==========================================

# Responder: 3D/3H/3S 12+ semi-solid six carder
2C - 3D:
  HCP: 12+
  LEN D: 6+
2C - 3H:
  HCP: 12+
  LEN H: 6+
2C - 3S:
  HCP: 12+
  LEN S: 6+

# Responder: 2H/2S weak 6-10 five carder, non-forcing
2C - 2H:
  HCP: 6-10
  LEN H: 5+
2C - 2S:
  HCP: 6-10
  LEN S: 5+

# Responder: 2NT 11-12 balanced; 3C 8-10 raise
2C - 2NT:
  HCP: 11-12
  SHAPE: BALANCED
2C - 3C:
  HCP: 8-10
  LEN C: 3+

# Responder: 2D relay (catch-all, kept last)
2C - 2D:
  HCP: 0-37

# Opener answers to the 2D relay (txt Part V.3):
# 2H/2S 15-16 4-carder; 2NT 13-16 clubs with side stoppers (approx 5+ C);
# 3D 15-16 4-card D. The 3C one-stopper variant is folded into 2NT
# (stopper counts are not expressible in this DSL).
2C - 2D - 2H:
  HCP: 15-16
  LEN H: 4
  PRIORITY_BONUS: 5
2C - 2D - 2S:
  HCP: 15-16
  LEN S: 4
  PRIORITY_BONUS: 5
2C - 2D - 2NT:
  HCP: 13-16
  LEN C: 5+
2C - 2D - 3D:
  HCP: 15-16
  LEN D: 4

# ==========================================
# 3C DEVELOPMENT (13-16, 7+ very good Clubs; txt Part V.2)
# Stopper-showing opener answers are not expressible (no stopper feature
# in this DSL); responder's stopper-asking relays are mapped as asks.
# ==========================================

# 3C - 3D/3H/3S: stopper-asking relays (D / H / S)
3C - 3D:
  HCP: 0-37
3C - 3H:
  HCP: 0-37
3C - 3S:
  HCP: 0-37

# 3C - 3NT: to play
3C - 3NT:
  HCP: 0-10

# 3C - 4D/4H/4S: cue bid with fit, else natural semi-solid 6-carder 12+
3C - 4D:
  HCP: 12+
  LEN D: 6+
3C - 4H:
  HCP: 12+
  LEN H: 6+
3C - 4S:
  HCP: 12+
  LEN S: 6+

# ==========================================
# 2D DEVELOPMENT (17-24, 4-4-4-1; txt Part II.4)
# Relay continuations beyond the first round are beyond this DSL.
# ==========================================

# 2D - 2S: signoff, may be only 3 carder (0-3)
2D - 2S:
  HCP: 0-3

# 2D - 2NT: one weak six carder, max KJ, nothing else (approx 4-7 HCP)
2D - 2NT:
  HCP: 4-7
  LEN C: 6+
2D - 2NT:
  HCP: 4-7
  LEN D: 6+
2D - 2NT:
  HCP: 4-7
  LEN H: 6+
2D - 2NT:
  HCP: 4-7
  LEN S: 6+

# 2D - 3C/3D/3H/3S: fair six carder, min AJ (approx 8-10 HCP)
2D - 3C:
  HCP: 8-10
  LEN C: 6+
2D - 3D:
  HCP: 8-10
  LEN D: 6+
2D - 3H:
  HCP: 8-10
  LEN H: 6+
2D - 3S:
  HCP: 8-10
  LEN S: 6+

# 2D - 2H: relay asking point range + singleton (catch-all, kept last)
2D - 2H:
  HCP: 0-37

# Opener's answers to the 2H relay (NBS = next below singleton):
# 17-20: 2S major singleton, 2NT C singleton, 3C D singleton
# 21-24: 3D H singleton, 3H S singleton, 3S C singleton, 3NT D singleton
2D - 2H - 2S:
  HCP: 17-20
  LEN S: 0-1
  LEN H: 4
  LEN D: 4
  LEN C: 4
2D - 2H - 2S:
  HCP: 17-20
  LEN H: 0-1
  LEN S: 4
  LEN D: 4
  LEN C: 4
2D - 2H - 2NT:
  HCP: 17-20
  LEN C: 0-1
  LEN H: 4
  LEN D: 4
  LEN S: 4
2D - 2H - 3C:
  HCP: 17-20
  LEN D: 0-1
  LEN H: 4
  LEN S: 4
  LEN C: 4
2D - 2H - 3D:
  HCP: 21-24
  LEN H: 0-1
  LEN S: 4
  LEN D: 4
  LEN C: 4
2D - 2H - 3H:
  HCP: 21-24
  LEN S: 0-1
  LEN H: 4
  LEN D: 4
  LEN C: 4
2D - 2H - 3S:
  HCP: 21-24
  LEN C: 0-1
  LEN H: 4
  LEN D: 4
  LEN S: 4
2D - 2H - 3NT:
  HCP: 21-24
  LEN D: 0-1
  LEN H: 4
  LEN S: 4
  LEN C: 4

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

# 1C - 1S - 4NT - 5NT: 2 Aces, Same Color
1C - 1S - 4NT - 5NT:
  ACES: 2
  ACE_TOPOLOGY: COLOR

# ==========================================
# DEFENSIVE BIDDING (Overcalls)
# ==========================================

# --- 1-Level Overcalls (8+, Good 5-carder) ---

# (1C) - 1D: Natural Overcall
(1C) - 1D:
  HCP: 8-16
  LEN D: 5+

# (1C) - 1H: Natural Overcall
(1C) - 1H:
  HCP: 8-16
  LEN H: 5+

# (1C) - 1S: Natural Overcall
(1C) - 1S:
  HCP: 8-16
  LEN S: 5+

# (1D) - 1H: Natural Overcall
(1D) - 1H:
  HCP: 8-16
  LEN H: 5+

# (1D) - 1S: Natural Overcall
(1D) - 1S:
  HCP: 8-16
  LEN S: 5+

# (1H) - 1S: Natural Overcall
(1H) - 1S:
  HCP: 8-16
  LEN S: 5+

# --- 1NT Overcall (16-18 Balanced) ---

# (1C) - 1NT
(1C) - 1NT:
  HCP: 16-18
  SHAPE: BALANCED

# (1D) - 1NT
(1D) - 1NT:
  HCP: 16-18
  SHAPE: BALANCED

# (1H) - 1NT
(1H) - 1NT:
  HCP: 16-18
  SHAPE: BALANCED

# (1S) - 1NT
(1S) - 1NT:
  HCP: 16-18
  SHAPE: BALANCED

# --- Jump Overcalls ---

# (1C) - 2D: Jump to 2D over 1C shows the two MAJOR suits (txt Part VII.1)
# Approximation: SAPV (strength-as-per-vulnerability) is not expressible;
# the HCP span covers the weak/normal/strong SAPV bands.
(1C) - 2D:
  HCP: 6-16
  LEN H: 5+
  LEN S: 5+

# (1C) - 2NT: the two lowest suits (D + H), SAPV (txt Part VII.1)
(1C) - 2NT:
  HCP: 6-16
  LEN D: 5+
  LEN H: 5+

# (1C) - 2H/2S: semi-solid six carder, SAPV (txt Part VII.2)
(1C) - 2H:
  HCP: 12-16
  LEN H: 6+
(1C) - 2S:
  HCP: 12-16
  LEN S: 6+

# --- Doubles (Takeout / Strong) ---

# (1C) - X: Double of Strong 1C (16+)
(1C) - X:
  HCP: 16+

# (1D) - X: Takeout (12+)
(1D) - X:
  HCP: 12+
  LEN D: 0-2 # Shortness in opponent suit typically

# (1H) - X: Takeout (12+)
(1H) - X:
  HCP: 12+
  LEN H: 0-2

# (1S) - X: Takeout (12+)
(1S) - X:
  HCP: 12+
  LEN S: 0-2
