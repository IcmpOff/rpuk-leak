local sirenStates = {}
local lightStates = {}

AddEventHandler('playerSpawned', function()
	SetVisualSettingFloat("car.defaultlight.night.emissive.on", 11.0 * 100.0)
	SetVisualSettingFloat("car.defaultlight.day.emissive.on", 17.0 * 100.0)
end)

function CleanupStates()
	for k, v in pairs(sirenStates) do
		if not DoesEntityExist(v['vehicle']) then
			local soundId = v['soundId']
			StopSound(soundId)
			ReleaseSoundId(soundId)

			sirenStates[k] = nil
		end
	end

	for k, v in pairs(lightStates) do
		if not DoesEntityExist(v['vehicle']) then
			lightStates[k] = nil
		end
	end
end

function GetLightStage(time, vehicle, mode, lightState, lightsValue)
	-- Reset the index if the light pattern has changed
	if lightState['lastPattern'] ~= lightsValue then
		lightState['patternStage'] = 1
		lightState['lastPattern'] = lightsValue
	end

	local pattern = config_modes[mode][lightsValue]
	local stage = pattern[lightState['patternStage']]

	local changed = false

	if time > lightState['lastSwitch'] + stage[2] then
		if lightState['patternStage'] == #pattern then
			lightState['patternStage'] = 1
		else
			lightState['patternStage'] = lightState['patternStage'] + 1
		end

		lightState['lastSwitch'] = time
		stage = pattern[lightState['patternStage']]
		changed = true
	end

	return stage, changed
end

