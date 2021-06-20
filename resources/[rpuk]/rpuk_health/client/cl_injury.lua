local tempenabled = false
local tempset = "move_m@injured"

AddEventHandler('AnimSet:Set:temp', function(enabled,enabledSet)
	tempenabled = enabled
	tempset = enabledSet
	TriggerEvent("AnimSet:Set")
end)

AddEventHandler('AnimSet:Set', function()
	local ped = PlayerPedId()
	if tempenabled == true then
		RequestAnimSet(tempset)
		while not HasAnimSetLoaded(tempset) do Citizen.Wait(0) end
		SetPedMovementClipset(ped, tempset)
		SetPedWeaponMovementClipset(ped, tempset)
		ResetPedStrafeClipset(ped)
	elseif tempenabled == false then
		SetPedMovementClipset(ped)
		ResetPedWeaponMovementClipset(ped)
		ResetPedStrafeClipset(ped)
	end
end)

function randomresp()
	local math = math.random(10)
	local ret = "My arms feels warm with blood"
	if math == 5 then
		ret = "My legs feels warm with blood"
	elseif math < 4 then
		ret = "My head feels warm with blood"
	end
	TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = ret })
	return ret
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		if GetEntityHealth(ped) < 150 and not IsEntityDead(ped) and not dead then
			ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			Wait(1000)
			TriggerEvent("AnimSet:Set:temp", true,"move_m@injured")
			randomresp()
			ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			Wait(15000)
			injur = false
		elseif not injur then
			injur = true
			clearAnim()
		end
	end
end)