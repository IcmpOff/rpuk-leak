local hackingindex = ''
local hackingtimer = ''

--Main thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, letSleep = GetEntityCoords(PlayerPedId()), true

		for index, data in pairs(ds.radioMasts) do
			local distance = #(playerCoords - data.access.location)

			if distance < 5 then
				letSleep = false
				local textformat

				if not data.offline then
					textformat = data.name .. '\nPress [~r~E~s~] To Hack Mast'
				else
					textformat = data.name .. '\nMast is offline'
				end

				local textpos = vector3(data.access.location.x, data.access.location.y, data.access.location.z + 1.0)
				ESX.Game.Utils.DrawText3D(textpos, textformat, 1.0, 6)


				if IsControlJustReleased(1,  38) then
					if distance < 1.5 then
						if not data.offline then
							TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "powerGrid"})
							hackingindex = index
							hackingtimer = data.timer
							TriggerEvent('mhacking:show')
							TriggerEvent('mhacking:start',7,35,hackingcb)
						end
					else
						TriggerEvent("mythic_notify:client:SendAlert", {text = "You are too far away!", type = 'error',})
					end
				end

			end
		end

		if letSleep then Citizen.Wait(500) end
	end
end)

--Main event to update your client when a mast goes down / up
RegisterNetEvent('rpuk_radioMasts:update')
AddEventHandler('rpuk_radioMasts:update', function(id, state)
	ds.radioMasts[id].offline = state
end)

--Hacking callback
function hackingcb(success, timeremaining) --Hacking callback
	if success then
		TriggerServerEvent('rpuk_radioMasts:toggleState', hackingindex, hackingtimer, true) --Future room here to use that server event to turn back on a mast without server doing it
		TriggerEvent('mhacking:hide')
	else
		TriggerEvent('mhacking:hide')
	end
end

--Get closest tower and is it on/offline
function mastCheck(coords)
	local lowestDist = 1000000000000000000 --Setting high so it will identify the closest one to you
	local lowestIndex = ''
	for index, data in pairs(ds.radioMasts) do
		if GetDistanceBetweenCoords(coords, data.access.location) < lowestDist then
			lowestIndex = index
			lowestDist = GetDistanceBetweenCoords(coords, data.access.location)
		end
	end
	if ds.radioMasts[lowestIndex].offline then --It is down
		ESX.ShowAdvancedNotification('Lifeinvader', 'Error', 'We failed to connect you to our '..ds.radioMasts[lowestIndex].name, 'CHAR_LIFEINVADER', 0)
		return false
	elseif not ds.radioMasts[lowestIndex].offline then --It isnt down
		return true
	end
end