ESX.RegisterCommand('ban', 'staff_level_2', function(xPlayer, args, showError)
	local identifier, license, playerip
	local liveid, xblid, discord, tokens = "no info", "no info", "no info", {}
	local sourceplayername, targetplayername = (xPlayer and xPlayer.getName()) or 'console', GetPlayerName(args.playerId)

	for k,v in ipairs(GetPlayerIdentifiers(args.playerId)) do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then identifier = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then playerip = v
		end
	end

	for tokenId=0, GetNumPlayerTokens(args.playerId) - 1 do
		table.insert(tokens, GetPlayerToken(args.playerId, tokenId))
	end

	local playerId = (xPlayer and xPlayer.playerId) or 0

	if args.duration > 0 then
		ban(playerId,identifier,license,liveid,xblid,discord,playerip,tokens,targetplayername,sourceplayername,args.duration,args.reason,0)
		DropPlayer(args.playerId, "You have been banned: " .. args.reason .. args.duration) -- todo improve
	else
		ban(playerId,identifier,license,liveid,xblid,discord,playerip,tokens,targetplayername,sourceplayername,args.duration,args.reason,1)
		DropPlayer(args.playerId, "You have been banned: " .. args.reason) -- todo improve
	end

	sendToDiscord(false, "ban", args.playerId, -1, args.reason .. " (" .. args.duration .. " Day)", sourceplayername) -- todo improve
end, true, {help = 'Ban an online player', validate = true, arguments = {
	{name = 'playerId', help = 'The id of the player to ban', type = 'playerId'},
	{name = 'duration', help = 'Ban duration in days, enter 0 for a permanent ban', type = 'number'},
	{name = 'reason', help = 'Player ban reason, surrounded with quotes (")', type = 'string'}
}})

AddEventHandler('rpuk_anticheat:ban', function(playerId, args)
	local identifier
	local license
	local liveid    = ""
	local xblid     = ""
	local discord   = ""
	local playerip
	local duration = tonumber(args.period)
	local reason = args.reason
	local targetplayername = GetPlayerName(playerId)
	local sourceplayername = args.from
	local tokens = {}
	local permanent

	if reason == "" then reason = 'No ban reason given' end

	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then identifier = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then playerip = v
		end
	end

	for tokenId=0, GetNumPlayerTokens(playerId) - 1 do
		table.insert(tokens, GetPlayerToken(playerId, tokenId))
	end

	if duration > 0 then
		permanent = 0
	else
		permanent = 1
	end

	ban(playerId,identifier,license,liveid,xblid,discord,playerip,tokens,targetplayername,sourceplayername,duration,reason,permanent)
	DropPlayer(playerId, reason)

	if sourceplayername == "RPUK Anticheat" then
		local identConcat = ("%s %s %s %s %s"):format(identifier, license, liveid, xblid, discord)
		globalBan(targetplayername, identConcat, reason)
	end
end)

ESX.RegisterCommand('banoffline', 'staff_level_2', function(xPlayer, args, showError)
	MySQL.Async.fetchAll('SELECT * FROM baninfo WHERE identifier = @identifier', {
		['@identifier'] = args.identifier
	}, function(data)
		if data[1] then
			local playerId, playerName = (xPlayer and xPlayer.playerId) or 0, (xPlayer and xPlayer.getName()) or 'console'
			ban(playerId, data[1].identifier, data[1].license,data[1].liveid,data[1].xblid,data[1].discord,data[1].playerip,data[1].tokens,data[1].playername,playerName,0,"Net Violation - (Offline Ban)",1)
		else
			showError('No player with the given identifier has been registered on this server')
		end
	end)
end, true, {help = 'Ban a player who is offline by their Steam hex identifier', validate = true, arguments = {
	{name = 'identifier', help = 'The player identifier', type = 'string'}
}})

-- console / rcon can also utilize es:command events, but breaks since the source isn't a connected player, ending up in error messages
-- update: esx commands work just fine :D
AddEventHandler('bansql:sendMessage', function(source, message)
	if source ~= 0 then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1Banlist', message } } )
	else
		print('SqlBan: ' .. message)
	end
end)

