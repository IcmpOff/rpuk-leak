local interactions = {}
local activeInteractions = {}
local smoke = false

ESX.TriggerServerCallback("rpuk_pacificHeist:getPowerInfo", function(data)
	if not data then
		for k,v in pairs(config.vaultPanel) do
			if ESX.Player.GetJobName() == "police" then
				interactions["panel:" .. k] = {
					id = k,
					pos = v.panel,
					text = "Push [E] to Close Vault Door",
					dist = v.panel.dist,
					action = function()
						TriggerServerEvent("rpuk_pacificHeist:closeDoorSV")
						clearAnim()
						TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = "Vault door is now closed." })
				end}
			end
		end
	end
end)

ESX.TriggerServerCallback("rpuk_pacificHeist:getPanel", function(stage)
	for k,v in pairs(stage) do
		if v == 1 then
			TriggerEvent("rpuk_pacificHeist:hackingStageOne", k)
		elseif v == 2 then
			TriggerEvent("rpuk_pacificHeist:hackingStageTwo", k)
		elseif v == 3 then
			TriggerEvent("rpuk_pacificHeist:hackingStageThree", k)
		elseif v == 0 then
			TriggerEvent("rpuk_pacificHeist:restartHacking", k)
		end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, lastJob)
	local oldJob = lastJob.name

	if ESX.Player.GetJobName() == "police" then
		for k,v in pairs(config.vaultPanel) do
			interactions["panel:" .. k] = {
				id = k,
				pos = v.panel,
				text = "Push [E] to Close Vault Door",
				dist = v.panel.dist,
				action = function()
					TriggerServerEvent("rpuk_pacificHeist:closeDoorSV")
					clearAnim()
					TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = "Vault door is now closed." })
			end}
		end
	elseif oldJob.name == "police" then
		ESX.TriggerServerCallback("rpuk_pacificHeist:getPowerInfo", function(data)
			if data then
				for k,v in pairs(config.vaultPanel) do
					interactions["panel:" .. k] = nil
				end
			else
				for k,v in pairs(config.vaultPanel) do
					interactions["panel:" .. k] = {
						id = k,
						pos = v.panel,
						text = config.vaultPanelInteraction,
						dist = v.panel.dist,
						action = function()
							TriggerServerEvent("rpuk_pacificHeist:vaultPanel",	"panel:" .. k)
					end}
				end
			end
		end)
	end
end)

------------------------------------------------------------
--- Power
RegisterNetEvent("rpuk_pacificHeist:placeC4")
RegisterNetEvent("rpuk_pacificHeist:updateInteraction")
RegisterNetEvent("rpuk_pacificHeist:rebootTransformer")
RegisterNetEvent("rpuk_pacificHeist:c4Countdown")
RegisterNetEvent("rpuk_pacificHeist:startSmoke")
RegisterNetEvent("rpuk_pacificHeist:countDown")
RegisterNetEvent("rpuk_pacificHeist:explosion")
RegisterNetEvent("rpuk_pacificHeist:stopFlames")
--- Bank
RegisterNetEvent("rpuk_pacificHeist:connectDevice")
RegisterNetEvent("rpuk_pacificHeist:restartHacking")
RegisterNetEvent("rpuk_pacificHeist:hackingStageOne")
RegisterNetEvent("rpuk_pacificHeist:hackingStageTwo")
RegisterNetEvent("rpuk_pacificHeist:hackingStageThree")
RegisterNetEvent("rpuk_pacificHeist:hackUse")
RegisterNetEvent("rpuk_pacificHeist:stageOne")
RegisterNetEvent("rpuk_pacificHeist:stageTwo")
RegisterNetEvent("rpuk_pacificHeist:stageThree")
RegisterNetEvent("rpuk_pacificHeist:setupVault")
RegisterNetEvent("rpuk_pacificHeist:vaultDoorOpen")
RegisterNetEvent("rpuk_pacificHeist:vaultDoorClose")
RegisterNetEvent("rpuk_pacificHeist:searchingSafe")
RegisterNetEvent("rpuk_pacificHeist:restartSafe")
RegisterNetEvent("rpuk_pacificHeist:rewardInteraction")
RegisterNetEvent("rpuk_pacificHeist:beginDrill")
RegisterNetEvent("rpuk_pacificHeist:boxRewardInteraction")
RegisterNetEvent("rpuk_pacificHeist:activateDepositBoxes")
------------------------------------------------------------

function getDistance(coords1, coords2)
	return Vdist2(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z)
end

function Draw3DText(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.02+ factor, 0.03, 110, 110, 110, 75)
end

