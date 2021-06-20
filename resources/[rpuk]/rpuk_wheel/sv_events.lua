function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

RegisterNetEvent('rpuk_playerMenu:showPlayers')
AddEventHandler('rpuk_playerMenu:showPlayers', function(target, name, job, grade, age)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Name: ".. firstToUpper(name) })
	TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Age: ".. age })
	TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Citizen ID: "..  xPlayer.rpuk_charid})
	TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Session ID: "..  xPlayer.source})

	if job == "ambulance" then
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Occupation: National Health Service" })
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
	elseif job == "police" then
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Occupation: Los Santos Police Service" })
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
	elseif job == "iopc" then
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Occupation: IOPC" })
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
	elseif job == "lost" or job == "nca"then
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Occupation: Unemployed" })
	elseif job == "gruppe6" then
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Occupation: Gruppe 6" })
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
	elseif job == "court" then
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Occupation: Los Santos Ministry Of Justice" })
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'info', text = "Occupation: ".. firstToUpper(job) })
	end

	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Name: ".. firstToUpper(name) })
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Age: ".. age })
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Citizen ID: "..  xPlayer.rpuk_charid})
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Session ID: "..  xPlayer.source})

	if job == "ambulance" then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: National Health Service" })
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
	elseif job == "police" then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: Los Santos Police Service" })
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
	elseif job == "iopc" then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: IOPC" })
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
	elseif job == "lost" or job == "nca"then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: Unemployed" })
	elseif job == "gruppe6" then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: Gruppe 6" })
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
	elseif job == "court" then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: Los Santos Ministry Of Justice" })
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: ".. firstToUpper(job) })
	end

end)

RegisterNetEvent('rpuk_playerMenu:checkTarget')
AddEventHandler('rpuk_playerMenu:checkTarget', function(target, name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(target)
	local job = xPlayer.job.name
	local grade = xPlayer.job.grade_label
	local itemData = xPlayer.getInventoryItem("idcard")
	if itemData.count >= 1 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Name: ".. firstToUpper(name) })
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Char ID: "..  xPlayer.rpuk_charid})
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Session ID: "..  xPlayer.source})

		if job == "ambulance" then
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: National Health Service" })
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
		elseif job == "police" then
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: Los Santos Police Service" })
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
		elseif job == "iopc" then
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: IOPC" })
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
		elseif job == "lost" or job == "nca" then
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: Unemployed" })
		elseif job == "gruppe6" then
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: Gruppe 6" })
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
		elseif job == "court" then
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: Los Santos Ministry Of Justice" })
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'info', text = "Occupation: ".. firstToUpper(job) })
		end
	end

end)

ESX.RegisterServerCallback('rpuk_wheel:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT rpuk_charid FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then
			MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE rpuk_charid = @rpukid',  {
				['@rpukid'] = result[1].rpuk_charid
			}, function(result2)
				cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
			end)
		else
			cb('unknown', false)
		end
	end)
end)

ESX.RegisterServerCallback('rpuk_wheel:getVehicleInfos', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT rpuk_charid FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE rpuk_charid = @rpukid',  {
				['@rpukid'] = result[1].rpuk_charid
			}, function(result2)

				retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname

				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)


-- ESX.RegisterServerCallback("rpuk_wheel:hasItem", function(target, cb, item, count)
-- 	local xPlayer = GetPlayerId(target)
-- 	local itemData = xPlayer.getInventoryItem(item)
-- 	if xPlayer then
-- 		if itemData.count >= count then
-- 			cb(true)
-- 		else
-- 			cb(false)
-- 		end
-- 	else
-- 		cb(false)
-- 	end
-- end)

