local slotMachines = {}

---
--- SECTION: Scaleforms
---

-- Attaches the scaleform to the slot machine
function AttachScaleformToSlotMachine(scaleform, theme)
	local machine = "vw_Prop_Casino_Slot_0"..theme.."a"
	local machineModelHash = GetHashKey(machine)
	local renderTargetName = "machine_0"..theme.."a"

	-- Scaleform must have loaded before we can attach it
	if not HasScaleformMovieLoaded(scaleform) then
		return -255
	end

	-- If the render target is not registered, register it
	if not IsNamedRendertargetRegistered(renderTargetName) then
		RegisterNamedRendertarget(renderTargetName, 0)
	end


	-- If the render target isn't linked, then link it to the machine
	if not IsNamedRendertargetLinked(machineModelHash) then
		LinkNamedRendertarget(machineModelHash)
	end

	-- Return the render target ID
	return GetNamedRendertargetRenderId(renderTargetName)
end

-- Remove named render target for slot machine
function DetachScaleformFromSlotMachine(scaleform, theme)
	local machine = "vw_Prop_Casino_Slot_0"..theme.."a"
	local machineModelHash = GetHashKey(machine)
	local renderTargetName = "machine_0"..theme.."a"

	if not IsNamedRendertargetRegistered(renderTargetName) then
		return
	end

	ReleaseNamedRendertarget(renderTargetName)
end

-- Sets the scaleform theme to the given slot theme
function SetSlotScaleformTheme(scaleform, themeNumber)
	local scaleformThemeNumber = SLOT_THEME_TO_SCALEFORM_THEME[themeNumber]

	BeginScaleformMovieMethod(scaleform, "SET_THEME")
	ScaleformMovieMethodAddParamInt(scaleformThemeNumber)
	EndScaleformMovieMethod()
end

-- Set the last win value
function SetLastWinValue(scaleform, lastWinValue)
	BeginScaleformMovieMethod(scaleform, "SET_LAST_WIN")
	ScaleformMovieMethodAddParamInt(lastWinValue)
	EndScaleformMovieMethod()
end

-- Set the bet value
function SetBetValue(scaleform, value)
	BeginScaleformMovieMethod(scaleform, "SET_BET")
	ScaleformMovieMethodAddParamInt(value)
	EndScaleformMovieMethod()
end

-- Set the message on the slot machine scaleform
function SetScaleformMessage(scaleform, message)
	BeginScaleformMovieMethod(scaleform, "SET_MESSAGE")
	BeginTextCommandScaleformString(message)
	EndTextCommandScaleformString()
	EndScaleformMovieMethod()
end

-- Generate a random message and set it on the slot machine scaleform
function SetRandomScaleformMessage(scaleform, machine, isWin)
	local selectedMessage = "SLOTS_MES"

	if isWin then
		selectedMessage = selectedMessage.."P"
	else
		selectedMessage = selectedMessage.."N"
	end

	selectedMessage = selectedMessage..machine['theme']

	local messageNumber = math.random(1, 16)
	if messageNumber < 10 then
		selectedMessage = selectedMessage.."0"
	end

	selectedMessage = selectedMessage..messageNumber

	SetScaleformMessage(scaleform, selectedMessage)
end

function LoadTextureDictionary(machine)
	-- Load the texture dictionary for the machine
	local textureDict = SLOT_THEME_TO_TEXTURE_DICT[machine['theme']]
	RequestStreamedTextureDict(textureDict, false)
	while not HasStreamedTextureDictLoaded(textureDict) do
		Citizen.Wait(100)
	end
end

function UnloadTextureDictionary(machine)
	local textureDict = SLOT_THEME_TO_TEXTURE_DICT[machine['theme']]
	SetStreamedTextureDictAsNoLongerNeeded(textureDict)
end

---
--- SECTION: ANIMATIONS
---

-- Get either the male or female anim dict based on the character
function GetPlayerSlotAnimation()
	if IsPedMale(GetPlayerPed()) then
		return "anim_casino_a@amb@casino@games@slots@male"
	end

	return "anim_casino_a@amb@casino@games@slots@female"
end

-- Request and wait for the animations to load
function LoadAnimations()
	local animDict = GetPlayerSlotAnimation()

	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(0)
	end
end

-- Unload the slot machine animations from memory
function UnloadAnimations()
	local animDict = GetPlayerSlotAnimation()

	RemoveAnimDict(animDict)
end

