-- ## Utalizing OneSync event calls to Monitor Server Activity
local playerCreatedEntitiesThisSecond = {}

AddEventHandler('explosionEvent', function(playerId, event) -- all networked explosions
	if ds.explosionTypes[event.explosionType] and ds.explosionTypes[event.explosionType].blacklisted then
		CancelEvent()
		sendToDiscord(false, "warning", playerId, -1, "exp_illegal")
		print(('[rpuk_anticheat] player "%s" explosion denied'):format(playerId))
	end

	if event.explosionType ~= 0 and event.explosionType ~= 13 and event.explosionType ~= 17 then
		print(('[rpuk_anticheat] player "%s" explosion "%s" denied\n%s'):format(playerId, event.explosionType, json.encode(event)))
	end

	if event.posX > 2000.0 and event.posY > 2000.0 and event.posX < 3000.0 and event.posY < 3000.0 then
		sendToDiscord(false, "warning", playerId, -1, "exp_large")
	end
end)

AddEventHandler("clearPedTasksEvent", function(playerId, data)
	local targetEntity = NetworkGetEntityFromNetworkId(data.pedId)

	if DoesEntityExist(targetEntity) and IsPedAPlayer(targetEntity) then
		local targetPlayerId = NetworkGetEntityOwner(targetEntity)
		local distanceBetweenPlayers = #(GetEntityCoords(GetPlayerPed(playerId)) - GetEntityCoords(targetEntity))
		sendToDiscord(false, "autoban", playerId, -1, "clear_ped_task", ('Target Server ID: %s\nDistance between players: %.0f units'):format(targetPlayerId, distanceBetweenPlayers))
		TriggerEvent('rpuk_anticheat:ban', playerId, {reason = 'Illegal Client', period = '0', from = "RPUK Anticheat"})
	end
end)

AddEventHandler("giveWeaponEvent", function(playerId, data) -- Ped to ped give weapon event
	CancelEvent()
	local targetEntity = NetworkGetEntityFromNetworkId(data.pedId)
	local targetPlayerId = NetworkGetEntityOwner(targetEntity)
	local extra, callType = ('Weapon Hash: %s\nAmmo: %s\nTarget player: %s'):format(data.weaponType, data.ammo, targetPlayerId), "give_weapon"

	sendToDiscord(false, "autoban", playerId, -1, callType, extra)
	local bandata = {reason = 'Illegal Client', period = '0', from = "RPUK Anticheat"}
	TriggerEvent('rpuk_anticheat:ban', playerId, bandata)
end)

AddEventHandler('entityCreated', function(entityHandle) -- blacklisted object created
	if entityHandle and DoesEntityExist(entityHandle) then
		local playerId, entityType, entityModel = NetworkGetEntityOwner(entityHandle), GetEntityType(entityHandle), GetEntityModel(entityHandle)

		if ds.bveh[entityModel] or ds.bped[entityModel] then
			CancelEvent()
		elseif ds.bobj[entityModel] then
			sendToDiscord(false, 'warning', playerId, -1, 'bl_entity_created', ('Entity Type: %s\nEntity Handle: %s\nEntity Model: %s'):format(ds.entityTypeLabels[entityType], entityHandle, entityModel))
			--DeleteEntity(entityHandle)
			CancelEvent()
		end
	end
end)

AddEventHandler('entityCreating', function(entityHandle) -- blacklisted vehicle & ped creation
	if entityHandle and DoesEntityExist(entityHandle) then
		local playerId, entityType, entityModel = NetworkGetEntityOwner(entityHandle), GetEntityType(entityHandle), GetEntityModel(entityHandle)

		if ds.bveh[entityModel] or ds.bped[entityModel] then
			CancelEvent()
		elseif ds.bobj[entityModel] then
			sendToDiscord(false, 'warning', playerId, -1, 'bl_entity_denied_creation', ('Entity Type: %s\nEntity Handle: %s\nEntity Model: %s'):format(ds.entityTypeLabels[entityType], entityHandle, entityModel))
			--DeleteEntity(entityHandle)
			CancelEvent()
		end

		if (entityType == 2 or entityType == 3) and not ds.whitelistedentites[entityModel] then
			if not playerCreatedEntitiesThisSecond[playerId] then playerCreatedEntitiesThisSecond[playerId] = 0 end
			playerCreatedEntitiesThisSecond[playerId] = playerCreatedEntitiesThisSecond[playerId] + 1
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		for playerId,numberOfEntities in pairs(playerCreatedEntitiesThisSecond) do
			if numberOfEntities >= ds.maxEntitesCreatedPerSecond then
				sendToDiscord(false, 'warning', playerId, -1, 'player_entity_limit', ('Number of entities this second: %s'):format(numberOfEntities))
			end

			playerCreatedEntitiesThisSecond[playerId] = nil
		end
	end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason) playerCreatedEntitiesThisSecond[playerId] = nil end)