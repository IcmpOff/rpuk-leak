local toggle_ragdoll = false

function setRagdoll(flag)
	toggle_ragdoll = flag
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if toggle_ragdoll then
			SetPedToRagdoll(PlayerPedId(), 1500, 1500, 0, 0, 0, 0)
		else
			Citizen.Wait(250)
		end
	end
end)

function anim_state(player)
	local ped = GetPlayerPed(player)
	local anim_data = {}
	anim_data[1] = IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3)
	anim_data[2] = IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3)
	anim_data[3] = IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3)
	return anim_data
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(2, 303) and IsInputDisabled(0) then
			local data = anim_state(PlayerPedId())
			if IsPedOnFoot(PlayerPedId()) and not data[1] and not data[2] and not data[3] then
				if exports.PolyZone:inPolyZone("Prison") then
					ESX.ShowNotification('You can\'t ragdoll at the prison', 5000, 'error')
				else
					if toggle_ragdoll then
						ESX.ShowNotification('Ragdoll: disabled', 5000, 'info')
						toggle_ragdoll = false
					else
						ESX.ShowNotification('Ragdoll: enabled', 5000, 'info')
						toggle_ragdoll = true
					end
				end
			end
		end
	end
end)