function activateInteraction(id)
	Citizen.CreateThread(function()
		local v = nil
		activeInteractions[id] = true
		while true do
			Citizen.Wait(0)
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			v = interactions[id]
			if v == nil then
				break
			end
			if getDistance(coords, v.pos) < v.dist then
				Draw3DText(v.pos.x, v.pos.y, v.pos.z+1.5, v.text)
				if IsControlJustReleased(0, 38) and v.action ~= nil then
					v.action()
					Wait(0)
				end
			else
				break
			end
		end
		activeInteractions[id] = nil
	end)
end

function clearAnim()
	local ped = PlayerPedId()
		ResetPedMovementClipset(ped, 0.0)
		ResetPedWeaponMovementClipset(ped)
		ResetPedStrafeClipset(ped)
		ClearPedTasks(ped)
end

function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		clearAnim()
		smoke = false
		startFire = false
		TriggerServerEvent("rpuk_pacificHeist:closeDoorSV")
	end
end)



Citizen.CreateThread(function()
	while true do
		Wait(500)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(interactions) do
			if getDistance(coords, v.pos) < v.dist and activeInteractions[k] == nil then
				activateInteraction(k)
			end
		end
	end
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

AddEventHandler("rpuk_pacificHeist:updateInteraction", function(id, key, val, params)
	if params then
		if params.exclude then
			for k,v in pairs(params.exclude) do
				if v == ESX.Player.GetJobName() then
					return
				end
			end
		end
		if params.include then
			local isIncluded = false
			for k,v in pairs(params.include) do
				if v == ESX.Player.GetJobName() then
					isIncluded = true
				end
			end
			if not isIncluded then
				return
			end
		end
	end

	if interactions[id] then
		interactions[id][key] = val
	end
end)

--------------------------------------------------------------------------------------------------------------------------------

-- Power Transformer

--------------------------------------------------------------------------------------------------------------------------------

for k,v in pairs(config.transformerLocation) do
	interactions["transformer:" .. k] = {
		id = k,
		pos = v.transformerSwitch,
		text = config.transformerInteraction,
		dist = 15,
		action = function()
			if ESX.Player.GetJobName() == "police" then
				TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'error', text = "You can not do this." })
			else
				TriggerServerEvent("rpuk_pacificHeist:C4Check",	"transformer:" .. k)
			end
		end}
end

AddEventHandler("rpuk_pacificHeist:rebootTransformer", function(id)
	local v = config.transformerLocation[tonumber(split(id, ":")[2])]
	interactions[id] = {
		text = config.transformerInteraction,
		pos = v.transformerSwitch,
		dist = v.transformerSwitch.dist,
		action = function()
			if ESX.Player.GetJobName() == "police" then
				TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'error', text = "You can not do this." })
			else
				TriggerServerEvent("rpuk_pacificHeist:C4Check",	id)
			end
		end
	}
end)

AddEventHandler("rpuk_pacificHeist:placeC4", function(id)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "c4",
		duration = 6000,
		label = "Placing C4",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@heists@ornate_bank@thermal_charge_heels",
			anim = "thermal_charge",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_bomb_01",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 200.0 },
		}
	}, function(status)
		if not status then
			TriggerServerEvent("rpuk_pacificHeist:fireTransformer", id)
			TriggerServerEvent("rpuk_pacificHeist:transformerCheck", id)
		else
			TriggerEvent("rpuk_pacificHeist:rebootTransformer", id)
			clearAnim()
			TriggerServerEvent('returnItem', 'c4')
		end
	end)
end)

AddEventHandler("rpuk_pacificHeist:startSmoke", function()
	Citizen.CreateThread(function()
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Citizen.Wait(10)
		end
		smoke = true
		while true do
			Citizen.Wait(1)
			if smoke then
				local playerloc = GetEntityCoords(PlayerPedId())
				local dst1 = GetDistanceBetweenCoords(playerloc, -1053.61, -230.07, 44.02, true)
				local dst2 = GetDistanceBetweenCoords(playerloc, -1056.05, -235.92, 44.02, true)
				SetPtfxAssetNextCall("core")
				Smoke = StartNetworkedParticleFxNonLoopedAtCoord("veh_respray_smoke", 664.15, 115.03, 83.45, 0.0, 0.0, 0.0, 0.80, false, false, false, false)
				Citizen.Wait(5000)
				StopParticleFxLooped(Smoke, 0)
			end
		end
	end)
end)

