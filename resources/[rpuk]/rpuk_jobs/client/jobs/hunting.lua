local occupied, onJob, jobBlip, jDist, job_stage, mark_animals = false, false, nil, nil, nil, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local canSleep = true

		if not occupied then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			for i=1, #Config.Hunting.NPCs.models, 1 do
				local distance = GetDistanceBetweenCoords(coords, Config.Hunting.NPCs.models[i].location[1], Config.Hunting.NPCs.models[i].location[2], Config.Hunting.NPCs.models[i].location[3], true)
				if distance < 50.0 and not Config.Hunting.NPCs.models[i].spawned then
					WaitForModel(Config.Hunting.NPCs.models[i].model)
					local pedHandle = CreatePed(5, Config.Hunting.NPCs.models[i].model, Config.Hunting.NPCs.models[i].location[1], Config.Hunting.NPCs.models[i].location[2], Config.Hunting.NPCs.models[i].location[3] , Config.Hunting.NPCs.models[i].location[4], false)
					SetEntityAsMissionEntity(pedHandle, true, true)
					SetBlockingOfNonTemporaryEvents(pedHandle, true)
					SetModelAsNoLongerNeeded(Config.Hunting.NPCs.models[i].model)
					if Config.Hunting.NPCs.models[i].godmode == true then
						SetEntityCanBeDamaged(pedHandle, false)
						FreezeEntityPosition(pedHandle, true)
					end
					if Config.Hunting.NPCs.models[i].anim then
						if Config.Hunting.NPCs.models[i].anim[2] then
							RequestAnimDict(Config.Hunting.NPCs.models[i].anim[1])
							while not HasAnimDictLoaded(Config.Hunting.NPCs.models[i].anim[1]) do
								Citizen.Wait(10)
							end
							TaskPlayAnim(pedHandle, Config.Hunting.NPCs.models[i].anim[1], Config.Hunting.NPCs.models[i].anim[2], 8.0, -8.0, -1, 2, 0.0, 0, 0, 0)
						else
							TaskStartScenarioInPlace(pedHandle, Config.Hunting.NPCs.models[i].anim[1], 0, true)
						end
					end
					if Config.Hunting.NPCs.models[i].weapon then
						local weapon = GetHashKey(Config.Hunting.NPCs.models[i].weapon)
						GiveWeaponToPed(pedHandle, weapon, 10000, false, true)
						SetCurrentPedWeapon(pedHandle, weapon, true)
					end
					Config.Hunting.NPCs.models[i].spawned = true
				elseif distance < 1.5 and Config.Hunting.NPCs.models[i].interation and not occupied then
					if Config.Hunting.NPCs.models[i].text then
						DisableControlAction(0, 44, true)
						local text_coord = vector3(Config.Hunting.NPCs.models[i].location[1], Config.Hunting.NPCs.models[i].location[2], Config.Hunting.NPCs.models[i].location[3] + 1.3)
						if Config.Hunting.NPCs.models[i].interation == "armorer" then
							ESX.Game.Utils.DrawText3D(text_coord, Config.Hunting.NPCs.models[i].text, 0.5, 6)
						else
							ESX.Game.Utils.DrawText3D(text_coord, "Your Level: " .. ESX.Player.GetJobGrade() .. "\n" .. Config.Hunting.NPCs.models[i].text, 0.5, 6)
						end
					end
					canSleep = false
					if IsControlJustReleased(0, 38) then
						occupied = true
						start_interaction(Config.Hunting.NPCs.models[i].interation, Config.Hunting.NPCs.models[i].extra)
					elseif IsControlJustReleased(0, 304) and Config.Hunting.NPCs.models[i].interation == "job" then
						occupied = true
						toggle_job()
					elseif IsDisabledControlJustReleased(0, 44) and Config.Hunting.NPCs.models[i].interation == "job" then
						occupied = true
						toggle_clothing()
					elseif IsControlJustReleased(0, 304) and Config.Hunting.NPCs.models[i].interation == "armorer" then
						occupied = true
						start_interaction(Config.Hunting.NPCs.models[i].interation)
					end
				end
			end

			if ESX.Player.GetJobName() == "ranger" then
				local closestPed, closestPedDst = ESX.Game.GetClosestPed(coords)
				for i=1, #Config.Hunting.Hunts.animals, 1 do
					local animal = Config.Hunting.Hunts.animals[i][1]
					if closestPedDst < 1.5 and GetEntityModel(closestPed) == GetHashKey(animal) then
						ESX.Game.Utils.DrawText3D(GetEntityCoords(closestPed), "[~g~E~s~] Skin", 0.5, 6)
						canSleep = false
						if IsControlJustReleased(0, 38) then
							occupied = true
							RequestAnimDict("amb@medic@standing@kneel@base")
							while not HasAnimDictLoaded("amb@medic@standing@kneel@base") do
								Citizen.Wait(10)
							end
							TaskPlayAnim(playerPed, "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false)
							TriggerEvent("mythic_progbar:client:progress", {
								name = "skinning",
								duration = 12000,
								label = "Skinning Animal",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "anim@gangops@facility@servers@bodysearch@",
									anim = "player_search",
									flags = 48,
									task = nil,
								},
							},
							function(cancel)
								if not cancel then
									if onJob and job_stage and job_stage == 3 then
										TriggerServerEvent('rpuk_hunting:clear_cull', 1, closestPed, 500)
										if math.random(1,10) == 1 then
											TriggerServerEvent('rpuk_jobs:level', 'ranger', true)
										end
									else
										TriggerServerEvent('rpuk_hunting:clear_cull', 0, closestPed, closestPedDst)
									end
									if ESX.Game.RequestNetworkControlOfEntity(closestPed, true) then
										DeleteEntity(closestPed)
									end
									cleanUp()
								elseif cancel then
									TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped skinning the animal!' })
									occupied = false
								end
							end)
						end
					end
				end
			end
		end

		if canSleep then
			Citizen.Wait(2000)
		end
	end
