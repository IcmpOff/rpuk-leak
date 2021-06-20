--Assign Locals
local spawned_ped = nil
local lasttarget = nil
local following = false
local attacking = false
local tracing = false
local attacked_player = 0
local animations = {
	['Normal'] = {
		sit = {
			dict = "creatures@rottweiler@amb@world_dog_sitting@idle_a",
			anim = "idle_b"
		},
		laydown = {
			dict = "creatures@rottweiler@amb@sleep_in_kennel@",
			anim = "sleep_in_kennel"
		}
	}
}

RegisterNetEvent("rpuk_Police:dogs")
AddEventHandler("rpuk_Police:dogs", function(type)
	type = type[1]
	if tonumber(ESX.Player.GetPoliceData().dog) >= 1 then
		if type == "vehicle" then
			vehicle()
		elseif type == "sit" then
				PlayAnimation(animations['Normal'].sit.dict, animations['Normal'].sit.anim)
		elseif type == "down" then
				PlayAnimation(animations['Normal'].laydown.dict, animations['Normal'].laydown.anim)
		elseif type == "tracedriver" then
			traceDriver()
		elseif type == "spawn" then
			local playerPed = PlayerPedId()
			local playerCoords = GetOffsetFromEntityInWorldCoords(playerPed, 1.5, 5.0, 0.0)
			spawn("a_c_shepherd", playerCoords)
		end
	end
end)

--Listen for /dog command
RegisterCommand('dog', function(source, args)
	if spawned_ped ~= nil then
		if ESX.Player.GetJobName() == "police" then
			if tonumber(ESX.Player.GetPoliceData().dog) >= 1 then
				if args[1] == "vehicle" then
					vehicle()
				elseif args[1] == "anim" then
					if args[2] == "sit" then
						PlayAnimation(animations['Normal'].sit.dict, animations['Normal'].sit.anim)
					elseif args[2] == "down" then
						PlayAnimation(animations['Normal'].laydown.dict, animations['Normal'].laydown.anim)
					end
				elseif args[1] == "tracedriver" then
					traceDriver()
				end
			end

		end
	end
end, false)

--Functions
function spawn(model, location)
	if spawned_ped == nil then
		local ped = GetHashKey(model)
		RequestModel(ped)
		while not HasModelLoaded(ped) do
			Citizen.Wait(1)
			RequestModel(ped)
		end
		local spawnCoords = location
		local dog = CreatePed(28, ped, spawnCoords.x, spawnCoords.y, spawnCoords.z, -87.745, 1, 1)
		spawned_ped = dog
		TriggerEvent('rpuk:activepet', true)
		SetBlockingOfNonTemporaryEvents(spawned_ped, true)
		SetPedFleeAttributes(spawned_ped, 0, 0)
		SetPedRelationshipGroupHash(spawned_ped, GetHashKey("k9"))
		SetPedMaxHealth(spawned_ped, 300)
		NetworkRegisterEntityAsNetworked(spawned_ped)
		while not NetworkGetEntityIsNetworked(spawned_ped) do
			NetworkRegisterEntityAsNetworked(spawned_ped)
			Citizen.Wait(1)
		end
		PlayAnimation(animations['Normal'].sit.dict, animations['Normal'].sit.anim)
	else
		local has_control = false
		RequestDogNetworkControl(function(cb)
			has_control = cb
		end)
		if has_control then
			SetEntityAsMissionEntity(spawned_ped, true, true)
			DeleteEntity(spawned_ped)
			spawned_ped = nil
			TriggerEvent('rpuk:activepet', false)
			if attacking then
				SetPedRelationshipGroupDefaultHash(target_ped, GetHashKey("CIVMALE"))
				target_ped = nil
				attacking = false
			end
			following = false
		end
	end
end