-- func_173
local _ANIM_LAST_4 = -1
local _ANIM_LAST_10 = -1
function GetAnimationSuffixRandom(mode, max, min)
	local generatedValue = 0

	if max > 1 then
		generatedValue = GetRandomIntInRange(min, max)

		-- Get the last generated value for these modes
		local lastGeneratedValue
		if mode == 4 then
			lastGeneratedValue = _ANIM_LAST_4
		elseif mode == 10 then
			lastGeneratedValue = _ANIM_LAST_10
		end

		if lastGeneratedValue and lastGeneratedValue == generatedValue then
			generatedValue = generatedValue + 1

			if generatedValue >= max then
				generatedValue = 0
			end
		end
	end

	if mode == 4 then
		_ANIM_LAST_4 = generatedValue
	elseif mode == 10 then
		_ANIM_LAST_10 = generatedValue
	end

	local t = {"a", "b", "c", "d", "e", "f", "g"}

	return "_" .. t[generatedValue + 1]
end

function GetSitDownAnimation(machine)
	maxDistance = 100.0

	selectedAnimation = 0

	local coords = GetEntityCoords(PlayerPedId())

	for animation=0,4 do
		local startPos = GetAnimationStartPosition(machine, SLOT_ENTER_ANIMS[animation + 1])

		local distance = GetDistanceBetweenCoords(coords, startPos, true)
		if distance < maxDistance then
			maxDistance = distance
			selectedAnimation = animation
		end
	end

	return selectedAnimation
end

