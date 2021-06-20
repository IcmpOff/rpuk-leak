ESX.RegisterServerCallback('rpuk_factions:payRentForCars', function(source, cb, model)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName = xPlayer.job.name
	for k, v in pairs(VehicleList.AssignedVehicles[jobName]) do
		local storeModel = GetHashKey(v.model)
		if storeModel == model then
			if v.price > 0 then
				local fundAccount = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
					["@job"] = jobName
				})[1]
				if fundAccount.fund >= v.price then
					MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
						["@fund"] = fundAccount.fund-v.price,
						["@job"] = jobName
					})
					cb(true)
					db_log(xPlayer.job.name, xPlayer.identifier, "fund", xPlayer.job.grade_label.. " " .. xPlayer.firstname .. " " .. xPlayer.lastname, "Rented Vehicle "..v.vehicleName, "- £"..v.price, xPlayer.rpuk_charid)
				else
					cb(false)
				end
			else
				cb(true)
			end
		end
	end
end)

RegisterNetEvent('rpuk_factions:returnVehicle')
AddEventHandler('rpuk_factions:returnVehicle', function(model)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName = xPlayer.job.name
	for k, v in pairs(VehicleList.AssignedVehicles[jobName]) do
		local storeModel = GetHashKey(v.model)
		if storeModel == model then
			if v.price > 0 then
				local fundAccount = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
					["@job"] = jobName
				})[1]
				if fundAccount then
					MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
						["@fund"] = v.price+fundAccount.fund,
						["@job"] = jobName
					})
					db_log(xPlayer.job.name, xPlayer.identifier, "fund", xPlayer.job.grade_label.. " " .. xPlayer.firstname .. " " .. xPlayer.lastname, "Returned Vehicle "..v.vehicleName, "+ £"..v.price, xPlayer.rpuk_charid)
				end
			end
		end
	end
end)

ESX.RegisterServerCallback('rpuk_factions:anpr_check', function(source, cb, plate)
	local data = {}

	if string.find(plate, " ") then -- verify it is a player car before running a unnessicary sql query
		local result = MySQL.Sync.fetchAll('SELECT ov.*, u.firstname, u.lastname, u.mdt_markers as mdt_markers FROM owned_vehicles ov LEFT JOIN users u ON ov.rpuk_charid = u.rpuk_charid WHERE plate = @plate', {
			['@plate'] = tostring(plate)
		})
		if result[1] then
			table.insert(data, {
				owner = result[1].firstname.. " "..result[1].lastname,
				plate = plate,
				markers = result[1].mdt_markers,
				status = result[1].mdt_status
			})
		end
	end

	if not data[1] then
		table.insert(data, {
			owner = "No Information",
			plate = plate,
			markers = "No Active Markers",
			status = nil,
		})
	end

	cb(data)
end)