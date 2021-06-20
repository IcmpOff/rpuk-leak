local KeyToucheCloseEvent = {
	{ code = 172, event = 'ArrowUp' },
	{ code = 173, event = 'ArrowDown' },
	{ code = 174, event = 'ArrowLeft' },
	{ code = 175, event = 'ArrowRight' },
	{ code = 176, event = 'Enter' },
	{ code = 177, event = 'Backspace' },
}

local menuIsOpen = false
local contacts = {}
local messages = {}
myPhoneNumber = ''
local useMouse = false
local ignoreFocus = false
isUsingCamera = false
hasFocus = false

function hasPhone(cb) cb((ESX.Player.GetInventory().phone and ESX.Player.GetInventory().phone.count > 0)) end

function getStatus() return menuIsOpen end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuIsOpen then
			SetNuiFocus(false)
		end

		if isUsingCamera then
			DestroyMobilePhone()
			CellCamActivate(false, false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(400)
		local formattedTime = ('%02d:%02d'):format(GetClockHours(), GetClockMinutes())
		SendNUIMessage({event = 'setTime', time = formattedTime})
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local player = PlayerPedId()
		local isInVehicle = IsPedInAnyVehicle(player, false)

		if isInVehicle or menuIsOpen and not isUsingCamera then
			DisplayRadar(true)
		else
			DisplayRadar(false)
		end

		if not isUsingCamera then
			if menuIsOpen then
				for _, value in ipairs(KeyToucheCloseEvent) do
					if IsControlJustReleased(1, value.code) then
						SendNUIMessage({keyUp = value.event})
					end
				end

				if useMouse and hasFocus == ignoreFocus then
					local nuiFocus = not hasFocus
					SetNuiFocus(nuiFocus, nuiFocus)
					hasFocus = nuiFocus
				elseif not useMouse and hasFocus then
					SetNuiFocus(false, false)
					hasFocus = false
				end
			else
				if hasFocus then
					SetNuiFocus(false, false)
					hasFocus = false
				end
			end
		end
	end
end)

--====================================================================================
--  Active ou Deactive une application (appName => config.json)
--====================================================================================

RegisterNetEvent('gcPhone:setEnableApp')
AddEventHandler('gcPhone:setEnableApp', function(appName, enable)
	SendNUIMessage({event = 'setEnableApp', appName = appName, enable = enable })
end)

function TakeAppel(infoCall)
	TriggerEvent('gcphone:autoAcceptCall', infoCall)
end

RegisterNetEvent('gcPhone:notifyFixePhoneChange')
AddEventHandler('gcPhone:notifyFixePhoneChange', function(_PhoneInCall)
	PhoneInCall = _PhoneInCall
end)

function PlaySoundJS(sound, volume)
	SendNUIMessage({ event = 'playSound', sound = sound, volume = volume })
end

function SetSoundVolumeJS(sound, volume)
	SendNUIMessage({ event = 'setSoundVolume', sound = sound, volume = volume})
end

function StopSoundJS(sound)
	SendNUIMessage({ event = 'stopSound', sound = sound})
end

RegisterNetEvent('gcPhone:forceOpenPhone')
AddEventHandler('gcPhone:forceOpenPhone', function(_myPhoneNumber)
	if not menuIsOpen then
		TooglePhone()
	end
end)

--====================================================================================
--  Events
--====================================================================================

RegisterNetEvent('gcPhone:myPhoneNumber')
AddEventHandler('gcPhone:myPhoneNumber', function(_myPhoneNumber)
	myPhoneNumber = _myPhoneNumber
	SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})
end)

RegisterNetEvent('gcPhone:contactList')
AddEventHandler('gcPhone:contactList', function(_contacts)
	SendNUIMessage({event = 'updateContacts', contacts = _contacts})
	contacts = _contacts
end)

RegisterNetEvent('gcPhone:allMessage')
AddEventHandler('gcPhone:allMessage', function(allmessages)
	SendNUIMessage({event = 'updateMessages', messages = allmessages})
	messages = allmessages
end)

