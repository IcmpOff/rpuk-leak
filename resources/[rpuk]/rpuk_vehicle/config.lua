Config       = {}
Config.Debug = true
Config.TaxPercent = 20

Config.Shops = {
	["mosleys"] = { -- Keep unique
		["header"] = "mosleys",
		["Type"] = "player", -- Player or Server
		["AllowedCats"] = {"suvs"}, -- restricted vehicle categories
		["Jobs"] = {}, -- Restricted jobs // cant use this vehicle shop
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-18,-1649.42, 29.65), 43.35}, -- The in menu viewing point
			[1] = {vector3(-16.47,-1652.76, 29.07), 319.48}, -- The vehicle purchased spawn point
			[2] = {vector3(-17.911,-1647.365, 32.65), 230.68}, -- Stat location
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-42.59,-1689.40,29.07), 29.09},
			[2] = {vector3(-46.98,-1690.76,29.07), 29.19},
			[3] = {vector3(-53.45,-1693.88,29.19), 29.15},
			[4] = {vector3(-56.81,-1684.85,29.19), 220.14},
		},
		["Interactions"] = {
			["Management"] = {["Location"] = vector3(-15.402,-1659.980,32.824), ["Distance"] = 1.5,["Text"] = "Press [~b~E~s~] To Access Car Dealers Computer", ["Control"] = 38}, -- Shop owner will interact here
			["Purchase"] = {["Location"] = vector3(-44.535,-1667.318,28.480), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Car Dealers Stock", ["Control"] = 38}, -- Purchase location
			["OfferDesk"] = {["Location"] = vector3(-14.502,-1660.653,32.824), ["Distance"] = 1.5,["Text"] = "Press [~b~E~s~] To Offer Vehicle", ["Control"] = 38}, -- Selling client will interact here
			["Preview"] = {["Location"] = vector3(-21.040, -1660.687, 28.480), ["Distance"] = 2.0,["Text"] = "Press [~b~E~s~] To Preview Full Range of Vehicles", ["Control"] = 38},
		},
		["Upgrades"] = { -- Shop upgrades?

		}
	},
	["autocare"] = { -- Keep unique
		["header"] = "autocare",
		["Type"] = "player", -- Player or Server
		["AllowedCats"] = {"suvs"}, -- restricted vehicle categories
		["Jobs"] = {}, -- Restricted jobs // cant use this vehicle shop
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(916.19,-963.03, 39.67), 245.19}, -- The in menu viewing point
			[1] = {vector3(928.03, -982.27, 39.67), 319.48}, -- The vehicle purchased spawn point
			[2] = {vector3(-17.911,-1647.365, 32.65), 230.68}, -- Stat location
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(928.03, -982.27, 39.67), 3.30},
			[2] = {vector3(923.03, -982.27, 39.67), 3.30},
			[3] = {vector3(916.03, -982.27, 39.67), 3.30},
		},
		["Interactions"] = {
			["Management"] = {["Location"] = vector3(951.790, -968.60, 39.304), ["Distance"] = 1.5,["Text"] = "Press [~b~E~s~] To Access Car Dealers Computer", ["Control"] = 38}, -- Shop owner will interact here
			["Purchase"] = {["Location"] = vector3(947.599,-966.761, 38.500), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Car Dealers Stock", ["Control"] = 38}, -- Purchase location
			["OfferDesk"] = {["Location"] = vector3(952.693, -968.60, 39.304), ["Distance"] = 1.5,["Text"] = "Press [~b~E~s~] To Offer Vehicle", ["Control"] = 38}, -- Selling client will interact here
			["Preview"] = {["Location"] = vector3(949.234, -961.385, 38.500), ["Distance"] = 2.0,["Text"] = "Press [~b~E~s~] To Preview Full Range of Vehicles", ["Control"] = 38},
		},
		["Upgrades"] = { -- Shop upgrades?

		}
	},
	["benefactor"] = { -- Keep unique
		["header"] = "benefactor",
		["Type"] = "player", -- Player or Server
		["AllowedCats"] = {"suvs"}, -- restricted vehicle categories
		["Jobs"] = {}, -- Restricted jobs // cant use this vehicle shop
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-75.62, 74.94, 71.89), 216.62}, -- The in menu viewing point
			[1] = {vector3(-76.84, 89.90, 71.52), 244.93}, -- The vehicle purchased spawn point
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-76.84, 89.90, 71.5), 244.93},
			[2] = {vector3(-70.72, 87.27, 71.5), 244.93},
			[3] = {vector3(-81.61, 84.49, 71.47), 151.15},
		},
		["Interactions"] = {
			["Management"] = {["Location"] = vector3(-53.745, 74.330, 71.741), ["Distance"] = 1.5,["Text"] = "Press [~b~E~s~] To Access Car Dealers Computer", ["Control"] = 38}, -- Shop owner will interact here
			["Purchase"] = {["Location"] = vector3(-56.010,67.752, 70.947), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Car Dealers Stock", ["Control"] = 38}, -- Purchase location
			["OfferDesk"] = {["Location"] = vector3(-53.542, 75.138, 71.713), ["Distance"] = 1.5,["Text"] = "Press [~b~E~s~] To Offer Vehicle", ["Control"] = 38}, -- Selling client will interact here
			["Preview"] = {["Location"] = vector3(-51.447, 73.762, 70.950), ["Distance"] = 2.0,["Text"] = "Press [~b~E~s~] To Preview Full Range of Vehicles", ["Control"] = 38},
		},
		["Upgrades"] = { -- Shop upgrades?

		}
	},
	["premium"] = { -- Premium main
		["header"] = "premium",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"compacts","coupes","suvs","sedan","muscle","offroad"}, -- restricted vehicle categories
		["Jobs"] = {},
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-47.81,-1095.79, 26.16), 122.28}, -- The in menu viewing point
			[1] = {vector3(-20.38,-1085.37, 26.31), 71.98}, -- Stat location
			[2] = {vector3(-17.911,-1647.365, 32.65), 230.68},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-20.38,-1085.37, 26.31), 71.98},
			[2] = {vector3(-14.07,-1108.37, 26.49), 98.74},
			[3] = {vector3(-12.95,-1105.20, 26.49), 99.35},
			[4] = {vector3(-12.37,-1102.39, 26.49), 99.35},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(-56.557, -1096.911, 25.422), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Car Dealers Stock", ["Control"] = 38}, -- Purchase location
		},
	},
	["lsinternationalair"] = { -- Premium main
		["header"] = "lsinternationalair",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"helicopters","planes"}, -- restricted vehicle categories
		["Jobs"] = {},
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-1654.91,-3146.33,13.89), 328.39}, -- The in menu viewing point
			[1] = {vector3(-20.38,-1085.37, 26.31), 71.98}, -- Stat location
			[2] = {vector3(-17.911,-1647.365, 32.65), 230.68},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-986.12, -3001.84, 14.12), 58.29},
			[2] = {vector3(-972.87, -2978.67, 14.11), 58.33},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(-939.011, -2962.844, 18.845), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Air Vehicles", ["Control"] = 38}, -- Purchase location
		},
	},
	["deliveryhub"] = { -- Premium main
		["header"] = "deliveryhub",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"commercials","trailer","vans","utility"}, -- restricted vehicle categories
		["Jobs"] = {},
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(881.28,-2524.37, 48.47), 127.26}, -- The in menu viewing point
			[1] = {vector3(881.28,-2524.37, 48.47), 127.26}, -- Stat location
			[2] = {vector3(881.28,-2524.37, 48.47), 127.26},
			[3] = {vector3(0,0,0), 0.0},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(1011.80,-2490.48, 28.47), 152.71},
			[2] = {vector3(1022.06,-2492.50, 28.67), 152.71},
			[3] = {vector3(1033.12, -2493.60, 28.67), 152.71},
			[4] = {vector3(1044.22, -2494.91, 28.67), 152.71},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(1008.918,-2529.980, 27.303), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Commercial Vehicle Stock", ["Control"] = 38}, -- Purchase location
		},
	},