end)

-- [[ Base Functions ]] --

function WaitForModel(model_input)
	model = GetHashKey(model_input)	
    if not IsModelValid(model) then
        return
    end
	if not HasModelLoaded(model) then
		RequestModel(model)
	end	
	while not HasModelLoaded(model) do
		Citizen.Wait(1000)
	end
end

function start_interaction(interaction, extra)	
	if ESX.Player.GetJobName() ~= "ranger" then
		TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', length = 7000, text = 'You must be clocked in as a Park Ranger'})
		occupied = false
		return
	end
	if interaction == "speech" then
		for _, line in pairs(Config.Hunting.NPCs.speech_lines[extra]) do
		  TriggerEvent("mythic_notify:client:SendAlert", {
			text = line,
			type = 'inform',
			length = 12000,
		  })
		  Citizen.Wait(3000)
		end
		if extra == "vehicle_rental" then
			spawn_vehicle('rpCiv2')
		end
	elseif interaction == "job" then
		if ESX.Player.GetJobGrade() < 2 then
			start_job(1)
		else
			start_job(math.random(1,2)) -- start job random = the table - 1 for animal models
		end
	elseif interaction == "armorer" then
		TriggerServerEvent("rpuk_hunting:openShop")
	end
	occupied = false
end

function toggle_job()
	ESX.TriggerServerCallback('esx_license:checkLicense', function(x)
		if x then
			if ESX.Player.GetJobName() == "ranger" then
				TriggerServerEvent('rpuk_jobs:assign', "unemployed")
				cleanUp()
				TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', length = 7000, text = 'Clocked Out (Unemployed)'})
			else
				TriggerServerEvent('rpuk_jobs:assign', "ranger")
				TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', length = 7000, text = 'Clocked In (Park Ranger)'})
			end
		else
			TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', length = 14000, text = 'You do not have the required licence (Hunting)'})
		end
		occupied = false
	end, GetPlayerServerId(PlayerId()), 'weapon')
end

function toggle_clothing()
	if ESX.Player.GetJobName() ~= "ranger" then
		TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "You must be clocked in as a Park Ranger"})
		cleanUp()
		return
	end
	local playerPed = PlayerPedId()
	if GetEntityModel(playerPed) == GetHashKey("mp_m_freemode_01") then
		SetPedComponentVariation(playerPed, 3, 11, 0, 2)
		SetPedComponentVariation(playerPed, 8, 15, 0, 2)
		SetPedComponentVariation(playerPed, 11, 278, 9, 2)
		SetPedComponentVariation(playerPed, 4, 4, 1, 2)
		SetPedComponentVariation(playerPed, 6, 24, 0, 2)
	else
		SetPedComponentVariation(playerPed, 3, 9, 0, 2)
		SetPedComponentVariation(playerPed, 8, 2, 0, 2)
		SetPedComponentVariation(playerPed, 11, 291, 7, 2)
		SetPedComponentVariation(playerPed, 4, 4, 1, 2)
		SetPedComponentVariation(playerPed, 6, 51, 0, 2)
	end
	cleanUp()
