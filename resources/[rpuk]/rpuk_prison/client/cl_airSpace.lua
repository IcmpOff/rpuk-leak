RegisterNetEvent('rpuk_prison:explodeHeli')
AddEventHandler('rpuk_prison:explodeHeli', function(target)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local missle = NetworkExplodeVehicle(vehicle, true, false, 0)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local plyPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(plyPed)
		local coord = GetEntityCoords(plyPed)
		local vehicleClass = GetVehicleClass(vehicle)
		local inHeli = (vehicleClass == 15 or vehicleClass == 16)
		local netPedFromFrontSeat = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehicle, -1)))
		local typeMSG
		local alertMSG
		if (prisonMessage:isPointInside(coord) or airfieldMessage:isPointInside(coord) or prisonDrain:isPointInside(coord) or airfield:isPointInside(coord)) then
			if inHeli then
				local mastOnline = exports.gcphone:mastCheck(coord)
				if mastOnline then
					if (prisonMessage:isPointInside(coord) or airfieldMessage:isPointInside(coord)) then
						if isInList(ESX.Player.GetJobName(), config.allowedInFlyZone) then
							alertMSG = "You are in restricted air space. This air space is protected by The Royal Air Force! You have been authorised to enter this air space!"
							typeMSG = "success"
						else
							alertMSG = "You are in restricted air space. This air space is protected by The Royal Air Force! Turn around or you will be treated as a threat and will be shot down!"
							typeMSG = "error"
						end
						TriggerEvent('mythic_notify:client:SendAlert', {
							length = 6000,
							type = typeMSG,
							text = alertMSG
						})
						Citizen.Wait(8000)
					end
					if (prisonDrain:isPointInside(coord) or airfield:isPointInside(coord)) then
						TriggerServerEvent("rpuk_prison:jobCheckFlyZone", netPedFromFrontSeat)
					end
				end
			end
		else
			Citizen.Wait(5000)
		end
	end
end)







