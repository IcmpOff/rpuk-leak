RegisterNetEvent("rpuk_mining:mine")
RegisterNetEvent("rpuk_mining:doneMining")

AddEventHandler("rpuk_mining:mine", function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local stats = json.decode(xPlayer.progressdata)
	local ore = Config.Mining.ores[item]

	if xPlayer.getInventoryItem("mining_drill").count <= 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "Missing tools for the job. Go to the hardware store" })
		return
	end

	if not xPlayer.canSwapItems(ore.returnedItems, ore.removedItems) then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "Item to heavy" })
		return
	end

	if stats[ore.skill] == nil then
		xPlayer.increaseStat(ore.skill, 0)
		stats[ore.skill] = 0
	end
	local stat = stats[ore.skill]

	if stat < ore.requiredSkill then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "Required mining skill: " .. ore.requiredSkill })
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "Current mining skill: " .. stat })
		return
	end

	local time = (stat == 0 and ore.time or (1-(0.1*stat))*ore.time)

	TriggerClientEvent("rpuk_mining:mine", _source, item, time)
end)

AddEventHandler("rpuk_mining:doneMining", function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local ore = Config.Mining.ores[item]

	if not xPlayer.canSwapItems(ore.returnedItems, ore.removedItems) then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "Item to heavy" })
		return
	end

	if ore.removedItems then
		for _,v in pairs(ore.removedItems) do
			local tempItem = xPlayer.getInventoryItem(v.name)
			if tempItem.count >= v.count then
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "Not enough of item: " .. tempItem.label })
				return
			end
		end
	end

	if ore.skills then
		if ore.skills.increase then
			for k,v in pairs(ore.skills.increase) do
				local stat = json.decode(xPlayer.progressdata)[k]
				if stat >= Config.Mining.maxSkill and v >= 0 then
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "Max mining skill" })
				elseif stat+v <= Config.Mining.maxSkill then
					xPlayer.increaseStat("pro_mining", v)
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "New mining skill level: " .. stat+v})
				elseif stat+v > Config.Mining.maxSkill then
					xPlayer.setStatData("pro_mining", 5)
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "New mining skill level: 5"})
				end
			end
		end
		if ore.skills.decrease then
			for k,v in pairs(ore.skills.decrease) do
				local stat = json.decode(xPlayer.progressdata)[k]
				if stat ~= 0 then
					if stat - v < 0 then
						xPlayer.setStatData(k, 0)
					else
						xPlayer.decreaseStat(k, v)
					end
				end
			end
		end
	end

	if ore.returnedItems then
		for _,v in pairs(ore.returnedItems) do
			xPlayer.addInventoryItem(v.name, v.count)
		end
	end
	if ore.removedItems then
		for _,v in pairs(ore.removedItems) do
			xPlayer.removeInventoryItems(v.name, v.count)
		end
	end
end)