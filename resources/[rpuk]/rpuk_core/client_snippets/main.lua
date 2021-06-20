local isDead, ToggleRadarOff, VisionState = false, nil, 0
entity = nil

RegisterKeyMapping('recordstart', 'Start recording a clip', 'keyboard', '')
RegisterKeyMapping('recordsave', 'Stop and save the recording', 'keyboard', '')
RegisterKeyMapping('recorddiscard', 'Stop and discard the recording', 'keyboard', '')

TriggerEvent('chat:addSuggestion', '/recordstart', 'Start recording a clip')
TriggerEvent('chat:addSuggestion', '/recordsave', 'Stop and save the recording')
TriggerEvent('chat:addSuggestion', '/recorddiscard', 'Stop and discard the recording')

RegisterCommand('recordstart', function(playerId, args, rawCommand) startRecording() end)
RegisterCommand('recordsave', function(playerId, args, rawCommand) stopRecordingAndSaveClip() end)
RegisterCommand('recorddiscard', function(playerId, args, rawCommand) stopRecordingAndDiscardClip() end)

local accountHashes = {
	bank = GetHashKey('BANK_BALANCE'),
	money = GetHashKey('MP0_WALLET_BALANCE')
}

local scopedWeapons = {
	[100416529] = true,  -- WEAPON_SNIPERRIFLE
	[205991906] = true,  -- WEAPON_HEAVYSNIPER
	[3342088282] = true, -- WEAPON_MARKSMANRIFLE
	[177293209] = true,   -- WEAPON_HEAVYSNIPER MKII
	[1785463520] = true, -- WEAPON_MARKSMANRIFLE_MK2
	[911657153] = true,-- Stungun
	[2726580491] = true, -- Grenade Launcher
}

Citizen.CreateThread(function()
	while not ESX.IsPlayerLoaded() do Citizen.Wait(500) end
	for k,v in ipairs(ESX.Player.GetAccounts()) do
		local statName = accountHashes[v.name]

		if statName then
			StatSetInt(statName, v.money, true)
		end
	end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	local statName = accountHashes[account.name]

	if statName then
		StatSetInt(statName, account.money, true)
	end
end)

Citizen.CreateThread(function()
	SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
	SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
	SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
	SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
	SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)

	for dispatchService=1,25 do
		EnableDispatchService(dispatchService, false)
	end

	AddTextEntry('FE_THDR_GTAO', ('Roleplay.co.uk | Server ID: ~y~%s~s~'):format(GetPlayerServerId(PlayerId())))
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		SetRadarZoom(1100) -- minimap size
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)  --- Disable recharge health
		HideHudComponentThisFrame(7) -- Area Name
		HideHudComponentThisFrame(9) -- Street Name
		HideHudComponentThisFrame(3) -- Disable Cash showing top right corner on window resize
		HideHudComponentThisFrame(4) -- Disable Bank showing top right corner on window resize
		HideHudComponentThisFrame(5) -- Disable Bank showing top right corner on window resize
		HideHudComponentThisFrame(13) -- Don't show bank & money updates (from rpuk_core)
		--SetPedSuffersCriticalHits(PlayerPedId(), false) -- Disable headshots
	end
end)

function ManageReticle(ped)
	local _, hash = GetCurrentPedWeapon(ped, true)
	if not scopedWeapons[hash] then
		HideHudComponentThisFrame(14)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		-- Disable reticle

		if not crosshair_active then
			ManageReticle(ped)
		end

		-- Disable melee while aiming (may be not working)
		if IsPedArmed(ped, 6) then
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
		end

		if IsPedBeingStunned(ped) then
			local TaserTime = math.random(12,15)
			SetPedMinGroundTimeForStungun(ped, TaserTime*1000)
		end

		-- Disable ammo HUD
		DisplayAmmoThisFrame(false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		InvalidateIdleCam()
		N_0x9e4cfff989258472() -- vehicle idle camera
		SetPedConfigFlag(PlayerPedId(), 184, true) -- disable automatic seat shuffle
		SetPedConfigFlag(PlayerPedId(), 35, false) -- disable Automatic Bike Helmet
		SetAudioFlag('DisableFlightMusic', true)

		-- disable wanted level
		ClearPlayerWantedLevel(PlayerId())
		SetMaxWantedLevel(0)
	end
end)