RegisterNetEvent('gcPhone:getBourse')
AddEventHandler('gcPhone:getBourse', function(bourse)
	SendNUIMessage({event = 'updateBourse', bourse = bourse})
end)

RegisterNetEvent('gcPhone:receiveMessage')
AddEventHandler('gcPhone:receiveMessage', function(message)
	local coords = GetEntityCoords(PlayerPedId())

	if exports.gcphone:mastCheck(coords) then
		SendNUIMessage({event = 'newMessage', message = message})
		table.insert(messages, message)

		if message.owner == 0 then
			hasPhone(function(_hasPhone)
				if _hasPhone then
					local msg = 'Incoming message from '.. message.transmitter

					for _,contact in pairs(contacts) do
						if contact.number == message.transmitter then
							msg = 'Incoming message from '.. contact.display
							break
						end
					end

					TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'inform', text = msg })

					for i=1, 3 do
						PlaySound(-1, 'Menu_Accept', 'Phone_SoundSet_Default', 0, 0, 1)
						Citizen.Wait(300)
					end
				end
			end)
		end
	end
end)

--====================================================================================
--  Function client | Contacts
--====================================================================================

function addContact(display, num) TriggerServerEvent('gcPhone:addContact', display, num) end

function deleteContact(num) TriggerServerEvent('gcPhone:deleteContact', num) end

--====================================================================================
--  Function client | Messages
--====================================================================================

function sendMessage(num, message)
	local coords = GetEntityCoords(PlayerPedId())
	if exports.gcphone:mastCheck(coords) then
		TriggerServerEvent('gcPhone:sendMessage', num, message)
	end
end

function deleteMessage(msgId)
	TriggerServerEvent('gcPhone:deleteMessage', msgId)

	for k, v in ipairs(messages) do
		if v.id == msgId then
			table.remove(messages, k)
			SendNUIMessage({event = 'updateMessages', messages = messages})
			return
		end
	end
end

function deleteMessageContact(num) TriggerServerEvent('gcPhone:deleteMessageNumber', num) end

function deleteAllMessage() TriggerServerEvent('gcPhone:deleteAllMessage') end

function setReadMessageNumber(num)
	TriggerServerEvent('gcPhone:setReadMessageNumber', num)

	for k, v in ipairs(messages) do
		if v.transmitter == num then
			v.isRead = 1
		end
	end
end

function requestAllMessages() TriggerServerEvent('gcPhone:requestAllMessages') end
function requestAllContact() TriggerServerEvent('gcPhone:requestAllContact') end

--====================================================================================
--  Function client | Appels
--====================================================================================

local aminCall = false
local inCall = false

RegisterNetEvent('gcPhone:waitingCall')
AddEventHandler('gcPhone:waitingCall', function(infoCall, initiator)
	local coords = GetEntityCoords(PlayerPedId())

	if exports.gcphone:mastCheck(coords) then
		SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
		if initiator then
			PhonePlayCall()
			if not menuIsOpen then
				TooglePhone()
			end
		else
			hasPhone(function(_hasPhone)
				if _hasPhone then
					if not menuIsOpen then
						TooglePhone()
					end
					TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'inform', text = 'Incoming phone call' })
				end
			end)
		end
	end
end)

RegisterNetEvent('gcPhone:acceptCall')
AddEventHandler('gcPhone:acceptCall', function(infoCall, initiator)
	local coords = GetEntityCoords(PlayerPedId())

	if exports.gcphone:mastCheck(coords) then
		if not inCall then
			inCall = true
			exports["pma-voice"]:setCallChannel(infoCall.id + 1)
		end

		if not menuIsOpen then
			TooglePhone()
		end

		PhonePlayCall()
		SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})
	end
end)

RegisterNetEvent("gcPhone:rejectCall")
AddEventHandler("gcPhone:rejectCall", function(infoCall)
	local coords = GetEntityCoords(PlayerPedId())
	if exports.gcphone:mastCheck(coords) then
		if inCall == true then
			inCall = false
			exports["pma-voice"]:removePlayerFromCall()
		end

		PhonePlayText()
		SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
	end
end)

