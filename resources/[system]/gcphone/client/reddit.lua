RegisterNetEvent('gcPhone:tchat_receive')
AddEventHandler('gcPhone:tchat_receive', function(message)
	local coords = GetEntityCoords(PlayerPedId())
	if exports.gcphone:mastCheck(coords) then
		SendNUIMessage({event = 'tchat_receive', message = message})
	end
end)

RegisterNetEvent('gcPhone:tchat_channel')
AddEventHandler('gcPhone:tchat_channel', function(channel, messages)
	local coords = GetEntityCoords(PlayerPedId())
	if exports.gcphone:mastCheck(coords) then
		SendNUIMessage({event = 'tchat_channel', messages = messages})
	end
end)

RegisterNUICallback('tchat_addMessage', function(data, cb)
	local coords = GetEntityCoords(PlayerPedId())
	if exports.gcphone:mastCheck(coords) then
		TriggerServerEvent('gcPhone:tchat_addMessage', data.channel, data.message)
	end
end)

RegisterNUICallback('tchat_getChannel', function(data, cb)
	local coords = GetEntityCoords(PlayerPedId())
	if exports.gcphone:mastCheck(coords) then
		TriggerServerEvent('gcPhone:tchat_channel', data.channel)
	end
end)
