local Categories, Vehicles = {}, {}
local pVehicles = {} -- preview tables
local VehicleData, ShopOffers = {}, {}

ESX.RegisterServerCallback('rpuk_vehshop:PurchaseVehicle', function(source, callback, currency, shop, vehModel, plate, importMenu, category)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bankAccount, handCash = xPlayer.getAccountBalance('bank'), xPlayer.getMoney()

	if xPlayer then -- ensure they are online and have valid data
		if Config.Shops[shop]["Type"] == "player" and not importMenu then -- a player owned shop // give car with data change
			local found = false
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			}, function(result)
				if result then
					if currency == "bank" then
						if bankAccount >= result[1]["sale_price"] then-- does the player have enough money?
							xPlayer.removeAccountMoney('bank', result[1]["sale_price"], ('%s (%s) [%s]'):format('Vehicle Purchase', plate, GetCurrentResourceName()))
							callback(true, "purchased")
							purchaseHandle(plate, false, xPlayer.identifier, xPlayer.rpuk_charid)
							createNewTrunk(plate)
							payForCar(shop, result[1]["sale_price"])
							print("RPUK TRANSACTION: RPUK VEHICLE SHOP [".. shop .."] [".. xPlayer.identifier .."]" .. " PURCHASED ["..plate.."][BANK £".. result[1]["sale_price"] .."][SUCCESS]")
							if shop == "scrapyard" then
								local character = xPlayer.firstname .. " " .. xPlayer.lastname
								TriggerEvent('rpuk:disc_post', source, "lostmc_bike_sale", "Motorbike Sale [" .. shop .. "]", "[" .. plate .. "] Was Sold for £" .. result[1]["sale_price"] .. " [" .. currency .. "]\nLog Book Transfered to: " .. character)
							end
						else
							print("RPUK TRANSACTION: RPUK VEHICLE SHOP [".. shop .."] [".. xPlayer.identifier .."]" .. " NOT PURCHASED ["..plate.."][BANK £".. result[1]["sale_price"] .."][FAILED]")
							callback(false, "[£" .. bankAccount .. "] You don't have enough in the bank to purchase this vehicle!")
						end
					elseif currency == "cash" then
						if handCash >= result[1]["sale_price"] then-- does the player have enough money?
							xPlayer.removeMoney(result[1]["sale_price"], ('%s (%s) [%s]'):format('Vehicle Purchase', plate, GetCurrentResourceName()))
							createNewTrunk(plate)
							callback(true, "purchased")
							purchaseHandle(plate, false, xPlayer.identifier, xPlayer.rpuk_charid)
							payForCar(shop, result[1]["sale_price"])
							print("RPUK TRANSACTION: RPUK VEHICLE SHOP [".. shop .."] [".. xPlayer.identifier .."]" .. " PURCHASED ["..plate.."][CASH £".. result[1]["sale_price"] .."][SUCCESS]")
							if shop == "scrapyard" then
								local character = xPlayer.firstname .. " " .. xPlayer.lastname
								TriggerEvent('rpuk:disc_post', source, "lostmc_bike_sale", "Motorbike Sale [" .. shop .. "]", "[" .. plate .. "] Was Sold for £" .. result[1]["sale_price"] .. " [" .. currency .. "]\nLog Book Transfered to: " .. character)
							end
						else
							print("RPUK TRANSACTION: RPUK VEHICLE SHOP [".. shop .."] [".. xPlayer.identifier .."]" .. " NOT PURCHASED ["..plate.."][CASH £".. result[1]["sale_price"] .."][FAILED]")
							callback(false, "[£" .. handCash .. "] You don't have enough cash to purchase this vehicle!")
						end
					end
				else
					callback(false, "Vehicle with this plate wasn't found!")
				end
			end)
		else -- server shop // give car with no data change
			local found = false
			for index, data in pairs(Vehicles) do
				if data.model == vehModel and data.category == category then
					found = true
					if currency == "bank" then
						if bankAccount >= data["price"] then-- does the player have enough money?
							xPlayer.removeAccountMoney('bank', data["price"], ('%s (%s) [%s]'):format('Vehicle Purchase', plate, GetCurrentResourceName()))
							callback(true, "purchased")
							createNewTrunk(plate)
							print("RPUK TRANSACTION: RPUK VEHICLE SHOP [".. shop .."] [".. xPlayer.identifier .."]" .. " PURCHASED ["..plate.."][BANK £".. data["price"] .."][SUCCESS]")
						else
							print("RPUK TRANSACTION: RPUK VEHICLE SHOP [".. shop .."] [".. xPlayer.identifier .."]" .. " NOT PURCHASED ["..plate.."][BANK £".. data["price"] .."][FAILED]")
							callback(false, "[£" .. bankAccount .. "] You don't have enough in the bank to purchase this vehicle!")
						end
					elseif currency == "cash" then
						if handCash >= data["price"] then-- does the player have enough money?
							xPlayer.removeMoney(data["price"], ('%s (%s) [%s]'):format('Vehicle Purchase', plate, GetCurrentResourceName()))
							callback(true, "purchased")
							createNewTrunk(plate)
							print("RPUK TRANSACTION: RPUK VEHICLE SHOP [".. shop .."] [".. xPlayer.identifier .."]" .. " PURCHASED ["..plate.."][CASH £".. data["price"] .."][SUCCESS]")
						else
							print("RPUK TRANSACTION: RPUK VEHICLE SHOP [".. shop .."] [".. xPlayer.identifier .."]" .. " NOT PURCHASED ["..plate.."][CASH £".. data["price"] .."][FAILED]")
							callback(false, "[£" .. handCash .. "] You don't have enough cash to purchase this vehicle!")
						end
					end
				end
			end
		end
	else
		print("RPUK TRANSACTION: REJECTED - PLAYER NOT ONLINE [SOURCE: " .. source .. "]")
		callback(false, "Something went wrong.")
	end