--[[	["police_car00"] = { -- MRPD Ground Vehicles
		["header"] = "police",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"emergency_pol"}, -- restricted vehicle categories
		["Jobs"] = {"police"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(481.59, -981.91, 41.35), 26.81}, -- The in menu viewing point
			[1] = {vector3(481.59, -981.91, 41.35), 26.81}, -- Stat location
			[2] = {vector3(481.59, -981.91, 41.35), 26.81},
			[3] = {vector3(481.59, -981.91, 41.35), 26.81},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(446.11, -1024.46, 28.31), 0.6},
			[2] = {vector3(438.71, -1025.86, 28.47), 0.6},
			[3] = {vector3(431.43, -1027.50, 28.62), 0.6},
			[4] = {vector3(453.62, -1025.13, 28.20), 0.6},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(458.838, -1007.994, 27.267), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Vehicles", ["Control"] = 38}, -- Purchase location
		},
	},
	["ambulance_car00"] = { -- Pillbox Ground vehicles
		["header"] = "ambulance",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"emergency_nhs"}, -- restricted vehicle categories
		["Jobs"] = {"ambulance"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(350.36, -563.46, 34.90), 0.21}, -- The in menu viewing point
			[1] = {vector3(350.36, -563.46, 34.90), 0.21}, -- Stat location
			[2] = {vector3(350.36, -563.46, 34.90), 0.21},
			[3] = {vector3(350.36, -563.46, 34.90), 0.21},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(316.67, -553.67, 28.42), 271.83},
			[2] = {vector3(316.42, -547.81, 28.42), 271.83},
			[3] = {vector3(321.14, -541.78, 28.42), 182.47},
			[4] = {vector3(326.66, -541.59, 28.42), 182.48},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(324.980, -558.362, 27.744), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Vehicles", ["Control"] = 38}, -- Purchase location
		},
	},
	["ambulance_car01"] = { -- Paleto Police Vehicles
		["header"] = "ambulance",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"emergency_nhs"}, -- restricted vehicle categories
		["Jobs"] = {"ambulance"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-447.994, 5994.404, 30.340), 85.38}, -- The in menu viewing point
			[1] = {vector3(-451.713, 5998.355, 30.340), 85.38}, -- Stat location
			[2] = {vector3(-451.713, 5998.355, 30.340), 85.38},
			[3] = {vector3(-451.713, 5998.355, 30.340), 85.38},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-451.713, 5998.355, 30.340), 85.38},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] =vector3(-449.960, 6003.424, 30.490), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Vehicles", ["Control"] = 38}, -- Purchase location
		},
	},
	["police_car01"] = { -- Vespuci Police Vehicles
		["header"] = "police",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"emergency_pol"}, -- restricted vehicle categories
		["Jobs"] = {"police"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-1076.53, -847.99, 4.53), 220.21}, -- The in menu viewing point
			[1] = {vector3(-1081.061, -840.979, 3.884), 0.21}, -- Stat location
			[2] = {vector3(-1081.061, -840.979, 3.884), 0.21},
			[3] = {vector3(-1081.061, -840.979, 3.884), 0.21},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-1076.53, -847.99, 4.53), 220.49},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(-1081.061, -840.979, 3.884), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Vehicles", ["Control"] = 38}, -- Purchase location
		},
	},
	["police_car02"] = { -- Paleto Police Vehicles
		["header"] = "police",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"emergency_pol"}, -- restricted vehicle categories
		["Jobs"] = {"police"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-447.994, 5994.404, 30.340), 85.38}, -- The in menu viewing point
			[1] = {vector3(-451.713, 5998.355, 30.340), 85.38}, -- Stat location
			[2] = {vector3(-451.713, 5998.355, 30.340), 85.38},
			[3] = {vector3(-451.713, 5998.355, 30.340), 85.38},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-451.713, 5998.355, 30.340), 85.38},
	},
	["Interactions"] = {
			["Purchase"] = {["Location"] =vector3(-449.960, 6003.424, 30.490), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Vehicles", ["Control"] = 38}, -- Purchase location
		},
	},
	["emergency_pol_water00"] = { -- Pillbox Ground vehicles
		["header"] = "police",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"emergency_water"}, -- restricted vehicle categories
		["Jobs"] = {"police"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-801.38, -1501.13, 0.12), 140.06}, -- The in menu viewing point
			[1] = {vector3(-801.38, -1501.13, 0.12), 140.06}, -- Stat location
			[2] = {vector3(-801.38, -1501.13, 0.12), 140.06},
			[3] = {vector3(-801.38, -1501.13, 0.12), 140.06},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-801.38, -1501.13, 0.12), 140.06},
			[2] = {vector3(-801.38, -1501.13, 0.12), 140.06},
			[3] = {vector3(-801.38, -1501.13, 0.12), 140.06},
			[4] = {vector3(-801.38, -1501.13, 0.12), 140.06},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(-801.102, -1495.516, 0.600), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Watercraft", ["Control"] = 38}, -- Purchase location
		},
	},
	["emergency_nhs_water00"] = { -- Pillbox Ground vehicles
		["header"] = "ambulance",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"emergency_water"}, -- restricted vehicle categories
		["Jobs"] = {"ambulance"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-801.38, -1501.13, 0.12), 140.06}, -- The in menu viewing point
			[1] = {vector3(-801.38, -1501.13, 0.12), 140.06}, -- Stat location
			[2] = {vector3(-801.38, -1501.13, 0.12), 140.06},
			[3] = {vector3(-801.38, -1501.13, 0.12), 140.06},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-801.38, -1501.13, 0.12), 140.06},
			[2] = {vector3(-801.38, -1501.13, 0.12), 140.06},
			[3] = {vector3(-801.38, -1501.13, 0.12), 140.06},
			[4] = {vector3(-801.38, -1501.13, 0.12), 140.06},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(-801.102, -1495.516, 0.600), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Watercraft", ["Control"] = 38}, -- Purchase location
		},
	},
	["nca_car00"] = { -- Vespuci Police Vehicles
		["header"] = "nca",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"group_nca"}, -- restricted vehicle categories
		["Jobs"] = {"nca"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-1076.53, -847.99, 4.53), 220.21}, -- The in menu viewing point
			[1] = {vector3(-1081.061, -840.979, 3.884), 0.21}, -- Stat location
			[2] = {vector3(-1081.061, -840.979, 3.884), 0.21},
			[3] = {vector3(-1081.061, -840.979, 3.884), 0.21},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-1076.53, -847.99, 4.53), 220.49},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(-1073.144, -843.698, 3.884), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Vehicles", ["Control"] = 38}, -- Purchase location
		},
	},
	["nca_car01"] = { -- Warehouse
		["header"] = "nca",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"group_nca"}, -- restricted vehicle categories
		["Jobs"] = {"nca"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-776.33740234375, -2581.4660644531, 29.659477233887), 220.21}, -- The in menu viewing point
			[1] = {vector3(-776.33740234375, -2581.4660644531, 29.659477233887), 220.21}, -- Stat location
			[2] = {vector3(-776.33740234375, -2581.4660644531, 29.659477233887), 220.21},
			[3] = {vector3(-776.33740234375, -2581.4660644531, 29.659477233887), 220.21},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-762.13, -2576.12, 14.08), 238.35},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(-758.74310302734, -2572.73828125, 13.441278457642), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Vehicles", ["Control"] = 38}, -- Purchase location
		},
	},
	["police_roof00"] = { -- MRPD Ground Vehicles
		["header"] = "police",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"emergency_heli"}, -- restricted vehicle categories
		["Jobs"] = {"police"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(449.03, -981.89, 43.87), 89.64}, -- The in menu viewing point
			[1] = {vector3(449.03, -981.89, 43.87), 89.64},
			[2] = {vector3(449.03, -981.89, 43.87), 89.64},
			[3] = {vector3(449.03, -981.89, 43.87), 89.64},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(449.03, -981.89, 43.87), 89.64},
			[2] = {vector3(449.03, -981.89, 43.87), 89.64},
			[3] = {vector3(481.56, -982.20, 41.18), 89.64},
			[4] = {vector3(481.56, -982.20, 41.18), 89.64},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(462.082, -981.040, 42.692), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Aircraft", ["Control"] = 38}, -- Purchase location
		},
	},
	["police_roof01"] = { -- MRPD Ground Vehicles
		["header"] = "police",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"emergency_heli"}, -- restricted vehicle categories
		["Jobs"] = {"police"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-1096.17, -832.14, 36.71), 89.64}, -- The in menu viewing point
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-1096.17, -832.14, 36.71), 89.64},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(-1093.14, -838.29, 36.71), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Aircraft", ["Control"] = 38}, -- Purchase location
		},
	},
	["police_roof02"] = { --paleto
		["header"] = "police",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"emergency_heli"}, -- restricted vehicle categories
		["Jobs"] = {"police"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-475.340, 5988.605, 30.346), 30.33}, -- The in menu viewing point
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-475.340, 5988.605, 30.346), 30.33},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(-463.669, 5997.744, 30.28), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Aircraft", ["Control"] = 38}, -- Purchase location
		},
	},
	["nhs_roof00"] = { -- MRPD Ground Vehicles
		["header"] = "ambulance",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"emergency_heli"}, -- restricted vehicle categories
		["Jobs"] = {"ambulance"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(350.94, -587.75, 74.34), 89.72},
			[1] = {vector3(350.94, -587.75, 74.34), 89.72},
			[2] = {vector3(350.94, -587.75, 74.34), 89.72},
			[3] = {vector3(350.94, -587.75, 74.34), 89.72},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(350.94, -587.75, 74.34), 89.72},
			[2] = {vector3(350.94, -587.75, 74.34), 89.72},
			[3] = {vector3(350.94, -587.75, 74.34), 89.72},
			[4] = {vector3(350.94, -587.75, 74.34), 89.72},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(338.720, -586.615, 73.164), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Aircraft", ["Control"] = 38}, -- Purchase location
		},
	},
	["nhs_roof01"] = { --paleto
		["header"] = "ambulance",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"emergency_heli"}, -- restricted vehicle categories
		["Jobs"] = {"ambulance"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-475.340, 5988.605, 30.346), 30.33}, -- The in menu viewing point
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-475.340, 5988.605, 30.346), 30.33},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(-463.669, 5997.744, 30.28), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Emergency Service Aircraft", ["Control"] = 38}, -- Purchase location
		},
	},]]
	["scrapyard"] = { -- Keep unique
		["header"] = "lost",
		["Type"] = "player", -- Player or Server
		["AllowedCats"] = {"suvs"}, -- restricted vehicle categories
		["Jobs"] = {},
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(27.60, 6450.60, 30.90), 6.02}, -- The in menu viewing point
			[1] = {vector3(44.12, 6456.38, 30.90), 225.06}, -- The vehicle purchased spawn point
			[2] = {vector3(44.12, 6456.38, 30.90), 225.06}, -- tats
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(45.38, 6457.96, 30.89), 225.06},
			[2] = {vector3(47.10, 6460.03, 30.89), 225.06},
			[3] = {vector3(49.19, 6462.28, 30.89), 225.06},
		},
		["Interactions"] = {
			["Management"] = {["Location"] = vector3(37.481773376465, 6464.078125, 31.871850967407), ["Distance"] = 1.5,["Text"] = "Press [~b~E~s~] To Access Bike Dealers Computer", ["Control"] = 38}, -- Shop owner will interact here
			["Purchase"] = {["Location"] = vector3(24.958919525146, 6465.8774414063, 30.426975250244), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Bike Dealers Stock", ["Control"] = 38}, -- Purchase location
			["OfferDesk"] = {["Location"] = vector3(38.137001037598, 6464.4448242188, 31.871850967407), ["Distance"] = 1.5,["Text"] = "Press [~b~E~s~] To Offer Vehicle", ["Control"] = 38}, -- Selling client will interact here
			["Preview"] = {["Location"] = vector3(23.596069335938, 6464.5795898438, 30.426975250244), ["Distance"] = 2.0,["Text"] = "Press [~b~E~s~] To Preview Full Range of Vehicles", ["Control"] = 38},
		},
		["Upgrades"] = { -- Shop upgrades?

		}
	},
	["beekers"] = { -- Keep unique
		["header"] = "beekers",
		["Type"] = "player", -- Player or Server
		["AllowedCats"] = {"suvs"}, -- restricted vehicle categories
		["Jobs"] = {},
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(177.733,6601.249, 36.761), 245.19}, -- The in menu viewing point
			[1] = {vector3(120.00,6599.43, 32.17), 270.45}, -- The vehicle purchased spawn point
			[2] = {vector3(177.733,6601.249, 36.761), 245.19}, -- Stat location
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(120.00,6599.43, 32.17), 270.45},
			[2] = {vector3(127.82, 6590.03, 32.11), 270.45},
			[3] = {vector3(143.40, 6575.00, 32.09), 270.45},
		},
		["Interactions"] = {
			["Management"] = {["Location"] = vector3(100.331, 6620.134, 32.257), ["Distance"] = 1.5,["Text"] = "Press [~b~E~s~] To Access Car Dealers Computer", ["Control"] = 38}, -- Shop owner will interact here
			["Purchase"] = {["Location"] = vector3(108.550,6621.168, 30.787), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Car Dealers Stock", ["Control"] = 38}, -- Purchase location
			["OfferDesk"] = {["Location"] = vector3(100.570, 6619.218, 32.266), ["Distance"] = 1.5,["Text"] = "Press [~b~E~s~] To Offer Vehicle", ["Control"] = 38}, -- Selling client will interact here
			["Preview"] = {["Location"] = vector3(105.959, 6627.304, 30.787), ["Distance"] = 2.0,["Text"] = "Press [~b~E~s~] To Preview Full Range of Vehicles", ["Control"] = 38},
		},
		["Upgrades"] = { -- Shop upgrades?
		},
	},
	["taxi"] = { -- Taxi Company
		["header"] = "taxi",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"service"}, -- restricted vehicle categories
		["Jobs"] = {"taxi"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(891.89, -160.46, 76.50), 328.60}, -- The in menu viewing point
			[1] = {vector3(891.89, -160.46, 76.50), 26.81}, -- Stat location
			[2] = {vector3(891.89, -160.46, 76.50), 26.81},
			[3] = {vector3(891.89, -160.46, 76.50), 26.81},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(896.82, -152.95, 76.17), 329.67},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(889.817, -154.642, 75.891), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Service Vehicles", ["Control"] = 38}, -- Purchase location
		},
	},
	["boatshop1"] = {
		["header"] = "rpuk",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"boats"}, -- restricted vehicle categories
		["Jobs"] = {}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(-815.8, -1418.3, -0.5), -112.0}, -- The in menu viewing point
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(-854.9, -1336.6, 0.0), 110.0},
			[2] = {vector3(-852.0, -1345.1, 0.0), 110.0},
			[3] = {vector3(-850.8, -1354.3, 0.0), 110.0},
			[4] = {vector3(-847.8, -1362.7, 0.0), 110.0},
			[5] = {vector3(-841.6, -1372.4, 0.0), 110.0},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(-815.5, -1346.4, 4.1), ["Distance"] = 1.5, ["Text"] = "Press ~INPUT_PICKUP~ to browse the ~y~Boat Shop~s~", ["Control"] = 38}, -- Purchase location
		},
	},
	["boatshop2"] = {
		["header"] = "rpuk",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"boats"}, -- restricted vehicle categories
		["Jobs"] = {}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(1496.43, -2780.94, 0.13), 198.98}, -- The in menu viewing point
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(1496.43, -2780.94, 0.13), 198.98},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(1496.285, -2767.124, 1.557), ["Distance"] = 1.5, ["Text"] = "Press ~INPUT_PICKUP~ to browse the ~y~Boat Shop~s~", ["Control"] = 38}, -- Purchase location
		},
	},
	--[[["iopc"] = {
		["header"] = "rpuk",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"iopc_hq"}, -- restricted vehicle categories
		["Jobs"] = {"iopc"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(145.03245544434, -695.27697753906, 33.128044128418), 247.38}, -- The in menu viewing point
			[1] = {vector3(145.03245544434, -695.27697753906, 33.128044128418), 247.38}, -- Stat location
			[2] = {vector3(145.03245544434, -695.27697753906, 33.128044128418), 247.38},
			[3] = {vector3(145.03245544434, -695.27697753906, 33.128044128418), 247.38},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(151.85366821289, -698.08520507813, 33.128723144531), 152.38},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(144.6307220459, -702.70782470703, 32.129928588867), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View IOPC Service Vehicles", ["Control"] = 38}, -- Purchase location
		},
	},
	["gruppe6"] = {
		["header"] = "rpuk",
		["Type"] = "server", -- Player or Server
		["AllowedCats"] = {"gruppe6_hq"}, -- restricted vehicle categories
		["Jobs"] = {"gruppe6"}, -- Restricted jobs // can only use this
		["ViewPoints"] = { -- Display Cars // Ref Plate
			[0] = {vector3(62.900981903076, -917.12548828125, 90.224449157715), 342.38}, -- The in menu viewing point
			[1] = {vector3(62.900981903076, -917.12548828125, 90.224449157715), 342.38}, -- Stat location
			[2] = {vector3(62.900981903076, -917.12548828125, 90.224449157715), 342.38},
			[3] = {vector3(62.900981903076, -917.12548828125, 90.224449157715), 342.38},
		},
		["SpawnPoints"] = { -- Possible spawn locations for a new bought car
			[1] = {vector3(38.059413909912, -887.44342041016, 29.197750091553), 340.0},
		},
		["Interactions"] = {
			["Purchase"] = {["Location"] = vector3(28.888984680176, -898.02600097656, 29.005016326904), ["Distance"] = 1.5,["Text"] = "Press ~INPUT_PICKUP~ To View Gruppe 6 - Service Vehicles", ["Control"] = 38}, -- Purchase location
		},
	},]]
}

