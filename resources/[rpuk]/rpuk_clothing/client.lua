inMenu = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true

		local coords = GetEntityCoords(PlayerPedId())
		for _, l in pairs(ds.locations) do
			if GetDistanceBetweenCoords(coords, l.location, true) < 10.0 then
				canSleep = false
				DrawMarker(1, l.location, 0.0, 0.0, 0.0, 0, 0.0, 0.0, l.size, l.rgb.r, l.rgb.g, l.rgb.b, l.rgb.a, false, true, 2, false, false, false, false)
				if GetDistanceBetweenCoords(coords, l.location, true) < 1.5 then
					if l.text then
						ESX.Game.Utils.DrawText3D(vector3(l.location.x, l.location.y, l.location.z + 1.0), "Press [~b~E~s~] to Access\n" .. l.text, 0.5, 6)
					end
					if IsControlJustReleased(0, 38) then
						open_view(l)
					end
				end
			end
		end

		for _, v in pairs(ds.wardrobes) do
			local obj = GetClosestObjectOfType(coords, 1.5, GetHashKey(v), false, false, false)
			if DoesEntityExist(obj) then
				local obj_coords = GetEntityCoords(obj)
				canSleep = false
				ESX.Game.Utils.DrawText3D(vector3(obj_coords.x, obj_coords.y, obj_coords.z + 1.0), "Press [~b~E~s~] to Access\n~g~Wardrobe", 0.5, 6)
				if IsControlJustReleased(0, 38) then
					open_wardrobe_cats()
				end
			end
		end

		if canSleep then
			Citizen.Wait(1000)
		end
	end
end)

function open_wardrobe_cats()
	ESX.TriggerServerCallback('rpuk_clothing:fetch_wardrobe', function(wardrobe_data)
		inMenu = true
		elements = {}

		for k, v in pairs(wardrobe_data) do
			table.insert(elements, {label = sUpper(k), cat = k, value = v})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fetch_data_cats', {
			title    = '',
			css 	 =  'housing',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value ~= nil then
				open_wardrobe(data.current.cat, data.current.value)
			end
		end, function(data, menu)
			menu.close()
			inMenu = false
		end)
	end)
end

function open_wardrobe(category, c_data)
	inMenu = true
	local elements = {}
	if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
		gender = "female"
	else
		gender = "male"
	end

	table.insert(elements, {label = "Reset Clothing", value = "reset"})

	for k, vString in pairs(c_data) do
		local drawable = string.sub(vString, 1, string.find(vString, ":") - 1)
		local texture = string.sub(vString, string.find(vString, ":") + 1)
		local draw_label = ds[category][gender][tonumber(drawable)].label
		table.insert(elements, {label = draw_label, type = ds[category][gender][tonumber(drawable)].type, drawable = tonumber(drawable), texture = tonumber(texture), value = "apply"})

	--[[ -- broken down by category start
		local found = false
		for _, data in pairs(elements) do
			if data.value == tonumber(drawable) then
				found = true
				break
			end
		end
		if not found then
			local draw_label = ds[category][gender][tonumber(drawable)].label

			Categories[tonumber(drawable)] = {}
			table.insert(elements, {label = draw_label, value = tonumber(drawable)})
		end	]]
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'clothing_shop', {
		title    = "",
		css 	 = "housing",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == "reset" then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
			menu.close()
			menu2.close()
		else
			TriggerEvent('rpuk_skin:save')
		end
	end, function(data, menu)
		menu.close()
		inMenu = false
		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end, function(data, menu)
		local value = data.current.value
		local current = data.current
		local list = ds[category][gender][current.drawable].arrays[current.texture]
		if value ~= "reset" and current.type == "prop" then
			for component, variation in pairs(list.array) do
				SetPedPropIndex(PlayerPedId(), tonumber(component),  tonumber(variation[1]),  tonumber(variation[2]),  tonumber(variation[3]))
			end
		elseif value ~= "reset" and current.type == "comp" then
			for component, variation in pairs(list.array) do
				SetPedComponentVariation(PlayerPedId(), tonumber(component),  tonumber(variation[1]),  tonumber(variation[2]),  tonumber(variation[3]))
			end
		end
	end)
end

function open_view(location)
	inMenu = true
	ESX.UI.Menu.CloseAll()
	local elements = {}
	if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
		gender = "female"
	else
		gender = "male"
	end

	table.insert(elements, {label = "Reset Clothing", value = "reset"})

	local Categories = {}
	for index, data in pairs(ds[location.category][gender]) do
		if data.category == location.sub_category then
			Categories[index] = {}
			Categories[index] = data
		end
	end

	for draw, data in pairs(Categories) do
		local options = {}
		local count = 0
		for i, v in pairs(data.arrays) do
			table.insert(options, v.label)
			count = count + 1
		end
		
		local xlabel
		if data.currency then
			xlabel = data.label .. " <span style='color:lightblue;'>(x" .. data.price .. ")</span>"
		else
			xlabel = data.label .. " <span style='color:lightgreen;'>£" .. data.price .. "</span>"
		end
		
		table.insert(elements, {
			drawable = draw,
			data 	= data,
			label   = xlabel,
			value   = 0,
			type    = 'slider',
			max     = count - 1,
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'clothing_shop', {
		title    = "",
		css 	 = location.header,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == "reset" then
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
			menu.close()
			menu2.close()
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title =  '',
			css   =  location.header,
			align = 'top-left',
			elements = {
				{label = "Purchase: " .. data.current.label, value = 'purchase'},
		}}, function(data2, menu2)
			if data2.current.value == "purchase" then
				local drawable = data.current.drawable
				local texture = data.current.value + 1 -- js ui indexing
				ESX.TriggerServerCallback('rpuk_clothing:purchase', function(result)
					if result then
						TriggerEvent('rpuk_skin:save')
					end
				end, location, gender, drawable, texture)
			end
		end, function(data2, menu2)
			menu2.close()
			inMenu = false
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end)
	end, function(data, menu)
		menu.close()
		inMenu = false
		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end, function(data, menu)
		local value = data.current.value
		local current = data.current.data
		if value ~= "reset" and current.type == "prop" then
			for component, variation in pairs(current.arrays[value+1].array) do
				SetPedPropIndex(PlayerPedId(), tonumber(component),  tonumber(variation[1]),  tonumber(variation[2]),  tonumber(variation[3]))
			end
		elseif value ~= "reset" and current.type == "comp" then
			for component, variation in pairs(current.arrays[value+1].array) do
				SetPedComponentVariation(PlayerPedId(), tonumber(component),  tonumber(variation[1]),  tonumber(variation[2]),  tonumber(variation[3]))
			end
		end
	end)
end

function sUpper(str)
	return (str:gsub("^%l", string.upper))
end