activeHouses = {}
local ownedHouses = {}
local isInHouse = {}
local currentCallers = {}

RegisterNetEvent("rpuk_housing:buyHouse")
RegisterNetEvent("rpuk_housing:upCullingDistance")
RegisterNetEvent("rpuk_housing:enter")
RegisterNetEvent("rpuk_housing:leave")
RegisterNetEvent("rpuk_housing:explosion")
RegisterNetEvent("rpuk_housing:knock")
RegisterNetEvent("rpuk_housing:acceptedKnock")
RegisterNetEvent("rpuk_housing:letIn")
RegisterNetEvent("rpuk_housing:openStorage")
RegisterNetEvent("rpuk_housing:manufacture")
RegisterNetEvent("rpuk_housing:storeVehicle")
RegisterNetEvent("rpuk_housing:removeCarFromGarage")
RegisterNetEvent("rpuk_housing:buyFurniture")
RegisterNetEvent("rpuk_housing:remoteFurnish")
RegisterNetEvent("rpuk_housing:placedFurniture")
RegisterNetEvent("rpuk_housing:removeFurnished")
RegisterNetEvent("rpuk_housing:refurnished")
RegisterNetEvent("rpuk_housing:alertOwner")
RegisterNetEvent("rpuk_housing:sellHouse")


function isInHouseCoords(id)
	if isInHouse[tostring(id)] then
		return config.houses[isInHouse[tostring(id)]].door
	end
end

config.defaultWeight, config.localWeight = ESX.getLocalWeight()

MySQL.ready(function()
	MySQL.Async.fetchAll("SELECT * FROM houses", {}, function(data)
		for k,v in pairs(data) do
			ownedHouses[v.houseId] = createHouse(v)
		end
	end)
end)

ESX.RegisterServerCallback("rpuk_housing:getAllOwnedHousesAndMyOwnHouse", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll("SELECT * FROM houses WHERE owner = @charId", {
		["@charId"] = xPlayer.getCharacterId()
	}, function(result)
		cb((result[1] and result[1].houseId or false), ownedHouses)
	end)
end)

ESX.RegisterServerCallback("rpuk_housing:hasItem", function(source, cb, item, count, houseID)
	local result = MySQL.Sync.fetchAll('SELECT * FROM warrants WHERE house_id = @houseID AND status = "accepted"', {
		['@houseID'] = houseID
	})[1]
	local xPlayer = ESX.GetPlayerFromId(source)

	if result or (xPlayer.job.name == "police" and xPlayer.job.grade >= 5)then
		local itemData = xPlayer.getInventoryItem(item)
		if itemData.count >= count then
			if not result then
				local result2 = MySQL.Sync.fetchAll('SELECT h.*, u.firstname, u.lastname FROM houses h JOIN users u ON h.owner = u.rpuk_charid WHERE h.houseId = @houseID', {
					['@houseID'] = houseID
				})
				if result2 then
					local targetName = result2[1].firstname.." "..result2[1].lastname
					MySQL.Async.execute('INSERT INTO warrants (identifier, rpuk_charid, officer_workplace, officer_name, officer_rank, senior_auth, target_name, house_id, business_id, reason, status, reviewed_by, warrant_executed_by, executed_date, date_created, decision_date) VALUES (@identifier, @rpuk_charid, @officer_workplace, @officer_name, @officer_rank, @senior_auth, @target_name, @house_id, @business_id, @reason, "completed", @reviewed_by, @warrant_executed_by, current_timestamp(), current_timestamp(), current_timestamp())',{
						['@identifier']		= xPlayer.identifier,
						['@rpuk_charid']	= xPlayer.getCharacterId(),
						['@officer_workplace'] = xPlayer.job.name,
						['@officer_name']	= xPlayer.firstname .. ' '.. xPlayer.lastname,
						['@officer_rank']	= xPlayer.job.grade_label,
						['@senior_auth']	= xPlayer.firstname .. ' '.. xPlayer.lastname,
						['@target_name']	= targetName,
						['@warrant_executed_by'] = xPlayer.firstname .. ' '.. xPlayer.lastname,
						['@reviewed_by'] = xPlayer.firstname .. ' '.. xPlayer.lastname,
						['@house_id'] = houseID,
						['@business_id'] = 0,
						['@reason']	= "Emergency Warrant",
					}, function(data)
						if data then
							TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = 'Your warrant has been actioned.'})
							xPlayer.removeInventoryItem(item, 1)
							if xPlayer.job.name == "police" then
								TriggerEvent('rpuk:disc_post', 0, "warrant_alert_police", "Emergency Warrant", "A Emergency Warrant has been actioned by "..xPlayer.firstname .. ' '.. xPlayer.lastname .. " on house number ".. houseID .. ".")
							end
							cb(true, "", true)
						else
							TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = 'Your warrant has not been sent through, please try again.'})
						end
					end)
				end
			else
				MySQL.Sync.execute("UPDATE warrants SET status = 'completed', executed_date = current_timestamp(), warrant_executed_by = @name WHERE house_id = @house_id", {
					['@house_id'] = houseID,
					["@name"] = xPlayer.firstname .. " " .. xPlayer.lastname
				})
				cb(true, "", false)
			end
			xPlayer.removeInventoryItem(item, 1)
		else
			cb(false, "You do not have a breaching charge on your person.", false)
		end
	else
		cb(false, "Your warrant has not been approved.", false)
	end