function PlayAnimation(machine, animationNumber, waitUntilPhase)

	local animationName
	local useOcclusionPortal = 1
	local looped = 0

	local blendInSpeed = 2.0
	local blendOutSpeed = -1.5
	local playbackRate = 1148846080


	if animationNumber <= 3 then
		-- Enter animations
		animationName = SLOT_ENTER_ANIMS[animationNumber + 1]

		playbackRate = 2.0
	elseif animationNumber == 4 then
		-- Idle animations
		animationName = "base_idle"

		-- If in first person
		if Citizen.InvokeNative(0xEE778F8C7E1142E2, 0) == 4 then
			animationName = animationName..GetAnimationSuffixRandom(4, 1, 0)
		else
			animationName = animationName..GetAnimationSuffixRandom(4, 5, 0)
		end
	elseif animationNumber == 5 then
		-- Bet one
		animationName = "press_betone_a"
		blendInSpeed = 4.0
		blendOutSpeed = -8.0
	elseif animationNumber == 6 then
		-- Bet max
		animationName = "press_betmax_a"
		blendInSpeed = 4.0
		blendOutSpeed = -8.0
	elseif animationNumber == 7 then
		-- Autospin
		animationName = "press_autospin"
	elseif animationNumber == 8 then
		-- Spin
		animationName = "press_spin"..GetAnimationSuffixRandom(8, 2, 0)
		blendInSpeed = 8.0
		blendOutSpeed = -4.0
	elseif animationNumber == 9 then
		animationName = "pull_spin"..GetAnimationSuffixRandom(8, 2, 0)
	elseif animationNumber == 10 then
		animationName = "betidle_idle"

		-- If in first person
		if Citizen.InvokeNative(0xEE778F8C7E1142E2, 0) == 4 then
			animationName = animationName..GetAnimationSuffixRandom(10, 1, 0)
		else
			animationName = animationName..GetAnimationSuffixRandom(10, 3, 0)
		end
	elseif animationNumber == 11 then
		animationName = "betidle_press_betone"..GetAnimationSuffixRandom(11, 3, 0)
		blendInSpeed = 8.0
		blendOutSpeed = -8.0
	elseif animationNumber == 12 then
		animationName = "betidle_press_betmax"..GetAnimationSuffixRandom(12, 3, 0)
		blendInSpeed = 8.0
		blendOutSpeed = -8.0
	elseif animationNumber == 13 then
		animationName = "betidle_press_autospin"
	elseif animationNumber == 14 then
		animationName = "betidle_press_spin"..GetAnimationSuffixRandom(14, 3, 0)
		blendInSpeed = 8.0
		blendOutSpeed = -4.0
	elseif animationNumber == 15 then
		animationName = "betidle_pull_spin"..GetAnimationSuffixRandom(15, 2, 0)
	elseif animationNumber == 16 then
		animationName = "betidle_to_base_transition"
	elseif animationNumber == 17 then
		animationName = "spinning"..GetAnimationSuffixRandom(17, 3, 0)
		useOcclusionPortal = 0
		looped = 1
	elseif animationNumber == 18 then
		-- In the base script, 4-0 is used if it is a jackpot, else 7-4
		animationName = "win"..GetAnimationSuffixRandom(18, 7, 0)
	elseif animationNumber == 19 then
		animationName = "win_big"..GetAnimationSuffixRandom(19, 3, 0)
	elseif animationNumber == 20 then
		animationName = "win_to_spinning_wheel"
	elseif animationNumber == 21 then
		animationName = "spinning_wheel"
		useOcclusionPortal = 0
		looped = 1
	elseif animationNumber == 22 then
		animationName = "win_spinning_wheel"
	elseif animationNumber == 23 then
		animationName = "lose"

		if GetRandomIntInRange(0, 10) >= 9 then
			animationName = animationName..GetAnimationSuffixRandom(23, 6, 3)
		else
			animationName = animationName..GetAnimationSuffixRandom(23, 3, 0)
		end
	elseif animationNumber == 24 then
		animationName = "lose_cruel"..GetAnimationSuffixRandom(24, 2, 0)
	elseif animationNumber == 25 then
		animationName = "exit_left"
		useOcclusionPortal = 0
		looped = 0
	elseif animationNumber == 26 then
		animationName = "betidle_left"
		useOcclusionPortal = 0
		looped = 0
	elseif animationNumber == 27 then
		animationName = "exit_right"
		useOcclusionPortal = 0
		looped = 0
	elseif animationNumber == 28 then
		animationName = "betidle_right"
		useOcclusionPortal = 0
		looped = 0
	end

	-- Make the player sit in the chair for the machine
	local animDict = GetPlayerSlotAnimation()
	local netScene = NetworkCreateSynchronisedScene(
		machine['position'][1], machine['position'][2], machine['position'][3],
		0.0, 0.0, machine['heading'],
		2, useOcclusionPortal, looped, 1065353216, 0, 1065353216
	)

	NetworkAddPedToSynchronisedScene(
		PlayerPedId(), netScene, animDict, animationName, blendInSpeed, blendOutSpeed, 13, 16, playbackRate, 0)

	if animationNumber == 9 or animationNumber == 15 then
		local machineName = "vw_prop_casino_slot_0"..machine['theme'].."a"
		local machineModelHash = GetHashKey(machineName)

		-- Citizen.InvokeNative(0x45F35C0EDC33B03B, netScene, machineModelHash, vector3(machine['position'][1], machine['position'][2], machine['position'][3]), animDict, animationName .. "_SLOTMACHINE", 2.0, -1.5, 13)
		Citizen.InvokeNative(0x45F35C0EDC33B03B, PlayerPedId(), machineModelHash, netScene, animDict, animationName .. "_SLOTMACHINE", 2.0, -1.5, 13)
	end

	NetworkStartSynchronisedScene(netScene)

	Citizen.Wait(1)

	local scene = NetworkConvertSynchronisedSceneToSynchronizedScene(netScene)

	if waitUntilPhase ~= nil then

		local phase = 0
		while phase < waitUntilPhase do
			phase = GetSynchronizedScenePhase(scene)
			Citizen.Wait(50)
		end
	end

	return netScene, scene
end

function GetAnimationStartPosition(slotMachine, animationName)
	local animDict = GetPlayerSlotAnimation()

	return GetAnimInitialOffsetPosition(animDict, animationName,
		slotMachine['position'][1], slotMachine['position'][2], slotMachine['position'][3], 0, 0, slotMachine['heading'], 0.01, 2)
end

---
--- SECTION: Sound Effects
---

function PlaySlotSound(slotmachine, soundEffect)
	local soundpack = SLOT_THEME_TO_SOUNDS[slotmachine['theme']]
	-- PlaySoundFromEntity(-1, "jackpot", PlayerPedId(), "dlc_vw_casino_slot_machine_ir_player_sounds", true, 20)
	-- PlaySoundFromEntity(-1, "Bar_Cut", PlayerPedId(), "FBI_05_SOUNDS", 0, 0)
	-- PlaySoundFromEntity(GetSoundId(), "POLICE_CRASH", PlayerPedId(), "PAPARAZZO_03A", 0, 0)
	-- PlaySoundFrontend(-1, "spin_wheel", "dlc_vw_casino_slot_machine_ak_player_sounds", true)

	-- temporarily overriden
	PlaySoundFromEntity(-1, soundEffect, PlayerPedId(), "dlc_vw_casino_slot_machine_ak_player_sounds", true, 20)
