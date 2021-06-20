playerThreatLevel = {}
local client_resources = 130

ESX.RegisterServerCallback('rpuk_anticheat:recdata', function(source, callback)
	callback(client_resources)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason) playerThreatLevel[playerId] = nil end)

AddEventHandler('rpuk_anticheat:cleanup', function(type)
	if type == "pickups" then
		sendToDiscord(false, "svr_action", source, -1, "Cleaned up the entire servers pickups")
	elseif type == "vehicles" then
		for k,vehicleEntity in pairs(GetAllVehicles()) do DeleteEntity(vehicleEntity) end
		sendToDiscord(false, "svr_action", source, -1, "Cleaned up the entire servers vehicles")
	elseif type == 'objects' then
		for k,objectEntity in pairs(GetAllObjects()) do DeleteEntity(objectEntity) end
		sendToDiscord(false, "svr_action", source, -1, "Cleaned up the entire servers objects")
	end
end)

RegisterNetEvent('rpuk_anticheat:a') -- client warn event
AddEventHandler('rpuk_anticheat:a', function(type)
	sendToDiscord(false, "warning", source, -1, type)
end)

RegisterNetEvent('rpuk_anticheat:ab') -- client autoban event
AddEventHandler('rpuk_anticheat:ab', function(type)
	sendToDiscord(false, "autoban", source, -1, type)
	TriggerEvent('rpuk_anticheat:ban', source, {reason = 'Illegal Client', period = '0', from = "RPUK Anticheat"})
end)

-- server autoban event
AddEventHandler('rpuk_anticheat:sab', function(playerId, type)
	sendToDiscord(false, "autoban", playerId, -1, type)
	TriggerEvent('rpuk_anticheat:ban', playerId, {reason = 'Illegal Client', period = '0', from = "RPUK Anticheat"})
end)

-- server autowarn event
AddEventHandler('rpuk_anticheat:saw', function(playerId, type)
	sendToDiscord(false, "warning", playerId, -1, type)
end)

-- Validate ooc messages
AddEventHandler('rpuk_anticheat:validateChat', function(message, playerId, cb)
	local isAllowed = true
	print("Chat Message: ", playerId, message)

	for _,msg in pairs(ds.bcht) do
		if string.match(string.lower(message), string.lower(msg)) then
			sendToDiscord(true, "autoban", playerId, -1, "chatspam")
			local bandata

			if string.match(string.lower(message), string.lower("nigger")) or string.match(string.lower(message), string.lower("nigga")) then
				bandata = {reason = '1.2 Chat Ban', period = '0', from = "RPUK Anticheat"}
			else
				bandata = {reason = 'Illegal Client', period = '0', from = "RPUK Anticheat"}
			end

			TriggerEvent('rpuk_anticheat:ban', playerId, bandata)
			isAllowed = false
			break
		end
	end

	if string.match(string.lower(message), string.lower("nigger")) or string.match(string.lower(message), string.lower("nigga")) then
		sendToDiscord(true, "autoban", playerId, -1, "chat_ban")
		local bandata = {reason = '1.2 Chat Ban', period = '0', from = "RPUK Anticheat"}
		TriggerEvent('rpuk_anticheat:ban', playerId, bandata)
		isAllowed = false
	end

	cb(isAllowed)
end)

-- #######

-- Server Threads
Citizen.CreateThread(function() -- fake events thread
	for _,evt in pairs(ds.bevt) do
		RegisterNetEvent(evt)
		AddEventHandler(evt, function()
			sendToDiscord(false, "autoban", source, -1, "fakeevent", tostring(evt))
			local bandata = {reason = 'Illegal Client', period = '0', from = "RPUK Anticheat"}
			TriggerEvent('rpuk_anticheat:ban', source, bandata)
		end)
	end
end)