end)

ESX.RegisterServerCallback("rpuk_housing:ownsVehicle", function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate AND rpuk_charid = @rpuk_charid", {
		["@plate"] = plate,
		["@rpuk_charid"] = xPlayer.getCharacterId()
	})[1])
end)

ESX.RegisterServerCallback("rpuk_housing:canStoreCar", function(source, cb, houseId, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isVehicleAlreadyInGarage = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE rpuk_charid = @rpuk_charid AND location = 'house' AND plate = @plate", {
		["@rpuk_charid"] = xPlayer.getCharacterId(),
		["@plate"] = plate
	})
	if next(isVehicleAlreadyInGarage) then
		cb(true)
		return
	end
	local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE rpuk_charid = @rpuk_charid AND location = 'house' AND plate != @plate", {
		["@rpuk_charid"] = xPlayer.getCharacterId(),
		["@plate"] = plate
	})
	cb(#result < ownedHouses[houseId].maxVehicles)
end)

ESX.RegisterServerCallback("rpuk_housing:getVehiclesInGarage", function(source, cb, houseId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE rpuk_charid = @rpuk_charid AND state = 1 AND location = @location", {
		["@rpuk_charid"] = xPlayer.getCharacterId(),
		["@location"] = "house"
	})
	cb(result)
end)

ESX.RegisterServerCallback("rpuk_housing:getBoughtFurniture", function(source, cb, houseId)
	cb(ownedHouses[houseId].boughtFurniture)
end)

ESX.RegisterServerCallback("rpuk_housing:placeBoughtFurniture", function(source, cb, houseId, furniture)
	cb(ownedHouses[houseId].removeFurniture(furniture, 1))
end)

ESX.RegisterServerCallback("rpuk_housing:getPlacedFurniture", function(source, cb, houseId)
	cb(ownedHouses[houseId].furniture)
end)

ESX.RegisterServerCallback("rpuk_housing:getHousePlayerIsIn", function(source, cb, target, key)
	if isInHouse[tostring(target)] then
		if key then
			cb(activeHouses[isInHouse[tostring(target)]][key])
		else
			cb(activeHouses[isInHouse[tostring(target)]])
		end
	else
		cb()
	end
end)

