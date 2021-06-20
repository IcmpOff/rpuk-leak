function TwitterGetTweets(accountId, cb)
	if accountId == nil then
		MySQL.Async.fetchAll([===[
			SELECT twitter_tweets.*,
				twitter_accounts.username as author,
				twitter_accounts.avatar_url as authorIcon,
				twitter_accounts.verified as verified
			FROM twitter_tweets
				LEFT JOIN twitter_accounts
				ON twitter_tweets.authorId = twitter_accounts.id
			ORDER BY time DESC LIMIT 130
			]===], {}, cb)
	else
		MySQL.Async.fetchAll([===[
			SELECT twitter_tweets.*,
				twitter_accounts.username as author,
				twitter_accounts.avatar_url as authorIcon,
				twitter_accounts.verified as verified,
				twitter_likes.id AS isLikes
			FROM twitter_tweets
				LEFT JOIN twitter_accounts
					ON twitter_tweets.authorId = twitter_accounts.id
				LEFT JOIN twitter_likes
					ON twitter_tweets.id = twitter_likes.tweetId AND twitter_likes.authorId = @accountId
			ORDER BY time DESC LIMIT 130
		]===], { ['@accountId'] = accountId }, cb)
	end
end

function TwitterGetFavotireTweets (accountId, cb)
	if accountId == nil then
		MySQL.Async.fetchAll([===[
			SELECT twitter_tweets.*,
				twitter_accounts.username as author,
				twitter_accounts.avatar_url as authorIcon,
				twitter_accounts.verified as verified
			FROM twitter_tweets
				LEFT JOIN twitter_accounts
					ON twitter_tweets.authorId = twitter_accounts.id
			WHERE twitter_tweets.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
			ORDER BY likes DESC, TIME DESC LIMIT 30
		]===], {}, cb)
	else
		MySQL.Async.fetchAll([===[
			SELECT twitter_tweets.*,
				twitter_accounts.username as author,
				twitter_accounts.avatar_url as authorIcon,
				twitter_accounts.verified as verified,
				twitter_likes.id AS isLikes
			FROM twitter_tweets
				LEFT JOIN twitter_accounts
					ON twitter_tweets.authorId = twitter_accounts.id
				LEFT JOIN twitter_likes
					ON twitter_tweets.id = twitter_likes.tweetId AND twitter_likes.authorId = @accountId
			WHERE twitter_tweets.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
			ORDER BY likes DESC, TIME DESC LIMIT 30
		]===], { ['@accountId'] = accountId }, cb)
	end
end

function getUser(username, password, cb)
	MySQL.Async.fetchAll("SELECT id, username as author, avatar_url as authorIcon FROM twitter_accounts WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password", {
		['@username'] = username,
		['@password'] = password
	}, function (data)
		cb(data[1])
	end)
end

function TwitterPostTweet(username, password, message, sourcePlayer, playerIdentifier, playerCharacterId, cb)
	getUser(username, password, function(user)
		if not user then
			if sourcePlayer then
				TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
			end

			return
		end

		MySQL.Async.insert("INSERT INTO twitter_tweets (`authorId`, `message`, `realUser`, `rpuk_charid`) VALUES(@authorId, @message, @realUser, @rpuk_charid)", {
			['@authorId'] = user.id,
			['@message'] = message,
			['@realUser'] = playerIdentifier, -- deprecated
			['@rpuk_charid'] = playerCharacterId
		}, function(id)
			MySQL.Async.fetchAll('SELECT * from twitter_tweets WHERE id = @id', {
				['@id'] = id
			}, function(tweets)
				tweet = tweets[1]
				tweet['author'] = user.author
				tweet['authorIcon'] = user.authorIcon
				TriggerClientEvent('gcPhone:twitter_newTweet', -1, tweet)
				TriggerEvent('gcPhone:twitter_newTweet', tweet, sourcePlayer)
			end)
		end)
	end)
end

function TwitterToogleLike(username, password, tweetId, sourcePlayer)
	getUser(username, password, function(user)
		if not user then
			if sourcePlayer then
				TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
			end

			return
		end

		MySQL.Async.fetchAll('SELECT * FROM twitter_tweets WHERE id = @id', {
			['@id'] = tweetId
		}, function(tweets)
			if not tweets[1] then return end
			local tweet = tweets[1]
			MySQL.Async.fetchAll('SELECT * FROM twitter_likes WHERE authorId = @authorId AND tweetId = @tweetId', {
				['authorId'] = user.id,
				['tweetId'] = tweetId
			}, function(row)
				if not row[1] then
					MySQL.Async.insert('INSERT INTO twitter_likes (`authorId`, `tweetId`) VALUES(@authorId, @tweetId)', {
						['authorId'] = user.id,
						['tweetId'] = tweetId
					}, function(newrow)
						MySQL.Async.execute('UPDATE `twitter_tweets` SET `likes`= likes + 1 WHERE id = @id', {
							['@id'] = tweet.id
						}, function ()
							TriggerClientEvent('gcPhone:twitter_updateTweetLikes', -1, tweet.id, tweet.likes + 1)
							TriggerClientEvent('gcPhone:twitter_setTweetLikes', sourcePlayer, tweet.id, true)
							TriggerEvent('gcPhone:twitter_updateTweetLikes', tweet.id, tweet.likes + 1)
						end)
					end)
				else
					MySQL.Async.execute('DELETE FROM twitter_likes WHERE id = @id', {
						['@id'] = row[1].id,
					}, function(newrow)
						MySQL.Async.execute('UPDATE `twitter_tweets` SET `likes`= likes - 1 WHERE id = @id', {
							['@id'] = tweet.id
						}, function()
							TriggerClientEvent('gcPhone:twitter_updateTweetLikes', -1, tweet.id, tweet.likes - 1)
							TriggerClientEvent('gcPhone:twitter_setTweetLikes', sourcePlayer, tweet.id, false)
							TriggerEvent('gcPhone:twitter_updateTweetLikes', tweet.id, tweet.likes - 1)
						end)
					end)
				end
			end)
		end)
	end)
