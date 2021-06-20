RegisterNetEvent('rpuk:vending_machine')
AddEventHandler('rpuk:vending_machine', function(type)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= 50 then
		xPlayer.removeMoney(50, ('%s [%s]'):format('Vending Machine Purchase', GetCurrentResourceName()))
		if type == "food" then
			xPlayer.addInventoryItem('apple', 2)
		elseif type == "drink" then
			xPlayer.addInventoryItem('water', 1)
		end
		xPlayer.showAdvancedNotification('VENDING MACHINE', "Purchase Successful!", "", 'CHAR_BANK_FLEECA', 0)
	else
		xPlayer.showAdvancedNotification('VENDING MACHINE', "Please Insert £50 Cash!", "", 'CHAR_BANK_FLEECA', 0)
	end
end)