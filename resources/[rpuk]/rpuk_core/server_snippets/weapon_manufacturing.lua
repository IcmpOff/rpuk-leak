RegisterNetEvent('rpuk_weapons:produceWeapon') --This is a little clunky but my brain stopped working
AddEventHandler('rpuk_weapons:produceWeapon', function(type, index)
	local xPlayer = ESX.GetPlayerFromId(source)
	local partsNeeded = 0
	local hasParts = 0
	for index, data in pairs(Weapons[type][index].parts) do
		partsNeeded = partsNeeded + data.amount
		if data.type == "item" then
			if xPlayer.getInventoryItem(data.item).count >= data.amount then
				hasParts = hasParts + data.amount
			end
		elseif data.type == "weapon" then
			if xPlayer.hasWeapon(data.item) then
				hasParts = hasParts + 1
			end
		end
	end
	if partsNeeded == hasParts then
		for index, data in pairs(Weapons[type][index].parts) do
			if data.type == "item" then
				xPlayer.removeInventoryItem(data.item, data.amount)
			elseif data.type == "weapon" then
				xPlayer.removeWeapon(data.item)
			end
		end
		xPlayer.addWeapon(Weapons[type][index].weapon_name, 100)
		xPlayer.showAdvancedNotification('Tool Bench', "Weapon Production", "You have produced a "..Weapons[type][index].name, 'CHAR_LESTER_DEATHWISH', 0)
		print("[Tool Bench] ".. xPlayer.getIdentifier() .. " produced a "..Weapons[type][index].name)
	else
		xPlayer.showAdvancedNotification('Tool Bench', "Weapon Production", "You don't have the correct parts to produce a "..Weapons[type][index].name, 'CHAR_LESTER_DEATHWISH', 0)
	end
end)

RegisterNetEvent('rpuk_weapons:produceAmmo')
AddEventHandler('rpuk_weapons:produceAmmo', function(type, index)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.hasWeapon(Weapons[type][index].weapon_name) then
		if xPlayer.getInventoryItem("gunpowder").count >= Weapons[type][index].gunpowder then
			xPlayer.addWeaponAmmo(Weapons[type][index].weapon_name, 50)
			xPlayer.removeInventoryItem("gunpowder", Weapons[type][index].gunpowder)
			xPlayer.showAdvancedNotification('Tool Bench', "Ammo Production", "You have produced 50 rounds for that weapon!", 'CHAR_LESTER_DEATHWISH', 0)
			print("[Tool Bench] ".. xPlayer.getIdentifier() .. " produced ammo for a "..Weapons[type][index].name)
		else
			xPlayer.showAdvancedNotification('Tool Bench', "Ammo Production", "You don't have enough gunpowder on you!", 'CHAR_LESTER_DEATHWISH', 0)
		end
	else
		xPlayer.showAdvancedNotification('Tool Bench', "Weapon Production", "You don't have the weapon you tried to make ammo for on you!", 'CHAR_LESTER_DEATHWISH', 0)
	end
end)