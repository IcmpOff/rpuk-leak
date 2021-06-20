local currentCallers = {}

RegisterNetEvent("rpuk_moneytransfer:openMenu")
RegisterNetEvent("rpuk_moneytransfer:openMenu:dropoff")

function stockRefilTimer(id, position)
	Citizen.CreateThread(function()
		while true do
			Wait(1000)
			config.pickupLocations[id].positions[position].restockTimer = config.pickupLocations[id].positions[position].restockTimer-1
			if config.pickupLocations[id].positions[position].restockTimer <= 0 then
				for k,v in pairs(config.pickupLocations[id].positions[position].items) do
					config.pickupLocations[id].positions[position].items[k].count = config.pickupLocations[id].positions[position].items[k].max
				end
				TriggerEvent("rpuk_alerts:sNotification", {notiftype = "collection", extraNotes = config.pickupLocations[id].positions[position].locationName, coords = vector3(config.pickupLocations[id].positions[position].x, config.pickupLocations[id].positions[position].y, config.pickupLocations[id].positions[position].z)})
				break
			end
		end
		config.pickupLocations[id].positions[position].restockTimer = config.pickupLocations[id].positions[position].defaultTimer
	end)
end

AddEventHandler("rpuk_moneytransfer:openMenu:dropoff", function(id, position)
	local _source = source
	local items = {}
	for k, v in pairs(config.dropoffLocations[id].positions[position].items) do
		table.insert(items, {
			name = k,
			count = v.price/config.percentageForReward,
			label = ESX.GetItemLabel(k)
		})
	end

	TriggerClientEvent("rpuk_inventory:openSecondaryInventory", _source, {
		id = id,
		position = position,
		text = "Menu",
		type = "rpuk_moneytransfer:dropoff",
		typeOfInv = "store"
	}, {}, items)
end)


AddEventHandler("rpuk_moneytransfer:openMenu", function(id, position)
	local _source = source
	local items = {}
	for k,v in pairs(config.pickupLocations[id].positions[position].items) do
		if v.count > 0 then
			table.insert(items, {
				name = k,
				count = v.count,
				label = ESX.GetItemLabel(k)
			})
		end
	end
	if not next(items) then
		local timeInSec = config.pickupLocations[id].positions[position].restockTimer
		local timeInHours = timeInSec/3600
		local timeInMinutes = math.floor(timeInHours%1*60)
		local time
		if timeInHours < 1 then
			time = timeInMinutes.." Minutes"
		else
			time = math.floor(timeInHours)..' Hour(s) '..timeInMinutes..' Minutes'
		end
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 2000, type = 'inform', text = 'Stock is empty, you need to wait '..time.." until restock"})
		return
	end

	if ESX.GetInActiveJob("gruppe6") < config.pickupLocations[id].positions[position].requiredAmountOfG6 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "You do not have enough untis available to continue this job." })
		return
	end

	TriggerClientEvent("rpuk_inventory:openSecondaryInventory", _source, {
		id = id,
		position = position,
		text = "Menu",
		type = "rpuk_moneytransfer",
	}, {}, items)
end)

ESX.RegisterServerCallback('rpuk_moneytransfer:dropoff:putItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local price = 0
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		for _,v in pairs(config.dropoffLocations) do
			for key,val in pairs(v.positions) do
				for label,tag in pairs(val.items) do
					if name == label then
						price = tag.price/config.percentageForReward
						break
					end
				end
			end
		end

		if price > 0 then
			if type == "item_standard" then
				local item = xPlayer.getInventoryItem(name)
				if item.count >= amount then
					xPlayer.removeInventoryItem(name, amount)
					price = price*amount
					xPlayer.addAccountMoney("money", price, ('%s [%s]'):format('Bonus from money transfer', GetCurrentResourceName()))
					xPlayer.showNotification("You have received a bonus of £"..ESX.Math.GroupDigits(math.floor(price)), 2500, 'inform', 'longnotif')
					cbResult = true
				else
					xPlayer.showNotification('Not enough of selected item', 2500, 'error', 'longnotif')
				end
			end
		else
			xPlayer.showNotification('You can not remove this item', 2500, 'error', 'longnotif')
		end

		if cbResult then
			local fundName = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
				["@job"] = xPlayer.job.name
			})[1]

			if fundName then
				xPlayer.showNotification("You have increased your fund by £"..ESX.Math.GroupDigits(math.floor(price/config.percentageForFund)), 2500, 'inform', 'longnotif')

				MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
					["@fund"] = (price/config.percentageForFund)+fundName.fund,
					["@job"] = xPlayer.job.name
				})
			end
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

ESX.RegisterServerCallback('rpuk_moneytransfer:getItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local item = config.pickupLocations[data.id].positions[data.position].items[name]
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true
		local items = {}

		if type == "item_standard" then
			if item.count >= amount then
				if xPlayer.canCarryItem(name, amount) then
					xPlayer.addInventoryItem(name, amount)
					config.pickupLocations[data.id].positions[data.position].items[name].count = config.pickupLocations[data.id].positions[data.position].items[name].count-amount
					cbResult = true
				else
					xPlayer.showNotification('You do not have enough room in your inventory', 2500, 'error', 'longnotif')
				end
			else
				xPlayer.showNotification('Insufficient amount of items in location', 2500, 'error', 'longnotif')
			end
		end

		if cbResult then
			for k,v in pairs(config.pickupLocations[data.id].positions[data.position].items) do
				if v.count > 0 then
					table.insert(items, {
						name = k,
						count = v.count,
						label = ESX.GetItemLabel(k)
					})
				end
			end

			if #items > 0 then
				xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", {
					id = data.id,
					position = data.position,
					text = "Menu",
					type = "rpuk_moneytransfer",
				}, {}, items)
			else
				local timeInSec = config.pickupLocations[data.id].positions[data.position].restockTimer
				local timeInHours = timeInSec/3600
				local timeInMinutes = math.floor(timeInHours%1*60)
				local time

				if timeInHours < 1 then
					time = timeInMinutes.." Minutes"
				else
					time = math.floor(timeInHours)..' Hour(s) '..timeInMinutes..' Minute(s)'
				end

				stockRefilTimer(data.id, data.position)
				xPlayer.triggerEvent("rpuk_inventory:closeInventory")
				xPlayer.showNotification('Stock is empty, you need to wait '..time.." until resotck", 2500, 'error', 'longnotif')
			end
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)