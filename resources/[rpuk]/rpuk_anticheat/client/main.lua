local spawned, b, tg, clear_peds = true, nil, false, false

RegisterNetEvent('rpuk:spawned')
AddEventHandler('rpuk:spawned', function(job)
	spawned = true
end)

RegisterNetEvent('rpuk_anticheat:togglePeds')
AddEventHandler('rpuk_anticheat:togglePeds', function(job)
	clear_peds = not clear_peds
end)

Citizen.CreateThread(function()
	while true do
		local orig = _G.Citizen.Trace
		for _, cmd in pairs(ds.bcmd) do
			for k,v in ipairs(GetRegisteredCommands()) do
				if tostring(cmd) == tostring(v["name"]) then
					TriggerServerEvent('rpuk_anticheat:ab', "illegal6")
					Citizen.Wait(3000)
				end
			end
		end
		Citizen.Wait(10000)
	end
end)

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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		if clear_peds then
			for ped in EnumeratePeds() do
				if not (IsPedAPlayer(ped))then
					RemoveAllPedWeapons(ped, true)
					DeleteEntity(ped)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		for _, wep in pairs(ds.bwep) do
			if HasPedGotWeapon(PlayerPedId(), GetHashKey(wep), false) then
				TriggerServerEvent('rpuk_anticheat:a', "blacklistedweapon")
				RemoveAllPedWeapons(PlayerPedId(), true)
				ESX.ShowAdvancedNotification("Restricted Weapon", "Weapons Removed", "You were detected with an illegal weapon, please remember client modifications and trainers are not allowed on RPUK servers.\nSee discord for help.", 'CHAR_SOCIAL_CLUB', 1)
				break
			end
		end

		-- Check BL vehicle & BL plate
		if IsPedInAnyVehicle(PlayerPedId()) then
			local vehicleEntity = GetVehiclePedIsIn(PlayerPedId(), false)

			if vehicleEntity and DoesEntityExist(vehicleEntity) then
				local vehiclePlate, vehicleModel = ESX.Math.Trim(GetVehicleNumberPlateText(vehicleEntity)), GetEntityModel(vehicleEntity)

				if ds.bveh[vehicleModel] then
					TriggerServerEvent('rpuk_anticheat:a', "blacklistedvehicle")
					ESX.Game.DeleteVehicle(vehicleEntity)
				end

				if ds.bnpl[vehiclePlate] then
					TriggerServerEvent('rpuk_anticheat:a', "blacklistednumberplate")
					ESX.Game.DeleteVehicle(vehicleEntity)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while not ESX.IsPlayerLoaded() do Citizen.Wait(1000) end -- wait for kashacter to choose char

	if not ESX.Player.GetIsStaff() then
		while true do
			Citizen.Wait(1000 * math.random(120,240))
			local curPed = PlayerPedId()
			local curHealth = GetEntityHealth( curPed )

			if curHealth > 150 and not IsPlayerDead(PlayerId()) then
				SetEntityHealth( curPed, curHealth-2)
				Citizen.Wait(math.random(100,200))
				if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then
					TriggerServerEvent('rpuk_anticheat:a', "healthviolation1")
				elseif GetEntityHealth(curPed) == curHealth-2 then
					SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
				end
			end

			if GetEntityHealth(curPed) > 400 then
				TriggerServerEvent('rpuk_anticheat:a', "healthviolation2")
			end
		end
	end
end)

RegisterNetEvent('rpuk_anticheat:tg')
AddEventHandler('rpuk_anticheat:tg', function(value)
	tg = value
end)

Citizen.CreateThread(function()
	while not ESX.IsPlayerLoaded() do Citizen.Wait(1000) end -- wait for kashacter to choose char

	if not ESX.Player.GetIsStaff() then
		while true do
			Citizen.Wait(1000 * math.random(30,60))
			if GetPlayerInvincible_2(PlayerId()) and not tg then
				if IsEntityPlayingAnim(PlayerPedId(), 'misslamar1dead_body', 'dead_idle', 3) or IsEntityPlayingAnim(PlayerPedId(), 'nm', 'firemans_carry', 0) then
					-- Player is dead //
				else
					TriggerServerEvent('rpuk_anticheat:a', "healthviolation3")
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while spawned == false do
		Citizen.Wait(100)
	end
	ESX.TriggerServerCallback("rpuk_anticheat:recdata", function(c)
		b = c
	end)
	while true do
		Citizen.Wait(math.random(3000,7000))
		if tonumber(b) ~= tonumber(GetNumResources()) then
			--TriggerServerEvent('rpuk_anticheat:ab', "recviol")
		end
	end
end)

RegisterNetEvent('rpuk_anticheat:rect')
AddEventHandler('rpuk_anticheat:rect', function(x)
	TriggerServerEvent('rpuk_anticheat:a', x)
end)