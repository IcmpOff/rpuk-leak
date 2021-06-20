RegisterNetEvent("rpuk_doors:lockpick")
RegisterNetEvent("rpuk_doors:advanced_lockpick")
RegisterNetEvent("rpuk_doors:ziptie")
RegisterNetEvent("rpuk_doors:breachDoor")
RegisterNetEvent("rpuk_doors:currentlyhacking")
RegisterNetEvent("rpuk_doors:unZiptie")
RegisterNetEvent("rpuk_doors:explosion")
RegisterNetEvent("rpuk_doors:explosionSound")
RegisterNetEvent("rpuk_doors:drill")
RegisterNetEvent('dooranim')
RegisterNetEvent("rpuk_doors:repairDoor")


AddEventHandler('rpuk_doors:lockpick', function(id)
	local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
	local anim = "machinic_loop_mechandplayer"
	local lockpick = exports.rpuk_shops:createSafe({math.random(0,99),math.random(0,99),math.random(0,99),math.random(0,99),math.random(0,99)}, animDict, anim)

	if lockpick then
		if 100 * math.random() < interactions[id].data.chanceToNotify then
			TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "disturbance"})
		end
		TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'inform', text = "You have managed to lockpick the door" })
		PlaySoundFrontend( 0, "TUMBLER_RESET", "SAFE_CRACK_SOUNDSET", true );
		TriggerServerEvent('returnItem', 'lockpick')
		TriggerServerEvent('rpuk_doors:doorSetUnLocked', id)
		TriggerServerEvent('rpuk_doors:doneWithAction', "lockpicking", id)
	else
		TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'inform', text = "The lockpick bent out of shape." })
		PlaySoundFrontend( 0, "TUMBLER_PIN_FALL_FINAL", "SAFE_CRACK_SOUNDSET", 1);
		TriggerServerEvent('rpuk_doors:doneWithAction', "lockpicking", id)
	end
end)

AddEventHandler('rpuk_doors:advanced_lockpick', function(id)
	local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
	local anim = "machinic_loop_mechandplayer"
	local lockpick = exports.rpuk_shops:createSafe({math.random(0,99),math.random(0,99),math.random(0,99)}, animDict, anim)

	if lockpick then
		if 100 * math.random() < interactions[id].data.chanceToNotify then
			TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "disturbance"})
		end
		TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'inform', text = "You have managed to lockpick the door" })
		PlaySoundFrontend( 0, "TUMBLER_RESET", "SAFE_CRACK_SOUNDSET", true );
		TriggerServerEvent('returnItem', 'advanced_lockpick')
		TriggerServerEvent('rpuk_doors:doorSetUnLocked', id)
		TriggerServerEvent('rpuk_doors:doneWithAction', "lockpicking", id)
	else
		TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'inform', text = "The lockpick bent out of shape." })
		PlaySoundFrontend( 0, "TUMBLER_PIN_FALL_FINAL", "SAFE_CRACK_SOUNDSET", 1);
		TriggerServerEvent('rpuk_doors:doneWithAction', "lockpicking", id)
	end
end)

AddEventHandler('rpuk_doors:drill', function(id)
	crouch()
	TriggerEvent("mythic_progbar:client:progress", {
		name = "drill",
		duration = 25000,
		label = "Drilling the door",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@heists@fleeca_bank@drilling",
			anim = "drill_straight_fail",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "hei_prop_heist_drill",
			bone = 57005,
			coords = { x = 0.15, y = 0.0, z = -0.05 },
			rotation = { x = 0.0, y = 90.0, z = 90.0	},
		}
	}, function(status)
		TriggerServerEvent('rpuk_doors:doneWithAction', "lockpicking", id)
		TriggerServerEvent('returnItem', 'drill')
		if 100 * math.random() < interactions[id].data.chanceToNotify then
			TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "disturbance"})
		end
		if not status then
			PlaySoundFrontend( 0, "TUMBLER_PIN_FALL", "SAFE_CRACK_SOUNDSET", true );
			TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'inform', text = "You have managed to drill open the door" })
			TriggerServerEvent('rpuk_doors:doorSetUnLocked', id)
			clearAnim()
		elseif status then
			clearAnim()
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped drilling' })
		end
	end)
end)

AddEventHandler('rpuk_doors:ziptie', function(id)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "ziptie",
		duration = 6000,
		label = "Attaching Ziptie To Door",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
			task = nil,
		}
	}, function(status)
		TriggerServerEvent('rpuk_doors:doneWithAction', "beingZiptied", id)
		if not status then
			TriggerServerEvent('rpuk_doors:doorSetZiptied', id)
		elseif status then
			TriggerServerEvent('returnItem', 'ziptie')
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped blocking the door' })
		end
	end)
