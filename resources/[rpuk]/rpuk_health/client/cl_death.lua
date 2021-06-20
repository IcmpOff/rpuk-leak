playersInJobDuty, dead, being_carried, spawned, count_nhs, injur = {police = {}, ambulance = {}}, false, false, false, false, false, 0

store = {
	dir = "misslamar1dead_body",
	anim = "dead_idle",

	death_coords = nil,
}

local tracked_blips = {}

RegisterNetEvent('esx:setJob')
RegisterNetEvent('rpuk:spawned')
RegisterNetEvent('rpuk_jobs:count')
RegisterNetEvent("rpuk_health:registerBlip")
RegisterNetEvent("rpuk_health:registerPlayerRevived")
RegisterNetEvent('AnimSet:Set:temp')
RegisterNetEvent('AnimSet:Set')
RegisterNetEvent("esx:playerLoaded")

AddEventHandler("esx:playerLoaded", function(data)
	if ESX.Player.GetJobName() == "ambulance" then
		ESX.TriggerServerCallback("rpuk_health:getDeadPlayers", function(deadPlayers)
			for k,v in pairs(deadPlayers) do
				createBlip(k)
			end
		end)
	end

	if ESX.Player.GetIsPlayerDead() == true then
		start_death()
	end
end)

RegisterNetEvent('rpuk_factions:updatePlayerDuty')
AddEventHandler('rpuk_factions:updatePlayerDuty', function(jobName, _playersInJobDuty)
	playersInJobDuty[jobName] = _playersInJobDuty
end)

AddEventHandler("rpuk_health:registerBlip", function(source)
	if ESX.Player.GetJobName() == "ambulance" then
		if GetResourceState('rpuk_housing') == 'started' then
			ESX.TriggerServerCallback("rpuk_housing:getHousePlayerIsIn", function(houseData)
				if houseData then
					createBlipForCoords(houseData, source)
				else
					createBlip(source)
				end
			end, source, "entrance")
		else
			createBlip(source)
		end
	end
end)

AddEventHandler("rpuk_health:registerPlayerRevived", function(source)
	if ESX.Player.GetJobName() == "ambulance" then
		removeBlip(tonumber(source))
	end
end)

function deadStatus() return dead end

function createBlipForCoords(coords, id)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 84)
	ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
	SetBlipColour(blip, 75)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Patient Callout")
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, 0.5) -- set scale
	SetBlipAsShortRange(blip, false)
	tracked_blips[id] = blip
end

function createBlip(id)
	local blip = ESX.Game.PlayerBlip(id, true, {sprite = 84, headingIndicator = true, colour = 75, string = "Patient Callout", scale = 0.5, shortRange = false})
	tracked_blips[id] = blip
end

function removeBlip(id)
	ESX.Game.PlayerBlip(id, false, {})
	tracked_blips[id] = nil
end

function DrawAdvancedText(text, x, y)
	SetTextFont(4)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	AddTextEntry('drawAdvancedText', text)
	BeginTextCommandDisplayText('drawAdvancedText')
	EndTextCommandDisplayText(x, y)
end

function clearAnim()
	local ped = PlayerPedId()
	ResetPedMovementClipset(ped, 0.0)
	ResetPedWeaponMovementClipset(ped)
	ResetPedStrafeClipset(ped)
end

function reviveEffect()
	local ped = PlayerPedId()
	ClearPedBloodDamage(ped)
	ResetPedVisibleDamage(ped)
	ClearPedLastDamageBone(ped)
	TriggerServerEvent('rpuk_restrain:registerHandsupState', false)
	DoScreenFadeIn(6000)
	TriggerEvent('esx_basicneeds:healPlayer')
	TriggerEvent("rpuk_weather:isBlurry", true)
	SetTimecycleModifier("hud_def_blur")
	SetTimecycleModifierStrength(0.7)
	SetEntityHealth(ped, 130)
	SetEntityVisible(ped, true, 0)
	SetEntityInvincible(ped, false)
	TriggerEvent("rpuk_core:radarToggle") -- Reset the Radar
	TriggerEvent("rpuk_hud:toggleHud", true)
	dead = false
