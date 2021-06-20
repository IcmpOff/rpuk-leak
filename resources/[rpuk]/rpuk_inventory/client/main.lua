isInInventory = false
local trunkData = nil
local lastPut = GetGameTimer()
local maxWeight = ESX.GetConfig().MaxWeight
local secondary = nil
local isBlurry = false

RegisterNetEvent('rpuk_weather:isBlurry')
AddEventHandler('rpuk_weather:isBlurry', function(_isBlurry) isBlurry = _isBlurry end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight', function(_maxWeight) maxWeight = _maxWeight end)

RegisterNetEvent('rpuk_inventory:closeInventory')
AddEventHandler('rpuk_inventory:closeInventory', function() closeInventory() end)

RegisterNetEvent('rpuk_inventory:openSecondaryInventory')
AddEventHandler('rpuk_inventory:openSecondaryInventory',function(data, money, inventory, weapons, ammo)
	setSecondaryInventoryData(data, money, inventory, weapons, ammo)
	openSecondaryInventory(data)
end)

RegisterNetEvent('rpuk_inventory:refreshSecondaryInventory')
AddEventHandler('rpuk_inventory:refreshSecondaryInventory', function(data, money, inventory, weapons, ammo)
	setSecondaryInventoryData(data, money, inventory, weapons, ammo)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if isInInventory then
			SetNuiFocus(false)
			if not isBlurry then SetTimecycleModifier('default') end
		end
	end
end)

function getStatus() return isInInventory end

function checkAnimationStates()
	local playerPed = PlayerPedId()
	if IsEntityPlayingAnim(playerPed, "random@mugging3", "handsup_standing_base", 3) then return true end -- Surrender Standing Up Anim
	if IsEntityPlayingAnim(playerPed, "mp_arresting", "idle", 3) then return true end -- Restrain Anim
	if IsEntityPlayingAnim(playerPed, "random@arrests@busted", "idle_a", 3) then return true end
	if IsEntityPlayingAnim(playerPed, "anim@move_m@prisoner_cuffed", "idle", 3) then return true end -- Ziptie Anim
	if IsEntityPlayingAnim(playerPed, "dead", "dead_a", 3) then return true end -- Sedate Anim
	if IsEntityPlayingAnim(playerPed, "misslamar1dead_body", "dead_idle", 3) then return true end -- Dead Anim

	return false
end

function openInventory()
	local chatUI = exports['chat']:getStatus()
	local wheelUI = exports['rpuk_wheel']:getStatus()
	local phoneUI = exports['gcphone']:getStatus()

	if not chatUI and not wheelUI and not phoneUI and not checkAnimationStates() and not IsPauseMenuActive() then
		local playerPed = PlayerPedId()
		local pedCoords = GetEntityCoords(playerPed)
		local pedVehicle = GetVehiclePedIsIn(playerPed, false)
		local pickupObj = GetClosestObjectOfType(pedCoords, 2.0, GetHashKey("v_ret_ta_box"), false)

		if pedVehicle == 0 then -- on foot
			if DoesEntityExist(pickupObj) then -- object found so check the closest pickup
				ESX.TriggerServerCallback('rpuk_inventory:closestPickup', function(distance, id)
					if distance > 2 then -- closest pickup is greater than 2m so normal inventory
						loadPlayerInventory()
						isInInventory = true
						SendNUIMessage({action = 'display', type = 'normal'})
						TriggerEvent('rpuk_inventory:inventoryStatus', true)
						SetNuiFocus(true, true)
						SetTimecycleModifier('hud_def_blur')
					else -- closer than or equal to 2 meters so open the pickup inventory
						TriggerServerEvent('rpuk_inventory:openPickup', id)
					end
				end, pedCoords)
			else -- No object found so normal inventory
				loadPlayerInventory()
				isInInventory = true
				SendNUIMessage({action = 'display', type = 'normal'})
				TriggerEvent('rpuk_inventory:inventoryStatus', true)
				SetNuiFocus(true, true)
				SetTimecycleModifier('hud_def_blur')
			end
		else -- In a car so normal inventory
			loadPlayerInventory()
			isInInventory = true
			SendNUIMessage({action = 'display', type = 'normal'})
			TriggerEvent('rpuk_inventory:inventoryStatus', true)
			SetNuiFocus(true, true)
			SetTimecycleModifier('hud_def_blur')
		end
	end
end

RegisterKeyMapping('openinventory', 'Open player inventory', 'keyboard', 'F3')
TriggerEvent('chat:addSuggestion', '/openinventory', 'Open player inventory')
RegisterCommand('openinventory', openInventory)

function openSecondaryInventory(data)
	loadPlayerInventory()
	isInInventory = true
	SendNUIMessage({action = 'display', type = data.type})

	SetNuiFocus(true, true)
	SetTimecycleModifier('hud_def_blur')
end

function closeInventory()
	isInInventory = false
	SendNUIMessage({action = 'hide'})
	SetNuiFocus(false, false)
	if not isBlurry then SetTimecycleModifier('default') end
	TriggerEvent('rpuk_inventory:inventoryStatus', false, secondary)
end

function loadPlayerInventory()
	local items = {}
	local currentWeight = 0

	for k,v in pairs(ESX.Player.GetAmmo()) do
		if v.count > 0 then
			table.insert(items, {
				label = v.label, count = v.count, type = 'item_ammo',
				name = k, usable = false, canRemove = true
			})
		end
	end

	for k,v in pairs(ESX.Player.GetAccounts()) do
		if not Config.ExcludeAccountsList[v.name] then
			if v.money > 0 then
				table.insert(items, {
					label = v.label, count = v.money, type = 'item_account',
					name = v.name, usable = false, canRemove = true
				})
			end
		end
	end

	for k,v in pairs(ESX.Player.GetInventory()) do
		if v.count > 0 then
			v.type = 'item_standard'
			table.insert(items, v)
			currentWeight = currentWeight + (v.weight * v.count)
		end
	end

	for k,v in pairs(ESX.Player.GetLoadout()) do
		table.insert(items, {
			label = v.label, count = 1,
			type = 'item_weapon', name = v.name,
			usable = false, canRemove = true
		})
	end

	SendNUIMessage({
		action = 'setItems',
		itemList = items,
		text = ('Weight: %.0f / %.0f'):format(currentWeight, maxWeight)
	})
end

function setSecondaryInventoryData(data, money, inventory, weapons, ammo)
	secondary = data
	local items = {}
	SendNUIMessage({action = 'setInfoText', text = data.text})

	if data.typeOfInv then SendNUIMessage({action = 'updateType', typeOfInv = data.typeOfInv}) end

	if money then
		for k, v in pairs(money) do
			if v.count > 0 then
				table.insert(items, {
					count = v.count, label = v.label, name = v.name,
					type = 'item_account', usable = false, canRemove = false, data = v.data
				})
			end
		end
	end

	if ammo then
		for k, v in pairs(ammo) do
			if v.count > 0 then
				table.insert(items, {
					count = v.count, label = v.label, name = v.name,
					type = 'item_ammo', usable = false, canRemove = false, data = v.data
				})
			end
		end
	end

	if inventory then
		for k, v in pairs(inventory) do
			if v.count <= 0 then
				inventory[k] = nil
			else
				v.type = 'item_standard'
				v.usable = false
				v.canRemove = false
				table.insert(items, v)
			end
		end
	end

	if weapons then
		for k,v in pairs(weapons) do
			table.insert(items, {
				label = v.label, count = v.count, type = 'item_weapon',
				name = v.name, usable = false, canRemove = false, data = v.data
			})
		end
	end

	SendNUIMessage({ action = 'setSecondInventoryItems', itemList = items})
end

RegisterNUICallback('NUIFocusOff', function(data, cb)
	closeInventory()
	cb('ok')
end)

RegisterNUICallback('getNearbyPlayers', function(data, cb)
	local playerPed = PlayerPedId()
	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3)
	local elements = {}

	for i = 1, #players, 1 do
		if players[i] ~= PlayerId() then
			if IsEntityVisible(GetPlayerPed(players[i])) then
				local playerId = GetPlayerServerId(players[i])

				elements[tostring(playerId)] = {
					name = ('Stranger: %s'):format(playerId),
					playerId = playerId,
					icon = 'fa-user'
				}
			end
		end
	end

	cb(elements)
end)