end)

AddEventHandler('rpuk_doors:unZiptie', function(id)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "ziptie",
		duration = 6000,
		label = "Breaking ziptie",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_cs_bowie_knife",
			bone = 28422,
			coords = { x = 0.1, y = 0.0, z = -0.1 },
			rotation = { x = 120.0, y = -20.0, z = 10.0 },
		}
	}, function(status)
		TriggerServerEvent('rpuk_doors:doneWithAction', "beingUnZiptied", id)
		if not status then
			TriggerServerEvent('rpuk_doors:doorSetUnZiptied', id)
		elseif status then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped breaking the ziptie' })
		end
	end)
end)

AddEventHandler('rpuk_doors:breachDoor', function(id)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "breachDoor",
		duration = 1700,
		label = "Attaching Breaching Charge",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
			anim = "plant_vertical",
			flags = 15,
			task = nil,
		},
		prop = {
			model = "prop_bomb_01",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 200.0 },
		}
	}, function(status)
		TriggerServerEvent('rpuk_doors:doneWithAction', "breaching", id)
		if not status then
			TriggerServerEvent("rpuk_doors:explosion", id)
			Citizen.Wait(9650)
			TriggerServerEvent('rpuk_doors:doorSetUnLocked', id)
		elseif status then
			TriggerServerEvent('returnItem', 'breaching_charge')
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped breaching the door' })
		end
	end)
end)


AddEventHandler('rpuk_doors:repairDoor', function(id)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "repair",
		duration = 6000,
		label = "Repairing Door",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "amb@world_human_hammering@male@base",
			anim = "base",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_tool_hammer",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 0.0 },
		}
	}, function(status)
		TriggerServerEvent('rpuk_doors:doneWithAction', "repairing", id)
		if not status then
			TriggerServerEvent('rpuk_doors:doorSetLocked', id)
		elseif status then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped repairing the door' })
		end
	end)
end)

AddEventHandler('rpuk_doors:currentlyhacking', function(mycb)
	local difficulty = math.random(Config.levelMinDifficulty, Config.levelMaxDifficulty)
	local hackTime = math.random(Config.minHackTime, Config.maxHackTime)
		mycb = true
		TriggerEvent("mhacking:show") --This line is where the hacking even starts
		TriggerEvent("mhacking:start",difficulty,hackTime,mycb1) --This line is the difficulty and tells it to start. First number is how long the blocks will be the second is how much time they have is.
end)

function mycb1(success, timeremaining)
	if success then
		TriggerEvent('mhacking:hide')
		TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'success', text = "You have managed to breach the secruity system." })
		TriggerServerEvent('rpuk_doors:doorSetUnLocked', closestInteraction())
	else
		TriggerEvent('mhacking:hide')
		TriggerEvent('mythic_notify:client:SendAlert', { action = 'longnotif', type = 'error', text = "The police have been informed of your attempt!" })
		TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "disturbance"})
	end
end

AddEventHandler("rpuk_doors:explosionSound", function(pos)
	local soundID = GetSoundId()
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(500)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(500)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(250)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(250)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(150)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", pos.x, pos.y, pos.z - 5.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	StopSound(soundID)
	ReleaseSoundId(soundID)
end)

AddEventHandler("rpuk_doors:explosion", function(pos)
	Citizen.Wait(9650)
	AddExplosion(pos.x, pos.y, pos.z, "EXPLOSION_STICKYBOMB", false, true, false)
end)

function crouch()
	local ped = PlayerPedId()
	RequestAnimSet("move_ped_crouched")
	while not HasAnimSetLoaded("move_ped_crouched") do
			Citizen.Wait(0)
	end
	SetPedMovementClipset(ped, "move_ped_crouched",1.0)
	SetPedWeaponMovementClipset(ped, "move_ped_crouched",1.0)
	SetPedStrafeClipset(ped, "move_ped_crouched_strafing",1.0)
end

AddEventHandler('dooranim', function()
local ped = GetPlayerPed( -1 )

	if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
		Citizen.CreateThread( function()
			RequestAnimDict( "anim@heists@keycard@" )
			ClearPedSecondaryTask(ped)
			TaskPlayAnim((ped), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
			Citizen.Wait(400)
			ClearPedTasks(ped)
		end)
	end
end)