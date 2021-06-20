ESX.RegisterServerCallback('rpuk_gangs:create', function(source, cb, name)
	local xPlayer = ESX.GetPlayerFromId(source)
	local cb_result, message = nil, nil
	name = tostring(name)

	if xPlayer then
		local allowed = true
		if xPlayer.policelevel > -1 or xPlayer.nhslevel > -1 or xPlayer.lostlevel > -1 then
			allowed, cb_result, message = false, false, "Gang creation failed. You are in a whitelisted faction."
		end
		local gang_id, gang_rank = xPlayer.getGang()
		if gang_id == 0 and allowed then

			local found = false

			for k, v in pairs(RPUK_GANGS) do
				if name == v.name then -- used to double check gang name/pre existance					
					found, message = true, "Gang creation failed. This name already exists!"
					break
				end
			end

			if found then
				cb_result = false
			else
				MySQL.Async.fetchAll('SELECT * FROM gangs WHERE gang_name=@gang_name', {
					['@gang_name'] = name,
				}, function(nameCheckResult)
					if nameCheckResult[1] then
						cb_result, message = false, "Gang creation failed. This name already exists!"
					else
						local default_members = {[xPlayer.rpuk_charid] = {rank = 1, name = xPlayer.firstname .. " " .. xPlayer.lastname}}
						MySQL.Async.insert('INSERT INTO `gangs` (`gang_name`, `gang_members`, `gang_ranks`) VALUES (@gang_name, @gang_members, @gang_ranks)', {
							['@gang_name']  = name,
							['@gang_members'] = json.encode(default_members),
							['@gang_ranks'] = json.encode(Config.default_ranks)
						}, function(gangID)
							if gangID then
								RPUK_GANGS[gangID] = createGang({id = gangID, name = name, members = default_members, ranks = Config.default_ranks, storage = json.encode('{}'), claim_blueprint = 0, claim_drugs = 0, claim_tips = 0})
								local xGang = getGangFromId(gangID)
								cb_result, message = true, "Gang creation was successful! The name was accepted and the gang was created. Manage it properly and stay within the community rules."
								xPlayer.setGang(gangID, 1) -- usable but please don't use xGang.addMember(charid) as it verifies they are able to join a gang and puts them at lowest rank
							else
								cb_result, message = false, "Gang creation failed. Something went wrong, please contact staff"
							end
						end)
					end
				end)
			end
		else
			if allowed then
				cb_result, message = false, "Gang creation failed. You are already in a gang!"
			end
		end
	end
	while cb_result == nil do
		Citizen.Wait(1000)
	end
	cb(cb_result, message)
end)

MySQL.ready(function()
	local SQL_GANGS = MySQL.Sync.fetchAll('SELECT * FROM gangs')
	for k, v in pairs(SQL_GANGS) do
		RPUK_GANGS[v.id] = createGang({id = v.id, name = v.gang_name, members = json.decode(v.gang_members), ranks = json.decode(v.gang_ranks), storage = v.gang_safe, claim_blueprint = v.claim_blueprint, claim_drugs = v.claim_drugs, claim_tips = v.claim_tips})
	end
end)

function syncGangs(gang_id)
	if gang_id then
		local xGang = getGangFromId(gang_id)
		if xGang then
			MySQL.Async.execute('UPDATE gangs SET gang_name=@gang_name, gang_members=@gang_members, gang_ranks=@gang_ranks, gang_safe=@gang_safe WHERE id=@gang_id', {
				['@gang_id'] = xGang.id,
				['@gang_name'] = xGang.name,
				['@gang_members'] = json.encode(xGang.members),
				['@gang_ranks'] = json.encode(xGang.ranks),
			})
			print("Gang SQL Sync Complete for Gang ID: " .. xGang.id .. " | " .. xGang.name)
		end
	else
		for k, v in pairs(RPUK_GANGS) do
			local xGang = getGangFromId(k)
			if xGang then
				MySQL.Async.execute('UPDATE gangs SET gang_name=@gang_name, gang_members=@gang_members, gang_ranks=@gang_ranks, gang_safe=@gang_safe  WHERE id=@gang_id', {
					['@gang_id'] = xGang.id,
					['@gang_name'] = xGang.name,
					['@gang_members'] = json.encode(xGang.members),
					['@gang_ranks'] = json.encode(xGang.ranks),
					['@gang_safe'] = json.encode(xGang.ranks),
				})
				print("Gang SQL Sync Complete for Gang ID: " .. xGang.id .. " | " .. xGang.name)
			end
		end
	end
end