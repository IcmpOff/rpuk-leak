ESX.RegisterServerCallback('rpuk_atm:deposit', function(playerId, cb, amount, atmType)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer and amount and tonumber(amount) then
		amount = ESX.Math.Round(tonumber(amount))

		if atmType == 'normal' then
			if amount <= xPlayer.getAccountBalance('money') then
				xPlayer.removeAccountMoney('money', amount, ('%s [%s]'):format('ATM - Deposit', GetCurrentResourceName()))
				xPlayer.addAccountMoney('bank', amount, ('%s [%s]'):format('ATM - Deposit', GetCurrentResourceName()))
				xPlayer.showAdvancedNotification('FLEECA BANK', 'Transaction Complete', 'Deposited ~g~£' .. ESX.Math.GroupDigits(amount) , 'CHAR_BANK_FLEECA', 9)
			else
				xPlayer.showAdvancedNotification('FLEECA BANK', 'Transaction Failed', '' , 'CHAR_BANK_FLEECA', 9)
			end

			cb(xPlayer.getAccountBalance('bank'))
		elseif atmType == 'fund' then
			TriggerEvent('rpuk_factions:deposit', playerId, xPlayer.job.name, amount, function(cb2)
				cb(cb2)
			end)
		end
	end
end)

ESX.RegisterServerCallback('rpuk_atm:withdraw', function(playerId, cb, amount, atmType)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer and amount and tonumber(amount) then
		amount = ESX.Math.Round(tonumber(amount))

		if atmType == 'normal' then
			if amount <= xPlayer.getAccountBalance('bank') then
				xPlayer.removeAccountMoney('bank', amount, ('%s [%s]'):format('ATM Transaction - Withdraw', GetCurrentResourceName()))
				xPlayer.addMoney(amount, ('%s [%s]'):format('ATM Transaction - Withdraw', GetCurrentResourceName()))
				xPlayer.showAdvancedNotification('FLEECA BANK', 'Transaction Complete', 'Withdrew ~g~£' .. ESX.Math.GroupDigits(amount) , 'CHAR_BANK_FLEECA', 9)
			else
				xPlayer.showAdvancedNotification('FLEECA BANK', 'Transaction Failed', '' , 'CHAR_BANK_FLEECA', 9)
			end

			cb(xPlayer.getAccountBalance('bank'))
		elseif atmType == 'fund' then
			TriggerEvent('rpuk_factions:withdraw', playerId, xPlayer.job.name, amount, function(newBalance)
				cb(newBalance)
			end)
		end
	end
end)