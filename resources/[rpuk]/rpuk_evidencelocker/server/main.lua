lockers = {}
local currentCallers = {}

MySQL.ready(function()
	loadLockers()
end)

function loadLockers()
	for k,v in pairs(config.lockers) do
		local data = json.decode(MySQL.Sync.fetchAll("SELECT * FROM evidencelocker WHERE name = @id", {["@id"] = k})[1].data)
		lockers[k] = createStorage({
			items = data,
			id = k
		})
	end
end

RegisterNetEvent("rpuk_evidencelocker:openGrinder")
AddEventHandler("rpuk_evidencelocker:openGrinder", function(id, position)
	local _source = source

	TriggerClientEvent("rpuk_inventory:openSecondaryInventory", _source, {
		id = id,
		text = "Grinder",
		type = "rpuk_evidencelocker:grinder",
	})
end)

ESX.RegisterServerCallback('rpuk_evidencelocker:grinder:putItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local price = 0
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		for _,v in pairs(config.items) do
			if name == v.item then
				price = v.price
				break
			end
		end

		if type == "item_standard" then
			local item = xPlayer.getInventoryItem(name)

			if item.count >= amount then
				xPlayer.removeInventoryItem(name, amount)
				price = price*amount
				cbResult = true
			else
				xPlayer.showNotification('Not enough of selected item', 2500, 'error')
			end
		elseif type == "item_ammo" then
			local ammo = xPlayer.getAmmo()

			if ammo[name].count >= amount then
				xPlayer.removeWeaponAmmo(name, amount)
				price = price*amount
				cbResult = true
			else
				xPlayer.showNotification('Not enough of selected ammo', 2500, 'error')
			end
		elseif type == "item_weapon" then
			local uppername = string.upper(name)

			for _,v in pairs(config.items) do
				if uppername == v.item then
					price = v.price
					break
				end
			end

			if xPlayer.hasWeapon(uppername) then
				xPlayer.removeWeapon(uppername)
				cbResult = true
			else
				xPlayer.showNotification('You do not have this weapon', 2500, 'error')
			end
		elseif type == "item_account" then
			local money = xPlayer.getAccount(name).money

			if name == "money" then
				xPlayer.showNotification('You can not grind this type', 2500, 'error')
			end

			if money >= amount then
				xPlayer.removeAccountMoney(name, amount, ('%s [%s]'):format('Evidence Grinder', GetCurrentResourceName()))
				price = amount*0.7
				cbResult = true
			else
				xPlayer.showNotification('You dont have enough of selected money', 2500, 'error')
			end
		end

		if cbResult then
			local fundName = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
				["@job"] = data.id
			})[1]

			if fundName then
				xPlayer.showNotification("You have increased your fund by £"..ESX.Math.GroupDigits(math.floor(price)), 4000, 'inform')

				MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
					["@fund"] = price+fundName.fund,
					["@job"] = data.id
				})

				TriggerEvent("rpuk_factions:dbLog", data.id, xPlayer.identifier, "fund", xPlayer.job.grade_label.. " " .. xPlayer.firstname .. " " .. xPlayer.lastname, name..''..amount, "+"..ESX.Math.GroupDigits(math.floor(price)), xPlayer.rpuk_charid)
			end
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

RegisterNetEvent("rpuk_evidencelocker:openLocker")
AddEventHandler("rpuk_evidencelocker:openLocker", function(id, position, restictedByItem)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if restictedByItem then
		local item = xPlayer.getInventoryItem(restictedByItem)
		if item.count <= 0 then
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "You do not have a "..ESX.GetItemLabel(restictedByItem)})
			return
		end
	end
	TriggerClientEvent("rpuk_inventory:openSecondaryInventory", _source, lockers[id].formatForSecondInventory(position))
end)

