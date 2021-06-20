RegisterNetEvent('gcPhone:twitter_getTweets')
AddEventHandler('gcPhone:twitter_getTweets', function(tweets)
	for k, v in pairs(tweets) do
		v.author = v.author:gsub('%W', '' ) -- escape any fake verified icons etc

		if v.verified then
			v.author = v.author .. ' ✔'
		end
	end

	SendNUIMessage({event = 'twitter_tweets', tweets = tweets})
end)

RegisterNetEvent('gcPhone:twitter_getFavoriteTweets')
AddEventHandler('gcPhone:twitter_getFavoriteTweets', function(tweets)
	SendNUIMessage({event = 'twitter_favoritetweets', tweets = tweets})
end)

RegisterNetEvent('gcPhone:twitter_newTweet')
AddEventHandler('gcPhone:twitter_newTweet', function(tweet) --Recieving a tweet whilst inside zone
	local coords = GetEntityCoords(PlayerPedId())
	if exports.gcphone:mastCheck(coords) then
		SendNUIMessage({event = 'twitter_newTweet', tweet = tweet})
	end
end)

RegisterNetEvent('gcPhone:twitter_updateTweetLikes')
AddEventHandler('gcPhone:twitter_updateTweetLikes', function(tweetId, likes)
	SendNUIMessage({event = 'twitter_updateTweetLikes', tweetId = tweetId, likes = likes})
end)

RegisterNetEvent('gcPhone:twitter_setAccount')
AddEventHandler('gcPhone:twitter_setAccount', function(username, password, avatarUrl)
	SendNUIMessage({event = 'twitter_setAccount', username = username, password = password, avatarUrl = avatarUrl})
end)

RegisterNetEvent('gcPhone:twitter_createAccount')
AddEventHandler('gcPhone:twitter_createAccount', function(account)
	SendNUIMessage({event = 'twitter_createAccount', account = account})
end)

RegisterNetEvent('gcPhone:twitter_showError')
AddEventHandler('gcPhone:twitter_showError', function(title, message)
	SendNUIMessage({event = 'twitter_showError', message = message, title = title})
end)

RegisterNetEvent('gcPhone:twitter_showSuccess')
AddEventHandler('gcPhone:twitter_showSuccess', function(title, message)
	SendNUIMessage({event = 'twitter_showSuccess', message = message, title = title})
end)

RegisterNetEvent('gcPhone:twitter_setTweetLikes')
AddEventHandler('gcPhone:twitter_setTweetLikes', function(tweetId, isLikes)
	SendNUIMessage({event = 'twitter_setTweetLikes', tweetId = tweetId, isLikes = isLikes})
end)

RegisterNUICallback('twitter_login', function(data, cb)
	TriggerServerEvent('gcPhone:twitter_login', data.username, data.password)
end)

RegisterNUICallback('twitter_changePassword', function(data, cb)
	TriggerServerEvent('gcPhone:twitter_changePassword', data.username, data.password, data.newPassword)
end)

RegisterNUICallback('twitter_createAccount', function(data, cb)
	TriggerServerEvent('gcPhone:twitter_createAccount', data.username, data.password, data.avatarUrl)
end)

RegisterNUICallback('twitter_getTweets', function(data, cb)
	local coords = GetEntityCoords(PlayerPedId())
	if exports.gcphone:mastCheck(coords) then
		TriggerServerEvent('gcPhone:twitter_getTweets', data.username, data.password)
	end
end)

RegisterNUICallback('twitter_getFavoriteTweets', function(data, cb) --Get favourite tweets whilst inside zone
	local coords = GetEntityCoords(PlayerPedId())
	if exports.gcphone:mastCheck(coords) then
		TriggerServerEvent('gcPhone:twitter_getFavoriteTweets', data.username, data.password)
	end
end)

RegisterNUICallback('twitter_postTweet', function(data, cb) --Sending tweet whilst inside zone
	local coords = GetEntityCoords(PlayerPedId())
	if exports.gcphone:mastCheck(coords) then
		TriggerServerEvent('gcPhone:twitter_postTweets', data.username or '', data.password or '', data.message)
	end
end)

RegisterNUICallback('twitter_postTweetImg', function(data, cb) --Sending tweet image whilst inside zone
	local coords = GetEntityCoords(PlayerPedId())
	if exports.gcphone:mastCheck(coords) then
		TriggerServerEvent('gcPhone:twitter_postTweets', data.username or '', data.password or '', data.img)
	end
end)

RegisterNUICallback('twitter_toggleLikeTweet', function(data, cb)
	TriggerServerEvent('gcPhone:twitter_toogleLikeTweet', data.username or '', data.password or '', data.tweetId)
end)

RegisterNUICallback('twitter_setAvatarUrl', function(data, cb)
	TriggerServerEvent('gcPhone:twitter_setAvatarUrl', data.username or '', data.password or '', data.avatarUrl)
end)
