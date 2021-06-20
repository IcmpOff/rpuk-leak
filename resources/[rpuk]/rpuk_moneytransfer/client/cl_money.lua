RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	interactions = {}
	activeInteractions = {}
	for k,v in pairs(config.pickupLocations) do
		if isInList(ESX.Player.GetJobName(), v.whitelisted) then
			for key, val in pairs(v.positions) do
				interactions["collectionPoint:"..k..":"..key] = createInteraction({
					id = "collectionPoint:"..k..":"..key,
					pos = val,
					text = v.text,
					whitelist = v.whitelisted,
					action = function()
						TriggerServerEvent("rpuk_moneytransfer:openMenu", k, key)
					end
				})
			end
		end
	end
	for k,v in pairs(config.dropoffLocations) do
		if isInList(ESX.Player.GetJobName(), v.whitelisted) then
			for key, val in pairs(v.positions) do
				interactions["dropoffPoint:"..k..":"..key] = createInteraction({
					id = "dropoffPoint:"..k..":"..key,
					pos = val,
					text = val.text,
					whitelist = v.whitelisted,
					action = function()
						TriggerServerEvent("rpuk_moneytransfer:openMenu:dropoff", k, key)
					end
				})
			end
		end
	end
end)


RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(data)
	for k,v in pairs(config.pickupLocations) do
		if isInList(ESX.Player.GetJobName(), v.whitelisted) then
			for key, val in pairs(v.positions) do
				interactions["collectionPoint:"..k..":"..key] = createInteraction({
					id = "collectionPoint:"..k..":"..key,
					pos = val,
					text = v.text,
					whitelist = v.whitelisted,
					action = function()
						TriggerServerEvent("rpuk_moneytransfer:openMenu", k, key)
					end
				})
			end
		end
	end
	for k,v in pairs(config.dropoffLocations) do
		if isInList(ESX.Player.GetJobName(), v.whitelisted) then
			for key, val in pairs(v.positions) do
				interactions["dropoffPoint:"..k..":"..key] = createInteraction({
					id = "dropoffPoint:"..k..":"..key,
					pos = val,
					text = val.text,
					whitelist = v.whitelisted,
					action = function()
						TriggerServerEvent("rpuk_moneytransfer:openMenu:dropoff", k, key)
					end
				})
			end
		end
	end
end)