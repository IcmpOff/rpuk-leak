--[[ Function List

	local xPlayer = ESX.GetPlayerFromId(source)
	local gang_id, gang_rank = xPlayer.getGang() 

	local xGang = getGangFromId(gang_id)
	local result = xGang.changeMemberRank(rpuk_charid, new_rank)
	local result = xGang.addMember(rpuk_charid)
	local result = xGang.removeMember(rpuk_charid)
	local result = xGang.changeName(new_gang_name)
	local result = xGang.changeRankLabel(rank_id, new_rank_label)
	local result = xGang.toggleRankPermission(rank_id, permission_string)
]]

ESX.RegisterServerCallback('rpuk_gangs:leave', function(source, cb)	
	local xPlayer = ESX.GetPlayerFromId(source)	
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)

	local cb_result, cb_msg = nil, nil

	if xGang then
		cb_result = xGang.removeMember(xPlayer.rpuk_charid)
		cb_msg = "You have left the gang."
	else
		cb_result, cb_msg = false, "Something went wrong."
	end

	while cb_result == nil do
		Citizen.Wait(1000)
	end

	cb(cb_result, cb_msg)
end)

-- pass leader info back to nui	
ESX.RegisterServerCallback('rpuk_gangs:rec_lead', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)	
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)

	local name = xGang.getName()
	local members = xGang.getMembers()
	local ranks = xGang.getRanks() 
	local permissions = Config.permission_strings
	local no_gangs = {}

	local xPlayers = ESX.GetPlayers()
	for i= 1, #xPlayers do
		local xTarget = ESX.GetPlayerFromId(xPlayers[i])
		if xTarget then
			local gang_id, gang_rank = xTarget.getGang()
			if gang_id == 0 then
				no_gangs[xTarget.rpuk_charid] = {name = xTarget.firstname .. " " .. xTarget.lastname}
			end
		end
	end
	
	cb({no_gangs = no_gangs, name = name, members = members, ranks = ranks, permissions = permissions})
end)

ESX.RegisterServerCallback('rpuk_gangs:kick', function(source, cb, target_id)	
	local xPlayer = ESX.GetPlayerFromId(source)	
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)

	local cb_result, cb_msg = nil, nil

	if doesGangMemberHavePermission(xPlayer.rpuk_charid, "gang_mng_kick", gang_id) then
		if xGang then
			cb_result = xGang.removeMember(target_id)
			if cb_result then
				cb_msg = "Gang member kicked!"
			else
				cb_msg = "Unable to kick gang member!"
			end
		else
			cb_result, cb_msg = false, "Something went wrong."
		end
	else
		cb_result, cb_msg = false, "You do not have permission to kick!"
	end
	
	local cb_members = xGang.getMembers()
	while cb_result == nil do
		Citizen.Wait(1000)
	end

	cb(cb_result, cb_msg, cb_members)
end)

ESX.RegisterServerCallback('rpuk_gangs:invite', function(source, cb, target_id)	
	local xPlayer = ESX.GetPlayerFromId(source)	
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)

	local cb_result, cb_msg = nil, nil
	print(doesGangMemberHavePermission(xPlayer.rpuk_charid, "gang_mng_invite", gang_id))
	if doesGangMemberHavePermission(xPlayer.rpuk_charid, "gang_mng_invite", gang_id) then
		if xGang then
			local xTarget = ESX.GetPlayerFromCharId(tonumber(target_id))
			if xTarget then
				TriggerClientEvent('rpuk_gangs:registerNewInvite', xTarget.source, gang_id, xGang.getName())
				cb_result, cb_msg = true, "Gang member invited!"
			else
				cb_result, cb_msg = false, "Unable to invite member!"
			end
		else
			cb_result, cb_msg = false, "Something went wrong."
		end
	else
		cb_result, cb_msg = false, "You do not have permission to invite!"
	end

	local no_gangs = {}
	local xPlayers = ESX.GetPlayers()
	for i= 1, #xPlayers do
		local xTarget = ESX.GetPlayerFromId(xPlayers[i])
		if xTarget then
			local gang_id, gang_rank = xTarget.getGang()
			if gang_id == 0 then
				no_gangs[xTarget.rpuk_charid] = {name = xTarget.firstname .. " " .. xTarget.lastname}
			end
		end
	end
	
	while cb_result == nil do
		Citizen.Wait(1000)
	end

	cb(cb_result, cb_msg, no_gangs)
