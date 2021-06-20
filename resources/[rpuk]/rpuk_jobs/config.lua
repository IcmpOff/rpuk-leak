Config = {}

Config.Fishing = {
	-- How long should it take for player to catch a fish in miliseconds
	FishTime = {a = 20000, b = 44000},
}

Config.Ocean = {
	-- Possible ocean salvage locations
	Locations = {
		vector3(3173.8, -320.1, -20.9),
		vector3(3150.1, -330.6, -26.0),
		vector3(3195.0, -377.6, -32.8),
		vector3(3186.7, -392.8, -16.5),
		vector3(3250.9, -420.4, -77.0),
		vector3(3298.2, -408.6, -123.0),
		vector3(3268.6, -448.5, -88.5),
		vector3(-882.0, 6629.6, -28.1),
		vector3(-898.7, 6647.9, -27.7),
		vector3(-914.5, 6665.6, -34.9),
		vector3(-998.3, 6704.2, -43.6),
		vector3(-1014.7, 6533.1, -28.6),
		vector3(-2838.8, -434.3, -29.9),
		vector3(-2845.6, -468.4, -31.6),
		vector3(-3400.8, 3716.8, -82.2),
		vector3(-3398.6, 3721.2, -79.8),
		vector3(-3182.4, 3040.8, -36.9),
		vector3(-3177.7, 3045.2, -39.5),
		vector3(3158.3, -262.1, -26.6),
		vector3(-3593.8, 1974.0, -154.3),
		vector3(-2012.1, -1245.5, -123.8),
		vector3(1826.1, -2920.9, -36.4),
		vector3(1864.9, -2944.5, -43.6),
		vector3(4167.9, 3710.7, -31.4),
		vector3(3158.3, -262.1, -26.6),
		vector3(4236.4, 3597.1, -45.2),
		vector3(3792.0, 3659.8, -17.1),
		vector3(3158.3, -262.1, -26.6),
		vector3(-2845.6, -468.4, -31.6),
		vector3(-1014.7, 6533.1, -28.6)
	}
}

