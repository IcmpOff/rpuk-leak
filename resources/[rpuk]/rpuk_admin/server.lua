local frozen = {}

local groupLabels = {
	['user'] = 'Member',
	['staff_level_1'] = 'Staff Level 1',
	['staff_level_2'] = 'Staff Level 2',
	['staff_level_3'] = 'Staff Level 3',
	['staff_level_4'] = 'Staff Level 4',
	['staff_level_5'] = 'Management / Leads'
}

local quickEventAces = {
	['slay'] = 'staff.slay',
	['freeze'] = 'staff.freeze',
	['crash'] = 'staff.crash',
	['bring'] = 'staff.bring',
	['bring_all'] = 'staff.bringall',
	['goto'] = 'staff.goto',
	['slap'] = 'staff.slap',
	['kick'] = 'staff.kick',
	['kick_all'] = 'staff.kickall',
	['heal'] = 'staff.heal',
	['heal_all'] = 'staff.healall',
	['revive'] = 'staff.revive',
	['revive_all'] = 'staff.reviveall',
	['addaccountmoney'] = 'command.setaccountmoney'
}

ESX.RegisterServerCallback('rpuk_admin:populatePlayers', function(source, cb)
	if IsPlayerAceAllowed(source, 'staff.menu') then
		local player_data = {}

		for k,v in ipairs(ESX.GetPlayers()) do
			local xPlayer = ESX.GetPlayerFromId(v)

			local allPlayerGroups

			for group,v in pairs(xPlayer.getGroups()) do
				local groupLabel = groupLabels[group] or ('unknown group "%s"'):format(group)

				if allPlayerGroups then
					allPlayerGroups = ('%s, %s'):format(allPlayerGroups, groupLabel)
				else
					allPlayerGroups = groupLabel
				end
			end

			table.insert(player_data, {
				id     		= v,
				name     	= xPlayer.name,
				character   = xPlayer.firstname .. " " .. xPlayer.lastname,
				charid		= xPlayer.rpuk_charid,
				group     	= allPlayerGroups,
				job    		= xPlayer.job,
				steam      	= xPlayer.identifier,
				cash		= xPlayer.getMoney(),
				dirty		= xPlayer.getAccount('black_money').money,
				bank		= xPlayer.getAccount('bank').money,
				loadout		= xPlayer.getLoadout()
			})
		end

		cb(player_data)
	else
		print(('[rpuk_admin] %s was denied "staff.menu"'):format(source))
		cb({})
	end
end)

RegisterNetEvent('rpuk_admin:kick')
AddEventHandler('rpuk_admin:kick', function(target, reason)
	if IsPlayerAceAllowed(source, 'staff.kick') then
		local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)

		if xTarget then
			if reason then
				local playerName = xTarget.getFullName()
				local stringify = " "
				for i, data in pairs(reason) do
					if tonumber(i) ~= 1 then
						stringify = stringify .. reason[i] .. " "
					end
				end
				TriggerClientEvent('chat:addMessage', -1, {template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(25, 25, 25, 0.6); border-radius: 3px;"><img style="position:absolute;right:0%;margin-top:auto;height:1.6vw;"src="https://www.roleplay.co.uk/images/rplogo.png" /> {0} {1}</div>',
					args = { playerName, "Was kicked from the server. ^3Reason:" .. stringify }
				})
				print("RPUK Admin: Player kicked by admin [" .. xTarget.identifier .. "] Reason: " .. stringify)
				DropPlayer(target, "You were kicked\nReason: " .. stringify)
			else
				local playerName = xTarget.getFullName()

				TriggerClientEvent('chat:addMessage', -1, {template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(25, 25, 25, 0.6); border-radius: 3px;"><img style="position:absolute;right:0%;margin-top:auto;height:1.6vw;"src="https://www.roleplay.co.uk/images/rplogo.png" /> {0} {1}</div>',
					args = { playerName, "^1Was Kicked from the server."}
				})

				print("RPUK Admin: Player kicked by admin" .. xTarget.identifier)
				DropPlayer(target, "Kicked from the server.")
			end
		else
			xPlayer.showNotification('Player could not be kicked due to not being online (xplayer nil)')
		end
	else
		print("RPUK Admin: Illegal Call Detected From " .. GetPlayerIdentifiers(source)[1] .. " Banning Client [Admin Kick]")
		TriggerEvent('rpuk_anticheat:sab', source, "fakeevent")
	end
end)

