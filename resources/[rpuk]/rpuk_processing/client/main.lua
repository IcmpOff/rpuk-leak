local HasAlreadyEnteredMarker, Lastprocess, LastAction, LastprocessData = false, nil, nil, nil
local CurrentAction, CurrentActionMsg, CurrentActionData, currProcessing = nil, '', nil, false
inMenu = false

RegisterNetEvent('rpuk_processing:hasEnteredMarker')
AddEventHandler('rpuk_processing:hasEnteredMarker', function(currentProcess, processData)
	CurrentAction = 'process.' .. string.lower(currentProcess)
	CurrentActionMsg = processData.Prompt
	CurrentActionData = { processData = processData }
end)

RegisterNetEvent('rpuk_processing:hasExitedMarker')
AddEventHandler('rpuk_processing:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Draw marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local canSleep = true
		for process, processData in ipairs(Config.ProcessingZone) do
			if GetDistanceBetweenCoords(coords, processData.Marker, true) < Config.DrawDistance and processData.job == nil or ESX.Player.GetJobName() == processData.job then
				DrawMarker(processData.MarkerSettings.type, processData.Marker, 0.0, 0.0, 0.0, 0, 0.0, 0.0, processData.MarkerSettings.x, processData.MarkerSettings.y, processData.MarkerSettings.z, processData.MarkerSettings.r, processData.MarkerSettings.g, processData.MarkerSettings.b, processData.MarkerSettings.a, false, true, 2, false, false, false, false)
				canSleep = false
			end
		end
		if canSleep then
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords, isInMarker, currentProcess, currentAction, currentprocessData = GetEntityCoords(playerPed), false, nil, nil, nil

		for process, processData in ipairs(Config.ProcessingZone) do
			if GetDistanceBetweenCoords(coords, processData.Marker, true) < processData.MarkerSettings.x then
				if processData.job == nil or ESX.Player.GetJobName() == processData.job then
					isInMarker, currentProcess, currentAction, currentprocessData = true, process, 'process.' .. string.lower(process), processData
				end
			end
		end

		local hasExited = false
		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (Lastprocess ~= currentProcess or LastAction ~= currentAction)) then
			if (Lastprocess ~= nil and LastAction ~= nil) and (Lastprocess ~= currentProcess or LastAction ~= currentAction) then
				TriggerEvent('rpuk_processing:hasExitedMarker', Lastprocess, LastAction)
				hasExited = true
			end
			HasAlreadyEnteredMarker = true
			Lastprocess, LastAction, LastprocessData = currentProcess, currentAction, currentprocessData
			TriggerEvent('rpuk_processing:hasEnteredMarker', currentProcess, currentprocessData)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			CurrentAction = nil
			TriggerEvent('rpuk_processing:hasExitedMarker', Lastprocess, LastAction)
		end

		if not HasAlreadyEnteredMarker then
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction ~= nil and not currProcessing then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(1, 51) then
				currProcessing = true
				ESX.TriggerServerCallback('rpuk_processing:startProcessing', function(returnVal, message, passed, items)
					if returnVal == true then
						TriggerEvent("mythic_progbar:client:progress", {
							name = "Processing",
							duration = passed,
							label = "Processing",
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
							  disableMovement = false,
							  disableCarMovement = false,
							  disableMouse = false,
							  disableCombat = false,
							},
						  }, function(status)
							if not status then
								TriggerServerEvent('rpuk_processing:endProcessing', CurrentActionData, items)
							end
						end)
					else
						ESX.ShowAdvancedNotification('Processing', 'Failed', message, 'CHAR_BLANK_ENTRY', 0)
					end
					currProcessing = false
				end, CurrentActionData)
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if currProcessing then
			DisableControlAction(0, 170, true) -- Disable F3
		else
			Citizen.Wait(500)
		end
	end
end)