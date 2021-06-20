local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10
local stockMarket = {}

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	xPlayer.triggerEvent('gcPhone:myPhoneNumber', xPlayer.getPhoneNumber())
	xPlayer.triggerEvent('gcPhone:getBourse', stockMarket)
	xPlayer.triggerEvent('gcPhone:contactList', getContacts(xPlayer.getCharacterId()))
	xPlayer.triggerEvent('gcPhone:allMessage', getMessages(xPlayer.getPhoneNumber()))
	sendHistoriqueCall(playerId, xPlayer.getPhoneNumber())
end)

ESX.RegisterServerCallback('gcphone:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.getInventoryItem(item)
	if items == nil then
		cb(0)
	else
		cb(items.count)
	end
end)

-- Used when restarting resource midgame
RegisterNetEvent('gcPhone:allUpdate')
AddEventHandler('gcPhone:allUpdate', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local phoneNumber = xPlayer.getPhoneNumber()

		xPlayer.triggerEvent('gcPhone:myPhoneNumber', phoneNumber)
		xPlayer.triggerEvent('gcPhone:contactList', getContacts(xPlayer.getCharacterId()))
		xPlayer.triggerEvent('gcPhone:allMessage', getMessages(phoneNumber))
		xPlayer.triggerEvent('gcPhone:getBourse', stockMarket)

		sendHistoriqueCall(xPlayer.playerId, phoneNumber)
	end
end)

MySQL.ready(function()
	MySQL.Async.fetchAll('DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 10)')
end)

function getPlayerIdFromCharacterId(characterId, cb)
	local xPlayer = ESX.GetPlayerFromCharId(characterId)

	if xPlayer then
		cb(xPlayer.playerId)
	else
		cb(nil)
	end
end

function getCharacterIdFromPhoneNumber(phoneNumber)
	local result = MySQL.Sync.fetchAll('SELECT rpuk_charid FROM users WHERE phone_number = @phone_number', {
		['@phone_number'] = phoneNumber
	})

	if result[1] then return result[1].rpuk_charid end
	return nil
end

function getContacts(characterId)
	return MySQL.Sync.fetchAll('SELECT * FROM phone_users_contacts WHERE rpuk_charid = @rpuk_charid', {
		['@rpuk_charid'] = characterId
	})
end

function addContact(source, characterId, number, display)
	local sourcePlayer = tonumber(source)

	MySQL.Async.insert('INSERT INTO phone_users_contacts (`rpuk_charid`, `number`, `display`) VALUES (@rpuk_charid, @number, @display)', {
		['@rpuk_charid'] = characterId,
		['@number'] = number,
		['@display'] = display,
	}, function()
		notifyContactChange(sourcePlayer)
	end)
end

function updateContact(source, id, number, display)
	local sourcePlayer = tonumber(source)
	MySQL.Async.insert('UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id', {
		['@number'] = number,
		['@display'] = display,
		['@id'] = id,
	}, function()
		notifyContactChange(sourcePlayer)
	end)
end

function deleteContact(playerId, characterId, id)
	MySQL.Sync.execute('DELETE FROM phone_users_contacts WHERE rpuk_charid = @rpuk_charid AND id = @id', {
		['@rpuk_charid'] = characterId,
		['@id'] = id,
	})

	notifyContactChange(playerId)
end

function deleteAllContact(characterId)
	MySQL.Sync.execute('DELETE FROM phone_users_contacts WHERE rpuk_charid = @rpuk_charid', {
		['@rpuk_charid'] = characterId
	})
end

function notifyContactChange(source)
	local sourcePlayer = tonumber(source)

	if sourcePlayer then
		local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
		TriggerClientEvent('gcPhone:contactList', sourcePlayer, getContacts(xPlayer.getCharacterId()))
	end
end

RegisterNetEvent('gcPhone:addContact')
AddEventHandler('gcPhone:addContact', function(display, phoneNumber)
	local xPlayer = ESX.GetPlayerFromId(source)
	addContact(source, xPlayer.getCharacterId(), phoneNumber, display)
end)

RegisterNetEvent('gcPhone:updateContact')
AddEventHandler('gcPhone:updateContact', function(id, display, phoneNumber)
	local sourcePlayer = tonumber(source)
	updateContact(sourcePlayer, id, phoneNumber, display)
end)

