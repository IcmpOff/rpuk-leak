local spikes_deployed = false
local obj1 = nil
local obj2 = nil
local obj3 = nil

Citizen.CreateThread(function() -- Main monitoring thread
	while true do
		Citizen.Wait(0)

		if spikes_deployed then
			local obj1coords = GetEntityCoords(obj1)
			local obj2coords = GetEntityCoords(obj2)
			local obj3coords = GetEntityCoords(obj3)

			for index, data in ipairs(GetActivePlayers()) do
				local currentVeh = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(index)), false)

				if currentVeh ~= nil and currentVeh ~= false then
					local currentVehcoords = GetEntityCoords(currentVeh)
					local DistanceBetweenObj1 = #(obj1coords - currentVehcoords)
					local DistanceBetweenObj2 = #(obj2coords - currentVehcoords)
					local DistanceBetweenObj3 = #(obj3coords - currentVehcoords)

					if DistanceBetweenObj1 < 3.25 or DistanceBetweenObj2 < 3.0 or DistanceBetweenObj3 < 3.0 then
						TriggerServerEvent("police:spikes", currentVeh, index)
					end
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- TODO this code eats FPS and needs to be gonish
-- Fallback monitoring thread
--[[
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local playerCoords = GetEntityCoords(playerPed)
			local p_stinger_02 = GetClosestObjectOfType(playerCoords, 0.7, GetHashKey("p_stinger_02"), false)
			local p_stinger_03 = GetClosestObjectOfType(playerCoords, 0.7, GetHashKey("p_stinger_03"), false)
			local p_stinger_04 = GetClosestObjectOfType(playerCoords, 0.7, GetHashKey("p_stinger_04"), false)

			if DoesEntityExist(p_stinger_02) or DoesEntityExist(p_stinger_03) or DoesEntityExist(p_stinger_04) then
				local currentVeh = GetVehiclePedIsIn(playerPed, false)
				TriggerEvent('police:dietyres', currentVeh)
			end
		else
			Citizen.Wait(500)
		end
	end
end)
]]

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if spikes_deployed and obj1 and DoesEntityExist(obj1) then
			local obj1coords = GetEntityCoords(obj1)

			if #(GetEntityCoords(PlayerPedId()) - obj1coords) > 200 then -- if the player is too far from his Spikes
				drawSpinner("Removing spikes!", 2000)

				ESX.Game.DeleteEntity(obj1)
				ESX.Game.DeleteEntity(obj2)
				ESX.Game.DeleteEntity(obj3)
				obj1 = nil
				obj2 = nil
				obj3 = nil
				spikes_deployed = false
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent("police:dietyres")
AddEventHandler("police:dietyres", function(currentVeh)
	SetVehicleTyreBurst(currentVeh, 0, false, 1000.0)
	SetVehicleTyreBurst(currentVeh, 1, false, 1000.0)
	SetVehicleTyreBurst(currentVeh, 2, false, 1000.0)
	SetVehicleTyreBurst(currentVeh, 3, false, 1000.0)
	SetVehicleTyreBurst(currentVeh, 4, false, 1000.0)
	SetVehicleTyreBurst(currentVeh, 5, false, 1000.0)
	Citizen.Wait(1000)
	ESX.Game.DeleteEntity(obj1)
	ESX.Game.DeleteEntity(obj2)
	ESX.Game.DeleteEntity(obj3)
	obj1 = nil
	obj2 = nil
	obj3 = nil
	spikes_deployed = false
end)

RegisterNetEvent("police:dietyres2")
AddEventHandler("police:dietyres2", function(peeps)
	SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 0, false, 1000.0)
	SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 1, false, 1000.0)
	SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 2, false, 1000.0)
	SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 3, false, 1000.0)
	SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 4, false, 1000.0)
	SetVehicleTyreBurst(GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(peeps)), false), 5, false, 1000.0)
end)

--=============================================================cALL IT

function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

function doAnimation()
	local coords  = GetEntityCoords(PlayerPedId())

	--FreezeEntityPosition(ped, true)
	loadAnimDict("pickup_object")
	TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 1.0, 1, -1, 33, 0, 0, 0, 0)
end

RegisterNetEvent("police:spikestrips")
AddEventHandler("police:spikestrips", function()
	if ESX.Player.GetJobName() == 'police' then
		SetEntityHeading(obj, GetEntityHeading(ped))
		Citizen.CreateThread(function()
			if not spikes_deployed then
				local spikes = GetHashKey("p_stinger_04")
				RequestModel(spikes)
				while not HasModelLoaded(spikes) do
					Citizen.Wait(0)
				end
				drawSpinner("Deploying spikes!", 1700)
				doAnimation()
				Citizen.Wait(1000)
				ClearPedTasksImmediately(PlayerPedId())
				Citizen.Wait(0)
				local playerheading = GetEntityHeading(PlayerPedId())
				zPass = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, -0.75)
				coords1 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, -0.75)
				coords2 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.25, -0.75)
				coords3 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 11.5, -0.75)
				obj1 = CreateObject(spikes, coords1['x'], coords1['y'], GetCoordZ(zPass.x, zPass.y, coords1['z']), true, true, true)
				obj2 = CreateObject(spikes, coords2['x'], coords2['y'], GetCoordZ(zPass.x, zPass.y, coords2['z']), true, true, true)
				obj3 = CreateObject(spikes, coords3['x'], coords3['y'], GetCoordZ(zPass.x, zPass.y, coords3['z']), true, true, true)
				SetEntityHeading(obj1, playerheading)
				SetEntityHeading(obj2, playerheading)
				SetEntityHeading(obj3, playerheading)
				Citizen.Wait(100)
				spikes_deployed = true
			else
				spikes_deployed = false
				drawSpinner("Removing spikes!", 1700)
				doAnimation()
				Citizen.Wait(1500)
				ClearPedTasksImmediately(PlayerPedId())
				Citizen.Wait(200)
				-- Move them out of world and flag to autocleanup - more reliable than delete entity
				SetEntityCoords(obj1, -5000.0, -5000.0, 20.0, true, false, false, true)
				SetEntityCoords(obj2, -5000.0, -5000.0, 20.0, true, false, false, true)
				SetEntityCoords(obj3, -5000.0, -5000.0, 20.0, true, false, false, true)
				SetEntityAsNoLongerNeeded(obj1)
				SetEntityAsNoLongerNeeded(obj2)
				SetEntityAsNoLongerNeeded(obj3)
				obj1 = nil
				obj2 = nil
				obj3 = nil
			end
		end)
	else
		TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "You can not do this." })
	end
end)

function drawSpinner(text, wait)
	AddTextEntry("polspikes", text)
	BeginTextCommandBusyspinnerOn("polspikes")
	EndTextCommandBusyspinnerOn(4)
	Citizen.Wait(wait)
	BusyspinnerOff()
end

function GetCoordZ(x, y, initial) -- Find ground
	local groundCheckHeights = {initial+0, initial+1, initial+2, initial+3, initial+4, initial+5, initial+6, initial+7, initial+8, initial+9, initial+10}
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end
	return initial -- fallback
end