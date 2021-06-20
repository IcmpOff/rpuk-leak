pickups = {}
local currentId = 1
local currentCallers = {}
-- function loadAllPickups()
-- 	local result = MySQL.Sync.fetchAll("SELECT * FROM pickups")
-- 	for k,v in pairs(result) do
-- 		pickups[v.id] = createPickup(v, first)
-- 	end
-- 	TriggerClientEvent("rpuk_inventory:pickupsLoadedIn", -1, pickups)
-- end

-- Citizen.CreateThread(function()
-- 	loadAllPickups()
-- end)

RegisterNetEvent("rpuk_inventory:dropItem")
RegisterNetEvent("rpuk_inventory:openPickup")

AddEventHandler("rpuk_inventory:openPickup", function(id)
	local _source = source
	if pickups[id] then
		TriggerClientEvent("rpuk_inventory:openSecondaryInventory", _source, pickups[id].formatForSecondInventory())
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 4000, type = 'inform', text = 'Pickup is not there anymore'})
	end
end)

AddEventHandler("rpuk_inventory:dropItem", function(type, name, amount, tempCoords)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local coords = {
		x = ESX.Round(tempCoords.x, 2),
		y = ESX.Round(tempCoords.y, 2),
		z = ESX.Round(tempCoords.z, 2)-1
	}
	local distance, id = getClosestPickup(coords)
	local dropped = false
	if distance then
		if distance > 2 then
			pickups[currentId] = createPickup({
				pos = coords,
				id = currentId
			})
			id = currentId
			currentId = currentId+1
			TriggerClientEvent("rpuk_inventory:createPickup", -1, pickups[id])
		end
	else
		pickups[currentId] = createPickup({
			pos = coords,
			id = currentId
		})
		id = currentId
		currentId = currentId+1
		TriggerClientEvent("rpuk_inventory:createPickup", -1, pickups[id])
	end
	if type == "item_standard" then
		local itemData = xPlayer.getInventoryItem(name)
		if itemData.count >= amount then
			local success, message = pickups[id].addItem(name, amount)
			if success then
				xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
				dropped = true
			else
				xPlayer.showNotification(message, 2500, 'error', 'longnotif')
			end
			xPlayer.removeInventoryItem(name, amount)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 2000, type = 'error', text = "Not enough of selected item on you" })
		end
	elseif type == "item_weapon" then
		local weapon = xPlayer.getWeapon(name)
		if weapon then
			local success, message = pickups[id].addWeapon(name, 1, weapon.components)
			if success then
				xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
				dropped = true
			else
				xPlayer.showNotification(message, 2500, 'error', 'longnotif')
			end
			xPlayer.removeWeapon(name)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 2000, type = 'error', text = 'You do not have this weapon on you' })
		end
	elseif type == "item_ammo" then
		local ammo = xPlayer.getAmmo()[name]
		if ammo.count >= amount then
			local success, message = pickups[id].addAmmo(name, amount)
			if success then
				xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
				dropped = true
			else
				xPlayer.showNotification(message, 2500, 'error', 'longnotif')
			end
			xPlayer.removeWeaponAmmo(name, amount)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 2000, type = 'error', text = 'You do not have enough of this ammo on you' })
		end
	elseif type == "item_account" then
		local money = xPlayer.getAccount(name).money
		if money >= amount then
			local success, message = pickups[id].addAccountMoney(name, amount)
			if success then
				xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
				dropped = true
			else
				xPlayer.showNotification(message, 2500, 'error', 'longnotif')
			end
			xPlayer.removeAccountMoney(name, amount, ('%s [%s]'):format('Dropped money', GetCurrentResourceName()))
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 2000, type = 'error', text = 'You do not have enough of this money on you' })
		end
	end
	if dropped then
		TriggerClientEvent("rpuk_inventory:droppedItem", _source, type, name, amount, coords)
	else
		pickups[id].save()
	end
end)

function getClosestPickup(coords)
	local closestDist = nil
	local id = nil
	for _,v in pairs(pickups) do
		local dist = getDistance(coords, v.pos)
		if closestDist then
			if dist < closestDist then
				closestDist = dist
				id = v.id
			end
		else
			closestDist = dist
			id = v.id
		end
	end
	return closestDist, id
end

