-- Menu state
local showMenu = false
local wheelStatus = false

local MAX_MENU_ITEMS = 5

function getStatus()
	if showMenu then
		return true
	elseif not showMenu then
		return false
	end
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if showMenu then
			SetNuiFocus(false)
		end
	end
end)

-- Main thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if showMenu and IsControlPressed(1, 171) and IsInputDisabled(0) then
			showMenu = false
			SetNuiFocus(false, false)
			TriggerEvent("rpuk_wheel:wheelStatus", false)
		end

		if IsControlPressed(1, 171) and IsInputDisabled(0) then
			if not (exports.rpuk_inventory:getStatus() and not exports.chat:getStatus() and not exports.gcphone:getStatus()) then
				TriggerEvent("rpuk_wheel:wheelStatus", true)
				showMenu = true
				local enabledMenus = {}

				for _, menuConfig in ipairs(rootMenuConfig) do
					if menuConfig:enableMenu() then
						local dataElements = {}
						local hasSubMenus = false

						if menuConfig.subMenus ~= nil and #menuConfig.subMenus > 0 then
							hasSubMenus = true
							local previousMenu = dataElements
							local currentElement, numEnabledSubMenus = {}, 0
							for i = 1, #menuConfig.subMenus do
								local subMenu = menuConfig.subMenus[i]

								if (newSubMenus[subMenu].enableMenu ~= nil and newSubMenus[subMenu].enableMenu()) or newSubMenus[subMenu].enableMenu == nil then
									numEnabledSubMenus = numEnabledSubMenus + 1
									local element = newSubMenus[subMenu]

									currentElement[#currentElement+1] = {
										title = element.title,
										icon = element.icon,
										functionName = element.functionName,
										functionParameters = element.functionParameters
									}

									currentElement[#currentElement].id = subMenu

									if numEnabledSubMenus % MAX_MENU_ITEMS == 0 and numEnabledSubMenus < (#menuConfig.subMenus - 1) then
										previousMenu[MAX_MENU_ITEMS + 1] = {
											id = "_more",
											title = "More",
											icon = "#more",
											items = currentElement
										}

										previousMenu = currentElement
										currentElement = {}
									end
								end
							end

							if #currentElement > 0 then
								previousMenu[MAX_MENU_ITEMS + 1] = {
									id = "_more",
									title = "More",
									icon = "#more",
									items = currentElement
								}
							end

							if dataElements[MAX_MENU_ITEMS + 1] then
								dataElements = dataElements[MAX_MENU_ITEMS + 1].items
							end
						end

						enabledMenus[#enabledMenus+1] = {
							id = menuConfig.id,
							title = menuConfig.displayName,
							functionName = menuConfig.functionName,
							icon = menuConfig.icon,
						}

						if hasSubMenus then
							enabledMenus[#enabledMenus].items = dataElements
						end
					end
				end

				SendNUIMessage({
					state = "show",
					resourceName = GetCurrentResourceName(),
					data = enabledMenus,
					menuKeyBind = 'CapsLock'
				})

				SetCursorLocation(0.5, 0.5)
				SetNuiFocus(true, true)

				-- Play sound
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

				while showMenu == true do Citizen.Wait(100) end
				Citizen.Wait(100)
				while IsControlPressed(1, 171) and IsInputDisabled(0) do Citizen.Wait(100) end
			end
		end
	end
end)
-- Callback function for closing menu
RegisterNUICallback('closemenu', function(data, cb)
	-- Clear focus and destroy UI
	showMenu = false
	SetNuiFocus(false, false)
	TriggerEvent("inmenu",false)
	SendNUIMessage({
		state = 'destroy'
	})
	TriggerEvent("rpuk_wheel:wheelStatus", false)

	-- Play sound
	PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

	-- Send ACK to callback function
	cb('ok')
end)


RegisterNUICallback('playSelectSound', function(data, cb)
	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	cb('ok')
end)

RegisterNUICallback('playBackSound', function(data, cb)
	PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	cb('ok')
end)

-- Callback function for when a slice is clicked, execute command
RegisterNUICallback('triggerAction', function(data, cb)
	showMenu = false
	TriggerEvent("rpuk_wheel:wheelStatus", false)
	SetNuiFocus(false, false)
	SendNUIMessage({
		state = 'destroy'
	})

	PlaySoundFrontend(-1, "CONTINUE", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

	if allowedEvents[data.action] then
		TriggerEvent(data.action, data.parameters)
	else
		TriggerServerEvent('rpuk_anticheat:ab', 'illegal16')
	end

	cb('ok')
end)

RegisterNetEvent("menu:menuexit")
AddEventHandler("menu:menuexit", function()
	if showMenu then
		showMenu = false
		SetNuiFocus(false)
		TriggerEvent("inmenu", false)
		SendNUIMessage({state = 'destroy'})
		TriggerEvent("rpuk_wheel:wheelStatus", false)
	end
end)