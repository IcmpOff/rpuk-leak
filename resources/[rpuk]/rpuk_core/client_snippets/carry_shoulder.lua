local carryingBackInProgress = false
local carryAnimNamePlaying = ''
local carryAnimDictPlaying = ''
local carryControlFlagPlaying = 0

function startCarryingClosestPlayer()
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()

	if IsPedOnFoot(PlayerPedId()) then
		if #(GetEntityCoords(PlayerPedId()) - vector3(1691.0, 2605.0, 45.5)) > 130 then
			if closestPlayer ~= -1 and closestPlayer and distance < 2 and HasEntityClearLosToEntity(PlayerPedId(), GetPlayerPed(closestPlayer), 17) then
				TriggerServerEvent('rpuk_carry:requestCarryingPlayer', GetPlayerServerId(closestPlayer))
			else
				ESX.ShowNotification('There is no one in your proximity', 5000, 'inform', 'error')
			end
		else
			ESX.ShowNotification('Carrying people in this location is not allowed', 5000, 'inform', 'error')
		end
	else
		ESX.ShowNotification('You need to be on foot to carry a player', 5000, 'inform', 'error')
	end
end

function GetCarry() return carryingBackInProgress end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if carryingBackInProgress then
			while not IsEntityPlayingAnim(PlayerPedId(), carryAnimDictPlaying, carryAnimNamePlaying, 3) do
				TaskPlayAnim(PlayerPedId(), carryAnimDictPlaying, carryAnimNamePlaying, 8.0, -8.0, 100000, carryControlFlagPlaying, 0, false, false, false)
				Citizen.Wait(0)
			end

			if not IsPedOnFoot(PlayerPedId()) then
				carryingBackInProgress = false
				TriggerEvent('rpuk_carry:stopCarry')
			end
		else
			Citizen.Wait(500)
		end
	end
end)

TriggerEvent('chat:addSuggestion', '/carry', 'Carry a nearby player on your shoulder')
RegisterCommand('carry', function() TriggerEvent('rpuk_core:carry') end)

RegisterNetEvent('rpuk_core:carry')
AddEventHandler('rpuk_core:carry', function()
	if carryingBackInProgress then
		TriggerServerEvent('rpuk_carry:stopCarry')
	else
		startCarryingClosestPlayer()
	end
end)

RegisterNetEvent('rpuk_carry:stopCarry')
AddEventHandler('rpuk_carry:stopCarry', function()
	carryingBackInProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

-- player who is carrying
RegisterNetEvent('rpuk_carry:startCarryPlayer')
AddEventHandler('rpuk_carry:startCarryPlayer', function(target)
	local animationLib, animation = 'nm', 'firemans_carry'
	TriggerEvent('rpuk:carry_boot', true)
	carryingBackInProgress = true

	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end

	AttachEntityToEntity(PlayerPedId(), GetPlayerPed(GetPlayerFromServerId(target)), 0, 0.27, 0.15, 0.63, 0.5, 0.5, 0.0, false, false, false, false, 2, false)

	TaskPlayAnim(PlayerPedId(), animationLib, animation, 8.0, -8.0, 100000, 33, 0, false, false, false)
	carryAnimNamePlaying = animation
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = 33
end)

-- player who is going to be carried
RegisterNetEvent('rpuk_carry:startCarryMe')
AddEventHandler('rpuk_carry:startCarryMe', function()
	local animationLib, animation = 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman'
	TriggerEvent('rpuk:carry_boot', true)
	carryingBackInProgress = true
	local playerPed = PlayerPedId()

	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end

	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, 100000, 49, 0, false, false, false)
	carryAnimNamePlaying = animation
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = 49
end)

RegisterNetEvent('rpuk:carry_boot')
AddEventHandler('rpuk:carry_boot', function(sync)
	if not sync then
		TriggerEvent('rpuk_carry:stopCarry')
	end
end)

RegisterNetEvent('rpuk_carry:requestCarry')
AddEventHandler('rpuk_carry:requestCarry', function(target)
	local carrier = GetPlayerPed(GetPlayerFromServerId(target))

	if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(carrier)) < 2 then
		local timer, accepted = GetGameTimer() + 5000, false

		while timer >= GetGameTimer() do
			Citizen.Wait(0)
			ESX.ShowHelpNotification("A Player Wants To Carry You!\n~INPUT_FRONTEND_ACCEPT~ To Accept\n~INPUT_FRONTEND_RRIGHT~ To Decline\n\n~c~You can stop this at any time by typing /carry or using the caps lock menu", true)

			if IsControlJustReleased(0, 194) then
				break
			elseif IsControlJustReleased(0, 201) then
				TriggerServerEvent('rpuk_carry:acceptCarry')
				accepted = true
				break
			end
		end

		if not accepted then
			TriggerServerEvent('rpuk_carry:declineCarry')
		end
	else
		TriggerServerEvent('rpuk_carry:declineCarry')
	end
end)