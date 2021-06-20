local moneyLocations = {
	vector3(115.84, -2006.01, 11.6),
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2)
		local coords = GetEntityCoords(PlayerPedId())
		local canSleep = true
		for i = 1, #moneyLocations, 1 do
			local distance = GetDistanceBetweenCoords(coords, moneyLocations[i].x, moneyLocations[i].y, moneyLocations[i].z, true)
			if distance < 1.7 then
				canSleep = false
				local tx_coords = vector3(moneyLocations[i].x, moneyLocations[i].y, moneyLocations[i].z + 1.5)
				ESX.Game.Utils.DrawText3D(tx_coords, "[~g~E~s~] To Launder Money", 0.5, 6)
				if IsControlJustReleased(1, 38) then
					ESX.TriggerServerCallback("rpuk_moneywash:returnVal", function(val, xMath)
						if val > 100 then
							TriggerEvent("mythic_progbar:client:progress", {
								name = "launder",
								duration = xMath,
								label = "Laundering Money",
								useWhileDead = false,
								canCancel = false,
								controlDisables = {
								  disableMovement = false,
								  disableCarMovement = false,
								  disableMouse = false,
								  disableCombat = false,
								},
								animation = {
								  animDict = nil,
								  anim = nil,
								  flags = 49,
								  task = "",
								},
								prop = {
									model = nil,
									bone = nil,
									coords = nil,
									rotation = nil,
								  }
							  }, function(status)
								if not status then
									local new_dist = GetDistanceBetweenCoords(coords, moneyLocations[i].x, moneyLocations[i].y, moneyLocations[i].z, true)
									if new_dist < 10 then
										TriggerServerEvent('rpuk_moneywash:process')
									else
										TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = "You were too far away to complete the laundering."})
									end
								end
							end)
						else
							TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = "You need at least £100 (Dirty) to launder money."})
						end
					end)
				end
			end
		end
		if canSleep then
			Citizen.Wait(1500)
		end
	end
end)