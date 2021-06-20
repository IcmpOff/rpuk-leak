local guiEnabled, hold = false, false
local pendingGangInvites = {}
local isBlurry = false

RegisterNetEvent('rpuk_weather:isBlurry')
AddEventHandler('rpuk_weather:isBlurry', function(_isBlurry) isBlurry = _isBlurry end)

function DisplayNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

RegisterNetEvent('rpuk_gangs:registerNewInvite')
AddEventHandler('rpuk_gangs:registerNewInvite', function(gangId, gangName)
	for k, v in pairs(pendingGangInvites) do
		if v.gang_id == gangId then
			return
		end
	end
	TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'inform', text = "You were invited to " .. gangName})
	table.insert(pendingGangInvites, {gang_id = gangId, gang_name = gangName})
end)

function openMenus(bool)
	if hold then
		return
	end
	hold = true
	SetNuiFocus(bool, bool)

	if bool and not isBlurry then
		SetTimecycleModifier('hud_def_blur')
	elseif not bool and not isBlurry then
		SetTimecycleModifier('default')
	end

	guiEnabled = bool
	if ESX.Player.GetGangId() == 0 then
		SendNUIMessage({
			type = "create_menu",
			pending_invites = pendingGangInvites,
			enable = bool
		})
	else
		if ESX.Player.GetGangRank() == 1 then
			ESX.TriggerServerCallback('rpuk_gangs:rec_lead', function(data)
				SendNUIMessage({
					type = "lead_menu",
					gang_name = data.name,
					gang_members = data.members,
					gang_ranks = data.ranks,
					default_permissions = Config.permission_strings,
					no_gangs = data.no_gangs,
					enable = bool
				})
			end)
		else
			SendNUIMessage({
				type = "leave_menu",
				enable = bool
			})
		end
	end
	hold = false
end

RegisterNUICallback('escape', function(data, cb)
    openMenus(false)
    cb('ok')
end)

RegisterNUICallback('leave', function(data, cb)
	hold = true
	ESX.TriggerServerCallback('rpuk_gangs:leave', function(cb_result, cb_message)
		cb({
			result = cb_result,
			message = cb_message
		})
	end, data.name)
	hold = false
end)

RegisterNUICallback('kick', function(data, cb)
	hold = true
	ESX.TriggerServerCallback('rpuk_gangs:kick', function(cb_result, cb_message, cb_members)
		cb({
			result = cb_result,
			message = cb_message,
			gang_members = json.encode(cb_members),
		})
	end, data.selectedMember)
	hold = false
end)

RegisterNUICallback('accept_invite', function(data, cb)
	hold = true
	ESX.TriggerServerCallback('rpuk_gangs:accept_invite', function(cb_result, cb_message)
		cb({
			result = cb_result,
			message = cb_message,
		})
	end, data.selectedPendingInvite)
	hold = false
end)

RegisterNUICallback('invite', function(data, cb)
	hold = true
	ESX.TriggerServerCallback('rpuk_gangs:invite', function(cb_result, cb_message, cb_nogang)

		cb({
			result = cb_result,
			message = cb_message,
			no_gangs = json.encode(cb_nogang),
		})
	end, data.selectedInvite)
	hold = false
end)

RegisterNUICallback('alter_rank', function(data, cb)
	hold = true
	ESX.TriggerServerCallback('rpuk_gangs:alter_rank', function(cb_result, cb_message, cb_members)
		cb({
			result = cb_result,
			message = cb_message,
			gang_members = json.encode(cb_members),
		})
	end, data.charID, data.selectedRank)
	hold = false
end)

RegisterNUICallback('alter_rank_label', function(data, cb)
	hold = true
	ESX.TriggerServerCallback('rpuk_gangs:rank_label', function(cb_result, cb_message, cb_ranks)
		cb({
			result = cb_result,
			message = cb_message,
			gang_ranks = json.encode(cb_ranks),
		})
	end, data.selectedRankProp, data.new_name)
	hold = false
end)

RegisterNUICallback('alter_rank_permission', function(data, cb)
	hold = true
	ESX.TriggerServerCallback('rpuk_gangs:rank_permission', function(cb_result, cb_message, cb_ranks)
		cb({
			result = cb_result,
			message = cb_message,
			gang_ranks = json.encode(cb_ranks),
		})
	end, data.selectedRankProp, data.selectedRankPerm)
	hold = false
end)

RegisterNUICallback('create_gang_rank', function(data, cb)
	hold = true
	print(data.new_name)
	ESX.TriggerServerCallback('rpuk_gangs:create_rank', function(cb_result, cb_message, cb_ranks)
		cb({
			result = cb_result,
			message = cb_message,
			gang_ranks = json.encode(cb_ranks),
		})
	end, data.new_name)
	hold = false
end)

RegisterNUICallback('delete_gang_rank', function(data, cb)
	hold = true
	ESX.TriggerServerCallback('rpuk_gangs:delete_rank', function(cb_result, cb_message, cb_ranks)
		cb({
			result = cb_result,
			message = cb_message,
			gang_ranks = json.encode(cb_ranks),
		})
	end, data.selectedRankProp)
	hold = false
end)

RegisterNUICallback('create', function(data, cb)
	hold = true
	local allowed, message = nil, nil
	for k, v in pairs(Config.reserved_gangs) do
		if string.match(v, string.lower(data.name)) then
			allowed, message = false, "This name is reserved. You aren't allowed to use the official turf gang names."
			break
		end
	end
	for k, v in pairs(Config.offensive_strings) do
		if string.match(v, string.lower(data.name)) then
			allowed, message = false, "You name contains a blacklisted phrase. Ensure you read our community rules."
			break
		end
	end

	if allowed == false then
		cb({
			result = allowed,
			message = message
		})
	else
		if ESX.Player.GetGangId() == 0 then
			ESX.TriggerServerCallback('rpuk_gangs:create', function(cb_result, cb_message)
				cb({
					result = cb_result,
					message = cb_message
				})
			end, data.name)
		else
			cb({
				result = false,
				message = "Gang creation failed. You are already in a gang!"
			})
		end
	end
	hold = false
end)

RegisterKeyMapping('gangmenu', 'Gang/Group Menu', 'keyboard', 'F6')

RegisterCommand("gangmenu", function(source, args)
	openMenus(true)
end)

--openMenus(false)