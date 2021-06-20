Config.Hunting = {}

Config.Hunting.payType = "money"

Config.Hunting.NPCs = {
	["models"] = {
		{
			model = "s_f_y_ranger_01", location = vector4(382.52, 799.49, 186.68, 101.14),
			text = "[~g~E~s~] To Talk",
			spawned = false, godmode = true, interation = "speech", extra = "introduction"
		},
		{
			model = "s_m_y_ranger_01", location = vector4(385.56, 794.23, 189.49, 324.22),
			text = "[~g~E~s~] To Talk\n[~g~H~s~] To Clock In/Out\n[~g~Q~s~] To Equip Uniform",
			anim = {"WORLD_HUMAN_CLIPBOARD"}, spawned = false, godmode = true, interation = "job", extra = "introduction"
		},
		{
			model = "s_m_y_ranger_01", location = vector4(376.57, 792.56, 186.62, 109.76),
			text = "[~g~E~s~] To Rent a Ranger Vehicle",
			spawned = false, godmode = true, interation = "speech", extra = "vehicle_rental"
		},
		{
			model = "s_m_y_ranger_01", location = vector4(385.98, 799.99, 186.68, 181.98),
			text = "[~g~E~s~] Open ranger shop",
			spawned = false, godmode = true, weapon = "weapon_musket", interation = "armorer", extra = "weapon_musket"
		},
		{
			model = "a_c_husky", location = vector4(379.364, 796.381, 189.492, 201.48),
			anim = {"creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel"}, spawned = false, godmode = true
		},
	},
	speech_lines = {
		["introduction"] = {
			"Welcome to the National Park Rangers Station. I'm one of the rangers, we were introduced in 1864 to monitor and preserve the beautiful wilderness of San Andreas.",
			"Throughout your time with us here, you can begin to understand and contribute to our goal! Of course we will pay you for your services.",
			"Some tasks you can do with us are, tracking, photography, monitor/reporting, and culling of pesky wildlife.",
			"To get started you can speak to Ranger Rob upstairs in the office!",
		},
		["vehicle_rental"] = {
			"Here take the keys to the Ranger vehicle. It doesn't excempt you from any laws, but it has some useful equipment.",
		},
	}
}

Config.Hunting.Hunts = {
	item_costs = {
		["weapon_musket"] = 10000,
		["armor"] = 1000,
		["binoculars"] = 500,
	},
	animals = {
		{"a_c_boar", "Boar"},
		{"a_c_mtlion", "Mountain Lion"},
		{"a_c_rabbit_01", "Rabbit"},
		{"a_c_coyote", "Coyote"},
		{"a_c_deer", "Deer"},
	},
	job_types = {
		culling = { -- Culling job move to the marked place shoot then get rid of the body
			text = "",
			points = {
				vector3(-1798.5659179688, 1163.9, 201.82919311523),
				vector3(-2247.0378417969, 951.36, 217.95301818848),
				vector3(-2424.1154785156, 1486.1, 276.38433837891),
				vector3(-2129.3137207031, 1803.4, 233.64878845215),
				vector3(-1813.2553710938, 1653.1, 221.35665893555),
				vector3(-1142.4792480469, 1490.3, 209.83723449707),
				vector3(-675.05895996094, 2064.1, 126.22150421143),
				vector3(-1466.0067138672, 4447.8, 17.563125610352),
				vector3(-1472.0434570313, 4528., 55.446990966797),
				vector3(-1509.0023193359, 4609.1, 37.944675445557),
				vector3(-1518.9091796875, 4674.8, 35.230602264404),
				vector3(-1533.2272949219, 4729.5, 51.536064147949),
				vector3(-1352.0098876953, 4889.1, 126.71502685547),
				vector3(-1181.2062988281, 4892.3, 211.21878051758),
				vector3(-1258.0661621094, 4677.8, 87.707733154297),
				vector3(-1528.3731689453, 4418.3, 10.521329879761),
				vector3(-1707.3939208984, 4327.8, 59.772361755371),
				vector3(-1878.8364257813, 4460.5, 32.087898254395),
				vector3(-1969.1525878906, 4542.8, 10.136251449585),
				vector3(-1637.5855712891, 4593.5, 42.581684112549),
				vector3(-1665.7088623047, 4877.8, 58.751815795898),
				vector3(-1216.5206298828, 5155.8, 105.62386322021),
				vector3(-960.83557128906, 5226.5, 107.9133605957),
				vector3(-666.91345214844, 5291.14, 70.164016723633),
			},
		},
		photo = { -- Photo taking job, move around the park taking photos of areas - getting a photo item and being able to trade that for payout
			text = "",
			points = {
				vector3(-1434.027, 4401.711, 45.092),
				vector3(-442.475, 4007.004, 79.379),
				vector3(-389.711, 4383.246, 53.102),
				vector3(-456.857, 5661.057, 68.235),
				vector3(501.785, 5604.251, 796.915),
				vector3(-959.812, 4843.826, 310.760),
				vector3(-1369.405, 4787.142, 128.870),
				vector3(-1691.884, 4597.416, 46.899),
				vector3(-1373.379, 4306.363, 0.882),
				vector3(-929.339, 4531.765, 114.862),
				vector3(-426.900, 1597.393, 355.097),
				vector3(-1587.326, 2098.526, 67.588),
			},
		},
		driving = { -- Driving or patrol, drive between checkpoints, radioing if anything is happening - payout at each checkpoint
			text = "",
			points = {
				vector3(0,0,0),
				vector3(0,0,0),
				vector3(0,0,0),
				vector3(0,0,0),
				vector3(0,0,0),
				vector3(0,0,0),
				vector3(0,0,0),
			},
		}
	},
}

Config.Hunting.shop = {
	WEAPON_MUSKET = {
		rank = 2,
		type = "item_weapon",
		price = 10000
	},
	musket = {
		rank = 2,
		type = "item_ammo",
		price = 25
	},
	armor = {
		rank = 2,
		type = "item_standard",
		price = 1000
	},
	binoculars = {
		rank = 2,
		type = "item_standard",
		price = 500
	}
}