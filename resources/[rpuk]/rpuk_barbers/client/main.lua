local isSkinCreatorOpened = false		-- Change this value to show/hide UI
local cam = -1							-- Camera control
local heading = 332.219879				-- Heading coord
local zoom = "visage"					-- Define which tab is shown first (Default: Head)
local isCameraActive
local zoomOffsetOld, camOffsetOld, headingOld = 0.0, 0.0, 90.0
local FirstSpawn     = true
local NewPlayer		 = true
local PlayerLoaded   = false
local PrevHat,PrevGlasses, PrevEars, PrevGender
local face

local HasAlreadyEnteredMarker = false
local LastPad = nil
local LastAction = nil
local LastPadData = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = nil

RegisterNUICallback('updateSkin', function(data)
	local playerPed = PlayerPedId()
	v = data.value

	hair = tonumber(data.hair)
	hair2 = hair -- doesn't do anything from what I can tell

	haircolor = tonumber(data.haircolor)
	haircolor2 = tonumber(data.haircolor2)

	eyebrow = tonumber(data.eyebrow)
	eyebrowopacity = tonumber(data.eyebrowopacity)

	beard = tonumber(data.beard)
	beardopacity = tonumber(data.beardopacity)
	beardcolor = tonumber(data.beardcolor)

	makeuptype = tonumber(data.makeuptype)  -- makeup 1
	makeupcolor = tonumber(data.makeupcolor)  -- makeup 2
	makeupcolor2 = tonumber(data.makeupcolor2)  -- makeup 3
	makeupthicknessRecieve = tonumber(data.makeupthickness) -- div by 10
	makeupthickness = makeupthicknessRecieve/10

	lipsticktype = tonumber(data.lipsticktype)
	lipstickcolor = tonumber(data.lipstickcolor)
	lipstickcolor2 = lipstickcolor

	lipstickthicknessRecieve = tonumber(data.lipstickthickness)
	lipstickthickness = lipstickthicknessRecieve/10

	if(v == true) then
		TriggerEvent('skinchanger:getSkin', function(OldSkinComponent)
			local skin_data = {["mask_1"]=OldSkinComponent.mask_1,["mask_2"]=OldSkinComponent.mask_2,["beard_1"]= beard,["beard_2"]= beardopacity,["beard_3"]= beardcolor,["beard_4"]= beardcolor,["lipstick_1"]= lipsticktype,["lipstick_2"]= lipstickthickness,["lipstick_3"]= lipstickcolor,["lipstick_4"]= lipstickcolor2,["makeup_1"]= makeuptype,["makeup_2"]= makeupcolor,["makeup_3"]= makeupcolor2,["makeup_4"]= makeupthickness,["sex"]=OldSkinComponent.sex,["face"]=OldSkinComponent.face,["skin"]=OldSkinComponent.skin,["eye_color"]=OldSkinComponent.eye_color,["complexion_1"]=OldSkinComponent.complexion_1,["complexion_2"]=OldSkinComponent.complexion_2,["moles_1"]=OldSkinComponent.moles_1,["moles_2"]=OldSkinComponent.moles_2,["age_1"]=OldSkinComponent.age_1,["age_2"]=OldSkinComponent.age_2,["eyebrows_1"]=eyebrow,["eyebrows_2"]=eyebrowopacity,["hair_1"]=hair,["hair_2"]=hair2,["hair_color_1"]=haircolor,["hair_color_2"]=haircolor2,["arms"]=OldSkinComponent.torso,["arms_2"]=OldSkinComponent.torsotext,["pants_1"]=OldSkinComponent.pants_1,["pants_2"]=OldSkinComponent.pants_2,["shoes_1"]=OldSkinComponent.shoes_1,["shoes_2"]=OldSkinComponent.shoes_2,["chain_1"]=OldSkinComponent.chain_1,["chain_2"]=OldSkinComponent.chain_2,["tshirt_1"]=OldSkinComponent.tshirt_1,["tshirt_2"]=OldSkinComponent.tshirt_2,["torso_1"]=OldSkinComponent.torso_1,["torso_2"]=OldSkinComponent.torso_2,["helmet_1"]=OldSkinComponent.helmet_1,["helmet_2"]=OldSkinComponent.helmet_2,["glasses_1"]=OldSkinComponent.glasses_1,["glasses_2"]=OldSkinComponent.glasses_2,["ears_1"]=OldSkinComponent.ears_1,["ears_2"]=OldSkinComponent.ears_2,["watches_1"]=OldSkinComponent.watches_1,["watches_2"]=OldSkinComponent.watches_2}
			TriggerServerEvent('esx_skin:save', skin_data)
		end)
		CloseSkinCreator()
	else

	TriggerEvent('skinchanger:getSkin', function(OldComponentsLoader)
		TriggerEvent('skinchanger:change', 'sex', OldComponentsLoader.sex)
		gender = OldComponentsLoader.sex
	end)

		SetPedComponentVariation	(PlayerPedId(), 2, hair, 0, 2)
		SetPedHairColor				(PlayerPedId(), haircolor, haircolor2)

		SetPedHeadOverlay       	(PlayerPedId(), 2, eyebrow, eyebrowopacity * 0.1)

		SetPedHeadOverlay       	(PlayerPedId(), 1, beard, beardopacity * 0.1)
		SetPedHeadOverlayColor  	(PlayerPedId(), 1, 1, beardcolor, beardcolor) -- Beard
		SetPedHeadOverlayColor  	(PlayerPedId(), 2, 1, beardcolor, beardcolor) -- Eye brows, uses same color as beard

		SetPedHeadOverlay(PlayerPedId(), 4, makeuptype, makeupthickness)
		SetPedHeadOverlayColor(PlayerPedId(), 4, 2, makeupcolor, makeupcolor2)

		SetPedHeadOverlay(PlayerPedId(), 8, lipsticktype, lipstickthickness)
		SetPedHeadOverlayColor(PlayerPedId(), 8, 2, lipstickcolor, lipstickcolor2)

		-- Clear the hat & glasses, ear shit whilst in ui
		ClearPedProp(PlayerPedId(), 0)
		ClearPedProp(PlayerPedId(), 1)
		ClearPedProp(PlayerPedId(), 2)
		SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)

		--[[In development]]--
		SetPedComponentVariation	(PlayerPedId(), 1, 0, 0, 2) -- Mask

	end