end

function start_job(int) -- set occupied = false after x time
	if int == 1 then -- Photo Job
		photo_job()
	elseif int == 2 then -- Driving Job
		spawn_animal()
	elseif int == 3 then -- Hunting Job
		spawn_animal()
	end
end

function spawn_vehicle(model)
	ESX.Game.SpawnVehicle(model, vector3(373.88, 796.84, 186.84), 180.90, function(spawned_vehicle)
		local playerPed = PlayerPedId()
		Citizen.Wait(1000)
		local vehicleProps = ESX.Game.GetVehicleProperties(spawned_vehicle)
		xplate = vehicleProps.plate
		local id = NetworkGetNetworkIdFromEntity(spawned_vehicle)
		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(spawned_vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(spawned_vehicle, true)
		SetVehicleNeedsToBeHotwired(spawned_vehicle, false)									
		SetVehicleModKit(spawned_vehicle, 0)
		SetVehicleWindowTint(spawned_vehicle, 0)
		SetVehicleDirtLevel(spawned_vehicle, 0)
		SetVehicleLivery(spawned_vehicle, 0)
		SetVehicleColours(spawned_vehicle, 12, 12)
	end, {
		plate = xplate
	}, {
		giveKeys = true
	})
end

local function addBlip(coords, var, xString)
	jobBlip = AddBlipForCoord(coords)
	SetBlipAsFriendly(jobBlip, true)
	SetBlipSprite(jobBlip, var)
	SetBlipScale(jobBlip, 1.5)
	BeginTextCommandSetBlipName("STRING");
	AddTextComponentString(tostring(xString))
	EndTextCommandSetBlipName(jobBlip)	
end

function spawn_animal_old(model)
	Citizen.CreateThread(function()
		if onJob then
			TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', length = 7000, text = 'Job Abandoned. Cooldown period Started.'})
			Citizen.Wait(20000)
			cleanUp()
			return
		end
		local lrand = math.random(1, tableLength(Config.Hunting.Hunts.job_types.culling.points))
		local location = Config.Hunting.Hunts.job_types.culling.points[lrand]
		local mrand = math.random(1, tableLength(Config.Hunting.Hunts.animals))
		local model =  Config.Hunting.Hunts.animals[mrand]
		TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', length = 5000, text = "Job Started: Overpopulation Culling. I have marked the animals last known whereabouts on your GPS."})
		addBlip(location, 161, "Hunt: Last Sighting")
		job_stage = 1
		onJob = true
		local playerPed, ped = PlayerPedId(), nil
		jDist = #(GetEntityCoords(playerPed) - location)	
		while (job_stage == 1) do
			Citizen.Wait(1000)
			if onJob then
				local coords = GetEntityCoords(playerPed)
				if #(coords - location) < 100.0 then
					if not ped then
						ped = CreatePed(5, GetHashKey(model[1]), location.x, location.y, location.z, 0.0, true, true)
						SetEntityAsMissionEntity(ped, true, true)
						blip = AddBlipForEntity(ped)
						SetBlipSprite(blip, 303)
						ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
						SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
						SetBlipColour(blip, 1)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Job: " .. model[2])
						EndTextCommandSetBlipName(blip)
						SetBlipScale(blip, 0.5) -- set scale
						SetBlipAsShortRange(blip, false)
						TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', length = 25000, text = "Hunt has been spotted in the area."})
						job_stage = 2
					end
				end
			else
				cleanUp()
			end
		end		
		while (job_stage == 2) do
			Citizen.Wait(3000)
			if onJob then
				if not DoesEntityExist(ped) then
					ped = CreatePed(5, GetHashKey(model[1]), location.x, location.y, location.z, 0.0, true, true)
					SetEntityAsMissionEntity(ped, true, true)
					blip = AddBlipForEntity(ped)
					SetBlipSprite(blip, 303)
					ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
					SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
					SetBlipColour(blip, 1)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("Job: " .. model[2])
					EndTextCommandSetBlipName(blip)
					SetBlipScale(blip, 0.5) -- set scale
					SetBlipAsShortRange(blip, false)
				end
				if IsEntityDead(ped) then
					TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', length = 25000, text = "The hunt is dead. Go skin it."})
					job_stage = 3
				end
			else
				cleanUp()
			end
		end
		local count = 0
		while (job_stage == 3) do
			Citizen.Wait(1000)
			if onJob then
				if count == 120 then
					TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', length = 25000, text = "The hunt rotted away. Job Over."})
					cleanUp()
				end				
			else
				cleanUp()
			end
		end		
	end)
end

function purchase(extra)
	TriggerServerEvent('rpuk_hunting:purchase', extra)
end

function spawn_animal()
	if onJob then
		cleanUp()
		return
	end
	onJob = true
	mark_animals = true
	job_stage = 3
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', length = 5000, text = "Job Started: Overpopulation Culling. I have marked the animals. Other hunters are in the area. You best get going!"})
end

function photo_job()
	Citizen.CreateThread(function()	
		if onJob then
			TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', length = 7000, text = 'Job Abandoned. Cooldown period Started.'})
			Citizen.Wait(20000)
			cleanUp()
			return
		end
		local lrand = math.random(1, tableLength(Config.Hunting.Hunts.job_types.photo.points))
		local location = Config.Hunting.Hunts.job_types.photo.points[lrand]
		TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', length = 5000, text = "Job Started: Photo Taking & Documenting. Go to the location marked and get a photo."})
		addBlip(location, 744, "Job: Media Photo")
		job_stage = 1
		onJob = true
		local playerPed = PlayerPedId()
		jDist = #(GetEntityCoords(playerPed) - location)	
		while (job_stage == 1) do
			Citizen.Wait(5)
			local xSleep = true
			if onJob then
				local coords = GetEntityCoords(playerPed)
				if #(coords - location) < 15.0 then
					xSleep = false
					local text_coords = vector3(location.x, location.y, location.z + 0.5)
					DrawMarker(1, location, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 0.5, 0, 519, 0, 105, 0, 0, 2, 0, 0, 0, 0)
					ESX.Game.Utils.DrawText3D(text_coords, "[~g~E~s~] To Take Picture", 0.5, 6)
					if IsControlJustReleased(0, 38) then
						
						TriggerEvent("mythic_progbar:client:progress", {
							name = "huntPicture",
							duration = 12000,
							label = "Taking Photo",
							useWhileDead = false,
							canCancel = true,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
							animation = {
								animDict = nil,
								anim = nil,
								flags = 48,
								task = "WORLD_HUMAN_PAPARAZZI",
							},
						},
						function(cancel)
							if not cancel then
								if onJob and job_stage and job_stage == 1 then
									TriggerServerEvent('rpuk_hunting:clear_photo', 211020, jDist)
									TriggerServerEvent('rpuk_jobs:progress', 'ranger')
								end
								cleanUp()
							elseif cancel then
								TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped taking the picture!' })
								occupied = false
							end
						end)
					end
				end
			else
				cleanUp()
			end
			if xSleep then
				Citizen.Wait(2000)
			end
		end
	end)
end

function tableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function removeBlip()
	RemoveBlip(jobBlip)
	jobBlip = nil
end

function cleanUp()
	RemoveBlip(jobBlip)
	jobBlip = nil
	onJob = false
	job_stage = nil
	jDist = nil
	occupied = false
	mark_animals = false
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

local ped_blips = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		if mark_animals and onJob then
			for ped in EnumeratePeds() do
				if GetPedType(ped) == 28 then
					pedBlip(ped)
				end
			end
		end
	end
end)

function pedBlip(ped)
	local blip = GetBlipFromEntity(ped)
	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 442)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation

		SetBlipColour(blip, 5)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Wild Animal")
		EndTextCommandSetBlipName(blip)

		SetBlipScale(blip, 0.5) -- set scale
		SetBlipAsShortRange(blip, true)
		table.insert(ped_blips, blip)
	end
end