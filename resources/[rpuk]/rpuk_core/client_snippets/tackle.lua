local TackleKey = 51 -- Change to a number which can be found here: https://wiki.fivem.net/wiki/Controls
local TackleTime = 1500 -- In milliseconds

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedJumping(PlayerPedId()) and IsControlJustReleased(0, TackleKey) then
			if IsPedInAnyVehicle(PlayerPedId()) then
				return
			else
				local ForwardVector = GetEntityForwardVector(PlayerPedId())
				local Tackled = {}
				local job = ESX.Player.GetJobName()

				if job == 'police' or job == 'gruppe6' then
					SetPedToRagdollWithFall(PlayerPedId(), 1500, 2000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
					while IsPedRagdoll(PlayerPedId()) do
						Citizen.Wait(0)
						for _, Value in ipairs(GetTouchedPlayers()) do
							if not Tackled[Value] then
								Tackled[Value] = true
								TriggerServerEvent('Tackle:Server:TacklePlayer', GetPlayerServerId(Value), ForwardVector.x, ForwardVector.y, ForwardVector.z, GetPlayerName(PlayerId()))
							end
						end
					end
				else
					TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'error', text = "Do not even try!" })
				end
			end
		end
	end
end)

RegisterNetEvent('Tackle:Client:TacklePlayer')
AddEventHandler('Tackle:Client:TacklePlayer', function(ForwardVectorX, ForwardVectorY, ForwardVectorZ, Tackler)
	SetPedToRagdollWithFall(PlayerPedId(), TackleTime, TackleTime, 0, ForwardVectorX, ForwardVectorY, ForwardVectorZ, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
end)

function GetTouchedPlayers()
	local TouchedPlayer = {}
	for _, Value in ipairs(GetActivePlayers()) do
		if IsEntityTouchingEntity(PlayerPedId(), GetPlayerPed(Value)) then
			table.insert(TouchedPlayer, Value)
		end
	end
	return TouchedPlayer
end