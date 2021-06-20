local ownedHouses = nil
local ownedHouse = 0

local furniture = {}
local shellObj = nil
local knockedOnDoor = {}
local isInHouse = false
local typeOfEntry = nil

local isBreaching = false
local isStoringVehicle = false
local isInShop = false
local isRefurnishing = false
local deleteRefurnish = false
local houseData = nil
local hasStorageFurniture = false
local plantInteraction, buttonInteraction, oldSelected, selectedSeed = false, false, "Sativa", "Sativa"
local zones = {}

function inHouse() return isInHouse end
function hasAccess() return typeOfEntry end

function checkHouseData(key)
	if key then
		if houseData then
			return houseData[key]
		end
	else
		return houseData
	end
end

RegisterNetEvent("rpuk_housing:registerNewHouseAsOwned")
RegisterNetEvent("rpuk_housing:registerAsOwnerOfHouse")
RegisterNetEvent("rpuk_housing:enterHouse")
RegisterNetEvent("rpuk_housing:leaveHouse")
RegisterNetEvent("rpuk_housing:explosion")
RegisterNetEvent("rpuk_housing:explosionSound")
RegisterNetEvent("rpuk_housing:registerInteractionDefault")
RegisterNetEvent("rpuk_housing:knockedDoor")
RegisterNetEvent("rpuk_housing:letIn")
RegisterNetEvent("rpuk_housing:soldHouse")
RegisterNetEvent("rpuk_housing:soldOwnHouse")
RegisterNetEvent('esx:setJob')

AddEventHandler('esx:setJob', function()
	interactions = {}
	activeInteractions = {}
	updateInteractions()
end)

AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() and isInHouse then
		local doorCoords = config.houses[isInHouse].door
		ESX.Game.Teleport(PlayerPedId(), doorCoords)
	end
end)

function updateInteractions()
	local text
	-- if you own this house, then add a garage and add a owned blip
	if ownedHouse then
		local v = config.houses[ownedHouse]

		interactions[ownedHouse..":garage"] = createInteraction({
			id = ownedHouse..":garage",
			pos = vector3(v.garage.x, v.garage.y, v.garage.z),
			text = "Press ~y~E~s~ to store vehicle",
			canInteractWithCar = true,
			hasToBeInCar = true,
			dist = 50,
			action = function() if not isStoringVehicle then storeVehicle(ownedHouse) end end
		})

		createBlip(v.door, 40, 3, GetStreetNameFromHashKey(GetStreetNameAtCoord(v.door.x, v.door.y, v.door.z)) .. " " .. ownedHouse)
	end

	for k,v in pairs(config.houses) do
		if config.addHouseBlips then
			local blip = AddBlipForCoord(v.door)
			SetBlipSprite (blip, 1)
			SetBlipScale(blip, 0.4)
			local colour = 1

			if ownedHouses[k] then colour = 3 end

			SetBlipColour (blip, colour)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("House")
			EndTextCommandSetBlipName(blip)
		end

		if ownedHouse == k then
			text = "Press ~y~E~s~ to interact with house"
		elseif ownedHouses[k] == nil and not ownedHouse then
			text = "Press ~y~E~s~ to buy house"
		elseif isInList(ESX.Player.GetJobName(), config.canRaid) and ownedHouses[k] ~= nil then
			text = "Press ~y~E~s~ to interact with house"
		elseif ownedHouses[k] ~= nil then
			text = "Press ~y~E~s~ to push door bell"
		else
			text = "Press ~y~E~s~ to interact"
		end

		interactions[k] = createInteraction({
			id = k, pos = v.door, text = text,
			action = function() defaultAction(k,v) end -- The action called when pressing E on a house
		})
	end
end

function spawned()
	ESX.TriggerServerCallback("rpuk_housing:getAllOwnedHousesAndMyOwnHouse", function(_ownedHouse, _ownedHouses)
		ownedHouse, ownedHouses = _ownedHouse, _ownedHouses
		updateInteractions()
	end)

	interactions["ikea"] = createInteraction({
		id = "ikea", pos = config.furnituring.enter, text = "Press ~y~E~s~ to shop",
		action = function() shopIkea() end
	})
end

function HelpText(msg, coords)
	if not coords or not Config.Use3DText then
		ESX.ShowHelpNotification(msg, true)
	else
		ESX.Game.Utils.DrawText3D(coords, string.gsub(msg, "~INPUT_CONTEXT~", "~r~[~w~E~r~]~w~"), 0.6)
	end
end

function createBlip(pos, sprite, colour, display)
	local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
	SetBlipSprite(blip, sprite)
	SetBlipColour(blip, colour)
	SetBlipScale  (blip, 0.85)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(display)
	EndTextCommandSetBlipName(blip)
end

AddEventHandler("rpuk_housing:registerNewHouseAsOwned", function(houseId)
	ownedHouses[houseId] = true

	local text = ""
	if ownedHouse == houseId then
		text = "Press ~y~E~s~ to interact with house"
	elseif ownedHouses[houseId] == nil and ownedHouse == 0 then
		text = "Press ~y~E~s~ to buy house"
	elseif (isInList(ESX.Player.GetJobName(), config.canRaid) or isInList(ESX.Player.GetJobName(), config.medics)) and ownedHouses[houseId] ~= nil then
		text = "Press ~y~E~s~ to interact with house"
	elseif ownedHouses[houseId] ~= nil then
		text = "Press ~y~E~s~ to Push Door Bell"
	end

	interactions[houseId].text = text
	interactions[houseId].refreshInteraction = true
end)

AddEventHandler("rpuk_housing:registerInteractionDefault", function(id)
	local k = id
	local v = config.houses[k]
	local text = ""
	if ownedHouse == k then
		text = "Press ~y~E~s~ to interact with house"
	elseif ownedHouses[k] == nil and not ownedHouse then
		text = "Press ~y~E~s~ to buy house"
	elseif (isInList(ESX.Player.GetJobName(), config.canRaid) or isInList(ESX.Player.GetJobName(), config.medics)) and ownedHouses[k] ~= nil then
		text = "Press ~y~E~s~ to interact with house"
	elseif ownedHouses[k] ~= nil then
		text = "Press ~y~E~s~ to Push Door Bell"
	end

	interactions[k] = createInteraction({
		id = k,
		pos = v.door,
		text = text,
		action = function() -- The action happening when pressing E on a house
			defaultAction(k,v)
		end
	})
end)

