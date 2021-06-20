ESX.RegisterServerCallback('rpuk_factions:getEmployeeList', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if Config.Management[xPlayer.job.name] and xPlayer.job.grade >= Config.Management[xPlayer.job.name] then
		local query

		if Config.LookupOverride[xPlayer.job.name] then
			local level = Config.LookupOverride[xPlayer.job.name].level
			query = ('SELECT rpuk_charid, firstname, lastname, %s AS joblevel FROM users WHERE %s > -1'):format(level, level)
		else
			query = [===[
				SELECT
					rpuk_charid, firstname, lastname,
					JSON_EXTRACT(mutexjobdata, @job_name) AS joblevel
				FROM users
				WHERE
					JSON_EXTRACT(mutexjobdata, @job_name) >= 1
				]===]
		end
		MySQL.Async.fetchAll(query, {
			['@job_name'] = '$.'..xPlayer.job.name
		}, function(result)
			cb(result)
		end)
	else
		cb({})
	end
end)

ESX.RegisterServerCallback('rpuk_factions:removePlayerAccessFromFaction', function(playerId, cb, characterId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local whitelistName = xPlayer.job.name

	if xPlayer.getCharacterId() == characterId then
		cb(false)
	else
		if Config.Management[xPlayer.job.name] and xPlayer.job.grade >= Config.Management[xPlayer.job.name] then
			local xTarget = ESX.GetPlayerFromCharId(characterId)

			if Config.LookupOverride[xPlayer.job.name] then
				if xTarget then
					if xTarget.job.name == xPlayer.job.name then
						if xPlayer.job.name == "ambulance" then whitelistName = "nhs" end
						xTarget.resetWhitelistFlags(whitelistName)
						xTarget.setWhitelist(whitelistName, -1, nil)
						xTarget.setJob('unemployed', 0)
						xTarget.save()
						cb(true)
					else
						cb(false)
					end
				else
					local lookupOverride = Config.LookupOverride[xPlayer.job.name]
					local flags = {}
					for k,v in pairs(lookupOverride.flags) do flags[k] = 0 end

					MySQL.Async.execute(('UPDATE users SET %s = @data, %s = @level, job = @job, job_grade = @jobGrade WHERE rpuk_charid = @rpuk_charid AND %s > -1'):format(lookupOverride.data, lookupOverride.level, lookupOverride.level), {
						['@rpuk_charid'] = characterId,
						['@data'] = json.encode(flags),
						['@level'] = -1,
						['@job'] = "unemployed",
						['@job_grade'] = 0,
					}, function(rowsChanged)
						cb(rowsChanged >= 0)
					end)
				end
			else
				if xTarget then
					xTarget.setMutexJob(xPlayer.job.name, 0)
					xTarget.setJob('unemployed', 0)
					xTarget.save()
					cb(true)
				else
					MySQL.Async.execute([===[
						UPDATE users
						SET
							mutexjobdata = JSON_SET(mutexjobdata, @job_mutex, @job_level),
							job = @job_name,
							job_grade = @job_level
						WHERE rpuk_charid = @rpuk_charid
					]===], {
						['@rpuk_charid'] = characterId,
						['@job_mutex'] = '$.'..xPlayer.job.name,
						['@job_level'] = 0,
						['@job_name'] = "unemployed",
					}, function(rowsChanged)
						cb(rowsChanged >= 0)
					end)
				end
			end
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('rpuk_factions:updateFlagsForPlayer', function(playerId, cb, characterId, newFlags, newPlayerRank)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if Config.Management[xPlayer.job.name] and xPlayer.job.grade >= Config.Management[xPlayer.job.name] and Config.LookupOverride[xPlayer.job.name] then
		local xTarget = ESX.GetPlayerFromCharId(characterId)

		if xTarget then
			if xTarget.job.name == xPlayer.job.name then
				local maxLevel = ESX.Table.SizeOf(ESX.GetJobs()[xPlayer.job.name].grades)
				local whitelistName = xPlayer.job.name

				if newPlayerRank <= maxLevel then
					if xPlayer.job.name == "ambulance" then whitelistName = "nhs" end
					for k,v in pairs(newFlags) do xTarget.setWhitelist(whitelistName, v, k) end
					xTarget.setWhitelist(whitelistName, newPlayerRank, nil)
					if xTarget.job.grade ~= newPlayerRank then xTarget.setJob(xPlayer.job.name, newPlayerRank) end
					xTarget.save()
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		else
			local lookupOverride = Config.LookupOverride[xPlayer.job.name]
			local maxLevel = ESX.Table.SizeOf(ESX.GetJobs()[xPlayer.job.name].grades)

			if newPlayerRank <= maxLevel then
				MySQL.Async.execute(('UPDATE users SET %s = @data, %s = @level, job = @job, job_grade = @job_grade WHERE rpuk_charid = @rpuk_charid AND %s > -1'):format(lookupOverride.data, lookupOverride.level, lookupOverride.level), {
					['@rpuk_charid'] = characterId,
					['@data'] = json.encode(newFlags),
					['@level'] = newPlayerRank,
					['@job'] = xPlayer.job.name,
					['@job_grade'] = newPlayerRank,
				}, function(rowsChanged)
					cb(rowsChanged >= 0)
				end)
			else
				cb(false)
			end
		end
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('rpuk_factions:updateMutexJobForPlayer', function(playerId, cb, characterId, level)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if Config.Management[xPlayer.job.name] and xPlayer.job.grade >= Config.Management[xPlayer.job.name] then
		local maxRank = Config.maxMutexRank[xPlayer.job.name]

		if level <= maxRank then
			local xTarget = ESX.GetPlayerFromCharId(characterId)

			if xTarget then
				if xTarget.job.name == xPlayer.job.name then
					xTarget.setMutexJob(xPlayer.job.name, level)
					xTarget.setJob(xPlayer.job.name, level)
					xTarget.save()
					cb(true)
				else
					cb(false)
				end
			else
				MySQL.Async.execute([===[
					UPDATE users
					SET
						mutexjobdata = JSON_SET(mutexjobdata, @job_mutex, @job_level),
						job = @job_name,
						job_grade = @job_level
					WHERE rpuk_charid = @rpuk_charid
				]===], {
					['@rpuk_charid'] = characterId,
					['@job_mutex'] = '$.'..xPlayer.job.name,
					['@job_name'] = xPlayer.job.name,
					['@job_level'] = level
				}, function(rowsChanged)
					cb(rowsChanged >= 0)
				end)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('rpuk_factions:getJobData', function(playerId, cb, characterId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if Config.Management[xPlayer.job.name] and xPlayer.job.grade >= Config.Management[xPlayer.job.name] and Config.LookupOverride[xPlayer.job.name] then
		MySQL.Async.fetchScalar(('SELECT %s FROM users WHERE rpuk_charid = @rpuk_charid'):format(Config.LookupOverride[xPlayer.job.name].data), {
			['@rpuk_charid'] = characterId
		}, function(jobData)
			cb(jobData)
		end)
	else
		cb({})
	end
end)

ESX.RegisterServerCallback('rpuk_factions:employPlayerByCharacterId', function(playerId, cb, characterId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local whitelistName = xPlayer.job.name

	if Config.Management[xPlayer.job.name] and xPlayer.job.grade >= Config.Management[xPlayer.job.name] then
		local xTarget = ESX.GetPlayerFromCharId(characterId)

		if Config.LookupOverride[xPlayer.job.name] then
			if xPlayer.job.name == "ambulance" then whitelistName = "nhs" end
			if xTarget then
				xTarget.setWhitelist(whitelistName, 0, nil)
				xTarget.setJob(xPlayer.job.name, 0)
				xTarget.save()
				cb(true)
			else
				local lookupOverride = Config.LookupOverride[xPlayer.job.name]

				MySQL.Async.execute(('UPDATE users SET %s = @level, job = @job, job_grade = @job_grade WHERE rpuk_charid = @rpuk_charid AND %s = -1'):format(lookupOverride.level, lookupOverride.level), {
					['@rpuk_charid'] = characterId,
					['@level'] = 0,
					['@job'] = xPlayer.job.name,
					['@job_grade'] = 0,
				}, function(rowsChanged)
					cb(rowsChanged >= 0)
				end)
			end
		else
			if xTarget then
				xTarget.setMutexJob(xPlayer.job.name, 1)
				xTarget.setJob(xPlayer.job.name, 1)
				xTarget.save()
				cb(true)
			else
				MySQL.Async.execute([===[
					UPDATE users
					SET
						mutexjobdata = JSON_SET(mutexjobdata, @job_mutex, @job_level),
						job = @job_name,
						job_grade = @job_level
					WHERE rpuk_charid = @rpuk_charid
				]===], {
					['@rpuk_charid'] = characterId,
					['@job_name'] = xPlayer.job.name,
					['@job_mutex'] = '$.'..xPlayer.job.name,
					['@job_level'] = 1
				}, function(rowsChanged)
					cb(rowsChanged >= 0)
				end)
			end
		end
	else
		cb(false)
	end
end)