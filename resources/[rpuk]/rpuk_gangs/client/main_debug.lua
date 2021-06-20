Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local canSleep = true
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		for i=1, #Config.DeveloperDebug["SpawnPeds"], 1 do
			local distance = GetDistanceBetweenCoords(coords, Config.DeveloperDebug["SpawnPeds"][i]["Location"][1], Config.DeveloperDebug["SpawnPeds"][i]["Location"][2], Config.DeveloperDebug["SpawnPeds"][i]["Location"][3], true)
			if distance < 50.0 and not Config.DeveloperDebug["SpawnPeds"][i]["spawned"] then
				
				WaitForModel(Config.DeveloperDebug["SpawnPeds"][i]["sex"])
				local pedHandle = CreatePed(5, Config.DeveloperDebug["SpawnPeds"][i]["sex"], Config.DeveloperDebug["SpawnPeds"][i]["Location"][1], Config.DeveloperDebug["SpawnPeds"][i]["Location"][2], Config.DeveloperDebug["SpawnPeds"][i]["Location"][3], Config.DeveloperDebug["SpawnPeds"][i]["Location"][4], false)
				
				SetEntityAsMissionEntity(pedHandle, true, true)
				SetBlockingOfNonTemporaryEvents(pedHandle, true)
				SetModelAsNoLongerNeeded(Config.DeveloperDebug["SpawnPeds"][i]["sex"])
				SetEntityCanBeDamaged(pedHandle, false)
				FreezeEntityPosition(pedHandle, true)
				
				apply_clothing(pedHandle, i)
				Config.DeveloperDebug["SpawnPeds"][i]["spawned"] = true
			end
		end
			
		if canSleep then
			Citizen.Wait(2000)
		end
	end
end)

