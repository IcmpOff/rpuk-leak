local veh_key_table, hou_key_table, cooldown = {}, {}, false

Citizen.CreateThread(function()
	while not ESX.IsPlayerLoaded() do Citizen.Wait(1000) end -- wait for kashacter to choose char

	ESX.TriggerServerCallback('rpuk_keys:keyTable', function(key_table)
		veh_key_table = key_table
	end, "vehicle")
end)

RegisterNetEvent('rpuk_keys:assignKey')
AddEventHandler('rpuk_keys:assignKey', function(key_table, handle)
	if key_table == "vehicle" then
		table.insert(veh_key_table, handle)
	elseif key_table == "housing" then

	end
end)

RegisterNetEvent('rpuk_keys:removeKey')
AddEventHandler('rpuk_keys:removeKey', function(key_table, handle)
	if key_table == "vehicle" then
		for k,v in ipairs(veh_key_table) do
			if v == handle then
				table.remove(veh_key_table, k)
				break
			end
		end
	end
end)

RegisterCommand("givekey", function(source, args)
	if args[1] then
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			local vehProps = ESX.Game.GetVehicleProperties(vehicle)
			for k, v in ipairs(veh_key_table) do
				if tostring(v) == tostring(vehProps.plate) then
					TriggerServerEvent('rpuk_keys:give_key', "vehicle", tostring(args[1]), vehProps.plate)
				end
			end
		else
			TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "You need to be in a vehicle to give keys!"})
		end
	end
end, false)

RegisterKeyMapping('togglelock', 'Toggle vehicle lock', 'keyboard', 'l')
TriggerEvent('chat:addSuggestion', '/togglelock', 'Toggle vehicle lock')

RegisterCommand('togglelock', function(playerId, args, rawCommand)
	if not cooldown then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicleHandle = GetVehiclePedIsIn(playerPed, false)
			local vehProps = ESX.Game.GetVehicleProperties(vehicleHandle)

			for _, data in ipairs(veh_key_table) do
				if data == vehProps.plate then
					toggleVehicleLock(vehicleHandle)
					break
				end
			end
		else -- Player is on foot
			local vehicleHandle, distance = ESX.Game.GetClosestVehicle()
			local vehProps = ESX.Game.GetVehicleProperties(vehicleHandle)

			for _, data in ipairs(veh_key_table) do
				if data == vehProps.plate then
					toggleVehicleLock(vehicleHandle)
					break
				end
			end
		end
	end
end, false)

function toggleVehicleLock(vehicleHandle)
	cooldown = true
	local playerPed, animDict = PlayerPedId(), 'anim@mp_player_intmenu@key_fob@'
	local networkId = NetworkGetNetworkIdFromEntity(vehicleHandle)
	TriggerServerEvent('rpuk_core:toggleVehicleLockOnEntityOwner', networkId)
	ESX.Streaming.RequestAnimDict(animDict)

	ESX.Game.SpawnObject('p_car_keys_01', vector3(0,0,0), function(objectHandle)
		SetEntityCollision(objectHandle, false, false)
		AttachEntityToEntity(objectHandle, playerPed, GetPedBoneIndex(playerPed, 57005), 0.09, 0.03, -0.02, 0.0, 0.0, 0.0, false, true, true, true, 0, true)
		ClearPedTasks(playerPed)

		-- todo better anim locking in a car
		--[[if IsPedOnFoot(playerPed) then
			local success, weaponHash = GetCurrentPedWeapon(playerPed, true)

			-- switch weapon first so animation doesn't look broken
			if weaponHash ~= GetHashKey('WEAPON_UNARMED') then
				SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
				Citizen.Wait(1000) -- let unarm animation run
			end

		-TaskTurnPedToFaceEntity(playerPed, vehicleHandle, 500)
			Citizen.Wait(500)
		end]]

		TaskPlayAnim(playerPed, animDict, 'fob_click', 3.0, -8.0, 1000, 50, 0.0, false, false, false)

		if GetVehicleDoorsLockedForPlayer(vehicleHandle, playerPed) then -- is locked
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "car", 0.1)
		else -- is unlocked
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "carlock", 0.1)
		end

		Citizen.Wait(1000)
		DetachEntity(objectHandle, false, false)
		ESX.Game.DeleteEntity(objectHandle)
		RemoveAnimDict(animDict)
	end)

	cooldown = false
end

function asyncPlayVehicleLockLights(vehicleHandle)
	Citizen.CreateThread(function()
		SetVehicleLights(vehicleHandle, 2)
		SetVehicleFullbeam(vehicleHandle, true)
		SetVehicleBrakeLights(vehicleHandle, true)
		SetVehicleInteriorlight(vehicleHandle, true)
		SetVehicleIndicatorLights(vehicleHandle, 0, true)
		SetVehicleIndicatorLights(vehicleHandle, 1, true)
		Citizen.Wait(450)

		SetVehicleIndicatorLights(vehicleHandle, 0, false)
		SetVehicleIndicatorLights(vehicleHandle, 1, false)
		Citizen.Wait(450)

		SetVehicleInteriorlight(vehicleHandle, true)
		SetVehicleIndicatorLights(vehicleHandle, 0, true)
		SetVehicleIndicatorLights(vehicleHandle, 1, true)
		Citizen.Wait(450)

		SetVehicleLights(vehicleHandle, 0)
		SetVehicleFullbeam(vehicleHandle, false)
		SetVehicleBrakeLights(vehicleHandle, false)
		SetVehicleInteriorlight(vehicleHandle, false)
		SetVehicleIndicatorLights(vehicleHandle, 0, false)
		SetVehicleIndicatorLights(vehicleHandle, 1, false)
	end)
end

-- Workaround for silly bug smashing windows, and hold F to leave vehicle with engine running
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsTryingToEnter(playerPed)

		if DoesEntityExist(vehicle) then
			local lockStatus = GetVehicleDoorLockStatus(vehicle)
			local driverPed = GetPedInVehicleSeat(vehicle, -1)

			if lockStatus == 7 then SetVehicleDoorsLockedForAllPlayers(vehicle, true) end

			if driverPed then
				SetPedCanBeDraggedOut(driverPed, false)
			end

			if GetVehicleDoorsLockedForPlayer(vehicle, playerPed) then
				ESX.ShowNotification('This vehicle is locked')
				ClearPedTasks(playerPed)
			end
		end
	end
end)

RegisterNetEvent('rpuk_core:toggleVehicleLockOnEntityOwner')
AddEventHandler('rpuk_core:toggleVehicleLockOnEntityOwner', function(networkId)
	local vehicleHandle = NetworkGetEntityFromNetworkId(networkId)

	if GetVehicleDoorsLockedForPlayer(vehicleHandle, PlayerPedId()) then -- is locked
		SetVehicleDoorsLockedForAllPlayers(vehicleHandle, false)
	else -- is unlocked
		SetVehicleDoorsLockedForAllPlayers(vehicleHandle, true)
	end

	asyncPlayVehicleLockLights(vehicleHandle)
end)