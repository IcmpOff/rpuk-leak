local currentCallers = {}

ESX.RegisterServerCallback('rpuk:search_player', function(source, callback, target)
	local xTarget = ESX.GetPlayerFromId(target)

	if xTarget then
		local xData = {
			blackMoney = xTarget.getAccount('black_money'),
			cash = xTarget.getMoney(),
			items = xTarget.inventory,
			weapons = xTarget.getLoadout(),
			ammo = xTarget.getAmmo()
		}
		callback(xData)
	end
end)

RegisterNetEvent('rpuk_restrain:putInVehicle')
AddEventHandler('rpuk_restrain:putInVehicle', function(target, seatNumber)
	TriggerClientEvent('rpuk_restrain:putplayerInVehicle', target, seatNumber)
end)

RegisterNetEvent('rpuk_restrain:OutVehicle')
AddEventHandler('rpuk_restrain:OutVehicle', function(target, seatNumber)
	TriggerClientEvent('rpuk_restrain:removefromVehicle', target, seatNumber)
end)

RegisterNetEvent('rpuk_restrain:animation')
AddEventHandler('rpuk_restrain:animation', function(target)
	local targetPlayer = ESX.GetPlayerFromId(target)

	TriggerClientEvent('rpuk_restrain:arrested', targetPlayer.source, source)
	TriggerClientEvent('rpuk_restrain:arrest', source)
end)

RegisterNetEvent('rpuk_restrain:handcuff')
AddEventHandler('rpuk_restrain:handcuff', function(target)
	TriggerClientEvent('rpuk_restrain:handcuff', target)
end)

RegisterNetEvent('rpuk_restrain:lockpickhandcuff')
AddEventHandler('rpuk_restrain:lockpickhandcuff', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local lockpick = xPlayer.getInventoryItem("lockpick")
	local advancedLockpick = xPlayer.getInventoryItem("advanced_lockpick")

	if lockpick.count <= 0 and advancedLockpick.count <= 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "You do not have any lockpicks" })
		return
	end

	if lockpick.count >= 1 then
		xPlayer.removeInventoryItem("lockpick", 1)
		TriggerClientEvent('rpuk_restain:pickLockProgress', _source, "lockpick")
		return
	end

	if advancedLockpick.count >= 1 then
		xPlayer.removeInventoryItem("advanced_lockpick", 1)
		TriggerClientEvent('rpuk_restain:pickLockProgress', _source, "advanced_lockpick")
		return
	end

end)

RegisterNetEvent('rpuk_restrain:checkForKnife')
AddEventHandler('rpuk_restrain:checkForKnife', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local loadout = xPlayer.getLoadout()
	local hasKnife = loadout["WEAPON_KNIFE"]
	local hasSwitchlade = loadout["WEAPON_SWITCHBLADE"]
	local hasMachete = loadout["WEAPON_MACHETE"]
	local weapon = ''
	if hasSwitchlade then
		weapon = "WEAPON_SWITCHBLADE"
	elseif hasKnife then
		weapon = "WEAPON_KNIFE"
	elseif hasMachete then
		weapon = "WEAPON_MACHETE"
	end


	if hasKnife or hasSwitchlade or hasMachete  then
		TriggerClientEvent('rpuk_restrain:removeZiptieAnim', _source, weapon)
		Citizen.Wait(4000)
		TriggerClientEvent("rpuk_restrain:unrestrain", target)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "You do not have a knife" })
	end

end)

RegisterNetEvent('rpuk_restrain:ziptieCheck')
AddEventHandler('rpuk_restrain:ziptieCheck', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local targetPlayer = ESX.GetPlayerFromId(target)
	local item = xPlayer.getInventoryItem("ziptie")

	if item.count <= 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "You do not have any handcuffs" })
		return
	end

	if item.count >= 1 then
		xPlayer.removeInventoryItem("ziptie", 1)
		TriggerClientEvent('rpuk_restrain:ziptiedAnim', targetPlayer.source, source)
		TriggerClientEvent('rpuk_restrain:ziptieingAnim', source)
		Citizen.Wait(4300)
		TriggerClientEvent('rpuk_restrain:ziptied', target)
		Citizen.Wait(400)
		return
	end
end)

