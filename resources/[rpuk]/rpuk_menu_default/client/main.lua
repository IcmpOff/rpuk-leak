Citizen.CreateThread(function()
	local menuType = 'default'
	local openMenus = {}

	local openMenu = function(namespace, name, data)
		openMenus[namespace .. '_' .. name] = true

		PlaySoundFrontend(-1, "CONTINUE", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

		SendNUIMessage({
			action    = 'openMenu',
			namespace = namespace,
			name      = name,
			data      = data,
		})

		SetNuiFocus(true, false)
	end

	local closeMenu = function(namespace, name)
		openMenus[namespace .. '_' .. name] = nil

		SendNUIMessage({
			action    = 'closeMenu',
			namespace = namespace,
			name      = name,
			data      = data,
		})

		if ESX.Table.SizeOf(openMenus) == 0 then
			SetNuiFocus(false)
			TriggerEvent('esx:resetNuiFocus')
		end
	end

	ESX.UI.Menu.RegisterType(menuType, openMenu, closeMenu)

	RegisterNUICallback('menu_submit', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(menuType, data._namespace, data._name)
		PlaySoundFrontend(-1, "CONTINUE", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

		if menu.submit ~= nil then
			menu.submit(data, menu)
		end

		cb('OK')
	end)

	RegisterNUICallback('menu_cancel', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(menuType, data._namespace, data._name)
		PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

		if menu.cancel ~= nil then
			menu.cancel(data, menu)
		end

		cb('OK')
	end)

	RegisterNUICallback('menu_change', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(menuType, data._namespace, data._name)

		for i=1, #data.elements, 1 do
			menu.setElement(i, 'value', data.elements[i].value)
			PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", true)

			if data.elements[i].selected then
				menu.setElement(i, 'selected', true)
			else
				menu.setElement(i, 'selected', false)
			end

		end

		if menu.change ~= nil then
			menu.change(data, menu)
		end

		cb('OK')
	end)

	AddEventHandler('esx:resetNuiFocus', function()
		if ESX.Table.SizeOf(openMenus) > 0 then
			Citizen.Wait(200)
			SetNuiFocus(true, false)
		end
	end)

	AddEventHandler('onResourceStop', function(resourceName)
		if resourceName == GetCurrentResourceName() then
			ESX.UI.Menu.CloseAll()
		end
	end)
end)
