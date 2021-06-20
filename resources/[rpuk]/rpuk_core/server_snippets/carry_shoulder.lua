local playersCarrying, playersBeingCarried, playersCarryRequest = {}, {}, {}

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if playersCarrying[playerId] then
		stopCarry(playerId)
	elseif playersBeingCarried[playerId] then
		local carrier = playersBeingCarried[playerId]
		stopCarry(carrier)
	elseif playersCarryRequest[playerId] then
		playersCarryRequest[playerId] = nil
	end
end)

RegisterNetEvent('rpuk_carry:acceptCarry')
AddEventHandler('rpuk_carry:acceptCarry', function()
	if not playersCarrying[source] and not playersBeingCarried[source] and playersCarryRequest[source] then
		local carrier = playersCarryRequest[source]

		TriggerClientEvent('rpuk_carry:startCarryMe', carrier)
		TriggerClientEvent('rpuk_carry:startCarryPlayer', source, carrier)
		playersCarrying[carrier] = source
		playersBeingCarried[source] = carrier
		playersCarryRequest[source] = nil
	end
end)

RegisterNetEvent('rpuk_carry:requestCarryingPlayer')
AddEventHandler('rpuk_carry:requestCarryingPlayer', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if GetPlayerName(target) and not playersCarrying[source] and not playersBeingCarried[source] and not playersCarrying[target] and not playersBeingCarried[target] and not playersCarryRequest[target] then
		playersCarryRequest[target] = source
		TriggerClientEvent('rpuk_carry:requestCarry', target, source)
		xPlayer.showNotification('You have asked to carry the person', 5000, 'inform', 'longnotif')
	else
		xPlayer.showNotification('Player carry request failed', 5000, 'inform', 'error')
	end
end)

RegisterNetEvent('rpuk_carry:reviveStop')
AddEventHandler('rpuk_carry:reviveStop', function(target)
	TriggerClientEvent('rpuk_carry:stopCarry', target)
end)

RegisterNetEvent('rpuk_carry:stopCarry')
AddEventHandler('rpuk_carry:stopCarry', function() stopCarry(source) end)

RegisterNetEvent('rpuk_carry:declineCarry')
AddEventHandler('rpuk_carry:declineCarry', function() playersCarryRequest[source] = nil end)

function stopCarry(playerId)
	if playersCarrying[playerId] then
		local playerBeingCarried = playersCarrying[playerId]
		if GetPlayerName(playerId) then TriggerClientEvent('rpuk_carry:stopCarry', playerId) end
		if GetPlayerName(playerBeingCarried) then TriggerClientEvent('rpuk_carry:stopCarry', playerBeingCarried) end
		playersBeingCarried[playerBeingCarried] = nil
		playersCarrying[playerId] = nil
	elseif playersBeingCarried[playerId] then
		stopCarry(playersBeingCarried[playerId])
	end
end