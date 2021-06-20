local vehicleList, busySpawnPoints, lastPlayersOccupiedSpawnPointIndex = {}, {}, {}

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	xPlayer.triggerEvent('rpuk_mechanic:setBusySpawnPoints', busySpawnPoints)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	-- Release the spawn point index from being locked since the player left the server mid-job
	if lastPlayersOccupiedSpawnPointIndex[playerId] then
		local lastPlayerOccupiedSpawnPointIndex = lastPlayersOccupiedSpawnPointIndex[playerId]
		busySpawnPoints[lastPlayerOccupiedSpawnPointIndex] = nil
		lastPlayersOccupiedSpawnPointIndex[playerId] = nil

		TriggerClientEvent('rpuk_mechanic:setBusySpawnPoints', -1, busySpawnPoints)
	end
end)

-- Register the spawn point index and lock it so other players can't also have it
ESX.RegisterServerCallback('rpuk_mechanic:startPickupJob', function(playerId, cb, spawnPointIndex, vehiclePlate)
	if lastPlayersOccupiedSpawnPointIndex[playerId] then
		cb('You have already been assigned a job and can\'t have more than one active at a given time.')
	else
		if Config.Mechanic.npc_locations[spawnPointIndex] and not busySpawnPoints[spawnPointIndex] then
			busySpawnPoints[spawnPointIndex], lastPlayersOccupiedSpawnPointIndex[playerId] = true, spawnPointIndex
			TriggerClientEvent('rpuk_mechanic:setBusySpawnPoints', -1, busySpawnPoints)

			vehicleList[vehiclePlate] = {plate = vehiclePlate, type = 'npc'}
			TriggerClientEvent('rpuk_mechanic:newVehicleRegistered', playerId, vehiclePlate, Config.Mechanic.npc_locations[spawnPointIndex], 'npc')
			TriggerClientEvent('rpuk_mechanic:newVehicleAlert', playerId, vehiclePlate, Config.Mechanic.npc_locations[spawnPointIndex], 'npc')
			TriggerClientEvent('mythic_notify:client:SendAlert', playerId, {type = "success", text = "Added " .. vehiclePlate .. " to impound list"})

			cb()
		else
			cb('There is currently no jobs available, come back later!')
		end
	end
end)

--[[
RegisterNetEvent('rpuk_mechanic:x')
AddEventHandler('rpuk_mechanic:x', function(distance, ent_handle1, ent_handle2)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "mechanic" then
		if tostring(ent_handle1) == tostring(ent_handle2) then
			local randomAmount = math.random(2000,3000) + distance / 10
			local distanceCalc

			if distance <= 1000 then
				distanceCalc = distance / math.random(2,3)
			else
				distanceCalc = distance / math.random(10,20)
			end

			print("RPUK MECHANIC: " .. xPlayer.identifier .. " Completed a job, pay summary £" .. math.floor(randomAmount) .. " + Distance Bonus: £" .. math.floor(distanceCalc) .. " [" .. math.floor(randomAmount) + math.floor(distanceCalc) .."]" .. os.time())
			xPlayer.showAdvancedNotification('FLEECA BANK', "Transfer Summary", "Status: Complete\nJob Awarded: ~g~£" .. math.floor(randomAmount) .. "\n~s~Distance Bonus: ~g~£" .. math.floor(distanceCalc), 'CHAR_BANK_FLEECA', 9)
			xPlayer.addAccountMoney('bank', math.floor(randomAmount) + math.floor(distanceCalc), 'rpuk_mechanic: player has impounded a car')
		else
			print("RPUK MECHANIC: VEHICLE CHECK FAILED " .. xPlayer.identifier .. os.time())
		end
	else
		print("RPUK MECHANIC: JOB CHECK FAILED " .. xPlayer.identifier .. os.time())
		TriggerEvent('rpuk_anticheat:sab', xPlayer.source, "job_restricted")
	end
end)
]]

RegisterNetEvent('rpuk_mechanic:registerNewVehicle')
AddEventHandler('rpuk_mechanic:registerNewVehicle', function(plate, coords, type)
	local _source = source

	if not vehicleList[plate] then
		vehicleList[plate] = {
			plate = plate,
			type = type,
		}

		TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = "success", text = "Added " .. plate .. " to impound list"})

		if type == "npc" then
			TriggerClientEvent('rpuk_mechanic:newVehicleRegistered', _source, plate, coords, type)
			TriggerClientEvent('rpuk_mechanic:newVehicleAlert', _source, plate, coords, type)
		elseif type == "police" then
			TriggerClientEvent('rpuk_mechanic:newVehicleRegistered', -1, plate, coords, type)
			TriggerClientEvent('rpuk_mechanic:newVehicleAlert', -1, plate, coords, type)
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = "error", text = "Vehicle is already on impound list"})
		--Notify player it is already on the impound list
	end
end)

RegisterNetEvent('rpuk_mechanic:moneyAdd')
AddEventHandler('rpuk_mechanic:moneyAdd', function(plate, type)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local amount = 2500

	if xPlayer.job.name == "mechanic" then
		if vehicleList[plate] ~= nil then
			TriggerClientEvent("rpuk_mechanic:deleteVehicleBlip", -1, plate)
			if type == "police" then
				amount = amount*2
			end

			xPlayer.addAccountMoney('bank', amount, 'RPUK_Mechanic: Completed a mechanic job')
			TriggerClientEvent('mythic_notify:client:SendAlert', playerId, {type = "inform", text = "You have earned £".. ESX.Math.GroupDigits(amount) })
			vehicleList[plate] = nil

			if lastPlayersOccupiedSpawnPointIndex[playerId] then
				local lastPlayerOccupiedSpawnPointIndex = lastPlayersOccupiedSpawnPointIndex[playerId]
				busySpawnPoints[lastPlayerOccupiedSpawnPointIndex] = nil
				lastPlayersOccupiedSpawnPointIndex[playerId] = nil

				TriggerClientEvent('rpuk_mechanic:setBusySpawnPoints', -1, busySpawnPoints)
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', playerId, {type = "error", text = "Vehicle not on list"})
		end
	else
		print("RPUK MECHANIC: JOB CHECK FAILED " .. xPlayer.identifier .. os.time())
		TriggerEvent('rpuk_anticheat:sab', xPlayer.source, "job_restricted")
	end
end)

RegisterNetEvent('rpuk_mechanic:deleteBlip')
AddEventHandler('rpuk_mechanic:deleteBlip', function(plate)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = "inform", length = 5000, text = "Accepted job, now take it back to the impound lot"})
	TriggerClientEvent("rpuk_mechanic:deleteVehicleBlip", -1, plate)
end)

RegisterNetEvent('rpuk_mechanic:deleteJob')
AddEventHandler('rpuk_mechanic:deleteJob', function(plate)
	if vehicleList[plate] ~= nil then
		TriggerClientEvent("rpuk_mechanic:deleteVehicleBlip", -1, plate)
		vehicleList[plate] = nil
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = "error", text = "Vehicle not on list"})
	end
end)

ESX.RegisterServerCallback("rpuk_mechanic:getVehicleList", function(source, cb)
	cb(vehicleList)
end)