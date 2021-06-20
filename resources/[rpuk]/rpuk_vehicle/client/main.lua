local HasSpawned, StatsSet, inRadius = true, false, false
Categories = nil
vehicleList = nil


RegisterNetEvent('rpuk:spawned')
AddEventHandler('rpuk:spawned', function(job) HasSpawned = true end)

Citizen.CreateThread(function() -- Grab the stats of the player//using the rec flags
	while true do
		Citizen.Wait(0)
		local letSleep = true

		if HasSpawned then
			local playerCoords = GetEntityCoords(PlayerPedId())

			for shop,data in pairs(Config.Shops) do
				for interaction, subInteration in pairs(data["Interactions"]) do
					local distance = #(playerCoords - data["Interactions"][interaction]["Location"])

					if distance < subInteration["Distance"]*10 then
						letSleep = false

						if interaction ~= "Management" and interaction ~= "OfferDesk" then
							DrawMarker(1, data["Interactions"][interaction]["Location"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0,1.0,1.0, 255,255,255, 100, false, true, 2, false, false, false, false)
						end

						if distance < subInteration["Distance"] then
							if interaction ~= "Management" and interaction ~= "OfferDesk" then
								ESX.ShowHelpNotification(data["Interactions"][interaction]["Text"])
							else
								ESX.Game.Utils.DrawText3D(data["Interactions"][interaction]["Location"], data["Interactions"][interaction]["Text"], 0.5, 6) end

								if IsControlJustReleased(0,data["Interactions"][interaction]["Control"]) then
									if interaction == "Management" then OpenGateway(shop)
									elseif interaction == "OfferDesk" then OfferGateway(shop)
									elseif interaction == "Purchase" then Gateway(shop)
									elseif interaction == "Modify" then ModifyInt(shop)
									elseif interaction == "Preview" then Vehicle_Preview(shop)
								end
							end
						end
					end
				end
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('rpuk_vehshop:setVehicleList')
AddEventHandler('rpuk_vehshop:setVehicleList', function(_vehicleList, _Categories)
	vehicleList = _vehicleList
	Categories = _Categories
end)