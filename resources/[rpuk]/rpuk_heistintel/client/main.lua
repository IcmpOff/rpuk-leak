--[[
	Put blank usb in computer
	Start download process
	Detects hack and sets off gas
	Progress bar shows up only the hacker
	After hack is done you can retrieve USB
	Then you go to lester
	Lester NPC is in his house for 1 hour //Means you will have to wait x hour for lester to leave
	After he leaves you can hack his computer //Means you have x time as a window to hack it
	Minigame will pop up and you will get access to information on his computer //If you fail the hack, 1 attempt it has a x chance of exploding which will start a fire
	You can then order a shipment //This shipment contains the heist equipment
	Shipment works the same as cocaine //Alert police
]]

-- If lester value == 0 this means he is not a ped (He gone)
-- If lester value ~= 0 this means he is a ped (He home)

RegisterNetEvent('rpuk_lester:updateDownloadTimer')
RegisterNetEvent('rpuk_lester:initDownloadTimer')
RegisterNetEvent('rpuk_lester:doneDownloading')
RegisterNetEvent('rpuk_lester:pickedupUSB')
RegisterNetEvent('rpuk_lester:updateCooldownTimer')
RegisterNetEvent('rpuk_lester:cooldownDone')
RegisterNetEvent("rpuk_lester:startgas")
RegisterNetEvent('rpuk_lester:spawnLester')
RegisterNetEvent('rpuk_lester:currentlyhacking')
RegisterNetEvent("rpuk_lester:upload")
RegisterNetEvent("rpuk_lester:download")
RegisterNetEvent('rpuk_lester:setWaypoint')
RegisterNetEvent('rpuk_lester:addBlip')
RegisterNetEvent('rpuk_lester:removeBlip')
RegisterNetEvent('rpuk_lester:shipment')
RegisterNetEvent('rpuk_lester:closeAllMenues')
RegisterNetEvent('rpuk_lester:deleteCrateObj')
RegisterNetEvent('rpuk_lester:spawnCrate')
RegisterNetEvent('rpuk_lester:registerCrate')
RegisterNetEvent('rpuk_lester:unregisterCrate')
RegisterNetEvent('rpuk_lester:userBusy')
RegisterNetEvent('rpuk_lester:restartPC')
RegisterNetEvent('animHack')

local interactions = {}
local refreshInteractions = false
local activeInteractions = {}
local hacking = false
local gas = false
local lester = 0
local crates = {}
local crateProps = {}
local lesterPC = false

ESX.TriggerServerCallback("rpuk_lester:getLesterStatus", function(status)
	TriggerEvent('rpuk_lester:spawnLester', status)
end)

for k,v in pairs(config.download) do
	table.insert(interactions, {
		text = v.text,
		action = function()
			TaskTurnPedToFaceCoord(PlayerPedId(), v.pos.x, v.pos.y, v.pos.z, 1.0)
			TriggerServerEvent('rpuk_lester:startDownload', k)
		end,
		pos = v.pos,
		displayDist = v.displayDist,
		dist = v.dist,
		canInteractWithCar = false,
		background = false,
		id = k,
		subid = "download"
	})
end

for k,v in pairs(config.upload) do
	table.insert(interactions, {
		text = v.text,
		action = function()
			TaskTurnPedToFaceCoord(PlayerPedId(), v.pos.x, v.pos.y, v.pos.z, 1.0)
			TriggerServerEvent('rpuk_lester:startUpload', k)
		end,
		pos = v.pos,
		displayDist = v.displayDist,
		dist = v.dist,
		canInteractWithCar = false,
		background = false,
		id = k,
		subid = "upload"
	})
end

function getDistance(coords1, coords2)
	return Vdist2(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z)
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


