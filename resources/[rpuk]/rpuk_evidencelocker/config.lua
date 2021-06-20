config = {}

config.lockers = {
	police = {
		text = "Press [E] to access evidence locker",
		whitelisted = {
			"police",
		},
		positions = {
			{
				x = 474.184,
				y = -994.906,
				z = 26.574,
				dist = 7,
				canDeposit = true,
				canWithdraw = true
			},
		},
		access = {
			deposit = {
				police = 0,
			},
			withdraw = {
				police = 3,
			}
		}
	},
	lost = {
		text = "Press [E] to access storage",
		whitelisted = {
			"lost",
		},
		positions = {
			{
				x = 976.830,
				y = -103.740,
				z = 73.845,
				dist = 7,
				canDeposit = true,
				canWithdraw = true
			},
		},
		access = {
			deposit = {
				lost = 0
			},
			withdraw = {
				lost = 1
			}
		}
	},
	ambulance = {
		text = "Press [E] to access storage",
		whitelisted = {
			"ambulance"
		},
		positions = {
			{
				x = 309.559,
				y = -561.460,
				z = 42.28,
				dist = 7,
				canDeposit = true,
				canWithdraw = true
			}
		},
		access = {
			deposit = {
				ambulance = 0,
			},
			withdraw = {
				ambulance = 3
			}
		}
	},
	gruppe6 = {
		text = "Press [E] to access storage",
		whitelisted = {
			"gruppe6",
		},
		positions = {
			{
				x = 1831.6201171875,
				y = 2592.7221679688,
				z = 44.952323913574,
				dist = 7,
				canDeposit = true,
				canWithdraw = true
			}
		},
		access = {
			deposit = {
				gruppe6 = 1
			},
			withdraw = {
				gruppe6 = 2
			}
		}
	},
	prisonFood = {
		text = "Press [E] to use fridge",
		whitelisted = nil,
		positions = {
			{
				x = 1776.2196044922,
				y = 2599.6281738281,
				z = 44.960746765137,
				dist = 3,
				canDeposit = true,
				canWithdraw = true
			}
		},
		access = nil
	},
	storeagePrisonBox = {
		text = "Press [E] to open storage",
		whitelisted = nil,
		positions = {
			{
				x = 1685.9604492188,
				y = 2554.005859375,
				z = 44.1484375,
				dist = 3,
				canDeposit = true,
				canWithdraw = true,
				requiredItem = "prison_key"
			}
		},
		access = nil
	},
	storeagePrisonBox2 = {
		text = "Press [E] to open storage",
		whitelisted = nil,
		positions = {
			{
				x = 1630.7557373047,
				y = 2526.9714355469,
				z = 44.562747955322,
				dist = 3,
				canDeposit = true,
				canWithdraw = true,
				requiredItem = "prison_key"
			}
		},
		access = nil
	},
}

config.ammoTypes = {
    pistol = {
        label = "Pistol ammo",
        weaponHash = "WEAPON_PISTOL",
		max = 250,
		count = 0
    },
    shotgun = {
        label = "Shotgun ammo",
        weaponHash = "WEAPON_PUMPSHOTGUN",
		max = 250,
		count = 0
    },
    smg = {
        label = "SMG ammo",
        weaponHash = "WEAPON_SMG",
		max = 250,
		count = 0
    },
    assaultRifle = {
        label = "Assault rifle ammo",
        weaponHash = "WEAPON_ASSAULTRIFLE",
		max = 250,
		count = 0
    },
    lmg = { -- Missing image
        label = "LMG ammo",
        weaponHash = "WEAPON_MG",
		max = 250,
		count = 0
    },
    sniper = {
        label = "Sniper ammo",
        weaponHash = "WEAPON_SNIPERRIFLE",
		max = 250,
		count = 0
	},
	petrol = { -- Missing image
		label = "Petrol",
		weaponHash = "WEAPON_PETROLCAN",
		max = 4500,
		count = 0
	},
	musket = {
		label = "Musket Ball",
		weaponHash = "WEAPON_MUSKET",
		max = 20,
		count = 0
	},
}

