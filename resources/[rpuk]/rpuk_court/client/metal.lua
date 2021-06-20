function GetCoordZ(x, y, initial)
	local groundCheckHeights = {initial+0, initial+1, initial+2, initial+3, initial+4, initial+5, initial+6, initial+7, initial+8, initial+9, initial+10}
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end
	return initial
end


-- RegisterCommand('metal', function(source, args, rawCommand)
-- 	local ped = PlayerPedId()
-- 	local coords = GetEntityCoords(PlayerPedId(), true);
-- 	obj = CreateObject(GetHashKey("ch_prop_ch_metal_detector_01a"), coords.x, coords.y, GetCoordZ(coords.x, coords.y,coords.z), true, true, true)
-- 	RequestModel("ch_prop_ch_metal_detector_01a")
-- 	while not HasModelLoaded("ch_prop_ch_metal_detector_01a") do
-- 		Citizen.Wait(0)
-- 	end
-- 	SetEntityHeading(obj, GetEntityHeading(ped))
-- 	local networkId = ObjToNet(obj)
-- 	SetNetworkIdExistsOnAllMachines(networkId, true)
-- 	SetNetworkIdCanMigrate(networkId, false)
-- 	NetworkSetNetworkIdDynamic(networkId, true)
-- 	trackedID = networkId
-- 	TriggerServerEvent("rpuk_court:SyncMetalDetector", GetEntityCoords(obj, true), trackedID, false)
-- end)

