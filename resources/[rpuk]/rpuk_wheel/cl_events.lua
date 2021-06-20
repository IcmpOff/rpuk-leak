--- Functions

function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end


function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
	TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 8.0, -1, 48, 0.0, false, false, false) end)
end

function showIdAnim()
	local ped = PlayerPedId()
	local playerPed = PlayerPedId()
	local idBadge = nil
	loadAnimDict("paper_1_rcm_alt1-8")
	TaskPlayAnim(ped, 'paper_1_rcm_alt1-8', 'player_one_dual-8', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	if idBadge == nil then
		idBadge = CreateObject(GetHashKey('prop_fib_badge'), GetEntityCoords(playerPed), 1, 1, 1)
		AttachEntityToEntity(idBadge, playerPed, GetPedBoneIndex(playerPed, 58867), 0.0, 0.075, 0.0, 0.0, 0.0, 500.0, 1, 1, 0, 1, 0, 1)
	end
	Citizen.Wait(4000)
	ClearPedSecondaryTask(ped)
	ClearPedTasks(ped)
	DeleteEntity(idBadge)
	idBadge = nil
end

function GetCoordZ(x, y, initial)
	local groundCheckHeights = {initial+0, initial+1, initial+2, initial+3, initial+4, initial+5, initial+6, initial+7, initial+8, initial+9, initial+10}
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end
	return initial
end

local tracked_entities = {"prop_roadcone01a", "prop_mp_barrier_01", "prop_barrier_work05", "prop_air_lights_02a", "prop_gazebo_02", "xm_prop_x17_bag_med_01a", "prop_air_lights_02a", "prop_air_lights_02b"}

function isPropNetworkedAndTracked()
	for index,data in pairs(tracked_entities) do
		local object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.0, GetHashKey(data), false)
		if DoesEntityExist(object) and NetworkGetEntityIsNetworked(object) then
			if ESX.Game.RequestNetworkControlOfEntity(object, true) then
				return true
			end
		end
	end
end

RegisterNetEvent('rpuk_playerMenu:deleteObject')
AddEventHandler('rpuk_playerMenu:deleteObject', function()
	for index,data in pairs(tracked_entities) do
		local object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.0, GetHashKey(data), false)
		if DoesEntityExist(object) and NetworkGetEntityIsNetworked(object) then
			if ESX.Game.RequestNetworkControlOfEntity(object, true) then
				DeleteEntity(object)
			end
		end
	end
end)

RegisterNetEvent('rpuk_playerMenu:rappelDown')
AddEventHandler('rpuk_playerMenu:rappelDown', function()
	local ped = GetPlayerPed(-1)
	if IsPedInAnyHeli(ped) then
		TaskRappelFromHeli(ped, 0)
		TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'Strap in boys' })
	end
end)
----------------------------------------

RegisterNetEvent('rpuk_playerMenu:helmet')
AddEventHandler('rpuk_playerMenu:helmet', function()
	local ped = PlayerPedId()
	if GetPedPropIndex(ped, 0) == 130 then
		startAnim("anim@mp_helmets@on_foot", "goggles_up")
		Citizen.Wait(600)
		if GetPedPropTextureIndex(ped, 0) == 0 then
			SetPedPropIndex(ped, 0, 129, 0, 2) -- Ear Guard up (NCA)
		elseif GetPedPropTextureIndex(ped, 0) == 1 then
			SetPedPropIndex(ped, 0, 129, 1, 2) -- Ear Guard up (SFO)
		elseif GetPedPropTextureIndex(ped, 0) == 2 then
			SetPedPropIndex(ped, 0, 129, 2, 2) -- Ear Guard up (CTSFO)
		end
	elseif GetPedPropIndex(ped, 0) == 129 then
		startAnim("anim@mp_helmets@on_foot", "goggles_down")
		Citizen.Wait(600)
		if GetPedPropTextureIndex(ped, 0) == 0 then
			SetPedPropIndex(ped, 0, 130, 0, 2) -- Ear Guard up (NCA)
		elseif GetPedPropTextureIndex(ped, 0) == 1 then
			SetPedPropIndex(ped, 0, 130, 1, 2) -- Ear Guard up (SFO)
		elseif GetPedPropTextureIndex(ped, 0) == 2 then
			SetPedPropIndex(ped, 0, 130, 2, 2) -- Ear Guard up (CTSFO)
		end
	elseif GetPedPropIndex(ped, 0) == 126 then
		startAnim("anim@mp_helmets@on_bike@dirt", "visor_down")
		Citizen.Wait(600)
		SetPedPropIndex(ped, 0, 125, 0, 2) -- G6 Helmet Down
	elseif GetPedPropIndex(ped, 0) == 125 then
		startAnim("anim@mp_helmets@on_bike@dirt", "visor_up")
		Citizen.Wait(600)
		SetPedPropIndex(ped, 0, 126, 0, 2) -- G6 Helmet Up
	end
end)