Config.invSize = {
	[0]=100, -- Compacts
	[1]=100, -- Sedans
	[2]=150, -- SUV
	[3]=100, -- COUPE
	[4]=100, -- MUSCLE
	[5]=100, -- SPORTS CLASIC
	[6]=100, -- SPORTS
	[7]=100, -- SUPER
	[8]=50, -- BIKES
	[9]=150, -- OFFROAD
	[10]=110, -- INDUSTRIAL
	[11]=110, -- UTILITY
	[12]=250, -- VANS
	[13]=0, -- CYCLES
	[14]=100, -- BOATS
	[15]=100, -- HELIS
	[16]=100, -- PLANES
	[17]=100, -- SERVICE
	[18]=100, -- EMERGENCY
	[19]=0, -- MILITARY
	[20]=500, -- COMMERCIAL
	[21]=0, -- TRAINS
}

cfg = {
	deformationMultiplier = -1,					-- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch. Visual damage does not sync well to other players.
	deformationExponent = 0.4,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	collisionDamageExponent = 0.6,				-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.

	damageFactorEngine = 10.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorBody = 10.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorPetrolTank = 64.0,				-- Sane values are 1 to 200. Higher values means more damage to vehicle. A good starting point is 64
	engineDamageExponent = 0.6,					-- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	weaponsDamageMultiplier = 0.01,				-- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
	degradingHealthSpeedFactor = 10,			-- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
	cascadingFailureSpeedFactor = 8.0,			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8

	degradingFailureThreshold = 650.0,			-- Below this value, slow health degradation will set in
	cascadingFailureThreshold = 360.0,			-- Below this value, health cascading failure will set in
	engineSafeGuard = 100.0,					-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.

	torqueMultiplierEnabled = true,				-- Decrease engine torque as engine gets more and more damaged

	limpMode = false,							-- If true, the engine never fails completely, so you will always be able to get to a mechanic unless you flip your vehicle and preventVehicleFlip is set to true
	limpModeMultiplier = 0.15,					-- The torque multiplier to use when vehicle is limping. Sane values are 0.05 to 0.25

	preventVehicleFlip = false,					-- If true, you can't turn over an upside down vehicle

	sundayDriver = true,						-- If true, the accelerator response is scaled to enable easy slow driving. Will not prevent full throttle. Does not work with binary accelerators like a keyboard. Set to false to disable. The included stop-without-reversing and brake-light-hold feature does also work for keyboards.
	sundayDriverAcceleratorCurve = 7.5,			-- The response curve to apply to the accelerator. Range 0.0 to 10.0. Higher values enables easier slow driving, meaning more pressure on the throttle is required to accelerate forward. Does nothing for keyboard drivers
	sundayDriverBrakeCurve = 5.0,				-- The response curve to apply to the Brake. Range 0.0 to 10.0. Higher values enables easier braking, meaning more pressure on the throttle is required to brake hard. Does nothing for keyboard drivers

	displayBlips = true,						-- Show blips for mechanics locations

	compatibilityMode = false,					-- prevents other scripts from modifying the fuel tank health to avoid random engine failure with BVA 2.01 (Downside is it disabled explosion prevention)

	-- Class Damagefactor Multiplier
	-- The damageFactor for engine, body and Petroltank will be multiplied by this value, depending on vehicle class
	-- Use it to increase or decrease damage for each class

	classDamageMultiplier = {
		[0] = 	0.7,		--	0: Compacts
				0.7,		--	1: Sedans
				0.7,		--	2: SUVs
				0.7,		--	3: Coupes
				0.75,		--	4: Muscle
				1.0,		--	5: Sports Classics
				1.0,		--	6: Sports
				1.0,		--	7: Super
				0.45,		--	8: Motorcycles
				0.7,		--	9: Off-road
				0.25,		--	10: Industrial
				0.7,		--	11: Utility
				0.7,		--	12: Vans
				0.0,		--	13: Cycles
				0.5,		--	14: Boats
				1.0,		--	15: Helicopters
				1.0,		--	16: Planes
				0.5,		--	17: Service
				0.8,		--	18: Emergency
				1.0,		--	19: Military
				0.5,		--	20: Commercial
				1.0			--	21: Trains
	}
}