AddEventHandler("rpuk_pacificHeist:countDown", function()
	local soundID = GetSoundId()
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", 664.76196289063, 112.57879638672, 80.922912597656 - 20.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", 664.76196289063, 112.57879638672, 80.922912597656 - 20.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", 664.76196289063, 112.57879638672, 80.922912597656 - 20.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", 664.76196289063, 112.57879638672, 80.922912597656 - 20.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", 664.76196289063, 112.57879638672, 80.922912597656 - 20.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(1000)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", 664.76196289063, 112.57879638672, 80.922912597656 - 20.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(500)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", 664.76196289063, 112.57879638672, 80.922912597656 - 20.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(500)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", 664.76196289063, 112.57879638672, 80.922912597656 - 20.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(250)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", 664.76196289063, 112.57879638672, 80.922912597656 - 20.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(250)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", 664.76196289063, 112.57879638672, 80.922912597656 - 20.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	Citizen.Wait(150)
	PlaySoundFromCoord(soundID, "CONFIRM_BEEP", 664.76196289063, 112.57879638672, 80.922912597656 - 20.0 , "HUD_MINI_GAME_SOUNDSET", 1, 50, 0)
	StopSound(soundID)
	ReleaseSoundId(soundID)
	fire = StartScriptFire(662.5, 115.74, 83.45, 25, false)
	fire2 = StartScriptFire(665.61, 114.48, 83.45, 25, false)
	fire3 = StartScriptFire(664.15, 115.03, 83.45, 25, false)
	fire4 = StartScriptFire(664.63, 113.28, 83.45, 25, false)
	fire5 = StartScriptFire(663.56, 113.67, 83.45, 25, false)
	fire6 = StartScriptFire(661.93, 114.53, 83.45, 25, false)
	Citizen.Wait(4000)
	TriggerServerEvent("rpuk_pacificHeist:smoke")
	Citizen.Wait(10000)
end)

AddEventHandler("rpuk_pacificHeist:explosion", function()
	Citizen.Wait(6650)
	AddExplosion(663.85736083984, 115.19109344482, 83.150665283203, "EXPLOSION_PETROL_PUMP", 0, true, false, 10)
	Citizen.Wait(250)
	AddExplosion(663.85736083984, 115.19109344482, 83.150665283203, "EXPLOSION_PETROL_PUMP", 0, true, false, 10)
	Citizen.Wait(250)
	AddExplosion(663.85736083984, 115.19109344482, 83.150665283203, "EXPLOSION_PETROL_PUMP", 0, true, false, 10)
end)



AddEventHandler("rpuk_pacificHeist:stopFlames", function()
	smoke = false
	fireID = {fire,fire2,fire3,fire4,fire5,fire6}
	for k, v in pairs(fireID) do
		RemoveScriptFire(v)
	end
	TriggerServerEvent("rpuk_pacificHeist:setPowerOnline")
	bankDoors = {"bankPacific_13","bankPacific_11","bankPacific_10","bankPacific_9","bankPacific_8","bankPacific_7","bankPacific_6","bankPacific_5","bankPacific_4","bankPacific_3"}
	for k,v in pairs(bankDoors) do
		TriggerServerEvent("rpuk_doors:doorSetLocked", v)
	end
end)

--------------------------------------------------------------------------------------------------------------------------------

-- Vault Hacking Panels

--------------------------------------------------------------------------------------------------------------------------------

AddEventHandler("rpuk_pacificHeist:setupVault", function(id)
	ESX.TriggerServerCallback("rpuk_pacificHeist:getPowerInfo", function(powerStatus)
		if not powerStatus then
			if ESX.Player.GetJobName() == "police" then
				for k,v in pairs(config.vaultPanel) do
					interactions["panel:" .. k] = {
						id = k,
						pos = v.panel,
						text = "Push [E] to Close Vault Door",
						dist = v.panel.dist,
						action = function()
							TriggerServerEvent("rpuk_pacificHeist:closeDoorSV")
							clearAnim()
							TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = "Vault door is now closed." })
					end}
				end
			else
				for k,v in pairs(config.vaultPanel) do
					interactions["panel:" .. k] = {
						id = k,
						pos = v.panel,
						text = config.vaultPanelInteraction,
						dist = v.panel.dist,
						action = function()
							TriggerServerEvent("rpuk_pacificHeist:vaultPanel",	"panel:" .. k)
					end}
				end
			end
		else
			for k,v in pairs(config.vaultPanel) do
				interactions["panel:" .. k] = nil
			end
		end
	end, k)
end)

AddEventHandler("rpuk_pacificHeist:restartHacking", function(id)
	if ESX.Player.GetJobName() ~= "police" then
		local v = config.vaultPanel[tonumber(split(id, ":")[2])]
		interactions[id] = {
			text = config.vaultPanelInteraction,
			pos = v.panel,
			dist = v.panel.dist,
			action = function()
				TriggerServerEvent("rpuk_pacificHeist:vaultPanel",	id)
			end
		}
	end

end)