end

function reviveEffectNoBlurr()
	local ped = PlayerPedId()
	ClearPedBloodDamage(ped)
	ResetPedVisibleDamage(ped)
	ClearPedLastDamageBone(ped)
	TriggerServerEvent('rpuk_restrain:registerHandsupState', false)
	DoScreenFadeIn(6000)
	SetEntityVisible(ped, true, 0)
	SetEntityInvincible(ped, false)
	TriggerEvent('esx_basicneeds:healPlayer')
	TriggerEvent("rpuk_core:radarToggle") -- Reset the Radar
	TriggerEvent("rpuk_hud:toggleHud", true)
	TriggerEvent("rpuk_weather:isBlurry", false)
	dead = false
end

function getNearestMedicDistance()
	local playerPed = PlayerPedId()
	local playerCoords, distances = GetEntityCoords(playerPed), {}

	for playerId,unit in pairs(playersInJobDuty.ambulance) do
		local player = GetPlayerFromServerId(playerId)

		if player and GetPlayerName(player) then
			local targetPed = GetPlayerPed(player)

			if DoesEntityExist(targetPed) and targetPed ~= playerPed then
				local targetCoords = GetEntityCoords(targetPed)
				local distance = #(playerCoords - targetCoords)

				table.insert(distances, distance)
			end
		end
	end

	table.sort(distances)

	if distances[1] then
		return ESX.Math.Round(distances[1])
	else
		return nil
	end
end


function loadAnimDict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname)
		while not HasAnimDictLoaded(dictname) do
		Citizen.Wait(1)
		end
	end
end

-- When dead handling thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()

		if IsPedDeadOrDying(ped) or IsPlayerDead(ped) and not dead then
			start_death()
		end

		if dead then
			loadAnimDict(store.dir)

			if not IsEntityPlayingAnim(ped, store.dir, store.anim, 3) and not being_carried then
				TaskPlayAnim(ped, store.dir, store.anim, 8.0, -8, -1, 1, 0, 0, 0, 0)
			end

			SetEntityVisible(ped, true, 0)
			SetEntityInvincible(ped, true)

			if GetEntityModel(ped) ~= GetHashKey('mp_m_freemode_01') and GetEntityModel(ped) ~= GetHashKey('mp_f_freemode_01') and GetEntityModel(ped) == GetHashKey('a_m_y_skater_01') then
				TriggerEvent('skinchanger:getSkin', function(skin)
					local model = 'mp_f_freemode_01'
					if skin.sex == 0 then
						model = 'mp_m_freemode_01'
					end

					if IsModelInCdimage(model) and IsModelValid(model) then
						RequestModel(model)
						while not HasModelLoaded(model) do Citizen.Wait(1000) end
						SetPlayerModel(PlayerId(-1), model)
					end

					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)



AddEventHandler('esx:setJob', function(job)
	if job.name ~= "ambulance" then
		for k,v in pairs(tracked_blips) do
			removeBlip(k)
		end
	elseif job.name == "ambulance" then
		ESX.TriggerServerCallback("rpuk_health:getDeadPlayers", function(deadPlayers)
			for k,v in pairs(deadPlayers) do
				createBlip(k)
			end
		end)
	end
end)

AddEventHandler('rpuk_jobs:count', function(xcount_pol, xcount_nhs, xcount_lost, xcount_mechanic)
	count_pol, count_nhs, count_lost, count_mechanic = xcount_pol, xcount_nhs, xcount_lost, xcount_mechanic
end)

AddEventHandler('rpuk:spawned', function()
	spawned = true
end)

function generateNearestMedicText(nearestMedic)
	if ShouldUseMetricMeasurements() then
		if nearestMedic < 1000 then
			return 'Less than a km away'
		elseif nearestMedic < 2000 then
			return 'Less than two km away'
		elseif nearestMedic < 3000 then
			return 'Less than three km away'
		else
			return ('%s meters away'):format(nearestMedic)
		end
	else
		local nearestMedicInFeet = nearestMedic * 3.2808
		nearestMedic = nearestMedic * 0.0006213712

		if nearestMedic < 1 then
			return 'Less than a mile away'
		elseif nearestMedic < 2 then
			return 'Less than two miles away'
		elseif nearestMedic < 3 then
			return 'Less than three miles away'
		else
			return ('%.0f feet away'):format(nearestMedicInFeet)
		end
	end
