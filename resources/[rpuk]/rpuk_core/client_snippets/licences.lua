local licence_list = nil

local locations = {
	vector3(-551.813, -189.814, 37.220),

}

Citizen.CreateThread(function()
	ESX.TriggerServerCallback('esx_license:getLicensesList', function(x)
		licence_list = x
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local canSleep = true
		for k, data in pairs(locations) do
			local distance = #(coords - data)
			if distance < 15 then
				canSleep = false
				DrawMarker(1, data, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
				if distance < 1.5 then
					local textpos = vector3(data.x, data.y, data.z + 2.0)
					ESX.Game.Utils.DrawText3D(textpos, "Press [~r~E~s~] to Access Licence Shop", 0.8, 6)
					if IsControlJustReleased(0, 38) then
						open_licenceshop()
					end
				end
			end
		end
		if canSleep then
			Citizen.Wait(1000)
		end
	end
end)

function open_licenceshop()
	ESX.TriggerServerCallback('rpuk_licences:getLicences', function(obtained)
		inMenu, pedVisible = true, false
		ESX.UI.Menu.CloseAll()
		local playerPed = PlayerPedId()
		local vehiclesByCategory = {}
		local elements           = {}
		local firstVehicleData   = nil

		--table.insert(elements, {label = "📅 Current Licences", value = "check"})

		for k, v in pairs(licence_list) do
			if v.avail == 1 then
				table.insert(elements, {label = v.label, data = v, value = "purchase"})
			end
		end

		for k, v in pairs(obtained) do
			for i, data in pairs(elements) do
				if data.value == "purchase" and v.type == data.data.type then
					table.remove(elements, i)
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'licence_shop', {
			title    = "",
			css 	 = "city",
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
				title =  '',
				css   =  "city",
				align = 'top-right',
				elements = {
					{label = "Purchase Licence", value = 'purchase'},
			}}, function(data2, menu2)
				if data2.current.value == 'purchase' then
					TriggerServerEvent('rpuk_licences:purchase', data.current.data.type)
					ESX.UI.Menu.CloseAll()
					inMenu = false
				elseif data2.current.value == 'check' then
					current_licences(obtained)
				end
			end, function(data2, menu2)
				menu2.close()
				inMenu = false
				ESX.ShowHelpNotification("", 0, 0, 0)
			end)
		end, function(data, menu)
			menu.close()
			inMenu = false
			ESX.ShowHelpNotification("", 0, 0, 0)
		end, function(data, menu)
			local formatted = "[~b~" .. data.current.data.label .. "~s~]\nPurchase for ~g~£" .. data.current.data.price .. "~s~\n\n~b~Description:~s~\n" .. data.current.data.desc
			ESX.ShowHelpNotification(formatted, 0, 0, 0)
		end)
	end)
end

function current_licences(obtained)
	inMenu = true
	local elements = {}
	local dataType = nil

	for k, v in pairs(obtained) do
		print(ESX.DumpTable(v))
	end
	for k, v in pairs(licence_list) do
		print(ESX.DumpTable(v))
	end

	--table.insert(elements, {label = "📅 Current Licences", value = "check"})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'current_licences', {
		title    = '',
		css 	=  "city",
		align    = 'top-right',
		elements = elements
	}, function(data, menu)
		if data.current.value ~= nil then

		end
	end, function(data, menu)
		menu.close()
		inMenu = false
	end)
end