ESX.RegisterServerCallback('rpuk_evidencelocker:putItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local label

	if not currentCallers[playerId] then
		currentCallers[playerId] = true
		local success1, message1 = lockers[data.id].canDeposit(xPlayer.job, data.positionId)

		if success1 then
			if type == "item_standard" then
				local item = xPlayer.getInventoryItem(name)

				if item.count >= amount then
					local success, message = lockers[data.id].addItem(name, amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.removeInventoryItem(name, amount)
						label = ESX.GetItemLabel(name)
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('Not enough of selected item in inventory', 2500, 'error', 'longnotif')
				end
			elseif type == "item_ammo" then
				local ammo = xPlayer.getAmmo()[name]

				if ammo.count >= amount then
					local success, message = lockers[data.id].addAmmo(name, amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.removeWeaponAmmo(name, amount)
						label = name.." Ammo"
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You do not have enough of ammo type', 2500, 'error', 'longnotif')
				end
			elseif type == "item_weapon" then
				if xPlayer.hasWeapon(name) then
					local success, message = lockers[data.id].addWeapon(name, 1)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.removeWeapon(name)
						label = ESX.GetWeaponLabel(name)
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You do not have this weapon on you', 2500, 'error', 'longnotif')
				end
			elseif type == "item_account" then
				local money = xPlayer.getAccount(name).money

				if money >= amount then
					local success, message = lockers[data.id].addAccountMoney(name, amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.removeAccountMoney(name, amount, ('%s [%s]'):format('Group Storage', GetCurrentResourceName()))
						label = name
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You dont have enough of selected money', 2500, 'error', 'longnotif')
				end
			end
		else
			xPlayer.showNotification(message1, 2500, 'error', 'longnotif')
		end
	end

	if label then
		TriggerEvent("rpuk_factions:dbLog", xPlayer.job.name, xPlayer.identifier, "storage", xPlayer.job.grade_label.. " " .. xPlayer.firstname .. " " .. xPlayer.lastname, label, "+"..amount, xPlayer.rpuk_charid)
		xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", lockers[data.id].formatForSecondInventory(data.positionId))
	end

	currentCallers[playerId] = nil
	cb(label and true or false)
end)

ESX.RegisterServerCallback('rpuk_evidencelocker:getItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local label

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		local success1, message1 = lockers[data.id].canWithdraw(xPlayer.job, data.positionId)

		if success1 then
			if type == "item_standard" then
				if xPlayer.canCarryItem(name, amount) then
					local success, message = lockers[data.id].removeItem(name, amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.addInventoryItem(name, amount)
						label = ESX.GetItemLabel(name)
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You do not have enough room in your inventory', 2500, 'error', 'longnotif')
				end
			elseif type == "item_ammo" then
				local ammo = xPlayer.getAmmo()[name]

				if ammo.count+amount > config.ammoTypes[name].max then
					amount = config.ammoTypes[name].max - ammo.count
				end

				if amount > 0 then
					local success, message = lockers[data.id].removeAmmo(name, amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.addWeaponAmmo(config.ammoTypes[name].weaponHash, amount)
						label = name.." Ammo"
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You are already full on this ammo type', 2500, 'error', 'longnotif')
				end
			elseif type == "item_weapon" then
				if xPlayer.hasWeapon(name) then
					xPlayer.showNotification('You already have this weapon on you', 2500, 'error', 'longnotif')
				else
					local success, message = lockers[data.id].removeWeapon(name, 1)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.addWeapon(name)
						label = ESX.GetWeaponLabel(name)
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				end
			elseif type == "item_account" then
				local success, message = lockers[data.id].removeAccountMoney(name, amount)

				if success then
					xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
					xPlayer.addAccountMoney(name, amount, ('%s [%s]'):format('Group Locker', GetCurrentResourceName()))
					label = name
				else
					xPlayer.showNotification(message, 2500, 'error', 'longnotif')
				end
			end
		else
			xPlayer.showNotification(message1, 2500, 'error', 'longnotif')
		end
	end

	if label then
		TriggerEvent("rpuk_factions:dbLog", xPlayer.job.name, xPlayer.identifier, "storage", xPlayer.job.grade_label.. " " .. xPlayer.firstname .. " " .. xPlayer.lastname, label, "-"..amount, xPlayer.rpuk_charid)
		xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", lockers[data.id].formatForSecondInventory(data.positionId))
	end

	currentCallers[playerId] = nil
	cb(label and true or false)
end)