RegisterNetEvent('gcPhone:deleteContact')
AddEventHandler('gcPhone:deleteContact', function(id)
	local xPlayer = ESX.GetPlayerFromId(source)
	deleteContact(source, xPlayer.getCharacterId(), id)
end)

function getMessages(phoneNumber)
	local result = MySQL.Sync.fetchAll('SELECT * FROM phone_messages WHERE receiver = @receiver LIMIT 250', {
		['@receiver'] = phoneNumber
	})

	return result
end

RegisterNetEvent('gcPhone:_internalAddMessage')
AddEventHandler('gcPhone:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
	cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

function _internalAddMessage(transmitter, receiver, message, owner)
	local id = MySQL.Sync.insert('INSERT INTO phone_messages (`transmitter`, `receiver`, `message`, `isRead`, `owner`) VALUES (@transmitter, @receiver, @message, @isRead, @owner)', {
		['@transmitter'] = transmitter,
		['@receiver'] = receiver,
		['@message'] = message or '',
		['@isRead'] = owner,
		['@owner'] = owner
	})

	return {id = id, transmitter = transmitter, receiver = receiver,
			message = message or '', isRead = owner, owner = owner, time=os.time()*1000}
end

function addMessage(source, targetPhoneNumber, message)
	local sourcePlayer = tonumber(source)
	local targetPlayerCharacterId = getCharacterIdFromPhoneNumber(targetPhoneNumber)
	local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
	local myPhone = xPlayer.getPhoneNumber()

	if targetPlayerCharacterId then
		local tomess = _internalAddMessage(myPhone, targetPhoneNumber, message, 0)

		getPlayerIdFromCharacterId(targetPlayerCharacterId, function(targetPlayer)
			if targetPlayer then
				TriggerClientEvent('gcPhone:receiveMessage', targetPlayer, tomess)
			end
		end)
	end

	local memess = _internalAddMessage(targetPhoneNumber, myPhone, message, 1)
	TriggerClientEvent('gcPhone:receiveMessage', sourcePlayer, memess)
end

function setReadMessageNumber(myPhoneNumber, num)
	MySQL.Sync.execute('UPDATE phone_messages SET isRead = 1 WHERE receiver = @receiver AND transmitter = @transmitter', {
		['@receiver'] = tostring(myPhoneNumber),
		['@transmitter'] = tostring(num)
	})
end

function deleteMessage(msgId)
	MySQL.Sync.execute('DELETE FROM phone_messages WHERE `id` = @id', {
		['@id'] = msgId
	})
end

function deleteAllMessageFromPhoneNumber(playerPhoneNumber, targetPhoneNumber)
	MySQL.Sync.execute('DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number', {
		['@mePhoneNumber'] = tostring(playerPhoneNumber),
		['@phone_number'] = tostring(targetPhoneNumber)
	})
end

function deleteAllMessage(phoneNumber)
	MySQL.Sync.execute('DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber', {
		['@mePhoneNumber'] = tostring(phoneNumber)
	})
end

RegisterNetEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(phoneNumber, message)
	local sourcePlayer = tonumber(source)
	local identifier = GetPlayerIdentifier(source, 0)
	addMessage(sourcePlayer, phoneNumber, message)

	print("RPUK:" .. sourcePlayer .. " " .. identifier .. " " .. phoneNumber .. " " .. message)
end)

RegisterNetEvent('gcPhone:deleteMessage')
AddEventHandler('gcPhone:deleteMessage', function(msgId)
	deleteMessage(msgId)
end)

RegisterNetEvent('gcPhone:deleteMessageNumber')
AddEventHandler('gcPhone:deleteMessageNumber', function(number)
	local xPlayer = ESX.GetPlayerFromId(source)
	deleteAllMessageFromPhoneNumber(xPlayer.getPhoneNumber(), number)
end)

RegisterNetEvent('gcPhone:deleteAllMessage')
AddEventHandler('gcPhone:deleteAllMessage', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	deleteAllMessage(xPlayer.getPhoneNumber())
end)

RegisterNetEvent('gcPhone:setReadMessageNumber')
AddEventHandler('gcPhone:setReadMessageNumber', function(num)
	local xPlayer = ESX.GetPlayerFromId(source)
	setReadMessageNumber(xPlayer.getPhoneNumber(), num)
end)

