local connectedPlayers = {}
local maxPlayers = GetConvarInt('sv_maxclients', 255)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	maxPlayers = GetConvarInt('sv_maxclients', 255)

	for k,playerId in ipairs(ESX.GetPlayers()) do
		connectedPlayers[playerId] = true
	end

	TriggerClientEvent('rpuk_guide:updateConnectedPlayers', -1, connectedPlayers)
	TriggerClientEvent('rpuk_guide:setMaxPlayers', -1, maxPlayers)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	connectedPlayers[playerId] = true
	TriggerClientEvent('rpuk_guide:updateConnectedPlayers', -1, connectedPlayers)
	TriggerClientEvent('rpuk_guide:setMaxPlayers', playerId, maxPlayers)
end)

AddEventHandler('esx:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil
	TriggerClientEvent('rpuk_guide:updateConnectedPlayers', -1, connectedPlayers)
end)