end)

ESX.RegisterServerCallback('rpuk_gangs:accept_invite', function(source, cb, gang_id)	
	local xPlayer = ESX.GetPlayerFromId(source)	
	local xGang = getGangFromId(gang_id)
	
	local cb_result, cb_msg = nil, "Something went wrong! Unable to accept the invite."
	if xGang then
		cb_result = xGang.addMember(xPlayer.rpuk_charid)
		cb_msg = "Gang invite accepted."
	else
		cb_result = false
	end
	
	while cb_result == nil do
		Citizen.Wait(1000)
	end

	cb(cb_result, cb_msg)
end)

ESX.RegisterServerCallback('rpuk_gangs:alter_rank', function(source, cb, target_id, new_rank)	
	new_rank = new_rank + 1 -- converts the js index
	target_id = tonumber(target_id)
	local xPlayer = ESX.GetPlayerFromId(source)	
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)

	local cb_result, cb_msg = nil, nil
	local xGangMember = xGang.getMemberFromId(target_id)
	if gang_rank < xGangMember.rank and gang_rank < new_rank then
			if xGangMember.rank > new_rank then
				if doesGangMemberHavePermission(xPlayer.rpuk_charid, "gang_mng_promote", gang_id) then
					cb_result = xGang.changeMemberRank(target_id, new_rank)
					if not cb_result then
						cb_msg = "Something went wrong with the promotion, likely a rank limit"
					else
						cb_msg = "Promoted gang member"
					end
				else
					cb_result, cb_msg = false, "You don't have permission to promote members."
				end
			elseif xGangMember.rank < new_rank then
				if doesGangMemberHavePermission(xPlayer.rpuk_charid, "gang_mng_demote", gang_id) then
					cb_result = xGang.changeMemberRank(target_id, new_rank)
					if not cb_result then
						cb_msg = "Something went wrong with the demotion, likely a rank limit"
					else
						cb_msg = "Demoted gang member"
					end
				else
					cb_result, cb_msg = false, "You don't have permission to demote members."
				end				
			else
				cb_result, cb_msg = false, "You can't promote/demote to the same rank."
				-- same rank
			end
	else
		cb_result, cb_msg = false, "You need to be above members rank to promote/demote them."
	end

	while cb_result == nil do
		Citizen.Wait(1000)
	end
	local cb_members = xGang.getMembers()
	
	cb(cb_result, cb_msg, cb_members)
end)

ESX.RegisterServerCallback('rpuk_gangs:rank_label', function(source, cb, rank_id, new_label)	
	rank_id = rank_id + 1
	new_label = tostring(new_label)
	local xPlayer = ESX.GetPlayerFromId(source)	
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)

	local cb_result, cb_msg = nil, nil

	if doesGangMemberHavePermission(xPlayer.rpuk_charid, "gang_mng_admin", gang_id) then
		if xGang then
			cb_result = xGang.changeRankLabel(rank_id, new_label)
			if cb_result then
				cb_msg = "Rank label changed!"
			else
				cb_msg = "Unable to change rank label!"
			end
		else
			cb_result, cb_msg = false, "Something went wrong."
		end
	else
		cb_result, cb_msg = false, "You do not have permission to change labels!"
	end
	
	while cb_result == nil do
		Citizen.Wait(1000)
	end
	local cb_ranks = xGang.getRanks() 
	cb(cb_result, cb_msg, cb_ranks)
