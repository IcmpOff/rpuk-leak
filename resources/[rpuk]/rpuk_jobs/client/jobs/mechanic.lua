local isAnyVehicleAttached, jobImpoundBlips, busySpawnPoints = false, {}, {}

RegisterNetEvent('rpuk_mechanic:vehicleImpoundRegister')
RegisterNetEvent('rpuk_mechanic:vehicleList')
RegisterNetEvent('rpuk_mechanic:newVehicleRegistered')
RegisterNetEvent('rpuk_mechanic:newVehicleAlert')
RegisterNetEvent('rpuk_mechanic:deleteVehicleBlip')
RegisterNetEvent('rpuk:mimpound')
RegisterNetEvent('rpuk:mflatbed')
RegisterNetEvent('rpuk:mtriggernpc')
RegisterNetEvent('rpuk_mechanic:setBusySpawnPoints')

AddEventHandler('rpuk_mechanic:setBusySpawnPoints', function(_busySpawnPoints)
	busySpawnPoints = _busySpawnPoints
end)

function addImpoundBlip(coords, name)
	local blip = AddBlipForCoord(coords)

	SetBlipAsFriendly(blip, true)
	SetBlipSprite(blip, 161)
	SetBlipColour(blip, 5) -- yellow blip

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(tostring(name))
	EndTextCommandSetBlipName(blip)

	return blip
end

function blipImpoundOff(blip)
	RemoveBlip(blip)
end

AddEventHandler('rpuk_mechanic:vehicleImpoundRegister', function()
	local vehicle, distance = ESX.Game.GetClosestVehicle()
	if (ESX.Player.GetJobName() == "police") then
		if vehicle ~= 0 and vehicle ~= nil and distance < 5.0 then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'reg_vehicle',
			{
				title = "Register a vehicle to be Impounded",
			}, function(data, menu)
				local length = string.len(data.value)
				local coords = GetEntityCoords(PlayerPedId())
				if data.value == nil or length < 2 or length > 13 then
					TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "Invild"})
					menu.close()
				else
					TriggerServerEvent("rpuk_mechanic:registerNewVehicle", string.upper(data.value), coords, "police")
					menu.close()
				end
			end, function(data, menu)
				menu.close()
			end)
		else
			TriggerEvent('mythic_notify:client:SendAlert', {type = "error", text = "You need to be close to a vehicle"})
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { length = 2000, type = 'inform', text = "You do not have access to use this." })
	end
end)

AddEventHandler('rpuk_mechanic:vehicleList', function()
	if ESX.Player.GetJobName() == "mechanic" and ESX.Player.GetJobGrade() >= 4 then
		ESX.TriggerServerCallback("rpuk_mechanic:getVehicleList", function(result)
			if next(result) == nil then
				TriggerEvent('mythic_notify:client:SendAlert', {
				length = 2000,
				type = 'inform',
				text = "No vehicles are listed to be collected." })
				return
			else
				local elements = {}
				for k,v in pairs(result) do
					if v.type == "police" then
						table.insert(elements, {
							label = "<span style='color:blue'>[Police] </span>"..k,
							value = k
						})
					end
				end
				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "plateLists", {
					title = "Current Job List",
					css = "",
					align = "top-left",
					elements = elements
				}, function(data, menu)
					ESX.UI.Menu.Open("default", GetCurrentResourceName(), "plateLists2", {
						title = "Vehicle Options",
						css = "",
						align = "top-left",
						elements = {
							{
								label = "Accept Job",
								value = "blip"
							},
							{
								label = "Remove Vehicle From Job",
								value = "removeJob"
							},
							{
								label = "Back",
								value = "back"
							}
						}
					}, function(data2, menu2)
						if data2.current.value == "blip" then
							TriggerServerEvent("rpuk_mechanic:deleteBlip", data.current.value)
							menu2.close()
						elseif data2.current.value == "removeJob" then
							TriggerServerEvent("rpuk_mechanic:deleteJob", data.current.value)
							menu2.close()
						else
							menu2.close()
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end, function(data, menu)
					menu.close()
				end)
			end
		end)
	else
		TriggerEvent('mythic_notify:client:SendAlert', {type = "error", text = "You are not high enough level."})
	end
end)

