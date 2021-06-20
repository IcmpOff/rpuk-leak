Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		for i=1, #Config.Standard, 1 do
			if Config.Standard[i].spawnedFlag == false then
				if GetDistanceBetweenCoords(coords, Config.Standard[i].x, Config.Standard[i].y,Config.Standard[i].z, true) < Config.Standard[i].spawnDistance then
					WaitForModel(Config.Standard[i].model)
					local pedHandle = CreatePed(5, Config.Standard[i].model, Config.Standard[i].x, Config.Standard[i].y,Config.Standard[i].z , Config.Standard[i].h, false)
					SetEntityAsMissionEntity(pedHandle, true, true)
					SetBlockingOfNonTemporaryEvents(pedHandle, true)
					SetModelAsNoLongerNeeded(Config.Standard[i].model)

					--Fix casino model peds
					if Config.Standard[i].model == "s_m_y_casino_01" then
						local randomVar = math.random(1,3)
						if randomVar == 1 then
							SetPedDefaultComponentVariation(pedHandle)
							SetPedComponentVariation(pedHandle, 3, 0, 1, 0)
							SetPedComponentVariation(pedHandle, 8, 0, 0, 0)-- The top
							SetPedComponentVariation(pedHandle, 11, 3, 0, 0)
						elseif randomVar == 2 then
							SetPedDefaultComponentVariation(pedHandle)
							SetPedComponentVariation(pedHandle, 3, 0, 1, 0)
							SetPedComponentVariation(pedHandle, 8, 0, 1, 0)-- The top
							SetPedComponentVariation(pedHandle, 11, 0, 0, 0)
						else
							SetPedDefaultComponentVariation(pedHandle)
							SetPedComponentVariation(pedHandle, 3, 2, 0, 0)
							SetPedComponentVariation(pedHandle, 8, 1, 0, 0)-- The top
							SetPedComponentVariation(pedHandle, 11, 1, 0, 0)
							SetPedComponentVariation(pedHandle, 10, 1, 0, 0)
						end
					end

					if Config.Standard[i].godmode == true then
						SetEntityCanBeDamaged(pedHandle, true)
						FreezeEntityPosition(pedHandle, true)
					end
					if Config.Standard[i].scen then
						TaskStartScenarioInPlace(pedHandle, Config.Standard[i].scen, 0, true)
					end

					Config.Standard[i].spawnedFlag = true -- Once spawned, set the spawned flag to true to ignore them in next run
				end
			end
		end
		for i=1, #Config.Interations, 1 do
			if Config.Interations[i].spawnedFlag == false then
				if GetDistanceBetweenCoords(coords, Config.Interations[i].x, Config.Interations[i].y,Config.Interations[i].z, true) < Config.Interations[i].spawnDistance then
					WaitForModel(Config.Interations[i].model)
					local pedHandle = CreatePed(5, Config.Interations[i].model, Config.Interations[i].x, Config.Interations[i].y,Config.Interations[i].z , Config.Interations[i].h, false)
					SetEntityAsMissionEntity(pedHandle, true, true)
					SetBlockingOfNonTemporaryEvents(pedHandle, true)
					SetModelAsNoLongerNeeded(Config.Interations[i].model)
					if Config.Interations[i].godmode == true then
						SetEntityCanBeDamaged(pedHandle, false)
						FreezeEntityPosition(pedHandle, true)
					end
					if Config.Interations[i].scen then
						TaskStartScenarioInPlace(pedHandle, Config.Interations[i].scen, 0, true)
					end
					Config.Interations[i].spawnedFlag = true -- Once spawned, set the spawned flag to true to ignore them in next run
					--print("RPUK DEBUG: " .. tostring(Config.Interations[i].spawnedFlag))
				end
			end
		end
	Citizen.Wait(5000)
	end
end)

WaitForModel = function(model_input)
	model = GetHashKey(model_input)
    if not IsModelValid(model) then
        return
    end
	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	while not HasModelLoaded(model) do
		Citizen.Wait(1000)
	end
end

