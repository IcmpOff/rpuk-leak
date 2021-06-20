local inMenu, count_mechanic = false, 0

RegisterNetEvent('rpuk_jobs:count')
AddEventHandler('rpuk_jobs:count', function(xcount_pol, xcount_nhs, xcount_lost, xcount_mechanic)
	count_pol, count_nhs, count_lost, count_mechanic = xcount_pol, xcount_nhs, xcount_lost, xcount_mechanic
end)

local countdown = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true
		local coords = GetEntityCoords(PlayerPedId())
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

		for index,data in pairs(ds.garages) do
			if (data.job == nil or data.job == ESX.Player.GetJobName()) and (data.gang == nil or (data.gang and ESX.Player.GetGangId() == data.gang)) then
				if vehicle and DoesEntityExist(vehicle) then
					for i=1, #data.savepoints do
						local distance = #(coords - data.savepoints[i].location)

						if distance < 7 then
							canSleep = false
							DrawMarker(data.savepoints[i].type, data.savepoints[i].location, data.savepoints[i].direction, 0, 0.0, 0.0, data.savepoints[i].size, 255, 255, 255, 50, false, false, 2, false, false, false, false)

							if distance < data.savepoints[i].size.y and data.savepoints[i].used == false then
								local textpos = vector3(data.savepoints[i].location.x, data.savepoints[i].location.y, data.savepoints[i].location.z + 2.0)
								local textformat = data.name .. "\nPress [~r~E~s~] To Park Vehicle Here"
								ESX.Game.Utils.DrawText3D(textpos, textformat, 1.0, 6)

								if IsControlJustReleased(0, 38) and countdown[vehicle] == nil and data.savepoints[i].used == false then
									storeVehicle(index, i, vehicle)
								end
							end
						end
					end
				else -- on foot
					local distance = #(coords - data.access.location)

					if distance < 10 then
						canSleep = false
						DrawMarker(data.access.type, data.access.location, data.access.direction, 0.0, 0.0, 0.0, data.access.size, 255, 255, 255, 100, false, false, 2, false, false, false, false)

						if distance < data.access.size.x then
							local textpos = vector3(data.access.location.x, data.access.location.y, data.access.location.z + 2.0)
							local textformat = data.name .. "\nPress [~r~E~s~] To Retrieve A Vehicle"
							ESX.Game.Utils.DrawText3D(textpos, textformat, 1.0, 6)

							if IsControlJustReleased(0, 38) and not inMenu then
								retrieveVehicle(index, data.vehicleType)
							end
						end
					end
				end
			end
		end

		for index,data in pairs(ds.impounds) do
			local distance = #(coords - data.access)

			if distance < 15 and vehicle == 0 or vehicle == nil then
				canSleep = false
				DrawMarker(data.marker.type, data.access, 0.0, 0.0, 0.0, 0, 0.0, 0.0, data.marker.size, 255, 255, 255, 100, false, false, 2, false, false, false, false)

				if distance < data.marker.size.x then
					local textpos = vector3(data.access.x, data.access.y, data.access.z + 2.0)
					local textformat = data.name .. "\nPress [~r~E~s~] To Retrieve A Vehicle"
					ESX.Game.Utils.DrawText3D(textpos, textformat, 1.0, 6)

					if IsControlJustReleased(0, 38) then
						retrieveVehicle(index, data.vehicleType)
					end
				end
			end

			if #(coords - data.impoundzone.location) < 15 then
				canSleep = false
				DrawMarker(data.impoundzone.marker.type, data.impoundzone.location, data.impoundzone.direction, 0, 0.0, 0.0, data.impoundzone.marker.size, 255, 0, 0, 30, false, false, 2, false, false, false, false)
			end
		end

		if canSleep then
			Citizen.Wait(500)
		end
	end
end)

function storeVehicle(index, i, vehicle)
	if #GetActivePlayers() > 45 and ds.garages[index].timer > 15 then
		countdown[vehicle] = 15
	else
		countdown[vehicle] = ds.garages[index].timer
	end

	local textCoords = vector3(ds.garages[index].savepoints[i].location.x, ds.garages[index].savepoints[i].location.y, ds.garages[index].savepoints[i].location.z + 2.0)
	ds.garages[index].savepoints[i].used = true

	Citizen.CreateThread(function()
		while countdown[vehicle] > 0 do
			Citizen.Wait(1000)
			if countdown[vehicle] > 0 then
				countdown[vehicle] = countdown[vehicle] - 1
			end
		end
	end)

	while countdown[vehicle] > 0 do
		Citizen.Wait(0)
		local text = ('%s~n~Time Until Stored: %s'):format(ds.garages[index].name, countdown[vehicle])
		ESX.Game.Utils.DrawText3D(textCoords, text, 1.0, 6)
	end

	if #(GetEntityCoords(vehicle) - textCoords) < 10 then
		local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
		TriggerServerEvent('rpuk_garages:storevehicle', index, vehicleData)
		ESX.Game.DeleteVehicle(vehicle)
	else
		ESX.ShowAdvancedNotification('Garage & Car Parking', "Vehicle Storage Failed", "Vehicle was too far away from the parking space to store the vehicle.", 'CHAR_CARSITE', 0)
	end
	ds.garages[index].savepoints[i].used = false
	countdown[vehicle] = nil
