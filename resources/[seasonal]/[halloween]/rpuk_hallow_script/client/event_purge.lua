purge_active = false
blips, r_blips = {}, {}

RegisterNetEvent('rpuk_halloween:purge_start')
AddEventHandler('rpuk_halloween:purge_start', function()
	ESX.Scaleform.ShowFreemodeMessage("~g~PURGE EVENT STARTED!", "The following rules do NOT apply during this event\n(G1.2) Random Death Match (RDM)\n(G1.1) Random Vehicle Death Match (RVDM)", 10)
	purge_active = true

	Citizen.CreateThread(function()
		while purge_active do
			Citizen.Wait(5)
			local canSleep = true
			local coords = GetEntityCoords(PlayerPedId())
			for k, v in pairs(config.crates) do	
				local crate_coords = vector3(v.location.x, v.location.y, v.location.z)
				if GetDistanceBetweenCoords(coords, crate_coords, true) < 20.0 then
					local object = GetClosestObjectOfType(coords, 2.0, GetHashKey(v.model), false)
					PlaceObjectOnGroundProperly(object)
					if DoesEntityExist(object) and not occupied and not v.searched then
						canSleep = false
						ESX.Game.Utils.DrawText3D(GetEntityCoords(object), "[~g~E~s~] To Search Crate", 0.8, 6)
						if IsControlJustReleased(0, 38) and not occupied then
							occupied = true
							TriggerEvent("mythic_progbar:client:progress", {
								name = "search_purge_crate",
								duration = 20000,
								label = "Searching",
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
							}, function(status)
								if not status then
									math.randomseed(GetGameTimer())
									local rnd = math.random(1, 10)
									if rnd < 2 then
										AddExplosion(v.location.x, v.location.y, v.location.z, 29, 1000.0, 1, 0, 10)
										v.searched = false
										occupied = false
									else
										TriggerServerEvent('rpuk_halloween:crate_search', k)
									end
									Citizen.Wait(5000)
									v.searched = true
									occupied = false
								else
									Citizen.Wait(2000)
									v.searched = false
									occupied = false
								end
							end)
						end
					end			
				end
			end
			if canSleep then
				Citizen.Wait(5000)
			end
		end
	end)
	
end)

RegisterNetEvent('rpuk_halloween:purge_crate')
AddEventHandler('rpuk_halloween:purge_crate', function(index)
	clean_up()
	Citizen.Wait(1000)
	local xCrate = CreateObject(GetHashKey(config.crates[index].model), config.crates[index].location.x, config.crates[index].location.y, config.crates[index].location.z, 0, 0, 1)
	PlaceObjectOnGroundProperly(xCrate)
	createBlip(xCrate, "crate")
	config.crates[index].entity = xCrate
end)

