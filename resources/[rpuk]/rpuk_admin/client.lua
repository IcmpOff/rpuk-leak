local colour, model, activeMode, godmode, ANametagsEnabled, states, spawned = 9, "", 0, false, nil, {}, false
local variation = false
states.frozen = false
states.frozenPos = nil

-- Quick fix handlers

local staff_temp_cmds = {
	["staffconsole"] = {"Staff Console", "HOME"},
	["cyclemode"] = {"Staff Mode", "DELETE"},
	["cyclecolour"] = {"Staff Colour Cycle", ""},
	["staffcamera"] = {"Staff Camera", "INSERT"},
	["staffnames"] = {"Staff Names", ""},
}

local dev_temp_cmds = {
	["cyclemode"] = {"Staff Mode", "DELETE"},
	["cyclecolour"] = {"Staff Colour Cycle", ""},
	["staffcamera"] = {"Staff Camera", "INSERT"},
	["staffnames"] = {"Staff Names", ""},
}

RegisterNetEvent('esx:setGroups')
AddEventHandler('esx:setGroups', function(groups)
	for group,v in pairs(groups) do
		if string.find(group, "staff_level_") then
			for command, keyData in pairs (staff_temp_cmds) do
				RegisterCommand(command, function()
					TriggerEvent('rpuk_admin:togglemode', command)
				end, false)
				RegisterKeyMapping(command, keyData[1], 'keyboard', keyData[2])
			end
			break -- has elevated perms over dev so can break here
		end
		if string.find(group, "dev_level_") then
			for command, keyData in pairs (dev_temp_cmds) do
				RegisterCommand(command, function()
					TriggerEvent('rpuk_admin:togglemode', command)
				end, false)
				RegisterKeyMapping(command, keyData[1], 'keyboard', keyData[2])
			end
		end
	end
end)

RegisterNetEvent('rpuk_admin:togglemode')
AddEventHandler('rpuk_admin:togglemode', function(mode)
	if mode == 'cyclemode' then CycleMode()
	elseif mode == 'staffconsole' then
		ESX.TriggerServerCallback('rpuk_admin:populatePlayers', function(data)
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'open', players = data})
		end)
	elseif mode == 'staffcamera' then TriggerEvent('demmycam:remoteAccessKey')
	elseif mode == 'staffnames' then ANametagsEnabled = not ANametagsEnabled
	elseif mode == 'cyclecolour' then
		if colour > 9 then
			colour = 0
			tronSuit()
		else
			colour = colour + 1
			tronSuit()
		end
	end
end)

RegisterNetEvent('rpuk:spawned')
AddEventHandler('rpuk:spawned', function(job)
	spawned = true
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if activeMode == 1 then
			if IsControlJustReleased(0, 111) and IsControlPressed(0, 61) then -- Numpad 8 + Active mode + Shift = Rainbow
				variation = not variation
				while variation and activeMode == 1 do
					Citizen.Wait(200)
					colour = math.random(1,9)
					tronSuit()
					if IsControlJustReleased(0, 111) or IsControlJustReleased(0, 214) then
						variation = false
					end
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function CycleMode()
	activeMode = activeMode + 1
	if activeMode == 3 then
		activeMode = 0 -- resets the active mode
	end
	TriggerEvent('skinchanger:getSkin', function(dbData)
		if dbData.sex == 0 then
			model = "mp_m_freemode_01"
		else
			model = "mp_f_freemode_01"
		end
	end)

	if activeMode == 0 then
		revertGod()
		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
		DetachEntity(PlayerPedId(), true, false)
		SetEntityVisible(PlayerPedId(), true, 0)
		NetworkSetEntityInvisibleToNetwork(PlayerPedId(), false)
	elseif activeMode == 1 then
		godmode = true
		tronSuit()
		DetachEntity(PlayerPedId(), true, false)
		SetEntityVisible(PlayerPedId(), true, 0)
		NetworkSetEntityInvisibleToNetwork(PlayerPedId(), false)
		TriggerEvent('rpuk_anticheat:tg', true)
	elseif activeMode == 2 then
		godmode = true
		SetEntityVisible(PlayerPedId(), false, 0)
		NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
		SetForcePedFootstepsTracks(false)
		DetachEntity(PlayerPedId(), true, false)
		TriggerEvent('rpuk_anticheat:tg', true)
	end
end

function tronSuit()
	local rand, col = math.random(1,2), 1
	if rand == 1 then col = 1	else col = 5 end
	if model == "mp_m_freemode_01" then
		SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0) --[[mask]]--
		SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 0) --[[arms]]--
		SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0) --[[bag]]
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 0) --[[chain]]
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 0) --[[shirt]]
		SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 0) --[[armor]]
		SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 0) --[[decal]]
		SetPedComponentVariation(PlayerPedId(), 4, 77, col, 0) --[[pants]]--
		SetPedComponentVariation(PlayerPedId(), 6, 55, col, 0) --[[shoes]]
		SetPedComponentVariation(PlayerPedId(), 11, 178, col, 0) --[[torso]]--
		SetPedPropIndex(PlayerPedId(), 0, 91, col, 2) -- Helmet
		-- SetPedPropIndex(PlayerPedId(), 0, 22, rand - 1, 2) -- Xmas Hat
	elseif model == "mp_f_freemode_01" then
		SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0) --[[mask]]--
		SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 0) --[[arms]]--
		SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0) --[[bag]]
		SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 0) --[[chain]]
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0, 0) --[[shirt]]
		SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 0) --[[armor]]
		SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 0) --[[decal]]
		SetPedComponentVariation(PlayerPedId(), 4, 79, col, 0) --[[pants]]--
		SetPedComponentVariation(PlayerPedId(), 6, 58, col, 0) --[[shoes]]
		SetPedComponentVariation(PlayerPedId(), 11, 180, col, 0) --[[torso]]--
		SetPedPropIndex(PlayerPedId(), 0, 90, col, 2) -- Helmet
		-- SetPedPropIndex(PlayerPedId(), 0, 23, rand - 1, 2) -- Xmas Hat
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if godmode then
			SetEntityInvincible(PlayerPedId(), true)
			SetPlayerInvincible(PlayerId(), true)
			SetPedCanRagdoll(PlayerPedId(), false)
			ClearPedBloodDamage(PlayerPedId())
			ResetPedVisibleDamage(PlayerPedId())
			ClearPedLastWeaponDamage(PlayerPedId())
			SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
			SetEntityOnlyDamagedByPlayer(PlayerPedId(), false)
			SetEntityCanBeDamaged(PlayerPedId(), false)
		else
			Citizen.Wait(500)
		end
	end
