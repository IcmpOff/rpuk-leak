local veh_key_table = {}
local hou_key_table = {}

RegisterNetEvent('rpuk_keys:assign_new')
AddEventHandler('rpuk_keys:assign_new', function(key_type, handle)
	local xPlayer = ESX.GetPlayerFromId(source)
	local char_ident = xPlayer.rpuk_charid
	if key_type == "vehicle" then
		table.insert(veh_key_table[char_ident], handle)
	elseif key_type == "housing" then
		table.insert(hou_key_table[char_ident], handle)
	end
	TriggerClientEvent('rpuk_keys:assignKey', source, key_type, handle)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { length = 5000, type = 'inform', text = "You now have keys for ".. handle})
	print("Key Assigned: " .. key_type .. " to " .. char_ident .. "[" .. handle .. "]")
end)

RegisterNetEvent('rpuk_keys:give_key')
AddEventHandler('rpuk_keys:give_key', function(key_type, target, handle)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		local char_ident = xPlayer.rpuk_charid
		if key_type == "vehicle" then
			table.insert(veh_key_table[char_ident], handle)
		elseif key_type == "housing" then
			table.insert(hou_key_table[char_ident], handle)
		end
		TriggerClientEvent('rpuk_keys:assignKey', target, key_type, handle)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { length = 5000, type = 'inform', text = "You have given keys for ".. handle})
		TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 5000, type = 'inform', text = "You now have keys for ".. handle})
		print("Key Assigned: " .. key_type .. " to " .. char_ident .. "[" .. handle .. "]")
	end
end)

RegisterNetEvent('rpuk_keys:removeKey')
AddEventHandler('rpuk_keys:removeKey', function(key_type, handle, playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId or source)

	if key_type == 'vehicle' then
		if veh_key_table[xPlayer.getCharacterId()] then
			for k,v in ipairs(veh_key_table[xPlayer.getCharacterId()]) do
				if v == handle then
					table.remove(veh_key_table[xPlayer.getCharacterId()], k)
					xPlayer.triggerEvent('rpuk_keys:removeKey', key_type, handle)
					break
				end
			end
		end
	end
end)

ESX.RegisterServerCallback("rpuk_keys:keyTable", function(source, callback, key_type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local char_ident = xPlayer.rpuk_charid
	if key_type == "housing" then
		if not hou_key_table[char_ident] then
			hou_key_table[char_ident] = {}
		end
		callback(hou_key_table[char_ident])
	elseif key_type == "vehicle" then
		if not veh_key_table[char_ident] then
			veh_key_table[char_ident] = {}
		end
		callback(veh_key_table[char_ident])
	end
end)

RegisterNetEvent('rpuk_core:toggleVehicleLockOnEntityOwner')
AddEventHandler('rpuk_core:toggleVehicleLockOnEntityOwner', function(networkId)
	local entityHandle = NetworkGetEntityFromNetworkId(networkId)
	local entityOwner = NetworkGetEntityOwner(entityHandle)

	TriggerClientEvent('rpuk_core:toggleVehicleLockOnEntityOwner', entityOwner, networkId)
end)