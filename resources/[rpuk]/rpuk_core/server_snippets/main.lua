function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	--Closes 268
	--TriggerClientEvent('esx:showNotification', -1, ('"%s %s~s~" has joined the server (server id %s)'):format(xPlayer.getfirstname(), xPlayer.getlastname(), playerId))
end)

-- [[ FACTION MISSION CRITICAL EVENTS DON'T TOUCH ]] --
-- [[ FACTION MISSION CRITICAL EVENTS DON'T TOUCH ]] --
-- [[ ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ ]] --

--[[
	Last Edit: Stealthee // 23/05/20 7:26am
	Reason: Adding/Modifying Faction Core Sync/Saves
]]--

RegisterNetEvent('rpuk_core:setJob')
AddEventHandler('rpuk_core:setJob', function(job, grade)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.setJob(job, grade)
	end
end)

RegisterNetEvent("rpuk_core:SavePlayer")
AddEventHandler("rpuk_core:SavePlayer", function()
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		ESX.SavePlayer(xPlayer)
	end
end)

AddEventHandler("rpuk_core:SavePlayerServer", function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		ESX.SavePlayer(xPlayer)
	end
end)
-- [[ ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ ]] --
-- [[ FACTION MISSION CRITICAL EVENTS DON'T TOUCH ]] --
-- [[ FACTION MISSION CRITICAL EVENTS DON'T TOUCH ]] --


ESX.RegisterServerCallback('rpuk_core:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			job        = xPlayer.job
		})
	end

	cb(players)
end)

ESX.RegisterServerCallback("rpuk_golf:startPlay", function(source, callback)
	local xPlayer = ESX.GetPlayerFromId(source)
	local accountMoney = xPlayer.getAccount('bank').money

	if accountMoney >= 1500 then
		xPlayer.removeAccountMoney('bank', 1500, ('%s [%s]'):format('Golfing Session', GetCurrentResourceName()))
		callback(true)
	else
		callback(false)
	end
end)

RegisterNetEvent("rpuk_core:tele_PlayerToAdmin")
AddEventHandler("rpuk_core:tele_PlayerToAdmin", function(target, AdminCoordX, AdminCoordY, AdminCoordZ) --Teleports A Player To An Admin
	TriggerClientEvent("rpuk_core:tele_PlayerToAdminResponse", target, AdminCoordX, AdminCoordY, AdminCoordZ)
	TriggerClientEvent('esx:showAdvancedNotification', target, 'RPUK | Admin', 'You Were Teleported', 'Please be prepared to speak.', 'CHAR_MP_FM_CONTACT', 7)
end)