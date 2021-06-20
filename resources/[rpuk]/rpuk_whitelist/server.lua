WhiteList = {}

function loadWhiteList(cb)
	WhiteList = {}

	MySQL.Async.fetchAll('SELECT identifier FROM whitelist', {}, function(result)
		for k,v in ipairs(result) do
			WhiteList[v.identifier] = true
		end

		if cb then
			cb()
		end
	end)
end

MySQL.ready(function()
	loadWhiteList()
end)

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	deferrals.defer()
	local tempId, kickReason, identifier = source
	Citizen.Wait(0)

	for k,v in ipairs(GetPlayerIdentifiers(tempId)) do
		if string.match(v, 'steam:') then
			identifier = v
			break
		end
	end

	if not ESX then
		kickReason = 'The server is still starting up, please try again in a few moments'
	elseif ESX.Table.SizeOf(WhiteList) == 0 then
		kickReason = 'The whitelist hasn\'t been loaded yet, or alternatively no one has been whitelisted'
	elseif not identifier then
		kickReason = 'Identifier missing'
	elseif not WhiteList[identifier] then
		kickReason = 'You are not whitelisted on this server. If the server recently started then it might be still ' ..
			'starting up, or we might be running a update on the server. If so try again soon'
	end

	if kickReason then
		deferrals.done(kickReason)
	else
		deferrals.done()
	end
end)

ESX.RegisterCommand('wlrefresh', 'staff_level_1', function(xPlayer, args, showError)
	loadWhiteList(function()
		showError('Whitelist reloaded')
	end)
end, true, {help = 'Reload the whitelist'})

ESX.RegisterCommand('wladd', 'staff_level_1', function(xPlayer, args, showError)
	args.identifier = args.identifier:lower()

	if string.len(args.identifier) == 21 then
		if WhiteList[args.identifier] then
			showError('The player is already whitelisted on this server!')
		else
			MySQL.Async.execute('INSERT INTO whitelist (identifier) VALUES (@identifier)', {
				['@identifier'] = args.identifier
			}, function(rowsChanged)
				WhiteList[args.identifier] = true
				showError('The player has been whitelisted!')
			end)
		end
	else
		showError('Invalid steam ID length!')
	end
end, true, {help = 'Add someone to the whitelist', validate = true, arguments = {
	{name = 'identifier', help = 'the player Steam identifier to whitelist', type = 'string'}
}})