RegisterNUICallback('PutIntoSecond', function(data, cb)
	if GetGameTimer() - lastPut < 50 then
		TriggerServerEvent('rpuk_anticheat:a', 'house_dupe_exploit')
		cb(false)
	else
		lastPut = GetGameTimer()

		if type(data.number) == 'number' and math.floor(data.number) == data.number and data.type and data.type ~= 'normal' then
			ESX.TriggerServerCallback(data.type .. ':putItem', function(success)
				if success then loadPlayerInventory() end
				cb(success)
			end, data.item.type, data.item.name, tonumber(data.number), secondary, data)
		else
			cb(false)
		end
	end
end)

RegisterNUICallback('TakeFromSecond', function(data, cb)
	if type(data.number) == 'number' and math.floor(data.number) == data.number and data.type then
		ESX.TriggerServerCallback(data.type .. ':getItem', function(success)
			if success then loadPlayerInventory() end
			cb(success)
		end, data.item.type, data.item.name, tonumber(data.number), secondary, data)
	end
end)

RegisterNUICallback('UseItem', function(data, cb)
	TriggerServerEvent('esx:useItem', data.item.name)
	Citizen.Wait(500)
	loadPlayerInventory()
	cb('ok')
end)

RegisterNUICallback('DropItem', function(data, cb)
	local playerPed = PlayerPedId()

	if IsPedOnFoot(playerPed) then
		if type(data.number) == 'number' and math.floor(data.number) == data.number then
			TriggerServerEvent('rpuk_inventory:dropItem', data.item.type, data.item.name, data.number, GetEntityCoords(playerPed))
		end

		ESX.Streaming.RequestAnimDict('anim@narcotics@trash')
		TaskPlayAnim(playerPed, 'anim@narcotics@trash', 'drop_front', 8.0, -8.0, 500, 33, 0, false, false, false)
		Wait(500)
		loadPlayerInventory()
		cb('ok')
	else
		ESX.ShowNotification('You are not on foot')
		cb('ok')
	end
end)

RegisterNUICallback('GiveItem', function(data, cb)
	local playerPed = PlayerPedId()
	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3)
	local foundPlayer = false

	for i = 1, #players, 1 do
		if players[i] ~= PlayerId() then
			if GetPlayerServerId(players[i]) == data.player and IsEntityVisible(GetPlayerPed(players[i])) then
				foundPlayer = true
				break
			end
		end
	end

	if foundPlayer then
		local count = tonumber(data.number)

		if data.item.type == 'item_weapon' then
			count = GetAmmoInPedWeapon(playerPed, GetHashKey(data.item.name))
		end

		TriggerServerEvent('esx:givePlayerInventoryItem', data.player, data.item.type, data.item.name, count)
		ESX.Streaming.RequestAnimDict('mp_common')
		TaskPlayAnim(playerPed, 'mp_common', 'givetake2_a', 8.0, -8.0, 500, 33, 0, false, false, false)
		Wait(500)
		loadPlayerInventory()
		cb('ok')
	else
		ESX.ShowNotification('That player is no longer near you')
		cb('ok')
	end
end)