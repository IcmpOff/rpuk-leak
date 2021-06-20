occupied = false

ds = {
	signup_points = {
		{model = "mp_m_freemode_01", location = vector4(216.3, -918.88, 29.55, 54.97), anim = {"rcmnigel1bnmt_1b", "dance_loop_tyler"}, type = "vendor", event = "masks", spawned = false, text = "| ~b~Christmas Token Vendor~s~ |\n[~g~E~s~] To Browse Hats"},
		{model = "mp_f_freemode_01", location = vector4(215.65, -920.55, 29.69, 54.97), anim = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "low_center_down"}, type = "vendor", event = "tops", spawned = false, text = "| ~b~Christmas Token Vendor~s~ |\n[~g~E~s~] To Browse Trousers"},
		{model = "mp_f_freemode_01", location = vector4(212.79, -916.85, 29.69, 233.22), anim = {"move_clown@p_m_zero_idles@", "fidget_short_dance"}, type = "vendor", event = "hats", spawned = false, text = "| ~b~Christmas Token Vendor~s~ |\n[~g~E~s~] To Browse Masks"},	
		{model = "mp_m_freemode_01", location = vector4(211.88, -918.44, 29.69, 233.22), anim = {"move_clown@p_m_zero_idles@", "fidget_short_dance"}, type = "vendor", event = "hats", spawned = false, text = "| ~b~Christmas Token Vendor~s~ |\n[~g~E~s~] To Browse Tops"},	

		{model = "u_m_y_imporage", location = vector4(213.29, -919.98, 29.74, 321.89), anim = {"timetable@ron@ig_3_couch", "base"}, type = "xmas_gift", event = "hats", spawned = false, text = "| ~b~Seasonal Event~s~ |\n[~g~E~s~] To Claim Daily Gift"},

		{model = "a_c_deer", location = vector4(218.4794921875, -909.51385498047, 29.69220161438, 25.89), anim = {"creatures@deer@amb@world_deer_grazing@idle_a", "idle_a"}, type = "", event = "", spawned = false, text = ""},
		{model = "a_c_deer", location = vector4(216.73794555664, -910.80407714844, 29.692235946655, 25.89), anim = {"creatures@deer@amb@world_deer_grazing@idle_a", "idle_b"}, type = "", event = "", spawned = false, text = ""},
		{model = "a_c_deer", location = vector4(217.08712768555, -912.75451660156, 29.692171096802, 131.89), anim = {"creatures@deer@amb@world_deer_grazing@idle_a", "idle_c"}, type = "", event = "", spawned = false, text = ""},
		{model = "a_c_deer", location = vector4(221.05, -912.51, 29.69, 221.9), anim = {"creatures@deer@amb@world_deer_grazing@idle_a", "idle_b"}, type = "", event = "", spawned = false, text = ""},
	},
	snowball_points = {
		vector3(217.53649902344, -899.68139648438, 30.0),
		vector3(217.09507751465, -893.98669433594, 30.0),
		vector3(231.69053649902, -876.31341552734, 30.0),
		vector3(228.47543334961, -882.84429931641, 30.0),
		vector3(232.15782165527, -884.46942138672, 30.0),
		vector3(230.60607910156, -865.45141601563, 30.0),
		vector3(228.74893188477, -905.12878417969, 30.0),
		vector3(225.47985839844, -905.86895751953, 30.0),

		vector3(1163.37731, 282.8529663, 81.43966369),

		vector3(1141.8630371094, 125.87673950195, 82.052383422852),
		vector3(1146.2108154297, 129.75241088867, 82.129043579102),
		vector3(1152.5629882813, 127.83551025391, 82.146278381348),
		vector3(1149.8198242188, 116.23357391357, 81.773994445801),
		vector3(1152.5886230469, 120.16711425781, 82.214569091797),
		vector3(1140.9241943359, 117.90904998779, 80.905387878418),
		vector3(1140.6440429688, 121.54532623291, 81.520851135254),
	}
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local canSleep = true
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			for i=1, #ds.snowball_points, 1 do
				local distance = #(coords - ds.snowball_points[i])
				if distance < 1.5 then
					ESX.Game.Utils.DrawText3D(ds.snowball_points[i], "Press [E] To Roll A\nSnowball", 0.8, 6)
					canSleep = false
					if IsControlJustReleased(0, 38) and not occupied then
						occupied = true -- no need to sync it to db
						GiveWeaponToPed(playerPed, GetHashKey('weapon_snowball'), 100, 0, 0)
						Citizen.Wait(10000)
						occupied = false
					elseif IsControlJustReleased(0, 38) and occupied then	
						TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'error', text = "Your hands are too cold... Wait a minute."})
					end
				end
			end
		if canSleep then
			Citizen.Wait(2000)
		end
	end
