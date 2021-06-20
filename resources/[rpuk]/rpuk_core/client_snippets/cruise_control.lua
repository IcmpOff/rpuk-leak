local cruiseActive = false
local initialSpeed, currentSpeed

local restrictedClasses = {
	[8] = false, [13] = true, [14] = true,
	[15] = true, [16] = true, [21] = true,
}

RegisterKeyMapping('cruisecontrol', 'Cruise Control', 'keyboard', 'y')
RegisterCommand('cruisecontrol', function(source)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local vehicleClass = GetVehicleClass(vehicle)
	local driver = GetPedInVehicleSeat(vehicle, -1)
	if vehicle ~= 0 and not restrictedClasses[vehicleClass] and driver == PlayerPedId() then
		cruiseActive = not cruiseActive

		if cruiseActive then
			initialSpeed = GetEntitySpeed(vehicle)
			local message = 'Cruise Control Activated at %.0f %s'

			if ShouldUseMetricMeasurements() then
				message = message:format(initialSpeed * 3.8, 'KM/H')
			else
				message = message:format(initialSpeed * 2.436, 'MPH')
			end

			TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = message})
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true
		if cruiseActive then
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			currentSpeed = GetEntitySpeed(vehicle)
			canSleep = false
			if GetVehicleFuelLevel(vehicle) < 10 then
				cruiseActive = false
				TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = 'Cruise Control Deactivated. Low fuel.'})
			elseif IsControlPressed(2, 72) or IsControlPressed(2, 71) then
				initialSpeed = currentSpeed
			elseif initialSpeed*2.436 > 10 and IsVehicleOnAllWheels(vehicle) and currentSpeed*2.436 > 10 then
				SetVehicleForwardSpeed(vehicle, initialSpeed)
			elseif IsControlPressed(2, 76) or IsControlJustReleased(2, 76) then
				cruiseActive = false
				TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = 'Cruise Control Deactivated. Handbrake engaged.'})
			else
				cruiseActive = false
				TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = 'Cruise Control Deactivated.'})
			end
		end
		if canSleep then
			Citizen.Wait(750)
		end
	end
end)