AddEventHandler("rpuk_housing:storeVehicle", function(plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Sync.execute("UPDATE owned_vehicles SET state = 1, location = @location WHERE rpuk_charid = @rpuk_charid AND plate = @plate", {
		["@rpuk_charid"] = xPlayer.getCharacterId(),
		["@plate"] = plate,
		["@location"] = "house"
	})
end)

AddEventHandler("rpuk_housing:sellHouse", function(houseID)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if houseID then
		local success, message = ownedHouses[houseID].sellHouse(xPlayer.getCharacterId())

		if success then
			local housePrice = math.floor(ownedHouses[houseID].price*config.sellPercentage)
			local msg = ("You have sold your house for <span style='color:lightgreen;'>£%s</span>"):format(ESX.Math.GroupDigits(housePrice))
			ownedHouses[houseID] = nil

			xPlayer.addAccountMoney('bank', housePrice, "Sold House: "..houseID)
			xPlayer.showNotification(msg, 5000, 'inform')
			xPlayer.triggerEvent("rpuk_housing:soldOwnHouse")
			TriggerClientEvent("rpuk_housing:soldHouse", -1, houseID)
		else
			xPlayer.showNotification(message, 5000, 'error')
		end
	else
		xPlayer.showNotification('House is not owned', 5000, 'error')
	end
end)

AddEventHandler("rpuk_housing:removeCarFromGarage", function(plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Sync.execute("UPDATE owned_vehicles SET state = 0 WHERE rpuk_charid = @rpuk_charid AND plate = @plate", {
		["@rpuk_charid"] = xPlayer.getCharacterId(),
		["@plate"] = plate,
	})
end)

AddEventHandler("rpuk_housing:buyHouse", function(houseId)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = xPlayer.getAccount('bank').money

	if ownedHouses[houseId] == nil then
		if money >= config.houses[houseId].price then
			ownedHouses[houseId] = createHouse({
				houseId = houseId,
				owner = xPlayer.getCharacterId(),
				furniture = "[]",
				bought_furniture = "[]",
				boughtTime = os.time(),
				paidMonth = 1,
				data = "[]"
			})

			MySQL.Sync.execute("INSERT INTO houses VALUES (@houseId, @owner, '{}', '{}', @boughtTime, @paidMonth, '[]')", {
				["@houseId"] = houseId,
				["@owner"] = xPlayer.getCharacterId(),
				["@boughtTime"] = os.time(),
				["@paidMonth"] = true
			})

			xPlayer.removeAccountMoney('bank', config.houses[houseId].price, ('%s (%s) [%s]')
				:format('Purchased New House', houseId, GetCurrentResourceName()))
			xPlayer.showNotification(('You have bought the house for <span style="color:lightgreen;">£%s</span>')
				:format(ESX.Math.GroupDigits(config.houses[houseId].price)), 5000, 'inform')

			TriggerClientEvent("rpuk_housing:registerNewHouseAsOwned", -1, houseId)
			xPlayer.triggerEvent("rpuk_housing:registerAsOwnerOfHouse", houseId)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "Not enough money missing: $" .. config.houses[houseId].price - money})
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "House is already owned"})
	end
end)

AddEventHandler('rpuk_housing:upCullingDistance', function(nearbyVehiclesNetworkIds)
	for k,entityNetworkId in ipairs(nearbyVehiclesNetworkIds) do
		local vehicleHandle = NetworkGetEntityFromNetworkId(entityNetworkId)

		if vehicleHandle and DoesEntityExist(vehicleHandle) then
			SetEntityDistanceCullingRadius(vehicleHandle, 99999999)
		end
	end
end)

AddEventHandler("rpuk_housing:enter", function(houseId, type)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if activeHouses[houseId] ~= nil then
		activeHouses[houseId].enter(_source, type)
	else
		activeHouses[houseId] = createInstance({
			id = houseId,
			type = type,
			isBrokenInto = type == "raider",
			source = _source
		})
		TriggerClientEvent("rpuk_housing:enterHouse", _source, activeHouses[houseId], type)
		isInHouse[tostring(_source)] = houseId
		if type == "raider" then

		elseif type == "medic" then
			print("RPUK HOUSING | [CharID:".. xPlayer.getCharacterId() .."] Forced Entry into house ID using medic access "..houseId)
			-- Inform all clients that they can enter this house
		end
	end
end)

AddEventHandler("rpuk_housing:leave", function(houseId)
	local _source = source

	isInHouse[tostring(_source)] = nil
	if activeHouses[houseId] ~= nil then
		activeHouses[houseId].leave(_source)
	end
end)

AddEventHandler("rpuk_housing:explosion", function(id)
	TriggerClientEvent("rpuk_housing:explosion", source, config.houses[id].door)
	TriggerClientEvent("rpuk_housing:explosionSound", -1, config.houses[id].door, id)
end)

AddEventHandler("rpuk_housing:knock", function(id)
	local _source = source

	if activeHouses[id] == nil then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "No one is home"})
	elseif activeHouses[id].knocked[_source] ~= nil then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "Already knocked"})
	else
		activeHouses[id].knock(_source)
	end
end)

AddEventHandler("rpuk_housing:letIn", function(target, id)
	if activeHouses[id] ~= nil then
		TriggerClientEvent("rpuk_housing:letIn", target, id)
	end
end)

AddEventHandler("rpuk_housing:openStorage", function(houseId)
	local _source = source

	TriggerClientEvent("rpuk_inventory:openSecondaryInventory", _source, ownedHouses[houseId].formatForSecondInventory())
end)

