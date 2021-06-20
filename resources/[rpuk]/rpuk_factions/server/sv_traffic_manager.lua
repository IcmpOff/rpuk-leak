RegisterNetEvent("rpuk_factions:TriggerNode")
AddEventHandler("rpuk_factions:TriggerNode", function(pos, enabled)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" then
		TriggerClientEvent("rpuk_factions:TriggerNode", -1, pos, enabled)
	end
end)
