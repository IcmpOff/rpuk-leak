Citizen.CreateThread(function()
	Citizen.Wait(1000)

	for _,playerId in ipairs(ESX.GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			xPlayer.triggerEvent('esx_status:load', xPlayer.getStatus())
		end
	end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	xPlayer.triggerEvent('esx_status:load', xPlayer.getStatus())
end)

AddEventHandler('esx_status:getStatus', function(playerId, statusName, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local status  = xPlayer.getStatus()

	for i=1, #status, 1 do
		if status[i].name == statusName then
			cb(status[i])
			break
		end
	end
end)

RegisterNetEvent('esx_status:update')
AddEventHandler('esx_status:update', function(status)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.setStatus(status)
	end
end)

ESX.RegisterCommand('heal', 'staff_level_1', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx_basicneeds:healPlayer')
	args.playerId.showNotification('You have been healed by a staff member', 5000, 'inform')
end, true, {help = 'Heal a player, or yourself - restores thirst, hunger and health.', validate = true, arguments = {
	{name = 'playerId', help = 'the player id', type = 'player'}
}})