AddEventHandler('rpuk_mechanic:newVehicleRegistered', function(plate, coords, type)
	if ESX.Player.GetJobName() == "mechanic" and ESX.Player.GetJobGrade() >= 4 and type == "police" then
		jobImpoundBlips[plate] = addImpoundBlip(coords,"Police Impound - Job Pickup")
		TriggerServerEvent("rpuk_alerts:sNotification", {notiftype = "impound"})
	elseif type == "npc" and ESX.Player.GetJobName() == "mechanic" then
		jobImpoundBlips[plate] = addImpoundBlip(coords,"Civ Impound - Job Pickup")
	end
end)

AddEventHandler('rpuk_mechanic:newVehicleAlert', function(plate, coords, type)
	local street = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	local streetHash = GetStreetNameFromHashKey(street)
	if ESX.Player.GetJobName() == "mechanic" and ESX.Player.GetJobGrade() >= 4 and type == "police" then
		TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", length = 10000, text = "Vehicle added to impound list | Plate: ".. plate .." | Street: ".. streetHash})
	end
end)

AddEventHandler('rpuk_mechanic:deleteVehicleBlip', function(plate)
	blipImpoundOff(jobImpoundBlips[plate])
	jobImpoundBlips[plate] = nil
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true
		local coords = GetEntityCoords(PlayerPedId())
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		for index, data in pairs(Config.Mechanic.locations) do
			local distance = #(coords - data.access.location)

			if distance < 30.0 and (vehicle == 0 or vehicle == nil) then
				canSleep = false
				DrawMarker(data.access.marker.type, data.access.location, 0.0, 0.0, 0.0, 0, 0.0, 0.0, data.access.marker.size, 255, 255, 255, 100, false, false, 2, false, false, false, false)

				if distance < data.access.marker.size.x then
					local textpos = vector3(data.access.location.x, data.access.location.y, data.access.location.z + 2.0)
					local textformat = data.name .. "\nPress [~r~E~s~] To Access Job Menu"
					ESX.Game.Utils.DrawText3D(textpos, textformat, 1.0, 6)

					if IsControlJustReleased(0, 38) then
						gateway(index)
					end
				end
			end
		end
		if canSleep then
			Citizen.Wait(500)
		end
	end
end)

function gateway(index)
	local elements = {}

	if ESX.Player.GetJobName() == "mechanic" then
		table.insert(elements, {label = "⚙ Mechanic Level: " .. ESX.Player.GetJobGrade() .. " ⚙", value = "header"})
		table.insert(elements, {label = "Start NPC Job", value = "mechanic_start_npc"})
		table.insert(elements, {label = "Rent A Vehicle", value = "mechanic_rent_vehicle"})
		table.insert(elements, {label = "Leave Service", value = "mechanic_leave_service"})
	else
		table.insert(elements, {label = "⚙ Enter Service ⚙", value = "mechanic_enter_service"})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fnc_gateway', {
	title		= '',
	css			= "mechanic",
	align		= 'top-left',
	elements = elements
	}, function(data, menu)
		if data.current.value == "mechanic_enter_service" then
			ESX.TriggerServerCallback('esx_license:checkLicense', function(result)
				if result then
					TriggerServerEvent('rpuk_jobs:assign', "mechanic")
					Citizen.Wait(750)
					ESX.UI.Menu.CloseAll()
					gateway(index)
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 4000, text = 'Mechanic, In Service'})
				else
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 4000, text = 'You need a mechanics licence from the city hall!'})
				end
			end, GetPlayerServerId(PlayerId()), 'mechanic')
		elseif data.current.value == "mechanic_leave_service" then
			TriggerServerEvent('rpuk_jobs:assign', "unemployed")
			Citizen.Wait(750)
			ESX.UI.Menu.CloseAll()
			gateway(index)
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 4000, text = 'Mechanic, Left Service'})
		elseif data.current.value == "mechanic_start_npc" then
			createJob()
			ESX.UI.Menu.CloseAll()
		elseif data.current.value == "mechanic_rent_vehicle" then
			TriggerEvent('rpuk_jobs:rentcar', 'mechanicvehicles')
		end
	end, function(data, menu)
		menu.close()
	end)
end