ESX.RegisterServerCallback('rpuk_housing:getItem', function(playerId, cb, itemType, name, amount, data, itemData)
	local houseId = data.id
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		if itemType == "item_standard" then
			if xPlayer.canCarryItem(name, amount) then
				local success, message = ownedHouses[houseId].removeItem(name, amount)

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
		elseif itemType == "item_ammo" then
			local ammo = xPlayer.getAmmo()[name]

			if ammo.count+amount > config.ammoTypes[name].max then
				amount = config.ammoTypes[name].max - ammo.count
			end

			if amount > 0 then
				local success, message = ownedHouses[houseId].removeAmmo(name, amount)

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
		elseif itemType == "item_weapon" then
			if xPlayer.hasWeapon(name) then
				xPlayer.showNotification('You already have this weapon on you', 2500, 'error', 'longnotif')
			else
				local success, message = ownedHouses[houseId].removeWeapon(name, amount, itemData.item.data.components)

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
			end
		elseif itemType == "item_account" then
			local success, message = ownedHouses[houseId].removeAccountMoney(name, amount)

			if success then
				xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
				xPlayer.addAccountMoney(name, amount, ('%s [%s]'):format('House Storage', GetCurrentResourceName()))
				cbResult = true
			else
				xPlayer.showNotification(message, 2500, 'error', 'longnotif')
			end
		end
	end

	if cbResult then
		xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", ownedHouses[houseId].formatForSecondInventory())
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

ESX.RegisterServerCallback('rpuk_housing:putItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local houseId = data.id
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		if type == "item_standard" then
			local item = xPlayer.getInventoryItem(name)

			if item.count >= amount then
				local success, message = ownedHouses[houseId].addItem(name, amount)

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
			if xPlayer.hasWeapon(name) then
				local success, message = ownedHouses[houseId].addWeapon(name, 1, xPlayer.getWeapon(name).components)

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
				local success, message = ownedHouses[houseId].addAmmo(name, amount)

				if success then
					xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
					xPlayer.removeWeaponAmmo(name, amount)
					cbResult = true
				else
					xPlayer.showNotification(message, 2500, 'error', 'longnotif')
				end
			else
				xPlayer.showNotification('You dont have enough of ammo type', 2500, 'error', 'longnotif')
			end
		elseif type == "item_account" then
			local money = xPlayer.getAccount(name).money

			if money >= amount then
				local success, message = ownedHouses[houseId].addAccountMoney(name, amount)

				if success then
					xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
					xPlayer.removeAccountMoney(name, amount, ('%s [%s]'):format('House Storage', GetCurrentResourceName()))
					cbResult = true
				else
					xPlayer.showNotification(message, 2500, 'error', 'longnotif')
				end
			else
				xPlayer.showNotification('You dont have enough of selected money', 2500, 'error', 'longnotif')
			end
		end

		if cbResult then
			xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", ownedHouses[houseId].formatForSecondInventory())
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

AddEventHandler("rpuk_housing:buyFurniture", function(houseId, category, furniture)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = xPlayer.getMoney()
	local data = config.furniture[category[1]][furniture]

	if money >= data[3] then
		local success, message = ownedHouses[houseId].addFurniture(data[2], data[1], 1)
		if not success then
			xPlayer.showNotification(message, 2500, 'error', 'longnotif')
			return
		elseif success then
			xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
		end
		xPlayer.removeAccountMoney("money", data[3], ('%s [%s]'):format('Purchased Housing Furniture', GetCurrentResourceName()))
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "Not enough money"})
	end
end)

