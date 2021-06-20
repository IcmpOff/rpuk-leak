-- Vehicle States {0=Unknown/Out, 1=Stored, 2=Mechanic Impound, 3=Police Impound, 4=Vehicle Shop}

-- Store Vehicle in a garage
RegisterNetEvent('rpuk_garages:storevehicle')
AddEventHandler('rpuk_garages:storevehicle', function(garageIndex, vdata)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = vdata.plate,
	}, function(rdata)
		if rdata[1] then
			rdata = rdata[1]
			local formatted_data = json.decode(rdata.vehicle)
			if vdata.model == formatted_data.model then
				formatted_data.engineHealth = vdata.engineHealth
				formatted_data.bodyHealth = vdata.bodyHealth
				formatted_data.fuelLevel = vdata.fuelLevel
				MySQL.Async.execute('UPDATE owned_vehicles SET state=@state, vehicle=@vehicle, location=@location WHERE plate=@plate', {
					['@state'] = 1,
					['@plate'] = vdata.plate,
					['@location'] = garageIndex,
					['@vehicle'] = json.encode(formatted_data),
				})

				TriggerEvent('rpuk_keys:removeKey', 'vehicle', vdata.plate, xPlayer.playerId)
			else
				TriggerClientEvent('rpuk_anticheat:saw', xPlayer.playerId, "vehmodelswitch")
			end
		else
			xPlayer.showAdvancedNotification('Garage & Car Parking', "Vehicle Record Not Found", vdata.plate, 'CHAR_CARSITE', 0)
		end
	end)
end)

-- Switch State
RegisterNetEvent('rpuk_garages:vehiclestate')
AddEventHandler('rpuk_garages:vehiclestate', function(plate, garage, state, clear_inventory)
	local ptime = (state == 3 and state) or os.time()

	MySQL.Async.execute('UPDATE owned_vehicles SET state=@state, location=@location, impound_time=@impound_time WHERE plate=@plate', {
		['@state'] = state,
		['@location'] = garage,
		['@plate'] = plate,
		['@impound_time'] = tonumber(ptime),
	})

	if clear_inventory then
		MySQL.Async.execute('UPDATE trunk_inventory SET data = @data WHERE plate = @plate', {
			['@data'] = "{}",
			['@plate'] = plate,
		})
	end
end)

RegisterNetEvent("rpuk_garages:applyMods")
AddEventHandler("rpuk_garages:applyMods", function(newVehicleProps)
	local playerId = source

	if string.find(newVehicleProps.plate, " ") then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
			['@plate'] = newVehicleProps.plate,
		}, function(result)
			if result[1] then
				local vehicleProps = json.decode(result[1].vehicle)

				if newVehicleProps.model == vehicleProps.model then
					MySQL.Async.execute('UPDATE owned_vehicles SET state = @state, vehicle = @vehicle, location = @location WHERE plate = @plate', {
						['@state'] = result[1].state, -- old state
						['@plate'] = result[1].plate, -- old plate
						['@location'] = result[1].location, -- old location
						['@vehicle'] = json.encode(newVehicleProps)
					})
				else
					TriggerClientEvent('rpuk_anticheat:saw', playerId, "vehmodelswitch")
				end
			end
		end)
	end
end)

-- Retrieve vehicle list
ESX.RegisterServerCallback('rpuk_garage:retrievegarage', function(playerId, cb, state, garageIndex, vehicleType)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if state == "insurance" then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE rpuk_charid = @rpukid AND state = 0', {
			['@rpukid'] = xPlayer.rpuk_charid,
		}, function(result)
			cb(result)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE rpuk_charid = @rpukid AND location = @location AND state = @state AND type = @type', {
			['@rpukid'] = xPlayer.rpuk_charid,
			['@location'] = garageIndex,
			['@state'] = tonumber(state),
			['@type'] = vehicleType
		}, function(data)
			for k,v in ipairs(data) do
				if v.impound_time and v.impound_time > 0 then
					local minutes = math.floor((os.time() - v.impound_time) / 300) -- fee increases every 300 seconds / 5 mins

					if minutes > 500 then minutes = 500 end -- max pay value = 500 * pound multiplier = fee

					v.impound_time = minutes
				end
			end

			cb(data)
		end)
	end
end)

-- Retrieve gang shared garage
ESX.RegisterServerCallback('rpuk_garage:retrieveGangGarage', function(playerId, cb, state, location, vehicleType)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local gang_id, gang_rank = xPlayer.getGang()
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE job = @job AND state = 1 OR location = @location AND state = 1', {
		['@job'] = "gang:" .. tostring(gang_id),
		['@location'] = tostring(location),
	}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('rpuk_garage:payfee', function(playerId, cb, fee)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.getMoney() >= fee then
		xPlayer.removeMoney(fee, ('%s [%s]'):format('Garaging / Impound Fee', GetCurrentResourceName()))
		cb(true)
	elseif xPlayer.getAccount('bank').money >= fee then
		xPlayer.removeAccountMoney('bank', fee, ('%s [%s]'):format('Garaging / Impound Fee', GetCurrentResourceName()))
		cb(true)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { length = 8000, type = 'error', text = "Claim FAILED due to insufficient funds "})
		cb(false)
	end
end)