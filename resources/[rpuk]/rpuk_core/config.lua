Config 				  = {}
Config.CooldownPolice = 700
Config.cooldown		  = 1700

-- Add/remove weapon hashes here to be added for holster checks.
Config.Weapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_MARKSMANPISTOL",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_FLAREGUN",
	"WEAPON_STUNGUN",
	"WEAPON_REVOLVER",
	"WEAPON_GROVEM1911",
	"WEAPON_BALLAM1911",
	"WEAPON_VAGOSM1911",
	"WEAPON_MARAGRANDEM1911",
	"WEAPON_AZTECAM1911",
	"WEAPON_TRIADSM1911",
}
-----------------------------------

Config.ReloadTime = 2000 --ms

Config.Ammo = {
	{
		name = 'pistol_ammo',
		weapons = {
			'WEAPON_PISTOL',
			'WEAPON_PISTOL_mk2',
			'WEAPON_APPISTOL',
			'WEAPON_SNSPISTOL',
			'WEAPON_COMBATPISTOL',
			'WEAPON_HEAVYPISTOL',
			'WEAPON_MACHINEPISTOL',
			'WEAPON_MARKSMANPISTOL',
			'WEAPON_PISTOL50',
			'WEAPON_VINTAGEPISTOL',
			"WEAPON_GROVEM1911",
			"WEAPON_BALLAM1911",
			"WEAPON_VAGOSM1911",
			"WEAPON_MARAGRANDEM1911",
			"WEAPON_AZTECAM1911",
			"WEAPON_TRIADSM1911",
		},
		count = 30
	},
	{
		name = 'shotgun_ammo',
		weapons = {
			'WEAPON_ASSAULTSHOTGUN',
			'WEAPON_AUTOSHOTGUN',
			'WEAPON_BULLPUPSHOTGUN',
			'WEAPON_DBSHOTGUN',
			'WEAPON_HEAVYSHOTGUN',
			'WEAPON_PUMPSHOTGUN',
			'WEAPON_SAWNOFFSHOTGUN'
		},
		count = 12
	},
	{
		name = 'smg_ammo',
		weapons = {
			'WEAPON_ASSAULTSMG',
			'WEAPON_COMBATPDW',
			'WEAPON_MICROSMG',
			'WEAPON_MINISMG',
			'WEAPON_SMG'
		},
		count = 45
	},
	{
		name = 'rifle_ammo',
		weapons = {
			'WEAPON_ADVANCEDRIFLE',
			'WEAPON_ASSAULTRIFLE',
			'WEAPON_BULLPUPRIFLE',
			'WEAPON_CARBINERIFLE',
			'WEAPON_CARBINERIFLE_MK2',
			'WEAPON_SPECIALCARBINE',
			'WEAPON_COMPACTRIFLE'
		},
		count = 45
	},
	{
		name = 'sniper_ammo',
		weapons = {
			'WEAPON_SNIPERRIFLE',
			'WEAPON_HEAVYSNIPER',
			'WEAPON_MARKSMANRIFLE'
		},
		count = 10
	}
}

Config.clothes = {
	["weapon"] = { "WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_STUNGUN" },
	["peds"] = {
	  ["mp_m_freemode_01"] = { -- Male multiplayer ped
		["components"] = {
		  [7] = { -- Component ID, "Neck" or "Teeth" category
			[1] = 3, -- Drawable ID, can specify multiple, separated by comma and or line breaks
			[8] = 5,
			[42] = 43,
			[110] = 111,
			[119] = 120,
			[4] = 2,
			[7] = 6
		  },
		  [8] = { 
			[16] = 18
		  }
		}
	  },
	  ["mp_f_freemode_01"] = { -- Female multiplayer ped
		["components"] = {
		[7] = { -- Component ID, "Neck" or "Teeth" category
			[1] = 3, -- Drawable ID, can specify multiple, separated by comma and or line breaks
			[8] = 5,
			[42] = 43,
			[110] = 111,
			[119] = 120,
			[4] = 2
		  },
		  [8] = { 
			[16] = 18
		  }
		}
	  },
	}
}


-- [[ Zones ]] --

