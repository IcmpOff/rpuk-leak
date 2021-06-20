local restart_claimed = {}
RegisterNetEvent('rpuk_christmas:claim_gift')
AddEventHandler('rpuk_christmas:claim_gift', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		if restart_claimed[xPlayer.rpuk_charid] then
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'error', text = 'You have claimed your gift for today!' })
		else
			restart_claimed[xPlayer.rpuk_charid] = true
			xPlayer.addInventoryItem('christmas_token', 3)
			xPlayer.addInventoryItem('christmas_candycane', math.random(1,5))
			xPlayer.addInventoryItem('christmas_gingerbread', math.random(1,5))
			xPlayer.addInventoryItem('christmas_chocolate', math.random(1,5))			
		end		
	end	
end)