local onJob, success, trailerEntityNetworkId, trailerEntityRawPlate, trailerEntityMaxBodyHealth = false, false, nil, nil, nil
local inMenu = false
local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }
local PlayerModel
local jobBlip

AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() and inMenu then
		ESX.UI.Menu.CloseAll()
	end
end)

local function mpMessage(type, large, small, time)
	local scaleform = RequestScaleformMovie("mp_big_message_freemode")
	while not HasScaleformMovieLoaded(scaleform) do Citizen.Wait(100) end

	BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieMethodParameterString(large)
	PushScaleformMovieMethodParameterString(small)
	PushScaleformMovieMethodParameterInt(time)
	EndScaleformMovieMethod()
	local timer = time

	if type == "fail" then
		PlaySoundFrontend(-1, "HACKING_FAILURE", 0, 1)
	elseif type == "success" then
		PlaySoundFrontend(-1, "HACKING_SUCCESS", 0, 1)
	end

	Citizen.CreateThread(function()
		while timer > 0 do
			Citizen.Wait(0)
			timer = timer - 10
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end
	end)
end

local function blipOff()
	RemoveBlip(jobBlip)
	jobBlip = nil
end

local function stopJob(call, m1, m2, m3, m4)
	mpMessage(call, m1, m2, 2000)
	if call == "success" then
		TriggerServerEvent("rpuk_deliveries:complated", onJob, success, m3, m4)
	end

	local trackedEntity = NetworkGetEntityFromNetworkId(trailerEntityNetworkId)
	if DoesEntityExist(trackedEntity) then ESX.Game.DeleteEntity(trackedEntity) end

	onJob, success, trailerEntityNetworkId, trailerEntityRawPlate, trailerEntityMaxBodyHealth = false, false, nil, nil, nil
	blipOff()
end

local function drawText(text, scale, x, y)
	BeginTextCommandDisplayText('STRING')
	SetTextColour(255, 255, 255, 255)
	SetTextFont(0)
	SetTextScale(scale, scale)
	SetTextRightJustify(true)
	SetTextWrap(0.0, x)
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
end

