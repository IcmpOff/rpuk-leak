ESX.RegisterServerCallback('rpuk_clothing:purchase', function(source, cb, location, gender, drawable, texture)
	local xPlayer = ESX.GetPlayerFromId(source)

	local wardrobe_data = json.decode(xPlayer.wardrobe)
	for index, data in pairs(wardrobe_data[location.category]) do
		if data == drawable .. ":" .. texture then
			xPlayer.showAdvancedNotification('Clothing Transaction', 'Transaction Failed', 'You already have this item of clothing!' , 'CHAR_BANK_FLEECA', 0)
			cb(false)
			return -- go no further // stops the event here
		end
	end

	local price = ds[location.category][gender][drawable].price
	local item_label = ds[location.category][gender][drawable].arrays[texture].label
	if ds[location.category][gender][drawable].currency then
		local xItem = xPlayer.getInventoryItem(ds[location.category][gender][drawable].currency)
		if xItem.count >= price then
			xPlayer.removeInventoryItem(ds[location.category][gender][drawable].currency, price)
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = 'Clothing Saved!'})
			print("RPUK TRANSACTION: " .. xPlayer.identifier .. " Purchased [".. location.category .. " " .. drawable .. ":" .. texture .."] '" .. item_label .. "' for x" .. price .. " " .. ds[location.category][gender][drawable].currency)
			cb(true)
		else
			cb(false)
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = "Clothing Failed To Save! You don't have enough " .. xItem.label})
		end	
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price, ('%s (%s:%s) [%s]'):format('Clothing Purchase', tostring(drawable), tostring(texture), GetCurrentResourceName()))
			xPlayer.giveClothing(location.category, drawable, texture)
			xPlayer.showAdvancedNotification('Clothing Transaction', 'Transaction Successful', item_label .. ' Purchased!' , 'CHAR_BANK_FLEECA', 0)
			print("RPUK TRANSACTION: " .. xPlayer.identifier .. " Purchased [".. location.category .. " " .. drawable .. ":" .. texture .."] '" .. item_label .. "' for £" .. price)

			if location.sub_category == "reserved_bodyarmour" and drawable == 5 then
				xPlayer.setArmour(100)
			end

			cb(true)
		else
			cb(false)
			xPlayer.showAdvancedNotification('Clothing Transaction', 'Transaction Failed', 'Not enough money to purchase this item of clothing!' , 'CHAR_BANK_FLEECA', 0)
		end
	end
end)

ESX.RegisterServerCallback('rpuk_clothing:fetch_wardrobe', function(source, cb, category)
	local xPlayer = ESX.GetPlayerFromId(source)
	if category then -- partial data
		local wardrobe_data = json.decode(xPlayer.wardrobe)
		cb(wardrobe_data.category)
	else -- full data
		local wardrobe_data = json.decode(xPlayer.wardrobe)
		cb(wardrobe_data)
	end
end)