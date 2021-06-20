local lockdown = false

RegisterNetEvent("rpuk_prison:openComputer")
AddEventHandler("rpuk_prison:openComputer", function()
	local auth = (ESX.Player.GetJobName() == "gruppe6" or ESX.Player.GetJobName() == "police")

	if auth then
		ESX.UI.Menu.CloseAll()
		local elements = {}
		table.insert(elements, {
			label = "View Current Serving Prisoners",
			value = "current"
		})
		table.insert(elements, {
			label = "",
			value = nil
		})
		if lockdown then
			table.insert(elements, {
				label = "End Lockdown",
				value = "lockdownoff"
			})
		else
			table.insert(elements, {
				label = "Initialise Lockdown",
				value = "lockdownon"
			})
		end
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), "computer",
		{
			css = "prison",
			align = "top-left",
			elements = elements
		}, function(data, menu)
			if data.current.value == "current" then
				viewCurrentPrisoners()
				menu.close()
			elseif data.current.value == "lockdownoff" then
				TriggerServerEvent("rpuk_prison:lockdown", false)
				TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "lockdownOff"})
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == "lockdownon" then
				TriggerServerEvent("rpuk_prison:lockdown", true)
				TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "lockdownOn"})
				ESX.UI.Menu.CloseAll()
			else
				menu.close()
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'error', text = 'You can not use this computer.' })
	end
end)


function viewCurrentPrisoners()
	ESX.TriggerServerCallback("rpuk_prison:fetchCurrentJailStatus", function(result)
		ESX.UI.Menu.CloseAll()
		local elements = {}
		if next(result) == nil then
			TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'inform', text = "No one is currently serving a sentence." })
			return
		else
			for k,v in pairs(result) do
				table.insert(elements, {
					label = capEachFirst(v.name),
					value = k
				})
			end
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "computer1", {
			css = "prison",
			align = "top-left",
			elements = elements
			}, function(data, menu)
				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "computer2", {
					css = "prison",
					align = "top-left",
					elements = {
						{
							label = "Name Of Prisoner: "..result[data.current.value].name,
							value = nil
						},
						{
							label = "Remaining Sentence: ".. result[data.current.value].remaining_time.." Months",
							value = nil
						},
						{
							label = "Arresting Officer: ".. result[data.current.value].arresting_officer,
							value = nil
						},
						{
							label = "Reason: ".. result[data.current.value].reason,
							value = nil
						},
						{
							label = "  ",
							value = nil
						},
						{
							label = "Change Sentence Time",
							value = "time"
						},
						{
							label = "Release Prisoner",
							value = "release"
						},
						{
							label = "  ",
							value = nil
						},
						{
							label = "Back",
							value = "back"
						}
					}
				}, function(data2, menu2)
					if data2.current.value == "back" then
						menu2.close()
					elseif data2.current.value == "release" then
						ESX.UI.Menu.CloseAll()
						TriggerServerEvent("rpuk_prison:unJailPlayer", result[data.current.value].rpuk_charid, "sentenceFinished", false)
						TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'You have released '..result[data.current.value].name.." from prison." })
					elseif data2.current.value == "time" then
						menu.close()
						menu2.close()
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'time',
						{
							title = "Enter New Time",
						}, function(data3, menu3)
							if tonumber(data3.value) ~= nil then
								TriggerServerEvent("rpuk_prison:changeSentenceTime", result[data.current.value], data3.value)
								ESX.UI.Menu.CloseAll()
							else
								menu3.close()
								TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You need to enter a number. "})
							end
						end, function(data3, menu3)
							menu3.close()
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end, function(data, menu)
				menu.close()
			end)
		end
	end)
end

RegisterNetEvent("rpuk_prison:startLockdown")
AddEventHandler("rpuk_prison:startLockdown", function(state)
	lockdown = state
	local alarmIpl = GetInteriorAtCoordsWithType(1787.004,2593.1984,45.7978,"int_prison_main")

	if lockdown then

		RefreshInterior(alarmIpl)
		EnableInteriorProp(alarmIpl, "prison_alarm")

		Citizen.CreateThread(function()
			while not PrepareAlarm("PRISON_ALARMS") do
				Citizen.Wait(100)
			end
			StartAlarm("PRISON_ALARMS", true)
		end)
	else

		RefreshInterior(alarmIpl)
		DisableInteriorProp(alarmIpl, "prison_alarm")

		Citizen.CreateThread(function()
			while not PrepareAlarm("PRISON_ALARMS") do
				Citizen.Wait(100)
			end
			StopAllAlarms(true)
		end)
	end
end)


RegisterNetEvent("rpuk_prison:checkPhone")
AddEventHandler("rpuk_prison:checkPhone", function()
	local player = PlayerPedId()
	local coord = GetEntityCoords(player)
	local phoneBooth = phoneBooth:isPointInside(coord)
	if phoneBooth then
		TriggerServerEvent("rpuk_prison:checkPhone")
	end
end)
