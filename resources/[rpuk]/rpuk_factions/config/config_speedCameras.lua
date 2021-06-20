SpeedCamera = {}

SpeedCamera.AlertSpeedToPolice = 30 -- How much above the speed limit will police be alerted if a vehicle is speeding (MPH)
SpeedCamera.SpeedToTriggerANPR = 20 -- How fast the vehicle needs to be to set off the ANPR (MPH)
SpeedCamera.SpeedLimitToFine = 5 -- How fast the vehicle needs to be to set off the ANPR (MPH)
SpeedCamera.WhitelistedVehicles = {
	"rppolice1", "rppolice2", "rppolice3", "rppolice4",
	"rppolice5", "rppolice6", "rppolice7", "rppolice8",
	"fbi2","rppolice9", "rppolice10", "rppolice11",
	"rpnhs6", "rppolice13", "rppolice14", "rppolice15",
	"rppoliceuc1", "rppoliceuc2", "rppoliceuc3",
	"rppoliceuc4", "rppoliceuc5", "sheriff2",
	"rpnhs1", "rpnhs2", "rpnhs3", "rpnhs4",
	"rpnhs5", "rppolice14", "rpnhs6", "rpnhs6",
	"rpnhs7", "rppoliceuc6", "rppoliceuc7", "rppoliceuc8", "rppoliceuc9",
	"rpg62"
}