end)

local claimed = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local canSleep = true
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			for i=1, #ds.signup_points, 1 do
				local distance = GetDistanceBetweenCoords(coords, ds.signup_points[i].location[1], ds.signup_points[i].location[2], ds.signup_points[i].location[3], true)
				if distance < 50.0 and not ds.signup_points[i].spawned then
					WaitForModel(ds.signup_points[i].model)
					local pedHandle = CreatePed(5, ds.signup_points[i].model, ds.signup_points[i].location[1], ds.signup_points[i].location[2], ds.signup_points[i].location[3] , ds.signup_points[i].location[4], false)
					SetEntityAsMissionEntity(pedHandle, true, true)
					SetBlockingOfNonTemporaryEvents(pedHandle, true)
					SetModelAsNoLongerNeeded(ds.signup_points[i].model)
					SetEntityCanBeDamaged(pedHandle, false)
					FreezeEntityPosition(pedHandle, true)
					if ds.signup_points[i].anim then
						if ds.signup_points[i].anim[2] then
							RequestAnimDict(ds.signup_points[i].anim[1])
							while not HasAnimDictLoaded(ds.signup_points[i].anim[1]) do
								Citizen.Wait(10)
							end
							TaskPlayAnim(pedHandle, ds.signup_points[i].anim[1], ds.signup_points[i].anim[2], 8.0, -8.0, -1, 3, 0.0, 0, 0, 0)
						else
							TaskStartScenarioInPlace(pedHandle, ds.signup_points[i].anim[1], 0, true)
						end
					end
					if ds.signup_points[i].model == "mp_m_freemode_01" or ds.signup_points[i].model == "mp_f_freemode_01" then
						apply_clothing(pedHandle, ds.signup_points[i].model)
					end
					ds.signup_points[i].spawned = true
				elseif distance < 1.5 then
					local text_coord = vector3(ds.signup_points[i].location[1], ds.signup_points[i].location[2], ds.signup_points[i].location[3] + 1.3)
					ESX.Game.Utils.DrawText3D(text_coord, ds.signup_points[i].text, 0.8, 6)
					canSleep = false
					if IsControlJustReleased(0, 38) and not occupied then
						if ds.signup_points[i].type == "xmas_gift" then
							claim_gift()
						end
					end

				end
			end
		if canSleep then
			Citizen.Wait(2000)
		end
	end
end)

function WaitForModel(model_input)
	model = GetHashKey(model_input)	
    if not IsModelValid(model) then
        return
    end
	if not HasModelLoaded(model) then
		RequestModel(model)
	end	
	while not HasModelLoaded(model) do
		Citizen.Wait(1000)
	end
end

function claim_gift()
	if claimed then
		TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'error', text = "You have claimed your gift for today!"})
	else
		claimed = true
		TriggerServerEvent('rpuk_christmas:claim_gift')
	end
end

