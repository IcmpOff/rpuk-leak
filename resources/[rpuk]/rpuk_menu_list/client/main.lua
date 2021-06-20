Citizen.CreateThread(function()
	local menuType = 'list'
	local openMenus = {}

	local openMenu = function(namespace, name, data)
		openMenus[namespace .. '_' .. name] = true

		SendNUIMessage({
			action    = 'openMenu',
			namespace = namespace,
			name      = name,
			data      = data
		})

		Citizen.Wait(200)
		SetNuiFocus(true, true)
	end

	local closeMenu = function(namespace, name)
		openMenus[namespace .. '_' .. name] = nil

		SendNUIMessage({
			action    = 'closeMenu',
			namespace = namespace,
			name      = name,
			data      = data
		})

		if ESX.Table.SizeOf(openMenus) == 0 then
			SetNuiFocus(false)
			TriggerEvent('esx:resetNuiFocus')
		end
	end

	ESX.UI.Menu.RegisterType(menuType, openMenu, closeMenu)

	RegisterNUICallback('menu_submit', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(menuType, data._namespace, data._name)

		if menu.submit ~= nil then
			menu.submit(data, menu)
		end

		cb('OK')
	end)

	RegisterNUICallback('menu_cancel', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(menuType, data._namespace, data._name)

		if menu.cancel ~= nil then
			menu.cancel(data, menu)
		end

		cb('OK')
	end)

	AddEventHandler('esx:resetNuiFocus', function()
		if ESX.Table.SizeOf(openMenus) > 0 then
			Citizen.Wait(200)
			SetNuiFocus(true, true)
		end
	end)

	AddEventHandler('onResourceStop', function(resourceName)
		if resourceName == GetCurrentResourceName() then
			ESX.UI.Menu.CloseAll()
		end
	end)
end)