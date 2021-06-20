local using = false

local static_list = {
	[1114264700] = "drink", -- Sprunk Green Vending Machine
	[992069095] = "drink", -- Cola Red Vending Machine
	[-742198632] = "drink", -- Water Fountain
	[690372739] = "drink", -- Coffee Machine
	[-1034034125] = "food", -- Candybox Vending Machine
	[-1581502570] = "food", -- Hotdog food stand
	[-654402915] = "food",
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true
		local coords = GetEntityCoords(PlayerPedId())

		for index, data in pairs(static_list) do
			local object = GetClosestObjectOfType(coords, 0.6, index, false)

			if DoesEntityExist(object) then
				local objectCoords = GetEntityCoords(object)
				if #(coords - objectCoords) < 2.0 and not using then
					canSleep = false
					ESX.Game.Utils.DrawText3D(objectCoords, "[~g~E~s~] USE VENDING MACHINE ~r~£50", 0.5, 6)
					if IsControlJustReleased(0, 38) then
						fnc_use(data)
					end
				end

				break
			end
		end

		if canSleep then
			Citizen.Wait(1500)
		end
	end
end)

function fnc_use(type)
	if not using then
		using = true
		TriggerServerEvent('rpuk:vending_machine', type)
		Citizen.Wait(1500)
		using = false
	end
end