AddEventHandler('rpuk_wheel:setVehicleSeat', function(seatIndex)
	local playerPed = PlayerPedId()
	local vehicleHandle = GetVehiclePedIsIn(playerPed, false)

	if vehicleHandle and doesVehicleSeatExistAndIsItAvailable(seatIndex, vehicleHandle) then
		TaskWarpPedIntoVehicle(playerPed, vehicleHandle, seatIndex)
	end
end)

RegisterCommand('seat', function(source, args)
	if tonumber(args[1]) then
		TriggerEvent('rpuk_wheel:setVehicleSeat', tonumber(args[1]))
	end
end)

RegisterCommand("window", function(source, args)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if tostring(args[1]) == nil then
		return
	elseif args[1] == "up" then -- RollDownWindow RollUpWindow
		RollUpWindow(vehicle, tonumber(args[2]))
	elseif args[1] == "down" then
		RollDownWindow(vehicle, tonumber(args[2]))
	end
end)

AddEventHandler("rpuk_wheel:setVehicleThing", function(type)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local hash = GetEntityModel(vehicle)
	local maxSeats = GetVehicleModelNumberOfSeats(hash)

	type = type[1]

	if vehicle and DoesEntityExist(vehicle) then
		if type == "engine" then
			if GetPedInVehicleSeat(vehicle, -1) == ped then
				if GetIsVehicleEngineRunning(vehicle) then
					SetVehicleEngineOn(vehicle, false, false, true)
					ESX.ShowNotification('Stopped vehicle engine')
				else
					if GetVehicleFuelLevel(vehicle) < 3 then
						ESX.ShowNotification('There\'s no fuel in the tank', 5000, 'error')
					elseif GetVehicleEngineHealth(vehicle) < 101 then
						ESX.ShowNotification('The engine wont turn over, something must be wrong with it', 5000, 'error')
					else
						SetVehicleEngineOn(vehicle, true, false, true)
						ESX.ShowNotification('Started vehicle engine')
					end
				end
			else
				ESX.ShowNotification('You only the driver can do that')
			end
		elseif type == "driver" then
			if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 then
				SetVehicleDoorShut(vehicle, 0, false)
			else
				SetVehicleDoorOpen(vehicle, 0, false)
			end
		elseif type == "passanger" then
			if GetVehicleDoorAngleRatio(vehicle, 1) > 0.0 then
				SetVehicleDoorShut(vehicle, 1, false)
			else
				SetVehicleDoorOpen(vehicle, 1, false)
			end
		elseif type == "rearLeftDoor" then
			if maxSeats >= 4 then
				if GetVehicleDoorAngleRatio(vehicle, 2) > 0.0 then
					SetVehicleDoorShut(vehicle, 2, false)
				else
					SetVehicleDoorOpen(vehicle, 2, false)
				end
			else
				TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'error', text = "You do not have any rear doors" })
			end
		elseif type == "rearRightDoor" then
			if maxSeats >= 4 then
				if GetVehicleDoorAngleRatio(vehicle, 3) > 0.0 then
					SetVehicleDoorShut(vehicle, 3, false)
				else
					SetVehicleDoorOpen(vehicle, 3, false)
				end
			else
				TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'error', text = "You do not have any rear doors" })
			end
		elseif type == "trunk" then
			if GetVehicleDoorAngleRatio(vehicle, 5) > 0.0 then
				SetVehicleDoorShut(vehicle, 5, false)
			else
				SetVehicleDoorOpen(vehicle, 5, false)
			end
		elseif type == "hood" then
			if GetVehicleDoorAngleRatio(vehicle, 4) > 0.0 then
				SetVehicleDoorShut(vehicle, 4, false)
			else
				SetVehicleDoorOpen(vehicle, 4, false)
			end
		end
	end
end)