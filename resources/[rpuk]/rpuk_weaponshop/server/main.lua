ESX.RegisterServerCallback("rpuk_weaponshop:validatePurchase", function(source, cb, cost, weaponName, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)

	if weaponName then
		if xPlayer.hasWeapon(weaponName) then
			if ammo then
				if pay(xPlayer, weaponName, cost) then
					xPlayer.addWeaponAmmo(weaponName, 30) -- TODO ammo shouldnt be hardcoded
					cb(nil)
				else
					cb('You couldn\'t afford to buy ammo for your weapon...')
				end
			else
				cb('Error 503')
			end
		else
			if pay(xPlayer, weaponName, cost) then
				xPlayer.addWeapon(weaponName, 30)
				cb(nil)
			else
				cb('You couldn\'t afford this weapon...')
			end
		end
	else
		if pay(xPlayer, 'armour', cost) then
			cb(nil)
		else
			cb('You couldn\'t afford this armour...')
		end
	end
end)

function pay(xPlayer, weaponName, cost)
	if xPlayer.getMoney() >= cost then
		xPlayer.removeMoney(cost, ('%s (%s) [%s]'):format('Weapon Shop Purchase', weaponName, GetCurrentResourceName()))
		return true
	elseif xPlayer.getAccount("bank")["money"] >= cost then
		xPlayer.removeAccountMoney("bank", cost, ('%s (%s) [%s]'):format('Weapon Shop Purchase', weaponName, GetCurrentResourceName()))
		return true
	else
		return false
	end
end