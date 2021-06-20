ESX.RegisterCommand('blips', 'staff_level_2', function(xPlayer, args, showError)
	xPlayer.triggerEvent('rpuk:staff_blips')
end, false, {help = 'Enable all player blips'})

ESX.RegisterCommand('deletepickups', 'staff_level_1', function(xPlayer, args, showError)
	TriggerEvent('rpuk_inventory:clearAllPickups')
end, true, {help = 'Delete all pickups'})

ESX.RegisterCommand('deletevehicles', 'staff_level_1', function(xPlayer, args, showError)
	TriggerEvent('rpuk_anticheat:cleanup', 'vehicles')
end, true, {help = 'Delete all vehicles in the server, panic command only.'})

ESX.RegisterCommand('deleteobjects', 'staff_level_1', function(xPlayer, args, showError)
	TriggerEvent('rpuk_anticheat:cleanup', 'objects')
end, true, {help = 'Delete all objects in the server, panic command only.'})

ESX.RegisterCommand('deletepeds', 'staff_level_1', function(xPlayer, args, showError)
	xPlayer.triggerEvent('rpuk_anticheat:togglePeds')
end, false, {help = 'Toggle ped deleter'})