RegisterNetEvent('rpuk_admin:quick')
AddEventHandler('rpuk_admin:quick', function(type, targetPlayer, arg3, arg4)
	if quickEventAces[type] then
		if IsPlayerAceAllowed(source, quickEventAces[type]) then
			local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(targetPlayer)

			if type == 'slay' then TriggerClientEvent('rpuk_admin:quick', targetPlayer, type)
			elseif type == 'heal' then TriggerClientEvent('esx_basicneeds:healPlayer', targetPlayer)
			elseif type == 'heal_all' then TriggerClientEvent('esx_basicneeds:healPlayer', -1)
			elseif type == 'revive' then TriggerEvent('rpuk_health:serverRevive', targetPlayer, 'staff.revive')
			elseif type == 'revive_all' then TriggerEvent('rpuk_health:serverReviveAll', 'staff.reviveall')
			elseif type == 'freeze' then TriggerClientEvent('rpuk_admin:quick', targetPlayer, type)
			elseif type == 'crash' then TriggerClientEvent('rpuk_admin:quick', targetPlayer, type)
			elseif type == 'bring' then xTarget.setCoords(xPlayer.getCoords())
			elseif type == 'bring_all' then TriggerClientEvent('rpuk_admin:quick', -1, 'bring_all', xPlayer.getCoords())
			elseif type == 'goto' then xPlayer.setCoords(xTarget.getCoords())
			elseif type == 'slap' then TriggerClientEvent('rpuk_admin:quick', source, type)
			elseif type == 'kick' then DropPlayer(targetPlayer, 'You have been kicked by server staff')
			elseif type == 'kick_all' then
				for k,playerId in ipairs(ESX.GetPlayers()) do
					if playerId ~= source then
						DropPlayer(playerId, 'You have been kicked from the server')
					end
				end
			elseif type == 'addaccountmoney' then
				if arg4 and tonumber(arg3) then
					xTarget.addAccountMoney(arg4, tonumber(arg3), ('%s (%s) [%s]'):format('Staff Compensation', xPlayer.getIdentifier(), GetCurrentResourceName()))
				end
			else
				print(('[rpuk_admin] %s was denied %s (unimplemented type "%s")'):format(source, quickEventAces[type], type))
			end
		else
			print(('[rpuk_admin] %s was denied %s'):format(source, quickEventAces[type]))
		end
	else
		print(('[rpuk_admin] %s was denied %s (invalid type "%s")'):format(source, quickEventAces[type], type))
	end
end)

ESX.RegisterCommand('announce', {'staff_level_1', 'dev_level_1'}, function(xPlayer, args, showError)
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(255, 20, 20, 0.3); border-radius: 3px;"><img style="position:absolute;z-index:10;right:0;height:3vw;top:auto;"src="https://www.roleplay.co.uk/images/rplogo.png" /> <b>STAFF ANNOUNCEMENT</b><br> {1}</div><br><br>',
		args = {'', args.message}
	})
end, true, {help = 'Announce a message to the entire server', validate = true, arguments = {
	{name = 'message', help = 'The message to announce (surround with quotes)', type = 'string'}
}})

ESX.RegisterCommand('dannounce', 'dev_level_1', function(xPlayer, args, showError)
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(20, 20, 255, 0.3); border-radius: 3px;"><img style="position:absolute;z-index:10;right:0;height:3vw;top:auto;"src="https://www.roleplay.co.uk/images/rplogo.png" /> <b>DEVELOPMENT ANNOUNCEMENT</b><br> {1}</div><br><br>',
		args = {'', args.message}
	})
end, true, {help = 'Announce a message to the entire server', validate = true, arguments = {
	{name = 'message', help = 'The message to announce (surround with quotes)', type = 'string'}
}})

ESX.RegisterCommand('freeze', 'staff_level_1', function(xPlayer, args, showError)
	local state, playerId = 'unfrozen', args.playerId.playerId

	if frozen[playerId] then
		frozen[playerId] = false
	else
		frozen[playerId] = true
		state = 'frozen'
	end

	args.playerId.triggerEvent('rpuk_admin:freezePlayer', frozen[playerId])
	args.playerId.triggerEvent('chat:addMessage', {args = {'^1SYSTEM', ('You have been %s by "^2%s^7"'):format(state, xPlayer.getName())}})
	showError(('Player "%s" has been %s'):format(args.playerId.getName(), state))
end, false, {help = 'Toggle freeze on a player, makes them unable to move', validate = true, arguments = {
	{name = 'playerId', help = 'A player id', type = 'player'}
}})

ESX.RegisterCommand('bring', {'staff_level_1', 'dev_level_2'}, function(xPlayer, args, showError)
	args.playerId.setCoords(xPlayer.getCoords())
end, false, {help = 'Bring a player to you', validate = true, arguments = {
	{name = 'playerId', help = 'A player id', type = 'player'}
}})

