cooldown	= 0
local crates = {}
isDone		= {
	lifeinvader = false,
}

local lester = {
	timer = config.lesteroutofhouse,
	status = false -- false is that he is out of house and true is in house
}

isBeingHacked = {
	name = nil,
	timer = 0,
}
activeInteractions = {}

isBeingUploaded = false

RegisterNetEvent('rpuk_lester:addInteracting')
RegisterNetEvent('rpuk_lester:removeInteracting')
RegisterNetEvent('rpuk_lester:startDownload')
RegisterNetEvent('rpuk_lester:startUpload')
RegisterNetEvent('rpuk_lester:getUSB')
RegisterNetEvent("rpuk_lester:gas")
RegisterNetEvent("rpuk_lester:gasStop")
RegisterNetEvent('rpuk_lester:buyCrate')
RegisterNetEvent('rpuk_lester:openCrate')
RegisterNetEvent('rpuk_lester:isDoneUploading')
RegisterNetEvent('rpuk_lester:paycopPed')

ESX.RegisterServerCallback('rpuk_lester:getActiveCrates', function(source, cb)
	cb(crates)
end)

ESX.RegisterServerCallback('rpuk_lester:getInfoWhenJoin', function(source, cb, k)
	cb(cooldown, isDone[k], isBeingHacked)
end)

ESX.RegisterServerCallback('rpuk_lester:getUploadInfo', function(source, cb)
	cb(isBeingUploaded)
end)

ESX.RegisterServerCallback("rpuk_lester:getLesterStatus", function(source, cb)
	cb(lester.status)
end)

AddEventHandler('rpuk_lester:addInteracting', function(id)
	local _source = source
	if activeInteractions[id] == nil then
		activeInteractions[id] = {}
	end
	table.insert(activeInteractions[id], _source)
end)

AddEventHandler('rpuk_lester:removeInteracting', function(id)
	local _source = source
	if #activeInteractions[id] == 1 then
		activeInteractions[id] = nil
	else
		local temp = {}
		 for k,v in pairs(activeInteractions) do
			if v ~= _source then
				table.insert(temp, v)
			end
		end
		for k,v in pairs(temp) do
			table.insert(activeInteractions[id], v)
		end
	end
end)

AddEventHandler('rpuk_lester:startDownload', function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem("blank_usb")

	if item.count <= 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "You do not have a Blank USB" })
			return
	end

	if ESX.GetInActiveJob("police") < config.minPolice then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "System is currently busy!" })
		return
	end

	if isBeingHacked.name ~= nil then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "Servers just got started hacked by someone else" })
		return
	end

	if item.count >= 1 then
		TriggerClientEvent("rpuk_lester:download", _source)
		xPlayer.removeInventoryItem("blank_usb", 1)
		isBeingHacked.name = id
		isBeingHacked.timer = config.downloadTime
		startHackTimer(id)
		return
	end

end)

AddEventHandler('rpuk_lester:startUpload', function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem("usb")

	if item.count <= 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "You do not have a USB with the correct software" })
		return
	end

	if item.count >= 1 then
		isBeingUploaded = true
		TriggerClientEvent("rpuk_lester:userBusy", -1)
		xPlayer.removeInventoryItem("usb", 1)
		TriggerClientEvent("rpuk_lester:upload", _source)
		return
	end

end)

function startHackTimer(id)
	Citizen.CreateThread(function()
		for k,v in pairs(activeInteractions) do
			for key,val in pairs(v) do
				TriggerClientEvent('rpuk_lester:initDownloadTimer', val, id)
			end
		end
		while isBeingHacked.timer > 0 do
			Wait(1000)
			isBeingHacked.timer = isBeingHacked.timer-1
			if activeInteractions[id] ~= nil then
				for k,v in pairs(activeInteractions[id]) do
					TriggerClientEvent('rpuk_lester:updateDownloadTimer', v, isBeingHacked.timer, id)
				end
			end
		end
		isDone[id] = true
		isBeingHacked.name = nil
		isBeingHacked.timer = 0
		if activeInteractions[id] ~= nil then
			for k,v in pairs(activeInteractions[id]) do
				TriggerClientEvent('rpuk_lester:doneDownloading', v, id)
			end
		end
	end)
