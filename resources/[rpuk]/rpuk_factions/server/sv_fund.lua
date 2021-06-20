RegisterNetEvent("rpuk_factions:addToFundAccess")
AddEventHandler("rpuk_factions:addToFundAccess", function(id, job)
	local _source = source
	local data = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
		["@job"] = job
	})[1]

	data.access = json.decode(data.access)
	local result = MySQL.Sync.fetchAll("SELECT * FROM users where rpuk_charid = @charId", {
		["@charId"] = id
	})[1]
	if data.access[id] == nil then
		data.access[id] = result.firstname .. " " .. result.lastname
	end

	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2000, action = 'longnotif', type = 'inform', text = "Given access to " .. result.firstname .. " " .. result.lastname })

	MySQL.Sync.execute("UPDATE faction_funds SET access = @access WHERE faction = @job", {
		["@access"] = json.encode(data.access),
		["@job"] = job
	})
end)

RegisterNetEvent("rpuk_factions:removeFundAccess")
AddEventHandler("rpuk_factions:removeFundAccess", function(id, job, displayName)
	local _source = source

	local data = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
		["@job"] = job
	})[1]
	data.access = json.decode(data.access)
	data.access[tostring(id)] = nil
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2000, action = 'longnotif', type = 'inform', text = "Removed access for " .. displayName })
	MySQL.Sync.execute("UPDATE faction_funds SET access = @access WHERE faction = @job", {
		["@access"] = json.encode(data.access),
		["@job"] = job
	})
end)

ESX.RegisterServerCallback("rpuk_factions:getFund", function(source, cb, job)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
		["@job"] = job
	}, function(result)
		result = result[1]
		result.access = json.decode(result.access)
		result.display = xPlayer.job.label .. " Fund"
		cb(result, result.access[tostring(xPlayer.rpuk_charid)] ~= nil)
	end)
end)

ESX.RegisterServerCallback("rpuk_factions:searchForPlayer", function(source, cb, type, input, job)
	local query = ""

	if type == "rpuk_charid" then
		input = tonumber(input)
		query = "SELECT * FROM users WHERE rpuk_charid = @input"
	elseif type == "steam_id" then
		query = "SELECT * FROM users WHERE identifier = @input" -- TODO might need to change / remove for charid
	elseif type == "server_id" then
		input = tonumber(input)
		local xPlayer = ESX.GetPlayerFromId(input)
		input = xPlayer.rpuk_charid
		query = "SELECT * FROM users WHERE rpuk_charid = @input"
	end

	if job == "police" or job == "lost" then
		query = query .. " AND " .. job .. "level > -1"
	elseif job == "ambulance" then
		query = query .. " AND emslevel > -1"
	else
		query = query .. ' AND `mutexjobdata` NOT LIKE ' .. "'%" .. job .. "\":0%'"
	end

	local data = MySQL.Sync.fetchAll(query, {
		["@input"] = input
	})

	cb(data)
end)

RegisterNetEvent("rpuk_factions:deposit")
AddEventHandler("rpuk_factions:deposit", function(source, job, amount, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	local data = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
		["@job"] = job
	})[1]

	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		xPlayer.showAdvancedNotification('FLEECA BANK', "Transaction Failed", "" , 'CHAR_BANK_FLEECA', 1)
		cb(data.fund)
	else
		xPlayer.removeMoney(amount, ('%s [%s]'):format('ATM Transaction - Faction Fund Deposit', GetCurrentResourceName()))
		MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
			["@fund"] = amount+data.fund,
			["@job"] = job
		})
		xPlayer.showAdvancedNotification('FLEECA BANK', "Transaction Complete", "Deposited ~g~£" .. amount , 'CHAR_BANK_FLEECA', 9)
		print("RPUK ATM: " .. xPlayer.identifier .. " Deposited " .. amount .. " Via fund")
		cb(amount+data.fund)
	end
end)

RegisterNetEvent("rpuk_factions:withdraw")
AddEventHandler("rpuk_factions:withdraw", function(source, job, amount, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local data = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
		["@job"] = job
	})[1]

	if amount == nil or amount <= 0 or amount > data.fund then
		xPlayer.showAdvancedNotification('FLEECA BANK', "Transaction Failed", "" , 'CHAR_BANK_FLEECA', 1)
		cb(data.fund)
	else
		MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
			["@fund"] = data.fund-amount,
			["@job"] = job
		})
		xPlayer.addMoney(amount, ('%s [%s]'):format('ATM Transaction - Faction Fund Withdraw', GetCurrentResourceName()))
		xPlayer.showAdvancedNotification('FLEECA BANK', "Transaction Complete", "Withdrew ~g~£" .. amount , 'CHAR_BANK_FLEECA', 9)
		print("RPUK ATM: " .. xPlayer.identifier .. " Withdrew " .. amount .. " From fund")
		cb(data.fund - amount)
	end
end)