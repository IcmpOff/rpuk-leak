local ShopItems = {}
local ShopKeepers = {}
local ProcessingTimer = 2000

--items that shopkeepers automatically convert when stocking
local itemSwaps = {
	["unripe_apple"] = "apple",
	["unripe_orange"] = "orange"
}

function ConvertDays(Unix)
	local UnixConvert = tonumber(math.floor(Unix))
	local mil2sec = UnixConvert / 1000
	local date = os.date("*t", mil2sec)
	local passback = date.day .. "/" .. date.month .. "/" .. date.year
	return passback
end

ESX.RegisterServerCallback('rpuk_shops:requestShopkeeper', function(source, cb, zone) -- Checks if the player can manage a shop
	local identifier = ESX.GetPlayerFromId(source).identifier
	local xPlayer = ESX.GetPlayerFromId(source)
	local CanManage = 0 -- {0=false, 1=true, 2=purchasable, 3 = worker}
	local worker = false
	MySQL.Async.fetchAll( -- do they own any shop
		'SELECT * FROM shops_owned WHERE shop = @zone',
	{
		['@zone'] = zone
	}, function(result)
		result = result[1]
		if result ~= nil then -- This shop exists in the db
			if result.shop == zone then
				if result.keeper ~= "none" and result.keeper ~= "gov" then
					if result.status == "closed" and (xPlayer.job.name == "city" and xPlayer.job.grade == 2) then
						CanManage = 1--This is the allow access
						cb(CanManage)
					elseif result.keeper == identifier then
						CanManage = 1--This is the allow access
						cb(CanManage)
					else
						local workers = json.decode(result["workers"])
						for _, data in pairs(workers) do
							if data == identifier then
								CanManage = 3--This is the allow access
								cb(CanManage)
								worker = true
							else
								CanManage = 0
								cb(CanManage)
							end
						end
						if not worker then
							TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = "error", text = "You can not use this."})
							CanManage = 0
							cb(CanManage)
						end
					end
				elseif result.keeper == "none" then
					if xPlayer.job.name == "city" and xPlayer.job.grade == 2 then
						CanManage = 1--This is the allow access
						cb(CanManage)
					else
						CanManage = 2 --Purchasable
						cb(CanManage)
					end
				elseif result.keeper == "gov" then
					if xPlayer.job.name == "city" and xPlayer.job.grade == 2 then
						CanManage = 1--This is the allow access
						cb(CanManage)
					else
						CanManage = 0
						cb(CanManage)
						TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = "error", text = "This is owned by the council, if you wish to own this please contact the council."})
					end
				end
			else
				CanManage = 0
				cb(CanManage)
			end
		else
			CanManage = 0
			cb(CanManage)
		end
	end)
end)

ESX.RegisterServerCallback('rpuk_shops:priceCheck', function(source, cb, zone)
	MySQL.Async.fetchAll('SELECT * FROM shops_owned WHERE shop = @zone', {
		['@zone'] = zone
	}, function (shop)
		shop = shop[1]
		cb(shop.shopPrice)
	end)
end)

ESX.RegisterServerCallback('rpuk_shops:purchase_business', function(source, cb, zone)
	local identifier = ESX.GetPlayerFromId(source).identifier
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM shops_owned WHERE shop = @zone', {
		['@zone'] = zone
	}, function (shop)
		shop = shop[1]
		if shop["keeper"] == "none" then
			if xPlayer.getAccount("bank")["money"] >= shop.shopPrice then
				cb(true, "Purchased Business.\nGood luck with your new business. For any questions and guides please visit Roleplay.co.uk.")
				xPlayer.removeAccountMoney('bank', shop.shopPrice, ('%s (%s) [%s]'):format('Business Purchased', zone, GetCurrentResourceName()))
				MySQL.Async.execute('UPDATE shops_owned SET keeper = @keeper, status = "open" WHERE id = @shopID', {
					['@shopID'] = shop.id,
					['@keeper'] = identifier
				})
				print('RPUK PROPERTY - SHOP: PURCHASED - ' .. identifier .. "[".. shop["id"] .."] " ..	"[".. shop["shop"] .."]" .. "[".. shop["keeper"] .."]" .. " ostime: " .. os.time())
			else
				cb(false, "You need £"..ESX.Math.GroupDigits(shop.shopPrice).. " in your bank to purchase this business!")
			end
		else
			cb(false, "This business isn't available for purchase")
		end
	end)
end)

