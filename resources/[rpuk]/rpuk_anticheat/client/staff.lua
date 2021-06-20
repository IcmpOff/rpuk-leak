local player_blips, blips_active = {}, false
RegisterNetEvent('rpuk:staff_blips')
AddEventHandler('rpuk:staff_blips', function()
	blips_active = not blips_active

	if not blips_active then
		for _, old in pairs(player_blips) do
			RemoveBlip(old)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true

		if blips_active then
			for _, old in pairs(player_blips) do
				RemoveBlip(old)
			end

			for i=1, #GetActivePlayers(), 1 do
				local player = GetPlayerFromServerId(i)
				if NetworkIsPlayerActive(player) then
					createBlip(player, GetPlayerName(player))
				end
			end

			Citizen.Wait(10000)
		end

		if canSleep then
			Citizen.Wait(1500)
		end
	end
end)

function createBlip(id, name)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipScale(blip, 0.6) -- set scale
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(name)
		EndTextCommandSetBlipName(blip)
		table.insert(player_blips, blip)
	end
end