end

function getFurthestHospitalRespawnCoords(coords)
	for k,v in ESX.Table.Sort(config.respawnLocations, function(t, a, b)
		a = t[a]
		b = t[b]

		local distanceA = #(coords - a)
		local distanceB = #(coords - b)

		if distanceA < distanceB then
			return false
		elseif distanceB < distanceA then
			return true
		end
	end) do
		return v
	end
end

function start_death()
	if not dead then
		local ped = PlayerPedId()
		TriggerEvent('rpuk_anticheat:tg', true)
		TriggerEvent('rpuk:carry_boot', true)
		-- The technicals of the death, coords, state changes etc
		store.death_coords = GetEntityCoords(ped)
		SetEntityInvincible(ped, true)
		SetEntityVisible(ped, false, 0)
		NetworkResurrectLocalPlayer(store.death_coords.x, store.death_coords.y, store.death_coords.z, 0, true, false)
		TriggerEvent("removeOxygenTank")

		if IsPedInAnyVehicle(ped, false) then
			TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped, false), 16)
		end

		-- Client visuals and experience
		TriggerEvent("rpuk_core:DeathToggle") -- Clear the HUD
		TriggerEvent('rpuk_hud:toggleHud', false) -- Clear the HUD
		dead = true
		local heldECount = 0
		local secondsTilRespawnAvailable, secondsTilBleedout = 300, 1200 -- 5 mins, 20 mins
		local nearestMedic
		local alertedNHS = false

		if count_nhs == 0 then secondsTilRespawnAvailable = 120 end

		Citizen.Wait(1000)

		Citizen.CreateThread(function()
			while secondsTilRespawnAvailable > 0 and dead and not inbed do
				Citizen.Wait(1000)
				nearestMedic = getNearestMedicDistance()
				if secondsTilRespawnAvailable > 0 then secondsTilRespawnAvailable = secondsTilRespawnAvailable - 1 end
			end

			while secondsTilBleedout > 0 and dead and not inbed do
				Citizen.Wait(1000)
				nearestMedic = getNearestMedicDistance()
				if secondsTilBleedout > 0 then secondsTilBleedout = secondsTilBleedout - 1 end
			end
		end)

		Citizen.CreateThread(function()
			while secondsTilRespawnAvailable > 0 and dead and not inbed do
				Citizen.Wait(0)
				local min, sec = ESX.SecondsToClock(secondsTilRespawnAvailable)
				local text = ('Waiting for ambulance service~n~Respawn available in: %s:%s'):format(min, sec)
				if nearestMedic then text = ('%s~n~Nearest medic: %s'):format(text, generateNearestMedicText(nearestMedic)) end
				if not alertedNHS then text = ('%s~n~Press ~y~R~s~ to alert NHS'):format(text) end

				if IsControlPressed(0, 45) and not alertedNHS then
					alertedNHS = true
					if GetResourceState('rpuk_housing') == 'started' and exports.rpuk_housing:checkHouseData("entrance") then
						store.death_coords = exports.rpuk_housing:checkHouseData("entrance")
					else
						store.death_coords = GetEntityCoords(PlayerPedId())
					end

					TriggerServerEvent('rpuk_health:alertMedicOfPostion', GetPlayerServerId(PlayerId()))
					TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "patient", coords = store.death_coords})
				elseif alertedNHS then
					text = ('%s~n~You have alerted NHS of your position'):format(text)
				end
				DrawAdvancedText(text, 0.5, 0.02)
			end

			while secondsTilBleedout > 0 and dead and not inbed do
				Citizen.Wait(0)
				heldECount = heldECount + 1
				local min, sec = ESX.SecondsToClock(secondsTilBleedout)
				local text

				if IsControlPressed(0, 38) then
					text = ('Waiting for ambulance service~n~You will bleed out in: %s:%s~n~Hold ~y~E~s~ to respawn (%s %%)'):format(min, sec, heldECount)

					if heldECount >= 100 then
						break
					end
				else
					heldECount = 0
					text = ('Waiting for ambulance service~n~You will bleed out in: %s:%s~n~Hold ~y~E~s~ to respawn'):format(min, sec)
				end

				if not alertedNHS then text = ('%s~n~Press ~y~R~s~ to alert NHS'):format(text) end

				if IsControlPressed(0, 45) and not alertedNHS then
					alertedNHS = true
					if GetResourceState('rpuk_housing') == 'started' and exports.rpuk_housing:checkHouseData("entrance") then
						store.death_coords = exports.rpuk_housing:checkHouseData("entrance")
					else
						store.death_coords = GetEntityCoords(PlayerPedId())
					end
					TriggerServerEvent('rpuk_health:alertMedicOfPostion', GetPlayerServerId(PlayerId()))
					TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "patient", coords = store.death_coords})
				elseif alertedNHS then
					text = ('%s~n~You have alerted NHS of your position'):format(text)
				end
				if nearestMedic then text = ('%s~n~Nearest medic: %s'):format(text, generateNearestMedicText(nearestMedic)) end
				DrawAdvancedText(text, 0.5, 0.02)
			end

			if secondsTilBleedout == 0 and dead and not inbed or heldECount >= 100 then
				TriggerServerEvent('rpuk_health:respawn')
			end
		end)
	end
