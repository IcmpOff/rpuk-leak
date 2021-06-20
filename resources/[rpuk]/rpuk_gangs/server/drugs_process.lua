ESX.RegisterServerCallback("rpuk_gangs:checkStage",function(source, cb, data, batch)
	local xPlayer = ESX.GetPlayerFromId(source)
    local allowed = true
	for k, v in pairs(data.item_array.input) do
		local item = xPlayer.getInventoryItem(k)
		if item.count < v then
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'error', text = "You don't have enough " .. item.label})
			allowed = false
			break
		end
	end
	cb(allowed)
end)

RegisterNetEvent('rpuk_gangs:item_remove')
AddEventHandler("rpuk_gangs:item_remove", function(data, batch)
	local xPlayer = ESX.GetPlayerFromId(source)
    for k, v in pairs(data.item_array.input) do
		local item = xPlayer.getInventoryItem(k)
		if item.count < v * batch then
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'error', text = "You don't have enough " .. item.label})
			return			
		end
	end
	for k, v in pairs(data.item_array.input) do
		local item = xPlayer.getInventoryItem(k)
		if item.count >= v * batch then
			xPlayer.removeInventoryItem(k, v * batch)
		end
	end
	for k, v in pairs(data.item_array.output) do
		xPlayer.addInventoryItem(k, v * batch)
	end	
end)

-- usable items

ESX.RegisterUsableItem("comp_drug_sativabud", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xBaggie = xPlayer.getInventoryItem("comp_drug_plasticbag")
	if xBaggie.count >= 1 then
		xPlayer.removeInventoryItem("comp_drug_plasticbag", 1)
		xPlayer.removeInventoryItem("comp_drug_sativabud", 1)
		xPlayer.addInventoryItem("drug_weed_sativa_bag", 1)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'error', text = "You do not have any plastic baggies!" })
	end
end)

ESX.RegisterUsableItem("comp_drug_indicabud", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xBaggie = xPlayer.getInventoryItem("comp_drug_plasticbag")
	if xBaggie.count >= 1 then
		xPlayer.removeInventoryItem("comp_drug_plasticbag", 1)
		xPlayer.removeInventoryItem("comp_drug_indicabud", 1)
		xPlayer.addInventoryItem("drug_weed_indica_bag", 1)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'error', text = "You do not have any plastic baggies!" })
	end
end)

ESX.RegisterUsableItem("comp_drug_cocaine_cut", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xBaggie = xPlayer.getInventoryItem("comp_drug_plasticbag")
	if xBaggie.count >= 1 then
		xPlayer.removeInventoryItem("comp_drug_plasticbag", 1)
		xPlayer.removeInventoryItem("comp_drug_cocaine_cut", 1)
		xPlayer.addInventoryItem("drug_cocaine_bag", 1)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'error', text = "You do not have any plastic baggies!" })
	end
end)

ESX.RegisterUsableItem("drug_weed_sativa_bag", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("drug_weed_sativa_bag", 1)
	TriggerClientEvent('rpuk_gangs:useDrug', "drug_weed_sativa_bag")
end)

ESX.RegisterUsableItem("drug_weed_indica_bag", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("drug_weed_indica_bag", 1)
	TriggerClientEvent('rpuk_gangs:useDrug', "drug_weed_indica_bag")
end)

ESX.RegisterUsableItem("drug_cocaine_bag", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("drug_cocaine_bag", 1)
	TriggerClientEvent('rpuk_gangs:useDrug', "drug_cocaine_bag")
end)