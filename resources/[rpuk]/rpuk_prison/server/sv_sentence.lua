config.ammoTypes = ESX.GetAmmo()

function sentenceTimer()
	SetTimeout(60000, function()
		local prisoners = MySQL.Sync.fetchAll("SELECT * FROM prison_sentences WHERE remaining_time > 0")
		local query = ""
		if not prisoners[1] then
			sentenceTimer()
			return
		end
		if next(prisoners) then
			for _,v in pairs(prisoners) do
				query = query.."UPDATE prison_sentences SET remaining_time = "..(v.remaining_time-1).." WHERE id = "..v.id..";\n"
			end
		end
		MySQL.Async.execute(query)
		sentenceTimer()
	end)
end
sentenceTimer()

ESX.RegisterServerCallback("rpuk_prison:fetchJailStatus", function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll('SELECT status FROM prison_sentences WHERE status = "jail" AND rpuk_charid = @rpuk_charid',{["@rpuk_charid"] = xPlayer.characterId})[1]
	cb(result)
end)

RegisterNetEvent("rpuk_prison:getSignCredits")
AddEventHandler("rpuk_prison:getSignCredits", function(sentenceId)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll('SELECT * FROM prison_sentences WHERE status = "jail" AND id = @id',{
		["@id"] = sentenceId
	})[1]
	if result then
		TriggerClientEvent("rpuk_prison:createSign", _source, xPlayer.firstname.. " "..xPlayer.lastname, tostring(result.time))
	end
end)


RegisterNetEvent("rpuk_prison:jailPlayer")
AddEventHandler("rpuk_prison:jailPlayer", function(target, sentenceTime, reason)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(target)
	local auth = (xPlayer.job.name == "police" or xPlayer.job.name == "gruppe6" or IsPlayerAceAllowed(_source, 'jail'))

	if xPlayer and xTarget then
		local jailStatus = MySQL.Sync.fetchAll('SELECT status FROM prison_sentences WHERE status = "jail" AND rpuk_charid = @rpuk_charid',{["@rpuk_charid"] = xTarget.characterId})[1]
		if auth then
			if not jailStatus then
				local sentenceId = MySQL.Sync.insert('INSERT INTO prison_sentences (`identifier`, `arresting_officer`, `time`, `remaining_time`, `reason`, `rpuk_charid`, `collection`) VALUES (@identifier, @arresting_officer, @time, @remaining_time, @reason, @rpuk_charid, @collection)',{
					['@identifier']		= xTarget.identifier,
					['@arresting_officer']	= xPlayer.firstname .. ' '.. xPlayer.lastname,
					['@time']	= sentenceTime,
					['@remaining_time'] = sentenceTime,
					['@reason']	= reason,
					['@rpuk_charid']	= xTarget.characterId,
					["@collection"] = json.encode({
						items = xTarget.getInventory(true),
						weapons = xTarget.getLoadout(true),
						ammo = xTarget.getAmmo(true)
					})
				})
				for i=1, #xTarget.inventory, 1 do
					if xTarget.inventory[i].count > 0 then
						xTarget.setInventoryItem(xTarget.inventory[i].name, 0)
					end
				end
				for k,v in pairs(xTarget.loadout) do
					xTarget.removeWeapon(v.name)
				end
				for k,v in pairs(xTarget.getAmmo()) do
					if v.count > 0 then
						xTarget.setWeaponAmmo(k, 0)
					end
				end
				TriggerClientEvent("rpuk_prison:sendToPrison", xTarget.playerId, sentenceId)
				xTarget.setState("jailed", 1)
				xTarget.setJob('unemployed',0)
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 4000, type = 'inform', text = 'Target is supposed to be in jail.' })
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 4000, type = 'error', text = 'You can not use this function.' })
		end
	end
end)

RegisterNetEvent("rpuk_prison:unJailPlayer")
AddEventHandler("rpuk_prison:unJailPlayer", function(target, type, seshID)
	local xTarget
	if seshID then
		xTarget = ESX.GetPlayerFromId(target)
	else
		xTarget = ESX.GetPlayerFromCharId(target)
	end

	local inJail = MySQL.Sync.fetchAll('SELECT status FROM prison_sentences WHERE status = "jail" AND rpuk_charid = @rpuk_charid',{["@rpuk_charid"] = xTarget.characterId})[1]

	if inJail then
		if type == "escape" then
			TriggerEvent("rpuk_prison:createWarrant", xTarget)
			MySQL.Sync.execute("UPDATE `prison_sentences` SET `status`= @status, `remaining_time` = @remainingTime WHERE rpuk_charid = @charid AND status = 'Jail'", {
				['@charid'] = xTarget.characterId,
				['@remainingTime'] = 0,
				['@status'] = "escaped",
			})
			TriggerClientEvent("rpuk_prison:alertPolice", xTarget.playerId, xTarget.firstname..' '..xTarget.lastname)
			xTarget.setState("jailed", 0)
		elseif type == "sentenceFinished" then
			MySQL.Async.execute("UPDATE `prison_sentences` SET `status`= @status, `remaining_time` = @remainingTime WHERE rpuk_charid = @charid AND status = 'Jail'", {
				['@charid'] = xTarget.characterId,
				['@remainingTime'] = 0,
				['@status'] = "released",
			})
			xTarget.setState("jailed", 0)
			TriggerClientEvent("rpuk_prison:releasedPrisoner", xTarget.playerId)
		end
	end
end)

