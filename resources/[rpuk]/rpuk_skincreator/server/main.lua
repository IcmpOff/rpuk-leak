RegisterNetEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	if skin and type(skin) == 'table' then
		local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer then
			xPlayer.setSkin(skin)
		end
	end
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		cb(xPlayer.getSkin())
	else
		cb({})
	end
end)

ESX.RegisterCommand('skin', 'staff_level_1', function(xPlayer, args, showError)
	args.playerId.triggerEvent('rpuk_skincreator:openSaveableMenu')
end, true, {help = 'Open the skin editor for a player', validate = true, arguments = {
	{name = 'playerId', help = 'Player id', type = 'player'}
}})