end)

function revertGod()
	godmode = false
	SetEntityInvincible(PlayerPedId(), false)
	SetPlayerInvincible(PlayerId(), false)
	SetPedCanRagdoll(PlayerPedId(), true)
	ClearPedBloodDamage(PlayerPedId())
	ResetPedVisibleDamage(PlayerPedId())
	ClearPedLastWeaponDamage(PlayerPedId())
	SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
	SetEntityOnlyDamagedByPlayer(PlayerPedId(), false)
	SetEntityCanBeDamaged(PlayerPedId(), true)
	TriggerEvent('rpuk_anticheat:tg', false)
end

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false)
end)

RegisterNUICallback('quick', function(data, cb)
	TriggerServerEvent('rpuk_admin:quick', data.type, data.playerId, data.arg3, data.arg4)
end)

RegisterNUICallback('set', function(data, cb)
	TriggerServerEvent('rpuk_admin:set', data.type, data.user, data.param)
end)

RegisterNUICallback('selfOptions', function(data, cb)
	if data.type == "self_nametags" then
		ANametagsEnabled = not ANametagsEnabled
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if ANametagsEnabled then
			local myPlayerCoords = GetEntityCoords(PlayerPedId())
			local AllPlayers = GetActivePlayers()
			table.removekey(AllPlayers, PlayerId())

			for i=1, #AllPlayers do
				local playerCoords = GetEntityCoords(GetPlayerPed(AllPlayers[i]))
				local distance, text = #(myPlayerCoords - playerCoords)

				if distance < 30 then
					if NetworkIsPlayerTalking(AllPlayers[i]) then
						text = ('~b~ID: %s~n~Steam Name: %s~s~'):format(GetPlayerServerId(AllPlayers[i]), GetPlayerName(AllPlayers[i]))
					else
						text = ('ID: %s~n~Steam Name: %s'):format(GetPlayerServerId(AllPlayers[i]), GetPlayerName(AllPlayers[i]))
					end

					ESX.Game.Utils.DrawText3D(playerCoords + vector3(0, 0, 1.3), text)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function table.removekey(array, element)
	for i = 1, #array do
		if array[i] == element then
			table.remove(array, i)
		end
	end
end

RegisterNetEvent('rpuk_admin:quick')
AddEventHandler('rpuk_admin:quick', function(t, target)
	if t == "crash" then
		print("Error "..GetGameTimer())
		while true do end
	elseif t == "freeze" then
		states.frozen = not states.frozen
		states.frozenPos = GetEntityCoords(PlayerPedId(), false)

		if not state then
			if not IsEntityVisible(PlayerPedId()) then
				SetEntityVisible(PlayerPedId(), true)
			end

			if not IsPedInAnyVehicle(PlayerPedId()) then
				SetEntityCollision(PlayerPedId(), true)
			end

			FreezeEntityPosition(PlayerPedId(), false)
			SetPlayerInvincible(PlayerId(), false)
		else
			SetEntityCollision(PlayerPedId(), false)
			FreezeEntityPosition(PlayerPedId(), true)

			if not IsPedFatallyInjured(PlayerPedId()) then
				ClearPedTasksImmediately(PlayerPedId())
			end
		end
	elseif t == 'slay' then
		SetEntityHealth(PlayerPedId(), 0)
	elseif t == 'bring_all' then
		ESX.Game.Teleport(PlayerPedId(), target)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if(states.frozen)then
			ClearPedTasksImmediately(PlayerPedId())
			SetEntityCoords(PlayerPedId(), states.frozenPos)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('rpuk_admin:freezePlayer')
AddEventHandler("rpuk_admin:freezePlayer", function(state)
	local player = PlayerId()

	local ped = PlayerPedId()

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end
end)

RegisterNetEvent('rpuk_admin:kill')
AddEventHandler('rpuk_admin:kill', function()
	SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('rpuk_admin:crash')
AddEventHandler('rpuk_admin:crash', function()
	while true do end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		SetNuiFocus(false)
		revertGod()

		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)

		DetachEntity(PlayerPedId(), true, false)
		SetEntityVisible(PlayerPedId(), true, 0)
		NetworkSetEntityInvisibleToNetwork(PlayerPedId(), false)
	end
end)