end

function retrieveVehicle(index, vehicleType)
	inMenu = true
	local header, state
	local eventCall = 'rpuk_garage:retrievegarage'

	if string.find(index, "pound_police") then
		state = 3
		header = ds.impounds[index].header
	elseif string.find(index, "pound_civilian") then
		state = 2
		header = ds.impounds[index].header
	elseif string.find(index, "gang_") then
		eventCall = 'rpuk_garage:retrieveGangGarage'
	else
		state = 1
		header = ds.garages[index].header
	end

	ESX.TriggerServerCallback(eventCall, function(vehicles)
		local elements = {}
		local vehiclesInMap = getAllVehiclePlates()

		if string.find(index, "pound_civilian") then
			table.insert(elements, {label = "Los Santos Insurance →", value = "vehicle_insurance"})
		end

		for k,v in ipairs(vehicles) do
			local vehicleProps = json.decode(v.vehicle)

			if IsModelInCdimage(vehicleProps.model) then
				local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model))
				if vehicleLabel == 'NULL' then vehicleLabel = GetDisplayNameFromVehicleModel(vehicleProps.model) end

				if string.find(index, "pound_police") or string.find(index, "pound_civilian") and not vehiclesInMap[v.plate] then
					local fee = math.floor(v.impound_time * ds.impounds[index].multiplier)

					table.insert(elements, {
						label = ('%s <span style="color:cyan;">[%s]</span> <span style="color:orange;">[Fee £%s]</span>'):format(vehicleLabel, v.plate, ESX.Math.GroupDigits(fee)),
						value = vehicleProps,
						fee = fee
					})
				elseif not string.find(index, "pound_police") and not string.find(index, "pound_civilian") then
					table.insert(elements, {
						label = ('%s <span style="color:cyan;">[%s]</span>'):format(vehicleLabel, v.plate),
						value = vehicleProps
					})
				end
			else
				table.insert(elements, {
					label = '<span style="color:red;">Found Invalid Vehicle</span>',
					model = vehicleProps.model,
					plate = v.plate,
					error = true
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fnc_retrieveVehicle', {
			title = '',
			css = header,
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.error then
				local msg = ('<span style="font-weight: bold;">Invalid vehicle found!</span><br>This vehicle is missing from ' ..
				'the server files. Please make a bug report about it at our forum if none exist.<br><br>' ..
				'<span style="font-weight: bold;">Vehicle Model:</span> %s<br><span style="font-weight: bold;">' ..
				'Vehicle Plate:</span> %s'):format(data.current.model, data.current.plate)

				ESX.ShowNotification(msg, 20000, 'error', 'longnotif')
			elseif data.current.value then
				if data.current.value == "vehicle_insurance" then
					vehInsurance(index)
				else
					if string.find(index, "pound_police") or string.find(index, "pound_civilian") then
						ESX.TriggerServerCallback('rpuk_garage:payfee', function(success)
							if success then
								spawnVehicle(index, data.current.value)
							end
						end, data.current.fee)
					else
						spawnVehicle(index, data.current.value)
					end
				end
			end
		end, function(data, menu)
			menu.close()
			inMenu = false
		end)
	end, state, index, vehicleType)
end

function getAllVehiclePlates()
	local vehicles = {}

	for entity in EnumerateVehicles() do
		local vehiclePlate = ESX.Math.Trim(GetVehicleNumberPlateText(entity))
		vehicles[vehiclePlate] = true
	end

	return vehicles
end