ESX.RegisterServerCallback('rpuk_shops:callback_buysell', function(source, cb, buyorsell, zone)
	if buyorsell == "buy_menu" then
		MySQL.Async.fetchAll('SELECT * FROM shops LEFT JOIN items ON items.name = shops.item WHERE store = @zone AND price > 0', {
			['@zone'] = zone
		}, function (buyResults)
			local buyItems = {}

			for k,v in ipairs(buyResults) do
				local label -- format the end visual label
				if v.trade == 'cash' or v.trade == 'blackmoney' or v.trade == 'bank' then
					label = ('%s <img width="20" height="20" src="nui://rpuk_inventory/html/img/items/%s.png"/> ' ..
					'(<span style="color:lightgreen;">%s%s</span>)')
					:format(v.label, v.item, v.trade_label, ESX.Math.GroupDigits(v.price))
				else
					label = ('%s <img width="20" height="20" src="nui://rpuk_inventory/html/img/items/%s.png"/> (x%s %s)')
					:format(v.label, v.item, ESX.Math.GroupDigits(v.price), v.trade_label)
				end

				if v.available ~= -1 and v.available == 0 then
					label = label .. " (Out Of Stock)"
				end

				table.insert(buyItems, {
					id = v.id,
					keeper = v.keeper,
					label = label,
					item = v.item,
					price = v.price,
					sellprice = v.sellprice,
					trade = v.trade,
					available = v.available,
					type = 'slider',
					value = 0,
					max = v.weight == 0 and 500000 or 50
				})
			end

			cb(buyItems)
		end)
	elseif buyorsell == "sell_menu" then
		MySQL.Async.fetchAll('SELECT * FROM shops LEFT JOIN items ON items.name = shops.item WHERE store = @zone AND sellprice > 0', {
			['@zone'] = zone
		}, function (sellResults)
			local sellItems = {}

			for k,v in ipairs(sellResults) do
				local label -- format the end visual label

				if v.trade == 'cash' or v.trade == 'blackmoney' or v.trade == 'bank' then
					label = ('%s <img width="20" height="20" src="nui://rpuk_inventory/html/img/items/%s.png"/> ' ..
					'(<span style="color:lightgreen;">%s%s</span>)')
					:format(v.label, v.item, v.trade_label, ESX.Math.GroupDigits(v.sellprice))
				else
					label = ('%s <img width="20" height="20" src="nui://rpuk_inventory/html/img/items/%s.png"/> ' ..
					'(x%s %s)'):format(v.label, v.item, ESX.Math.GroupDigits(v.sellprice), v.trade_label)
				end

				--[[if v.available ~= -1 and v.available == 0 then
					label = label .. " (Out Of Stock)"
				end]]

				table.insert(sellItems, {
					id = v.id,
					keeper = v.keeper,
					label = label,
					item = v.item,
					price = v.price,
					sellprice = v.sellprice,
					trade = v.trade,
					available = v.available,
					type = 'slider',
					value = 0,
					max = v.weight == 0 and 500000 or 50
				})
			end

			cb(sellItems)
		end)
	end
end)

