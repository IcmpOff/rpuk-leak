local enabled = false

RegisterKeyMapping('sessionheads', 'Player ID Check', 'keyboard', '')
RegisterCommand('sessionheads', function(source)
	if not enabled then
		fnc_sessionheads()
	end
end)

function fnc_sessionheads()
	enabled = true
	local AllPlayers = GetActivePlayers()
	local count = 90000
	Citizen.CreateThread(function()
		while enabled do
			Citizen.Wait(0)
			if count >= 80000 then
				for index, session in pairs(AllPlayers) do
					local pos = GetEntityCoords(GetPlayerPed(session))
					local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), pos)

					if distance <= 20 and IsEntityVisible(GetPlayerPed(session)) then
						if NetworkIsPlayerTalking(session) then
							DrawText3D(pos.x, pos.y, pos.z + 1.3, "~r~" .. GetPlayerServerId(session))
						else
							DrawText3D(pos.x, pos.y, pos.z + 1.3, "~w~" .. GetPlayerServerId(session))
						end
					end
				end
			end
			count = count - 10
			if count <= 0 then
				enabled = false
			end
		end
	end)
end

function table.removekey(array, element)
	for i = 1, #array do
		if array[i] == element then
			table.remove(array, i)
		end
	end
end

function DrawText3D(x, y, z, text)
	local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

	local scale = (1 / dist) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(0)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x, _y)
	end
end