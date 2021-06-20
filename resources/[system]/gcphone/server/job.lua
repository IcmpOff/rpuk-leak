local phoneNumbers = {}

for k,v in ipairs({'ambulance', 'taxi', 'police', 'mechanic', 'gruppe6', 'weazel', 'court'}) do
	phoneNumbers[v] = {type = v, sources = {}}
end

function notifyAlertSMS(job, coords, message)
	if job == 'police' then --No need to store police dispatches and gps coordinates in the databases. No need for them to even go to the phone. This is causing 4 sql queries per cop per dispatch.
		TriggerEvent('rpuk_alerts:sNotification', {notiftype = "dispatch", dispatch = message, coords = vector3(coords['x'], coords['y'], coords['z'])})
	elseif phoneNumbers[job] then -- for job hotlines
		for playerId, _ in pairs(phoneNumbers[job].sources) do
			local xPlayer = ESX.GetPlayerFromId(playerId)
			if xPlayer then
				TriggerEvent('gcPhone:_internalAddMessage', job, xPlayer.getPhoneNumber(), message, 0, function(smsMess)
					TriggerClientEvent('gcPhone:receiveMessage', playerId, smsMess)
				end)

				if coords then
					TriggerEvent('gcPhone:_internalAddMessage', job, xPlayer.getPhoneNumber(), ('GPS: %.1f, %.1f'):format(coords.x, coords.y), 0, function(smsMess)
						TriggerClientEvent('gcPhone:receiveMessage', playerId, smsMess)
					end)
				end
			end
		end
	end	
	-- let it fall through if the phone number wasn't for the jobs
end

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	if phoneNumbers[lastJob.name] then
		TriggerEvent('esx_addons_gcphone:removeSource', lastJob.name, playerId)
	end

	if phoneNumbers[job.name] then
		TriggerEvent('esx_addons_gcphone:addSource', job.name, playerId)
	end
end)

AddEventHandler('esx_addons_gcphone:addSource', function(number, playerId) phoneNumbers[number].sources[playerId] = true end)
AddEventHandler('esx_addons_gcphone:removeSource', function(number, playerId) phoneNumbers[number].sources[playerId] = nil end)

RegisterNetEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(job, message) 
	notifyAlertSMS(job, nil, message)
end)

RegisterNetEvent('esx_addons_gcphone:startCall')
AddEventHandler('esx_addons_gcphone:startCall', function(job, message, coords, from) 
	if message ~= nil and message ~= "" then
		notifyAlertSMS(job, coords, message .. " (From "..from..")") 
		TriggerEvent('rpuk:disc_post', 0, tostring(job), "New Phone Message ("..from..")", tostring(message))
	end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	if phoneNumbers[xPlayer.job.name] then
		TriggerEvent('esx_addons_gcphone:addSource', xPlayer.job.name, playerId)
	end
end)

AddEventHandler('esx:playerDropped', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if phoneNumbers[xPlayer.job.name] then
		TriggerEvent('esx_addons_gcphone:removeSource', xPlayer.job.name, playerId)
	end
end)