ESX.RegisterServerCallback('rpuk_shops:callback_buy', function(source, cb, itemID, quantity, zone)
	local xPlayer = ESX.GetPlayerFromId(source)

	if quantity < 1 then
		print('RPUK TRANSACTIONS: ' .. xPlayer.identifier .. ' RESTRICTION CHECK! AMOUNT < 0')
		cb(false)
	end

	MySQL.Async.fetchAll('SELECT * FROM shops WHERE id = @itemID', {
		['@itemID'] = itemID
	}, function(value)
		if value[1]["available"] == nil then -- Error with the fetch result
			print('RPUK TRANSACTION: ERROR value["available"]/result IS NIL FOR PASSED ITEM ID: ' .. itemID)
			cb(false)
		elseif value[1]["available"] == -1 then -- The shop has something to sell @ infinate quantity
			if xPlayer.canCarryItem(value[1]["item"], quantity) then -- Can they carry it?
				if value[1]["trade"] == "cash" then -- Check if the tender is cash
					if xPlayer.getMoney() >= value[1]["price"] * quantity then -- Can they afford?
						xPlayer.removeMoney(value[1]["price"] * quantity, ('%s (x%s%s) [%s]'):format('Shop Purchase Item', quantity, value[1]["item"], GetCurrentResourceName()))
						xPlayer.addInventoryItem(value[1]["item"], quantity)
						print('RPUK TRANSACTION: [BUY] ' .. xPlayer.identifier .. ' Purchased ' .. value[1]["item"] .. '[x' ..	quantity .. '] for ' .. value[1]["trade_label"] .. value[1]["price"] * quantity .. ' ['.. value[1]["trade"] ..']'	.. " ostime: " .. os.time())
						message = "Purchased!"
						cb(true, message)
					else
						message = "You don't have enough money."
						cb(false, message)
					end
				elseif value[1]["trade"] == "blackmoney" then	-- Check if the tender is black/dirty cash
					if xPlayer.getAccount('black_money').money >= value[1]["price"] * quantity then -- Can they afford?
						xPlayer.removeAccountMoney('black_money', value[1]["price"] * quantity, ('%s (x%s%s) [%s]'):format('Shop Purchase Item', quantity, value[1]["item"], GetCurrentResourceName()))
						xPlayer.addInventoryItem(value[1]["item"], quantity)
						print('RPUK TRANSACTION: [BUY] ' .. xPlayer.identifier .. ' Purchased ' .. value[1]["item"] .. '[x' ..	quantity .. '] for ' .. value[1]["trade_label"] .. value[1]["price"] * quantity .. ' ['.. value[1]["trade"] ..']'	.. " ostime: " .. os.time())
						message = "Purchased!"
						cb(true, message)
					else
						message = "You don't have enough money."
						cb(false, message)
					end
				elseif value[1]["trade"] == "bank" then	-- Check if the tender is bank transfer
					if xPlayer.getAccount('bank').money >= value[1]["price"] * quantity then -- Can they afford?
						xPlayer.removeAccountMoney('bank', value[1]["price"] * quantity, ('%s (x%s%s) [%s]'):format('Shop Purchase Item', quantity, value[1]["item"], GetCurrentResourceName()))
						xPlayer.addInventoryItem(value[1]["item"], quantity)
						print('RPUK TRANSACTION: [BUY] ' .. xPlayer.identifier .. ' Purchased ' .. value[1]["item"] .. '[x' ..	quantity .. '] for ' .. value[1]["trade_label"] .. value[1]["price"] * quantity .. ' ['.. value[1]["trade"] ..']'	.. " ostime: " .. os.time())
						message = "Purchased!"
						cb(true, message)
					else
						message = "You don't have enough money."
						cb(false, message)
					end
				else -- Fallback if the tender is an item
					local tender, finalQuan = value[1]["trade"], value[1]["price"] * quantity
					local invItem = xPlayer.getInventoryItem(tender)
					local itemCount = invItem.count
					if itemCount >= value[1]["price"] * quantity then -- Can they afford the trade?
						xPlayer.removeInventoryItem(tender, finalQuan)
						xPlayer.addInventoryItem(value[1]["item"], quantity)
						print('RPUK TRANSACTION: [BUY] ' .. xPlayer.identifier .. ' Purchased ' .. value[1]["item"] .. '[x' ..	quantity .. '] for ' .. value[1]["trade_label"] .. value[1]["price"] * quantity .. ' ['.. value[1]["trade"] ..']'	.. " ostime: " .. os.time())
						message = "Purchased!"
						cb(true, message)
					else
						message = "You don't have enough " .. invItem.label
						print(message)
						cb(false, message)
					end
				end
			else
				message = "You don't have enough inventory space."
				cb(false, message)
			end
		elseif value[1]["available"] >= quantity then -- The store has stock and we can fulfill the buy request
			if xPlayer.canCarryItem(value[1]["item"], quantity) then -- Can they carry it?
				if value[1]["trade"] == "cash" then -- Check if the tender is cash
					if xPlayer.getMoney() >= value[1]["price"] * quantity then -- Can they afford?
						xPlayer.removeMoney(value[1]["price"] * quantity, ('%s (x%s%s) [%s]'):format('Shop Purchase Item', quantity, value[1]["item"], GetCurrentResourceName()))
						AlterAvail("buy", itemID, quantity)
						xPlayer.addInventoryItem(value[1]["item"], quantity)
						print(zone)
						shopBank(zone, value[1]["price"] * quantity)

						print('RPUK TRANSACTION: [BUY-SQL] ' .. xPlayer.identifier .. ' Purchased ' .. value[1]["item"] .. '[x' ..	quantity .. '] for ' .. value[1]["trade_label"] .. value[1]["price"] * quantity .. ' ['.. value[1]["trade"] ..']'	.. " ostime: " .. os.time())
						message = "Purchased!"
						cb(true, message)
					else
						message = "You don't have enough money."
						cb(false, message)
					end
				elseif value[1]["trade"] == "blackmoney" then	-- Check if the tender is black/dirty cash
					if xPlayer.getAccount('black_money').money >= value[1]["price"] * quantity then -- Can they afford?
						xPlayer.removeAccountMoney('black_money', value[1]["price"] * quantity, ('%s (x%s%s) [%s]'):format('Shop Purchase Item', quantity, value[1]["item"], GetCurrentResourceName()))
						AlterAvail("buy", itemID, quantity)
						xPlayer.addInventoryItem(value[1]["item"], quantity)
						print('RPUK TRANSACTION: [BUY-SQL] ' .. xPlayer.identifier .. ' Purchased ' .. value[1]["item"] .. '[x' ..	quantity .. '] for ' .. value[1]["trade_label"] .. value[1]["price"] * quantity .. ' ['.. value[1]["trade"] ..']' .. " ostime: " .. os.time())
						message = "Purchased!"
						cb(true, message)
					else
						message = "You don't have enough money."
						cb(false, message)
					end
				elseif value[1]["trade"] == "bank" then	-- Check if the tender is bank transfer
					if xPlayer.getAccount('bank').money >= value[1]["price"] * quantity then -- Can they afford?
						xPlayer.removeAccountMoney('bank', value[1]["price"] * quantity, ('%s (x%s%s) [%s]'):format('Shop Purchase Item', quantity, value[1]["item"], GetCurrentResourceName()))
						AlterAvail("buy", itemID, quantity)
						xPlayer.addInventoryItem(value[1]["item"], quantity)
						print('RPUK TRANSACTION: [BUY-SQL] ' .. xPlayer.identifier .. ' Purchased ' .. value[1]["item"] .. '[x' ..	quantity .. '] for ' .. value[1]["trade_label"] .. value[1]["price"] * quantity .. ' ['.. value[1]["trade"] ..']'	.. " ostime: " .. os.time())
						message = "Purchased!"
						cb(true, message)
					else
						message = "You don't have enough money."
						cb(false, message)
					end
				else -- Fallback if the tender is an item
					local tender, finalQuan = value[1]["trade"], value[1]["price"] * quantity
					local invItem = xPlayer.getInventoryItem(tender)
					local itemCount = invItem.count
					if itemCount >= value[1]["price"] * quantity then -- Can they afford the trade?
						xPlayer.removeInventoryItem(tender, finalQuan)
						AlterAvail("buy", itemID, quantity)
						xPlayer.addInventoryItem(value[1]["item"], quantity)
						print('RPUK TRANSACTION: [BUY-SQL] ' .. xPlayer.identifier .. ' Purchased ' .. value[1]["item"] .. '[x' ..	quantity .. '] for ' .. value[1]["trade_label"] .. value[1]["price"] * quantity .. ' ['.. value[1]["trade"] ..']'	.. " ostime: " .. os.time())
						message = "Purchased!"
						cb(true, message)
					else
						message = "You don't have enough " .. invItem.label
						print(message)
						cb(false, message)
					end
				end
			else
				message = "You don't have enough inventory space."
				cb(false, message)
			end
		else -- fallback not enough quantity
			message = "The shop doesn't have that quantity!"
			print(message)
			cb(false, message)
		end
	end)
end)

function shopBank(shop, add)
	if Config.Zones[shop]["Keeper"] == "player" then
	MySQL.Async.fetchAll("SELECT bank FROM shops_owned WHERE shop=@shop", {
			['@shop'] = shop
		}, function(data)
			if data[1]["bank"] then -- if it exists
				MySQL.Async.execute('UPDATE shops_owned SET `bank` = @newBank WHERE shop = @shop', {
					['@newBank'] = data[1]["bank"] + tonumber(add),
					['@shop'] = shop
				})

			end
		end)
	end
end


