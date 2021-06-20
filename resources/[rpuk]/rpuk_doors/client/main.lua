job = ESX.Player.GetJob()
interactions = {}
activeInteractions = {}


RegisterNetEvent('rpuk_doors:updateDoor')
RegisterNetEvent('rpuk_doors:advancepick')
RegisterNetEvent('esx:playerLoaded')
RegisterNetEvent('esx:setJob')

Citizen.CreateThread(function()
	ESX.TriggerServerCallback("rpuk_doors:getAllDoors", function(doors)
		for k,v in pairs(doors) do
			interactions[v.id] = {
				text = "",
				dist = v.frozenDist,
				displayDist = v.distance,
				pos = v.textCoords,
				id = v.id,
				positionForDoorText = v.positionForDoorText,
				textOnDoor = v.textOnDoor,
				refresh = false,
				background = false,
				data = v
			}
		end
	end)
end)

function lockpickOption(id)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), "rpuk_doors",
	{
		css = "interaction",
		align = "top-left",
		elements = {
			{
				label = "Lockpick",
				value = "lockpick"
			},
			{
				label = "Advanced lockpick",
				value = "advanced_lockpick"
			},
			{
				label = "Drill",
				value = "drill"
			}
		}
	}, function(data, menu)
		TriggerServerEvent("rpuk_doors:pick", id, data.current.value)
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
			RequestAnimDict( dict )
			Citizen.Wait( 5 )
	end
end

function resetAnim()
	local player = GetPlayerPed( -1 )
	ClearPedSecondaryTask(player)
end

function clearAnim()
	local ped = PlayerPedId()
	ResetPedMovementClipset(ped, 0.0)
	ResetPedWeaponMovementClipset(ped)
	ResetPedStrafeClipset(ped)
end

function crackingsafeanim(animType)
	local player = GetPlayerPed( -1 )
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
			loadAnimDict( "mini@safe_cracking" )
		if animType == 1 then
			if IsEntityPlayingAnim(player, "mini@safe_cracking", "dial_turn_anti_fast_1", 3) then
				--ClearPedSecondaryTask(player)
			else
				TaskPlayAnim(player, "mini@safe_cracking", "dial_turn_anti_fast_1", 8.0, -8, -1, 49, 0, 0, 0, 0)
			end
		end
			if animType == 2 then
				TaskPlayAnim( player, "mini@safe_cracking", animsIdle[math.floor(math.ceil(4))], 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			end
			if animType == 3 then
				TaskPlayAnim( player, "mini@safe_cracking", animsSucceed[math.floor(math.ceil(4))], 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
		end
	end
end

AddEventHandler('esx:playerLoaded', function(playerData)
	job = playerData.job
	while IsPedStill(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId()) do Citizen.Wait(0) end
	for k,v in pairs(activeInteractions) do
		interactions[k].refresh = true
	end
end)

AddEventHandler('esx:setJob', function(data)
	job = data
	for k,v in pairs(activeInteractions) do
		interactions[k].refresh = true
	end
end)

function getDistance(coords1, coords2)
	if coords1.z-0.5 <= coords2.z then
		return Vdist2(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z)
	else
		return 9999999999
	end
end

function Draw3DText(x,y,z, text, background)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.4, 0.4)
	SetTextFont(4)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	if background ~= false then
		local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0125, 0.02+ factor, 0.05, 110, 110, 110, 75)
	end
end

function closestInteraction()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local closestId = nil
	local closestDist = 9999999999999
	for k,v in pairs(interactions) do
		local dist = getDistance(coords, v.pos)
		if dist < closestDist then
			closestId = k
			closestDist = dist
		end
	end

	return closestId
end

Citizen.CreateThread(function()
	while true do
		Wait(250)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(interactions) do
			if activeInteractions[v.id] == nil and getDistance(coords, v.pos) < v.dist and interactions[k] ~= nil then
				activeInteractions[v.id] = true
				closeToInteraction(k, v)
			end
		end
	end
end)

