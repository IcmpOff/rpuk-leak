Config.Delivery = {}
Config.Delivery.Debug = false

Config.Delivery.RentVehs = {
	["foodvehicles"] = {
		header = "fooddelivery",
		location = vector3(-1268.343, -878.648, 10.930),
		rLocation = vector3(-1164.821, -889.556, 13.125),
		marker	 = {type = 1, draw = 50, colour = {r = 116, g = 123, b = 240 }},
		hint	 = "Press ~INPUT_PICKUP~ to ~y~Rent a Vehicle~s~",
		vehicles = {
			{model = "foodcar", price = 500, spawn = {x = -1251.97, y = -883.97, z = 11.43, h = 125.06}},
			{model = "foodcar2", price = 500, spawn = {x = -1257.01, y = -887.52, z = 11.53, h = 125.06}},
			{model = "foodcar3", price = 500, spawn = {x = -1262.60, y = -891.27, z = 10.97, h = 125.06}},
		}
	},
	["foodvehicles2"] = {
		header = "fooddelivery",
		location = vector3(-1168.702, -896.852, 12.916),
		rLocation = vector3(-1252.409, -863.561, 11.391),
		marker	 = {type = 1, draw = 50, colour = {r = 116, g = 123, b = 240 }},
		hint	 = "Press ~INPUT_PICKUP~ to ~y~Rent a Vehicle~s~",
		vehicles = {
			{model = "foodcar", price = 500, spawn = {x = -1172.94, y = -876.65, z = 13.94, h = 125.06}},
			{model = "foodcar2", price = 500, spawn = {x = -1174.75, y = -872.96, z = 13.95, h = 125.06}},
			{model = "foodcar3", price = 500, spawn = {x = -1170.83, y = -879.91, z = 13.94, h = 125.06}},
		}
	},
	["commercialvehicles"] = {
		header = "deliveryhub",
		location = vector3(1018.891, -2511.627, 27.480),
		rLocation = vector3(-1164.821, -889.556, 13.125),
		marker	 = {type = 1, draw = 50, colour = {r = 116, g = 123, b = 240 }},
		hint	 = "Press ~INPUT_PICKUP~ to ~y~Rent a Commercial Vehicle~s~",
		vehicles = {
			{model = "packer", price = 5000, spawn = {x = 1006.82, y = -2488.80, z = 28.37, h = 158.36}},
		}
	},
	["mechanicvehicles"] = { -- remote accessed
		header = "mechanic",
		location = vector3(0, 0, -100),
		rLocation = vector3(0, 0, -100),
		marker	 = {type = 1, draw = 0, colour = {r = 116, g = 123, b = 240 }},
		hint	 = "Press ~INPUT_PICKUP~ to ~y~Rent a Mechanic Vehicle~s~",
		vehicles = {
			{model = "flatbed", price = 500, spawn = {x = 391.20, y = -1621.75, z = 29.38, h = 321.44}},
			{model = "hldiscovery", price = 2500, spawn = {x = 391.20, y = -1621.75, z = 29.38, h = 321.44}},
			{model = "rpCiv3", price = 1000, spawn = {x = 391.20, y = -1621.75, z = 29.38, h = 321.44}},
		}
	},
}

