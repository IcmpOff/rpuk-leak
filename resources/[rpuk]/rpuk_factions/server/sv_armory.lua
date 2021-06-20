local currentCallers = {}

ESX.RegisterServerCallback('rpuk_factions_locker:getItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local price = Armory.AssignedLoadouts[data.id][itemData.item.data].price
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		local accountType = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
			["@job"] = xPlayer.job.name
		})[1]

		if type == "item_standard" then
			if
				(Config.checkLog[xPlayer.job.name].Fund and accountType.fund >= price*amount) or
				(not Config.checkLog[xPlayer.job.name].Fund and xPlayer.getMoney() >= price*amount)
			then
				if xPlayer.canCarryItem(name, amount) then
					price = price*amount
					if not Config.checkLog[xPlayer.job.name].Fund then
						xPlayer.removeAccountMoney("money", price, ('%s (%s) [%s]'):format('Purchased item from lockerroom', name, GetCurrentResourceName()))
					end
					xPlayer.addInventoryItem(name, amount)
					cbResult = true
				else
					xPlayer.showNotification('You do not have enough space in your inventory', 2500, 'error', 'longnotif')
				end
			else
				xPlayer.showNotification('Not enough money', 2500, 'error', 'longnotif')
			end
		elseif type == "item_weapon" then
			if
				(Config.checkLog[xPlayer.job.name].Fund and accountType.fund >= price*amount) or
				(not Config.checkLog[xPlayer.job.name].Fund and xPlayer.getMoney() >= price*amount)
			then
				if xPlayer.hasWeapon(name) then
					xPlayer.showNotification('You already have this weapon', 2500, 'error', 'longnotif')
				else
					price = price
					if not Config.checkLog[xPlayer.job.name].Fund then
						xPlayer.removeAccountMoney("money", price, ('%s (%s) [%s]'):format('Purchased item from lockerroom', name, GetCurrentResourceName()))
					end
					amount = 1
					xPlayer.addWeapon(name)
					cbResult = true
				end
			else
				xPlayer.showNotification('Not enough money', 2500, 'error', 'longnotif')
			end
		elseif type == "item_ammo" then
			local ammo = xPlayer.getAmmo()

			if ammo[name].count+amount > Config.ammoTypes[name].max then
				amount = Config.ammoTypes[name].max - ammo[name].count
			end

			if amount > 0 then
				if
					(Config.checkLog[xPlayer.job.name].Fund and accountType.fund >= price*amount) or
					(not Config.checkLog[xPlayer.job.name].Fund and xPlayer.getMoney() >= price*amount)
				then
					price = price*amount
					if not Config.checkLog[xPlayer.job.name].Fund then
						xPlayer.removeAccountMoney("money", price*amount, ('%s (%s) [%s]'):format('Purchased item from lockerroom', name, GetCurrentResourceName()))
					end
					xPlayer.addWeaponAmmo(name, amount)
					cbResult = true
				else
					xPlayer.showNotification('Not enough money', 2500, 'error', 'longnotif')
				end
			else
				xPlayer.showNotification('You already have max ammo', 2500, 'error', 'longnotif')
			end
		end

		if cbResult then
			db_log(xPlayer.job.name, xPlayer.identifier, "loadout", xPlayer.job.grade_label.. " " .. xPlayer.firstname .. " " .. xPlayer.lastname, Armory.AssignedLoadouts[data.id][itemData.item.data].label, "-"..amount, xPlayer.rpuk_charid)

			if Config.checkLog[xPlayer.job.name].Fund then
				if accountType then
					MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
						["@fund"] = accountType.fund-price,
						["@job"] = xPlayer.job.name
					})
					if price > 0 then
						db_log(xPlayer.job.name, xPlayer.identifier, "fund", xPlayer.job.grade_label.. " " .. xPlayer.firstname .. " " .. xPlayer.lastname, Armory.AssignedLoadouts[data.id][itemData.item.data].label, "-"..amount..' (£'..price..')', xPlayer.rpuk_charid)
					end
				end
			end
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

