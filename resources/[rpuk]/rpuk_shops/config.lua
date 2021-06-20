Config = {}
Config.DrawDistance = 100
Config.Size = {x = 1.5, y = 1.5, z = 1.0}
Config.Color = {r = 255, g = 255, b = 255}
Config.Type = 1
Config.Job = 'delivery'
Config.Grade = 1

Config.Zones = {
	TwentyFourSeven = {
		LocationName = 'TwentyFourSeven',
		Header = '247',
		Keeper = 'server',
		Pos = {
			{x = 373.875, y = 325.896, z = 102.566},
			{x = 2557.458, y = 382.282, z = 107.622},
			{x = -3038.939, y = 585.954, z = 6.908},
			{x = 547.431, y = 2671.710, z = 41.156},
			{x = 1961.464, y = 3740.672, z = 31.343},
			{x = 2678.916, y = 3280.671, z = 54.241}
		},
		Deliv = {}
	},
	RobsLiquor = {
		LocationName = 'RobsLiquor',
		Header = 'robsLiq',
		Keeper = 'server',
		Pos = {
			{x = -1222.915, y = -906.983, z = 11.326},
			{x = -1487.553, y = -379.107, z = 39.163},
			{x = -2968.243, y = 390.910, z = 14.043},
			{x = 1392.562, y = 3604.684, z = 33.980}
		},
		Deliv = {}
	},
	LTDgasoline = {
		LocationName = 'LTDgasoline',
		Header = 'LTD',
		Keeper = 'server',
		Pos = {
			{x = -48.519, y = -1757.514, z = 28.421},
			{x = 1163.373, y = -323.801, z = 68.205},
			{x = -707.501, y = -914.260, z = 18.215},
			{x = -1820.523, y = 792.518, z = 137.118},
			{x = 1698.388, y = 4924.404, z = 41.063}
		},
		Deliv = {}
	},
	FishingShop = {
		LocationName = 'FishingShop',
		Header = '247',
		Keeper = 'server',
		Pos = {
			vector3(-1122.2, 2681.9, 17.6)
		},
		Deliv = {}
	},
--	CasinoTokens = {
--		LocationName = 'CasinoTokens',
--		Header = 'casino',
--		Keeper = 'server',
--		Pos = {
--			{x = 1116.172, y = 219.906, z = -50.430}
--		},
--		Deliv = {}
--	},
	NightClub = {
		LocationName = 'NightClub',
		Header = 'rpuk',
		Keeper = 'server',
		Pos = {
			{x = 127.830, y = -1284.796, z = 28.280}, --StripClub
			{x = -1393.409, y = -606.624, z = 29.319}, --Tequila la
			{x = -559.906, y = 287.093, z = 81.176}, --Bahamamas
			{x = -10.852, y = -1662.088, z = 32.044} --Car dealer
		},
		Deliv = {}
	},
	CasinoBar = {
		LocationName = 'CasinoBar',
		Header = 'casino',
		Keeper = 'server',
		Pos = {
			{x = 1108.258, y = 208.428, z = -50.44}, -- Casino 1
			{x = 1115.038, y = 209.685, z = -50.44}, -- Casino 2
			{x = 945.703, y = 16.758, z = 115.164}, -- Casino Penthouse 1
			{x = 944.398, y = 14.648, z = 115.164} -- Casino Penthouse 2
		},
		Deliv = {}
	},
	BlackMarket = {
		LocationName = 'BlackMarket',
		Header = 'rpuk',
		Keeper = 'server',
		Pos = {
			{x = 125.900, y = -610.20, z = 205.0} -- Casino Toilets -- keep this in the admin zone for debugging
		},
		Deliv = {}
	},
	TBJewellers = {
		-- diamond-dealer shop
		LocationName = 'TBJewellers',
		Header = 'tbjeweller',
		Keeper = 'server',
		Pos = {
			{x = -625.127, y = -232.233, z = 37.057} -- diamond shop in Rockford
		},
		Deliv = {}
	},

	BloodDeliv = {
		LocationName = 'BloodDeliv',
		Header = 'ambulance',
		Keeper = 'server',
		Pos = {
			{x = 1828.757, y =  3674.436, z = 33.0}
		},
		Deliv = {}
	},
	NHSDesk = {
		-- nhs desk npcs
		LocationName = 'NHSDesk',
		Header = 'ambulance',
		Keeper = 'server',
		Pos = {},
		Deliv = {}
	},
	HalloweenToken = {
		-- Halloween Tokens
		LocationName = 'HalloweenToken',
		Header = 'hallow',
		Keeper = 'server',
		Pos = {},
		Deliv = {}
	},
	butcherMarket = {
		-- maze dealer npc interaction
		LocationName = 'butcherMarket',
		Header = 'rpuk',
		Keeper = 'server',
		Pos = {
			{x = 991.87103271484, y = -2175.0229492188, z = 28.976778030396}
		},
		Deliv = {}
	},
	resourceExport = {
		LocationName = 'resourceExport',
		Header = 'rpuk',
		Keeper = 'player',
		Pos = {
			{x= -1081.967, y = -2080.574, z = 13.675}
		},
		Deliv = {
			{x= -1076.407, y = -2057.123, z = 12.270, size = 7.0}
		}
	},
	--
	--[[ PLAYER OWNED SHOPS ]] PlayerShop_00 = {
		LocationName = 'PlayerShop_00', -- 24/7 Senora Fwy/
		Header = '247',
		Keeper = 'player',
		Pos = {
			{x = 1729.216, y = 6414.131, z = 34.037} -- 24/7 Senora Fwy/
		},
		Deliv = {
			{x = 1720.768, y = 6425.851, z = 32.378, size = 7.0} -- 24/7 Senora Fwy/
		}
	},
	PlayerShop_01 = {
		LocationName = 'PlayerShop_01', -- Route 68
		Header = '247',
		Keeper = 'player',
		Pos = {
			{x = -2540.911, y = 2313.988, z = 32.411} -- Route 68
		},
		Deliv = {
			{x = -2516.199, y = 2321.757, z = 32.060, size = 7.0} -- Route 68
		}
	},
	PlayerShop_02 = {
		LocationName = 'PlayerShop_02', -- El Rancho Blvd
		Header = 'noblestore',
		Keeper = 'player',
		Pos = {
			{x = 1135.808, y = -982.281, z = 45.415}, -- El Rancho Blvd
			{x = 926.558, y = -1809.633, z = 23.968} -- El Rancho Blvd
		},
		Deliv = {
			{x = 1109.353, y = -989.320, z = 43.905, size = 7.0} -- El Rancho Blvd
		}
	},
	PlayerShop_03 = {
		LocationName = 'PlayerShop_03', -- Route 68 Grand Senora
		Header = 'robsLiq',
		Keeper = 'player',
		Pos = {
			{x = 1166.024, y = 2708.930, z = 37.157} -- Route 68 Grand Senora
		},
		Deliv = {
			{x = 1187.576, y = 2727.911, z = 37.004, size = 7.0} -- Route 68 Grand Senora
		}
	},
	PlayerShop_04 = {
		LocationName = 'PlayerShop_04', -- Paleto Bay
		Header = '247',
		Keeper = 'player',
		Pos = {
			{x = 161.717, y = 6640.228, z = 30.711} -- Paleto Bay
		},
		Deliv = {
			{x = 179.070, y = 6625.002, z = 30.694, size = 7.0} -- Paleto Bay
		}
	},
	tacoShop = {
		LocationName = 'tacoShop',
		Header = 'rpuk',
		Keeper = 'player',
		Pos = {
			{x = 11.16, y = -1605.72, z = 28.371028900146}
		},
		Deliv = {
			{x = 15.871109008789, y = -1598.5194091797, z = 28.377986907959, size = 7.0}
		}
	},
	burgerShop = {
		LocationName = 'burgerShop',
		Header = 'rpuk',
		Keeper = 'player',
		Pos = {
			{x = -1193.95, y = -892.87, z = 12.995161056519}
		},
		Deliv = {
			{x = -1165.4388427734, y = -889.83093261719, z = 13.104991912842, size = 7.0}
		}
	},
	wilcoClub = {
		LocationName = 'wilcoClub',
		Header = 'rpuk',
		Keeper = 'player',
		Pos = {
			{x = -435.75729370117, y = 274.8659362793, z = 82.422088623047}
		},
		Deliv = {
			{x = -1165.4388427734, y = -889.83093261719, z = 13.104991912842, size = 7.0}
		}
	},
	missionBar = {
		LocationName = 'missionBar',
		Header = 'rpuk',
		Keeper = 'player',
		Pos = {
			{x = 379.92929077148, y = -1079.7834472656, z = 28.480751037598}
		},
		Deliv = {
			{x = 417.73937988281, y = -1068.4499511719, z = 28.213317871094, size = 7.0}
		}
	},
	legionRestaurant = {
		LocationName = 'legionRestaurant',
		Header = 'rpuk',
		Keeper = 'player',
		Pos = {
			{x = 124.79946899414, y = -1033.9538574219, z = 28.277141571045}
		},
		Deliv = {
			{x = 123.72277069092, y = -1040.3305664063, z = 28.210666656494, size = 7.0}
		}
	},
	beanMachine = {
		LocationName = 'beanMachine',
		Header = 'rpuk',
		Keeper = 'player',
		Pos = {
			{x = -633.57281494141, y = 235.2666015625, z = 80.881500244141}
		},
		Deliv = {
			{x = -629.85882568359, y = 199.32751464844, z = 69.488891601563, size = 7.0}
		}
	},
	lostClubhouseBar = {
		LocationName = 'lostClubhouseBar',
		Header = 'lost',
		Keeper = 'player',
		Pos = {},
		Deliv = {
			{x = 974.01940917969, y = -90.15210723877, z = 73.353126525879, size = 5.0}
		}
	},
	butcherVendor = {
		-- nhs desk npcs
		LocationName = 'butcherVendor',
		Header = 'housing_2',
		Keeper = 'server',
		Pos = {},
		Deliv = {}
	}
}

