--Main thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local distance = #(coords - vector3(-1082.23, -247.68, 36.76))

		if distance < 7 then
			DrawMarker(1, vector3(-1082.23, -247.68, 36.76), vector3(0,0,0), 0, 0.0, 0.0, vector3(1, 1, 0.3), 255, 255, 255, 50, false, false, 2, false, false, false, false)

			if distance < 1.5 then
				ESX.ShowHelpNotification('Press ~INPUT_PICKUP~ To Access Lifeinvader Services')

				if IsControlJustReleased(0, 38) then
					OpenMenu()
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function OpenMenu()
	local elements = {}

	if ESX.Player.GetJobName() == 'police' then
		table.insert(elements, {label = '<span style="color:blue">[Twitter]</span> Track Server', value = 'twitter_tracker'})
	end

	table.insert(elements, {label = '<span style="color:blue">[Twitter]</span> Reset Password', value = 'reset_password'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'twitterMenu', {
		title = '',
		css = 'lifeinvaders',
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'twitter_tracker' then
			ListTweets()
		elseif data.current.value == 'reset_password' then
			ListAccounts()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ListTweets()
	local elements = {}

	ESX.TriggerServerCallback('rpuk_twitter:listTweets', function(tweets)
		for k,v in ipairs(tweets) do
			table.insert(elements, {label = v.message, characterId = v.rpuk_charid})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'twitterList', {
			title = '',
			css		= 'lifeinvaders',
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			TriggerServerEvent('rpuk_twitter:lookupPlayer', data.current.characterId)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function ListAccounts()
	local elements = {}
	local result

	ESX.TriggerServerCallback('rpuk_twitter:listAccounts', function(accounts)
		for k,v in ipairs(accounts) do
			table.insert(elements, {label = v.username})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'twitterAccountList', {
			title = '',
			css   = 'lifeinvaders',
			align = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			DisplayOnscreenKeyboard(1, 'FMMC_MPM_NA', '', '', '', '', '', 30)
			while (UpdateOnscreenKeyboard() == 0) do
				DisableAllControlActions(0)
				Wait(0)
			end
			if (GetOnscreenKeyboardResult()) then
				result = GetOnscreenKeyboardResult()
			end
			TriggerServerEvent('rpuk_twitter:changePassword', data.current.label, result)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

--Gets street name and displays to police man
RegisterNetEvent ('rpuk_twitter:returnStreet')
AddEventHandler('rpuk_twitter:returnStreet', function(coords)
	local s, cs = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	local sName = GetStreetNameFromHashKey(s)
	ESX.ShowAdvancedNotification('Twitter', 'Location Track', 'User logged into our ' ..sName.. ' server just now!', 'CHAR_LIFEINVADER', 0)
end)