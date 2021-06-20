local inMenu, DisplayStats, rateLimit, pedVisible, livCheck, currentDisplayVehicle = false, true, 0, true, false, nil
Vehicles = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)
		if rateLimit <= 1 then
			Citizen.Wait(60000)
			rateLimit = 0
		end
	end
end)

function OpenGateway(shop)
	ESX.TriggerServerCallback('rpuk_shops:requestShopkeeper', function(result) -- {0=false, 1=true, 2=purchasable, 3=worker}
		if result == 1 or result == 3 then --
			ManagerComputer(shop, result)
		elseif result == 2 then
			buyShop(shop)
		else
			ESX.ShowAdvancedNotification("Unauthorised", "", "You don't run this vehicle dealership.", 'CHAR_CARSITE', 0)
		end
	end, shop)
end

function buyShop(shopName)
	inMenu = true
	local elements = {}
	table.insert(elements, {label = "Purchase Business (<span style='color:green;'>£480,000</span>)", value = "purchase_business"})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'managercomp', {
		title 	= '',
		css 	=  Config.Shops[shopName]["header"],
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'purchase_business' then
			ESX.TriggerServerCallback('rpuk_shops:purchase_business', function(validated, message)
				if validated then -- purchase successful
					ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Property Management', message, 'CHAR_MINOTAUR', 0)
					menu.close()
				else  -- purchase NOT successful
					ESX.ShowAdvancedNotification('Minotaur Investment & Finance', 'Property Management', message, 'CHAR_MINOTAUR', 0)
					menu.close()
				end
			end, shopName)
		end
	end, function(data, menu)
		menu.close()
		inMenu = false
	end)
end

function ManagerComputer(shopName, access)
	inMenu = true
	local elements = {}
	table.insert(elements, {label = "Garage to Stock", value = "my_garage"})
	table.insert(elements, {label = "Stock to Garage", value = "my_stock"})

	table.insert(elements, {label = "Website", value = "web"})
	table.insert(elements, {label = "View Current Offers", value = "current_offers"})
	if access == 1 then
		table.insert(elements, {label = "Manage Workers", value = "manage_workers"})
		table.insert(elements, {label = "", value = "nil"})
		table.insert(elements, {label = "Give up The Shop", value = "give_up"})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'managercomp', {
		title 	= '',
		css 	=  Config.Shops[shopName]["header"],
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'my_stock' then
			myGarage(shopName)
		elseif data.current.value == 'my_garage' then
			NewStock(shopName)
		elseif data.current.value == 'web' then
			TriggerEvent('rpuk_stock:openGui', shopName)
		elseif data.current.value == 'current_offers' then
			shopOffers(shopName)
		elseif data.current.value == "give_up" then
			SellUp(shopName)
		elseif data.current.value == "manage_workers" then
			ManageWorkers(shopName)
		end
	end, function(data, menu)
		menu.close()
		inMenu = false
	end)
end

function SellUp(zone)
	inMenu = true
	local elements = {}

	table.insert(elements, {label = "Go Back", value = "back"})
	table.insert(elements, {label = "Give Up Shop", value = "give_up"})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sellup', {
		title = title,
		css =  zone,
		align		= 'top-left',
		elements	= elements
	}, function(data, menu)
		if data.current.value == "back" then
			OpenManagerMenu(zone, 1)
		elseif data.current.value == "give_up" then
			TriggerServerEvent('rpuk_shop:sellupShop', zone)
			ESX.UI.Menu.CloseAll()
		end
	end, function(data, menu)
		menu.close()
		inMenu = false
	end)
end

function Gateway(shop) -- Direct call to either player or server menu
	local restricted = false
	for index,data in pairs(Config.Shops[shop]["Jobs"]) do
		if data ~= ESX.Player.GetJobName() then
			restricted = true
			break
		end
	end
	if not restricted then
		if Config.Shops[shop]["Type"] == "player" then
			Shop_Player(shop)
		else
			Shop_Server(shop)
		end
	else
		ESX.ShowAdvancedNotification(ESX.Player.GetJobLabel(), "You can't access this service.", "", 'CHAR_CARSITE', 0)
	end
end

local maxVal, newVal = 0, 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if inMenu and GetVehiclePedIsIn(PlayerPedId())  ~= 0 then
			SetEntityVisible(PlayerPedId(), pedVisible)
		end
		if livCheck and IsControlJustReleased(0, 47) then
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			maxVal = GetVehicleLiveryCount(vehicle, false)
			if GetVehicleLivery(vehicle) >= maxVal then
				newVal = -1
			else
				newVal = newVal + 1
			end
			SetVehicleLivery(vehicle, newVal)
		end
		if inMenu then
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 75, true)
		else
			livCheck = false
		end
	end
end)