ESX.RegisterServerCallback('rpuk_restrain:getItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local xTarget = ESX.GetPlayerFromId(data.targetId)
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		if isInList(xPlayer.job.name, Config.AccessToSearchPlayer) then
			if type == "item_standard" then
				if xPlayer.canCarryItem(name, amount) then
					if xTarget.getInventoryItem(name).count >= amount then
						xPlayer.showNotification("You have taken x" .. amount .. " of " .. ESX.GetItemLabel(name), 2500, 'inform', 'longnotif')
						xTarget.showNotification("Person has taken x" .. amount .. " of " .. ESX.GetItemLabel(name), 2500, 'inform', 'longnotif')
						xTarget.removeInventoryItem(name, amount)
						xPlayer.addInventoryItem(name, amount)
						cbResult = true
					else
						xPlayer.showNotification("Targeted player does not have this many of the item", 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification("You can not carry this", 2500, 'error', 'longnotif')
				end
			elseif type == "item_account" then
				if xTarget.getAccount(name).money >= amount then
					xPlayer.showNotification("You have taken x" .. amount .. " of " .. itemData.item.label, 2500, 'inform', 'longnotif')
					xTarget.showNotification("Person has taken x" .. amount .. " of " .. itemData.item.label, 2500, 'inform', 'longnotif')
					xTarget.removeAccountMoney(name, amount, ('%s [%s]'):format('Money was seized', GetCurrentResourceName()))
					xPlayer.addAccountMoney(name, amount, "rpuk_restrain - Retrieved seized money")
					cbResult = true
				else
					xPlayer.showNotification("Person does not have this much money on them", 2500, 'error', 'longnotif')
				end
			elseif type == "item_ammo" then
				local targetAmmo = xTarget.getAmmo()[name]
				local sourceAmmo = xPlayer.getAmmo()[name]

				if targetAmmo.count >= amount then
					if sourceAmmo.count ~= sourceAmmo.max then
						if sourceAmmo.count + amount > sourceAmmo.max then
							amount = sourceAmmo.max - sourceAmmo.count
						end

						xPlayer.showNotification("You have taken x" .. amount .. " of " .. sourceAmmo.label, 2500, 'inform', 'longnotif')
						xTarget.showNotification("Person has taken x" .. amount .. " of " .. sourceAmmo.label, 2500, 'inform', 'longnotif')
						xTarget.removeWeaponAmmo(name, amount)
						xPlayer.addWeaponAmmo(name, amount)
						cbResult = true
					else
						xPlayer.showNotification("You are already full on this ammo", 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification("Person does not have this much ammo on them", 2500, 'error', 'longnotif')
				end
			elseif type == "item_weapon" then
				local weaponData = xTarget.getWeapon(name)

				if weaponData then
					if xPlayer.getWeapon(name) then
						xPlayer.showNotification("You already have this weapon on you", 2500, 'error', 'longnotif')
					else
						xPlayer.showNotification("You have taken " .. weaponData.label, 2500, 'inform', 'longnotif')
						xTarget.showNotification("Person has taken " .. weaponData.label, 2500, 'inform', 'longnotif')
						xTarget.removeWeapon(name)
						xPlayer.addWeapon(name)

						if next(weaponData.components) then
							for k,v in pairs(weaponData.components) do
								xPlayer.addWeaponComponent(name, v)
							end
						end

						cbResult = true
					end
				else
					xPlayer.showNotification("Player does not have this weapon on them", 2500, 'error', 'longnotif')
				end
			end

			xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", data, formatForSecondaryInventory(xTarget))
		else
			xPlayer.showNotification('You\'re not a cop!', 5000, 'error')
			print(('[rpuk_inventory] character id "%s" job "%s" denied "rpuk_restrain:getItem"'):format(xPlayer.getCharacterId(), xPlayer.job.name))
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

function formatForSecondaryInventory(xPlayer)
	local blackMoney = xPlayer.getAccount('black_money')
	local cash = xPlayer.getMoney()
	local accounts = {}
	local weapons = {}
	local ammo = {}

	if cash > 0 then
		table.insert(accounts, {
			count = cash,
			name = "money",
			label = "Cash"
		})
	end

	if blackMoney.money > 0 then
		table.insert(accounts, {
			count = blackMoney.money,
			name = blackMoney.name,
			label = blackMoney.label
		})
	end

	for k,v in pairs(xPlayer.getAmmo()) do
		if v.count > 0 then
			table.insert(ammo, {
				label = v.label,
				name = k,
				count = v.count
			})
		end
	end

	for k,v in pairs(xPlayer.getLoadout()) do
		table.insert(weapons, {
			count = 1,
			label = v.label,
			name = v.name
		})
	end

	return accounts, xPlayer.getInventory(), weapons, ammo
end

RegisterNetEvent('rpuk_restrain:drag')
AddEventHandler('rpuk_restrain:drag', function(target)
	local _source = source
	TriggerClientEvent('rpuk_restrain:drag', target, _source)
end)