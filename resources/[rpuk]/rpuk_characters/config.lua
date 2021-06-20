Config = {}

Config.StartingAccountMoney = json.encode({bank = 5000, money = 1000})

Config.JailLocationOutside = vector3(1874.6, 2525.1, 44.6)
Config.JailLocationInside = vector3(1777.8, 2568.6, 49.5)
Config.JailLocationCenter = vector3(1691.0, 2605.0, 45.5)

-- Available job spawns
Config.JobSpawns = {
	police = {
		location = vector3(476.424, -976.620, 26.984),
		armour = true,
	},
	ambulance = {
		location = vector3(314.362, -549.271, 27.743),
		armour = true,
	},
	lost = {
		location = vector3(960.82, -107.74, 73.36),
		armour = false
	},
	gruppe6 = {
		location = vector3(25.713, -903.380, 28.982),
		armor = true
	}
}

-- All these spawn locations are located at the famous motel
-- Requires you to have the proper map resources loaded or you'll be teleporting to an empty area
Config.AvailableSpawnLocations = {
	vector3(345.1, -213.7, 58.0),
	vector3(345.1, -213.7, 54.2),
	vector3(341.2, -223.8, 54.2),
	vector3(341.2, -223.8, 58.0)
}

Config.PedSpawns = {
	{spawn = vector3(-545.5, -1288.0, 25.9), handle = nil},
	{spawn = vector3(-545.1, -1287.0, 25.9), handle = nil},
	{spawn = vector3(-544.7, -1286.0, 25.9), handle = nil},
	{spawn = vector3(-544.3, -1285.1, 25.9), handle = nil},
}