ESX.RegisterCommand('goto', {'staff_level_1', 'dev_level_2'}, function(xPlayer, args, showError)
	xPlayer.setCoords(args.playerId.getCoords())
end, false, {help = 'Teleport to another player', validate = true, arguments = {
	{name = 'playerId', help = 'A player id', type = 'player'}
}})

ESX.RegisterCommand('die', 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('rpuk_admin:kill')
	showError('You killed yourself')
end, false, {help = 'Commit suicide'})

ESX.RegisterCommand('report', 'user', function(xPlayer, args, showError)
	showError('This command has been removed. If you need staff help then connect to our TeamSpeak server at ^4TS.Roleplay.co.uk^7 and switch to the "Join for Support" channel. Or you can ask for help in our #help Discord channel at ^4discord.gg/roleplay^7')
end, false, {help = 'Report a player / incident'})

ESX.RegisterCommand('help', 'user', function(xPlayer, args, showError)
	showError('If you need help then connect to our TeamSpeak server at ^4TS.Roleplay.co.uk^7 and switch to the "Join for Support" channel. Or you can ask for help in our #help Discord channel at ^4discord.gg/roleplay^7')
end, false, {help = 'Get staff help'})

ESX.RegisterCommand('cyclemode', {'staff_level_1', 'dev_level_1'}, function(xPlayer, args, showError)
	xPlayer.triggerEvent('rpuk_admin:togglemode', 'cyclemode')
end, false, {help = 'Staff mode'})

ESX.RegisterCommand('staffconsole', 'staff_level_1', function(xPlayer, args, showError)
	xPlayer.triggerEvent('rpuk_admin:togglemode', 'staffconsole')
end, false, {help = 'Open staff console'})

ESX.RegisterCommand('cyclecolour', 'staff_level_1', function(xPlayer, args, showError)
	xPlayer.triggerEvent('rpuk_admin:togglemode', 'cyclecolour')
end, false, {help = 'Toggle staff cycle colours'})

ESX.RegisterCommand('staffcamera', {'staff_level_1', 'dev_level_2'}, function(xPlayer, args, showError)
	xPlayer.triggerEvent('rpuk_admin:togglemode', 'staffcamera')
end, false, {help = 'Toggle staff camera'})

ESX.RegisterCommand('staffnames', {'staff_level_1', 'dev_level_2'}, function(xPlayer, args, showError)
	xPlayer.triggerEvent('rpuk_admin:togglemode', 'staffnames')
end, false, {help = 'Toggle drawing player names'})

ESX.RegisterCommand('kick', 'staff_level_1', function(xPlayer, args, showError)
	DropPlayer(args.playerId, args.reason)
	local xTarget = ESX.GetPlayerFromId(args.playerId)
	TriggerClientEvent('chat:addMessage', -1, {template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(25, 25, 25, 0.6); border-radius: 3px;"><img style="position:absolute;right:0%;margin-top:auto;height:1.6vw;"src="https://www.roleplay.co.uk/images/rplogo.png" /> {0} {1}</div>',
		args = { xTarget.getFullName(), "Was kicked from the server. ^3Reason: " .. args.reason }
	})
end, true, {help = 'Kick a player from the server', validate = true, arguments = {
	{name = 'playerId', help = 'A player id', type = 'playerId'},
	{name = 'reason', help = 'Reason (surround with quotes)', type = 'string'},
}})

ESX.RegisterCommand('revive', 'staff_level_1', function(xPlayer, args, showError)
	TriggerEvent('rpuk_health:serverRevive', args.playerId, 'command.revive')
end, true, {help = 'Revive a player', validate = true, arguments = {
	{name = 'playerId', help = 'A player id', type = 'playerId'}
}})

ESX.RegisterCommand('admincuff', 'staff_level_1', function(xPlayer, args, showError)
	TriggerEvent('rpuk_restrain:handcuff', args.playerId)
end, true, {help = 'Admin cuff a player', validate = true, arguments = {
	{name = 'playerId', help = 'A player id', type = 'playerId'}
}})

RegisterNetEvent('demmycam:requestcam')
AddEventHandler ('demmycam:requestcam', function()
	local src = source
	if not Config.Permission or IsPlayerAceAllowed(src, Config.Permission) then
		TriggerClientEvent('demmycam:startcam', src)
	else
		TriggerClientEvent('demmycam:nope',src)
	end
end)

RegisterNetEvent('demmycam:deletenetworked')
AddEventHandler ('demmycam:deletenetworked',function(owner, netID)
	local src = source
	if not Config.Permission or IsPlayerAceAllowed(src, Config.Permission) then
		TriggerClientEvent('demmycam:delete',owner,netID)
	end
end)