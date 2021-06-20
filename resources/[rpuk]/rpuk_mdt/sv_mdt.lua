local call_index = 0

function getOverdueStatus(Unix)
	local current = os.time()
	local final = Unix/1000+1209600
	local days = math.floor((final - current)/60/60/24)
	return days < 0
end

RegisterNetEvent("rpuk_mdt:hotKeyOpen")
AddEventHandler("rpuk_mdt:hotKeyOpen", function(refresh)
	local usource = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' or (xPlayer.job.name == 'court' and xPlayer.job.grade >= 1) then
		MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_reports` WHERE `deleted` = 0 ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
			for r = 1, #reports do
				reports[r].charges = json.decode(reports[r].charges)
			end
			MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_warrants` WHERE `deleted` = 0 ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
				for w = 1, #warrants do
					warrants[w].charges = json.decode(warrants[w].charges)
				end
				local officer = GetCharacterName(usource)
				if refresh then
					TriggerClientEvent('rpuk_mdt:refreshHome', usource, reports, warrants, officer, xPlayer.job.name, xPlayer.job.grade, xPlayer.job.grade_label)
				else
					TriggerClientEvent('rpuk_mdt:toggleVisibilty', usource, reports, warrants, officer, xPlayer.job.name, xPlayer.job.grade, xPlayer.job.grade_label)
				end
			end)
		end)
	end
end)

RegisterNetEvent("rpuk_mdt:getOffensesAndOfficer")
AddEventHandler("rpuk_mdt:getOffensesAndOfficer", function()
	local playerId = source

	MySQL.Async.fetchAll('SELECT * FROM fine_types', {}, function(fines)
		local officer = GetCharacterName(playerId)
		TriggerClientEvent("rpuk_mdt:returnOffensesAndOfficer", playerId, fines, officer)
	end)
end)

RegisterNetEvent("rpuk_mdt:performOffenderSearch")
AddEventHandler("rpuk_mdt:performOffenderSearch", function(query)
	local usource = source
	local matches = {}
	MySQL.Async.fetchAll("SELECT * FROM `users` WHERE state=0 AND (LOWER(`firstname`) LIKE @query OR LOWER(`lastname`) LIKE @query OR CONCAT(LOWER(`firstname`), ' ', LOWER(`lastname`)) LIKE @query)", {
		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
	}, function(result)

		for index, data in ipairs(result) do
			result[index].id = result[index].rpuk_charid
			table.insert(matches, data)
		end

		TriggerClientEvent("rpuk_mdt:returnOffenderSearchResults", usource, matches)
	end)
end)

