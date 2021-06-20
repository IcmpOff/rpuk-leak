local lastCalled = 0
local packageClaimed = false
local randomSelection = nil
local timeDifference = 3601

RegisterNetEvent('rpuk_gangs:start_cocaine')
AddEventHandler("rpuk_gangs:start_cocaine", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)

	timeDifference = os.time() - tonumber(lastCalled)

	print("RPUK Gangs: Package Call Attempt " .. xPlayer.name .. " " .. xPlayer.identifier, timeDifference)

	if timeDifference >= 3600 then
		packageClaimed = false
		lastCalled = os.time()
		local timeSecs = math.random(60000,600000) -- 1 min to 20 mins
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 5000, type = 'inform', text = "I'll get Gus to give you a message!"})
		Citizen.Wait(timeSecs)
		randomSelection = math.random(1, #(Config.IslandPickups))

		local gangMembers = xGang.getMembers()
		for k, v in pairs(gangMembers) do
			local xGangMember = ESX.GetPlayerFromCharId(tonumber(k))
			if xGangMember then -- the gang member is online
				TriggerEvent('gcPhone:_internalAddMessage', "Gus (Chicken Man)", xGangMember.phoneNumber, "The package is ready at the island pick-up point. #" .. randomSelection, 0, function(object)
					TriggerClientEvent('gcPhone:receiveMessage', xGangMember.source, object)
				end)
			end
		end

		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xTarget = ESX.GetPlayerFromId(xPlayers[i])
			if xTarget.getGang() ~= 0 then
				TriggerClientEvent('rpuk_gangs:assign_cocaine', xTarget.source, randomSelection)
			end
		end

	else
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 5000, type = 'inform', text = "I'll get Gus to give you a message!"})
		Citizen.Wait(math.random(3000, 6000))

		local gusMessage = "I sent out a drug package to the island recently, I'm not fussed who gets it just process it and sell the fucking stuff!"
		if packageClaimed then
			gusMessage = ("The package was already picked up recently, try to intercept it if you want. Call me after a while and I'll get another one for you to pickup."):format()
		end

		TriggerEvent('gcPhone:_internalAddMessage', "Gus (Chicken Man)", xPlayer.phoneNumber, gusMessage, 0, function(object)
			TriggerClientEvent('gcPhone:receiveMessage', xPlayer.source, object)
		end)
	end
end)

RegisterNetEvent('rpuk_gangs:claim_crate')
AddEventHandler("rpuk_gangs:claim_crate", function(clientDumpValue)
	local xPlayer = ESX.GetPlayerFromId(source)
	print("RPUK Gangs: Package Claim Attempt " .. xPlayer.name .. " " .. xPlayer.identifier)
	if packageClaimed then
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 5000, type = 'inform', text = "Package was already claimed!"})
		TriggerClientEvent('rpuk_gangs:clearPickupCrates', -1)
		return
	end
	if clientDumpValue ~= 12200 then
		TriggerEvent('rpuk_anticheat:sab', xPlayer.source, "job_restricted")
		return
	end

	local packageDistance = #(Config.IslandPickups[randomSelection] - xPlayer.getCoords(true))
	if packageDistance < 100 then
		packageClaimed = true
		print("RPUK Gangs: Package Claimed " .. xPlayer.name .. " " .. xPlayer.identifier)
		TriggerClientEvent('rpuk_gangs:clearPickupCrates', -1)
		xPlayer.addInventoryItem('comp_drug_cocaine_unrefined', 500)
	else
		print("RPUK Gangs: " .. xPlayer.identifier .. " was too far away from the crate to be rewarded.")
	end
end)