RegisterNetEvent("rpuk_stage:effectsServer")
AddEventHandler("rpuk_stage:effectsServer", function(toggle)
    TriggerClientEvent("rpuk_stage:effectsClient", -1, toggle)
end)