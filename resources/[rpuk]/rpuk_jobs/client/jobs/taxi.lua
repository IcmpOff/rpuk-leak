local OnJob, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, IsDead = false, false, false, false, false
local CurrentCustomer, CustomerJobDistance, CustomerVehicle, CurrentCustomerBlip, DestinationBlip, targetCoords

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

function ShowLoadingPromt(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(0)

		BeginTextCommandBusyspinnerOn('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandBusyspinnerOn(type)
		Citizen.Wait(time)

		BusyspinnerOff()
	end)
end

function GetRandomWalkingNPC()
	local search = {}
	local peds   = ESX.Game.GetPeds(ignoreList)

	for i=1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		for k,v in ipairs(search) do
			if ESX.Game.RequestNetworkControlOfEntity(v) then
				return v
			end
		end
	end

	for i=1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		for k,v in ipairs(search) do
			if ESX.Game.RequestNetworkControlOfEntity(v) then
				return v
			end
		end
	end
end

function ClearCurrentMission()
	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end

	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end

	CurrentCustomer           = nil
	CurrentCustomerBlip       = nil
	DestinationBlip           = nil
	IsNearCustomer            = false
	CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle    = false
	CustomerVehicle           = nil
	CustomerJobDistance       = nil
	targetCoords              = nil
end

function StartTaxiJob()
	ShowLoadingPromt('Taking service: for hire', 5000, 3)
	ClearCurrentMission()

	OnJob = true
end

function StopTaxiJob()
	local playerPed = PlayerPedId()

	ShowLoadingPromt('Ending service', 5000, 3)

	if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
		local vehicle = GetVehiclePedIsIn(playerPed,  false)
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

		if CustomerEnteredVehicle then
			TaskGoStraightToCoord(CurrentCustomer,  targetCoords.x,  targetCoords.y,  targetCoords.z,  1.0,  -1,  0.0,  0.0)
		end
	end

	ClearCurrentMission()
	OnJob = false
end

function OpenTaxiActionsMenu()
	local elements = {}

	if ESX.Player.GetJobName() ~= 'taxi' then
		table.insert(elements, {label = '<span style="color:yellow;">Go On Duty</span>', value = 'join_service'})
	else
		table.insert(elements, {label = '<span style="color:yellow;">Go Off Duty</span>', value = 'leave_service'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'selfhelpmenu', {
		title    = "Taxi Service",
		css =  'rpuk',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'join_service' then
			ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
				if hasLicense then
					TriggerServerEvent('rpuk_core:setJob', "taxi", 0)
					ESX.ShowAdvancedNotification('Taxi Service', 'Job Status', "~y~You are now in service!~n~(Use F6 when in a Taxi Vehicle)", 'CHAR_TAXI', 1)
					ESX.UI.Menu.CloseAll()
				else
					ESX.ShowAdvancedNotification('Taxi Service', 'Licence Check', "~y~You need a Taxi licence!~n~(Get one from the City Hall / Licence Shop)", 'CHAR_TAXI', 1)
					ESX.UI.Menu.CloseAll()
				end
			end, GetPlayerServerId(PlayerId()), 'taxi')
		elseif data.current.value == 'leave_service' then
			ESX.ShowAdvancedNotification('Taxi Service', 'Job Status', "~y~You are no longer in service!", 'CHAR_TAXI', 1)
			TriggerServerEvent('rpuk_core:setJob', "unemployed", 0)
			ESX.UI.Menu.CloseAll()
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx_taxijob:AdvancedNotif')
AddEventHandler('esx_taxijob:AdvancedNotif', function(message)
	Citizen.Wait(100)
	ESX.ShowAdvancedNotification('Taxi Service', 'Job Complete', "", 'CHAR_TAXI', 1)
end)

RegisterNetEvent('esx_taxijob:toggleNPCJob')
AddEventHandler('esx_taxijob:toggleNPCJob', function()
	if OnJob then
		StopTaxiJob()
	else
		if ESX.Player.GetJobName() == 'taxi' then
			local playerPed = PlayerPedId()
			local vehicle   = GetVehiclePedIsIn(playerPed, false)

			if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
				if ESX.Player.GetJobGrade() >= 3 then
					StartTaxiJob()
				else
					if IsInAuthorizedVehicle() then
						StartTaxiJob()
					else
						ESX.ShowNotification('You must be in a taxi vehicle to start a mission')
					end
				end
			else
				if ESX.Player.GetJobGrade() >= 3 then
					ESX.ShowNotification('You must be in a vehicle to begin the mission')
				else
					ESX.ShowNotification('You must be in a taxi vehicle to start a mission')
				end
			end
		end
	end
end)


function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #Config.Taxi.AuthorizedVehicles, 1 do
		if vehModel == GetHashKey(Config.Taxi.AuthorizedVehicles[i].model) then
			return true
		end
	end

	return false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true
		local coords = GetEntityCoords(PlayerPedId())
		local distance = #(coords - Config.Taxi.Zone.Pos)

		if distance < Config.Taxi.DrawDistance then
			canSleep = false
			DrawMarker(1, Config.Taxi.Zone.Pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.8, 255, 255, 255, 100, false, true, 2, false, false, false, false)

			if distance < 1.5 then
				ESX.Game.Utils.DrawText3D(vector3(Config.Taxi.Zone.Pos.x, Config.Taxi.Zone.Pos.y, Config.Taxi.Zone.Pos.z + 1.5), "Press [~y~E~s~] To Access Taxi Service", 0.8, 6)
				if IsControlJustReleased(0, 38) then
					OpenTaxiActionsMenu()
				end
			end
		end

		if canSleep then
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if not IsInAuthorizedVehicle() and OnJob and ESX.Player.GetJobName() == 'taxi' then

			local failed = true

			for i = 180, 1, -1 do -- 3mins max
				if (i > 15) and (i % 60 == 0) then
					ESX.ShowAdvancedNotification('Taxi Service', 'Job Status', string.format("You have %.0f minutes to get back in the taxi!", i/60), 'CHAR_TAXI', 1)
				elseif (i <= 15) and (i % 5 == 0) then
					ESX.ShowAdvancedNotification('Taxi Service', 'Job Status', string.format("You have %s seconds to get back in the taxi!", i), 'CHAR_TAXI', 1)
				end

				Citizen.Wait(1000) -- 1 sec

				if IsInAuthorizedVehicle() and OnJob and ESX.Player.GetJobName() == 'taxi' then
					failed = false
					break
				end
			end

			if failed then
				ESX.ShowAdvancedNotification('Taxi Service', 'Job Status', "Too late! All taxi service jobs stopped", 'CHAR_TAXI', 1)

				if IsPedSittingInVehicle(CurrentCustomer, CustomerVehicle) and GetEntitySpeed(CurrentCustomer) < 10 then
					if CustomerEnteredVehicle then
						TaskLeaveVehicle(CurrentCustomer, CustomerVehicle, 256)
						TaskWanderStandard(CurrentCustomer, 10, 10)
						SetEntityAsMissionEntity(CurrentCustomer, false, true)

						local scope = function(customer)
							Citizen.SetTimeout(30000, function()
								DeletePed(customer)
							end)
						end

						scope(CurrentCustomer)

					end
				end

				ClearCurrentMission()
				OnJob = false
			else
				ESX.ShowAdvancedNotification('Taxi Service', 'Job Status', "You made it. The taxi service continues...", 'CHAR_TAXI', 1)
			end

		end
	end
end)

-- Taxi Job
Citizen.CreateThread(function()
	local customerGetInTimer = 0
	local customerUnavailable = false
	local customerStandTimer = 0

	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		if OnJob then
			if CurrentCustomer == nil then
				DrawSub('Drive around and find someone that needs a ~y~ride~s~', 5000)

				if IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then

					local waitUntil = GetGameTimer() + GetRandomIntInRange(30000, 45000) -- 30-45 secs
					while OnJob and waitUntil > GetGameTimer() and not customerUnavailable do
						Citizen.Wait(0)
					end

					if OnJob and IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then

						CurrentCustomer = GetRandomWalkingNPC()

						if CurrentCustomer ~= nil then
							customerUnavailable = false

							CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

							SetBlipAsFriendly(CurrentCustomerBlip, true)
							SetBlipColour(CurrentCustomerBlip, 2)
							SetBlipCategory(CurrentCustomerBlip, 3)
							SetBlipRoute(CurrentCustomerBlip, true)

							SetEntityAsMissionEntity(CurrentCustomer, true, false)
							ClearPedTasksImmediately(CurrentCustomer)
							SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)

							local standTime = GetRandomIntInRange(60000, 180000) --ped will wait between 1 and 3 mins for pickup.
							TaskStandStill(CurrentCustomer, standTime)
							customerStandTimer = GetGameTimer() + standTime
							ESX.ShowNotification('You have found a client')
							PlaySoundFrontend(-1, "MP_5_SECOND_TIMER", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
						else
							-- failed to find a viable customer target.
							customerUnavailable = true
						end
					end
				end
			else
				--Customer in play...CurrentCustomer is true
				--customer died or timed-out standing still; get rid
				if IsPedFatallyInjured(CurrentCustomer) or (customerStandTimer < GetGameTimer() and not CustomerIsEnteringVehicle) then
					if IsPedFatallyInjured(CurrentCustomer) then
						ESX.ShowNotification('Your client is unconscious. Look for another one')
					else
						ESX.ShowNotification('Your client has given up. Look for another one')
						TaskWanderStandard(CurrentCustomer, 10, 10)
					end

					if DoesBlipExist(CurrentCustomerBlip) then RemoveBlip(CurrentCustomerBlip) end
					if DoesBlipExist(DestinationBlip) then RemoveBlip(DestinationBlip) end

					SetEntityAsMissionEntity(CurrentCustomer, false, true)
					CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, CustomerVehicle, CustomerJobDistance, targetCoords = nil, nil, nil, false, false, false, nil, nil, nil
				end

				--is the player driving?
				if IsPedInAnyVehicle(playerPed, false) then
					local vehicle          = GetVehiclePedIsIn(playerPed, false)
					local playerCoords     = GetEntityCoords(playerPed)
					local customerCoords   = GetEntityCoords(CurrentCustomer)
					local customerDistance = #(playerCoords - customerCoords)

					--is the customer in or getting in the car?
					if IsPedSittingInVehicle(CurrentCustomer, vehicle) then

						--is customer finished getting in?
						if CustomerEnteredVehicle then
							local targetDistance = #(playerCoords - targetCoords)

							--if math.random() < 0.75 then  --one day I will work this shit out!
							--TASK::TASK_CHAT_TO_PED(iLocal_851, Local_410.f_3, 16, 0f, 0f, 0f, 0f, 0f);
								--TaskChatToPed(0, CurrentCustomer, 16, 0.0, 0.0, 0.0, 0.0, 0.0)
								--TaskUseMobilePhone(CurrentCustomer,1,1)
							--else
								--SetPedTalk(CurrentCustomer)
							--end

							--are we at customer's destination?
							if targetDistance < 10 then
								TaskLeaveVehicle(CurrentCustomer, vehicle, 0)

								ESX.ShowNotification('You have arrived at your destination')

								TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
								TaskWanderStandard(CurrentCustomer, 10, 10)
								SetEntityAsMissionEntity(CurrentCustomer, false, true)
								TriggerServerEvent('esx_taxijob:successfulpayoutt', CustomerJobDistance)
								RemoveBlip(DestinationBlip)

								local scope = function(customer)
									Citizen.SetTimeout(30000, function()
										DeletePed(customer)
									end)
								end

								scope(CurrentCustomer)

								CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, CustomerVehicle, CustomerJobDistance, targetCoords = nil, nil, nil, false, false, false, nil, nil, nil
							end

							if targetCoords then
								DrawMarker(36, targetCoords.x, targetCoords.y, targetCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)
							end
						else

							--customer has just now got in car
							RemoveBlip(CurrentCustomerBlip)
							CurrentCustomerBlip = nil
							targetCoords = Config.Taxi.JobLocations[GetRandomIntInRange(1, #Config.Taxi.JobLocations)]
							local distance = #(playerCoords - targetCoords)

							while distance < Config.Taxi.MinimumDistance do
								Citizen.Wait(5)

								targetCoords = Config.Taxi.JobLocations[GetRandomIntInRange(1, #Config.Taxi.JobLocations)]
								distance = #(playerCoords - targetCoords)
							end

							CustomerJobDistance = distance

							local street = table.pack(GetStreetNameAtCoord(targetCoords.x, targetCoords.y, targetCoords.z))
							local msg

							if street[2] ~= 0 and street[2] ~= nil then
								msg = ('Take me to %s, near %s'):format(GetStreetNameFromHashKey(street[1]), GetStreetNameFromHashKey(street[2]))
							else
								msg = ('Take me to %s'):format(GetStreetNameFromHashKey(street[1]))
							end

							ESX.ShowNotification(msg)

							DestinationBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

							BeginTextCommandSetBlipName('STRING')
							AddTextComponentSubstringPlayerName('Destination')
							EndTextCommandSetBlipName(blip)
							SetBlipRoute(DestinationBlip, true)

							CustomerEnteredVehicle = true
						end
					else

						--customer ped is not yet in the taxi
						DrawMarker(36, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)

						if not CustomerEnteredVehicle then
							if customerDistance <= 40.0 then

								if not IsNearCustomer then
									ESX.ShowNotification('You are too far from the client, get closer to them')
									IsNearCustomer = true
								end

							end

							if customerDistance <= 20.0 then
								if not CustomerIsEnteringVehicle then
									ClearPedTasksImmediately(CurrentCustomer)

									local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

									for i=maxSeats - 1, 0, -1 do
										if IsVehicleSeatFree(vehicle, i) then
											freeSeat = i
											break
										end
									end

									if freeSeat then
										TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
										CustomerIsEnteringVehicle = true
										CustomerVehicle = vehicle
										customerGetInTimer = GetGameTimer() + 60000 -- 1 minute allowed for this
									end
								else
									--CustomerIsEnteringVehicle is true, but something stopped the customer getting in
									if customerGetInTimer > GetGameTimer() then
										if not GetIsTaskActive(CurrentCustomer, 160) then
											-- CTaskEnterVehicle isn't still running, presumably cancelled by interruption, accident
											TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0) -- try again
										end
									else
										-- customer is blocked or stuck for 1 minute; give up this attempt
										ESX.ShowNotification('Your client has given up. Look for another one')

										if DoesBlipExist(CurrentCustomerBlip) then
											RemoveBlip(CurrentCustomerBlip)
										end

										if DoesBlipExist(DestinationBlip) then
											RemoveBlip(DestinationBlip)
										end

										TaskWanderStandard(CurrentCustomer, 10, 10)
										SetEntityAsMissionEntity(CurrentCustomer, false, true)
										CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, CustomerVehicle, CustomerJobDistance, targetCoords = nil, nil, nil, false, false, false, nil, nil, nil
									end
								end
							end
						end
					end
				else
					DrawSub('Please return to your vehicle to continue the mission', 5000)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)