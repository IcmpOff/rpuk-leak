local DrawDistance, Color = 100, {r = 255, g = 255, b = 255}
local inMenu, contJob, holding = false, false, {}

local HubMarkers = {
	["job_pickup"] = {
		position 	= vector3(1017.037, -2528.995, 27.302),
		req_job	 	= nil,
		req_grade 	= nil,
		help_notif	= "[~o~Civilians~s~]\nYou will need a Commercial Driver\'s Licence from the City Hall to sign on as a driver with us!\n\n[~b~Delivery Drivers~s~]\nPress ~INPUT_PICKUP~ To See Delivery Job Listings\n\n\n~c~You will need to source the products yourself (The shop wants apples? Go pick some apples!)",
		c_function	= "DeliveryService",
	},
	--[[["job_pickup2"] = {
		position 	= vector3(1018.891, -2511.627, 27.480),
		req_job	 	= nil,
		req_grade 	= nil,
		help_notif	= "[~o~Civilians~s~]\nYou will need a Commercial Driver\'s Licence from the City Hall to sign on as a driver with us!\n\n[~b~Delivery Drivers~s~]\nPress ~INPUT_PICKUP~ To See Delivery Job Listings\n\n\n~c~You will need to source the products yourself (The shop wants apples? Go pick some apples!)",
		c_function	= "DeliveryService",
	},	]]
}

local jobList = {
	["docks"] = { -- will itterate through these lists to find safe place to spawn trailer/vehicle
		0.57, --heading
		vector3(949.26,-3130.26,6.07),
		vector3(941.02,-3130.49,6.07),
		vector3(932.67,-3130.40,6.07),
		vector3(925.04,-3130.61,6.07),
	}
}

-- Draw ground interaction markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local canSleep = true

		for index,data in pairs(HubMarkers) do
			local distance = #(coords - data.position)

			if distance < DrawDistance then
				DrawMarker(1, data.position.x, data.position.y, data.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.0, Color.r, Color.g, Color.b, 100, false, false, 2, false, nil, nil, false)
				canSleep = false

				if distance < 1.5 and not inMenu and not guiEnabled then -- within zone
					ESX.ShowHelpNotification(data.help_notif)

					if IsControlJustReleased(0, 38) then
						point_handler(data.c_function)
					end
				end
			end
		end

		if contJob then
			for index,data in pairs(Config.DelivPoints) do
				local distance = #(coords - data[1])

				if distance < DrawDistance then
					DrawMarker(1, data[1].x, data[1].y, data[1].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 6.5, 6.5, 2.0, 100, 100, Color.b, 100, false, false, 2, false, false, false, false)
					canSleep = false

					if distance < 5.5 then -- within zone
						ESX.ShowHelpNotification("[~b~Delivery Drivers~s~]\nPress ~INPUT_PICKUP~ To Deliver Container/Goods")

						if IsControlJustReleased(0, 38) then
							point_handler("DeliveryGoodsIn")
						end
					end
				end
			end
		end

		if canSleep then
			Citizen.Wait(500)
		end
	end
end)

function point_handler(call) -- just handles the pressed E in zone function calls
	if call == "DeliveryService" then
		DeliveryService()
	elseif call == "DeliveryGoodsIn" then
		if contJob then -- container delivery
			for index,data in pairs(holding) do
				local close_trailer = GetClosestVehicle(GetEntityCoords(GetVehiclePedIsIn(PlayerPedId(),false)), 10.0, GetHashKey(holding[index]["vehicle"]), 0)
				if close_trailer then
					ESX.TriggerServerCallback('rpuk_stock:completeJob', function(result)
						if result then
							DeleteEntity(close_trailer)
							table.remove(holding, index)
							contJob = false
						end
					end, holding[index]["jobid"])
				end
			end
		else -- basic goods

		end
	end
end

function DeliveryService()
	inMenu = true
	elements = {}
	if ESX.Player.GetJobName() == 'delivery' then
		table.insert(elements, {label = "Job Selection", value = "job_selection"})
		table.insert(elements, {label = "Leave Service", value = "leave_service"})
	else
		table.insert(elements, {label = "Enter Service", value = "enter_service"})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jobEnteringShite', {
		title    = '',
		css =  'deliveryhub',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'enter_service' then
			ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
				if hasLicense then
					TriggerServerEvent('rpuk_core:setJob', "delivery", 1)
					ESX.ShowAdvancedNotification('Pegasus Delivery Services', 'Job Status', "You are now in service!", 'CHAR_PEGASUS_DELIVERY', 0)
					ESX.UI.Menu.CloseAll()
					inMenu = false
				else
					ESX.ShowAdvancedNotification('Pegasus Delivery Services', 'Licence Check', "~y~You need a Commercial Driver\'s Licence!~n~(Get one from the City Hall)", 'CHAR_PEGASUS_DELIVERY', 0)
					ESX.UI.Menu.CloseAll()
					inMenu = false
				end
			end, GetPlayerServerId(PlayerId()), 'drive_truck')
		elseif data.current.value == 'leave_service' then
			TriggerServerEvent('rpuk_core:setJob', "unemployed", 0)
			ESX.UI.Menu.CloseAll()
			inMenu = false
		elseif data.current.value == 'job_selection' then
			ESX.UI.Menu.CloseAll()
			inMenu = false
			EnableGui(true, "driver")
		end
	end, function(data, menu)
		menu.close()
		inMenu = false
	end)
end

--[[USAGE: containerJob(vehModel, endPoint(Name or v3 coords), SpawnList) ]]
function containerJob(trailer, endPoint, list, jid)
	for i=1, #jobList[list], 1 do
		if ESX.Game.IsSpawnPointClear(jobList[list][i+1], 3.0) then
			ESX.Game.SpawnVehicle(trailer, jobList[list][i+1], jobList[list][1], function(spawned_vehicle)
				table.insert(holding,{jobid = jid, vehicle = trailer}) -- adding the handle to the holding table for future use
			end)

			-- drawing route
			if type(endPoint) == "vector3" then -- exact coords
				SetNewWaypoint(jobList[list][i+1].x, jobList[list][i+1].y)
				ClearGpsMultiRoute()
				StartGpsMultiRoute(6, false, true)
				AddPointToGpsMultiRoute(jobList[list][i+1]) -- Spawned Trailer Location
				AddPointToGpsMultiRoute(endPoint) -- the end point
				SetGpsMultiRouteRender(true)
			else -- a shop name
				for index, data in pairs(Config.DelivPoints) do
					if tostring(index) == tostring(endPoint) then
						SetNewWaypoint(jobList[list][i+1].x, jobList[list][i+1].y)
						ClearGpsMultiRoute()
						StartGpsMultiRoute(6, false, true)
						AddPointToGpsMultiRoute(jobList[list][i+1]) -- Spawned Trailer Location
						AddPointToGpsMultiRoute(data[1]) -- the end point
						SetGpsMultiRouteRender(true)
						break
					end
				end
			end
			contJob = true
			break
		end
	end

	-- on veh delivery accept - spawn the car outside
	-- on new order generated // notify all on duty drivers. Cron job, to alert server-wide via tweet that jobs are available visit deliv hub etc to sign up
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for index,data in pairs(holding) do
			table.remove(holding, index)
		end
	end
end)