ESX.RegisterCommand('setwhitelist', 'dev_level_2', function(xPlayer, args, showError)
	if args.factionFlag == args.factionName then args.factionFlag = nil end
	args.playerId.setWhitelist(args.factionName, args.factionLevel, args.factionFlag)
end, true, {help = 'Set whitelist flag', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'factionName', help = 'Valid faction names: "police, nhs, lost"', type = 'string'},
	{name = 'factionLevel', help = 'Faction level', type = 'number'},
	{name = 'factionFlag', help = 'For no flag set it to the faction name. Valid faction flags: "taser, dog, firstaid, driving, pilot, boat, firearms, special, firstaid, driving, pilot, boat, special, hart, manufacture, bank, launder, smuggling, special"', type = 'string'}
}})

ESX.RegisterCommand('setcoords', 'staff_level_2', function(xPlayer, args, showError)
	xPlayer.setCoords({x = args.x, y = args.y, z = args.z})
end, false, {help = _U('command_setcoords'), validate = true, arguments = {
	{name = 'x', help = _U('command_setcoords_x'), type = 'number'},
	{name = 'y', help = _U('command_setcoords_y'), type = 'number'},
	{name = 'z', help = _U('command_setcoords_z'), type = 'number'}
}})

ESX.RegisterCommand('setjob', 'staff_level_5', function(xPlayer, args, showError)
	if ESX.DoesJobExist(args.job, args.grade) then
		args.playerId.setJob(args.job, args.grade)
	else
		showError(_U('command_setjob_invalid'))
	end
end, true, {help = _U('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'job', help = _U('command_setjob_job'), type = 'string'},
	{name = 'grade', help = _U('command_setjob_grade'), type = 'number'}
}})

ESX.RegisterCommand('car', 'staff_level_4', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:spawnVehicle', args.car)
end, false, {help = _U('command_car'), validate = false, arguments = {
	{name = 'car', help = _U('command_car_car'), type = 'any'}
}})

ESX.RegisterCommand('spawnobj', 'staff_level_4', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:spawnObject', args.model)
end, false, {help = _U('command_obj_spawn'), validate = false, arguments = {
	{name = 'model', help = _U('command_obj_spawn_help'), type = 'any'}
}})

ESX.RegisterCommand({'cardel', 'dv'}, 'staff_level_2', function(xPlayer, args, showError)
	xPlayer.triggerEvent('esx:deleteVehicle', args.radius)
end, false, {help = _U('command_cardel'), validate = false, arguments = {
	{name = 'radius', help = _U('command_cardel_radius'), type = 'any'}
}})

ESX.RegisterCommand('setaccountmoney', 'staff_level_5', function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.setAccountMoney(args.account, args.amount, ('%s (%s) [%s]'):format('Staff Compensation', xPlayer.identifier, GetCurrentResourceName()))
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {help = _U('command_setaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_setaccountmoney_amount'), type = 'number'}
}})

ESX.RegisterCommand('giveaccountmoney', 'staff_level_5', function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.addAccountMoney(args.account, args.amount, ('%s (%s) [%s]'):format('Staff Compensation', xPlayer.identifier, GetCurrentResourceName()))
	else
		showError(_U('command_giveaccountmoney_invalid'))
	end
end, true, {help = _U('command_giveaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _U('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _U('command_giveaccountmoney_amount'), type = 'number'}
}})

ESX.RegisterCommand('giveitem', 'staff_level_4', function(xPlayer, args, showError)
	args.playerId.addInventoryItem(args.item, args.count)
end, true, {help = _U('command_giveitem'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'item', help = _U('command_giveitem_item'), type = 'item'},
	{name = 'count', help = _U('command_giveitem_count'), type = 'number'}
}})

ESX.RegisterCommand('giveweapon', 'staff_level_4', function(xPlayer, args, showError)
	if args.playerId.hasWeapon(args.weapon) then
		showError(_U('command_giveweapon_hasalready'))
	else
		xPlayer.addWeapon(args.weapon, args.ammo)
	end
end, true, {help = _U('command_giveweapon'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'weapon', help = _U('command_giveweapon_weapon'), type = 'weapon'},
	{name = 'ammo', help = _U('command_giveweapon_ammo'), type = 'number'}
}})

