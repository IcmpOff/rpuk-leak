jobName = ESX.Player.GetJobName()

RegisterNetEvent('rpuk:spawned')
AddEventHandler('rpuk:spawned', function()
	if isInList(ESX.Player.GetJobName(), Config.AccessToRadioFreq) then
		exports["pma-voice"]:GivePlayerAccessToFrequencies(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
	Citizen.Wait(1000)
	if isInList(ESX.Player.GetJobName(), Config.AccessToRadioFreq) then
		exports["pma-voice"]:GivePlayerAccessToFrequencies(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
	end
	jobName = ESX.Player.GetJobName()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler('esx:setJob', function(data)
	Citizen.Wait(2000)
	jobName = data.name
end)

function isInList(val, list)
	for k,v in pairs(list) do
		if val == v then
			return true
		end
	end
	return false
end



function checkPolyZone(type) -- This checks what polyZone you are in and if your job/mutex is allowed it will return a booleen
	ESX.PlayerData = ESX.GetPlayerData() -- todo fix
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	for _,v in pairs(Locations.PolyPoints) do
		if v[type] then
			for _, val in pairs(v[type].PolyZone) do
				if val:isPointInside(pedCoords) then
					if v.JobInfo.type == "job" then
						if ESX.PlayerData[v.JobInfo.targetIndex] >= v[type].Restriction.rankRequried then -- todo fix
							if ESX.PlayerData[v.JobInfo.targetIndex] > -1 then -- todo fix
								if v[type].Restriction.requriedToClockIn then
									if ESX.Player.GetJobName() == v.JobInfo.name then
										return true
									else
										-- return false
									end
								else
									return true
								end
							else
								-- return false
							end
						else
							-- return false
						end
					elseif v.JobInfo.type == "mutex" then
						if ESX.Player.GetCivJob()[v.JobInfo.targetIndex] then
							if ESX.Player.GetCivJob()[v.JobInfo.targetIndex] >= v[type].Restriction.rankRequried then
								if ESX.Player.GetCivJob()[v.JobInfo.targetIndex] > 0 then
									if v[type].Restriction.requriedToClockIn then
										if ESX.Player.GetJobName() == v.JobInfo.name then
											return true
										else
											-- return false
										end
									else
										return true
									end
								else
									-- return false
								end
							else
								-- return false
							end
						else
							-- return false
						end
					end
				end
			end
		end
	end

	return false
end


function checkLocation(type) -- This returns the name of the polyZone in which you are currently in. It returns a string.
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)

	for _,v in pairs(Locations.PolyPoints) do
		if v[type] then
			for k, val in pairs(v[type].PolyZone) do
				if val:isPointInside(pedCoords) then
					if val then
						return k
					else
						return false
					end
				end
			end
		end
	end
end

function checkForJobRadius() -- This returns a booleen if you are within a job interaction zone
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)

	for k,v in pairs(Locations.JobInteraction) do
		if v:isPointInside(pedCoords) then
			return true
		end
	end
end


function checkJobPerm(type) -- This returns the data of job which is required to be used in the polyzone
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	ESX.PlayerData = ESX.GetPlayerData() -- todo fix

	for k,v in pairs(Locations.PolyPoints) do
		if v[type] then
			for key, val in pairs(v[type].PolyZone) do
				if val:isPointInside(pedCoords) then
					if v.JobInfo.type == "job" then
						if ESX.PlayerData[v.JobInfo.targetIndex] > -1 then  -- todo fix
							return v.JobInfo
						end
					elseif v.JobInfo.type == "mutex" then
						if ESX.Player.GetCivJob()[v.JobInfo.targetIndex] then
							if ESX.Player.GetCivJob()[v.JobInfo.targetIndex] > 0 then
								return v.JobInfo
							end
						end
					end
				end
			end
		end
	end
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

--No touchy da fishy
function sortedKeys (t, f)
	local a = {}
	local b = {}
	for k,v in pairs(t) do
		table.insert(a, tonumber(v.order))
		b[v.order] = k
	end
	table.sort(a, f)
	local i = 0
	local iter = function ()
		i = i + 1
		if a[i] ~= nil then
		return b[tostring(a[i])], t[a[i]] end
	end
	return iter
end
--No touchy da fishy


RegisterNetEvent('rpuk_factions:closeToInteraction')
AddEventHandler('rpuk_factions:closeToInteraction', function(Interaction)
	local currentJob = checkJobPerm(Interaction)
	local polyZone = checkLocation(Interaction)

	if Interaction == "ClockIn" then
		if currentJob.name == "police" and ESX.Player.GetPoliceLevel() > -1 then
			TriggerServerEvent('rpuk_core:setJob', "police", ESX.Player.GetPoliceLevel())
			TriggerServerEvent('rpuk_factions:updatePlayerDuty', true, 'police')
		elseif currentJob.name == "ambulance" and ESX.Player.GetNHSLevel() > -1 then
			TriggerServerEvent('rpuk_core:setJob', "ambulance", ESX.Player.GetNHSLevel())
			TriggerServerEvent('rpuk_factions:updatePlayerDuty', true, 'ambulance')
		elseif currentJob.name == "lost" and ESX.Player.GetLostLevel() > -1 then
			TriggerServerEvent('rpuk_core:setJob', "lost", ESX.Player.GetLostLevel())
		else
			if ESX.Player.GetCivJob()[currentJob.name] then
				if ESX.Player.GetCivJob()[currentJob.name] > 0 then
					TriggerServerEvent('rpuk_core:setJob', currentJob.name, ESX.Player.GetCivJob()[currentJob.name])
				end
			end
		end
		TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'Welcome Back!'})
		if isInList(currentJob.name, Config.AccessToRadioFreq) then
			exports["pma-voice"]:GivePlayerAccessToFrequencies(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
		end
	elseif Interaction == "ClockOut" then
		TriggerServerEvent('rpuk_core:setJob', "unemployed", 0)
		TriggerServerEvent('rpuk_factions:updatePlayerDuty', false)
		TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'See you soon!'})
		exports["pma-voice"]:RemovePlayerAccessToFrequencies(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
	elseif Interaction == "LockerRoom" then
		TriggerEvent("rpuk_factions:openLockerRoom", ESX.Player.GetJobName())
	elseif Interaction == "Armory" then
		TriggerEvent("rpuk_factions:openArmory", ESX.Player.GetJobName())
	elseif Interaction == "Attachments" then
		TriggerEvent("rpuk_factions:openAttachmentMenu", ESX.Player.GetJobName())
	elseif Interaction == "VehicleRental" then
		TriggerEvent("rpuk_factions:openVehicleMenu", ESX.Player.GetJobName(), Locations.PolyPoints[ESX.Player.GetJobName()][Interaction].PolyZone[polyZone].name)
	elseif Interaction == "VehicleDelete" then
		TriggerEvent("rpuk_factions:returnVehicle", ESX.Player.GetJobName())
	elseif Interaction == "Management" then
		if Config.Management[currentJob.name] then
			if ESX.Player.GetJobGrade() >= Config.Management[currentJob.name] then
				TriggerEvent("rpuk_factions:openManagementMenu", currentJob.name)
			else
				TriggerEvent('mythic_notify:client:SendAlert', {length = 6000, type = 'error', text = 'You can not use this.' })
			end
		end
	elseif Interaction == "ViewFund" then
		if Config.fundAccess[currentJob.name] then
			if ESX.Player.GetJobGrade() >= Config.fundAccess[currentJob.name].View then
				TriggerEvent("rpuk_atm:OpenRemotely", currentJob.name)
			else
				TriggerEvent('mythic_notify:client:SendAlert', {length = 6000, type = 'error', text = 'You can not use this.' })
			end
		end
	elseif Interaction == "FundManagement" then
		if Config.fundAccess[currentJob.name] then
			if ESX.Player.GetJobGrade() >= Config.fundAccess[currentJob.name].Admin then
				TriggerEvent("rpuk_factions:fundManagementMenu", currentJob.name)
			else
				TriggerEvent('mythic_notify:client:SendAlert', {length = 6000, type = 'error', text = 'You can not use this.' })
			end
		end
	end
end)