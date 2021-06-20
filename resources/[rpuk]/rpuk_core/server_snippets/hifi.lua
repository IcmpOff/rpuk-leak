ESX.RegisterUsableItem('hifi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hifi', 1)
	TriggerClientEvent('esx_hifi:place_hifi', source)
end)

RegisterNetEvent('esx_hifi:remove_hifi')
AddEventHandler('esx_hifi:remove_hifi', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem('hifi', 1) then
		xPlayer.addInventoryItem('hifi', 1)
	end

	TriggerClientEvent('esx_hifi:stop_music', -1, coords)
end)


RegisterNetEvent('esx_hifi:play_music')
AddEventHandler('esx_hifi:play_music', function(id, coords)
	TriggerClientEvent('esx_hifi:play_music', -1, id, coords)
end)

RegisterNetEvent('esx_hifi:stop_music')
AddEventHandler('esx_hifi:stop_music', function(coords)
	TriggerClientEvent('esx_hifi:stop_music', -1, coords)
end)

RegisterNetEvent('esx_hifi:setVolume')
AddEventHandler('esx_hifi:setVolume', function(volume, coords)
	TriggerClientEvent('esx_hifi:setVolume', -1, volume, coords)
end)