metalDetectors = {
	Court_1 = {
		Location = BoxZone:Create(vector3(-577.36, -201.72, 38.22), 1.0, 1.4, {
			heading=300,
			-- debugPoly=true,
			minZ=35.42,
			maxZ=39.42
		}),
		Online = true,
		Restriction = {"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_SMG", "WEAPON_VINTAGEPISTOL", "WEAPON_PISTOL50","WEAPON_COMBATPDW", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE","WEAPON_MICROSMG", "WEAPON_DOUBLEACTION", "WEAPON_MACHINEPISTOL", "WEAPON_COMPACTRIFLE", "weapon_knife", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_POOLCUE", "WEAPON_GOLFCLUB", "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_DAGGER", "WEAPON_KNUCKLE", "WEAPON_KNIFE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_WRENCH"},
		Access = {"gruppe6"}
	},
	Court_2 = {
		Location = BoxZone:Create(vector3(-580.15, -203.45, 38.22), 1.0, 1.4, {
			heading=120,
			-- debugPoly=true,
			minZ=35.42,
			maxZ=39.42
		}),
		Online = true,
		Restriction = {"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_SMG", "WEAPON_VINTAGEPISTOL", "WEAPON_PISTOL50","WEAPON_COMBATPDW", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE","WEAPON_MICROSMG", "WEAPON_DOUBLEACTION", "WEAPON_MACHINEPISTOL", "WEAPON_COMPACTRIFLE", "weapon_knife", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_POOLCUE", "WEAPON_GOLFCLUB", "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_DAGGER", "WEAPON_KNUCKLE", "WEAPON_KNIFE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_WRENCH"},
		Access = {"gruppe6"}
	},
	Court_3 = {
		Location = BoxZone:Create(vector3(-550.34, -196.3, 38.22), 1.0, 1.4, {
			heading=300,
			-- debugPoly=true,
			minZ=35.42,
			maxZ=39.42
		}),
		Online = true,
		Restriction = {"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_SMG", "WEAPON_VINTAGEPISTOL", "WEAPON_PISTOL50","WEAPON_COMBATPDW", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE","WEAPON_MICROSMG", "WEAPON_DOUBLEACTION", "WEAPON_MACHINEPISTOL", "WEAPON_COMPACTRIFLE", "weapon_knife", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_POOLCUE", "WEAPON_GOLFCLUB", "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_DAGGER", "WEAPON_KNUCKLE", "WEAPON_KNIFE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_WRENCH"},
		Access = {"gruppe6"}
	},
	Court_4 = {
		Location = BoxZone:Create(vector3(-549.23, -195.63, 38.22), 1.0, 1.4, {
			heading=300,
			-- debugPoly=true,
			minZ=35.42,
			maxZ=39.42
		}),
		Online = true,
		Restriction = {"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_SMG", "WEAPON_VINTAGEPISTOL", "WEAPON_PISTOL50","WEAPON_COMBATPDW", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE","WEAPON_MICROSMG", "WEAPON_DOUBLEACTION", "WEAPON_MACHINEPISTOL", "WEAPON_COMPACTRIFLE", "weapon_knife", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_POOLCUE", "WEAPON_GOLFCLUB", "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_DAGGER", "WEAPON_KNUCKLE", "WEAPON_KNIFE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_WRENCH"},
		Access = {"gruppe6"}
	},
	Court_5 = {
		Location = BoxZone:Create(vector3(-530.77, -176.1, 38.22), 1.0, 1.4, {
			heading=300,
			-- debugPoly=true,
			minZ=35.42,
			maxZ=39.42
		}),
		Online = true,
		Restriction = {"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_SMG", "WEAPON_VINTAGEPISTOL", "WEAPON_PISTOL50","WEAPON_COMBATPDW", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE","WEAPON_MICROSMG", "WEAPON_DOUBLEACTION", "WEAPON_MACHINEPISTOL", "WEAPON_COMPACTRIFLE", "weapon_knife", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_POOLCUE", "WEAPON_GOLFCLUB", "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_DAGGER", "WEAPON_KNUCKLE", "WEAPON_KNIFE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_WRENCH"},
		Access = {"gruppe6"}
	},
	Court_6 = {
		Location = BoxZone:Create(vector3(-527.43, -174.11, 38.22), 1, 1.4, {
			heading=300,
			-- debugPoly=true,
			minZ=35.42,
			maxZ=39.42
		}),
		Online = true,
		Restriction = {"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_SMG", "WEAPON_VINTAGEPISTOL", "WEAPON_PISTOL50","WEAPON_COMBATPDW", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE","WEAPON_MICROSMG", "WEAPON_DOUBLEACTION", "WEAPON_MACHINEPISTOL", "WEAPON_COMPACTRIFLE", "weapon_knife", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_POOLCUE", "WEAPON_GOLFCLUB", "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_DAGGER", "WEAPON_KNUCKLE", "WEAPON_KNIFE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_WRENCH"},
		Access = {"gruppe6"}
	},
	Court_7 = {
		Location = BoxZone:Create(vector3(-511.83, -209.93, 38.22), 1, 1.4, {
			heading=30,
			--debugPoly=true,
			minZ=35.42,
			maxZ=39.42
		}),
		Online = true,
		Restriction = {"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_SMG", "WEAPON_VINTAGEPISTOL", "WEAPON_PISTOL50","WEAPON_COMBATPDW", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE","WEAPON_MICROSMG", "WEAPON_DOUBLEACTION", "WEAPON_MACHINEPISTOL", "WEAPON_COMPACTRIFLE", "weapon_knife", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_POOLCUE", "WEAPON_GOLFCLUB", "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_DAGGER", "WEAPON_KNUCKLE", "WEAPON_KNIFE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_WRENCH"},
		Access = {"gruppe6"}
	},
	Court_8 = {
		Location = BoxZone:Create(vector3(-512.62, -208.95, 38.22), 1.0, 1.4, {
			heading=30,
			--debugPoly=true,
			minZ=35.42,
			maxZ=39.42
		}),
		Online = true,
		Restriction = {"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_SMG", "WEAPON_VINTAGEPISTOL", "WEAPON_PISTOL50","WEAPON_COMBATPDW", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE","WEAPON_MICROSMG", "WEAPON_DOUBLEACTION", "WEAPON_MACHINEPISTOL", "WEAPON_COMPACTRIFLE", "weapon_knife", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_POOLCUE", "WEAPON_GOLFCLUB", "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_DAGGER", "WEAPON_KNUCKLE", "WEAPON_KNIFE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_WRENCH"},
		Access = {"gruppe6"}
	},
	Prison_1 = {
		Location = BoxZone:Create(vector3(1801.04, 2592.47, 45.8), 1, 1.4, {
			heading=0,
			--debugPoly=true,
			minZ=43.0,
			maxZ=47.0
		}),
		Online = true,
		Restriction = {"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_SMG", "WEAPON_VINTAGEPISTOL", "WEAPON_PISTOL50","WEAPON_COMBATPDW", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE","WEAPON_MICROSMG", "WEAPON_DOUBLEACTION", "WEAPON_MACHINEPISTOL", "WEAPON_COMPACTRIFLE", "weapon_knife", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_POOLCUE", "WEAPON_GOLFCLUB", "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_DAGGER", "WEAPON_KNUCKLE", "WEAPON_KNIFE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_WRENCH"},
		Access = {"gruppe6", "police"}
	},
	Prison_2 = {
		Location = BoxZone:Create(vector3(1801.03, 2595.7, 45.8), 1, 1.4, {
			heading=0,
			--debugPoly=true,
			minZ=43.0,
			maxZ=47.0
		}),
		Online = true,
		Restriction = {"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_SMG", "WEAPON_VINTAGEPISTOL", "WEAPON_PISTOL50","WEAPON_COMBATPDW", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE","WEAPON_MICROSMG", "WEAPON_DOUBLEACTION", "WEAPON_MACHINEPISTOL", "WEAPON_COMPACTRIFLE", "weapon_knife", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_POOLCUE", "WEAPON_GOLFCLUB", "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_DAGGER", "WEAPON_KNUCKLE", "WEAPON_KNIFE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_WRENCH"},
		Access = {"gruppe6", "police"}
	},
	Fight_Club_1 = {
		Location = BoxZone:Create(vector3(927.32, -1802.87, 24.97), 1, 1.4, {
			heading=85,
			--debugPoly=true,
			minZ=22.17,
			maxZ=26.17
		}),
		Online = true,
		Restriction = {"WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_SMG", "WEAPON_VINTAGEPISTOL", "WEAPON_PISTOL50","WEAPON_COMBATPDW", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE","WEAPON_MICROSMG", "WEAPON_DOUBLEACTION", "WEAPON_MACHINEPISTOL", "WEAPON_COMPACTRIFLE", "weapon_knife", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_POOLCUE", "WEAPON_GOLFCLUB", "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_DAGGER", "WEAPON_KNUCKLE", "WEAPON_KNIFE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_WRENCH"},
		Access = {"lost"}
	},
}



Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		for k, v in pairs(metalDetectors) do
			if v.Location:isPointInside(pedCoords) then
				metalDetector(k)
			end
		end
		Citizen.Wait(100)
	end
