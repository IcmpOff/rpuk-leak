config = {}
-- death squad blips - 378
-- crate blips - 501

config = {
	blips = {
		["crate"] = {icon = 501, colour = 1, radius = 10, text = "Loot Crate"},
		["squad"] = {icon = 378, colour = 1, radius = 10, text = "Death Squad"},
	},-- end blips
	crates = {	
		{
			entity = nil,
			searched = false,
			location = vector4(189.70, -929.75, 30.69, 232.11),
			model = "bkr_prop_crate_set_01a",
			pools = {"t0", "t1", "t2","t3"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(231.21, -884.98, 30.50, 158.48),
			model = "bkr_prop_crate_set_01a",
			pools = {"t0", "t1", "t2"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(1.62, -1057.74, 38.15, 158.48),
			model = "bkr_prop_crate_set_01a",
			pools = {"t0", "t1", "t2", "t3", "t4"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(-1102.46, -836.19, 37.70, 158.48),
			model = "ex_prop_crate_ammo_sc",
			pools = {"t0","t2", "t3", "t4"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(-589.03, -922.98, 36.83, 158.48),
			model = "ex_prop_crate_ammo_sc",
			pools = {"t0","t2", "t3", "t4"}
		},		
		{
			entity = nil,
			searched = false,
			location = vector4(1849.48, 3665.46, 34.12, 158.48),
			model = "bkr_prop_crate_set_01a",
			pools = {"t0","t1", "t2", "t3"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(930.22, 3538.60, 34.05, 158.48),
			model = "ex_prop_crate_ammo_sc",
			pools = {"t0","t1", "t2", "t3"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(774.13, 2260.43, 48.96, 158.48),
			model = "ex_prop_crate_highend_pharma_bc",
			pools = {"t0","drug1"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(615.15, 95.59, 92.35, 158.48),
			model = "ex_prop_crate_jewels_sc",
			pools = {"t0","rare"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(74.20, -166.98, 55.12, 158.48),
			model = "ex_prop_crate_elec_sc",
			pools = {"elec"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(100.11, -1937.10, 20.80, 158.48),
			model = "ex_prop_crate_ammo_sc",
			pools = {"t0","t1", "t2", "elec"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(623.75, 616.46, 128.91, 158.48),
			model = "bkr_prop_crate_set_01a",
			pools = {"t0","t1", "t2", "elec"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(-1180.05, 43.87, 52.48, 0.46),
			model = "ex_prop_crate_ammo_sc",
			pools = {"t0","t2", "t3", "t4"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(-2149.63, 3084.37, 32.81, 0.46),
			model = "ex_prop_crate_ammo_sc",
			pools = {"t0","t2", "t3", "t4"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(-2298.22, 203.20, 167.60, 158.48),
			model = "ex_prop_crate_highend_pharma_bc",
			pools = {"t0","drug1"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(1191.69, -1541.97, 39.40, 0.46),
			model = "ex_prop_crate_ammo_sc",
			pools = {"t0","t2", "t3", "t4"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(-414.87, 1097.13, 332.53, 158.48),
			model = "bkr_prop_crate_set_01a",
			pools = {"t0", "t1", "t2"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(373.03, 789.55, 187.18, 158.48),
			model = "bkr_prop_crate_set_01a",
			pools = {"t0", "t1", "t2"}
		},		
		{
			entity = nil,
			searched = false,
			location = vector4(739.26, 1205.66, 326.65, 158.48),
			model = "bkr_prop_crate_set_01a",
			pools = {"t0", "t1", "t3"}
		},
		{
			entity = nil,
			searched = false,
			location = vector4(496.46, -3355.07, 6.07, 158.48),
			model = "ex_prop_crate_ammo_sc",
			pools = {"t0", "t1", "t3"}
		}
	},-- end crate locations
	crate_pools = {
		["t0"] = {
			chance = 100,
			contents = {
				"bandage",
				"weapon_knife",
				"apple",
				"weapon_crowbar",
				"weapon_vintagepistol",				
			}
		},
		["t1"] = {
			chance = 75,
			contents = {
				"halloween_token",
				"weapon_pistol",
				"diamond",
				"casino_playtoken",
				"weapon_sawnoffshotgun",
			}
		},
		["t2"] = {
			chance = 50,
			contents = {
				"weapon_pumpshotgun",
				"ziptie",
				"lockpick",
				"repairkit",
				"weapon_flashlight",
			}
		},
		["t3"] = {
			chance = 25,
			contents = {
				"weapon_molotov",
				"halloween_token",
				"weapon_pistol50",
			}
		},
		["t4"] = {
			chance = 5,
			contents = {
				"armor",
				"c4",
				"weapon_sniperrifle",
			}
		},
		["drug1"] = {
			chance = 75,
			contents = {
				"cocaine",
				"cocaine",
				"cannabis",
				"cannabis",
				"meth",
				"taco",
			}
		},
		["rare"] = {
			chance = 75,
			contents = {
				"diamond",
				"diamond",
				"diamond",
				"diamond",
				"gold",
				"iron",
				"gold",
			}
		},
		["elec"] = {
			chance = 100,
			contents = {
				"hifi",
				"radio",
				"phone",
				"usb",
				"drill",
			}
		},
	}, -- end crate pools
	npc_pools = {
		locations = {
			vector3(111.255, -397.475, 40.265),
			vector3(169.132, -1072.508, 28.194),
			vector3(-99.468, -1019.621, 26.274),
			vector3(-23.300, -1302.016, 28.170),
			vector3(-49.161, -1756.999, 28.421),
			vector3(126.425, -1993.398, 17.360),
			vector3(478.485, -1889.845, 25.095),
			vector3(160.446, -1898.398, 21.957),
			vector3(150.650, -1307.579, 28.202),
			vector3(366.489, -768.913, 28.284),
			vector3(317.915, -611.145, 30.446),
			vector3(-344.306, -745.044, 32.970),
			vector3(-172.442, -638.259, 31.424),
			vector3(-16.349, -686.354, 31.338),
			vector3(469.483, -231.514, 52.793),
			vector3(617.435, 198.939, 97.413),
			vector3(369.345, 343.759, 102.100),
			vector3(-421.107, 265.468, 82.196),
			vector3(-555.383, 284.059, 81.176),
			vector3(-541.398, -211.185, 36.650),
			vector3(-556.176, -184.552, 41.700),
			vector3(-1092.547, -888.875, 2.592),
			vector3(-1140.802, -1067.475, 1.150),
			vector3(-706.235, -909.846, 18.216),
			vector3(-670.676, 1207.151, 9.612),
			vector3(-467.613, -906.623, 37.689),
			vector3(204.393, -891.004, 30.498),
			vector3(234.470, -753.038, 29.826),
			vector3(298.545, -561.745, 42.318),
			vector3(949.431, -111.945, 73.353), -- lost mc
		},
		attributes = {
			Health = 500,
			Movement = 3,
			Range = 2,
			Ability = 100,
			Accuracy = 80,
			Pattern = "FIRING_PATTERN_FULL_AUTO",
		},
		loadouts = {
			["s_m_y_clown_01"] = {"weapon_microsmg", "weapon_pumpshotgun"},
		
		}		
	},-- end npc pools
	props = {
		{model = "apa_mp_apa_crashed_usaf_01a", location = vector3(-705.58, -1236.90, 9.60), rotation = vector3(-12, -12, 0.59), entity = nil},
		{model = "prop_container_01a", location = vector3(-695.00, -1247.34, 10.52), rotation = vector3(0, 0, 0.79), entity = nil},
		{model = "prop_sec_barier_01a", location = vector3(-754.76, -1300.89, 5.0), rotation = vector3(0, 0, 220.79), entity = nil},
		{model = -105439435, location = vector3(-748.51, -1297.75, 5.15), rotation = vector3(0, 0, 40.79), entity = nil},

		{model = "prop_gazebo_03", location = vector3(-742.00, -1299.07, 5.15), rotation = vector3(0, 0, 40.79), entity = nil},
		{model = "prop_gazebo_03", location = vector3(-738.81, -1303.07, 5.15), rotation = vector3(0, 0, 40.79), entity = nil},

		{model = "prop_skid_tent_cloth", location = vector3(-732.997, -1303.247, 4.050), rotation = vector3(0, 0, 40.79), entity = nil},
		{model = "prop_skid_tent_cloth", location = vector3(-731.072, -1301.541, 4.050), rotation = vector3(0, 0, 40.79), entity = nil},
		{model = "prop_skid_tent_cloth", location = vector3(-729.402, -1299.863, 4.050), rotation = vector3(0, 0, 40.79), entity = nil},
		{model = "prop_skid_tent_cloth", location = vector3(-731.341, -1298.004, 4.050), rotation = vector3(0, 0, 40.79), entity = nil},

		{model = "sm_prop_smug_crate_m_medical", location = vector3(-733.47497558594,-1299.4506835938, 4.0502443313599), rotation = vector3(0, 0, 230.79), entity = nil},
		
		{model = "hei_prop_carrier_cargo_04c", location = vector3(-739.04888916016, -1293.3780517578, 4.0003805160522), rotation = vector3(0, 0, 0.79), entity = nil},
		{model = "hei_prop_carrier_cargo_05b", location = vector3(-735.44024658203, -1290.5568847656, 4.1517868041992), rotation = vector3(0, 0, 230.79), entity = nil},
		{model = "hei_prop_carrier_cargo_04b_s", location = vector3(-732.818359375, -1288.6021728516, 4.1019225120544), rotation = vector3(0, 0, 90.79), entity = nil},
		
		{model = "prop_air_generator_03", location = vector3(-743.74713134766, -1313.3338623047, 4.0003800392151), rotation = vector3(0, 0, 140.79), entity = nil},
		
		{model = "prop_air_lights_05a", location = vector3(-748.62609863281, -1293.7495117188, 5.7697882652283), rotation = vector3(0, 0, 140.79), entity = nil},
		{model = "prop_air_lights_05a", location = vector3(-739.92803955078, -1289.0090332031, 6.2095856666565), rotation = vector3(0, 0, 140.79), entity = nil},
		{model = "prop_air_lights_05a", location = vector3(-732.17388916016, -1284.3094482422, 7.0476131439209), rotation = vector3(0, 0, 140.79), entity = nil},
		{model = "prop_air_lights_05a", location = vector3(-725.31555175781, -1278.4884033203, 7.8586058616638), rotation = vector3(0, 0, 140.79), entity = nil},
		{model = "prop_air_lights_05a", location = vector3(-719.72039794922, -1271.4442138672, 8.6883058547974), rotation = vector3(0, 0, 140.79), entity = nil},

		{model = "prop_air_lights_04a", location = vector3(-747.42010498047, -1301.6051025391, 7.0644607543945), rotation = vector3(0, 0, 0.79), entity = nil},
		{model = "prop_air_lights_04a", location = vector3(-698.61267089844, -1250.3037109375, 11.321947097778), rotation = vector3(0, 0, 180.79), entity = nil},

		{model = "prop_air_conelight", location = vector3(-709.64599609375, -1246.3137207031, 9.03), rotation = vector3(0, 0, 130.79), entity = nil, sink = true},

		{model = "v_med_trolley", location = vector3(-737.50061035156, -1304.6785888672, 4.0003800392151), rotation = vector3(0, 0, 225.79), entity = nil, sink = true},
	
		{model = "hei_prop_carrier_cargo_05b", location = vector3(-762.69384765625, -1308.4323730469, 4.1502752304077), rotation = vector3(0, 0, 230.79), entity = nil},
		{model = "hei_prop_carrier_cargo_05b", location = vector3(-759.56634521484, -1309.1322021484, 4.1502757072449), rotation = vector3(0, 0, 230.79), entity = nil},
		
		{model = "prop_air_lights_02b", location = vector3(242.77980041504, -879.70751953125, 30.422428131104), rotation = vector3(0, 0, 230.79), entity = nil, sink = true},
		{model = "prop_air_lights_02b", location = vector3(238.9358215332, -878.31469726563, 30.402545928955), rotation = vector3(0, 0, 230.79), entity = nil, sink = true},
		{model = "prop_air_lights_02b", location = vector3(228.68756103516, -874.6005859375, 30.422428131104), rotation = vector3(0, 0, 230.79), entity = nil, sink = true},
		{model = "prop_air_lights_02b", location = vector3(224.87091064453, -873.41052246094, 30.402545928955), rotation = vector3(0, 0, 230.79), entity = nil, sink = true},

		{model = "prop_air_lights_02b", location = vector3(226.41625976563, -874.83648681641, 30.515775680542), rotation = vector3(0, 0, 230.79), entity = nil, sink = true},
		{model = "prop_air_lights_02b", location = vector3(236.15744018555, -897.52202148438, 33.092016601563), rotation = vector3(0, 0, 230.79), entity = nil, sink = true},
		{model = "prop_air_lights_02b", location = vector3(210.34397277832, -891.3025, 34.512841033936), rotation = vector3(0, 0, 230.79), entity = nil, sink = true},
		{model = "prop_air_lights_02b", location = vector3(265.17031860352, -736.53444824219, 41.577724456787), rotation = vector3(0, 0, 230.79), entity = nil, sink = true},
		{model = "prop_air_lights_02b", location = vector3(240.81086730957, -727.56726074219, 40.663604736328), rotation = vector3(0, 0, 230.79), entity = nil, sink = true},
		
		{model = "prop_air_lights_02b", location = vector3(215.06674194336, -918.77490234375, 52.717247009277), rotation = vector3(0, 0, 140.79), entity = nil},
	}
} -- end config