SpeedCamera.Locations = {
	--[[
	exampleID = {
		Location = CircleZone:Create(vector3(259.02, -1060.71, 29.34), 8.5, { -- This is the Detection Circle
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation =BoxZone:Create(vector3(239.49, -1065.75, 29.18), 1.2, 1.4, { -- This is the polyzone for the speed camera
			heading=0,
			--debugPoly=true,
			minZ=27.58,
			maxZ=31.58
		}),
		Online = true, -- Default State When Server Starts Up
		Whitelist = {
			"rppolice1", "rppolice2", "rppolice3", "rppolice4",
			"rppolice5", "rppolice6", "rppolice7", "rppolice8",
			"fbi2","rppolice9", "rppolice10", "rppolice11",
			"rpnhs6", "rppolice13", "rppolice14", "rppolice15",
			"rppoliceuc1", "rppoliceuc2", "rppoliceuc3",
			"rppoliceuc4", "rppoliceuc5", "sheriff2",
			"rpnhs1", "rpnhs2", "rpnhs3", "rpnhs4",
			"rpnhs5", "rppolice14", "rpnhs6", "rpnhs6",
			"rpnhs7", "rpnca1", "rpnca2", "rpnca3", "rpnca4",
			"rpg62"},
		Access = {"police"}, -- List of people who can trun on/off speed camera
		SpeedLimit = 70, --MPH -- Speed Limit Zone
		ANPR = true, -- Detects if the vehicle owns has a warrant
		SpeedDetection = true, -- Will send alerts if vehicle is speeding
	},
	]]
	legion_square_1 = {
		Location = CircleZone:Create(vector3(259.02, -1060.71, 29.34), 8.5, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation =BoxZone:Create(vector3(239.49, -1065.75, 29.18), 1.2, 1.4, {
			heading=0,
			--debugPoly=true,
			minZ=27.58,
			maxZ=31.58
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	legion_square_2 = {
		Location = CircleZone:Create(vector3(231.54, -1034.16, 29.35), 10.5, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = BoxZone:Create(vector3(249.0, -1032.34, 29.24), 1.2, 1.2, {
			heading=350,
			--debugPoly=true,
			minZ=27.44,
			maxZ=31.44
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	legion_square_3 = {
		Location = CircleZone:Create(vector3(175.42, -792.63, 32.85), 9.5, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = BoxZone:Create(vector3(172.63, -773.29, 31.74), 2, 2, {
			heading=340,
			--debugPoly=true,
			minZ=30.54,
			maxZ=34.54
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	legion_square_4 = {
		Location = CircleZone:Create(vector3(201.63, -768.03, 33.66), 9.5, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = BoxZone:Create(vector3(200.98, -783.22, 32.94), 1.6, 1.2, {
			heading=345,
			--debugPoly=true,
			minZ=30.54,
			maxZ=34.54
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	legion_square_5 = {
		Location = CircleZone:Create(vector3(97.67, -1053.59, 29.31), 14.5, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = CircleZone:Create(vector3(94.89, -1082.75, 29.29), 2.5, {
			useZ=true,
			--debugPoly=true
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	legion_square_6 = {
		Location = CircleZone:Create(vector3(66.07, -1076.52, 29.39), 10.5, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = CircleZone:Create(vector3(67.97, -1039.32, 29.45), 2.0, {
			useZ=true,
			--debugPoly=true
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	pillbox_1 = {
		Location = CircleZone:Create(vector3(279.6, -567.04, 43.18), 9.0, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = BoxZone:Create(vector3(277.71, -587.15, 43.21), 1.6, 1.6, {
			heading=340,
			--debugPoly=true,
			minZ=41.21,
			maxZ=45.21
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	pillbox_2 = {
		Location = CircleZone:Create(vector3(244.03, -603.3, 43.26), 7.5, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = BoxZone:Create(vector3(247.98, -577.37, 43.27), 1.6, 1.8, {
			heading=335,
			--debugPoly=true,
			minZ=41.87,
			maxZ=45.87
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	pillbox_3 = {
		Location = CircleZone:Create(vector3(133.33, -583.02, 44.03), 9.5, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = BoxZone:Create(vector3(156.09, -584.18, 43.95), 1.2, 2, {
			heading=340,
			--debugPoly=true,
			minZ=42.15,
			maxZ=46.15
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	alter_street_1 = {
		Location = CircleZone:Create(vector3(-195.04, -925.52, 29.34), 11.5, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = BoxZone:Create(vector3(-193.16, -951.35, 29.31), 1.8, 1.6, {
			heading=340,
			--debugPoly=true,
			minZ=27.31,
			maxZ=31.31
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	alter_street_2 = {
		Location = CircleZone:Create(vector3(72.36, -558.34, 33.78), 13.0, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = BoxZone:Create(vector3(96.25, -557.79, 31.51), 1.2, 1.4, {
			heading=9,
			--debugPoly=true
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	davis_ave_1 = {
		Location = CircleZone:Create(vector3(-216.78, -1806.32, 29.94), 16.5, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = CircleZone:Create(vector3(-229.81, -1836.79, 29.7), 3.0, {
			useZ=true,
			--debugPoly=true
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	innocence_blvd_1 = {
		Location = CircleZone:Create(vector3(347.45, -1549.61, 29.29), 9.0, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = BoxZone:Create(vector3(330.76, -1542.1, 29.17), 1.6, 1.4, {
			heading=50,
			--debugPoly=true,
			minZ=27.57,
			maxZ=31.57
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	innocence_blvd_2 = {
		Location = CircleZone:Create(vector3(340.3, -1517.0, 29.27), 12.0, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = BoxZone:Create(vector3(361.81, -1520.62, 29.28), 2, 1.2, {
			heading=40,
			--debugPoly=true,
			minZ=28.28,
			maxZ=32.28
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	stwb_ave_1 = {
		Location = CircleZone:Create(vector3(369.17, -664.96, 29.25), 12.0, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = BoxZone:Create(vector3(363.65, -685.7, 29.2), 1.4, 1.4, {
			heading=345,
			--debugPoly=true,
			minZ=27.4,
			maxZ=31.4
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
	stwb_ave_2 = {
		Location = CircleZone:Create(vector3(332.46, -697.78, 29.2), 10.0, {
			useZ=true,
			--debugPoly=true
		}),
		PanelLocation = BoxZone:Create(vector3(334.4, -677.98, 29.3), 2, 2, {
			heading=345,
			--debugPoly=true,
			minZ=28.1,
			maxZ=32.1
		}),
		Online = true,
		Whitelist = SpeedCamera.WhitelistedVehicles,
		Access = {"police"},
		SpeedLimit = 70, --MPH
		ANPR = true,
		SpeedDetection = true,
	},
}