RegisterNetEvent("rpuk_mdt:getOffenderDetails")
AddEventHandler("rpuk_mdt:getOffenderDetails", function(offender)
	local usource = source
	GetLicenses(offender.rpuk_charid, function(licenses) offender.licenses = licenses end)
	while offender.licenses == nil do Citizen.Wait(0) end

	local result = MySQL.Sync.fetchAll('SELECT * FROM `user_mdt` WHERE `char_id` = @rpuk_charid', {
		['@rpuk_charid'] = offender.rpuk_charid
	})
	offender.notes = ""
	offender.id = offender.rpuk_charid
	offender.mugshot_url = ""
	offender.bail = false
	if result[1] then
		offender.notes = result[1].notes
		offender.mugshot_url = result[1].mugshot_url
		offender.bail = result[1].bail
	end

	local convictions = MySQL.Sync.fetchAll('SELECT * FROM `user_convictions` WHERE `char_id` = @rpuk_charid', {
		['@rpuk_charid'] = offender.rpuk_charid
	})
	if convictions[1] then
		offender.convictions = {}
		for i = 1, #convictions do
			local conviction = convictions[i]
			offender.convictions[conviction.offense] = conviction.count
		end
	end

	local warrants = MySQL.Sync.fetchAll('SELECT * FROM `mdt_warrants` WHERE `char_id` = @rpuk_charid AND `actioned` = 0 AND `deleted` = 0', {
		['@rpuk_charid'] = offender.rpuk_charid
	})
	if warrants[1] then
		offender.haswarrant = true
	end

	local job = MySQL.Sync.fetchAll('SELECT j.*, u.rpuk_charid FROM jobs j JOIN users u ON j.name = u.job WHERE u.rpuk_charid = @rpuk_charid', {
		['@rpuk_charid'] = offender.rpuk_charid
	})
	offender.occupation = job[1].label

	local phone_number = MySQL.Sync.fetchAll('SELECT `phone_number` FROM `users` WHERE `rpuk_charid` = @rpuk_charid', {
		['@rpuk_charid'] = offender.rpuk_charid
	})
	offender.phone_number = phone_number[1].phone_number

	local unpaidFines = MySQL.Sync.fetchAll('SELECT * FROM fines WHERE rpuk_charid = @rpuk_charid AND status = 1 ORDER BY date_created DESC' , {
		['@rpuk_charid'] = offender.rpuk_charid
	})
	if unpaidFines[1] then
		for i=1, #unpaidFines do
			unpaidFines[i].overdue = getOverdueStatus(unpaidFines[i].date_created)
		end
	end
	offender.unpaidFines = unpaidFines

	local sentences = MySQL.Sync.fetchAll('SELECT id, time, reason, game_time, arresting_officer, rpuk_charid FROM prison_sentences WHERE rpuk_charid = @rpuk_charid GROUP BY id ORDER BY game_time DESC' , {
		['@rpuk_charid'] = offender.rpuk_charid
	})

	offender.sentences = sentences

	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE rpuk_charid = @rpuk_charid', {
		['@rpuk_charid'] = offender.rpuk_charid
	})

	for i = 1, #vehicles do
		vehicles[i].state, vehicles[i].stored, vehicles[i].job, vehicles[i].fourrieremecano, vehicles[i].vehiclename, vehicles[i].ownerName = nil
		vehicles[i].vehicle = json.decode(vehicles[i].vehicle)
		vehicles[i].model = vehicles[i].vehicle.model
		if vehicles[i].vehicle.color1 then
			if colors[tostring(vehicles[i].vehicle.color2)] and colors[tostring(vehicles[i].vehicle.color1)] then
				vehicles[i].color = colors[tostring(vehicles[i].vehicle.color2)] .. " on " .. colors[tostring(vehicles[i].vehicle.color1)]
			elseif colors[tostring(vehicles[i].vehicle.color1)] then
				vehicles[i].color = colors[tostring(vehicles[i].vehicle.color1)]
			elseif colors[tostring(vehicles[i].vehicle.color2)] then
				vehicles[i].color = colors[tostring(vehicles[i].vehicle.color2)]
			else
				vehicles[i].color = "Unknown"
			end
		end
		vehicles[i].vehicle = nil
	end
	offender.vehicles = vehicles

	TriggerClientEvent("rpuk_mdt:returnOffenderDetails", usource, offender)
end)