ESX.RegisterServerCallback('rpuk_factions_locker:putItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local price
	local label
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		for k,v in pairs(Armory.AssignedLoadouts[data.id]) do
			if name == v.item then
				price = v.price
				label = v.label
				break
			end
		end

		if price then
			if type == "item_standard" then
				local item = xPlayer.getInventoryItem(name)
				if item.count >= amount then
					xPlayer.removeInventoryItem(name, amount)
					price = price*amount
					cbResult = true
				else
					xPlayer.showNotification('Not enough of selected item', 2500, 'error', 'longnotif')
				end
			elseif type == "item_ammo" then
				local ammo = xPlayer.getAmmo()

				if ammo[name].count >= amount then
					xPlayer.removeWeaponAmmo(name, amount)
					price = price*amount
					cbResult = true
				else
					xPlayer.showNotification('Not enough of selected ammo', 2500, 'error', 'longnotif')
				end
			elseif type == "item_weapon" then
				if xPlayer.hasWeapon(name) then
					xPlayer.removeWeapon(name)
					price = price
					amount = 1
					cbResult = true
				else
					xPlayer.showNotification('You do not have this weapon', 2500, 'error', 'longnotif')
				end
			end
		else
			xPlayer.showNotification('You can not put this item in the armory', 2500, 'error', 'longnotif')
		end

		if cbResult then
			db_log(xPlayer.job.name, xPlayer.identifier, "loadout", xPlayer.job.grade_label.. " " .. xPlayer.firstname .. " " .. xPlayer.lastname, label, "+"..amount, xPlayer.rpuk_charid)

			if Config.checkLog[xPlayer.job.name].Fund then
				local accountType = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
					["@job"] = xPlayer.job.name
				})[1]

				if accountType then
					MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
						["@fund"] = price+accountType.fund,
						["@job"] = xPlayer.job.name
					})

					if price > 0 then
						db_log(xPlayer.job.name, xPlayer.identifier, "fund", xPlayer.job.grade_label.. " " .. xPlayer.firstname .. " " .. xPlayer.lastname, label, "+"..amount..' (£'..price..')', xPlayer.rpuk_charid)
					end
				end
			end
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

function ConvertTime(Unix)
	local UnixConvert = tonumber(math.floor(Unix))
	local mil2sec = UnixConvert / 1000
	local date = os.date("*t", mil2sec)
	local passback = date.day .. "/" .. date.month .. "/" .. date.year .. " " .. date.hour .. ":" .. date.min
	return passback
end

ESX.RegisterServerCallback('rpuk_factions:openLogCallback', function(source, callback, callType, job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	print("RPUK FACTIONS: LOG REQUEST FROM " .. xPlayer.rpuk_charid)
	local result = MySQL.Sync.fetchAll('SELECT * FROM log_group_armory WHERE job = @job AND type = @type ORDER BY game_time DESC', {
		['@job'] = tostring(job),
		['@type'] = tostring(callType),
	})

	for k,v in pairs(result) do
		result[k].formattedTime = ConvertTime(v.game_time)
	end

	callback(result)
end)

RegisterServerEvent("rpuk_factions:dbLog")
AddEventHandler("rpuk_factions:dbLog", function(job, identifier, type, name, item, quantity, rpuk_charid)
	db_log(job, identifier, type, name, item, quantity, rpuk_charid)
end)

function db_log(job, identifier, type, name, item, quantity, rpuk_charid)
	MySQL.Async.execute('INSERT INTO log_group_armory (identifier, job, type, name, item, quantity, rpuk_charid) VALUES (@identifier, @job, @type, @name, @item, @quantity, @rpuk_charid)', {
		['@identifier'] = identifier,
		['@job'] = tostring(job),
		['@type'] = tostring(type),
		['@name'] = tostring(name),
		['@item'] = tostring(item),
		['@quantity'] = tostring(quantity),
		['@rpuk_charid'] = tostring(rpuk_charid)
	})
end

RegisterNetEvent('rpuk_factions:attachmentSelected')
AddEventHandler('rpuk_factions:attachmentSelected', function(weapon, attachment, hasAttachment)
	local xPlayer = ESX.GetPlayerFromId(source)
	if hasAttachment then
		xPlayer.removeWeaponComponent(weapon, attachment)
	else
		xPlayer.addWeaponComponent(weapon, attachment)
	end
end)