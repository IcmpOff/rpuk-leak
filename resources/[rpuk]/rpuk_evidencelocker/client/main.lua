RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	interactions = {}
	activeInteractions = {}
	for k,v in pairs(config.lockers) do
		if isInList(ESX.Player.GetJobName(), v.whitelisted) then
			for key, val in pairs(v.positions) do
				interactions["lockers:"..k..":"..key] = createInteraction({
					id = "lockers:"..k..":"..key,
					pos = val,
					text = v.text,
					whitelist = v.whitelisted,
					dist = val.dist,
					action = function()
						TriggerServerEvent("rpuk_evidencelocker:openLocker", k, key, val.requiredItem)
					end
				})
			end
		end
	end
	for k,v in pairs(config.selling) do
		if isInList(ESX.Player.GetJobName(), v.whitelisted) then
			for key, val in pairs(v.positions) do
				interactions["selling:"..k..":"..key] = createInteraction({
					id = "selling:"..k..":"..key,
					pos = val,
					text = v.text,
					whitelist = v.whitelisted,
					dist = val.dist,
					action = function()
						TriggerServerEvent("rpuk_evidencelocker:openGrinder", k, key)
					end
				})
			end
		end
	end
end)


RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(data)
	for k,v in pairs(config.lockers) do
		if isInList(ESX.Player.GetJobName(), v.whitelisted) then
			for key, val in pairs(v.positions) do
				interactions["lockers:"..k..":"..key] = createInteraction({
					id = "lockers:"..k..":"..key,
					pos = val,
					text = v.text,
					whitelist = v.whitelisted,
					dist = val.dist,
					action = function()
						TriggerServerEvent("rpuk_evidencelocker:openLocker", k, key, val.requiredItem)
					end
				})
			end
		end
	end
	for k,v in pairs(config.selling) do
		if isInList(ESX.Player.GetJobName(), v.whitelisted) then
			for key, val in pairs(v.positions) do
				interactions["selling:"..k..":"..key] = createInteraction({
					id = "selling:"..k..":"..key,
					pos = val,
					text = v.text,
					whitelist = v.whitelisted,
					dist = val.dist,
					action = function()
						TriggerServerEvent("rpuk_evidencelocker:openGrinder", k, key)
					end
				})
			end
		end
	end
end)