end

---
--- SECTION: POSITIONS
---

-- Find the absolute nearest machine to the player
function FindNearestSlotMachine()
	local coords = GetEntityCoords(PlayerPedId())

	local nearestMachineIdx, foundMachine
	local nearestMachineDistance = 9999999999
	for k,v in pairs(SLOT_MACHINES) do
		machineDistance = GetDistanceBetweenCoords(coords, v['position'][1], v['position'][2], v['position'][3], true)

		if machineDistance < SLOT_ACTIVATION_DISTANCE and nearestMachineDistance > machineDistance then
			nearestMachineDistance = machineDistance
			nearestMachineIdx = k
			foundMachine = true
		end
	end

	return foundMachine, nearestMachineIdx, nearestMachineDistance
end

---
--- SECTION: Reels
---

-- Creates the reels, and returns 6 objects from left to right, first 3 A reel, second 3 B reel
function CreateReels(machine)
	local reels = {}

	-- a reel: static reel
	-- b reel: reel with blur
	local reelTypes = {"a", "b"}
	local reelTypesHashes = {}

	for k, reelType in pairs(reelTypes) do
		local reelName = "vw_prop_casino_slot_0"..machine['theme']..reelType.."_reels"
		local reelHash = GetHashKey(reelName)

		RequestModel(reelHash)
		while not HasModelLoaded(reelHash) do
			Citizen.Wait(100)
		end

		reelTypesHashes[k] = reelHash
	end

	for k,pos in pairs(SLOT_REEL_OFFSETS) do
		local reelSet = {}

		for i, reelTypeHash in pairs(reelTypesHashes) do
			local reelPos = GetObjectOffsetFromCoords(
				machine['position'][1], machine['position'][2], machine['position'][3],
				machine['heading'],
				pos[1], pos[2], pos[3]
			)

			local reel = CreateObject(reelTypeHash, reelPos, false, false, true)
			FreezeEntityPosition(reel, true)
			SetEntityCollision(reel, false, 0)
			SetEntityRotation(reel, 0.0, 0.0, machine['heading'], 2, 1)

			TriggerEvent('rpuk_slots_objmanager:add', reel)

			reelSet[i] = reel
		end

		reels[k] = reelSet
	end

	for _, reelTypeHash in pairs(reelTypesHashes) do
		SetModelAsNoLongerNeeded(reelTypeHash)
	end

	SetMovingReelsActive(reels, false)

	return reels
end

function DeleteReels(reels)
	for k,reelSet in pairs(reels) do
		for _, reel in pairs(reelSet) do
			DeleteObject(reel)
			TriggerEvent('rpuk_slots_objmanager:remove', reel)
		end
	end
end

function SetMovingReelsActive(reels, status)
	local activeIdx
	if status then
		activeIdx = 2
	else
		activeIdx = 1
	end

	for _, reelSet in pairs(reels) do
		SetMovingReelActive(reelSet, status)
	end
end

function SetMovingReelActive(reelSet, status)
	local activeIdx
	if status then
		activeIdx = 2
	else
		activeIdx = 1
	end

	for idx, reel in pairs(reelSet) do
		SetEntityVisible(reel, idx == activeIdx, false)
	end

	if not status then
		SetEntityRotation(reelSet[1], GetEntityRotation(reelSet[2]), 2, 1)
	end
end


---
--- SECTION: MAIN LOGIC
---

