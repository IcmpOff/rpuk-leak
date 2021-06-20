local additional_objects = {
	{prop = "prop_crashed_heli", location = vector3(587.22, 3121.28, 39.20), rotation = vector3(0.0, 0.0, -90.0), collision = true}, -- Ammo heli crash
	{prop = "ex_prop_exec_crashedp", location = vector3(590.98, 3118.34, 39.20), rotation = vector3(90.0, 100.0, -90.0), collision = true}, -- Ammo plane crash
	{prop = 37760292, location = vector3(297.77, -585.30, 42.24), rotation = vector3(0.0, 0.0, 0.0), collision = true}, -- pillbox temporary bollard
	{prop = 37760292, location = vector3(298.31, -583.62, 42.24), rotation = vector3(0.0, 0.0, 0.0), collision = true}, -- pillbox temporary bollard
	{prop = "prop_atm_01", location = vector3(1131.59, -980.91, 45.46), rotation = vector3(0.0, 0.0, -80.0), collision = true}, -- Noble Stores ATM
	{prop = "prop_temp_block_blocker", location = vector3(1526.80, 3783.21, 33.50), rotation = vector3(0.0, 0.0, 35.0), collision = true}, -- Sandy Door Collision
	{prop = "prop_watercooler", location = vector3(1778.93, 2567.33, 44.80), rotation = vector3(0.0, 0.0, 180.0), collision = true}, -- Prison Water
	{prop = "prop_atm_01", location = vector3(1778.27, 2567.17, 44.84), rotation = vector3(0.0, 0.0, 180.0), collision = true}, -- Prison ATM
	{prop = "prop_vend_snak_01", location = vector3(1779.81, 2567.52, 44.85), rotation = vector3(0.0, 0.0, 180.0), collision = true}, -- Prison Vending

	{prop = "prop_atm_01", location = vector3(904.65, -1804.63, 23.80), rotation = vector3(0.0, 0.0, 318.0), collision = true}, -- LostMC Fightclub	ATM 1
	{prop = "bkr_prop_coke_table01a", location = vector3(904.17, -1814.62, 23.97), rotation = vector3(0.0, 0.0, 330.82), collision = true}, -- LostMC Fightclub
	{prop = -741944541, location = vector3(922.74, -1820.32, 23.88), rotation = vector3(0.0, 0.0, 236.65), collision = true}, -- LostMC Fightclub Extra Chairs
	{prop = -741944541, location = vector3(922.27, -1821.0, 23.88), rotation = vector3(0.0, 0.0, 236.65), collision = true}, -- LostMC Fightclub Extra Chairs

	{prop = "prop_atm_02", location = vector3(123.16, -626.01, 205.60), rotation = vector3(0.0, 0.0, -110.0), collision = true}, -- Admin offices ATM
	{prop = "v_res_tre_wardrobe", location = vector3(147.53, -634.64, 205.05), rotation = vector3(0.0, 0.0, 70.0), collision = true}, -- Admin Wardrobe	

	{prop = "prop_atm_01", location = vector3(1100.49, 206.30, -50.45), rotation = vector3(0.0, 0.0, 155.08), collision = true}, -- Casino Main ATM
	{prop = "prop_atm_01", location = vector3(1152.79, 255.94, -52.45), rotation = vector3(0.0, 0.0, 265.04), collision = true}, -- Casino Floor ATM

	{prop = "prop_tv_flat_01", location = vector3(925.30, -1817.23, 25.59), rotation = vector3(0.0, 0.0, 235.30), collision = true}, -- Fightclub
	{prop = "prop_tv_flat_01", location = vector3(915.84, -1828.14, 25.59), rotation = vector3(0.0, 0.0, 139.0), collision = true}, -- Fightclub

	{prop = "prop_ld_int_safe_01", location = vector3(258.99325561523, 204.23419189453, 109.28777313232), rotation = vector3(0.0, 0.0, 70.0), collision = true}, -- Bank
	{prop = "prop_ld_int_safe_01", location = vector3(266.4, 214.2, 109.2876739502), rotation = vector3(0.0, 0.0, 250.0), collision = true}, -- Bank

	{prop = "prop_cons_ply02", location = vector3(1775.240, 2556.168, 44.591), rotation = vector3(0.0, 0.0, 0.0), collision = true}, -- Prison
	{prop = "prop_cactus_01e", location = vector3(1775.044, 2546.885, 44.591), rotation = vector3(0.0, 0.0, 0.0), collision = true}, -- Prison

	{prop = "prop_gas_pump_old2", location = vector3(-1139.43, -2868.42, 12.95), rotation = vector3(0.0, 0.0, 240.91), collision = true}, -- Airport gas pump
	{prop = "prop_gas_pump_old2", location = vector3(-1172.52, -2849.44, 12.95), rotation = vector3(0.0, 0.0, 240.91), collision = true}, -- Airport gas pump
	{prop = "prop_gas_pump_old2", location = vector3(-1106.59, -2887.34, 12.95), rotation = vector3(0.0, 0.0, 240.91), collision = true}, -- Airport gas pump

	{prop = "prop_gas_pump_old2", location = vector3(-999.79, -3011.42, 12.95), rotation = vector3(0.0, 0.0, 150.73), collision = true}, -- Airport hangar pump

	{prop = -11849332, location = vector3(-593.762, -928.222, 24.078), rotation = vector3(0.0, 0.0, 150.73), collision = true}, -- Weazel Gnomes	
	
	{prop = "prop_fnccorgm_02e", location = vector3(-1135.35, 4947.59, 221.39), rotation = vector3(-7.0, 0.0, 68.48), collision = false, onfloor = false}, -- Lost
	{prop = "prop_fnccorgm_02e", location = vector3(-1148.79, 4905.74, 219.70), rotation = vector3(-7.0, 0.0, 127.92), collision = false, onfloor = false}, -- Lost

	{prop = "prop_ld_int_safe_01", location = vector3(1.37, -1818.39, 29.02), rotation = vector3(0.0, 0.0, 230.70), collision = true, onfloor = false}, -- Grove St Stash
	{prop = 1270590574, location = vector3(1394.52, 3601.35, 37.941), rotation = vector3(0.0, 0.0, 230.70), collision = true, onfloor = true}, -- Gas Tank Sandy Shop
	{prop = "bkr_prop_meth_table01a", location = vector3(1387.51, 3608.61, 37.94), rotation = vector3(0.0, 0.0, 23.31), collision = true, onfloor = true}, -- Gas Tank Sandy Shop
	{prop = "bkr_prop_meth_table01a", location = vector3(2436.72, 4967.58, 41.35), rotation = vector3(0.0, 0.0, 302.10), collision = true, onfloor = true}, -- Grannies basement
	{prop = "bkr_prop_meth_table01a", location = vector3(-6.68, -1821.72, 28.54), rotation = vector3(0.0, 0.0, 322.39), collision = true, onfloor = true}, -- Grove Shop Meth 1
	{prop = "bkr_prop_weed_table_01b", location = vector3(-9.03, -1822.01, 28.54), rotation = vector3(0.0, 0.0, 55.36), collision = true, onfloor = true}, -- Grove Shop Meth 2
	{prop = -2059889071, location = vector3(-8.41, -1826.77, 28.74), rotation = vector3(0.0, 0.0, 123.91), collision = true, onfloor = true}, -- Grove Shop Meth 3
	{prop = "bkr_prop_meth_smashedtray_01", location = vector3(-8.5655431747437, -1821.3729248047, 29.381837844849), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = true}, -- Grove Shop Meth 4
	{prop = "v_res_pestle", location = vector3(-9.0342330932617, -1821.4572753906, 29.381837844849), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = true}, -- Grove Shop Meth 4
	{prop = "prop_drug_burner", location = vector3(-9.2636251449585, -1822.8253173828, 29.381837844849), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = true}, -- Grove Shop Meth 4
	{prop = "prop_drug_burner", location = vector3(-8.9742755889893, -1822.4035644531, 29.381837844849), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = true}, -- Grove Shop Meth 4
	{prop = "prop_drug_package_02", location = vector3(-9.4266519546509, -1822.158203125, 29.381837844849), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = true}, -- Grove Shop Meth 4

	{prop = "prop_drug_burner", location = vector3(1983.805, -2611.517, 3.415), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = true}, -- Cocaine Boat
	{prop = "apa_p_apdlc_treadmill_s", location = vector3(-56.30, -1286.05, 28.23), rotation = vector3(0.0, 0.0, 270.09), collision = true, onfloor = false}, -- LS Gym Treadmill
	{prop = "apa_p_apdlc_treadmill_s", location = vector3(-56.18, -1279.12, 28.23), rotation = vector3(0.0, 0.0, 264.29), collision = true, onfloor = false}, -- LS Gym Treadmill
	{prop = "bkr_prop_weed_table_01b", location = vector3(2332.07, 2571.93, 45.68), rotation = vector3(0.0, 0.0, 246.95), collision = true, onfloor = false}, -- LSD Table
	{prop = "prop_drug_burner", location = vector3(2332.108, 2572.707, 46.519), rotation = vector3(0.0, 0.0, 246.95), collision = true, onfloor = false}, -- LSD Table
	{prop = "prop_drug_erlenmeyer", location = vector3(2331.908, 2572.181, 46.519), rotation = vector3(0.0, 0.0, 246.95), collision = true, onfloor = false}, -- LSD Table
	{prop = "prop_drug_bottle", location = vector3(2331.698, 2571.675, 46.519), rotation = vector3(0.0, 0.0, 246.95), collision = true, onfloor = false}, -- LSD Table
	{prop = "prop_drug_bottle", location = vector3(2331.700, 2571.377, 46.519), rotation = vector3(0.0, 0.0, 246.95), collision = true, onfloor = false}, -- LSD Table

	{prop = "misc_jetty1", location = vector3(1498.917, -2775.969, 0.3), rotation = vector3(0, 0, 180.0), collision = true, onfloor = false},
	{prop = "prop_meth_setup_01", location = vector3(1323.77, -1657.77, 43.45), rotation = vector3(0, 0, 0.0), collision = true, onfloor = true},

	{prop = "bkr_prop_meth_table01a", location = vector3(-717.65, -858.36, 22.21), rotation = vector3(0, 0, 261.52), collision = true, onfloor = true},
	{prop = "bkr_prop_meth_table01a", location = vector3(-718.27, -862.37, 22.21), rotation = vector3(0, 0, 179.66), collision = true, onfloor = true},
	{prop = "prop_meth_setup_01", location = vector3(-717.42, -860.79, 22.41), rotation = vector3(0, 0, 90.03), collision = true, onfloor = true},

	{prop = "bkr_prop_meth_table01a", location = vector3(1326.76, -1656.09, 43.25), rotation = vector3(0, 0, 217.24), collision = true, onfloor = true},
	{prop = "bkr_prop_meth_table01a", location = vector3(1325.22, -1657.99, 43.25), rotation = vector3(0, 0, 217.24), collision = true, onfloor = true},

	{prop = "bkr_prop_meth_table01a", location = vector3(1325.22, -1657.99, 43.25), rotation = vector3(0, 0, 217.24), collision = true, onfloor = true},
	{prop = "bkr_prop_meth_table01a", location = vector3(1325.22, -1657.99, 43.25), rotation = vector3(0, 0, 217.24), collision = true, onfloor = true},

	{prop = "gr_prop_gr_bench_01a", location = vector3(990.97, -112.80, 73.08), rotation = vector3(0, 0, 60.92), collision = true, onfloor = false},
	{prop = "gr_prop_gr_bench_01a", location = vector3(995.45, -115.55, 73.08), rotation = vector3(0, 0, 237.38), collision = true, onfloor = false},
	{prop = "gr_prop_gr_bench_02a", location = vector3(995.33, -110.66, 73.08), rotation = vector3(0, 0, 327.68), collision = true, onfloor = false},
	{prop = "gr_prop_gr_crates_weapon_mix_01a", location = vector3(993.08, -110.04, 73.08), rotation = vector3(0, 0, 8.89), collision = true, onfloor = false},
	{prop = "bkr_prop_biker_barstool_03", location = vector3(994.82, -111.43, 73.08), rotation = vector3(0, 0, 337.18), collision = true, onfloor = false},

	{prop = "motopatoche", location = vector3(954.808, -117.518, 78.495), rotation = vector3(0, -3.0, 60.18), collision = true, onfloor = false},
	{prop = "gr_prop_gr_bench_02a", location = vector3(2145.83, 4774.10, 40.03), rotation = vector3(0, 0.0, 204.73), collision = true, onfloor = false},
	{prop = "gr_prop_gr_bench_02a", location = vector3(245.01, 3111.50, 41.49), rotation = vector3(0, 0.0, 185.45), collision = true, onfloor = false},
	{prop = "gr_prop_gr_bench_02a", location = vector3(-2219.98, -365.47, 12.36), rotation = vector3(0, 0.0, 345.64), collision = true, onfloor = false},

	{prop = 1433474877, location = vector3(-28.224, -1406.39, 27.9), rotation = vector3(90.0, 0.0, 90.0), collision = true, onfloor = false}, -- ballas carwash bar
	{prop = 1433474877, location = vector3(-26.270, -1406.39, 27.9), rotation = vector3(90.0, 0.0, 90.0), collision = true, onfloor = false}, -- ballas carwash bar

	-- housing development --	
	--[[
	{prop = "white_shell", 		location = vector3(1775.6563720703, 3269.2807617188, 40.721145629883), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_apartment1", location = vector3(1740.0817871094, 3249.037109375, 40.463928222656), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_apartment2", location = vector3(1703.4270019531, 3256.7270507813, 40.009155273438), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_apartment3", location = vector3(1686.3088378906, 3246.4245605469, 39.831470489502), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_lester", 	location = vector3(1656.8000488281, 3241.0808105469, 39.571956634521), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_ranch", 		location = vector3(1629.8985595703, 3233.13671875, 39.411544799805), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_trailer", 	location = vector3(1599.4627685547, 3224.5256347656, 39.411544799805), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_trevor", 	location = vector3(1556.0042724609, 3217.2517089844, 39.418090820313), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_v16low",		location = vector3(1557.3369140625, 3158.802734375, 39.531597137451), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_v16mid", 	location = vector3(1525.2095947266, 3129.2026367188, 39.531597137451), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_highend", 	location = vector3(1492.0863037109, 3191.3540039063, 39.411560058594), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_highendv2", 	location = vector3(1422.2237548828, 3176.1845703125, 39.414108276367), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_michael", 	location = vector3(1372.3564453125, 3161.6599121094, 39.414108276367), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},

	{prop = "shell_coke1",		location = vector3(1398.3311767578, 3101.1711425781, 39.360679626465), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_coke2", 		location = vector3(1354.8074951172, 3090.0795898438, 39.534156799316), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_meth", 		location = vector3(1309.2673339844, 3077.1669921875, 39.439155578613), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_weed", 		location = vector3(1275.0375976563, 3068.0083007813, 39.534156799316), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	{prop = "shell_weed2", 		location = vector3(1235.0893554688, 3056.3073730469, 39.501216888428), rotation = vector3(0.0, 0.0, 0.0), collision = true, onfloor = false},
	]]
}

local remove_objects = {
	{model = 870605061, coords = vector3(-0.22, 0.75, -0.25)},
	{model = -1136244251, coords = vector3(-0.22, 0.75, -0.25)},
}

Citizen.CreateThread(function()
	for _, data in pairs(additional_objects) do
		if type(data.prop) == "string" then
			prop = CreateObject(GetHashKey(data.prop), data.location, 0, 0, 1)
		else
			prop = CreateObject(data.prop, data.location, 0, 0, 1)
		end
		SetEntityRotation(prop, data.rotation, 1, true)
		if data.collision then
			SetEntityCollision(prop, true, true)
			FreezeEntityPosition(prop, true)
		end
		if data.onfloor then
			PlaceObjectOnGroundProperly(prop)
		end
	end

	for _, data in pairs(remove_objects) do
		local model = data.model
		if type(data.model) == "string" then
			model = GetHashKey(data.model)
		end	
		local entity = GetClosestObjectOfType(data.coords, 0.5, model, false)
		if DoesEntityExist(entity) then
			DeleteEntity(entity)
			SetEntityCollision(entity, false)
			SetEntityVisible(entity, false, false)
		end
	end
end)









