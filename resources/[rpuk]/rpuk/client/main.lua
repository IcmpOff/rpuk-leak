local isPaused, isDead = false, false
local stats = {
	["stamina"] = {"MP0_STAMINA", "Stamina"}, -- running / distance
	["strength"] = {"MP0_STRENGTH", "Strength"}, -- how hard you punch
	["stealth"] = {"MP0_STEALTH_ABILITY", "Stealth"}, -- useless in our usage
	["shooting"] = {"MP0_SHOOTING_ABILITY", "Shooting"}, -- increase whilst you are flying
	["flying"] = {"MP0_FLYING_ABILITY", "Flying"}, -- recoil control
	["driving"] = {"MP0_DRIVING_ABILITY", "Driving"}, -- increase whilst you are driving
	["lung_capacity"] = {"MP0_LUNG_CAPACITY", "Lung Capacity"}, -- swimming
	["mental_state"] = {"MP0_PLAYER_MENTAL_STATE", "Mental State"}, -- useless in our usage // mental breakdown
}

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(job, level, flag)
	local allowed_flags = ESX.Table.Set({"taser", "dog", "firstaid", "driving", "pilot", "boat", "firearms", "special", "hart", "training", "manufacture", "bank", "launder", "smuggling", "cid", "covert"})
	level = tonumber(level)

	if flag and flag ~= job then
		if job == "police" then
			if allowed_flags[flag] then
				ESX.PlayerData.police_data[flag] = level
				ESX.ShowAdvancedNotification("Job Whitelisting", "Job flags changed", "", 'CHAR_BARRY', 1)
			else
				ESX.ShowAdvancedNotification("ERROR", "Job Flag Was Wrong", "Whitelist flag does not exist in list, contact a dev", 'CHAR_BARRY', 1)
			end
		elseif job == "nhs" then
			if allowed_flags[flag] then
				ESX.PlayerData.nhs_data[flag] = level
				ESX.ShowAdvancedNotification("Job Whitelisting", "Job flags changed", "", 'CHAR_BARRY', 1)
			else
				ESX.ShowAdvancedNotification("ERROR", "Job Flag Was Wrong", "Whitelist flag does not exist in list, contact a dev", 'CHAR_BARRY', 1)
			end
		elseif job == "lost" then
			if allowed_flags[flag] then
				ESX.PlayerData.lost_data[flag] = level
				ESX.ShowAdvancedNotification("Job Whitelisting", "Job flags changed", "", 'CHAR_BARRY', 1)
			else
				ESX.ShowAdvancedNotification("ERROR", "Job Flag Was Wrong", "Whitelist flag does not exist in list, contact a dev", 'CHAR_BARRY', 1)
			end
		end
	else
		if job == "police" then
			ESX.PlayerData.police_level = level
			ESX.ShowAdvancedNotification("Police Service", "Job whitelisting changed", "", 'CHAR_BARRY', 1)
		elseif job == "nhs" then
			ESX.PlayerData.nhs_level = level
			ESX.ShowAdvancedNotification("NHS / Fire", "Job whitelisting changed", "", 'CHAR_BARRY', 1)
		elseif job == "lost" then
			ESX.PlayerData.lost_level = level
			ESX.ShowAdvancedNotification("Lost MC", "Job whitelisting changed", "", 'CHAR_BARRY', 1)
		else
			if ESX.PlayerData.civ_job[job] then
				if ESX.PlayerData.civ_job[job] < level then
					ESX.ShowNotification('Job Proficiency", "Increased", "Your job proficiency has increased!', 5000, 'info', 'longnotif')
				else
					ESX.ShowAdvancedNotification("- Job Proficiency", "Decreased", "Your job proficiency has decreased!", 'CHAR_BARRY', 1)
				end
				ESX.PlayerData.civ_job[job] = level
			end
		end
	end
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang_id, gang_rank)
	ESX.PlayerData.gang_data.gang_id = gang_id
	ESX.PlayerData.gang_data.gang_rank = gang_rank
end)