function vehInsurance(index)
	ESX.TriggerServerCallback('rpuk_garage:retrievegarage', function(vehicles)
		inMenu = true
		local elements = {}

		for k,v in ipairs(vehicles) do
			local vehicleProps = json.decode(v.vehicle)

			if IsModelInCdimage(vehicleProps.model) then
				local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model))
				if vehicleLabel == 'NULL' then vehicleLabel = GetDisplayNameFromVehicleModel(vehicleProps.model) end
				local fee = calcInsurance(vehicleProps)

				table.insert(elements, {
					label = ('%s <span style="color:cyan;">[%s]</span> <span style="color:orange;">[Fee £%s]</span>'):format(vehicleLabel, v.plate, ESX.Math.GroupDigits(fee)),
					value = vehicleProps,
					job = v.job,
					fee = fee,
					plate = v.plate
				})
			else
				table.insert(elements, {
					label = '<span style="color:red;">Found Invalid Vehicle</span>',
					model = vehicleProps.model,
					plate = v.plate,
					error = true
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fnc_vehicleinsurance', {
			title = '',
			css = "mechanic",
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.error then
				local msg = ('<span style="font-weight: bold;">Invalid vehicle found!</span><br>This vehicle is missing from ' ..
				'the server files. Please make a bug report about it at our forum if none exist.<br><br>' ..
				'<span style="font-weight: bold;">Vehicle Model:</span> %s<br><span style="font-weight: bold;">' ..
				'Vehicle Plate:</span> %s'):format(data.current.model, data.current.plate)

				ESX.ShowNotification(msg, 20000, 'error', 'longnotif')
			elseif data.current.value ~= nil then
				ESX.TriggerServerCallback('rpuk_garage:payfee', function(result)
					if result then
						local vData = data.current.value
						local vJob = data.current.job
						local fLocation = getReturnLocation(vData, vJob)
						TriggerServerEvent('rpuk_garages:vehiclestate', vData.plate, fLocation, 1, true)
						TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'success', text = "Insurance Claimed, Vehicle return to " .. ds.garages[fLocation].name})
					end
				end, data.current.fee)

				menu.close()
				inMenu = false
			end
		end, function(data, menu)
			menu.close()
			inMenu = false
		end)
	end, "insurance")
end

-- Function to decide where to return a claimed vehicle to
function getReturnLocation(vehicle, job)
	local fLocation = 'legionsquare_upper' -- Default location

	if IsThisModelAHeli(vehicle.model) or IsThisModelAPlane(vehicle.model) then -- First check for helicopters / planes
		if job == 'police' then -- Police Heli
			fLocation = 'vespucci_police_helipad'
		elseif job == 'ambulance' then -- Air Rescue Heli
			fLocation = 'pillbox_nhs_helipad'
		else -- other helis or planes
			fLocation = "ls_airport"
		end
	elseif IsThisModelABoat(vehicle.model) then
		fLocation = "boat_tackle_st"
	else -- Ground Vehicles
		if job == 'police' then
			fLocation = 'vespucci_police'
		elseif job == 'ambulance' then
			fLocation = 'pillbox_nhs'
		elseif job == 'nca' then
			fLocation = 'vespucci_nca'
		elseif job == 'gruppe6' then
			fLocation = 'g6_hq'
		end
	end

	return fLocation
end

function calcInsurance(vehicle)
	local fee = 250

	return fee
end

function spawnVehicle(index, vehicleData)
	local found = false
	if string.find(index, "pound_") then
		for i=1, #ds.impounds[index].spawnpoints, 1 do
			local spawnCoords = vector3(ds.impounds[index].spawnpoints[i].x, ds.impounds[index].spawnpoints[i].y, ds.impounds[index].spawnpoints[i].z)
			local spawnHeading = ds.impounds[index].spawnpoints[i].w
			if ESX.Game.IsSpawnPointClear(spawnCoords, 3.0) then
				found = true
				ESX.Game.SpawnVehicle(vehicleData.model, spawnCoords, spawnHeading, function(vehicle)
					TriggerServerEvent('rpuk_garages:vehiclestate', vehicleData.plate, index, 0)
					TriggerServerEvent("rpuk_trunk:loadTrunk", vehicleData.plate, GetVehicleClass(vehicle))
					indicatorMarker(vehicle, 15000)
				end, vehicleData, {
					giveKeys = true
				})
				ESX.UI.Menu.CloseAll()
				inMenu = false
				break
			end
		end
	else
		for i=1, #ds.garages[index].spawnpoints, 1 do
			local spawnCoords = vector3(ds.garages[index].spawnpoints[i].x, ds.garages[index].spawnpoints[i].y, ds.garages[index].spawnpoints[i].z)
			local spawnHeading = ds.garages[index].spawnpoints[i].w
			if ESX.Game.IsSpawnPointClear(spawnCoords, 3.0) then
				found = true
				ESX.Game.SpawnVehicle(vehicleData.model, spawnCoords, spawnHeading, function(vehicle)
					TriggerServerEvent('rpuk_garages:vehiclestate', vehicleData.plate, index, 0)
					indicatorMarker(vehicle, 15000)
				end, vehicleData,{
					giveKeys = true
				})
				ESX.UI.Menu.CloseAll()
				inMenu = false
				break
			end
		end
	end
	if found then
		ESX.ShowAdvancedNotification('Garage & Car Parking', "Retrieved Vehicle", "", 'CHAR_CARSITE', 0)
	else
		ESX.ShowAdvancedNotification('Garage & Car Parking', "No Parking Spaces Available", "", 'CHAR_CARSITE', 0)
	end