RegisterNetEvent('gcPhone:deleteALL')
AddEventHandler('gcPhone:deleteALL', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	deleteAllMessage(xPlayer.getPhoneNumber())
	deleteAllContact(xPlayer.getCharacterId())
	appelsDeleteAllHistorique(xPlayer.getPhoneNumber())
	xPlayer.triggerEvent('gcPhone:contactList', {})
	xPlayer.triggerEvent('gcPhone:allMessage', {})
	xPlayer.triggerEvent('appelsDeleteAllHistorique', {})
end)

function getHistoriqueCall(num)
	local result = MySQL.Sync.fetchAll('SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120', {
		['@num'] = num
	})

	return result
end

function sendHistoriqueCall(src, num)
	local histo = getHistoriqueCall(num)
	TriggerClientEvent('gcPhone:historiqueCall', src, histo)
end

function saveAppels(appelInfo)
	if not appelInfo.extraData or not appelInfo.extraData.useNumber then
		MySQL.Async.insert('INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES (@owner, @num, @incoming, @accepts)', {
			['@owner'] = appelInfo.transmitter_num,
			['@num'] = appelInfo.receiver_num,
			['@incoming'] = 1,
			['@accepts'] = appelInfo.is_accepts
		}, function()
			notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
		end)
	end

	if appelInfo.is_valid and not appelInfo.hidden then
		local num = appelInfo.transmitter_num

		MySQL.Async.insert('INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES (@owner, @num, @incoming, @accepts)', {
			['@owner'] = appelInfo.receiver_num,
			['@num'] = num,
			['@incoming'] = 0,
			['@accepts'] = appelInfo.is_accepts
		}, function()
			if appelInfo.receiver_src then
				notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
			end
		end)
	end
end

function notifyNewAppelsHisto(src, num)
	sendHistoriqueCall(src, num)
end

RegisterNetEvent('gcPhone:getHistoriqueCall')
AddEventHandler('gcPhone:getHistoriqueCall', function()
	sendHistoriqueCall(source, num)
end)

RegisterNetEvent('gcPhone:internal_startCall')
AddEventHandler('gcPhone:internal_startCall', function(source, phone_number, rtcOffer, extraData)
	if FixePhone[phone_number] then
		onCallFixePhone(source, phone_number, rtcOffer, extraData)
		return
	end

	if not phone_number or phone_number == '' then return end

	local hidden = string.sub(phone_number, 1, 1) == '#' -- todo hidden?

	if hidden then phone_number = string.sub(phone_number, 2) end

	local indexCall = lastIndexCall
	lastIndexCall = lastIndexCall + 1
	local sourcePlayer = tonumber(source)
	local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
	local srcPhone

	if extraData and extraData.useNumber then
		srcPhone = extraData.useNumber
	else
		srcPhone = xPlayer.getPhoneNumber()
	end

	local targetPlayerCharacterId = getCharacterIdFromPhoneNumber(phone_number)
	local is_valid = targetPlayerCharacterId and targetPlayerCharacterId ~= xPlayer.getCharacterId()

	AppelsEnCours[indexCall] = {
		id = indexCall,
		transmitter_src = sourcePlayer,
		transmitter_num = srcPhone,
		receiver_src = nil,
		receiver_num = phone_number,
		is_valid = is_valid,
		is_accepts = false,
		hidden = hidden,
		rtcOffer = rtcOffer,
		extraData = extraData
	}

	if is_valid then
		getPlayerIdFromCharacterId(targetPlayerCharacterId, function (targetPlayer)
			if targetPlayer then
				AppelsEnCours[indexCall].receiver_src = targetPlayer
				TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
				TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
				TriggerClientEvent('gcPhone:waitingCall', targetPlayer, AppelsEnCours[indexCall], false)
			else
				TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
				TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
			end
		end)
	else
		TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
		TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
	end
end)

RegisterNetEvent('gcPhone:startCall')
AddEventHandler('gcPhone:startCall', function(phone_number, rtcOffer, extraData)
	TriggerEvent('gcPhone:internal_startCall',source, phone_number, rtcOffer, extraData)
end)

