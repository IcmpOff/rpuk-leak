local harvestZoneIndexPlayerIsNear, isBusy, pickaxeObject = false, false, nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords, letSleep = GetEntityCoords(PlayerPedId()), true

		for k,v in ipairs(Config.Harvesting.HarvestingZone) do
			local distance = #(coords - v.Marker)

			if distance < Config.Harvesting.SpawnDistance then
				letSleep = false
				harvestZoneIndexPlayerIsNear = k -- interaction data

				if ESX.Table.SizeOf(v.ObjectHandles) < v.SpawnObjectMaxCount then -- the max quantity is less than the current count for the object / spawn a new one
					local objectCoords = GenerateObjectCoords(k)

					ESX.Game.SpawnLocalObject(v.SpawnObject, objectCoords, function(entityHandle)
						PlaceObjectOnGroundProperly(entityHandle)
						FreezeEntityPosition(entityHandle, true)
						v.ObjectHandles[entityHandle] = true
					end)
				else
					letSleep = true
				end
			else
				if localTableCount(v.ObjectHandles) > 0 then -- If the count is higher than 0 then remove them as no longer in range
					harvestZoneIndexPlayerIsNear = nil -- reset
					for entity,v2 in pairs(v.ObjectHandles) do
						DeleteEntity(entity)
						v.ObjectHandles[entity] = nil
					end
				end
			end
		end

		if letSleep then Citizen.Wait(500) end
	end
end)

function localTableCount(t)
	local count = 0

	for _,_ in pairs(t) do
		count = count + 1
	end

	return count
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local letSleep, nearbyObject = true

		if harvestZoneIndexPlayerIsNear then
			local coords = GetEntityCoords(PlayerPedId())
			local zone = Config.Harvesting.HarvestingZone[harvestZoneIndexPlayerIsNear]

			for entityHandle,v in pairs(zone.ObjectHandles) do
				if #(coords - GetEntityCoords(entityHandle)) < 2 then
					nearbyObject = entityHandle
					break
				end
			end

			if nearbyObject and not isBusy then
				letSleep = false
				ESX.ShowHelpNotification(zone.HelpNotification, true)

				if IsControlJustReleased(0, 38) then
					isBusy = true

					ESX.TriggerServerCallback('rpuk_harvesting:startHarvesting', function(success)
						if success then
							if zone.createPickaxe then
								ESX.Game.SpawnObject('prop_tool_pickaxe', {x = 0, y = 0, z = 0}, function(object)
									local playerPed = PlayerPedId()
									local boneIndex = GetPedBoneIndex(playerPed, 57005)
									local position = vector3(0.1, -0.02, -0.02)
									local rotation = vector3(90.0, 170.0, 220.0)
									AttachEntityToEntity(object, playerPed, boneIndex, position, rotation, true, true, false, true, 1, true)
									pickaxeObject = object
								end)
							end

							TriggerEvent("mythic_progbar:client:progress", {
								name = "Harvesting",
								duration = zone.Timer * 1000,
								label = "Harvesting",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true},
								animation = {animDict = zone.AnimLib, anim = zone.Task, flags = 1, task = nil},
							}, function(canceled)
								isBusy = false

								if pickaxeObject then
									DetachEntity(pickaxeObject, true, true)
									ESX.Game.DeleteEntity(pickaxeObject)
									pickaxeObject = nil
								end

								if canceled then
									TriggerServerEvent('rpuk_harvesting:cancelHarvesting')
								else
									ESX.Game.DeleteEntity(nearbyObject)
									zone.ObjectHandles[nearbyObject] = nil
								end
							end)
						else
							isBusy = false
						end
					end, harvestZoneIndexPlayerIsNear)
				end
			end
		end

		if letSleep then Citizen.Wait(500) end
	end
end)

function GenerateObjectCoords(zoneIndex)
	local objectCoordX, objectCoordY, modX, modY
	local zone = Config.Harvesting.HarvestingZone[zoneIndex]
	local retCoords = zone.Marker

	modX = math.random(-zone.RadiusVar, zone.RadiusVar)
	modY = math.random(-zone.RadiusVar, zone.RadiusVar)

	objectCoordX, objectCoordY = retCoords.x + modX, retCoords.y + modY

	local coordZ = GetCoordZ(retCoords.z, objectCoordX, objectCoordY)
	local coord = vector3(objectCoordX, objectCoordY, coordZ)

	return coord
end

function GetCoordZ(initial, x, y)
	local groundCheckHeights = {initial+0, initial+1, initial+2, initial+3, initial+4, initial+5, initial+6, initial+7, initial+8, initial+9, initial+10}

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end

	return initial -- fallback
end

AddEventHandler('onResourceStop', function(resource) -- Delete entity if resource stops
	if resource == GetCurrentResourceName() then
		for k,v in ipairs(Config.Harvesting.HarvestingZone) do
			for entityHandle,v in pairs(v.ObjectHandles) do
				ESX.Game.DeleteEntity(entityHandle)
			end
		end

		if pickaxeObject and DoesEntityExist(pickaxeObject) then
			DetachEntity(pickaxeObject, true, true)
			ESX.Game.DeleteEntity(pickaxeObject)
		end
	end
end)