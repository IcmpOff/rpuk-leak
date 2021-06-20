local isSkinCreatorOpened = false
local heading = 332.2
local zoom = 'visage' -- Define which tab is shown first (Default: Head)
local cam, choosenModel

RegisterCommand('skin2', function(a,b)
	TriggerEvent('esx_skincreation:openMenu', b[1])
end)

AddEventHandler('esx_skincreation:openMenu', function(model)
	isSkinCreatorOpened = true
	SetSkinCreationMenuActive(true, model)
	choosenModel = model

	startAsyncRestrictionLoop()
	SetEntityHeading(PlayerPedId(), heading)
end)

function startAsyncRestrictionLoop()
	local playerPed = PlayerPedId()
	SetPlayerInvincible(playerPed, true)
	FreezeEntityPosition(playerPed, true)

	while isSkinCreatorOpened do
		Citizen.Wait(0)
		playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)

		if not DoesCamExist(cam) then
			cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
			SetCamCoord(cam, playerCoords)
			SetCamRot(cam, 0.0, 0.0, 0.0)
			SetCamActive(cam, true)
			RenderScriptCams(true, false, 0, true, true)
			SetCamCoord(cam, playerCoords)
		end

		if zoom == 'visage' or zoom == 'pilosite' then
			SetCamCoord(cam, playerCoords.x + 0.2, playerCoords.y + 0.5, playerCoords.z + 0.7)
			SetCamRot(cam, 0.0, 0.0, 150.0)
		elseif zoom == 'vetements' then
			SetCamCoord(cam, playerCoords.x + 0.3, playerCoords.y + 2.0, playerCoords.z + 0.0)
			SetCamRot(cam, 0.0, 0.0, 170.0)
		end
	end

	Citizen.Wait(500)

	FreezeEntityPosition(playerPed, false)
	SetPlayerInvincible(playerPed, false)
	SetSkinCreationMenuActive(false)

	RenderScriptCams(false, true, 500, true, true)
	SetCamActive(cam, false)
	DestroyCam(cam, true)
end

RegisterNUICallback('onSelectGender', function(data)
	local availableModels = {}

	for model,label in pairs(RegisteredModelsByGender[data.gender]) do
		availableModels[model] = label
	end

	SendNUIMessage({receivePlayerModels = true, availableModels = availableModels})
end)

RegisterNUICallback('onSelectModel', function(data)
	local hash = GetHashKey(data.model)

	if GetEntityModel(playerPed) ~= hash then
		if IsModelInCdimage(hash) and IsModelValid(hash) then
			BeginTextCommandBusyspinnerOn('STRING')
			AddTextComponentSubstringPlayerName('Changing player model')
			EndTextCommandBusyspinnerOn(4)

			RequestModel(hash)

			while not HasModelLoaded(hash) do
				Citizen.Wait(100)
			end

			SetPlayerModel(PlayerId(), hash)
			playerPed = PlayerPedId() -- update player ped, new handle
			SetPedDefaultComponentVariation(playerPed)
			ClearPedProp(playerPed, 0)

			SetModelAsNoLongerNeeded(hash)
			BusyspinnerOff()
		end
	end

	if Models[data.model] then
		local hatList, glassesList, earsList, topList, pantsList, shoesList, watchesList = {}, {}, {}, {}, {}, {}, {}

		for k,v in ipairs(Models[data.model].Hats) do hatList[k] = v.label end
		for k,v in ipairs(Models[data.model].Glasses) do glassesList[k] = v.label end
		for k,v in ipairs(Models[data.model].Ears) do earsList[k] = v.label end
		for k,v in ipairs(Models[data.model].Tops) do topList[k] = v.label end
		for k,v in ipairs(Models[data.model].Pants) do pantsList[k] = v.label end
		for k,v in ipairs(Models[data.model].Shoes) do shoesList[k] = v.label end
		for k,v in ipairs(Models[data.model].Watches) do watchesList[k] = v.label end

		SendNUIMessage({
			addItems = true,
			numOfHairs = #Models[data.model].Hairs,

			-- clothes
			hats = hatList,
			glasses = glassesList,
			ears = earsList,
			tops = topList,
			pants = pantsList,
			shoes = shoesList,
			watches = watchesList
		})
	end
end)