Config.Delivery.StartPoints = {
	["deliv_mobile"] = { -- Canals
		header = "fooddelivery",
		prop	 = {model = "p_planning_board_01", x = -1271.89, y = -880.60, z = 10.90, h = 39.52},
		job_type = "food",
		progress = "delivery",
		job_pool = "npcdoors",
		location = vector3(-1271.89, -880.60, 12.30),
		draw	 = 4.5,
		distance = 1.5,
		marker	 = {colour = {r = 116, g = 123, b = 240 }},
		hint = "Press [~b~E~s~] To Checkout the Job Postings",
		clothing = {
			["male"] = {
				[0] = {"prop", 58, 2, 0}, -- Hat
				[1] = {"comp", 121, 0, 2}, -- Mask
				[3] = {"comp", 0, 0, 2}, -- Torso
				[4] = {"comp", 35, 0, 2}, -- Legs
				[5] = {"comp", 23, 14, 2}, -- Bags
				[6] = {"comp", 24, 0, 2}, -- Shoes
				[8] = {"comp", 15, 0, 2}, -- Undershirt
				[11] = {"comp", 94, 2, 2}, -- Tops
			},
			["female"] = {
				[0] = {"prop", 58, 2, 2}, -- Hat
				[1] = {"comp", 121, 0, 2}, -- Mask
				[3] = {"comp", 14, 0, 2}, -- Torso
				[4] = {"comp", 34, 0, 2}, -- Legs
				[5] = {"comp", 23, 14, 2}, -- Bags
				[6] = {"comp", 24, 0, 2}, -- Shoes
				[8] = {"comp", 3, 0, 2}, -- Undershirt
				[11] = {"comp", 85, 2, 2}, -- Tops
			},
		},
	},
	["deliv_mobile2"] = { -- Sandy Shores
		header = "fooddelivery",
		prop	 = {model = "p_planning_board_01", x = 1554.40, y = 3802.47, z = 33.00, h = 26.69},
		job_type = "food",
		progress = "delivery",
		job_pool = "npcdoors",
		location = vector3(1554.40, 3802.47, 34.00),
		draw	 = 4.5,
		distance = 1.5,
		marker	 = {colour = {r = 116, g = 123, b = 240 }},
		hint = "Press [~b~E~s~] To Checkout the Job Postings",
		clothing = {
			["male"] = {
				[0] = {"prop", 58, 2, 0}, -- Hat
				[1] = {"comp", 121, 0, 2}, -- Mask
				[3] = {"comp", 0, 0, 2}, -- Torso
				[4] = {"comp", 35, 0, 2}, -- Legs
				[5] = {"comp", 23, 14, 2}, -- Bags
				[6] = {"comp", 24, 0, 2}, -- Shoes
				[8] = {"comp", 15, 0, 2}, -- Undershirt
				[11] = {"comp", 94, 2, 2}, -- Tops
			},
			["female"] = {
				[0] = {"prop", 58, 2, 2}, -- Hat
				[1] = {"comp", 121, 0, 2}, -- Mask
				[3] = {"comp", 14, 0, 2}, -- Torso
				[4] = {"comp", 34, 0, 2}, -- Legs
				[5] = {"comp", 23, 14, 2}, -- Bags
				[6] = {"comp", 24, 0, 2}, -- Shoes
				[8] = {"comp", 3, 0, 2}, -- Undershirt
				[11] = {"comp", 85, 2, 2}, -- Tops
			},
		},
	},
	["deliv_mobile3"] = { -- Canals
		header = "fooddelivery",
		prop	 = {model = "p_planning_board_01", x = -1173.58, y = -900.16, z = 12.68, h = 123.36},
		job_type = "food",
		progress = "delivery",
		job_pool = "npcdoors",
		location = vector3(-1173.58, -900.16, 14.08),
		draw	 = 4.5,
		distance = 1.5,
		marker	 = {colour = {r = 116, g = 123, b = 240 }},
		hint = "Press [~b~E~s~] To Checkout the Job Postings",
		clothing = {
			["male"] = {
				[0] = {"prop", 58, 2, 0}, -- Hat
				[1] = {"comp", 121, 0, 2}, -- Mask
				[3] = {"comp", 0, 0, 2}, -- Torso
				[4] = {"comp", 35, 0, 2}, -- Legs
				[5] = {"comp", 23, 14, 2}, -- Bags
				[6] = {"comp", 24, 0, 2}, -- Shoes
				[8] = {"comp", 15, 0, 2}, -- Undershirt
				[11] = {"comp", 94, 2, 2}, -- Tops
			},
			["female"] = {
				[0] = {"prop", 58, 2, 2}, -- Hat
				[1] = {"comp", 121, 0, 2}, -- Mask
				[3] = {"comp", 14, 0, 2}, -- Torso
				[4] = {"comp", 34, 0, 2}, -- Legs
				[5] = {"comp", 23, 14, 2}, -- Bags
				[6] = {"comp", 24, 0, 2}, -- Shoes
				[8] = {"comp", 3, 0, 2}, -- Undershirt
				[11] = {"comp", 85, 2, 2}, -- Tops
			},
		},
	},
	["deliv_fuel"] = { -- Delivery Hub
		header = "deliveryhub",
		prop	 = {model = "p_planning_board_01", x = 1018.85, y = -2515.64, z = 27.30, h = 259.66},
		job_type = "fuel",
		progress = "delivery",
		job_pool = "fuelstations",
		location = vector3(1018.85, -2515.64, 29.00),
		draw	 = 4.5,
		distance = 1.5,
		marker	 = {colour = {r = 116, g = 123, b = 240 }},
		hint = "Fuel Delivery\nPress [~b~E~s~] To Checkout the Local Job Postings\n\nCheckout Player Shop Postings\n➡",
		clothing = {
			["male"] = {
				[0] = {"prop", 60, 9, 2}, -- Hat
				[3] = {"comp", 43, 0, 2}, -- Torso
				[4] = {"comp", 89, 5, 2}, -- Legs
				[6] = {"comp", 61, 0, 2}, -- Shoes
				[8] = {"comp", 15, 0, 2}, -- Undershirt
				[11] = {"comp", 205, 0, 2}, -- Tops
			},
			["female"] = {
				[0] = {"prop", 60, 9, 2}, -- Hat
				[3] = {"comp", 141, 0, 2}, -- Torso
				[4] = {"comp", 92, 5, 2}, -- Legs
				[6] = {"comp", 86, 0, 2}, -- Shoes
				[8] = {"comp", 3, 0, 2}, -- Undershirt
				[11] = {"comp", 207, 0, 2}, -- Tops
			},
		},
	},
}