RegisterNetEvent('rpuk:setState')
AddEventHandler('rpuk:setState', function(state, value)
	if state == "dead" then
		ESX.PlayerData.death_state = value
	elseif state == "jailed" then
		ESX.PlayerData.jail_state = value
	end
end)

RegisterNetEvent('esx:setGroups')
AddEventHandler('esx:setGroups', function(groups)
	for group,v in pairs(groups) do
		if string.find(group, 'staff_level_') then
			ESX.PlayerData.isStaff = true
		elseif string.find(group, 'dev_level_') then
			ESX.PlayerData.isDev = true
		elseif string.find(group, 'donator_level_') then
			ESX.PlayerData.isDonator = true
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	for k,v in pairs(playerData) do
		ESX.PlayerData[k] = v
	end

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
	ESX.PlayerLoaded = true

	Citizen.Wait(3000)
	StartServerSyncLoops()
end)

RegisterNetEvent('esx:setName')
AddEventHandler('esx:setName', function(newName) ESX.SetPlayerData('name', newName) end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight', function(newMaxWeight) ESX.SetPlayerData('maxWeight', newMaxWeight) end)

AddEventHandler('esx:onPlayerSpawn', function() isDead = false end)
AddEventHandler('esx:onPlayerDeath', function() isDead = true end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(100)
	end

	TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function()
	local playerPed = PlayerPedId()
	RemoveAllPedWeapons(playerPed, true)

	for k,v in pairs(ESX.PlayerData.loadout) do
		local weaponName = v.name
		local weaponHash = GetHashKey(weaponName)

		GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
		SetPedWeaponTintIndex(playerPed, weaponHash, v.tintIndex)

		for k2,v2 in ipairs(v.components) do
			local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash
			GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
		end
	end

	for k,v in pairs(ESX.PlayerData.ammo) do
		if v.count > 0 then
			SetPedAmmo(playerPed, v.weaponHash, v.count)
		end
	end
end)

RegisterNetEvent('esx:setHealth')
AddEventHandler('esx:setHealth', function(health) SetEntityHealth(PlayerPedId(), health) end)

RegisterNetEvent('esx:setArmour')
AddEventHandler('esx:setArmour', function(armour) SetPedArmour(PlayerPedId(), armour) end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account) ESX.PlayerData.accounts[account.name] = account end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	local itemData = ESX.PlayerData.inventory[item]
	ESX.UI.ShowInventoryItemNotification(true, itemData.label, count - itemData.count)
	itemData.count = count
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	local itemData = ESX.PlayerData.inventory[item]
	ESX.UI.ShowInventoryItemNotification(false, itemData.label, itemData.count - count)
	itemData.count = count
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job) ESX.PlayerData.job = job end)

RegisterNetEvent('esx:setStat')
AddEventHandler('esx:setStat', function(stat, value)
	if stats[stat] then
		StatSetInt(stats[stat][1], value, true)
		ESX.PlayerData.stats[stat] = value
	end
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
	TriggerServerEvent("esx:weaponAdded", weaponHash)
	ESX.PlayerData.loadout[weaponName] = {name = weaponName, label = ESX.GetWeaponLabel(weaponName), components = {}, tintIndex = 0}
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
	ESX.PlayerData.loadout[weaponName].components[weaponComponent] = true
end)

RegisterNetEvent('esx:setAmmo')
AddEventHandler('esx:setAmmo', function(ammoType, ammo)
	SetPedAmmo(PlayerPedId(), Config.ammoTypes[ammoType].weaponHash, ammo)
	ESX.PlayerData.ammo[ammoType].count = ammo
end)

RegisterNetEvent('esx:setWeaponTint')
AddEventHandler('esx:setWeaponTint', function(weaponName, weaponTintIndex)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	SetPedWeaponTintIndex(playerPed, weaponHash, weaponTintIndex)
	ESX.PlayerData.loadout[weaponName].tintIndex = weaponTintIndex
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)

	RemoveWeaponFromPed(playerPed, weaponHash)
	ESX.PlayerData.loadout[weaponName] = nil