--- Clothing Menu

RegisterNetEvent('rpuk_playerMenu:hats')
AddEventHandler('rpuk_playerMenu:hats', function()
	if GetPedPropIndex(PlayerPedId(), 0) == -1 then -- not wearing any
		TriggerEvent('skinchanger:getSkin', function(oldData)
			if oldData.helmet_1 ~= -1 then
				startAnim("missfbi4", "takeoff_mask")
				SetPedPropIndex(PlayerPedId(), 0, oldData.helmet_1, oldData.helmet_2, 2)
			end
		end)
	else
		startAnim("missfbi4", "takeoff_mask")
		ClearPedProp(PlayerPedId(), 0)
	end
end)

RegisterNetEvent('rpuk_playerMenu:masks')
AddEventHandler('rpuk_playerMenu:masks', function()
	if GetPedDrawableVariation(PlayerPedId(), 1) == 0 then -- not wearing any
		TriggerEvent('skinchanger:getSkin', function(oldData)
			startAnim("missfbi4", "takeoff_mask")
			SetPedComponentVariation(PlayerPedId(), 1, oldData.mask_1, oldData.mask_2, 2)
		end)
	else
		startAnim("missfbi4", "takeoff_mask")
		SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
	end
end)

RegisterNetEvent('rpuk_playerMenu:glasses')
AddEventHandler('rpuk_playerMenu:glasses', function()
	if GetPedPropIndex(PlayerPedId(), 1) == -1 then -- not wearing any
		TriggerEvent('skinchanger:getSkin', function(oldData)
			if oldData.glasses_1 ~= -1 then
				startAnim("clothingspecs", "try_glasses_positive_a")
				SetPedPropIndex(PlayerPedId(), 1, oldData.glasses_1, oldData.glasses_2, 2)
			end
		end)
	else
		startAnim("clothingspecs", "try_glasses_positive_a")
		ClearPedProp(PlayerPedId(), 1)
	end
end)


RegisterNetEvent('rpuk_playerMenu:bags')
AddEventHandler('rpuk_playerMenu:bags', function()
	local playerPedID = PlayerPedId()
	local playerPed = PlayerPedId()
	if GetPedDrawableVariation(playerPed, 5) == 0 then
		TriggerEvent('skinchanger:getSkin', function(oldData)
			SetPedComponentVariation(playerPed, 5, oldData.bags_1, oldData.bags_2, 2)
		end)
	else
		SetPedComponentVariation(playerPedID, 5, 0, 0, 2)
	end
end)

---- Placable Objects
RegisterNetEvent('rpuk_playerMenu:placeGazebo')
AddEventHandler('rpuk_playerMenu:placeGazebo', function()
	local ped = PlayerPedId()
	local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -0.75)
	local obj = CreateObject(`prop_gazebo_02`, coords.x, coords.y, GetCoordZ(coords.x, coords.y, coords.z),	true, true, true)
	SetEntityHeading(obj, GetEntityHeading(ped))
end)

RegisterNetEvent('rpuk_playerMenu:placeCone')
AddEventHandler('rpuk_playerMenu:placeCone', function()
	local ped = PlayerPedId()
	local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -0.75)
	local obj = CreateObject(`prop_roadcone01a`, coords.x, coords.y, GetCoordZ(coords.x, coords.y, coords.z),	true, true, true)
	SetEntityHeading(obj, GetEntityHeading(ped))
end)

RegisterNetEvent('rpuk_playerMenu:placeMedicBag')
AddEventHandler('rpuk_playerMenu:placeMedicBag', function()
	local ped = PlayerPedId()
	local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -0.75)
	local obj = CreateObject(`xm_prop_x17_bag_med_01a`, coords.x, coords.y, GetCoordZ(coords.x, coords.y, coords.z),	true, true, true)
	SetEntityHeading(obj, GetEntityHeading(ped))
end)

RegisterNetEvent('rpuk_playerMenu:placeLights')
AddEventHandler('rpuk_playerMenu:placeLights', function()
	local ped = PlayerPedId()
	local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -0.75)
	if ESX.Player.GetJobName() == 'police' then
		local obj = CreateObject(`prop_air_lights_02a`, coords.x, coords.y, GetCoordZ(coords.x, coords.y, coords.z),	true, true, true)
		SetEntityHeading(obj, GetEntityHeading(ped))
	else
		TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "You can not do this." })
	end
