local Data = {}

Citizen['CreateThread'](function()
    while true do
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if not IsPedDeadOrDying(PlayerPedId()) then
			if vehicle ~= nil and vehicle ~= 0 then else -- Works better when falling through
				if Config['CancelAnimation'] then
					if IsControlJustReleased(0, Config['CancelAnimation']) then
						ClearPedTasks(PlayerPedId())
					end
				end
				if Config['PoleDance']['Enabled'] then
					for k, v in pairs(Config['PoleDance']['Locations']) do
						if #(GetEntityCoords(PlayerPedId()) - v['Position']) <= 1.0 then
							DrawText3D(v['Position'], Strings['Pole_Dance'], 0.35)
							if IsControlJustReleased(0, 51) then
								LoadDict('mini@strip_club@pole_dance@pole_dance' .. v['Number'])
								local scene = NetworkCreateSynchronisedScene(v['Position'], vector3(0.0, 0.0, 0.0), 2, false, false, 1065353216, 0, 1.3)
								NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, 'mini@strip_club@pole_dance@pole_dance' .. v['Number'], 'pd_dance_0' .. v['Number'], 1.5, -4.0, 1, 1, 1148846080, 0)
								NetworkStartSynchronisedScene(scene)
							end
						end
					end
				end
			end
        end
        Wait(0)
    end
end)

RegisterCommand('exp_rpuk_anims', function(source, args)
	TriggerEvent("loffe_animations:openMenu")
end, false)

