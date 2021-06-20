local currentTattoos, cam, CurrentActionData = {}, -1, {}
local HasAlreadyEnteredMarker, CurrentAction, CurrentActionMsg
local TattoosTable = {}
local TattooZoneCamPos = {}
local plrInMenu = false
local plrSex = 0 --0 = male, 1 = female
local Version = "tattoo"
--print("plrSex inited to: "..plrSex)

TriggerEvent('skinchanger:getSkin', function(skin)
	plrSex = skin.sex
end)

AddEventHandler('skinchanger:modelLoaded', function()
	ESX.TriggerServerCallback('rpuk_tattooshop:requestPlayerTattoos', function(tattooList)

		--get and store the sex of the player (sometimes it fails in ESX detector above)
		TriggerEvent('skinchanger:getSkin', function(skin)
			plrSex = skin.sex
		end)
		--print("plrSex set to: "..plrSex.." in 'skinchanger:modelLoaded'")

		if tattooList then
			for k,v in pairs(tattooList) do

				local TattooTexture = TattoosTable[v.collection][v.texture]

				if plrSex == 0 and #TattooTexture.HashNameMale > 0 then
					ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooTexture.HashNameMale))
				elseif plrSex == 1 and #TattooTexture.HashNameFemale > 0 then
					ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooTexture.HashNameFemale))
				end

			end

			currentTattoos = tattooList
		end
	end)
end)

function loadJSONTattoosTable()
	-- func to load tattoos from files into one large table. Run once per session only
	local myTable = {}

	--loop the filenamelist
	for k,v in pairs(Config.TattooJSONFileList) do

		local subTableName = v.Name

		local filePath = "client/v-tattoos/" .. subTableName .. ".json"
		local filePath2 = "client/tattoozones/tattoozones." .. subTableName .. ".json"

		local loadFile = LoadResourceFile(GetCurrentResourceName(), filePath )
		local loadFile2 = LoadResourceFile(GetCurrentResourceName(), filePath2 )

		--extract the data from the json
		local extract = {}
		extract[subTableName] = {}
		extract[subTableName] = json.decode(loadFile)

		local extract2 = {}
		extract2[subTableName] = {}
		extract2[subTableName] = json.decode(loadFile2)


		for k2,v2 in pairs(extract[subTableName]) do --go through every item in the first table
			--now search for this Name tattoo in the extract2 table
			if extract2[subTableName] then -- apparently there's a lot of invalid setup configuration files?
				for k3,v3 in pairs(extract2[subTableName]) do

					if v3.Name == v2.Name then --we have our match
						extract[subTableName][k2]["updateGroup"] = v3.updateGroup
						extract[subTableName][k2]["eFacing"] = v3.eFacing
						break --no point in hunting further
					end
				end
			--else
				--print(subTableName .. ' missing')
			end
		end

		--add the data to the table
		myTable[subTableName] = {}
		for k2,v2 in pairs(extract[subTableName]) do
			table.insert(myTable[subTableName], v2)
		end
	end

	return myTable
end

function loadJSONTattooCamPos()
	-- func to load tattoos from files into one large table. Run once per session only
	local myTable

	local filePath = "client/tattoozones/updateGroup.json"
	local loadFile = LoadResourceFile(GetCurrentResourceName(), filePath )
	myTable = json.decode(loadFile)

	return myTable
end