end)


RegisterNetEvent('rpuk_playerMenu:placeLightsNHS')
AddEventHandler('rpuk_playerMenu:placeLightsNHS', function()
	local ped = PlayerPedId()
	local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -0.75)
	local obj = CreateObject(`prop_air_lights_02b`, coords.x, coords.y, GetCoordZ(coords.x, coords.y, coords.z),	true, true, true)
	SetEntityHeading(obj, GetEntityHeading(ped))
end)

RegisterNetEvent('rpuk_playerMenu:placeCBarrier')
AddEventHandler('rpuk_playerMenu:placeCBarrier', function()
	local ped = PlayerPedId()
	local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -0.75)
	local obj = CreateObject(`prop_mp_barrier_01`, coords.x, coords.y, GetCoordZ(coords.x, coords.y, coords.z),	true, true, true)
	SetEntityHeading(obj, GetEntityHeading(ped))
end)

RegisterNetEvent('rpuk_playerMenu:placeWBarrier')
AddEventHandler('rpuk_playerMenu:placeWBarrier', function()
	local ped = PlayerPedId()
	local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -0.75)
	local obj = CreateObject(`prop_barrier_work05`, coords.x, coords.y, GetCoordZ(coords.x, coords.y, coords.z),	true, true, true)
	SetEntityHeading(obj, GetEntityHeading(ped))
end)


-- RegisterCommand('tape', function(source, args, rawCommand)
-- 	TriggerEvent("rpuk_playerMenu:placetape")
-- end)

RegisterNetEvent('rpuk_playerMenu:placetape')
AddEventHandler('rpuk_playerMenu:placetape', function()
	print("4ll")
	local ped = PlayerPedId()
	local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -1.5)
	local obj = CreateObject(GetHashKey("prop_cordon_tape"), coords.x, coords.y, coords.z,	true, true, true)
	SetEntityHeading(obj, GetEntityHeading(ped))
end)


RegisterNetEvent("rpuk_playerMenu:givePermit")
AddEventHandler("rpuk_playerMenu:givePermit", function(license)
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and distance < 3.0 then
		ESX.TriggerServerCallback("esx_license:getLicenses", function(licenses, name)
			for k,v in pairs(licenses) do
				if v.type == license then
					TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "Person already has this license" })
					return
				end
			end
			TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'inform', text = 'You have given aprovel a Licence for '.. name})
			TriggerServerEvent("esx_license:addLicense", GetPlayerServerId(closestPlayer), license)
		end, GetPlayerServerId(closestPlayer))
	else
		TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "There is no player near-by" })
	end
end)

RegisterNetEvent("rpuk_playerMenu:removePermit")
AddEventHandler("rpuk_playerMenu:removePermit", function(license)
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and distance < 3.0 then
		ESX.TriggerServerCallback("esx_license:getLicenses", function(licenses, name)
			for k,v in pairs(licenses) do
				if v.type == license then
					TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'inform', text = "You have removed a " .. license .." from ".. name})
					TriggerServerEvent("esx_license:removeLicense", GetPlayerServerId(closestPlayer), license)
					return
				end
			end
			TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "Person does not have this license" })
		end, GetPlayerServerId(closestPlayer))
	else
		TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "There is no player near-by" })
	end
end)


RegisterNetEvent("rpuk_playerMenu:checkTargetPermit")
AddEventHandler("rpuk_playerMenu:checkTargetPermit", function()
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and distance < 3.0 then
		ESX.TriggerServerCallback("esx_license:getLicenses", function(licenses, name)
			TriggerServerEvent("rpuk_playerMenu:checkTarget", GetPlayerServerId(closestPlayer), name)
		end, GetPlayerServerId(closestPlayer))
	else
		TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "There is no player near-by" })
	end
end)