local function addBlip(coords, sprite)
	jobBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(jobBlip, sprite or 161)
	SetBlipRoute(jobBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Current Delivery")
	EndTextCommandSetBlipName(jobBlip)
end

local function showSubtitle(text, time)
	ClearPrints()
	BeginTextCommandPrint("STRING")
	AddTextComponentString(text)
	EndTextCommandPrint(time, true)
end

local function indicatorMarker(entity, time)
	local vCoords = GetEntityCoords(entity)
	local height = math.ceil(GetEntityHeightAboveGround(entity)) * 2
	local coords = vector3(vCoords.x, vCoords.y, vCoords.z + height)
	local timer = time

	while timer > 0 do
		Citizen.Wait(0)
		timer = timer - 10
		DrawMarker(0, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 116, 123,240, 100, true, true, 2, false, false, false, false)
	end
end

local function startFuelJob(passed_menu)
	if not onJob then
		onJob = true
		math.randomseed(GetGameTimer())

		if GetResourceKvpInt('spoken_with_ron') == 0 then
			SetResourceKvpInt('spoken_with_ron', 1)
			ESX.ShowAdvancedNotification("Contact Added", "Mr Ron", "", 'CHAR_MANUEL', 3, true, true)

			Citizen.Wait(3000)

			ESX.ShowAdvancedNotification("Mr Ron", "Hello Worker",
			"Hi, I own RON and see that you've signed up as a driver for us. Our missions are " ..
			"simple, just deliver fragile fuel trailers. You either buy or rent our trucks (don't forget to return them)." ..
			"~n~~n~Good luck!", 'CHAR_MANUEL', 1, false, true)

			Citizen.Wait(10000)

			local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId(), true)
			ESX.ShowAdvancedNotification("Mr Ron", "RE: Hello Worker", "Hello Mr Ron. Yes I am up for a mission right now, what do I do?", mugshotStr, 7, false, true)
			UnregisterPedheadshot(mugshot)
			Citizen.Wait(6000)
		end

		local jType = Config.Delivery.StartPoints[passed_menu].job_pool
		local randomDeliveryJobIndex = math.random(1, #(Config.Delivery.JobPool[jType]))
		local jobData = Config.Delivery.JobPool[jType][randomDeliveryJobIndex]
		local jobCoords = jobData.coords
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local travelDistanceToJobLocation = CalculateTravelDistanceBetweenPoints(playerCoords, jobCoords)
		local jobTime = jobData.time * 60
		local zoneNameFull = zones[GetNameOfZone(jobCoords.x, jobCoords.y, jobCoords.z)]
		local distance, min, sec, deliverLocationMsg, ready, trailerCurrentHealth, subtitleMsg
		local disableInteractions = false
		local jobPart = 1
		local returnCargoCoords = vector3(987.0, -2512.2, 27.3)

		if travelDistanceToJobLocation > 100000 then -- native failure point?
			print('CalculateTravelDistanceBetweenPoints() native fail point! using distance instead')
			local backupDistance = #(playerCoords - jobCoords)
			travelDistanceToJobLocation = backupDistance
		end

		ESX.ShowAdvancedNotification("RON Oil Delivery", "Job Started",
			"Are you our driver? Ok I've marked your cargo on the map. Attach it to your truck and then text me back. " ..
			"I'll setup the delivery route for you.", 'CHAR_MANUEL', 1, false, true)

		while onJob do
			Citizen.Wait(500)

			if IsPedInAnyVehicle(playerPed, false) then
				local bool, trailer = GetVehicleTrailerVehicle(GetVehiclePedIsIn(playerPed, false))
				showSubtitle('Attach the ~y~Cargo~s~', 500)

				-- is it the proper trailer? match from spawnVehicle
				if trailer > 0 and GetVehicleNumberPlateText(trailer) == trailerEntityRawPlate then
					blipOff()

					local mugshot, mugshotStr = ESX.Game.GetPedMugshot(playerPed, true)
					ESX.ShowAdvancedNotification("RON Oil Delivery", "Cargo Attached",
						"Hi I got the cargo attached now, where am I delivering it?", mugshotStr, 7, false, true)
					UnregisterPedheadshot(mugshot)
					break
				end
			else
				showSubtitle('Get in a truck, or rent one', 500)
			end
		end


		if not onJob then return end

		Citizen.Wait(5000)

		if zoneNameFull then
			deliverLocationMsg = ('You are delivering the cargo to %s, I\'ve updated your GPS. Make it in time!'):format(zoneNameFull)
			subtitleMsg = ('Deliver the ~y~Cargo~s~ to ~b~%s~s~'):format(zoneNameFull)
		else
			deliverLocationMsg = 'I\'ve updated your GPS, make it in time!'
			subtitleMsg = 'Deliver the ~y~Cargo~s~'
		end

		ESX.ShowAdvancedNotification("RON Oil Delivery", "Delivery Location", deliverLocationMsg, 'CHAR_MANUEL', 1, false, true)
		addBlip(jobCoords)

		Citizen.CreateThread(function()
			while onJob do
				Citizen.Wait(1000)
				playerPed = PlayerPedId()
				if jobTime > 0 then jobTime = jobTime - 1 end
				if jobTime == 0 then stopJob("fail", "Job Failed", "Out of time!") end

				local trailerEntity = NetworkGetEntityFromNetworkId(trailerEntityNetworkId)
				min, sec = ESX.SecondsToClock(jobTime)

				if DoesEntityExist(trailerEntity) then
					if jobPart == 1 then
						distance = #(GetEntityCoords(trailerEntity) - jobCoords)
					elseif jobPart == 2 then
						distance = #(GetEntityCoords(trailerEntity) - returnCargoCoords)
					end

					if not disableInteractions then
						trailerCurrentHealth = (GetVehicleBodyHealth(trailerEntity) / trailerEntityMaxBodyHealth)

						if trailerCurrentHealth < 0.1 then
							ESX.ShowAdvancedNotification("RON Oil Delivery", "You Idiot", 'What did you do?! It\'s precious cargo you idiot!', 'CHAR_MANUEL', 1, false, true)
							stopJob("fail", "Job Failed", "The trailer was damaged!")
						end
					end
				elseif not DoesEntityExist(trailerEntity) and not disableInteractions then
					ESX.ShowAdvancedNotification("RON Oil Delivery", "You Idiot", 'Where is the trailer?!', 'CHAR_MANUEL', 1, false, true)
					stopJob("fail", "Job Failed", "The trailer was lost!")
				end

				if not ready then ready = true end
			end
		end)

		while not ready do Citizen.Wait(500) end

		if not HasStreamedTextureDictLoaded('timerbars') then
			RequestStreamedTextureDict('timerbars')
			while not HasStreamedTextureDictLoaded('timerbars') do Citizen.Wait(100) end
		end

		while onJob do
			Citizen.Wait(0)
			drawTimerBar('Time Remaining:', ('%s:%s'):format(min, sec), 1)
			drawTimerBar('Cargo Health:', trailerCurrentHealth, 2, true)
			if subtitleMsg then showSubtitle(subtitleMsg, 0) end

			if jobPart == 1 then -- deliver back
				if distance < 100 then
					DrawMarker(1, jobCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.5, 6.5, 0.5, Config.Delivery.StartPoints[passed_menu].marker.colour.r, Config.Delivery.StartPoints[passed_menu].marker.colour.g, Config.Delivery.StartPoints[passed_menu].marker.colour.b, 100, false, true, 2, false, false, false, false)

					if distance < 10 and IsPedInAnyVehicle(playerPed, false) and not disableInteractions then
						ESX.ShowHelpNotification("Press ~INPUT_PICKUP~ to ~y~Offload Fuel~s~")

						if IsControlJustReleased(0, 38) then
							disableInteractions = true

							TriggerEvent("mythic_progbar:client:progress", {
								name = "deliver",
								duration = 20000,
								label = "Offloading Fuel",
								useWhileDead = false,
								canCancel = false,
								controlDisables = {disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true}
							}, function(canceled)
								if not canceled then
									blipOff()
									subtitleMsg = nil
									Citizen.Wait(2000)
									local mugshot, mugshotStr = ESX.Game.GetPedMugshot(playerPed, true)
									ESX.ShowAdvancedNotification("RON Oil Delivery", "Fuel Delivered",
										"Hi I've delivered the fuel, I will be returning now.", mugshotStr, 7, false, true)
									UnregisterPedheadshot(mugshot)

									Citizen.Wait(5000)
									ESX.ShowAdvancedNotification("RON Oil Delivery", "RE: Fuel Delivered",
										"We'll be expecting you to be back with the cargo safe and sound.", 'CHAR_MANUEL', 1, false, true)
									Citizen.Wait(2000)

									addBlip(returnCargoCoords)
									subtitleMsg = 'Return to the ~b~Delivery Hub~s~ and park the ~y~Cargo~s~'
									jobPart = 2
									Citizen.Wait(2000) -- arb wait for jobPart2 to set the distance back to the delivery hub
									disableInteractions = false
								end
							end)
						end
					end
				end
			elseif jobPart == 2 then -- deliver back
				if distance < 100 then
					DrawMarker(1, returnCargoCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.5, 6.5, 0.5, Config.Delivery.StartPoints[passed_menu].marker.colour.r, Config.Delivery.StartPoints[passed_menu].marker.colour.g, Config.Delivery.StartPoints[passed_menu].marker.colour.b, 100, false, true, 2, false, false, false, false)

					if distance < 10 and not disableInteractions then
						ESX.ShowHelpNotification("Press ~INPUT_PICKUP~ to Store ~y~Cargo~s~")

						if IsControlJustReleased(0, 38) then
							disableInteractions = true
							success = true
							stopJob("success", "Job Complete", "More bucks for the bank!", travelDistanceToJobLocation, "fuel")
						end
					end
				end
			end
		end
	end
end

local function startFoodJob(passed_menu)
	if not onJob then
		onJob = true
		math.randomseed(GetGameTimer())

		local jType = Config.Delivery.StartPoints[passed_menu].job_pool
		local randomLocation = math.random(1,#(Config.Delivery.JobPool[jType]))
		local jobLocation = Config.Delivery.JobPool[jType][randomLocation]
		local timer = ESX.Math.Round(#(Config.Delivery.StartPoints[passed_menu].location - jobLocation) / 3)
		addBlip(jobLocation)

		Citizen.CreateThread(function()
			while onJob and timer > 0 do
				Citizen.Wait(1000)
				if timer > 0 then timer = timer - 1 end
			end
		end)

		while onJob do
			Citizen.Wait(0)
			local coords = GetEntityCoords(PlayerPedId())
			local distance = #(coords - jobLocation)
			local min, sec = ESX.SecondsToClock(timer)

			showSubtitle(('Job Time Remaining: %s:%s'):format(min, sec), 0)

			if timer <= 0 then
				stopJob("fail", "Job Failed", "Out of time!")
			end

			if distance < 50 then
				DrawMarker(1, jobLocation, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, Config.Delivery.StartPoints[passed_menu].marker.colour.r, Config.Delivery.StartPoints[passed_menu].marker.colour.g, Config.Delivery.StartPoints[passed_menu].marker.colour.b, 100, false, true, 2, false, false, false, false)

				if distance < Config.Delivery.StartPoints[passed_menu].distance and not success then
					ESX.ShowHelpNotification("Press ~INPUT_PICKUP~ to ~y~Complete Delivery~s~")

					if IsControlJustReleased(0, 38) then
						TriggerEvent("mythic_progbar:client:progress", {
							name = "deliver",
							duration = 2000,
							label = "Delivering",
							useWhileDead = false,
							canCancel = false,
							controlDisables = {
								disableMovement = true,
								disableCarMovement = true,
								disableMouse = false,
								disableCombat = true,
							},
						}, function(status)
							if not status then
								success = true
								stopJob("success", "Job Complete", "More bucks for the bank!", distance)
							end
						end)
					end
				end
			end
		end
	end
end

function spawnJobVehicle(model, spawnCoords, indicatorLength, onlyCheckAvailableSpawnPoint)
	if model == "tanker" then
		for k,v in ipairs(Config.Delivery.TankerSpawns) do
			if ESX.Game.IsSpawnPointClear(v, 5.0) then
				if onlyCheckAvailableSpawnPoint then return true end

				spawnCoords = vector3(v.x, v.y, v.z)
				addBlip(spawnCoords)
				local spawnModel = GetHashKey('tanker')
				ESX.Streaming.RequestModel(spawnModel)
				local vehicle = CreateVehicle(spawnModel, spawnCoords, v.w, true, false)
				SetEntityAsMissionEntity(vehicle, true, false)
				SetModelAsNoLongerNeeded(spawnModel)
				local plate = GetVehicleNumberPlateText(vehicle)
				trailerEntityRawPlate = plate --set global var of trailer's plate to track later on
				trailerEntityMaxBodyHealth = GetVehicleBodyHealth(vehicle)
				trailerEntityNetworkId = NetworkGetNetworkIdFromEntity(vehicle) --set global var of trailer to track later on
				Citizen.CreateThread(function() indicatorMarker(vehicle, indicatorLength) end)
				return true
			end
		end
	elseif model == "packer" then
		for k,v in ipairs(Config.Delivery.TankerSpawns) do
			if ESX.Game.IsSpawnPointClear(v, 5.0) then
				if onlyCheckAvailableSpawnPoint then return true end

				ESX.Game.SpawnVehicle(model, vector3(v.x, v.y, v.z), v.w, function(vehicle)
					indicatorMarker(vehicle, indicatorLength)
				end, nil, {giveKeys = true})

				return true
			end
		end
	else
		if ESX.Game.IsSpawnPointClear(spawnCoords, 7) then
			if onlyCheckAvailableSpawnPoint then return true end

			ESX.Game.SpawnVehicle(model, vector3(spawnCoords.x, spawnCoords.y, spawnCoords.z), spawnCoords.h, function(vehicle)
				indicatorMarker(vehicle, indicatorLength)
			end, nil, {giveKeys = true})

			return true
		else
			return false
		end
	end

	return false
end

local function startHandler(passed_menu)
	if Config.Delivery.StartPoints[passed_menu].job_type == "food" then
		startFoodJob(passed_menu)
	elseif Config.Delivery.StartPoints[passed_menu].job_type == "fuel" then
		if spawnJobVehicle("tanker", nil, 300000) then
			startFuelJob(passed_menu)
		else
			ESX.ShowAdvancedNotification("RON Oil Delivery", "No spawn points available",
				"Hello driver, there is no spawn points available right now for your cargo.", 'CHAR_MANUEL', 1, false, true)
		end
	end
end

local function applyUniform(passed_menu)
	inMenu = true

	TriggerEvent('skinchanger:getSkin', function(dbData)
		if dbData.sex == 0 then
			PlayerModel = "male"
		else
			PlayerModel = "female"
		end
	end)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rpuk_delivjobUniform', {
		title		= "",
		css =	Config.Delivery.StartPoints[passed_menu].header,
		align		= 'top-left',
		elements = {
			{label = "Civilian Clothing", value = "civilian_clothing"},
			{label = "Assigned Work Uniform", value = "work_clothing"}
	}}, function(data, menu)
		if data.current.value == "civilian_clothing" then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == "work_clothing" then
			for index,data in pairs(Config.Delivery.StartPoints[passed_menu].clothing[PlayerModel]) do
				if data[1] == "comp" then
					SetPedComponentVariation(PlayerPedId(), index, data[2], data[3], data[4])
				elseif data[1] == "prop" then
					SetPedPropIndex(PlayerPedId(), index, data[2], data[3], data[4])
				end
			end
		end
	end, function(data, menu)
		menu.close()
		inMenu = false
	end)
end

local function openJobSelection(passed_menu)
	inMenu = true
	local elements = {}

	if onJob then
		table.insert(elements, {label = "Cancel All Jobs", value = "cancel_all"})
	else
		table.insert(elements, {label = "Start Delivery Job", value = "start_new"})
	end

	table.insert(elements, {label = "Uniform Options", value = "uniform"})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rpuk_delivJobSelect', {
		title		= "",
		css =	Config.Delivery.StartPoints[passed_menu].header,
		align		= 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value ~= nil then
			if data.current.value == "cancel_all" then
				ESX.UI.Menu.CloseAll()
				inMenu = false
				stopJob("cancel", "Job Cancelled", "It has been a stressful day, doing nothing...")
			elseif data.current.value == "start_new" then
				ESX.UI.Menu.CloseAll()
				inMenu = false
				startHandler(passed_menu)
			elseif data.current.value == "uniform" then
				applyUniform(passed_menu)
			end
		end
	end, function(data, menu)
		menu.close()
		inMenu = false
	end)
