local job_counts = {}
local currentCallers = {}

Config.ammoTypes = ESX.GetAmmo()
Config.defaultWeight, Config.localWeight = ESX.getLocalWeight()

-- [[ OBJECT FUNCTIONS ]] --

function getGangFromId(id)
	id = tonumber(id)
	return RPUK_GANGS[id]
end

function doesGangMemberHavePermission(rpuk_charid, permission_string, gang_id)
	-- Bit of a long winded way of doing it, #FirstDraft
	if gang_id ~= 0 then
		local xGang = getGangFromId(gang_id)
		local xGangMember = xGang.getMemberFromId(rpuk_charid)
		if xGangMember then
			for k, v in pairs (xGangMember.rank_permissions) do
				if v == permission_string then
					return true -- found the permission
				end
			end
			return false -- fallthrough the loop
		else
			return false -- not found the member in the gang
		end
	else
		return false -- not even in a gang
	end
end

-- [[ STANDARD FUNCTIONS ]] --

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function generateResult(xPlayer, location, npc_type)
	math.randomseed(os.time())
	local gang_id, gang_rank = xPlayer.getGang()
	if tonumber(gang_id) == tonumber(Config.StashHouses[location].controlled_by) then
		onTurf = true
	end
	local rand = math.random(1,4)
	if rand == 1 or rand == 2 then
		if onTurf then
			return "danger_sale" -- sale of product
		else
			return "danger_sale" -- sale on hostile turf
		end
	elseif rand == 3 then
		return "none" -- leave me alone message
	elseif rand == 4 and not onTurf then
		if gang_id == 0 then
			return "police" -- call police
		else
			return "turf" -- call turf owners
		end
	else
		return "none" -- leave me alone message
	end
end

function randomDrug(xPlayer, location)
	local prefered_drug = Config.StashHouses[location].attributes.pref_drug
	local xItem = xPlayer.getInventoryItem(prefered_drug)

	if xItem.count > 0 then
		return xItem
	else
		local found = false
		for k, v in pairs(Config.DrugTypes) do
			local xCheck = xPlayer.getInventoryItem(k)
			if xCheck.count > 0 then
				found = xCheck
				break
			end
		end
		return found
	end
end

ESX.RegisterServerCallback('rpuk_gangs:hasPermission', function(source, cb, permission_string)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)
	if xGang and xPlayer then
		local result = xGang.hasPermission(gang_rank, permission_string)
		cb(result)
	else
		cb(false)
	end
end)

RegisterNetEvent('rpuk_gangs:npcClaim')
AddEventHandler("rpuk_gangs:npcClaim", function(claimType)
	local xPlayer = ESX.GetPlayerFromId(source)
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)
	if xGang and xPlayer then
		local result = xGang.getClaimed(claimType)
		if result == 0 or result == false then
			if claimType == "blueprint" then
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 7000, type = 'success', text = "It's guns you want huh? Yeah here I have a few spare for the gang."})
				xPlayer.addInventoryItem("blueprint_gangpistol", 15)
				xPlayer.addInventoryItem("graffiti_spraycan", 20)
			elseif claimType == "drugs" then
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 7000, type = 'success', text = "It's drugs you want... I only know about the white stuff... I'll call my guy over at Cayo Perico, you will have to go pick it up though. Expect a text soon."})
			elseif claimType == "tips" then
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 7000, type = 'success', text = "None for you bud."})
				xPlayer.addInventoryItem("graffiti_spraycan", 10)
			end
			xGang.updateClaimed(claimType, 1)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'error', text = 'Come back another time!'})
		end
	end
end)

RegisterNetEvent('rpuk_gangs:openStorage')
AddEventHandler("rpuk_gangs:openStorage", function(gang_id)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xGang = getGangFromId(tonumber(gang_id))
	TriggerClientEvent("rpuk_inventory:openSecondaryInventory", source, xGang.formatForSecondInventory())
end)

