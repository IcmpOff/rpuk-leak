local logIdsBySource = {}

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	-- Using MySQL.Async.insert to get created log id
	MySQL.Async.insert('INSERT INTO rpuk_logs_sessions (identifier, rpuk_charid, source, connect_time) VALUES (@identifier, @character_id, @source, @connect_time)', {
		['@identifier'] = xPlayer.getIdentifier(),
		['@character_id'] = xPlayer.getCharacterId(),
		['@source'] = playerId,
		['@connect_time'] = os.time(),
	}, function(newLogId)
		logIdsBySource[playerId] = newLogId -- Store session log ID for this player
	end)
end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		MySQL.Async.execute('UPDATE rpuk_logs_sessions  SET disconnect_time = @disconnect_time, disconnect_reason = @disconnect_reason WHERE id = @logId', {
			['@logId'] = logIdsBySource[playerId],
			['@disconnect_time'] = os.time(),
			['@disconnect_reason'] = reason
		}, function(rowsChanged) end)
		logIdsBySource[playerId] = nil
	end
end)