Citizen.CreateThread(function()
	local on = false
	local time = GetGameTimer()

	local nearbyVehiclesUpdateTime = -VEHICLES_IN_ZONE_UPDATE_PERIOD
	local nearbyVehicles = {}
	while true do
		local playerPed = PlayerPedId()
		local time = GetGameTimer()

		if time >= nearbyVehiclesUpdateTime + VEHICLES_IN_ZONE_UPDATE_PERIOD then
			nearbyVehicles = GetGamePool('CVehicle')
			nearbyVehiclesUpdateTime = time

			CleanupStates()
		end

		for _, vehicle in pairs(nearbyVehicles) do
			local plate = GetVehicleNumberPlateText(vehicle)
			local primaryLightsValue = DecorGetInt(vehicle, "rpuk_sirens:lightsPrimary")
			local secondaryLightsValue = DecorGetInt(vehicle, "rpuk_sirens:lightsSecondary")
			local sirenValue = DecorGetInt(vehicle, "rpuk_sirens:sirenState")

			if primaryLightsValue ~= 0 or secondaryLightsValue ~= 0 then
				local lightState = lightStates[plate]
				if lightState == nil then
					SetVehicleHasMutedSirens(vehicle, true) --Added because otherwise clients get small blips on sirens just when lights are on
					lightStates[plate] = {
						vehicle = vehicle,
						primary = {
							lastPattern = 1,
							patternStage = 1,
							lastSwitch = time
						},
						secondary = {
							lastPattern = 1,
							patternStage = 1,
							lastSwitch = time
						},
						envLights = {}
					}

					lightState = lightStates[plate]
				end

				local primaryStage, primaryChanged = nil
				if primaryLightsValue ~= 0 then
					primaryStage, primaryChanged = GetLightStage(time, vehicle, "primary", lightState["primary"], primaryLightsValue)
				end

				local secondaryStage, secondaryChanged = nil
				if secondaryLightsValue ~= 0 then
					secondaryStage, secondaryChanged = GetLightStage(time, vehicle, "secondary", lightState["secondary"], secondaryLightsValue)
				end

				if primaryChanged or secondaryChanged then
					local envLights = lightState["envLights"]

					for i, _ in pairs(envLights) do
						envLights[i] = nil
					end

					local config = config_sirenDefinitions[GetEntityModel(vehicle)]

					if config ~= nil then
						for idx, val in pairs(config['extras']) do
							if val["els"] then
								local on = (primaryStage ~= nil and primaryStage[1][idx]) or (secondaryStage ~= nil and secondaryStage[1][idx])
								SetVehicleExtra(vehicle, idx, not on)

								if on and val["envLight"] and idx == 1 then
									if GetIsVehicleEngineRunning(vehicle) then
										envLights[val["color"]] = true
									end
								end
							end
						end
					end
				end

				for k, _ in pairs(lightState["envLights"]) do
					local color = config_colors[k]
					DrawLightWithRangeAndShadow(GetEntityCoords(vehicle), color[1], color[2], color[3], 50.0, 0.04, 5.0)
				end
			end

			if (primaryLightsValue == 0 and secondaryLightsValue == 0) and lightStates[plate] ~= nil then
				local config = config_sirenDefinitions[GetEntityModel(vehicle)]

				if config ~= nil then
					-- Turn off the lights
					for idx, val in pairs(config['extras']) do
						if val["els"] then
							SetVehicleExtra(vehicle, idx, true)
						end
					end
				end

				lightStates[plate] = nil
			end

			if sirenValue ~= 0 and sirenStates[plate] == nil then
				local soundId = GetSoundId()
				sirenStates[plate] = { vehicle = vehicle, soundId = soundId, lastSiren = sirenValue }
				local sirenToPlay = intToSirenName(sirenValue)
				PlaySoundFromEntity(soundId, sirenToPlay, vehicle, "DLC_WMSIRENS_SOUNDSET", 0, 0)
			end

			if sirenValue == 0 and sirenStates[plate] ~= nil then
				local soundId = sirenStates[plate]['soundId']
				StopSound(soundId)
				ReleaseSoundId(soundId)

				sirenStates[plate] = nil
			end

			if (sirenValue ~= 0 and (sirenStates[plate]['lastSiren'] ~= sirenValue)) then
				local soundId = sirenStates[plate]['soundId']
				StopSound(soundId)
				ReleaseSoundId(soundId)
				local soundId = GetSoundId()
				sirenStates[plate] = { vehicle = vehicle, soundId = soundId, lastSiren = sirenValue }
				local sirenToPlay = intToSirenName(sirenValue)
				PlaySoundFromEntity(soundId, sirenToPlay, vehicle, "DLC_WMSIRENS_SOUNDSET", 0, 0)
			end
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do
		Citizen.Wait(0)
	end

	SetVisualSettingFloat("car.defaultlight.night.emissive.on", 11.0 * 100.0)
	SetVisualSettingFloat("car.defaultlight.day.emissive.on", 17.0 * 100.0)
	RequestScriptAudioBank("DLC_WMSIRENS\\SIRENPACK_ONE", false)
	DecorRegister("rpuk_sirens:lightsPrimary", 3)
	DecorRegister("rpuk_sirens:lightsSecondary", 3)
	DecorRegister("rpuk_sirens:sirenState", 3)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local config = config_sirenDefinitions[GetEntityModel(vehicle)]
		DistantCopCarSirens(false)

		if config then
			DisableControlAction(0, 44, true) --Q
			DisableControlAction(0, 19, true) --Alt
			DisableControlAction(0, 21, true) --Left shift
			DisableControlAction(0, 157, true) --1
			DisableControlAction(0, 158, true) --2
			DisableControlAction(0, 160, true) --3
			DisableControlAction(0, 164, true) --4
			SetVehRadioStation(vehicle, "OFF")
			SetVehicleRadioEnabled(vehicle, false)

			local shift = false
			if IsDisabledControlPressed(0, 21) then
				shift = true
			end

			if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then --Check that driver is controling
				--If q is pressed
				if GetLastInputMethod(0) then -- If on keyboard
					if IsDisabledControlJustReleased(0, 44) then
						local lightsValue = DecorGetInt(vehicle, "rpuk_sirens:lightsPrimary")
						local secValue = DecorGetInt(vehicle, "rpuk_sirens:lightsSecondary")

						if lightsValue ~= 0 then
							if shift then
								if secValue ~= 0 then
									TriggerEvent("InteractSound_CL:PlayOnOne", "sirenclickoff", 0.5)
									DecorSetInt(vehicle, "rpuk_sirens:lightsSecondary", 0)
								else
									TriggerEvent("InteractSound_CL:PlayOnOne", "sirenclick", 0.5)
									DecorSetInt(vehicle, "rpuk_sirens:lightsSecondary", 1)
								end
							else
								TriggerEvent("InteractSound_CL:PlayOnOne", "sirenclickoff", 0.5)
								DecorSetInt(vehicle, "rpuk_sirens:lightsPrimary", 0)
								DecorSetInt(vehicle, "rpuk_sirens:lightsSecondary", 0)
								DecorSetInt(vehicle, "rpuk_sirens:sirenState", 0)
								SetVehicleSiren(vehicle, false)
							end
						else
							TriggerEvent("InteractSound_CL:PlayOnOne", "sirenclick", 0.5)
							DecorSetInt(vehicle, "rpuk_sirens:lightsPrimary", 1)
							SetVehicleHasMutedSirens(vehicle, true)
							SetVehicleSiren(vehicle, true)
						end
					end

					if not config.sirenDisallow then
						--If alt is pressed
						if IsDisabledControlJustReleased(0, 19) then
							toggleSirenValue(vehicle)
						end

						--If siren 1 is pressed
						if IsDisabledControlJustReleased(0, 157) then
							toggleSirenValue(vehicle, 1)
						end

						--If siren 2 is pressed
						if IsDisabledControlJustReleased(0, 158) then
							toggleSirenValue(vehicle, 2)
						end

						--If siren 3 is pressed
						if IsDisabledControlJustReleased(0, 160) then
							toggleSirenValue(vehicle, 3)
						end

						--If siren 4 is pressed
						if IsDisabledControlJustReleased(0, 164) then
							toggleSirenValue(vehicle, 4)
						end
					end
				end
			end
		end
	end
end)

--This function is called when siren changes are made from alt or the numbers
function toggleSirenValue(vehicle, sirenStage)
	local sirenValue = DecorGetInt(vehicle, "rpuk_sirens:sirenState")
	local lightsValue = DecorGetInt(vehicle, "rpuk_sirens:lightsPrimary")

	if lightsValue ~= 0 then
		if not sirenStage then
			if sirenValue ~= 0 then
				DecorSetInt(vehicle, "rpuk_sirens:sirenState", 0)
			else
				DecorSetInt(vehicle, "rpuk_sirens:sirenState", 1)
			end
		else
			if sirenValue ~= sirenStage then
				DecorSetInt(vehicle, "rpuk_sirens:sirenState", sirenStage)
			end
		end

		Wait(100)
		SoundVehicleHornThisFrame(vehicle)
		Wait(100)
		SoundVehicleHornThisFrame(vehicle)
	end
end

function intToSirenName(int)
	local names = { "SIREN_ALPHA", "SIREN_BRAVO", "SIREN_CHARLIE", "SIREN_DELTA", "SIREN_ECHO", "SIREN_FOXTROT", "SIREN_GOLF", "SIREN_HOTEL" }
	return names[int]
end