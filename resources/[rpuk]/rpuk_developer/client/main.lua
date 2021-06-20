local jchange = 0
RegisterCommand('f_jacket', function(playerId, args, rawCommand)
jchange = jchange + 1
SetPedComponentVariation(PlayerPedId(), 11, 203, jchange , 0)
SetPedComponentVariation(PlayerPedId(), 3, 3, 0 , 0)
SetPedComponentVariation(PlayerPedId(), 8, 2, 0 , 0)
end)

local cvchange = -1 
RegisterCommand('f_cvest', function(playerId, args, rawCommand)
cvchange = cvchange + 1
SetPedComponentVariation(PlayerPedId(), 11, 216, cvchange , 0)
SetPedComponentVariation(PlayerPedId(), 3, 11,  0, 0)
SetPedComponentVariation(PlayerPedId(), 8, 2, 0 , 0)
end)

RegisterCommand('change_livery', function(playerId, args, rawCommand)
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(PlayerId()), false)
	SetVehicleLivery(vehicle, tonumber(args[1]))
	--SetVehicleMod(vehicle, 48, args[1], false)
end)

local mjchange = -1 
RegisterCommand('m_jacket', function(playerId, args, rawCommand)
mjchange = mjchange + 1
SetPedComponentVariation(PlayerPedId(), 11, 211, mjchange , 0)
SetPedComponentVariation(PlayerPedId(), 3, 4, 0 , 0) -- arms
SetPedComponentVariation(PlayerPedId(), 8, 15, 0 , 0)
end)

local mcvchange = -1 
RegisterCommand('m_cvest', function(playerId, args, rawCommand)
mcvchange = mcvchange + 1
SetPedComponentVariation(PlayerPedId(), 11, 212, mcvchange , 0)
SetPedComponentVariation(PlayerPedId(), 3, 2,  0, 0) -- arms
SetPedComponentVariation(PlayerPedId(), 8, 15, 0 , 0)
end)

local fshoes = 0 
local flegs = 0
local wings = 0 
RegisterCommand('f_shoes', function(playerId, args, rawCommand)
	while true do
		Citizen.Wait(750)
		SetPedComponentVariation(PlayerPedId(), 6, 81, fshoes , 0)
		SetPedComponentVariation(PlayerPedId(), 4, 98, flegs , 0)
		
		SetPedComponentVariation(PlayerPedId(), 11, 254, flegs , 0)
		SetPedComponentVariation(PlayerPedId(), 3, 8, 0 , 0)
		SetPedComponentVariation(PlayerPedId(), 8, 2, 0 , 0)
		SetPedComponentVariation(PlayerPedId(), 1, 123, flegs , 0)
		SetPedComponentVariation(PlayerPedId(), 5, 67, wings, 0)
		fshoes = fshoes + 1
		if fshoes == 10 then
			fshoes = 0
		end
		flegs = flegs + 1
		if flegs == 5 then
			flegs = 0
		end
		wings = wings + 1
		if wings == 7 then
			wings = 0
		end
	end
end)

local fshoes = 0 
local flegs = 0
local wings = 0
RegisterCommand('m_shoes', function(playerId, args, rawCommand)
	while true do
		Citizen.Wait(750)
		SetPedComponentVariation(PlayerPedId(), 6, 77, fshoes , 0)
		SetPedComponentVariation(PlayerPedId(), 4, 95, flegs , 0)
		
		SetPedComponentVariation(PlayerPedId(), 11, 246, flegs , 0)
		SetPedComponentVariation(PlayerPedId(), 3, 7, 0 , 0) -- arms
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0 , 0)
		SetPedComponentVariation(PlayerPedId(), 1, 123, flegs , 0) -- mask
		SetPedComponentVariation(PlayerPedId(), 5, 67, 0 , 0)
				
		fshoes = fshoes + 1
		if fshoes == 7 then
			fshoes = 0
		end
		flegs = flegs + 1
		if flegs == 5 then
			flegs = 0
		end
	end
end)