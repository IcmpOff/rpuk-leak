RegisterNetEvent('rpuk_factions:performTreatment')
AddEventHandler('rpuk_factions:performTreatment', function(type)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	local closestPlayerPed = GetPlayerPed(closestPlayer)
	local data = anim_state(closestPlayer)
	type = type[1]

	if closestPlayer == -1 or closestDistance > 2.0 then
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'No players need treatment near you!' })
	else
		if type == "revive" then
			TriggerEvent("mythic_progbar:client:progress", {
				name = "revive",
				duration = 7000,
				label = "Performing CPR",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "mini@cpr@char_a@cpr_str",
					anim = "cpr_pumpchest",
				},
			},
			function(cancel)
				if not cancel then
					if isInList(ESX.Player.GetJobName(), Config.AccessToPerformMedicalActions) then
						if math.random(100) > 20 then
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "defib", 0.3)
							TriggerServerEvent('rpuk_health:reviveTarget', GetPlayerServerId(closestPlayer), "civ")
							TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'success', text = "You have successfully completed CPR"})
						else
							TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "Unlucky Doctor! Patient hasn't responded to the treatment! Try again..."})
						end
					else
						if ESX.Player.GetInventory().defib and ESX.Player.GetInventory().defib.count > 0 then
							TriggerServerEvent("removeItem", "defib")
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 8, "defib", 0.3)
							TriggerServerEvent('rpuk_health:reviveTarget', GetPlayerServerId(closestPlayer), "civ")
							TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'success', text = "You have successfully completed CPR"})
						else
							TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'error', text = 'You need the defibrillator to revive this person!' })
						end
					end
				elseif cancel then
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped CPR!' })
				end
			end)
		elseif type == "reviveTreatment" then
			TriggerEvent("mythic_progbar:client:progress", {
				name = "revive",
				duration = 7000,
				label = "Assisting Patient",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "amb@medic@standing@tendtodead@idle_a",
					anim = "idle_a",
					flags = 49,
					task = nil,
				},
			},
			function(cancel)
				if not cancel then
					if math.random(100) > 20 then
						TriggerServerEvent('rpuk_health:reviveTarget', GetPlayerServerId(closestPlayer), "civ")
						TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'success', text = "You have successfully completed CPR"})
					else
						TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "Unlucky Doctor! Patient hasn't responded to the treatment! Try again..."})
					end
				elseif cancel then
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped CPR!' })
				end
			end)
		elseif type == "respawn" then
			if data[6] or data[7] then
				TriggerEvent("mythic_progbar:client:progress", {
					name = "revive",
					duration = 7000,
					label = "Checking Final Pulse",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = "amb@medic@standing@tendtodead@idle_a",
						anim = "idle_a",
						flags = 49,
						task = nil,
						},
				},
				function(cancel)
					if not cancel then
						TriggerServerEvent("rpuk_health:respawn", GetPlayerServerId(closestPlayer))
					elseif cancel then
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped claiming DNR!' })
					end
				end)
			end
		elseif type == "npcCallOut" then
			if data[6] or data[7] then
				TriggerEvent("mythic_progbar:client:progress", {
					name = "revive",
					duration = 7000,
					label = "Sending to Local Hospital",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = "amb@medic@standing@tendtodead@idle_a",
						anim = "idle_a",
						flags = 49,
						task = nil,
						},
				},
				function(cancel)
					if not cancel then
						local hosptial = getClosestHospital(GetEntityCoords(PlayerPedId()))
						if closestPlayer ~= -1 and closestDistance < 2.0 then
							TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'You have sent the Patient to '.. hosptial ..' hospital!'})
							TriggerServerEvent("rpuk_factions:sendToNpcVehicle", GetPlayerServerId(closestPlayer), hosptial)
						end
					elseif cancel then
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped claiming DNR!' })
					end
				end)
			end
		elseif type == "releaseFromBed" then
			if data[6] or data[7] then
				TriggerEvent("mythic_progbar:client:progress", {
					name = "revive",
					duration = 7000,
					label = "Removing patient from bed",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = "amb@medic@standing@tendtodead@idle_a",
						anim = "idle_a",
						flags = 49,
						task = nil,
					},
				},
				function(cancel)
					if not cancel then
						if closestPlayer ~= -1 and closestDistance < 2.0 then
							TriggerServerEvent("rpuk_health:takePatientOffBed", GetPlayerServerId(closestPlayer))
						end
					elseif cancel then
						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped cleaning up the bed!' })
					end
				end)
			end
		elseif type == "bandage" then
			TriggerEvent("mythic_progbar:client:progress", {
				name = "bandage",
				duration = 7000,
				label = "Applying Bandage",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "amb@medic@standing@tendtodead@idle_a",
					anim = "idle_a",
					flags = 49,
					task = nil,
				},
			},
			function(cancel)
				if not cancel then
					TriggerServerEvent("rpuk_health:treatTarget", GetPlayerServerId(closestPlayer), "bandage")
				elseif cancel then
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped CPR!' })
				end
			end)
		elseif type == "medicine" then
			TriggerEvent("mythic_progbar:client:progress", {
				name = "medicine",
				duration = 7000,
				label = "Giving Medicine",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "amb@medic@standing@tendtodead@idle_a",
					anim = "idle_a",
					flags = 49,
					task = nil,
				},
			},
			function(cancel)
				if not cancel then
					TriggerServerEvent("rpuk_health:treatTarget", GetPlayerServerId(closestPlayer), "medicine")
				elseif cancel then
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped CPR!' })
				end
			end)
		elseif type == "issues" then
			TriggerEvent("mythic_progbar:client:progress", {
				name = "checking",
				duration = 5000,
				label = "Checking Patient",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "amb@medic@standing@tendtodead@idle_a",
					anim = "idle_a",
					flags = 49,
					task = nil,
				},
			},
			function(status)
				if not status then
					ESX.TriggerServerCallback("rpuk_health:getInjury", function(_rawDeathCause)
						local hit, bone = GetPedLastDamageBone(closestPlayerPed)
						local deathCause
						local message
						local color
						local pulse = math.random(60, 100)

						if _rawDeathCause then
							deathCause = _rawDeathCause

							if hashDeathToText[tostring(deathCause)] then
								deathCause = hashDeathToText[tostring(deathCause)]
								TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'inform', text = "It seems they sustained injuries from a " .. deathCause})
							else
								TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'inform', text = 'It seems they were injured from unknown causes' })
							end
						end

						if bonesList[bone] == "torso" then
							if deathCause then
								color = triageLevel[deathCause].torso
							end
							TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'inform', text = 'Injury to torso area.' })
						elseif bonesList[bone] == "head" then
							if deathCause then
								color = triageLevel[deathCause].head
							end
							TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'inform', text = 'Injury to head area.' })
						elseif bonesList[bone] == "arms" then
							if deathCause then
								color = triageLevel[deathCause].arms
							end
							TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'inform', text = 'Injury to arms area.' })
						elseif bonesList[bone] == "legs" then
							if deathCause then
								color = triageLevel[deathCause].legs
							end
							TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'inform', text = 'Injury to legs area.' })
						else
							if deathCause then
								color = triageLevel[deathCause].nobone
							else
								color = "yellow"
							end
							TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'inform', text = 'Injury to body.' })
						end
						if color ~= nil then
							if color == "green" then
								message = 'Triage Card: Green (MINOR)'
								pulse = math.random(60, 120)
							elseif color == "yellow" then
								message = 'Triage Card: Yellow (DELAYED)'
								pulse = math.random(70, 150)
							elseif color == "red" then
								pulse = math.random(80, 170)
								message = 'Triage Card: Red (IMMEDIATE)'
							elseif color == "black" then
								message = 'Triage Card: Black (DECEASED)'
								pulse = math.random(10, 60)
							end
						else
							pulse = math.random(10, 170)
							message = 'Triage Card: Yellow (DELAYED)'
						end
						TriggerEvent('mythic_notify:client:SendAlert', {
							length = 9000,
							type = 'inform',
							text = message
						})
						TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'inform', text = 'Pulse is currently '.. pulse ..'BPM'})
					end, GetPlayerServerId(closestPlayer))
				end
			end)
		end
	end
