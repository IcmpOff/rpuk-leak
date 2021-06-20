config = {}

config.transformerInteraction = "Push [E] to place C4"
config.vaultPanelInteraction = "Push [E] to connect Lesters Hacking Device"
config.safeInteraction = "Push [E] to use keycard"
config.depositBoxInteraction = "Push [E] to open Deposit Boxes"
--
config.minPolice = 10
-- Cooldown for power (aka Vault Heist)
config.transformerRebootTime = 7200 -- Sec
-- Level One Phase
config.levelOneMinDifficulty = 5
config.levelOneMaxDifficulty = 7
-- Level Two Phase
config.levelTwoMinDifficulty = 3
config.levelTwoMaxDifficulty = 4
---- Level Three Phase
config.levelThreeMinDifficulty = 2
config.levelThreeMaxDifficulty = 3
--- Hacking Times
config.minHackTime = 11 --Sec
config.maxHackTime = 20 --Sec
---- Safe
config.safeCooldown = 10800 -- Sec
config.minAmountOfKeys = 1
config.maxAmountOfKeys = 2
----
config.transformerLocation = {
  {
    transformerSwitch = {
      x = 664.61734619141, 
      y = 112.92027282715,
      z = 79.922798156738,
      dist = 12
    },
  },
}

config.vaultPanel = {
  {
    panel = {
      x = 253.11373901367,
      y = 228.33401489258,
      z = 100.68322753906,
      dist = 12
    },
  },
}

config.officeSafe = {
  {
    safe = {
      x = 266.39787475586,
      y = 214.10,
      z = 108.23330688477,
      dist = 3
    }
  },
  {
    safe = {
      x = 259.12585449219,
      y = 204.23439025879,
      z = 108.23340606689,
      dist = 3
    },
  }
}

config.depositBoxes = {
  {
    box = {
      x = 264.55258178711,
      y = 216.26954650879,
      z = 100.6833114624,
      dist = 6
    }
  },
  {
    box = {
      x = 266.05764770508,
      y = 213.46360778809,
      z = 100.68333435059,
      dist = 6
    },
  },
  {
    box = {
      x = 263.33071899414,
      y = 212.26379394531,
      z = 100.68333435059,
      dist = 6
    },
  },
  {
    box = {
      x = 258.25317382813,
      y = 214.13578796387,
      z = 100.68333435059,
      dist = 6
    },
  },
  {
    box = {
      x = 259.62133789063,
      y = 218.00819396973,
      z = 100.68333435059,
      dist = 6
    },
  }
}