Config.Zones = {
	{
		Text = "Press [~b~E~s~] to Leave ~o~Money Wash~s~.",
		Marker = vector3(1138.075, -3198.640, -40.661),
		MarkerSettings = {action = "teleport", r = 255, g = 55, b = 55, a = 100, type = 1, x = 2.5, y = 2.5, z = 0.5},
		TeleportPoint = { coords = vector3(1196.531, -3253.551, 6.100), h = 122 }
	},
	{
		Text = "Press [~b~E~s~] to Leave [~r~Returns you to Mosleys - Logged~s~]",
		Marker = vector3(-1495.587, -2985.658, -83.207),
		MarkerSettings = {action = "teleport", r = 255, g = 255, b = 255, a = 100, type = 1, x = 2.0, y = 2.0, z = 0.5},
		TeleportPoint = { coords = vector3(-21.040, -1660.687, 28.480), h = 122 }
	},
	{
		Text = "Press [~b~E~s~] to Leave [~r~Returns you to Autocare - Logged~s~]",
		Marker = vector3(-1495.573, -2990.799, -83.207),
		MarkerSettings = {action = "teleport", r = 255, g = 255, b = 255, a = 100, type = 1, x = 2.0, y = 2.0, z = 0.5},
		TeleportPoint = { coords = vector3(949.234, -961.385, 38.500), h = 122 }
	},
	{
		Text = "Press [~b~E~s~] to Leave [~r~Returns you to Benefactors - Logged~s~]",
		Marker = vector3(-1495.572, -2996.058, -83.207),
		MarkerSettings = {action = "teleport", r = 255, g = 255, b = 255, a = 100, type = 1, x = 2.0, y = 2.0, z = 0.5},
		TeleportPoint = { coords = vector3(-51.447, 73.762, 70.950), h = 122 }
	},
	{
		Text = "Press [~b~E~s~] to Leave [~r~Returns you to Beekers - Logged~s~]",
		Marker = vector3(-1495.603, -3000.709, -83.207),
		MarkerSettings = {action = "teleport", r = 255, g = 255, b = 255, a = 100, type = 1, x = 2.0, y = 2.0, z = 0.5},
		TeleportPoint = { coords = vector3(105.959, 6627.304, 30.787), h = 122 }
	},
	{
		Text = "Press [~b~E~s~] to Access ~b~Clubhouse~s~.",
		Marker = vector3(1991.149, 3059.862, 46.055),
		MarkerSettings = {job = "lost", action = "teleport", r = 150, g = 100, b = 0, a = 255, type = 1, x = 1.5, y = 1.5, z = 0.5},
		TeleportPoint = { coords = vector3(459.493, -1008.010, 27.253), h = 180 }
	},
	{
		Text = "Not quite sure how you got down here\nPress [~b~E~s~] to Go Back To ~b~Reality~s~.",
		Marker = vector3(2.75, 2.27, -1.25),
		MarkerSettings = {action = "teleport", r = 255, g = 0, b = 0, a = 255, type = 1, x = 1.5, y = 1.5, z = 0.5},
		TeleportPoint = { coords = vector3(-2.762, 8.423, 69.935), h = 180 }
	},
	-- [[ Automatic - No Button Interaction ]] --
	{ -- [[ IKEA LEAVE 1 ]] --
		Marker = vector3(-1266.961, -2959.372, -49.490),
		MarkerSettings = {action = "auto_teleport", r = 255, g = 255, b = 0, a = 100, type = 1, x = 5.0, y = 5.0, z = 0.5},
		TeleportPoint = { coords = vector3(49.499, -1734.550, 28.303), h = 270 }
	},
	{ --- [[ Casino Entrance 1 ]] --
		Marker = vector3(927.174, 48.472, 80.096),
		MarkerSettings = {action = "auto_teleport", r = 0, g = 150, b = 200, a = 100, type = 1, x = 2.5, y = 2.5, z = 0.5},
		TeleportPoint = { coords = vector3(1090.537, 209.431, -50.000), h = 180 }
	},
	{ --- [[ Casino Entrance 2 ]] --
		Marker = vector3(925.673, 46.086, 80.096),
		MarkerSettings = {action = "auto_teleport", r = 0, g = 150, b = 200, a = 100, type = 1, x = 2.5, y = 2.5, z = 0.5},
		TeleportPoint = { coords = vector3(1090.537, 209.431, -50.000), h = 180 }
	},
	{ --- [[ Casino Entrance 3 ]] --
		Marker = vector3(924.185, 43.706, 80.096),
		MarkerSettings = {action = "auto_teleport", r = 0, g = 150, b = 200, a = 100, type = 1, x = 2.5, y = 2.5, z = 0.5},
		TeleportPoint = { coords = vector3(1090.537, 209.431, -50.000), h = 180 }
	},
	{ --- [[ Casino Leave 1 ]] --
		Marker = vector3(1089.688, 204.933, -50.000),
		MarkerSettings = {action = "auto_teleport", r = 0, g = 150, b = 200, a = 100, type = 1, x = 3.0, y = 3.0, z = 0.5},
		TeleportPoint = { coords = vector3(923.266, 47.645, 80.106), h = 180 }
	},
	{ --- [[ Spawn House Leave ]] --
		Marker = vector3(-24.726, -597.532, 79.033),
		MarkerSettings = {action = "auto_teleport", r = 0, g = 150, b = 200, a = 100, type = 1, x = 1.5, y = 1.5, z = 0.5},
		TeleportPoint = { coords = vector3(-51.466, -584.704, 35.800), h = 180 }
	},
	
	--- [[ Specific Large Pop Zones ]] --
	{ -- Casino (No Weapons, Timescale Modifier)
		Marker = vector3(1117.2705078125, 237.26304626465, -50.840763092041),
		MarkerSettings = {action = "casino", r = 0, g = 150, b = 200, a = 0, type = 1, x = 100.5, y = 100.5, z = 10.5},
	},
	{ -- Pillbox Hospital (No Vehicles)
		Marker = vector3(304.44161987305, -586.57824707031, 42.284076690674),
		MarkerSettings = {action = "pillbox", r = 0, g = 150, b = 200, a = 0, type = 1, x = 5.0, y = 5.0, z = 5.5},
	},
}

Config.Progression = {
	mechanic = {
		progress = 'pro_mechanic',
		hasMutex = true,
		label = 'Mechanic Progression',
		increase = 0.04,
		max = 4.0
	},
	ranger = {
		progress = 'pro_ranger',
		hasMutex = true,
		label = 'Ranger Progression',
		increase = 0.1,
		max = 4.0
	}
}

-----------------------------------