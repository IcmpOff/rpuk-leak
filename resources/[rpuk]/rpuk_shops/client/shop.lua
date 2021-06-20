local hasAlreadyEnteredMarker
local currentActionData, title, css = {}, "Shop", "rpuk"
local inMenu = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local letSleep = true

		for k,v in pairs(Config.Zones) do
			for key,val in pairs(v.Pos) do
				val = vector3(val.x, val.y, val.z + 1.5) -- im too lazy to convert them all to vector3
				local distance = #(playerCoords - val)

				if distance < 2 and not inMenu then
					letSleep = false
					ESX.Game.Utils.DrawText3D(val, "Press ~y~E~s~ to access ~y~Store~s~", 0.7, 4)
					if IsControlJustReleased(0, 38) and IsInputDisabled(0) and distance < 2 then OpenGateway(k) end
				end
			end
		end

		if letSleep then Citizen.Wait(500) end
	end
end)


function capEachFirst(str)
	str = string.lower(str)
	str = string.gsub(" "..str, "%W%l", string.upper):sub(2)
	return str
end

function OpenGateway(zone)
	ESX.UI.Menu.CloseAll()
	inMenu = true
	local id = ""
	local elements = {}

	ESX.TriggerServerCallback("rpuk_shops:fetchStatus", function(result)
		if result == "npcStore" then
			table.insert(elements, {label = "Buy Items", value = "buyitems"})
			if Config.Zones[zone].Keeper ~= "server" then
				table.insert(elements, {label = "Manage Property", value = "manage_property"})
			else
				table.insert(elements, {label = "Sell Items", value = "sellitems"})
			end
		else
			id = result.id
			table.insert(elements, {label = "Store Status: ".. capEachFirst(result.status), value = nil})
			if ESX.Player.GetJobName() == "police" or ESX.Player.GetJobName() == "nca" then
				table.insert(elements, {label = "Business ID: "..result.id, value = nil})
			end
			table.insert(elements, {label = " ", value = nil})

			if result.status == "open" then
				table.insert(elements, {label = "Buy Items", value = "buyitems"})
				if Config.Zones[zone].Keeper ~= "server" then
					table.insert(elements, {label = "Manage Property", value = "manage_property"})
				else
					table.insert(elements, {label = "Sell Items", value = "sellitems"})
				end
				if ESX.Player.GetJobName() == "police" or ESX.Player.GetJobName() == "nca" then
					table.insert(elements, {label = "Close Business", value = "shutDown"})
				end
			else
				table.insert(elements, {label = "Information (Click Here)", value = "info"})
				if Config.Zones[zone].Keeper ~= "server" then
					if ESX.Player.GetJobName() == "police" or ESX.Player.GetJobName() == "nca" then
						table.insert(elements, {label = "Manage Current Stock", value = "manage_stock_current"})
					elseif ESX.Player.GetJobName() == "city" and ESX.Player.GetJobName() == 2 then
						table.insert(elements, {label = "Manage Property", value = "manage_property"})
					end
				end
				if ESX.Player.GetJobName() == "police" or ESX.Player.GetJobName() == "nca" or ESX.Player.GetJobName() == "court" or ESX.Player.GetJobName() == "city" then
					table.insert(elements, {label = "Open Business", value = "open"})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'playermenu', {
			title 	= title,
			css 	=	css,
			align	 = 'center',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'buyitems' then
				OpenShopMenu(zone)
			elseif data.current.value == 'sellitems' then
				OpenSellMenu(zone)
			elseif data.current.value == 'manage_property' then
				if not cooldown then -- Stop the callback spam
					ESX.TriggerServerCallback('rpuk_shops:requestShopkeeper', function(result2) -- {0=false, 1=true, 2=purchasable, 4=Police}
						if result2 == 0 then
							ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Property Management', "You don't own this property!", 'CHAR_MINOTAUR', 1)
						else
							OpenManagerMenu(zone, result2)
						end
					end, zone)
				end
			elseif data.current.value == 'shutDown' then
				ESX.TriggerServerCallback("rpuk_shops:fetchWarrant", function(result2)
					if result2 then
						TriggerServerEvent("rpuk_shop:changeStatusOfShop", id, "closed")
						TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "You have closed down the property"})
						menu.close()
					else
						TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "Your warrant has not been approved or you have not requested one."})
					end
				end, id)
			elseif data.current.value == 'open' then
				TriggerServerEvent("rpuk_shop:changeStatusOfShop", id, "open")
				TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "You have opened up the property"})
				menu.close()
			elseif data.current.value == 'manage_stock_current' then
				ESX.UI.Menu.CloseAll()
				ManageCurrentStock(zone)
			elseif data.current.value == 'info' then
				TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", length = 5000, text = "To who it may concern, this business has been closed until further notice. Any issues or questions please contact the Los Santos Judges."})
				menu.close()
			end
		end, function(data, menu)
			menu.close()
			inMenu = false
		end)
	end, zone)
