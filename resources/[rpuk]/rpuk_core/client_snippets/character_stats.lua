local using = false

local stats = {
	["stamina"] = {"MP0_STAMINA", "Stamina"}, -- running / distance
	["strength"] = {"MP0_STRENGTH", "Strength"}, -- how hard you punch
	["stealth"] = {"MP0_STEALTH_ABILITY", "Stealth"}, -- useless in our usage
	["shooting"] = {"MP0_SHOOTING_ABILITY", "Shooting"}, -- increase whilst you are flying
	["flying"] = {"MP0_FLYING_ABILITY", "Flying"}, -- recoil control
	["driving"] = {"MP0_DRIVING_ABILITY", "Driving"}, -- increase whilst you are driving
	["lung_capacity"] = {"MP0_LUNG_CAPACITY", "Lung Capacity"}, -- swimming
	["mental_state"] = {"MP0_PLAYER_MENTAL_STATE", "Mental State"}, -- useless in our usage // mental breakdown
}
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	for k, v in pairs(playerData.stats) do
		if stats[k] then
			local sv = tostring(k)
			local nv = tonumber(v)
			StatSetInt(stats[sv][1], nv, true)
		end
	end
end)

local static_list = {
	[-1555713785] = {
		equipmentLabel = "Barbell",
		duration = 5000,
		animData = {
			dir = "base",
			anim = "amb@world_human_muscle_free_weights@male@barbell@base",
			flags = 49,
			task = nil,
		},
		propData = {
			model = "prop_curl_bar_01",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 182.0 },
		},
		stat = "strength"
	},

	[1505848876] =  {
		equipmentLabel = "Barbell",
		duration = 5000,
		animData = {
			dir = "base",
			anim = "amb@world_human_muscle_free_weights@male@barbell@base",
			flags = 49,
			task = nil,
		},
		propData = {
			model = "prop_curl_bar_01",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = 0.0 },
			rotation = { x = 0.0, y = 0.0, z = 182.0 },
		},
		stat = "strength"
	},

	[1732037892] =  {
		equipmentLabel = "Treadmill",
		duration = 8000,
		animData = {
			dir = "idle_a",
			anim = "amb@world_human_jog_standing@male@idle_a",
			flags = 14,
			task = nil,
		},
		propData = nil,
		stat = "stamina"
	},


}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true
		local coords = GetEntityCoords(PlayerPedId())

		for k, v in pairs(static_list) do
			local object = GetClosestObjectOfType(coords, 1.0, k, false)
			if DoesEntityExist(object) and not using then
				canSleep = false
				ESX.Game.Utils.DrawText3D(GetEntityCoords(object), "[~g~E~s~] Interact With\n~r~" .. v.equipmentLabel, 0.5, 6)
				if IsControlJustReleased(0, 38) then
					gym_use(v.animData, v.propData, v.duration, v.stat)
				end
			end
		end

		if canSleep then
			Citizen.Wait(2000)
		end
	end
end)

function gym_use(animData, propData, duration, stat)
	if not using then
		using = true
		TriggerEvent("mythic_progbar:client:progress", {
			name = "equipment22",
			duration = duration,
			label = "Using Equipment",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = animData.anim,
				anim = animData.dir,
				flags = animData.flags,
				task = nil,
			},
			prop = propData,
			}, function(status)
			if not status then
				if math.random(1,4) == 1 then
					TriggerServerEvent('rpuk_stats:increase', stat)
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = stats[stat][2] .. ' significantly increased!' })
				end
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = stats[stat][2] .. ' increased!' })
				using = false
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped using the equipment! ' })
				using = false
			end
		end)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)

		if ESX.Player.GetStats().strength and ESX.Player.GetStats().strength > 10 then
			SetPlayerLockonRangeOverride(PlayerId(), 1.0)
			SetPlayerLockon(PlayerId(), true)
		else
			SetPlayerLockonRangeOverride(PlayerId(), 0.0)
			SetPlayerLockon(PlayerId(), false)
		end
	end
	--ESX.UI.ShowInventoryItemNotification(true, stats[a][2], 1)
end)

Citizen.CreateThread( function()
	local resetcounter = 0
	local jumpDisabled = false

	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		local isPedJumping = IsPedJumping(ped)
		if isPedJumping then
			if jumpDisabled and resetcounter > 0 then
				SetPedToRagdoll(ped, 1000, 1000, 3, 0, 0, 0)
				resetcounter = 0
			end

			if not jumpDisabled then
				jumpDisabled = true
				resetcounter = 100
				Citizen.Wait(1200)
			end

			if resetcounter > 0 then
				resetcounter = resetcounter - 1
			else
				if jumpDisabled then
					resetcounter = 0
					jumpDisabled = false
				end
			end
		end
	end
end)
