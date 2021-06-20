RegisterNetEvent('mythic_notify:client:SendAlert')
AddEventHandler('mythic_notify:client:SendAlert', function(data)
	SendAlert(data.type, data.text, data.length, data.style)
end)

RegisterNetEvent('mythic_notify:client:SendUniqueAlert')
AddEventHandler('mythic_notify:client:SendUniqueAlert', function(data)
	SendUniqueAlert(data.id, data.type, data.text, data.length, data.style)
end)


RegisterNetEvent('mythic_notify:client:PersistentAlert')
AddEventHandler('mythic_notify:client:PersistentAlert', function(data)
	PersistentAlert(data.action, data.id, data.type, data.text, data.style)
end)

function SendAlert(type, text, length, style)
	SendNUIMessage({
		action = 'showNotification',
		type = type,
		text = text,
		length = length,
		style = style
	})
end

function SendUniqueAlert(id, type, text, length, style)
	SendNUIMessage({
		action = 'showNotification',
		id = id,
		type = type,
		text = text,
		style = style
	})
end

function PersistentAlert(action, id, type, text, style)
	if action:upper() == 'START' then
		SendNUIMessage({
			action = 'showNotification',
			persist = action,
			id = id,
			type = type,
			text = text,
			style = style
		})
	elseif action:upper() == 'END' then
		SendNUIMessage({
			action = 'showNotification',
			persist = action,
			id = id
		})
	end
end