RegisterNetEvent("rpuk_playerMenu:showPermits")
AddEventHandler("rpuk_playerMenu:showPermits", function()
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
	local job = ESX.Player.GetJobName()
	local grade = ESX.Player.GetJobGradeLabel()

	ESX.TriggerServerCallback("esx_license:getLicenses", function(licenses, name, age, charID, sessionID)
		if closestPlayer ~= -1 and distance < 3.0 then
			TriggerServerEvent("rpuk_playerMenu:showPlayers", GetPlayerServerId(closestPlayer), name, job, grade, age)
		else
			if licenses[1] == nil then
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "No licenses" })
			end
			local text = ""
			TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Name: ".. name })
			TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Age: ".. age })
			TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Citizen ID: ".. charID })
			TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Session ID: ".. sessionID })
			if job == "ambulance" then
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Occupation: National Health Service" })
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
			elseif job == "police" then
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Occupation: Los Santos Police Service" })
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
			elseif job == "lost" or job == "nca" then
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Occupation: Unemployed" })
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
			elseif job == "gruppe6" then
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Occupation: Gruppe 6" })
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
			elseif job == "court" then
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Occupation: Los Santos Ministry Of Justice" })
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Postion: ".. firstToUpper(grade) })
			else
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Occupation: ".. firstToUpper(job) })
			end
			for k,v in pairs(licenses) do
				TriggerEvent('mythic_notify:client:SendAlert', { length = 9000, type = 'info', text = "Licence: ".. v.label })
			end
		end
		if job == "police" then showIdAnim() end
	end, GetPlayerServerId(PlayerId()))
end)

RegisterCommand("c",function(source, args)
	if tostring(args[1]) == nil then
		return
	else
		if tostring(args[1]) ~= nil then
			local passed = tostring(args[1])

			if passed == 'hat' then
				if GetPedPropIndex(PlayerPedId(), 0) == -1 then -- not wearing any
					TriggerEvent('skinchanger:getSkin', function(oldData)
						if oldData.helmet_1 ~= -1 then
							startAnim("missfbi4", "takeoff_mask")
							SetPedPropIndex(PlayerPedId(), 0, oldData.helmet_1, oldData.helmet_2, 2)
						end
					end)
				else
					startAnim("missfbi4", "takeoff_mask")
					ClearPedProp(PlayerPedId(), 0)
				end
			elseif passed == "mask" then
				if GetPedDrawableVariation(PlayerPedId(), 1) == 0 then -- not wearing any
					TriggerEvent('skinchanger:getSkin', function(oldData)
						startAnim("missfbi4", "takeoff_mask")
						SetPedComponentVariation(PlayerPedId(), 1, oldData.mask_1, oldData.mask_2, 2)
					end)
				else
					startAnim("missfbi4", "takeoff_mask")
					SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
				end
			elseif passed == "glasses" then
				if GetPedPropIndex(PlayerPedId(), 1) == -1 then -- not wearing any
					TriggerEvent('skinchanger:getSkin', function(oldData)
						if oldData.glasses_1 ~= -1 then
							startAnim("clothingspecs", "try_glasses_positive_a")
							SetPedPropIndex(PlayerPedId(), 1, oldData.glasses_1, oldData.glasses_2, 2)
						end
					end)
				else
					startAnim("clothingspecs", "try_glasses_positive_a")
					ClearPedProp(PlayerPedId(), 1)
				end
			end
		end
	end
end, false)

RegisterNetEvent('rpuk:policeType')
AddEventHandler('rpuk:policeType', function(type)
	local vehicle, distance = ESX.Game.GetClosestVehicle()
	local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

	if type == "vehicleLookUp" then
		LookupVehicle()
	elseif type == "vehicle" and vehicle ~= 0 and vehicle ~= nil and distance < 5.0 then
		OpenVehicleInfosMenu(vehicleData)
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You are not close enough' })
		return
	end
end)

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		title = "Enter Registration Plate",
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Database Error' })
		else
			ESX.TriggerServerCallback('rpuk_wheel:getVehicleFromPlate', function(owner, found)
				if found then
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', length = 6000, text = 'Result Found - Vehicle Belongs To: '.. owner})
				else
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', length = 6000, text = 'No Results Found' })
				end
			end, data.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('rpuk_wheel:getVehicleInfos', function(retrivedInfo)
		local elements = {{label = 'PLATE: '..retrivedInfo.plate}}

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = 'Unknown Owner'})
		else
			table.insert(elements, {label = 'Vehicle is registered to: '.. retrivedInfo.owner})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title		= 'Vehicle Info',
			align		= 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, vehicleData.plate)
end

RegisterNetEvent('rpuk:panicAlarmForJudge')
AddEventHandler('rpuk:panicAlarmForJudge', function()
	if ESX.Player.GetJobName() == "court" then
		TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "panic", officerName = true})
		TriggerEvent('mythic_notify:client:SendAlert', {length = 7500, type = 'inform', text = 'You have activated your Panic Alarm, find yourself a safe location the police will be with you soon!' })
	end
end)

