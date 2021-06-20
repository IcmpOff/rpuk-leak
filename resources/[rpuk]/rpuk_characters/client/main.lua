local isMenuOpen, respawnAtLastCoords, hasOpenedGuide, cam, currentlySelectedCharacterIndex, spawnedPedsIn = true, nil, false, nil, nil, false
local metroTrain = nil
local playerCharacters = {}
local buttonsScaleform = nil

Citizen.CreateThread(function()
	asyncFetchCharactersEarly()
	SetAudioFlag('PlayMenuMusic', true)
	SetCloudHatOpacity(0.05)

	respawnAtLastCoords = nil
	TriggerEvent('rpuk_hud:toggleHud', false)
	TriggerEvent('rpuk_core:radarToggle', true)

	local defaultModel = GetHashKey('mp_m_freemode_01')
	RequestModel(defaultModel)

	while not HasModelLoaded(defaultModel) do Citizen.Wait(100) end

	SetPlayerModel(PlayerId(), defaultModel)
	SetModelAsNoLongerNeeded(defaultModel)
	SetPedDefaultComponentVariation(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), true)
	NetworkFadeOutEntity(PlayerPedId(), true, false)

	cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	SetCamCoord(cam, -540.597, -1288.538, 27.207)
	SetCamRot(cam, 0.0, -0.0, 66.087)
	RenderScriptCams(1,0,0,1,1)
	SetCamActive(cam, true)
	RenderScriptCams(true, false, 1, true, true)
	SetEntityCoords(PlayerPedId(), -545.879, -1266.880, 25.907, 0.0, 0.0, 0.0, true)

	buttonsScaleform = ESX.Scaleform.Utils.RequestScaleformMovie('instructional_buttons')

	while not spawnedPedsIn do Citizen.Wait(0) end

	DoScreenFadeOut(0)
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()
	DoScreenFadeIn(1000)
	while not IsScreenFadedIn() do Citizen.Wait(100) end

	currentlySelectedCharacterIndex = 1

	local metroModel = GetHashKey("metrotrain")
	RequestModel(metroModel)
	while not HasModelLoaded(metroModel) do
		RequestModel(metroModel)
		Citizen.Wait(0)
	end

	metroTrain = CreateMissionTrain(24, -559.288, -1312.895, 24.892, false)
	Citizen.Wait(2700)
	SetTrainCruiseSpeed(metroTrain, 0.0)
	while not IsVehicleStopped(metroTrain) do Citizen.Wait(0) end
	SetVehicleDoorOpen(metroTrain, 1)
	PlayVehicleDoorOpenSound(metroTrain, 1)
	SetVehicleDoorOpen(metroTrain, 3)
	PlayVehicleDoorOpenSound(metroTrain, 1)
	SetModelAsNoLongerNeeded(metroModel)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if currentlySelectedCharacterIndex then
			if IsDisabledControlJustReleased(0, 174) then cycleSelect(false) end
			if IsDisabledControlJustReleased(0, 175) then cycleSelect(true) end

			if IsDisabledControlJustReleased(0, 191) then
				local data = {
					characterIndex = currentlySelectedCharacterIndex,
					doesCharacterExist = 'false',
					isNameWiped = false
				}

				if playerCharacters[currentlySelectedCharacterIndex] then
					data.doesCharacterExist = 'true'
					if (playerCharacters[currentlySelectedCharacterIndex].firstname == '' or playerCharacters[currentlySelectedCharacterIndex].lastname == '') then
						data.isNameWiped = true
					end
				end

				SendNUIMessage({action = 'closeUI'})
				choosenCharacter(data, function() end)
			end
			DisableAllControlActions(0)
			drawButtonsThisFrame()
		end
	end
end)

function cycleSelect(direction)
	SetEntityAlpha(Config.PedSpawns[currentlySelectedCharacterIndex].handle, 153, false)

	if direction then --True = right
		if currentlySelectedCharacterIndex == 4 then
			currentlySelectedCharacterIndex = 1
		else
			currentlySelectedCharacterIndex = currentlySelectedCharacterIndex + 1
		end
	else
		if currentlySelectedCharacterIndex == 1 then
			currentlySelectedCharacterIndex = 4
		else
			currentlySelectedCharacterIndex = currentlySelectedCharacterIndex - 1
		end
	end

	ResetEntityAlpha(Config.PedSpawns[currentlySelectedCharacterIndex].handle)

	SendNUIMessage({
		action = 'openUI',
		character = playerCharacters[currentlySelectedCharacterIndex],
		character_index = currentlySelectedCharacterIndex,
		isVoiceActivated = true
	})