function OpenShopMenu()
	local elements = {}

	plrInMenu = true

	--spawn a thread to disable movement while in camera/shop mode
	-- Disable Controls
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if plrInMenu == true then
				DisableControlAction(2, 14, true) --INPUT_WEAPON_WHEEL_NEXT	SCROLLWHEEL DOWN DPAD LEFT
				DisableControlAction(2, 15, true) --INPUT_WEAPON_WHEEL_PREV	SCROLLWHEEL UP DPAD RIGHT
				DisableControlAction(2, 16, true) --INPUT_SELECT_NEXT_WEAPON	SCROLLWHEEL DOWN
				DisableControlAction(2, 17, true) --INPUT_SELECT_PREV_WEAPON	SCROLLWHEEL UP
				DisableControlAction(2, 30, true) --INPUT_MOVE_LR	D LEFT STICK
				DisableControlAction(2, 31, true) --INPUT_MOVE_UD	S LEFT STICK
				DisableControlAction(2, 32, true) --INPUT_MOVE_UP_ONLY	W LEFT STICK
				DisableControlAction(2, 33, true) --INPUT_MOVE_DOWN_ONLY	S LEFT STICK
				DisableControlAction(2, 34, true) --INPUT_MOVE_LEFT_ONLY	A LEFT STICK
				DisableControlAction(2, 35, true) --INPUT_MOVE_RIGHT_ONLY	D LEFT STICK
				DisableControlAction(0, 25, true) --INPUT_AIM	RIGHT MOUSE BUTTON
				DisableControlAction(0, 24, true) --INPUT_ATTACK	LEFT MOUSE BUTTON
				DisableControlAction(0, 44, true) --INPUT_COVER	Q	RB

			else
				Citizen.Wait(1000) --wait a second and then end this thread.
				break
			end
		end
	end)

	table.insert(elements, {label= "Remove All", value = "remove_all"})
	for k,v in pairs(Config.TattooJSONFileList) do
		table.insert(elements, {label= v.Title, value = v.Name})
	end

	if DoesCamExist(cam) then
		RenderScriptCams(false, false, 0, 1, 0)
		DestroyCam(cam, false)
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop', {
		title    = "",
		css =  Version,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local currentLabel, currentValue = data.current.label, data.current.value

		if data.current.value ~= "remove_all" then
			elements = {{label = _U('go_back_to_menu'), value = nil}}

			for k,v in pairs(TattoosTable[data.current.value]) do

				local sexOfTattooOK = false
				local sexOfTattoo = ""
				if #v.HashNameMale > 0 and #v.HashNameFemale > 0 then
					sexOfTattoo = "M/F"
					sexOfTattooOK = true
				elseif #v.HashNameMale > 0 then
					sexOfTattoo = "M"
					sexOfTattooOK = plrSex == 0 or false
				elseif #v.HashNameFemale > 0 then
					sexOfTattoo = "F"
					sexOfTattooOK = plrSex == 1 or false
				else
					sexOfTattoo = "N/A"
					sexOfTattooOK = false
				end

				if sexOfTattooOK then

					--get the human-readable bodyzone
					local bodyzone = "Unknown"
					--local camzone = "UNKNOWN"
					for k2,v2 in pairs(TattooZoneCamPos) do
						if v2.updateGroup == v.Zone then
							bodyzone = v2.bodyzone
							--camzone = v2.updateGroup
							break
						end
					end

					local modifiedPrice = math.floor(v.Price / 20) -- 5% of GTAO prices

					table.insert(elements, {
						--label = k .. ". " .. v.LocalizedName .. " (" .. sexOfTattoo .. ") - " .. bodyzone .." - [" .. camzone .."] - " .. _U('money_amount', ESX.Math.GroupDigits(modifiedPrice)),
						label = k .. ". " .. v.LocalizedName .. " (" .. sexOfTattoo .. ") - " .. bodyzone .." - " .. _U('money_amount', ESX.Math.GroupDigits(modifiedPrice)),
						value = k,
						price = modifiedPrice
					})
				end

			end


			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop_categories', {
				title    = _U('tattoos') .. ' | '..currentLabel,
				css =  Version,
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local price = data2.current.price
				if data2.current.value ~= nil then

					ESX.TriggerServerCallback('rpuk_tattooshop:purchaseTattoo', function(success)
						if success then
							table.insert(currentTattoos, {collection = currentValue, texture = data2.current.value})
						else
							cleanPlayer()
						end
					end, currentTattoos, price, {collection = currentValue, texture = data2.current.value})

				else
					OpenShopMenu()
					RenderScriptCams(false, false, 0, 1, 0)
					DestroyCam(cam, false)
					cleanPlayer()
				end

			end, function(data2, menu2)
				menu2.close()
				RenderScriptCams(false, false, 0, 1, 0)
				DestroyCam(cam, false)
				setPedSkin()
			end, function(data2, menu2) -- when highlighted
				if data2.current.value ~= nil then
					drawTattoo(data2.current.value, currentValue)
				end
			end)
		elseif data.current.value == "remove_all" then
			ESX.TriggerServerCallback('rpuk_tattooshop:purchaseTattoo', function(success)
				if success then
					currentTattoos = {}
					cleanPlayer()
				end
			end, {}, 1000, {})
		end
	end, function(data, menu)
		menu.close()
		setPedSkin()
		plrInMenu = false
		CurrentAction = nil
	end)
end

