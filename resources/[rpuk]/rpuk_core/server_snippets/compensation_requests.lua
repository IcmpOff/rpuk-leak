local transacting = {}
local account_string = {
	["account_cash"] = {"Clean Cash", "money"},
	["account_bank"] = {"Bank Transfer", "bank"},
	["account_dirty"] = {"Dirty Cash", "black_money"},
}

ESX.RegisterServerCallback('rpuk:compdata', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		MySQL.Async.fetchAll('SELECT * FROM comp_requests WHERE identifier=@identifier AND claimed_flag = 0', {
			['@identifier'] = xPlayer.identifier
		}, function(uf_result)
			local fn_result = {}
			if uf_result[1] then
				for k, v in pairs(uf_result) do
					if v.rpuk_charid == xPlayer.rpuk_charid or v.rpuk_charid == -1 then
						local comp_data = ""
						for i, c in pairs(json.decode(v.comp_data)) do
							if string.match(string.lower(i), "account_") then
								comp_data = ('%s %s (£%s), '):format(comp_data, account_string[i][1], c)
							else
								comp_data = ('%s %s (x%s), '):format(comp_data, ESX.GetItems()[i].label, c)
							end
						end
						table.insert(fn_result, {id = v.id, itm_string = comp_data, com_note = v.public_note, com_date = ConvertTime(v.insert_time)})
					end
				end
			end
			cb(fn_result)
		end)
	end
end)

RegisterNetEvent('rpuk:compclaim')
AddEventHandler('rpuk:compclaim', function(claim_id)
	local xSource = source
	if transacting[xSource] then
		return -- stop them, they are already using this event call
	else
		transacting[xSource] = true
	end
	if type(claim_id) ~= "number" then
		transacting[xSource] = nil
		return -- invalid data type passed to server
	end

	local xPlayer = ESX.GetPlayerFromId(xSource)
	MySQL.Async.fetchAll('SELECT * FROM comp_requests WHERE identifier=@identifier AND id=@claim_id AND claimed_flag = 0', {
		['@identifier'] = xPlayer.identifier,
		['@claim_id'] = tonumber(claim_id),
	}, function(result)
		if result then
			MySQL.Async.execute('UPDATE comp_requests SET claimed_flag = 1, claimed_time = current_timestamp() WHERE id = @claim_id AND identifier=@identifier AND claimed_flag = 0', {
				['@claim_id'] = tonumber(claim_id),
				['@identifier'] = xPlayer.identifier,
			}, function(xRes)
				if xRes == 1 then
					for item, quantity in pairs(json.decode(result[1].comp_data)) do
						if string.match(string.lower(item), "account_") then
							xPlayer.addAccountMoney(account_string[item][2], quantity, ('%s (ID:%s) [%s]'):format('Compensation Claim', claim_id, GetCurrentResourceName()))
						elseif string.match(string.lower(item), "weapon_") then
							if not xPlayer.hasWeapon(item) then
								xPlayer.addWeapon(item, quantity)
							else
								TriggerClientEvent('mythic_notify:client:SendAlert', xSource, { length = 6000, type = 'inform', text = 'You already have a ' .. ESX.GetItems()[item].label .. ' failed to claim.'})
							end
						elseif string.match(string.lower(item), "ammo_") then
							local ammoString = string.sub(item, 6, -1)
							xPlayer.addWeaponAmmo(ammoString,quantity)
						else
							xPlayer.addInventoryItem(item, quantity)
						end
					end
					TriggerClientEvent('mythic_notify:client:SendAlert', xSource, { length = 6000, type = 'inform', text = 'Claimed compensation'})
					transacting[xSource] = nil
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', xSource, { length = 6000, type = 'inform', text = 'Something went wrong, please contact a member of staff if you believe this is a mistake.'})
					transacting[xSource] = nil
				end
			end)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xSource, { length = 6000, type = 'inform', text = 'Something went wrong, please contact a member of staff if you believe this is a mistake.'})
			transacting[xSource] = nil
		end
	end)
end)

function ConvertTime(Unix)
	local UnixConvert = tonumber(math.floor(Unix))
	local mil2sec = UnixConvert / 1000
	date = os.date("*t", mil2sec)
	local passback = date.day .. "-" .. date.month .. "-" .. date.year .. " " .. date.hour .. ":" .. date.min
	return passback
end