RegisterNetEvent('gcPhone:historiqueCall')
AddEventHandler('gcPhone:historiqueCall', function(historique)
	SendNUIMessage({event = 'historiqueCall', historique = historique})
end)

function startCall(phone_number, rtcOffer, extraData)
	local coords = GetEntityCoords(PlayerPedId())

	if exports.gcphone:mastCheck(coords) then
		TriggerServerEvent('gcPhone:startCall', phone_number, rtcOffer, extraData)
	end
end

function acceptCall(infoCall, rtcAnswer) TriggerServerEvent('gcPhone:acceptCall', infoCall, rtcAnswer) end

function rejectCall(infoCall) TriggerServerEvent('gcPhone:rejectCall', infoCall) end

function ignoreCall(infoCall) TriggerServerEvent('gcPhone:ignoreCall', infoCall) end

function requestHistoriqueCall() TriggerServerEvent('gcPhone:getHistoriqueCall') end

function appelsDeleteHistorique(num) TriggerServerEvent('gcPhone:appelsDeleteHistorique', num) end

function appelsDeleteAllHistorique() TriggerServerEvent('gcPhone:appelsDeleteAllHistorique') end

--====================================================================================
--	Event NUI - Appels
--====================================================================================

RegisterNUICallback('startCall', function(data, cb)
	startCall(data.numero, data.rtcOffer, data.extraData)
	cb()
end)

RegisterNUICallback('acceptCall', function(data, cb)
	acceptCall(data.infoCall, data.rtcAnswer)
	cb()
end)
RegisterNUICallback('rejectCall', function(data, cb)
	rejectCall(data.infoCall)
	cb()
end)

RegisterNUICallback('ignoreCall', function(data, cb)
	ignoreCall(data.infoCall)
	cb()
end)

RegisterNetEvent('gcphone:autoCall')
AddEventHandler('gcphone:autoCall', function(number, extraData)
	if number then
		SendNUIMessage({ event = 'autoStartCall', number = number, extraData = extraData})
	end
end)

RegisterNetEvent('gcphone:autoCallNumber')
AddEventHandler('gcphone:autoCallNumber', function(data)
	TriggerEvent('gcphone:autoCall', data.number)
end)

RegisterNetEvent('gcphone:autoAcceptCall')
AddEventHandler('gcphone:autoAcceptCall', function(infoCall)
	SendNUIMessage({ event = 'autoAcceptCall', infoCall = infoCall})
end)

--====================================================================================
--	Gestion des evenements NUI
--====================================================================================
RegisterNUICallback('log', function(data, cb)
	--print(data)
	cb()
end)

RegisterNUICallback('focus', function(data, cb)
	cb()
end)

RegisterNUICallback('blur', function(data, cb)
	cb()
end)

RegisterNUICallback('reponseText', function(data, cb)
	local limit = data.limit or 255
	local text = data.text or ''
	AddTextEntry('screen_label', data.title or 'Input')

	DisplayOnscreenKeyboard(1, "screen_label", "", text, "", "", "", limit)

	while UpdateOnscreenKeyboard() == 0 do
		DisableAllControlActions(0)
		Citizen.Wait(0)
	end

	if GetOnscreenKeyboardResult() then
		text = GetOnscreenKeyboardResult()
	else
		text = nil
	end

	cb(json.encode({text = text}))
end)

--====================================================================================
--  Event - Messages
--====================================================================================

RegisterNUICallback('getMessages', function(data, cb)
	cb(json.encode(messages))
end)

RegisterNUICallback('sendMessage', function(data, cb)
	if data.message == '%pos%' then
		local coords = GetEntityCoords(PlayerPedId())
		data.message = ('GPS: %.1f, %.1f'):format(coords.x, coords.y)
	end

	TriggerServerEvent('gcPhone:sendMessage', data.phoneNumber, data.message)
end)

RegisterNUICallback('deleteMessage', function(data, cb)
	deleteMessage(data.id)
	cb()
end)