RegisterNetEvent("rpuk_mdt:getOffenderDetailsById")
AddEventHandler("rpuk_mdt:getOffenderDetailsById", function(char_id)
	local usource = source

	local result = MySQL.Sync.fetchAll('SELECT * FROM `users` WHERE `rpuk_charid` = @rpuk_charid', {
		['@rpuk_charid'] = char_id
	})
	local offender = result[1]

	if not offender then
		TriggerClientEvent("rpuk_mdt:closeModal", usource)
		TriggerClientEvent("rpuk_mdt:sendNotification", usource, "This person no longer exists.")
		return
	end

	GetLicenses(offender.rpuk_charid, function(licenses) offender.licenses = licenses end)
	while offender.licenses == nil do Citizen.Wait(0) end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM `user_mdt` WHERE `char_id` = @rpuk_charid', {
		['@rpuk_charid'] = offender.rpuk_charid
	})
	offender.notes = ""
	offender.id = offender.rpuk_charid
	offender.mugshot_url = ""
	offender.bail = false
	if result2[1] then
		offender.notes = result2[1].notes
		offender.mugshot_url = result2[1].mugshot_url
		offender.bail = result2[1].bail
	end

	local convictions = MySQL.Sync.fetchAll('SELECT * FROM `user_convictions` WHERE `char_id` = @rpuk_charid', {
		['@rpuk_charid'] = offender.rpuk_charid
	})
	if convictions[1] then
		offender.convictions = {}
		for i = 1, #convictions do
			local conviction = convictions[i]
			offender.convictions[conviction.offense] = conviction.count
		end
	end

	local warrants = MySQL.Sync.fetchAll('SELECT * FROM `mdt_warrants` WHERE `char_id` = @rpuk_charid AND `deleted` = 0 AND `actioned` = 0', {
		['@rpuk_charid'] = offender.rpuk_charid
	})
	if warrants[1] then
		offender.haswarrant = true
	end

	local job = MySQL.Sync.fetchAll('SELECT j.*, u.rpuk_charid FROM jobs j JOIN users u ON j.name = u.job WHERE u.rpuk_charid = @rpuk_charid', {
		['@rpuk_charid'] = offender.rpuk_charid
	})
	offender.occupation = job[1].label

	local phone_number = MySQL.Sync.fetchAll('SELECT `phone_number` FROM `users` WHERE `rpuk_charid` = @rpuk_charid', {
		['@rpuk_charid'] = offender.rpuk_charid
	})
	offender.phone_number = phone_number[1].phone_number

	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE rpuk_charid = @rpuk_charid', {
		['@rpuk_charid'] = offender.rpuk_charid
	})

	local unpaidFines = MySQL.Sync.fetchAll('SELECT * FROM fines WHERE rpuk_charid = @rpuk_charid AND status = 1 ORDER BY date_created DESC' , {
		['@rpuk_charid'] = offender.rpuk_charid
	})
	if unpaidFines[1] then
		for i=1, #unpaidFines do
			unpaidFines[i].overdue = getOverdueStatus(unpaidFines[i].date_created)
		end
	end
	offender.unpaidFines = unpaidFines

	local sentences = MySQL.Sync.fetchAll('SELECT id, time, reason, game_time, arresting_officer, rpuk_charid FROM prison_sentences WHERE rpuk_charid = @rpuk_charid GROUP BY id ORDER BY game_time DESC' , {
		['@rpuk_charid'] = offender.rpuk_charid
	})

	offender.sentences = sentences

	for i = 1, #vehicles do
		vehicles[i].state, vehicles[i].stored, vehicles[i].job, vehicles[i].fourrieremecano, vehicles[i].vehiclename, vehicles[i].ownerName = nil
		vehicles[i].vehicle = json.decode(vehicles[i].vehicle)
		vehicles[i].model = vehicles[i].vehicle.model
		if vehicles[i].vehicle.color1 then
			if colors[tostring(vehicles[i].vehicle.color2)] and colors[tostring(vehicles[i].vehicle.color1)] then
				vehicles[i].color = colors[tostring(vehicles[i].vehicle.color2)] .. " on " .. colors[tostring(vehicles[i].vehicle.color1)]
			elseif colors[tostring(vehicles[i].vehicle.color1)] then
				vehicles[i].color = colors[tostring(vehicles[i].vehicle.color1)]
			elseif colors[tostring(vehicles[i].vehicle.color2)] then
				vehicles[i].color = colors[tostring(vehicles[i].vehicle.color2)]
			else
				vehicles[i].color = "Unknown"
			end
		end
		vehicles[i].vehicle = nil
	end
	offender.vehicles = vehicles

	TriggerClientEvent("rpuk_mdt:returnOffenderDetails", usource, offender)
end)

