# Option: New Minor Forcing
# Description: Rebid of unbid minor at 2-level after 1X-1Y-1NT/2NT (forcing 1 round) asking opener for major fit/shape.

# New Minor Forcing (NMF)
1C - 1H - 1NT - 2D:
  CONVENTION: New_Minor_Forcing
  FORCING: ONE_ROUND
  HCP: 11+

1C - 1S - 1NT - 2D:
  CONVENTION: New_Minor_Forcing
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
