local stageEffects = {
    smoke = {
        vector3(686.25, 577.74, 129.46),
    },
    fire = {
        {location = vector3(671.49, 574.97, 129.61), handle = nil},
        {location = vector3(677.98, 572.60, 129.61), handle = nil},
        {location = vector3(682.55, 567.12, 129.61), handle = nil},
        {location = vector3(689.67, 568.37, 129.61), handle = nil},
        {location = vector3(694.60, 566.56, 129.61), handle = nil},
    }
}

local effects = false
RegisterCommand('smoke', function(source, args)
    effects = not effects
end, false)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if effects then
			for index, data in pairs(stageEffects.fire) do
				UseParticleFxAssetNextCall("core")
				local handle = StartParticleFxLoopedAtCoord("proj_molotov_flame", data.location, 0.0, 0.0, 0.0, tonumber(3 .. .0), 0, 0, 0, 0)
				stageEffects.fire[index].handle = handle
			end
			Citizen.Wait(1000)
			for index, data in pairs(stageEffects.fire) do
				StopParticleFxLooped(data.handle, 0)
				stageEffects.fire[index].handle = nil
			end
			Citizen.Wait(1000)
		end
	end
end)

local var = -1
function devMenu()
	local elements = {}

	table.insert(elements, {label = "depositBoxReward", value = "0"})
	table.insert(elements, {label = "drillCheck", value = "1"})
	table.insert(elements, {label = "NCA jacket [m]", value = "2"})
	table.insert(elements, {label = "NCA jacket [f]", value = "3"})


	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'staffhelp', {
		title    = 'Staff Help',
		css =  'rpuk',
		css =  'rpuk',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == '0' then
            TriggerServerEvent('rpuk_pacificHeist:depositBoxReward', 1)
        elseif data.current.value == '1' then
            TriggerServerEvent('rpuk_pacificHeist:drillCheck', 1, "keys")
        elseif data.current.value == '2' then
			SetPedComponentVariation(PlayerPedId(), 11, 129, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 8, 0, 1, 2)
		elseif data.current.value == '3' then
			SetPedComponentVariation(PlayerPedId(), 11, 127, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 3, 3, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 8, 51, 1, 2)
		end

	end, function(data, menu)
		menu.close()
	end)
end

RegisterCommand("devmenu", function(source, args, rawCommand)
	devMenu()
end, false)

RegisterCommand("debug", function(source, args, rawCommand)
	debugmode = not debugmode
end, false)

RegisterNetEvent('rpuk_clippers:client_sync')
AddEventHandler('rpuk_clippers:client_sync', function(component, variation)
	SetPedComponentVariation(PlayerPedId(), component, variation, 0, 2)
	TriggerEvent('skinchanger:getSkin', function(OldSkinComponent)
		local skin_data = OldSkinComponent
		skin_data["hair_1"] = 0
		skin_data["hair_2"] = 0
		TriggerServerEvent('esx_skin:save', skin_data)
		TriggerServerEvent("rpuk_core:SavePlayer")
	end)
end)

function anim_haircut()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(playerPed))
        local prop = CreateObject(GetHashKey("prop_clippers_01"), x, y, z + 0.2, true, true, true)
        local boneIndex = GetPedBoneIndex(playerPed, 57005)
        AttachEntityToEntity(prop, playerPed, boneIndex, 0.1, 0.008, -0.02, 45.0, 90.0, 0.0, true, true, false, true, 1, true)

		ESX.Streaming.RequestAnimDict('gestures@m@car@low@casual@ds', function()
			TaskPlayAnim(PlayerPedId(), 'gestures@m@car@low@casual@ds', 'gesture_point', 8.0, -8, -1, 49, 0, 0, 0, 0)

			Citizen.Wait(3000)
			IsAnimated = false
			ClearPedSecondaryTask(PlayerPedId())
			DeleteObject(prop)
		end)
    end)
end


local inFreeze = false
local lowGrav = false

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextScale(0.25, 0.25)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end


function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function GetVehicle()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
           -- FreezeEntityPosition(ped, inFreeze)
	    	if IsEntityTouchingEntity(PlayerPedId(), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
	    	end
            if lowGrav then
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+5.0)
            end
        end
        success, ped = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rped
end

function GetObject()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if distance < 10.0 then
            distanceFrom = distance
            rped = ped
            --FreezeEntityPosition(ped, inFreeze)
	    	if IsEntityTouchingEntity(PlayerPedId(), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
	    	end

            if lowGrav then
            	--ActivatePhysics(ped)
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
            	FreezeEntityPosition(ped, false)
            end
        end

        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end




function getNPC()
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped

	    	if IsEntityTouchingEntity(PlayerPedId(), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) )
	    	end

            FreezeEntityPosition(ped, inFreeze)
            if lowGrav then
            	SetPedToRagdoll(ped, 511, 511, 0, 0, 0, 0)
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
            end
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == PlayerPedId() then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end



