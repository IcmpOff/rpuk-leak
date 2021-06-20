local DamageNeeded = 100.0
local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)

local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}

Citizen.CreateThread(function()
	Citizen.Wait(200)
	while true do
		local ped = PlayerPedId()
		local closestVehicle, Distance = ESX.Game.GetClosestVehicle()
		local vehicleCoords = GetEntityCoords(closestVehicle)
		local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
		if Distance < 4.5  and not IsPedInAnyVehicle(ped, false) and not IsPedDeadOrDying(ped, true) and not IsPedRagdoll(ped) and not IsEntityPlayingAnim(ped, 'misslamar1dead_body', 'dead_idle', 3) then
			Vehicle.Coords = vehicleCoords
			Vehicle.Dimensions = dimension
			Vehicle.Vehicle = closestVehicle
			Vehicle.Distance = Distance
			local ped_coords = GetEntityCoords(ped)
			if GetDistanceBetweenCoords(vehicleCoords + GetEntityForwardVector(closestVehicle), ped_coords, true) > GetDistanceBetweenCoords(vehicleCoords + GetEntityForwardVector(closestVehicle) * -1, ped_coords, true) then
				Vehicle.IsInFront = false
			else
				Vehicle.IsInFront = true
			end
		else
			Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
		end
		Citizen.Wait(2000)
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local ped = PlayerPedId()

		local VehicleClass = GetVehicleClass(Vehicle.Vehicle) -- 14 boat

		if Vehicle.Vehicle ~= nil then
			if IsVehicleSeatFree(Vehicle.Vehicle, -1) and GetVehicleEngineHealth(Vehicle.Vehicle) <= DamageNeeded then
				ESX.Game.Utils.DrawText3D({x = Vehicle.Coords.x, y = Vehicle.Coords.y, z = Vehicle.Coords.z}, 'Press [~g~SHIFT~w~] and [~g~E~w~] to push the vehicle', 0.4)
			end

			if IsControlPressed(0, 21) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and IsControlJustPressed(0, 38)  and GetVehicleEngineHealth(Vehicle.Vehicle) <= DamageNeeded and not IsPedDeadOrDying(ped, true) and not IsPedRagdoll(ped) and not IsEntityPlayingAnim(PlayerPedId(), 'misslamar1dead_body', 'dead_idle', 3) then
				NetworkRequestControlOfEntity(Vehicle.Vehicle)
				local coords = GetEntityCoords(ped)

				if VehicleClass == 14 then
					if Vehicle.IsInFront then
						AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.35, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
					else
						AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.35, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
					end
				else
					if Vehicle.IsInFront then
						AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
					else
						AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
					end
				end
				ESX.Streaming.RequestAnimDict('missfinale_c2ig_11')
				TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
				Citizen.Wait(200)

				local currentVehicle = Vehicle.Vehicle
				while true do
					Citizen.Wait(5)

					if VehicleClass == 14 then
						if IsDisabledControlPressed(0, 34) then
							TaskVehicleTempAction(PlayerPedId(), currentVehicle, 11, 20)
						end

						if IsDisabledControlPressed(0, 9) then
							TaskVehicleTempAction(PlayerPedId(), currentVehicle, 10, 20)
						end
					else
						if IsDisabledControlPressed(0, 34) then
							TaskVehicleTempAction(PlayerPedId(), currentVehicle, 11, 1000)
						end

						if IsDisabledControlPressed(0, 9) then
							TaskVehicleTempAction(PlayerPedId(), currentVehicle, 10, 1000)
						end
					end

					if Vehicle.IsInFront then
						SetVehicleForwardSpeed(currentVehicle, -1.0)
					else
						SetVehicleForwardSpeed(currentVehicle, 1.0)
					end

					if HasEntityCollidedWithAnything(currentVehicle) and VehicleClass ~= 14 then
						SetVehicleOnGroundProperly(currentVehicle)
					end

					if not IsDisabledControlPressed(0, 38) then
						DetachEntity(ped, false, false)
						StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
						FreezeEntityPosition(ped, false)
						break
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)