config.ammo = {
    WEAPON_ASSAULTRIFLE = "assaultRifle",
    WEAPON_APPISTOL = "pistol",
    WEAPON_DBSHOTGUN = "shotgun",
    WEAPON_MARKSMANPISTOL = "pistol",
    WEAPON_DOUBLEACTION = "pistol",
    WEAPON_HEAVYSNIPER = "sniper",
    WEAPON_BULLPUPSHOTGUN = "shotgun",
    WEAPON_COMBATPISTOL = "pistol",
    WEAPON_PUMPSHOTGUN_MK2 = "shotgun",
    WEAPON_CARBINERIFLE_MK2 = "assaultRifle",
    WEAPON_PUMPSHOTGUN = "shotgun",
    WEAPON_HEAVYPISTOL = "pistol",
    WEAPON_PISTOL = "pistol",
    WEAPON_SPECIALCARBINE_MK2 = "assaultRifle",
    WEAPON_REVOLVER = "pistol",
    WEAPON_NAVYREVOLVER = "pistol",
    WEAPON_PISTOL_MK2 = "pistol",
    WEAPON_HEAVYSHOTGUN = "shotgun",
    WEAPON_SPECIALCARBINE = "assaultRifle",
    WEAPON_ASSAULTSMG = "smg",
    WEAPON_SMG = "smg",
    WEAPON_MICROSMG = "smg",
    WEAPON_CERAMICPISTOL = "pistol",
    WEAPON_MARKSMANRIFLE_MK2 = "sniper",
    WEAPON_SNIPERRIFLE = "sniper",
    WEAPON_VINTAGEPISTOL = "pistol",
    WEAPON_SMG_MK2 = "smg",
    WEAPON_MG = "lmg",
    WEAPON_MARKSMANRIFLE = "sniper",
    WEAPON_COMBATMG_MK2 = "lmg",
    WEAPON_COMBATMG = "lmg",
    WEAPON_SNSPISTOL_MK2 = "pistol",
    WEAPON_HEAVYSNIPER_MK2 = "sniper",
    WEAPON_GUSENBERG = "lmg",
    WEAPON_SNSPISTOL = "pistol",
    WEAPON_COMPACTRIFLE = "assaultRifle",
    WEAPON_ASSAULTSHOTGUN = "shotgun",
    WEAPON_AUTOSHOTGUN = "shotgun",
    WEAPON_MINISMG = "smg",
    WEAPON_COMBATPDW = "smg",
    WEAPON_ASSAULTRIFLE_MK2 = "assaultRifle",
    WEAPON_PISTOL50 = "pistol",
    WEAPON_ADVANCEDRIFLE = "assaultRifle",
    WEAPON_MACHINEPISTOL = "smg",
    WEAPON_CARBINERIFLE = "assaultRifle",
    WEAPON_MUSKET = "musket",
    WEAPON_BULLPUPRIFLE = "assaultRifle",
    WEAPON_BULLPUPRIFLE_MK2 = "assaultRifle",
    WEAPON_SAWNOFFSHOTGUN = "shotgun",
	WEAPON_REVOLVER_MK2 = "pistol",
	WEAPON_PETROLCAN = "petrol"
}

config.selling = {
	police = {
		text = "Press [E] to register item for disposal [Police]",
		whitelisted = {
			"police",
			"gruppe6"
		},
		positions = {
			{
				x = 2854.2900390625,
				y = 1564.6419677734,
				z = 23.530403137207
			},
		},
	},
}