ESX.RegisterServerCallback('rpuk_inventory:pickup:getItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local id = data.id
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		if pickups[id] then
			if type == "item_standard" then
				if xPlayer.canCarryItem(name, amount) then
					local success, message = pickups[id].removeItem(name, amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.addInventoryItem(name, amount)
						cbResult = true
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You do not have enough room in your inventory', 2500, 'error', 'longnotif')
				end
			elseif type == "item_weapon" then
				if not xPlayer.hasWeapon(name) then
					local success, message = pickups[id].removeWeapon(name, 1, itemData.item.data.components)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.addWeapon(name)
						cbResult = true

						if itemData.item.data.components then
							for k,v in pairs(itemData.item.data.components) do
								xPlayer.addWeaponComponent(name, v)
							end
						end
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You already have this weapon on you', 2500, 'error', 'longnotif')
				end
			elseif type == "item_ammo" then
				local ammo = xPlayer.getAmmo()[name]
				if ammo.count+amount > ammoTypes[name].max then
					amount = ammoTypes[name].max - ammo.count
				end

				if amount > 0 then
					local success, message = pickups[id].removeAmmo(name, amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.addWeaponAmmo(name, amount)
						cbResult = true
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You are already full on this ammo type', 2500, 'error', 'longnotif')
				end
			elseif type == "item_account" then
				local success, message = pickups[id].removeAccountMoney(name, amount)

				if success then
					xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
					xPlayer.addAccountMoney(name, amount, ('%s [%s]'):format('Picked up money', GetCurrentResourceName()))
					cbResult = true
				else
					xPlayer.showNotification(message, 2500, 'error', 'longnotif')
				end
			end

			if pickups[id] then
				xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", pickups[id].formatForSecondInventory())
			else
				xPlayer.triggerEvent("rpuk_inventory:closeInventory")
			end
		else
			xPlayer.showNotification('Pickup does not exist', 2500, 'error', 'longnotif')
			xPlayer.triggerEvent("rpuk_inventory:closeInventory")
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

ESX.RegisterServerCallback('rpuk_inventory:pickup:putItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local id = data.id
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		if pickups[id] then
			if type == "item_standard" then
				local _itemData = xPlayer.getInventoryItem(name)

				if _itemData.count >= amount then
					local success, message = pickups[id].addItem(name, amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.removeInventoryItem(name, amount)
						cbResult = true
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('Not enough of selected item in inventory', 2500, 'error', 'longnotif')
				end
			elseif type == "item_weapon" then
				local weapon = xPlayer.getWeapon(name)
				if weapon then
					local success, message = pickups[id].addWeapon(name, 1, weapon.components)
					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.removeWeapon(name)
						cbResult = true
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You do not have this weapon on you', 2500, 'error', 'longnotif')
				end
			elseif type == "item_ammo" then
				local ammo = xPlayer.getAmmo()[name]
				if ammo.count >= amount then
					local success, message = pickups[id].addAmmo(name, amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.removeWeaponAmmo(name, amount)
						cbResult = true
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You do not have enough of ammo type', 2500, 'error', 'longnotif')
				end
			elseif type == "item_account" then
				local money = xPlayer.getAccountBalance(name)

				if money >= amount then
					local success, message = pickups[id].addAccountMoney(name, amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.removeAccountMoney(name, amount, ('%s [%s]'):format('Dropped money', GetCurrentResourceName()))
						cbResult = true
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You dont have enough of selected money', 2500, 'error', 'longnotif')
				end
			end

			if pickups[id] then
				xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", pickups[id].formatForSecondInventory())

				if cbResult then
					xPlayer.triggerEvent("rpuk_inventory:droppedItem", type, name, amount, coords)
				end
			else
				xPlayer.triggerEvent("rpuk_inventory:closeInventory")
			end
		else
			xPlayer.showNotification('Pickup does not exist', 2500, 'error', 'longnotif')
			xPlayer.triggerEvent("rpuk_inventory:closeInventory")
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

function getDistance(pos1, pos2)
	return math.sqrt((pos1.x-pos2.x)^2+(pos1.y-pos2.y)^2+(pos1.z-pos2.z)^2)
end

RegisterNetEvent("rpuk_inventory:clearAllPickups")
AddEventHandler("rpuk_inventory:clearAllPikcups", function()
	for k, v in pairs(pickups) do
		pickups[k].delete()
	end
end)