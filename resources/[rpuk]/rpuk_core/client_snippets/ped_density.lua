local def_density, par_density, playerCount, playerCoords = 0.1, 0.1, 0, nil
local event = false

local ped_vars = {
	{location = vector3(411.430, -992.314, 28.412), radius = 200, density = 0.1}, -- MRPD
	{location = vector3(234.824, -840.496, 30.045), radius = 200, density = 0.1}, -- Legion Square
	{location = vector3(1745.966, 3755.517, 32.928), radius = 200, density = 0.1}, -- Sandy Shores
	{location = vector3(-158.261, 1014.6, 232.1761), radius = 200, density = 0.0}, -- Housing Estate
	{location = vector3(322.26135253906, -2013.2398681641, 20.444511413574), radius = 200, density = 0.5}, -- Yellow Gang Turf
	{location = vector3(-2.2021136283875,-1367.9722900391, 28.364635467529), radius = 200, density = 0.5, parked_density = 0.0}, -- CarWash Gang Turf
	{location = vector3(62.609180450439, -1904.0269775391, 20.699356079102), radius = 200, density = 0.5, parked_density = 0.0}, -- GroveSt Gang Turf
	{location = vector3(1325.1997070313, -1623.0732421875, 51.278232574463), radius = 200, density = 0.5}, -- OilCity Gang Turf
	{location = vector3(1528.9541015625, 3611.0673828125, 34.366630554199), radius = 200, density = 0.5}, -- Blue Sandy Motel Gang Turf

	{location = vector3(390.24319458008, 787.78210449219, 186.4642791748), radius = 300, density = 0.4}, -- Hunting Lodge
	{location = vector3(-942.90173339844, 4837.0698242188, 310.67001342773	), radius = 300, density = 0.4}, -- Hunting Lodge
}

Citizen.CreateThread(function()
	while not playerCoords do
		Citizen.Wait(1000)
	end
	while true do
		Citizen.Wait(0)
		if not event then -- let the event script handle ped population if event is active
			for i=1, #ped_vars, 1 do
				if #(playerCoords - ped_vars[i].location) < ped_vars[i].radius then
					def_density = ped_vars[i].density
					if ped_vars[i].parked_density then
						par_density = ped_vars[i].parked_density
					else
						par_density = def_density
					end
					break
				else
					if playerCount <= 40 then
						def_density = def_density * 2
					end
				end
			end

			SetVehicleDensityMultiplierThisFrame(def_density)
			SetPedDensityMultiplierThisFrame(def_density)
			SetRandomVehicleDensityMultiplierThisFrame(def_density)
			SetParkedVehicleDensityMultiplierThisFrame(par_density)
			SetScenarioPedDensityMultiplierThisFrame(def_density, def_density)

			StartAudioScene('CHARACTER_CHANGE_IN_SKY_SCENE')
			SetGarbageTrucks(false)
			SetRandomBoats(false)
			SetCreateRandomCops(false)
			SetCreateRandomCopsNotOnScenarios(false)
			SetCreateRandomCopsOnScenarios(false)
			ClearAreaOfCops(playerCoords.x, playerCoords.y, playerCoords.z, 350.0)
		end
	end
end)

-- Random helicopter dropping out of the sky

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

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

Citizen.CreateThread(function()
	while true do
		for veh in EnumerateVehicles() do
			local class = GetVehicleClass(veh)
			if class == 15 or class == 16 or veh == 'polmav' then
				if IsVehicleSeatFree(veh, -1) and IsEntityInAir(veh) then
					SetEntityAsMissionEntity(veh, 1, 1)
					DeleteEntity(veh)
				end
			end
		end
		Citizen.Wait(2000)
		playerCount = Tablelength(GetActivePlayers())
		playerCoords = GetEntityCoords(PlayerPedId())
	end
end)

function Tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

-- Event listeners

RegisterNetEvent('rpuk_halloween:purge_start')
AddEventHandler('rpuk_halloween:purge_start', function()
	event = true
end)

RegisterNetEvent('rpuk_halloween:purge_stop')
AddEventHandler('rpuk_halloween:purge_stop', function()
	event = false
end)