end)

function purchaseHandle(plate, stored, newOwner, rpukid) -- Handles the purchase of the vehicle - transfer from shop to owner
	if plate then -- request of ownership change and remove from
		MySQL.Async.execute('UPDATE owned_vehicles SET `owner` = @newOwner, rpuk_charid=@rpukid, location = "legionsquare_lower", state = 1, sale_price = 0 WHERE plate = @plate', {
			['@newOwner'] = newOwner,
			['@rpukid'] = rpukid,
			['@plate'] = plate
		}, function(result)
			if result then
				print("RPUK VEHSHOP - (vehOwnership)[" .. plate .. "]" .. "[" .. tostring(stored) .. "]".. "[" .. newOwner .. "]")
			end
		end)
	end
end

function createNewTrunk(plate)
	MySQL.Async.execute('INSERT INTO trunk_inventory (data, plate, owned) VALUES (@data, @plate, @owned)', {
		['@data'] = "{}",
		['@plate'] = plate,
		['@owned'] = 1
	})
end

function payForCar(shop, add)
	MySQL.Async.fetchAll("SELECT bank FROM shops_owned WHERE shop=@shop", {
		['@shop'] = shop
	}, function(data)
		if data[1]["bank"] then
			MySQL.Async.execute('UPDATE shops_owned SET `bank` = @newBank WHERE shop = @shop', {
				['@newBank'] = data[1]["bank"] + tonumber(add),
				['@shop'] = shop
			})

		end
	end)
end

function chargeAccount(shop, offer, plate, stored, newOwner)
	xPlayer = ESX.GetPlayerFromIdentifier(newOwner)
	MySQL.Async.fetchAll("SELECT bank FROM shops_owned WHERE shop=@shop", {
		['@shop'] = shop
	}, function(data)
		if data[1]["bank"] >= tonumber(offer) then
			MySQL.Async.execute('UPDATE shops_owned SET `bank` = @newBank WHERE shop = @shop', {
				['@newBank'] = data[1]["bank"] - tonumber(offer),
				['@shop'] = shop
			}, function(result)
				if result then
					print("RPUK VEHSHOP - (BANK CHANGE)[" .. shop .. "]" .. "[" .. tostring(data[1]["bank"]) .. "] TO".. "[" .. data[1]["bank"] - tonumber(offer) .. "]")
					purchaseHandle(plate, stored, newOwner, xPlayer.rpuk_charid)
					for index, data in pairs(ShopOffers) do
						for i=1, #data, 1 do
							if data[i]["plate"] == plate then
								table.remove(ShopOffers[index], i)
								print("RPUK VEHICLE SHOPS - OFFER ACCEPTED " .. plate .. " BY " .. xPlayer.identifier)
								break
							end
						end
					end
					xPlayer.showAdvancedNotification('Offer Accepted', "£-" .. offer .. "", "", 'CHAR_CARSITE', 0)
				else
					xPlayer.showAdvancedNotification('Insufficient Funds', "Shop Bank Account", "", 'CHAR_CARSITE', 0)
				end
			end)
		else
			xPlayer.showAdvancedNotification('Insufficient Funds', "Shop Bank Account", "", 'CHAR_CARSITE', 0)
		end
	end)