function defaultAction(k,v)
	local elements = {}

	if isBreaching then return end

	ESX.UI.Menu.CloseAll()
	table.insert(elements, {label = "House 	Number: "..k, value = nil})
	table.insert(elements, {label = "", value = nil})

	if ownedHouse == k then
		local resellPrice = ESX.Math.GroupDigits(math.floor(v.price * config.sellPercentage))
		table.insert(elements, {label = "Enter house", value = "enterOwner"})
		table.insert(elements, {label = "Use garage", value = "useGarage"})
		table.insert(elements, {
			label = ("Sell house for <span style='color:green;'>£%s</span>"):format(resellPrice),
			value = "sellHouse"
		})
	elseif ownedHouses[k] == nil and not ownedHouse then
		table.insert(elements, {
			label = ("Buy house for <span style='color:green;'>£%s</span>"):format(ESX.Math.GroupDigits(v.price)),
			value = "buyHouse"
		})

		table.insert(elements, {label = "Visit house", value = "visit"})
	elseif isInList(ESX.Player.GetJobName(), config.canRaid) and ownedHouses[k] ~= nil then
		table.insert(elements, {label = "Raid house", value = "raid"})
		table.insert(elements, {label = "Push Door Bell", value = "knock"})
	elseif isInList(ESX.Player.GetJobName(), config.medics) and ownedHouses[k] ~= nil then
		table.insert(elements, {label = "Enter house", value = "enterMedic"})
		table.insert(elements, {label = "Push Door Bell", value = "knock"})
	elseif ownedHouses[k] ~= nil then
		TriggerServerEvent("rpuk_housing:knock", k)
		return
	end

	table.insert(elements, {label = "", value = nil})
	table.insert(elements, {label = "Close", value = "close"})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "buyHouse", {
		title = "",
		css = "housing",
		align = "top-left",
		elements = elements
	}, function(data, menu)
		if data.current.value == "buyHouse" then
			TriggerServerEvent("rpuk_housing:buyHouse", k)
			menu.close()
		elseif data.current.value == "enterOwner" then
			TriggerServerEvent("rpuk_housing:enter", k, "owner")
			menu.close()
		elseif data.current.value == "visit" then
			TriggerServerEvent("rpuk_housing:enter", k, "visit")
			menu.close()
		elseif data.current.value == "raid" then
			ESX.TriggerServerCallback("rpuk_housing:hasItem", function(hasItem, message, emergencyWarrant)
				if hasItem then
					isBreaching = true
					menu.close()
					TriggerServerEvent("rpuk_housing:alertOwner", k)
					TriggerEvent("mythic_progbar:client:progress", {
						name = "breachDoor",
						duration = 1700,
						label = "Attaching Breaching Charge",
						useWhileDead = false,
						canCancel = false,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						animation = {
							animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
							anim = "plant_vertical",
							flags = 15,
							task = nil,
						},
						prop = {
							model = "prop_bomb_01",
							bone = 28422,
							coords = { x = 0.0, y = 0.0, z = 0.0 },
							rotation = { x = 0.0, y = 0.0, z = 200.0 },
						}
					}, function(status)
						if not status then
							TriggerServerEvent("rpuk_housing:explosion", k)
						end
					end)
				else
					TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = message })
				end
			end, "breaching_charge", 1, k)
		elseif data.current.value == "enterMedic" then
			TriggerServerEvent("rpuk_housing:enter", k, "medic")
			menu.close()
		elseif data.current.value == "knock" then
			TriggerEvent("InteractSound_CL:PlayOnOne","doorbell",0.7)
			TriggerServerEvent("rpuk_housing:knock", k)
			menu.close()
		elseif data.current.value == "sellHouse" then
			TriggerEvent('mythic_notify:client:PersistentAlert', {
				action = "START",
				id = 1,
				type = 'error',
				text = 'By confirming this sale you will loose access to cars in house garage, loose the items in the house and all your furniture'
			})

			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "sellHouse", {
				css = "housing",
				align = "top-left",
				title = "",
				elements = {
					{label = "Read Top Right", value = ""},
					{label = "Confirm Sale", value = "yes"},
					{label = "Back", value = "no"}
			}},function(data2, menu2)
				if data2.current.value == "yes" then
					TriggerServerEvent("rpuk_housing:sellHouse", k)
					ESX.UI.Menu.CloseAll()
					TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 1})
				elseif data2.current.value == "no" then
					menu2.close()
					TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 1})
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == "useGarage" then
			openGarage(ownedHouse)
		elseif data.current.value == "close" then
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

AddEventHandler("rpuk_housing:registerAsOwnerOfHouse", function(houseId)
	ownedHouse = houseId
	ownedHouses[houseId] = true
	local text = ""

	if ownedHouse == houseId then
		text = "Press ~y~E~s~ to interact with house"
	elseif ownedHouses[houseId] == nil and ownedHouse == 0 then
		text = "Press ~y~E~s~ to purchase house"
	elseif isInList(ESX.Player.GetJobName(), config.canRaid) and ownedHouses[houseId] ~= nil then
		text = "Press ~y~E~s~ to interact with house"
	elseif ownedHouses[houseId] ~= nil then
		text = "Press ~y~E~s~ to Push Door Bell"
	end

	interactions[houseId].text = text
	interactions[houseId].refreshInteraction = true
	createBlip(config.houses[ownedHouse].door, 40, 3, GetStreetNameFromHashKey(GetStreetNameAtCoord(config.houses[ownedHouse].door.x, config.houses[ownedHouse].door.y, config.houses[ownedHouse].door.z)) .. " " .. ownedHouse)
end)

