local isPaused, isMenuOpen, keepNuiFocusOnClose, isBlurry = false, false, false, false

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() and isMenuOpen then
		SetNuiFocus(false)
		if not isBlurry then SetTimecycleModifier('default') end
	end
end)

RegisterNetEvent('rpuk_weather:isBlurry')
AddEventHandler('rpuk_weather:isBlurry', function(_isBlurry) isBlurry = _isBlurry end)

RegisterNetEvent('rpuk_guide:updateConnectedPlayers')
AddEventHandler('rpuk_guide:updateConnectedPlayers', function(connectedPlayers)
	SendNUIMessage({
		action = 'updateServerInfo',
		playerCount = ESX.Table.SizeOf(connectedPlayers)
	})
end)

RegisterNetEvent('rpuk_guide:setMaxPlayers')
AddEventHandler('rpuk_guide:setMaxPlayers', function(maxPlayers)
	SendNUIMessage({
		action = 'updateServerInfo',
		maxPlayers = maxPlayers
	})
end)

AddEventHandler('rpuk_guide:openGuide', function(_keepNuiFocusOnClose)
	if not IsPauseMenuActive() then
		SetNuiFocus(true, true)
		SetTimecycleModifier('hud_def_blur')
		SendNUIMessage({action = 'open'})
		isMenuOpen = true
		if _keepNuiFocusOnClose then keepNuiFocusOnClose = true end
		Citizen.Wait(200)
	end
end)

RegisterCommand('openguide', function() TriggerEvent('rpuk_guide:openGuide') end, false)

RegisterKeyMapping('openguide', 'Open Guide Menu', 'keyboard', 'F5')

RegisterNUICallback('onCloseMenu', function()
	isMenuOpen = false
	TriggerEvent('rpuk_guide:onGuideClosed')

	if not keepNuiFocusOnClose then
		SetNuiFocus(false)
		if not isBlurry then SetTimecycleModifier('default') end
	else
		keepNuiFocusOnClose = false
	end
end)

-- Close scoreboard when game is paused
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)
		local isPauseMenuActive = IsPauseMenuActive()

		if isPauseMenuActive and not isPaused then
			isPaused = true
			SendNUIMessage({action = 'close'})
		elseif not isPauseMenuActive and isPaused then
			isPaused = false
		end
	end
end)
