Citizen.CreateThread(function()
	for k,v in pairs(Config.Ammo) do
		ESX.RegisterUsableItem(v.name, function(playerId)
			TriggerClientEvent('rpuk_ammo:useAmmoItem', playerId, v)
		end)
	end
end)

RegisterNetEvent('rpuk_ammo:removeAmmoItem')
AddEventHandler('rpuk_ammo:removeAmmoItem', function(ammoItemName, ammoAmountToAdd, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem(ammoItemName).count > 0 then
		xPlayer.removeInventoryItem(ammoItemName, 1)
		xPlayer.addWeaponAmmo(weaponName, ammoAmountToAdd)
	end
end)