AddEventHandler("rpuk_housing:enterHouse", function(data, type)
	local ped = PlayerPedId()
	local couldNotLoad = {}
	knockedOnDoor = data.knocked
	isInHouse = data.id
	houseData = data
	typeOfEntry = type
	FreezeEntityPosition(ped, true)

	upCullingDistanceToNearbyVehicles()

	shellObj = createShell(config.props[data.prop].obj, config.houseSpawns[data.houseSpawn].coords)
	furnituringZones(data.houseSpawn, data.prop)
	Citizen.CreateThread(function()
		for k,v in pairs(data.furniture) do
			local model = GetHashKey(v.object)
			local count = 0
			if couldNotLoad[v.object] == nil and IsModelInCdimage(model) then
				RequestModel(model)
				Citizen.Wait(10)
				while not HasModelLoaded(model) do
					Citizen.Wait(10)
					count = count + 10
					if count > 2000 then
						couldNotLoad[v.object] = true
						TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "Report to a dev that obj: " .. v.object .. " could not load" })
						break
					end
				end
				if couldNotLoad[v.object] == nil then
					local obj = CreateObject(model, GetOffsetFromEntityInWorldCoords(shellObj, vector3(v.offset[1], v.offset[2], v.offset[3])), false, true, false)
					SetModelAsNoLongerNeeded(model)
					SetEntityHeading(obj, v.heading)
					FreezeEntityPosition(obj, true)
					SetEntityCoordsNoOffset(obj, GetOffsetFromEntityInWorldCoords(shellObj, vector3(v.offset[1], v.offset[2], v.offset[3])))
					furniture[k] = {
						obj = obj,
						pos = GetEntityCoords(obj),
						interactionId = "furniture:" .. k
					}
					if v.category == "Storage" and config.access[type].storage then
						hasStorageFurniture = true
						interactions["furniture:" .. k] = createInteraction({
							id = "furniture:" .. k,
							pos = furniture[k].pos,
							text = "Press ~y~E~s~ to open storage",
							action = function()
								TriggerServerEvent("rpuk_housing:openStorage", data.id)
							end
						})
					elseif config.GrowingInteracts[v.object] then
						if houseData.id == ownedHouse then -- I own the house
							local txt = "~b~" .. config.GrowingInteracts[v.object].label .. "~s~\n" .. config.GrowingInteracts[v.object].stage
							if v["plantData"] then
								if v["plantData"]["seed"] then txt = txt .. "\nSeed: " .. v["plantData"]["seed"] end
								if v["plantData"]["watered"] then txt = txt .. "\nWatered: ~g~Yes~s~" else txt = txt .. "\nWatered: ~r~No~s~" end
								if v["plantData"]["soiled"] then txt = txt .. "\nSoil: ~g~Yes~s~" else txt = txt .. "\nSoil: ~r~No~s~" end
							end
							interactions["furniture:" .. k] = createInteraction({
								id = "furniture:" .. k,
								pos = furniture[k].pos,
								text = txt,
								action = function()
									HandleGrowingInteraction(k, v)
								end
							})
						elseif (ESX.Player.GetJobName() == "police") then
							interactions["furniture:" .. k] = createInteraction({
								id = "furniture:" .. k,
								pos = furniture[k].pos,
								text = "Plant",
								action = function()
									HandleRipUp(houseData.id, k, v)
								end
							})
						end
					end
				end
			end
		end

		interactions.exit = createInteraction({
			id = "exit",
			pos = data.exit,
			text = "Press ~y~E~s~ to exit",
			action = function()
				TriggerServerEvent("rpuk_housing:leave", data.id)
				knockedOnDoor = {}
				isInHouse = false
				houseData = nil
				typeOfEntry = nil
			end
		})
	end)

	DoScreenFadeOut(750)
	while not IsScreenFadedOut() do Wait(0) end

	RequestCollisionAtCoord(data.exit.x, data.exit.y, data.exit.z)
	RequestModel(config.props[data.prop].obj)
	SetEntityCoords(ped, data.exit.x, data.exit.y, data.exit.z+0.5)

	for i = 1, 25 do
		SetEntityCoords(ped, data.exit.x, data.exit.y, data.exit.z+0.5)
		Wait(50)
	end

	while not HasCollisionLoadedAroundEntity(ped) do
		SetEntityCoords(ped, data.exit.x, data.exit.y, data.exit.z+0.5)
		Wait(50)
	end

	SetEntityCoords(ped, data.exit.x, data.exit.y, data.exit.z)
	DoScreenFadeIn(1500)
	TriggerEvent("InteractSound_CL:PlayOnOne","doorOpen",0.7)
	FreezeEntityPosition(ped, false)
	SetTimeAndWeather()

	Citizen.CreateThread(function()
		while isInHouse do
			Citizen.Wait(0)
			local coords = GetEntityCoords(ped)
			SetTimeAndWeather()
			if coords.z <= -100 then
				SetEntityCoords(ped, data.exit.x, data.exit.y, data.exit.z)
			end
		end
	end)
end)

AddEventHandler("rpuk_housing:leaveHouse", function(coords)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)

	DoScreenFadeOut(750)
	while not IsScreenFadedOut() do Wait(0) end
	DoScreenFadeIn(1500)

	TriggerEvent("InteractSound_CL:PlayOnOne","doorClose",0.7)
	SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)

	for k,v in pairs(furniture) do
		DeleteObject(v.obj)
		if v.interactionId then
			interactions[v.interactionId] = nil
		end
	end

	DeleteObject(shellObj)
	interactions.exit = nil
	hasStorageFurniture = false
end)

AddEventHandler("rpuk_housing:knockedDoor", function(_source, name)
	knockedOnDoor[_source] = name
end)

AddEventHandler("rpuk_housing:letIn", function(id)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	if getDistance(coords, config.houses[id].door) > 5 then
		TriggerEvent('mythic_notify:client:SendAlert', { length = 2500, action = 'longnotif', type = 'inform', text = "Standing to far away from door"})
	else
		TriggerServerEvent("rpuk_housing:enter", id, "visit")
	end
end)

function createShell(prop, coords)
	local obj = CreateObject(prop, coords, false, true, false)
	FreezeEntityPosition(obj, true)
	SetEntityHeading(obj, 0.0)
	return obj
end

function SetTimeAndWeather()
	NetworkOverrideClockTime(15, 0, 0)
	ClearOverrideWeather()
	ClearWeatherTypePersist()
	SetWeatherTypePersist('EXTRASUNNY')
	SetWeatherTypeNow('EXTRASUNNY')
	SetWeatherTypeNowPersist('EXTRASUNNY')
end

AddEventHandler("rpuk_housing:explosion", function(pos)
	Citizen.Wait(9650)
	AddExplosion(pos.x, pos.y, pos.z, "EXPLOSION_STICKYBOMB", false, true, false, true)
	isBreaching = false
end)

AddEventHandler("rpuk_housing:explosionSound", function(pos, id)
	local soundID = GetSoundId()
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)

	for i=1, 8 do
		PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
		Citizen.Wait(1000)
	end

	Citizen.Wait(500)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(500)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(250)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(250)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(150)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	StopSound(soundID)
	ReleaseSoundId(soundID)

	if id ~= ownedHouse then
		interactions[id].text = "Press ~y~E~s~ to enter"
		interactions[id].action = function()
			TriggerServerEvent("rpuk_housing:enter", id, "raider")
		end
	end
end)

function upCullingDistanceToNearbyVehicles()
	local nearbyVehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(PlayerPedId()), 50)
	local nearbyVehiclesNetworkIds = {}

	for k,entityHandle in ipairs(nearbyVehicles) do
		if GetPedInVehicleSeat(entityHandle, -1) == 0 then
			if NetworkGetEntityIsNetworked(entityHandle) then
				local networkId = NetworkGetNetworkIdFromEntity(entityHandle)

				if networkId then
					table.insert(nearbyVehiclesNetworkIds, networkId)
				end
			end
		end
	end

	if #nearbyVehiclesNetworkIds > 0 then
		TriggerServerEvent('rpuk_housing:upCullingDistance', nearbyVehiclesNetworkIds)
	end