end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
	ESX.PlayerData.loadout[weaponName].components[weaponComponent] = nil
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(coords)
	local playerPed = PlayerPedId()

	-- ensure decmial number
	coords.x = coords.x + 0.0
	coords.y = coords.y + 0.0
	coords.z = coords.z + 0.0

	ESX.Game.Teleport(playerPed, coords)
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(vehicleName)
	local model = (type(vehicleName) == 'number' and vehicleName or GetHashKey(vehicleName))

	if IsModelInCdimage(model) then
		local playerPed = PlayerPedId()
		local playerCoords, playerHeading = GetEntityCoords(playerPed), GetEntityHeading(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			ESX.Game.DeleteEntity(GetVehiclePedIsIn(playerPed, false))
		end

		ESX.Game.SpawnVehicle(model, playerCoords, playerHeading, function(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			SetVehicleCurrentRpm(vehicle, 3000)
		end)
	else
		TriggerEvent('chat:addMessage', {templateId = 'rpuk', args = {'Invalid vehicle model.'}})
	end
end)

RegisterNetEvent('esx:registerSuggestions')
AddEventHandler('esx:registerSuggestions', function(registeredCommands)
	for name,command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
		end
	end
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function(radius)
	local playerPed = PlayerPedId()

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)

		for k,entity in ipairs(vehicles) do

			if ESX.Game.RequestNetworkControlOfEntity(entity, true) then
				ESX.Game.DeleteVehicle(entity)
			end
		end
	else
		local vehicle = ESX.Game.GetVehicleInDirection()

		if IsPedInAnyVehicle(playerPed, true) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		if ESX.Game.RequestNetworkControlOfEntity(vehicle, true) then
			ESX.Game.DeleteVehicle(vehicle)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)

		if IsPauseMenuActive() and not isPaused then
			isPaused = true

			TriggerEvent('rpuk_hud:toggleHud', false)
		elseif not IsPauseMenuActive() and isPaused then
			isPaused = false
			TriggerEvent('rpuk_hud:toggleHud', true)
		end
	end
end)

function StartServerSyncLoops()
	-- keep track of ammo
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			if isDead then
				Citizen.Wait(500)
			else
				local playerPed = PlayerPedId()
				if IsPedShooting(playerPed) then
					local _,weaponHash = GetCurrentPedWeapon(playerPed, true)
					local weapon = ESX.GetWeaponFromHash(weaponHash)

					while IsControlPressed(0, 24) do
						Citizen.Wait(0)
					end

					if weapon then
						local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
						TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)
					end
				end
			end
		end
	end)

	-- sync current player coords with server
	Citizen.CreateThread(function()
		local previousCoords = vector3(ESX.PlayerData.coords.x, ESX.PlayerData.coords.y, ESX.PlayerData.coords.z)

		while true do
			Citizen.Wait(10000)
			local playerPed = PlayerPedId()

			if DoesEntityExist(playerPed) then
				local playerCoords = GetEntityCoords(playerPed)
				local distance = #(playerCoords - previousCoords)

				if distance > 7 then
					previousCoords = playerCoords
					local playerHeading = ESX.Math.Round(GetEntityHeading(playerPed), 1)
					local formattedCoords = {x = ESX.Math.Round(playerCoords.x, 1), y = ESX.Math.Round(playerCoords.y, 1), z = ESX.Math.Round(playerCoords.z, 1), heading = playerHeading}
					TriggerServerEvent('esx:updateCoords', formattedCoords)
				end
			end
		end
	end)

	-- sync current player coords with server
	Citizen.CreateThread(function()
		local previousHealth, previousArmour = 0, 0

		while true do
			Citizen.Wait(10000)
			local playerPed = PlayerPedId()

			if DoesEntityExist(playerPed) then
				local health, armour, syncToDatabase = GetEntityHealth(playerPed), GetPedArmour(playerPed)

				if health ~= previousHealth then syncToDatabase = true end
				if armour ~= previousArmour then syncToDatabase = true end
				if syncToDatabase then TriggerServerEvent('esx:updateHealth', health, armour) end

				previousHealth, previousArmour = health, armour
			end
		end
	end)
end

-- Command Handlers

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(objectName)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)
	local model = (type(objectName) == 'number' and objectName or GetHashKey(objectName))

	ESX.Game.SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end)