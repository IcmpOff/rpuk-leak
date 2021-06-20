RegisterNetEvent('phone:banktransfer')
AddEventHandler('phone:banktransfer', function(target, OG_amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	local amount = tonumber(OG_amount) or 0

	if xTarget then
		if amount > 0 and amount <= xPlayer.getAccount('bank').money then
			xPlayer.removeAccountMoney('bank', amount, ('%s [%s]'):format('Phone Banking Transfer', GetCurrentResourceName()))
			xTarget.addAccountMoney('bank', amount, ('%s [%s]'):format('Phone Banking Transfer', GetCurrentResourceName()))
			local playerMsg = ('You transferred £%s to a player'):format(ESX.Math.GroupDigits(amount))
			local targetMsg = ('You have received a transfer of £%s from a player'):format(ESX.Math.GroupDigits(amount))
			xPlayer.showNotification(playerMsg, 5000, 'info')
			xTarget.showNotification(targetMsg, 5000, 'info')
		else
			xPlayer.showNotification('Transfer failed, check your balance', 5000, 'error')
		end
	else
		xPlayer.showNotification('Player ID not valid', 5000, 'error')
	end
end)