function getAvailableSpawnPoint()
	local playerCoords, counter = GetEntityCoords(PlayerPedId()), 0

	while counter < #Config.Mechanic.npc_locations do
		Citizen.Wait(0)
		local spawnPointIndex = GetRandomIntInRange(1, #Config.Mechanic.npc_locations)
		local spawnPoint = Config.Mechanic.npc_locations[spawnPointIndex]
		local distance = #(playerCoords - spawnPoint)

		if not busySpawnPoints[spawnPointIndex] and ESX.Game.IsSpawnPointClear(spawnPoint, 5) and distance > 50 then
			return spawnPoint, spawnPointIndex
		end

		counter = counter + 1
	end

	return nil
end

function createJob()
	local spawnPoint, spawnPointIndex = getAvailableSpawnPoint()

	if spawnPoint then
		local randomPlate = exports['rpuk_vehicle']:GeneratePlate(true)

		ESX.TriggerServerCallback('rpuk_mechanic:startPickupJob', function(errorMessage)
			if errorMessage then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 4000, text = errorMessage})
			else
				asyncSpawnJobVehicleWhenPlayerIsNearby(spawnPoint, randomPlate)
			end
		end, spawnPointIndex, randomPlate)
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 4000, text = 'There is currently no jobs available for you, come back later!'})
	end
end

function asyncSpawnJobVehicleWhenPlayerIsNearby(spawnPoint, vehiclePlate)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(500)
			local playerCoords = GetEntityCoords(PlayerPedId())

			if #(playerCoords - spawnPoint) < 50 then break end
		end

		local randomIndex = math.random(1, #Config.Mechanic.npc_vehicles)
		local randomVehicle = Config.Mechanic.npc_vehicles[randomIndex]

		ESX.Game.SpawnVehicle(randomVehicle, spawnPoint, 0.0, function(vehicle)
			SetVehicleDoorsLockedForAllPlayers(vehicle, true)
			SetVehicleFuelLevel(vehicle, 0)
			SetVehicleEngineHealth(vehicle, 10)
			SetVehicleMaxSpeed(vehicle, 10)
			SetVehicleTyreBurst(vehicle, 1, true, 1000)
			SetVehicleTyreBurst(vehicle, 3, true, 1000)
		end, {plate = vehiclePlate})
	end)
end

AddEventHandler('rpuk:mimpound', function()
	local vehicle, distance = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
	local coords = GetEntityCoords(PlayerPedId())

	if ESX.Player.GetJobName() == "mechanic" then
		if vehicle ~= -1 and distance < 5 then
			local plate = GetVehicleNumberPlateText(vehicle)
			local zone = ds.impounds["pound_civilian_innocence"]

			if #(coords - zone.impoundzone.location) < zone.impoundzone.marker.size.y then
				ESX.TriggerServerCallback("rpuk_mechanic:getVehicleList", function(result)
					if result[plate] then
						TriggerEvent("mythic_progbar:client:progress", {
							name = "Impounding", label = "Impounding Vehicle",
							duration = 20000, useWhileDead = false, canCancel = true,
							controlDisables = {disableMovement = false, disableCarMovement = true, disableMouse = false, disableCombat = true},
							animation = {animDict = "amb@medic@standing@timeofdeath@base", anim = "base", flags = 49, task = nil},
							prop = {model = "prop_notepad_01", bone = 60309, coords = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}}
						}, function(canceled)
							if canceled then
								TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = 'You have canceled the vehicle impound'})
							else
								local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

								if IsEntityAttached(vehicle) then
									DetachEntity(vehicle, false, false)
								end

								if result[plate].type == "police" then
									TriggerServerEvent('rpuk_garages:vehiclestate', vehicleData.plate, "pound_police_innocence", 3)
								else
									TriggerServerEvent('rpuk_garages:vehiclestate', vehicleData.plate, "pound_civilian_innocence", 2)
								end

								TriggerServerEvent("rpuk_mechanic:moneyAdd", plate, result[plate].type)
								ESX.Game.DeleteVehicle(vehicle)

								-- if math.random(1,20) == 1 then
								-- 	TriggerServerEvent('rpuk_jobs:level', 'mechanic', true)
								-- end

								TriggerServerEvent('rpuk_jobs:progress', 'mechanic')
							end
						end)
					else
						ESX.ShowNotification('That vehicle is not marked for impound')
					end
				end)
			else
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You are out of range of the impound!'})
			end
		end
	end