function ban(source,identifier,license,liveid,xblid,discord,playerip,tokens,targetplayername,sourceplayername,duration,reason,permanent, type)
	if identifier then
		local expiration = duration * 86400

		if expiration < os.time() then expiration = os.time() + expiration end

		MySQL.Async.execute([===[
			INSERT INTO banlist (
				identifier, license, liveid, xblid, discord, playerip, tokens,
				targetplayername, sourceplayername, reason, expiration, timeat, permanent, active
			)

			VALUES (
				@identifier, @license, @liveid, @xblid, @discord, @playerip, @tokens,
				@targetplayername, @sourceplayername, @reason, @expiration, @timeat, @permanent, @active
			)
		]===], {
			['@identifier'] = identifier,
			['@license'] = license,
			['@liveid'] = liveid,
			['@xblid'] = xblid,
			['@discord']  = discord,
			['@playerip'] = playerip,
			tokens = json.encode(tokens),
			['@targetplayername'] = targetplayername,
			['@sourceplayername'] = sourceplayername .. " - (Game)",
			['@reason'] = reason,
			['@expiration'] = expiration,
			['@timeat'] = os.time(),
			['@permanent'] = permanent,
			['@active'] = 1,
		}, function(rowsChanged)

		end)

		if permanent == 0 then
			TriggerEvent('bansql:sendMessage', source, (targetplayername .. "Duration: " .. duration .. "Reason: " .. reason))
		else
			TriggerEvent('bansql:sendMessage', source, (targetplayername .. "Banned for: " .. reason))
		end

		TriggerClientEvent('chat:addMessage', -1, {template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(25, 25, 25, 0.6); border-radius: 3px;"><img style="position:absolute;right:0%;margin-top:auto;height:1.6vw;"src="https://www.roleplay.co.uk/images/rplogo.png" /> {0} {1}</div>',
			args = { targetplayername, "^1Was Banned from the server" }
		})

		MySQL.Async.execute([===[
			INSERT INTO banlisthistory (
				identifier, license, liveid, xblid, discord, playerip, tokens,
				targetplayername, sourceplayername, reason, expiration, timeat, permanent
			)

			VALUES (
				@identifier, @license, @liveid, @xblid, @discord, @playerip, @tokens,
				@targetplayername, @sourceplayername, @reason, @expiration, @timeat, @permanent
			)
		]===], {
			['@identifier']       = identifier,
			['@license']          = license,
			['@liveid']           = liveid,
			['@xblid']            = xblid,
			['@discord']          = discord,
			['@playerip']         = playerip,
			tokens = json.encode(tokens),
			['@targetplayername'] = targetplayername,
			['@sourceplayername'] = sourceplayername .. " - (Game)",
			['@reason']           = reason,
			['@expiration']       = expiration,
			['@timeat']           = os.time(),
			['@permanent']        = permanent
		}, function(rowsChanged)

		end)
	end
end

function globalBan(playerName, concatIdentifier, knownData)
	if playerName then

		playerName = playerName:gsub("%s+", "")
		playerName = string.gsub(playerName, "%s+", "")

		local MSBIWebhook = "https://discord.com/api/webhooks/791719791299395614/_ZBKV8E0w3U6TEVpnlbhAK7QM3qN3AduhVunAXZmYG4gXcVayiCzHr-b-1t2FKx9Yd5Y"
		local TestWebhook = "https://discord.com/api/webhooks/791722754910584833/nuJlsGn4xeQ0jW7pI7M_QvuupDViR8zepDOuTEH6bwYy6KJbekUUsJOpik-h6ZFmpdJF"

		local embeds = {{
			title = "Anticheat Autoban",
			description = "Full details of the ban can be requested from @Stealthee any appeals please point them to Roleplay.co.uk once successfully appealed at MSBI",
			color = 15158332,
			thumbnail = {url = "https://i.imgur.com/ZPs8c4V.png"},
			footer = {text = "Roleplay.co.uk | Stealthee • 2020"}
		}}

		PerformHttpRequest(MSBIWebhook, function(err, text, headers) end, 'POST', json.encode({username = "RPUK Anticheat", content = "!addban " .. playerName .. " " .. concatIdentifier, avatar_url = "https://i.imgur.com/ZPs8c4V.png", embeds = {}}), { ['Content-Type'] = 'application/json' })
	end
end