AddEventHandler("rpuk_housing:remoteFurnish", function(houseId, prop, label, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local success, message = ownedHouses[houseId].addFurniture(prop, label, count)
	if not success then
		xPlayer.showNotification(message, 2500, 'error', 'longnotif')
		return
	elseif success then
		xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
	end
end)

AddEventHandler("rpuk_housing:placedFurniture", function(houseId, object, coords, heading)
	local xPlayer = ESX.GetPlayerFromId(source)
	ownedHouses[houseId].placedFurniture(object, coords, heading)
	Citizen.Wait(1500)
	if object == "prop_bucket_01a" then
		local furn = ownedHouses[houseId].fetchFurniture()
		TriggerClientEvent('rpuk_housing:interactionUpdate', xPlayer.source, furn)
	end
end)

AddEventHandler("rpuk_housing:removeFurnished", function(houseId, propId, prop)
	local xPlayer = ESX.GetPlayerFromId(source)

	local success = false
	if config.GrowingInteracts[tostring(prop)] then -- stops them picking up full plants and hiding them etc
		local success, message = ownedHouses[houseId].removeFurnished(propId, prop)
		local success = ownedHouses[houseId].stopPlantData(propId)
		local success2 = ownedHouses[houseId].removeFurniture(prop, 1)
		local success3 = ownedHouses[houseId].addFurniture("prop_bucket_01a", "Plant Pot", 1)
	else
		local success, message = ownedHouses[houseId].removeFurnished(propId, prop)
	end

	TriggerClientEvent('rpuk_housing:interactionUpdate', xPlayer.source, ownedHouses[houseId].fetchFurniture())
	if not success then
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 2500, action = 'longnotif', type = 'error', text = message})
		return
	elseif success then
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 2500, action = 'longnotif', type = 'inform', text = message})
	end
end)

AddEventHandler("rpuk_housing:refurnished", function(houseId, propId, offset, heading)
	local _source = source
	local success, message = ownedHouses[houseId].moveFurniture(propId, offset, heading)
	TriggerClientEvent('rpuk_housing:interactionUpdate', _source, ownedHouses[houseId].fetchFurniture())
	if not success then
		xPlayer.showNotification(message, 2500, 'error', 'longnotif')
		return
	elseif success then
		xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
	end
end)

AddEventHandler("rpuk_housing:alertOwner", function(houseID)
	local result = MySQL.Sync.fetchAll('SELECT h.*, u.rpuk_charid, u.phone_number FROM houses h JOIN users u ON h.owner = u.rpuk_charid WHERE h.houseId = @houseID', {
		['@houseID'] = houseID
	})
	local xPlayer = ESX.GetPlayerFromCharId(result[1].rpuk_charid)
	if xPlayer then
		TriggerEvent('gcPhone:_internalAddMessage', "gruppe6", xPlayer.phoneNumber, 'This is a automated alert from Gruppe Sechs. Intruder detected at home address.', 0, function(object)
			TriggerClientEvent('gcPhone:receiveMessage', xPlayer.source, object)
		end)
	else
		TriggerEvent('gcPhone:_internalAddMessage', "gruppe6", result[1].phone_number, 'This is a automated alert from Gruppe Sechs. Intruder detected at home address.', 0, function(object)
		end)
	end
end)