Config.Harvesting = {
	SpawnDistance = 50,

	HarvestingZone = {
		{
			HelpNotification = "[~o~Orange Tree~s~]\nPress ~INPUT_PICKUP~ To Harvest ~o~Oranges\n\n\n~c~Oranges can be sold to local shops for a quick penny!", -- The help hint when in radius
			Marker = vector3(810.095,266.480, 88.066), -- the center of the harvesting location
			RadiusVar = 30, -- the distance of the land // alter this and the spawned quantity
			Timer = 10, -- Seconds to harvest the item
			AnimLib = nil, Task = "WORLD_HUMAN_GARDENER_PLANT", -- Anims = (lib, task) / scenario = (nil, task)
			SpawnObject = "prop_tree_birch_05",
			SpawnObjectMaxCount = 10,
			ObjectHandles = {}, -- Don't touch, this is the entity handles and the object counts
			OutRandom = true, -- if true, the output will be -2 or +2 than the quantity value below // False = the output is a fixed value
			Output = {["unripe_orange"] = 3} -- Output of the harvesting, followed by quantity / will accept randomness
			--RareObj = "shark" -- if present in the table it will run a 10% chance to get 1 of these items per item in the output
		},
		{
			HelpNotification = "[~r~Apple Tree~s~]\nPress ~INPUT_PICKUP~ To Harvest ~r~Apple\n\n\n~c~Apples can be sold to local shops for a quick penny!", -- The help hint when in radius
			Marker = vector3(1199.872,4356.130,43.774),
			RadiusVar = 30,
			Timer = 10,
			AnimLib = nil, Task = "WORLD_HUMAN_GARDENER_PLANT",
			SpawnObject = "prop_tree_birch_05",
			SpawnObjectMaxCount = 10,
			ObjectHandles = {},
			OutRandom = true,
			Output = {["unripe_apple"] = 3}
		},
		{
			HelpNotification = "[~r~Blood Bag Delivery~s~]\nPress ~INPUT_PICKUP~ To Pickup ~r~Blood Bag~s~\n\n\n~c~Bloodbags can be delivered to Sandy Shores medical center for a cash reward!",
			Marker = vector3(268.494,-1360.905,24.340),
			RadiusVar = 0,
			Timer = 2,
			AnimLib = nil, Task = "WORLD_HUMAN_TOURIST_MAP",
			SpawnObject = "xm_prop_x17_bag_med_01a",
			SpawnObjectMaxCount = 1,
			ObjectHandles = {},
			OutRandom = false,
			Output = {["blood_bag_delivery"] = 1},
		},
		{
			HelpNotification = "[~y~Oil Container~s~]\nPress ~INPUT_PICKUP~ To ~y~Oil Container~s~\n\n\n~c~Can be taken to the plastic factory!",
			Marker = vector3(-2544.271, 3879.676, 2.55),
			RadiusVar = 25,
			Timer = 1,
			AnimLib = "weapons@first_person@aim_rng@generic@projectile@sticky_bomb@", Task = "plant_floor",
			SpawnObject = "ng_proc_oilcan01a",
			SpawnObjectMaxCount = 25,
			ObjectHandles = {},
			OutRandom = false,
			Output = {["petrol"] = 1},
		},
		{
			HelpNotification = "[~r~Cedar Trees~s~]\nPress ~INPUT_PICKUP~ To Harvest ~r~Cedar\n\n\n~c~Can be taken to the lumber yard!",
			Marker = vector3(1789.83, 6545.641, 66.61),
			RadiusVar = 25,
			Timer = 5,
			AnimLib = nil, Task = "WORLD_HUMAN_GARDENER_PLANT",
			SpawnObject = "prop_tree_cedar_s_02",
			SpawnObjectMaxCount = 25,
			ObjectHandles = {},
			OutRandom = false,
			Output = {["wood"] = 1},
		},
		{
			HelpNotification = "",
			Marker = vector3(2793.706, 6521.086, 1.324),
			RadiusVar = 1,
			Timer = 30,
			AnimLib = nil, Task = "WORLD_HUMAN_GARDENER_PLANT",
			SpawnObject = "prop_box_ammo03a",
			SpawnObjectMaxCount = 1,
			ObjectHandles = {},
			OutRandom = false,
			Output = {["weapon_microsmg"] = 1},
			hidden = true -- hidden location
		},
		----Prison
		{
			HelpNotification = "[~r~Apple Tree~s~]\nPress ~INPUT_PICKUP~ To Harvest ~r~Apple\n\n\n~c~You can use these to create smoothies!", -- The help hint when in radius
			Marker = vector3(1752.1982421875, 2545.234375, 42.564968109131),
			RadiusVar = 10,
			Timer = 15,
			AnimLib = nil, Task = "WORLD_HUMAN_GARDENER_PLANT",
			SpawnObject = "prop_tree_birch_05",
			SpawnObjectMaxCount = 7,
			ObjectHandles = {},
			OutRandom = true,
			Output = {["apple"] = 3}
		},
		{
			HelpNotification = "[~r~Orange Tree~s~]\nPress ~INPUT_PICKUP~ To Harvest ~r~Apple\n\n\n~c~You can use these to create smoothies!", -- The help hint when in radius
			Marker = vector3(1661.1572265625, 2522.109375, 43.564876556396),
			RadiusVar = 10,
			Timer = 15,
			AnimLib = nil, Task = "WORLD_HUMAN_GARDENER_PLANT",
			SpawnObject = "prop_tree_birch_05",
			SpawnObjectMaxCount = 8,
			ObjectHandles = {},
			OutRandom = true,
			Output = {["orange"] = 3}
		},
		---
		{
			HelpNotification = "[~r~Mushroom~s~]\nPress ~INPUT_PICKUP~ To Pick ~o~Mushroom",
			Marker = vector3(-103.022, 1249.645, 293.311),
			RadiusVar = 10,
			Timer = 15,
			AnimLib = nil, Task = "WORLD_HUMAN_GARDENER_PLANT",
			SpawnObject = "prop_stoneshroom2",
			SpawnObjectMaxCount = 8,
			ObjectHandles = {},
			OutRandom = false,
			Output = {["drug_magicmushroom"] = 1}
		},		
		{
			HelpNotification = "[~r~Mushroom~s~]\nPress ~INPUT_PICKUP~ To Pick ~o~Mushroom",
			Marker = vector3(645.419, 2470.821, 61.824),
			RadiusVar = 10,
			Timer = 15,
			AnimLib = nil, Task = "WORLD_HUMAN_GARDENER_PLANT",
			SpawnObject = "prop_stoneshroom2",
			SpawnObjectMaxCount = 8,
			ObjectHandles = {},
			OutRandom = false,
			Output = {["drug_magicmushroom"] = 1}
		},
		{
			HelpNotification = "[~r~Mushroom~s~]\nPress ~INPUT_PICKUP~ To Pick ~o~Mushroom",
			Marker = vector3(1345.728, 1704.665, 89.994),
			RadiusVar = 10,
			Timer = 15,
			AnimLib = nil, Task = "WORLD_HUMAN_GARDENER_PLANT",
			SpawnObject = "prop_stoneshroom2",
			SpawnObjectMaxCount = 8,
			ObjectHandles = {},
			OutRandom = false,
			Output = {["drug_magicmushroom"] = 1}
		},
		{
			HelpNotification = "[~r~Mushroom~s~]\nPress ~INPUT_PICKUP~ To Pick ~o~Mushroom",
			Marker = vector3(-1815.345, 2302.179, 58.358),
			RadiusVar = 5,
			Timer = 15,
			AnimLib = nil, Task = "WORLD_HUMAN_GARDENER_PLANT",
			SpawnObject = "prop_stoneshroom2",
			SpawnObjectMaxCount = 8,
			ObjectHandles = {},
			OutRandom = false,
			Output = {["drug_magicmushroom"] = 1}
		},
		{	
			HelpNotification = "[~g~Washed Up Pseudoephedrine~s~]\nPress ~INPUT_PICKUP~ To Pickup ~b~Pseudoephedrine~s~\n\n\n~c~Pseudoephedrine can be processed into Meth and sold!",	
			Marker = vector3(-1646.329, 4490.479, -0.023),	
			RadiusVar = 30,	
			Timer = 10,	
			AnimLib = nil, Task = "WORLD_HUMAN_GARDENER_PLANT",	
			SpawnObject = "bkr_prop_meth_pseudoephedrine",	
			SpawnObjectMaxCount = 15,	
			ObjectHandles = {},	
			OutRandom = true,	
			Output = {["pseudoephedrine"] = 10}	
		},
		
	}
}