AddEventHandler('playerConnecting', function (playerName, setKickReason, deferrals)
	deferrals.defer()
	local tempId = source
	Citizen.Wait(0)

	deferrals.update('Checking ban status...')
	Citizen.Wait(0)

	local steamID  = "empty"
	local license  = "empty"
	local liveid   = "empty"
	local xblid    = "empty"
	local discord  = "empty"
	local playerip = "empty"
	local tokens = {}

	for k,v in ipairs(GetPlayerIdentifiers(tempId)) do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then steamID = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then playerip = v
		end
	end

	for tokenId=0, GetNumPlayerTokens(tempId) - 1 do
		table.insert(tokens, GetPlayerToken(tempId, tokenId))
	end

	if steamID == 'empty' then
		deferrals.done('There was an error loading your character!\nError code: identifier-missing\n\nThis issue occured because your Steam identification isn\'t available, make sure Steam is running!')
		return
	end

	MySQL.Async.fetchAll([===[
		SELECT
			id, reason, expiration, permanent, sourceplayername, timeat

		FROM banlist

		WHERE
			active = 1

			AND (
				license = @license
				OR identifier = @identifier
				OR liveid = @liveid
				OR xblid = @xblid
				OR discord = @discord
				OR playerip = @playerip
			)

			AND (permanent = 1 OR UNIX_TIMESTAMP() < expiration)

		ORDER
			BY permanent DESC, expiration DESC LIMIT 1
	]===], {
		license = license,
		identifier = steamID,
		liveid = liveid,
		xblid = xblid,
		discord = discord,
		playerip = playerip,
	}, function(data)
		if #data == 0 then
			-- Not banned
			deferrals.done()
		else
			data = data[1]
			local banDate = os.date('*t', data.timeat)
			local banTime = os.time{year = banDate.year, month = banDate.month, day = banDate.day}
			local daysSinceBan = math.floor(os.difftime(os.time(), banTime) / (24 * 60 * 60))
			local monthsSinceBan = daysSinceBan / 30
			local formattedDate = ('%02d-%02d-%02d'):format(banDate.year, banDate.month, banDate.day)
			local steamDec = tonumber(string.sub(GetPlayerIdentifier(tempId), 7, -1), 16)

			if data.permanent == 1 then
				local hasSixMonthsPassed = monthsSinceBan >= 6 and 'Yes (six months has passed)' or 'No (six months has not passed yet)'
				deferrals.done(('\nYou are permanently banned from playing on RPUK\n\nBan date: %s\nBan appealable: %s\nBan issuer: %s\nBan reason: %s\n\nYour Steam identifier: %s\nYour Ban ID: RPUKBID#%s\n\nSee Guide on Unban Appeal\nhttps://wiki.roleplay.co.uk/Guide:Unban_Appeal'):format(formattedDate, hasSixMonthsPassed, data.sourceplayername, data.reason, steamDec, data.id))
			else
				local totalMinutes = math.max((((tonumber(data.expiration)) - os.time())/60), 0)
				local minutes = math.floor(totalMinutes % 60)
				local hrs = math.floor(totalMinutes / 60) % 24
				local days = math.floor((totalMinutes / 60) / 24)
				local formattedTime = ''
				local unbanDate = os.date('*t', data.expiration)
				local formattedUnbanDate = ('%02d-%02d-%02d'):format(unbanDate.year, unbanDate.month, unbanDate.day)

				if days > 0 then
					formattedTime = days .. " days, "
				end

				if hrs > 0 or days > 0 then
					formattedTime = formattedTime .. hrs .. " hours, "
				end

				formattedTime = formattedTime .. minutes .. " minutes"

				deferrals.done(('\nYou are temporarily banned from playing on RPUK\n\nBan date: %s\n' ..
				'Ban time remaining: %s (%s)\nBan issuer: %s\nBan reason: %s\n\nYour Steam identifier: %s\n' ..
				'Your Ban ID: RPUKBID#%s\n\n' ..
				'See Guide on Unban Appeal\nhttps://wiki.roleplay.co.uk/Guide:Unban_Appeal')
				:format(formattedDate, formattedTime, formattedUnbanDate, data.sourceplayername, data.reason, steamDec, data.id))
			end
		end
	end)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local steamID  = "no info"
	local license  = "no info"
	local liveid   = "no info"
	local xblid    = "no info"
	local discord  = "no info"
	local playerip = "no info"
	local tokens = {}
	local playername = xPlayer.getName()

	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.sub(v, 1, string.len("steam:")) == "steam:" then steamID = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then license = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then playerip = v
		end
	end

	for tokenId=0, GetNumPlayerTokens(playerId) - 1 do
		table.insert(tokens, GetPlayerToken(playerId, tokenId))
	end

	MySQL.Async.fetchAll('SELECT identifier FROM baninfo WHERE identifier = @identifier', {
		['@identifier'] = steamID
	}, function(result)
		local found = false

		for k,v in ipairs(result) do
			if v.identifier == steamID then
				found = true
				break
			end
		end

		if not found then
			MySQL.Async.execute([===[
				INSERT INTO baninfo (
					identifier, license, liveid, xblid, discord, playerip, tokens, playername
				)

				VALUES (
					@identifier, @license, @liveid, @xblid, @discord, @playerip, @tokens, @playername
				)
			]===], {
				['@identifier'] = steamID,
				['@license']    = license,
				['@liveid']     = liveid,
				['@xblid']      = xblid,
				['@discord']    = discord,
				['@playerip']   = playerip,
				tokens = json.encode(tokens),
				['@playername'] = playername
			}, function(rowsChanged) end)
		else
			MySQL.Async.execute([===[
				UPDATE baninfo SET
					license = @license,
					liveid = @liveid,
					xblid = @xblid,
					discord = @discord,
					playerip = @playerip,
					tokens = @tokens,
					playername = @playername

				WHERE identifier = @identifier
			]===], {
				['@identifier'] = steamID,
				['@license']    = license,
				['@liveid']     = liveid,
				['@xblid']      = xblid,
				['@discord']    = discord,
				['@playerip']   = playerip,
				tokens = json.encode(tokens),
				['@playername'] = playername
			}, function(rowsChanged) end)
		end
	end)
end)