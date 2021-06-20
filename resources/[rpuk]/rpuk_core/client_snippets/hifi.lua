local menuOpen = false
local musicMaxDistance = 30

RegisterNetEvent('esx_hifi:place_hifi')
AddEventHandler('esx_hifi:place_hifi', function()
	local playerPed = PlayerPedId()
	local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
	local objectCoords = (coords + forward * 1.0)
		startAnimation("anim@heists@money_grab@briefcase","put_down_case")
		Citizen.Wait(1000)
		ClearPedTasks(PlayerPedId())
		ESX.Game.SpawnObject('prop_boombox_01', objectCoords, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end)

RegisterNetEvent('esx_hifi:play_music')
AddEventHandler('esx_hifi:play_music', function(id, object)
	if distance(object) < musicMaxDistance then
		SendNUIMessage({
			transactionType = 'playSound',
			transactionData = id -- recieved the youtube id
		})

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(100)
				if distance(object) > musicMaxDistance then
					SendNUIMessage({
						transactionType = 'volume',
						transactionData = 0
					})
				else
					local calc_volume = 100 - distance(object) * 7
					if calc_volume > 50 then -- holy fuck it is loud at 100%
						calc_volume = 50
					end
					SendNUIMessage({ -- distance calculation
						transactionType = 'volume',
						transactionData = calc_volume / 2 -- quick loud fix
					})

				end
			end
		end)
	end
end)

RegisterNetEvent('esx_hifi:stop_music')
AddEventHandler('esx_hifi:stop_music', function(object)
	if distance(object) < musicMaxDistance then
		SendNUIMessage({
			transactionType = 'stopSound'
		})
	end
end)

RegisterNetEvent('esx_hifi:setVolume')
AddEventHandler('esx_hifi:setVolume', function(volume, object)
	if distance(object) < musicMaxDistance then
		SendNUIMessage({
			transactionType = 'volume',
			transactionData = volume
		})
	end
end)

function distance(object)
	local playerPed = PlayerPedId()
	local lCoords = GetEntityCoords(playerPed)
	local distance  = GetDistanceBetweenCoords(lCoords, object, true)
	return distance
end

function OpenhifiMenu(entity)
	menuOpen = true
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hifi', {
		title   = '',
		css = 'music',
		align   = 'top-left',
		elements = {
			{label = "Pick Up Speaker", value = 'get_hifi'},
			{label = "Play Music", value = 'play'},
			--{label = "Music Volume", value = 'volume'},
			{label = "Stop Music", value = 'stop'},
			{label = "", value = ""},
			{label = "For best results play covers", value = ""},
		}
	}, function(data, menu)
		local playerPed = PlayerPedId()
		local lCoords = GetEntityCoords(playerPed)
		if data.current.value == 'get_hifi' then

			if ESX.Player.GetInventory().hifi and ESX.Player.GetInventory().hifi.value > 0 then
				NetworkRequestControlOfEntity(entity)
				menu.close()
				menuOpen = false
				startAnimation("anim@heists@narcotics@trash","pickup")
				Citizen.Wait(700)
				SetEntityAsMissionEntity(entity,false,true)
				DeleteEntity(entity)
				ESX.Game.DeleteObject(entity)
				if not DoesEntityExist(entity) then
					TriggerServerEvent('esx_hifi:remove_hifi', lCoords)
				end
				Citizen.Wait(500)
				ClearPedTasks(PlayerPedId())
			else
				menu.close()
				menuOpen = false
				TriggerEvent('esx:showNotification', "You already have a speaker on you.")
			end
		elseif data.current.value == 'play' then
			play(lCoords)
		elseif data.current.value == 'stop' then
			TriggerServerEvent('esx_hifi:stop_music', lCoords)
			menuOpen = false
			menu.close()
		elseif data.current.value == 'volume' then
			setVolume(lCoords)
		end
	end, function(data, menu)
		menuOpen = false
		menu.close()
	end)
end

function setVolume(coords)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'setvolume',
	{
		title = "Set Volume",
	}, function(data, menu)
		local value = tonumber(data.value)
		if value < 0 or value > 100 then
			ESX.ShowNotification("The volume must be between 0 and 100")
		else
			TriggerServerEvent('esx_hifi:setVolume', value, coords)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function play(coords)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'play',
	{
		title = "Enter the id of the YouTube video",
	}, function(data, menu)
		TriggerServerEvent('esx_hifi:play_music', data.value, coords)
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	while true do
		canSleep = true

		local object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.0, 1729911864, false)
		if DoesEntityExist(object) and NetworkGetEntityIsNetworked(object) then
			canSleep = false
			ESX.Game.Utils.DrawText3D(GetEntityCoords(object), "[~g~E~s~] Access Speaker", 0.5, 6)
			if IsControlJustPressed(0, 38) then
				OpenhifiMenu(object)
			end
		end

		if canSleep then
			Citizen.Wait(500)
		end
		Citizen.Wait(5)
	end
end)

function startAnimation(lib,anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
	end)
end

RegisterNUICallback("noembed", function(data)
	TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'error', text = "This video cannot be embedded"})
end)
