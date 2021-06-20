RegisterNetEvent('rpuk_fuel:pay')
AddEventHandler('rpuk_fuel:pay', function(price, givePetrolCan, givePetrolAmmo)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = ESX.Math.Round(price or 0)

	if price > 0 then
		if xPlayer.getAccountBalance('money') >= price then
			xPlayer.removeMoney(amount, ('%s [%s]'):format('Fuel Payment', GetCurrentResourceName()))
			local hasPetrolCan = xPlayer.hasWeapon('WEAPON_PETROLCAN')

			if givePetrolCan and not hasPetrolCan then
				xPlayer.addWeapon('WEAPON_PETROLCAN', 4500)
			elseif givePetrolAmmo and hasPetrolCan then
				xPlayer.setWeaponAmmo('WEAPON_PETROLCAN', 4500)
			end
		else
			xPlayer.removeMoney(xPlayer.getAccountBalance('money'), ('%s [%s]'):format('Fuel Payment', GetCurrentResourceName()))
		end
	end
end)