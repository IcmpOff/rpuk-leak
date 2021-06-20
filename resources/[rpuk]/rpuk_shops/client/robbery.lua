local interactions = {}
local activeInteractions = {}
local blips = {}

RegisterNetEvent("rpuk_storeRobbery:startSafe")
RegisterNetEvent("rpuk_storeRobbery:repairSafe")
RegisterNetEvent("rpuk_storeRobbery:updateInteraction")
RegisterNetEvent("rpuk_storeRobbery:safeIsReadyToOpen")
RegisterNetEvent("rpuk_storeRobbery:restartSafe")
RegisterNetEvent("rpuk_storeRobbery:removeBlip")
RegisterNetEvent("rpuk_storeRobbery:addBlip")

function getDistance(coords1, coords2)
	return Vdist2(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z)
end

function Draw3DText(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.02+ factor, 0.03, 110, 110, 110, 75)
end

function addBlip(id)
	local data = interactions[id]
	local blip = AddBlipForCoord(data.pos.x, data.pos.y, data.pos.z)
	SetBlipAsFriendly(blip, true)
	SetBlipSprite(blip, 161)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(tostring("Shop Robbery"))
	EndTextCommandSetBlipName(blip)
	blips[id] = blip
end

local function blipOff(id)
	RemoveBlip(blips[id])
	blips[id] = nil
end

function crouch()
	local ped = PlayerPedId()
	RequestAnimSet("move_ped_crouched")
	while not HasAnimSetLoaded("move_ped_crouched") do
		Citizen.Wait(0)
	end
	SetPedMovementClipset(ped, "move_ped_crouched",1.0)
	SetPedWeaponMovementClipset(ped, "move_ped_crouched",1.0)
	SetPedStrafeClipset(ped, "move_ped_crouched_strafing",1.0)
end

function clearAnim()
	local ped = PlayerPedId()
	ResetPedMovementClipset(ped, 0.0)
	ResetPedWeaponMovementClipset(ped)
	ResetPedStrafeClipset(ped)
end

function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function activateInteraction(id)
  Citizen.CreateThread(function()
	local v = nil
	activeInteractions[id] = true
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		v = interactions[id]
		if v == nil then
			break
		end
		if getDistance(coords, v.pos) < v.dist then
			Draw3DText(v.pos.x, v.pos.y, v.pos.z+1.5, v.text)
			if IsControlJustReleased(0, 38) and v.action ~= nil then
				v.action()
				Wait(0)
			end
		else
			break
		end
	end
	activeInteractions[id] = nil
	end)
end

Citizen.CreateThread(function()
	while true do
		Wait(500)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(interactions) do
			if getDistance(coords, v.pos) < v.dist and activeInteractions[k] == nil then
				activateInteraction(k)
			end
		end
	end
end)

for k,v in pairs(Config.robbery) do
	interactions["safe:" .. k] = {
		id = k,
		pos = v.safe,
		text = "Press E to interact with safe",
		dist = 8,
		action = function()
			TriggerServerEvent("rpuk_storeRobbery:startCrack:safe",  "safe:" .. k) --Inside this function gets ran when you press E
		end
	}
end

AddEventHandler("rpuk_storeRobbery:restartSafe", function(id)
	blipOff(id)
	local v = Config.robbery[tonumber(split(id, ":")[2])]
	interactions[id] = {
		text = "Press E to interact with safe",
		pos = v.safe,
		dist = 8,
		action = function()
			TriggerServerEvent("rpuk_storeRobbery:startCrack:safe", id) --Inside this function gets ran when you press E
		end
	}
end)

AddEventHandler("rpuk_storeRobbery:repairSafe", function(id)
	local v = Config.robbery[tonumber(split(id, ":")[2])]
	if ESX.Player.GetJobName() == "police" then
		interactions[id] = {
			text = "Press E to repair safe",
			pos = v.safe,
			dist = 8,
			action = function()
				TriggerServerEvent("rpuk_storeRobbery:repairSafeSV", id)
			end
		}
	end
end)

AddEventHandler("rpuk_storeRobbery:removeBlip", function(id)
	blipOff(id)
end)

AddEventHandler("rpuk_storeRobbery:addBlip", function(id)
	if ESX.Player.GetJobName() == "police" or ESX.Player.GetJobName() == "ambulance" then
		addBlip(id)
	end
end)

AddEventHandler("rpuk_storeRobbery:startSafe", function(id)
	TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "shop"})

	local safe = exports['rpuk_shops']:createSafe({math.random(0,99),math.random(0,99),math.random(0,99),math.random(0,99)}, "mini@safe_cracking", "idle_base")

	if safe then
		local rewardTime = math.random(Config.minTimeforSafe, Config.maxTimeforSafe)
		TriggerServerEvent("rpuk_storeRobbery:startCrackTimer:safe", id, rewardTime, function()
		end)
	else
		TriggerServerEvent("rpuk_storeRobbery:restartSafeSV", id)
	end
end)

AddEventHandler("rpuk_storeRobbery:updateInteraction", function(id, key, val, params)
	if params ~= nil then
		if params.exclude ~= nil then
			for k,v in pairs(params.exclude) do
				if v == ESX.Player.GetJobName() then
					return
				end
			end
		end
		if params.include ~= nil then
			local isIncluded = false
			for k,v in pairs(params.include) do
				if v == ESX.Player.GetJobName() then
					isIncluded = true
				end
			end
			if not isIncluded then
				return
			end
		end
	end
	if interactions[id] then
		interactions[id][key] = val
	end
end)

AddEventHandler("rpuk_storeRobbery:safeIsReadyToOpen", function(id)
	local v = Config.robbery[tonumber(split(id, ":")[2])]
	interactions[id] = {
	text = "Press E to collect money",
	pos = v.safe,
	dist = 8,
	action = function()
		TriggerServerEvent("rpuk_storeRobbery:collectInteraction", id)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "reward",
			duration = 30000,
			label = "Searching for money",
			useWhileDead = false,
			canCancel = false,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
				animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
				anim = "machinic_loop_mechandplayer",
				flags = 49,
				task = nil,
			},
		},function(status)
			if not status then
				TriggerServerEvent('rpuk_storeRobbery:collectMoney', id, GetEntityCoords(PlayerPedId()), v.safe)
			end
		end)
	end
	}
end)