end

AddEventHandler('rpuk_lester:getUSB', function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not isDone[id] then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "Download is not done or someone else just took the USB" })
		return
	elseif cooldown > 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "System is rebooting" })
		return
	end

	isDone[id] = false
	cooldown = config.lastDownload
	xPlayer.addInventoryItem("usb", 1)
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'success', text = "Picked up USB" })

	if activeInteractions[id] ~= nil then
		for k,v in pairs(activeInteractions[id]) do
			TriggerClientEvent('rpuk_lester:pickedupUSB', v, id)
		end
	end
	startCooldown(id)
end)

function startCooldown(id)
	Citizen.CreateThread(function()
		while cooldown > 0 do
			Wait(1000)
			cooldown = cooldown-1
			if activeInteractions[id] ~= nil then
				for k,v in pairs(activeInteractions[id]) do
					TriggerClientEvent('rpuk_lester:updateCooldownTimer', v, cooldown)
				end
			end
		end
		cooldown = 0
		if activeInteractions[id] ~= nil then
			for k,v in pairs(activeInteractions[id]) do
				TriggerClientEvent('rpuk_lester:cooldownDone', v, cooldown)
			end
		end
	end)
end

-- AddEventHandler("rpuk_lester:gas", function(toggle)
--	 if toggle then
--		 TriggerClientEvent("rpuk_lester:startgas", -1, true)
--		 TriggerClientEvent("rpuk_lester:effectsClient", -1, true)
--	 else
--		 TriggerClientEvent("rpuk_lester:effectsClient", -1, false)
--		 TriggerClientEvent("rpuk_lester:startgas", -1, false)
--	 end
-- end)

AddEventHandler('rpuk_lester:isDoneUploading', function()
	isBeingUploaded = false
end)


function getRandomCrateLoc()
	local possible = {}
	for i=1, #config.cratePositions do
		if crates[i] == nil then
			table.insert(possible, i)
		end
	end
	if possible[1] == nil then
		return nil
	end
	return possible[math.random(1, #possible)]
end

AddEventHandler('rpuk_lester:buyCrate', function(crateSize)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent("mythic_notify:client:SendAlert", _source, {
		text = "Congratulations Lester! You have successfully downloaded your program once again!.",
		type = 'success',
		length = 10000,
	})
	xPlayer.addInventoryItem("code_cracker", 1)
	TriggerClientEvent('rpuk_lester:closeAllMenues', _source)
end)

AddEventHandler('rpuk_lester:paycopPed', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() < config.intelleak then
		TriggerClientEvent("mythic_notify:client:SendAlert", _source, {
			text = "Looks like you dont have the money on you",
			type = 'error',
		})
		return
	end
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 20000, action = 'longnotif', type = 'success', text = "So ive been informed that Life Invader is now being actively patrolled. Apprently people are attempting to break in to download a new software or something! Apprently this software opens up the access to any computer in the world! Crazy Shit!" })
	xPlayer.removeMoney(config.intelleak, ('%s [%s]'):format('Heist Intel Leak Payment', GetCurrentResourceName()))
end)

Citizen.CreateThread(function()
	while true do
		if lester.timer < 0 then
			if lester.status then
				lester.timer = config.lesteroutofhouse
				-- TriggerClientEvent for when he leaves the house
			else
				lester.timer = config.lesterinthehouse
				-- TriggerClientEvent for when he gets home
			end
			lester.status = not lester.status
			TriggerClientEvent('rpuk_lester:spawnLester', -1, lester.status)
		end
		Citizen.Wait(1000)
		lester.timer = lester.timer - 1
	end
end)