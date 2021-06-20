local isSedated = {}
local deadPlayers = {}
local deathCause = {}

ESX.RegisterServerCallback('rpuk_health:getPlayerState', function(source, cb, target)
	cb({isSedated[target]})
end)

ESX.RegisterServerCallback("rpuk_health:getDeadPlayers", function(source, cb)
	cb(deadPlayers)
end)

ESX.RegisterServerCallback("rpuk_health:getInjury", function(source, cb, targetPlayerId)
	cb(deathCause[targetPlayerId])
end)

RegisterNetEvent('rpuk_health:alertMedicOfPostion')
AddEventHandler('rpuk_health:alertMedicOfPostion', function(playerID)
	local _source = source
	TriggerClientEvent("rpuk_health:registerBlip", -1, _source, deadPlayers[playerID])
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		deadPlayers[xPlayer.source] = data.victimCoords
		deathCause[xPlayer.source] = data.rawDeathCause
		if waitingList[xPlayer.source] then waitingList[xPlayer.source] = nil end
		xPlayer.setState("dead", 1)
		print(('[rpuk_health] player "%s" has died, victim coords: "%s", death cause: "%s", killed by player: %s')
		:format(xPlayer.source, data.victimCoords, data.deathCause, data.killedByPlayer and data.killerServerId or 'no'))
	end
end)

RegisterNetEvent('rpuk_health:reviveTarget')
AddEventHandler('rpuk_health:reviveTarget', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	local pillbox = #(vector3(316.386, -582.153, 42.284) - xPlayer.getCoords(true))
	local prison = #(vector3(1779.4916992188, 2559.884765625, 44.797897338867) - xPlayer.getCoords(true))
	local paleto = #(vector3(-240.6, 6324.9, 31.4) - xPlayer.getCoords(true))
	local sandy = #(vector3(1833.6, 3674.2, 33.2) - xPlayer.getCoords(true))

	local blackmarket = #(vector3(-177.693, 409.4913, 110.774) - xPlayer.getCoords(true))
	if xPlayer and xTarget then
		if type == "civ" then
			if xPlayer.job.name == "ambulance" or xPlayer.job.name == "police" then
				xTarget.setState("dead", 0)
				if xPlayer.job.name == "ambulance" then
					xPlayer.addAccountMoney('bank', 500, ('%s [%s]'):format('Medic Job Payout - Revive', GetCurrentResourceName()))
					TriggerClientEvent("mythic_notify:client:SendAlert", source, {
						text = "£500 Transfered to your bank account.",
						type = 'inform',
					})
				end
				print("PLAYER REVIVED: " .. xTarget.firstname .. " " .. xTarget.lastname .. "[" .. xPlayer.identifier .."] BY: " .. xPlayer.firstname .. " " .. xPlayer.lastname .. "[" .. xPlayer.identifier .. "][MEDIC]")
				TriggerClientEvent('rpuk_health:revive', xTarget.source, "civ")
				TriggerClientEvent("rpuk_health:registerPlayerRevived", -1, target)
				deadPlayers[target] = nil
				deathCause[target] = nil
			elseif blackmarket < 20.0 then
				xTarget.setState("dead", 0)
				print("PLAYER REVIVED: " .. xTarget.firstname .. " " .. xTarget.lastname .. "[" .. xPlayer.identifier .."] BY: " .. xPlayer.firstname .. " " .. xPlayer.lastname .. "[" .. xPlayer.identifier .. "][HOSPITAL]")
				TriggerClientEvent('rpuk_health:revive', xTarget.source, "civ")
				TriggerClientEvent("rpuk_health:registerPlayerRevived", -1, target)
				deadPlayers[target] = nil
				deathCause[target] = nil
			else
				print("PLAYER ATTEMPTED TO REVIVE: " .. xTarget.firstname .. " " .. xTarget.lastname .. "[" .. xPlayer.identifier .."] CALLER: " .. xPlayer.firstname .. " " .. xPlayer.lastname .. "[" .. xPlayer.identifier .. "]")
			end

		elseif type == "beds" then

			if pillbox < 60.0 or prison < 50.0 or paleto < 80.0 or sandy < 80.0 then
				xTarget.setState("dead", 0)
				local accountType = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
					["@job"] = "ambulance"
				})[1]
				if accountType then
					MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
						["@fund"] = 250+accountType.fund,
						["@job"] = "ambulance"
					})
				end
				print("PLAYER REVIVED: " .. xTarget.firstname .. " " .. xTarget.lastname .. "[" .. xPlayer.identifier .."] BY: " .. xPlayer.firstname .. " " .. xPlayer.lastname .. "[" .. xPlayer.identifier .. "][MEDIC]")
				TriggerClientEvent("rpuk_health:registerPlayerRevived", -1, target)
				deadPlayers[target] = nil
				deathCause[target] = nil
			else
				print("PLAYER ATTEMPTED TO REVIVE: " .. xTarget.firstname .. " " .. xTarget.lastname .. "[" .. xPlayer.identifier .."] CALLER: " .. xPlayer.firstname .. " " .. xPlayer.lastname .. "[" .. xPlayer.identifier .. "]")
			end

		elseif type == "admin" then

			if xPlayer.isAceAllowed('staff.revive') then
				xTarget.setState("dead", 0)
				print("PLAYER REVIVED: " .. xTarget.firstname .. " " .. xTarget.lastname .. "[" .. xPlayer.identifier .."] BY: " .. xPlayer.firstname .. " " .. xPlayer.lastname .. "[" .. xPlayer.identifier .. "][ADMIN]")
				TriggerClientEvent('rpuk_health:revive', xTarget.source, "admin")
				TriggerClientEvent("rpuk_health:registerPlayerRevived", -1, target)
				deadPlayers[target] = nil
				deathCause[target] = nil
			else
				print(('[rpuk_health] %s was denied "staff.revive"'):format(xPlayer.playerId))
			end

		end
	end
