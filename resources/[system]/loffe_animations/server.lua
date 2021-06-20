RegisterServerEvent('loffe_animations:syncAccepted')
AddEventHandler('loffe_animations:syncAccepted', function(requester, id)
    local accepted = source

    TriggerClientEvent('loffe_animations:playSynced', accepted, requester, id, 'Accepter')
    TriggerClientEvent('loffe_animations:playSynced', requester, accepted, id, 'Requester')
end)

RegisterServerEvent('loffe_animations:requestSynced')
AddEventHandler('loffe_animations:requestSynced', function(target, id)
    local requester = source
    local xPlayer = ESX['GetPlayerFromId'](requester)
    TriggerClientEvent('loffe_animations:syncRequest', target, requester, id, xPlayer.firstname)
end)

ESX.RegisterCommand('legacy_anims', 'staff_level_5', function(xPlayer, args, showError)
	xPlayer.triggerEvent('loffe_animations:openMenu')
end, true, {help = "Ability to use legacy anim sets (Redundant)"})