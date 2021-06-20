WhiteList = {}

function loadWhiteList(cb)
	WhiteList = {}

	MySQL.Async.fetchAll('SELECT identifier FROM event_signups', {}, function(result)
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
	if purge_active then
		deferrals.defer()
		local tempId, kickReason, identifier = source

		Citizen.Wait(0)

		deferrals.update("Making sure you\'re whitelisted for this server event...")
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
			kickReason = "Whitelist hasn't loaded yet."
		elseif not identifier then
			kickReason = "Ensure your steam is running."
		elseif not WhiteList[identifier] then
			kickReason = "You are not whitelisted for this server event. Join teamspeak @ TS.Roleplay.co.uk"
		end

		if kickReason then
			deferrals.done(kickReason)
		else
			deferrals.done()
		end
	end
end)

ESX.RegisterCommand('event_whitelist_reload', 'staff_level_1', function(xPlayer, args, showError)
	loadWhiteList(function()
		showError('Whitelist reloaded')
	end)
end, true, {help = "Reload the event whitelist."})

ESX.RegisterCommand('event_whitelist_add', 'staff_level_1', function(xPlayer, args, showError)
	args.identifier = args.identifier:lower()

	if string.len(args.identifier) == 21 then
		if WhiteList[args.identifier] then
			showError('The player is already whitelisted on this server!')
		else
			MySQL.Async.execute('INSERT INTO event_signups (identifier) VALUES (@identifier)', {
				['@identifier'] = args.identifier
			}, function(rowsChanged)
				WhiteList[args.identifier] = true
				showError('The player has been whitelisted!')
			end)
		end
	else
		showError('Invalid steam ID length!')
	end
end, true, {help = "Add a steam ID to the event whitelist.", validate = true, arguments = {
	{name = 'identifier', help = 'the player Steam identifier to whitelist (steam:9123xxxxxx)', type = 'string'}
}})