end)

-- Server-sided only event for reviving players
AddEventHandler('rpuk_health:serverRevive', function(playerId, reviveSource, all)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		xPlayer.setState('dead', 0)
		xPlayer.triggerEvent('rpuk_health:revive', 'admin')
		TriggerClientEvent('rpuk_health:registerPlayerRevived', -1, playerId)
		deadPlayers[playerId] = nil
		deathCause[playerId] = nil

		print(('[rpuk_health] serverRevive has been triggered on player id %s. reviveSource: "%s"'):format(playerId, reviveSource))
	end
end)

-- Server-sided only event for reviving all players
AddEventHandler('rpuk_health:serverReviveAll', function(reviveSource)
	for playerId,deathCoords in pairs(deadPlayers) do
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			xPlayer.setState('dead', 0)
			xPlayer.triggerEvent('rpuk_health:revive', 'admin')
			TriggerClientEvent('rpuk_health:registerPlayerRevived', -1, playerId)
			deadPlayers[playerId] = nil
			deathCause[playerId] = nil
		end
	end

	print(('[rpuk_health] serverReviveAll has been triggered. reviveSource: "%s"'):format(reviveSource))
end)


RegisterNetEvent('rpuk_health:respawn')
AddEventHandler('rpuk_health:respawn', function(target)
	local _source = source
	if target ~= nil then
		_source = target
	end
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() > 0 then
		xPlayer.removeMoney(xPlayer.getMoney(), ('%s [%s]'):format('Character Respawn', GetCurrentResourceName()))
	end
	if xPlayer.getAccount('black_money').money > 0 then
		xPlayer.setAccountMoney('black_money', 0, ('%s [%s]'):format('Character Respawn', GetCurrentResourceName()))
	end
	for i=1, #xPlayer.inventory, 1 do
		if xPlayer.inventory[i].count > 0 then
			xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
		end
	end
	for k,v in pairs(xPlayer.loadout) do
		xPlayer.removeWeapon(v.name)
	end
	for k,v in pairs(xPlayer.getAmmo()) do
		if v.count > 0 then
			xPlayer.setWeaponAmmo(k, 0)
		end
	end
	xPlayer.setState("dead", 0)
	TriggerClientEvent("rpuk_health:registerPlayerRevived", -1, _source)
	deadPlayers[_source] = nil
	deathCause[_source] = nil
	if xPlayer.jailed then
		TriggerClientEvent('rpuk_health:revive', _source, "prison")
	elseif xPlayer.job.name == 'police' then
		TriggerClientEvent('rpuk_health:revive', _source, 'police')
	elseif xPlayer.job.name == 'gruppe6' then
		TriggerClientEvent('rpuk_health:revive', _source, 'gruppe6')
	else
		TriggerClientEvent('rpuk_health:revive', _source, "hospital")
	end
end)

AddEventHandler('playerDropped', function()
	local _source = source

	if deadPlayers[_source] ~= nil then
		TriggerClientEvent("rpuk_health:registerPlayerRevived", -1, _source)
		deadPlayers[_source] = nil
		deathCause[_source] = nil
		waitingList[_source] = nil
	end
	for key, val in pairs(activeBeds) do
		for k, v in pairs(val) do
			if v.playerID == _source then
				activeBeds[key] = nil
			end
		end
	end
end)

RegisterNetEvent('rpuk_health:treatTarget')
AddEventHandler('rpuk_health:treatTarget', function(target, type)
	TriggerClientEvent('rpuk_factions:treatmentType', target, type)
end)

RegisterNetEvent('rpuk_health:changeStatus')
AddEventHandler('rpuk_health:changeStatus', function(state, target)
  local _source = source
  if target == nil then
	if state then
	  isSedated[_source] = true
	else
	  isSedated[_source] = nil
	end
  else
	if state then
	  isSedated[target] = true
	else
	  isSedated[target] = nil
	end
  end
end)

RegisterNetEvent('rpuk_health:payDocPed')
AddEventHandler('rpuk_health:payDocPed', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() < config.price then
	  TriggerClientEvent("mythic_notify:client:SendAlert", _source, {
		text = "Looks like you dont have the money on you",
		type = 'error',
	  })
	  return
	end
	xPlayer.removeMoney(config.price, ('%s [%s]'):format('Revive Fee - BM Doctor', GetCurrentResourceName()))
	xPlayer.addInventoryItem("defib", 1)
end)