end)

ESX.RegisterServerCallback('rpuk_gangs:rank_permission', function(source, cb, rank_id, permission_string)	
	rank_id = rank_id + 1 -- for the js index
	local xPlayer = ESX.GetPlayerFromId(source)	
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)

	permission_string = tostring(permission_string)
	local cb_result, cb_msg = nil, nil
	if Config.permission_strings[permission_string] then
		if doesGangMemberHavePermission(xPlayer.rpuk_charid, "gang_mng_admin", gang_id) then
			if xGang then
				cb_result = xGang.toggleRankPermission(rank_id, permission_string)
				if cb_result then
					cb_msg = "Rank permissions changed!"
				else
					cb_msg = "Unable to change rank permission!"
				end
			else
				cb_result, cb_msg = false, "Something went wrong."
			end
		else
			cb_result, cb_msg = false, "You do not have permission to change permissions!"
		end
	else
		cb_result, cb_msg = false, "Invalid permission, please notify a developer!"
	end
	while cb_result == nil do
		Citizen.Wait(1000)
	end
	local cb_ranks = xGang.getRanks()
	print(cb_result, cb_msg)
	cb(cb_result, cb_msg, cb_ranks)
end)

ESX.RegisterServerCallback('rpuk_gangs:create_rank', function(source, cb, new_label)	
	new_label = tostring(new_label)
	local xPlayer = ESX.GetPlayerFromId(source)	
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)

	local cb_result, cb_msg = nil, nil

	if doesGangMemberHavePermission(xPlayer.rpuk_charid, "gang_mng_admin", gang_id) then
		if xGang then
			cb_result = xGang.createRank(new_label)
			if cb_result then
				cb_msg = "New gang rank created!"
			else
				cb_msg = "Unable to create new gang rank!"
			end
		else
			cb_result, cb_msg = false, "Something went wrong."
		end
	else
		cb_result, cb_msg = false, "You do not have permission to create ranks!"
	end
	
	while cb_result == nil do
		Citizen.Wait(1000)
	end
	local cb_ranks = xGang.getRanks() 
	cb(cb_result, cb_msg, cb_ranks)
end)

ESX.RegisterServerCallback('rpuk_gangs:delete_rank', function(source, cb, rank_id)	
	rank_id = rank_id + 1 -- js indexing
	rank_id = tonumber(rank_id)
	
	local xPlayer = ESX.GetPlayerFromId(source)	
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)

	local cb_result, cb_msg = nil, nil

	if doesGangMemberHavePermission(xPlayer.rpuk_charid, "gang_mng_admin", gang_id) then
		if xGang then
			if rank_id > 4 then
				local xGangMembers = xGang.getMembers()
				for k, v in pairs(xGangMembers) do
					if tonumber(v.rank) >= tonumber(rank_id) then
					--	xGang.removeMember(k)
					end
					local xTarget = ESX.GetPlayerFromCharId(k)
					if xTarget then
					--	xGang.addMember(xTarget.rpuk_charid)
					end
				end

				cb_result = xGang.deleteRank(rank_id)

				if cb_result then
					cb_msg = "Gang rank deleted!"
				else
					cb_msg = "Unable to delete the gang rank!"
				end
			else
				cb_result, cb_msg = false, "You are unable to delete a default rank."
			end
		else
			cb_result, cb_msg = false, "Something went wrong."
		end
	else
		cb_result, cb_msg = false, "You do not have permission to delete ranks!"
	end
	
	while cb_result == nil do
		Citizen.Wait(1000)
	end
	local cb_ranks = xGang.getRanks()
	cb(cb_result, cb_msg, cb_ranks)
end)
--[[
RegisterCommand('gang_remove', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)	
	local gang_id, gang_rank = xPlayer.getGang()
	local xGang = getGangFromId(gang_id)
	xPlayer.setGang(0,0) -- default
end,false)
]]