ESX.RegisterServerCallback('rpuk_shops:callback_sell', function(source, cb, itemID, quantity)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM shops WHERE id = @itemID', {
		['@itemID'] = itemID
	}, function(value)
		if value[1]["id"] == nil then -- Error with the fetch result
			print('RPUK TRANSACTION: ERROR value["id"]/result IS NIL FOR PASSED ITEM ID: ' .. itemID)
			cb(false)
		elseif value[1]["available"] == -1 then -- Sell with no DB changes
			local xItem = xPlayer.getInventoryItem(value[1]["item"]) -- check the player has the item
			if xItem.count >= quantity then -- player has enough to sell
				if value[1]["trade"] == "cash" then -- remove item give cash
					xPlayer.addMoney(value[1]["sellprice"] * quantity, ('%s %s [%s]'):format('Shop Sale', value[1]["item"], GetCurrentResourceName()))
					xPlayer.removeInventoryItem(value[1]["item"], quantity)
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'inform', text = ('You sold x%s %s for £%s '):format(quantity, value[1]["item"], value[1]["sellprice"] * quantity) })
					cb(true)
				elseif value[1]["trade"] == "blackmoney" then -- remove then give black money
					xPlayer.addAccountMoney('black_money', value[1]["sellprice"] * quantity, ('%s %s [%s]'):format('Shop Sale', value[1]["item"], GetCurrentResourceName()))
					xPlayer.removeInventoryItem(value[1]["item"], quantity)
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'inform', text = ('You sold x%s %s for £%s '):format(quantity, value[1]["item"], value[1]["sellprice"] * quantity) })
					cb(true)
				elseif value[1]["trade"] == "bank" then -- remove then give black money
					xPlayer.addAccountMoney('bank', value[1]["sellprice"] * quantity, ('%s %s [%s]'):format('Shop Sale', value[1]["item"], GetCurrentResourceName()))
					xPlayer.removeInventoryItem(value[1]["item"], quantity)
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'inform', text = ('You sold x%s %s for £%s '):format(quantity, value[1]["item"], value[1]["sellprice"] * quantity) })
					cb(true)
				else -- remove item and give replace
					xPlayer.addInventoryItem(value[1]["trade"], value[1]["sellprice"])
					xPlayer.removeInventoryItem(value[1]["item"], quantity)
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'inform', text = ('You sold x%s %s for x%s %s'):format(quantity, value[1]["item"], value[1]["sellprice"], value[1]["trade"]) })
					cb(true)
				end
			else -- not enough to sell
				cb(false)
			end
		else -- sell with db change
			local xItem = xPlayer.getInventoryItem(value[1]["item"]) -- check the player has the item
			if xItem.count >= quantity then -- player has enough to sell
				if value[1]["trade"] == "cash" then -- remove item give cash
					AlterAvail("sell", itemID, quantity)
					xPlayer.addMoney(value[1]["sellprice"] * quantity, ('%s %s [%s]'):format('Shop Sale', value[1]["item"], GetCurrentResourceName()))
					xPlayer.removeInventoryItem(value[1]["item"], quantity)
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'inform', text = ('You sold x%s %s for £%s '):format(quantity, value[1]["item"], value[1]["sellprice"] * quantity) })
					cb(true)
				elseif value[1]["trade"] == "blackmoney" then -- remove then give black money
					AlterAvail("sell", itemID, quantity)
					xPlayer.addAccountMoney('black_money', value[1]["sellprice"] * quantity, ('%s %s [%s]'):format('Shop Sale', value[1]["item"], GetCurrentResourceName()))
					xPlayer.removeInventoryItem(value[1]["item"], quantity)
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'inform', text = ('You sold x%s %s for £%s '):format(quantity, value[1]["item"], value[1]["sellprice"] * quantity) })
					cb(true)
				elseif value[1]["trade"] == "bank" then -- remove then give black money
					AlterAvail("sell", itemID, quantity)
					xPlayer.addAccountMoney('bank', value[1]["sellprice"] * quantity, ('%s %s [%s]'):format('Shop Sale', value[1]["item"], GetCurrentResourceName()))
					xPlayer.removeInventoryItem(value[1]["item"], quantity)
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'inform', text = ('You sold x%s %s for £%s '):format(quantity, value[1]["item"], value[1]["sellprice"] * quantity) })
					cb(true)
				else -- remove item and give replace
					AlterAvail("sell", itemID, quantity)
					xPlayer.addInventoryItem(value[1]["trade"], value[1]["sellprice"])
					xPlayer.removeInventoryItem(value[1]["item"], quantity)
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 9000, type = 'inform', text = ('You sold x%s %s for x%s %s'):format(quantity, value[1]["item"], value[1]["sellprice"], value[1]["trade"]) })
					cb(true)
				end
			else -- not enough to sell
				cb(false)
			end
		end
	end)
end)

function AlterAvail(callType, itemID, byValue) -- Execute the change on the DB
	MySQL.Async.fetchAll('SELECT * FROM shops WHERE id = @itemID', {
		['@itemID'] = itemID
	}, function(shopResult)
		for i=1, #shopResult, 1 do
			if callType == "buy" then
				local newValue = shopResult[i].available - byValue
				MySQL.Async.execute('UPDATE shops SET available = @newValue WHERE id = @itemID', {
					['@itemID'] = itemID,
					['@newValue'] = newValue
				})
			elseif callType == "sell" then
				local newValue = shopResult[1].available + byValue
				MySQL.Async.execute('UPDATE shops SET available = @newValue WHERE id = @itemID', {
					['@itemID'] = itemID,
					['@newValue'] = newValue
				})
			end
		end
	end)
end

