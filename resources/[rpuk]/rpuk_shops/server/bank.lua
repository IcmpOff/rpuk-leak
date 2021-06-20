RegisterNetEvent('rpuk_robberies:toggleBank')
AddEventHandler('rpuk_robberies:toggleBank', function(index, state)
	Config.Banks[index].isHacked = state
	TriggerClientEvent("rpuk_robberies:toggleBankClient", -1, index, state)
end)

RegisterNetEvent('rpuk_robberies:openSafe')
AddEventHandler('rpuk_robberies:openSafe', function(bank, safe)
	local xPlayer = ESX.GetPlayerFromId(source)
	for index, data in pairs (Config.Banks[bank].items) do
		if 100 * math.random() < data.chance then
			if data.type == "item" then
				xPlayer.addInventoryItem(data.item, data.quantity)
			elseif data.type == "cash" then
				xPlayer.addMoney(data.quantity, ('%s [%s]'):format('Bank Robbery Payout', GetCurrentResourceName()))
			end
		end
	end
	Config.Banks[bank].safes[safe].searched = true
	TriggerClientEvent("rpuk_robberies:updateSafe", -1, bank, safe)
end)

ESX.RegisterServerCallback('rpuk_robberies:checkPolice', function(source, callback, number)
	local xPlayers = ESX.GetPlayers()
	copsConnected = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		local xPolData = json.decode(xPlayer.getpolicedata())
		if xPlayer.job.name == 'police' and tonumber(xPolData.firearms) > 1 then
			copsConnected = copsConnected + 1
		end
	end
	if copsConnected >= number then
		callback(true)
	else
		callback(false)
	end
end)

ESX.RegisterServerCallback('rpuk_robberies:getAll', function(source, callback)
	callback(Config.Banks)
end)