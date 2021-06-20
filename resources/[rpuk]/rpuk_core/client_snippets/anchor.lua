local currentFreeze = false

AddEventHandler('rpuk_core:toggleBoatAnchor', function()
	local vehicleHandle = GetVehiclePedIsIn(PlayerPedId(), false)

	if DoesEntityExist(vehicleHandle) then
		local entityModel = GetEntityModel(vehicleHandle)

		if IsThisModelABoat(entityModel) then
			if GetEntitySpeed(vehicleHandle) * 3.6 < 10 then
				if IsBoatAnchoredAndFrozen(vehicleHandle) then
					SetForcedBoatLocationWhenAnchored(vehicleHandle, false)
					SetBoatFrozenWhenAnchored(vehicleHandle, false)
					SetBoatAnchor(vehicleHandle, false)
					ESX.ShowNotification('The boat is not anchored anymore')
				else
					SetBoatAnchor(vehicleHandle, true)
					SetBoatFrozenWhenAnchored(vehicleHandle, true)
					SetForcedBoatLocationWhenAnchored(vehicleHandle, true)
					ESX.ShowNotification('The boat is now anchored')
				end
			else
				ESX.ShowNotification('The boat is going too fast to drop an anchor', 5000, 'error')
			end
		else
			ESX.ShowNotification('That\'s not a boat!', 5000, 'error')
		end
	end
end)