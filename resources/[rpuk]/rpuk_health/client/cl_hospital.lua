inbed = false

local deathAnims = {
	[1] = "dead_a",
	[2] = "dead_b",
	[3] = "dead_c",
	[4] = "dead_d",
	[5] = "dead_e",
	[6] = "dead_f",
	[7] = "dead_g",
	[8] = "dead_h",
}

WaitingRoomZones = {
	Pillbox = CircleZone:Create(vector3(318.41, -582.14, 28.88), 88.5, {
		useZ=true,
		--debugPoly=true
	}),
	Sandy = CircleZone:Create(vector3(1837.63, 3685.86, 33.86), 32.5, {
		useZ=true,
		--debugPoly=true
	}),
	Paleto = CircleZone:Create(vector3(-252.93, 6321.13, 32.43), 40.0, {
		useZ=true,
		--debugPoly=true
	}),
}

RegisterNetEvent('rpuk_health:sendPatientToFreeBed')
AddEventHandler('rpuk_health:sendPatientToFreeBed', function(data, reviveTime)
	TriggerEvent("rpuk_restrain:detachDrag")
	TriggerEvent("mythic_progbar:client:progress", {
		name = "checkin",
		duration = 5000,
		label = "Checking In",
		useWhileDead = true,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "missfam4",
			anim = "base",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "p_amb_clipboard_01",
			bone = 36029,
			coords = { x = 0.16, y = 0.08, z = 0.1 },
			rotation = { x = -130.0, y = -50.0, z = 90.0},
		}
	}, function(status)
		if not status then
			sendPatientToBed(data, reviveTime)
			TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "patientInBed", extraNotes = "A Patient has been admitted to "..data.label})
		end
	end)
end)

RegisterNetEvent('rpuk_health:takeOffMedicalList')
AddEventHandler('rpuk_health:takeOffMedicalList', function()
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and distance < 2.0 then
		TriggerServerEvent('rpuk_health:checkMedicalListForTarget', GetPlayerServerId(closestPlayer))
	end
end)

RegisterNetEvent('rpuk_health:sendToWaitingRoom')
AddEventHandler('rpuk_health:sendToWaitingRoom', function(data)
	local playerPed = PlayerPedId()
	TriggerEvent("mythic_progbar:client:progress", {
		name = "checkin",
		duration = 5000,
		label = "Checking In",
		useWhileDead = false,
		canCancel = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "missfam4",
			anim = "base",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "p_amb_clipboard_01",
			bone = 36029,
			coords = { x = 0.16, y = 0.08, z = 0.1 },
			rotation = { x = -130.0, y = -50.0, z = 90.0},
		}
	}, function(status)
		if not status then
			DoScreenFadeOut(2000)
			Citizen.Wait(2000)
			SetEntityCoords(playerPed, vector3(data.coords.x, data.coords.y, data.coords.z))
			SetEntityRotation(playerPed, data.coords.heading)
			Citizen.Wait(1000)
			DoScreenFadeIn(2000)
			createZoneRange(data)
			TriggerEvent('mythic_notify:client:SendAlert', {
				length = 12000,
				type = 'inform',
				text = 'You have been added to the waiting list to be seen by a doctor, please wait within the hospital. <br><br> If you leave the hospital without seeing a doctor you will be fined £'.. Beds.feeAmount
			})
			TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "gpAppointment", extraNotes = "A Patient has been added to the "..data.name.. " list."})
		end
	end)
end)

function createZoneRange(data)
	Citizen.CreateThread(function()
		while true do
			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)
			for k, v in pairs(WaitingRoomZones) do
				if data.name == k then
					if not v:isPointInside(pedCoords) then
						TriggerServerEvent("rpuk_health:leftWaitingRoom", data)
						return
					end
				end
			end
			Citizen.Wait(100)
		end
	end)
end

function createAnim(data)
	local playerPed = PlayerPedId()
	local anim = deathAnims[math.random(1,8)]
	loadAnimDict("dead")
	if not IsEntityPlayingAnim(playerPed, "dead", anim, 3) then
		SetEntityCoords(playerPed, vector3(data.x, data.y, data.z))
		SetEntityRotation(playerPed, data.heading)
		TaskPlayAnim(playerPed, "dead", anim, 8.0, -8, -1, 1, 0, 0, 0, 0)
	end
end

function standUpAnim(data)
	local playerPed = PlayerPedId()
	loadAnimDict("switch@franklin@bed")
	if not IsEntityPlayingAnim(playerPed, "switch@franklin@bed", "bed_reading_getup", 3) then
		SetEntityCoords(playerPed, vector3(data.x, data.y, data.z))
		SetEntityRotation(playerPed, data.heading)
		TaskPlayAnim(playerPed, "switch@franklin@bed", "bed_reading_getup", 8.0, -8, 3000, 1, 0, 0, 0, 0)
	end
end

function checkOutNotification(data)
	local playerPed = PlayerPedId()
	TriggerEvent('mythic_notify:client:PersistentAlert', {
		action = "START",
		id = 1,
		type = 'inform',
		text = 'Push [Z] to check out of the hosptial!'
	})
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if IsDisabledControlJustReleased(0, 20) then
				TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 1})
				TriggerServerEvent("rpuk_health:checkOutOfTheHospital", data)
				FreezeEntityPosition(playerPed, false)
				SetEntityCollision(playerPed, true, true)
				standUpAnim(data)
				inbed = false
				reviveEffect()
				break
			end
		end
	end)
end

function sendPatientToBed(data, reviveTime)
	local playerPed = PlayerPedId()
	inbed = true
	DoScreenFadeOut(2000)
	Citizen.Wait(2000)
	createAnim(data)
	Citizen.Wait(1000)
	DoScreenFadeIn(2000)
	FreezeEntityPosition(playerPed, true)
	SetEntityCollision(playerPed, false, false)
	TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'inform', text = "You are being treated, please wait." })
	TriggerEvent("mythic_progbar:client:progress", {
		name = "Healing",
		duration = reviveTime,
		label = "Time Until Resuscitation",
		useWhileDead = true,
		canCancel = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	}, function(status)
		if not status then
			TriggerServerEvent('rpuk_health:reviveTarget', GetPlayerServerId(PlayerId()), "beds")
			checkOutNotification(data)
		end
	end)
end

RegisterNetEvent('rpuk_health:releaseFromBedFromDoctor')
AddEventHandler('rpuk_health:releaseFromBedFromDoctor', function()
	local playerPed = PlayerPedId()
	TriggerEvent("mythic_progbar:client:cancel")
	FreezeEntityPosition(playerPed, false)
	SetEntityCollision(playerPed, true, true)
	TriggerServerEvent('rpuk_health:reviveTarget', GetPlayerServerId(PlayerId()), "beds")
	inbed = false
	reviveEffect()
end)


RegisterNetEvent('rpuk_health:prisonTreatment')
AddEventHandler('rpuk_health:prisonTreatment', function()
	TriggerEvent("mythic_progbar:client:progress", {
		name = "Healing",
		duration = 120000,
		label = "Medical Treatment",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "amb@world_human_clipboard@male@idle_a",
			anim = "idle_c",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_ld_health_pack",
		}
	}, function(status)
		if not status then
			local ped = PlayerPedId()
			ClearPedBloodDamage(ped)
			ResetPedVisibleDamage(ped)
			ClearPedLastDamageBone(ped)
			TriggerEvent('esx_basicneeds:healPlayer')
			TriggerEvent("rpuk_weather:isBlurry", false)
			TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'Now go back to the cells!' })
		end
	end)
end)