ESX.RegisterCommand('giveammo', 'staff_level_4', function(xPlayer, args, showError)
	xPlayer.addWeaponAmmo(args.ammoType, args.amount)
end, true, {help = _U('command_giveweapon'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'ammoType', help = _U('command_giveammo'), type = 'ammo'},
	{name = 'amount', help = _U('command_giveweapon_ammo'), type = 'number'}
}})

ESX.RegisterCommand('giveweaponcomponent', 'staff_level_4', function(xPlayer, args, showError)
	if args.playerId.hasWeapon(args.weaponName) then
		local component = ESX.GetWeaponComponent(args.weaponName, args.componentName)

		if component then
			if xPlayer.hasWeaponComponent(args.weaponName, args.componentName) then
				showError(_U('command_giveweaponcomponent_hasalready'))
			else
				xPlayer.addWeaponComponent(args.weaponName, args.componentName)
			end
		else
			showError(_U('command_giveweaponcomponent_invalid'))
		end
	else
		showError(_U('command_giveweaponcomponent_missingweapon'))
	end
end, true, {help = _U('command_giveweaponcomponent'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'weaponName', help = _U('command_giveweapon_weapon'), type = 'weapon'},
	{name = 'componentName', help = _U('command_giveweaponcomponent_component'), type = 'string'}
}})

ESX.RegisterCommand({'clear', 'cls'}, 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('chat:clear')
end, false, {help = _U('command_clear')})

ESX.RegisterCommand({'clearall', 'clsall'}, 'staff_level_1', function(xPlayer, args, showError)
	TriggerClientEvent('chat:clear', -1)
end, false, {help = _U('command_clearall')})

ESX.RegisterCommand('clearinventory', 'staff_level_2', function(xPlayer, args, showError)
	for k,v in ipairs(args.playerId.inventory) do
		if v.count > 0 then
			args.playerId.setInventoryItem(v.name, 0)
		end
	end
end, true, {help = _U('command_clearinventory'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('clearloadout', 'staff_level_2', function(xPlayer, args, showError)
	for k,v in pairs(args.playerId.loadout) do
		args.playerId.removeWeapon(v.name)
	end
end, true, {help = _U('command_clearloadout'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('clearammo', 'staff_level_2', function(xPlayer, args, showError)
	for k,v in pairs(xPlayer.getAmmo()) do
		if v.count > 0 then
			args.playerId.removeWeaponAmmo(k)
		end
	end
end, true, {help = _U('command_clearammo'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('groupadd', 'dev_level_2', function(xPlayer, args, showError)
	if args.playerId.addGroup(args.group) then
		showError('Adding player to group was successful')
	else
		showError('Failed adding player to group, is the player already in that group?')
	end
end, true, {help = 'Add a player to a group', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'group', help = _U('command_setgroup_group'), type = 'string'}
}})

ESX.RegisterCommand('groupremove', 'dev_level_2', function(xPlayer, args, showError)
	if args.playerId.removeGroup(args.group) then
		showError('Removing player from group was successful')
	else
		showError('Failed removing player from a group, is the player in that group?')
	end
end, true, {help = 'Remove a player from a group', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
	{name = 'group', help = _U('command_setgroup_group'), type = 'string'}
}})

ESX.RegisterCommand('grouplist', {'staff_level_5', 'dev_level_2'}, function(xPlayer, args, showError)
	local groups

	for group,v in pairs(args.playerId.getGroups()) do
		if groups then
			groups = ('%s, %s'):format(groups, group)
		else
			groups = group
		end
	end

	showError(('Player groups: %s'):format(groups))
end, true, {help = 'List the groups a player is in', validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('setstat', 'dev_level_2', function(xPlayer, args, showError)
	args.playerId.setStatData(args.stat, args.level)
end, true, {help = 'Set stat', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
	{name = 'stat', help = 'stat', type = 'string'},
	{name = 'level', help = 'level', type = 'number'},
}})

ESX.RegisterCommand('save', 'staff_level_1', function(xPlayer, args, showError)
	ESX.SavePlayer(args.playerId)
end, true, {help = _U('command_save'), validate = true, arguments = {
	{name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'}
}})

ESX.RegisterCommand('saveall', 'staff_level_1', function(xPlayer, args, showError)
	ESX.SavePlayers()
end, true, {help = _U('command_saveall')})
