local chatInputActive = false
local chatInputActivating = false
local chatHidden = true
local chatLoaded = false
local shouldBeHidden = false
local hideChat = false
local inventoryStatus = false

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:removeTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')
RegisterNetEvent("rpuk_inventory:inventoryStatus")

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if chatInputActive then
			SetNuiFocus(false)
		end
	end
end)

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

AddEventHandler("rpuk_inventory:inventoryStatus", function(status)
	inventoryStatus = status
end)

--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
	local args = { text }

	if author ~= "" then
		table.insert(args, 1, author)
	end

	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = {
			color = color,
			multiline = true,
			args = args
		}
	})
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
	print(msg)
end)

AddEventHandler('chat:addMessage', function(message)
	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = message
	})
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
	SendNUIMessage({
		type = 'ON_SUGGESTION_ADD',
		suggestion = {
			name = name,
			help = help,
			params = params or nil
		}
	})
end)

AddEventHandler('chat:addSuggestions', function(suggestions)
	for _, suggestion in ipairs(suggestions) do
		SendNUIMessage({
			type = 'ON_SUGGESTION_ADD',
			suggestion = suggestion
		})
	end
end)

AddEventHandler('chat:removeSuggestion', function(name)
	SendNUIMessage({
		type = 'ON_SUGGESTION_REMOVE',
		name = name
	})
end)

AddEventHandler('chat:addTemplate', function(id, html)
	SendNUIMessage({
		type = 'ON_TEMPLATE_ADD',
		template = {id = id, html = html}
	})
end)


AddEventHandler('chat:removeTemplate', function(id)
	SendNUIMessage({
		type = 'ON_TEMPLATE_REMOVE',
		template = {id = id}
	})
end)

AddEventHandler('chat:clear', function(name)
	SendNUIMessage({type = 'ON_CLEAR'})
end)


RegisterNUICallback('chatResult', function(data, cb)
	chatInputActive = false
	SetNuiFocus(false)
	TriggerEvent("chat:chatStatus", false)

	if not data.canceled then
		local id = PlayerId()

		--deprecated
		local r, g, b = 0, 0x99, 255

		if data.message:sub(1, 1) == '/' then
			ExecuteCommand(data.message:sub(2))
		end
	end

	cb('ok')
end)

local function refreshCommands()
	if GetRegisteredCommands then
		local registeredCommands = GetRegisteredCommands()
		local suggestions = {}

		for _, command in ipairs(registeredCommands) do
			if IsAceAllowed(('command.%s'):format(command.name)) then
				table.insert(suggestions, {
					name = '/' .. command.name,
					help = ''
				})
			end
		end

		TriggerEvent('chat:addSuggestions', suggestions)
	end
end

local function refreshThemes()
	local themes = {}

	for resIdx = 0, GetNumResources() - 1 do
		local resource = GetResourceByFindIndex(resIdx)

		if GetResourceState(resource) == 'started' then
			local numThemes = GetNumResourceMetadata(resource, 'chat_theme')

			if numThemes > 0 then
				local themeName = GetResourceMetadata(resource, 'chat_theme')
				local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')

				if themeName and themeData then
					themeData.baseUrl = 'nui://' .. resource .. '/'
					themes[themeName] = themeData
				end
			end
		end
	end

	SendNUIMessage({
		type = 'ON_UPDATE_THEMES',
		themes = themes
	})
end

RegisterNUICallback('loaded', function(data, cb)
	TriggerServerEvent('chat:init');

	refreshCommands()
	refreshThemes()

	chatLoaded = true

	cb('ok')
end)

Citizen.CreateThread(function()
	SetTextChatEnabled(false)

	while true do
		Citizen.Wait(0)

		if not chatInputActive then
			if IsControlPressed(0, 245) then
				local alertsUI = exports["rpuk_alerts"]:getStatus()
				local inventoryUI = exports["rpuk_inventory"]:getStatus()
				local wheelUI = exports["rpuk_wheel"]:getStatus()
				local phoneUI = exports["gcphone"]:getStatus()

				if not inventoryUI and not wheelUI and not phoneUI and not alertsUI then
					chatInputActive = true
					chatInputActivating = true

					TriggerEvent("chat:chatStatus", true)

					SendNUIMessage({
						type = 'ON_OPEN'
					})
				end
			end
		end

		if chatInputActivating then
			if not IsControlPressed(0, 245) and not inventoryStatus and not alertsUI then
			SetNuiFocus(true)

			chatInputActivating = false
			end
		end

		if chatLoaded then
			if not hideChat then
				shouldBeHidden = false
			else
				shouldBeHidden = true
			end

			if IsScreenFadedOut() or IsPauseMenuActive() then
				shouldBeHidden = true
			end

			if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then
				chatHidden = shouldBeHidden

				SendNUIMessage({
					type = 'ON_SCREEN_STATE_CHANGE',
					shouldHide = shouldBeHidden
				})
			end
		end
	end
end)

RegisterNetEvent('rpuk_core:toggle_chat')
AddEventHandler('rpuk_core:toggle_chat', function()
	hideChat = not hideChat
end)

function getStatus() return chatInputActive end