-- Server owned shop
function Shop_Server(shop)
	if not vehicleList or not Categories then
		ESX.ShowNotification('The vehicle list has not loaded yet, wait a couple of seconds')
		return
	end

	inMenu, pedVisible = true, false
	ESX.UI.Menu.CloseAll()
	local playerPed = PlayerPedId()
	local vehiclesByCategory = {}
	local elements           = {}
	local firstVehicleData   = nil

	if ESX.Player.GetJobName() == "police" or ESX.Player.GetJobName() == "ambulance" then
		livCheck = true -- Allows police & NHS To livery change
		ESX.ShowNotification("Press <span style='color:cyan;'>G</span> to cycle the vehicle livery<br>Not all vehicles have multiple liveries", 20000)
	end

	for k,v in ipairs(Categories) do
		for k2,v2 in ipairs(Config.Shops[shop].AllowedCats) do
			if v.name == v2 then
				vehiclesByCategory[v.name] = {}
			end
		end
	end

	for i=1, #vehicleList, 1 do
		if IsModelInCdimage(GetHashKey(vehicleList[i].model)) then
			for k,x in pairs(Config.Shops[shop]["AllowedCats"]) do
				if x == vehicleList[i].category then
					table.insert(vehiclesByCategory[vehicleList[i].category], vehicleList[i])
				end
			end
		else
			print(('[RPUK Vehicle Shop] [^3ERROR^7] Vehicle "%s" does not exist'):format(vehicleList[i].model))
		end
	end

	for i=1, #Categories, 1 do
		for k,x in pairs(Config.Shops[shop]["AllowedCats"]) do
			if Categories[i].name == x then
				local category         = Categories[i]
				local categoryVehicles = vehiclesByCategory[category.name]
				local options          = {}

				for j=1, #categoryVehicles, 1 do
					local vehicle = categoryVehicles[j]
					if not firstVehicleData then firstVehicleData = vehicle end
					table.insert(options, ('%s <span style="color:green;">£%s</span>'):format(GetLabelText(GetDisplayNameFromVehicleModel(vehicle.model)), ESX.Math.GroupDigits(vehicle.price)))
				end

				table.insert(elements, {
					name    = category.name,
					label   = category.label,
					value   = 0,
					type    = 'slider',
					max     = #Categories[i],
					options = options,
					categoryName = Categories[i].name
				})
			end
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = "",
		css 	=  Config.Shops[shop]["header"],
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = '',
			css 	=  Config.Shops[shop]["header"],
			align = 'top-left',
			elements = {
				{label = "No",  value = 'reject_vehicle'},
				{label = "Purchase Vehicle (Cash)", value = 'purchase_vehicle', currency = "cash"},
				{label = "Purchase Vehicle (Bank)", value = 'purchase_vehicle', currency = "bank"},
		}}, function(data2, menu2)
			local currentLivery = GetVehicleLivery(GetVehiclePedIsIn(PlayerPedId(), false))

			if data2.current.value == 'purchase_vehicle' then
				local newPlate = GeneratePlate()

				ESX.TriggerServerCallback('rpuk_vehshop:PurchaseVehicle', function(result, message)
					if result == true then -- purchase success
						DeleteDisplayVehicleInsideShop() -- clearup cars
						inMenu, pedVisible = false, true
						SetEntityVisible(PlayerPedId(), true)
						ESX.UI.Menu.CloseAll()
						local found = false
						for index,spawnData in pairs(Config.Shops[shop]["SpawnPoints"]) do -- don't cause explosions outside checking spawn points
							if ESX.Game.IsSpawnPointClear(spawnData[1], 3.0) then
								found = true
								ESX.Game.SpawnVehicle(vehicleData.model, spawnData[1], spawnData[2], function(vehicle)
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
									TriggerServerEvent("rpuk_vehshop:takeOwnership","new", vehicleProps, false, false, getVehicleType(data.current.categoryName)) -- optional job at the end EG: vehicleProps, "police")
								end, {
									modLivery = currentLivery, windowTint = 0, dirtLevel = 0.0, plate = newPlate
								}, {giveKeys = true})

								SetEntityCoords(PlayerPedId(), Config.Shops[shop]["Interactions"]["Purchase"]["Location"])
								ESX.ShowAdvancedNotification('Vehicle Purchased', 'Waiting Outside', "["..newPlate.."] Is waiting for you outside. Enjoy.", 'CHAR_CARSITE', 0)
								break -- break out the check loop
							end
						end

						if not found then
							ESX.Game.SpawnVehicle(vehicleData.model, vector3(0,0,0), data[2], function(vehicle)
								local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
								TriggerServerEvent("rpuk_vehshop:takeOwnership","new", vehicleProps, (Config.Shops[shop]["Jobs"] and Config.Shops[shop]["Jobs"][1] or false), false, getVehicleType(data.current.categoryName)) -- optional job at the end EG: vehicleProps, "police")
							end, {modLivery = currentLivery, windowTint = 0, dirtLevel = 0.0, plate = newPlate})

							SetEntityCoords(PlayerPedId(), Config.Shops[shop]["Interactions"]["Purchase"]["Location"])
							ESX.ShowAdvancedNotification('Vehicle Purchased', 'Spawn Blocked', "You have purchased ["..newPlate.."] however the spawn point is blocked.\nYou can take out your vehicle at any garage.", 'CHAR_CARSITE', 0)
						end
					else -- failed
						ESX.ShowAdvancedNotification('Vehicle Purchase', 'Failed', message, 'CHAR_CARSITE', 0)
					end
				end, data2.current.currency, shop, vehicleData.model, newPlate, nil, data.current.name)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
		DeleteDisplayVehicleInsideShop()
		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		SetEntityCoords(playerPed, Config.Shops[shop]["Interactions"]["Purchase"]["Location"])
		inMenu, pedVisible = false, true
		SetEntityVisible(PlayerPedId(), true)
	end, function(data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
		DisplayStats = true

		DeleteDisplayVehicleInsideShop()
		WaitForVehicleToLoad(vehicleData.model)

		ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Shops[shop]["ViewPoints"][0][1], Config.Shops[shop]["ViewPoints"][0][2], function(vehicle)
			SetVehicleModKit(vehicle, 0)
			SetVehicleWindowTint(vehicle, 0)
			SetVehicleDirtLevel(vehicle, 0)
			currentDisplayVehicle = vehicle
			SetVehicleCurrentRpm(vehicle, 3000)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetModelAsNoLongerNeeded(vehicleData.model)
		end)
	end)

	local vehicleData = firstVehicleData
	DisplayStats = true

	WaitForVehicleToLoad(vehicleData.model)

	ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Shops[shop]["ViewPoints"][0][1], Config.Shops[shop]["ViewPoints"][0][2], function(vehicle)
		SetVehicleModKit(vehicle, 0)
		SetVehicleWindowTint(vehicle, 0)
		SetVehicleDirtLevel(vehicle, 0)
		currentDisplayVehicle = vehicle
		SetVehicleCurrentRpm(vehicle, 3000)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		SetModelAsNoLongerNeeded(vehicleData.model)
	end)
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName('The vehicle is currently loading, please wait')
		EndTextCommandBusyspinnerOn(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		BusyspinnerOff()
	end
end

function DeleteDisplayVehicleInsideShop()
	local attempt = 0

	if currentDisplayVehicle and DoesEntityExist(currentDisplayVehicle) then
		while DoesEntityExist(currentDisplayVehicle) and not NetworkHasControlOfEntity(currentDisplayVehicle) and attempt < 100 do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(currentDisplayVehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(currentDisplayVehicle) and NetworkHasControlOfEntity(currentDisplayVehicle) then
			ESX.Game.DeleteVehicle(currentDisplayVehicle)
		end
	end
end

function Shop_Player(shop)
	ESX.TriggerServerCallback('rpuk_vehshop:returnVehicle', function(vehTable)
		inMenu, pedVisible = true, false
		ESX.UI.Menu.CloseAll()
		local playerPed = PlayerPedId()
		local elements = {}
		local firstVehicleData

		for k,vehicle in pairs(vehTable) do
			if k == 1 then firstVehicleData = vehicle.vehicle end

			table.insert(elements, {
				data 	= vehicle,
				label   = GetLabelText(GetDisplayNameFromVehicleModel(vehicle.vehicle.model)) .. " [<span style='color:cyan;'>" .. vehicle.plate .. "</span>][<span style='color:lightgreen;'>£"..vehicle.price.."</span>] " .. "(" .. vehicle.seller .. ")", -- get the localised version of the display name
				value   = 0,
			})
		end

		if firstVehicleData then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
				title    = "",
				css 	=  Config.Shops[shop]["header"],
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
					title = '',
					css 	=  Config.Shops[shop]["header"],
					align = 'top-left',
					elements = {
						{label = "No",  value = 'reject_vehicle'},
						{label = "Purchase Vehicle (Cash)", value = 'purchase_vehicle', currency = "cash"},
						{label = "Purchase Vehicle (Bank)", value = 'purchase_vehicle', currency = "bank"},
				}}, function(data2, menu2)
					if data2.current.value == 'purchase_vehicle' then
						local vehicleData = data.current.data.vehicle
						ESX.TriggerServerCallback('rpuk_vehshop:PurchaseVehicle', function(result, message)
							if result == true then -- purchase success
								DeleteDisplayVehicleInsideShop() -- clearup cars
								inMenu, pedVisible = false, true
								SetEntityVisible(PlayerPedId(), true)
								ESX.UI.Menu.CloseAll()
								local found = false
								for index,spawnData in pairs(Config.Shops[shop]["SpawnPoints"]) do -- don't cause explosions outside checking spawn points
									if ESX.Game.IsSpawnPointClear(spawnData[1], 3.0) then
										found = true
										ESX.Game.SpawnVehicle(vehicleData.model, spawnData[1], spawnData[2], function(vehicle)
										end, vehicleData, {giveKeys = true})

										ESX.ShowAdvancedNotification('Vehicle Purchased', 'Waiting Outside', "["..vehicleData.plate.."] Is waiting for you outside. Enjoy.", 'CHAR_CARSITE', 0)
										SetEntityCoords(PlayerPedId(), Config.Shops[shop]["Interactions"]["Purchase"]["Location"])
										break -- break out the check loop
									end
								end
								if not found then
									ESX.Game.SpawnVehicle(vehicleData.model, vector3(0,0,0), data[2], function(vehicle)
										ESX.ShowAdvancedNotification('Vehicle Purchased', 'Spawn Blocked', "You have purchased ["..vehicleData.plate.."] however the spawn point is blocked.\nYou can take out your vehicle at any garage.", 'CHAR_CARSITE', 0)
										SetEntityCoords(PlayerPedId(), Config.Shops[shop]["Interactions"]["Purchase"]["Location"])
									end, vehicleData)
								end
							else -- failed
								ESX.ShowAdvancedNotification('Vehicle Purchase', 'Failed', message, 'CHAR_CARSITE', 0)
							end
						end, data2.current.currency, shop, vehicleData.model, vehicleData.plate, nil, data.current.name)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end, function(data, menu)
				menu.close()
				DeleteDisplayVehicleInsideShop()
				FreezeEntityPosition(playerPed, false)
				SetEntityCoords(playerPed, Config.Shops[shop]["Interactions"]["Purchase"]["Location"])
				inMenu, pedVisible = false, true
				SetEntityVisible(playerPed, true)
			end, function(data, menu)
				DeleteDisplayVehicleInsideShop()
				WaitForVehicleToLoad(data.current.data.vehicle.model)

				ESX.Game.SpawnLocalVehicle(data.current.data.vehicle.model, Config.Shops[shop]["ViewPoints"][0][1], Config.Shops[shop]["ViewPoints"][0][2], function(vehicle)
					ESX.Game.SetVehicleProperties(vehicle, data.current.data.vehicle)
					currentDisplayVehicle = vehicle
					SetVehicleCurrentRpm(vehicle, 3000)
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
					FreezeEntityPosition(vehicle, true)
					SetModelAsNoLongerNeeded(data.current.data.vehicle.model)
				end)
			end)

			DeleteDisplayVehicleInsideShop()
			WaitForVehicleToLoad(firstVehicleData.model)

			ESX.Game.SpawnLocalVehicle(firstVehicleData.model, Config.Shops[shop]["ViewPoints"][0][1], Config.Shops[shop]["ViewPoints"][0][2], function(vehicle)
				ESX.Game.SetVehicleProperties(vehicle, firstVehicleData) -- apply modifications to car
				currentDisplayVehicle = vehicle
				SetVehicleCurrentRpm(vehicle, 3000)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				FreezeEntityPosition(vehicle, true)
				SetModelAsNoLongerNeeded(firstVehicleData.model)
			end)
		else
			ESX.ShowNotification('This shop is empty')
			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			inMenu, pedVisible = false, true
		end
	end, "stock", shop) -- callback end
