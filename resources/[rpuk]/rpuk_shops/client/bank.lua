--Main thread
local bankIndex, rated = nil, false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local textformat = ''
		for index, data in pairs(Config.Banks) do
			--Hacking and repairing part below
			if GetDistanceBetweenCoords(coords, data.hackingPoint) < 2.0 then
				if not data.isHacked then
					textformat = data.name .. "\nPress [~r~E~s~] To Hack Terminal"
				elseif ESX.Player.GetJobName() == "police" then
					textformat = data.name .. "\nPress [~r~E~s~] To Repair The Terminal"
				end
				local textpos = vector3(data.hackingPoint.x, data.hackingPoint.y, data.hackingPoint.z + 1.0)
				ESX.Game.Utils.DrawText3D(textpos, textformat, 1.0, 6)
				if GetDistanceBetweenCoords(coords, data.hackingPoint) < 1.0 then
					if IsControlJustReleased(1,	38) and not rated then
						if (GetSelectedPedWeapon(PlayerPedId()) ~= -1569615261) then
							if not data.isHacked then
								ESX.TriggerServerCallback('rpuk_robberies:checkPolice', function(police)
									if police then
										rated = true
										TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "bank"})
										bankIndex = index
										TriggerEvent("mythic_progbar:client:progress", {
											name = "device",
											duration = data.wait,
											label = "Configuring Device",
											useWhileDead = false,
											canCancel = false,
											controlDisables = {
												disableMovement = false,
												disableCarMovement = false,
												disableMouse = false,
												disableCombat = false,
											},
											}, function(status)
											if not status then
												local coords = GetEntityCoords(PlayerPedId())
												if GetDistanceBetweenCoords(coords, data.hackingPoint) < 1.0 then
													TriggerEvent("mhacking:show")
													TriggerEvent("mhacking:start",7,35,hackingcb)
												end
												rated = false
											end
										end)
									else
										ESX.ShowHelpNotification("There arent enough police online to rob this bank!")
									end
								end, data.police)
							elseif ESX.Player.GetJobName() == "police" then
								TriggerEvent("mythic_progbar:client:progress", {
									name = "detach",
									duration = 15000,
									label = "Trying to restart system",
									useWhileDead = false,
									canCancel = false,
									controlDisables = {
										disableMovement = false,
										disableCarMovement = false,
										disableMouse = false,
										disableCombat = false,
									},
									}, function(status)
									if not status then
										TriggerServerEvent("rpuk_robberies:toggleBank", index, false)
									end
								end)
							end
						else
							ESX.ShowHelpNotification("You can't rob it with your fists!")
						end
					end
				end
			end
			--Grabbing from safe below
			if data.isHacked then
				for index2, data2 in pairs(data.safes) do
					if not data2.searched then
						if GetDistanceBetweenCoords(coords, data2.location) < 1.0 then
							textformat = "Safe #"..index2 .. "\nPress [~r~E~s~] To Open Safe"
							local textpos = vector3(data2.location.x, data2.location.y, data2.location.z + 1.0)
							ESX.Game.Utils.DrawText3D(textpos, textformat, 1.0, 6)
							if IsControlJustReleased(1,	38) then
								TriggerEvent("mythic_progbar:client:progress", {
									name = "drill",
									duration = data2.time,
									label = "Drilling the Safe",
									useWhileDead = false,
									canCancel = true,
									controlDisables = {
										disableMovement = true,
										disableCarMovement = true,
										disableMouse = false,
										disableCombat = true,
									},
									animation = {
										animDict = "anim@heists@fleeca_bank@drilling",
										anim = "drill_straight_fail",
										flags = 49,
										task = nil,
									},
									prop = {
										model = "hei_prop_heist_drill",
										bone = 57005,
										coords = { x = 0.15, y = 0.0, z = -0.05 },
										rotation = { x = 0.0, y = 90.0, z = 90.0	},
									}
									}, function(status)
									if not status then
										local coords = GetEntityCoords(PlayerPedId())
										if GetDistanceBetweenCoords(coords, data2.location) < 1.0 then
											if not data2.searched then
												TriggerServerEvent("rpuk_robberies:openSafe", index, index2)
											end
										end
									end
								end)
							end
						end
					end
				end
			end
		end
	end
