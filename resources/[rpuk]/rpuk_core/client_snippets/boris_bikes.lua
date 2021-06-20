local active_bike = false

local locations = {
	{text = "Press [~b~E~s~] To Rent\n~y~Boris Bike", vehicle = "cruiser", location = vector3(-1017.039, -2689.723, 12.990)}, -- Airport
	{text = "Press [~b~E~s~] To Rent\n~y~Boris Bike", vehicle = "cruiser", location = vector3(-537.118, -307.369, 34.212)}, -- City Hall
	{text = "Press [~b~E~s~] To Rent\n~y~Boris Bike", vehicle = "cruiser", location = vector3(-202.566, -1005.576, 28.146)}, -- Train Station
	{text = "Press [~b~E~s~] To Rent\n~y~Boris Bike", vehicle = "cruiser", location = vector3(-1642.636, -1022.770, 12.152)}, -- Pier
	{text = "Press [~b~E~s~] To Rent\n~y~Boris Bike", vehicle = "cruiser", location = vector3(-2192.987, 4253.681, 47.081)}, -- West highway
	{text = "Press [~b~E~s~] To Rent\n~y~Boris Bike", vehicle = "cruiser", location = vector3(2687.176, 3290.950, 54.241)}, -- Grand Senora Desert
	{text = "Press [~b~E~s~] To Rent\n~y~Boris Bike", vehicle = "cruiser", location = vector3(3794.203, 4449.562, 3.852)}, -- Fishing 1
	{text = "Press [~b~E~s~] To Rent\n~y~Boris Bike", vehicle = "cruiser", location = vector3(-3254.177, 994.709, 11.457)}, -- Fishing 2
	{text = "Press [~b~E~s~] To Rent\n~y~Boris Bike", vehicle = "cruiser", location = vector3(-1572.551, 5169.472, 18.548)}, -- Fishing 3
	{text = "Press [~b~E~s~] To Rent\n~y~Boris Bike", vehicle = "cruiser", location = vector3(-778.074, 5588.242, 32.486)}, -- Hunting Shack
	{text = "Press [~b~E~s~] To Rent\n~y~Boris Bike", vehicle = "cruiser", location = vector3(288.569, -613.879, 42.394)}, -- Hospital


	{text = "Press [~b~E~s~] To Rent\n~y~Quad", vehicle = "verus", location = vector3(5036.479, -4623.665, 2.733)}, -- Island Dock 1
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local canSleep = true
		for k, data in pairs(locations) do
			local distance = #(coords - data.location)
			if distance < 20 then
				canSleep = false
				DrawMarker(1, data.location, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
				if distance < 1.5 then
					local textpos = vector3(data.location.x, data.location.y, data.location.z + 2.0)
					ESX.Game.Utils.DrawText3D(textpos, data.text, 0.8, 6)
					if IsControlJustReleased(0, 38) and not active_bike then
						active_bike = true
						ESX.Game.SpawnVehicle(data.vehicle, GetEntityCoords(playerPed), 303.20, function(vehicle)
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						end)
					elseif IsControlJustReleased(0, 38) and active_bike and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), GetHashKey(data.vehicle)) then
						DeleteEntity(GetVehiclePedIsIn(playerPed, false))
						active_bike = false
					end
				end
			end
		end
		if canSleep then
			Citizen.Wait(3000)
		end
	end
end)