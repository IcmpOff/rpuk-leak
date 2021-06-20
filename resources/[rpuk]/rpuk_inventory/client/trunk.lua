local openedTrunk = false
local vehicle = nil

function openedTrunk2(usedVehicle)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()

		while openedTrunk do
			playerPed = PlayerPedId()

			local distance = #(GetEntityCoords(usedVehicle) - GetEntityCoords(playerPed))
			local isPlayingAnimation = IsEntityPlayingAnim(playerPed, "missbigscore2aig_7@gunman", "boot_l_loop", 3)

			if distance > 10 then
				openedTrunk = false
				TriggerEvent("rpuk_inventory:closeInventory")
			end

			if not isPlayingAnimation then
				ESX.Streaming.RequestAnimDict("missbigscore2aig_7@gunman")
				TaskPlayAnim(playerPed, 'missbigscore2aig_7@gunman', 'boot_l_loop', 8.0, -8.0, -1, 33, 0, false, false, false)
			end

			Citizen.Wait(500)
		end

		ClearPedTasks(playerPed)
		ClearPedTasksImmediately(playerPed)
		ClearPedSecondaryTask(playerPed)
	end)
end

RegisterNetEvent("rpuk_inventory:inventoryStatus")
AddEventHandler("rpuk_inventory:inventoryStatus", function(state, data)
	if data and data.type == "rpuk_trunk" then
		if openedTrunk then
			local playerPed = PlayerPedId()
			openedTrunk = false

			if vehicle and DoesEntityExist(vehicle) then
				if DoesVehicleHaveDoor(vehicle, 5) then
					SetVehicleDoorShut(vehicle, 5, false)
				end

				ClearPedTasks(playerPed)
				ClearPedTasksImmediately(playerPed)
				ClearPedSecondaryTask(playerPed)
			end
		end
	end
end)

function openTrunkInventory()
	local playerPed = PlayerPedId()

	if IsPedOnFoot(playerPed) then
		local vehFront, distance = ESX.Game.GetClosestVehicle(GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.5, 0.0))
		vehicle = vehFront

		if distance > 2 then
			TriggerEvent('mythic_notify:client:SendAlert', { length = 2500, action = 'longnotif', type = 'inform', text = "There is no vehicle in front of you"})
		else
			local vehiclePlate = GetVehicleNumberPlateText(vehFront)
			local locked = GetVehicleDoorsLockedForPlayer(vehFront, playerPed)
			local class = GetVehicleClass(vehFront)

			if locked then
				ESX.ShowNotification('The trunk on this vehicle is locked')
			else
				openedTrunk = true
				openedTrunk2(vehFront)
				TriggerServerEvent("rpuk_trunk:openTrunk", vehiclePlate, class)

				if DoesVehicleHaveDoor(vehFront, 5) then
					if GetVehicleDoorAngleRatio(vehFront, 5) > 0.0 then
						SetVehicleDoorShut(vehFront, 5, false)
					else
						SetVehicleDoorOpen(vehFront, 5, false)
					end
				end
			end
		end
	end
end

RegisterKeyMapping('opentrunkinventory', 'Open vehicle trunk', 'keyboard', 'y')
TriggerEvent('chat:addSuggestion', '/opentrunkinventory', 'Open vehicle trunk')
RegisterCommand('opentrunkinventory', openTrunkInventory)