ESX.RegisterServerCallback('rpuk_shops:callStock', function(source, cb, callType, shopID)
	local identifier = ESX.GetPlayerFromId(source).identifier
	if callType == "stock_call_current" then
		MySQL.Async.fetchAll('SELECT id, store, item, price, available FROM shops WHERE store = @shopID ORDER BY id DESC', {
			['@shopID'] = shopID
		}, function (result)
			local stock = {}
			for i=1, #result, 1 do
				table.insert(stock, {
					id		= result[i].id,
					store 	= result[i].store,
					item 	= result[i].item,
					price 	= result[i].price,
					quantity 	= result[i].available,
				})
			end
			cb(stock)
		end)
	end
end)

ESX.RegisterServerCallback('rpuk_shops:callAvailable', function(source, cb, callType, shopID)
	local identifier = ESX.GetPlayerFromId(source).identifier
	if callType == "orders_call_available" then -- Placing a new stock order // so return the available list of items a shop can stock
		MySQL.Async.fetchAll('SELECT name, label FROM items WHERE can_stock = 1', {
		}, function (result)
			local itemList = {}
			for i=1, #result, 1 do
				table.insert(itemList, {
					item		= result[i].name,
					label 	= result[i].label,
				})
			end
			cb(itemList)
		end)
	end
end)

ESX.RegisterServerCallback('rpuk_shops:getInventory', function(source, cb, callType, vehPlate, orderID)
	local identifier = ESX.GetPlayerFromId(source).identifier
	local xPlayer = ESX.GetPlayerFromId(source)
	local cbResult = false

	if callType == "user" then
		local inventory = {}
		for k, v in pairs(xPlayer.inventory) do
			if v.count > 0 then
				table.insert(inventory, {
					label	 = v.label,
					item	 = v.name,
					count 	= v.count,
				})
			end
		end
		cb(inventory)
	elseif callType == "delivery" then -- get the vehicle inventory
		MySQL.Async.fetchAll('SELECT * FROM shop_orders WHERE id = @orderID', {
			['@orderID'] = orderID
		}, function (result)
			if result then
				local item, quantity = result[1]["product"], result[1]["quantity"]
				local driverPrice = result[1]["payment"] + result[1]["payment"] * 0.1 -- the 10% of the price
				for index, data in pairs(itemSwaps) do -- swap the items
					if data == item then
						item = index
						break
					end
				end
				MySQL.Async.fetchAll('SELECT data FROM trunk_inventory WHERE plate = @plate', {
					['@plate'] = vehPlate
				}, function (result2)
					if result2 and result2[1] then
						local data = (result2[1].data == nil and {} or json.decode(result2[1].data))
						local tablecount = ESX.Table.SizeOf(data["coffre"]) -- get how many elements

						for i=tablecount,1,-1 do -- go through the table and find the object
							if data["coffre"][i]["name"] == item and quantity <= data["coffre"][i]["count"] then -- if the vehicle inventory quantity and item == the order quantity and item
								data["coffre"][i]["count"] = data["coffre"][i]["count"] - quantity -- set the value in the table to 0

								MySQL.Async.execute('UPDATE trunk_inventory SET data = @data WHERE plate = @plate', {
									['@plate'] = vehPlate,
									['@data'] = json.encode(data) -- re-encode to json and send that bollox to the inventory
								})

								Citizen.Wait(100)
								MySQL.Async.execute('UPDATE shop_orders SET status = @status WHERE id = @orderNumber', {
									['@status'] = "delivered",
									['@orderNumber'] = orderID
								})

								notifyFulfilled(orderID)
								print("RPUK TRANSACTION: ORDER FULFILLED " .. xPlayer.identifier .. " ORDER: " .. orderID)
								TriggerEvent('rpuk_inventory:updateInventory', vehPlate) -- remote update the vehicle inventory for the peoples
								xPlayer.addAccountMoney("bank", driverPrice, ('%s [%s]'):format('Shop Delivery Payout', GetCurrentResourceName()))
								cbResult = true
							end
						end

						cb(cbResult)
					else
						cb(cbResult)
					end
				end)
			else
				cb(cbResult)
			end
		end)

	end
	if cbResult then print("RPUK TRANSACTION: ORDER ALTERATION (Caller: " .. identifier .. "; Order ID: " .. orderID .. "; Call Type: " .. callType .. ") [Result: " .. tostring(cbResult) .."]") end -- log if great success
end)

function notifyFulfilled(orderNo, passedStreetName)
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'delivery' then
			xPlayer.showAdvancedNotification('Delivery Job', "Order: " .. orderNo, "Order was fulfilled by a delivery driver.", 'CHAR_CARSITE', 1)
		end
	end
end

