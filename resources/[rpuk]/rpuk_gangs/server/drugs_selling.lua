ESX.RegisterServerCallback("rpuk_gangs:npc_interaction",function(source, cb, location, npc_type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not location or not npc_type then
		TriggerEvent('rpuk_anticheat:sab', xPlayer.source, "job_restricted")
		return
	end

	local saleResult = generateResult(xPlayer, location, npc_type)
	if saleResult == "sale" then
		local xDrug = randomDrug(xPlayer, location)
		if xDrug and xDrug.count > 0 then
			local val = math.random(Config.DrugTypes[xDrug.name].p1, Config.DrugTypes[xDrug.name].p2)
			if job_counts and job_counts.police + job_counts.gangs > 15 then val = val * Config.risk_multiply end
			local quant = 1
			if xDrug.count > 5 then quant = math.random(1,4) end
			xPlayer.removeInventoryItem(xDrug.name, quant)
			xPlayer.addMoney(quant * val, ('Drug Street Sale (x%s %s at %s for %s) [%s]'):format(quant, xDrug.name, quant * val, location, GetCurrentResourceName()))
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 5000, type = 'inform', text = ('You Sold x%s %s for £%s'):format(quant, xDrug.label, quant * val)})
		else
			saleResult = "noxdrug"
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 5000, type = 'error', text = "You don't have any drugs on you!"})
		end
	elseif saleResult == "danger_sale" then
		local xDrug = randomDrug(xPlayer, location)
		if xDrug and xDrug.count > 0 then
			local danger_sale = math.random(Config.DrugTypes[xDrug.name].p1, Config.DrugTypes[xDrug.name].p2) * Config.risk_multiply
			local val = math.random(Config.DrugTypes[xDrug.name].p1, Config.DrugTypes[xDrug.name].p2)
			if job_counts and job_counts.police + job_counts.gangs > 15 then val = val * Config.risk_multiply end
			local quant = 1
			if xDrug.count > 5 then quant = math.random(1,4) end
			xPlayer.removeInventoryItem(xDrug.name, quant)
			xPlayer.addMoney((quant * val) + danger_sale, ('Drug Street Sale (x%s %s at %s for %s) [%s]'):format(quant, xDrug.name, (quant * val) + danger_sale, location, GetCurrentResourceName()))
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 5000, type = 'inform', text = ('You Sold x%s %s for £%s (+£%s)'):format(quant, xDrug.label, quant * val, danger_sale)})
			saleResult = "sale"
		else
			saleResult = "noxdrug"
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 5000, type = 'error', text = "You don't have any drugs on you!"})
		end
	elseif saleResult == "police" then
		TriggerEvent('rpuk_alerts:sNotification', {notiftype = "drugsale"})
	elseif saleResult == "turf" then
		local xGang = getGangFromId(Config.StashHouses[location].controlled_by)
		if xGang then
			local xMembers = xGang.getMembers()
			for k, v in pairs(xMembers) do
				local xMember = ESX.GetPlayerFromCharId(tonumber(k))
				local gang_id, gang_rank = xPlayer.getGang() 
				if xMember then
					if xGang.hasPermission(gang_rank, "gang_fnc_phone") then
						TriggerEvent('gcPhone:_internalAddMessage', "Local Crew", xMember.phoneNumber, tostring(Config.Strings["turf_text"][math.random(1,4)]), 0, function(object)
							TriggerClientEvent('gcPhone:receiveMessage', xMember.source, object)
						end)
					end
				end
			end		
		end
	else -- will handle the none

	end
	cb(saleResult)
end)

