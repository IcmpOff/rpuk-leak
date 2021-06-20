local sold_ped_list = {}

Citizen.CreateThread(function()
	while true do
		local canSleep = 7000
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local inZone = false
		for index, data in pairs(Config.StashHouses) do
			if #(playerCoords - data.coords) < data.range then -- in the territory
				canSleep = 1000
				turf_data.controlled_by = data.controlled_by
				if data.controlled_by == ESX.Player.GetGangId() then turf_data.reputation = "~g~Friendly~s~"
				elseif data.controlled_by ~= ESX.Player.GetGangId() and ESX.Player.GetGangId() ~= 0 then turf_data.reputation = "~r~Hostile~s~"
				else turf_data.reputation = "~y~Mutual~s~" end
				inZone = true
				local closestNpc, nType = GetClosestNpc(playerCoords.x, playerCoords.y, playerCoords.z, 2.5)
				if closestNpc and nType ~= nil and not interacting then
					canSleep = 0
					local npcCoords = GetEntityCoords(closestNpc)
					if not NetworkGetEntityIsNetworked(closestNpc) then
						break
					end
					ESX.Game.Utils.DrawText3D(vector3(npcCoords.x, npcCoords.y, npcCoords.z + 0.2), "[~b~H~s~] Offer Drugs", 0.7, 4)
					if IsControlJustReleased(0, 74) and not interacting then
						interacting = true
						if sold_ped_list[closestNpc] then
							if sold_ped_list[closestNpc] == "sale" then
								TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "You already sold to me..."})
							else
								TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "I told you no..."})
							end
							interacting = false
							break
						end
						local storedVehicle, freeSeat = GetVehiclePedIsIn(closestNpc, false), 0
						if storedVehicle ~= 0 then
							local driver = GetPedInVehicleSeat(storedVehicle, -1)
							if driver == closestNpc then freeSeat = -1 end
							TaskLeaveVehicle(closestNpc, storedVehicle, 1)
							Citizen.Wait(1000)
						end
						SetEntityAsMissionEntity(closestNpc)
						TaskStandStill(closestNpc, 1000)						
						ESX.TriggerServerCallback('rpuk_gangs:npc_interaction', function(result)
							if result == "sale" then
								RequestAnimDict("mp_ped_interaction")
								while not HasAnimDictLoaded("mp_ped_interaction") do
									Citizen.Wait(100)
								end
								local AnimCoords = GetOffsetFromEntityInWorldCoords(closestNpc, 0.0, 0.9, 0.0)
								SetEntityHeading(playerPed, GetEntityHeading(closestNpc) - 180.1)
								SetEntityCoordsNoOffset(playerPed, AnimCoords.x, AnimCoords.y, AnimCoords.z, 0)
								TaskPlayAnim(playerPed, "mp_ped_interaction", "handshake_guy_a", 8.0, -8.0, 4000, 14, 0, false, false, false)
								TaskPlayAnim(closestNpc, "mp_ped_interaction", "handshake_guy_b", 8.0, -8.0, 4000, 14, 0, false, false, false)
								Citizen.Wait(4000)
							elseif result == "police" or result == "turf" then
								TaskUseMobilePhoneTimed(closestNpc, 7000)
							end
							if result ~= "noxdrug" then
								TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = tostring(Config.Strings[result][math.random(1,4)])})
							end
							sold_ped_list[closestNpc] = result
							
							if storedVehicle ~= 0 then
								if freeSeat ~= -1 then
									local maxSeats = GetVehicleMaxNumberOfPassengers(storedVehicle)
									for i=maxSeats - 1, 0, -1 do
										if IsVehicleSeatFree(storedVehicle, i) then
											freeSeat = i
											break
										end
									end
								end
								TaskEnterVehicle(closestNpc, storedVehicle, -1, freeSeat, 2.0, 0)
							end
							SetPedAsNoLongerNeeded(closestNpc)
							Citizen.Wait(3000)
							interacting = false
						end, index, nType, data.controlled_by == ESX.Player.GetGangId())
					end
				end
			end
		end
		if not inZone then
			turf_data.controlled_by = 0
			turf_data.reputation = "None"
		end
		Citizen.Wait(canSleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		sleepTime = 5000
		if ESX.Player.GetGangId() == 0 then
			sleepTime = 5000 -- up this
		else
			if turf_data.controlled_by == 0 then
			elseif turf_data.controlled_by == ESX.Player.GetGangId() then
				SetPlayerCanBeHassledByGangs(PlayerId(), false)
			elseif turf_data.controlled_by ~= ESX.Player.GetGangId() then
				SetPlayerCanBeHassledByGangs(PlayerId(), true)
			end
		end
		Citizen.Wait(sleepTime)
	end
end)