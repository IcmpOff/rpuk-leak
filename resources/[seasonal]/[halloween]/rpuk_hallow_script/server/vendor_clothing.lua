ESX.RegisterServerCallback('rpuk_halloween:clothing_purchase', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if price < 0 then
		print("Rejecting price of < 0 " .. xPlayer.identifier)
		return
	end

	local xItem = xPlayer.getInventoryItem("halloween_token")
	if xItem.count >= price then
		xPlayer.removeInventoryItem("halloween_token", price)
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = 'Clothing Saved!'})
		print("RPUK Halloween: " .. xPlayer.identifier .. " Purchased a halloween clothing item for " .. price)
		cb(true)
	else
		cb(false)
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = "Clothing Failed To Save! You don't have enough Halloween Tokens!"})
	end
end)

-- item store handled by rpuk_shops