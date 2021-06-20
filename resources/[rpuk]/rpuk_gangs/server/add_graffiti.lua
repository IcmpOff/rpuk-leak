local limit = 0
ESX.RegisterUsableItem('graffiti_spraycan', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gang_id, gang_rank = xPlayer.getGang()
	if gang_id > 0 and gang_id < 7 then
		if limit < 20 then
			limit = limit + 1
			xPlayer.triggerEvent('rpuk_gangs:graffiti')
			xPlayer.removeInventoryItem("graffiti_spraycan", 1)
		else
			xPlayer.showNotification('City Graffiti Limit Reached!')
		end
	else
		xPlayer.showNotification("You don't know any Graffiti Art!")
	end
end)