end

RegisterNetEvent("rpuk_jobs:rentcar")
AddEventHandler("rpuk_jobs:rentcar", function(menu)
	openRentVeh(menu)
end)

function openRentVeh(passed_menu)
	inMenu = true
	local elements = {}

	for index,data in ipairs(Config.Delivery.RentVehs[passed_menu].vehicles) do
		table.insert(elements, {
			label = ("%s - <span style='color:lightgreen;'>£%s</span>"):format(GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(data.model))), ESX.Math.GroupDigits(data.price)),
			value = data.model,
			spawn = data.spawn,
			price = data.price
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rpuk_delivRentcar', {
		title		= "",
		css =	Config.Delivery.RentVehs[passed_menu].header,
		align		= 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value ~= nil then
			if spawnJobVehicle(data.current.value, data.current.spawn, 10000, true) then
				ESX.TriggerServerCallback('rpuk_deliveries:rentVehicle', function(result)
					if result then
						spawnJobVehicle(data.current.value, data.current.spawn, 10000)
						ESX.ShowAdvancedNotification("FLEECA BANK", "Payment Authorised", "Thank you for banking with us.", 'CHAR_BANK_FLEECA', 9)
						ESX.UI.Menu.CloseAll()
						inMenu = false
					else
						ESX.ShowAdvancedNotification("FLEECA BANK", "Payment Declined", "Speak to a financial advisor by visiting your local branch.", 'CHAR_BANK_FLEECA', 9)
					end
				end, passed_menu, data.current.value)
			else
				ESX.ShowAdvancedNotification("RON Oil Delivery", "No spawn points available",
					"Hello driver, there is no spawn points available right now for your truck.", 'CHAR_MANUEL', 1, false, true)
			end
		end
	end, function(data, menu)
		menu.close()
		inMenu = false
	end)