RegisterNetEvent("rpuk_housing:plantInteraction")
AddEventHandler("rpuk_housing:plantInteraction", function(houseId, propId, objectName, interactionType)
	local xPlayer = ESX.GetPlayerFromId(source)

	local plantData = ownedHouses[houseId].getPlantData(propId) -- returns the data of the prop
	if not plantData then
		local success = ownedHouses[houseId].startPlantData(propId) -- initialised the plant data
		plantData = ownedHouses[houseId].getPlantData(propId)
	end

	if interactionType == "Sativa" or interactionType == "Indica" then
		local xSeed = "comp_drug_cannaseed_indica"
		if interactionType == "Sativa" then
			xSeed = "comp_drug_cannaseed_sativa"
		end
		local xItem = xPlayer.getInventoryItem(xSeed)
		if xItem.count >= 1 then
			if not plantData.seed then
				ownedHouses[houseId].updatePlantData(propId, {
					seed = interactionType,
					soiled = plantData.soiled,
					watered = plantData.watered,
					wateredTime = plantData.wateredTime,
					wateredStage = plantData.wateredStage,
				}, true)
				xPlayer.removeInventoryItem(xSeed, 1)
			else
				plant_msg(xPlayer.source, "error", "There is already a seed in the pot.")
			end
		else
			plant_msg(xPlayer.source, "error", "You do not have enough " .. xItem.label)
		end
	elseif interactionType == "water" then
		local xItem = xPlayer.getInventoryItem("comp_drug_wateringcan")
		if xItem.count >= 1 then
			if not plantData.watered then
				ownedHouses[houseId].updatePlantData(propId, {
					seed = plantData.seed,
					soiled = plantData.soiled,
					watered = true,
					wateredTime = os.time(),
					wateredStage = 1,
				}, true)
				xPlayer.removeInventoryItem("comp_drug_wateringcan", 1)
			else
				plant_msg(xPlayer.source, "error", "There is already sufficient water.")
			end
		else
			plant_msg(xPlayer.source, "error", "You do not have enough " .. xItem.label)
		end
	elseif interactionType == "soil" then
		local xItem = xPlayer.getInventoryItem("comp_drug_soil")
		if xItem.count >= 1 then
			if not plantData.soiled then
				ownedHouses[houseId].updatePlantData(propId, {
					seed = plantData.seed,
					soiled = true,
					watered = plantData.watered,
					wateredTime = plantData.wateredTime,
					wateredStage = plantData.wateredStage,
				}, true)
				xPlayer.removeInventoryItem("comp_drug_soil", 1)
			else
				plant_msg(xPlayer.source, "error", "There is already sufficient soil.")
			end
		else
			plant_msg(xPlayer.source, "error", "You do not have enough " .. xItem.label)
		end
	elseif interactionType == "cut" then
		if plantData.seed then
			ownedHouses[houseId].furniture[propId].object = "prop_bucket_01a"
			local success, message = ownedHouses[houseId].removeFurnished(propId, ownedHouses[houseId].furniture[propId].object)
			local bud, quantity = "", math.random(250, 300)
			if plantData.seed == "Sativa" then bud = "comp_drug_sativabud"
			elseif plantData.seed == "Indica" then bud = "comp_drug_indicabud" end
			xPlayer.addInventoryItem(bud, quantity)
		else
			plant_msg(xPlayer.source, "error", "Seed not found.")
		end
	elseif interactionType == "police" then
		if plantData.seed then
			local xProp = ownedHouses[houseId].furniture[propId].object
			local success, message = ownedHouses[houseId].removeFurnished(propId, xProp)
			local success2 = ownedHouses[houseId].removeFurniture(xProp, 1)
			local success3 = ownedHouses[houseId].addFurniture("prop_bucket_01a", "Plant Pot", 1)
			plant_msg(xPlayer.source, "error", "Plant ripped up - it will still show until the house refreshes. Under development.")
		else
			plant_msg(xPlayer.source, "error", "Seed not found.")
		end
	end
	local inTheHouse = activeHouses[houseId].players
	--for k, v in pairs(inTheHouse) do
	--	local xPlayer = ESX.GetPlayerFromId(tonumber(k))
		TriggerClientEvent('rpuk_housing:interactionUpdate', xPlayer.source, ownedHouses[houseId].fetchFurniture(), activeHouses[houseId])
	--end
end)

-- plant tick

local plantStageTime = 12.00 -- 12
function plantTick()
	for houseId, houseData in pairs (ownedHouses) do
		local saveHouse = false
		for objectId, objectData in pairs (houseData.furniture) do
			if config.GrowingInteracts[objectData.object] then
				local plantData = objectData.plantData
				if plantData and plantData.watered and plantData.wateredTime and plantData.seed and plantData.soiled then
					local timeDifference = os.time() - plantData.wateredTime
					if tonumber(timeDifference) / 60 / 60 >= plantStageTime then
						if objectData.object == "prop_bucket_01a" then -- stage 0
							ownedHouses[houseId].furniture[objectId].object = "bkr_prop_weed_01_small_01c"
						elseif objectData.object == "bkr_prop_weed_01_small_01c" then -- stage 1
							ownedHouses[houseId].furniture[objectId].object = "bkr_prop_weed_01_small_01b"
						elseif objectData.object == "bkr_prop_weed_01_small_01b" then -- stage 2
							ownedHouses[houseId].furniture[objectId].object = "bkr_prop_weed_med_01a"
						elseif objectData.object == "bkr_prop_weed_med_01a" then -- stage 3
							ownedHouses[houseId].furniture[objectId].object = "bkr_prop_weed_lrg_01a"
						end
						if ownedHouses[houseId].furniture[objectId].object ~= "bkr_prop_weed_lrg_01a" then
							ownedHouses[houseId].updatePlantData(objectId, {
								seed = plantData.seed,
								soiled = plantData.soiled,
								watered = nil,
								wateredTime = nil,
								wateredStage = nil,
							})
						end
						saveHouse = true
					end
				end
			end
		end
		if saveHouse then
			ownedHouses[houseId].saveFurniture()
		end
	end
	SetTimeout(5 * 60 * 1000, plantTick) -- 5 mins
end

plantTick()

function plant_msg(source, success, message)
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { length = 5000, action = 'longnotif', type = success, text = message})
end