local blackmoneyAmount, hasMoneyCheck = 0, false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local canSleep = true
		for i=1, #Config.Interations, 1 do
			if GetDistanceBetweenCoords(coords, Config.Interations[i].x, Config.Interations[i].y,Config.Interations[i].z, true) < Config.Interations[i].textDistance then
				canSleep = false
				local VectorCoords = vector3(Config.Interations[i].x, Config.Interations[i].y, Config.Interations[i].z+1.3)
				if blackmoneyAmount > 0 and Config.Interations[i].interactionType == "BlackMarket" then
					ESX.Game.Utils.DrawText3D(VectorCoords, "Launder", 0.5, 6)
					if IsControlJustReleased(0, 38) then
						TriggerEvent('rpuk_shops:remoteAccess',Config.Interations[i].interactionType)
					end
				end
				if Config.Interations[i].interactionType == "tutorial" then
					ESX.Game.Utils.DrawText3D(VectorCoords, "[E] Speak", 0.5, 6)
					if IsControlJustReleased(0, 38) then
						speakToNPC(Config.Interations[i].tutorialType)
					end
				end
				if Config.Interations[i].interactionType == "shop" then
					ESX.Game.Utils.DrawText3D(VectorCoords, "[E] Speak", 0.5, 6)
					if IsControlJustReleased(0, 38) then
						TriggerEvent('rpuk_shops:remoteAccess', Config.Interations[i].shopType)
					end
				end
			end
		end
		if canSleep then
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if hasMoneyCheck then
			Citizen.Wait(5000 * math.random(10,20))
			hasMoneyCheck = false
		end
	end
end)

function speakToNPC(tutorial)
	local message
	if tutorial == "pinkcage" then
		message = "Ello mate! <br><br> I guess its your first time in Los Santos, if so I can help you to get started! Here in Los Santos we need to start with the basics! <br><br> I would recommend taking a trip to the City Hall where you will find infomation about licences and jobs in the city. I've sent you the address on your GPS! <br><br> If you have any questions Twitter is a good place to start, a lot of helpful people around willing to answer questions! <br><br> Oh and don't forgot to check the tourist brochure in your pocket, has some more info! <br><br> (OOC: Try pressing CAPS, F2 and F3 to interact with the world, press F5 for controls)"
		SetNewWaypoint(-552.449, -191.255)
	elseif tutorial == "cityhall" then
		message = "Welcome to the Los Santos City Hall! <br><br> The City Hall acts as our job hub and licensing centre. From here you can purchase licenses that enable you to perform jobs around the city. <br><br> The mechanic, taxi and delivery driver license allow you to pick up work from these three core jobs in the city. <br><br> So get yourself a license and head down to appropiate HQ for your new job (Impound Lot, Taxi Hub, Delivery Hub). <br><br> If you don't have the money to spend you can start off by doing a license-free job like Food Deliveries or Mining, marked on your map. <br><br> If you are interested in a career within the Police or NHS visit wiki.roleplay.co.uk/GTA."
	elseif tutorial == "prison" then
		message = "Just arrived, huh? <br><br> Well, in here things work in a certain way lad, and its time you adjust. First of all, you can check your sentence at the phoneboxes at the far end of the block. <br><br>  Additionally, if you help out with odd jobs like cleaning tables and doing dishes you can lower your sentence by a decent amount. <br><br> If you instead want to take a good long nap, that's another way to spend your time in here. <br><br> (OOC: Use the CAPS key to interact)"
	elseif tutorial == "mechanic" then
		message = "Hey buddy! You look a tad bit confused. <br><br> How about you clock in and get yourself a tow truck? <br><br> When you've done that it's time to take your first job and get to work. <br><br> (OOC: Use the CAPS key to reach job interactions)"
	elseif tutorial == "mining" then
		message = "You alright fella? <br><br> You'll need some tools to work here, you can get them from most general stores. After you've got that it's time to get to work! <br><br> When you're done mining you'll have to head to the smeltery in Los Santos and lastly to T.B.J Jewellers or The White Company to sell."
	elseif tutorial == "taxi" then
		message = "Hola Amigo! <br><br> You wanna earn some extra cash? It's easy! Head into the boss' office and clock in, then get a cab from the garage up the stairs and get driving."
	elseif tutorial == "fooddelivery" then
		message = "How’s it going? <br><br> What would you say about doing some food deliveries? We're running a bit short on people at the moment. <br><br>Just walk up to that board over there and get delivering. You can rent a car to the right of the board."
	elseif tutorial == "commercial" then
		message = "Yalright? <br><br>If you're here to do some delivery jobs just head over there and rent a lorry, then go take a job over at the board. <br><br> If you've got the license you can also do deliveries for the privately owned shops and restaurants, you find those in the corner."
	end




	TriggerEvent('mythic_notify:client:SendAlert', {length = 12000, type = 'inform', text = message })
end