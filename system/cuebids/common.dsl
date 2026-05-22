# Shared Cuebid and Convention Definitions

# ==========================================
# MICHAELS CUEBIDS (Direct cuebid over opponent opening)
# ==========================================

# Michaels Cuebid over 1C showing both majors
(1C) - 2C:
  BID_CLASS: CUEBID
  CUEBID_TYPE: Michaels
  CUE_TARGET: OPP_SUIT
  FORCING: ONE_ROUND
  HCP: 8-15
  LEN H: 5+
  LEN S: 5+

# Michaels Cuebid over 1D showing both majors
(1D) - 2D:
  BID_CLASS: CUEBID
  CUEBID_TYPE: Michaels
  CUE_TARGET: OPP_SUIT
  FORCING: ONE_ROUND
  HCP: 8-15
  LEN H: 5+
  LEN S: 5+

# Michaels Cuebid over 1H showing Spades and an unspecified minor
(1H) - 2H:
  BID_CLASS: CUEBID
  CUEBID_TYPE: Michaels
  CUE_TARGET: OPP_SUIT
  FORCING: ONE_ROUND
  HCP: 8-15
  LEN S: 5+

# Michaels Cuebid over 1S showing Hearts and an unspecified minor
(1S) - 2S:
  BID_CLASS: CUEBID
  CUEBID_TYPE: Michaels
  CUE_TARGET: OPP_SUIT
  FORCING: ONE_ROUND
  HCP: 8-15
  LEN H: 5+


# ==========================================
# DRURY CONVENTION (Passed hand response to 3rd/4th seat major openings)
# ==========================================

# Drury response to 1H opening
1H - 2C:
  PASSED_HAND: TRUE
  OPENER_SEAT: 3,4
  HCP: 9-11
  LEN H: 3+
  CONVENTION: Drury

# Drury response to 1S opening
1S - 2C:
  PASSED_HAND: TRUE
  OPENER_SEAT: 3,4
  HCP: 9-11
  LEN S: 3+
  CONVENTION: Drury

# Opener rebid showing sub-minimum hand (not interested in game, to play)
1H - 2C - 2H:
  PARTNER_PASSED_HAND: TRUE
  OPENER_SEAT: 3,4
  HCP: 11-13
  LEN H: 5+
  CONVENTION: Drury_Subminimum

1S - 2C - 2S:
  PARTNER_PASSED_HAND: TRUE
  OPENER_SEAT: 3,4
  HCP: 11-13
  LEN S: 5+
  CONVENTION: Drury_Subminimum

# Opener rebid 2D showing full opening hand (asking responder to describe fit/strength)
1H - 2C - 2D:
  PARTNER_PASSED_HAND: TRUE
  OPENER_SEAT: 3,4
  HCP: 14+
  CONVENTION: Drury_FullOpening

1S - 2C - 2D:
  PARTNER_PASSED_HAND: TRUE
  OPENER_SEAT: 3,4
  HCP: 14+
  CONVENTION: Drury_FullOpening