end

function Vehicle_Preview(shop)
	if not Categories then return end
	ESX.TriggerServerCallback('rpuk_vehshop:getPreviewVehicles', function(vehicles)
		Vehicles = vehicles
		inMenu, pedVisible = true, false
		ESX.UI.Menu.CloseAll()
		local playerPed = PlayerPedId()
		local vehiclesByCategory = {}
		local elements           = {}
		local firstVehicleData   = nil

		for i=1, #Categories, 1 do
			vehiclesByCategory[Categories[i].name] = {}
		end

		for i=1, #Vehicles, 1 do
			if IsModelInCdimage(GetHashKey(Vehicles[i].model)) then
				table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
			else
				print(('[RPUK Vehicle Shop] [^3ERROR^7] Vehicle "%s" does not exist'):format(Vehicles[i].model))
			end
		end

		for i=1, #Categories, 1 do
			local category         = Categories[i]
			local categoryVehicles = vehiclesByCategory[category.name]
			local options          = {}
			for j=1, #categoryVehicles, 1 do
				local vehicle = categoryVehicles[j]
				if not firstVehicleData then
					firstVehicleData = vehicle
				end

				table.insert(options, ('%s'):format(GetLabelText(GetDisplayNameFromVehicleModel(vehicle.model)), ESX.Math.GroupDigits(vehicle.price)))
			end

			if options[1] ~= nil then
				table.insert(elements, {
					name    = category.name,
					label   = category.label,
					value   = 0,
					type    = 'slider',
					max     = #Categories[i],
					options = options
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
			title    = "",
			css 	=  Config.Shops[shop]["header"],
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			SetEntityCoords(playerPed, Config.Shops[shop]["Interactions"]["Preview"]["Location"])
			inMenu, pedVisible = false, true
			SetEntityVisible(PlayerPedId(), true)
		end, function(data, menu)
			menu.close()
			DeleteDisplayVehicleInsideShop()
			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			SetEntityCoords(playerPed, Config.Shops[shop]["Interactions"]["Preview"]["Location"])
			inMenu, pedVisible = false, true
			SetEntityVisible(PlayerPedId(), true)
		end, function(data, menu)
			local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
			DisplayStats = true

			DeleteDisplayVehicleInsideShop()
			WaitForVehicleToLoad(vehicleData.model)

			ESX.Game.SpawnLocalVehicle(vehicleData.model, vector3(-1506.79, -2993.57, -82.03), 92.15, function(vehicle)
				SetVehicleModKit(vehicle, 0)
				SetVehicleWindowTint(vehicle, 0)
				SetVehicleDirtLevel(vehicle, 0)
				currentDisplayVehicle = vehicle
				SetVehicleCurrentRpm(vehicle, 3000)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				FreezeEntityPosition(vehicle, true)
				SetModelAsNoLongerNeeded(vehicleData.model)
			end)
		end)

		ESX.Game.SpawnLocalVehicle(firstVehicleData.model, vector3(-1506.79, -2993.57, -82.03), 92.15, function(vehicle)
			SetVehicleModKit(vehicle, 0)
			SetVehicleWindowTint(vehicle, 0)
			SetVehicleDirtLevel(vehicle, 0)
			currentDisplayVehicle = vehicle
			SetVehicleCurrentRpm(vehicle, 3000)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetModelAsNoLongerNeeded(firstVehicleData.model)
		end)
	end, shop)
end

function OfferGateway(shop)
	inMenu = true
	local elements = {}

	table.insert(elements, {label = "Submit New Offer", value = "offer_new"})
	table.insert(elements, {label = "Check Current Offers", value = "offer_current"})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'myoffers', {
		title 	= '',
		css 	=  Config.Shops[shop]["header"],
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'offer_new' then
			NewOffer(shop)
		elseif data.current.value == 'offer_current' then
			MyOffers(shop)
		end
	end, function(data, menu)
		menu.close()
		inMenu = false
	end)
end

function MyOffers(shop)
	ESX.TriggerServerCallback('rpuk_vehshop:shopOffers', function(offersTable)
		local elements = {
			head = {"NAME", "MODEL", "PLATE", "OFFER", ""},
			rows = {}
		}
		for i=1, #offersTable, 1 do
			table.insert(elements.rows, {
				data = offersTable[i],
				cols = {
					offersTable[i].data.name,
					GetLabelText(GetDisplayNameFromVehicleModel(offersTable[i].data.model)),
					offersTable[i].data.plate,
					"£"..offersTable[i].data.offer,

					'{{' .. "Withdraw Offer" .. '|offer_withdraw}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_test', elements, function(data, menu)
			if data.value == 'offer_withdraw' then
				TriggerServerEvent('rpuk_vehshop:closeOffer', "withdraw", shop, data.data.data.plate)
				menu.close()
			end
		end, function(data, menu)
			menu.close()
		end)
	end, shop, "self")
end

function shopOffers(shop)
	ESX.TriggerServerCallback('rpuk_vehshop:shopOffers', function(offersTable)
		local elements = {
			head = {"NAME", "MODEL", "PLATE", "OFFER", "", ""},
			rows = {}
		}
		for i=1, #offersTable, 1 do
			table.insert(elements.rows, {
				data = offersTable[i],
				cols = {
					offersTable[i].data.name,
					GetLabelText(GetDisplayNameFromVehicleModel(offersTable[i].data.model)),
					offersTable[i].data.plate,
					"£"..offersTable[i].data.offer,
					'{{' .. "Reject Offer" .. '|offer_reject}}',
					'{{' .. "Accept Offer" .. '|offer_accept}}',

				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_test', elements, function(data, menu)
			if data.value == 'offer_reject' then
				TriggerServerEvent('rpuk_vehshop:closeOffer', "reject", shop, data.data.data.plate)
				menu.close()
			elseif data.value == 'offer_accept' then
				TriggerServerEvent('rpuk_vehshop:takeOwnership', "transfer", data.data.data, shop, data.data.data.offer)
				menu.close()
			end
		end, function(data, menu)
			menu.close()
		end)
	end, shop, "dealer")
end

function NewOffer(shop)
	ESX.TriggerServerCallback('rpuk_vehshop:returnVehicle', function(vehTable)
		inMenu = true
		local elements = {}

		for index, data in pairs(vehTable) do
			table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(data.vehicle.model)) .. " [<span style='color:cyan;'>" .. data.vehicle.plate .. "</span>]", model = data.vehicle.model, value = data.vehicle.plate})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'newOffer', {
			title 	= '',
			css 	=  Config.Shops[shop]["header"],
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'offer_amount', {
				title = GetLabelText(GetDisplayNameFromVehicleModel(data.current.model)) .. " [" .. data.current.value .. "]"
				}, function(data2, menu)
				if tonumber(data2.value) == nil then
					ESX.ShowNotification("Invalid Amount")
				else
					if rateLimit < 1 then
						--rateLimit = 1
						TriggerServerEvent('rpuk_vehshop:sendOffer', shop, data.current.value, data2.value, data.current.model)
						menu.close()
					else
						ESX.ShowAdvancedNotification("Offer Limited", "You are being rate limited", "Come back in 60 seconds.", 'CHAR_CARSITE', 0)
					end
				end
			end, function(data, menu)
				menu.close()
				inMenu = false
			end)
		end, function(data, menu)
			menu.close()
			inMenu = false
		end)
	end, "owned", shop) -- callback end
end

function NewStock(shop)
	ESX.TriggerServerCallback('rpuk_vehshop:returnVehicle', function(vehTable)
		inMenu = true
		local elements = {}

		for index, data in pairs(vehTable) do
			table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(data.vehicle.model)) .. " [<span style='color:cyan;'>" .. data.vehicle.plate .. "</span>]", model = data.vehicle.model, value = data.vehicle.plate})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'newOffer', {
			title 	= '',
			css 	=  Config.Shops[shop]["header"],
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'offer_amount', {
				title = "Input Price £"
				}, function(data2, menu)
				if tostring(data2.value) == nil then
					ESX.ShowNotification("Invalid Amount")
				else
					if tonumber(data2.value) ~= nil then
						ESX.ShowAdvancedNotification(tostring(data.current.value), "Moved to shop stock", "£"..data2.value, 'CHAR_CARSITE', 0)
						TriggerServerEvent('rpuk_vehshop:changeLocation', tostring(data.current.value), shop, data2.value, 4)
						menu.close()
					else
						ESX.ShowAdvancedNotification("Input Rejected", "Input did not meet the requirements", "", 'CHAR_CARSITE', 0)
					end
					menu.close()
				end
			end, function(data, menu)
				menu.close()
				inMenu = false
			end)
		end, function(data, menu)
			menu.close()
			inMenu = false
		end)
	end, "owned", "garage") -- callback end