RegisterNetEvent("rpuk_prison:createWarrant")
AddEventHandler("rpuk_prison:createWarrant", function(target)
	local data = MySQL.Sync.fetchAll('SELECT * FROM prison_sentences WHERE status = "jail" AND rpuk_charid = @rpuk_charid',{["@rpuk_charid"] = target.characterId})[1]
	local insertIntoReport = MySQL.Sync.insert('INSERT INTO `mdt_reports` (`char_id`, `title`, `incident`, `charges`, `author`, `name`, fine, duration) VALUES (@rpuk_charid, @title, @incident, @charges, @author, @name, @fine, @duration)', {
		['@rpuk_charid']  = target.characterId,
		['@title'] = "Prison Break",
		['@incident'] = "Escaped From Prison, previous sentence time was "..data.time.. " months.",
		['@charges'] = '{"95":1}',
		['@author'] = "Automated Missing Prisoner Prison System",
		['@name'] = target.firstname..' '..target.lastname,
		['@fine'] = 0,
		['@duration'] = 0,
	})
	if insertIntoReport then
		MySQL.Sync.insert('INSERT INTO `mdt_warrants` (`name`, `char_id`, `report_id`, `report_title`, `charges`,`expire`, `notes`, `author`, `fine`, `duration`) VALUES (@name, @char_id, @report_id, @report_title, @charges, NOW() + INTERVAL 14 DAY, @notes, @author, @fine, @duration)', {
			['@name']  = target.firstname.. ' '..target.lastname,
			['@char_id'] = target.characterId,
			['@report_id'] = insertIntoReport,
			['@report_title'] = "Prison Escape",
			['@charges'] = '{"95":1}',
			['@notes'] = "Escaped From Prison, previous sentence time was "..data.time.. " months.",
			['@author'] = "Automated Missing Prisoner Prison System",
			['@fine'] = 0,
			['@duration'] = 0
		})
	end
end)

RegisterNetEvent("rpuk_prison:jobCheckFlyZone")
AddEventHandler("rpuk_prison:jobCheckFlyZone", function(frontSeatPlayerId)
	local xPlayer = ESX.GetPlayerFromId(frontSeatPlayerId)

	if xPlayer then
		if xPlayer.job.name ~= "police" and xPlayer.job.name ~= "ambulance" and xPlayer.job.name ~= "gruppe6" then
			xPlayer.triggerEvent("rpuk_prison:explodeHeli")
		end
	end
end)

RegisterNetEvent("rpuk_prison:checkPhone")
AddEventHandler("rpuk_prison:checkPhone", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local data = MySQL.Sync.fetchAll('SELECT * FROM prison_sentences WHERE status = "jail" AND rpuk_charid = @rpuk_charid',{["@rpuk_charid"] = xPlayer.characterId})[1]

	if data == nil then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source,
		{
			length = 4000,
			type = 'error',
			text = 'You do not have anyone to call.'
		})
		return
	end

	if data.remaining_time > 0 then
		local text
		if xPlayer.sex == "m" then
			text = "Welcome to Her Majesty's Prison Service Helpline. <br> Hello Mr."..xPlayer.lastname.."<br> We do hope you are learning from the mistakes that led you here and are completing prison jobs to try and reduce your sentence. <br> Anyway, I guess you're calling to check how long you have left to serve? <br> Well lucky for you we do have that information, you currently have "..data.remaining_time.. " months remaining. <br> HM Prison Service."
		else
			text = "Welcome to Her Majesty's Prison Service Helpline. <br> Hello Mrs."..xPlayer.lastname.."<br> We do hope you are learning from the mistakes that led you here and are completing prison jobs to try and reduce your sentence. <br> Anyway, I guess you're calling to check how long you have left to serve? <br> Well lucky for you we do have that information, you currently have "..data.remaining_time.. " months remaining. <br> HM Prison Service."
		end
		TriggerClientEvent('mythic_notify:client:SendAlert', _source,
		{
			length = 12000,
			type = 'inform',
			text = text
		})
	elseif data.remaining_time == 0 then
		TriggerEvent("rpuk_prison:unJailPlayer", xPlayer.playerId, "sentenceFinished", true)
	end
end)



