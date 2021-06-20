guiEnabled = false
local current_shop = nil

--[[HANDLES UI OPEN/CLOSE & POPULATION OF DATA]]--
function EnableGui(enable, callType, shop)
	if enable ~= false then
		if callType == "keeper" then
			current_shop = shop
			ESX.TriggerServerCallback('rpuk_stock:getCoreData', function(shopData, orderData, vehList, rawMats, manuGoods)
				local form_vehList, form_rawList, form_manuList, form_delivs, form_placed = {}, {}, {}, {}, {} -- formatted lists (label, item/model, price)

				if tostring(shopData["shop_type"]) == "vehicle" then
					for index, data in pairs(vehList) do
						-- print(ESX.DumpTable(data))
						form_vehList[index] = {}
						local name = GetLabelText(GetDisplayNameFromVehicleModel(data["model"]))
						form_vehList[index] = {name,data["model"],data["price"]}
					end
				else
					for index, data in pairs(rawMats) do
						form_rawList[index] = {}
						form_rawList[index] = {data["label"],data["name"]}
					end

					for index, data in pairs(manuGoods) do
						form_manuList[index] = {}
						form_manuList[index] = {data["label"],data["name"]}
					end
				end

				orderCount, delivCount = 0, 0 --  quick way of reindexing for the js to read it
				for index, data in pairs(orderData) do
					if orderData[index][5] == "placed" then
						form_placed[orderCount] = {}
						form_placed[orderCount] = {data[1],data[2],data[3],data[4],data[5], data[6]}
						orderCount = orderCount + 1
					elseif orderData[index][5] == "delivered" then
						form_delivs[delivCount] = {}
						form_delivs[delivCount] = {data[1],data[2],data[3],data[4],data[5], data[6]}
						delivCount = delivCount + 1
					end
				end

				SetNuiFocus(true,true)
				guiEnabled = enable
				SendNUIMessage({
					type = "enableui",
					enable = enable,
					callType = callType,
					driverData = {},
					vehicles = form_vehList,
					manugoods = form_manuList,
					rawmats = form_rawList,
					curOrders = form_placed, -- coming in pre-formatted from server // withholds identifiers etc
					curDelivs = form_delivs, -- coming in pre-formatted from server // withholds identifiers etc
					banking = tonumber(shopData["bank"]), -- shop type + bank account stuff
					marketType = tostring(shopData["shop_type"]),
				})
			end, current_shop)
		elseif callType == "driver" then
			ESX.TriggerServerCallback('rpuk_stock:deliv_pulljobs', function(jobData)
				local format_jobs, orderCount = {}, 0

				for index, data in pairs(jobData) do
					if jobData[index][5] == "placed" then
						format_jobs[orderCount] = {}
						local zoneNameFull = GetNameOfZone(Config.DelivPoints[data[4]][1].x, Config.DelivPoints[data[4]][1].y, Config.DelivPoints[data[4]][1].z)
						local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(Config.DelivPoints[data[4]][1].x, Config.DelivPoints[data[4]][1].y, Config.DelivPoints[data[4]][1].z))
						location = zoneNameFull .. " | " .. streetName
						format_jobs[orderCount] = {data[1],data[2],data[3],location,data[5], data[6], data[4]}
						orderCount = orderCount + 1
					end
				end

				SetNuiFocus(true,true)
				guiEnabled = enable
				SendNUIMessage({
					type = "enableui",
					enable = enable,
					callType = callType,
					driverData = format_jobs,
					vehicles = {},
					rawmats = {},
					manugoods = {},
					curOrders = {}, -- coming in pre-formatted from server // withholds identifiers etc
					curDelivs = {}, -- coming in pre-formatted from server // withholds identifiers etc
					banking = 0, -- shop type + bank account stuff
					marketType = "driver",
				})
			end)
		end
	else
		SetNuiFocus(enable, enable)
		guiEnabled = enable
		SendNUIMessage({
			type = "enableui",
			enable = enable,
		})
	end