Citizen.CreateThread( function()

    while true do

        Citizen.Wait(1)

        if debugmode then
            local pos = GetEntityCoords(PlayerPedId())

            local forPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0.0)
            local backPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, -1.0, 0.0)
            local LPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.0, 0.0, 0.0)
            local RPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -1.0, 0.0, 0.0)

            local forPos2 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0.0)
            local backPos2 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, -2.0, 0.0)
            local LPos2 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 2.0, 0.0, 0.0)
            local RPos2 = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -2.0, 0.0, 0.0)

            local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
            local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
            currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

            drawTxt(0.8, 0.50, 0.4,0.4,0.30, "Heading: " .. GetEntityHeading(PlayerPedId()), 55, 155, 55, 255)
            drawTxt(0.8, 0.52, 0.4,0.4,0.30, "Coords: " .. pos, 55, 155, 55, 255)
            drawTxt(0.8, 0.54, 0.4,0.4,0.30, "Attached Ent: " .. GetEntityAttachedTo(PlayerPedId()), 55, 155, 55, 255)
            drawTxt(0.8, 0.56, 0.4,0.4,0.30, "Health: " .. GetEntityHealth(PlayerPedId()), 55, 155, 55, 255)
            drawTxt(0.8, 0.58, 0.4,0.4,0.30, "H a G: " .. GetEntityHeightAboveGround(PlayerPedId()), 55, 155, 55, 255)
            drawTxt(0.8, 0.60, 0.4,0.4,0.30, "Model: " .. GetEntityModel(PlayerPedId()), 55, 155, 55, 255)
            drawTxt(0.8, 0.62, 0.4,0.4,0.30, "Speed: " .. GetEntitySpeed(PlayerPedId()), 55, 155, 55, 255)
            drawTxt(0.8, 0.64, 0.4,0.4,0.30, "Frame Time: " .. GetFrameTime(), 55, 155, 55, 255)
            drawTxt(0.8, 0.66, 0.4,0.4,0.30, "Street: " .. currentStreetName, 55, 155, 55, 255)


            DrawLine(pos,forPos, 255,0,0,115)
            DrawLine(pos,backPos, 255,0,0,115)

            DrawLine(pos,LPos, 255,255,0,115)
            DrawLine(pos,RPos, 255,255,0,115)

            DrawLine(forPos,forPos2, 255,0,255,115)
            DrawLine(backPos,backPos2, 255,0,255,115)

            DrawLine(LPos,LPos2, 255,255,255,115)
            DrawLine(RPos,RPos2, 255,255,255,115)

            local nearped = getNPC()

            local veh = GetVehicle()

            local nearobj = GetObject()

            if IsControlJustReleased(0, 38) then
                if inFreeze then
                    inFreeze = false
                    TriggerEvent("DoShortHudText",'Freeze Disabled',3)
                else
                    inFreeze = true
                    TriggerEvent("DoShortHudText",'Freeze Enabled',3)
                end
            end

            if IsControlJustReleased(0, 47) then
                if lowGrav then
                    lowGrav = false
                    TriggerEvent("DoShortHudText",'Low Grav Disabled',3)
                else
                    lowGrav = true
                    TriggerEvent("DoShortHudText",'Low Grav Enabled',3)
                end
            end

        else
            Citizen.Wait(5000)
        end
    end
end)

bobs = {
	GetHashKey("CARGOBOB"),
	GetHashKey("CARGOBOB2"),
	GetHashKey("CARGOBOB3"),
	GetHashKey("CARGOBOB4"),
}

Citizen.CreateThread(function()
    while true do
    	Citizen.Wait(0)
    	veh = GetVehiclePedIsUsing(PlayerPedId())
    	if IsControlJustPressed(1, 74) then
    		for i = 1,#bobs do
    				rightveh = IsVehicleModel(veh, bobs[i])
    			if rightveh then
    				Citizen.InvokeNative(0x7BEB0C7A235F6F3B,GetVehiclePedIsUsing(PlayerPedId()),1)
    			end
			end
		end
    end
end)

RegisterCommand("removehook", function()
	veh = GetVehiclePedIsUsing(PlayerPedId())
	if Citizen.InvokeNative(0x6E08BF5B3722BAC9,veh) or Citizen.InvokeNative(0x1821D91AD4B56108,veh) then
		vehattached = Citizen.InvokeNative(0x873B82D42AC2B9E5,veh)
		Citizen.InvokeNative(0xADF7BE450512C12F,vehattached)
		Citizen.InvokeNative(0x9768CF648F54C804,veh)
	end
end, false)
