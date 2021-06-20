local canRequest = {}
--canRequest[source] = {["requested"] = true, ["time"] = os.time()} -- generate a pending request

ESX.RegisterServerCallback("rpuk_processing:startProcessing", function(source, cb, callType)
	local xPlayer = ESX.GetPlayerFromId(source)
	local processID = callType["processData"]["UID"] -- the UID from the config
	local dist = #(callType["processData"]["Marker"] - xPlayer.getCoords(true))
	local result, message, passed = false, "Passed", 0
	local items = {}

	if dist < callType["processData"]["MarkerSettings"]["x"] then
		if not canRequest[source] then
			for item,v in pairs(callType["processData"]["Input"]) do -- for each item in the input table, check the player has >= the needed quantity
				local check = xPlayer.getInventoryItem(item)
				if check.count < callType["processData"]["Input"][item] then
					result, message, passed = false, "You don't have enough " .. check.label, 0
					break
				end
				while check.count == nil or check.count == 0 do Citizen.Wait(10) end
				if callType["processData"]["Batch"] then
					passed = check.count * (callType["processData"]["Timer"] * 1000)
				else
					passed = callType["processData"]["Timer"] * 1000
				end
				result = true
				items[item] = {}
				items[item].count = check.count
			end
		else
			result, message, passed = false, "You are already processing", 0
		end
	else
		xPlayer.showNotification("You are not in the processing zone")
	end
	
	if result then
		canRequest[source] = {["requested"] = true, ["time"] = os.time()}
	end
	
	cb(result, message, passed, items)
end)

RegisterNetEvent('rpuk_processing:endProcessing')
AddEventHandler('rpuk_processing:endProcessing', function(callType, items)
	if canRequest[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		local processID = callType["processData"]["UID"] -- the UID from the config
		local dist = #(callType["processData"]["Marker"] - xPlayer.getCoords(true))
		if dist < callType["processData"]["MarkerSettings"]["x"] then
			for index, data in pairs(items) do
				if xPlayer.getInventoryItem(index).count ~= data.count then
					xPlayer.showNotification("You don't have the same quantity")
					canRequest[source] = nil
					return
				end
			end
			if not callType["processData"]["Batch"] then -- single processing
				for item,v in pairs(callType["processData"]["Input"]) do -- Take the shit in the input table away
					xPlayer.removeInventoryItem(item, callType["processData"]["Input"][item])
				end
				for item,v in pairs(callType["processData"]["Output"]) do -- Give the stuff
					xPlayer.addInventoryItem(item, callType["processData"]["Output"][item])
				end
			else -- multi processing // ensure single items only in input & output - 1 for 1
				local sQuant = nil
				for item,v in pairs(callType["processData"]["Input"]) do -- Take the shit in the input table away
					local invItem = xPlayer.getInventoryItem(item)
					sQuant = invItem.count / callType["processData"]["Input"][item]
					xPlayer.removeInventoryItem(item, invItem.count)				
				end
				for item,v in pairs(callType["processData"]["Output"]) do -- Take the shit in the input table away	
					xPlayer.addInventoryItem(item, callType["processData"]["Output"][item] * math.floor(sQuant))
				end
					
			end			
			canRequest[source] = nil		
		else
			xPlayer.showNotification("You are not in the processing zone")
			canRequest[source] = nil
		end
	else
		local uniqRef = math.random(1000,1500) * math.random(1,5) + math.random(100,1000) -- CTRL F this in console if anyone reports it
		xPlayer.showNotification("Request Failure: Report this \n#" .. uniqRef)
		print("RPUK PROCESSING: UNEXPECTED REQUEST ["..uniqRef.."] - " .. xPlayer.getIdentifier())-- Wasn't expecting a request
	end
end)

function tablelength(T) -- will count how many elements in the table and return it
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

AddEventHandler('playerDropped', function(reason)
	if canRequest[source] then
		canRequest[source] = nil
	end
end)