end

function OpenShopMenu(zone)
	ESX.TriggerServerCallback('rpuk_shops:callback_buysell', function(returnedBuyItems)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy', {
			title		= title,
			css 		=	css,
			align		= 'center',
			elements	= returnedBuyItems
		}, function(data, menu)
			if data.current.value > 0 then
				ESX.TriggerServerCallback('rpuk_shops:callback_buy', function(validated, message)
					if validated then -- purchase successful
						ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Purchase / Trade', "Thank you for your purchase", 'CHAR_MINOTAUR', 9)
					else -- purchase NOT successful
						ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Purchase / Trade', "You could not afford that", 'CHAR_MINOTAUR', 9)
					end
				end, data.current.id, data.current.value, zone)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, "buy_menu", zone)
end

function OpenSellMenu(zone)
	ESX.TriggerServerCallback('rpuk_shops:callback_buysell', function(returnedBuyItems)
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sell', {
			title		= title,
			css 		= css,
			align		= 'center',
			elements	= returnedBuyItems
		}, function(data, menu)
			if data.current.value > 0 then
				ESX.TriggerServerCallback('rpuk_shops:callback_sell', function(validated, message)
					if validated then -- purchase successful
						ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Sell Product', "Sold item!", 'CHAR_MINOTAUR', 9)
					else -- purchase NOT successful
						ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Sell Product', "Could not sell item!", 'CHAR_MINOTAUR', 9)
					end
				end, data.current.id, data.current.value)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, "sell_menu", zone)
end

