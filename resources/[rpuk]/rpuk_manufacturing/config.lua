config = {}

config.locations = {
	smeltery = {
		positions = {
			{
				x = 1115.2030029297,
				y = -2004.0891113281,
				z = 34.439399719238
			}
		},
		requiredJob = nil,
		unAuthorizedJob = {
			"police"
		},
		text = "Press [E] to use smeltery",
		recipes = {
			"coal_coke",
			"copper_ingot",
			"iron",
			"silver_ingot",
			"titanium_ingot",
			"aluminium_ingot",
			"gold",
			"steel_ingot",
			"lead_ingot"
		},
		hasStorage = true,
	},
	-- oilRefinery = {
	--     positions = {
	--         {
	--             x = 2776.3107910156,
	--             y = 1553.9166259766,
	--             z = 24.50065612793
	--         }
	--     },
	--     blip = {
	--         sprite = 361,
	--         colour = 1,
	--         display = "Oil refinery"
	--     },
	--     requiredJob = nil,
	--     unAuthorizedJob = {
	--         "police"
	--     },
	--     text = "Press [E] to use refinery",
	--     recipes = {
	--         "petrol_barrel",
	--     }
	-- },
	tacoShop = {
		positions = {
			{
				x = 10.864475250244,
				y = -1598.9122314453,
				z = 28.1
			}
		},
		blip = {
			sprite = 528,
			colour = 5,
			display = "The Tiny Big Taco"
		},
		requiredJob = nil,
		shopName = "The Tiny Big Taco",
		unAuthorizedJob = {
			"police"
		},
		text = "Press [E] to use oven",
		recipes = {
			"taco",
			"burger"
		},
		hasStorage = true,
	},

	burgerShop = {
		positions = {
			{
				x = -1202.7562255859,
				y = -897.45440673828,
				z = 12.6
			}
		},
		blip = {
			sprite = 528,
			colour = 5,
			display = "Burger Shot"
		},
		requiredJob = nil,
		shopName = "Burger Shot",
		unAuthorizedJob = {
			"police"
		},
		text = "Press [E] to use pan",
		recipes = {
			"taco",
			"burger"
		},
		hasStorage = true,
	},
	wilcoClub = {
		positions = {
			{
				x = -432.80328369141,
				y = 272.77725219727,
				z = 82.3
			}
		},
		requiredJob = nil,
		unAuthorizedJob = {
			"police"
		},
		text = "Press [E] to make drinks",
		shopName = "Wilco's Club",
		recipes = {
			"oldFashioned",
			"appletini",
			"tequilaSunrise",
			"spikedMichelada",
			"smoothie"
		},
		hasStorage = true,
	},
	legionRestaurant = {
		positions = {
			{
				x = 143.84352111816,
				y = -1052.9345703125,
				z = 21.6
			}
		},
		blip = {
			sprite = 528,
			colour = 5,
			display = "LS Restaurant"
		},
		requiredJob = nil,
		shopName = "Legion Restaurant",
		unAuthorizedJob = {
			"police"
		},
		text = "Press [E] to make food",
		recipes = {
			"taco",
			"burger",
			"breakfast"
		},
		hasStorage = true,
	},
	missionBar = {
		positions = {
			{
				x = 377.25115966797,
				y = -1080.7878417969,
				z = 28.257289123535
			}
		},
		blip = {
			sprite = 528,
			colour = 5,
			display = "LS Cocktail Lounge"
		},
		shopName = "LS Cocktail Lounge",
		requiredJob = nil,
		unAuthorizedJob = {
			"police"
		},
		text = "Press [E] to make drinks",
		recipes = {
			"oldFashioned",
			"appletini",
			"tequilaSunrise",
			"spikedMichelada",
			"smoothie"
		},
		hasStorage = true,
	},
	soberDrink = {
		positions = {
			{
				x = 13.596351623535,
				y = -1595.6694335938,
				z = 28.362403869629
			},

			{
				x = -1199.4924316406,
				y = -895.59906005859,
				z = 13.038387298584

			},

			{
				x = -1199.4924316406,
				y = -895.59906005859,
				z = 13.038387298584
			},

		},
		requiredJob = nil,
		unAuthorizedJob = {
			"police"
		},
		text = "Press [E] to make drinks",
		shopName = "LS Cocktail Lounge",
		recipes = {
			"smoothie",
		},
		hasStorage = true,
	},
	alcoholDrink = {
		positions = {
			{
				x = 131.03157043457,
				y = -1057.0166015625,
				z = 21.60
			},

			{
				x = 126.39498901367,
				y = -1036.5196533203,
				z = 27.84585723877
			},
		},
		requiredJob = nil,
		unAuthorizedJob = {
			"police"
		},
		text = "Press [E] to make drinks",
		shopName = "Alcohol Mixing",
		recipes = {
			"oldFashioned",
			"appletini",
			"tequilaSunrise",
			"spikedMichelada",
			"smoothie"
		},
		hasStorage = true,
	},
	prison = {
		positions = {
			{
				x = 1778.2641601563,
				y = 2598.0927734375,
				z = 44.298081970215
			},
		},
		requiredJob = nil,
		unAuthorizedJob = {},
		text = "Press [E] to make food",
		shopName = "Prison Grub",
		recipes = {
			"taco",
			"burger",
			"smoothie"
		},
		hasStorage = true,
	},

	beanMachine = {
		positions = {
			{
				x = -635.56903076172,
				y = 236.43330383301,
				z = 82.213882446289
			},
		},
		requiredJob = nil,
		unAuthorizedJob = {},
		text = "Press [E] to make drinks",
		shopName = "Bean Machine",
		recipes = {
			"smoothie"
		},
		hasStorage = true,

	},

	craftBenchLost = {
		positions = {
			{
				x = 991.119,
				z = 72.926,
				y = -113.059,
			},
			{
				x = 995.333,
				y = -115.262,
				z = 72.926
			},			
		},
		requiredJob = {"lost"},
		unAuthorizedJob = {},
		text = "Press [E] to craft",
		shopName = "Crafting Bench",
		recipes = {
			"pistol50",
			"microsmg",
			"compactrifle",
			"machinepistol",
			"combatpdw",
			"gusenberg",
			"sawnoffshotgun",
			"pistol_ammo",
			"smg_ammo",
			"sniper_ammo",
			"shotgun_ammo",
			"assaultRifle_ammo",
			"lmg_ammo",
			"ziptie",
			"fiftycalmodification",
			"lockpick",
			"advanced_lockpick",
			"grip",
			"long_barrel",
			"short_barrel",
			"rifle_magazine",
			"smg_magazine",
			"pistol_magazine",
			"wood_stock",
			"wire_stock",
			"reciever_assembly",
			"tactical_rail",
			"trigger_assembly",
			"rotating_cylinder",
			"hammer",
			"drill",
			"slider_assembly",
			"boring_kit",
			"spring",
			"pistol",
			"vintagepistol",
		},
		hasStorage = true,
	},

	craftBenchEveryone = {
		positions = {
			{
				x = 2145.768,
				y = 4774.270,
				z = 39.834
			},
			{
				x = 244.894,
				y = 3111.687,
				z = 41.294
			},
			{
				x = -2220.066,
				y = -365.627,
				z = 12.167
			},
		},
		requiredJob = nil,
		unAuthorizedJob = {},
		text = "Press [E] to craft",
		shopName = "Crafting Bench",
		recipes = {
			"pistol_ammo",
			"ziptie",
			"fiftycalmodification",
			"lockpick",
			"advanced_lockpick",
			"grip",
			"long_barrel",
			"short_barrel",
			"pistol_magazine",
			"wood_stock",
			"wire_stock",
			"reciever_assembly",
			"tactical_rail",
			"trigger_assembly",
			"rotating_cylinder",
			"hammer",
			"drill",
			"slider_assembly",
			"boring_kit",
			"spring",
			"pistol",
			"vintagepistol",
			"pistol50",
		},
		hasStorage = true,
	},

	lab = {
		positions = {
			{
				x = 115.3175201416, 
				y = -1994.5391845703, 
				z = 12.40447807312
			},
			{
				x = 2433.4416503906,
				y = 4969.455078125,
				z = 40.8
			},
		},
		requiredJob = nil,
		unAuthorizedJob = {},
		text = "Press [E] to use lab",
		shopName = "Lab",
		recipes = {
			"gunpowder"
		},
		hasStorage = true,
	},
	conversionForPlastic = {
		positions = {
			{
				x = 110.65322113037,
				y = -2423.6896972656,
				z = 4.9
			},
		},
		requiredJob = nil,
		unAuthorizedJob = {},
		text = "Press [E] to start Refining Oil",
		shopName = "Refinery",
		blip = {
			sprite = 467,
			colour = 9,
			display = "Oil Refinery"
		},
		recipes = {
			"plastic"
		},
		hasStorage = true,
	},
	conversionForHemp = {
		positions = {
			{
				x = 713.82928466797,
				y = -972.19757080078,
				z = 28.8
			},
		},
		requiredJob = nil,
		unAuthorizedJob = {},
		text = "Press [E] to start making Hemp",
		shopName = "Hemp",
		recipes = {
			"hemp_wadding"
		},
		hasStorage = true,
	},
	prisonCrafting = {
		positions = {
			{
				x = 1763.6856689453,
				y = 2579.3911132812,
				z = 44.826251983643
			},
		},
		requiredJob = nil,
		unAuthorizedJob = {},
		text = "Press [E] to light plastic",
		shopName = "Showers",
		recipes = {
			"prison_key"
		},
		hasStorage = true,
	},
}