end

function myGarage(shop)
	ESX.TriggerServerCallback('rpuk_vehshop:returnVehicle', function(vehTable)
		inMenu = true
		local elements = {}

		for index, data in pairs(vehTable) do
			table.insert(elements, {label = GetLabelText(GetDisplayNameFromVehicleModel(data.vehicle.model)) .. " [<span style='color:cyan;'>" .. data.vehicle.plate .. "</span>]", model = data.vehicle.model, value = data.vehicle.plate})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'newOffer', {
			title 	= '',
			css 	=  Config.Shops[shop]["header"],
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'offer_amount', {
				title = "Confirm By Entering Numberplate: "
				}, function(data2, menu)
				if data2.value == nil then
					ESX.ShowNotification("Invalid Amount")
				else
					if tostring(data2.value) == tostring(data.current.value) then
						ESX.ShowAdvancedNotification(tostring(data.current.value), "Moved to garage", "", 'CHAR_CARSITE', 0)
						TriggerServerEvent('rpuk_vehshop:changeLocation', tostring(data.current.value), "legionsquare_lower", 0, 1)
						menu.close()
					else
						ESX.ShowAdvancedNotification("Input Rejected", "Input did not meet the requirements", "", 'CHAR_CARSITE', 0)
					end
					menu.close()
				end
			end, function(data, menu)
				menu.close()
				inMenu = false
			end)
		end, function(data, menu)
			menu.close()
			inMenu = false
		end)
	end, "stock", shop) -- callback end