function OpenManagerMenu(zone, result)
	local elements = {}
	local done = false

	if result == 1 or result == 3 then
		table.insert(elements, {label = "Add New Stock", value = "manage_stock_new"})
		table.insert(elements, {label = "Manage Current Stock", value = "manage_stock_current"})
		table.insert(elements, {label = "Website", value = "web"})
		if result == 1 then
			table.insert(elements, {label = "Manage Workers", value = "manage_workers"})
			table.insert(elements, {label = "", value = "nil"})
			table.insert(elements, {label = "Give up The Shop", value = "give_up"})
			table.insert(elements, {label = "", value = "nil"})
			table.insert(elements, {label = "Transfer Ownership", value = "transfer"})
		end
		done = true
	elseif result == 2 then
		ESX.TriggerServerCallback('rpuk_shops:priceCheck', function(data)
			table.insert(elements, {label = "Purchase Business: <span style='color:green;'>£"..ESX.Math.GroupDigits(data).."</span>", value = "purchase_business"})
			done = true
		end, zone)
	end

	while not done do Citizen.Wait(100) end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'prop_manager', {
		title = title,
		css =	css,
		align		= 'center',
		elements	= elements
	}, function(data, menu)
		if data.current.value == "purchase_business" then
			ESX.TriggerServerCallback('rpuk_shops:purchase_business', function(validated, message)
				ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Property Management', message, 'CHAR_MINOTAUR', 9)
				menu.close()
				inMenu = false
			end, zone)
		elseif data.current.value == "manage_stock_new" then
			ESX.UI.Menu.CloseAll()
			ManageNewStock(zone)
		elseif data.current.value == "manage_stock_current" then
			ESX.UI.Menu.CloseAll()
			ManageCurrentStock(zone)
		elseif data.current.value == "web" then
			TriggerEvent('rpuk_stock:openGui', zone)
			ESX.UI.Menu.CloseAll()
			inMenu = false
		elseif data.current.value == "give_up" then
			SellUp(zone)
		elseif data.current.value == "manage_workers" then
			ManageWorkers(zone)
		elseif data.current.value == "transfer" then
			transferOwnership(zone)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function transferOwnership(zone)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list', {
		title = "Enter ID of player you wish to transfer to!",
	}, function(data, menu)
		if data.value == nil or tonumber(data.value) == nil then
			TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "Invalid"})
		else
			ESX.TriggerServerCallback('rpuk_shops:transferShopOwner', function(success)
				if success then
					ESX.UI.Menu.CloseAll()
					inMenu = false
				end
			end, tonumber(data.value), zone)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function SellUp(zone)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sellup', {
		title = title,
		css =	css,
		align		= 'center',
		elements	= {
			{label = "Go Back", value = "back"},
			{label = "Give Up Shop", value = "give_up"}
	}}, function(data, menu)
		if data.current.value == "back" then
			menu.close()
		elseif data.current.value == "give_up" then
			TriggerServerEvent('rpuk_shop:sellupShop', zone)
			ESX.UI.Menu.CloseAll()
			inMenu = false
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ManageNewStock(zone)
	TriggerServerEvent('rpuk_core:SavePlayer')
	Citizen.Wait(1000)

	ESX.TriggerServerCallback('rpuk_shops:getInventory', function(returnedInventory)
		local elements = {
			head = {"PRODUCT", "QUANTITY", ""},
			rows = {}
		}

		for i=1, #returnedInventory, 1 do
			table.insert(elements.rows, {
				data = returnedInventory[i], item = returnedInventory[i].item,
				cols = {
					returnedInventory[i].label,
					returnedInventory[i].count,
					'{{' .. "Select Item" .. '|select_item}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_test', elements, function(data, menu)
			if data.value == 'select_item' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'input_stock', {
					title = "How much do you want to sell 1 unit for?"
				}, function(data2, menu2)
					local amount = tonumber(data2.value)
					local round = amount

					if round == nil then
						ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Stock Management', "Invalid Input!", 'CHAR_MINOTAUR', 1)
					elseif round < 1 then
						ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Stock Management', "Invalid Input!", 'CHAR_MINOTAUR', 1)
					else
						round = math.ceil(round)
						menu2.close()

						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'order_quantity', {
							title = "How many " .. data.data["label"] .. " to sell at £"..round
						}, function(data3, menu3)
							local Q_amount = tonumber(data3.value)
							local Q_round = Q_amount

							if Q_round == nil then
								ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Stock Management', "Invalid Input!", 'CHAR_MINOTAUR', 1)
							elseif Q_round < 1 then
								ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Stock Management', "Invalid Input!", 'CHAR_MINOTAUR', 1)
							else
								Q_round = math.ceil(Q_amount)
								menu.close()

								ESX.TriggerServerCallback('rpuk_shops:stockInput', function(result)
									if result then
										ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Stock Management', data.data["label"] .. " Inserted!", 'CHAR_MINOTAUR', 1)
										ESX.UI.Menu.CloseAll()
										inMenu = false
									else
										ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Stock Management', "Failed to Insert!", 'CHAR_MINOTAUR', 1)
										ESX.UI.Menu.CloseAll()
										inMenu = false
									end
								end, zone, data.data["item"], Q_round, amount)
							end
						end, function(data3, menu3)
							menu3.close()
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
			inMenu = false
		end)
	end, "user")
end

function ManageCurrentStock(zone)
	ESX.TriggerServerCallback('rpuk_shops:callStock', function(returnedStock)
		local elements = {
			head = {"PRODUCT", "PRICE", "QUANTITY"--[[, "TAX"]], " "},
			rows = {}
		}

		for i=1, #returnedStock, 1 do
			table.insert(elements.rows, {
				data = returnedStock[i], productID = returnedStock[i].id,
				cols = {
					returnedStock[i].item,
					returnedStock[i].price,
					returnedStock[i].quantity,
					--returnedStock[i].tax,
					'{{' .. "Withdraw Stock" .. '|stock_withdraw}}' -- the value
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_test', elements, function(data, menu)
			if data.value == 'stock_withdraw' then
				TriggerServerEvent('rpuk_shops:alterStock', data.value, data.data["id"], zone)
				menu.close()
				inMenu = false
			end
		end, function(data, menu)
			menu.close()
			inMenu = false
		end)
	end, "stock_call_current", zone)
end

function PlaceNewStock(zone)
	ESX.TriggerServerCallback('rpuk_shops:callAvailable', function(returnedItems)
		local elements = {
			head = {"PRODUCT", "PLACE ORDER"},
			rows = {}
		}

		for i=1, #returnedItems, 1 do
			table.insert(elements.rows, {
				data = returnedItems[i], productName = returnedItems[i].name,
				cols = {
					returnedItems[i].label,
					'{{' .. "Place Order" .. '|place_order}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_test', elements, function(data, menu)
			if data.value == "place_order" then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'place_order', {
					title = "How much are you willing to pay per unit (individual item)"
				}, function(data2, menu2)
					local amount = tonumber(data2.value)
					local round = amount

					if round == nil then
						ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Stock Management', "Invalid Input!", 'CHAR_MINOTAUR', 1)
					elseif round < 1 then
						ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Stock Management', "Invalid Input!", 'CHAR_MINOTAUR', 1)
					else
						round = math.ceil(round)
						menu2.close()
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'order_quantity', {
							title = "How many would you like to purchase for £"..round
						}, function(data3, menu3)
							local Q_amount = tonumber(data3.value)
							local Q_round = Q_amount
							if Q_round == nil then
								ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Stock Management', "Invalid Input!", 'CHAR_MINOTAUR', 1)
							elseif Q_round < 1 then
								ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Stock Management', "Invalid Input!", 'CHAR_MINOTAUR', 1)
							else
								Q_round = math.ceil(Q_amount)
								menu3.close()
								ESX.TriggerServerCallback('rpuk_shops:generateOrder', function(result, message)
									if result then
										ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Stock Ordered (~g~' .. data.data["label"] .. "~s~)", message, 'CHAR_MINOTAUR', 1)
										ESX.UI.Menu.CloseAll()
										OpenManagerMenu(zone)
										CurrentStockOrders(zone)
									else
										ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Failed to order (~g~' .. data.data["label"] .. "~s~)", message, 'CHAR_MINOTAUR', 1)
										ESX.UI.Menu.CloseAll()
										OpenManagerMenu(zone)
										PlaceNewStock(zone)
									end
								end, "stock_new_order", zone, data.data["item"], Q_round, amount)
							end
						end, function(data3, menu3)
							menu3.close()
							inMenu = false
						end)
					end
				end, function(data2, menu2)
					menu2.close()
					inMenu = false
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, "orders_call_available", zone)
end

function CurrentStockOrders(zone)
	ESX.TriggerServerCallback('rpuk_shops:callOrders', function(returnedOrders)
		local elements = {
			head = {"PRODUCT", "ORDER QUANTITY", "ORDER PAYMENT", "CREATION DATE/TIME", "STATUS", ""},
			rows = {}
		}
		for i=1, #returnedOrders, 1 do
			local option, status = nil, nil
			print(returnedOrders[i].status)
			if returnedOrders[i].status == "placed" then
				status = "Placed"
				option = '{{' .. "Cancel Order" .. '|cancel_order}}'
			elseif returnedOrders[i].status == "delivered" then
				status = "Delivered"
				option = '{{' .. "Accept Delivery" .. '|accept_delivery}}'
			elseif returnedOrders[i].status == "progress" then
				status = "In Progress"
				option = "In Progress"
			elseif returnedOrders[i].status == "complete" then
				status = "Completed"
				option = "Completed"
			end
			table.insert(elements.rows, {
				data = returnedOrders[i], orderID = returnedOrders[i].id, orderShop = returnedOrders[i].shop,
				cols = {
					returnedOrders[i].product,
					returnedOrders[i].quantity,
					returnedOrders[i].payment,
					returnedOrders[i].created,
					status,
					option
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'current_stock_orders', elements, function(data, menu)
			if data.value ~= nil then
				TriggerServerEvent('rpuk_shops:alterOrder', data.data["id"], data.value)
				ESX.UI.Menu.CloseAll()
			end
		end, function(data, menu)
			menu.close()
		end)
	end, "orders_call_current", zone)
end

function OpenGoodsIn(zone)
	ESX.TriggerServerCallback('rpuk_shops:callOrders', function(returnedOrders)
		local elements = {
			head = {"PRODUCT", "ORDER QUANTITY", "ORDER PAYMENT", "CREATION DATE/TIME", "STATUS", ""},
			rows = {}
		}

		for i=1, #returnedOrders, 1 do
			local option = '{{' .. "Cancel Order" .. '|cancel_order}}'
			local status

			if returnedOrders[i].status == "placed" then
				status = "Placed"
				option = '{{' .. "Fulfill Order" .. '|fulfill_order}}'
			end

			table.insert(elements.rows, {
				data = returnedOrders[i], orderID = returnedOrders[i].id, orderShop = returnedOrders[i].shop,
				cols = {
					returnedOrders[i].product,
					returnedOrders[i].quantity,
					returnedOrders[i].payment,
					returnedOrders[i].created,
					status,
					option
				}
			})
		end
		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'current_stock_orders', elements, function(data, menu)
			if data.value ~= nil then
				local vehPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
				if vehPlate then -- does the vehicle exist check
					ESX.TriggerServerCallback('rpuk_shops:getInventory', function(retResult)
						if retResult then
							ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Goods In / Delivery', "Successfully Delivered!", 'CHAR_MINOTAUR', 1)
							ESX.UI.Menu.CloseAll()
						else
							ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Goods In / Delivery', "Failed to deliver the goods!", 'CHAR_MINOTAUR', 1)
						end
					end, "delivery", vehPlate, data.data["id"])
				else
					ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Goods In / Delivery', "You need to be in a commercial vehicle!", 'CHAR_MINOTAUR', 1)
				end
			end
		end, function(data, menu)
			menu.close()
		end)
	end, "order_call_goodsin", zone)
end

AddEventHandler('rpuk_shops:hasEnteredMarker', function(zone)
	currentActionData = {zone = zone}
	if Config.Zones[currentActionData.zone]["Header"] ~= "rpuk" then
		title = ""
	end
	css =	Config.Zones[currentActionData.zone]["Header"]
end)

AddEventHandler('rpuk_shops:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	currentActionData = {}
	inMenu = false
	title = "Shop"
	css = "rpuk"
end)

RegisterNetEvent("rpuk_shops:remoteAccess")
AddEventHandler("rpuk_shops:remoteAccess",function(zone)
	if zone == "false" then
		ESX.UI.Menu.CloseAll()
		Citizen.Wait(10)
		currentActionData = {}
		title = "Shop"
		css = "rpuk"
	else
		ESX.UI.Menu.CloseAll()
		Citizen.Wait(10)
		currentActionData = {zone = zone}
		Citizen.Wait(50)
		if Config.Zones[currentActionData.zone]["Header"] ~= "rpuk" then
			title = ""
		end
		css =	Config.Zones[currentActionData.zone]["Header"]
		OpenGateway(zone)
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, true
		--local classVehicle = GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false))

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Deliv, 1 do
				local distance = GetDistanceBetweenCoords(playerCoords, v.Deliv[i].x, v.Deliv[i].y, v.Deliv[i].z, true)
				if distance < Config.DrawDistance and GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 --[[and classVehicle == 20]] then -- can see it distance &	in a commercial vehicle class
					DrawMarker(Config.Type, v.Deliv[i].x, v.Deliv[i].y, v.Deliv[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Deliv[i].size, v.Deliv[i].size, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, nil, nil, false)
					letSleep = false

					if distance < v.Deliv[i].size then -- in the radius of the delivery circle
						ESX.ShowHelpNotification("[~b~Delivery Drivers~s~]\nPress ~INPUT_PICKUP~ To Deliver Goods\n\n\n~c~You will need the products in the vehicle inventory to deliver them.")
						if IsControlJustReleased(0, 38) then
							OpenGoodsIn(k)
						end
					end
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			TriggerEvent('rpuk_shops:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('rpuk_shops:hasExitedMarker')
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

function ManageWorkers(zone)
	ESX.TriggerServerCallback('rpuk_shops:showWorkers', function(workersTable)
		local elements = {{label = "Add Worker", value = "add_worker"}}

		for index,data in pairs(workersTable) do
			table.insert(elements, {label = data.label, value = data.value})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manageWorkers', {
			title 	= 'Manage Workers',
			css 	=	css,
			align	 = 'center',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'add_worker' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'worker_id', {
					title = "Enter the workers ID:"
				}, function(data2, menu2)
					if not data2.value or not tostring(data2.value) then
						ESX.ShowNotification("Invalid Value")
					else
						ESX.TriggerServerCallback('rpuk_shops:manageWorker', function(success)
							if success then
								menu2.close()
								menu.close()
							end
						end, tonumber(data2.value), "add", zone)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value then
				ESX.TriggerServerCallback('rpuk_shops:manageWorker', function(success)
					if success then
						menu.removeElement({value = data.current.value})
						menu.refresh()
					end
				end, data.current.value, "remove", zone)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, zone)
end