Config.DelivPoints = {
	-- used for the rpuk_stock delivery points
	['PlayerShop_00'] = {vector3(1720.768, 6425.851, 32.378), vector3(1720.768, 6425.851, 32.378)}, -- rpuk_shops
	['PlayerShop_01'] = {vector3(-2516.199, 2321.757, 32.060), vector3(-2516.199, 2321.757, 32.060)}, -- rpuk_shops
	['PlayerShop_02'] = {vector3(1109.353, -989.320, 43.905), vector3(1109.353, -989.320, 43.905)}, -- rpuk_shops
	['PlayerShop_03'] = {vector3(1187.576, 2727.911, 37.004), vector3(1187.576, 2727.911, 37.004)}, -- rpuk_shops
	['PlayerShop_04'] = {vector3(179.070, 6625.002, 30.694), vector3(179.070, 6625.002, 30.694)}, -- rpuk_shops
	['mosleys'] = {vector3(5.018, -1684.205, 28.269), vector3(-10.82, -1668.47, 28.91)}, -- rpuk_vehshop
	['autocare'] = {vector3(872.990, -948.699, 25.282), vector3(928.03, -982.27, 39.67)}, -- rpuk_vehshop
	['beekers'] = {vector3(99.609, 6634.076, 30.453), vector3(99.609, 6634.076, 30.453)}, -- rpuk_vehshop
	['benefactor'] = {vector3(-55.468, 85.781, 72.762), vector3(-55.468, 85.781, 72.762)}, -- rpuk_vehshop
	['scrapyard'] = {
		vector3(-3.1657176017761, 6473.638671875, 30.291858673096),
		vector3(-3.1657176017761, 6473.638671875, 30.291858673096)
	}, -- rpuk_vehshop
	['tacoShop'] = {vector3(15.87, -1598.51, 28.37), vector3(15.87, -1598.51, 28.37)}, -- restaurants
	['burgerShop'] = {vector3(-1165.43, -889.83, 13.10), vector3(-1165.43, -889.83, 13.10)}, -- restaurants
	['wilcoClub'] = {vector3(-432.44, 275.91, 82.4), vector3(-432.44, 275.91, 82.4)}, -- restaurants
	['missionBar'] = {vector3(417.73, -1068.44, 28.21), vector3(417.73, -1068.44, 28.21)}, -- restaurants
	['legionRestaurant'] = {vector3(123.72, 3511.848, 34.910), vector3(1542.855, -1040.33, 28.21)} -- restaurants
}

