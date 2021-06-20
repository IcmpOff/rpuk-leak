local vehPayout = 3650

ESX.RegisterServerCallback('rpuk_stock:getCoreData', function(playerId, cb, shop)
	local found, vehicles, rawMaterials, manuGoods, shopData, orderData, orderDelivData = 0, {}, {}, {}, {}, {}, {}

	MySQL.Async.fetchAll('SELECT * FROM items WHERE can_stock = 1 AND type = "raw"', {}, function(data)
		if data ~= nil then
			rawMaterials = data
			found = found + 1
		else
			found = found + 1
		end
	end)

	MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE import = 1', {}, function(data2)
		if data2 ~= nil then
			vehicles = data2
			found = found + 1
		else
			found = found + 1
		end
	end)

	MySQL.Async.fetchAll('SELECT bank, shop_type FROM shops_owned WHERE shop = @passedShop', {
		["@passedShop"] = shop
	}, function(data3)
		if data3 ~= nil then
			shopData = data3[1]
			found = found + 1
		else
			found = found + 1
		end
	end)

	MySQL.Async.fetchAll('SELECT * FROM items WHERE can_stock = 1 AND type = "manufactured"', {}, function(data)
		if data ~= nil then
			manuGoods = data
			found = found + 1
		else
			found = found + 1
		end
	end)

	MySQL.Async.fetchAll('SELECT * FROM shop_orders LEFT JOIN items ON items.name = shop_orders.product WHERE shop = @passedShop', {
		["@passedShop"] = shop
	}, function(data4)
		if data4 ~= nil then
			for index, data in pairs(data4) do
				orderData[index] = {}
				orderData[index] = {data["label"],data["quantity"],data["payment"],ConvertTime(data["created"]).." UTC",data["status"], data["id"]}
			end

			found = found + 1
		else
			found = found + 1
		end
	end)

	while found < 5 do -- checks all sql queries are done before moving on
		Citizen.Wait(100)
	end
	cb(shopData, orderData, vehicles, rawMaterials, manuGoods)
end)

--[[HANDLE ORDERING]]--
ESX.RegisterServerCallback('rpuk_stock:generateNewOrder', function(playerId, cb, type, option, passedshop, quantity, price)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local result, message = nil, nil

	if type == "vehicle" then --option=model
		MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE model = @option', {
			['@option'] = option
		}, function(vehResult)
			if vehResult[1].price then -- price exists
				if xPlayer.getAccount('bank').money >= vehResult[1].price then
					MySQL.Async.execute('INSERT INTO shop_orders (keeper, order_type, shop, product, quantity, payment) VALUES (@keeper, @order_type, @shop, @product, @quantity, @payment)', {
						['@keeper']		= xPlayer.identifier,
						['@order_type']	= type,
						['@shop']		= passedshop,
						['@product']	= option,
						['@quantity']	= 1,
						['@payment']	= vehPayout
					}, function (ExecResult)
						if ExecResult then
							TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { length = 8000, type = 'inform', text = "You have created an order!" })
							xPlayer.removeAccountMoney('bank', vehResult[1].price, ('%s (x%s %s) [%s]'):format('Stock Order Generated', quantity, option, GetCurrentResourceName()))
							triggerNotification()
							print("RPUK TRANSACTION: ORDER GENERATED (Keeper: " .. xPlayer.identifier .. "; Shop: " .. passedshop .. "; Product: " .. option .."; Quantity: " .. 1 .. "; Offer/Payment: " .. vehResult[1].price .. ")[SUCCESS]")
							result, message = true, "Order Generated! Funds removed from your account."
						else
							print("RPUK TRANSACTION: ORDER FAILED (Keeper: " .. xPlayer.identifier .. "; Shop: " .. passedshop .. "; Product: " .. option .."; Quantity: " .. 1 .. "; Offer/Payment: " .. vehResult[1].price .. ")[FAILED]")
							result, message = false, "Something went wrong!"
						end
					end)
				else
					result, message = false, "Insufficient funds in your bank account!"
					TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { length = 8000, type = 'error', text = "Insufficient funds in your bank account!" })
				end
			else
				result, message = false, "Something went wrong!"
			end
		end)

	elseif type == "raw" or type == "manufactured" then -- option = item
		local quantity, price = tonumber(quantity), tonumber(price)

		if option ~= nil and quantity ~= nil and price ~= nil and quantity > 0 and price > 0 then
			if xPlayer.getAccount('bank').money >= quantity * price then
				MySQL.Async.execute('INSERT INTO shop_orders (keeper, order_type, shop, product, quantity, payment) VALUES (@keeper, @order_type, @shop, @product, @quantity, @payment)', {
					['@keeper']		= xPlayer.identifier,
					['@order_type']	= type,
					['@shop']		= passedshop,
					['@product']	= option,
					['@quantity']	= quantity,
					['@payment']	= price * quantity
				}, function (ExecResult)
					if ExecResult then
						xPlayer.removeAccountMoney('bank', price * quantity, ('%s (x%s %s) [%s]'):format('Stock Order Generated', quantity, option, GetCurrentResourceName()))
						triggerNotification()
						print("RPUK TRANSACTION: ORDER GENERATED (Keeper: " .. xPlayer.identifier .. "; Shop: " .. passedshop .. "; Product: " .. option .."; Quantity: " .. quantity .. "; Offer/Payment: " .. price * quantity .. ")[SUCCESS]")
						result, message = true, "Order Generated! Funds removed from your account."
					else
						print("RPUK TRANSACTION: ORDER FAILED (Keeper: " .. xPlayer.identifier .. "; Shop: " .. passedshop .. "; Product: " .. option .."; Quantity: " .. quantity .. "; Offer/Payment: " .. price * quantity .. ")[FAILED]")
					end
				end)
			else
				result, message = false, "Insufficient funds in your bank account!"
			end
		else
			result, message = false, "Invalid Input!"
		end
	else
		result, message = false, "Something went wrong!"
	end

	while result == nil or message == nil do Citizen.Wait(100) end
	xPlayer.showAdvancedNotification('Pegasus Delivery & Retail', "", message, 'CHAR_PEGASUS_DELIVERY', 0)
	cb(result)
