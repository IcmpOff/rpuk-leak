RegisterServerEvent("rpuk_factions:svSync")
AddEventHandler("rpuk_factions:svSync", function(UID, status)
	TriggerClientEvent("rpuk_factions:MDSync", -1, UID, status)
end)


RegisterNetEvent("rpuk_factions:checkForWarrant")
AddEventHandler("rpuk_factions:checkForWarrant", function(plate, displayOfVehicle)
	local _source = source
	if string.find(plate, " ") then
		MySQL.Async.fetchScalar('SELECT m.* FROM mdt_warrants m JOIN owned_vehicles o ON m.char_id = o.rpuk_charid WHERE plate = @plate AND actioned = 0 AND deleted = 0', {
			['@plate'] = plate
		}, function(warrants)
			if warrants then
				TriggerClientEvent("rpuk_factions:alertPoliceForWarrant", _source, plate, displayOfVehicle)
				return
			end
		end)
	end
end)

RegisterNetEvent("rpuk_factions:speedingFine")
AddEventHandler("rpuk_factions:speedingFine", function(data, speed, plate)
	local _source = source
	local amount = math.ceil(((speed-data.SpeedLimit) / 10) * 100)
	if string.find(plate, " ") then
		local result = MySQL.Sync.fetchAll('SELECT o.*, u.firstname, u.lastname FROM owned_vehicles o JOIN users u ON o.rpuk_charid = u.rpuk_charid WHERE plate = @plate', {
			['@plate'] = tostring(plate)
		})[1]

		local xTarget = ESX.GetPlayerFromCharId(result.charid)
		if xTarget then
			MySQL.Async.execute('INSERT INTO fines (identifier, rpuk_charid, biller_identifier,biller_rpuk_charid,name, biller_name, amount, reason) VALUES (@identifier, @rpuk_charid, @biller_identifier, @biller_rpuk_charid, @name, @biller_name, @amount, @reason)',{
				['@identifier']		= xTarget.identifier,
				['@rpuk_charid']		= result.rpuk_charid,
				['@biller_identifier']	= "N/A",
				['@biller_rpuk_charid']		= "0",
				['@name']	= xTarget.firstname.." "..xTarget.lastname,
				['@biller_name']	= "Automated Speed Ticket",
				['@amount']	= amount,
				['@reason']	= "Speeding in a "..data.SpeedLimit.." Zone. Driving "..(math.floor(speed-data.SpeedLimit)).." Miles Above the speed limit."
			}, function(result2)
				if result2 then
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 5000, type = 'inform', text = 'You have been caught speeding in a '..data.SpeedLimit..' zone. A Fine has been sent to the owner of the Plate: '..plate })
					print("Billed Player: " .. xTarget.firstname .. " " .. xTarget.lastname .. "[" .. xTarget.rpuk_charid .."] [AutoSpeed Ticket] FOR: £".. amount .. "")
				end
			end)
		else
			MySQL.Async.execute('INSERT INTO fines (identifier, rpuk_charid, biller_identifier,biller_rpuk_charid,name, biller_name, amount, reason) VALUES (@identifier, @rpuk_charid, @biller_identifier, @biller_rpuk_charid, @name, @biller_name, @amount, @reason)',{
				['@identifier']		= result.owner,
				['@rpuk_charid']		= result.rpuk_charid,
				['@biller_identifier']	= "N/A",
				['@biller_rpuk_charid']		= "0",
				['@name']	= result.firstname.." "..result.lastname,
				['@biller_name']	= "Automated Speed Ticket",
				['@amount']	= amount,
				['@reason']	= "Speeding in a "..data.SpeedLimit.." Zone. Driving "..(math.floor(speed-data.SpeedLimit)).." Miles Above the speed limit."
			}, function(result2)
				if result2 then
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 5000, type = 'inform', text = 'You have been caught speeding in a '..data.SpeedLimit..' zone. A Fine has been sent to the owner of the Plate: '..plate })
					print("Billed Player: " .. result.firstname .. " " .. result.lastname .. "[" .. result.rpuk_charid .."] [AutoSpeed Ticket] FOR: £".. amount .. "")
				end
			end)
		end
	end
end)