end)

RegisterNetEvent('rpuk_factions:treatmentType')
AddEventHandler('rpuk_factions:treatmentType', function(healType)
	local playerPed = PlayerPedId()
	if healType == 'bandage' then
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Bandage is now applied!' })
		sethealthFull()
		ClearPedLastDamageBone(playerPed)
	elseif healType == 'medicine' then
		TriggerEvent('esx_basicneeds:healPlayer', playerPed)
		TriggerEvent("rpuk_weather:isBlurry", false)
	end
end)

function getClosestHospital(coords)
	for k,v in ESX.Table.Sort(Config.teleportToHospital, function(t, a, b)
		a = t[a]
		b = t[b]

		local distanceA = #(coords - a)
		local distanceB = #(coords - b)

		if distanceA < distanceB then
			return true
		elseif distanceB < distanceA then
			return false
		end
	end) do
		return k
	end
end


RegisterNetEvent('rpuk_factions:teleportToHospital')
AddEventHandler('rpuk_factions:teleportToHospital', function(hosptial)
	local playerPed = PlayerPedId()
	local coords = Config.teleportToHospital[hosptial]
	TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'You have been dropped off by the local ambulance crew. Please wait for medical staff!' })
	DoScreenFadeOut(2000)
	Citizen.Wait(2000)
	local timeout = 0
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	NewLoadSceneStart(coords.x, coords.y, coords.x, coords.y, coords.z, 50.0, 0)
	while not HasCollisionLoadedAroundEntity(playerPed) and timeout < 1000 do
		Citizen.Wait(0)
		timeout = timeout + 1
	end
	timeout = 0
	while IsNetworkLoadingScene() and timeout < 1000 do
		Citizen.Wait(0)
		timeout = timeout + 1
	end
	SetEntityCoords(playerPed, coords)
	Citizen.Wait(1000)
	DoScreenFadeIn(2000)
end)