end

function newImport(shop)
	if not Categories then return end

	ESX.TriggerServerCallback('rpuk_vehshop:getImports', function(vehTable)
		Vehicles = vehTable
		inMenu = true
		ESX.UI.Menu.CloseAll()
		local playerPed = PlayerPedId()
		local vehiclesByCategory = {}
		local elements           = {}
		local firstVehicleData   = nil

		for i=1, #Categories, 1 do
			vehiclesByCategory[Categories[i].name] = {}
		end

		for i=1, #Vehicles, 1 do
			if IsModelInCdimage(GetHashKey(Vehicles[i].model)) then
				table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
			else
				print(('[RPUK Vehicle Shop] [^3ERROR^7] Vehicle "%s" does not exist'):format(Vehicles[i].model))
			end
		end

		for i=1, #Categories, 1 do
			local category         = Categories[i]
			local categoryVehicles = vehiclesByCategory[category.name]
			local options          = {}
			for j=1, #categoryVehicles, 1 do
				local vehicle = categoryVehicles[j]
				if not firstVehicleData then
					firstVehicleData = vehicle
				end
				table.insert(options, ('%s <span style="color:green;">£%s</span>'):format(vehicle.name, ESX.Math.GroupDigits(vehicle.price)))
			end

			table.insert(elements, {
				name    = category.name,
				label   = category.label,
				value   = 0,
				type    = 'slider',
				max     = #Categories[i],
				options = options
			})

			for i,v in pairs(elements) do -- clearout the non needed categories
				for k,x in pairs(Config.Shops[shop]["AllowedCats"]) do
					if v.name ~= x then
						table.remove(elements, i)
					end
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
			title    = "",
			css 	=  Config.Shops[shop]["header"],
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
				title = '',
				css 	=  Config.Shops[shop]["header"],
				align = 'top-left',
				elements = {
					{label = "No",  value = 'reject_vehicle'},
					{label = "Purchase Vehicle (Cash)", value = 'purchase_vehicle', currency = "cash"},
					{label = "Purchase Vehicle (Bank)", value = 'purchase_vehicle', currency = "bank"},
			}}, function(data2, menu2)
				if data2.current.value == 'purchase_vehicle' then
					local newPlate = GeneratePlate()
					ESX.TriggerServerCallback('rpuk_vehshop:PurchaseVehicle', function(result, message)
						if result == true then -- purchase success
							DeleteDisplayVehicleInsideShop() -- clearup cars
							inMenu = false
							ESX.UI.Menu.CloseAll()
							local found = false
							for index,spawnData in pairs(Config.Shops[shop]["SpawnPoints"]) do -- don't cause explosions outside checking spawn points
								if ESX.Game.IsSpawnPointClear(spawnData[1], 3.0) then
									found = true
									ESX.Game.SpawnVehicle(vehicleData.model, spawnData[1], spawnData[2], function(vehicle)
										local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
										TriggerServerEvent("rpuk_vehshop:takeOwnership","new", vehicleProps, false, false, getVehicleType(data.current.categoryName)) -- optional job at the end EG: vehicleProps, "police")
									end, {plate = newPlate}, {
										giveKeys = true
									})

									SetEntityCoords(PlayerPedId(), Config.Shops[shop]["Interactions"]["Management"]["Location"])
									ESX.ShowAdvancedNotification('Vehicle Purchased', 'Waiting Outside', "["..newPlate.."] Is waiting for you outside. Enjoy.", 'CHAR_CARSITE', 0)
									break -- break out the check loop
								end
							end
							if not found then
								ESX.Game.SpawnVehicle(vehicleData.model, vector3(0,0,0), data[2], function(vehicle)
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

									TriggerServerEvent("rpuk_vehshop:takeOwnership", "new", vehicleProps, false, false, getVehicleType(data.current.categoryName)) -- optional job at the end EG: vehicleProps, "police")
									SetEntityCoords(PlayerPedId(), Config.Shops[shop]["Interactions"]["Management"]["Location"])
									ESX.ShowAdvancedNotification('Vehicle Purchased', 'Spawn Blocked', "You have purchased ["..newPlate.."] however the spawn point is blocked.\nYou can take out your vehicle at any garage.", 'CHAR_CARSITE', 0)
								end, {plate = newPlate})
							end
						else -- failed
							ESX.ShowAdvancedNotification('Vehicle Purchase', 'Failed', message, 'CHAR_CARSITE', 0)
						end
					end, data2.current.currency, shop, vehicleData.model, newPlate, true, data.current.name)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
			DeleteDisplayVehicleInsideShop()
			FreezeEntityPosition(playerPed, false)
			SetEntityCoords(playerPed, Config.Shops[shop]["Interactions"]["Purchase"]["Location"])
			inMenu = false
		end, function(data, menu)
			local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
			DisplayStats = true

			DeleteDisplayVehicleInsideShop()
			WaitForVehicleToLoad(vehicleData.model)

			ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Shops[shop]["ViewPoints"][0][1], Config.Shops[shop]["ViewPoints"][0][2], function(vehicle)
				currentDisplayVehicle = vehicle
				SetVehicleCurrentRpm(vehicle, 3000)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				FreezeEntityPosition(vehicle, true)
				SetModelAsNoLongerNeeded(vehicleData.model)
			end)
		end)

		DeleteDisplayVehicleInsideShop()
		WaitForVehicleToLoad(firstVehicleData.model)

		ESX.Game.SpawnLocalVehicle(firstVehicleData.model, Config.Shops[shop]["ViewPoints"][0][1], Config.Shops[shop]["ViewPoints"][0][2], function(vehicle)
			currentDisplayVehicle = vehicle
			SetVehicleCurrentRpm(vehicle, 3000)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetModelAsNoLongerNeeded(firstVehicleData.model)
		end)
	end)
