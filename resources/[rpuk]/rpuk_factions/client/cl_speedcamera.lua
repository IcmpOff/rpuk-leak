


RegisterNetEvent("rpuk_factions:changeStatus")
AddEventHandler("rpuk_factions:changeStatus", function(status)
	local UID = checkZoneCamera()
	if UID then
		if checkZoneCameraPerms() then
			if not status then
				TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'You have turned off the speed camera!' })
			else
				TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'You have turned on the speed camera!' })
			end
			TriggerServerEvent("rpuk_factions:svSync", UID, status)
		else
			takeDownPanel(UID)
		end
	end
end)

RegisterNetEvent("rpuk_factions:MDSync")
AddEventHandler("rpuk_factions:MDSync", function(UID, status)
	SpeedCamera.Locations[UID].Online = status
end)



Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local inVehicle = IsPedInAnyVehicle(ped, false)
		if inVehicle then
			local pedCoords = GetEntityCoords(ped)
			for k, v in pairs(SpeedCamera.Locations) do
				if v.Location:isPointInside(pedCoords) then
					speedCamera(v)
				end
			end
			Citizen.Wait(0)
		else
			Citizen.Wait(5000)
		end
	end
end)


function speedCamera(data)
	if data.Online then
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, false)
		local vehicleSpeed = GetEntitySpeed(vehicle)*2.436
		local vehicleModel = GetEntityModel(vehicle)
		local displayOfVehicle = string.lower(GetDisplayNameFromVehicleModel(vehicleModel))
		local vehiclePlate = GetVehicleNumberPlateText(vehicle)
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			if vehicleSpeed > SpeedCamera.SpeedToTriggerANPR then
				if string.find(vehiclePlate, " ") then
					if data.ANPR then
						--TriggerServerEvent("rpuk_factions:checkForWarrant", vehiclePlate, displayOfVehicle)
						Citizen.Wait(2000)
					end
				end
			end
			if vehicleSpeed > data.SpeedLimit then
				if data.SpeedDetection then
					if not isInList(displayOfVehicle, data.Whitelist) then
						-- if vehicleSpeed > (data.SpeedLimit+SpeedCamera.AlertSpeedToPolice) then
						-- 	TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "speeding", plate = vehiclePlate, model = GetLabelText(displayOfVehicle)})
						-- end
						if vehicleSpeed > data.SpeedLimit+SpeedCamera.SpeedLimitToFine then
							if string.find(vehiclePlate, " ") then
								TriggerServerEvent("rpuk_factions:speedingFine", data, vehicleSpeed, vehiclePlate)
							else
								TriggerEvent('mythic_notify:client:SendAlert', {length = 8000, type = 'inform', text = 'You have been caught speeding in a '..data.SpeedLimit..' zone. <br> A Fine has been sent to the owner of the Plate: '..vehiclePlate })
							end
							TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
							Citizen.Wait(2000)
						end
					end
				end
			end
		end
	end
end


RegisterNetEvent("rpuk_factions:alertPoliceForWarrant")
AddEventHandler("rpuk_factions:alertPoliceForWarrant", function(vehiclePlate, displayOfVehicle)
	TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "caughtVehicle", plate = vehiclePlate, model = GetLabelText(displayOfVehicle)})
end)

function checkZoneCamera()
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	for k, v in pairs(SpeedCamera.Locations) do
		if v.PanelLocation:isPointInside(pedCoords) then
			return k
		end
	end
end

function checkZoneCameraStatus()
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	for k, v in pairs(SpeedCamera.Locations) do
		if v.PanelLocation:isPointInside(pedCoords) then
			return v.Online
		end
	end
end

function checkZoneCameraPerms()
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	for k, v in pairs(SpeedCamera.Locations) do
		if isInList(ESX.Player.GetJobName(), SpeedCamera.Locations[k].Access)then
			return true
		end
	end
end

function checkIfCanCutPower()
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	for _, v in pairs(SpeedCamera.Locations) do
		if v.PanelLocation:isPointInside(pedCoords) then
			if v.Online then
				return true
			end
		end
	end
end

function takeDownPanel(UID)
	if UID then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "speedcamera",
			duration = 60000,
			label = "Turning Off Power",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
				closeInv = true
			},
			animation = {
				animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
				anim = "machinic_loop_mechandplayer",
				flags = 49,
				task = nil,
			},
		}, function(status)
			if not status then
				TriggerServerEvent("rpuk_factions:svSync", UID, false)
				TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "speedcameraoffline"})
				TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'You have disabled the speed camera!' })
			end
		end)
	end
end