function HUD_Display()
	if ToggleRadarOff == false then
		TriggerEvent("rpuk_hud:toggleHud", true)
	else
		TriggerEvent("rpuk_hud:toggleHud", false)
	end
end

AddEventHandler('esx:onPlayerDeath', function(data) isDead = true end)
AddEventHandler('playerSpawned', function(spawn)
	SetDeepOceanScaler(0.0)
	isDead = false
end)

function OpenPlayerMenu()
	local elements = {
		{label = "Self Help", value = 'selfHelp'},
	}

	if ESX.Player.GetIsStaff() then
		table.insert(elements, {label = "Admin Menu", value = "staffmenu"})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'playermenu', {
		title    = 'Player Menu',
		css =  'rpuk',
		align    = 'top',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'staffmenu' then
			OpenStaffMenu()
		elseif data.current.value == 'selfHelp' then
			SelfHelp()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function SelfHelp()
	local elements = {
		{label = "Interface Options", value = "interfacemenu"},
		{label = "Rockstar Editor", value = "mediamenu"}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'selfhelpmenu', {
		title    = 'Self Help',
		css =  'rpuk',
		align    = 'top',
		elements = elements
	}, function(data, menu)
		if data.current.value == "mediamenu" then
			OpenMediaMenu()
		elseif data.current.value == 'interfacemenu' then
			InterfaceMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenStaffMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'staffmenu', {
		title    = 'Staff',
		css 	 =  'rpuk',
		align    = 'top',
		elements = {
			{label = "<B><span style='color:orange;'>TELEPORT WAYPOINT</span></B>", value = "quickteleport"},
			{label = "Teleport >>", value = "adminteleport"},
			{label = "Set Staff Camera Type", value = 0, max = 1, type = 'slider', camera = true}
	}}, function(data, menu)
		if data.current.value == 'quickteleport' then
			TeleportToWaypoint()
		elseif data.current.value == 'adminteleport' then
			AdminTeleportMenu()
		elseif data.current.camera then
			ESX.ShowNotification('Camera type has been set')
			TriggerEvent('rpuk_admin:setCameraType', data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenMediaMenu()
	local elements = {}

	table.insert(elements, {label = "<B><span style='color:red;'>•</span></B> Start Recording", value = "start"})
	table.insert(elements, {label = "<B><span style='color:red;'>❚❚</span></B> Stop & Save Clip", value = "stopsave"})
	table.insert(elements, {label = "<B><span style='color:red;'>❚❚</span></B> Stop & Discard Clip", value = "stopbin"})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'staffmenu', {
		title    = 'R* Editor',
		css =  'rpuk',
		align    = 'top',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'start' then
			startRecording()
		elseif data.current.value == 'stopsave' then
			stopRecordingAndSaveClip()
		elseif data.current.value == 'stopbin' then
			stopRecordingAndDiscardClip()
		elseif data.current.value == 'sessionLeave' then
			NetworkSessionEnd(true, true)
		elseif data.current.value == 'editoropen' then
			ESX.UI.Menu.CloseAll()
			Citizen.Wait(500)
			NetworkSessionLeaveSinglePlayer()

			ActivateRockstarEditor()

			while IsPauseMenuActive() do Citizen.Wait(1000) end

			DoScreenFadeIn(1)
			ESX.ShowNotification('You now have to relog')
		end
	end, function(data, menu)
		menu.close()
	end)
end

function startRecording()
	if IsRecording() then
		ESX.ShowNotification('You are already recording!')
	else
		StartRecording(1)
	end
end

function stopRecordingAndSaveClip()
	if IsRecording() then
		StopRecordingAndSaveClip()
		ESX.ShowNotification('Saving clip')
	else
		ESX.ShowNotification('You have not started recording!')
	end
end

function stopRecordingAndDiscardClip()
	if IsRecording() then
		StopRecordingAndDiscardClip()
		ESX.ShowNotification('Discarded clip')
	else
		ESX.ShowNotification('You have not started recording!')
	end
end

-- end
TeleportToWaypoint = function()
	local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
		local playerPed = PlayerPedId()
		local vehicleHandle = GetVehiclePedIsIn(playerPed, false)
		local isInVehicle = IsPedInAnyVehicle(playerPed, false)
			and GetPedInVehicleSeat(vehicleHandle, -1) == playerPed or false
		local groundZ, found = 850.0, false
		local pedRestoreVisibility = IsEntityVisible(playerPed)

		if isInVehicle then
			FreezeEntityPosition(vehicleHandle, true)
			NetworkFadeOutEntity(vehicleHandle, true, false)
		else
			ClearPedTasksImmediately(playerPed)
			FreezeEntityPosition(playerPed, true)
			NetworkFadeOutEntity(playerPed, true, false)
		end

		for z=0.0, 950.0, 25 do
			local testZ = z

			RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, testZ)
			NewLoadSceneStart(waypointCoords.x, waypointCoords.y, waypointCoords.x, waypointCoords.y, testZ, 50.0, 0)

			local tempTimer = GetGameTimer()

			while IsNetworkLoadingScene() do
				Citizen.Wait(0)
				if GetGameTimer() - tempTimer > 1000 then break end
			end

			SetEntityCoords(isInVehicle and vehicleHandle or playerPed, waypointCoords.x, waypointCoords.y, testZ, false, false, false, true)
			tempTimer = GetGameTimer()

			while not HasCollisionLoadedAroundEntity(playerPed) do
				Citizen.Wait(0)
				if GetGameTimer() - tempTimer > 1000 then break end
			end

			found, groundZ = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, testZ, false)

			if found then
				SetEntityCoords(isInVehicle and vehicleHandle or playerPed, waypointCoords.x, waypointCoords.y, groundZ, false, false, false, true)

				if isInVehicle then
					FreezeEntityPosition(vehicleHandle, false)
					SetVehicleOnGroundProperly(vehicleHandle)
					FreezeEntityPosition(vehicleHandle, true)
				end

				break
			else
				Citizen.Wait(10)
			end
		end

		if not found then
			ESX.ShowNotification('Could not find a safe ground coord')
		end

		if pedRestoreVisibility then
			NetworkFadeInEntity(isInVehicle and vehicleHandle or playerPed, true)
		end

		FreezeEntityPosition(isInVehicle and vehicleHandle or playerPed, false)
		SetGameplayCamRelativePitch(0.0, 1.0)
	else
		ESX.ShowNotification("Please place your waypoint.")
	end
end

DoScreenFadeIn(500)

RegisterNetEvent('rpuk_core:tele_PlayerToAdminResponse')
AddEventHandler("rpuk_core:tele_PlayerToAdminResponse", function(ServerAdminCoordX, ServerAdminCoordY, ServerAdminCoordZ)
	SetEntityCoords(PlayerPedId(), ServerAdminCoordX, ServerAdminCoordY, ServerAdminCoordZ)
end)

RegisterNetEvent('rpuk_core:radarToggle')
AddEventHandler("rpuk_core:radarToggle", function(state)
	ToggleRadarOff = state or false
end)

RegisterNetEvent('rpuk_core:DeathToggle')
AddEventHandler("rpuk_core:DeathToggle", function()
	ToggleRadarOff = true
end)

function AdminTeleportMenu()
	local elements = {}

	table.insert(elements, {label = "Your <span style='color:orange;'>Coordinates</span>", value = "getcoords"})
	table.insert(elements, {label = "Main <span style='color:orange;'>Admin</span> Offices", value = "tele_admin_main", x = 121.3, y = -621.7, z = 206.0})
	if ESX.Player.GetIsStaff() then
		table.insert(elements, {label = "Main <span style='color:lightgreen;'>Developer</span> Zone", value = "tele_admin_main", x = -1282.8303222656, y = -3017.1967773438, z = -49.490047454834})
	end
	--table.insert(elements, {label = "Legion Square <span style='color:orange;'>Garage</span>", value = "tele_ls-garage", x = 234.104, y = -756.808, z = 36.86})
	--table.insert(elements, {label = "Main <span style='color:aqua;'>Police</span> Station", value = "tele_pol_main", x = -1121.34, y = -850.65, z = 18.6})
	--table.insert(elements, {label = "Pillbox <span style='color:green;'>NHS</span> Hospital", value = "tele_nhs_pill", x = 250.338, y = -568.723, z = 42.27})
	--table.insert(elements, {label = "Main <span style='color:red;'>FIRE</span> Station", value = "tele_fire_main", x = 1196.0, y = -1459.0, z = 33.836})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'teleportmenu', {
		title    = 'Staff Teleport',
		css 	 =  'rpuk',
		align    = 'top',
		elements = elements
	}, function(data, menu)
	if data.current.value == 'getcoords' then
		local AdminCoords = GetEntityCoords(PlayerPedId(), true)
		ESX.ShowNotification('X: '..AdminCoords.x)
		ESX.ShowNotification('Y: '..AdminCoords.y)
		ESX.ShowNotification('Z: '..AdminCoords.z)
	else --teleport fixed location
		local vec3coords = vector3(data.current.x, data.current.y, data.current.z)
		RequestCollisionAtCoord(vec3coords)
		Citizen.Wait(500)
		SetEntityCoords(PlayerPedId(), vec3coords)
		entity = PlayerPedId()
	  end
	end, function(data, menu)
		menu.close()
	end)