end

function drawButtonsThisFrame()
	BeginScaleformMovieMethod(buttonsScaleform, 'CLEAR_ALL')
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(buttonsScaleform, 'SET_CLEAR_SPACE')
	ScaleformMovieMethodAddParamInt(200)
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(buttonsScaleform, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamTextureNameString("~INPUT_CELLPHONE_RIGHT~")
	ScaleformMovieMethodAddParamTextureNameString('Cycle Right')
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(buttonsScaleform, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(1)
	ScaleformMovieMethodAddParamTextureNameString("~INPUT_CELLPHONE_LEFT~")
	ScaleformMovieMethodAddParamTextureNameString('Cycle Left')
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(buttonsScaleform, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(2)
	ScaleformMovieMethodAddParamTextureNameString("~INPUT_FRONTEND_RDOWN~")
	ScaleformMovieMethodAddParamTextureNameString('Select Slot')
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(buttonsScaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(buttonsScaleform, 'SET_BACKGROUND_COLOUR')
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(80)
	EndScaleformMovieMethod()

	DrawScaleformMovieFullscreen(buttonsScaleform, 255, 255, 255, 255, 0)
end

function asyncFetchCharactersEarly()
	ESX.DrawSpinner('Loading Characters From Hive')

	ESX.TriggerServerCallback('rpuk_characters:fetchCharacters', function(_playerCharacters)
		SetNuiFocus(true, true)
		SetNuiFocusKeepInput(true)

		-- wtf is this needed for?!
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			SetNuiFocus(true, true)
			SetNuiFocusKeepInput(true)
		end)

		for k,v in ipairs(_playerCharacters) do
			playerCharacters[v.character_index] = v
		end

		for k,v in ipairs(Config.PedSpawns) do
			local decodedSkin
			local model = "s_m_m_strperf_01"

			if playerCharacters[k] and playerCharacters[k].skin and playerCharacters[k].skin ~= '' then
				decodedSkin = json.decode(playerCharacters[k].skin)

				if decodedSkin.sex == 0 then
					model = "mp_m_freemode_01"
				else
					model = "mp_f_freemode_01"
				end
			end

			RequestModel(model)
			while not HasModelLoaded(model) do Citizen.Wait(10) end

			v.handle = CreatePed('PED_TYPE_NETWORK_PLAYER', GetHashKey(model), v.spawn, -70.0, false, false)
			FreezeEntityPosition(v.handle, true)
			SetEntityInvincible(v.handle, true)
			SetBlockingOfNonTemporaryEvents(v.handle, true)
			TaskStartScenarioInPlace(v.handle, "WORLD_HUMAN_COP_IDLES", 0, true)

			if k ~= 1 then SetEntityAlpha(v.handle, 204, false) end
			SetModelAsNoLongerNeeded(model)

			if decodedSkin then
				TriggerEvent('skinchanger:loadSkin', decodedSkin, function() end, v.handle)
			end
		end

		spawnedPedsIn = true
		while currentlySelectedCharacterIndex == nil do Citizen.Wait(0) end

		SendNUIMessage({
			action = 'openUI',
			character = playerCharacters[1],
			character_index = 1,
			isVoiceActivated = true
			--isVoiceActivated = isVoiceActivated()
		})
	end)
	BusyspinnerOff()
end

function spawnCharacter(spawnCoords, playerJobName, playerSkin, isPlayerInJail, isPlayerDead, health, armour)
	currentlySelectedCharacterIndex = nil
	SetScaleformMovieAsNoLongerNeeded(buttonsScaleform)

	for index,data in pairs(Config.PedSpawns) do
		if data.handle then
			DeleteEntity(data.handle)
			data.handle = nil
		end
	end

	if not IsPlayerSwitchInProgress() then SwitchOutPlayer(PlayerPedId(), 0, 1) end
	while GetPlayerSwitchState() ~= 5 do Citizen.Wait(100) end

	BusyspinnerOff()
	local openSkinMenu = true

	if isPlayerInJail then
		spawnCoords = Config.JailLocationInside
	else
		if spawnCoords then
			spawnCoords = json.decode(spawnCoords)
			spawnCoords = vector3(spawnCoords.x, spawnCoords.y, spawnCoords.z)

			if #(spawnCoords - Config.JailLocationCenter) < 130 then
				spawnCoords = Config.JailLocationOutside
				ESX.ShowNotification('You will spawn at the jail parking area because you were previously close to the jail.')
			end
		else
			local spawnIndex = math.random(1, #Config.AvailableSpawnLocations)
			spawnCoords = Config.AvailableSpawnLocations[spawnIndex]
		end

		if Config.JobSpawns[playerJobName] then
			SendNUIMessage({action = 'chooseSpawnLocation'})
			SetNuiFocus(true, true)
			isMenuOpen = true

			while respawnAtLastCoords == nil do Citizen.Wait(100) end

			if not respawnAtLastCoords then
				spawnCoords = Config.JobSpawns[playerJobName].location

				if Config.JobSpawns[playerJobName].armour then
					SetPedArmour(PlayerPedId(), 100)
				end
			end
		end
	end

	ESX.DrawSpinner('Spawning Character')

	if playerSkin and playerSkin ~= '' then
		local decodedSkin = json.decode(playerSkin)

		if decodedSkin and type(decodedSkin) == 'table' then
			openSkinMenu = false
			TriggerEvent('skinchanger:loadSkin', decodedSkin, function() end)
		end
	end

	ESX.Game.Teleport(PlayerPedId(), spawnCoords, function()
		Citizen.Wait(500)
		RenderScriptCams(false, true, 500, true, true)
		SetCamActive(cam, false)
		DestroyCam(cam, true)
		SwitchInPlayer(PlayerPedId())

		while GetPlayerSwitchState() ~= 12 do Citizen.Wait(100) end

		FreezeEntityPosition(PlayerPedId(), false)
		NetworkFadeInEntity(PlayerPedId(), true)
		BusyspinnerOff()
		ClearCloudHat()
		Citizen.Wait(500)

		SetAudioFlag('PlayMenuMusic', false)
		TriggerEvent('rpuk:spawned')
		isMenuOpen = false

		Citizen.Wait(5)
		TriggerEvent('rpuk_hud:toggleHud', true)
		TriggerEvent('rpuk_core:radarToggle', false)

		if openSkinMenu then
			TriggerEvent('rpuk_skincreator:openSaveableMenu')
		end

		if not isPlayerInJail and not isPlayerDead then
			SetEntityHealth(PlayerPedId(), health)
			SetPedArmour(PlayerPedId(), armour)
		end

		if isPlayerInJail then
			TriggerEvent("rpuk_prison:spawnedBack")
		end

		-- enable PVP after 10 seconds (spawn protection)
		if not isPlayerDead then
			SetEntityAlpha(PlayerPedId(), 150, false)
			ESX.DrawSpinner('Combat Protection Active')
			Citizen.Wait(10000)
		end

		SetCanAttackFriendly(PlayerPedId(), true, false)
		NetworkSetFriendlyFireOption(true)
		SetPedMaxHealth(PlayerPedId(), 200)
		ResetEntityAlpha(PlayerPedId())
		BusyspinnerOff()
	end, true)
end

RegisterNUICallback('choosenCharacter', function(data, cb)
	choosenCharacter(data, cb)
end)

function choosenCharacter(data, cb)
	SetNuiFocusKeepInput(false)
	local doesCharacterExist = data.doesCharacterExist == 'true'

	if doesCharacterExist then
		if data.isNameWiped then
			SendNUIMessage({action = 'showNamePrompt', characterIndex = data.characterIndex})
		else
			ESX.DrawSpinner('Loading Character From Hive')
			SendNUIMessage({action = 'playIntro'})
			SetNuiFocus(false)

			DeleteMissionTrain(metroTrain)
			ESX.TriggerServerCallback('rpuk_characters:choosenCharacter', function(...)
				cb(true)
				spawnCharacter(...)
			end, data.characterIndex, doesCharacterExist)
		end
	else
		SendNUIMessage({action = 'createCharacter', characterIndex = data.characterIndex})
	end
end

-- this below needs fixing
RegisterNUICallback('openPauseMenu', function(data, cb)
	SetNuiFocusKeepInput(false)
	SetNuiFocus(false)

	ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), true, 42)
	Citizen.Wait(1000)

	while GetPauseMenuState() ~= 0 do Citizen.Wait(500) end

	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(true)
	cb(isVoiceActivated())
end)

RegisterNUICallback('keepFocus', function(data, cb)
	SetNuiFocusKeepInput(true)
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
	ESX.TriggerServerCallback('rpuk_characters:deleteCharacter', function(rowsChanged)
		cb(rowsChanged > 0)
		DeleteEntity(Config.PedSpawns[data.characterIndex].handle)
		Config.PedSpawns[data.characterIndex].handle = nil
		local model = GetHashKey('s_m_m_strperf_01')

		RequestModel(model)
		while not HasModelLoaded(model) do Citizen.Wait(10) end

		Config.PedSpawns[data.characterIndex].handle = CreatePed('PED_TYPE_NETWORK_PLAYER', model, Config.PedSpawns[data.characterIndex].spawn, -70.0, false, false)
		FreezeEntityPosition(Config.PedSpawns[data.characterIndex].handle, true)
		SetEntityInvincible(Config.PedSpawns[data.characterIndex].handle, true)
		SetBlockingOfNonTemporaryEvents(Config.PedSpawns[data.characterIndex].handle, true)
		TaskStartScenarioInPlace(Config.PedSpawns[data.characterIndex].handle, "WORLD_HUMAN_COP_IDLES", 0, true)
		SetModelAsNoLongerNeeded(model)
		playerCharacters[data.characterIndex] = nil
	end, data.characterIndex)
end)

RegisterNUICallback('openGuide', function(data, cb)
	hasOpenedGuide = true
	TriggerEvent('rpuk_guide:openGuide', true)
end)

AddEventHandler('rpuk_guide:onGuideClosed', function()
	if hasOpenedGuide then
		hasOpenedGuide = false
		SetNuiFocus(true, true)
		SetTimecycleModifier('default')
	end
end)

RegisterNUICallback('spawnLocationChoosen', function(data, cb)
	SetNuiFocus(false)
	isMenuOpen = false
	respawnAtLastCoords = data.respawnAtLastCoords
	cb('ok')
end)

RegisterNUICallback('characterCreated', function(data, cb)
	local reason

	for key,val in pairs(data) do
		if key == 'firstName' or key == 'lastName' then
			local name = verifyName(val)

			if val ~= name then
				reason = name
			end
		elseif key == 'age' then
			local age = tonumber(val)

			if age then
				if age < 18 or age > 100 then
					reason = 'Your character age is outside the allowed range (18-100 years old)'
				end
			else
				reason = 'You didn\'t choose character age'
			end
		elseif key == 'height' then
			local height = tonumber(val)

			if height then
				if height > 200 or height < 140 then
					reason = 'Your character height is outside the allowed range (140-200 cm)'
				end
			else
				reason = 'You didn\'t choose character height'
			end
		elseif key == 'gender' and val == 'none' then
			reason = 'Select your character\'s gender'
		elseif key == 'gtaRulesChecked' and not val then
			reason = 'You must have read the GTA RP Rules before you proceed'
		elseif key == 'communityRulesChecked' and not val then
			reason = 'You must have read the Community Rules before you proceed'
		end

		if reason then break end
	end

	if reason then
		cb(false)
		TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = reason})
	else
		cb(true)
		ESX.DrawSpinner('Creating Character')
		SendNUIMessage({action = 'playIntro'})
		SetNuiFocus(false)

		ESX.TriggerServerCallback('rpuk_characters:choosenCharacter', function(...)
			DeleteMissionTrain(metroTrain)
			spawnCharacter(...)
		end, data.characterIndex, data.doesCharacterExist, data.firstName, data.lastName, data.age or 0, data.height or 0, data.gender or '', data.updateNames)
	end
end)

function verifyName(name)
	-- Don't allow short user names
	local nameLength, validCharacterLength, spacesInName = string.len(name), 0, 0

	if nameLength > 25 or nameLength < 1 then return 'Your player name is too short or too long.' end

	for k in name:gmatch('[abcdefghijklmnopqrstuvwxyzåäöABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ0123456789 -]') do validCharacterLength = validCharacterLength + 1 end

	if validCharacterLength ~= nameLength then return 'Your name contains characters that are not allowed on this server.' end

	for word in string.gmatch(name, '%S+') do spacesInName = spacesInName + 1 end

	if spacesInName > 10 then return 'Your name contains too many spaces' end

	return name
end

function isVoiceActivated() return GetConvarInt('profile_voiceEnable', 0) == 1 and GetConvarInt('profile_voiceTalkEnabled', 0) == 1 end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if isMenuOpen then
			SetNuiFocus(false)
		end
	end
end)