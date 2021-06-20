local isMenuOpen = false

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() and isMenuOpen then
		SetNuiFocus(false)
	end
end)

RegisterNetEvent('rpuk_factions:openManagementComputer')
AddEventHandler('rpuk_factions:openManagementComputer', function()
	Citizen.Wait(500)
	if Config.Management[ESX.Player.GetJobName()] then
		if ESX.Player.GetJobGrade() >= Config.Management[ESX.Player.GetJobName()] then
			local isJob = Config.LookupOverride[ESX.Player.GetJobName()]
			SendNUIMessage({name = 'openFactionManagment', isJob = isJob})
			SetNuiFocus(true, true)
			isMenuOpen = true
		else
			TriggerEvent('mythic_notify:client:SendAlert', {length = 6000, type = 'error', text = 'You can not use this.' })
		end
	end
end)

RegisterNetEvent('rpuk_factions:openManagementMenu')
AddEventHandler('rpuk_factions:openManagementMenu', function(job)
	ESX.UI.Menu.CloseAll()
	local elements = {}
	if Config.checkLog[job].Armory then
		table.insert(elements, {
			label = "Armory Log",
			value = "loadout"
		})
	end
	if Config.checkLog[job].Evidence then
		table.insert(elements, {
			label = "Evidence Log",
			value = "storage"
		})
	end
	if Config.checkLog[job].Fund then
		table.insert(elements, {
			label = "Fund Log",
			value = "fund"
		})
	end
		table.insert(elements, {
			label = "Employment Computer",
			value = "employment"
		})
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), "personalMenu",
	{
		css = "interaction",
		align = "top-left",
		elements = elements
	}, function(data, menu)
		if data.current.value == "employment" then
			TriggerEvent("rpuk_factions:openManagementComputer")
			menu.close()
		else
			ESX.TriggerServerCallback('rpuk_factions:openLogCallback', function(result)
				logMenu(job, result)
			end, data.current.value, job)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end)

function logMenu(job, data)
	local elements = {}
	for _, v in pairs(data) do
		if string.sub(v.quantity, 1, 1) == "+" then
			table.insert(elements, {label = "Name: ".. v.name .. " | <span style='color:green;'> Quantity: " .. v.quantity .. " </span> | Item Name: " .. v.item .. " ", value = "check", data = v})
		else
			table.insert(elements, {label = "Name: ".. v.name .. " | <span style='color:red;'> Quantity: " .. v.quantity .. " </span> | Item Name: " .. v.item .. " ", value = "check", data = v})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'check_logs', {
		title    = '',
		css =  job,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == "check" then
			depth_log(job, data.current.data)
		end
	end, function(data, menu)
	menu.close()
	end)
end

function depth_log(job, v)
	local elements = {}

	table.insert(elements, {label = "Item: " .. v.item, value = "check"})
	table.insert(elements, {label = "Quantity: " .. v.quantity, value = "check"})
	table.insert(elements, {label = "Signed: " .. v.name, value = "check"})
	table.insert(elements, {label = "Time : " .. v.formattedTime, value = "check"})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'check_logs_indepth', {
		title    = '',
		css =  job,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		end, function(data, menu)
		menu.close()
	end)
end

RegisterNUICallback('onMenuClose', function(data, cb)
	SetNuiFocus(false)
	isMenuOpen = false
end)

RegisterNUICallback('getEmployeeList', function(data, cb)
	ESX.TriggerServerCallback('rpuk_factions:getEmployeeList', function(result)
		cb(result)
	end)
end)

RegisterNUICallback('getPlayerList', function(data, cb)
	ESX.TriggerServerCallback('rpuk_factions:getServerxPlayers', function(players)
		cb(players)
	end, ESX.Player.GetJobName())
end)

RegisterNUICallback('updateFlagsForPlayer', function(data, cb)
	local newFlags = data.newFlags
	local newPlayerRank = data.newFlags.rank
	newFlags.rank = nil

	ESX.TriggerServerCallback('rpuk_factions:updateFlagsForPlayer', function(success)
		cb(success)
	end, data.characterId, newFlags, newPlayerRank)
end)

RegisterNUICallback('updateMutexJobForPlayer', function(data, cb)
	ESX.TriggerServerCallback('rpuk_factions:updateMutexJobForPlayer', function(success)
		cb(success)
	end, data.characterId, data.level)
end)

RegisterNUICallback('removePlayerAccessFromFaction', function(data, cb)
	ESX.TriggerServerCallback('rpuk_factions:removePlayerAccessFromFaction', function(success)
		cb(success)
	end, data.characterId)
end)

RegisterNUICallback('employPlayerByCharacterId', function(data, cb)
	ESX.TriggerServerCallback('rpuk_factions:employPlayerByCharacterId', function(success)
		cb(success)
	end, data.characterId)
end)

RegisterNUICallback('getEmployeeDetails', function(data, cb)
	if Config.LookupOverride[ESX.Player.GetJobName()] then
		ESX.TriggerServerCallback('rpuk_factions:getJobData', function(jobData)
			local newJobData = {}

			for k,v in pairs(json.decode(jobData)) do
				table.insert(newJobData, {
					label = Config.LookupOverride[ESX.Player.GetJobName()].flags[k],
					name = k,
					value = v
				})
			end

			cb(newJobData)
		end, data.characterId)
	else
		cb({})
	end
end)