ESX.RegisterServerCallback('rpuk_shops:stockInput', function(source, cb, zone, itemName, itemQuantity, unitPrice)

	local identifier = ESX.GetPlayerFromId(source).identifier
	local xPlayer = ESX.GetPlayerFromId(source)
	local sellprice = -1

	local xItem = xPlayer.getInventoryItem(itemName) --count the input items before any swaps!

	local swappedItemName = nil
	for k, v in pairs(itemSwaps) do
		if itemName == k then
			print("swapping "..k.." for "..v)
			swappedItemName = k
			itemName = v
			break
		end
	end
	print(zone, itemName, itemQuantity, unitPrice)
	local finalResult = false

	if xItem.count >= itemQuantity then
		MySQL.Async.fetchAll('SELECT * FROM shops WHERE available >= 0 AND item = @name AND store = @zone', {
			['@name'] = itemName,
			['@zone'] = zone,
		}, function (result)
			--print(result[1])
			if result[1] ~= nil then -- is there anything there
				local NewAmount = result[1]["available"] + itemQuantity
				MySQL.Async.execute('UPDATE shops SET available = @available, price = @price WHERE store = @zone AND item = @itemName', {
					['@available'] = NewAmount,
					['@zone'] = zone,
					['@price'] = unitPrice,
					['@itemName']	= itemName
				}, function (ExecResult)
					if ExecResult then
						if swappedItemName then
							xPlayer.removeInventoryItem(swappedItemName, itemQuantity)
						else
							xPlayer.removeInventoryItem(itemName, itemQuantity)
						end
						ESX.SavePlayer(xPlayer, function()
							ESX.Players[source] = nil
						end)
						finalResult = true
						print("COMPLETED: UPDATED PREVIOUS ENTRY")
						cb(finalResult)
					else
						finalResult = false
						print("FAILED: UPDATED PREVIOUS ENTRY FAILED")
						cb(finalResult)
					end
				end)
			else -- no entry
				MySQL.Async.execute('INSERT INTO shops (keeper, store, item, price, sellprice, trade, trade_label, available) VALUES (@keeper, @zone, @itemName, @price, @sellprice, @trade, @trade_label, @available)', {
					['@keeper']		= identifier,
					['@zone']		= zone,
					['@itemName']	= itemName,
					['@price']	= unitPrice,
					['@sellprice']	= sellprice,
					['@trade']	= "cash",
					['@trade_label']	= "£",
					['@available']	= itemQuantity
				}, function (ExecResult)
					if ExecResult then
						if swappedItemName then
							xPlayer.removeInventoryItem(swappedItemName, itemQuantity)
						else
							xPlayer.removeInventoryItem(itemName, itemQuantity)
						end
						ESX.SavePlayer(xPlayer, function()
							ESX.Players[source] = nil
						end)
						finalResult = true
						print("COMPLETED: INSERTED NEW")
						cb(finalResult)
					else
						finalResult = false
						print("FAILED: INSERTED NEW")
						cb(finalResult)
					end
				end)
			end
		end)
	else
		finalResult = false
		print("FAILED: QUANTITY")
		cb(finalResult)
	end
end)

RegisterNetEvent('rpuk_shops:alterStock')
AddEventHandler('rpuk_shops:alterStock', function(callType, stockID, zone)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = ESX.GetPlayerFromId(source).identifier
	if callType == "stock_withdraw" then
		MySQL.Async.fetchAll('SELECT * FROM shops WHERE id = @stockID', { -- Withdraw everything from a shop entry and delete the entry
			['@keeper'] = identifier,
			['@stockID'] = stockID
		}, function(stockResult)
			for i=1, #stockResult, 1 do
				if stockResult[i].id == stockID then
					xPlayer.addInventoryItem(stockResult[i].item, stockResult[i].available)
					MySQL.Async.execute('DELETE FROM shops WHERE store = @zone AND id = @stockID', {
						['@zone'] = zone,
						['@stockID'] = stockID
					})
				else
					print("RPUK TRANSACTION: ORDER ERROR/EXPLOIT (Caller: " .. identifier .. "; Stock ID: " .. stockID .. "; Call Type: " .. callType .. ")")
				end
			end
		end)
	end
	print("RPUK TRANSACTION: STOCK ALTERATION (Caller: " .. identifier .. "; Order ID: " .. stockID .. "; Call Type: " .. callType .. ")")
end)

ESX.RegisterServerCallback('rpuk_shops:generateOrder', function(source, cb, callType, zone, item, itemQuantity, offeredPrice)
	local identifier = ESX.GetPlayerFromId(source).identifier
	local xPlayer = ESX.GetPlayerFromId(source)
	local result = false
	local message = "Something went wrong..."
	local newPrice = itemQuantity * offeredPrice
	if callType == "stock_new_order" then
		if xPlayer.getAccount("bank")["money"] >= newPrice then -- switch to the company bank when available
			xPlayer.removeAccountMoney("bank", newPrice, ('%s [%s]'):format('Generate new order', GetCurrentResourceName())) -- switch to the company bank when available
			message = "Ordered x" .. itemQuantity .. " (" .. item .. ") for ~g~£" .. newPrice
			result = true
			local keeper, shop, product, quantity, payment = identifier, zone, item, itemQuantity, newPrice
			MySQL.Async.execute('INSERT INTO shop_orders (keeper, shop, product, quantity, payment) VALUES (@keeper, @shop, @product, @quantity, @payment)', {
				['@keeper']		= keeper,
				['@shop']		= shop,
				['@product']	= product,
				['@quantity']	= quantity,
				['@payment']	= payment
			}, function (ExecResult)
				if ExecResult then
					print("RPUK TRANSACTION: ORDER GENERATED (Keeper: " .. keeper .. "; Shop: " .. shop .. "; Product: " .. product .."; Quantity: " .. quantity .. "; Offer/Payment: " .. payment .. ")[SUCCESS]")
				else
					print("RPUK TRANSACTION: ORDER FAILED (Keeper: " .. keeper .. "; Shop: " .. shop .. "; Product: " .. product .."; Quantity: " .. quantity .. "; Offer/Payment: " .. payment .. ")[FAILED]")
				end
			end)
		else
			message = "Unable to afford x" .. itemQuantity .. " (" .. item .. ") for ~g~£" .. newPrice
			result = false
			print("RPUK TRANSACTION: STOCK ORDER " .. xPlayer.identifier .. " Failed [" .. item .. "][" .. itemQuantity .."] for [£" .. newPrice .. "] at " .. zone .. "] (FUNDS)")
		end
	end
	cb(result, message)
end)