end

function TwitterCreateAccount(username, password, avatarUrl, srcIdentifier, cb)
	MySQL.Async.insert('INSERT IGNORE INTO twitter_accounts (`username`, `password`, `avatar_url`, `identifier`) VALUES (@username, @password, @avatarUrl, @identifier)', {
		['username'] = username,
		['password'] = password,
		['avatarUrl'] = avatarUrl,
		['identifier'] = srcIdentifier
	}, cb)
end

function TwitterShowError(sourcePlayer, title, message)
	TriggerClientEvent('gcPhone:twitter_showError', sourcePlayer, message)
end

function TwitterShowSuccess(sourcePlayer, title, message)
	TriggerClientEvent('gcPhone:twitter_showSuccess', sourcePlayer, title, message)
end

RegisterNetEvent('gcPhone:twitter_login')
AddEventHandler('gcPhone:twitter_login', function(username, password)
	local sourcePlayer = source

	getUser(username, password, function(user)
		if not user then
			TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
		else
			TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_SUCCESS')
			TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer, username, password, user.authorIcon)
		end
	end)
end)

RegisterNetEvent('gcPhone:twitter_changePassword')
AddEventHandler('gcPhone:twitter_changePassword', function(username, password, newPassword)
	local sourcePlayer = source
	getUser(username, password, function(user)
		if not user then
			TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_NEW_PASSWORD_ERROR')
		else
			MySQL.Async.execute("UPDATE `twitter_accounts` SET `password`= @newPassword WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password", {
				['@username'] = username,
				['@password'] = password,
				['@newPassword'] = newPassword
			}, function (result)
				if (result == 1) then
					TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer, username, newPassword, user.authorIcon)
					TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_NEW_PASSWORD_SUCCESS')
				else
					TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_NEW_PASSWORD_ERROR')
				end
			end)
		end
	end)
end)

RegisterNetEvent('gcPhone:twitter_createAccount')
AddEventHandler('gcPhone:twitter_createAccount', function(username, password, avatarUrl)
	local sourcePlayer = source
	local srcIdentifier = GetPlayerIdentifier(sourcePlayer, 0)

	TwitterCreateAccount(username, password, avatarUrl, srcIdentifier, function (id)
		if id ~= 0 then
			TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer, username, password, avatarUrl)
			TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_ACCOUNT_CREATE_SUCCESS')
		else
			TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_ACCOUNT_CREATE_ERROR')
		end
	end)
end)

RegisterNetEvent('gcPhone:twitter_getTweets')
AddEventHandler('gcPhone:twitter_getTweets', function(username, password)
	local sourcePlayer = source
	if username and username ~= "" and password and password ~= "" then
		getUser(username, password, function(user)
			local accountId = user and user.id
			TwitterGetTweets(accountId, function(tweets)
				TriggerClientEvent('gcPhone:twitter_getTweets', sourcePlayer, tweets)
			end)
		end)
	else
		TwitterGetTweets(nil, function(tweets)
			TriggerClientEvent('gcPhone:twitter_getTweets', sourcePlayer, tweets)
		end)
	end
end)

RegisterNetEvent('gcPhone:twitter_getFavoriteTweets')
AddEventHandler('gcPhone:twitter_getFavoriteTweets', function(username, password)
	local sourcePlayer = source
	if username and username ~= "" and password and password ~= "" then
		getUser(username, password, function(user)
			local accountId = user and user.id
			TwitterGetFavotireTweets(accountId, function(tweets)
				TriggerClientEvent('gcPhone:twitter_getFavoriteTweets', sourcePlayer, tweets)
			end)
		end)
	else
		TwitterGetFavotireTweets(nil, function(tweets)
			TriggerClientEvent('gcPhone:twitter_getFavoriteTweets', sourcePlayer, tweets)
		end)
	end
end)

RegisterNetEvent('gcPhone:twitter_postTweets')
AddEventHandler('gcPhone:twitter_postTweets', function(username, password, message)
	local xPlayer = ESX.GetPlayerFromId(source)
	TwitterPostTweet(username, password, message, xPlayer.playerId, xPlayer.getIdentifier(), xPlayer.getCharacterId())
end)

RegisterNetEvent('gcPhone:twitter_toogleLikeTweet')
AddEventHandler('gcPhone:twitter_toogleLikeTweet', function(username, password, tweetId)
	local sourcePlayer = source
	TwitterToogleLike(username, password, tweetId, sourcePlayer)
end)

RegisterNetEvent('gcPhone:twitter_setAvatarUrl')
AddEventHandler('gcPhone:twitter_setAvatarUrl', function(username, password, avatarUrl)
	local sourcePlayer = source

	MySQL.Async.execute("UPDATE `twitter_accounts` SET `avatar_url`= @avatarUrl WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password", {
		['@username'] = username,
		['@password'] = password,
		['@avatarUrl'] = avatarUrl
	}, function (result)
		if result == 1 then
			TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer, username, password, avatarUrl)
			TwitterShowSuccess(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_AVATAR_SUCCESS')
		else
			TwitterShowError(sourcePlayer, 'Twitter Info', 'APP_TWITTER_NOTIF_LOGIN_ERROR')
		end
	end)
end)