end)


function metalDetector(id)
	for key, val in pairs(metalDetectors) do
		if key == id then
			if val.Online then
				if checkForWeapon(val.Restriction) then
					if 100 * math.random() < 80 then
						TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 15, "metal", 0.4)
					else
						TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 15, "wii", 0.4)
					end
					Citizen.Wait(5000)
				else
					TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 15, "wii", 0.4)
					Citizen.Wait(5000)
				end
			else
				Citizen.Wait(5000)
			end
		end
	end
end

RegisterNetEvent("rpuk_courts:changeStatus")
AddEventHandler("rpuk_courts:changeStatus", function(status)
	local UID = checkZoneDetector()
	if UID then
		if not status then
			TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'You have turnt off the metal detector!' })
		else
			TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'You have turnt on the metal detector!' })
		end
		TriggerServerEvent("rpuk_courts:svSync", UID, status)
	end
end)

RegisterNetEvent("rpuk_courts:MDSync")
AddEventHandler("rpuk_courts:MDSync", function(UID, status)
	metalDetectors[UID].Online = status
end)


function checkForWeapon(data)
	local ped = PlayerPedId()
	for _, weapon in pairs(data) do
		if HasPedGotWeapon(ped, weapon, false) then
			return true
		end
	end
end

function checkZoneDetector()
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	for k, v in pairs(metalDetectors) do
		if v.Location:isPointInside(pedCoords) and isInList(ESX.Player.GetJobName(), v.Access) then
			return k
		end
	end
end

function checkZoneDetectorPerms()
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	for k, v in pairs(metalDetectors) do
		if v.Location:isPointInside(pedCoords) and isInList(ESX.Player.GetJobName(), v.Access) then
			return true
		end
	end
end

function checkZoneDetectorStatus()
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	for _, v in pairs(metalDetectors) do
		if v.Location:isPointInside(pedCoords) then
			return v.Online
		end
	end
end

function isInList(val, list)
	if list == nil then
		return true
	end
	for k,v in pairs(list) do
		if val == v then
			return true
		end
	end
	return false
end