ESX.RegisterServerCallback('rpuk_gangs:putItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local gang_id = data.id
	local xGang = getGangFromId(tonumber(gang_id))
	local cbResult = false
	local gm_id, gm_rank = xPlayer.getGang()

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		if xGang.hasPermission(gm_rank, "gang_fnc_safe_deposit") then
			if type == "item_standard" then
				local item = xPlayer.getInventoryItem(name)

				if item.count >= amount then
					local success, message = xGang.addItem(name, amount)

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
					local success, message = xGang.addWeapon(name, 1, xPlayer.getWeapon(name).components)

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
			elseif type == "item_ammo" then
				local ammo = xPlayer.getAmmo()[name]

				if ammo.count >= amount then
					local success, message = xGang.addAmmo(name, amount)

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
					local success, message = xGang.addAccountMoney(name, amount)

					if success then
						xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
						xPlayer.removeAccountMoney(name, amount, ('%s [%s]'):format('House Storage', GetCurrentResourceName()))
						cbResult = true
					else
						xPlayer.showNotification(message, 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You do not have enough dirty money', 2500, 'error', 'longnotif')
				end
			end
		else
			xPlayer.showNotification('You do not have permission to deposit into the storage', 2500, 'error', 'longnotif')
		end
	end

	if cbResult then
		xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", xGang.formatForSecondInventory())
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

ESX.RegisterServerCallback('rpuk_gangs:getItem', function(playerId, cb, itemType, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local gang_id = data.id
	local xGang = getGangFromId(tonumber(gang_id))
	local cbResult = false
	local gm_id, gm_rank = xPlayer.getGang()

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		if xGang.hasPermission(gm_rank, "gang_fnc_safe_withdraw") then
			if itemType == "item_standard" then
				if xPlayer.canCarryItem(name, amount) then
					local success, message = xGang.removeItem(name, amount)

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
			elseif itemType == "item_ammo" then
				local ammo = xPlayer.getAmmo()[name]

				if ammo.count+ammo.count > Config.ammoTypes[name].max then
					amount = Config.ammoTypes[name].max - ammo.count
				end

				if amount > 0 then
					local success, message = xGang.removeAmmo(name, amount)

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
					xPlayer.showNotification('You already have the same weapon', 2500, 'inform', 'longnotif')
				else
					local success, message = xGang.removeWeapon(name, amount, itemData.item.data.components)

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
				local success, message = xGang.removeAccountMoney(name, amount)

				if success then
					xPlayer.showNotification(message, 2500, 'inform', 'longnotif')
					xPlayer.addAccountMoney(name, amount, ('%s [%s]'):format('House Storage', GetCurrentResourceName()))
					cbResult = true
				else
					xPlayer.showNotification(message, 2500, 'error', 'longnotif')
				end
			end
		else
			xPlayer.showNotification('You do not have permission to withdraw from the storage', 2500, 'error', 'longnotif')
		end
	end

	if cbResult then
		xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", xGang.formatForSecondInventory())
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

RegisterNetEvent('rpuk_jobs:count')
AddEventHandler("rpuk_jobs:count", function(data)
	job_counts = data
end)

ESX.RegisterServerCallback('rpuk_gangs:purchaseGrow', function(source, cb, index)
	local xPlayer = ESX.GetPlayerFromId(source)
	local result = false

	if xPlayer and Config.GrowShops[index] then
		local money = xPlayer.getMoney()
		if money >= Config.GrowShops[index].price then
			xPlayer.removeAccountMoney("money", Config.GrowShops[index].price, ('%s (%s) [%s]'):format('Grow Shop Purchase', Config.GrowShops[index].label, GetCurrentResourceName()))
			if Config.GrowShops[index].prop then
				TriggerClientEvent('rpuk_housing:remoteFurnish', source, Config.GrowShops[index].prop, Config.GrowShops[index].label, 1)
			else
				xPlayer.addInventoryItem(Config.GrowShops[index].item, 1)
			end
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { length = 2500, action = 'longnotif', type = 'success', text = "Purchased " .. Config.GrowShops[index].label})
			result = true
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { length = 2500, action = 'longnotif', type = 'error', text = "Not enough money"})
			result = false
		end
	else
		result = false
	end

	cb(result)
end)