end

-- Vehicle stats
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if inMenu and DisplayStats and GetVehiclePedIsIn(PlayerPedId(),  false) ~= nil and GetVehiclePedIsIn(PlayerPedId(),  false) ~= 0 then -- inMenu
			local vehicle = GetVehiclePedIsIn(PlayerPedId(),  false)
			local model = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
			local topSpeed = GetVehicleEstimatedMaxSpeed(vehicle)

			if model == "NULL" then model = "Unknown" end

			DrawRect(0.942, 0.70, 0.1, 0.2, 0, 0, 0, 150)
			DrawAdvancedText(1.035, 0.63, 0.005, 0.0028, 0.4, model, 255, 255, 255, 255, 6, 0)

			if ShouldUseMetricMeasurements() then
				topSpeed = ESX.Math.Round(topSpeed * 3.6) .. ' KM/H'
			else
				topSpeed = ESX.Math.Round(topSpeed * 2.237) .. ' MPH'
			end

			DrawAdvancedText(1.035, 0.66, 0.005, 0.0028, 0.4, "Top Speed: " .. topSpeed, 0, 191, 255, 255, 6, 0)
			DrawAdvancedText(1.035, 0.69, 0.005, 0.0028, 0.4, "Acceleration: " .. tostring(ESX.Math.Round(GetVehicleAcceleration(vehicle), 1)), 0, 191, 255, 255, 6, 0)
			DrawAdvancedText(1.035, 0.72, 0.005, 0.0028, 0.4, "Braking: " .. tostring(ESX.Math.Round(GetVehicleMaxBraking(vehicle), 1)), 0, 191, 255, 255, 6, 0)
			DrawAdvancedText(1.035, 0.75, 0.005, 0.0028, 0.4, "Traction: " .. tostring(ESX.Math.Round(GetVehicleMaxTraction(vehicle), 1)), 0, 191, 255, 255, 6, 0)
			DrawAdvancedText(1.035, 0.78, 0.005, 0.0028, 0.4, "Inventory: " .. tostring(Config.invSize[GetVehicleClass(vehicle)]), 0, 191, 255, 255, 6, 0)
		end

		if not inMenu then
			Citizen.Wait(1000)
		end
	end
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
	SetTextFont(font)
	SetTextScale(sc, sc)
	SetTextJustification(jus)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

