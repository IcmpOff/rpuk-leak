local prompt, local_action = "", false

function startManufacturing(data)
	manufacturing = true
	Citizen.CreateThread(function()
		while manufacturing do
			Citizen.Wait(10000)
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			if #(playerCoords - data.coords) > 100 then
				end_handler()
			elseif check_actions() then
				end_handler()
			end
		end
	end)
	Citizen.CreateThread(function()
		while manufacturing do
			local letSleep = 2000
			local scaleform = ESX.Scaleform.PrepareBasicInstructional(data.buttons, ('(%s - Batch Size: %s)'):format(data.title, Config.batch_size))
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			if show_cookhud then
				letSleep = 0
				DrawScaleformMovieFullscreen(scaleform)
				if IsControlJustReleased(1, 168) then
					end_handler()
				elseif IsControlJustReleased(1, 304) then
					for _, aString in pairs(Config.Recipes[data.drug_type]) do
						TriggerEvent('mythic_notify:client:SendAlert', { length = 10000, type = 'inform', text = aString})
						Wait(1000)
					end
				elseif IsControlJustReleased(0, 172) and Config.batch_size <= 9 then
					Config.batch_size = Config.batch_size + 1
				elseif IsControlJustReleased(0, 173) and Config.batch_size >= 2 then
					Config.batch_size = Config.batch_size - 1
				end			
			end
			
			for k, v in pairs(data.cooking_array) do
				local distance = #(playerCoords - v.coord)
				if distance < 1.5 then
					letSleep = 0
					ESX.Game.Utils.DrawText3D(v.coord, v.text, 0.5, 4)
					if IsControlJustReleased(0, 38) and not local_action then
						local bar_data = v.data
						local savedBatchSize = Config.batch_size
						if bar_data then
							local_action = true
							ESX.TriggerServerCallback('rpuk_gangs:checkStage', function(ret)
								if ret then
									TriggerEvent("mythic_progbar:client:progress", {
										name = "drug_manu_bar",
										duration = bar_data.duration * Config.batch_size,
										label = bar_data.bar_text,
										useWhileDead = false,
										canCancel = true,
										controlDisables = {
											disableMovement = true,
											disableCarMovement = true,
											disableMouse = false,
											disableCombat = true,
										},
										playAnim(bar_data.lib, bar_data.anim_scen, bar_data.duration)
										}, function(status)
										if not status then
											TriggerServerEvent('rpuk_gangs:item_remove', bar_data, savedBatchSize)
											local_action = false
										elseif status then
											-- failed
											local_action = false
										end
									end)
								else
									Citizen.Wait(5000)
									local_action = false
								end
							end, bar_data, Config.batch_size)
						end
					end
				end
			end
			
			Citizen.Wait(letSleep)
		end
	end)	
end