end

function InterfaceMenu()
	local elements = {}
	table.insert(elements, {label = "Toggle HUD", value = "interface_radar"})
	table.insert(elements, {label = "Toggle Chat", value = "interface_chat"})
	table.insert(elements, {label = "Toggle Crosshair", value = "interface_cross"})
	table.insert(elements, {label = "Weapon Wheel Refresh", value = "wheelfix"})
	table.insert(elements, {label = "Reset UI", value = "resetUI"})

	if ESX.Player.GetIsStaff() then
		table.insert(elements, {label = "[STAFF] Toggle Vision Filter", value = "visionFilter"})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'customization', {
		title    = 'Player Menu',
		css 	 = 'rpuk',
		align    = 'top',
		elements = elements
	}, function(data, menu)
		--[[Radar Toggle Check]]--
		if data.current.value == 'interface_radar' then
			ToggleRadarOff = not ToggleRadarOff
			HUD_Display()
		elseif data.current.value == 'wheelfix' then
			TriggerEvent("wheelfix")
		elseif data.current.value == 'interface_chat' then
			TriggerEvent('rpuk_core:toggle_chat')
		elseif data.current.value == 'visionFilter' then
			VisionState = VisionState + 1
			ChangeVision()
			if VisionState == 3 then
				VisionState = 0
			end
		elseif data.current.value == 'interface_cross' then
			TriggerEvent('rpuk_core:toggle_crosshair')
		elseif data.current.value == 'resetUI' then
			TriggerEvent("menu:menuexit")
			SetNuiFocus(false, false)
			ESX.UI.Menu.CloseAll()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ChangeVision()
	if VisionState == 1 then
		SetNightvision(false)
		SetSeethrough(false)
	elseif VisionState == 2 then
		SetNightvision(true)
		SetSeethrough(false)
	elseif VisionState == 3 then
		SetNightvision(false)
		SetSeethrough(true)
	end
end

RegisterKeyMapping('playermenu', 'Open Player Menu', 'keyboard', 'F1')
RegisterCommand('playermenu', function()
	if not IsEntityPlayingAnim(PlayerPedId(), 'misslamar1dead_body', 'dead_idle', 3) and not IsPauseMenuActive() then
		OpenPlayerMenu()
	end
end)