--[[

Theory:
	Smelting ores decrease mining skill to seperate miners from smelters
	Would potentially make mining companies and smelting companies which would fluctuate the market
	Playerstores could request ores which players can sell to
]]

config.recipes = {
	prison_key = {
		itemsRequired = {
			PLASTIC_SHEET = {
				type = "item_standard",
				count = 25,
				remove = true
			},
		},
		itemsReturned = {
			prison_key = {
				type = "item_standard",
				count = 1
			}
		},
		animation = {
			animDict = "missheistfbisetup1",
			anim = "unlock_loop_janitor",
			flags = 49,
			task = nil,
		},
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		text = "Lighting Plastic To Make Key",
		time = 25000,
		secondInventory = {
			name = "prison_key",
			type = "item_standard",
			count = 1
		}
	},
--[[ Example
	coal_coke = { -- Recipe Name (keeps same as returned item)
		itemsRequired = {
			coal = { -- Required item(s) spawn name
				type = "item_standard", -- (item_standard) - Virtual Items | (item_ammo) - Ammo | (item_weapon) - Weapons
				count = 2 - Amount Required
			},
		},
		itemsReturned = {
			coal_coke = { -- Returned item(s) spawn name
				type = "item_standard", -- (item_standard) - Virtual Items | (item_ammo) - Ammo | (item_weapon) - Weapons
				count = 1 - Amount Returned
			},
		},
		skill = {
			required = {
				{
					name = "pro_smelt", -- Name of skill that is required to craft x item (Has to have a max skill level on line - 11)
					requiredLevel = 0, -- Level of skill that is required to craft x item
				}
			},
			increase = {
				{
					name = "pro_smelt", -- Name of skill that is increased from crafting
					increase = 0.005 -- Amount of skill is increased by from crafting
				}
			},
			decrease = {
				{
					name = "pro_smelt",-- Name of skill that is decreased from crafting
					decrease = 0.002 -- Amount of skill that is decreased from crafting
				}
			},
			speedIncreaseSkill = 0.25 -- Increase on time it takes to create x
		},
		animation = { -- Animation settings
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = { -- Remove if not used
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 2500, -- time it takes to craft x in ms
		text = "Smelting coal into Coal coke", -- text that is on the progress bar
		controlDisables = { -- During progress bar what is blocked.
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = { -- What is shown in second inv
			name = "coal_coke",
			type = "item_standard",
			count = 1
		}
	},
]]

	lockpick = {
		itemsRequired = {
			steel_ingot = {
				type = "item_standard",
				count = 4,
				remove = true
			},
		},
		itemsReturned = {
			lockpick = {
				type = "item_standard",
				count = 1
			}
		},
		skill = {
			required = {
				{
					name = "pro_crafting",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_crafting",
					increase = 0.003
				}
			},
			speedIncreaseSkill = 0.20
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 15000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "lockpick",
			type = "item_standard",
			count = 1
		}
	},

	advanced_lockpick = {
		itemsRequired = {
			titanium_ingot = {
				type = "item_standard",
				count = 8,
				remove = true
			},
			PLASTIC_SHEET = {
				type = "item_standard",
				count = 5,
				remove = true
			},
		},
		itemsReturned = {
			advanced_lockpick = {
				type = "item_standard",
				count = 1
			}
		},
		skill = {
			required = {
				{
					name = "pro_crafting",
					requiredLevel = 2,
				}
			},
			increase = {
				{
					name = "pro_crafting",
					increase = 0.004
				}
			},
			speedIncreaseSkill = 0.20
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 15000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "advanced_lockpick",
			type = "item_standard",
			count = 1
		}
	},

	ziptie = {
		itemsRequired = {
			PLASTIC_SHEET = {
				type = "item_standard",
				count = 5,
				remove = true
			},
			WEAPON_KNIFE = {
				type = "item_weapon",
				count = 1,
				remove = false
			}
		},
		itemsReturned = {
			ziptie = {
				type = "item_standard",
				count = 1
			}
		},
		text = "Cutting fine strips into zipties",
		time = 30000,
		animation = {
			animDict = "amb@medic@standing@tendtodead@idle_a",
			anim = "idle_a",
			flags = 49,
			task = nil,
		},
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "ziptie",
			type = "item_standard",
			count = 1
		}
	},

	--Weapons/Ammo

	grip = {
		itemsRequired = {
			cutted_wood = {
				type = "item_standard",
				count = 40,
				remove = true
			},
			steel_ingot = {
				type = "item_standard",
				count = 20,
				remove = true
			},
		},
		itemsReturned = {
			grip = {
				type = "item_standard",
				count = 1
			}
		},
		skill = {
			required = {
				{
					name = "pro_crafting",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_crafting",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 60000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "grip",
			type = "item_standard",
			count = 1
		}
	},

	long_barrel = {
		itemsRequired = {
			steel_ingot = {
				type = "item_standard",
				count = 40,
				remove = true
			},
			titanium_ingot = {
				type = "item_standard",
				count = 10,
				remove = true
			}
		},
		itemsReturned = {
			long_barrel = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 120000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "long_barrel",
			type = "item_standard",
			count = 1
		}
	},

	short_barrel = {
		itemsRequired = {
			steel_ingot = {
				type = "item_standard",
				count = 30,
				remove = true
			}
		},
		itemsReturned = {
			short_barrel = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 60000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "short_barrel",
			type = "item_standard",
			count = 1
		}
	},

	rifle_magazine = {
		itemsRequired = {
			spring = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			assaultRifle = {
				type = "item_ammo",
				count = 30,
				remove = true
			},
			steel_ingot = {
				type = "item_standard",
				count = 10,
				remove = true
			}
		},
		itemsReturned = {
			rifle_magazine = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		-- prop = {
		-- 	model = "prop_tool_hammer",
		-- 	bone = 28422,
		-- 	coords = { x = 0.0, y = 0.0, z = 0.0 },
		-- 	rotation = { x = 0.0, y = 0.0, z = 0.0 },
		-- },
		time = 180000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "rifle_magazine",
			type = "item_standard",
			count = 1
		}
	},

	smg_magazine = {
		itemsRequired = {
			spring = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			smg = {
				type = "item_ammo",
				count = 30,
				remove = true
			},
			steel_ingot = {
				type = "item_standard",
				count = 5,
				remove = true
			}
		},
		itemsReturned = {
			smg_magazine = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 180000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "smg_magazine",
			type = "item_standard",
			count = 1
		}
	},

	pistol_magazine = {
		itemsRequired = {
			spring = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			pistol = {
				type = "item_ammo",
				count = 15,
				remove = true
			},
			steel_ingot = {
				type = "item_standard",
				count = 5,
				remove = true
			}
		},
		itemsReturned = {
			pistol_magazine = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 180000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "pistol_magazine",
			type = "item_standard",
			count = 1
		}
	},

	wood_stock = {
		itemsRequired = {
			cutted_wood = {
				type = "item_standard",
				count = 40,
				remove = true
			},
			steel_ingot = {
				type = "item_standard",
				count = 10,
				remove = true
			}
		},
		itemsReturned = {
			wood_stock = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 60000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "wood_stock",
			type = "item_standard",
			count = 1
		}
	},

	wire_stock = {
		itemsRequired = {
			aluminium_ingot = {
				type = "item_standard",
				count = 40,
				remove = true
			}
		},
		itemsReturned = {
			wire_stock = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 60000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "wire_stock",
			type = "item_standard",
			count = 1
		}
	},

	reciever_assembly = {
		itemsRequired = {
			steel_ingot = {
				type = "item_standard",
				count = 15,
				remove = true
			},
			titanium_ingot = {
				type = "item_standard",
				count = 15,
				remove = true
			},
			copper_ingot = {
				type = "item_standard",
				count = 8,
				remove = true
			}
		},
		itemsReturned = {
			reciever_assembly = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 60000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "reciever_assembly",
			type = "item_standard",
			count = 1
		}
	},

	tactical_rail = {
		itemsRequired = {
			aluminium_ingot = {
				type = "item_standard",
				count = 30,
				remove = true
			},
			steel_ingot = {
				type = "item_standard",
				count = 20,
				remove = true
			}
		},
		itemsReturned = {
			tactical_rail = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 60000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "tactical_rail",
			type = "item_standard",
			count = 1
		}
	},

	trigger_assembly = {
		itemsRequired = {
			aluminium_ingot = {
				type = "item_standard",
				count = 30,
				remove = true
			},
			steel_ingot = {
				type = "item_standard",
				count = 20,
				remove = true
			}
		},
		itemsReturned = {
			trigger_assembly = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 60000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "trigger_assembly",
			type = "item_standard",
			count = 1
		}
	},

	rotating_cylinder = {
		itemsRequired = {
			steel_ingot = {
				type = "item_standard",
				count = 2,
				remove = true
			},
			aluminium_ingot = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			rotating_cylinder = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 60000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "rotating_cylinder",
			type = "item_standard",
			count = 1
		}
	},

	hammer = {
		itemsRequired = {
			copper_ingot = {
				type = "item_standard",
				count = 15,
				remove = true
			},
			steel_ingot = {
				type = "item_standard",
				count = 15,
				remove = true
			}
		},
		itemsReturned = {
			hammer = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 60000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "hammer",
			type = "item_standard",
			count = 1
		}
	},

	drill = {
		itemsRequired = {
			steel_ingot = {
				type = "item_standard",
				count = 150,
				remove = true
			},
			copper_ingot = {
				type = "item_standard",
				count = 50,
				remove = true
			},
			titanium_ingot = {
				type = "item_standard",
				count = 50,
				remove = true
			}
		},
		itemsReturned = {
			hammer = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 300000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "hammer",
			type = "item_standard",
			count = 1
		}
	},

	fiftycalmodification = {
		itemsRequired = {
			steel_ingot = {
				type = "item_standard",
				count = 30,
				remove = true
			},
			aluminium_ingot = {
				type = "item_standard",
				count = 30,
				remove = true
			}
		},
		itemsReturned = {
			fiftycalmodification = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 60000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "fiftycalmodification",
			type = "item_standard",
			count = 1
		}
	},

	slider_assembly = {
		itemsRequired = {
			steel_ingot = {
				type = "item_standard",
				count = 30,
				remove = true
			}
		},
		itemsReturned = {
			slider_assembly = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 60000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "slider_assembly",
			type = "item_standard",
			count = 1
		}
	},

	boring_kit = {
		itemsRequired = {
			steel_ingot = {
				type = "item_standard",
				count = 25,
				remove = true
			},
			diamond = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			boring_kit = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 120000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "boring_kit",
			type = "item_standard",
			count = 1
		}
	},

	spring = {
		itemsRequired = {
			steel_ingot = {
				type = "item_standard",
				count = 10,
				remove = true
			}
		},
		itemsReturned = {
			spring = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 30000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "spring",
			type = "item_standard",
			count = 1
		}
	},

--- Weapons
	vintagepistol = {
		itemsRequired = {
			--blueprint_vintage = {
			--	type = "item_standard",
			--	count = 1,
			--	remove = true
			--},
			grip = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			pistol_magazine = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			trigger_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			slider_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			},
		},
		itemsReturned = {
			WEAPON_VINTAGEPISTOL = {
				type = "item_weapon",
				count = 1
			},
			pistol = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 200000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_VINTAGEPISTOL",
			type = "item_weapon",
			count = 1
		}
	},

	pistol = {
		itemsRequired = {
			--blueprint_pistol = {
			--	type = "item_standard",
			--	count = 1,
			--	remove = true
			--},
			grip = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			pistol_magazine = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			slider_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			WEAPON_PISTOL = {
				type = "item_weapon",
				count = 1
			},
			pistol = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 400000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_PISTOL",
			type = "item_weapon",
			count = 1
		}
	},

	pistol50 = {
		itemsRequired = {
			--blueprint_50pistol = {
			--	type = "item_standard",
			--	count = 1,
			--	remove = true
			--},
			WEAPON_PISTOL = {
				type = "item_weapon",
				count = 1,
				remove = true
			},
			fiftycalmodification = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			boring_kit = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			drill = {
				type = "item_standard",
				count = 1,
				remove = false
			}
		},
		itemsReturned = {
			WEAPON_PISTOL50 = {
				type = "item_weapon",
				count = 1
			},
			pistol = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 500000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_PISTOL50",
			type = "item_weapon",
			count = 1
		}
	},

	microsmg = {
		itemsRequired = {
			blueprint_uzi = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			wire_stock = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			smg_magazine = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			trigger_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			tactical_rail = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			reciever_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			WEAPON_MICROSMG = {
				type = "item_weapon",
				count = 1
			},
			smg = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 600000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_MICROSMG",
			type = "item_weapon",
			count = 1
		}
	},

	compactrifle = {
		itemsRequired = {
			blueprint_compactrifle = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			wood_stock = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			long_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			rifle_magazine = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			trigger_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			tactical_rail = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			reciever_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			WEAPON_COMPACTRIFLE = {
				type = "item_weapon",
				count = 1
			},
			assaultRifle = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 600000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_COMPACTRIFLE",
			type = "item_weapon",
			count = 1
		}
	},

	machinepistol = {
		itemsRequired = {
			blueprint_machinepistol = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			wire_stock = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			smg_magazine = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			trigger_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			reciever_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			WEAPON_MACHINEPISTOL = {
				type = "item_weapon",
				count = 1
			},
			smg = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 600000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_MACHINEPISTOL",
			type = "item_weapon",
			count = 1
		}
	},

	combatpdw = {
		itemsRequired = {
			blueprint_combatpdw = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			wire_stock = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			smg_magazine = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			trigger_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			reciever_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			tactical_rail = {
				type = "item_standard",
				count = 1,
				remove = true
			},
		},
		itemsReturned = {
			WEAPON_COMBATPDW = {
				type = "item_weapon",
				count = 1
			},
			smg = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 600000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_COMBATPDW",
			type = "item_weapon",
			count = 1
		}
	},

	gusenberg = {
		itemsRequired = {
			blueprint_gusenberg = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			wood_stock = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			smg_magazine = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			trigger_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			reciever_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			WEAPON_GUSENBERG = {
				type = "item_weapon",
				count = 1
			},
			smg = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 600000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_GUSENBERG",
			type = "item_weapon",
			count = 1
		}
	},

	sawnoffshotgun = {
		itemsRequired = {
			blueprint_sawnoffshotgun = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			wood_stock = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 2,
				remove = true
			},
			trigger_assembly = {
				type = "item_standard",
				count = 2,
				remove = true
			},
			hammer = {
				type = "item_standard",
				count = 2,
				remove = true
			}
		},
		itemsReturned = {
			WEAPON_SAWNOFFSHOTGUN = {
				type = "item_weapon",
				count = 1
			},
			shotgun = {
				type = "item_ammo",
				count = 15
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 600000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_SAWNOFFSHOTGUN",
			type = "item_weapon",
			count = 1
		}
	},

	-- shotgun = { -- ?? Again this doesn't exist helloo?
	-- 	itemsRequired = {
	-- 		blueprint_shotgun = {
	-- 			type = "item_standard",
	-- 			count = 1,
	-- 			remove = true
	-- 		},
	-- 		wood_stock = {
	-- 			type = "item_standard",
	-- 			count = 1,
	-- 			remove = true
	-- 		},
	-- 		long_barrel = {
	-- 			type = "item_standard",
	-- 			count = 2,
	-- 			remove = true
	-- 		},
	-- 		trigger_assembly = {
	-- 			type = "item_standard",
	-- 			count = 2,
	-- 			remove = true
	-- 		},
	-- 		hammer = {
	-- 			type = "item_standard",
	-- 			count = 2,
	-- 			remove = true
	-- 		}
	-- 	},
	-- 	itemsReturned = {
	-- 		WEAPON_SHOTGUN = {
	-- 			type = "item_weapon",
	-- 			count = 1
	-- 		},
	-- 		shotgun = {
	-- 			type = "item_ammo",
	-- 			count = 15
	-- 		}
	-- 	},
	-- 	skill = {
	-- 		required = {
	-- 			{
	-- 				name = "pro_weapons",
	-- 				requiredLevel = 0,
	-- 			}
	-- 		},
	-- 		increase = {
	-- 			{
	-- 				name = "pro_weapons",
	-- 				increase = 0.005
	-- 			}
	-- 		},
	-- 		speedIncreaseSkill = 0.25
	-- 	},
	-- 	animation = {
	-- 		animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
	-- 		anim = "fidget_low_loop",
	-- 		flags = 49,
	-- 		task = nil,
	-- 	},
	-- 	prop = {
	-- 		model = "prop_tool_hammer",
	-- 		bone = 28422,
	-- 		coords = { x = 0.0, y = 0.0, z = 0.0 },
	-- 		rotation = { x = 0.0, y = 0.0, z = 0.0 },
	-- 	},
	-- 	time = 600000, -- ms
	-- 	text = "Crafting",
	-- 	controlDisables = {
	-- 		disableMovement = true,
	-- 		disableCarMovement = false,
	-- 		disableMouse = false,
	-- 		disableCombat = false,
	-- 	},
	-- 	secondInventory = {
	-- 		name = "WEAPON_SHOTGUN",
	-- 		type = "item_weapon",
	-- 		count = 1
	-- 	}
	-- },


	gangPistol1 = {
		itemsRequired = {
			blueprint_gangpistol = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			grip = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			slider_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			WEAPON_GROVEM1911 = {
				type = "item_weapon",
				count = 1
			},
			pistol = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 200000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_GROVEM1911",
			type = "item_weapon",
			count = 1
		}
	},
	gangPistol2 = {
		itemsRequired = {
			blueprint_gangpistol = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			grip = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			slider_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			WEAPON_BALLAM1911 = {
				type = "item_weapon",
				count = 1
			},
			pistol = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 200000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_BALLAM1911",
			type = "item_weapon",
			count = 1
		}
	},
	gangPistol3 = {
		itemsRequired = {
			blueprint_gangpistol = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			grip = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			slider_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			WEAPON_VAGOSM1911 = {
				type = "item_weapon",
				count = 1
			},
			pistol = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 200000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_VAGOSM1911",
			type = "item_weapon",
			count = 1
		}
	},
	gangPistol4 = {
		itemsRequired = {
			blueprint_gangpistol = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			grip = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			slider_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			WEAPON_MARAGRANDEM1911 = {
				type = "item_weapon",
				count = 1
			},
			pistol = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 200000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_MARAGRANDEM1911",
			type = "item_weapon",
			count = 1
		}
	},
	gangPistol5 = {
		itemsRequired = {
			blueprint_gangpistol = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			grip = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			slider_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			WEAPON_AZTECAM1911 = {
				type = "item_weapon",
				count = 1
			},
			pistol = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 200000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_AZTECAM1911",
			type = "item_weapon",
			count = 1
		}
	},
	gangPistol6 = {
		itemsRequired = {
			blueprint_gangpistol = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			grip = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			short_barrel = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			slider_assembly = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			WEAPON_TRIADSM1911 = {
				type = "item_weapon",
				count = 1
			},
			pistol = {
				type = "item_ammo",
				count = 30
			}
		},
		skill = {
			required = {
				{
					name = "pro_weapons",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_weapons",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		time = 200000, -- ms
		text = "Crafting",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "WEAPON_TRIADSM1911",
			type = "item_weapon",
			count = 1
		}
	},

	-- Weapon Parts
	--Food/Drink Recipes
	smoothie = {
		itemsRequired = {
			apple = {
				type = "item_standard",
				count = 4,
				remove = true
			},
			orange = {
				type = "item_standard",
				count = 4,
				remove = true
			},
		},
		itemsReturned = {
			smoothie = {
				type = "item_standard",
				count = 1
			}
		},
		skill = {
			required = {
				{
					name = "pro_food",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_food",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "anim@amb@business@coc@coc_unpack_cut@",
			anim = "fullcut_cycle_v6_cokecutter",
			flags = 49,
			task = nil,
		},
		time = 6500, -- ms
		text = "Blending Fruit",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "smoothie",
			type = "item_standard",
			count = 1
		}
	},

	taco = {
		itemsRequired = {
			beef = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			vegetables = {
				type = "item_standard",
				count = 1,
				remove = true
			},
		},
		itemsReturned = {
			taco = {
				type = "item_standard",
				count = 1
			}
		},
		skill = {
			required = {
				{
					name = "pro_food",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_food",
					increase = 0.015
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "amb@prop_human_bbq@male@idle_b",
			anim = "idle_e",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_kitch_pot_fry",
			bone = 57005,
			coords = { x = 0.35, y = 0.0, z = -0.01 },
			rotation = { x = 9.0, y = 4.5, z = 190.0  },
		},
		time = 5000, -- ms
		text = "Cooking Taco",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "taco",
			type = "item_standard",
			count = 1
		}
	},

	burger = {
		itemsRequired = {
			beef = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			bread = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			vegetables = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			burger = {
				type = "item_standard",
				count = 1
			}
		},
		skill = {
			required = {
				{
					name = "pro_food",
					requiredLevel = 1.0,
				}
			},
			increase = {
				{
					name = "pro_food",
					increase = 0.009
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "amb@prop_human_bbq@male@idle_b",
			anim = "idle_e",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_kitch_pot_fry",
			bone = 57005,
			coords = { x = 0.35, y = 0.0, z = -0.01 },
			rotation = { x = 9.0, y = 4.5, z = 190.0  },
		},
		time = 6000, -- ms
		text = "Cooking Burger",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "burger",
			type = "item_standard",
			count = 1
		}
	},

	breakfast = {
		itemsRequired = {
			sausage = {
				type = "item_standard",
				count = 2,
				remove = true
			},
			eggs = {
				type = "item_standard",
				count = 2,
				remove = true
			},
			beans = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			bread = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			bacon = {
				type = "item_standard",
				count = 2,
				remove = true
			}
		},
		itemsReturned = {
			breakfast = {
				type = "item_standard",
				count = 1
			}
		},
		skill = {
			required = {
				{
					name = "pro_food",
					requiredLevel = 3.0,
				}
			},
			increase = {
				{
					name = "pro_food",
					increase = 0.015
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "amb@prop_human_bbq@male@idle_b",
			anim = "idle_e",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_kitch_pot_fry",
			bone = 57005,
			coords = { x = 0.35, y = 0.0, z = -0.01 },
			rotation = { x = 9.0, y = 4.5, z = 190.0  },
		},
		time = 15000, -- ms
		text = "Cooking breakfast",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "breakfast",
			type = "item_standard",
			count = 1
		}
	},

	oldFashioned = {
		itemsRequired = {
			whisky = {
				type = "item_standard",
				count = 2,
				remove = true
			},
			orange = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			brownSugar = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			oldFashioned = {
				type = "item_standard",
				count = 1
			}
		},
		skill = {
			required = {
				{
					name = "pro_food",
					requiredLevel = 2,
				}
			},
			increase = {
				{
					name = "pro_food",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "anim@amb@business@coc@coc_unpack_cut@",
			anim = "fullcut_cycle_v6_cokecutter",
			flags = 49,
			task = nil,
		},
		time = 6500, -- ms
		text = "Stirring Up a Storm",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "oldFashioned",
			type = "item_standard",
			count = 1
		}
	},
	appletini = {
		itemsRequired = {
			vodka = {
				type = "item_standard",
				count = 2,
				remove = true
			},
			apple = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			brownSugar = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			appletini = {
				type = "item_standard",
				count = 1
			}
		},
		skill = {
			required = {
				{
					name = "pro_food",
					requiredLevel = 2,
				}
			},
			increase = {
				{
					name = "pro_food",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "anim@amb@business@coc@coc_unpack_cut@",
			anim = "fullcut_cycle_v6_cokecutter",
			flags = 49,
			task = nil,
		},
		time = 7000, -- ms
		text = "Shaking...",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "appletini",
			type = "item_standard",
			count = 1
		}
	},


	tequilaSunrise = {
		itemsRequired = {
			tequila = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			orange = {
				type = "item_standard",
				count = 1,
				remove = true
			},
		},
		itemsReturned = {
			tequilaSunrise = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_food",
					requiredLevel = 1,
				}
			},
			increase = {
				{
					name = "pro_food",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "anim@amb@business@coc@coc_unpack_cut@",
			anim = "fullcut_cycle_v6_cokecutter",
			flags = 49,
			task = nil,
		},
		time = 8500, -- ms
		text = "Stirring Up a Storm",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "tequilaSunrise",
			type = "item_standard",
			count = 1
		}
	},

	spikedMichelada = {
		itemsRequired = {
			beer = {
				type = "item_standard",
				count = 2,
				remove = true
			},
			tequila = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			orange = {
				type = "item_standard",
				count = 1,
				remove = true
			},
		},
		itemsReturned = {
			spikedMichelada = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_food",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_food",
					increase = 0.005
				}
			},
			speedIncreaseSkill = 0.25
		},
		animation = {
			animDict = "anim@amb@business@coc@coc_unpack_cut@",
			anim = "fullcut_cycle_v6_cokecutter",
			flags = 49,
			task = nil,
		},
		time = 6000, -- ms
		text = "Stirring Up a Storm",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "spikedMichelada",
			type = "item_standard",
			count = 1
		}
	},

	-- Mining Resources
	coal_coke = {
		itemsRequired = {
			coal = {
				type = "item_standard",
				count = 2,
				remove = true
			},
		},
		itemsReturned = {
			coal_coke = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_smelt",
					requiredLevel = 0,
				}
			},
			increase = {
				{
					name = "pro_smelt",
					increase = 0.001
				}
			},
			decrease = {
				{
					name = "pro_mining",
					decrease = 0.001
				}
			},
			speedIncreaseSkill = 0.25
		},
		time = 6500, -- ms
		text = "Smelting coal into Coal coke",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "coal_coke",
			type = "item_standard",
			count = 1
		}
	},
	copper_ingot = {
		itemsRequired = {
			copper_ore = {
				type = "item_standard",
				count = 2,
				remove = true
			},
		},
		itemsReturned = {
			copper_ingot = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_smelt",
					requiredLevel = 1,
				}
			},
			increase = {
				{
					name = "pro_smelt",
					increase = 0.0008
				}
			},
			decrease = {
				{
					name = "pro_mining",
					decrease = 0.0008
				}
			},
			speedIncreaseSkill = 0.25
		},
		time = 6500, -- ms
		text = "Smelting copper ore into copper ingot",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "copper_ingot",
			type = "item_standard",
			count = 1
		}
	},
	iron = {
		itemsRequired = {
			ore_iron = {
				type = "item_standard",
				count = 2,
				remove = true
			},
		},
		itemsReturned = {
			iron = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_smelt",
					requiredLevel = 1,
				}
			},
			increase = {
				{
					name = "pro_smelt",
					increase = 0.0008
				}
			},
			decrease = {
				{
					name = "pro_mining",
					decrease = 0.0008
				}
			},
			speedIncreaseSkill = 0.25
		},
		time = 6500, -- ms
		text = "Smelting iron ore into iron ingot",
		secondInventory = {
			name = "iron",
			type = "item_standard",
			count = 1
		}
	},
	silver_ingot = {
		itemsRequired = {
			silver_ore = {
				type = "item_standard",
				count = 2,
				remove = true
			},
		},
		itemsReturned = {
			silver_ingot = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_smelt",
					requiredLevel = 2,
				}
			},
			increase = {
				{
					name = "pro_smelt",
					increase = 0.0007
				}
			},
			decrease = {
				{
					name = "pro_mining",
					decrease = 0.0007
				}
			},
			speedIncreaseSkill = 0.25
		},
		time = 6500, -- ms
		text = "Smelting silver ore into silver ingot",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "silver_ingot",
			type = "item_standard",
			count = 1
		}
	},
	titanium_ingot = {
		itemsRequired = {
			titanium_ore = {
				type = "item_standard",
				count = 2,
				remove = true
			},
		},
		itemsReturned = {
			titanium_ingot = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_smelt",
					requiredLevel = 2,
				}
			},
			increase = {
				{
					name = "pro_smelt",
					increase = 0.0007
				}
			},
			decrease = {
				{
					name = "pro_mining",
					decrease = 0.0007
				}
			},
			speedIncreaseSkill = 0.25
		},
		time = 6500, -- ms
		text = "Smelting titanium ore into titanium ingot",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "titanium_ingot",
			type = "item_standard",
			count = 1
		}
	},
	aluminium_ingot = {
		itemsRequired = {
			aluminium_ore = {
				type = "item_standard",
				count = 2,
				remove = true
			},
		},
		itemsReturned = {
			aluminium_ingot = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_smelt",
					requiredLevel = 2,
				}
			},
			increase = {
				{
					name = "pro_smelt",
					increase = 0.0007
				}
			},
			decrease = {
				{
					name = "pro_mining",
					decrease = 0.0007
				}
			},
			speedIncreaseSkill = 0.25
		},
		time = 6500, -- ms
		text = "Smelting aluminium ore into aluminium ingot",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "aluminium_ingot",
			type = "item_standard",
			count = 1
		}
	},
	lead_ingot = {
		itemsRequired = {
			lead_ore = {
				type = "item_standard",
				count = 2,
				remove = true
			},
		},
		itemsReturned = {
			lead_ingot = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_smelt",
					requiredLevel = 3,
				}
			},
			increase = {
				{
					name = "pro_smelt",
					increase = 0.0005
				}
			},
			decrease = {
				{
					name = "pro_mining",
					decrease = 0.0005
				}
			},
			speedIncreaseSkill = 0.25
		},
		time = 6500, -- ms
		text = "Smelting lead ore into lead ingot",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "lead_ingot",
			type = "item_standard",
			count = 1
		}
	},
	gold = {
		itemsRequired = {
			ore_gold = {
				type = "item_standard",
				count = 2,
				remove = true
			},
		},
		itemsReturned = {
			gold = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_smelt",
					requiredLevel = 3,
				}
			},
			decrease = {
				{
					name = "pro_smelt",
					decrease = 0.0001
				}
			},
			speedIncreaseSkill = 0.25
		},
		time = 6500, -- ms
		text = "Smelting gold ore into gold ingot",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "gold",
			type = "item_standard",
			count = 1
		}
	},
	steel_ingot = {
		itemsRequired = {
			iron = {
				type = "item_standard",
				count = 2,
				remove = true
			},
			coal_coke = {
				type = "item_standard",
				count = 1,
				remove = true
			},
		},
		itemsReturned = {
			steel_ingot = {
				type = "item_standard",
				count = 1
			},
		},
		skill = {
			required = {
				{
					name = "pro_smelt",
					requiredLevel = 4,
				}
			},
			increase = {
				{
					name = "pro_smelt",
					increase = 0.005
				}
			},
			decrease = {
				{
					name = "pro_mining",
					decrease = 0.002
				}
			},
			speedIncreaseSkill = 0.25
		},
		time = 6500, -- ms
		text = "Smelting Iron and Coal into steel ingot(s)",
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "steel_ingot",
			type = "item_standard",
			count = 1
		}
	},

	-- Other
	plastic = {
		itemsRequired = {
			petrol = {
				type = "item_standard",
				count = 2,
				remove = true
			}
		},
		itemsReturned = {
			PLASTIC_SHEET = {
				type = "item_standard",
				count = 1
			}
		},
		text = "Processing petrol into plastic sheets",
		time = 10000,
		animation = {
			animDict = "amb@medic@standing@tendtodead@idle_a",
			anim = "idle_a",
			flags = 49,
			task = nil,
		},
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		secondInventory = {
			name = "PLASTIC_SHEET",
			type = "item_standard",
			count = 1
		}
	},
	gunpowder = {
		itemsRequired = {
			potassium_nitrate = {
				type = "item_standard",
				count = 2,
				remove = true
			},
			sulphur = {
				type = "item_standard",
				count = 2,
				remove = true
			}
		},
		itemsReturned = {
			gunpowder = {
				type = "item_standard",
				count = 1
			}
		},
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		animation = {
			animDict = "amb@medic@standing@tendtodead@idle_a",
			anim = "idle_a",
			flags = 49,
			task = nil,
		},
		text = "Making gunpowder",
		time = 6000,
		secondInventory = {
			name = "gunpowder",
			type = "item_standard",
			count = 1
		}
	},

	hemp_wadding = {
		itemsRequired = {
			comp_drug_sativabud = {
				type = "item_standard",
				count = 2,
				remove = true
			},
		},
		itemsReturned = {
			hemp_wadding = {
				type = "item_standard",
				count = 1
			}
		},
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		animation = {
			animDict = "amb@medic@standing@tendtodead@idle_a",
			anim = "idle_a",
			flags = 49,
			task = nil,
		},
		text = "Making hemp wadding",
		time = 5000,
		secondInventory = {
			name = "hemp_wadding",
			type = "item_standard",
			count = 1
		}
	},

	-- Ammo manufacturing

	pistol_ammo = {
		itemsRequired = {
			gunpowder = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			lead_ingot = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			copper_ingot = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			pistol = {
				type = "item_ammo",
				count = 2
			}
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		text = "Making pistol rounds",
		time = 8000,
		secondInventory = {
			name = "pistol",
			type = "item_ammo",
			count = 2
		}
	},

	assaultRifle_ammo = {
		itemsRequired = {
			gunpowder = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			lead_ingot = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			copper_ingot = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			assaultRifle = {
				type = "item_ammo",
				count = 1
			}
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		text = "Making assault rifle rounds",
		time = 8000,
		secondInventory = {
			name = "assaultRifle",
			type = "item_ammo",
			count = 1
		}
	},

	shotgun_ammo = {
		itemsRequired = {
			gunpowder = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			lead_ingot = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			hemp_wadding = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			shotgun = {
				type = "item_ammo",
				count = 2
			}
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		text = "Making shotgun shells",
		time = 8000,
		secondInventory = {
			name = "shotgun",
			type = "item_ammo",
			count = 2
		}
	},

	smg_ammo = {
		itemsRequired = {
			gunpowder = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			lead_ingot = {
				type = "item_standard",
				count = 1,
				remove = true
			},
			copper_ingot = {
				type = "item_standard",
				count = 1,
				remove = true
			}
		},
		itemsReturned = {
			smg = {
				type = "item_ammo",
				count = 1
			}
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		text = "Making smg rounds",
		time = 8000,
		secondInventory = {
			name = "smg",
			type = "item_ammo",
			count = 1
		}
	},

	lmg_ammo = {
		itemsRequired = {
			gunpowder = {
				type = "item_standard",
				count = 2,
				remove = true
			},
			lead_ingot = {
				type = "item_standard",
				count = 2,
				remove = true
			},
			copper_ingot = {
				type = "item_standard",
				count = 2,
				remove = true
			}
		},
		itemsReturned = {
			lmg = {
				type = "item_ammo",
				count = 1
			}
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		text = "Making lmg rounds",
		time = 8000,
		secondInventory = {
			name = "lmg",
			type = "item_ammo",
			count = 1
		}
	},

	sniper_ammo = {
		itemsRequired = {
			gunpowder = {
				type = "item_standard",
				count = 5,
				remove = true
			},
			lead_ingot = {
				type = "item_standard",
				count = 5,
				remove = true
			},
			copper_ingot = {
				type = "item_standard",
				count = 5,
				remove = true
			}
		},
		itemsReturned = {
			sniper = {
				type = "item_ammo",
				count = 1
			}
		},
		animation = {
			animDict = "weapons@first_person@aim_idle@p_m_zero@melee@small_wpn@hammer@fidgets@c",
			anim = "fidget_low_loop",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		},
		controlDisables = {
			disableMovement = true,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		},
		text = "Making sniper rounds",
		time = 8000,
		secondInventory = {
			name = "sniper",
			type = "item_ammo",
			count = 1
		}
	},

	-- petrol_barrel = {
	-- 	itemsRequired = {
	-- 		oil_barrel = {
	-- 			type = "item_standard",
	-- 			count = 1
	-- 		},
	-- 	},
	-- 	itemsReturned = {
	-- 		petrol_barrel = {
	-- 			type = "item_standard",
	-- 			count = 1
	-- 		},
	-- 	},
	-- 	time = 2500, -- ms
	-- 	text = "Refining crude oil into petrol",
	-- 	animation = {
	-- 		animDict = "anim@heists@fleeca_bank@drilling",
	-- 		anim = "drill_left",
	-- 		flags = 49,
	-- 		task = nil,
	-- 	},
	-- 	prop = {
	-- 		model = "hei_prop_heist_drill",
	-- 		bone = 57005,
	-- 		coords = { x = 0.15, y = 0.0, z = -0.05 },
	-- 		rotation = { x = 0.0, y = 90.0, z = 90.0  },
	-- 	},
	-- 	controlDisables = {
	-- 		disableMovement = true,
	-- 		disableCarMovement = true,
	-- 		disableMouse = false,
	-- 		disableCombat = true,
	-- 	},
	-- 	secondInventory = {
	-- 		name = "petrol_barrel",
	-- 		type = "item_standard",
	-- 		count = 1
	-- 	}
	-- },

	-- raw_plastic = {
	-- 	itemsRequired = {
	-- 		oil_barrel = {
	-- 			type = "item_standard",
	-- 			count = 1
	-- 		},
	-- 	},
	-- 	itemsReturned = {
	-- 		petrol_barrel = {
	-- 			type = "item_standard",
	-- 			count = 1
	-- 		},
	-- 	},
	-- 	time = 2500, -- ms
	-- 	text = "Refining crude oil into petrol",
	-- 	animation = {
	-- 		animDict = "anim@heists@fleeca_bank@drilling",
	-- 		anim = "drill_left",
	-- 		flags = 49,
	-- 		task = nil,
	-- 	},
	-- 	prop = {
	-- 		model = "prop_barrel_exp_01a",
	-- 		bone = 57005,
	-- 		coords = { x = 0.15, y = 0.0, z = -0.05 },
	-- 		rotation = { x = 0.0, y = 90.0, z = 90.0  },
	-- 	},
	-- 	controlDisables = {
	-- 		disableMovement = true,
	-- 		disableCarMovement = true,
	-- 		disableMouse = false,
	-- 		disableCombat = true,
	-- 	},
	-- 	secondInventory = {
	-- 		name = "petrol_barrel",
	-- 		type = "item_standard",
	-- 		count = 1
	-- 	}
	-- }
}