RegisterNetEvent('rpuk_halloween:purge_npcs')
AddEventHandler('rpuk_halloween:purge_npcs', function(index)
	local length = tableLength(config.npc_pools.locations)
	for i = 6, 1, -1 do
		local newGroup = CreateGroup()
		local pedGroup = {}
		local r = math.random(1, length)		
		local count = 1
		for k, v in pairs(config.npc_pools.loadouts) do		
			while not HasModelLoaded(k) do RequestModel(k) Citizen.Wait(100) end
			local ped = CreatePed(3, k, config.npc_pools.locations[r].x, config.npc_pools.locations[r].y, config.npc_pools.locations[r].z, 0.0, true, true)		
			SetEntityAsMissionEntity(ped,true,true)
			SetEntityMaxHealth(ped, config.npc_pools.attributes.Health*2)
			SetEntityHealth(ped, config.npc_pools.attributes.Health*2)
			SetPedCombatMovement(ped, config.npc_pools.attributes.Movement)
			SetPedCombatRange(ped, config.npc_pools.attributes.Range)
			SetPedCombatAbility(ped, config.npc_pools.attributes.Ability)
			SetPedFiringPattern(ped,GetHashKey(config.npc_pools.attributes.Pattern))
			SetPedAccuracy(ped, config.npc_pools.attributes.Accuracy)

			SetPedSeeingRange(ped, 150)
			SetPedCombatRange(ped, 2)
			SetPedRelationshipGroupHash(ped, GetHashKey(0x06C3F072))
			SetPedHearingRange(ped, 80.0)
			SetPedCombatAttributes(ped, 46, 1)
			SetPedFleeAttributes(ped, 0, 0)
			TaskCombatHatedTargetsInArea(ped, config.npc_pools.locations[r].x, config.npc_pools.locations[r].y, config.npc_pools.locations[r].z, 5000, 1)
			SetPedCanCowerInCover(ped, false)

			local weapon = v[math.random(1, tableLength(v))]
			GiveWeaponToPed(ped, GetHashKey(weapon), 10000, false, true)
			SetCurrentPedWeapon(ped, GetHashKey(weapon), true)

			pedGroup[count] = ped
			if count == 1 then
			   SetPedAsGroupLeader(ped, newGroup)
			   TaskWanderStandard(ped, 10.0, 10)
			   local closestPlayer, distance = ESX.Game.GetClosestPlayer()
			   TaskCombatPed(ped, GetPlayerPed(closestPlayer), 0, 16)
			else
				SetPedAsGroupMember(ped, newGroup)
			end		
			count = count + 1
		end
		SetGroupFormation(newGroup, 2)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local canSleep = true
		local coords = GetEntityCoords(PlayerPedId())
		for _, data in pairs(config.props) do
			if #(coords - data.location) < 200 and data.entity == nil then
				if type(data.model) == "string" then
					prop = CreateObject(GetHashKey(data.model), data.location, 0, 0, 1)
				else
					prop = CreateObject(data.model, data.location, 0, 0, 1)
				end
				if not data.sink then
					PlaceObjectOnGroundProperly(prop)
				end
				SetEntityRotation(prop, data.rotation, 1, true)
				SetEntityCollision(prop, true, true)
				FreezeEntityPosition(prop, true)
				data.entity = prop
			end
		end
	end
end)

RegisterNetEvent('rpuk_halloween:purge_stop')
AddEventHandler('rpuk_halloween:purge_stop', function()
	ESX.Scaleform.ShowFreemodeMessage("~g~PURGE EVENT ENDED!", "The following rules are now enforced\n(G1.2) Random Death Match (RDM)\n(G1.1) Random Vehicle Death Match (RVDM)", 10)
	purge_active = false
	occupied = false
	clean_up()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		clean_up()
	end
end)

function clean_up()
	for k, v in pairs(config.crates) do
		if v.entity then
			DeleteObject(v.entity)
			v.entity = nil
			v.searched = false
		end
	end
	for _, e in pairs(blips) do
		RemoveBlip(e)
	end
	for k, v in pairs(config.props) do
		DeleteObject(v.entity)
		v.entity = nil
	end
end

function tableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true
		if purge_active then
			SetVehicleDensityMultiplierThisFrame(0)
			SetPedDensityMultiplierThisFrame(0)
			SetRandomVehicleDensityMultiplierThisFrame(0)
			SetParkedVehicleDensityMultiplierThisFrame(0)
			SetScenarioPedDensityMultiplierThisFrame(0, 0)
			canSleep = false
		end
		if canSleep then
			Citizen.Wait(5000)
		end
	end
end)

function createBlip(entity, cType)
	local blip = AddBlipForEntity(entity)
	SetBlipSprite(blip, config.blips[cType].icon)
	SetBlipColour(blip, config.blips[cType].colour)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(config.blips[cType].text)
	EndTextCommandSetBlipName(blip)

	SetBlipScale(blip, 0.80) -- set scale
	SetBlipAsShortRange(blip, true)
	table.insert(blips, blip)
end