end

function storeVehicle(id)
	isStoringVehicle = true
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

	if vehicle ~= 0 then
		ESX.TriggerServerCallback("rpuk_housing:ownsVehicle", function(data)
			if data then
				ESX.TriggerServerCallback("rpuk_housing:canStoreCar", function(canStore)
					if canStore then
						storeVehicleTimer(vehicle, vehicleData, id)
					else
						isStoringVehicle = false
						TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "Too many cars already in garage" })
					end
				end, id, vehicleData.plate)
			else
				isStoringVehicle = false
				TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "You do not own this vehicle" })
			end
		end, vehicleData.plate)
	else
		isStoringVehicle = false
		TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "You are not in a vehicle" })
	end
end

function storeVehicleTimer(vehicle, vehicleData, id)
	Citizen.CreateThread(function()
		local timer = 15 -- 15 Seconds until it gets stored

		while GetVehiclePedIsIn(PlayerPedId()) == vehicle and timer > 0 and getDistance(GetEntityCoords(vehicle), interactions[ownedHouse..":garage"].pos) < 20 do
			interactions[ownedHouse..":garage"].text = "Wait in your vehicle for " .. timer .. " seconds"
			Citizen.Wait(1000)
			timer = timer-1
		end

		if timer <= 0 and getDistance(GetEntityCoords(vehicle), interactions[ownedHouse..":garage"].pos) < 20 then
			TriggerServerEvent("rpuk_housing:storeVehicle", vehicleData.plate)
			DeleteEntity(vehicle)
		end

		interactions[ownedHouse..":garage"].text = "Press ~y~E~s~ to store vehicle"
		interactions[ownedHouse..":garage"].refreshInteraction = true
		isStoringVehicle = false
	end)
end

function openGarage(houseId)
	ESX.TriggerServerCallback("rpuk_housing:getVehiclesInGarage", function(vehicles)
		local elem = {}

		for k,v in pairs(vehicles) do
			table.insert(elem, {
				label = GetLabelText(GetDisplayNameFromVehicleModel(json.decode(v.vehicle).model)) .. " <span style='color:cyan;'>[" .. v.plate .. "]</span>",
				value = k
			})
		end

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'housing_garage', {
			title = '',
			css = "parking",
			align = 'top-left',
			elements = elem
		}, function(data, menu)
			local garage = config.houses[houseId].garage

			if ESX.Game.IsSpawnPointClear(vector3(garage.x, garage.y, garage.z), 5) then
				local vehicleData = json.decode(vehicles[data.current.value].vehicle)
				ESX.Game.SpawnVehicle(vehicleData.model, vector3(garage.x, garage.y, garage.z), garage.w, function(vehicle)

				end, vehicleData, {giveKeys = true})

				TriggerServerEvent("rpuk_housing:removeCarFromGarage", vehicleData.plate)
				ESX.UI.Menu.CloseAll()
			else
				menu.close()
				TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "Garage blocked" })
			end
		end, function(data, menu)
			menu.close()
		end)
	end, houseId)
end

function shopIkea()
	if ownedHouse then
		isInShop = true
		-- FreezeEntityPosition(PlayerPedId(), true)
		local currentCategory = 1
		local category = config.furniture.categories[currentCategory]
		local current = 1
		local isChanging = false
		local model = GetHashKey(config.furniture[category[1]][current][2])
		local count = 0

		if IsModelInCdimage(model) then
			RequestModel(model)
			Citizen.Wait(10)

			while not HasModelLoaded(model) do
				Citizen.Wait(10)
				count = count + 10

				if count > 2000 then
					ESX.ShowNotification(('Please report to the development team that the object %s could not load (2 secs)')
						:format(config.furniture[category[1]][current][2]), 5000, 'error')
					break
				end
			end
		else
			ESX.ShowNotification(('Please report to the development team that the object %s does not exist')
				:format(config.furniture[category[1]][current][2]), 5000, 'error')
		end

		local tempFurniture = CreateObject(model, config.furnituring.teleport)
		SetModelAsNoLongerNeeded(model)
		SetEntityHeading(tempFurniture, 0.0)

		local cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
		SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, -5.0, 4.0))
		PointCamAtCoord(cam, GetEntityCoords(tempFurniture))
		RenderScriptCams(1, 0, 0, 1, 1)
		SetCamActive(cam, true)
		FreezeEntityPosition(PlayerPedId(), true)

		Citizen.CreateThread(function()
			while isInShop do
				Wait(0)
				SetTimeAndWeather()
			end
		end)

		while true do
			Wait(0)
			HelpText((strings.buyingFurniture):format(category[2], config.furniture[category[1]][current][1], config.furniture[category[1]][current][3]))

			ESX.Game.Utils.DrawText3D(GetEntityCoords(tempFurniture), ('%s (~g~£%s~w~)'):format(config.furniture[category[1]][current][1], config.furniture[category[1]][current][3]), 1.0, 4)

			DisableControlAction(0, 24)
			DisableControlAction(0, 25)
			DisableControlAction(0, 14)
			DisableControlAction(0, 15)
			DisableControlAction(0, 16)
			DisableControlAction(0, 17)

			if IsControlJustReleased(0, 194) then -- Control for backspace
				DeleteObject(tempFurniture)
				break
			elseif IsControlJustReleased(0, 172) and not isChanging then
				isChanging = true
				tempFurniture, category, currentCategory, current = ikeaChange(tempFurniture, category, currentCategory, current, 1, 0)
				isChanging = false
			elseif IsControlJustReleased(0, 173) and not isChanging then
				isChanging = true
				tempFurniture, category, currentCategory, current = ikeaChange(tempFurniture, category, currentCategory, current, -1, 0)
				isChanging = false
			elseif IsControlJustReleased(0, 190) and not isChanging then
				isChanging = true
				tempFurniture, category, currentCategory, current = ikeaChange(tempFurniture, category, currentCategory, current, 0, 1)
				isChanging = false
			elseif IsControlJustReleased(0, 189) and not isChanging then
				isChanging = true
				tempFurniture, category, currentCategory, current = ikeaChange(tempFurniture, category, currentCategory, current, 0, -1)
				isChanging = false
			elseif IsControlPressed(0, 34) then
				SetEntityHeading(tempFurniture, GetEntityHeading(tempFurniture) + 0.25)
			elseif IsControlPressed(0, 35) then
				SetEntityHeading(tempFurniture, GetEntityHeading(tempFurniture) - 0.25)
			elseif IsDisabledControlPressed(0, 96) then
				local currentCoord = GetCamCoord(cam)
				if currentCoord.z + 0.1 <= GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, -5.0, 4.5).z then
					currentCoord = vector3(currentCoord.x, currentCoord.y, currentCoord.z + 0.1)
					SetCamCoord(cam, currentCoord)
				end
			elseif IsDisabledControlPressed(0, 97) then
				local currentCoord = GetCamCoord(cam)
				if currentCoord.z - 0.1 >= GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, -5.0, 0.1).z then
					currentCoord = vector3(currentCoord.x, currentCoord.y, currentCoord.z - 0.1)
					SetCamCoord(cam, currentCoord)
				end
			elseif IsControlPressed(0, 33) then
				local fov = GetCamFov(cam)
				if fov + 0.1 >= 129.9 then fov = 129.9 else fov = fov + 0.1 end
				SetCamFov(cam, fov)
			elseif IsControlPressed(0, 32) then
				local fov = GetCamFov(cam)
				if fov - 0.1 <= 1.1 then fov = 1.1 else fov = fov - 0.1 end
				SetCamFov(cam, fov)
			elseif IsControlJustReleased(0, 191) then
				local answered = false

				ESX.UI.Menu.CloseAll()
				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "rpuk_housing_furniture", {
					title = (strings.confirmPurchase):format(config.furniture[category[1]][current][1], config.furniture[category[1]][current][3]),
					css = "housing_2",
					align = "center",
					elements = {
						{label = strings.yes, value = true},
						{label = strings.no, value = false}
				}}, function(data, menu)
					if data.current.value then
						TriggerServerEvent("rpuk_housing:buyFurniture", ownedHouse, category, current)
					end
					answered = true
					menu.close()
				end, function(data, menu)
					answered = true
					menu.close()
				end)

				while not answered do Wait(100) end
				Wait(250)
			end
		end

		FreezeEntityPosition(PlayerPedId(), false)
		DeleteObject(tempFurniture)
		RenderScriptCams(false, false, 0, true, false)
		DestroyCam(cam)
		isInShop = false
	else
		TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "You do not own a house" })
	end