RegisterNetEvent("rpuk_mdt:saveOffenderChanges")
AddEventHandler("rpuk_mdt:saveOffenderChanges", function(rpuk_charid, changes)
	local usource = source
	MySQL.Async.fetchAll('SELECT * FROM `user_mdt` WHERE `char_id` = @rpuk_charid', {
		['@rpuk_charid']  = rpuk_charid
	}, function(result)
		if result[1] then
			MySQL.Async.execute('UPDATE `user_mdt` SET `notes` = @notes, `mugshot_url` = @mugshot_url, `bail` = @bail WHERE `char_id` = @rpuk_charid', {
				['@rpuk_charid'] = rpuk_charid,
				['@notes'] = changes.notes,
				['@mugshot_url'] = changes.mugshot_url,
				['@bail'] = changes.bail
			})
		else
			MySQL.Async.insert('INSERT INTO `user_mdt` (`char_id`, `notes`, `mugshot_url`, `bail`) VALUES (@rpuk_charid, @notes, @mugshot_url, @bail)', {
				['@rpuk_charid'] = rpuk_charid,
				['@notes'] = changes.notes,
				['@mugshot_url'] = changes.mugshot_url,
				['@bail'] = changes.bail
			})
		end
		for i = 1, #changes.licenses_removed do
			local license = changes.licenses_removed[i]
			MySQL.Async.execute('DELETE FROM `user_licenses` WHERE `rpuk_charid` = @rpuk_charid AND (`type` = @type)', {
				['@type'] = license.type,
				['@rpuk_charid'] = rpuk_charid
			})
		end

		if changes.convictions ~= nil then
			for conviction, amount in pairs(changes.convictions) do
				MySQL.Async.execute('UPDATE `user_convictions` SET `count` = @count WHERE `char_id` = @rpuk_charid AND `offense` = @offense', {
					['@rpuk_charid'] = rpuk_charid,
					['@count'] = amount,
					['@offense'] = conviction
				})
			end
		end

		for i = 1, #changes.convictions_removed do
			MySQL.Async.execute('DELETE FROM `user_convictions` WHERE `char_id` = @rpuk_charid AND `offense` = @offense', {
				['@rpuk_charid'] = rpuk_charid,
				['offense'] = changes.convictions_removed[i]
			})
		end

		TriggerClientEvent("rpuk_mdt:sendNotification", usource, "Offender changes have been saved.")
	end)
end)

RegisterNetEvent("rpuk_mdt:saveReportChanges")
AddEventHandler("rpuk_mdt:saveReportChanges", function(data)
	MySQL.Async.execute('UPDATE `mdt_reports` SET `title` = @title, `incident` = @incident, `charges` = @charges WHERE `id` = @id', {
		['@id'] = data.id,
		['@title'] = data.title,
		['@incident'] = data.incident,
		['@charges'] = json.encode(data.charges)
	})
	TriggerClientEvent("rpuk_mdt:sendNotification", source, "Report changes have been saved.")
end)

RegisterNetEvent("rpuk_mdt:deleteReport")
AddEventHandler("rpuk_mdt:deleteReport", function(id)
	MySQL.Async.execute('UPDATE `mdt_reports` SET `deleted` = 1 WHERE `id` = @id', {
		['@id']  = id
	})
	TriggerClientEvent("rpuk_mdt:sendNotification", source, "Report has been successfully deleted.")
end)

RegisterNetEvent("rpuk_mdt:actionReport")
AddEventHandler("rpuk_mdt:actionReport", function(data)
	MySQL.Async.execute('UPDATE `mdt_reports` SET `actioned` = 1 WHERE `id` = @id', {
		['@id']  = data.id
	})

	for offense, count in pairs(data.charges) do
		MySQL.Async.fetchAll('SELECT * FROM `user_convictions` WHERE `offense` = @offense AND `char_id` = @rpuk_charid', {
			['@offense'] = offense,
			['@rpuk_charid'] = data.char_id
		}, function(result)
			if result[1] then
				MySQL.Async.execute('UPDATE `user_convictions` SET `count` = @count WHERE `offense` = @offense AND `char_id` = @rpuk_charid', {
					['@rpuk_charid']  = data.char_id,
					['@offense'] = offense,
					['@count'] = result[1].count + count
				})
			else
				MySQL.Async.insert('INSERT INTO `user_convictions` (`char_id`, `offense`, `count`) VALUES (@rpuk_charid, @offense, @count)', {
					['@rpuk_charid']  = data.char_id,
					['@offense'] = offense,
					['@count'] = count
				})
			end
		end)
	end
	TriggerClientEvent("rpuk_mdt:sendNotification", source, "Report has been marked as actioned.")
end)

RegisterNetEvent("rpuk_mdt:actionWarrant")
AddEventHandler("rpuk_mdt:actionWarrant", function(data)
	MySQL.Async.execute('UPDATE `mdt_warrants` SET `actioned` = 1 WHERE `id` = @id', {
		['@id']  = data.id
	})
	TriggerClientEvent("rpuk_mdt:sendNotification", source, "Warrant has been marked as actioned.")
end)

