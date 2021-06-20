manufacturing, show_cookhud, batch_size = false, true, 1

Citizen.CreateThread(function()
	while true do
		local canSleep = 7000
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		if not manufacturing then
			for index, data in pairs(Config.DrugLocations) do
				if data.assigned_turf == nil or Config.StashHouses[data.assigned_turf].controlled_by == ESX.Player.GetGangId() then
					local distance = #(playerCoords - data.coords)
					if distance < 1.5 then
						canSleep = 0
						ESX.Game.Utils.DrawText3D(data.coords, data.label, 0.5, 4)
						if IsControlJustReleased(0, 38) then
							begin_handler(data)
						end
						break
					elseif distance < 50.0 then
						canSleep = 2000
					end
				end
			end
		end
		Citizen.Wait(canSleep)
	end
end)

function begin_handler(data)
	startManufacturing(data)
	-- drug_meth_lowgrade_bag
	-- drug_meth_midgrade_bag
	-- drug_meth_highgrade_bag
	-- drug_cocaine_bag
	-- drug_crack_bag
end

function end_handler()
	manufacturing = false
end