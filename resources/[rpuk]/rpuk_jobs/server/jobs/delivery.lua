ESX.RegisterServerCallback('rpuk_deliveries:rentVehicle', function(playerId, cb, passedMenu, model)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	local cashBalance = xPlayer.getMoney()
	local bankBalance = xPlayer.getAccount('bank').money

	local price = 0

	for index, data in pairs(Config.Delivery.RentVehs[passedMenu].vehicles) do
		if data.model == model then
			price = data.price
		end
	end

	if cashBalance >= price then
		xPlayer.removeMoney(price, ('%s [%s]'):format('Vehicle Rental', GetCurrentResourceName()))
		cb(true)
	elseif bankBalance >= price then
		xPlayer.removeAccountMoney('bank', price, ('%s [%s]'):format('Delivery Job Vehicle Rental', GetCurrentResourceName()))
		cb(true)
	else
		cb(false)
	end
end)

RegisterNetEvent('rpuk_deliveries:complated')
AddEventHandler('rpuk_deliveries:complated', function(varCheck, varCheck2, distance, fuel)
	local xPlayer = ESX.GetPlayerFromId(source)
	distance = math.floor(distance)

	if varCheck and varCheck2 then
		local deliveryPay = math.floor(math.random(350, 600) + distance / 10)
		local distanceBonusPay, totalPay

		if distance < 1000 then
			distanceBonusPay = math.floor(distance / math.random(2, 3))
		else
			distanceBonusPay = math.floor(distance / math.random(10, 20))
		end

		totalPay = deliveryPay + distanceBonusPay

		print(('[rpuk_deliveries] [^2INFO^7] "%s" tiggered ":completed". Pay: £%s + £%s'):format(xPlayer.getIdentifier(), deliveryPay, distanceBonusPay))
		local msg = ('Job Status: Completed~n~~n~Delivery: ~g~£%s~s~~n~Distance Bonus: ~g~£%s~s~')
			:format(ESX.Math.GroupDigits(deliveryPay), ESX.Math.GroupDigits(distanceBonusPay))

		if fuel then
			local petrolAmount = math.random(5, 10)
			local randomDangerPay = math.random(2000, 5000)

			if xPlayer.canCarryItem('petrol', petrolAmount) then
				xPlayer.addInventoryItem('petrol', petrolAmount)
			else
				xPlayer.showNotification('You were also granted some petrol, but you did not have enough space in your inventory to recieve them.', 5000, 'error')
			end

			totalPay = totalPay + randomDangerPay
			msg = ('%s~n~Danger Cargo Bonus: ~g~£%s~s~'):format(msg, ESX.Math.GroupDigits(randomDangerPay))
		end

		msg = ('%s~n~Grand Total: ~g~£%s~s~'):format(msg, ESX.Math.GroupDigits(totalPay))

		xPlayer.addAccountMoney('bank', totalPay, ('%s [%s]'):format('Delivery Job Payout', GetCurrentResourceName()))
		xPlayer.showAdvancedNotification('FLEECA BANK', 'Transfer Summary', msg, 'CHAR_BANK_FLEECA', 9)
	end
end)

RegisterNetEvent('rpuk_delivery:vehicleReturn')
AddEventHandler('rpuk_delivery:vehicleReturn', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addAccountMoney('bank', 100, ('%s [%s]'):format('Delivery Vehicle Return', GetCurrentResourceName()))
	xPlayer.showAdvancedNotification('FLEECA BANK', 'Transfer Summary', 'Vehicle Returned ~g~+£25', 'CHAR_BANK_FLEECA', 9)
end)