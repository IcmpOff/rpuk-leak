local job_max = {
	["mechanic"] = 4,
	["ranger"] = 4,
}

-- Assigns the player to the job
RegisterNetEvent('rpuk_jobs:assign')
AddEventHandler('rpuk_jobs:assign', function(job)
	local xPlayer = ESX.GetPlayerFromId(source)
	local data = json.decode(xPlayer.mutexjobdata)
	if job == "unemployed" then
		xPlayer.setJob(job, 0)
	elseif data[job] then
		val = string.sub(data[job], 0, 1)
		if tonumber(val) <= tonumber(job_max[job]) then
			xPlayer.setJob(tostring(job), tonumber(val))
		else
			xPlayer.setJob(tostring(job), tonumber(job_max[job]))
		end
	end
	TriggerEvent("rpuk_core:SavePlayerServer", xPlayer.source)
end)

-- Increases/decreases the players job level
RegisterNetEvent('rpuk_jobs:level')
AddEventHandler('rpuk_jobs:level', function(target, job, increase)
	local _job = job
	local xPlayer = ESX.GetPlayerFromId(target)
	local data = json.decode(xPlayer.mutexjobdata)
	if increase then
		if tonumber(data[_job]) < tonumber(getMaxGrade(_job)) then
			print("RPUK JOBS LEVEL CHANGE: " .. xPlayer.identifier .. " " .. _job .. " FROM: " .. data[_job] .. " TO: " .. data[_job] + 1 )
			local newGrade = data[_job] + 1
			xPlayer.setMutexJob(_job, newGrade)
			xPlayer.setJob(_job, newGrade)
		else
			print("Job not changed (already at max level)")
			xPlayer.showNotification('Already at max level', 5000, 'info', 'longnotif')
		end
	else
		print("RPUK JOBS LEVEL CHANGE: " .. xPlayer.identifier .. " " .. _job .. " FROM: " .. data[_job] .. " TO: " .. data[_job] - 1 )
		local newGrade = data[_job] - 1
		xPlayer.setMutexJob(_job, newGrade)
		xPlayer.setJob(_job, newGrade)
	end
	TriggerEvent("rpuk_core:SavePlayerServer", xPlayer.source)
end)

-- Hawaai and I couldn't figure out a better way to check this, there were some weird edge case issue with using ESX.Math.Round() to check
function shouldLevel(num)
	for i=1, 10 do
		if i == num then return true end
	end
end

RegisterNetEvent('rpuk_jobs:progress')
AddEventHandler('rpuk_jobs:progress', function(job)
	local xPlayer = ESX.GetPlayerFromId(source)
	local mutexData =json.decode(xPlayer.getmutexjobdata())
	local progressData = json.decode(xPlayer.getprogressdata())
	local progress = Config.Progression[job].progress
	local label = Config.Progression[job].label
	local increase = Config.Progression[job].increase
	local max = Config.Progression[job].max
	local hasMutex = Config.Progression[job].hasMutex

	if progressData[progress] then
		if hasMutex and progressData[progress] < mutexData[job] then -- preserve previous levels
			xPlayer.setStatData(progress, mutexData[job])
			xPlayer.showNotification(('Your previous qualifications allow to to have progression level %s for %s'):format(mutexData[job], label))
		elseif progressData[progress] == max then --Already at max
			xPlayer.showNotification(("You already have the maximum %s"):format(label), 2500, 'inform')
		elseif progressData[progress] + increase > max then --At or over max with this increase
			xPlayer.setStatData(progress, max)
			xPlayer.showNotification(('You have reached the maximum level of %s for %s'):format(max, label), 2500, 'inform')
			if hasMutex then TriggerEvent('rpuk_jobs:level', source, job, true) end
		else -- mpr,a; [rpgressopm]
			xPlayer.increaseStat(progress, increase)
			xPlayer.showNotification('New '.. label .. ' ' .. progressData[progress] + increase, 2500, 'inform')
			local num = ESX.Math.Round(progressData[progress] + increase, 2)
			if hasMutex and shouldLevel(num) then --if progression involves mutex job trigger mutex levelling
				TriggerEvent('rpuk_jobs:level', source, job, true)
			end
		end
	else --progress does not yet exist in progressdata (never done this job before)
		xPlayer.setStatData(progress, increase)
		xPlayer.showNotification('You have learned a new skill, ' .. label .. ' increased to ' .. increase, 2500, 'inform')
	end
end)


function getMaxGrade(job)
	local grades = ESX.GetJobs()[job].grades
	local maxGrade = 0
	for k, _ in pairs(grades) do
		if tonumber(k) > tonumber(maxGrade) then
			maxGrade = k
		end
	end
	return maxGrade
end

function CountRoles()
	local xPlayers = ESX.GetPlayers()
	local count_pol, count_nhs, count_lost, count_mechanicLevel4, count_whitegangs, count_nca = 0, 0, 0, 0, 0, 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		local gang_id, gang_rank = xPlayer.getGang()
		if xPlayer.job.name == 'police' then
			count_pol = count_pol + 1
		elseif xPlayer.job.name == 'ambulance' then
			count_nhs = count_nhs + 1
		elseif xPlayer.job.name == 'lost' then
			count_lost = count_lost + 1
		elseif xPlayer.job.name == 'mechanic' and xPlayer.job.grade >= 4 then
			count_mechanicLevel4 = count_mechanicLevel4 + 1
		end
		if gang_id > 0 and gang_id < 6 then -- one of the main turf gangs = more risk
			count_whitegangs = count_whitegangs + 1
		end
	end
	--print("CONNECTED JOB COUNT: " .. " POL:" .. count_pol .. " NHS:" .. count_nhs .. " Lost:" .. count_lost)
	TriggerClientEvent('rpuk_jobs:count', -1, count_pol, count_nhs, count_lost, count_mechanicLevel4, count_whitegangs)
	TriggerEvent('rpuk_jobs:count', {police = count_pol, nhs = count_nhs, lost = count_lost, mechanics = count_mechanicLevel4, gangs = count_whitegangs})
	SetTimeout(120000, CountRoles)
end

CountRoles()