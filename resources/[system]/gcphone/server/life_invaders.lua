local lastSearch = os.time()

ESX.RegisterServerCallback('rpuk_twitter:listTweets', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (math.floor(os.difftime(os.time(), lastSearch) / 60) >= 5) then
		MySQL.Async.fetchAll('SELECT message, rpuk_charid FROM twitter_tweets ORDER BY time DESC LIMIT 10', {
		}, function(result)
			cb(result)
		end)
	else
		xPlayer.showAdvancedNotification('Twitter', 'Location Track', 'We only accept a certain amount of requests from the police', 'CHAR_LIFEINVADER', 0)
		cb({})
	end
end)

ESX.RegisterServerCallback('rpuk_twitter:listAccounts', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT username FROM twitter_accounts WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.getIdentifier()
	}, function(result)
		cb(result)
	end)
end)

RegisterNetEvent('rpuk_twitter:lookupPlayer')
AddEventHandler('rpuk_twitter:lookupPlayer', function(characterId)
	local xTarget = ESX.GetPlayerFromCharId(characterId)
	local xPlayer = ESX.GetPlayerFromId(source)

	if math.floor(os.difftime(os.time(), lastSearch) / 60) >= 5 then
		if xTarget then
			TriggerClientEvent('rpuk_twitter:returnStreet', source, xTarget.getCoords())
			lastSearch = os.time()
		else
			xPlayer.showAdvancedNotification('Twitter', 'Location Track', 'We failed to track the tweet', 'CHAR_LIFEINVADER', 0)
		end
	else
		xPlayer.showAdvancedNotification('Twitter', 'Location Track', 'We only accept a certain amount of requests from the police', 'CHAR_LIFEINVADER', 0)
	end
end)

RegisterNetEvent('rpuk_twitter:changePassword')
AddEventHandler('rpuk_twitter:changePassword', function(username, new)
	local xPlayer = ESX.GetPlayerFromId(source)
	if username and new then
		MySQL.Async.execute('UPDATE `twitter_accounts` SET `password`= @password WHERE twitter_accounts.username = @username', {
			['@username'] = tostring(username),
			['@password'] = tostring(new),
		}, function (result)
			if (result == 1) then
				xPlayer.showAdvancedNotification('Twitter', 'Reset PW', 'We have updated your password!', 'CHAR_LIFEINVADER', 0)
			else
			  xPlayer.showAdvancedNotification('Twitter', 'Reset PW', 'We failed to update your password.', 'CHAR_LIFEINVADER', 0)
			end
		end)
	end
end)