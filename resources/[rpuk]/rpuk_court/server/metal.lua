RegisterServerEvent("rpuk_courts:svSync")
AddEventHandler("rpuk_courts:svSync", function(UID, status)
	TriggerClientEvent("rpuk_courts:MDSync", -1, UID, status)
end)