end

RegisterNetEvent("rpuk_housing:remoteFurnish")
AddEventHandler("rpuk_housing:remoteFurnish", function(prop, label, count)
	if ownedHouse then
		TriggerServerEvent("rpuk_housing:remoteFurnish", ownedHouse, prop, label, count)
	else
		TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "You do not own a house" })
	end
end)

function ikeaChange(tempFurniture, category, currentCategory, current, categoryChange, furnitureChange)
	if categoryChange ~= 0 then
		if config.furniture.categories[currentCategory+categoryChange] then
			category = config.furniture.categories[currentCategory+categoryChange]
			currentCategory = currentCategory+categoryChange
			current = 1
		else
			category = config.furniture.categories[1]

			if categoryChange == 1 then
				currentCategory = 1
			else
				currentCategory = #config.furniture.categories
			end

			current = 1
		end
	elseif furnitureChange ~= 0 then
		if config.furniture[category[1]][current + furnitureChange] then
			current = current+furnitureChange
		else
			if furnitureChange == 1 then
				current = 1
			else
				current = #config.furniture[category[1]]
			end
		end
	end
	DeleteObject(tempFurniture)
	model = GetHashKey(config.furniture[category[1]][current][2])

	local count = 0
	if IsModelInCdimage(model) then
		RequestModel(model)
		Citizen.Wait(10)

		while not HasModelLoaded(model) do
			Citizen.Wait(10)
			count = count + 10
			if count > 2000 then
				TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "Report to a dev that obj: " .. model .. " could not load" })
			end
		end
	end

	tempFurniture = CreateObject(model, config.furnituring.teleport)
	SetModelAsNoLongerNeeded(model)
	SetEntityHeading(tempFurniture, 0.0)

	return tempFurniture, category, currentCategory, current
end

function startFurnishing(id, houseSpawn, prop)
	ESX.TriggerServerCallback("rpuk_housing:getBoughtFurniture", function(tempFurniture)
		if not next(tempFurniture) then
			TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "You do not own any furniture" })
			return
		end

		local elem = {}
		for k,v in pairs(tempFurniture) do
			local xlabel

			if config.GrowingInteracts[k] then
				xlabel = config.GrowingInteracts[k].label
			else
				xlabel = v.name .. " x" .. v.amount
			end

			table.insert(elem, {
				value = k,
				label = xlabel
			})
		end

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "rpuk_housing_furnishing", {
			title = "",
			css = "housing",
			align = "top-left",
			elements = elem
		}, function(data, menu)
			placeFurniture(id, houseSpawn, config.houseSpawns[houseSpawn].coords + config.offsets[prop].spawn_furniture, data.current.value, tempFurniture[data.current.value].name, false)
		end, function(data, menu)
			menu.close()
		end)
	end, ownedHouse)
end

