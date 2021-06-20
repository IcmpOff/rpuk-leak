local isChatCooldownActive, playerCooldowns = false, {}

function setChatCooldown()
	isChatCooldownActive = true
	Citizen.Wait(100)
	isChatCooldownActive = false
end

ESX.RegisterCommand('ooc', 'user', function(xPlayer, args, showError, playerId)
	if isChatCooldownActive then
		showError('Chat Notice | Slow Mode!')
	else
		local errorMessage

		-- Check discord link
		if string.match(args.message, "discord.gg") or string.match(args.message, "Discord.gg") then
			if string.match(message, "discord.gg/roleplay") or string.match(args.message, "Discord.gg/roleplay") or string.match(args.message, "Discord.gg/Roleplay") then
				-- url is ok
			else
				errorMessage = 'Chat Notice | Do not post any discord links! Only Warning!'
				xPlayer.triggerEvent('esx_rpchat:Counter')
			end
		end

		-- Check cooldown
		if playerCooldowns[playerId] then
			local lastPlayerMessage = os.clock() - playerCooldowns[playerId]

			if lastPlayerMessage < 10 then
				errorMessage = 'You\'re on a 10 second /ooc command cooldown'
			end
		end

		-- Check if the message contains "bad" words
		TriggerEvent('rpuk_anticheat:validateChat', args.message, playerId, function(isAllowed)
			if not isAllowed then
				errorMessage = 'You are now banned!'
			end
		end)

		if errorMessage then
			showError(errorMessage)
		else
			playerCooldowns[playerId] = os.clock()

			TriggerClientEvent('chat:addMessage', -1, {
				templateId = 'ooc',
				args = {xPlayer.getFullName(), playerId, args.message}
			})
		end

		setChatCooldown()
	end
end, false, {help = 'Send a global out-of-character message', validate = true, arguments = {
	{name = 'message', help = 'Message to send PUT YOUR MESSAGE in "double quotes"', type = 'string'}
}})

AddEventHandler('esx:playerDropped', function(playerId, reason)
	playerCooldowns[playerId] = nil
end)