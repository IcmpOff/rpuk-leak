local currentCallers = {}
vehicles = {}

RegisterNetEvent("rpuk_trunk:loadTrunk")
AddEventHandler("rpuk_trunk:loadTrunk", function(plate, class)
	loadTrunk(plate, class)
end)

function loadTrunk(plate, class)
	if vehicles[plate] then return end

	local _source = source

	local result = MySQL.Sync.fetchAll("SELECT * FROM trunk_inventory WHERE plate = @plate", {
		["@plate"] = plate
	})[1]

	if result == nil then
		local temp = {
			plate = plate,
			owned = false,
			class = class
		}
		vehicles[plate] = createTrunk(temp)
	else
		result.owned = true
		result.owner = _source
		result.class = class

		vehicles[plate] = createTrunk(result)
	end
end

RegisterNetEvent("rpuk_trunk:openTrunk")
AddEventHandler("rpuk_trunk:openTrunk", function(plate, class)
	local _source = source

	if vehicles[plate] == nil then
		loadTrunk(plate, class)
	end

	TriggerClientEvent("rpuk_inventory:openSecondaryInventory", _source, vehicles[plate].formatForSecondInventory())
end)

ESX.RegisterServerCallback('rpuk_trunk:getItem', function(playerId, cb, itemType, name, amount, data, itemData)
	local plate = data.id
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		if itemType == "item_standard" then
			if xPlayer.canCarryItem(name, amount) then
				local success, message = vehicles[plate].removeItem(name, amount)

				if success then
					xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
					xPlayer.addInventoryItem(name, amount)
					cbResult = true
				else
					xPlayer.showNotification(message, 2500, 'error', 'longnotif')
				end
			else
				xPlayer.showNotification('You do not have enough inventory space', 2500, 'error', 'longnotif')
			end
		elseif itemType == "item_weapon" then
			if xPlayer.hasWeapon(name) then
				xPlayer.showNotification('You already have the same weapon', 2500, 'inform', 'longnotif')
			else
				local success, message = vehicles[plate].removeWeapon(name, 1, itemData.item.data.components)

				if success then
					xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
					xPlayer.addWeapon(name, 0)
					cbResult = true

					if itemData.item.data.components then
						for k,v in pairs(itemData.item.data.components) do
							xPlayer.addWeaponComponent(name, v)
						end
					end
				else
					xPlayer.showNotification(message, 2500, 'error', 'longnotif')
				end
			end
		elseif itemType == "item_ammo" then
			local ammo = xPlayer.getAmmo()[name]

			if ammo.count+amount > Config.ammoTypes[name].max then
				amount = Config.ammoTypes[name].max - ammo.count
			end

			if amount > 0 then
				local success, message = vehicles[plate].removeAmmo(name, amount)

				if success then
					xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
					xPlayer.addWeaponAmmo(Config.ammoTypes[name].weaponHash, amount)
					cbResult = true
				else
					xPlayer.showNotification(message, 2500, 'error', 'longnotif')
				end
			else
				xPlayer.showNotification('You are already full on this ammo type', 2500, 'error', 'longnotif')
			end
		elseif itemType == "item_account" then
			if name == "black_money" then
				local success, message = vehicles[plate].removeBlackMoney(amount)

				if success then
					xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
					xPlayer.addAccountMoney("black_money", amount, ('%s [%s]'):format('Trunk Storage', GetCurrentResourceName()))
					cbResult = true
				else
					xPlayer.showNotification(message, 2500, 'error', 'longnotif')
				end
			elseif name == "money" then
				local success, message = vehicles[plate].removeMoney(amount)

				if success then
					xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
					xPlayer.addAccountMoney("money", amount, ('%s [%s]'):format('Trunk Storage', GetCurrentResourceName()))
					cbResult = true
				else
					xPlayer.showNotification(message, 2500, 'error', 'longnotif')
				end
			end
		end
	end

	if cbResult then
		xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", vehicles[plate].formatForSecondInventory())
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

ESX.RegisterServerCallback('rpuk_trunk:putItem', function(playerId, cb, itemType, name, amount, data)
	local plate = data.id
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		if itemType == "item_standard" then
			local item = xPlayer.getInventoryItem(name)

			if item.count >= amount then
				local success, message = vehicles[plate].addItem(name, amount)

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
		elseif itemType == "item_weapon" then
			if xPlayer.hasWeapon(name) then
				local success, message = vehicles[plate].addWeapon(name, 1, xPlayer.getWeapon(name).components)

				if success then
					xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
					xPlayer.removeWeapon(name)
					cbResult = true
				else
					xPlayer.showNotification(message, 2500, 'error', 'longnotif')
				end
			else
				xPlayer.showNotification('You do not have this weapon on you', 2500, 'inform', 'longnotif')
			end
		elseif itemType == "item_ammo" then
			local ammo = xPlayer.getAmmo()[name]

			if ammo.count >= amount then
				local success, message = vehicles[plate].addAmmo(name, amount)

				if success then
					xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
					xPlayer.removeWeaponAmmo(name, amount)
					cbResult = true
				else
					xPlayer.showNotification(message, 2500, 'error', 'longnotif')
				end
			else
				xPlayer.showNotification('You do not have enough of the ammo type', 2500, 'error', 'longnotif')
			end
		elseif itemType == "item_account" then
			if name == "black_money" then
				local money = xPlayer.getAccountBalance('black_money')

				if money >= amount then
					local success, message = vehicles[plate].addBlackMoney(amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.removeAccountMoney("black_money", amount, ('%s [%s]'):format('Trunk Storage', GetCurrentResourceName()))
						cbResult = true
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You do not have enough dirty money', 2500, 'error', 'longnotif')
				end
			elseif name == "money" then
				local money = xPlayer.getAccountBalance('money')

				if money >= amount then
					local success, message = vehicles[plate].addMoney(amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.removeAccountMoney("money", amount, ('%s [%s]'):format('Trunk Storage', GetCurrentResourceName()))
						cbResult = true
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You do not have enough cash', 2500, 'error', 'longnotif')
				end
			end
		end

		if cbResult then
			xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", vehicles[plate].formatForSecondInventory())
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)