end)

--[[HANDLE BANKING / TRANSFERS]]--
ESX.RegisterServerCallback('rpuk_stock:handleBank', function(playerId, cb, type, value, passedshop)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local result, message, newValue, found = nil, nil, nil, 0

	MySQL.Async.fetchAll('SELECT bank FROM shops_owned WHERE shop = @passedShop', {
		["@passedShop"] = passedshop
	}, function(result2)
		if result2[1] ~= nil then
			local currentBank = tonumber(result2[1]["bank"])

			if type == "withdraw" then -- player clicked withdraw money
				if currentBank >= value then
					newValue = currentBank - tonumber(value)

					MySQL.Async.execute('UPDATE shops_owned SET `bank` = @newBank WHERE shop = @shop', {
						['@newBank'] = newValue,
						['@shop'] = passedshop,
					})

					xPlayer.addAccountMoney('bank', value, ('%s (%s) [%s]'):format('Player Shop Withdraw', passedshop, GetCurrentResourceName()))
					print("RPUK TRANSACTION: Shop Bank > [" .. type .. "][" .. passedshop .. "] OLD:[" .. currentBank .. "] NEW:[".. newValue .."] DIFF:[" .. value .. "]")
					result, message = true, "£"..value.." Transfered!"
				else
					result, message = false, "Insufficient Bank Funds!"
				end
			elseif type == "deposit" then -- player clicked deposit money
				if xPlayer.getAccount('bank').money >= tonumber(value) then
					newValue = currentBank + tonumber(value)

					MySQL.Async.execute('UPDATE shops_owned SET `bank` = @newBank WHERE shop = @shop', {
						['@newBank'] = newValue,
						['@shop'] = passedshop,
					})

					xPlayer.removeAccountMoney('bank', value, ('%s (%s) [%s]'):format('Player Shop Deposit', passedshop, GetCurrentResourceName()))
					print("RPUK TRANSACTION: Shop Bank > [" .. type .. "][" .. passedshop .. "] OLD:[" .. currentBank .. "] NEW:[".. newValue .."] DIFF:[" .. value .. "]")
					result, message = true, "£"..value.." Transfered!"
				else
					result, message = false, "Insufficient Bank Funds!"
				end
			else
				result, message = false, "Something went wrong!"
			end

			found = found + 1
		else
			result, message = false, "Something Went Wrong"
			found = found + 1
		end
	end)

	while result == nil or message == nil do Citizen.Wait(10) end
	xPlayer.showAdvancedNotification('Pegasus Delivery & Retail', "", message, 'CHAR_PEGASUS_DELIVERY', 0)
	cb(result, newValue)
end)

RegisterNetEvent('rpuk_stock:alterOrder')
AddEventHandler('rpuk_stock:alterOrder', function(orderNumber, callType)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local identifier = ESX.GetPlayerFromId(playerId).identifier

	if callType == "cancel_order" then
		orderStatus("cancelled", orderNumber)
	elseif callType == "accept_delivery" then
		MySQL.Async.fetchAll('SELECT * FROM shop_orders WHERE id = @orderNumber', {
			['@orderNumber'] = orderNumber
		}, function(shopResult)
			if tostring(shopResult[1]["status"]) == "delivered" then
				if tostring(shopResult[1]["order_type"]) == "raw" or tostring(shopResult[1]["order_type"]) == "manu" then
					xPlayer.addInventoryItem(shopResult[1]["product"], shopResult[1]["quantity"])
					orderStatus("complete", orderNumber)
				elseif tostring(shopResult[1]["order_type"]) == "vehicle" then
					TriggerClientEvent('rpuk_stock:accepted_deliv', xPlayer.playerId, shopResult[1].shop, shopResult[1].product)
					orderStatus("complete", orderNumber)
				end
			end
		end)
	end

	print("RPUK TRANSACTION: ORDER ALTERATION (Caller: " .. identifier .. "; Order ID: " .. orderNumber .. "; Call Type: " .. callType .. ")")
end)

function orderStatus(status, orderId)
	MySQL.Async.execute('UPDATE shop_orders SET status = @status WHERE id = @orderNumber', {
		['@status'] = status,
		['@orderNumber'] = orderId
	})
end

function triggerNotification()
	-- check all players
	-- send tweet / warehouse update
end

function ConvertTime(Unix) -- returns the table in a readable form // print the return
	local UnixConvert = tonumber(math.floor(Unix))
	local mil2sec = UnixConvert / 1000
	local date = os.date("*t", mil2sec)
	local passback = date.day .. "-" .. date.month .. "-" .. date.year .. " " .. date.hour .. ":" .. date.min
	return passback
end