config.items = {
	--Weapons
	{item = "WEAPON_FLASHLIGHT", price = 200, type = "item_weapon"},
	{item = "WEAPON_NIGHTSTICK", price = 200, type = "item_weapon"},
	{item = "WEAPON_PISTOL", price = 2500, type = "item_weapon"},
	{item = "WEAPON_COMBATPISTOL", price = 2500, type = "item_weapon"},
	{item = "WEAPON_VINTAGEPISTOL", price = 2500, type = "item_weapon"},
	{item = "WEAPON_SMG", price = 6000, type = "item_weapon"},
	{item = "WEAPON_SPECIALCARBINE", price = 6500, type = "item_weapon"},
	{item = "WEAPON_CARBINERIFLE_MK2", price = 7500, type = "item_weapon"},
	{item = "WEAPON_SNIPERRIFLE", price = 10000, type = "item_weapon"},
	{item = "WEAPON_GRENADELAUNCHER", price = 6000, type = "item_weapon"},
	{item = "WEAPON_SAWNOFFSHOTGUN", price = 7500, type = "item_weapon"},
	{item = "WEAPON_SMG_MK2", price = 8000, type = "item_weapon"},
	{item = "WEAPON_GUSENBERG", price = 9500, type = "item_weapon"},
	{item = "WEAPON_REVOLVER", price = 3000, type = "item_weapon"},
	{item = "WEAPON_COMPACTRIFLE", price = 8000, type = "item_weapon"},
	{item = "WEAPON_SHOTGUN", price = 9800, type = "item_weapon"},
	{item = "WEAPON_COMBATPDW", price = 6000, type = "item_weapon"},
	{item = "WEAPON_MOLOTOV", price = 800, type = "item_weapon"},
	{item = "WEAPON_MICROSMG", price = 3500, type = "item_weapon"},
	{item = "WEAPON_PUMPSHOTGUN", price = 6000, type = "item_weapon"},
	{item = "WEAPON_ASSAULTSHOTGUN", price = 8000, type = "item_weapon"},
	{item = "WEAPON_MACHINEPISTOL", price = 5500, type = "item_weapon"},
	{item = "WEAPON_DOUBLEACTION", price = 6000, type = "item_weapon"},
	{item = "WEAPON_DBSHOTGUN", price = 5500, type = "item_weapon"},
	{item = "WEAPON_PISTOL50", price = 9000, type = "item_weapon"},
	{item = "WEAPON_DOUBLEACTION", price = 6000, type = "item_weapon"},
	{item = "WEAPON_SNSPISTOL", price = 4000, type = "item_weapon"},
	{item = "WEAPON_BULLPUPRIFLE", price = 9000, type = "item_weapon"},
	{item = "WEAPON_ADVANCEDRIFLE", price = 8000, type = "item_weapon"},
	{item = "WEAPON_MARKSMANRIFLE", price = 5000, type = "item_weapon"},
	{item = "WEAPON_MUSKET", price = 4000, type = "item_weapon"},
	{item = "WEAPON_BAT", price = 100, type = "item_weapon"},

	-- Ammo
	{item = "pistol", price = 2, type = "item_ammo"},
	{item = "smg", price = 2, type = "item_ammo"},
	{item = "assaultRifle", price = 2, type = "item_ammo"},
	{item = "sniper", price = 2, type = "item_ammo"},
	{item = "beanBag", price = 2, type = "item_ammo"},
	{item = "musket", price = 2, type = "item_ammo"},

	--Items (keep old drugs because still in circulation)
	{item = "code_cracker", price = 3000, type = "item_standard"},
	{item = "advanced_lockpick", price = 300, type = "item_standard"},
	{item = "meth", price = 100, type = "item_standard"},
	{item = "marijuana", price = 120, type = "item_standard"},
	{item = "gunpowder", price = 60, type = "item_standard"},
	{item = "c4", price = 12000, type = "item_standard"},
	{item = "coca_leaves", price = 80, type = "item_standard"},
	{item = "cocaine", price = 120, type = "item_standard"},
	{item = "cannabis", price = 45, type = "item_standard"},
	{item = "grip", price = 30, type = "item_standard"},
	{item = "trigger", price = 35, type = "item_standard"},
	{item = "fiftycalmodification", price = 4000, type = "item_standard"},
	{item = "drill", price = 300, type = "item_standard"},

	-- New Drug Components
	{item = "comp_drug_methylamine", price = 80, type = "item_standard"},
	{item = "comp_drug_paracetamol", price = 80, type = "item_standard"},
	{item = "comp_drug_asprin", price = 80, type = "item_standard"},
	{item = "comp_drug_asprin", price = 80, type = "item_standard"},
	{item = "comp_drug_bicarb", price = 80, type = "item_standard"},
	{item = "comp_drug_powdmilk", price = 80, type = "item_standard"},
	{item = "comp_drug_ergotamine", price = 80, type = "item_standard"},
	{item = "comp_drug_fentanyl_dropper", price = 80, type = "item_standard"},
	{item = "comp_drug_lysergicacid", price = 80, type = "item_standard"},
	{item = "comp_drug_blottingpaper", price = 80, type = "item_standard"},
	{item = "comp_drug_soil", price = 80, type = "item_standard"},
	{item = "comp_drug_cannaseed_sativa", price = 80, type = "item_standard"},
	{item = "comp_drug_cannaseed_indica", price = 80, type = "item_standard"},
	{item = "comp_drug_plantpot", price = 80, type = "item_standard"},
	{item = "comp_drug_wateringcan", price = 80, type = "item_standard"},
	{item = "comp_drug_pseudo", price = 80, type = "item_standard"},
	{item = "comp_drug_iodine_bottle", price = 80, type = "item_standard"},
	{item = "comp_drug_phosphorus", price = 80, type = "item_standard"},
	{item = "comp_drug_plantfood", price = 80, type = "item_standard"},
	{item = "comp_drug_morphine", price = 80, type = "item_standard"},
	{item = "comp_drug_methanphetamine", price = 80, type = "item_standard"},
	{item = "comp_drug_methanphetamine_highgrade", price = 80, type = "item_standard"},
	{item = "comp_drug_sativabud", price = 80, type = "item_standard"},
	{item = "comp_drug_indicabud", price = 80, type = "item_standard"},
	{item = "comp_drug_growlights", price = 80, type = "item_standard"},
	{item = "comp_drug_plasticbag", price = 80, type = "item_standard"},
	{item = "comp_drug_cocaine_cut", price = 80, type = "item_standard"},
	{item = "comp_drug_cocaine_unrefined", price = 80, type = "item_standard"},
	{item = "comp_drug_crackcocaine_lump", price = 80, type = "item_standard"},
	{item = "comp_drug_lsd_oil", price = 80, type = "item_standard"},
	{item = "comp_drug_mdma_oil", price = 80, type = "item_standard"},
	{item = "comp_drug_pillpress", price = 80, type = "item_standard"},
	{item = "comp_drug_crystalmeth_tray", price = 80, type = "item_standard"},
	{item = "comp_drug_crystalmeth_highgrade_tray", price = 80, type = "item_standard"},
	{item = "comp_drug_diacetylmorphine", price = 80, type = "item_standard"},
	{item = "comp_drug_rizla", price = 80, type = "item_standard"},

	-- New Drugs
	{item = "drug_methadone_shot", price = 160, type = "item_standard"},
	{item = "drug_ketamine_bottle", price = 160, type = "item_standard"},
	{item = "drug_heroin_bag", price = 160, type = "item_standard"},
	{item = "drug_ecstacy_pill", price = 160, type = "item_standard"},
	{item = "drug_magicmushroom", price = 160, type = "item_standard"},
	{item = "drug_crack_bag", price = 160, type = "item_standard"},
	{item = "drug_lsd_tab", price = 160, type = "item_standard"},
	{item = "drug_cocaine_bag", price = 160, type = "item_standard"},
	{item = "drug_weed_sativa_bag", price = 160, type = "item_standard"},
	{item = "drug_weed_indica_bag", price = 160, type = "item_standard"},
	{item = "drug_meth_highgrade_bag", price = 160, type = "item_standard"},
	{item = "drug_meth_midgrade_bag", price = 160, type = "item_standard"},
	{item = "drug_meth_lowgrade_bag", price = 160, type = "item_standard"},
	{item = "drug_nitrousoxide_bulb", price = 160, type = "item_standard"},
	{item = "drug_diazepam", price = 160, type = "item_standard"},

}