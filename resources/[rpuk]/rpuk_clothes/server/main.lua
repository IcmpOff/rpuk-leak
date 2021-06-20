RegisterNetEvent('rpuk_clothes:buyclothes')
AddEventHandler('rpuk_clothes:buyclothes', function (price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price, ('%s [%s]'):format('Old Clothing Purchase', GetCurrentResourceName()))
		TriggerClientEvent('esx_skin:openSaveableRestrictedMenu', source)
	else
		TriggerClientEvent('esx:showNotification', _source, "Not enough money!")
	end
end)
