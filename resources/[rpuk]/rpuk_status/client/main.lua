local spawned = false
local Status = {}
math.randomseed(GetGameTimer() + GetRandomIntInRange(-1000, 1000))

Citizen.CreateThread(function()
	while not spawned do
		Citizen.Wait(100)
	end

	if ESX.Player.GetIsPlayerDead() == true then
		TriggerEvent('esx_basicneeds:resetStatus')
	end
end)

function GetStatusData()
	local status = {}

	for k,v in ipairs(Status) do
		table.insert(status, {
			name = v.name,
			val = v.val,
			percent = v.getPercent()
		})
	end

	return status
end

RegisterNetEvent('rpuk:spawned')
AddEventHandler('rpuk:spawned', function()
	spawned = true
end)

AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('esx_status:set', 'hunger', 100)
	TriggerEvent('esx_status:set', 'thirst', 100)
end)

RegisterNetEvent('esx_basicneeds:healPlayer')
AddEventHandler('esx_basicneeds:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('esx_status:set', 'hunger', 100)
	TriggerEvent('esx_status:set', 'thirst', 100)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('esx_status:loaded', function()
	--- Removes Health Amount
	TriggerEvent('esx_status:registerStatus', 'hunger', 100, function(status)
		if status.val == 1 then ESX.ShowNotification('You are starving!', 5000, 'error') end
		if status.val == 10 then ESX.ShowNotification('You are very hungry, if you don\'t find something to eat soon you will starve', 5000, 'error') end
		if status.val == 20 then ESX.ShowNotification('You are getting hungry') end
		if status.val == 30 then ESX.ShowNotification('You could do with a snack') end
		if status.val == 40 then ESX.ShowNotification('You could do with a snack') end
		status.remove(1)
	end)

	TriggerEvent('esx_status:registerStatus', 'thirst', 100, function(status)
		if status.val == 1 then ESX.ShowNotification('You are starving from dehydration!', 5000, 'error') end
		if status.val == 10 then ESX.ShowNotification('You are gasping for something to drink', 5000, 'error') end
		if status.val == 20 then ESX.ShowNotification('You are getting thirsty') end
		if status.val == 30 then ESX.ShowNotification('You need a drink') end
		if status.val == 40 then ESX.ShowNotification('You need a drink') end
		status.remove(1)
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			local playerPed = PlayerPedId()
			local prevHealth = GetEntityHealth(playerPed)
			local health = prevHealth
			local dead = exports.rpuk_health:deadStatus()

			if not dead then
				TriggerEvent('esx_status:getStatus', 'hunger', function(status)
					if status.val == 0 then health = health - 1 end
				end)

				TriggerEvent('esx_status:getStatus', 'thirst', function(status)
					if status.val == 0 then health = health - 1 end
				end)

				if health ~= prevHealth then
					ApplyDamageToPed(playerPed, prevHealth - health, false)
				end
			end
		end
	end)
end)

AddEventHandler('esx_status:registerStatus', function(name, default, tickCallback)
	local status = CreateStatus(name, default, tickCallback)
	table.insert(Status, status)
end)

AddEventHandler('esx_status:unregisterStatus', function(name)
	for k,v in ipairs(Status) do
		if v.name == name then
			table.remove(Status, k)
			break
		end
	end
end)

RegisterNetEvent('esx_status:load')
AddEventHandler('esx_status:load', function(status)
	if status then
		for k,v in ipairs(Status) do
			if status[v.name] then
				v.set(status[v.name])
			end
		end
	end

	Citizen.CreateThread(function()
		while true do
			for i=1, #Status, 1 do
				Status[i].onTick()
			end

			TriggerEvent('esx_status:onTick', GetStatusData())
			Citizen.Wait(Config.TickTime)
		end
	end)
end)

RegisterNetEvent('esx_status:set')
AddEventHandler('esx_status:set', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].set(val)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData())
end)

RegisterNetEvent('esx_status:add')
AddEventHandler('esx_status:add', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].add(val)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData())
end)

RegisterNetEvent('esx_status:remove')
AddEventHandler('esx_status:remove', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].remove(val)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData())
end)

AddEventHandler('esx_status:getStatus', function(name, cb)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			cb(Status[i])
			return
		end
	end
end)

Citizen.CreateThread(function() TriggerEvent('esx_status:loaded') end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(getInterval(Config.SyncInterval))
		local minimalData = {}
		for k,v in ipairs(GetStatusData()) do minimalData[v.name] = v.val end
		TriggerServerEvent('esx_status:update', minimalData)
	end
end)

function getInterval(number)
	local plus = math.random(1,2)
	local offset = math.random(1, 100)
	if plus == 1 then return number + offset*1000
	else return number - offset*1000 end
end
