local lastPlayerSuccess = {}

RegisterNetEvent('esx_taxijob:successfulpayoutt')
AddEventHandler('esx_taxijob:successfulpayoutt', function(jobDistance)
	local xPlayer = ESX.GetPlayerFromId(source)
	local timeNow = os.clock()

	if xPlayer.job.name == 'taxi' then
		if not lastPlayerSuccess[source] or timeNow - lastPlayerSuccess[source] > 20 then
			lastPlayerSuccess[source] = timeNow
			math.randomseed(os.time())

			local tipMoney = math.random(Config.Taxi.NPCJobEarnings.min, Config.Taxi.NPCJobEarnings.max)
			local distanceMoney = math.floor(jobDistance / Config.Taxi.DistanceDivisor)
			local totalMoney = distanceMoney + tipMoney

			if xPlayer.job.grade >= 3 then totalMoney = totalMoney * 2 end

			xPlayer.addMoney(totalMoney, ('%s [%s]'):format('Taxi Job Payout', GetCurrentResourceName()))
			local msg = ('Meter: ~g~£%s~s~~n~Tip: ~g~£%s~s~~n~Grand Total: ~g~£%s~s~')
			:format(ESX.Math.GroupDigits(distanceMoney), ESX.Math.GroupDigits(tipMoney), ESX.Math.GroupDigits(totalMoney))
			xPlayer.showAdvancedNotification('Taxi Service', 'Trip Complete', msg, 'CHAR_TAXI', 9)
		else
			TriggerEvent('rpuk_anticheat:saw', source, 'taxi_timeout')
		end
	else
		print(('esx_taxijob: %s attempted to trigger success!'):format(xPlayer.identifier))
		print('RPUK Admin: Illegal Call Detected From ' .. xPlayer.identifier .. ' Banning Client [Admin Kick]')
		TriggerEvent('rpuk_anticheat:sab', source, 'job_restricted')
	end
end)