ESX.RegisterServerCallback('rpuk_stock:deliv_pulljobs', function(source, cb)
	local orderData = {}

	MySQL.Async.fetchAll('SELECT * FROM shop_orders LEFT JOIN items ON items.name = shop_orders.product WHERE status = "placed"', {
		["@passedShop"] = shop
	}, function(result)
		if result then
			for index, data in pairs(result) do
				orderData[index] = {}
				orderData[index] = {data["label"] or "vehicle",data["quantity"],data["payment"],data["shop"],data["status"], data["id"]}
			end

			cb(orderData)
		end
	end)
end)

ESX.RegisterServerCallback('rpuk_stock:completeJob', function(source, cb, jobID)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM shop_orders WHERE id = @orderID', {
		['@orderID'] = jobID
	}, function(result)
		if result[1].status == "placed" then
			local xTarget = ESX.GetPlayerFromIdentifier(result[1].keeper)

			MySQL.Async.execute('UPDATE shop_orders SET `status` = "delivered" WHERE id = @order', {
				['@order'] = jobID,
			})

			if xTarget then -- notify shop keeper of delivery
				xTarget.showAdvancedNotification('Pegasus Delivery & Retail', "Vehicle Delivered", "A vehicle was delivered to your shop.", 'CHAR_PEGASUS_DELIVERY', 1)
			end

			if result[1].payment > 3500 then -- greater amount, transfered
				xPlayer.addAccountMoney('bank', result[1].payment, ('%s [%s]'):format('Delivery Hub Payout', GetCurrentResourceName()))
				xPlayer.showAdvancedNotification('Pegasus Delivery & Retail', "Job Completed", "£" .. result[1].payment .. " Transfered to your bank account.", 'CHAR_PEGASUS_DELIVERY', 9)
			else -- cash
				xPlayer.addMoney(result[1].payment, ('%s [%s]'):format('Delivery Hub Payout', GetCurrentResourceName()))
				xPlayer.showAdvancedNotification('Pegasus Delivery & Retail', "Job Completed", "£" .. result[1].payment .. " In cash.", 'CHAR_PEGASUS_DELIVERY', 9)
			end

			cb(true)
		else
			xPlayer.showAdvancedNotification('Pegasus Delivery & Retail', "Job Failed.", "Seems like this job was already fulfilled. Be faster next time.", 'CHAR_PEGASUS_DELIVERY', 1)
			cb(false)
		end
	end)
end)