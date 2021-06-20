AddEventHandler('esx:getSharedObject', function(cb) TriggerServerEvent('rpuk_anticheat:ab', 'illegal15') end)

AddEventHandler('esx:getSharedData', function(cb) cb(ESX) end)

exports('getSharedData', function() return ESX end)