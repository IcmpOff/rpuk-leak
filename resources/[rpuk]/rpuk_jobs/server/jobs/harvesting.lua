local playersInHarvest = {}

ESX.RegisterServerCallback('rpuk_harvesting:startHarvesting', function(playerId, cb, harvestZoneIndex)
	local zone = Config.Harvesting.HarvestingZone[harvestZoneIndex]

	if zone then
		-- decoy, ban player!
		if zone.hidden then
			TriggerEvent('rpuk_anticheat:sab', playerId, 'decoy_harvest')
			cb(false)
		else
			local xPlayer = ESX.GetPlayerFromId(playerId)
			local distance = #(xPlayer.getCoords(true) - zone.Marker)

			if distance < Config.Harvesting.SpawnDistance then
				if zone.RequiresItem then
					if xPlayer.hasItem(zone.RequiresItem) then
						playersInHarvest[playerId] = {timeStart = os.clock(), harvestZoneIndex = harvestZoneIndex}
						cb(true)
					else
						xPlayer.showNotification(('You must have a %s'):format(ESX.GetItemLabel(zone.RequiresItem)))
						cb(false)
					end
				else
					playersInHarvest[playerId] = {timeStart = os.clock(), harvestZoneIndex = harvestZoneIndex}
					cb(true)
				end
			else
				print('[rpuk_harvesting] denied startHarvesting for a player')
				cb(false)
			end
		end
	else
		cb(false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local timeNow = os.clock()

		for playerId,data in pairs(playersInHarvest) do
			Citizen.Wait(10)
			local xPlayer = ESX.GetPlayerFromId(playerId)

			-- Is player online?
			if xPlayer then
				local zone = Config.Harvesting.HarvestingZone[data.harvestZoneIndex]
				local distance = #(xPlayer.getCoords(true) - zone.Marker)

				-- Is player still in the zone?
				if distance < Config.Harvesting.SpawnDistance then
					local timeSpent = timeNow - data.timeStart

					-- Player has spent active seconds
					if timeSpent >= zone.Timer then
						for item,quant in pairs(zone.Output) do
							local chance = math.random(1,100)

							if zone.OutRandom then
								quant = math.random(quant-2,quant+2)
							end

							if xPlayer.canCarryItem(item, quant) then
								xPlayer.addInventoryItem(item, quant)
								print(('[rpuk_harvesting] "%s" harvested item'):format(xPlayer.getIdentifier()))
							else
								xPlayer.showNotification('You cannot carry what you were harvesting, free up some inventory space')
							end

							if zone.RareObj and chance > 90 then
								if xPlayer.canCarryItem(zone.RareObj, 1) then
									xPlayer.addInventoryItem(zone.RareObj, 1)
									print(('[rpuk_harvesting] "%s" harvested rare item'):format(xPlayer.getIdentifier()))
								end
							end
						end

						playersInHarvest[playerId] = nil
					end
				else
					-- Player left zone, cancel animation and remove from active table
					playersInHarvest[playerId] = nil
				end
			else
				-- Player not online, remove from active table
				playersInHarvest[playerId] = nil
			end
		end
	end
end)

RegisterNetEvent('rpuk_harvesting:cancelHarvesting')
AddEventHandler('rpuk_harvesting:cancelHarvesting', function() playersInHarvest[source] = nil end)

AddEventHandler('playerDropped', function(reason) playersInHarvest[source] = nil end)