function closeToInteraction(k, v)
	Citizen.CreateThread(function()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local door = v.data

			for key,val in pairs(v.data.doors) do
				local closeDoor = GetClosestObjectOfType(val.objCoords.x, val.objCoords.y, val.objCoords.z, 5.0, val.objHash, false, false, false)
				if (door.locked and val.objCloseState) then
					FreezeEntityPosition(closeDoor, door.locked)
					SetEntityRotation(closeDoor, val.objCloseState.pitch, val.objCloseState.roll, val.objCloseState.yaw, 0, true)
				elseif door.locked then
					FreezeEntityPosition(closeDoor, door.locked)
				end
			end
			interactions[k].text = ""
			if door.authorizedJobs == nil and door.unAuthorized == nil then
				if job.name == "staff" then
					TriggerServerEvent('rpuk_doors:toggleDoor', door.id)
					TriggerEvent('dooranim')
				elseif canRepair(door.allowedToRepairDoor) and not door.locked then
					interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.repair
				elseif door.lockpick and job.name ~= "police" and door.locked and not door.ziptied and door.isEnoughCopsOnDuty then
					interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.lockpick
				elseif door.ziptie and not door.locked and not door.ziptied and job.name ~= "police" then
					interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.ziptie
				elseif door.ziptie and door.locked and door.ziptied and job.name ~= "police" then
					interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.ziptied
				elseif door.hackable and job.name ~= "police" and door.locked then
					interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.hackable
				elseif door.breachable and job.name == "police" and door.locked then
					interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.breach
				else
					interactions[k].text = door.textIfUnAuthorized
				end
			elseif door.authorizedJobs ~= nil then
				if (isAuthorized(job, door.authorizedJobs) and not door.ziptied) or job.name == "staff" then
					interactions[k].text = door.textIfAuthorized
				else
					if canRepair(door.allowedToRepairDoor) and not door.locked then
						interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.repair
					elseif door.lockpick and job.name ~= "police" and door.locked and not door.ziptied and door.isEnoughCopsOnDuty then
						interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.lockpick
					elseif door.ziptie and not door.locked and not door.ziptied and job.name ~= "police" then
						interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.ziptie
					elseif door.ziptie and door.locked and door.ziptied and job.name ~= "police" then
						interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.ziptied
					elseif door.hackable and job.name ~= "police" and door.locked then
						interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.hackable
					elseif door.breachable and job.name == "police" and door.locked then
						interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.breach
					else
						interactions[k].text = door.textIfUnAuthorized
					end
				end
			else
				if isUnauthorized(job, door.unAuthorized) then
					if canRepair(door.allowedToRepairDoor) and not door.locked then
						interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.repair
					elseif door.lockpick and job.name ~= "police" and door.locked and not door.ziptied and door.isEnoughCopsOnDuty then
						interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.lockpick
					elseif door.ziptie and not door.locked and not v.ziptied and job.name ~= "police" then
						interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.ziptie

					elseif door.ziptie and door.locked and door.ziptied and job.name ~= "police" then
						interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.ziptied

					elseif door.hackable and job.name ~= "police" and door.locked then
						interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.hackable

					elseif door.breachable and job.name == "police" and door.locked then
						interactions[k].text = door.textIfUnAuthorized .. "\n" .. Config.text.breach

					else
						interactions[k].text = door.textIfUnAuthorized
					end
				else
					interactions[k].text = door.textIfAuthorized
				end
			end

			-- The action taken when E is pressed on a door
			interactions[k].action = function()
				if door.authorizedJobs == nil and door.unAuthorized == nil then
					if job.name == "staff" then
						TriggerServerEvent('rpuk_doors:toggleDoor', door.id)
						TriggerEvent('dooranim')
					elseif canRepair(door.allowedToRepairDoor) and not door.locked then
						TriggerServerEvent("rpuk_doors:repairDoor", door.id)
					elseif door.lockpick and job.name ~= "police" and door.locked and not door.ziptied and door.isEnoughCopsOnDuty then
						lockpickOption(door.id)
					elseif door.ziptie and not door.locked and not door.ziptied and job.name ~= "police" then
						TriggerServerEvent("rpuk_doors:ziptie", door.id)
					elseif door.ziptie and door.locked and door.ziptied and job.name ~= "police" then
						TriggerServerEvent("rpuk_doors:unZiptie", door.id)
					elseif door.hackable and job.name ~= "police" and door.locked then
						TriggerServerEvent('rpuk_doors:hack', door.id)
					elseif door.breachable and job.name == "police" and door.locked then
						TriggerServerEvent("rpuk_doors:breach", door.id)
					end
				elseif door.authorizedJobs ~= nil then
					if (isAuthorized(job, door.authorizedJobs) and not door.ziptied) or job.name == "staff" then
						TriggerServerEvent('rpuk_doors:toggleDoor', door.id)
						TriggerEvent('dooranim')
					else
						if canRepair(door.allowedToRepairDoor) and not door.locked then
							TriggerServerEvent("rpuk_doors:repairDoor", door.id)
						elseif door.lockpick and job.name ~= "police" and door.locked and not door.ziptied and door.isEnoughCopsOnDuty then
							lockpickOption(door.id)
						elseif door.ziptie and not door.locked and not door.ziptied and job.name ~= "police" then
							TriggerServerEvent("rpuk_doors:ziptie", door.id)
						elseif door.ziptie and door.locked and door.ziptied and job.name ~= "police" then
							TriggerServerEvent("rpuk_doors:unZiptie", door.id)
						elseif door.hackable and job.name ~= "police" and door.locked then
							TriggerServerEvent('rpuk_doors:hack', door.id)
						elseif door.breachable and job.name == "police" and door.locked then
							TriggerServerEvent("rpuk_doors:breach", door.id)
						end
					end
				else
					if isUnauthorized(job, door.unAuthorized) then
						if canRepair(door.allowedToRepairDoor) and not door.locked then
							TriggerServerEvent("rpuk_doors:repairDoor", door.id)
						elseif door.lockpick and job.name ~= "police" and door.locked and not door.ziptied and door.isEnoughCopsOnDuty then
							lockpickOption(door.id)
						elseif door.ziptie and not door.locked and not door.ziptied and job.name ~= "police" then
							TriggerServerEvent("rpuk_doors:ziptie", door.id)
						elseif door.ziptie and door.locked and door.ziptied and job.name ~= "police" then
							TriggerServerEvent("rpuk_doors:unZiptie", door.id)
						elseif door.hackable and job.name ~= "police" and door.locked then
							TriggerServerEvent('rpuk_doors:hack', door.id)
						elseif door.breachable and job.name == "police" and door.locked then
							TriggerServerEvent("rpuk_doors:breach", door.id)
						end
					else
						TriggerServerEvent('rpuk_doors:toggleDoor', door.id)
						TriggerEvent('dooranim')
					end
				end
			end

		--TriggerServerEvent('rpuk_doors:addInteracting', v.id)
		while getDistance(coords, v.pos) < v.dist and not interactions[k].refresh do
			Citizen.Wait(0)
			ped = PlayerPedId()
			coords = GetEntityCoords(ped)
			if getDistance(coords, v.pos) < v.dist then -- Frozen Dist
				if getDistance(coords, v.pos) < v.displayDist then -- Coords On Door Text
					if v.textOnDoor then -- Coors Stuck On Door position
						local doorObj = GetClosestObjectOfType(coords, 5.0, door.doors[1].objHash, false)
						local doorOffset = GetOffsetFromEntityInWorldCoords(doorObj, v.positionForDoorText.offsetX, v.positionForDoorText.offsetY, v.positionForDoorText.offsetZ)
						Draw3DText(doorOffset.x, doorOffset.y, doorOffset.z, interactions[k].text, v.background)
					else -- Coords set by Config
						Draw3DText(v.pos.x, v.pos.y, v.pos.z, interactions[k].text, v.background)
					end
					if IsControlJustReleased(0, 38) and v.action ~= nil and v.id == closestInteraction() then
						interactions[k].action()
					end
				end
			end
		end
		--TriggerServerEvent('rpuk_doors:removeInteracting', v.id)
		v.refresh = false
		activeInteractions[v.id] = nil
	end)