ESX.RegisterServerCallback('rpuk_shops:callOrders', function(source, cb, callType, shopID)
	local identifier = ESX.GetPlayerFromId(source).identifier
	if callType == "orders_call_current" then -- Returns the current stock orders for the passed shopID
		MySQL.Async.fetchAll('SELECT id, shop, product, quantity, payment, created, status FROM shop_orders WHERE keeper = @identifier AND shop = @shopID AND status !="cancelled" ORDER BY created ASC', {
			['@identifier'] = identifier,
			['@shopID'] = shopID
		}, function (result)
			local orders = {}
			for i=1, #result, 1 do
				local creationResult = ConvertTime(result[i].created)
				table.insert(orders, {
					id		= result[i].id,
					shop 	= result[i].shop,
					product 	= result[i].product,
					quantity 	= result[i].quantity,
					payment 	= result[i].payment,
					created 	= creationResult,
					status 	= result[i].status,
				})
			end
			cb(orders)
		end)
	elseif callType == "order_call_goodsin" then
		MySQL.Async.fetchAll('SELECT id, shop, product, quantity, payment, created, status FROM shop_orders WHERE shop = @shopID AND status="placed" ORDER BY created ASC', {
			['@identifier'] = identifier,
			['@shopID'] = shopID
		}, function (result)
			local orders = {}
			for i=1, #result, 1 do
				local creationResult = ConvertTime(result[i].created)
				table.insert(orders, {
					id		= result[i].id,
					shop 	= result[i].shop,
					product 	= result[i].product,
					quantity 	= result[i].quantity,
					payment 	= result[i].payment,
					created 	= creationResult,
					status 	= result[i].status,
				})
			end
			cb(orders)
		end)
	elseif callType == "order_call_available" then
		MySQL.Async.fetchAll('SELECT id, shop, product, quantity, payment, created, status FROM shop_orders WHERE status="placed" ORDER BY created ASC', {
			['@identifier'] = identifier,
			['@shopID'] = shopID
		}, function (result)
			local orders = {}
			for i=1, #result, 1 do
				local creationResult = ConvertTime(result[i].created)
				table.insert(orders, {
					id		= result[i].id,
					shop 	= result[i].shop,
					product 	= result[i].product,
					quantity 	= result[i].quantity,
					payment 	= result[i].payment,
					created 	= creationResult,
					status 	= result[i].status,
				})
			end
			cb(orders)
		end)
	end
end)

RegisterNetEvent('rpuk_shops:alterOrder')
AddEventHandler('rpuk_shops:alterOrder', function(orderNumber, callType)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = ESX.GetPlayerFromId(source).identifier
	print("Triggered: " ..	orderNumber .. callType)
	if callType == "cancel_order" then
		MySQL.Async.execute('UPDATE shop_orders SET status = @status WHERE id = @orderNumber', {
			['@status'] = "cancelled",
			['@orderNumber'] = orderNumber
		})
	elseif callType == "accept_delivery" then
		MySQL.Async.execute('UPDATE shop_orders SET status = @status WHERE id = @orderNumber', {
			['@status'] = "complete",
			['@orderNumber'] = orderNumber
		})
		MySQL.Async.fetchAll('SELECT * FROM shop_orders LEFT JOIN items ON items.name = shop_orders.product WHERE id = @orderNumber', {
			['@orderNumber'] = orderNumber
		}, function(shopResult)
			for i=1, #shopResult, 1 do
				if shopResult[i].name then
					xPlayer.addInventoryItem(shopResult[i].name, shopResult[i].quantity)
					-- Trigger advanced notif
				else
					print("RPUK TRANSACTION: ORDER ERROR/EXPLOIT (Caller: " .. identifier .. "; Order ID: " .. orderNumber .. "; Call Type: " .. callType .. ")")
				end
			end
		end)
	end
	print("RPUK TRANSACTION: ORDER ALTERATION (Caller: " .. identifier .. "; Order ID: " .. orderNumber .. "; Call Type: " .. callType .. ")")
end)

RegisterNetEvent('rpuk_logs:commitLog')
AddEventHandler('rpuk_logs:commitLog', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('INSERT INTO logs (identifier, resource, purchased, pur_quantity, ) VALUES (@source, @shop, @product, @quantity, @payment)', {
		['@status'] = "complete",
		['@orderNumber'] = orderNumber
	})

	print('RPUK TRANSACTION: [BUY] ' .. xPlayer.identifier .. ' Purchased ' .. value[1]["item"] .. '[x' ..	quantity .. '] for ' .. value[1]["trade_label"] .. value[1]["price"] * quantity .. ' ['.. value[1]["trade"] ..']' )
end)

RegisterNetEvent('rpuk_shop:sellupShop')
AddEventHandler('rpuk_shop:sellupShop', function(shop)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE shops_owned SET keeper = "none" WHERE shop = @shop', {
		['@shop'] = shop
	})
	print('RPUK SHOPS: [RELEASE] ' .. xPlayer.identifier .. ' GAVE UP ' .. shop)

	xPlayer.showNotification('Very well, you no longer own this shop.')
end)

ESX.RegisterServerCallback('rpuk_shops:transferShopOwner', function(playerId, cb, id, zone)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local xTarget = ESX.GetPlayerFromId(id)

	if playerId == id then
		xPlayer.showNotification('Transfer ownership to yourself? Why?', 5000, 'error')
		cb(false)
	else
		if xTarget then
			MySQL.Async.fetchAll('SELECT * FROM shops_owned WHERE shop = @zone', {
				['@zone'] = zone
			}, function (shop)
				shop = shop[1]

				MySQL.Async.execute('UPDATE shops_owned SET keeper = @keeper, workers = "{}" WHERE id = @shopID', {
					['@shopID'] = shop["id"],
					['@keeper'] = xTarget.getIdentifier()
				})
			end)

			TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { length = 6000, type = 'inform', text = 'You have now transferred ownership of the buissness to '..xTarget.getFullName()})

			TriggerEvent('gcPhone:_internalAddMessage', xPlayer.phoneNumber, xTarget.phoneNumber, 'You now have ownership of '..zone.. ' authorised by '.. xPlayer.getFullName(), 0, function(object)
				TriggerClientEvent('gcPhone:receiveMessage', xTarget.source, object)
			end)

			print('RPUK SHOPS: [Transfter] ' .. xPlayer.identifier .. ' Transferd Ownership to ' .. xTarget.getIdentifier() .. ' ' .. zone)
			cb(true)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', playerId, { length = 6000, type = 'info', text = 'Invaild ID'})
			print('RPUK SHOPS: [Transfter] ' .. xPlayer.identifier .. ' Ownership Failed to transfer' .. ' ' .. zone)
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('rpuk_shops:fetchStatus', function(source, cb, zone)
	local result = MySQL.Sync.fetchAll("SELECT * FROM shops_owned WHERE shop = @zone", {
		['@zone'] = zone
	})[1]

	if result then
		cb(result)
	else
		cb("npcStore")
	end
end)