RegisterNetEvent('loffe_animations:openMenu')
AddEventHandler('loffe_animations:openMenu', function()
    local elements = {}

    table.insert(elements, {label = Strings['Animations'], value = 'animations'})
    table.insert(elements, {label = Strings['Synced'], value = 'synced'})

	ESX['UI']['Menu']['Open']('default', GetCurrentResourceName(), 'animations',
	{
		css = "anims",
		title = "",
		align = 'top-left',
		elements = elements
    }, function(data, menu)
        if data['current']['value'] == 'synced' then

            local elements2 = {}
            for k, v in pairs(Config['Synced']) do
                table.insert(elements2, {['label'] = v['Label'], ['id'] = k})
            end
            
			ESX['UI']['Menu']['Open']('default', GetCurrentResourceName(), 'play_synced',
            {
				css = "anims",
				title = "",
                align = 'top-left',
                elements = elements2
            }, function(data2, menu2)
                current = data2['current']
                local allowed = false
                if Config['Synced'][current['id']]['Car'] then
                    if IsPedInAnyVehicle(PlayerPedId(), false) then
                        allowed = true
                    else
                        ESX['ShowNotification'](Strings['Not_In_Car'])
                    end
                else
                    allowed = true
                end
                if allowed then
                    if not Config['Debug'] then
                        local allowed = false
                        local distance, closest
        
                        for k, v in pairs(GetActivePlayers()) do
                            src = GetPlayerServerId(v)
                            if src ~= GetPlayerServerId(PlayerId()) then
                                plr = GetPlayerFromServerId(src)
                                dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(plr)))
                                if not closest then
                                    closest = src
                                    distance = dist
                                else
                                    if dist < distance then
                                        distance = dist
                                        closest = src
                                    end
                                end
                            end
                        end

                        if distance <= 2.0 then
                            TriggerServerEvent('loffe_animations:requestSynced', closest, current['id'])
                        else
                            ESX['ShowNotification'](Strings['Noone_Close'])
                        end

                    else

                        local id = current['id']

                        local target = ClonePed(PlayerPedId(), GetEntityHeading(PlayerPedId()), 1, 1)
                        CreateThread(function()

                            local anim = Config['Synced'][id]['Accepter']

                            if Config['Synced'][id]['Car'] then
                                TaskWarpPedIntoVehicle(target, GetVehiclePedIsUsing(PlayerPedId()), 0)
                            end

                            if anim['Attach'] then
                                local attach = anim['Attach']
                                AttachEntityToEntity(target, PlayerPedId(), attach['Bone'], attach['xP'], attach['yP'], attach['zP'], attach['xR'], attach['yR'], attach['zR'], 0, 0, 0, 0, 2, 1)
                            end

                            Wait(750)

                            if anim['Type'] == 'animation' then
                                LoadDict(anim['Dict'])
                                TaskPlayAnim(target, anim['Dict'], anim['Anim'], 8.0, -8.0, -1, anim['Flags'] or 0, 0, false, false, false)
                            end

                            anim = Config['Synced'][id]['Requester']

                            while not IsEntityPlayingAnim(PlayerPedId(), anim['Dict'], anim['Anim'], 3) do
                                Wait(0)
                                SetEntityNoCollisionEntity(target, PlayerPedId(), true)
                            end
                            DetachEntity(target)
                            while IsEntityPlayingAnim(PlayerPedId(), anim['Dict'], anim['Anim'], 3) do
                                Wait(0)
                                SetEntityNoCollisionEntity(target, PlayerPedId(), true)
                            end

                            ClearPedTasks(target)
                            DeleteEntity(target)

                        end)
                        CreateThread(function()
                            local anim = Config['Synced'][id]['Requester']
                            if anim['Attach'] then
                                local attach = anim['Attach']
                                AttachEntityToEntity(PlayerPedId(), target, attach['Bone'], attach['xP'], attach['yP'], attach['zP'], attach['xR'], attach['yR'], attach['zR'], 0, 0, 0, 0, 2, 1)
                            end

                            Wait(750)

                            if anim['Type'] == 'animation' then
                                PlayAnim(anim['Dict'], anim['Anim'], anim['Flags'])
                            end

                            anim = Config['Synced'][id]['Accepter']

                            while not IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
                                Wait(0)
                                SetEntityNoCollisionEntity(PlayerPedId(), target, true)
                            end
                            DetachEntity(PlayerPedId())
                            while IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
                                Wait(0)
                                SetEntityNoCollisionEntity(PlayerPedId(), target, true)
                            end

                            ClearPedTasks(PlayerPedId())
                        end)

                    end
                end


            end, function(data2, menu2)
                menu2['close']()
            end)

        elseif data['current']['value'] == 'manage' then

            local elements2 = {}
            for k, v in pairs(Data['Favorites']) do
                table.insert(elements2, {['label'] = v['Label'], ['id'] = k})
            end
            
			ESX['UI']['Menu']['Open']('default', GetCurrentResourceName(), 'play_animation',
            {
				css = "anims",
				title = "",
                align = 'top-left',
                elements = elements2
            }, function(data2, menu2)
                current = data2['current']

                ESX['UI']['Menu']['Open']('default', GetCurrentResourceName(), 'choose_favorite',
                {
                    title = (Strings['Remove?']):format(Data['Favorites'][current['id']]['Label']),
                    css = "rpuk",
					align = 'top-left',
                    elements = {
                        {['label'] = Strings['Yes'], ['value'] = 'y'},
                        {['label'] = Strings['No'], ['value'] = 'n'}
                    }
                }, function(data3, menu3)
                    ESX['UI']['Menu']['CloseAll']()
                    local current = data3['current']
                    
                    if current['value'] == 'y' then
                        local fav = Data['Favorites']
                        Data['Favorites'] = {}
                        for k, v in pairs(fav) do
                            if k ~= data2['current']['id'] then
                                Data['Favorites'][k] = v
                            end
                        end
                        TriggerServerEvent('loffe_animations:update_favorites', json['encode'](Data['Favorites']))
                    end
                end, function(data3, menu3)
                    menu3['close']()
                end)

            end, function(data2, menu2)
                menu2['close']()
            end)

        elseif data['current']['value'] == 'favorite' then

            local elements2 = {}
            for k, v in pairs(Config['Animations']) do
                table.insert(elements2, {['label'] = v['Label'], ['id'] = k})
            end
            
			ESX['UI']['Menu']['Open']('default', GetCurrentResourceName(), 'play_animation',
            {
                css = "anims",
				title = "",
                align = 'top-left',
                elements = elements2
            }, function(data2, menu2)
                current = data2['current']

                local elements3 = {}
                for k, v in pairs(Config['Animations'][current['id']]['Data']) do
                    table.insert(elements3, {['label'] = v['Label'], ['id'] = v['id'], ['data'] = v})
                end
                
                ESX['UI']['Menu']['Open']('default', GetCurrentResourceName(), 'choose_favorite',
                {
                    css = "anims",
					title = "",
                    align = 'top-left',
                    elements = elements3
                }, function(data3, menu3)
                    ESX['UI']['Menu']['CloseAll']()
                    local current = data3['current']['data']
                    CreateThread(function()
                        local string = (Strings['Choose_Favorite'] .. '\n'):format(data3['current']['label'])
                        local button = 'error'
                        
                        for k, v in pairs(Config['SelectableButtons']) do
                            if not Data['Favorites'][v[2]] then
                                string = string .. v[1] .. '\n'
                            end
                        end
						
                        string = string .. '\n' .. '~INPUT_FRONTEND_RRIGHT~ ' .. Strings['Close']

                        local chosen = false
                        while not chosen do 
                            Wait(0)
                            HelpText(string)

                            for k, v in pairs(Config['SelectableButtons']) do
                                if IsDisabledControlJustReleased(0, v[2]) then
                                    button = v[2]
                                    chosen = true
                                end
                                DisableControlAction(0, v[2])
                            end

                            if IsControlJustReleased(0, 194) then
                                button = false
                                chosen = true
                            end

                        end

                        if button then
                            Data['Favorites'][tostring(button)] = current
                            TriggerServerEvent('loffe_animations:update_favorites', json['encode'](Data['Favorites']))
                        end
                    end)
                end, function(data3, menu3)
                    menu3['close']()
                end)

            end, function(data2, menu2)
                menu2['close']()
            end)

        elseif data['current']['value'] == 'animations' then

            local elements2 = {}
            
            for k, v in pairs(Config['Animations']) do
                table.insert(elements2, {['label'] = v['Label'], ['value'] = k})
            end

			ESX['UI']['Menu']['Open']('default', GetCurrentResourceName(), 'view_animations',
            {
                css = "anims",
				title = "",
                align = 'top-left',
                elements = elements2
            }, function(data2, menu2)

                local elements3 = {}
                for k, v in pairs(Config['Animations'][data2['current']['value']]['Data']) do
                    table.insert(elements3, {label = v['Label'], data = v})
                end

                ESX['UI']['Menu']['Open']('default', GetCurrentResourceName(), 'play_animation',
                {
                    css = "anims",
					title = "",
                    align = 'top-left',
                    elements = elements3
                }, function(data3, menu3)
                    local current = data3['current']['data']

                    if current['Type'] == 'scenario' then
                        TaskStartScenarioInPlace(PlayerPedId(), current['Anim'], 0, false)
                    elseif current['Type'] == 'walking_style' then
                        SetWalkingStyle(current['Style'])
                    elseif current['Type'] == 'animation' then
                        PlayAnim(current['Dict'], current['Anim'], current['Flags'])
                    end
                end, function(data3, menu3)
                    menu3['close']()
                end)
                
            end, function(data2, menu2)
                menu2['close']()
            end)

		end
	end, function(data, menu)
		menu['close']()
	end)
