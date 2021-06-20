local deathCauseList = {
	[GetHashKey('WEAPON_DROWNING')] = 'Drowned under water',
	[GetHashKey('WEAPON_DROWNING_IN_VEHICLE')] = 'Drowned under water inside an vehicle',
	[GetHashKey('WEAPON_BLEEDING')] = 'Bleeded to death',
	[GetHashKey('WEAPON_EXPLOSION')] = 'Died from an explosion',
	[GetHashKey('WEAPON_FALL')] = 'Fell to his/her death',
	[GetHashKey('WEAPON_HIT_BY_WATER_CANNON')] = 'Hit by a water cannon',
	[GetHashKey('WEAPON_RAMMED_BY_CAR')] = 'Death from world after exiting (or being exited from) vehicle (high speed exit/flying out of windscreen)',
	[GetHashKey('WEAPON_RUN_OVER_BY_CAR')] = 'Rammed by an vehicle',
	[GetHashKey('WEAPON_HELI_CRASH')] = 'Died from a heli crash',
	[GetHashKey('WEAPON_FIRE')] = 'Burned to death',
	[GetHashKey('WEAPON_UNARMED')] = 'Beaten to death in a fist fight', -- unsigned
	[-1569615261] = 'Beaten to death in a fist fight', -- int https://gtaforums.com/topic/717612-v-scriptnative-documentation-and-research/?do=findComment&comment=1067469487
	[GetHashKey('WEAPON_ANIMAL')] = 'Killed by an animal',
	[GetHashKey('WEAPON_COUGAR')] = 'Killed by an cougar',
	[GetHashKey('VEHICLE_WEAPON_PLANE_ROCKET')] = 'Killed by a helicopter rocket',
	[-1323279794] = 'Mowed over by an aircraft'
}

Citizen.CreateThread(function()
	local isPlayerDead = false

	while true do
		Citizen.Wait(0)
		local player = PlayerId()

		if NetworkIsPlayerActive(player) then
			local playerPed = PlayerPedId()

			if IsPedFatallyInjured(playerPed) and not isPlayerDead then
				isPlayerDead = true
				local killerEntity, deathCause = GetPedSourceOfDeath(playerPed), GetPedCauseOfDeath(playerPed)
				local killerClientId = NetworkGetPlayerIndexFromPed(killerEntity)

				if killerEntity ~= playerPed and killerClientId and NetworkIsPlayerActive(killerClientId) then
					PlayerKilledByPlayer(playerPed, killerClientId, deathCause)
				else
					PlayerKilled(playerPed, deathCause)
				end
			elseif not IsPedFatallyInjured(playerPed) then
				isPlayerDead = false
			end
		end
	end
end)

function PlayerKilledByPlayer(playerPed, killerClientId, deathCause)
	local victimCoords = GetEntityCoords(playerPed)
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance = #(victimCoords - killerCoords)

	local data = {
		victimCoords = victimCoords,
		killerCoords = killerCoords,
		killerServerId = GetPlayerServerId(killerClientId),
		killedByPlayer = true,
		deathCause = ProcessDeathCause(deathCause),
		rawDeathCause = deathCause,
		distance = ESX.Math.Round(distance, 1)
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end

function PlayerKilled(playerPed, deathCause)
	local data = {
		victimCoords = GetEntityCoords(playerPed),
		killedByPlayer = false,
		deathCause = ProcessDeathCause(deathCause),
		rawDeathCause = deathCause
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end

function ProcessDeathCause(deathHash)
	if not deathHash then
		return 'Could not reverse death cause, hash was nil'
	end

	-- process weapon death hash
	for name,v in pairs(Config.Weapons) do
		if GetHashKey(name) == deathHash then
			return ('Killed using weapon "%s"'):format(v.label)
		end
	end

	if deathCauseList[deathHash] then
		return deathCauseList[deathHash]
	end

	return ('Could not look up death cause! Hash: %s'):format(deathHash)
end