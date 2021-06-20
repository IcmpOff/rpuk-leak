local fishing = false
local pause = false
local pausetimer = 0
local correct = 0
local bait = "none"
local input

Citizen.CreateThread(function()
	while true do
		Wait(600)
		if pause and fishing then
			pausetimer = pausetimer + 1
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(5)

		if fishing then
			if IsControlJustReleased(0, 157) then
				input = 1
			end
			if IsControlJustReleased(0, 158) then
				input = 2
			end
			if IsControlJustReleased(0, 160) then
				input = 3
			end
			if IsControlJustReleased(0, 108) then
				input = 4
			end
			if IsControlJustReleased(0, 110) then
				input = 5
			end
			if IsControlJustReleased(0, 107) then
				input = 6
			end
			if IsControlJustReleased(0, 117) then
				input = 7
			end
			if IsControlJustReleased(0, 111) then
				input = 8
			end

			if IsControlJustReleased(0, 38) then
				fishing = false
				ESX.ShowNotification("Stopped fishing")
					ClearPedTasks(PlayerPedId())
			end
			if fishing then
				playerPed = PlayerPedId()
				local pos = GetEntityCoords(PlayerPedId())
				if pos.y >= 7700 or pos.y <= -4000 or pos.x <= -3700 or pos.x >= 4300 or IsPedInAnyVehicle(PlayerPedId()) then
				else
					fishing = false
					ESX.ShowNotification("Stopped fishing")
				end
				if IsEntityDead(playerPed) or IsEntityInWater(playerPed) then
					ESX.ShowNotification("Stopped fishing")
				end
			end

			if pausetimer > 3 then
				input = 99
			end

			if pause and input ~= 0 then
				pause = false
				if input == correct then
					TriggerServerEvent('fishing:catch', bait)
				else
					ESX.ShowNotification("Fish got free")
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = math.random(Config.Fishing.FishTime.a , Config.Fishing.FishTime.b)
		Wait(wait)
		if fishing then
			pause = true
			correct = math.random(4,8)
			ESX.ShowNotification("Fish is taking the bait \n Press Numpad" .. correct .. " to catch it")
			input = 0
			pausetimer = 0
			DisableControlAction(0,288,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,105,true)
			DisableControlAction(0,120,true)
			DisableControlAction(0,154,true)
			DisableControlAction(0,186,true)
			DisableControlAction(0,252,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,170,true)
			DisableControlAction(0,305,true)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('fishing:break')
AddEventHandler('fishing:break', function()
	fishing = false
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('fishing:spawnPed')
AddEventHandler('fishing:spawnPed', function()

	RequestModel( GetHashKey( "A_C_SharkTiger" ) )
		while ( not HasModelLoaded( GetHashKey( "A_C_SharkTiger" ) ) ) do
			Citizen.Wait( 1 )
		end
	local pos = GetEntityCoords(PlayerPedId())

	local ped = CreatePed(29, 0x06C3F072, pos.x, pos.y, pos.z, 90.0, true, false)
	SetEntityHealth(ped, 0)
end)

RegisterNetEvent('fishing:setbait')
AddEventHandler('fishing:setbait', function(bool)
	bait = bool
	print(bait)
end)

RegisterNetEvent('fishing:fishstart')
AddEventHandler('fishing:fishstart', function()
	playerPed = PlayerPedId()
	local pos = GetEntityCoords(PlayerPedId())
	print('started fishing' .. pos)
	if IsPedInAnyVehicle(playerPed) then
		ESX.ShowNotification("You can not fish from a vehicle")
	else
		if pos.y >= 7700 or pos.y <= -4000 or pos.x <= -3700 or pos.x >= 4300 then
			ESX.ShowNotification("Fishing started - Press E again to stop fishing")
			TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_FISHING", 0, true)
			fishing = true
		else
			ClearPedTasks(PlayerPedId())
			ESX.ShowNotification("You need to go further away from the shore")
		end
	end
end, false)