Citizen.CreateThread(function()
	while true do
		Wait(500)
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
		if v.subid == "download" then
			ESX.TriggerServerCallback("rpuk_lester:getInfoWhenJoin", function(timer, isDone, isBeingHacked)
				if timer > 0 then
					interactions[k].text = "You gotta wait ~r~" .. timer .. "~w~ seconds until system is activated"
					interactions[k].action = nil
					interactions[k].dist = 6
				elseif isDone then
					interactions[k].text = config.download[v.id].done
					interactions[k].action = function()
						TriggerServerEvent('rpuk_lester:getUSB', v.id)
						PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
					end
					interactions[k].dist = 6
				elseif isBeingHacked.name ~= nil then
					interactions[k].text = "Download done in ~r~" .. isBeingHacked.timer .. "~w~ seconds"
					interactions[k].dist = 6
					interactions[k].action = nil
				else
					interactions[k].text = config.download[v.id].text
					interactions[k].dist = config.download[v.id].dist
					interactions[k].action = function()
						TriggerServerEvent('rpuk_lester:startDownload', v.id)
					end
				end
			end, v.id)
		elseif v.subid == "upload" then
			ESX.TriggerServerCallback("rpuk_lester:getUploadInfo", function(isBeingUploaded)
				if isBeingUploaded then
					interactions[k].text = "Uploading Software"
					interactions[k].action = nil
					interactions[k].dist = 6
				elseif lester ~= 0 then
					interactions[k].text = "You can not use Lester's computer while he is home!"
					interactions[k].action = nil
					interactions[k].dist = 12
				else
					interactions[k].text = config.upload[v.id].text
					interactions[k].dist = config.upload[v.id].dist
					interactions[k].action = function()
						TriggerServerEvent('rpuk_lester:startUpload')
					end
				end
			end, v.id)
		end
		v = interactions[k]
		TriggerServerEvent('rpuk_lester:addInteracting', v.id)
		while getDistance(coords, v.pos) < v.dist and not refreshInteractions do
			Wait(0)
			ped = PlayerPedId()
			coords = GetEntityCoords(ped)
			if getDistance(coords, v.pos) < v.displayDist and (v.canInteractWithCar or (not v.canInteractWithCar and (not (GetVehiclePedIsIn(ped, false) ~= 0)))) then
				Draw3DText(v.pos.x, v.pos.y, v.pos.z+1.5, v.text, v.background)
				if IsControlJustReleased(0, 38) and v.action ~= nil then
					v.action()
					Wait(500)
				end
			end
		end
		TriggerServerEvent('rpuk_lester:removeInteracting', v.id)
		refreshInteractions = false
		activeInteractions[v.id] = nil
	end)
end

AddEventHandler('animHack', function(vehicle)
	RequestAnimDict("missheist_jewel@hacking")
	while not HasAnimDictLoaded("missheist_jewel@hacking") do
		Citizen.Wait(0)
	end
		Citizen.Wait(1)

		while hacking do
			local anim3 = IsEntityPlayingAnim(PlayerPedId(), "missheist_jewel@hacking", "hack_loop", 3)
			if not anim3 then
				TaskPlayAnim(PlayerPedId(), "missheist_jewel@hacking", "hack_loop", 8.0, -8, -1, 16, 0, 0, 0, 0)
			end
				Citizen.Wait(1)
		end
end)

AddEventHandler("rpuk_lester:download", function()
	TriggerEvent('dooranim')
	TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'inform', text = "You have inserted your Blank USB" })
	PlaySoundFrontend(-1, "Pin_Bad", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", true)
	TriggerEvent("animHack")
	hacking = true
	Citizen.Wait(3000)
	TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = "Download Commencing" })
	Citizen.Wait(3000)
	TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = "Unrecongnised User" })
	Citizen.Wait(3000)
	TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = "Activating Defence Protcol" })
	Citizen.Wait(3000)
	TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = "Protcol Initalised" })
	hacking = false
	-- TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'info', text = "You need to leave the room while the software is downloading due the gas filling the room, your job is to wait until you can collect the USB." })
	-- Citizen.Wait(5000)
	-- TriggerServerEvent("rpuk_lester:gas", true)
	TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "disturbance"})
end)

AddEventHandler('rpuk_lester:initDownloadTimer', function(id)
	for k,v in pairs(interactions) do
		if v.subid == "download" then
			if v.id == id then
				interactions[k].text = "Download done in ~r~" .. config.downloadTime .. "~w~ seconds"
				interactions[k].dist = 12
				interactions[k].action = nil
			else
				interactions[k].text = "System is currently being hacked from a different location"
				interactions[k].action = nil
			end
		end
	end
end)

AddEventHandler('rpuk_lester:updateDownloadTimer', function(time, id)
	for k,v in pairs(interactions) do
		if v.id == id then
			interactions[k].text = "Download done in ~r~" .. time .. "~w~ seconds"
		end
	end
end)