function placeFurniture(id, houseSpawn, propCoords, object, label, refurnish, refurnishId)
	Citizen.CreateThread(function()
		local spawnLocation = propCoords
		local model = GetHashKey(object)
		ESX.UI.Menu.CloseAll()
		local count = 0

		if IsModelInCdimage(model) then
			RequestModel(model)
			Citizen.Wait(10)
			while not HasModelLoaded(model) do
				Citizen.Wait(10)
				count = count + 10
				if count > 2000 then
					TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "Report to a dev that obj: " .. model .. " could not load" })
				end
			end
		end

		local tempFurniture = CreateObject(model, spawnLocation, true)
		SetModelAsNoLongerNeeded(model)
		SetEntityCollision(tempFurniture, false, false)
		SetEntityHasGravity(tempFurniture, false)
		Wait(250)

		Citizen.CreateThread(function()
			local hasPressedEnter = false
			local hasNotPlaced = true

			while hasNotPlaced and isInHouse do
				Wait(0)

				HelpText(strings.furnishing)
				DisableControlAction(0, 24)
				DisableControlAction(0, 25)
				DisableControlAction(0, 14)
				DisableControlAction(0, 15)
				DisableControlAction(0, 16)
				DisableControlAction(0, 17)
				ESX.Game.Utils.DrawText3D(GetEntityCoords(tempFurniture), ('%s, %s: %s'):format(label, strings.rotation, string.format("%.2f", GetEntityHeading(tempFurniture))), 0.3)

				if IsControlPressed(0, 173) and not hasPressedEnter then
					if IsDisabledControlPressed(0, 61) then
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, 0.03, 0.0))
					elseif IsControlPressed(0, 210) then
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, 0.005, 0.0))
					else
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, 0.01, 0.0))
					end
				end

				if IsControlPressed(0, 172) and not hasPressedEnter then
					if IsDisabledControlPressed(0, 61) then
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, -0.03, 0.0))
					elseif IsControlPressed(0, 210) then
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, -0.005, 0.0))
					else
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, -0.01, 0.0))
					end
				end

				if IsDisabledControlPressed(0, 175) and not hasPressedEnter then
					if IsDisabledControlPressed(0, 61) then
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, -0.03, 0.0, 0.0))
					elseif IsControlPressed(0, 210) then
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, -0.005, 0.0, 0.0))
					else
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, -0.01, 0.0, 0.0))
					end
				end

				if IsDisabledControlPressed(0, 174) and not hasPressedEnter then
					if IsDisabledControlPressed(0, 61) then
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.03, 0.0, 0.0))
					elseif IsControlPressed(0, 210) then
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.005, 0.0, 0.0))
					else
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.01, 0.0, 0.0))
					end
				end

				if IsDisabledControlPressed(0, 96) and not hasPressedEnter then
					if IsDisabledControlPressed(0, 61) then
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, 0.0, 0.03))
					elseif IsControlPressed(0, 210) then
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, 0.0, 0.005))
					else
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, 0.0, 0.01))
					end
				end

				if IsDisabledControlPressed(0, 97) and not hasPressedEnter then
					if IsDisabledControlPressed(0, 61) then
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, 0.0, -0.03))
					elseif IsControlPressed(0, 210) then
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, 0.0, -0.005))
					else
						SetEntityCoords(tempFurniture, GetOffsetFromEntityInWorldCoords(tempFurniture, 0.0, 0.0, -0.01))
					end
				end

				if IsDisabledControlPressed(0, 24) and not hasPressedEnter then
					if IsDisabledControlPressed(0, 61) then
						SetEntityHeading(tempFurniture, GetEntityHeading(tempFurniture)+1.5)
					elseif IsControlPressed(0, 210) then
						SetEntityHeading(tempFurniture, GetEntityHeading(tempFurniture)+0.1)
					else
						SetEntityHeading(tempFurniture, GetEntityHeading(tempFurniture)+0.5)
					end
				end

				if IsDisabledControlPressed(0, 25) and not hasPressedEnter then
					if IsDisabledControlPressed(0, 61) then
						SetEntityHeading(tempFurniture, GetEntityHeading(tempFurniture)-1.5)
					elseif IsControlPressed(0, 210) then
						SetEntityHeading(tempFurniture, GetEntityHeading(tempFurniture)-0.1)
					else
						SetEntityHeading(tempFurniture, GetEntityHeading(tempFurniture)-0.5)
					end
				end

				if IsControlJustReleased(0, 47) and not hasPressedEnter then
					PlaceObjectOnGroundProperly(tempFurniture)
				end

				if IsControlJustReleased(0, 215) and not hasPressedEnter then
					hasPressedEnter = true
					local coords = GetEntityCoords(tempFurniture)
					local isInside = false

					for k,v in pairs(zones) do
						if v:isPointInside(coords) then
							isInside = true
							break
						end
					end

					if isInside then
						if refurnish then
							deleteRefurnish = true
							isRefurnishing = false
							TriggerServerEvent("rpuk_housing:refurnished", id, refurnishId, coords-GetEntityCoords(shellObj), GetEntityHeading(tempFurniture))
							hasNotPlaced = false
						else
							ESX.TriggerServerCallback("rpuk_housing:placeBoughtFurniture", function(success, message)
								if success then
									TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'inform', text = message })
									SetEntityCollision(tempFurniture, true, false)
									FreezeEntityPosition(tempFurniture, true)
									TriggerServerEvent("rpuk_housing:placedFurniture", id, object, coords-GetEntityCoords(shellObj), GetEntityHeading(tempFurniture))
									hasNotPlaced = false
									local isStorage = nil

									for k,v in pairs(config.furniture.Storage) do
										if v[2] == object then
											for i=1,500 do
												if not interactions["furniture:"..i] then
													print(GetEntityCoords(tempFurniture))
													interactions["furniture:"..i] = createInteraction({
														id = "furniture:"..i,
														pos = GetEntityCoords(tempFurniture),
														text = "Press ~y~E~s~ to open storage",
														action = function()
															TriggerServerEvent("rpuk_housing:openStorage", id)
														end
													})

													isStorage = "furniture:"..i
													hasStorageFurniture = true
													break
												end
											end
										end
									end

									table.insert(furniture, {
										obj = tempFurniture,
										interactionId = isStorage
									})
								else
									hasPressedEnter = true
									TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = message })
								end
							end, id, object)
						end
					else
						hasPressedEnter = true
						TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "Furniture needs to be inside of the house" })
					end
				end

				if IsControlJustReleased(0, 194) and not hasPressedEnter then
					if refurnish then isRefurnishing = false end
					DeleteObject(tempFurniture)
					return
				end
			end
		end)
	end)
end

function furnituringZones(location, prop)
	local baseLocation = config.houseSpawns[location].coords
	for k,v in pairs(config.props[prop].furnituring) do
		local vectors = {}
		for key, val in pairs(v.vectors) do
			table.insert(vectors, vector2(val.x+baseLocation.x, val.y+baseLocation.y))
		end
		local zone = PolyZone.Create(nil,vectors, {
			name = "furnishing"..k,
			minZ = v.minZ,
			maxZ = v.maxZ,
			debugGrid = false,
			gridDivisions = 25
		})
		table.insert(zones, zone)
	end
end