end

function indicatorMarker(entity, time)
	local vCoords = GetEntityCoords(entity)
	local height = math.ceil(GetEntityHeightAboveGround(entity)) * 2.0
	local coords = vector3(vCoords.x, vCoords.y, vCoords.z + height)
	local timer = time
	while timer > 0 do
		Citizen.Wait(0)
		timer = timer - 10
		DrawMarker(0, coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 116, 123,240, 100, true, true, 2, false, false, false, false)
	end
end

RegisterNetEvent('rpuk:policeImpound')
AddEventHandler('rpuk:policeImpound', function(job)
	local vehicle, distance = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
	local coords = GetEntityCoords(PlayerPedId())
	if distance < 5.0 and vehicle ~= nil and vehicle ~= 0 then
		local plate = GetVehicleNumberPlateText(vehicle)
		if ESX.Player.GetJobName() == "police" then
			if ESX.Game.RequestNetworkControlOfEntity(vehicle, true) then
				if string.find(plate, " ") then
					if count_mechanic < 8 then
						TriggerEvent("mythic_progbar:client:progress", {
							name = "Impounding",
							duration = 20000,
							label = "Impounding Vehicle",
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = false,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
							animation = {
								animDict = "amb@medic@standing@timeofdeath@base",
								anim = "base",
								flags = 49,
								task = nil,
							},
							prop = {
								model = "prop_notepad_01",
								bone = 60309,
								coords = { x = 0.0, y = 0.0, z = 0.0 },
								rotation = { x = 0.0, y = 0.0, z = 0.0 },
							}
							}, function(status)
							if not status then
								local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
								TriggerServerEvent('rpuk_garages:vehiclestate', vehicleData.plate, "pound_police_innocence", 3)
								ESX.Game.DeleteVehicle(vehicle)
							elseif status then
								TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped impounding the vehicle' })
							end
						end)
					else
						local ref = ds.impounds["pound_police_innocence"]
						if GetDistanceBetweenCoords(coords, ref.impoundzone.location, true) < ref.impoundzone.marker.size.y then
							TriggerEvent("mythic_progbar:client:progress", {
								name = "Impounding",
								duration = 20000,
								label = "Impounding Vehicle",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {
									disableMovement = false,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "amb@medic@standing@timeofdeath@base",
									anim = "base",
									flags = 49,
									task = nil,
								},
								prop = {
									model = "prop_notepad_01",
									bone = 60309,
									coords = { x = 0.0, y = 0.0, z = 0.0 },
									rotation = { x = 0.0, y = 0.0, z = 0.0 },
								}
								}, function(status)
								if not status then
									local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
									TriggerServerEvent('rpuk_garages:vehiclestate', vehicleData.plate, "pound_police_innocence", 3)
									ESX.Game.DeleteVehicle(vehicle)
								elseif status then
									TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped impounding the vehicle' })
								end
							end)
						else
							ESX.ShowAdvancedNotification('Garage & Car Parking', "Out of Range", "You are out of range of the impound!", 'CHAR_CARSITE', 0)
						end
					end
				else
					TriggerEvent("mythic_progbar:client:progress", {
						name = "Impounding",
						duration = 5000,
						label = "Impounding Vehicle",
						useWhileDead = false,
						canCancel = true,
						controlDisables = {
							disableMovement = false,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						},
						animation = {
							animDict = "amb@medic@standing@timeofdeath@base",
							anim = "base",
							flags = 49,
							task = nil,
						},
						prop = {
							model = "prop_notepad_01",
							bone = 60309,
							coords = { x = 0.0, y = 0.0, z = 0.0 },
							rotation = { x = 0.0, y = 0.0, z = 0.0 },
						}
						}, function(status)
						if not status then
							ESX.Game.DeleteVehicle(vehicle)
						elseif status then
							TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped impounding the vehicle' })
						end
					end)
				end
			end
		else
			ESX.ShowAdvancedNotification('Garage & Car Parking', "No Permissions", "You can not use this feature!", 'CHAR_CARSITE', 0)
		end
	end
end)