-- Main entry to begin sitting at a machine
function StartMachine(machineIdx)
	local machine = SLOT_MACHINES[machineIdx]
	local machineState = slotMachines[machineIdx]

	-- Make sure the reels haven't got the spin blur
	SetMovingReelsActive(machineState['reels'], false)

	-- -- pause!
	while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01", false, -1) do
		Citizen.Wait(1)
	end

	-- Load player animations required to sit at this machine
	LoadAnimations()

	if not IsAudioSceneActive("dlc_vw_casino_slot_machines_playing") then
		StartAudioScene("dlc_vw_casino_slot_machines_playing")
	end

	LoadTextureDictionary(machine)

	-- Load the scaleform for the machine UI
	local scaleform = RequestScaleformMovie("slot_machine")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(100)
	end

	-- Play sit down animation
	local sitDownNetScene = PlayAnimation(machine, GetSitDownAnimation(machine), 0.7)

	-- Initialize the scaleform
	local renderTargetId = AttachScaleformToSlotMachine(scaleform, machine['theme'])
	SetRandomScaleformMessage(scaleform, machine, true)
	SetSlotScaleformTheme(scaleform, machine['theme'])
	SetBetValue(scaleform, 0)
	SetLastWinValue(scaleform, 0)

	-- Play idle animation
	PlayAnimation(machine, 4)

	local buttonScaleform = ESX.Scaleform.PrepareBasicInstructional({{button = {10, 191}, text = "Spin"}, {button = {194}, text = "Exit"}, {button = {22}, text = "Bet One"}, {button = {204}, text = "Bet Max"}})

	local exit = false
	local state = 0

	Citizen.CreateThread(function()
		local betMultiplier = 0
		local sceneIdleAnimation
		local wheelEndPositions
		local wheelsRotationRemaining
		local winningAmount

		local count = 0

		while true do
			Citizen.Wait(0)

			if state == 0 then
				-- Waiting for bet
				-- 10 or 191 Spin
				-- 177 Quit
				-- 22 Bet One
				-- 204 Bet Max

				if IsControlJustReleased(0, 10) or IsControlJustReleased(0, 191) then
					-- Spin
					if betMultiplier == 0 then
						ESX.ShowHelpNotification("You must place a bet to spin!")
					else
						PlayAnimation(machine, 8, 0.15)
						sceneIdleAnimation = nil
						state = 1 -- spin
					end
				elseif IsControlJustReleased(0, 22) then
					-- Bet one
					if betMultiplier < 5 then
						PlayAnimation(machine, 5, 0.2)
						sceneIdleAnimation = nil

						betMultiplier = betMultiplier + 1

						SetBetValue(scaleform, (SLOT_THEME_TO_BET_VALUE[machine['theme']]) * betMultiplier)
					else
						ESX.ShowHelpNotification("You have placed the max bet!")
					end
				elseif IsControlJustReleased(0, 204) then
					-- Bet max
					if betMultiplier ~= 5 then
						PlayAnimation(machine, 6, 0.2)
						sceneIdleAnimation = nil

						betMultiplier = 5

						SetBetValue(scaleform, (SLOT_THEME_TO_BET_VALUE[machine['theme']]) * betMultiplier)
					else
						ESX.ShowHelpNotification("You have placed the max bet!")
					end
				elseif IsControlJustReleased(0, 194) then
					-- Quit
					exit = true
					break
				end
			elseif state == 1 then
				state = 2

				-- Trigger server side spin logic
				ESX.TriggerServerCallback('rpuk_slots:spin', function(canSpin, genWheelEndPositions, genWinningAmount)
					if canSpin then
						state = 3
						wheelEndPositions = genWheelEndPositions
						winningAmount = genWinningAmount
					else
						-- Go to reset state
						state = 7
					end
				end, machine['theme'], betMultiplier)
			elseif state == 2 then
				-- This state is a dummy state while the callback from ESX completes
			elseif state == 3 then
				SetMovingReelsActive(machineState['reels'], true)

				local extraSpins = GetRandomIntInRange(1, 2)

				wheelsRotationRemaining = {}
				for wheelIdx=1,3 do
					-- Calculate desired angle
					local desiredEnd = 360.0 - ((wheelEndPositions[wheelIdx] - 1) * 11.25)
					local currentSpin = GetEntityRotation(machineState['reels'][wheelIdx][2])[1]

					wheelsRotationRemaining[wheelIdx] = ((wheelIdx) * 360.0) + (360.0 - currentSpin) + desiredEnd
				end

				state = 4
			elseif state == 4 then
				local spinRate = (22.5 / 4.0)

				while true do
					Citizen.Wait(10)

					local allZero = true
					for wheelIdx, wheelRotationRemaining in pairs(wheelsRotationRemaining) do
						if wheelRotationRemaining > 0 then
							local currentSpin = GetEntityRotation(machineState['reels'][wheelIdx][2])[1]
							local currentValue = wheelsRotationRemaining[wheelIdx]

							if currentValue > 0 and (currentValue - spinRate) <= 0 then
								SetEntityRotation(machineState['reels'][wheelIdx][2], 360.0 - ((wheelEndPositions[wheelIdx] - 1) * 11.25), 0.0, machine['heading'], 2, 1)

								wheelsRotationRemaining[wheelIdx] = 0
								SetMovingReelActive(machineState['reels'][wheelIdx], false)

								PlaySlotSound(machine, "wheel_stop_clunk")
							else
								SetEntityRotation(machineState['reels'][wheelIdx][2], currentSpin + spinRate, 0.0, machine['heading'], 2, 1)

								wheelsRotationRemaining[wheelIdx] = wheelsRotationRemaining[wheelIdx] - spinRate

								if wheelsRotationRemaining[wheelIdx] > 0 then
									allZero = false
								end
							end
						end
					end

					if allZero then
						state = 5
						break
					end
				end
			elseif state == 5 then
				SetLastWinValue(scaleform, winningAmount)

				-- Disable spin animation
				SetMovingReelsActive(machineState['reels'], false)

				state = 6

				if winningAmount > 0 then
					ESX.TriggerServerCallback('rpuk_slots:redeem', function(success)
						state = 7
						SetRandomScaleformMessage(scaleform, machine, true)
					end)
				else
					state = 7
					SetRandomScaleformMessage(scaleform, machine, false)
				end
			elseif state == 6 then
				-- Dummy state to wait for redeem
			elseif state == 7 then
				-- Reset state. Used after completion or after cancellation by server.
				betMultiplier = 0
				winningAmount = 0
				SetBetValue(scaleform, 0)

				state = 0
			end

			if sceneIdleAnimation == nil or GetSynchronizedScenePhase(sceneIdleAnimation) == 1 then
				_, sceneIdleAnimation = PlayAnimation(machine, 4)
			end
		end
	end)

	while not exit do
		Citizen.Wait(0)

		-- Render controls too in 0 state
		if state == 0 then
			DrawScaleformMovieFullscreen(buttonScaleform, 255, 255, 255, 255, 0)
		end

		Citizen.InvokeNative(0x32F34FF7F617643B, scaleform, 1)
		SetTextRenderId(renderTargetId)
		SetScriptGfxDrawOrder(4)
		SetScriptGfxDrawBehindPausemenu(1)
		DrawScaleformMovie(scaleform, 0.401, 0.09, 0.805, 0.195, 255, 255, 255, 255, 0)
		SetTextRenderId(GetDefaultScriptRendertargetRenderId())
	end

	PlayAnimation(machine, 27)

	UnloadTextureDictionary(machine)

	-- Clean up resources
	if HasScaleformMovieLoaded(scaleform) then
		DetachScaleformFromSlotMachine(scaleform, machine['theme'])
		SetScaleformMovieAsNoLongerNeeded(scaleform)
	end

	if HasScaleformMovieLoaded(buttonScaleform) then
		SetScaleformMovieAsNoLongerNeeded(buttonScaleform)
	end

	if IsAudioSceneActive("dlc_vw_casino_slot_machines_playing") then
		StopAudioScene("dlc_vw_casino_slot_machines_playing")
	end

	UnloadAnimations()

	Citizen.Wait(1)

