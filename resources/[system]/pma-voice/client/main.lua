local Cfg = Cfg
local currentGrid = 0
local volume = 1.0
local intialized = false
local voiceTarget = 1

--Radio mix
local radioEffectId = CreateAudioSubmix('Radio')
SetAudioSubmixEffectRadioFx(radioEffectId, 0)
SetAudioSubmixEffectParamInt(radioEffectId, 0, GetHashKey('default'), 1)
AddAudioSubmixOutput(radioEffectId, 0)

--Phone mix
--[[local phoneEffectId = CreateAudioSubmix('Phone')
SetAudioSubmixEffectRadioFx(phoneEffectId, 0)
SetAudioSubmixEffectParamFloat(phoneEffectId, 0, `freq_hi`, 1.0)
AddAudioSubmixOutput(phoneEffectId, 0)]]--

playerServerId = GetPlayerServerId(PlayerId())
voiceData = {
	mode = 2,
	radio = 0,
	call = 0,
	routingBucket = 0
}
radioData = {}
callData = {}

RegisterNetEvent('pma-voice:updateRoutingBucket')
AddEventHandler('pma-voice:updateRoutingBucket', function(routingBucket)
	voiceData.routingBucket = routingBucket
end)

function round(value, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

RegisterKeyMapping('radio_voldown', 'Radio Volume -', 'keyboard', '')
RegisterCommand('radio_voldown', function()
	if volume < 0.1 then
		volume = 0.0
	else
		volume = round(volume - 0.1, 1)
	end

	SendNUIMessage({radioVolume = volume})
end)

RegisterKeyMapping('radio_volup', 'Radio Volume +', 'keyboard', '')
RegisterCommand('radio_volup', function()
	if volume > 0.9 then
		volume = 1.0
	else
		volume = round(volume + 0.1, 1)
	end

	SendNUIMessage({radioVolume = volume})
end)

function toggleVoice(tgtId, enabled, effectType)
	if enabled and effectType then
		if effectType == 'radio' then
			MumbleSetSubmixForServerId(tgtId, radioEffectId)
		elseif effectType == 'phone' then
			--MumbleSetSubmixForServerId(tgtId, phoneEffectId)
		end
	elseif not enabled then
		MumbleSetSubmixForServerId(tgtId, -1)
	end
	MumbleSetVolumeOverrideByServerId(tgtId, enabled and volume or -1.0)
end

function playerTargets(...)
	local targets = {...}

	MumbleClearVoiceTargetPlayers(voiceTarget)

	for i = 1, #targets do
		for id, _ in pairs(targets[i]) do
			MumbleAddVoiceTargetPlayerByServerId(voiceTarget, id)
		end
	end
end

function playMicClicks(clickType)
	if Cfg.micClicks then
		SendNUIMessage({
			sound = (clickType and "audio_on" or "audio_off"),
			volume = (clickType and (volume) or 0.05)
		})
	end
end

local playerMuted = false

RegisterCommand('cycleproximity', function()
	if not playerMuted then
		local voiceMode = voiceData.mode
		local newMode = voiceMode + 1

		voiceMode = (newMode <= #Cfg.voiceModes and newMode) or 1
		MumbleSetAudioInputDistance(Cfg.voiceModes[voiceMode][1] + 0.0)
		voiceData.mode = voiceMode
		-- make sure we update the UI to the latest voice mode
		SendNUIMessage({
			voiceMode = voiceMode - 1
		})
		TriggerEvent('pma-voice:setTalkingMode', voiceMode)
	end
end)

RegisterKeyMapping('cycleproximity', 'Cycle Proximity', 'keyboard', 'g')

RegisterNetEvent('pma-voice:mutePlayer')
AddEventHandler('pma-voice:mutePlayer', function()
	playerMuted = not playerMuted
	if playerMuted then
		MumbleSetAudioInputDistance(0.1)
	else
		MumbleSetAudioInputDistance(Cfg.voiceModes[voiceData.mode][1])
	end
end)

function setVoiceProperty(type, value)
	if type == "radioEnabled" then
		Cfg.radioEnabled = value
		SendNUIMessage({
			radioEnabled = value
		})
	elseif type == "micClicks" then
		Cfg.micClicks = value
	end
end
exports('setVoiceProperty', setVoiceProperty)

local function getGridZone()
	local plyPos = GetEntityCoords(PlayerPedId(), false)
	return 31 + (voiceData.routingBucket * 5) + math.ceil((plyPos.x + plyPos.y) / (128 * 2))
end

local function updateZone(force)
	local newGrid = getGridZone()

	if newGrid ~= currentGrid or force then
		currentGrid = newGrid
		MumbleClearVoiceTargetChannels(voiceTarget)
		NetworkSetVoiceChannel(currentGrid)
		-- add nearby grids to voice targets
		for nearbyGrids = currentGrid - 3, currentGrid + 3 do
			MumbleAddVoiceTargetChannel(voiceTarget, nearbyGrids)
		end
	end
end

Citizen.CreateThread(function()
	while not intialized do Wait(100) end

	while true do
		Wait(150)

		while not MumbleIsConnected() do
			currentGrid = -1 -- reset the grid to something out of bounds so it will resync their zone on disconnect.
			Wait(100)
		end

		updateZone()

		SendNUIMessage({
			usingRadio = Cfg.radioPressed,
			talking = NetworkIsPlayerTalking(PlayerId()) == 1
		})

		handleZoneOverride()
	end
end)

function handleZoneOverride()
	if voiceData.mode ~= 1 then
		local playerPed = PlayerPedId()
		local interiorId = GetInteriorFromEntity(playerPed)
		local enforceWhisper = false

		if interiorId == 519169 and IsValidInterior(interiorId) then -- Vesp
			local roomHash = GetRoomKeyFromEntity(playerPed)
			local roomId = GetInteriorRoomIndexByHash(interiorId, roomHash)
			if roomId == 8 then
				enforceWhisper = true
			end
		elseif interiorId == 512001 and IsValidInterior(interiorId) then -- MRPD
			local roomHash = GetRoomKeyFromEntity(playerPed)
			local roomId = GetInteriorRoomIndexByHash(interiorId, roomHash)
			if (roomId == 21 or roomId == 20 or roomId == 23 or roomId == 9 or roomId == 8 or roomId == 24) then
				enforceWhisper = true
			end
		elseif interiorId == 121090 and IsValidInterior(interiorId) then -- Pillbox
			local roomHash = GetRoomKeyFromEntity(playerPed)
			local roomId = GetInteriorRoomIndexByHash(interiorId, roomHash)
			if (roomId == 1 or roomId == 2 or roomId == 8 or roomId == 12 or roomId == 11 or roomId == 7 or roomId == 14 or roomId == 24 or roomId == 3) then	
				enforceWhisper = true
			end
		elseif interiorId == 158210 and IsValidInterior(interiorId) then -- Prison
			local roomHash = GetRoomKeyFromEntity(playerPed)
			local roomId = GetInteriorRoomIndexByHash(interiorId, roomHash)
			if (roomId == 6 or roomId == 1 or roomId == 2) then
				enforceWhisper = true
			end
		end

		if enforceWhisper then
			MumbleSetAudioInputDistance(Cfg.voiceModes[1][1])
			voiceData.mode = 1
			SendNUIMessage({voiceMode = 0})
			TriggerEvent('pma-voice:setTalkingMode', 1)
		end
	end
end

AddEventHandler('onClientResourceStart', function(resource)
	if resource ~= GetCurrentResourceName() then return end

	while not NetworkIsSessionStarted() do
		Wait(10)
	end

	TriggerServerEvent('pma-voice:registerVoiceInfo')

	-- this sets how far the player can hear.
	MumbleSetAudioOutputDistance(Cfg.voiceModes[#Cfg.voiceModes][1] + 0.0)

	while not MumbleIsConnected() do
		Wait(250)
	end

	MumbleSetVoiceTarget(0)
	MumbleClearVoiceTarget(voiceTarget)
	MumbleSetVoiceTarget(voiceTarget)
	MumbleSetAudioInputDistance(Cfg.voiceModes[voiceData.mode][1] + 0.0)

	updateZone()
	intialized = true

	-- not waiting right here (in testing) let to some cases of the UI
	-- just not working at all.
	Wait(1000)
	SendNUIMessage({
		voiceModes = json.encode(Cfg.voiceModes),
		voiceMode = voiceData.mode - 1,
		playerId = playerServerId,
		radioChannelOverrides = json.encode(Cfg.radioChannelOverrides)
	})
end)