RegisterNetEvent("rpuk_mdt:submitNewReport")
AddEventHandler("rpuk_mdt:submitNewReport", function(data)
	local usource = source
	local author = GetCharacterName(usource)
	local xPlayer = ESX.GetPlayerFromId(usource)
	local charges = json.encode(data.charges)
	MySQL.Async.insert('INSERT INTO `mdt_reports` (`char_id`, `title`, `incident`, `charges`, `author`, `name`, fine, duration) VALUES (@rpuk_charid, @title, @incident, @charges, @author, @name, @fine, @duration)', {
		['@rpuk_charid']  = data.char_id,
		['@title'] = data.title,
		['@incident'] = data.incident,
		['@charges'] = charges,
		['@author'] = xPlayer.job.grade_label .. " ".. author,
		['@name'] = data.name,
		['@fine'] = data.fine,
		['@duration'] = data.duration,
	}, function(rpuk_charid)

		TriggerEvent("rpuk_mdt:getReportDetailsById", rpuk_charid, usource)
		TriggerClientEvent("rpuk_mdt:sendNotification", usource, "A new report has been submitted.")
	end)
end)

RegisterNetEvent("rpuk_mdt:performReportSearch")
AddEventHandler("rpuk_mdt:performReportSearch", function(query)
	local usource = source
	local matches = {}
	MySQL.Async.fetchAll("SELECT * FROM `mdt_reports` WHERE `deleted` = 0 AND (`id` LIKE @query OR LOWER(`title`) LIKE @query OR LOWER(`name`) LIKE @query OR LOWER(`author`) LIKE @query) ORDER BY date DESC", {
		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
	}, function(result)

		for _, data in ipairs(result) do
			data.charges = json.decode(data.charges)
			table.insert(matches, data)
		end

		TriggerClientEvent("rpuk_mdt:returnReportSearchResults", usource, matches)
	end)
end)

RegisterNetEvent("rpuk_mdt:publicReportSearch")
AddEventHandler("rpuk_mdt:publicReportSearch", function(query)
	local usource = source
	local matches = {}

	MySQL.Async.fetchAll("SELECT * FROM `mdt_reports` WHERE `deleted` = 0 AND `public` = 1 ORDER BY date DESC", {}, function(result)

		for _, data in ipairs(result) do
			data.charges = json.decode(data.charges)
			table.insert(matches, data)
		end
		TriggerClientEvent("rpuk_mdt:returnPublicReportResults", usource, matches)
		TriggerClientEvent("rpuk_mdt:sendNotification", usource, "Public Reports Loaded")
	end)
end)

RegisterNetEvent("rpuk_mdt:performVehicleSearch")
AddEventHandler("rpuk_mdt:performVehicleSearch", function(query)
	local usource = source
	local matches = {}
	MySQL.Async.fetchAll("SELECT ov.*, u.firstname, u.lastname FROM owned_vehicles ov JOIN users u ON ov.rpuk_charid = u.rpuk_charid WHERE LOWER(`plate`) LIKE @query", {
		['@query'] = string.lower('%'..query..'%') -- % wildcard, needed to search for all alike results
	}, function(result)

		for _, data in ipairs(result) do
			local data_decoded = json.decode(data.vehicle)
			data.model = data_decoded.model
			if data_decoded.color1 then
				data.color = colors[tostring(data_decoded.color1)]
				if colors[tostring(data_decoded.color2)] then
					data.color = colors[tostring(data_decoded.color2)] .. " on " .. colors[tostring(data_decoded.color1)]
				end
			end
			table.insert(matches, data)
		end
		TriggerClientEvent("rpuk_mdt:returnVehicleSearchResults", usource, matches)
	end)
end)

