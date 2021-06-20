interacting, turf_data = false, {controlled_by = 0, reputation = "Mutual"}

Citizen.CreateThread(function()
	while true do
		local canSleep = 7000
		local playerCoords = GetEntityCoords(PlayerPedId())
		for index, data_stash in pairs(Config.StashHouses) do
			if ESX.Player.GetGangId() == data_stash.controlled_by then
				local distance = #(playerCoords - data_stash.coords)

				if distance < data_stash.range then -- in the territory
					canSleep = 2500
					for int_type, data in pairs(Config.StashHouses[index].access_points) do

						local access_dist = #(playerCoords - data.location)
						if access_dist <= 3.5 then
							canSleep = 1
							ESX.Game.Utils.DrawText3D(data.location, data.label, 0.5, 4)
							if IsControlJustReleased(0, 38) and not interacting and access_dist <= 1.5 then
								if int_type == "clothing" then clothing_menu(index)
								elseif int_type == "storage" then access_storage(data_stash.controlled_by)
								elseif int_type == "weapon_manufacture" then access_weapon_manufacture(data_stash.controlled_by)
								elseif int_type == "support_npc" then support_npc(data.location)
								else
								end
							end
						end
						if (int_type == "support_npc") and not data.spawned then
							WaitForModel(data.model)
							local pedHandle = CreatePed(5, data.model, data.location[1], data.location[2], data.location[3]-0.7, data.heading, false)
							SetEntityAsMissionEntity(pedHandle, true, true)
							SetBlockingOfNonTemporaryEvents(pedHandle, true)
							SetModelAsNoLongerNeeded(data.model)
							FreezeEntityPosition(pedHandle, true)
							SetEntityCanBeDamaged(pedHandle, false)
							RequestAnimDict("timetable@ron@ig_3_couch")
							while not HasAnimDictLoaded("timetable@ron@ig_3_couch") do
								Citizen.Wait(10)
							end
							TaskPlayAnim(pedHandle, "timetable@ron@ig_3_couch", "base", 8.0, -8.0, -1, 2, 0.0, 0, 0, 0)
							data.spawned = true
						end
					end
				end
				break
			else
				canSleep = 10000
			end
		end
		Citizen.Wait(canSleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		local canSleep = 7000
		local playerCoords = GetEntityCoords(PlayerPedId())
		for index, data in pairs(Config.GrowShops) do
			local distance = #(playerCoords - data.coords)
			if distance < 150 then
				canSleep = 1750
				if distance < 1.5 then
					canSleep = 1
					ESX.Game.Utils.DrawText3D(data.coords, "[~b~E~s~] To Purchase\n"..data.label .. "\n~g~£"..data.price, 0.5, 4)
					if IsControlJustReleased(0, 38) and not interacting then
						interacting = true
						ESX.TriggerServerCallback('rpuk_gangs:purchaseGrow', function(cb_result)
							complete = cb_result
						end, index)
						while complete == nil do Citizen.Wait(1000) end
						interacting = false
					end
					break
				end
			end
		end
		Citizen.Wait(canSleep)
	end
end)