AddEventHandler("rpuk_pacificHeist:hackingStageOne", function(id)
	if ESX.Player.GetJobName() ~= "police" then
		local v = config.vaultPanel[tonumber(split(id, ":")[2])]
		interactions[id] = {
			text = "Push [E] to begin Hacking Stage Phase One",
			pos = v.panel,
			dist = v.panel.dist,
			action = function()
				TriggerEvent("rpuk_pacificHeist:stageOne", id)
			end
		}
	end
end)

AddEventHandler("rpuk_pacificHeist:hackingStageTwo", function(id)
	if ESX.Player.GetJobName() ~= "police" then
		local v = config.vaultPanel[tonumber(split(id, ":")[2])]
		interactions[id] = {
			text = "Push [E] to begin Hacking Stage Phase Two",
			pos = v.panel,
			dist = v.panel.dist,
			action = function()
				TriggerEvent("rpuk_pacificHeist:stageTwo", id)
			end
		}
	end

end)

AddEventHandler("rpuk_pacificHeist:hackingStageThree", function(id)
	if ESX.Player.GetJobName() ~= "police" then
		local v = config.vaultPanel[tonumber(split(id, ":")[2])]
		interactions[id] = {
			text = "Push [E] to begin Hacking Stage Phase Three",
			pos = v.panel,
			dist = v.panel.dist,
			action = function()
				TriggerEvent("rpuk_pacificHeist:stageThree", id)
			end
		}
	end

end)

AddEventHandler("rpuk_pacificHeist:stageOne", function(id)
	local stageOne = math.random(config.levelOneMinDifficulty, config.levelOneMaxDifficulty)
	local hackTime = math.random(config.minHackTime, config.maxHackTime)
	TriggerServerEvent("rpuk_pacificHeist:registerPanelInUse", id)
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start",stageOne,hackTime,function(success, timeremaining)
		if success then
			TriggerEvent('mhacking:hide')
			TriggerServerEvent("rpuk_pacificHeist:hackPanel", id, 2)
			clearAnim()
		else
			TriggerEvent('mhacking:hide')
			TriggerServerEvent("rpuk_pacificHeist:hackPanel", id, 1)
			clearAnim()
			TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'error', text = "You have failed." })
		end
	end)
	PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
end)

AddEventHandler("rpuk_pacificHeist:stageTwo", function(id)
local stageTwo = math.random(config.levelTwoMinDifficulty, config.levelTwoMaxDifficulty)
local hackTime = math.random(config.minHackTime, config.maxHackTime)
TriggerServerEvent("rpuk_pacificHeist:registerPanelInUse", id)
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start",stageTwo,hackTime,function(success, timeremaining)
		if success then
			TriggerEvent('mhacking:hide')
			TriggerServerEvent("rpuk_pacificHeist:hackPanel", id, 3)
			clearAnim()
		else
			TriggerEvent('mhacking:hide')
			TriggerServerEvent("rpuk_pacificHeist:hackPanel", id, 1)
			clearAnim()
			TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'error', text = "You have failed." })
		end
	end)
	PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
end)

AddEventHandler("rpuk_pacificHeist:stageThree", function(id)
local stageThree = math.random(config.levelThreeMinDifficulty, config.levelThreeMaxDifficulty)
local hackTime = math.random(config.minHackTime, config.maxHackTime)
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start",stageThree,hackTime,function(success, timeremaining)
		TriggerServerEvent("rpuk_pacificHeist:registerPanelInUse", id)
		if success then
			TriggerEvent('mhacking:hide')
			TriggerServerEvent("rpuk_pacificHeist:openDoorSV")
			clearAnim()
			TriggerServerEvent("rpuk_pacificHeist:vaultOpen", id)
		else
			TriggerEvent('mhacking:hide')
			TriggerServerEvent("rpuk_pacificHeist:hackPanel", id, 1)
			clearAnim()
			TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'error', text = "You have failed." })
		end
	end)
	PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
end)


AddEventHandler("rpuk_pacificHeist:connectDevice", function(id)
	PlaySoundFrontend(-1, "Pin_Bad", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", true)
	Citizen.Wait(500)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "upload",
		duration = 16000,
		label = "Uploading Software",
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
			model = "hei_prop_heist_card_hack",
			bone = 28422,
			coords = { x = 0.1, y = 0.0, z = -0.1 },
			rotation = { x = 120.0, y = -20.0, z = 10.0 },
		}
	}, function(status)
		if not status then
			TriggerServerEvent("rpuk_pacificHeist:hackPanel", id, 1)
		else
			TriggerServerEvent('returnItem', 'code_cracker')
			TriggerServerEvent("rpuk_pacificHeist:restartPanel", id)
			clearAnim()
		end
	end)