function sendToDiscord(isBanPublic, type, playerId, time, reason, extra_data) -- discord message function
	if GetPlayerName(playerId) then
		local xPlayer = ESX.GetPlayerFromId(playerId)
		local steamDec, characterName, fields, colour, footer, hookName = tonumber(string.sub(GetPlayerIdentifier(playerId), 7, -1), 16), (xPlayer and xPlayer.getFullName() or "N/A"), {}

		table.insert(fields, {name = "Steam Name", value = GetPlayerName(playerId), inline = true})
		table.insert(fields, {name = "Character Name", value = characterName, inline = true})
		table.insert(fields, {name = "Session ID", value = playerId, inline = true})

		if type == "unban" then
			hookName, colour, footer = "RPUK AntiCheat - Player Unbanned", 15258703, "Roleplay.co.uk • Ban List"

			table.insert(fields, {name = "Steam Account", value = ("[Search Account](https://steamcommunity.com/profiles/%s)"):format(steamDec), inline = true})
			table.insert(fields, {name = "BM Search", value = "[Search Account](https://www.battlemetrics.com/rcon/players?filter%5Bsearch%5D=%22" .. steamDec .. "%22)", inline = true})
			table.insert(fields, {name = "GTA Panel", value = ("[Search Account](https://recon.roleplay.co.uk/fivem/prod/players?query=%s)"):format(steamDec), inline = true})
			table.insert(fields, {name = "Development / Leads Reference", value = os.time()})
			table.insert(fields, {name = "Staff Team Reference", value = ("%s unbanned"):format(steamDec)})

		elseif type == "ban" then
			hookName, colour = "RPUK AntiCheat - Player Ban", 15224675

			table.insert(fields, {name = "Steam Account", value = ("[Search Account](https://steamcommunity.com/profiles/%s)"):format(steamDec), inline = true})
			table.insert(fields, {name = "BM Search", value = "[Search Account](https://www.battlemetrics.com/rcon/players?filter%5Bsearch%5D=%22" .. steamDec .. "%22)", inline = true})
			table.insert(fields, {name = "GTA Panel", value = ("[Search Account](https://recon.roleplay.co.uk/fivem/prod/players?query=%s)"):format(steamDec), inline = true})
			table.insert(fields, {name = "Development / Leads Reference", value = reason})
			table.insert(fields, {name = "Staff Team Reference", value = reason})

			if extra_data then
				footer = "Roleplay.co.uk • Ban List • " .. extra_data
			else
				footer = "Roleplay.co.uk • Ban List • Staff"
			end
		elseif type == "autoban" then
			hookName, colour, footer = "RPUK AntiCheat - Player Autobanned", 15224675, "Roleplay.co.uk • Ban List"
			local devReference = ds.reasons[reason].dev
			if extra_data then devReference = ("%s\n%s"):format(devReference, extra_data) end

			table.insert(fields, {name = "Steam Account", value = ("[Search Account](https://steamcommunity.com/profiles/%s)"):format(steamDec), inline = true})
			table.insert(fields, {name = "BM Search", value = "[Search Account](https://www.battlemetrics.com/rcon/players?filter%5Bsearch%5D=%22" .. steamDec .. "%22)", inline = true})
			table.insert(fields, {name = "GTA Panel", value = ("[Search Account](https://recon.roleplay.co.uk/fivem/prod/players?query=%s)"):format(steamDec), inline = true})
			table.insert(fields, {name = "Development / Leads Reference", value = devReference})
			table.insert(fields, {name = "Staff Team Reference", value = ds.reasons[reason].staff})

		elseif type == "warning" then
			hookName, colour, footer = "RPUK AntiCheat - Illegal Client Warning", 15258703, "Roleplay.co.uk\nThis is rate limited so there may be multiple attacks/events."
			local devReference = ds.reasons[reason].dev
			if extra_data then devReference = ("%s\n%s"):format(devReference, extra_data) end

			if identifier ~= "Unknown Player" then
				table.insert(fields, {name = "Steam Account", value = ("[Search Account](https://steamcommunity.com/profiles/%s)"):format(steamDec), inline = true})
				table.insert(fields, {name = "BM Search", value = "[Search Account](https://www.battlemetrics.com/rcon/players?filter%5Bsearch%5D=%22" .. steamDec .. "%22)", inline = true})
				table.insert(fields, {name = "GTA Panel", value = ("[Search Account](https://recon.roleplay.co.uk/fivem/prod/players?query=%s)"):format(steamDec), inline = true})
			end

			table.insert(fields, {name = "Development / Leads Reference", value = devReference})
			table.insert(fields, {name = "Staff Team Reference", value = ds.reasons[reason].staff})

			-- Handle warning points to player
			if not playerThreatLevel[playerId] then playerThreatLevel[playerId] = 0 end
			playerThreatLevel[playerId] = playerThreatLevel[playerId] + 1

			-- Right now it will just send a warning, but in the future it's designed to autoban
			if playerThreatLevel[playerId] == ds.maxWarningPoints then
				sendToDiscord(false, "warning", playerId, nil, "threat_level_max", nil)
			end
		elseif type == "svr_action" then
			hookName, colour, footer = "RPUK AntiCheat - Server Wide Action", 5236948, "Roleplay.co.uk • Server Monitor"

			table.insert(fields, {name = "Steam Account", value = ("[Search Account](https://steamcommunity.com/profiles/%s)"):format(steamDec), inline = true})
			table.insert(fields, {name = "BM Search", value = "[Search Account](https://www.battlemetrics.com/rcon/players?filter%5Bsearch%5D=%22" .. steamDec .. "%22)", inline = true})
			table.insert(fields, {name = "GTA Panel", value = ("[Search Account](https://recon.roleplay.co.uk/fivem/prod/players?query=%s)"):format(steamDec), inline = true})
			table.insert(fields, {name = "Development & Staff Team Reference", value = reason})
		end

		local embeds = {{
			title = "",
			description = "",
			color = colour,
			thumbnail = {url = "https://i.imgur.com/ZPs8c4V.png"},
			footer = {text = footer},
			fields = fields
		}}

		PerformHttpRequest(ds.discord.webhook, function(err, text, headers) end, 'POST', json.encode({username = hookName, content = "", avatar_url = "https://i.imgur.com/ZPs8c4V.png", embeds = embeds}), { ['Content-Type'] = 'application/json' })

		if isBanPublic and xPlayer then
			TriggerClientEvent('chat:addMessage', -1, {template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(25, 25, 25, 0.6); border-radius: 3px;"><img style="position:absolute;right:0%;margin-top:auto;height:1.6vw;"src="https://www.roleplay.co.uk/images/rplogo.png" />^1 {0} {1}</div>',
			args = { xPlayer.name, " Was Banned from the server" }})
		end
	else
		print('[rpuk_anticheat] [^3WARNING^7] function sendToDiscord called with invalid playerId')
	end
end

function steam64(input) -- convert to steam 64 id
	local steam16 = input
	steam16 = string.sub(steam16, string.find(steam16, ":" )+1)
	local final = tonumber(steam16, 16)
	return final
end