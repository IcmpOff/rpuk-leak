Config = {}

--[[
Please try to maintain catagories and format throughout

For random location generation I have kept drug runs and money wash in their individual files

https://docs.fivem.net/docs/game-references/blips/

As I go on, exclusive blips are size 0.9 and mass blips like shops are 0.7

Blips pack is from

https://www.gta5-mods.com/misc/new-colorful-hud-weapons-radio-map-blips
]]--

Config.Blips = {
	{name = "TwentyFourSeven", text = "Shop", color = 0, id = 52, coords = vector3(373.875,   325.896,  102.566)},
	{name = "TwentyFourSeven", text = "Shop", color = 0, id = 52, coords = vector3(2557.458,  382.282,  107.622)},
	{name = "TwentyFourSeven", text = "Shop", color = 0, id = 52, coords = vector3(-3038.939, 585.954,  6.908)},
	{name = "TwentyFourSeven", text = "Shop", color = 0, id = 52, coords = vector3(547.431,   2671.710, 41.156)},
	{name = "TwentyFourSeven", text = "Shop", color = 0, id = 52, coords = vector3(1961.464,  3740.672, 31.343)},
	{name = "TwentyFourSeven", text = "Shop", color = 0, id = 52, coords = vector3(2678.916,  3280.671, 54.241)},

	{name = "RobsLiquor", text = "Shop", color = 0, id = 52, coords = vector3(-1222.915, -906.983,  11.326)},
	{name = "RobsLiquor", text = "Shop", color = 0, id = 52, coords = vector3(-1487.553, -379.107,  39.163)},
	{name = "RobsLiquor", text = "Shop", color = 0, id = 52, coords = vector3(-2968.243, 390.910,   14.043)},
	{name = "RobsLiquor", text = "Shop", color = 0, id = 52, coords = vector3(1392.562,  3604.684,  33.980)},

	{name = "LTDgasoline", text = "Shop", color = 0, id = 52, coords = vector3(-48.519,   -1757.514, 28.421)},
	{name = "LTDgasoline", text = "Shop", color = 0, id = 52, coords = vector3(1163.373,  -323.801,  68.205)},
	{name = "LTDgasoline", text = "Shop", color = 0, id = 52, coords = vector3(-707.501,  -914.260,  18.215)},
	{name = "LTDgasoline", text = "Shop", color = 0, id = 52, coords = vector3(-1820.523, 792.518,   137.118)},
	{name = "LTDgasoline", text = "Shop", color = 0, id = 52, coords = vector3(1698.388,  4924.404,  41.063)},

	{
		name = "FishingShop", text = "Wang's Fishing Shop", color = 8, id = 543, blipDetail = true,
		description = 'Mr Wang\'s Shop is a family business on its second generation. You can sell all your fish here.',
		coords = vector3(-1122.2, 2681.9, 17.6), category = 10
	},

	--[[{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(72.3, -1399.1, 28.4)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(-703.8, -152.3, 36.4)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(-167.9, -299.0, 38.7)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(428.7, -800.1, 28.5)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(-829.4, -1073.7, 10.3)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(-1447.8, -242.5, 48.8)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(11.6, 6514.2, 30.9)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(123.6, -219.4, 53.6)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(1696.3, 4829.3, 41.1)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(618.1, 2759.6, 41.1)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(1190.6, 2713.4, 37.2)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(-1193.4, -772.3, 16.3)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(-3172.5, 1048.1, 19.9)},
	{name = "Clothing", text = "Clothes Shop", color = 50, id = 73, coords = vector3(-1108.4, 2708.9, 18.1)},
	{name = "Clothing", text = "Haters Clothing Shop", color = 50, id = 73, coords = vector3(-1121.87, -1439.17, 5.23)},
	{name = "Clothing", text = "Shell Shock Armour", color = 50, id = 73, coords = vector3(18.147754669189, -1111.0356445313, 28.797018051147)},
	{name = "Clothing", text = "Shell Shock Armour", color = 50, id = 73, coords = vector3(248.13249206543, -46.308071136475, 68.941070556641)},

	{name = "WeaponShop", text = "Weapon Shop", color = 1, id = 110, coords = vector3(20.1, -1106.2, 29.7)},
	{name = "WeaponShop", text = "Weapon Shop", color = 1, id = 110, coords = vector3(810.2, -2157.3, 29.6)},
	{name = "WeaponShop", text = "Weapon Shop", color = 1, id = 110, coords = vector3(1693.4, 3759.5, 34.7)},
	{name = "WeaponShop", text = "Weapon Shop", color = 1, id = 110, coords = vector3(-330.2, 6083.8, 31.4)},]]

	{name = "NightClub", text = "Night Club", color = 57, id = 590, coords = vector3(-1388.609, -586.304, 29.218)},
	{name = "NightClub", text = "Night Club", color = 57, id = 590, coords = vector3(110.13, -1288.70, 28.85)},

	{name = "BorisBikes", text = "Boris Bikes", color = 46, id = 536, scale = 0.5, coords = vector3(-1014.199,  -2695.161,  12.981)},
	{name = "BorisBikes", text = "Boris Bikes", color = 46, id = 536, scale = 0.5, coords = vector3(-537.118,  -307.369,  34.212)},
	{name = "BorisBikes", text = "Boris Bikes", color = 46, id = 536, scale = 0.5, coords = vector3(-203.851,  -1005.026,  28.146)},
	{name = "BorisBikes", text = "Boris Bikes", color = 46, id = 536, scale = 0.5, coords = vector3(-1642.636,  -1022.770,  12.152)},
	{name = "BorisBikes", text = "Boris Bikes", color = 46, id = 536, scale = 0.5, coords = vector3(-2192.987,  4253.681,  47.081)},
	{name = "BorisBikes", text = "Boris Bikes", color = 46, id = 536, scale = 0.5, coords = vector3(2687.176,  3290.950,  54.241)},

	{name = "VehImpound", text = "Vehicle Impound", color = 46, id = 446, coords = vector3(375.479, -1611.892, 30.292)},

	--[[{name = "Barbers", text = "Hair & Beauty", color = 50, id = 71, coords = vector3(-814.308,  -183.823,  36.598)},
	{name = "Barbers", text = "Hair & Beauty", color = 50, id = 71, coords = vector3(136.826,   -1708.373, 28.320)},
	{name = "Barbers", text = "Hair & Beauty", color = 50, id = 71, coords = vector3(-1282.604, -1116.757, 6.020)},
	{name = "Barbers", text = "Hair & Beauty", color = 50, id = 71, coords = vector3(1931.513,  3729.671,  31.874)},
	{name = "Barbers", text = "Hair & Beauty", color = 50, id = 71, coords = vector3(1212.840,  -472.921,  65.238)},
	{name = "Barbers", text = "Hair & Beauty", color = 50, id = 71, coords = vector3(-32.885,   -152.319,  56.106)},
	{name = "Barbers", text = "Hair & Beauty", color = 50, id = 71, coords = vector3(-278.077,  6228.463,  30.725)},]]

	{name = "Bank", text = "Los Santos Bank", color = 2, id = 374, coords = vector3(146.913, -1044.836, 28.376)}, -- Fleeca Bank Vespucci Boulevard
	{name = "Bank", text = "Los Santos Bank", color = 2, id = 374, coords = vector3(-103.649, 6477.946, 30.627)}, -- Blaine County North Savings Bank
	{name = "Bank", text = "Los Santos Bank", color = 2, id = 374, coords = vector3(1175.55, 2712.92, 37.09)}, -- Fleeca Bank Route 68
	{name = "Bank", text = "Los Santos Bank", color = 2, id = 374, coords = vector3(-1210.39, -336.38, 36.78)}, -- Fleeca Bank Blvd Del Perro


	{name = "grapeseed_south", text = "Public Carpark", color = 84, id = 558, coords = vector3(1695.578, 4789.248, 40.998)},
	{name = "legionsquare", text = "Public Carpark", color = 84, id = 558, coords = vector3(232.093, -760.170, 29.843)},
	{name = "altast_pillbox", text = "Public Carpark", color = 84, id = 558, coords = vector3(-316.530, -1030.919, 29.535)},
	{name = "clintonave_vinewood", text = "Public Carpark", color = 84, id = 558, coords = vector3(441.515, 230.807, 102.165)},
	{name = "paleto boulevard", text = "Public Carpark", color = 84, id = 558, coords = vector3(-133.60, 6276.63, 31.35)},
	{name = "west_vinewood", text = "Public Carpark", color = 84, id = 558, coords = vector3(-625.9, 191.7, 68.2)},
	{name = "ls_cityhall", text = "Public Carpark", color = 84, id = 558, coords = vector3(-557.997, -165.256, 37.309)},  

	{name = 'boat_tackle_st', text = 'Boat Garage', color = 3, id = 356, coords = vector3(-721.5, -1324.2, 0.6)},
	{name = 'boat_paleto_cove', text = 'Boat Garage', color = 3, id = 356, coords = vector3(-1606.6, 5256.6, 2.9)},
	{name = 'boat_san_chianski_mountain_range', text = 'Boat Garage', color = 3, id = 356, coords = vector3(3866.5, 4463.6, 1.7)},

	{name = "warehouse", text = "The White Company", color = 84, id = 478, coords = vector3(-1062.1804199219, -2078.6962890625, 12.287417411804)},

	--[[{name = "VehCustomize", text = "LS Customs", color = 4, id = 72, coords = vector3(-350.655,-136.55, 38.295)},
	{name = "VehCustomize", text = "LS Customs", color = 4, id = 72, coords = vector3(726.157, -1088.768, 22.169)},
	{name = "VehCustomize", text = "LS Customs", color = 4, id = 72, coords = vector3(-1150.26,-1995.642, 12.466)},
	{name = "VehCustomize", text = "LS Customs", color = 4, id = 72, coords = vector3(1174.701,2643.764, 37.048)},]]

	{name = "ParkRangers", text = "National Park Rangers", color = 0, id = 141, coords = vector3(386.989,   791.163,  187.0)},


	{name = "AppleField", text = "Apple Field", color = 2, id = 605, coords = vector3(1199.872, 4356.130, 43.774), category = 10},
	{name = "OrangeField", text = "Orange Field", color = 47, id = 556, coords = vector3(810.095, 266.480, 88.066), category = 10},
	{name = "CedarField", text = "Cedar Field", color = 2, id = 79, coords = vector3(1788.67, 6545.71, 66.65), category = 10},
	{name = "LumberYard", text = "Lumber Yard", color = 2, id = 285, coords = vector3(-553.74, 5324.40, 72.60), category = 10},

	--{name = "PumpkinPatch", text = "Pumpkin Patch", color = 0, id = 593, coords = vector3(1260.1202392578, 1815.1553955078, 81.210441589355)},
	--{name = "HalloweenVendors", text = "Halloween Vendors", color = 0, id = 594, coords = vector3(338.55685424805, -2041.7852783203, 20.311929702759)},

	{name = "RPUKBloodStart", text = "Blood Pickup", color = 0, id = 153, coords = vector3(296.0, -1446.0, 30.0), category = 10},
	{name = "RPUKBloodStop", text = "Blood Drop-off", color = 0, id = 153, coords = vector3(1840.0, 3673.0, 34.0), category = 10},

	{name = "OilContainers", text = "Oil Container Spillage", color = 13, id = 415, coords = vector3(-2544.271, 3879.676, 2.55), category = 10},

	{name = "RPUKDelivery", text = "Food Delivery", color = 13, id = 488, coords = vector3(1554.40, 3802.47, 33.00)},
	{name = "RPUKDelivery", text = "Food Delivery", color = 13, id = 488, coords = vector3(-1271.89, -880.60, 10.90)},

	{
		name = "BeanMachine", text = "Bean Machine", color = 16, id = 647, blipDetail = true, owner = 'Connor, Mick & Jeff',
		coords = vector3(-628.9, 246.0, 80.7)
	},

	{name = "DiamondShop", text = "T.B.Jewellers", color = 26, id = 617, coords = vector3(-625.127,  -232.233,  37.0), category = 10},
	{name = "MetalSmelting", text = "Smeltery", color = 9, id = 648, coords = vector3(1114.788,  -2004.394,  34.444), category = 10},

	{
		name = "ComedyClub", text = "Wilco's Comedy Club", color = 0, id = 93,
		coords = vector3(-430.142,   261.5,  82.005)
	},

	{
		name = "LSGym", text = "Los Santos Gym", color = 0, id = 311,
		coords = vector3(-45.062, -1290.042,  28.182)
	},

	{name = "TwentyFourSeven", text = "Player Shop", color = 5, id = 52, coords = vector3(1729.216,  6414.131, 34.037)},
	{name = "RobsLiquor", text = "Player Shop", color = 5, id = 52, coords = vector3( 1166.024,  2708.930,  37.157)},
	{name = "RobsLiquor", text = "Player Shop", color = 5, id = 52, coords = vector3(-2540.911, 2313.988, 32.411)}, -- route 68
	{name = "TwentyFourSeven", text = "Player Shop", color = 5, id = 52, coords = vector3(161.774,  6640.492, 30.711)},

	{
		name = "TaxiRank", text = "Downtown Cab Co.", color = 46, id = 56, coords = vector3(911.108, -177.867, 74.283),
		blipDetail = true, imgName = "taxi", jType = "~b~Driving", category = 10,
		description = "Collecting customers and driving them to their final destination. Includes distance based job payouts."
	},

	--{name = "RonOil", text = "RON Petroleum", color = 13, id = 479, coords = vector3(1513.433, -2533.246, 56.488), blipDetail = true, imgName = "ronoil", jType = "~b~Driving", description = "Delivery job for RON Petroleum, moving tankers of oil from manufacturing to petrol stations!")},

	{
		name = "Casino", text = "Diamond Casino & Resort", color = 26, id = 617, coords = vector3(922.293, 48.235, 80.0),
		blipDetail = true, imgName = "casino",
		description = "At the heart and soul of The Diamond is your enjoyment, whether you’re meeting with friends for an array of activities or finding peace of mind in your personal Penthouse Spa.", description2 = "The Diamond is here to spoil you. (Blackjack, Slot Machines, Luckywheel, Exclusive Clothing & Vehicles and much more to come!)"
	},

	{
		name = "CarBuy1", text = "Premium Deluxe Motorsport", color = 4, id = 523, coords = vector3(-56.576, -1096.856, 25.4),
		blipDetail = true, imgName = "motorsport", category = 11,
		description = "Founded by Simeon Yetarian, Premium Deluxe Motorsport offers a range of basic vehicles from your everyday SUVs to your Mercedes imports."
	},

	{
		name = "BoatShop1", text = "Boat Shop", color = 0, id = 404, coords = vector3(-815.5, -1346.4, 4.1),
		blipDetail = true, description = "Buy your very own boat."
	},

	{
		name = "jail", text = "Bolingbroke Penitentiary", color = 4, id = 188, scale = 0.9,
		coords = vector3(1854.00, 2622.00, 45.00), blipDetail = true, imgName = "prison",
		description = "Ran by the San Andreas State Prison Authority. Bolingbroke offers a wide range of activities for inmates, and promotes adoption of a healthy and lawful lifestyle."
	},

	{
		name = "hospital_pillbox", text = 'Hospital', title = "Pillbox Hill Medical Center", color = 11, id = 61,
		coords = vector3(307.07, -594.85, 42.427), blipDetail = true, imgName = "hospital_pillbox",
		description = "The Pillbox Hill Medical Center is the main hospital serving Central Los Santos"
	},

	{
		name = "hospital_sandyshores", text = 'Hospital', title = "Sandy Shores Medical Center", color = 11, id = 61,
		scale = 0.5, coords = vector3(1839.5, 3672.6, 33.2), blipDetail = true, imgName = "hospital_sandy",
		description = "The Sandy Shores Medical Center is a smaller hospital at the center of Sandy Shores"
	},

	{
		name = "hospital_paletobay", text = 'Hospital', title = "Bay Care Center", color = 11, id = 61,
		coords = vector3(-244.0, 6327.8, 31.4), blipDetail = true, imgName = "hospital_paleto",
		description = "The Bay Care Center is a smaller hospital at the heart of the residence of pine"
	},

	{
		name = "pd_sandyshores", text = "Police Station", color = 0, id = 60, scale = 0.5, coords = vector3(1855.7, 3682.3, 33.2),
		blipDetail = true, title = "Sandy Shores Police Station",
		description = "",
		description2 = ""
	},

	{
		name = "pd_mrpd", text = "Police Station", color = 0, id = 60, coords = vector3(429.052, -982.082, 29.711),
		blipDetail = true, title = "Mission Row Police Station",
		description = "Mission Row Police Station is one of the police stations on Los Santos. Officers from here can deploy to patrol all over the island.",
		description2 = "Chief Superintendent: Shane Jones~n~Superintendent: Barry Greenhalgh~n~Superintendent: Shepherd Kingston"
	},

	{
		name = "pd_vespucci", text = "Police Station", color = 0, id = 60, coords = vector3(-1102.17, -840.18, 19.00),
		blipDetail = true, imgName = "vespucci", title = "Vespucci Police Station",
		description = "Vespucci Police Station is one of the police stations on Los Santos. Officers from here can deploy to patrol all over the island.",
		description2 = "Chief Superintendent: Shane Jones~n~Superintendent: Barry Greenhalgh~n~Superintendent: Shepherd Kingston"
	},

	{
		name = "pd_paleto", text = "Police Station", color = 0, id = 60, coords = vector3(-441.0, 6018.5, 30.5),
		blipDetail = true, title = "Paleto Bay Police Station",
		description = "",
		description2 = ""
	},

	--{name = "VehCustomize", text = "Benny's Original Motor Works", color = 83, id = 72, coords = vector3(-205.626,-1314.99, 30.247), blipDetail = true, imgName = "bennys", description = "Turning your classic junker into a high-spec, tricked-out king of the streets.")},

	{
		name = "cityHall", text = "Los Santos City Hall", color = 0, id = 181,
		coords = vector3(-552.701, -191.053, 37.220), blipDetail = true, imgName = "townhall",
		description = "The centre of all governmental affairs. Licences and permits can be granted here."
	},

	--{name = "tacdeps", text = "Tactical Deployment HQ", color = 54, id = 178, coords = vector3(-709.03, -1382.63, 5.28), blipDetail = true, imgName = "tacdep", description = "The centre hub for all emergency services to deploy boats and aircraft at their disposal.")},

	--[[
		{name = "TattooShop", text = "Los Santos Tattoos", linkName = "Tattoo Studio", color = 50, id = 75, coords = vector3(1322.6,  -1651.9,  51.2), blipDetail = true, imgName = "lossantostats", description = "Nothing says individuality like a tribal band of Chinese symbols you don't understand out of a catalogue at random.")},
		{name = "TattooShop", text = "The Pit", linkName = "Tattoo Studio", color = 50, id = 75, coords = vector3(-1153.6,  -1425.6,  4.9), blipDetail = true, imgName = "thepit", description = "Nothing says individuality like a tribal band of Chinese symbols you don't understand out of a catalogue at random.")},
		{name = "TattooShop", text = "Blazing Tattoo", linkName = "Tattoo Studio", color = 50, id = 75, coords = vector3(322.1,  180.4,  103.5), blipDetail = true, imgName = "blazingtats", description = "Nothing says individuality like a tribal band of Chinese symbols you don't understand out of a catalogue at random.")},
		{name = "TattooShop", text = "InkInc Tattoos", linkName = "Tattoo Studio", color = 50, id = 75, coords = vector3(-3170.0,  1075.0,  20.8), blipDetail = true, imgName = "inktats", description = "Nothing says individuality like a tribal band of Chinese symbols you don't understand out of a catalogue at random.")},
		{name = "TattooShop", text = "Tattoo Body Art & Piercing", linkName = "Tattoo Studio", color = 50, id = 75, coords = vector3(1864.6,  3747.7,  33.0), blipDetail = true, imgName = "tattoo", description = "Nothing says individuality like a tribal band of Chinese symbols you don't understand out of a catalogue at random.")},
		{name = "TattooShop", text = "Tattoo Body Art & Piercing", linkName = "Tattoo Studio", color = 50, id = 75, coords = vector3(-293.7,  6200.0,  31.4), blipDetail = true, imgName = "tattoo2", description = "Nothing says individuality like a tribal band of Chinese symbols you don't understand out of a catalogue at random.")},
	]]

	{
		name = "YouTool", text = "YouTool Housing & Hardware", linkName = "Housing and Hardware", color = 47, id = 566,
		coords = vector3(2755.125,  3469.180,  54.759), blipDetail = true, imgName = "youtools",
		description = "One of those stores where you find something you didn't know you needed!"
	},

	{
		name = "DeliveryHub", text = "Pegasus | Commerical Delivery Hub", linkName = "Delivery Hub", color = 13, id = 477,
		coords = vector3(1011.752,  -2525.055,  27.308), blipDetail = true, imgName = "deliveryhub", category = 10,
		description = "Apart of the Pegasus Business Empire. The delivery hub is the centeral location for all deliveries in Los Santos.~n~A great place to get a job!"
	},

	{
		name = "GolfClub", text = "Los Santos | Country Club", linkName = "LS Country Club", color = 0, id = 109,
		coords = vector3(-1345.193, 58.679, 54.246), blipDetail = true, imgName = "golfclub", owner = "The High Society",
		description = "A truly beautiful course. For a price anyone can play.~n~To truly integrate into the High Society reputation, wealth, and influence are all taken into consideration."
	},

	{
		name = "PlayerShop", text = "El Rancho, Noble Store", linkName = "Player Shop", color = 5, id = 52,
		coords = vector3( 1135.808,  -982.281,  45.415), blipDetail = true, imgName = "stavshop", owner = "Chris Noble",
		description = "Noble Store's aims to give its customers a simpler everyday life and through low prices, good selection, availability and high customer focus will have close and lasting customer relationships."
	},

	{
		name = "PlayerShop", text = "Mosley's Dealership & Auto Repairs", linkName = "Mosley's Car Dealership", color = 5,
		id = 523, coords = vector3(-41.2, -1675.4, 28.4), blipDetail = true, imgName = "mosleys", owner = "Tokjat Stock", category = 11,
		description = "A recently acquired business. Provider of automobile equipment such as brakes, shocks, tires.~n~Access to import vehicles from overseas."
	},

	{
		name = "PlayerShop", text = "AutoCare Auto Repairs & Imports", color = 5, id = 523, category = 11,
		coords = vector3(946.5, -987.7, 38.2), blipDetail = true, imgName = "autocare", owner = "Harley Rose",
		description = "A recently acquired business. Provider of automobile equipment such as brakes, shocks, tires.~n~Access to import vehicles from overseas."
	},

	{
		name = "PlayerShop", text = "Beekers Garage & Parts", color = 5, id = 523, category = 11,
		coords = vector3(100.796,6618.104, 31.435), blipDetail = true, imgName = "beekers", owner = "Wilf Williams",
		description = "A recently acquired business. Provider of automobile equipment such as brakes, shocks, tires.~n~Access to import vehicles from overseas."
	},

	{
		name = "PlayerShop", text = "Benefactor, Luxury Automaker", color = 5, category = 11,
		id = 523, coords = vector3(-56.010, 67.752, 70.947), blipDetail = true, imgName = "benefactor",
		description = "A recently acquired business. Provider of automobile equipment such as brakes, shocks, tires.~n~Access to import vehicles from overseas."
	},

	{name = "scrapyard",  text = "Custom Motorcycles", color = 5, id = 661, category = 11, coords = vector3(38.3, 6453.9, 30.4)},

	{
		name = "lifeinvader", text = "Lifeinvader Office", linkName = "Lifeinvader", color = 49, id = 77,
		coords = vector3(-1082.14, -247.58, 36.76), blipDetail = true, imgName = "liveinvader_outside",
		description = "The technology core for the city! Built on corruption, and government intel. Your privacy is not our number one priority."
	},
}