Config.Delivery.JobPool = {
	["npcdoors"] = { -- Property doors
		vector3(-1220.50, 666.95, 143.10),
		vector3(-1338.97, 606.31, 133.37),
		vector3(-1051.85, 431.66, 76.06),
		vector3(-904.04, 191.49, 68.44),
		vector3(-21.58, -23.70, 72.2),
		vector3(-904.04, 191.49, 68.44),
		vector3(225.39, -283.63, 28.25),
		vector3(5.62, -707.72, 44.97),
		vector3(284.50, -938.50, 28.35),
		vector3(411.59, -1487.54, 29.14),
		vector3(85.19, -1958.18, 20.12),
		vector3(-213.00, -1617.35, 37.35),
		vector3(-1015.65, -1515.05, 5.51),
		vector3(-1004.788, -1154.824, 1.64603),
		vector3(-1113.937, -1193.136, 1.827304),
		vector3(-1075.903, -1026.452, 4.031562),
		vector3(-1056.485, -1001.234, 1.639098),
		vector3(-1090.886, -926.188, 2.630009),
		vector3(-1075.903, -1026.452, 4.031562),
		vector3(-1181.652, -988.6455, 1.634243),
		vector3(-1151.11, -990.905, 1.638789),
		vector3(-1022.788, -896.3149, 4.908271),
		vector3(-1060.738, -826.829, 18.69866),
		vector3(-968.6487, -1329.453, 5.144861),
		vector3(-1185.5, -1386.238, 4.112149),
		vector3(-1132.848, -1456.029, 4.372081),
		vector3(-1125.602, -1544.203, 5.391256),
		vector3(-1084.74, -1558.709, 4.10145),
		vector3(-1098.367, -1679.272, 3.853804),
		vector3(-1155.863, -1574.202, 8.344403),
		vector3(-1122.675, -1557.524, 5.277201),
		vector3(-1108.679, -1527.393, 6.265457),
		vector3(-1273.549, -1382.664, 3.81341),
		vector3(-1342.454, -1234.849, 5.420023),
		vector3(-1351.21, -1128.669, 3.626104),
		vector3(-1343.232, -1043.639, 7.303696),
		vector3(-729.2556, -880.1547, 22.22747),
		vector3(-831.3006, -864.8558, 20.22383),
		vector3(-810.4093, -978.4364, 13.74061),
		vector3(-683.8874, -876.8568, 24.02004),
		vector3(-1031.316, -903.0217, 3.692086),
		vector3(-1262.703, -1123.342, 7.092357),
		vector3(-1225.079, -1208.524, 7.619214),
		vector3(-1207.095, -1263.851, 6.378308),
		vector3(-1086.787, -1278.122, 5.09411),
		vector3(-886.1298, -1232.698, 5.006698),
		vector3(-753.5927, -1512.016, 4.370816),
		vector3(-696.3545, -1386.89, 4.846177),
	},
	["parcels"] = { -- Varies between interiors of shops & just outside
		vector3(-51.95,-1761.67,28.89),
		vector3(-41.15,-1751.66,29.42),
		vector3(369.38,317.44,103.21),
		vector3(375.08,333.65,103.57),
		vector3(-702.38,-920.38,18.8),
		vector3(-705.7,-905.46,19.22),
		vector3(-1225.49,-893.3,12.13),
		vector3(-1223.77,-912.26,12.33),
		vector3(-1506.82,-383.06,40.64),
		vector3(-1482.29,-378.95,40.16),
		vector3(1149.13,-985.08,45.64),
		vector3(1131.86,-979.32,46.42),
		vector3(1157.19,-331.77,68.64),
		vector3(1163.79,-314.6,69.21),
		vector3(-1145.42,-1590.97,4.06),
		vector3(-1150.31,-1601.7,4.39),
		vector3(48.18,-992.62,29.03),
		vector3(38.41,-1005.3,29.48),
		vector3(370.05,-1036.4,28.99),
		vector3(376.7,-1028.82,29.34),
		vector3(785.95,-761.67,26.33),
		vector3(797.0,-757.31,26.89),
		vector3(41.53,-138.21,55.08),
		vector3(50.96,-135.49,55.2),
		vector3(106.8,304.21,109.81),
		vector3(90.86,298.51,110.21),
	},
	["vehsmall"] = { -- Majority curbside
		vector3(-153.19,-838.31,30.12),
		vector3(-143.85,-846.3,30.6),
		vector3(37.72,-795.71,30.93),
		vector3(44.94,-803.24,31.52),
		vector3(111.7,-809.56,30.71),
		vector3(102.19,-818.22,31.35),
		vector3(132.61,-889.41,29.71),
		vector3(121.25,-879.82,31.12),
		vector3(54.41,-994.86,28.7),
		vector3(43.89,-997.98,29.34),
		vector3(54.41,-994.86,28.7),
		vector3(57.65,-1003.72,29.36),
		vector3(142.87,-1026.78,28.67),
		vector3(135.44,-1031.19,29.35),
		vector3(248.03,-1005.49,28.61),
		vector3(254.83,-1013.25,29.27),
		vector3(275.68,-929.64,28.47),
		vector3(285.55,-937.26,29.39),
		vector3(294.29,-877.33,28.61),
		vector3(301.12,-883.47,29.28),
		vector3(247.68,-832.03,29.16),
		vector3(258.66,-830.44,29.58),
		vector3(227.21,-705.26,35.07),
		vector3(232.2,-714.55,35.78),
		vector3(241.06,-667.74,37.44),
		vector3(245.5,-677.7,37.75),
		vector3(257.05,-628.21,40.59),
		vector3(268.54,-640.44,42.02),
		vector3(211.33,-605.63,41.42),
		vector3(222.32,-596.71,43.87),
		vector3(126.27,-555.46,42.66),
		vector3(168.11,-567.17,43.87),
		vector3(254.2,-377.17,43.96),
		vector3(239.06,-409.27,47.92),
		vector3(244.49,349.05,105.46),
		vector3(252.86,357.13,105.53),
		vector3(130.77,-307.27,44.58),
		vector3(138.67,-285.45,50.45),
		vector3(54.44,-280.4,46.9),
		vector3(61.86,-260.86,52.35),
		vector3(55.15,-225.54,50.44),
		vector3(76.29,-233.15,51.4),
		vector3(44.6,-138.99,54.66),
		vector3(50.78,-136.23,55.2),
		vector3(32.51,-162.61,54.86),
		vector3(26.84,-168.84,55.54),
		vector3(-29.6,-110.84,56.51),
		vector3(-23.5,-106.74,57.04),
		vector3(-95.29,-87.53,57),
		vector3(-87.82,-83.55,57.82),
		vector3(-146.26,-71.46,53.9),
		vector3(-132.92,-69.02,55.42),
		vector3(-238.41,91.97,68.11),
		vector3(-263.61,98.88,69.3),
		vector3(-251.45,20.43,53.9),
		vector3(-273.35,28.21,54.75),
		vector3(-322.4,-10.06,47.42),
		vector3(-315.48,-3.76,48.2),
		vector3(-431.22,14.6,45.5),
		vector3(-424.83,21.74,46.27),
		vector3(-497.33,-8.38,44.33),
		vector3(-500.95,-18.65,45.13),
		vector3(-406.69,-44.87,45.13),
		vector3(-429.07,-24.12,46.23),
		vector3(-433.94,-76.33,40.93),
		vector3(-437.89,-66.91,43),
		vector3(-583.22,-154.84,37.51),
		vector3(-582.8,-146.8,38.23),
		vector3(-613.68,-213.46,36.51),
		vector3(-622.23,-210.97,37.33),
		vector3(-582.44,-322.69,34.33),
		vector3(-583.02,-330.38,34.97),
		vector3(-658.25,-329,34.2),
		vector3(-666.69,-329.06,35.2),
		vector3(-645.84,-419.67,34.1),
		vector3(-654.84,-414.21,35.45),
		vector3(-712.7,-668.08,29.81),
		vector3(-714.58,-675.37,30.63),
		vector3(-648.24,-681.53,30.61),
		vector3(-656.77,-678.12,31.46),
		vector3(-648.87,-904.3,23.8),
		vector3(-660.88,-900.72,24.61),
		vector3(-529.01,-848.03,29.26),
		vector3(-531.0,-854.04,29.79),
	},
	["vehlarge"] = { -- Usually roadside or carparking for properties
		vector3(-1395.82,-653.76,28.91),
		vector3(-1413.43,-635.47,28.67),
		vector3(164.18,-1280.21,29.38),
		vector3(136.5,-1278.69,29.36),
		vector3(75.71,164.41,104.93),
		vector3(78.55,180.44,104.63),
		vector3(-226.62,308.87,92.4),
		vector3(-229.54,293.59,92.19),
		vector3(-365.87,297.27,85.04),
		vector3(-370.5,277.98,86.42),
		vector3(-403.95,196.11,82.67),
		vector3(-395.17,208.6,83.59),
		vector3(-412.26,297.95,83.46),
		vector3(-427.08,294.19,83.23),
		vector3(-606.23,-901.52,25.39),
		vector3(-592.48,-892.76,25.93),
		vector3(-837.03,-1142.46,7.44),
		vector3(-841.89,-1127.91,6.97),
		vector3(-1061.56,-1382.19,5.44),
		vector3(-1039.38,-1396.88,5.55),
		vector3(156.41,-1651.21,29.53),
		vector3(169.11,-1633.38,29.29),
		vector3(168.13,-1470.07,29.37),
		vector3(175.78,-1461.16,29.24),
		vector3(118.99,-1486.21,29.38),
		vector3(143.54,-1481.18,29.36),
		vector3(-548.34,308.19,83.34),
		vector3(-546.6,291.46,83.02),
	},
	["fuelstations"] = { -- Fuel Station Forcourts, time in minutes
		{coords = vector3(43.7, 2776.2, 56.9), time = 25, award = 10000},
		{coords = vector3(262.9, 2611.6, 43.9), time = 23, award = 10000},
		{coords = vector3(1038.3, 2681.3, 38.4), time = 23, award = 10000},
		{coords = vector3(1210.0, 2662.4, 36.9), time = 23, award = 10000},
		{coords = vector3(2536.8, 2593.9, 37.0), time = 23, award = 10000},
		{coords = vector3(2682.3, 3262.5, 54.3), time = 26, award = 10000},
		{coords = vector3(2008.9, 3771.7, 31.2), time = 30, award = 10000},
		{coords = vector3(1698.5, 4915.1, 41.1), time = 30, award = 10000},
		{coords = vector3(1699.7, 6413.8, 31.9), time = 40, award = 10000},
		{coords = vector3(201.0, 6618.5, 30.8), time = 40, award = 10000},
		{coords = vector3(-96.4, 6421.9, 30.5), time = 40, award = 10000},
		{coords = vector3(-2554.4, 2322.8, 32.1), time = 25, award = 10000},
		{coords = vector3(-1789.4, 811.3, 137.6), time = 20, award = 10000},
		{coords = vector3(-1409.7, -277.8, 45.4), time = 20, award = 10000},
		{coords = vector3(-2092.7, -322.1, 12.0), time = 20, award = 10000},
		{coords = vector3(-728.1, -933.9, 18.1), time = 20, award = 10000},
		{coords = vector3(-523.7, -1204.0, 17.3), time = 15, award = 5000},
		{coords = vector3(-81.5, -1756.3, 28.7), time = 10, award = 5000},
		{coords = vector3(269.1, -1258.9, 28.3), time = 15, award = 5000},
		{coords = vector3(823.1, -1028.5, 25.3), time = 15, award = 5000},
		{coords = vector3(1198.2, -1391.2, 34.2), time = 10, award = 5000},
		{coords = vector3(1171.0, -316.8, 68.2), time = 10, award = 5000},
		{coords = vector3(616.8, 268.7, 102.1), time = 15, award = 5000},
		{coords = vector3(2593.6, 360.3, 107.5), time = 20, award = 10000}
	},
	["mail_palbay"] = { -- Paleto Bay Mail Man
		vector3(-291.14, 6199.27, 32.49),
		vector3(-96.43, 6324.47, 32.08),
		vector3(-390.28, 6300.23, 30.75),
		vector3(-360.8, 6320.98, 30.76),
		vector3(-303.41, 6329, 32.99),
		vector3(-215.5, 6431.99, 32.49),
		vector3(-46.21,6595.62,31.55),
		vector3(0.46, 6546.92, 32.37),
		vector3(-1.09, 6512.9, 33.04),
		vector3(99.35, 6618.56, 33.47),
		vector3(-774.31, 5597.84, 34.61),
		vector3(-696.1, 5802.36, 17.83),
		vector3(-448.77, 6009.95, 32.22),
		vector3(-326.55,6083.95,31.96),
		vector3(-341.66, 6212.46,32.59),
		vector3(-247.15,6331.02,32.93),
		vector3(-394.74,6272.52,30.94),
		vector3(35.18,6662.39,32.19),
		vector3(-130.66,6551.98,29.87),
		vector3(-106.06,6469.6,32.63),
		vector3(-94.5, 6408.86, 32.14),
		vector3(-25.2,6472.25,31.98),
		vector3(-105.28,6528.96,30.17),
		vector3(150.41,6647.58,32.11),
		vector3(161.68,6636.1,32.17),
		vector3(-9.37,6653.93,31.98),
		vector3(-40.15,6637.23,31.09),
		vector3(-5.97,6623.07,32.32),
		vector3(-113.22, 6538.18, 30.6),
	},
	["mail_sandy"] = { -- Sandy Shores Mail Man
		vector3(1986.69824, 3815.02490, 33.32370),
		vector3(1446.34997, 3649.69384, 35.48260),
		vector3(228.27, 3165.8, 43.61),
		vector3(170.36, 3113.28, 43.51),
		vector3(179.76, 3033.1, 43.98),
		vector3(1990.57141, 3057.46801, 48.06378),
		vector3(2201.01, 3318.25, 46.77),
		vector3(2368.38, 3155.96, 48.61),
		vector3(1881.07,3888.5,34.25),
		vector3(1889.76,3810.71,33.75),
		vector3(1638.8,3734.17,34.41),
		vector3(2630.27,3262.88,56.25),
		vector3(2622.43,3275.56,56.3),
		vector3(2633.7,3287.4,56.45),
		vector3(2389.48, 3341.64, 47.72),
		vector3(2393.01, 3320.62, 48.24),
		vector3(2163.38, 3374.63, 46.07),
		vector3(1959.95, 3741.99, 33.24),
		vector3(1931.55, 3727.6, 33.84),
		vector3(1850.68, 3690.03, 35.5),
		vector3(1707.92, 3585.29, 36.57),
		vector3(1756.33, 3659.54, 35.39),
		vector3(1825.41, 3718.35, 34.42),
		vector3(1899.13, 3764.68, 33.79),
		vector3(1923.37, 3797.43, 33.44),
		vector3(1914.69, 3813.37, 33.44),
		vector3(1913.61, 3868.06, 33.37),
		vector3(1942.34, 3885.42, 33.67),
		vector3(1728.66, 3851.46, 34.78),
		vector3(903.67, 3560.82, 33.81),
		vector3(910.93, 3644.29, 32.68),
		vector3(1393.15,3673.4, 34.79),
		vector3(1435.18, 3682.92, 34.84),
	},
	["mail_grapeseed"] = { -- Grade Seed Mail Man
		vector3(2563.99, 4692.7, 35.02),
		vector3(1967.33, 4640.92, 41.88),
		vector3(2030.39, 4980.46, 42.1),
		vector3(1717.86, 4676.93, 43.66),
		vector3(1689.25, 4818.3, 43.06),
		vector3(2505.48, 4095.73, 39.2),
		vector3(2570.87, 4282.84, 43.0),
		vector3(2721.19, 4285.98, 48.6),
		vector3(2727.59, 4145.46, 45.69),
		vector3(3322.6, 5166.06, 19.92),
		vector3(2216.42, 5612.49, 55.69),
		vector3(2434.51, 4976.82, 47.07),
		vector3(2300.36, 4871.94, 42.06),
		vector3(1962.36, 5184.98, 47.98),
		vector3(1698.97, 4921.18, 42.56),
		vector3(1655.87, 4874.38, 42.04),
		vector3(2159.72, 4789.8, 41.67),
		vector3(2121.77, 4784.71, 41.97),
		vector3(2639.04, 4246.56, 44.77),
		vector3(2455.85, 4058.3, 38.06),
		vector3(3680.06, 4497.93, 25.11),
		vector3(3807.8, 4478.6, 6.37),
	},
}