end

-- [[ ESX Vehicle Shop Plate Checking ]] --
ESX.RegisterServerCallback('rpuk_vehshop:isPlateTaken', function(source, callback, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		callback(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('rpuk_vehshop:returnVehicle', function(source, callback, callType, shop)
    local xPlayer = ESX.GetPlayerFromId(source)
	local vehicles = {}
	if callType == "stock" then
		MySQL.Async.fetchAll("SELECT ov.*, u.firstname, u.lastname FROM owned_vehicles AS ov INNER JOIN users AS u ON ov.rpuk_charid = u.rpuk_charid WHERE location = @shop", {
			['@shop'] = shop
		}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(vehicles, {
					vehicle = vehicle,
					state = v.state,
					price = v.sale_price,
					impounded = v.impounded,
					plate = v.plate,
					seller = string.sub(v.firstname, 1, 1) .. ". " .. v.lastname
				})
			end
			callback(vehicles)
		end)
		--
	elseif callType == "owned" then
		MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE rpuk_charid=@rpukid AND state!=4 AND state!=0", {
			['@rpukid'] = xPlayer.rpuk_charid
		}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(vehicles, {
					vehicle = vehicle,
					state = v.state,
					price = v.sale_price,
					impounded = v.impounded,
					plate = v.plate
				})
			end
			callback(vehicles)
		end)
	end
end)

RegisterNetEvent('rpuk_vehshop:takeOwnership')
AddEventHandler('rpuk_vehshop:takeOwnership', function(callType, vehicleProps, job, offer, vehicleType) -- job or the shop location // offer is optional value used by accepting offer only
	local xPlayer = ESX.GetPlayerFromId(source)

	if callType == "transfer" then -- used for accepting car offers
		local plate, stored, newOwner, shop = vehicleProps.plate, "garage", xPlayer.identifier, job
		chargeAccount(shop, offer, plate, stored, newOwner)
	elseif callType == "new" then -- used in purchasing a car
		if job then
			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, rpuk_charid, plate, vehicle, job, type) VALUES (@owner, @rpukid, @plate, @vehicle, @job, @type)', {
				['@owner']   = xPlayer.identifier,
				['@rpukid']   = xPlayer.rpuk_charid,
				['@plate']   = vehicleProps.plate,
				['@vehicle'] = json.encode(vehicleProps),
				['@job'] = job,
				['@type'] = vehicleType
			}, function(rowsChanged) end)
		else
			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, rpuk_charid, plate, vehicle, type) VALUES (@owner, @rpukid, @plate, @vehicle, @type)', {
				['@owner']   = xPlayer.identifier,
				['@rpukid']   = xPlayer.rpuk_charid,
				['@plate']   = vehicleProps.plate,
				['@vehicle'] = json.encode(vehicleProps),
				['@type'] = vehicleType
			}, function(rowsChanged) end)
		end
	elseif callType == "delivered" then -- used in purchasing a car
		if job then
			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, rpuk_charid, state, plate, vehicle, location, job) VALUES (@owner, @rpukid, @state, @plate, @vehicle, @location, @job)', {
				['@owner']   = xPlayer.identifier,
				['@rpukid']   = xPlayer.rpuk_charid,
				['@state']	 = 1,
				['@plate']   = vehicleProps.plate,
				['@vehicle'] = json.encode(vehicleProps),
				['@location']= 'legionsquare_lower',
				['@job'] = job
			}, function(rowsChanged) end)
		else
			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, rpuk_charid, state, plate, vehicle, location) VALUES (@owner, @rpukid, @state, @plate, @vehicle, @location)', {
				['@owner']   = xPlayer.identifier,
				['@rpukid']   = xPlayer.rpuk_charid,
				['@state']	 = 1,
				['@plate']   = vehicleProps.plate,
				['@vehicle'] = json.encode(vehicleProps),
				['@location']= 'legionsquare_lower',
			}, function(rowsChanged) end)
		end
	end
end)