function follow()
	if spawned_ped ~= nil then
		if not following then
			local has_control = false
			RequestDogNetworkControl(function(cb)
				has_control = cb
			end)
			if has_control then
				TaskFollowToOffsetOfEntity(spawned_ped, PlayerPedId(), 0.5, 0.0, 0.0, 5.0, -1, 0.0, 1)
				SetPedKeepTask(spawned_ped, true)
				following = true
				attacking = false
				TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'success', text = "Following"}) 
			end
		else
			local has_control = false
			RequestDogNetworkControl(function(cb)
				has_control = cb
			end)
			if has_control then
				SetPedKeepTask(spawned_ped, false)
				ClearPedTasks(spawned_ped)
				following = false
				attacking = false
				TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'success', text = "Following"}) 
			end
		end
	end
end

function vehicle()
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehicle = ESX.Game.GetVehicleInDirection()
		if DoesEntityExist(vehicle) then
			if IsEntityAttachedToAnyVehicle(spawned_ped) then
				PlayAnimation(animations['Normal'].sit.dict, animations['Normal'].sit.anim)
				AttachEntityToEntity(spawned_ped, vehicle, 1, -0.3, -3.0, -1.1, 0.0, 0.0, 220.0, false, false, false, false, 20, true)
				DetachEntity(spawned_ped, true, true)
				TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'inform', text = "You take your dog out of Car"}) 
			else
				local plyCoords = GetEntityCoords(PlayerPedId(), false)
				local dogCoords = GetEntityCoords(spawned_ped, false)
				if (Vdist(plyCoords.x, plyCoords.y, plyCoords.z, dogCoords.x, dogCoords.y, dogCoords.z)<2) then
					if GetHashKey("rpPolice11") == GetEntityModel(vehicle) then
						PlayAnimation(animations['Normal'].laydown.dict, animations['Normal'].laydown.anim)
						AttachEntityToEntity(spawned_ped, vehicle, 1, -0.2, -1.3, -0.5, -2, -0.0, -180.0, false, false, false, false, 20, true)
						following = false
						TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'inform', text = "You put dog in Car"})  
					end
				end
			end
		end
	end
end

function traceDriver()
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehicle = ESX.Game.GetVehicleInDirection()
		if DoesEntityExist(vehicle) and not tracing then
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dogCoords = GetEntityCoords(spawned_ped, false)
			if (Vdist(plyCoords.x, plyCoords.y, plyCoords.z, dogCoords.x, dogCoords.y, dogCoords.z)<2) then
				tracing = true
				TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'Tracing Driver', text = ""}) 
				SetVehicleDoorOpen(vehicle, 0, 0, 0)
				SetVehicleDoorOpen(vehicle, 1, 0, 0)
				SetVehicleDoorOpen(vehicle, 2, 0, 0)
				SetVehicleDoorOpen(vehicle, 3, 0, 0)
				SetVehicleDoorOpen(vehicle, 5, 0, 0)
				SetVehicleDoorOpen(vehicle, 6, 0, 0)
				SetVehicleDoorOpen(vehicle, 7, 0, 0)

				-- Back Right
				local offsetOne = GetOffsetFromEntityInWorldCoords(vehicle, 2.0, -2.0, 0.0)
				TaskGoToCoordAnyMeans(spawned_ped, offsetOne.x, offsetOne.y, offsetOne.z, 5.0, 0, 0, 1, 10.0)
				Citizen.Wait(math.random(3000,7000))
				-- Front Right
				local offsetTwo = GetOffsetFromEntityInWorldCoords(vehicle, 2.0, 2.0, 0.0)
				TaskGoToCoordAnyMeans(spawned_ped, offsetTwo.x, offsetTwo.y, offsetTwo.z, 5.0, 0, 0, 1, 10.0)
				Citizen.Wait(math.random(3000,7000))
				-- Front Left
				local offsetThree = GetOffsetFromEntityInWorldCoords(vehicle, -2.0, 2.0, 0.0)
				TaskGoToCoordAnyMeans(spawned_ped, offsetThree.x, offsetThree.y, offsetThree.z, 5.0, 0, 0, 1, 10.0)
				Citizen.Wait(math.random(3000,7000))
				-- Back Left
				local offsetFour = GetOffsetFromEntityInWorldCoords(vehicle, -2.0, -2.0, 0.0)
				TaskGoToCoordAnyMeans(spawned_ped, offsetFour.x, offsetFour.y, offsetFour.z, 5.0, 0, 0, 1, 10.0)
				Citizen.Wait(math.random(3000,7000))

				local lastped = GetLastPedInVehicleSeat(vehicle, -1)
				if lastped ~= nil then
					local lastpedCoords = GetEntityCoords(lastped, false)
					if (Vdist(lastpedCoords.x, lastpedCoords.y, lastpedCoords.z, dogCoords.x, dogCoords.y, dogCoords.z)<300) then
						local has_control = false
						RequestDogNetworkControl(function(cb)
							has_control = cb
						end)
						if has_control then
							TaskFollowToOffsetOfEntity(spawned_ped, lastped, 0.5, 0.0, 0.0, 3.5, -1, 0.0, 1)
							SetPedKeepTask(spawned_ped, true)
							following = true
							attacking = false
							drawSpinner("Found a scent", 5000)
						end
					else
						TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'error', text = "Falied to Find a warm scent"}) 
					end
				else
					TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'error', text = "Falied to Find a scent"}) 
				end
				tracing = false
			end
		end
	end
