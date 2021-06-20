MySQL.ready(function()
end)

ESX.RegisterCommand('setstat', 'dev_level_2', function(xPlayer, args, showError)
	args.playerId.setStatData(args.stat, args.level)
end, true, {help = 'Set stat', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
	{name = 'stat', help = 'stat', type = 'string'},
	{name = 'level', help = 'level', type = 'number'},
}})

ESX.RegisterServerCallback('hi', function(playerId, cb)
	Wait(10000)
	cb(true)
end)

ESX.RegisterCommand('d', 'staff_level_5', function(xPlayer, args, showError)
	exports['screenshot-basic']:requestClientScreenshot(xPlayer.playerId, {
		fileName = 'cache/screenshot.jpg'
	}, function(err, data)
		print('err', err)
		print('data', data)
	end)
end, false, {help = 'callback size', validate = false})

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(55000)
		--TriggerClientEvent('connectqueue:updateQueueCount', -1, 50, 10)

	end
end)


ESX.RegisterCommand('paycheck', 'user', function(xPlayer, args, showError)
	local jobName = xPlayer.job.name
	local job     = xPlayer.job.grade_name
	local salary  = xPlayer.job.grade_salary

	print(salary)
	if salary > 0 then
		if true then -- unemployed
			print('a')
			xPlayer.addAccountMoney('bank', salary, ('%s (%s) [%s]'):format('Pay Check','Unemployed', GetCurrentResourceName()))
			xPlayer.showNotification(("You received your welfare check: <span style='color:lightgreen;'>£%s</span>"):format(ESX.Math.GroupDigits(salary)), 9000, 'inform')
		else -- generic job
			print('ba')

			xPlayer.addAccountMoney('bank', salary, ('%s (%s) [%s]'):format('Pay Check', jobName, GetCurrentResourceName()))
			xPlayer.showNotification(("You received your salary: <span style='color:lightgreen;'>£%s</span>"):format(ESX.Math.GroupDigits(salary)), 9000, 'inform')
		end
	end
end, false, {help = ('command_clear')})