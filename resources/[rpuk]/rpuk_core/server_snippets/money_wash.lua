RegisterNetEvent('rpuk_moneywash:process')
AddEventHandler('rpuk_moneywash:process', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local dirty = xPlayer.getAccount('black_money').money

	if dirty <= 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'error', text = "You don't have enough dirty cash!"})
	else
		xPlayer.removeAccountMoney('black_money', dirty, ('%s [%s]'):format('Money Wash Clean', GetCurrentResourceName()))
		xPlayer.addMoney(dirty * 0.85, ('%s [%s]'):format('Money Wash Payout', GetCurrentResourceName()))
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = ('You laundered £%s into £%s'):format(dirty, dirty * 0.85)})
	end
end)

ESX.RegisterServerCallback('rpuk_moneywash:returnVal', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local dirty = xPlayer.getAccount('black_money').money
	local xMath = 0
	if dirty < 10000 then xMath = 35000
	elseif dirty < 20000 then xMath = 60000
	elseif dirty > 20000 then xMath = 18000
	end
	cb(dirty, xMath)
end)