function apply_clothing(playerPed, npc_gender)
	SetPedHeadBlendData			(playerPed, Character[npc_gender]['face'], Character[npc_gender]['face'], Character[npc_gender]['face'], Character[npc_gender]['skin'], Character[npc_gender]['skin'], Character[npc_gender]['skin'], 1.0, 1.0, 1.0, true)
	SetPedHairColor				(playerPed,			Character[npc_gender]['hair_color_1'],		Character[npc_gender]['hair_color_2'])					-- Hair Color
	SetPedHeadOverlay			(playerPed, 3,		Character[npc_gender]['age_1'],				(Character[npc_gender]['age_2'] / 10) + 0.0)			-- Age + opacity
	SetPedHeadOverlay			(playerPed, 1,		Character[npc_gender]['beard_1'],			(Character[npc_gender]['beard_2'] / 10) + 0.0)			-- Beard + opacity
	SetPedEyeColor				(playerPed,			Character[npc_gender]['eye_color'], 0, 1)												-- Eyes color
	SetPedHeadOverlay			(playerPed, 2,		Character[npc_gender]['eyebrows_1'],		(Character[npc_gender]['eyebrows_2'] / 10) + 0.0)		-- Eyebrows + opacity
	SetPedComponentVariation	(playerPed, 2,		Character[npc_gender]['hair_1'],			0, 2)						-- Hair
	SetPedHeadOverlayColor		(playerPed, 1, 1,	Character[npc_gender]['beard_3'],			Character[npc_gender]['beard_4'])						-- Beard Color
	SetPedHeadOverlayColor		(playerPed, 2, 1,	Character[npc_gender]['eyebrows_3'],		Character[npc_gender]['eyebrows_4'])					-- Eyebrows Color

	SetPedHeadOverlay			(playerPed, 5,		Character[npc_gender]['blush_1'],			(Character[npc_gender]['blush_2'] / 10) + 0.0)			-- Blush + opacity
	SetPedHeadOverlayColor		(playerPed, 5, 2,	Character[npc_gender]['blush_3'])														-- Blush Color
	SetPedHeadOverlay			(playerPed, 6,		Character[npc_gender]['complexion_1'],		(Character[npc_gender]['complexion_2'] / 10) + 0.0)		-- Complexion + opacity
	SetPedHeadOverlay			(playerPed, 7,		Character[npc_gender]['sun_1'],				(Character[npc_gender]['sun_2'] / 10) + 0.0)			-- Sun Damage + opacity
	SetPedHeadOverlay			(playerPed, 9,		Character[npc_gender]['moles_1'],			(Character[npc_gender]['moles_2'] / 10) + 0.0)			-- Moles/Freckles + opacity
	SetPedHeadOverlay			(playerPed, 10,		Character[npc_gender]['chest_1'],			(Character[npc_gender]['chest_2'] / 10) + 0.0)			-- Chest Hair + opacity
	SetPedHeadOverlayColor		(playerPed, 10, 1,	Character[npc_gender]['chest_3'])														-- Torso Color
	SetPedHeadOverlay			(playerPed, 11,		Character[npc_gender]['bodyb_1'],			(Character[npc_gender]['bodyb_2'] / 10) + 0.0)			-- Body Blemishes + opacity


	SetPedHeadOverlay(PlayerPedId(), 4, Character[npc_gender]['makeup_1'], Character[npc_gender]['makeup_4'])
	SetPedHeadOverlayColor(PlayerPedId(), 4, 2, Character[npc_gender]['makeup_3'], Character[npc_gender]['makeup_2'])
	SetPedHeadOverlay(PlayerPedId(), 8, Character[npc_gender]['lipstick_1'], Character[npc_gender]['lipstick_2'])
	SetPedHeadOverlayColor(PlayerPedId(), 8, 2, Character[npc_gender]['lipstick_3'], Character[npc_gender]['lipstick_4'])
	if Character[npc_gender]['ears_1'] == -1 then
		ClearPedProp(playerPed, 2)
	else
		SetPedPropIndex			(playerPed, 2,		Character[npc_gender]['ears_1'],			Character[npc_gender]['ears_2'], 2)						-- Ears Accessories
	end
	SetPedComponentVariation	(playerPed, 8,		Character[npc_gender]['tshirt_1'],			Character[npc_gender]['tshirt_2'], 2)					-- Tshirt
	SetPedComponentVariation	(playerPed, 11,		Character[npc_gender]['torso_1'],			Character[npc_gender]['torso_2'], 2)					-- torso parts
	SetPedComponentVariation	(playerPed, 3,		Character[npc_gender]['arms'],				Character[npc_gender]['arms_2'], 2)						-- Amrs
	SetPedComponentVariation	(playerPed, 10,		Character[npc_gender]['decals_1'],			Character[npc_gender]['decals_2'], 2)					-- decals
	SetPedComponentVariation	(playerPed, 4,		Character[npc_gender]['pants_1'],			Character[npc_gender]['pants_2'], 2)					-- pants
	SetPedComponentVariation	(playerPed, 6,		Character[npc_gender]['shoes_1'],			Character[npc_gender]['shoes_2'], 2)					-- shoes
	SetPedComponentVariation	(playerPed, 1,		Character[npc_gender]['mask_1'],			Character[npc_gender]['mask_2'], 2)						-- mask
	SetPedComponentVariation	(playerPed, 9,		Character[npc_gender]['bproof_1'],			Character[npc_gender]['bproof_2'], 2)					-- bulletproof
	SetPedComponentVariation	(playerPed, 7,		Character[npc_gender]['chain_1'],			Character[npc_gender]['chain_2'], 2)					-- chain
	SetPedComponentVariation	(playerPed, 5,		Character[npc_gender]['bags_1'],			Character[npc_gender]['bags_2'], 2)						-- Bag

	if Character[npc_gender]['helmet_1'] == -1 then
		ClearPedProp(playerPed, 0)
	else
		SetPedPropIndex			(playerPed, 0,		Character[npc_gender]['helmet_1'],			Character[npc_gender]['helmet_2'], 2)					-- Helmet
	end

	if Character[npc_gender]['glasses_1'] == -1 then
		ClearPedProp(playerPed, 1)
	else
		SetPedPropIndex			(playerPed, 1,		Character[npc_gender]['glasses_1'],			Character[npc_gender]['glasses_2'], 2)					-- Glasses
	end
end