local pickupThread = false

RegisterNetEvent('rpuk_gangs:assign_cocaine')
AddEventHandler('rpuk_gangs:assign_cocaine', function(selection)
	if pickupThread then
		return
	end
	pickupThread = true
	local pickupLocation = Config.IslandPickups[selection]
	while pickupThread do
		local canSleep = 10000
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local distance = #(playerCoords - pickupLocation)
		if distance <= 500 then
			canSleep = 100
			if distance <= 1.5 then
				canSleep = 0
				ESX.Game.Utils.DrawText3D(pickupLocation, "Press [~y~E~s~] To Open Package", 0.8, 6)
				if IsControlJustReleased(0, 32) then
					TriggerEvent("mythic_progbar:client:progress", {
						name = "gangcrate",
						duration = 420000, -- 7 mins = 420000
						label = "Opening Crate",
						useWhileDead = false,
						canCancel = true,
						controlDisables = {
						  disableMovement = true,
						  disableCarMovement = true,
						  disableMouse = false,
						  disableCombat = true,
						},
						animation = {
						  animDict = nil,
						  anim = nil,
						  flags = 49,
						  task = "",
						}
					  }, function(status)
						if not status then
							local new_dist = #(GetEntityCoords(playerPed) - pickupLocation)
							if new_dist < 5 then
								TriggerServerEvent('rpuk_gangs:claim_crate', 12200)
								Citizen.Wait(1000)
								pickupThread = false
							else
								TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = "You were too far away to collect the crate."})
							end
						end
					end)
				end
			end
		end
		
		Citizen.Wait(canSleep)
	end
end)

RegisterNetEvent('rpuk_gangs:clearPickupCrates')
AddEventHandler('rpuk_gangs:clearPickupCrates', function()
	pickupThread = false
end)