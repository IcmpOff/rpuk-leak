playersInJobDuty, currentPlayerJobInDuty = {police = {}, ambulance = {}}, {}
Config.ammoTypes = ESX.GetAmmo()

function isInList(val, list)
	for k,v in pairs(list) do
		if val == v then
			return true
		end
	end
	return false
end

RegisterNetEvent('police:spikes')
AddEventHandler('police:spikes', function(currentVeh, peeps)
	TriggerClientEvent("police:dietyres", peeps, currentVeh)
	TriggerClientEvent("police:dietyres2", peeps)
end)