end)

function getVehicleHandleAttached()
	local vehicles = ESX.Game.GetVehiclesInArea(false, 20)
	local mechanicVehicleEntity = GetVehiclePedIsIn(PlayerPedId(), true)

	for k,v in ipairs(vehicles) do
		if IsEntityAttachedToEntity(mechanicVehicleEntity, v) then
			return v
		end
	end
end

AddEventHandler('rpuk:mflatbed', function()
	local mechanicVehicleEntity = GetVehiclePedIsIn(PlayerPedId(), true)
	local vehicle, distance = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))

	if distance < 5 and vehicle and vehicle ~= 0 then
		local plate = GetVehicleNumberPlateText(vehicle)

		if ESX.Player.GetJobName() == "mechanic" then
			if GetEntityModel(mechanicVehicleEntity) == GetHashKey('flatbed') or GetEntityModel(mechanicVehicleEntity) == GetHashKey('rpCiv3') then
				ESX.TriggerServerCallback("rpuk_mechanic:getVehicleList", function(result)
					if result[plate] then
						if isAnyVehicleAttached then
							TriggerEvent("mythic_progbar:client:progress", {
								name = "detach", label = "Detaching Vehicle", duration = 5000, useWhileDead = false, canCancel = true,
								controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true},
								animation = {animDict = "amb@medic@standing@timeofdeath@base",anim = "base",flags = 49,task = nil},
								prop = {model = "prop_notepad_01",bone = 60309}
							}, function(status)
								if not status then
									local attachedVehicleHandle = getVehicleHandleAttached()

									if attachedVehicleHandle then
										local towOffset = GetOffsetFromEntityInWorldCoords(mechanicVehicleEntity, 0.0, -10.0, 0.0)
										DetachEntity(attachedVehicleHandle, false, false)
										SetEntityCoords(attachedVehicleHandle, towOffset.x, towOffset.y, towOffset.z, 1, 0, 0, 1)
										PlaceObjectOnGroundProperly(attachedVehicleHandle)
										isAnyVehicleAttached = false
									else
										ESX.ShowNotification('Could not find attached vehicle, try again')
									end
								elseif status then
									TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped detaching the vehicle' })
								end
							end)
						else
							if vehicle ~= mechanicVehicleEntity then
								if ESX.Game.RequestNetworkControlOfEntity(vehicle, true) then
									TriggerEvent("mythic_progbar:client:progress", {
										name = "attach", label = "Attaching Vehicle", duration = 17000, useWhileDead = false, canCancel = true,
										controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true},
										animation = {animDict = "amb@medic@standing@timeofdeath@base",anim = "base",flags = 49,task = nil},
										prop = {model = "prop_notepad_01",bone = 60309}
									}, function(status)
										if not status then
											local vehicleHeightMin, vehicleHeightMax = GetModelDimensions(GetEntityModel(vehicle))
											local boneIndex = GetEntityBoneIndexByName(mechanicVehicleEntity, "bodyshell")
											AttachEntityToEntity(vehicle, mechanicVehicleEntity, boneIndex, 0.0, -2.2, 0.4 - vehicleHeightMin.z, 0.0, 0.0, 0.0, true, true, false, true, false, true)
											isAnyVehicleAttached = true
											TriggerServerEvent("rpuk_mechanic:deleteBlip", plate)
										elseif status then
											TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have canceled attaching the vehicle' })
										end
									end)
								end
							end
						end
					else
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You can only impound vehicles which are on the impound list!'})
					end
				end)
			else
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Your last vehicle needs to be a flatbed to use this!'})
			end
		end
	end
end)

AddEventHandler('rpuk:mtriggernpc', function()
	local mechanicVehicleEntity = GetVehiclePedIsIn(PlayerPedId(), true)

	if ESX.Player.GetJobName() == "mechanic" and ESX.Player.GetJobGrade() >= 1 then
		if GetEntityModel(mechanicVehicleEntity) == GetHashKey('flatbed') or GetEntityModel(mechanicVehicleEntity) == GetHashKey('rpCiv3') then
			createJob()
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Your last vehicle needs to be a flatbed to start an NPC job!'})
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'To start an NPC job away from the depot you need to be a level 1 mechanic!'})
	end
end)
