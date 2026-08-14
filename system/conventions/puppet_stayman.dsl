# Puppet Stayman (1NT - 3C / 2NT - 3C)
1NT - 3C:
  CONVENTION: Puppet_Stayman
  FORCING: GAME_FORCING
  HCP: 10+

2NT - 3C:
  CONVENTION: Puppet_Stayman_2NT
  FORCING: GAME_FORCING
  HCP: 5+

1NT - 3C - 3D:
  CONVENTION: Puppet_One_Or_Both_4M
  LEN H: 4
  LEN S: 4

1NT - 3C - 3H:
  CONVENTION: Puppet_5_Hearts
  LEN H: 5+

1NT - 3C - 3S:
  CONVENTION: Puppet_5_Spades
  LEN S: 5+

1NT - 3C - 3NT:
  CONVENTION: Puppet_No_Major
  LEN H: 0-3
  LEN S: 0-3