Config.Delivery.TankerSpawns = {
	vector4(1013.60, -2490.09, 30.15, 157.20),
	vector4(1022.94, -2492.03, 30.15, 157.20),
	vector4(1031.99, -2492.34, 30.14, 157.20),
	vector4(1043.99, -2492.34, 30.14, 157.20),
	vector4( 992.84, -2546.84, 30.14, 157.20),
	vector4( 987.38, -2546.93, 30.14, 157.20),
	vector4( 982.38, -2546.93, 30.14, 157.20),
	vector4( 977.38, -2546.93, 30.14, 157.20),
	-- Old tanker spawn DO NOT REMOVE in case we wanna move it back to the oil fields with lazy spawning later on
	-- vector4(1736.71, -1541.07, 114.36, 254.16),
	-- vector4(1738.63, -1535.69, 114.32, 254.16),
	-- vector4(1746.83, -1509.40, 114.47, 254.16),
	-- vector4(1749.10, -1498.50, 114.45, 258.52),
	-- vector4(1704.84, -1481.61, 114.56, 80.41),
	-- vector4(1713.97, -1467.62, 114.61, 81.11),
	-- vector4(1686.39, -1537.56, 114.43, 80.82),
	-- vector4(1683.71, -154.26, 114.36, 80.82),
}