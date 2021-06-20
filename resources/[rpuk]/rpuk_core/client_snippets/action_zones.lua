Citizen.CreateThread(function()
	local triggered = false
	while true do
		Citizen.Wait(2)
		local canSleep = true
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		for _,v in pairs(Config.Zones) do
			local dist = #(coords - v.Marker)
			if dist < 50.0 then
				DrawMarker(v.MarkerSettings.type, v.Marker.x, v.Marker.y, v.Marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.MarkerSettings.x, v.MarkerSettings.y, v.MarkerSettings.z, v.MarkerSettings.r, v.MarkerSettings.g, v.MarkerSettings.b, v.MarkerSettings.a, false, true, 2, false, false, false, false)
				canSleep = false
				if dist < v.MarkerSettings.x then
					if v.MarkerSettings.job and v.MarkerSettings.job ~= ESX.Player.GetJobName() then
						return
					end

					if v.MarkerSettings.action == "teleport" then
						local text_coords = vector3(v.Marker.x, v.Marker.y, v.Marker.z + 1.0)
						ESX.Game.Utils.DrawText3D(text_coords, v.Text, 0.6)
						if IsControlPressed(0, 38) then
							goto_coordinates(v.TeleportPoint.coords, v.TeleportPoint.h)
						end
					elseif v.MarkerSettings.action == "auto_teleport" then
						goto_coordinates(v.TeleportPoint.coords, v.TeleportPoint.h)
					elseif v.MarkerSettings.action == "casino" then
						local selectedWeapon = GetSelectedPedWeapon(playerPed)
						if selectedWeapon ~= GetHashKey('WEAPON_UNARMED') then
							SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
						end
						DisableControlAction(0, 37, true) -- Casino disable weapon wheel
						if not triggered then
							TriggerEvent('rpuk_slots:InZoneRange', true)
							TriggerEvent('rpuk_blackjack:InZoneRange', true)
							triggered = true
						end
					elseif v.MarkerSettings.action == "pillbox" then
						local vehicle = GetVehiclePedIsIn(playerPed)
						if vehicle ~= 0 and vehicle ~= nil then
							DeleteEntity(vehicle)
						end
					end
				end
			end
		end

		if canSleep then
			Citizen.Wait(5000)
		end
	end
end)

function goto_coordinates(coords, heading)
	RequestCollisionAtCoord(coords)
	local player = PlayerPedId()
	DoScreenFadeOut(2000)
	Citizen.Wait(2000)
	SetEntityCoords(player, coords)
	SetEntityHeading(player, heading)
	DoScreenFadeIn(1500)
	TriggerEvent('instance:close')
	SetMobilePhoneRadioState(0)
	SetAudioFlag('MobileRadioInGame', 0)
end