function startRefurnishing(id, houseSpawn)
	ESX.TriggerServerCallback("rpuk_housing:getPlacedFurniture", function(tempFurniture)
		if not tempFurniture[1] then
			TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "You dont have any furniture placed" })
			return
		end

		local elem = {}
		local markers = {}
		local hasSelectedFurniture = false
		isRefurnishing = true

		for k,v in pairs(tempFurniture) do
			local lbl

			if v.name then
				lbl = v.name
			else
				if config.GrowingInteracts[v.object] then
					lbl = config.GrowingInteracts[v.object].label
				else
					lbl = "Unknown"
				end
			end

			table.insert(elem, {
				label = k .. ": " .. lbl,
				value = k,
				coords = GetOffsetFromEntityInWorldCoords(shellObj, vector3(v.offset[1], v.offset[2], v.offset[3]))
			})
		end

		Citizen.CreateThread(function()
			while not hasSelectedFurniture do
				Wait(0)
				for k,v in pairs(elem) do
					ESX.Game.Utils.DrawText3D(v.coords, v.label, 0.4)
				end
			end
		end)

		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "refurnishing", {
			title = "",
			css = "housing",
			align = "top-left",
			elements = elem
		}, function(data, menu)
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "refurnish_confirm", {
				title = "",
				css = "housing",
				align = "top-left",
				elements = {
					{label = "Refurnish", value = "refurnish"},
					{label = "Remove furniture", value = "remove"},
					{label = "Back", value = "back"}
			}}, function(data2, menu2)
				if data2.current.value == "refurnish" then
					hasSelectedFurniture = true
					local entity = GetClosestObjectOfType(data.current.coords.x+0.0, data.current.coords.y+0.0, data.current.coords.z+0.0, 5.0, GetHashKey(tempFurniture[data.current.value].object))

					Citizen.CreateThread(function()
						while isRefurnishing do
							Wait(0)
							SetEntityVisible(entity, false, false)
						end

						if deleteRefurnish then
							DeleteObject(entity, false)
						else
							SetEntityVisible(entity, true, false)
						end
					end)

					placeFurniture(id, houseSpawn, vector3(data.current.coords.x, data.current.coords.y, data.current.coords.z), tempFurniture[data.current.value].object, tempFurniture[data.current.value].name, true, data.current.value)
				elseif data2.current.value == "remove" then
					hasSelectedFurniture = true
					local entity = GetClosestObjectOfType(data.current.coords.x+0.0, data.current.coords.y+0.0, data.current.coords.z+0.0, 5.0, GetHashKey(tempFurniture[data.current.value].object))

					for k,v in pairs(config.furniture.Storage) do
						if v[2] == tempFurniture[data.current.value].object then
							interactions[closestInteraction(GetEntityCoords(entity))] = nil
						end
					end

					TriggerServerEvent("rpuk_housing:removeFurnished", id, data.current.value, tempFurniture[data.current.value].object)
					DeleteObject(entity, true)
					ESX.UI.Menu.CloseAll()
				elseif data2.current.value == "back" then
					menu2.close()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			hasSelectedFurniture = true
			menu.close()
		end)
	end, id)
end

function combineVectors(vector_1, vector_2) return vector_1+vector_2 end

RegisterNetEvent("rpuk_housing:homeOptions")
AddEventHandler("rpuk_housing:homeOptions", function(type)
	local data = checkHouseData()
	type = type[1]

	if type == "furnish" then
		startFurnishing(data.id, data.houseSpawn, data.prop)
	elseif type == "refunish" then
		startRefurnishing(data.id, data.houseSpawn)
	elseif type == "intercom" then
		if next(knockedOnDoor) == nil then
			TriggerEvent('mythic_notify:client:SendAlert', { length = 2500, action = 'longnotif', type = 'inform', text = "No one is trying to enter"})
			return
		end
		local elem = {}

		for k,v in pairs(knockedOnDoor) do
			table.insert(elem, {label = v, value = k})
		end

		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "letIn", {
			title = "",
			css = "housing",
			align = "top-left",
			elements = elem
		}, function(x2, menu2)
			if x2.current.value == "back" then
				menu2.close()
			else
				TriggerServerEvent("rpuk_housing:letIn", x2.current.value, data.id)
				knockedOnDoor[x2.current.value] = nil
				ESX.UI.Menu.CloseAll()
			end
		end, function(x2, menu2)
			menu2.close()
		end)
	elseif type == "storage" then
		if not hasStorageFurniture then
			TriggerServerEvent("rpuk_housing:openStorage", data.id)
		else
			TriggerEvent('mythic_notify:client:SendAlert', { length = 2500, type = 'inform', text = "You have placed storage somewhere in your house."})
		end
	end

end)

AddEventHandler("rpuk_housing:soldOwnHouse", function()
	interactions[ownedHouse..":garage"] = nil
	ownedHouse = nil
end)

AddEventHandler("rpuk_housing:soldHouse", function(houseId)
	ownedHouses[houseId] = nil

	local text = ""
	if ownedHouse == houseId then
		text = "Press ~y~E~s~ to interact with house"
	elseif ownedHouses[houseId] == nil and not ownedHouse then
		text = "Press ~y~E~s~ to buy house"
	elseif (isInList(ESX.Player.GetJobName(), config.canRaid) or isInList(ESX.Player.GetJobName(), config.medics)) and ownedHouses[houseId] ~= nil then
		text = "Press ~y~E~s~ to interact with house"
	elseif ownedHouses[houseId] ~= nil then
		text = "Press ~y~E~s~ to push door bell"
	end

	interactions[houseId].text = text
	interactions[houseId].action = function()
		defaultAction(houseId, config.houses[houseId])
	end
	interactions[houseId].refreshInteraction = true
end)

-- House Growing // Feel free to neaten it up but please keep functionality the same
function HandleRipUp(houseId, propId, propData)
	local objectName = propData.object

	buttonInteraction = true
	TriggerEvent("mythic_progbar:client:progress", {
		name = "weedhousingseed",
		duration = 7000,
		label = "Ripping Up",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = nil,
			anim = "WORLD_HUMAN_GARDENER_PLANT",
			flags = 8,
			task = nil,
		},
	},
	function(cancel)
		if not cancel then
			TriggerServerEvent('rpuk_housing:plantInteraction', houseId, propId, objectName, "police")
		elseif cancel then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped interacting!' })
		end
	end)
	buttonInteraction = false
end