end

-- Handle the revive
RegisterNetEvent("rpuk_health:revive")
AddEventHandler("rpuk_health:revive", function(type)
	dead = false
	local ped = PlayerPedId()

	if IsEntityPlayingAnim(ped, "nm", "firemans_carry", 3) then
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
		local target = GetPlayerServerId(closestPlayer)

		if target ~= 0 then
			TriggerServerEvent("rpuk_carry:reviveStop", target)
		end
	end

	DoScreenFadeOut(1000)
	Citizen.Wait(1000)

	if type == "hospital" then
		local respawnCoords = getFurthestHospitalRespawnCoords(GetEntityCoords(ped))
		SetEntityCoords(ped, respawnCoords, 0.0, 0.0, 0.0, false)
		reviveEffectNoBlurr()
	elseif type == 'police' then
		SetEntityCoords(ped, -1119.17, -852.67, 18.69, 0.0, 0.0, 0.0, false)
		reviveEffectNoBlurr()
	elseif type == 'gruppe6' then
		SetEntityCoords(ped, 1853.81, 2592.32, 44.67, 0.0, 0.0, 0.0, false)
		reviveEffectNoBlurr()
	elseif type == "prison" then
		SetEntityCoords(ped, 1777.775, 2559.013, 45.722, 0.0, 0.0, 0.0, false)
		reviveEffectNoBlurr()
	elseif type == "admin" then
		reviveEffectNoBlurr()
	elseif type == "civ" then
		reviveEffect()
	end

	SetPedToRagdoll(ped, 1500, 1500, 0, 0, 0, 0)
	StopAnimTask(ped, store.dir, store.anim, 1)
	TriggerEvent('rpuk_anticheat:tg', false)
	TriggerEvent("rpuk_restrain:detachDrag")
	store.death_coords = nil
end)


--------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if dead or isSedated then
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 20, true) -- Z

			DisableControlAction(2, 303, true) -- U
			DisableControlAction(0, 73, true) -- X
			DisableControlAction(0, 323, true) -- X

			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D
			-- DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?
			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job
			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable Hansup
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle
			DisableControlAction(2, 36, true) -- Disable going stealth
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			if inbed then
				DisableControlAction(0, 201, true) -- Disable Enter Key
				if IsEntityPlayingAnim(PlayerPedId(), "nm", "firemans_carry", 3) then
					local closestPlayer, distance = ESX.Game.GetClosestPlayer()
					local target = GetPlayerServerId(closestPlayer)

					if target ~= 0 then
						TriggerServerEvent("rpuk_carry:reviveStop", target)
					end
				end
				TriggerEvent("rpuk_restrain:detachDrag")
			end
		else
			Citizen.Wait(500)
		end
	end
end)