Citizen.CreateThread(function()
	local timeouts = {}
	local menuType = 'dialog'
	local openMenus = {}

	local openMenu = function(namespace, name, data)
		openMenus[namespace .. '_' .. name] = true
		SetNuiFocus(false)

		for i=1, #timeouts, 1 do
			ESX.ClearTimeout(timeouts[i])
		end

		SendNUIMessage({
			action    = 'openMenu',
			namespace = namespace,
			name      = name,
			data      = data
		})

		Citizen.Wait(200)
		SetNuiFocus(true, true)

		table.insert(timeouts, timeoutId)
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
		local post = true

		if menu.submit ~= nil then

			-- Is the submitted data a number?
			if tonumber(data.value) ~= nil then

				-- Round float values
				data.value = ESX.Math.Round(tonumber(data.value))

				-- Check for negative value
				if tonumber(data.value) <= 0 then
					post = false
				end
			end

			data.value = ESX.Math.Trim(data.value)

			-- Don't post if the value is negative or if it's 0
			if post then
				menu.submit(data, menu)
			else
				ESX.ShowNotification('That input is invalid!')
			end
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

	RegisterNUICallback('menu_change', function(data, cb)
		local menu = ESX.UI.Menu.GetOpened(menuType, data._namespace, data._name)

		if menu.change ~= nil then
			menu.change(data, menu)
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