RegisterNetEvent('rpuk_vehshop:changeLocation')
AddEventHandler('rpuk_vehshop:changeLocation', function(plate, newLoc, newPrice, state)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE owned_vehicles SET `location` = @newLoc, sale_price = @price, state = @state WHERE plate = @plate', {['@newLoc'] = newLoc,['@plate'] = plate,['@price'] = newPrice, ['@state'] = state})
	print("RPUK VEHICLE SHOPS - " .. plate .. " CHANGE LOCATION TO " .. newLoc .. " BY " .. xPlayer.identifier .. " PRICE " .. newPrice)
end)

RegisterNetEvent('rpuk_vehshop:sendOffer')
AddEventHandler('rpuk_vehshop:sendOffer', function(shop, plate, offer, model)
	local xPlayer = ESX.GetPlayerFromId(source)
	if ShopOffers[shop] == nil then
		ShopOffers[shop] = {}
	end
	table.insert(ShopOffers[shop], {owner = xPlayer.identifier, plate = plate, offer = offer, name = xPlayer.name, model = model})
	xPlayer.showAdvancedNotification('Offer Submitted', plate, "Submitted for value £" .. offer, 'CHAR_CARSITE', 0)
end)

RegisterNetEvent('rpuk_vehshop:closeOffer')
AddEventHandler('rpuk_vehshop:closeOffer', function(callType, shop, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	if callType == "withdraw" then
		for index, data in pairs(ShopOffers) do
			for i=1, #data, 1 do
				if data[i]["plate"] == plate then
					table.remove(ShopOffers[index], i)
					print("RPUK VEHICLE SHOPS - OFFER WITHDRAWN " .. plate .. " BY " .. xPlayer.identifier)
					xPlayer.showAdvancedNotification('Offer Withdrawn', plate, "", 'CHAR_CARSITE', 0)
					break
				end
			end
		end
	end
	if callType == "reject" then
		for index, data in pairs(ShopOffers) do
			for i=1, #data, 1 do
				if data[i]["plate"] == plate then
					table.remove(ShopOffers[index], i)
					print("RPUK VEHICLE SHOPS - OFFER REJECTED " .. plate .. " BY " .. xPlayer.identifier)
					xPlayer.showAdvancedNotification('Offer Rejected', plate, "", 'CHAR_CARSITE', 0)
					break
				end
			end
		end
	end
end)

ESX.RegisterServerCallback('rpuk_vehshop:shopOffers', function(source, callback, shop, callType)
	local xPlayer = ESX.GetPlayerFromId(source)
	if callType == "self" then
		local cb_offers = {}
		if ShopOffers[shop] then -- stop the nil return
			for index,data in pairs(ShopOffers[shop]) do
				if xPlayer.identifier == data["owner"] then
					table.insert(cb_offers, {data = data})
				end
			end
		end
		callback(cb_offers)
	elseif callType == "dealer" then
		local cb_offers = {}
		if ShopOffers[shop] then -- stop the nil return
			for index,data in pairs(ShopOffers[shop]) do
				table.insert(cb_offers, {data = data})
			end
		end
		callback(cb_offers)
	end
end)

ESX.RegisterServerCallback('rpuk_vehshop:getImports', function(source, callback)
	local import_vehicles = {}
	local vehicles = MySQL.Sync.fetchAll("SELECT * FROM vehicles WHERE import = 1 AND available = 1")
	--print(ESX.DumpTable(vehicles))
	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]
		table.insert(import_vehicles, vehicle)
	end
	callback(import_vehicles)
end)

--[[ Dealing with the server vehicle shops data ]]--
MySQL.ready(function()
	Citizen.Wait(1000) -- let clients load script

	Categories     = MySQL.Sync.fetchAll("SELECT * FROM vehicle_categories")
	local vehicles = MySQL.Sync.fetchAll("SELECT * FROM vehicles WHERE available='1'")

	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
				break
			end
		end

		table.insert(Vehicles, vehicle)
	end

	vehicles = MySQL.Sync.fetchAll("SELECT * FROM vehicles WHERE available='1' AND import='1'")

	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
				break
			end
		end

		table.insert(pVehicles, vehicle)
	end

	TriggerClientEvent('rpuk_vehshop:setVehicleList', -1, Vehicles, Categories)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer) xPlayer.triggerEvent('rpuk_vehshop:setVehicleList', Vehicles, Categories) end)

ESX.RegisterServerCallback('rpuk_vehshop:getCategories', function(source, callback)
	callback(Categories)
end)

ESX.RegisterServerCallback('rpuk_vehshop:getPreviewVehicles', function(source, callback, shop)
	callback(pVehicles)
end)