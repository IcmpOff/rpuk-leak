ESX.RegisterServerCallback('rpuk_tattooshop:requestPlayerTattoos', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE rpuk_charid = @rpuk_charid', {
			['@rpuk_charid'] = xPlayer.rpuk_charid
		}, function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)

ESX.RegisterServerCallback('rpuk_tattooshop:purchaseTattoo', function(source, cb, tattooList, price, tattoo)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price, ('%s (%s) [%s]'):format('Purchase Tattoo', tattoo, GetCurrentResourceName()))
		table.insert(tattooList, tattoo)

		MySQL.Async.execute('UPDATE users SET tattoos = @tattoos WHERE rpuk_charid = @rpuk_charid', {
			['@tattoos'] = json.encode(tattooList),
			['@rpuk_charid'] = xPlayer.rpuk_charid
		})

		TriggerClientEvent('esx:showNotification', source, _U('bought_tattoo', ESX.Math.GroupDigits(price)))
		cb(true)
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', source, _U('not_enough_money', ESX.Math.GroupDigits(missingMoney)))
		cb(false)
	end
end)