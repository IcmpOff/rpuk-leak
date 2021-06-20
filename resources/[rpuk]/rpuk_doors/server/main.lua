local doors = {}
local activeInteractions = {}
local actions = {
	beingZiptied = {},
	beingUnZiptied = {},
	lockpicking = {},
	breaching = {},
	repairing = {},
}

RegisterNetEvent('rpuk_doors:toggleDoor')
--RegisterNetEvent('rpuk_doors:addInteracting')
--RegisterNetEvent('rpuk_doors:removeInteracting')
RegisterNetEvent('rpuk_doors:hack')
RegisterNetEvent('rpuk_doors:pick')
RegisterNetEvent('rpuk_doors:doorSetLocked')
RegisterNetEvent('rpuk_doors:doorSetUnLocked')
RegisterNetEvent("rpuk_doors:ziptie")
RegisterNetEvent("rpuk_doors:doorSetZiptied")
RegisterNetEvent("rpuk_doors:unZiptie")
RegisterNetEvent("rpuk_doors:doorSetUnZiptied")
RegisterNetEvent("rpuk_doors:doneWithAction")
RegisterNetEvent("rpuk_doors:breach")
RegisterNetEvent("rpuk_doors:explosion")
RegisterNetEvent("rpuk_doors:repairDoor")

RegisterNetEvent("esx:playerLoaded")
RegisterNetEvent("esx:setJob")
RegisterNetEvent("playerDropped")

for k,v in pairs(Config.DoorList) do
	doors[v.id] = makeDoor(v, k)
end

ESX.RegisterServerCallback("rpuk_doors:getAllDoors", function(source, cb)
	cb(doors)
end)

ESX.RegisterServerCallback("rpuk_doors:getDoorInfo", function(source, cb, doorId)
	cb(doors[doorId])
end)

AddEventHandler('rpuk_doors:toggleDoor', function(id)
	doors[id].toggleLock()
end)

AddEventHandler('rpuk_doors:doorSetLocked', function(id)
	doors[id].SetLock()
end)

AddEventHandler('rpuk_doors:doorSetUnLocked', function(id)
	doors[id].SetUnLocked()
end)

AddEventHandler("rpuk_doors:doorSetZiptied", function(id)
	doors[id].taskZiptie()
end)

AddEventHandler("rpuk_doors:doorSetUnZiptied", function(id)
	doors[id].unZiptie()
end)

AddEventHandler("rpuk_doors:doneWithAction", function(action, id)
	actions[action][id] = nil
end)

--[[AddEventHandler('rpuk_doors:addInteracting', function(id)
	local _source = source
	if activeInteractions[id] == nil then
		activeInteractions[id] = {}
	end
	activeInteractions[id][_source] = true
end)

AddEventHandler('rpuk_doors:removeInteracting', function(id)
	local _source = source

	if id and activeInteractions[id] then
		activeInteractions[id][_source] = nil
		activeInteractions[id] = nil
	end
end)]]--

AddEventHandler("rpuk_doors:repairDoor", function(id)
	local _source = source

	if actions.repairing[id] ~= nil then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "Someone is already repairing the door" })
		return
	end
	actions.repairing[id] = nil
	TriggerClientEvent("rpuk_doors:repairDoor", _source, id)
end)


AddEventHandler('rpuk_doors:hack', function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem("code_cracker")

	if item.count <= 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "You do not have the LC69 Software" })
		return
	end

	if item.count >= 1 then
		TriggerClientEvent('rpuk_doors:currentlyhacking', _source)
		return
	end
end)

AddEventHandler('rpuk_doors:pick', function(id, type)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem(type)

	if item.count <= 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "You do not have a " .. item.label })
		return
	elseif actions.lockpicking[id] ~= nil then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "Someone is already picklocking the door" })
		return
	end

	if item.count >= 1 then
		xPlayer.removeInventoryItem(type, 1)
		TriggerClientEvent('rpuk_doors:' .. type, _source, id)
		actions.lockpicking[id] = true
		return
	end
end)

AddEventHandler("rpuk_doors:ziptie", function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem("ziptie")

	if item.count <= 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "You do not have a ziptie" })
		return
	elseif actions.beingZiptied[id] ~= nil then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "Someone is already ziptying" })
		return
	end

	if item.count >= 1 then
		xPlayer.removeInventoryItem("ziptie", 1)
		TriggerClientEvent('rpuk_doors:ziptie', _source, id)
		actions.beingZiptied[id] = true
		return
	end

	TriggerClientEvent('rpuk_doors:ziptie', _source, id)
	actions.beingZiptied[id] = true
end)

AddEventHandler("rpuk_doors:unZiptie", function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local hasWeapon = xPlayer.hasWeapon("WEAPON_KNIFE") or xPlayer.hasWeapon("WEAPON_DAGGER") or xPlayer.hasWeapon("WEAPON_HATCHET") or xPlayer.hasWeapon("WEAPON_MACHETE") or xPlayer.hasWeapon("WEAPON_SWITCHBLADE")

	if actions.beingUnZiptied[id] ~= nil then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "Someone is already breaking ziptie" })
		return
	end

	if hasWeapon then
		TriggerClientEvent('rpuk_doors:unZiptie', _source, id)
		actions.beingUnZiptied[id] = true
		return
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "You do not have a knife to cut this ziptie" })
		return
	end
end)

AddEventHandler("rpuk_doors:breach", function(id)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem("breaching_charge")

	if item.count <= 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "You do not have a breaching charge" })
		return
	elseif actions.breaching[id] ~= nil then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { action = 'longnotif', type = 'error', text = "Someone is already placing a breaching charge" })
		return
	end

	if item.count >= 1 then
		xPlayer.removeInventoryItem("breaching_charge", 1)
		TriggerClientEvent('rpuk_doors:breachDoor', _source, id)
		actions.breaching[id] = true
		return
	end
	TriggerClientEvent('rpuk_doors:breachDoor', _source, id)
	actions.breaching[id] = true
end)

AddEventHandler("rpuk_doors:explosion", function(id)
	TriggerClientEvent("rpuk_doors:explosion", source, doors[id].textCoords)
	TriggerClientEvent("rpuk_doors:explosionSound", -1, doors[id].textCoords)
end)

AddEventHandler('esx:playerLoaded', function(_, xPlayer)
	if xPlayer.job.name == "police" then
		for k,v in pairs(doors) do
			v.updateJob()
		end
	end
end)

AddEventHandler('esx:setJob', function(_source, job, lastJob)
	if (job.name == "police" and lastJob.name ~= "police") or lastJob.name == "police" then
		for k,v in pairs(doors) do
			v.updateJob()
		end
	end
end)

AddEventHandler('playerDropped', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil then
		if xPlayer.job.name == "police" then
			Citizen.Wait(2500)
			for k,v in pairs(doors) do
				v.updateJob()
			end
		end
	end
end)
