-- https://raw.githubusercontent.com/EGUltraTM/HideInTrunk/master/client/main.lua
-- modified for rpuk and optimized threads

local inTrunk = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true
		if inTrunk then
			local vehicle = GetEntityAttachedTo(PlayerPedId())
			if DoesEntityExist(vehicle) or not IsPedDeadOrDying(PlayerPedId()) or not IsPedFatallyInjured(PlayerPedId()) then
				canSleep = false
				local coords = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'boot'))
				SetEntityCollision(PlayerPedId(), false, false)
				ESX.Game.Utils.DrawText3D(coords, '~s~[~r~E~s~] Leave', 0.4)
				if GetVehicleDoorAngleRatio(vehicle, 5) < 0.9 then
					SetEntityVisible(PlayerPedId(), false, false)
				else
					if not IsEntityPlayingAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 3) then
						loadDict('timetable@floyd@cryingonbed@base')
						TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
						SetEntityVisible(PlayerPedId(), true, false)
					end
				end
				if IsControlJustReleased(0, 38) and inTrunk then
					SetCarBootOpen(vehicle)
					SetEntityCollision(PlayerPedId(), true, true)
					Wait(750)
					inTrunk = false
					DetachEntity(PlayerPedId(), true, true)
					SetEntityVisible(PlayerPedId(), true, false)
					ClearPedTasks(PlayerPedId())
					SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))
					Wait(250)
					SetVehicleDoorShut(vehicle, 5)
				end
			else
				inTrunk = false
				SetEntityCollision(PlayerPedId(), true, true)
				DetachEntity(PlayerPedId(), true, true)
				SetEntityVisible(PlayerPedId(), true, false)
				ClearPedTasks(PlayerPedId())
				SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))
			end
		end
		if canSleep then
			Citizen.Wait(1500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 70)
		local canSleep = true
		if DoesEntityExist(vehicle) and IsVehicleSeatFree(vehicle,-1) then
			local isVehicleLocked = GetVehicleDoorsLockedForPlayer(vehicle, PlayerPedId())
			local trunk = GetEntityBoneIndexByName(vehicle, 'boot')
			if trunk ~= -1 then
				canSleep = false
				local coords = GetWorldPositionOfEntityBone(vehicle, trunk)
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) <= 1.5 then
					if not inTrunk then
						if GetVehicleDoorAngleRatio(vehicle, 5) < 0.9 then
							ESX.Game.Utils.DrawText3D(coords, '~s~[~r~E~s~] Hide~n~~s~[~r~H~s~] Open', 0.4)
								if IsControlJustReleased(0, 74)then
									if isVehicleLocked then
										TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "This vehicle is locked."})
									else
										if ESX.Game.RequestNetworkControlOfEntity(vehicle, true) then
											SetCarBootOpen(vehicle)
										end
									end
								end
						else
							ESX.Game.Utils.DrawText3D(coords, '~s~[~r~E~s~] Hide~n~~s~[~r~H~s~] Open', 0.4)
							if IsControlJustReleased(0, 74) then
								SetVehicleDoorShut(vehicle, 5)
							end
						end
					end
					if IsControlJustReleased(0, 38) and not inTrunk then
						local player = ESX.Game.GetClosestPlayer()
						local playerPed = GetPlayerPed(player)
						local playerPed2 = PlayerPedId()
						if not isVehicleLocked then
							if DoesEntityExist(playerPed) then
								if not IsEntityAttached(playerPed) or GetDistanceBetweenCoords(GetEntityCoords(playerPed), GetEntityCoords(PlayerPedId()), true) >= 5.0 then
									TriggerEvent('rpuk:carry_boot', false)
									SetCarBootOpen(vehicle)
									Wait(350)
									AttachEntityToEntity(PlayerPedId(), vehicle, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
									loadDict('timetable@floyd@cryingonbed@base')
									TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
									Wait(50)
									inTrunk = true

									Wait(1500)
									SetVehicleDoorShut(vehicle, 5)
								else
									TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "There is already a body inside."})
								end
							end
						else
							TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "This vehicle is locked."})
						end
					end
				end
			end
		end
		if canSleep then
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent('rpuk:carry_boot')
AddEventHandler('rpuk:carry_boot', function()
	inTrunk = false
	SetEntityCollision(PlayerPedId(), true, true)
	DetachEntity(PlayerPedId(), true, true)
	SetEntityVisible(PlayerPedId(), true, false)
	ClearPedTasks(PlayerPedId())
	SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))
end)

loadDict = function(dict)
	while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

SetEntityCollision(PlayerPedId(), true, true)
SetEntityVisible(PlayerPedId(), true, false)