function HandleGrowingInteraction(propId, propData)
	if plantInteraction then return end

	local objectName = propData.object
	plantInteraction = true
	local scaleform = ESX.Scaleform.PrepareBasicInstructional(config.GrowingInteracts[objectName].buttons, config.GrowingInteracts[objectName].stage .. " Selected Seed ("..selectedSeed..")")

	if objectName == "prop_bucket_01a" then -- stage 0
		while plantInteraction and isInHouse do
			Citizen.Wait(0)
			if oldSelected ~= selectedSeed then
				scaleform = ESX.Scaleform.PrepareBasicInstructional(config.GrowingInteracts[objectName].buttons, config.GrowingInteracts[objectName].stage .. " Selected Seed ("..selectedSeed..")")
				oldSelected = selectedSeed
			end
			DrawScaleformMovieFullscreen(scaleform)
			if IsControlJustReleased(1, 38) and not buttonInteraction then -- Seeding
				buttonInteraction = true
				TriggerEvent("mythic_progbar:client:progress", {
					name = "weedhousingseed",
					duration = 7000,
					label = "Seeding Pot",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = nil,
						anim = "WORLD_HUMAN_GARDENER_PLANT",
						flags = 8,
						task = nil,
					},
				},
				function(cancel)
					if not cancel then
						TriggerServerEvent('rpuk_housing:plantInteraction', ownedHouse, propId, objectName, selectedSeed)
					elseif cancel then
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped seeding!' })
					end
				end)
				Citizen.Wait(1000)
				plantInteraction = false
				buttonInteraction = false
			elseif IsControlJustReleased(1, 185) and not buttonInteraction then
				buttonInteraction = true
				TriggerEvent("mythic_progbar:client:progress", {
					name = "weedhousingsoil",
					duration = 7000,
					label = "Soil Plant",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = nil,
						anim = "WORLD_HUMAN_GARDENER_PLANT",
						flags = 8,
						task = nil,
					},
				}, function(cancel)
					if not cancel then
						TriggerServerEvent('rpuk_housing:plantInteraction', ownedHouse, propId, objectName, "soil")
					elseif cancel then
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped soiling!' })
					end
				end)
				Citizen.Wait(1000)
				plantInteraction = false
				buttonInteraction = false
			elseif IsControlJustReleased(1, 182) and not buttonInteraction then
				buttonInteraction = true
				TriggerEvent("mythic_progbar:client:progress", {
					name = "weedhousingwater",
					duration = 7000,
					label = "Spraying Plant",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = nil,
						anim = "WORLD_HUMAN_GARDENER_PLANT",
						flags = 8,
						task = nil,
					},
				}, function(cancel)
					if not cancel then
						TriggerServerEvent('rpuk_housing:plantInteraction', ownedHouse, propId, objectName, "water")
					elseif cancel then
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped spraying!' })
					end
				end)
				Citizen.Wait(1000)
				plantInteraction = false
				buttonInteraction = false
			elseif IsControlJustReleased(1, 172) or IsControlJustReleased(1, 173) and not buttonInteraction then
				if selectedSeed == "Sativa" then selectedSeed = "Indica"
				else selectedSeed = "Sativa" end
			elseif IsControlJustReleased(1, 168) then
				plantInteraction = false
				buttonInteraction = false
			end
		end
	elseif objectName == "bkr_prop_weed_lrg_01a" then -- stage 4
		while plantInteraction and isInHouse do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(scaleform)
			if IsControlJustReleased(1, 38) and not buttonInteraction then
				buttonInteraction = true
				TriggerEvent("mythic_progbar:client:progress", {
					name = "weedhousingcut",
					duration = 7000,
					label = "Cutting Plant",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = nil,
						anim = "WORLD_HUMAN_GARDENER_PLANT",
						flags = 8,
						task = nil,
					},
				},
				function(cancel)
					if not cancel then
						TriggerServerEvent('rpuk_housing:plantInteraction', ownedHouse, propId, objectName, "cut")
						local plantCoords = GetOffsetFromEntityInWorldCoords(shellObj, vector3(propData.offset[1], propData.offset[2], propData.offset[3]))
						local entity = GetClosestObjectOfType(plantCoords.x, plantCoords.y, plantCoords.z, 5.0, GetHashKey(objectName))
						DeleteObject(entity, true)
						interactions["furniture:" .. propId] = nil
					elseif cancel then
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped cutting!' })
					end
				end)

				Citizen.Wait(1000)
				plantInteraction = false
				buttonInteraction = false
			elseif IsControlJustReleased(1, 168) then
				plantInteraction = false
				buttonInteraction = false
			end
		end
	else
		while plantInteraction and isInHouse do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(scaleform)

			if IsControlJustReleased(1, 38) and not buttonInteraction then
				buttonInteraction = true
				TriggerEvent("mythic_progbar:client:progress", {
					name = "weedhousingwater",
					duration = 7000,
					label = "Spraying Plant",
					useWhileDead = false, canCancel = true,
					controlDisables = {disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
					animation = {animDict = nil, anim = "WORLD_HUMAN_GARDENER_PLANT", flags = 8, task = nil},
				}, function(cancel)
					if not cancel then
						TriggerServerEvent('rpuk_housing:plantInteraction', ownedHouse, propId, objectName, "water")
					elseif cancel then
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped spraying!' })
					end
				end)

				Citizen.Wait(1000)
				plantInteraction = false
				buttonInteraction = false
			elseif IsControlJustReleased(1, 168) then
				plantInteraction = false
				buttonInteraction = false
			end
		end
	end

	plantInteraction = false
	buttonInteraction = false
end

RegisterNetEvent("rpuk_housing:interactionUpdate")
AddEventHandler("rpuk_housing:interactionUpdate", function(xFurniture, houseData)
	for k,v in pairs(xFurniture) do
		local xCoords = GetOffsetFromEntityInWorldCoords(shellObj, vector3(v.offset[1], v.offset[2], v.offset[3]))
		local obj = GetClosestObjectOfType(xCoords.x, xCoords.y, xCoords.z, 5.0, GetHashKey(v.object))
		--local obj = CreateObject(model, GetOffsetFromEntityInWorldCoords(shellObj, vector3(v.offset[1], v.offset[2], v.offset[3])), false, true, false)

		furniture[k] = {
			obj = obj,
			pos = GetEntityCoords(obj),
			interactionId = "furniture:" .. k
		}

		if v.category == "Storage" and config.access[type].storage then
			hasStorageFurniture = true
			interactions["furniture:" .. k] = createInteraction({
				id = "furniture:" .. k,
				pos = furniture[k].pos,
				text = "Press ~y~E~s~ to open storage",
				action = function()
					TriggerServerEvent("rpuk_housing:openStorage", houseId)
				end
			})
		elseif config.GrowingInteracts[v.object] then
			if houseData.id == ownedHouse then -- I own the house
				local txt = "~b~" .. config.GrowingInteracts[v.object].label .. "~s~\n" .. config.GrowingInteracts[v.object].stage

				if v["plantData"] then
					if v["plantData"]["seed"] then txt = txt .. "\nSeed: " .. v["plantData"]["seed"] end
					if v["plantData"]["watered"] then txt = txt .. "\nWatered: ~g~Yes~s~" else txt = txt .. "\nWatered: ~r~No~s~" end
					if v["plantData"]["soiled"] then txt = txt .. "\nSoil: ~g~Yes~s~" else txt = txt .. "\nSoil: ~r~No~s~" end
				end

				interactions["furniture:" .. k] = createInteraction({
					id = "furniture:" .. k,
					pos = furniture[k].pos,
					text = txt,
					action = function() HandleGrowingInteraction(k, v) end
				})
			elseif (ESX.Player.GetJobName() == "police") then
				interactions["furniture:" .. k] = createInteraction({
					id = "furniture:" .. k,
					pos = furniture[k].pos,
					text = "Plant",
					action = function() HandleRipUp(houseData.id, k, v) end
				})
			end
		end
	end
end)

Citizen.CreateThread(function()
	while not ESX.IsPlayerLoaded() do Citizen.Wait(1000) end -- wait for kashacter to choose char
	spawned()
end)