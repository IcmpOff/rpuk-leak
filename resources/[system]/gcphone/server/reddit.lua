function TchatGetMessageChannel(channel, cb)
	MySQL.Async.fetchAll('SELECT * FROM phone_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100', { 
		['@channel'] = channel
	}, cb)
end

function TchatAddMessage(channel, message)
	MySQL.Async.insert('INSERT INTO phone_app_chat (`channel`, `message`) VALUES (@channel, @message)', {
		['@channel'] = channel,
		['@message'] = message
	}, function(id)
		MySQL.Async.fetchAll('SELECT * FROM phone_app_chat WHERE `id` = @id', {
			['@id'] = id
		}, function(reponse)
			TriggerClientEvent('gcPhone:tchat_receive', -1, reponse[1])
		end)
	end)
end

RegisterNetEvent('gcPhone:tchat_channel')
AddEventHandler('gcPhone:tchat_channel', function(channel)
	local sourcePlayer = tonumber(source)
	TchatGetMessageChannel(channel, function (messages)
		TriggerClientEvent('gcPhone:tchat_channel', sourcePlayer, channel, messages)
	end)
end)

RegisterNetEvent('gcPhone:tchat_addMessage')
AddEventHandler('gcPhone:tchat_addMessage', function(channel, message)
	TchatAddMessage(channel, message)
end)