--initialise the TattoosTable from files
Citizen.CreateThread(function()
	TattoosTable = loadJSONTattoosTable()
	TattooZoneCamPos = loadJSONTattooCamPos()
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords, letSleep = GetEntityCoords(PlayerPedId()), true

		if not plrInMenu then --hide the marker if player already in tattooshop menu
			for k,v in pairs(Config.Zones) do
				if (Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v[1], true) < Config.DrawDistance) then
					DrawMarker(Config.Type, v[1], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
					letSleep = false
				end
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker = false
		local currentZone, LastZone

		for k,v in pairs(Config.Zones) do
			if GetDistanceBetweenCoords(coords, v[1], true) < Config.Size.x then
				isInMarker  = true
				currentZone = 'TattooShop'
				LastZone    = 'TattooShop'
				Version = v[2]
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('rpuk_tattooshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('rpuk_tattooshop:hasExitedMarker', LastZone)
		end
	end
end)

AddEventHandler('rpuk_tattooshop:hasEnteredMarker', function(zone)
	if zone == 'TattooShop' then
		CurrentAction     = 'tattoo_shop'
		CurrentActionMsg  = _U('tattoo_shop_prompt')
		CurrentActionData = {zone = zone}
	end
end)

AddEventHandler('rpuk_tattooshop:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
	Version = "tattoo"
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'tattoo_shop' then
					OpenShopMenu()
				end
				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function setPedSkin()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)

	Citizen.Wait(1000)

	for k,v in pairs(currentTattoos) do

		local TattooTexture = TattoosTable[v.collection][v.texture]

		if plrSex == 0 and #TattooTexture.HashNameMale > 0 then
			ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooTexture.HashNameMale))
		elseif plrSex == 1 and #TattooTexture.HashNameFemale > 0 then
			ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooTexture.HashNameFemale))
		end

	end
end

function drawTattoo(current, collection)
	SetEntityHeading(PlayerPedId(), 297.7296)
	ClearPedDecorations(PlayerPedId())

	for k,v in pairs(currentTattoos) do

		local TattooTexture = TattoosTable[v.collection][v.texture]

		if plrSex == 0 and #TattooTexture.HashNameMale > 0 then
			ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooTexture.HashNameMale))
		elseif plrSex == 1 and #TattooTexture.HashNameFemale > 0 then
			ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooTexture.HashNameFemale))
		end

	end

	if plrSex == 0 then
		TriggerEvent('skinchanger:loadSkin', {
			sex      = 0,
			tshirt_1 = 15,
			tshirt_2 = 0,
			arms     = 15,
			torso_1  = 91,
			torso_2  = 0,
			pants_1  = 14,
			pants_2  = 0,
			chain_1 = 0,
			chain_2 = 0
		})
	else
		TriggerEvent('skinchanger:loadSkin', {
			sex      = 1,
			tshirt_1 = 34,
			tshirt_2 = 0,
			arms     = 15,
			torso_1  = 101,
			torso_2  = 1,
			pants_1  = 16,
			pants_2  = 0,
			chain_1 = 0,
			chain_2 = 0
		})
	end

	local characterType = 3 --default to male_MP

	local newTattooTexture = TattoosTable[collection][current]
	if plrSex == 0 and #newTattooTexture.HashNameMale > 0 then
		ApplyPedOverlay(PlayerPedId(), GetHashKey(collection), GetHashKey(newTattooTexture.HashNameMale))
		characterType = 3
	elseif plrSex == 1 and #newTattooTexture.HashNameFemale > 0 then
		ApplyPedOverlay(PlayerPedId(), GetHashKey(collection), GetHashKey(newTattooTexture.HashNameFemale))
		characterType = 4
	end

	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

		SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
		SetCamRot(cam, 0.0, 0.0, 0.0)
		SetCamActive(cam, true)
		RenderScriptCams(true, false, 0, true, true)
		SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
	end

	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))

	local thisTattooZoneCamPos = TattooZoneCamPos[TattoosTable[collection][current].updateGroup]

	for k2,v2 in pairs(TattooZoneCamPos) do
		if v2.updateGroup == TattoosTable[collection][current].updateGroup then
			thisTattooZoneCamPos = v2
			break
		end
	end

	if thisTattooZoneCamPos then
		SetCamCoord(cam, x + thisTattooZoneCamPos.addedX, y + thisTattooZoneCamPos.addedY, z + thisTattooZoneCamPos.addedZ)
		SetCamRot(cam, 0.0, 0.0, thisTattooZoneCamPos.rotZ)
	else
		print(('tattoo %s %s has missing CamPos data'):format(collection, current))
	end
end

function cleanPlayer()
	ClearPedDecorations(PlayerPedId())

	for k,v in pairs(currentTattoos) do
		local TattooTexture = TattoosTable[v.collection][v.texture]

		if plrSex == 0 and #TattooTexture.HashNameMale > 0 then
			ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooTexture.HashNameMale))
		elseif plrSex == 1 and #TattooTexture.HashNameFemale > 0 then
			ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooTexture.HashNameFemale))
		end
	end
end