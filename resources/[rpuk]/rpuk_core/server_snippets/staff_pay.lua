local staff_pay = 2500
local staff_interval = 7 * 60000
local dev_pay = 250000

function staffPay()	
	local xPlayers = ESX.GetPlayers()	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		local xGroups = xPlayer.getGroups()
		for group, active in pairs(xGroups) do
			if string.find(group, "staff_level_") and active == true then
				print("Paid £" .. staff_pay .. " to Staff Member " .. xPlayer.name .. " Group: " .. group)
				xPlayer.addAccountMoney('bank', staff_pay, ('%s [%s]'):format('Staff Pay Check', GetCurrentResourceName()))
			end
		end
	end
	SetTimeout(staff_interval, staffPay)
end

staffPay()

ESX.RegisterCommand('dev_int_1', 'staff_level_5', function(xPlayer, args, showError)
	
	MySQL.Async.fetchAll('SELECT * FROM user_groups', {}, function(result)
		for k, v in pairs(result) do
			for group, active in pairs(json.decode(v.groups)) do
				if string.find(group, "dev_level_") and active == true then
					MySQL.Async.execute('INSERT INTO comp_requests (identifier, rpuk_charid, comp_data, public_note, staff, staff_note) VALUES (@identifier, -1, @comp_data, "Staff Pay Check", @caller, "Weekly Development Pay Check")', {
						['@identifier'] = v.identifier,
						["@comp_data"] = json.encode({account_bank = dev_pay}),
						["@caller"] = xPlayer.name,
					})
				end
			end
		end
	end)
	
end, false, {help = "Run the internal command 1", validate = false, arguments = {}})