RegisterNetEvent("rpuk_mdt:performVehicleSearchInFront")
AddEventHandler("rpuk_mdt:performVehicleSearchInFront", function(query)
	local usource = source
	local xPlayer = ESX.GetPlayerFromId(usource)
	local match = {}
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'nca' then
		MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_reports` WHERE `deleted` = 0 ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(reports)
			for r = 1, #reports do
				reports[r].charges = json.decode(reports[r].charges)
			end
			MySQL.Async.fetchAll("SELECT * FROM (SELECT * FROM `mdt_warrants` WHERE `deleted` = 0 ORDER BY `id` DESC LIMIT 3) sub ORDER BY `id` DESC", {}, function(warrants)
				for w = 1, #warrants do
					warrants[w].charges = json.decode(warrants[w].charges)
				end
				MySQL.Async.fetchAll("SELECT ov.*, u.firstname, u.lastname FROM owned_vehicles ov JOIN users u ON ov.rpuk_charid = u.rpuk_charid WHERE `plate` = @query", {
					['@query'] = query
				}, function(result)
					for _, data in ipairs(result) do
						local data_decoded = json.decode(data.vehicle)
						data.model = data_decoded.model
						if data_decoded.color1 then
							data.color = colors[tostring(data_decoded.color1)]
							if colors[tostring(data_decoded.color2)] then
								data.color = colors[tostring(data_decoded.color2)] .. " on " .. colors[tostring(data_decoded.color1)]
							end
						end
						table.insert(match, data)
					end
					local officer = GetCharacterName(usource)
					TriggerClientEvent('rpuk_mdt:toggleVisibilty', usource, reports, warrants, officer, xPlayer.job.name, xPlayer.job.grade, xPlayer.job.grade_label)
					TriggerClientEvent("rpuk_mdt:returnVehicleSearchInFront", usource, match, query)
				end)
			end)
		end)
	end
end)

RegisterNetEvent("rpuk_mdt:getVehicle")
AddEventHandler("rpuk_mdt:getVehicle", function(vehicle)
	local usource = source

	local result = MySQL.Sync.fetchAll("SELECT * FROM `users` WHERE `rpuk_charid` = @query", {
		['@query'] = vehicle.rpuk_charid
	})[1]

	if result then
		vehicle.owner = (result.firstname .. ' ' .. result.lastname)
		vehicle.owner_id = result.rpuk_charid
	end

	local data = MySQL.Sync.fetchAll('SELECT mdt_notes, mdt_status FROM `owned_vehicles` WHERE `plate` = @plate', {
		['@plate'] = vehicle.plate
	})

	data = data[1]
	if data then
		vehicle.stolen = data.mdt_status
		vehicle.notes = json.decode(data.mdt_notes)
	else
		vehicle.stolen = false
		vehicle.notes = ''
	end

	local warrants = MySQL.Sync.fetchAll('SELECT * FROM `mdt_warrants` WHERE `char_id` = @rpuk_charid AND `actioned` = 0 AND `deleted` = 0', {
		['@rpuk_charid'] = vehicle.rpuk_charid
	})
	if warrants[1] then
		vehicle.haswarrant = true
	end

	local bail = MySQL.Sync.fetchAll('SELECT `bail` FROM user_mdt WHERE `char_id` = @rpuk_charid', {
		['@rpuk_charid'] = vehicle.rpuk_charid
	})
	if bail and bail[1] and bail[1].bail == 1 then vehicle.bail = true else vehicle.bail = false end

	vehicle.type = types[vehicle.type]
	TriggerClientEvent("rpuk_mdt:returnVehicleDetails", usource, vehicle)
end)

RegisterNetEvent("rpuk_mdt:getWarrants")
AddEventHandler("rpuk_mdt:getWarrants", function()
	local usource = source
	MySQL.Async.fetchAll("SELECT * FROM `mdt_warrants` WHERE actioned = 0 AND deleted = 0", {}, function(warrants)
		for i = 1, #warrants do
			warrants[i].expire_time = ""
			warrants[i].charges = json.decode(warrants[i].charges)
		end
		TriggerClientEvent("rpuk_mdt:returnWarrants", usource, warrants)
	end)
end)

RegisterNetEvent("rpuk_mdt:getPolicePatrolHours")
AddEventHandler("rpuk_mdt:getPolicePatrolHours", function()
	local usource = source
	local xPlayer = ESX.GetPlayerFromId(usource)
	if xPlayer.job.name == 'police' and xPlayer.job.grade >= 5 then
		MySQL.Async.fetchAll([[
			SELECT
					u.rpuk_charid,
					u.firstname,
					u.lastname,
					u.policelevel,
					ROUND(COUNT(l.id)*7/60,0) AS patrol_hours
				FROM users u
				LEFT JOIN rpuk_logs l
				ON u.rpuk_charid = l.character_id
					AND l.time >= UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 30 DAY))
					AND log_description IN ('Pay Check [es_extended]','Pay Check (police) [es_extended]','Pay Check (police) [rpuk]')
				WHERE u.policelevel >=0
				GROUP BY u.rpuk_charid
				ORDER BY u.policelevel DESC, patrol_hours DESC;
			]], {}, function(hours)
			TriggerClientEvent("rpuk_mdt:returnPoliceOfficers", usource, hours)
		end)
	else
		TriggerClientEvent("rpuk_mdt:returnPoliceOfficers", usource, {})
	end
end)

RegisterNetEvent("rpuk_mdt:submitNewWarrant")
AddEventHandler("rpuk_mdt:submitNewWarrant", function(data)
	local usource = source
	local xPlayer = ESX.GetPlayerFromId(usource)
	data.charges = json.encode(data.charges)
	data.author = GetCharacterName(usource)
	MySQL.Async.insert('INSERT INTO `mdt_warrants` (`name`, `char_id`, `report_id`, `report_title`, `charges`,`expire`, `notes`, `author`, `fine`, `duration`) VALUES (@name, @char_id, @report_id, @report_title, @charges, @expire, @notes, @author, @fine, @duration)', {
		['@name']  = data.name,
		['@char_id'] = data.char_id,
		['@report_id'] = data.report_id,
		['@report_title'] = data.report_title,
		['@charges'] = data.charges,
		['@expire'] = data.expire,
		['@notes'] = data.notes,
		['@author'] = xPlayer.job.grade_label .. " " ..data.author,
		['@fine'] = data.fine,
		['@duration'] = data.duration

	}, function()
		TriggerClientEvent("rpuk_mdt:completedWarrantAction", usource)
		TriggerClientEvent("rpuk_mdt:sendNotification", usource, "A new warrant has been created.")
	end)
end)

RegisterNetEvent("rpuk_mdt:deleteWarrant")
AddEventHandler("rpuk_mdt:deleteWarrant", function(id)
	local usource = source
	local xPlayer = ESX.GetPlayerFromId(usource)

	if (xPlayer.job.name == "police") or (xPlayer.job.name == "nca") then
		MySQL.Async.execute('UPDATE `mdt_warrants` SET `deleted` = 1 WHERE `id` = @id', {
			['@id']  = id
		}, function()
			TriggerClientEvent("rpuk_mdt:completedWarrantAction", usource)
		end)
		TriggerClientEvent("rpuk_mdt:sendNotification", usource, "Warrant has been deleted.")
	else
		TriggerClientEvent("rpuk_mdt:sendNotification", usource, "You can not use this function.")
	end
end)

RegisterNetEvent("rpuk_mdt:getReportDetailsById")
AddEventHandler("rpuk_mdt:getReportDetailsById", function(query, _source)
	if _source then source = _source end
	local usource = source
	MySQL.Async.fetchAll("SELECT * FROM `mdt_reports` WHERE `id` = @query AND `deleted` = 0", {
		['@query'] = query
	}, function(result)
		if result and result[1] then
			result[1].charges = json.decode(result[1].charges)
			TriggerClientEvent("rpuk_mdt:returnReportDetails", usource, result[1])
		else
			TriggerClientEvent("rpuk_mdt:closeModal", usource)
			TriggerClientEvent("rpuk_mdt:sendNotification", usource, "This report cannot be found.")
		end
	end)
end)

RegisterNetEvent("rpuk_mdt:newCall")
AddEventHandler("rpuk_mdt:newCall", function(details, caller, coords)
	call_index = call_index + 1
	local xPlayers = ESX.GetPlayers()
	for i= 1, #xPlayers do
		local source = xPlayers[i]
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.job.name == 'police' then
			TriggerClientEvent("rpuk_mdt:newCall", source, details, caller, coords, call_index)
			TriggerClientEvent("InteractSound_CL:PlayOnOne", source, 'demo', 1.0)
			TriggerClientEvent("mythic_notify:client:SendAlert", source, {type="infom", text="You have received a new call.", length=5000, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' }})
		end
	end
end)

RegisterNetEvent("rpuk_mdt:attachToCall")
AddEventHandler("rpuk_mdt:attachToCall", function(index)
	local usource = source
	local charname = GetCharacterName(usource)
	local xPlayers = ESX.GetPlayers()
	for i= 1, #xPlayers do
		local source = xPlayers[i]
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.job.name == 'police' then
			TriggerClientEvent("rpuk_mdt:newCallAttach", source, index, charname)
		end
	end
	TriggerClientEvent("rpuk_mdt:sendNotification", usource, "You have attached to this call.")
end)

RegisterNetEvent("rpuk_mdt:detachFromCall")
AddEventHandler("rpuk_mdt:detachFromCall", function(index)
	local usource = source
	local charname = GetCharacterName(usource)
	local xPlayers = ESX.GetPlayers()
	for i= 1, #xPlayers do
		local source = xPlayers[i]
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.job.name == 'police' then
			TriggerClientEvent("rpuk_mdt:newCallDetach", source, index, charname)
		end
	end
	TriggerClientEvent("rpuk_mdt:sendNotification", usource, "You have detached from this call.")
end)

RegisterNetEvent("rpuk_mdt:editCall")
AddEventHandler("rpuk_mdt:editCall", function(index, details)
	local usource = source
	local xPlayers = ESX.GetPlayers()
	for i= 1, #xPlayers do
		local source = xPlayers[i]
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.job.name == 'police' then
			TriggerClientEvent("rpuk_mdt:editCall", source, index, details)
		end
	end
	TriggerClientEvent("rpuk_mdt:sendNotification", usource, "You have edited this call.")
end)

RegisterNetEvent("rpuk_mdt:deleteCall")
AddEventHandler("rpuk_mdt:deleteCall", function(index)
	local usource = source
	local xPlayers = ESX.GetPlayers()
	for i= 1, #xPlayers do
		local source = xPlayers[i]
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.job.name == 'police' then
			TriggerClientEvent("rpuk_mdt:deleteCall", source, index)
		end
	end
	TriggerClientEvent("rpuk_mdt:sendNotification", usource, "You have deleted this call.")
end)

RegisterNetEvent("rpuk_mdt:saveVehicleChanges")
AddEventHandler("rpuk_mdt:saveVehicleChanges", function(data)
	if data.stolen then data.stolen = 1 else data.stolen = 0 end
	local usource = source

	MySQL.Async.execute('UPDATE `owned_vehicles` SET mdt_status = @stolen, mdt_notes = @notes WHERE `plate` = @plate', {
		['@plate'] = data.plate,
		['@stolen'] = data.stolen,
		['@notes'] = json.encode(data.notes)
	})
	TriggerClientEvent("rpuk_mdt:sendNotification", usource, "Vehicle changes have been saved.")
end)

RegisterNetEvent("rpuk_mdt:setReportPublicStatus")
AddEventHandler("rpuk_mdt:setReportPublicStatus", function(data)
	local usource = source
	local message = data.status and 'Public' or 'Private'

	MySQL.Async.execute('UPDATE `mdt_reports` SET public = @status WHERE `id` = @id', {
		['@id'] = data.id,
		['@status'] = data.status
	})
	TriggerClientEvent("rpuk_mdt:sendNotification", usource, "Report is now " .. message )
end)

RegisterNetEvent("rpuk_mdt:saveOffenderMarkers")
AddEventHandler("rpuk_mdt:saveOffenderMarkers", function(data)
	local usource = source

	MySQL.Async.execute('UPDATE `users` SET mdt_markers = @markers WHERE `rpuk_charid` = @charid', {
		['@markers'] = json.encode(data.mdt_markers),
		['@charid'] = data.rpuk_charid,
	})
	TriggerClientEvent("rpuk_mdt:sendNotification", usource, "Marker changes have been saved.")
end)

function GetLicenses(rpuk_charid, cb)
	MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE rpuk_charid = @owner', {
		['@owner'] = rpuk_charid
	}, function(result)
		local licenses   = {}
		local asyncTasks = {}

		for i=1, #result, 1 do

			local scope = function(type)
				table.insert(asyncTasks, function(cb)
					MySQL.Async.fetchAll('SELECT * FROM licenses WHERE type = @type', {
						['@type'] = type
					}, function(result2)
						if result2[1] then
							table.insert(licenses, {
								type  = type,
								label = result2[1].label
							})
						end

						cb()
					end)
				end)
			end

			scope(result[i].type)

		end

		Async.parallel(asyncTasks, function(results)
			if #licenses == 0 then licenses = false end
			cb(licenses)
		end)

	end)
end

function print(val)
	TriggerEvent("rpuk:debug", val)
end

function GetCharacterName(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	return xPlayer.getFullName()
end

function tprint (tbl, indent)
	if not indent then indent = 0 end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  "= "
		end
		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end