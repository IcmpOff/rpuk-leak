ESX.StartPayCheck = function()
	function payCheck()
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local jobName = xPlayer.job.name
			local job     = xPlayer.job.grade_name
			local salary  = xPlayer.job.grade_salary

			if salary > 0 then
				if job == 'unemployed' then -- unemployed
					xPlayer.addAccountMoney('bank', salary, ('%s (%s) [%s]'):format('Pay Check','Unemployed', GetCurrentResourceName()))
					xPlayer.showNotification(("You received your welfare check: <span style='color:lightgreen;'>£%s</span>"):format(ESX.Math.GroupDigits(salary)), 9000, 'inform')
				else -- generic job
					xPlayer.addAccountMoney('bank', salary, ('%s (%s) [%s]'):format('Pay Check', jobName, GetCurrentResourceName()))
					xPlayer.showNotification(("You received your salary: <span style='color:lightgreen;'>£%s</span>"):format(ESX.Math.GroupDigits(salary)), 9000, 'inform')
				end
			end

		end

		SetTimeout(Config.PaycheckInterval, payCheck)
	end

	SetTimeout(Config.PaycheckInterval, payCheck)
end