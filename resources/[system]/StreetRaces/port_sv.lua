-- Helper function for getting player money
function getMoney(source)
	-- Add framework API's here (return large number by default)
	local xPlayer = ESX.GetPlayerFromId(source)
	CurrentMoney = xPlayer.getMoney()

	return CurrentMoney
end

-- Helper function for removing player money
function removeMoney(source, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(amount, ('%s [%s]'):format('Street Racing Pay In', GetCurrentResourceName()))
end

-- Helper function for adding player money
function addMoney(source, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addMoney(amount, ('%s [%s]'):format('Street Racing Payout', GetCurrentResourceName()))
end

-- Helper function for getting player name
function getName(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	return xPlayer.firstname .. " " .. xPlayer.lastname
end

-- Helper function for notifying players
function notifyPlayer(notif, source, header, msg)
	if notif == "chat" then
		TriggerClientEvent('chat:addMessage', source, {
			template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(153, 255, 255, 0.6); border-radius: 3px; color:black;"><img style="position:absolute;z-index:10;right:0;height:3vw;top:auto;"src="https://www.roleplay.co.uk/images/rplogo.png" /> <b>{0}</b><br> {1}</div><br><br>',
			args = {header, msg}
		})
	elseif notif == "mythic" then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { length = 2500, action = 'longnotif', type = 'inform', text = header .. ": " .. msg})
	end
end

-- Saved player data and file
local playersData = nil
local playersDataFile = "./StreetRaces_saveData.txt"

-- Helper function for loading saved player data
function loadPlayerData(source)
	-- Load data from file if not already initialized
	if playersData == nil then
		playersData = {}
		local file = io.open(playersDataFile, "r")
		if file then
			local contents = file:read("*a")
			playersData = json.decode(contents);
			io.close(file)
		end
	end

	-- Get player steamID from source and use as key to get player data
	local playerId = string.sub(GetPlayerIdentifier(source, 0), 7, -1)
	local playerData = playersData[playerId]

	-- Return saved player data
	if playerData == nil then
		playerData = {}
	end
	return playerData
end

-- Helper function for saving player data
function savePlayerData(source, data)
	-- Load data from file if not already initialized
	if playersData == nil then
		playersData = {}
		local file = io.open(playersDataFile, "r")
		if file then
			local contents = file:read("*a")
			playersData = json.decode(contents);
			io.close(file)
		end
	end

	-- Get player steamID from source and use as key to save player data
	local playerId = string.sub(GetPlayerIdentifier(source, 0), 7, -1)
	playersData[playerId] = data

	-- Save file
	local file = io.open(playersDataFile, "w+")
	if file then
		local contents = json.encode(playersData)
		file:write(contents)
		io.close(file)
	end
end
