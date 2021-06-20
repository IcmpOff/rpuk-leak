RegisterNetEvent("rpuk_factions:sendToNpcVehicle")
AddEventHandler("rpuk_factions:sendToNpcVehicle", function(target, hospital)
	TriggerClientEvent("rpuk_factions:teleportToHospital", target, hospital)
end)