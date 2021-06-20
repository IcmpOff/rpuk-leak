local zoneNames = {AIRP = "Los Santos International Airport",ALAMO = "Alamo Sea",ALTA = "Alta",ARMYB = "Fort Zancudo",BANHAMC = "Banham Canyon Dr",BANNING = "Banning",BAYTRE = "Baytree Canyon", BEACH = "Vespucci Beach",BHAMCA = "Banham Canyon",BRADP = "Braddock Pass",BRADT = "Braddock Tunnel",BURTON = "Burton",CALAFB = "Calafia Bridge",CANNY = "Raton Canyon",CCREAK = "Cassidy Creek",CHAMH = "Chamberlain Hills",CHIL = "Vinewood Hills",CHU = "Chumash",CMSW = "Chiliad Mountain State Wilderness",CYPRE = "Cypress Flats",DAVIS = "Davis",DELBE = "Del Perro Beach",DELPE = "Del Perro",DELSOL = "La Puerta",DESRT = "Grand Senora Desert",DOWNT = "Downtown",DTVINE = "Downtown Vinewood",EAST_V = "East Vinewood",EBURO = "El Burro Heights",ELGORL = "El Gordo Lighthouse",ELYSIAN = "Elysian Island",GALFISH = "Galilee",GALLI = "Galileo Park",golf = "GWC and Golfing Society",GRAPES = "Grapeseed",GREATC = "Great Chaparral",HARMO = "Harmony",HAWICK = "Hawick",HORS = "Vinewood Racetrack",HUMLAB = "Humane Labs and Research",JAIL = "Bolingbroke Penitentiary",KOREAT = "Little Seoul",LACT = "Land Act Reservoir",LAGO = "Lago Zancudo",LDAM = "Land Act Dam",LEGSQU = "Legion Square",LMESA = "La Mesa",LOSPUER = "La Puerta",MIRR = "Mirror Park",MORN = "Morningwood",MOVIE = "Richards Majestic",MTCHIL = "Mount Chiliad",MTGORDO = "Mount Gordo",MTJOSE = "Mount Josiah",MURRI = "Murrieta Heights",NCHU = "North Chumash",NOOSE = "N.O.O.S.E",OCEANA = "Pacific Ocean",PALCOV = "Paleto Cove",PALETO = "Paleto Bay",PALFOR = "Paleto Forest",PALHIGH = "Palomino Highlands",PALMPOW = "Palmer-Taylor Power Station",PBLUFF = "Pacific Bluffs",PBOX = "Pillbox Hill",PROCOB = "Procopio Beach",RANCHO = "Rancho",RGLEN = "Richman Glen",RICHM = "Richman",ROCKF = "Rockford Hills",RTRAK = "Redwood Lights Track",SanAnd = "San Andreas",SANCHIA = "San Chianski Mountain Range",SANDY = "Sandy Shores",SKID = "Mission Row",SLAB = "Stab City",STAD = "Maze Bank Arena",STRAW = "Strawberry",TATAMO = "Tataviam Mountains",TERMINA = "Terminal",TEXTI = "Textile City",TONGVAH = "Tongva Hills",TONGVAV = "Tongva Valley",VCANA = "Vespucci Canals",VESP = "Vespucci",VINE = "Vinewood",WINDF = "Ron Alternates Wind Farm",WVINE = "West Vinewood",ZANCUDO = "Zancudo River",ZP_ORT = "Port of South Los Santos",ZQ_UAR = "Davis Quartz"}
local lastNotifGPS = nil
local historyOpen = false
local radioActive = true

function GetTheStreet(coords)
	local x, y, z = table.unpack(coords)
	local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
	local currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
	local intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
	local zone = tostring(GetNameOfZone(x, y, z))
	local playerStreetsLocation

	if not zone then
		zone = "UNKNOWN"
		zoneNames['UNKNOWN'] = zone
	elseif not zoneNames[tostring(zone)] then
		zoneNames[tostring(zone)] = "Undefined Zone"
	end

	if intersectStreetName ~= nil and intersectStreetName ~= "" then
		playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | " .. zoneNames[tostring(zone)]
	elseif currentStreetName ~= nil and currentStreetName ~= "" then
		playerStreetsLocation = currentStreetName .. " | " .. zoneNames[tostring(zone)]
	else
		playerStreetsLocation = zoneNames[tostring(zone)]
	end

	return playerStreetsLocation
end

RegisterCommand("dispatch", function(source, args)
	radioActive = not radioActive
	if not radioActive then
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You will no longer get any incoming alerts from dispatch!' })
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'You will now get alerts from dispatch!' })
	end
end)

RegisterNetEvent('rpuk_alerts:RecieveAlert') --Recieve Alert
AddEventHandler('rpuk_alerts:RecieveAlert', function(type, data, length, jobs)
	for _, jdata in pairs (jobs) do
		if radioActive and ESX.Player.GetJobName() == jdata then
			lastNotifGPS = data["coords"]
			data["loc"] = GetTheStreet(data["coords"])
			SendNUIMessage({action = 'display', style = type, info = data, length = length})
			PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
		end
	end
end)

RegisterNUICallback("gps", function(data)
	historyOpen = false
	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
	SetNewWaypoint(data.x, data.y)
end)

RegisterNUICallback("exit", function(data)
	historyOpen = false
	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
end)

function getStatus() return historyOpen end

RegisterKeyMapping('rpuk_alerts_history', 'Alerts History', 'keyboard', 'o')
RegisterCommand('rpuk_alerts_history', function(source)
	local phoneUI = exports["gcphone"]:getStatus()
	if not phoneUI then
		if lastNotifGPS ~= nil then
			if not historyOpen then
				historyOpen = true
				SetNuiFocus(true, true)
				SetNuiFocusKeepInput(true)
				SendNUIMessage({action = 'historyOpen'})
			else
				historyOpen = false
				SetNuiFocus(false, false)
				SetNuiFocusKeepInput(false)
				SendNUIMessage({action = 'historyClose'})
			end
		end
	end
end)

RegisterKeyMapping('rpuk_alerts_gps', 'Alerts GPS', 'keyboard', 'i')
RegisterCommand('rpuk_alerts_gps', function(source)
	if lastNotifGPS ~= nil then
		SetNewWaypoint(lastNotifGPS.x, lastNotifGPS.y)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if historyOpen then
			DisableAllControlActions(0)
		else
			Citizen.Wait(500)
		end
	end
end)