AddEventHandler('rpuk_lester:doneDownloading', function(id)
	for k,v in pairs(interactions) do
		if v.id == id then
			-- TriggerServerEvent("rpuk_lester:gas", false)
			interactions[k].text = config.download[id].done
			interactions[k].action = function()
				TriggerServerEvent('rpuk_lester:getUSB', id)
			end
			interactions[k].dist = 12
		end
	end
end)

AddEventHandler('rpuk_lester:pickedupUSB', function(id)
	for k,v in pairs(interactions) do
		if v.subid == "download" then
			interactions[k].text = "You gotta wait ~r~" .. config.lastDownload .. "~w~ seconds until system is activated"
			interactions[k].dist = 12
			interactions[k].action = nil
		end
	end
end)

AddEventHandler('rpuk_lester:updateCooldownTimer', function(time)
	for k,v in pairs(interactions) do
		if v.subid == "download" then
			interactions[k].text = "You gotta wait ~r~" .. time .. "~w~ seconds until system is activated"
		end
	end
end)

AddEventHandler('rpuk_lester:cooldownDone', function()
	for k,v in pairs(interactions) do
		if v.subid == "download" then
			interactions[k].text = config.download[v.id].text
			interactions[k].dist = config.download[v.id].dist
			interactions[k].action = function()
				TriggerServerEvent('rpuk_lester:startDownload', v.id)
			end
		end
	end
end)

-- AddEventHandler("rpuk_lester:startgas", function(toggle)
--	 Citizen.CreateThread(function()
--		 while true do
--			 Citizen.Wait(500)
--			 if toggle then
--				 local playerloc = GetEntityCoords(PlayerPedId())
--				 local dst1 = GetDistanceBetweenCoords(playerloc, -1053.61, -230.07, 44.02, true)
--				 local dst2 = GetDistanceBetweenCoords(playerloc, -1056.05, -235.92, 44.02, true)
--				 if dst1 <= 5 or dst2 <= 4 then
--					 ApplyDamageToPed(PlayerPedId(), 15, false)
--					 Citizen.Wait(500)
--				 end
--			 end
--		 end
--	 end)
-- end)

-- RegisterNetEvent("rpuk_lester:effectsClient")
-- AddEventHandler("rpuk_lester:effectsClient", function(toggle)
--	 local playerloc = GetEntityCoords(PlayerPedId())
--	 local dst1 = GetDistanceBetweenCoords(playerloc, -1053.61, -230.07, 44.02, true)
--	 local dst2 = GetDistanceBetweenCoords(playerloc, -1056.05, -235.92, 44.02, true)
--	 if toggle then
--		 UseParticleFxAssetNextCall("core")
--		 smoke = StartParticleFxLoopedAtCoord("veh_respray_smoke", -1054.56, -231.38, 45.50, 0.0, 0.0, 0.0, 0.80, 0.0, 0.0, 0.0, 0)
--	 else
--		 StopParticleFxLooped(smoke, 0)
--	 end
-- end)

--Upload
function deleteLester()
	DeletePed(lester)
	lester = 0
end

function spawnLester()
	Citizen.CreateThread(function()
		if lester == 0 then
			for k,v in pairs(config.peds) do
				RequestModel(v.ped)
				while not HasModelLoaded(v.ped) do
					Wait(1)
				end
				lester = CreatePed(0, v.ped, v.pos.x, v.pos.y, v.pos.z, v.pos.h, false, true)
				FreezeEntityPosition(lester, true)
				SetEntityInvincible(lester, true)
				SetPedCanPlayAmbientAnims(lester, true)
				SetBlockingOfNonTemporaryEvents(lester, true)
				SetPedDiesWhenInjured(lester, false)
				SetPedCanRagdollFromPlayerImpact(lester, false)
				SetEntityInvincible(lester, true)
				FreezeEntityPosition(lester, true)
				TaskStartScenarioInPlace(lester, v.anim, 0, true);
			end
		end
	end)
end
spawnLester()