RegisterNUICallback('deleteMessageNumber', function(data, cb)
	deleteMessageContact(data.number)
	cb()
end)

RegisterNUICallback('deleteAllMessage', function(data, cb)
	deleteAllMessage()
	cb()
end)

RegisterNUICallback('setReadMessageNumber', function(data, cb)
	setReadMessageNumber(data.number)
	cb()
end)

--====================================================================================
--  Event - Contacts
--====================================================================================
RegisterNUICallback('addContact', function(data, cb)
	TriggerServerEvent('gcPhone:addContact', data.display, data.phoneNumber)
end)

RegisterNUICallback('updateContact', function(data, cb)
	TriggerServerEvent('gcPhone:updateContact', data.id, data.display, data.phoneNumber)
end)

RegisterNUICallback('deleteContact', function(data, cb)
	TriggerServerEvent('gcPhone:deleteContact', data.id)
end)

RegisterNUICallback('getContacts', function(data, cb)
	cb(json.encode(contacts))
end)

RegisterNUICallback('setGPS', function(data, cb)
	SetNewWaypoint(tonumber(data.x), tonumber(data.y))
	cb()
end)

-- Add security for event (leuit#0100)
RegisterNUICallback('callEvent', function(data, cb)
	local eventName = data.eventName or ''
	if string.match(eventName, 'gcphone') then
		if data.data then
			TriggerEvent(data.eventName, data.data)
		else
			TriggerEvent(data.eventName)
		end
	end

	cb()
end)

RegisterNUICallback('useMouse', function(um, cb)
	useMouse = um
end)

RegisterNUICallback('deleteALL', function(data, cb)
	TriggerServerEvent('gcPhone:deleteALL')
	cb()
end)

function TooglePhone()
	menuIsOpen = not menuIsOpen
	SendNUIMessage({show = menuIsOpen})
	local dead = exports.rpuk_health:deadStatus()

	if menuIsOpen and not dead then
		PhonePlayIn()
	else
		PhonePlayOut()
	end
end

function checkAnimationStates()
	local playerPed = PlayerPedId()
	if IsEntityPlayingAnim(playerPed, "random@mugging3", "handsup_standing_base", 3) then return true end -- Surrender Standing Up Anim
	if IsEntityPlayingAnim(playerPed, "mp_arresting", "idle", 3) then return true end -- Restrain Anim
	if IsEntityPlayingAnim(playerPed, "random@arrests@busted", "idle_a", 3) then return true end
	if IsEntityPlayingAnim(playerPed, "anim@move_m@prisoner_cuffed", "idle", 3) then return true end -- Ziptie Anim
	if IsEntityPlayingAnim(playerPed, "dead", "dead_a", 3) then return true end -- Sedate Anim
	if IsEntityPlayingAnim(playerPed, "misslamar1dead_body", "dead_idle", 3) then return true end -- Dead Anim

	return false
end

RegisterKeyMapping('openphone', 'Open phone', 'keyboard', 'F2')
TriggerEvent('chat:addSuggestion', '/openphone', 'Open phone')

RegisterCommand('openphone', function()
	if not checkAnimationStates() and not IsPauseMenuActive() then
		hasPhone(function(hasPhone)
			if hasPhone then
				TooglePhone()
			else
				ESX.ShowNotification('You do not have a phone', 5000, 'error')
			end
		end)
	end
end)

RegisterNUICallback('closePhone', function(data, cb)
	menuIsOpen = false
	SendNUIMessage({show = false})
	PhonePlayOut()
	cb()
end)

RegisterNUICallback('appelsDeleteHistorique', function(data, cb)
	appelsDeleteHistorique(data.numero)
	cb()
end)

RegisterNUICallback('appelsDeleteAllHistorique', function(data, cb)
	appelsDeleteAllHistorique(data.infoCall)
	cb()
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(1000)
		TriggerServerEvent('gcPhone:allUpdate')
	end
end)

RegisterNUICallback('setIgnoreFocus', function(data, cb)
	ignoreFocus = data.ignoreFocus
	cb()
end)