end

--[[EXIT THE NUI ESC CALLBACK]]--
RegisterNUICallback('escape', function(data, cb)
	EnableGui(false)
	cb('ok')
end)

--[[ORDER CALLBACK FROM THE NUI]]--
RegisterNUICallback('order', function(data, cb)
	if data.id == "vehicle" then
		ESX.TriggerServerCallback('rpuk_stock:generateNewOrder', function(result, message)

		end, data.id, data.option, current_shop, data.quantity, data.price)
	else
		if tonumber(data.quantity) > 0 and tonumber(data.price) > 0 then
			ESX.TriggerServerCallback('rpuk_stock:generateNewOrder', function(result, message)

			end, data.id, data.option, current_shop, data.quantity, data.price)
		end
	end

	cb('ok')
end)

--[[ALTER ORDER CALLBACK FROM THE NUI]]--
RegisterNUICallback('driver', function(data, cb)
	local jobID = data.id
	local sleep = false

	for index,data2 in pairs(data.type) do
		if tonumber(data2[6]) == tonumber(jobID) then
			if sleep then
				TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'inform', text = "You have already accepted a delivery!" })
				Citizen.Wait(5000)
			end

			if data2[1] == "vehicle" then -- starting vehicle job
				sleep = false
				TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'inform', text = "You have accepted a delivery!" })

				if tonumber(data2[3]) >= 100000 then
					containerJob("trailerlarge", data2[7], "docks", data2[6])
				else
					containerJob("tr4", data2[7], "docks", data2[6])
				end
			else
				ESX.ShowAdvancedNotification('Pegasus Delivery & Retail', 'Job Specification', "", 'CHAR_MP_FM_CONTACT', 0)
			end
		end
	end

	cb('ok')
end)

RegisterNUICallback('altero', function(data, cb)
	if tonumber(data.id) > 0 then
		TriggerServerEvent('rpuk_stock:alterOrder', data.id, data.type)
		TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'inform', text = "You have altered a order!" })
	end
	cb('ok')
end)

RegisterNetEvent('rpuk_stock:accepted_deliv')
AddEventHandler('rpuk_stock:accepted_deliv', function(shop, model)
	local newPlate = exports['rpuk_vehicle']:GeneratePlate()

	ESX.Game.SpawnVehicle(model, Config.DelivPoints[shop][2], 0, function(spawned_vehicle) -- spawn vehicle under the map
		local vehicleProps = ESX.Game.GetVehicleProperties(spawned_vehicle) -- get vehicle props
		TriggerServerEvent("rpuk_vehshop:takeOwnership","delivered", vehicleProps)-- optional job at the end EG: vehicleProps, "police")
		TriggerEvent('mythic:notify:client:SendAlert', {length = 6000, type='inform', text='Vehicle is now in your garage at legion square'})
		TriggerEvent('mythic:notify:client:SendAlert', {length = 6000, type='inform', text='Go to the "Garage To Stock Menu" to put it up for sale.'})
		ESX.Game.DeleteEntity(spawned_vehicle)
	end, {
		plate = newPlate
	})
end)

RegisterNetEvent("rpuk_stock:openGui")
AddEventHandler("rpuk_stock:openGui", function(shop)
	EnableGui(true, "keeper", shop)
end)

--[[BANK CALLBACK FROM THE NUI]]--
RegisterNUICallback('bank', function(data, cb)
	if tonumber(data.quantity) ~= nil and tonumber(data.quantity) > 0 then
		ESX.TriggerServerCallback('rpuk_stock:handleBank', function(result, newval)
		if result == true then -- has altered the account
			SendNUIMessage({
				type = "updateBank", -- update the bank balance field
				newValue = newval,
			})
		end
		end, data.type, tonumber(data.quantity), current_shop)
	end
	cb('ok')
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		EnableGui(false)
		SetNuiFocus(false)
	end
end)