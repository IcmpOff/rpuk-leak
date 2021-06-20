local playerCount, maxPlayers = 0, 0

RegisterNetEvent('rpuk_guide:updateConnectedPlayers')
AddEventHandler('rpuk_guide:updateConnectedPlayers', function(connectedPlayers)
	playerCount = ESX.Table.SizeOf(connectedPlayers)
end)

RegisterNetEvent('rpuk_guide:setMaxPlayers')
AddEventHandler('rpuk_guide:setMaxPlayers', function(_maxPlayers)
	maxPlayers = _maxPlayers
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		SetRichPresence(('%s / %s'):format(playerCount, maxPlayers))
		SetDiscordAppId('708848566357196802')
		SetDiscordRichPresenceAsset('rplogo_2_')
	end
end)