end

function drawTimerBar(title, text, barIndex, isProgressBar)
	local safeZone = GetSafeZoneSize()
	local safeZoneX = (1.0 - safeZone) * 0.5
	local safeZoneY = (1.0 - safeZone) * 0.5
	local drawY = 0.984 - safeZoneY - barIndex * 0.038

	DrawSprite('timerbars', 'all_black_bg', 0.918 - safeZoneX, drawY, 0.165, 0.035, 0.0, 255, 255, 255, 160)
	drawText(title, 0.465, 0.918 - safeZoneX + 0.012, drawY - 0.009 - 0.00625)

	if isProgressBar then
		local pBarX = 0.918 - safeZoneX + 0.047
		local pBarY = drawY + 0.0015
		local width = 0.0616 * text

		DrawRect(pBarX, pBarY, 0.0616, 0.0105, 255, 0, 0, 255)
		DrawRect(pBarX - 0.0616 / 2 + width / 2, pBarY, width, 0.0105, 0, 255, 33, 255)
	else
		drawText(text, 0.425, 0.918 - safeZoneX + 0.0785, drawY + -0.0165)
	end
end

Citizen.CreateThread(function()
	for index,data in pairs(Config.Delivery.StartPoints) do
		if data.prop then
			local prop = GetHashKey(data.prop.model)
			local object = CreateObject(prop, data.prop.x, data.prop.y, data.prop.z, 0, 0, 1)
			SetEntityRotation(object, 0.0, 0.0, data.prop.h, 1, true)
			SetEntityCollision(object, true, true)
		end
	end

	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local canSleep = true

		-- Vehicle Renting --
		for index,data in pairs(Config.Delivery.RentVehs) do
			local distance = #(coords - data.location)

			if distance < data.marker.draw then
				DrawMarker(data.marker.type, data.location, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, data.marker.colour.r, data.marker.colour.g, data.marker.colour.b, 100, false, true, 2, false, false, false, false)

				if distance < 1.5 and not inMenu then
					ESX.ShowHelpNotification(data.hint)

					if IsControlJustReleased(0, 38) then
						openRentVeh(index)
					end
				end
				canSleep = false
			end
		end

		-- Vehicle Return --
		for index,data in pairs(Config.Delivery.RentVehs) do
			local distance = #(coords - data.rLocation)

			if distance < data.marker.draw and IsPedInAnyVehicle(PlayerPedId(), false) then
				DrawMarker(data.marker.type, data.rLocation, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 4.0, 4.0, 0.5, data.marker.colour.r, data.marker.colour.g, data.marker.colour.b, 100, false, true, 2, false, false, false, false)

				if distance < 3 and not inMenu then
					ESX.ShowHelpNotification("Press ~INPUT_PICKUP~ to ~y~Return the Rented Vehicle~s~")
					if IsControlJustReleased(0, 38) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
						for k, v in pairs(data.vehicles) do
							if GetHashKey(v.model) == GetEntityModel(vehicle) then
								if DoesEntityExist(vehicle) then
									ESX.Game.DeleteEntity(vehicle)
									TriggerServerEvent('rpuk_delivery:vehicleReturn')
								end
							end
						end
					end
				end
				canSleep = false
			end
		end

		-- Job Starting --
		for index,data in pairs(Config.Delivery.StartPoints) do
			local distance = #(coords - data.location)
			if distance < data.draw then
				ESX.Game.Utils.DrawText3D(data.location, data.hint, 1.0, 6)

				if distance < 1.5 and not inMenu then
					if IsControlJustReleased(0, 38) then
						openJobSelection(index)
					end
				end
				canSleep = false
			end
		end

		if canSleep then
			Citizen.Wait(500)
		end
	end
end)