-- [[ ESX Vehicle Shop, Plate Generate ]] --
local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate(skipVerification)
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(GetRandomLetter(4) .. ' ' .. GetRandomNumber(3))

		if skipVerification then
			doBreak = true
		else
			ESX.TriggerServerCallback('rpuk_vehshop:isPlateTaken', function (isPlateTaken)
				if not isPlateTaken then
					doBreak = true
				end
			end, generatedPlate)
		end

		if doBreak then
			break
		end
	end

	return generatedPlate
end

-- mixing async with sync tasks
function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('rpuk_vehshop:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function ManageWorkers(zone)
	ESX.TriggerServerCallback('rpuk_shops:showWorkers', function(workersTable)
		inMenu = true
		elements = {}
		table.insert(elements, {label = "Add Worker", value = "add_worker"})
		for index, data in pairs(workersTable) do
			table.insert(elements, {label = data.label, value = data.value})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manageWorkers', {
			title 	= '',
			css 	=  Config.Shops[zone]["header"],
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'add_worker' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'worker_id', {
					title = "Enter the workers ID: "
					}, function(data2, menu)
					if data2.value == nil then
						ESX.ShowNotification("Invalid Value")
					else
						ESX.TriggerServerCallback('rpuk_shops:manageWorker', function(success)
							if success then
								menu.close()
							end
						end, tonumber(data2.value), "add", zone)
					end
				end, function(data, menu)
					menu.close()
					inMenu = false
				end)
			else
				ESX.TriggerServerCallback('rpuk_shops:manageWorker', function(success)
					if success then
						menu.removeElement({value = data.current.value})
						menu.refresh()
					end
				end, data.current.value, "remove", zone)
			end
		end, function(data, menu)
			menu.close()
			inMenu = false
		end)
	end, zone)
end

function getVehicleType(vehicleCategory)
	if vehicleCategory == 'boats' then
		return 'boat'
	elseif vehicleCategory == 'planes' or vehicleCategory == 'helicopters' then
		return 'aircraft'
	else
		return 'car'
	end
end