end

function CreateMachines()
	for machineIdx, machine in pairs(SLOT_MACHINES) do
		slotMachines[machineIdx] = {
			reels = CreateReels(machine)
		}
	end
end

function DeleteMachines()
	for _, slotMachineState in pairs(slotMachines) do
		DeleteReels(slotMachineState['reels'])
	end

	slotMachines = {}
end

local inZone = false
Citizen.CreateThread(function()
	-- Register strings
	for _, data in pairs(STRING_DEFS) do
		AddTextEntry(data[1], data[2])
	end

	local hasCreatedMachines = false

	while true do
		Citizen.Wait(1)

		-- Using the RPUK_Zones to trigger in radius check rpuk_zones (client.lua/227-241)
		if inZone then

			if not hasCreatedMachines then
				CreateMachines()
				hasCreatedMachines = true
			end

			-- Wait for player to be near a slot machine
			foundMachine, nearestMachineIdx = FindNearestSlotMachine()

			if foundMachine then
				local machine = SLOT_MACHINES[nearestMachineIdx]

				ESX.ShowHelpNotification("Press ~INPUT_PICKUP~ to sit at "..SLOT_THEME_TO_NAME[machine['theme']].."!\n~b~[Minimum bet £"..SLOT_THEME_TO_BET_VALUE[machine['theme']].."]~s~")

				if IsControlJustReleased(0, 38) then
					Citizen.Wait(1)
					StartMachine(nearestMachineIdx)
				end
			end
		else
			-- Player is out of range of the casino. Delete the machine related objects if they exist
			if hasCreatedMachines then
				DeleteMachines()
				hasCreatedMachines = false
			end
		end
	end
end)

RegisterNetEvent('rpuk_slots:InZoneRange')
AddEventHandler('rpuk_slots:InZoneRange', function(boolValue)
	inZone = boolValue
end)