end)

--Play v loud alarm when the bank is being robbed / hasnt been marked as closed again
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep = true
		for index, data in pairs (Config.Banks) do
			if data.doorName then
				local door = GetClosestObjectOfType(data.doorCoords.x, data.doorCoords.y, data.doorCoords.z, 20.0, GetHashKey(data.doorName),false, false, false)
				if data.isHacked then
					canSleep = false
					SetEntityRotation(door, 0.0, 0.0, data.doorORot, 1, true)
					local sid = GetSoundId()
					PlaySoundFromCoord(sid, "silo_alarm_loop", data.doorCoords.x, data.doorCoords.y, data.doorCoords.z - 50.0 , "dlc_xm_silo_finale_sounds", 1, 50, 0)
					Citizen.Wait(10000)
					StopSound(sid)
					ReleaseSoundId(sid)
				else
					SetEntityRotation(door, 0.0, 0.0, data.doorCRot, 1, true)
				end
			end
		end
		if canSleep then
			Citizen.Wait(3000)
		end
	end
end)

--Weld anim
function WeldAnimation(wait)
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
		Citizen.Wait(wait)
		ClearPedTasksImmediately(playerPed)
	end)
end

--Hacking callback
function hackingcb(success, timeremaining) --Hacking callback
	if success then
		TriggerServerEvent("rpuk_robberies:toggleBank", bankIndex, true)
		TriggerEvent('mhacking:hide')
	else
		TriggerEvent('mhacking:hide')
	end
end

--Toggles the bank open / closed for the client
RegisterNetEvent("rpuk_robberies:toggleBankClient")
AddEventHandler("rpuk_robberies:toggleBankClient", function(index, state)
	if Config.Banks[index].doorName then
		local door = GetClosestObjectOfType(Config.Banks[index].doorCoords.x, Config.Banks[index].doorCoords.y, Config.Banks[index].doorCoords.z, 20.0, GetHashKey(Config.Banks[index].doorName),false, false, false)
	end
	if state then
		Config.Banks[index].isHacked = state
		if door then
			SetEntityRotation(door, 0.0, 0.0, Config.Banks[index].doorORot, 1, true)
		end
		if ESX.Player.GetJobName() == "police" or ESX.Player.GetJobName() == "ambulance" then
			addBlip(index)
		end
	else --Reset safes on lock up
		Config.Banks[index].isHacked = state
		if door then
			SetEntityRotation(door, 0.0, 0.0, Config.Banks[index].doorCRot, 1, true)
		end
		for index, data in pairs (Config.Banks[index].safes) do
			data.searched = false
		end
		if ESX.Player.GetJobName() == "police" or ESX.Player.GetJobName() == "ambulance" then
			RemoveBlip(Config.Banks[index].blipHandle)
			Config.Banks[index].blipHandle = nil
		end
	end
	
end)

function addBlip(index)
	Config.Banks[index].blipHandle = AddBlipForCoord(Config.Banks[index].hackingPoint)
	SetBlipAsFriendly(Config.Banks[index].blipHandle, true)
	SetBlipSprite(Config.Banks[index].blipHandle, 161)
	BeginTextCommandSetBlipName("STRING");
	AddTextComponentString(tostring("Bank Robbery"))
	EndTextCommandSetBlipName(Config.Banks[index].blipHandle)
end

--Update the safe to closed
RegisterNetEvent("rpuk_robberies:updateSafe")
AddEventHandler("rpuk_robberies:updateSafe", function(bank, safe)
	Config.Banks[bank].safes[safe].searched = true
end)