local downMasts = {}

--Lets all clients know that the tower is down
RegisterNetEvent('rpuk_radioMasts:toggleState')
AddEventHandler('rpuk_radioMasts:toggleState', function(id, timer, state)
	if state then --Toggling the mast offline
		downMasts[id] = {}
		downMasts[id]['timer'] = timer
		downMasts[id]['downtime'] = os.time()
	elseif not state then --Clear it from table if put back online
		downMasts[id] = nil
	end

	TriggerClientEvent('rpuk_radioMasts:update', -1, id, state)
end)

--This checks to see if a radio tower is down and needs to be put back up. Runs every 2.5 mins so make sure config times are 2.5 intervals
function timerCheck()
	SetTimeout(120000, function() --120000 = 2.5 mins
		for index, data in pairs(downMasts) do
			if (math.floor(os.difftime(os.time(), data.downtime) / 60) >= data.timer) then
				downMasts[index] = nil
				TriggerClientEvent('rpuk_radioMasts:update', -1, index, false)
			end
		end
		timerCheck()
	end)
end
timerCheck()
