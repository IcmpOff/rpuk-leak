local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta",
['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach",
['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton",
['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills",
['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats",
['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta",
['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood",
['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse",
['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society",
['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony",
['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research",
['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir",
['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa",
['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic",
['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights",
['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove",
['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands",
['PALMPOW'] = "Palmer-Taylor Power Station",['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill",
['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen",
['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas",
['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row",['SLAB'] = "Stab City",
['STAD'] = "Maze Bank Arena",['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal",
['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals",
['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood",
['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

-- Hide hud
local showUI = true -- UI Toggle
local isSeatbeltOn = false -- Seatbelt toggle
local isInCarState = false
local currSpeed = 0.0
local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
local seatbeltEjectSpeed = 45 / 2.237 --MPH
local seatbeltEjectAccel = 100 * 9.81
local oxygenTank = 50.0
local attachedProp = 0
local attachedProp2 = 0
local scubaClothes = true
local oxyAlert = false
local invehicle = false
local showLocationHud = false

SetBlipAlpha(GetNorthRadarBlip(), 0)--Gets Rid of North icon on minimap

function GetMinimapAnchor()
	local safezone = GetSafeZoneSize()
	local safezone_x = 1.0 / 20.0
	local safezone_y = 1.0 / 20.0
	local aspect_ratio = GetAspectRatio(0)
	if aspect_ratio > 2 then aspect_ratio = 16/9 end
	local res_x, res_y = GetActiveScreenResolution()
	local xscale = 1.0 / res_x
	local yscale = 1.0 / res_y
	local Minimap = {}
	Minimap.width = xscale * (res_x / (4 * aspect_ratio))
	Minimap.height = yscale * (res_y / 5.674)
	Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
	if GetAspectRatio(0) > 2.37 then
		Minimap.left_x = Minimap.left_x + Minimap.width * 0.91
		Minimap.width = Minimap.width * 0.75
	elseif GetAspectRatio(0) > 2.36 then
		Minimap.left_x = Minimap.left_x + Minimap.width * 0.89
		Minimap.width = Minimap.width * 0.75
	elseif GetAspectRatio(0) > 2 then
		Minimap.left_x = Minimap.left_x + Minimap.width * 0.845
		Minimap.width = Minimap.width * 0.76
	elseif GetAspectRatio(0) > 1.8 then
		Minimap.left_x = Minimap.left_x + Minimap.width * 0.2225
		Minimap.width = Minimap.width * 0.995
	end
	Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
	Minimap.right_x = Minimap.left_x + Minimap.width
	Minimap.top_y = Minimap.bottom_y - Minimap.height
	Minimap.x = Minimap.left_x
	Minimap.y = Minimap.top_y
	Minimap.xunit = xscale
	Minimap.yunit = yscale
	return Minimap
end

function anim_state(ped)
	local anim_data = {}
	anim_data[1] = IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3)
	anim_data[2] = IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3)
	anim_data[3] = IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3)
	return anim_data
end

function removeAttachedProp2()
	DeleteEntity(attachedProp2)
	attachedProp2 = 0
end

function removeAttachedProp()
	DeleteEntity(attachedProp)
	attachedProp = 0
end

function getOxygenStatus()
	return oxygenTank
end

function attachProp2(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp2()
	local ped = PlayerPedId()
	local attachModel = GetHashKey(attachModelSent)
	local bone = GetPedBoneIndex(ped, boneNumberSent)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp2 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp2, ped, bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function attachProp(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	local ped = PlayerPedId()
	local attachModel = GetHashKey(attachModelSent)
	local bone = GetPedBoneIndex(ped, boneNumberSent)

	RequestModel(attachModel)

	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end

	attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp, ped, bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

RegisterNetEvent('rpuk_hud:toggleHud')
AddEventHandler("rpuk_hud:toggleHud", function(state)
	showUI = state or false
end)

RegisterNetEvent("useOxygenTank")
AddEventHandler("useOxygenTank", function()
	oxygenTank = 100.0
end)

RegisterNetEvent("removeOxygenTank")
AddEventHandler("removeOxygenTank", function()
	if oxygenTank > 50.0 then
		oxygenTank = 50.0
	end
end)

AddEventHandler('esx_status:onStatusChange', function(name, value)
	SendNUIMessage({
		action = 'setStatusValue',
		name = name,
		value = value
	})
end)

--Health/Armor/O2/minimap_pos
Citizen.CreateThread(function()
	local ui = GetMinimapAnchor()

	while true do
		Citizen.Wait(200)

		local playerPed = PlayerPedId()
		local health = GetEntityHealth(playerPed) - 100
		local armor = GetPedArmour(playerPed)

		SendNUIMessage({
			action = 'updateStatusHud',
			show = showUI,
			health = health,
			armour = armor,
			oxygenLevel = oxygenTank,
			bwidth = ui.width,
			bottomy = ui.bottom_y,
			rightx = ui.right_x,
			leftx = ui.left_x,
		})

		if oxygenTank > 0 and IsPedSwimmingUnderWater(playerPed) then
			SetPedDiesInWater(playerPed, false)
			if oxygenTank > 50.0 then
				oxygenTank = oxygenTank - 0.1
			else
				oxygenTank = oxygenTank - 0.3
			end
		else
			SetPedDiesInWater(playerPed, true)
		end

		if not IsPedSwimmingUnderWater(playerPed) and oxygenTank < 50.0 then
			oxygenTank = oxygenTank + 1.0
			if oxygenTank > 50.0 then
				oxygenTank = 50.0
			end
		end

		if oxygenTank > 50.0 and scubaClothes then
			attachProp("p_s_scuba_tank_s", 24818, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0)
			attachProp2("p_s_scuba_mask_s", 12844, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0)
			scubaClothes = false
			oxyAlert = true
		elseif oxygenTank <= 50.0 and not scubaClothes then
			removeAttachedProp()
			removeAttachedProp2()
			scubaClothes = true
		elseif oxygenTank <= 50.0 and oxyAlert then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Your air tank is now empty' })
			oxyAlert = false
		end
	end
end)

function getDirectionFromHeading(heading)
	if heading >= 315 or heading < 45 then
		return "North"
	elseif heading >= 45 and heading < 135 then
		return "West"
	elseif heading >=135 and heading < 225 then
		return "South"
	elseif heading >= 225 and heading < 315 then
		return "East"
	end
end

--Location/Heading
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		showLocationHud = IsRadarEnabled() and not IsPauseMenuActive()

		if showLocationHud then
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local zoneNameFull = zones[GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z)]
			local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z))
			local locationMsg
			local heading = getDirectionFromHeading(GetEntityHeading(playerPed))

			if zoneNameFull then
				locationMsg = heading .. ' | ' .. streetName .. ', ' .. zoneNameFull
			else
				locationMsg = streetName.. ' | ' .. heading
			end

			SendNUIMessage({ action = 'locationHud', Message = locationMsg, locationToggle = true})
		else
			SendNUIMessage({ action = 'locationHud', Message = "", locationToggle = false})
		end
	end
end)

-- CompassRotation
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)

		if showLocationHud then
			local playerPed = PlayerPedId()
			SendNUIMessage({action = 'locationHud', rotate = GetEntityHeading(playerPed), locationToggle = true})
		else
			Citizen.Wait(500)
		end
	end
end)

--Speed
Citizen.CreateThread(function()
	local lastSpeed = 0

	while true do
		Citizen.Wait(100)
		local playerPed = PlayerPedId()
		local inVehicle = IsPedInAnyVehicle(playerPed, false)

		if inVehicle then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			local carSpeed
			local fuelLevel = GetVehicleFuelLevel(vehicle)
			local isVehicleDriver = playerPed == GetPedInVehicleSeat(vehicle, -1)
			local vehicleClass = GetVehicleClass(vehicle)
			local engineRunning = GetIsVehicleEngineRunning(vehicle)
			local vehicleSpeed = GetEntitySpeed(vehicle)
			local speedType

			if vehicleClass == 14 or vehicleClass == 15 or vehicleClass == 16 then -- boats, helicopters & planes
				carSpeed = vehicleSpeed * 2.24
				speedType = "KNOT"
			elseif ShouldUseMetricMeasurements() then
				carSpeed = vehicleSpeed * 3.8
				speedType = "KM/H"
			else
				carSpeed = vehicleSpeed * 2.436
				speedType = "MPH"
			end

			if isVehicleDriver and vehicleClass ~= 13 and engineRunning and lastSpeed ~= carSpeed then
				SendNUIMessage({
					action = 'car',
					showcarhud = true,
					speed = carSpeed,
					speedType = speedType,
					fuel = fuelLevel,
				})

				lastSpeed = carSpeed
			elseif not isVehicleDriver and not engineRunning then
				SendNUIMessage({
					action = 'car',
					showcarhud = false,
				})

				lastSpeed = carSpeed
			elseif inVehicle and not engineRunning then
				SendNUIMessage({
					action = 'car',
					showcarhud = false,
				})
			end

			isInCarState = false
		elseif not inVehicle and not isInCarState then
			SendNUIMessage({
				action = 'car',
				showhud = false,
			})

			isInCarState = true
		else
			Citizen.Wait(500)
		end
	end
end)

--- Seatbelt
Citizen.CreateThread(function()
	local lastSeatbeltState = false
	local heldFKey = 0

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local isInVehicle = IsPedInAnyVehicle(playerPed, false)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleClass = GetVehicleClass(vehicle)
		local whitelist = (vehicleClass ~= 13 and vehicleClass ~= 8 and vehicleClass ~= 15 and vehicleClass ~= 16 and vehicleClass ~= 14)
		local playerInCar = isInVehicle and whitelist
		local animStateData = anim_state(playerPed)

		DisableControlAction(0, 75) -- control exit vehicle

		if not invehicle and playerInCar then
			invehicle = true
			TriggerEvent("InteractSound_CL:PlayOnOne","beltalarm",0.35)
		end

		if playerInCar and not animStateData[2] then
			if IsControlJustReleased(0, 311) and not animStateData[2] then
				isSeatbeltOn = not isSeatbeltOn

				if isSeatbeltOn then
					TriggerEvent("InteractSound_CL:PlayOnOne","seatbelt",0.5)
				else
					TriggerEvent("InteractSound_CL:PlayOnOne","seatbeltoff",0.8)
				end
			end

			if isSeatbeltOn then
				SendNUIMessage({
					action = 'seatbelt',
					showSeatbelt = true,
				})

				prevVelocity = GetEntityVelocity(vehicle)
				lastSeatbeltState = true
			else
				local prevSpeed = currSpeed
				if lastSeatbeltState then prevSpeed = GetEntitySpeed(vehicle) end
				lastSeatbeltState = false
				local position = GetEntityCoords(playerPed)
				currSpeed = GetEntitySpeed(vehicle)
				prevVelocity = GetEntityVelocity(vehicle)
				local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
				local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()

				if vehIsMovingFwd and prevSpeed > seatbeltEjectSpeed and vehAcc > seatbeltEjectAccel then
					SetEntityCoords(playerPed, position.x, position.y, position.z - 0.47, true, true, true)
					SetEntityVelocity(playerPed, prevVelocity.x, prevVelocity.y, prevVelocity.z)
					Citizen.Wait(1)
					SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
					SetPedConfigFlag(playerPed, 32, true)
				else
					SetPedConfigFlag(playerPed, 32, false)
					prevVelocity = GetEntityVelocity(vehicle)
				end

				SendNUIMessage({
					action = 'seatbelt',
					showSeatbelt = false,
				})
			end
		else
			SendNUIMessage({
				action = 'seatbelt',
				showSeatbelt = true,
			})

			isSeatbeltOn = false
			invehicle = false
			Citizen.Wait(500)
		end

		if isInVehicle then
			if IsDisabledControlPressed(0, 75) then heldFKey = heldFKey + 1 else heldFKey = 0 end

			if (IsDisabledControlJustReleased(0, 75) or heldFKey > 25) and isInVehicle and UpdateOnscreenKeyboard() ~= 0 then
				local isVehicleLocked = GetVehicleDoorsLockedForPlayer(vehicle, playerPed)
				local _isSeatBeltOn = isSeatbeltOn or animStateData[2]

				if _isSeatBeltOn and isVehicleLocked then
					ESX.ShowNotification('Your seat belt is holding you tight, and the vehicle is locked')
				elseif isVehicleLocked then
					ESX.ShowNotification('This vehicle is locked, you cannot exit it')
				elseif _isSeatBeltOn then
					ESX.ShowNotification('Your seat belt is holding you tight')
				else
					if heldFKey > 25 then
						SetVehicleEngineOn(vehicle, true, true, false)
					end

					TaskLeaveVehicle(playerPed, vehicle, 0)
				end
			end
		end

	end
end)