function apply_clothing(playerPed, index)
	SetPedHeadBlendData			(playerPed, Config.DeveloperDebug["SpawnPeds"][index]['face'], Config.DeveloperDebug["SpawnPeds"][index]['face'], Config.DeveloperDebug["SpawnPeds"][index]['face'], Config.DeveloperDebug["SpawnPeds"][index]['skin'], Config.DeveloperDebug["SpawnPeds"][index]['skin'], Config.DeveloperDebug["SpawnPeds"][index]['skin'], 1.0, 1.0, 1.0, true)
	SetPedHairColor				(playerPed,			Config.DeveloperDebug["SpawnPeds"][index]['hair_color_1'],		Config.DeveloperDebug["SpawnPeds"][index]['hair_color_2'])					-- Hair Color
	SetPedHeadOverlay			(playerPed, 3,		Config.DeveloperDebug["SpawnPeds"][index]['age_1'],				(Config.DeveloperDebug["SpawnPeds"][index]['age_2'] / 10) + 0.0)			-- Age + opacity
	SetPedHeadOverlay			(playerPed, 1,		Config.DeveloperDebug["SpawnPeds"][index]['beard_1'],			(Config.DeveloperDebug["SpawnPeds"][index]['beard_2'] / 10) + 0.0)			-- Beard + opacity
	SetPedEyeColor				(playerPed,			Config.DeveloperDebug["SpawnPeds"][index]['eye_color'], 0, 1)												-- Eyes color
	SetPedHeadOverlay			(playerPed, 2,		Config.DeveloperDebug["SpawnPeds"][index]['eyebrows_1'],		(Config.DeveloperDebug["SpawnPeds"][index]['eyebrows_2'] / 10) + 0.0)		-- Eyebrows + opacity
	SetPedComponentVariation	(playerPed, 2,		Config.DeveloperDebug["SpawnPeds"][index]['hair_1'],			0, 2)						-- Hair
	SetPedHeadOverlayColor		(playerPed, 1, 1,	Config.DeveloperDebug["SpawnPeds"][index]['beard_3'],			Config.DeveloperDebug["SpawnPeds"][index]['beard_4'])						-- Beard Color
	SetPedHeadOverlayColor		(playerPed, 2, 1,	Config.DeveloperDebug["SpawnPeds"][index]['eyebrows_3'],		Config.DeveloperDebug["SpawnPeds"][index]['eyebrows_4'])					-- Eyebrows Color

	SetPedHeadOverlay			(playerPed, 5,		Config.DeveloperDebug["SpawnPeds"][index]['blush_1'],			(Config.DeveloperDebug["SpawnPeds"][index]['blush_2'] / 10) + 0.0)			-- Blush + opacity
	SetPedHeadOverlayColor		(playerPed, 5, 2,	Config.DeveloperDebug["SpawnPeds"][index]['blush_3'])														-- Blush Color
	SetPedHeadOverlay			(playerPed, 6,		Config.DeveloperDebug["SpawnPeds"][index]['complexion_1'],		(Config.DeveloperDebug["SpawnPeds"][index]['complexion_2'] / 10) + 0.0)		-- Complexion + opacity
	SetPedHeadOverlay			(playerPed, 7,		Config.DeveloperDebug["SpawnPeds"][index]['sun_1'],				(Config.DeveloperDebug["SpawnPeds"][index]['sun_2'] / 10) + 0.0)			-- Sun Damage + opacity
	SetPedHeadOverlay			(playerPed, 9,		Config.DeveloperDebug["SpawnPeds"][index]['moles_1'],			(Config.DeveloperDebug["SpawnPeds"][index]['moles_2'] / 10) + 0.0)			-- Moles/Freckles + opacity
	SetPedHeadOverlay			(playerPed, 10,		Config.DeveloperDebug["SpawnPeds"][index]['chest_1'],			(Config.DeveloperDebug["SpawnPeds"][index]['chest_2'] / 10) + 0.0)			-- Chest Hair + opacity
	SetPedHeadOverlayColor		(playerPed, 10, 1,	Config.DeveloperDebug["SpawnPeds"][index]['chest_3'])														-- Torso Color
	SetPedHeadOverlay			(playerPed, 11,		Config.DeveloperDebug["SpawnPeds"][index]['bodyb_1'],			(Config.DeveloperDebug["SpawnPeds"][index]['bodyb_2'] / 10) + 0.0)			-- Body Blemishes + opacity


	SetPedHeadOverlay(PlayerPedId(), 4, Config.DeveloperDebug["SpawnPeds"][index]['makeup_1'], Config.DeveloperDebug["SpawnPeds"][index]['makeup_4'])
	SetPedHeadOverlayColor(PlayerPedId(), 4, 2, Config.DeveloperDebug["SpawnPeds"][index]['makeup_3'], Config.DeveloperDebug["SpawnPeds"][index]['makeup_2'])
	SetPedHeadOverlay(PlayerPedId(), 8, Config.DeveloperDebug["SpawnPeds"][index]['lipstick_1'], Config.DeveloperDebug["SpawnPeds"][index]['lipstick_2'])
	SetPedHeadOverlayColor(PlayerPedId(), 8, 2, Config.DeveloperDebug["SpawnPeds"][index]['lipstick_3'], Config.DeveloperDebug["SpawnPeds"][index]['lipstick_4'])
	if Config.DeveloperDebug["SpawnPeds"][index]['ears_1'] == -1 then
		ClearPedProp(playerPed, 2)
	else
		SetPedPropIndex			(playerPed, 2,		Config.DeveloperDebug["SpawnPeds"][index]['ears_1'],			Config.DeveloperDebug["SpawnPeds"][index]['ears_2'], 2)						-- Ears Accessories
	end
	SetPedComponentVariation	(playerPed, 8,		Config.DeveloperDebug["SpawnPeds"][index]['tshirt_1'],			Config.DeveloperDebug["SpawnPeds"][index]['tshirt_2'], 2)					-- Tshirt
	SetPedComponentVariation	(playerPed, 11,		Config.DeveloperDebug["SpawnPeds"][index]['torso_1'],			Config.DeveloperDebug["SpawnPeds"][index]['torso_2'], 2)					-- torso parts
	SetPedComponentVariation	(playerPed, 3,		Config.DeveloperDebug["SpawnPeds"][index]['arms'],				Config.DeveloperDebug["SpawnPeds"][index]['arms_2'], 2)						-- Amrs
	SetPedComponentVariation	(playerPed, 10,		Config.DeveloperDebug["SpawnPeds"][index]['decals_1'],			Config.DeveloperDebug["SpawnPeds"][index]['decals_2'], 2)					-- decals
	SetPedComponentVariation	(playerPed, 4,		Config.DeveloperDebug["SpawnPeds"][index]['pants_1'],			Config.DeveloperDebug["SpawnPeds"][index]['pants_2'], 2)					-- pants
	SetPedComponentVariation	(playerPed, 6,		Config.DeveloperDebug["SpawnPeds"][index]['shoes_1'],			Config.DeveloperDebug["SpawnPeds"][index]['shoes_2'], 2)					-- shoes
	if Config.DeveloperDebug["SpawnPeds"][index]['torso_2'] < 6 and math.random(1,2) == 1 then
		SetPedComponentVariation	(playerPed, 1,		Config.DeveloperDebug["SpawnPeds"][index]['mask_1'],			Config.DeveloperDebug["SpawnPeds"][index]['torso_2'], 2)					-- mask
	end
	SetPedComponentVariation	(playerPed, 9,		Config.DeveloperDebug["SpawnPeds"][index]['bproof_1'],			Config.DeveloperDebug["SpawnPeds"][index]['bproof_2'], 2)					-- bulletproof
	SetPedComponentVariation	(playerPed, 7,		Config.DeveloperDebug["SpawnPeds"][index]['chain_1'],			Config.DeveloperDebug["SpawnPeds"][index]['chain_2'], 2)					-- chain
	SetPedComponentVariation	(playerPed, 5,		Config.DeveloperDebug["SpawnPeds"][index]['bags_1'],			Config.DeveloperDebug["SpawnPeds"][index]['bags_2'], 2)						-- Bag

	if Config.DeveloperDebug["SpawnPeds"][index]['helmet_1'] == -1 then
		ClearPedProp(playerPed, 0)
	else
		SetPedPropIndex			(playerPed, 0,		Config.DeveloperDebug["SpawnPeds"][index]['helmet_1'],			Config.DeveloperDebug["SpawnPeds"][index]['helmet_2'], 2)					-- Helmet
	end

	if Config.DeveloperDebug["SpawnPeds"][index]['glasses_1'] == -1 then
		ClearPedProp(playerPed, 1)
	else
		SetPedPropIndex			(playerPed, 1,		Config.DeveloperDebug["SpawnPeds"][index]['glasses_1'],			Config.DeveloperDebug["SpawnPeds"][index]['glasses_2'], 2)					-- Glasses
	end
	
	if Config.DeveloperDebug["SpawnPeds"][index]['weapon'] then
		GiveWeaponToPed(playerPed, GetHashKey(Config.DeveloperDebug["SpawnPeds"][index]['weapon']), 0, false, false)
		SetCurrentPedWeapon(playerPed, GetHashKey(Config.DeveloperDebug["SpawnPeds"][index]['weapon']), true)
	end
end

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