end)

-- Character rotation
RegisterNUICallback('rotateleftheading', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
	heading = heading+tonumber(data.value)
end)

RegisterNUICallback('rotaterightheading', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
	heading = heading-tonumber(data.value)
end)

-- Close all
RegisterNUICallback('closeall', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
	heading = heading-tonumber(data.value)
	CloseSkinCreator()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end)

-- Define which part of the body must be zoomed
RegisterNUICallback('zoom', function(data)
	zoom = data.zoom
end)

function CloseSkinCreator()
	local ped = PlayerPedId()
	isSkinCreatorOpened = false
	ShowSkinCreator(false)
	isCameraActive = false
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 500, true, true)
	cam = nil

	-- Player
	SetPlayerInvincible(ped, false)
end

function ShowSkinCreator(enable)
local elements    = {}
	TriggerEvent('skinchanger:getData', function(components, maxVals)
		local _components = {}

		for i=1, #components, 1 do
			_components[i] = components[i]
		end

		-- Insert elements
		for i=1, #_components, 1 do
			local value       = _components[i].value
			local componentId = _components[i].componentId

			if componentId == 0 then
				value = GetPedPropIndex(playerPed,  _components[i].componentId)
			end

			local data = {
				label     = _components[i].label,
				name      = _components[i].name,
				value     = value,
				min       = _components[i].min,
			}

			for k,v in pairs(maxVals) do
				if k == _components[i].name then
					data.max = v
					break
				end
			end

			table.insert(elements, data)
		end
	end)
	isCameraActive = true
	SetNuiFocus(enable, enable)
	SendNUIMessage({
		openSkinCreator = enable,
	})

	for index, data in ipairs(elements) do
		local name, Valmax

		for key, value in pairs(data) do
			if key == 'name' then
				name = value
			end
			if key == 'max' then
				Valmax = value
			end
		end

		SendNUIMessage({
			type = "updateMaxVal",
			classname = name,
			defaultVal = 0,
			maxVal = Valmax
		})
	end
end

-- Disable Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isCameraActive == true then
			local ped = PlayerPedId()

			-- Camera
			RenderScriptCams(false, false, 0, 1, 0)
			DestroyCam(cam, false)
			if(not DoesCamExist(cam)) then
				cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
				SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
				SetCamRot(cam, 0.0, 0.0, 0.0)
				SetCamActive(cam,  true)
				RenderScriptCams(true,  false,  0,  true,  true)
				SetCamCoord(cam, GetEntityCoords(PlayerPedId()))
			end
			local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
			if zoom == "visage" or zoom == "pilosite" then
				SetCamCoord(cam, x+0.2, y+0.5, z+0.7)
				SetCamRot(cam, 0.0, 0.0, 150.0)
			elseif zoom == "vetements" then
				SetCamCoord(cam, x+0.3, y+2.0, z+0.0)
				SetCamRot(cam, 0.0, 0.0, 170.0)
			end
			SetEntityHeading(PlayerPedId(), heading)
		else
			Citizen.Wait(500)
		end
	end

end)

AddEventHandler('esx_skin:setLastSkin', function(skin)
	lastSkinOld = skin
end)

RegisterNetEvent('esx_skin:openSaveableBarberRestrictedMenu')
AddEventHandler('esx_skin:openSaveableBarberRestrictedMenu', function(submitCb, cancelCb, restrict)
	ShowSkinCreator(true)
end)

AddEventHandler('ds_clotheshops:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = "Press ~INPUT_PICKUP~ to ~p~Doll up~s~."
	CurrentActionData = {}
end)

AddEventHandler('ds_clotheshops:hasExitedMarker', function(zone)

	ESX.UI.Menu.CloseAll()
	CurrentAction = nil

end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		local letSleep = true
		Wait(0)

		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				letSleep = false
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
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

		Wait(0)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('ds_clotheshops:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('ds_clotheshops:hasExitedMarker', LastZone)
		end

	end
end)

function OpenGateWay()
  local price = 250
  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'shop_clothes',
    {
      title = 'Hair & <span style="color:pink;">Beauty</span>',
	  css =  'rpuk',
align    = 'top-left',
      elements = {
        { label = "Purchase Hair / Beauty" .. ' (<span style="color:green;">£' .. price .. '<span style="color:#FFFFFF;">)', value = 'yes' },
        { label = "Exit", value = 'no' },
      }
    },
    function (data, menu)
      if data.current.value == 'yes' then
		Citizen.Wait(500)
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
		Citizen.Wait(1000)
        TriggerServerEvent('rpuk_barbers:buystyle', price)
      end
      menu.close()
    end,
    function (data, menu)
      menu.close()
    end
  )
end

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlPressed(0,  38) then
				if CurrentAction == 'shop_menu' then
					OpenGateWay()
				end
				CurrentAction = nil
			end
		end
	end
end)