end

function isAuthorized(rank, list)
	for _,v in pairs(list) do
		if rank.name == v.name and rank.grade >= v.rank then
			if v.specUnit[1] == nil then
				return true
			end
			-- for key,val in pairs(v.specUnit) do
			-- 	return true
			-- end
			return false
		end
		if v.type == "gang" then
			if ESX.Player.GetGangData().gang_id == v.name then
				return true
			end
		elseif v.type == "civJob" then
			if ESX.Player.GetCivJob()[v.name] then
				if ESX.Player.GetCivJob()[v.name] >= v.rank then
					return true
				end
			end
		end
	end

	return false
end

function isUnauthorized(rank, list)
	for k,v in pairs(list) do
		if rank.name == v.name then
			return true
		end
	end
	return false
end

function canRepair(list)
	for k,v in pairs(list) do
		if job.name == v then
			return true
		end
	end
	return false
end



AddEventHandler('rpuk_doors:updateDoor', function(id, update, options)
	if interactions[id] then
		if options then
			for k,v in pairs(options) do
				interactions[id].data[k] = v
			end
			interactions[id].refresh = true
			Citizen.Wait(Config.LockTimer)
		end
		for k,v in pairs(update) do
			if k == "locked" then
				for _,val in pairs(interactions[id].data.doors) do
					local closeDoor = GetClosestObjectOfType(val.objCoords.x, val.objCoords.y, val.objCoords.z, 5.0, val.objHash, false, false, false)
					FreezeEntityPosition(closeDoor, v)
					if val.objCloseState then
						SetEntityRotation(closeDoor, val.objCloseState.pitch, val.objCloseState.roll, val.objCloseState.yaw, 0, true)
					end
				end
			end
			interactions[id].data[k] = v
		end
		interactions[id].refresh = true
	end
end)