Config.safeInteraction = 'Press E to crack safe'
Config.cashierInteraction = 'Press E to grab cash'

Config.minPolice = 5
-- Safe Cooldown
Config.cooldown = 600 --Sec
-- Safe Reward
Config.minCash = 1500
Config.maxCash = 15000
-- Time it takes to open safe
Config.minTimeforSafe = 10 --Sec
Config.maxTimeforSafe = 320 --Sec

Config.centerOfTown = {
	x = 450.57,
	y = -987.19,
	z = 26.67
}

Config.robbery = {
	{
		safe = {
			-- Large
			x = -1478.89,
			y = -375.38,
			z = 38.0
		},
		cashier = {
			x = -1486.2331542969,
			y = -378.06164550781,
			z = 40.163414001465
		}
	},
	{
		safe = {
			-- Large
			x = -1220.90,
			y = -915.98,
			z = 10.5
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- Small
			x = -1829.27,
			y = 798.80,
			z = 137.0
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- Big
			x = -2959.59,
			y = 387.11,
			z = 17.05
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- SMALL
			x = -3048.2,
			y = 585.60,
			z = 6.70
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- SMALL
			x = -3250.08,
			y = 1004.42,
			z = 11.40
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- SMALL
			x = 546.41,
			y = 2662.72,
			z = 40.8
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- Big
			x = 1169.35,
			y = 2717.87,
			z = 36.20
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- Small
			x = 2672.40,
			y = 3286.67,
			z = 54.0
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- Small
			x = 1958.90,
			y = 3749.36,
			z = 31.0
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- Small
			x = 1707.95,
			y = 4920.44,
			z = 41.0
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- Small
			x = 1734.88,
			y = 6420.86,
			z = 33.8
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- Small
			x = 378.19,
			y = 333.50,
			z = 102.40
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- Small
			x = 1159.48,
			y = -313.99,
			z = 67.60
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- Big
			x = 1126.81,
			y = -979.8,
			z = 44.30
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- SMALL
			x = -43.45,
			y = -1748.33,
			z = 28.15
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	},
	{
		safe = {
			-- SMALL
			x = 2549.20,
			y = 384.87,
			z = 107.30
		},
		cashier = {
			x = 0.0,
			y = 0.0,
			z = 0.0
		}
	}
}

Config.Banks = {
	['legion_bank'] = {
		--MAIN BANK
		name = 'Fleeca Bank Legion Square',
		hackingPoint = vector3(147.28, -1046.25, 28.37),
		doorName = 'v_ilev_gb_vauldr',
		doorCoords = vector3(147.82, -1045.08, 28.37),
		doorORot = -150.0,
		doorCRot = -110.0,
		isHacked = false,
		blipHandle = nil,
		wait = 90000,
		safes = {
			{
				location = vector3(150.53, -1050.00, 28.35),
				searched = false,
				time = 300000
			},
			{
				location = vector3(147.961, -1050.93, 28.35),
				searched = false,
				time = 300000
			},
			{
				location = vector3(146.62, -1048.55, 28.35),
				searched = false,
				time = 300000
			}
		},
		items = {
			--Chances are out of 100%
			{item = 'gold', chance = 90, quantity = 120, type = 'item'}, --17650
			{item = 'diamond', chance = 90, quantity = 60, type = 'item'},
			{item = 'casino_playtoken', chance = 90, quantity = 100, type = 'item'},
			{item = '', chance = 60, quantity = 50000, type = 'cash'},
			{item = 'bank_securitycard_legion', chance = 25, quantity = 1, type = 'item'}
		},
		police = 3
	},
	['paleto_bank'] = {
		--MAIN BANK
		name = 'Blaine County Bank',
		hackingPoint = vector3(-105.85, 6472.11, 30.63),
		doorName = 'v_ilev_cbankvauldoor01',
		doorCoords = vector3(-105.12, 6472.77, 30.63),
		doorORot = 85.0,
		doorCRot = 45.0,
		isHacked = false,
		blipHandle = nil,
		wait = 90000,
		safes = {
			{
				location = vector3(-105.96, 6478.88, 30.63),
				searched = false,
				time = 300000
			},
			{
				location = vector3(-103.118, 6478.45, 30.63),
				searched = false,
				time = 300000
			},
			{
				location = vector3(-102.75, 6475.34, 30.63),
				searched = false,
				time = 300000
			}
		},
		items = {
			--Chances are out of 100%
			{item = 'gold', chance = 90, quantity = 120, type = 'item'}, --17650
			{item = 'diamond', chance = 90, quantity = 60, type = 'item'},
			{item = 'casino_playtoken', chance = 90, quantity = 100, type = 'item'},
			{item = '', chance = 40, quantity = 30000, type = 'cash'},
			{item = 'bank_securitycard_paleto', chance = 25, quantity = 1, type = 'item'}
		},
		police = 3
	},
	['route68_bank'] = {
		name = 'Fleeca Bank Route 68',
		hackingPoint = vector3(1175.55, 2712.92, 37.09),
		doorName = 'v_ilev_gb_vauldr',
		doorCoords = vector3(1175.59, 2711.717, 37.088),
		doorORot = 50.0,
		doorCRot = 90.0,
		isHacked = false,
		blipHandle = nil,
		wait = 45000,
		safes = {
			{
				location = vector3(1171.03, 2715.27, 37.07),
				searched = false,
				time = 150000
			},
			{
				location = vector3(1173.24, 2717.02, 37.07),
				searched = false,
				time = 150000
			},
			{
				location = vector3(1175.46, 2715.16, 37.07),
				searched = false,
				time = 150000
			}
		},
		items = {
			--Chances are out of 100%
			{item = 'gold', chance = 90, quantity = 120, type = 'item'}, --17650
			{item = 'diamond', chance = 90, quantity = 35, type = 'item'},
			{item = 'casino_playtoken', chance = 90, quantity = 50, type = 'item'},
			{item = '', chance = 30, quantity = 40000, type = 'cash'}
		},
		police = 3
	},
	['blvd_delpero_bank'] = {
		name = 'Fleeca Bank Blvd Del Perro',
		hackingPoint = vector3(-1210.39, -336.38, 36.78),
		doorName = 'v_ilev_gb_vauldr',
		doorCoords = vector3(-1210.94, -335.35, 36.78),
		doorORot = -103.0,
		doorCRot = -63.0,
		isHacked = false,
		blipHandle = nil,
		wait = 45000,
		safes = {
			{
				location = vector3(-1205.19, -336.45, 36.76),
				searched = false,
				time = 150000
			},
			{
				location = vector3(-1026.45, -339.08, 36.76),
				searched = false,
				time = 150000
			},
			{
				location = vector3(-1209.29, -338.31, 36.76),
				searched = false,
				time = 150000
			}
		},
		items = {
			--Chances are out of 100%
			{item = 'gold', chance = 90, quantity = 120, type = 'item'}, --17650
			{item = 'diamond', chance = 90, quantity = 60, type = 'item'},
			{item = 'casino_playtoken', chance = 90, quantity = 50, type = 'item'},
			{item = '', chance = 60, quantity = 50000, type = 'cash'}
		},
		police = 3
	},
	
	-- tapping for pharamacy robbery here
	['pharma_paleto'] = {
		name = 'Pharmacy Security',
		hackingPoint = vector3(-177.866, 6383.475, 30.725),
		isHacked = false,
		blipHandle = nil,
		wait = 45000,
		safes = {
			{
				location = vector3(-180.168, 6385.897, 30.478),
				searched = false,
				time = 150000
			},
			{
				location = vector3(-174.596, 6389.178, 30.521),
				searched = false,
				time = 150000
			}
		},
		items = {
			{item = 'comp_drug_paracetamol', chance = 75, quantity = 20, type = 'item'},
			{item = 'comp_drug_asprin', chance = 75, quantity = 15, type = 'item'},		
			{item = 'comp_drug_ergotamine', chance = 75, quantity = 12, type = 'item'},
			{item = 'comp_drug_fentanyl_dropper', chance = 75, quantity = 10, type = 'item'},
			{item = 'comp_drug_lysergicacid', chance = 75, quantity = 20, type = 'item'},
			{item = 'comp_drug_chloroform', chance = 50, quantity = 5, type = 'item'},
			{item = 'comp_drug_morphine', chance = 50, quantity = 10, type = 'item'},
			{item = 'drug_methadone_shot', chance = 25, quantity = 2, type = 'item'},
			{item = 'drug_ketamine_bottle', chance = 50, quantity = 7, type = 'item'},
			{item = 'drug_nitrousoxide_bulb', chance = 50, quantity = 5, type = 'item'},
			{item = 'drug_diazepam', chance = 50, quantity = 10, type = 'item'},
		},
		police = 3
	},
	['pharma_hardwick'] = {
		name = 'Pharmacy Security',
		hackingPoint = vector3(93.009, -230.644, 53.898),
		isHacked = false,
		blipHandle = nil,
		wait = 45000,
		safes = {
			{
				location = vector3(91.016, -231.562, 53.919),
				searched = false,
				time = 150000
			},
			{
				location = vector3(96.319, -233.492, 53.851),
				searched = false,
				time = 150000
			}
		},
		items = {
			{item = 'comp_drug_paracetamol', chance = 75, quantity = 20, type = 'item'},
			{item = 'comp_drug_asprin', chance = 75, quantity = 15, type = 'item'},		
			{item = 'comp_drug_ergotamine', chance = 75, quantity = 12, type = 'item'},
			{item = 'comp_drug_fentanyl_dropper', chance = 75, quantity = 10, type = 'item'},
			{item = 'comp_drug_lysergicacid', chance = 75, quantity = 20, type = 'item'},
			{item = 'comp_drug_chloroform', chance = 50, quantity = 5, type = 'item'},
			{item = 'comp_drug_morphine', chance = 50, quantity = 10, type = 'item'},
			{item = 'drug_methadone_shot', chance = 25, quantity = 2, type = 'item'},
			{item = 'drug_ketamine_bottle', chance = 50, quantity = 7, type = 'item'},
			{item = 'drug_nitrousoxide_bulb', chance = 50, quantity = 5, type = 'item'},
			{item = 'drug_diazepam', chance = 50, quantity = 10, type = 'item'},
		},
		police = 3
	},
	['pharma_humainelabs'] = {
		name = 'Humaine Labs',
		hackingPoint = vector3(3532.629, 3666.548, 27.732),
		isHacked = false,
		blipHandle = nil,
		wait = 45000,
		safes = {
			{
				location = vector3(3534.417, 3659.323, 26.853),
				searched = false,
				time = 150000
			},
			{
				location = vector3(3537.901, 3660.435, 26.942),
				searched = false,
				time = 150000
			}
		},
		items = {
			{item = 'comp_drug_methylamine', chance = 100, quantity = 33, type = 'item'},			
			{item = 'comp_drug_asprin', chance = 20, quantity = 15, type = 'item'},		
			{item = 'comp_drug_ergotamine', chance = 20, quantity = 12, type = 'item'},
			{item = 'comp_drug_fentanyl_dropper', chance = 20, quantity = 10, type = 'item'},
			{item = 'comp_drug_lysergicacid', chance = 20, quantity = 20, type = 'item'},
			{item = 'comp_drug_chloroform', chance = 20, quantity = 5, type = 'item'},
			{item = 'comp_drug_morphine', chance = 20, quantity = 10, type = 'item'},
			{item = 'drug_methadone_shot', chance = 20, quantity = 2, type = 'item'},
			{item = 'drug_ketamine_bottle', chance = 20, quantity = 7, type = 'item'},
			{item = 'drug_nitrousoxide_bulb', chance = 20, quantity = 5, type = 'item'},
			{item = 'drug_diazepam', chance = 50, quantity = 20, type = 'item'},		
		},
		police = 5
	},
}