RegisterNUICallback('updateSkin', function(data)
	local playerPed = PlayerPedId()
	local creationComplete = data.value
	local choosenModel = data.model

	-- Face
	local dad = tonumber(data.dad)
	local mum = tonumber(data.mum)
	local dadmumpercent = tonumber(data.dadmumpercent)
	local skin = tonumber(data.skin)
	local eyecolor = tonumber(data.eyecolor)
	local acne = tonumber(data.acne)
	local skinproblem = tonumber(data.skinproblem)
	local freckle = tonumber(data.freckle)
	local wrinkle = tonumber(data.wrinkle)
	local wrinkleopacity = tonumber(data.wrinkleopacity)
	local hairIndex = tonumber(data.hair)
	local haircolor = tonumber(data.haircolor)
	local eyebrow = tonumber(data.eyebrow)
	local eyebrowopacity = tonumber(data.eyebrowopacity)
	local beard = tonumber(data.beard)
	local beardopacity = tonumber(data.beardopacity)
	local beardcolor = tonumber(data.beardcolor)

	-- Clothes
	local hat = tonumber(data.hats)
	local glasses = tonumber(data.glasses)
	local ears = tonumber(data.ears)
	local tops = tonumber(data.tops)
	local pants = tonumber(data.pants)
	local shoes = tonumber(data.shoes)
	local watches = tonumber(data.watches)

	-- TODO
	if creationComplete then
		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent('esx_skin:save', skin)
		end)

		isSkinCreatorOpened = false
	else
		-- Face
		SetPedHeadBlendData			(playerPed, dad, mum, dad, skin, skin, skin, dadmumpercent * 0.1, dadmumpercent * 0.1, 1.0, true)
		SetPedEyeColor				(playerPed, eyecolor)
		if acne == 0 then
			SetPedHeadOverlay		(playerPed, 0, acne, 0.0)
		else
			SetPedHeadOverlay		(playerPed, 0, acne, 1.0)
		end
		SetPedHeadOverlay			(playerPed, 6, skinproblem, 1.0)
		if freckle == 0 then
			SetPedHeadOverlay		(playerPed, 9, freckle, 0.0)
		else
			SetPedHeadOverlay		(playerPed, 9, freckle, 1.0)
		end
		SetPedHeadOverlay       	(playerPed, 3, wrinkle, wrinkleopacity * 0.1)


		local hairDrawableId = Models[choosenModel].Hairs[hairIndex]
		if not hairDrawableId then hairDrawableId = 0 end
		SetPedComponentVariation(playerPed, 2, hairDrawableId, 0, 2)

		SetPedHairColor				(playerPed, haircolor, haircolor)
		SetPedHeadOverlay       	(playerPed, 2, eyebrow, eyebrowopacity * 0.1)
		SetPedHeadOverlay       	(playerPed, 1, beard, beardopacity * 0.1)
		SetPedHeadOverlayColor  	(playerPed, 1, 1, beardcolor, beardcolor)
		SetPedHeadOverlayColor  	(playerPed, 2, 1, beardcolor, beardcolor)

		local topOutfit, pantsOutfit, shoesOutfit

		if hat == 0 then
			ClearPedProp(playerPed, 0)
		else
			local hatOutfit = Models[choosenModel].Hats[hat]
			SetPedPropIndex(playerPed, 0, hatOutfit.hat[1], hatOutfit.hat[2], true)
		end

		if glasses == 0 then
			ClearPedProp(playerPed, 1)
		else
			local glassesOutfit = Models[choosenModel].Glasses[glasses]
			SetPedPropIndex(playerPed, 1, glassesOutfit.glasses[1], glassesOutfit.glasses[2], true)
		end

		if ears == 0 then
			ClearPedProp(playerPed, 2)
		else
			local earsOutfit = Models[choosenModel].Ears[ears]
			SetPedPropIndex(playerPed, 2, earsOutfit.ears[1], earsOutfit.ears[2], true)
		end

		if watches == 0 then
			ClearPedProp(playerPed, 6)
		else
			local watchOutfit = Models[choosenModel].Watches[watches]
			SetPedPropIndex(playerPed, 6, watchOutfit.watch[1], watchOutfit.watch[2], true)
		end

		if tops == 0 then
			topOutfit = Models[choosenModel].Defaults.Tops
		else
			topOutfit = Models[choosenModel].Tops[tops]
		end

		if pants == 0 then
			pantsOutfit = Models[choosenModel].Defaults.Pants
		else
			pantsOutfit = Models[choosenModel].Pants[pants]
		end

		if shoes == 0 then
			shoesOutfit = Models[choosenModel].Defaults.Shoes
		else
			shoesOutfit = Models[choosenModel].Shoes[shoes]
		end

		SetPedComponentVariation(playerPed, 3, topOutfit.arms[1], topOutfit.arms[2], topOutfit.arms[3])
		SetPedComponentVariation(playerPed, 4, pantsOutfit.legs[1], pantsOutfit.legs[2], pantsOutfit.legs[3])
		SetPedComponentVariation(playerPed, 6, shoesOutfit.shoes[1], shoesOutfit.shoes[2], shoesOutfit.shoes[3])
		SetPedComponentVariation(playerPed, 7, topOutfit.accessory[1], topOutfit.accessory[2], topOutfit.accessory[3])
		SetPedComponentVariation(playerPed, 8, topOutfit.undershirt[1], topOutfit.undershirt[2], topOutfit.undershirt[3])
		SetPedComponentVariation(playerPed, 11, topOutfit.torso[1], topOutfit.torso[2], topOutfit.torso[3])

		-- TODO hardcoded
		SetPedHeadOverlay       	(playerPed, 4, 0, 0.0)   	 -- Lipstick
		SetPedHeadOverlay       	(playerPed, 8, 0, 0.0) 		 -- Makeup
		SetPedHeadOverlayColor  	(playerPed, 4, 1, 0, 0)      -- Makeup Color
		SetPedHeadOverlayColor  	(playerPed, 8, 1, 0, 0)      -- Lipstick Color
		SetPedComponentVariation	(playerPed, 1, 0,0, 2)       -- Mask
	end
end)

RegisterNUICallback('rotateleftheading', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
	heading = currentHeading + tonumber(data.value)
	SetEntityHeading(PlayerPedId(), heading)
end)

RegisterNUICallback('rotaterightheading', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
	heading = currentHeading - tonumber(data.value)
	SetEntityHeading(PlayerPedId(), heading)
end)

RegisterNUICallback('zoom', function(data)
	zoom = data.zoom
end)

function SetSkinCreationMenuActive(enable, model)
	SetNuiFocus(enable, enable)

	SendNUIMessage({
		openSkinCreator = true,
		state = enable
	})
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if isSkinCreatorOpened then
			local playerPed = PlayerPedId()
			SetPlayerInvincible(playerPed, false)
			FreezeEntityPosition(playerPed, false)

			SetNuiFocus(false)
		end
	end
end)