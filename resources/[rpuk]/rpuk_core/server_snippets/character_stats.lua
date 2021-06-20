RegisterNetEvent('rpuk_stats:increase')
AddEventHandler('rpuk_stats:increase', function(stat)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xStat = tostring(stat)
	local oldData = json.decode(xPlayer.progressdata)
	if oldData[xStat] then
		xPlayer.setStatData(xStat, oldData[xStat] + 1)
	else
		xPlayer.setStatData(xStat, 1)
	end
end)