end)

RegisterNetEvent('loffe_animations:syncRequest')
AddEventHandler('loffe_animations:syncRequest', function(requester, id, name, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
    local accepted = false
    local timer = GetGameTimer() + 5000
    while timer >= GetGameTimer() do 
        Wait(0)
        if id == "carry" then
            HelpText(name .. " Wants To Carry You!\n~INPUT_FRONTEND_ACCEPT~ To Accept\n~INPUT_FRONTEND_RRIGHT~ To Decline\n\n~c~You can stop this at any time by typing /carry or using the caps lock menu")
        else
            HelpText((Strings['Sync_Request']):format(Config['Synced'][id]['RequesterLabel'], name) .. ('\n~INPUT_FRONTEND_ACCEPT~ %s \n~INPUT_FRONTEND_RRIGHT~ %s'):format(Strings['Yes'], Strings['No']))
        end
        if IsControlJustReleased(0, 194) then
            break
        elseif IsControlJustReleased(0, 201) then
            accepted = true
            break
        end

    end

    if accepted then
        if id == "carry" then
            TriggerServerEvent('rpuk_carry:accept', requester, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
        else
            TriggerServerEvent('loffe_animations:syncAccepted', requester, id)
        end
    end
end)

RegisterNetEvent('loffe_animations:playSynced')
AddEventHandler('loffe_animations:playSynced', function(serverid, id, type)
    local anim = Config['Synced'][id][type]

    local target = GetPlayerPed(GetPlayerFromServerId(serverid))
    if anim['Attach'] then
        local attach = anim['Attach']
        AttachEntityToEntity(PlayerPedId(), target, attach['Bone'], attach['xP'], attach['yP'], attach['zP'], attach['xR'], attach['yR'], attach['zR'], 0, 0, 0, 0, 2, 1)
    end

    Wait(750)

    if anim['Type'] == 'animation' then
        PlayAnim(anim['Dict'], anim['Anim'], anim['Flags'])
    end

    if type == 'Requester' then
        anim = Config['Synced'][id]['Accepter']
    else
        anim = Config['Synced'][id]['Requester']
    end
    while not IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
        Wait(0)
        SetEntityNoCollisionEntity(PlayerPedId(), target, true)
    end
    DetachEntity(PlayerPedId())
    while IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
        Wait(0)
        SetEntityNoCollisionEntity(PlayerPedId(), target, true)
    end

    ClearPedTasks(PlayerPedId())
end)

SetWalkingStyle = function(Style)
    LoadDict(Style)
    SetPedMovementClipset(PlayerPedId(), Style, true)
end

PlayAnim = function(Dict, Anim, Flag)
    LoadDict(Dict)
    TaskPlayAnim(PlayerPedId(), Dict, Anim, 8.0, -8.0, -1, Flag or 0, 0, false, false, false)
end

LoadDict = function(Dict)
    while not HasAnimDictLoaded(Dict) do 
        Wait(0)
        RequestAnimDict(Dict)
    end
end

HelpText = function(msg)
    AddTextEntry(GetCurrentResourceName(), msg)
    DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
end

DrawText3D = function(coords, text, scale)
	local onScreen,_x,_y=World3dToScreen2d(coords.x, coords.y, coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 41, 41, 125)
end