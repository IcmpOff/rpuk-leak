RegisterNetEvent('rpuk_factions:returnVehicle')
AddEventHandler('rpuk_factions:returnVehicle', function(job)
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	local myModel = GetEntityModel(vehicle)
	local deletedVehicle = false

	for k,v in pairs(VehicleList.AssignedVehicles[job]) do
		local storeModel = GetHashKey(v.model)

		if storeModel == myModel then
			local vehiclePlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
			ESX.Game.DeleteEntity(vehicle)
			deletedVehicle = true
			TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'success', text = "Vehicle Stored!"})
			TriggerServerEvent("rpuk_factions:returnVehicle", myModel)
			TriggerServerEvent('rpuk_keys:removeKey', 'vehicle', vehiclePlate)
			break
		end
	end

	if not deletedVehicle then ESX.ShowNotification('You can only return service vehicles') end
end)

RegisterNetEvent('rpuk_factions:openVehicleMenu')
AddEventHandler('rpuk_factions:openVehicleMenu', function(job, garageType)
	local elements = {}

	for _, v in pairs(VehicleList.AssignedVehicles[job]) do
		if v.type == garageType then
			if canFlagAccess(v.min_grade, v.needed_flags.flag_type, v.needed_flags.flags) then
				table.insert(elements, {label = ('%s (%s)'):format(v.vehicleName, v.label), model = v.model, value = v})
			end
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rent_veh', {
		title    = '',
		css 	 =  job,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value ~= nil then
			local playerPed = PlayerPedId()
			local playerCoords, playerHeading = GetOffsetFromEntityInWorldCoords(playerPed, 1.5, 5.0, 0.0), GetEntityHeading(playerPed)
			if ESX.Game.IsSpawnPointClear(playerCoords, 3.0) then
				ESX.TriggerServerCallback('rpuk_factions:payRentForCars', function(result)
					if result then
						ESX.Game.SpawnVehicle(data.current.model, playerCoords, playerHeading, function(vehicle)
							ESX.Game.SetVehicleProperties(vehicle, data.current.value.default_mods)
						end, data.current.value, {
							giveKeys = true
						})
						ESX.UI.Menu.CloseAll()
						elements = nil
					else
						TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'error', text = "Your fund does not have the money to pull this vehicle out." })
					end
				end, GetHashKey(data.current.model))
			else
				TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'You are too close to a vehicle.' })
			end
		end
	end, function(data, menu)
		elements = nil
		menu.close()
	end)
end)

function canFlagAccess(job_grade, flag_type, flag_array)
	local canAccess = false
	if ESX.Player.GetJobGrade() >= tonumber(job_grade) then
		if tablelength(flag_array) > 0 then
			for flag, level in pairs(flag_array) do
				ESX.PlayerData = ESX.GetPlayerData() -- todo fix

				-- todo fix
				if ESX.PlayerData[flag_type][flag] and tonumber(ESX.PlayerData[flag_type][flag]) >= tonumber(level) then
					canAccess = true
				end
			end
		else
			canAccess = true
		end
	end
	return canAccess
end

-- Temporary player command to allow them to self fix cars with stuck sirens
RegisterCommand("elsfix", function()
	local job = ESX.Player.GetJobName()
	if job == "police" or job == "ambulance" or job == "nca" or job == "gruppe6" then
		local playerPed = PlayerPedId()
		local currentVehicle = GetVehiclePedIsIn(playerPed)
		local myModel = GetEntityModel(currentVehicle)
		local playerCoords, playerHeading = GetEntityCoords(currentVehicle), GetEntityHeading(currentVehicle)
		local vehicleProps = ESX.Game.GetVehicleProperties(currentVehicle)
		for k, v in pairs(VehicleList.AssignedVehicles[job]) do
			if GetHashKey(v.model) == myModel then
				DeleteEntity(currentVehicle)
				local storedVeh
				ESX.Game.SpawnVehicle(myModel, playerCoords, playerHeading, function(vehicle)
					storedVeh = vehicle
					ESX.Game.SetVehicleProperties(vehicle, v.default_mods)
				end, vehicleProps, {
					giveKeys = true
				})
				Citizen.Wait(1000)
				if DoesEntityExist(storedVeh) then
					TaskWarpPedIntoVehicle(playerPed, storedVeh, -1)
				end
				break
			end
		end
	end
end, false)