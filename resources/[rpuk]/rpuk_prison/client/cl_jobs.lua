RegisterNetEvent('rpuk_prison:jobs')
AddEventHandler('rpuk_prison:jobs', function(type)
	local player = PlayerPedId()
	local coord = GetEntityCoords(player)
	if type == "clean" then
		if (not cleaningPoints:isPointInside(coord) and not cleaningPoints2:isPointInside(coord)) then
			TriggerEvent('mythic_notify:client:SendAlert', {length = 4000, type = 'error', text = 'You need to be near a table.' })
			return
		end
	elseif type == "sink" then
		if not sink:isPointInside(coord) then
			TriggerEvent('mythic_notify:client:SendAlert', {length = 4000, type = 'error', text = 'You need to be near a sink.' })
			return
		end
	elseif type == "stock" then
		if not stock:isPointInside(coord) then
			TriggerEvent('mythic_notify:client:SendAlert', {length = 4000, type = 'error', text = 'You need to be near a clothing rack.' })
			return
		end
	elseif type == "search" then
		if (not searchPoint:isPointInside(coord) and not searchPoint2:isPointInside(coord) and not searchPoint3:isPointInside(coord)) then
			TriggerEvent('mythic_notify:client:SendAlert', {length = 4000, type = 'error', text = 'You need to be near a place to search!' })
			return
		end
	end
	TriggerEvent("mythic_progbar:client:progress", {
		name = "job",
		duration = config.jobAnims[type].time,
		label = config.jobAnims[type].label,
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
			closeInv = true
		},
		animation = config.jobAnims[type].animation,
		prop = config.jobAnims[type].prop,
	}, function(status)
		if not status then
			TriggerServerEvent("rpuk_prison:resultFromJob", type)
		end
	end)
end)