ESX.RegisterServerCallback('rpuk_shops:fetchWarrant', function(source, cb, id)
	local result = MySQL.Sync.fetchAll('SELECT * FROM warrants WHERE business_id = @zone AND status = "accepted"', {
		['@zone'] = id
	})[1]
	cb(result)
end)

RegisterNetEvent('rpuk_shop:changeStatusOfShop')
AddEventHandler('rpuk_shop:changeStatusOfShop', function(shopID, status)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Sync.execute('UPDATE shops_owned SET status = @status WHERE id = @shopID', {
		['@shopID'] = shopID,
		['@status'] = status
	})

	if status == "closed" then
		MySQL.Sync.execute("UPDATE warrants SET status = 'completed', executed_date = current_timestamp(), warrant_executed_by = @name WHERE business_id = @shopID", {
			['@shopID'] = shopID,
			["@name"] = xPlayer.firstname .. " " .. xPlayer.lastname
		})

		print('RPUK SHOPS: [RELEASE] ' .. xPlayer.identifier .. ' Closed Down ' .. shopID)
	else
		print('RPUK SHOPS: [RELEASE] ' .. xPlayer.identifier .. ' Opened UP ' .. shopID)
	end
end)

function ConvertTime(Unix) -- returns the table in a readable form // print the return
	local UnixConvert = tonumber(math.floor(Unix))
	local mil2sec = UnixConvert / 1000
	local date = os.date("*t", mil2sec)
	--Final Display Format DD-MM-YYYY HH:MM (year, month, day, hour, min, sec, wday)
	local passback = date.day .. "-" .. date.month .. "-" .. date.year .. " " .. date.hour .. ":" .. date.min
	--print("RPUK DEBUG: " .. passback)
	return passback
end

ESX.RegisterServerCallback('rpuk_shops:showWorkers', function(source, callback, shop)
	local workerTable = {}

	-- do they own any shop
	MySQL.Async.fetchAll('SELECT workers FROM shops_owned WHERE shop = @zone', {
		['@zone'] = shop
	}, function(result)
		if result and result[1] ~= nil then -- This shop exists in the db
			local workers = json.decode(result[1].workers)

			if workers then
				for index,data in pairs(workers) do
					if ESX.GetPlayerFromIdentifier(data) ~= nil then --Check if player is online
						table.insert(workerTable, {label = ESX.GetPlayerFromIdentifier(data).getName(), value = data})
					end
				end
			end

			callback(workerTable)
		else
			callback(workerTable)
		end
	end)
end)

ESX.RegisterServerCallback('rpuk_shops:manageWorker', function(playerId, cb, id, action, zone)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if playerId == id then
		xPlayer.showNotification('You cannot employ yourself', 5000, 'error')
		cb(false)
	else
		if action == "add" then
			local txPlayer = ESX.GetPlayerFromId(id)

			if txPlayer then
				MySQL.Async.fetchAll("SELECT workers FROM shops_owned WHERE shop = @zone", {
					['@zone'] = zone
				}, function(result)
					local workers, found = {}, false

					if result[1].workers then
						workers = json.decode(result[1].workers)
					end

					for index,data in ipairs(workers) do
						if data == txPlayer.getIdentifier() then
							found = true
							break
						end
					end

					if not found then
						table.insert(workers, txPlayer.getIdentifier())

						MySQL.Async.execute("UPDATE shops_owned SET workers=@workers WHERE shop=@zone", {
							['@workers'] = json.encode(workers),
							['@zone'] = zone
						})

						xPlayer.showAdvancedNotification('Worker Management', 'Success', "A worker was added to your store!", 'CHAR_MINOTAUR', 1)
						cb(true)
					else
						xPlayer.showAdvancedNotification('Worker Management', 'Failed', "That player already works for you!", 'CHAR_MINOTAUR', 1)
						cb(false)
					end
				end)
			else
				xPlayer.showAdvancedNotification('Worker Management', 'Failed', "The ID you entered was not an online player!", 'CHAR_MINOTAUR', 1)
				cb(false)
			end
		elseif action == "remove" then --Remove from workers list
			MySQL.Async.fetchAll("SELECT workers FROM shops_owned WHERE shop = @zone", {
				['@zone'] = zone
			}, function(result)
				local workers, found = {}, false

				if result[1].workers then
					workers = json.decode(result[1].workers)
				end

				for index,data in ipairs(workers) do
					if data == id then --Gets index of the ID you want to remove
						table.remove(workers, index)
						found = true
						break
					end
				end

				if found then
					MySQL.Async.execute("UPDATE shops_owned SET workers = @workers WHERE shop = @zone", {
						['@workers'] = json.encode(workers),
						['@zone'] = zone
					})

					xPlayer.showAdvancedNotification('Worker Management', 'Success', "A worker was removed from your store!", 'CHAR_MINOTAUR', 1)
					cb(true)
				else
					xPlayer.showAdvancedNotification('Worker Management', 'Failed', "Could not find the worker!", 'CHAR_MINOTAUR', 1)
					cb(false)
				end
			end)
		end
	end
end)