end

function drawSpinner(text, wait)
	AddTextEntry("dogsniff", text)
	BeginTextCommandBusyspinnerOn("dogsniff")
	EndTextCommandBusyspinnerOn(4)
	Citizen.Wait(wait)
	BusyspinnerOff()
end

function attack(target)
	lasttarget = target
	if not attacking then
		local has_control = false
		RequestDogNetworkControl(function(cb)
			has_control = cb
		end)
		if has_control then
			SetCanAttackFriendly(spawned_ped, true, true)
			TaskPutPedDirectlyIntoMelee(spawned_ped, target, 0.0, -1.0, 0.0, 0)
			attacked_player = 0
		end
		attacking = true
		following = false
		TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'error', text = "Attacking"}) 
	else
		attacking = false
		ClearPedTasks(spawned_ped)
	end
end

Citizen.CreateThread(function() --Deletes dog when you die
	while true do
		Citizen.Wait(100)
		if lasttarget ~= nil then
			if IsEntityDead(lasttarget) or IsEntityPlayingAnim(PlayerPedId(), 'misslamar1dead_body', 'dead_idle', 3) then
				attacking = false
				ClearPedTasks(spawned_ped)
				lasttarget = nil
			end
		end
	end
end)


function RequestDogNetworkControl(callback)
	local netId = NetworkGetNetworkIdFromEntity(spawned_ped)
	local timer = 0
	NetworkRequestControlOfNetworkId(netId)
	while not NetworkHasControlOfNetworkId(netId) do
		Citizen.Wait(1)
		NetworkRequestControlOfNetworkId(netId)
		timer = timer + 1
		if timer == 5000 then
			Citizen.Trace("Control failed")
			callback(false)
			break
		end
	end
	callback(true)
end

function PlayAnimation(dict, anim)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(0)
	end
	TaskPlayAnim(spawned_ped, dict, anim, 8.0, -8.0, -1, 2, 0.0, 0, 0, 0)
end

RegisterKeyMapping('-pet_keydown_event', 'Pet Quick Command', 'keyboard', 'g')
RegisterCommand('-pet_keydown_event', function()
	if jobName == "police" then
		if tonumber(ESX.Player.GetPoliceData().dog) >= 1 then
			if spawned_ped ~= nil then
				if IsPlayerFreeAiming(PlayerId()) then
					local bool, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
					if bool then
						if IsEntityAPed(target) then
							if not IsPedInAnyVehicle(target, false) then
								attack(target)
							end
						end
					end
				else
					print("triggering call")
					RequestAnimDict("rcmnigel1c")
					while not HasAnimDictLoaded("rcmnigel1c") do
						Citizen.Wait(100)
					end
					TaskPlayAnim(PlayerPedId(), "rcmnigel1c", "hailing_whistle_waive_a", 2.7, 2.7, 500, 49, 0, 0, 0, 0)
					follow()
				end
			end
		end
	end
end, false)