RegisterNetEvent('gcPhone:acceptCall')
AddEventHandler('gcPhone:acceptCall', function(infoCall, rtcAnswer)
	local id = infoCall.id

	if AppelsEnCours[id] then
		if PhoneFixeInfo[id] then
			onAcceptFixePhone(source, infoCall, rtcAnswer)
			return
		end

		AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src

		if AppelsEnCours[id].transmitter_src and AppelsEnCours[id].receiver_src~= nil then
			AppelsEnCours[id].is_accepts = true
			AppelsEnCours[id].rtcAnswer = rtcAnswer
			TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
			TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
			saveAppels(AppelsEnCours[id])
		end
	end
end)

RegisterNetEvent('gcPhone:rejectCall')
AddEventHandler('gcPhone:rejectCall', function (infoCall)
	local id = infoCall.id

	if AppelsEnCours[id] then
		if PhoneFixeInfo[id] then
			onRejectFixePhone(source, infoCall)
			return
		end

		if AppelsEnCours[id].transmitter_src then
			TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
		end

		if AppelsEnCours[id].receiver_src then
			TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].receiver_src)
		end

		if AppelsEnCours[id].is_accepts == false then
			saveAppels(AppelsEnCours[id])
		end

		TriggerEvent('gcPhone:removeCall', AppelsEnCours)
		AppelsEnCours[id] = nil
	end
end)

RegisterNetEvent('gcPhone:appelsDeleteHistorique')
AddEventHandler('gcPhone:appelsDeleteHistorique', function(numero)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Sync.execute('DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num', {
		['@owner'] = tostring(xPlayer.getPhoneNumber()),
		['@num'] = tostring(numero)
	})
end)

function appelsDeleteAllHistorique(phoneNumber)
	MySQL.Sync.execute('DELETE FROM phone_calls WHERE `owner` = @owner', {
		['@owner'] = tostring(phoneNumber)
	})
end

RegisterNetEvent('gcPhone:appelsDeleteAllHistorique')
AddEventHandler('gcPhone:appelsDeleteAllHistorique', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	appelsDeleteAllHistorique(xPlayer.getPhoneNumber())
end)

function setStockMarket()
	stockMarket = {}

	for k,v in pairs(ESX.GetItems()) do
		table.insert(stockMarket, {
			currentPrice = 5,
			previousPrice = 5,
			img = k,
			label = v.label
		})
	end

	TriggerClientEvent('gcPhone:getBourse', -1, stockMarket)
end

function onCallFixePhone(source, phone_number, rtcOffer, extraData)
	local indexCall = lastIndexCall
	lastIndexCall = lastIndexCall + 1
	local hidden = string.sub(phone_number, 1, 1) == '#'

	if hidden then
		phone_number = string.sub(phone_number, 2)
	end

	local sourcePlayer = tonumber(source)
	local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
	local srcPhone

	if extraData and extraData.useNumber then
		srcPhone = extraData.useNumber
	else
		srcPhone = xPlayer.getPhoneNumber()
	end

	AppelsEnCours[indexCall] = {
		id = indexCall,
		transmitter_src = sourcePlayer,
		transmitter_num = srcPhone,
		receiver_src = nil,
		receiver_num = phone_number,
		is_valid = false,
		is_accepts = false,
		hidden = hidden,
		rtcOffer = rtcOffer,
		extraData = extraData,
		coords = FixePhone[phone_number].coords
	}

	PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

	TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
	TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
end

function onAcceptFixePhone(source, infoCall, rtcAnswer)
	local id = infoCall.id
	AppelsEnCours[id].receiver_src = source

	if AppelsEnCours[id].transmitter_src and AppelsEnCours[id].receiver_src~= nil then
		AppelsEnCours[id].is_accepts = true
		AppelsEnCours[id].forceSaveAfter = true
		AppelsEnCours[id].rtcAnswer = rtcAnswer
		PhoneFixeInfo[id] = nil

		TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
		TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
		TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)

		saveAppels(AppelsEnCours[id])
	end
end

function onRejectFixePhone(source, infoCall, rtcAnswer)
	local id = infoCall.id
	PhoneFixeInfo[id] = nil
	TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
	TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)

	if not AppelsEnCours[id].is_accepts then
		saveAppels(AppelsEnCours[id])
	end

	AppelsEnCours[id] = nil
end

Citizen.CreateThread(function()
	Citizen.Wait(2000)
	setStockMarket()
end)