RegisterNetEvent('rpuk_barbers:buystyle')
AddEventHandler('rpuk_barbers:buystyle', function (price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price, ('%s [%s]'):format('Barber Style Purchase', GetCurrentResourceName()))
		TriggerClientEvent('esx_skin:openSaveableBarberRestrictedMenu', source)
	else
		TriggerClientEvent('esx:showNotification', _source, "Not enough money!")
	end
end)
