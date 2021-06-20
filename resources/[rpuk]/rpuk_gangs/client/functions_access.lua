function clothing_menu(turf)
	local elements = {}

	if not hasPermission("gang_fnc_clothing") then
		TriggerEvent('mythic_notify:client:SendAlert', { length = 7000, type = 'error', text = "You don't have permission to use this feature. Speak to your gang leader."})
		return
	end

	local gender = nil
	if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
		gender =  "male"
	else
		gender = "female"
	end

	for label, data in pairs(Config.StashHouses[turf].clothing[gender]) do
		table.insert(elements, {label = label, xtype = data.type, value = data.array})
	end

	table.insert(elements, {label = "♣ Clear Accessories", value = "clear_acc"})
	table.insert(elements, {label = "💾 Save Clothing", value = "save_loadout"})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_gang_clothing', {
	title    = '',
	css =  "rpuk",
	align    = 'top-left',
	elements = elements
	}, function(data, menu)
		if data.current.value == "save_loadout" then
			TriggerEvent('rpuk_skin:save')
		elseif data.current.value == "clear_acc" then
			ClearPedProp(PlayerPedId(), 0)
			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)
		else
			clothing_data = data.current.value
			if data.current.xtype == "component" then
				for component, variation in pairs(clothing_data) do
					if tostring(type(variation)) == "table" then
						SetPedComponentVariation(PlayerPedId(), tonumber(component),  tonumber(variation[1]),  tonumber(variation[2]),  tonumber(variation[3]))
					end
				end
			elseif data.current.xtype == "prop" then
				for component, variation in pairs(clothing_data) do
					if tostring(type(variation)) == "table" then
						if tonumber(variation[1]) then
							SetPedPropIndex(PlayerPedId(), tonumber(component),  tonumber(variation[1]),  tonumber(variation[2]),  tonumber(variation[3]))
						end
					end
				end
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function access_storage(gang_id)
	if not hasPermission("gang_fnc_safe") then
		TriggerEvent('mythic_notify:client:SendAlert', { length = 7000, type = 'error', text = "You don't have permission to use this feature. Speak to your gang leader."})
		return
	end
	TriggerServerEvent('rpuk_gangs:openStorage', gang_id)
end

function access_weapon_manufacture(gang_id)
	if not hasPermission("gang_fnc_weapon_bench") then
		TriggerEvent('mythic_notify:client:SendAlert', { length = 7000, type = 'error', text = "You don't have permission to use this feature. Speak to your gang leader."})
		return
	end
	TriggerServerEvent("rpuk_manufacturing:custom", {
        recipes = {
			"gangPistol" .. tostring(gang_id),
			"pistol_ammo",
			"ziptie",
			"grip",
			"fiftycalmodification",
			"lockpick",
			"advanced_lockpick",
			"grip",
			"long_barrel",
			"short_barrel",
			"pistol_magazine",
			"wood_stock",
			"wire_stock",
			"reciever_assembly",
			"tactical_rail",
			"trigger_assembly",
			"rotating_cylinder",
			"hammer",
			"drill",
			"slider_assembly",
			"boring_kit",
			"spring",
        }
    })
end

local interactingLocal = false
function support_npc(coords)
	if not hasPermission("gang_fnc_local_gang_member") or interactingLocal then
		TriggerEvent('mythic_notify:client:SendAlert', { length = 7000, type = 'error', text = "The boss told me not to speak to you..."})
		return
	end

	interactingLocal = true
	local scaleform = ESX.Scaleform.PrepareBasicInstructional({{button = {168}, text = "Stop Speaking"},{button = {304}, text = "Ask (Guns)"},{button = {185}, text = "Ask (Drugs)"},{button = {183}, text = "Ask (Tips)"}})

	while interactingLocal do
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local distance = #(coords - playerCoords)
		if distance >= 3.0 then
			interactingLocal = false
			break
		end
		DrawScaleformMovieFullscreen(scaleform)
		if IsControlJustReleased(0, 168) then
			interactingLocal = false
		end
		if IsControlJustReleased(0, 304) then
			TriggerServerEvent('rpuk_gangs:npcClaim', "blueprint")
			Citizen.Wait(1500)
		end
		if IsControlJustReleased(0, 185) then
			TriggerServerEvent('rpuk_gangs:start_cocaine')
			--TriggerServerEvent('rpuk_gangs:npcClaim', "drugs")
			Citizen.Wait(1500)
		end
		if IsControlJustReleased(0, 183) then
			TriggerServerEvent('rpuk_gangs:npcClaim', "tips")
			Citizen.Wait(1500)
		end
		Citizen.Wait(0)
	end
end