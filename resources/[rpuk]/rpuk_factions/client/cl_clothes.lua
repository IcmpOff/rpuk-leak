local oldComponentLanyard, togglelanyard  = GetPedDrawableVariation(PlayerPedId(), 7), false
local drawableBeforeGlove, toggleGlove = 0, false


RegisterNetEvent('rpuk:carClothesMenu')
AddEventHandler('rpuk:carClothesMenu', function()
	TriggerEvent("rpuk_factions:openLockerRoom", ESX.Player.GetJobName(), true)
end)

RegisterNetEvent('rpuk_factions:openLockerRoom')
AddEventHandler('rpuk_factions:openLockerRoom', function(job, useInVehicle)
	local elements = {}
	local gender
	local ped = PlayerPedId()
	local dataType

	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then -- male model
		gender =  "male"
	else
		gender = "female"
	end

	if job == "police" then
		dataType = ESX.Player.GetPoliceData()
	elseif job == "ambulance" then
		dataType = ESX.Player.GetNHSData()
	elseif job == "lost" then
		dataType = ESX.Player.GetLostData()
	end

	if Clothing.ClothingList[job] then
		if Clothing.ClothingList[job][gender] then
			for k,_ in sortedKeys(Clothing.ClothingList[job][gender]) do
				local v = Clothing.ClothingList[job][gender][k]
				if useInVehicle then
					if v.access.useInVehicle then
						if v.access.flagName then
							if dataType[v.access.flagName] then
								if tonumber(dataType[v.access.flagName]) >= tonumber(v.access.flagLevel) then
									table.insert(elements, {label = v.label, value = v})
								end
							end
						elseif ESX.Player.GetJobGrade() >= v.access.jobGrade then
							table.insert(elements, {label = v.label, value = v})
						end
					end
				else
					if v.access.flagName then
						if dataType[v.access.flagName] then
							if tonumber(dataType[v.access.flagName]) >= tonumber(v.access.flagLevel) then
								table.insert(elements, {label = v.label, value = v})
							end
						end
					elseif ESX.Player.GetJobGrade() >= v.access.jobGrade then
						table.insert(elements, {label = v.label, value = v})
					end
				end
			end
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'error', text = 'No Clothes' })
		return
	end
	table.insert(elements, {label = "", value = ""})
	table.insert(elements, {label = "♣ Clear Accessories", value = "clear_acc"})
	table.insert(elements, {label = "😄 Restore To Saved Clothing", value = "restore"})
	table.insert(elements, {label = "💾 Save Clothing", value = "save_loadout"})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_factions_clothing', {
	title    = '',
	css =  job,
	align    = 'top-left',
	elements = elements
	}, function(data, menu)
	if data.current.value == "save_loadout" then
		TriggerEvent('rpuk_skin:save')
		startAnim("missmic4", "michael_tux_fidget")
		menu.close()
	elseif data.current.value == "restore" then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
			startAnim("missmic4", "michael_tux_fidget")
			menu.close()
		end)
	elseif data.current.value == "clear_acc" then
		ClearPedProp(ped, 0)
		SetPedComponentVariation(ped, 9, 0, 0, 2)
		SetPedComponentVariation(ped, 7, 0, 0, 2)
	else
		data = data.current.value
		if data.type == "component" then
			for component, variation in pairs(data) do
				if tostring(type(variation)) == "table" then
					if tostring(variation[2]) == "grade" then
						SetPedComponentVariation(ped, tonumber(component),  tonumber(variation[1]),  ESX.Player.GetJobGrade(),  tonumber(variation[3]))
					else
						SetPedComponentVariation(ped, tonumber(component),  tonumber(variation[1]),  tonumber(variation[2]),  tonumber(variation[3]))
					end
				end
			end
		elseif data.type == "prop" then
			for component, variation in pairs(data) do
				if tostring(type(variation)) == "table" then
					if tonumber(variation[1]) then
						SetPedPropIndex(ped, tonumber(component),  tonumber(variation[1]),  tonumber(variation[2]),  tonumber(variation[3]))
					end
				end
			end
		end
	end
	end, function(data, menu)
		menu.close()
	end)
end)

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
	TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 8.0, -1, 48, 0.0, false, false, false) end)
end

RegisterNetEvent('rpuk:gloves')
AddEventHandler('rpuk:gloves', function()
	local drawable = GetPedDrawableVariation(PlayerPedId(), 3)
	if not toggleGlove then
		drawableBeforeGlove = drawable
		if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
			if drawable == 0 then
				drawable = 85
			elseif drawable == 1 then
				drawable = 86
			elseif drawable == 2 then
				drawable = 87
			elseif drawable == 4 then
				drawable = 88
			elseif drawable == 5 then
				drawable = 89
			elseif drawable == 6 then
				drawable = 90
			elseif drawable == 8 then
				drawable = 91
			elseif drawable == 11 then
				drawable = 92
			elseif drawable == 12 then
				drawable = 93
			elseif drawable == 14 then
				drawable = 94
			elseif drawable == 15 then
				drawable = 95
			end
		elseif GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
			if drawable == 0 then
				drawable = 98
			elseif drawable == 1 then
				drawable = 99
			elseif drawable == 2 then
				drawable = 100
			elseif drawable == 3 then
				drawable = 101
			elseif drawable == 4 then
				drawable = 102
			elseif drawable == 5 then
				drawable = 103
			elseif drawable == 6 then
				drawable = 104
			elseif drawable == 7 then
				drawable = 105
			elseif drawable == 9 then
				drawable = 106
			elseif drawable == 11 then
				drawable = 107
			elseif drawable == 12 then
				drawable = 108
			elseif drawable == 14 then
				drawable = 109
			elseif drawable == 15 then
				drawable = 110
			end
		end
	else
		drawable = drawableBeforeGlove
	end
	toggleGlove = not toggleGlove
	startAnim("missmic4", "michael_tux_fidget")
	SetPedComponentVariation(PlayerPedId(), 3, drawable, 0, 1)
end)

RegisterNetEvent('rpuk:lanyard')
AddEventHandler('rpuk:lanyard', function()
	local playerPed = PlayerPedId()
	if ESX.Player.GetJobName() == "police" then
		if not togglelanyard then
			if GetEntityModel(playerPed) == GetHashKey("mp_f_freemode_01") then SetPedComponentVariation(playerPed, 7, 98, 0, 2)
				elseif GetEntityModel(playerPed) == GetHashKey("mp_m_freemode_01") then SetPedComponentVariation(playerPed, 7, 128, 0, 2)
			end
		else
			SetPedComponentVariation(playerPed, 7, oldComponentLanyard, 0, 2)
		end
		togglelanyard = not togglelanyard
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You do not have permission to use this!' })
	end
end)


