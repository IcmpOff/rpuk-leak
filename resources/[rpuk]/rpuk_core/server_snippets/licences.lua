local xLicences = {}

MySQL.ready(function()
	Citizen.Wait(30000)
	MySQL.Async.fetchAll('SELECT type, price FROM licenses WHERE available = 1', {
	}, function(result)
		for index,data in pairs(result) do
			xLicences[data.type] = data.price
		end
	end)
end)

RegisterNetEvent('rpuk_licences:purchase')
AddEventHandler('rpuk_licences:purchase', function(type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= xLicences[type] then
		xPlayer.removeMoney(xLicences[type], ('%s (%s) [%s]'):format('Licence Purchase', type, GetCurrentResourceName()))
		TriggerEvent('esx_license:addLicense', source, tostring(type), function()

		end)
		print("RPUK LICENCE: " .. xPlayer.identifier .. " " .. type)
		xPlayer.showAdvancedNotification('FLEECA BANK', "Transaction Complete", "" , 'CHAR_BANK_FLEECA', 9)
	else
		xPlayer.showAdvancedNotification('FLEECA BANK', "Transaction Failed", "You don't have enough cash for this transaction." , 'CHAR_BANK_FLEECA', 9)
	end
end)

ESX.RegisterServerCallback("rpuk_licences:getLicences", function(source, callback)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE rpuk_charid = @rpuk_charid', {
		['@rpuk_charid'] = xPlayer.rpuk_charid
	}, function(result)
		callback(result)
	end)
end)

function AddLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.execute('INSERT INTO user_licenses (type, owner, rpuk_charid) VALUES (@type, @owner, @rpuk_charid)', {
		['@type']  = type,
		['@owner'] = xPlayer.identifier,
		['@rpuk_charid'] = xPlayer.rpuk_charid
	}, function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end

function RemoveLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.execute('DELETE FROM user_licenses WHERE type = @type AND rpuk_charid = @rpuk_charid', {
		['@type']  = type,
		['@rpuk_charid'] = xPlayer.rpuk_charid
	}, function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end

function GetLicense(type, cb)
	MySQL.Async.fetchAll('SELECT * FROM licenses WHERE type = @type', {
		['@type'] = type
	}, function(result)
		local data = {
			type  = type,
			label = result[1].label
		}

		cb(data)
	end)
end

function GetLicenses(target, cb)
	local xPlayer = ESX.GetPlayerFromId(target)
	MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE rpuk_charid = @charid', {
		['@charid'] = xPlayer.rpuk_charid
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
			cb(licenses, xPlayer.firstname .. " " .. xPlayer.lastname, xPlayer.dateOfBirth,xPlayer.rpuk_charid,xPlayer.source)
		end)
	end)
end

function CheckLicense(target, type, cb)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND rpuk_charid = @rpuk_charid', {
		['@type']  = type,
		['@rpuk_charid'] = xPlayer.rpuk_charid
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end

	end)
end

function GetLicensesList(cb)
	MySQL.Async.fetchAll('SELECT * FROM licenses', {
		['@type'] = type
	}, function(result)
		local licenses = {}

		for i=1, #result, 1 do
			table.insert(licenses, {
				type  = result[i].type,
				label = result[i].label,
				price = result[i].price,
				desc = result[i].description,
				avail = result[i].available,
			})
		end

		cb(licenses)
	end)
end

RegisterNetEvent('esx_license:addLicense')
AddEventHandler('esx_license:addLicense', function(target, type, cb)
	AddLicense(target, type, cb)
end)

RegisterNetEvent('esx_license:removeLicense')
AddEventHandler('esx_license:removeLicense', function(target, type, cb)
	RemoveLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicense', function(type, cb)
	GetLicense(type, cb)
end)

AddEventHandler('esx_license:getLicenses', function(target, cb)
	GetLicenses(target, cb)
end)

AddEventHandler('esx_license:checkLicense', function(target, type, cb)
	CheckLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

ESX.RegisterServerCallback('esx_license:getLicense', function(source, cb, type)
	GetLicense(type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicenses', function(source, cb, target)
	GetLicenses(target, cb)
end)

ESX.RegisterServerCallback('esx_license:checkLicense', function(source, cb, target, type)
	CheckLicense(target, type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicensesList', function(source, cb)
	GetLicensesList(cb)
end)