end)

AddEventHandler("rpuk_pacificHeist:vaultDoorOpen", function(id)
	local vault = GetClosestObjectOfType(254.56930541992, 224.97172546387,101.87572479248, 12.0, 961976194, false, false, false)
	SetEntityRotation(vault, 0.0, 0.0, 60.0, 0, true)
end)

AddEventHandler("rpuk_pacificHeist:vaultDoorClose", function(id)
	local vault = GetClosestObjectOfType(254.56930541992, 224.97172546387,101.87572479248, 12.0, 961976194, false, false, false)
	SetEntityRotation(vault, 0.0, 0.0, 160.0, 0, true)
end)

--------------------------------------------------------------------------------------------------------------------------------

--Office Safe

--------------------------------------------------------------------------------------------------------------------------------

for k,v in pairs(config.officeSafe) do
	interactions["safe:" .. k] = {
		id = k,
		pos = v.safe,
		text = config.safeInteraction,
		dist = 5.5,
		action = function()
			TriggerServerEvent("rpuk_pacificHeist:keycardCheck",	"safe:" .. k)
		end}
end

AddEventHandler("rpuk_pacificHeist:restartSafe", function(id)
	local v = config.officeSafe[tonumber(split(id, ":")[2])]
	interactions[id] = {
		pos = v.safe,
		text = config.safeInteraction,
		dist = 5.5,
		action = function()
			TriggerServerEvent("rpuk_pacificHeist:keycardCheck",	id)
		end}
end)


AddEventHandler("rpuk_pacificHeist:searchingSafe", function(id)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "safe",
		duration = 16000,
		label = "Searching Safe",
		useWhileDead = false,
		canCancel = false,
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
	}, function(status)
		if not status then
			TriggerEvent("rpuk_pacificHeist:rewardInteraction", id)
		end
	end)
end)

AddEventHandler("rpuk_pacificHeist:rewardInteraction", function(id)
	local v = config.officeSafe[tonumber(split(id, ":")[2])]
	interactions[id] = {
		pos = v.safe,
		text = "Push [E] Collect Keys",
		dist = 12,
		action = function()
			TriggerServerEvent("rpuk_pacificHeist:safeReward",	id)
			clearAnim()
		end}
end)


--------------------------------------------------------------------------------------------------------------------------------

--Deposit Boxes

--------------------------------------------------------------------------------------------------------------------------------

function depositOption(id)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), "rpuk_doors",
	{
		css = "interaction",
		align = "top-left",
		elements = {
			{
				label = "Use Drill",
				value = "drill"
			},
			{
				label = "Use Keys",
				value = "keys"
			}
		}
	}, function(data, menu)
		TriggerServerEvent("rpuk_pacificHeist:drillCheck", id, data.current.value)
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

AddEventHandler("rpuk_pacificHeist:activateDepositBoxes", function(id)
	ESX.TriggerServerCallback("rpuk_pacificHeist:vaultDoorInfo", function(vaultDoor)
		if vaultDoor then
			for k,v in pairs(config.depositBoxes) do
				interactions["boxes:" .. k] = {
					id = "boxes:" .. k,
					pos = v.box,
					text = config.depositBoxInteraction,
					dist = 3,
					action = function()
						depositOption("boxes:" .. k)
					end}
			end
		else
			for k,v in pairs(config.depositBoxes) do
				interactions["boxes:" .. k] = nil
			end
		end
	end, k)
end)

AddEventHandler("rpuk_pacificHeist:beginDrill", function(id)
	TriggerEvent("mythic_progbar:client:progress", {
		name = "box",
		duration = 30000,
		label = "Drilling Deposit Boxes",
		useWhileDead = false,
		canCancel = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@heists@fleeca_bank@drilling",
			anim = "drill_left",
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
		if not status then
			TriggerEvent("rpuk_pacificHeist:boxRewardInteraction", id)
		end
	end)
end)

AddEventHandler("rpuk_pacificHeist:boxRewardInteraction", function(id)
	local v = config.depositBoxes[tonumber(split(id, ":")[2])]
	interactions[id] = {
		pos = v.box,
		text = "Push [E] Open Box",
		dist = 3,
		action = function()
			TriggerEvent('dooranim')
			TriggerServerEvent("rpuk_pacificHeist:depositBoxReward",	id)
			clearAnim()
		end
	}
end)