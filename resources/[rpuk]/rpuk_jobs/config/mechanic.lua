Config.Mechanic = {}

-- garages and impound areas are handled by rpuk_garages

Config.Mechanic.locations = {
	["innocence_impound"] = {
		header = "mechanic",
		name = "~y~Highways Los Santos~s~\nMechanic and Highways Job",
		access = {location = vector3(374.069, -1608.8, 28.292), marker = {type = 1, size = vector3(1.5, 1.5, 0.5)}},
		rent_spawnpoints = {
			vector4(394.64, -1625.82, 29.52, 49.18),
			vector4(385.85, -1634.01, 29.52, 320.08),
			vector4(391.09, -1610.49, 29.52, 229.27),
		},
	},
}

Config.Mechanic.npc_vehicles = {
	'coquette3',
	'chino',
	'felon2',
	'panto',
	'issi2',
}

Config.Mechanic.npc_locations = {
	vector3(-2480.9, -212.0, 17.4), -- esx locations start
	vector3(-2723.4, 13.2, 15.1),
	vector3(-3169.6, 976.2, 15.0),
	vector3(-3139.8, 1078.7, 20.2),
	vector3(-1656.9, -246.2, 54.5),
	vector3(-1586.7, -647.6, 29.4),
	vector3(-1036.1, -491.1, 36.2),
	vector3(-1029.2, -475.5, 36.4),
	vector3(75.2, 164.9, 104.7),
	vector3(-534.6, -756.7, 31.6),
	vector3(487.2, -30.8, 88.9),
	vector3(-772.2, -1281.8, 4.6),
	vector3(-663.8, -1207.0, 10.2),
	vector3(719.1, -767.8, 24.9),
	vector3(-971.0, -2410.4, 13.3),
	vector3(-1067.5, -2571.4, 13.2),
	vector3(-619.2, -2207.3, 5.6),
	vector3(1192.1, -1336.9, 35.1),
	vector3(-432.8, -2166.1, 9.9),
	vector3(-451.8, -2269.3, 7.2),
	vector3(939.3, -2197.5, 30.5),
	vector3(-556.1, -1794.7, 22.0),
	vector3(591.7, -2628.2, 5.6),
	vector3(1654.5, -2535.8, 74.5),
	vector3(1642.6, -2413.3, 93.1),
	vector3(1371.3, -2549.5, 47.6),
	vector3(383.8, -1652.9, 37.3),
	vector3(27.2, -1030.9, 29.4),
	vector3(229.3, -365.9, 43.8),
	vector3(-85.8, -51.7, 61.1),
	vector3(-4.6, -670.3, 31.9),
	vector3(-111.9, 92.0, 71.1),
	vector3(-314.3, -698.2, 32.5),
	vector3(-366.9, 115.5, 65.6),
	vector3(-592.1, 138.2, 60.1),
	vector3(-1613.9, 18.8, 61.8),
	vector3(-1709.8, 55.1, 65.7),
	vector3(-521.9, -266.8, 34.9),
	vector3(-451.1, -333.5, 34.0),
	vector3(322.4, -1900.5, 25.8), -- esx locations end
	vector3(-1395.82,-653.76,28.91), -- rpuk deliveries large start
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
	vector3(-546.6,291.46,83.02), -- rpuk deliveries large end
}