AddEventHandler('rpuk_lester:spawnLester', function(status)
	if status then
		spawnLester()
		lesterPC = true
		for k,v in pairs(interactions) do
			if v.id == "lester" then
				interactions[k].text = "You can not use Lester's computer while he is home!"
				interactions[k].dist = 12
				interactions[k].action = nil
			end
		end
	else
		deleteLester()
		lesterPC = false
		for k,v in pairs(interactions) do
			if v.id == "lester" then
				interactions[k].text = "Press E to use Lesters PC"
				interactions[k].dist = 12
				interactions[k].action = function()
					TriggerServerEvent('rpuk_lester:startUpload')
				end
			end
		end
	end
end)

AddEventHandler('rpuk_lester:userBusy', function()
	for k,v in pairs(interactions) do
		if v.id == "lester" then
				interactions[k].text = "Uploading Software"
				interactions[k].action = nil
				interactions[k].dist = 12
		end
	end
end)

AddEventHandler('rpuk_lester:restartPC', function()
	for k,v in pairs(interactions) do
		if v.id == "lester" then
			interactions[k].text = "Press E to use Lesters PC"
			interactions[k].dist = 12
			interactions[k].action = function()
				TriggerServerEvent('rpuk_lester:startUpload')
			end
		end
	end
end)



AddEventHandler('rpuk_lester:currentlyhacking', function(mycb)
	mycb = true
	TriggerEvent("mhacking:show") --This line is where the hacking even starts
	TriggerEvent("mhacking:start",4,20,mycb1) --This line is the difficulty and tells it to start. First number is how long the blocks will be the second is how much time they have is.
end)

function mycb1(success, timeremaining)
	if success then
		if lesterPC then
			TriggerEvent('mhacking:hide')
			hacking = false
			TriggerServerEvent('rpuk_lester:isDoneUploading')
			return
		end
		TriggerEvent('mhacking:hide')
		TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'success', text = "Welcome Back Lester! You are now logged on" })
		TriggerEvent("rpuk_lester:shipment")
		hacking = false
		TriggerServerEvent('rpuk_lester:isDoneUploading')
	else
		if lesterPC then
			TriggerServerEvent('rpuk_lester:isDoneUploading')
			hacking = false
			TriggerEvent('mhacking:hide')
			TriggerServerEvent("returnItem", "usb")
			return
		end
		TriggerServerEvent('rpuk_lester:isDoneUploading')
		hacking = false
		TriggerEvent('mhacking:hide')
		TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'error', text = "You failed to breach the system" })
		TriggerEvent("rpuk_lester:restartPC")
		TriggerServerEvent("returnItem", "usb")
		if math.random(100) > 40 then
			local fire = StartScriptFire(1276.10, -1709.89, 55.0, 25, true)
			AddExplosion(1276.10, -1709.89, 55.0,"EXPLOSION_GRENADE",false, true, false)
			TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'inform', text = "The PC has overheated" })
			Citizen.Wait(18000)
			RemoveScriptFire(fire)
		end
	end
end

AddEventHandler("rpuk_lester:upload", function()
	TriggerEvent('dooranim')
	TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'error', text = "The account is locked!" })
	PlaySoundFrontend(-1, "Pin_Bad", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", true)
	Citizen.Wait(2000)
	TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'error', text = "You need to bypass the password of the account" })
	Citizen.Wait(3000)
	TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'error', text = "You need to plug in the USB to bypass the password" })
	Citizen.Wait(2000)
	TriggerEvent('dooranim')
	TriggerEvent("animHack")
	hacking = true
	TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'inform', text = "USB Inserted - Initiated Bypassing Protocol" })
	PlaySoundFrontend(-1, "Pin_Good", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", true)
	Citizen.Wait(3000)
	TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'inform', text = "Uploading Software" })
	Citizen.Wait(2000)
	TriggerEvent('rpuk_lester:currentlyhacking')
	PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
end)

AddEventHandler('rpuk_lester:shipment', function()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), "rpuk_lester",
		{
			css = "cocaine_doctor_contact",
			align = "top-left",
			elements = {
				{
					label = "Download 'LC69' Software",
					value = "large"
				},
			}
		}, function(data, menu)
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('rpuk_lester:buyCrate', data.current.value)
			TriggerEvent("rpuk_lester:restartPC")
		end, function(data, menu)
			menu.close()
			TriggerEvent("rpuk_lester:restartPC")
		end
	)
end)

AddEventHandler('rpuk_lester:closeAllMenues', function()
	ESX.UI.Menu.CloseAll()
end)