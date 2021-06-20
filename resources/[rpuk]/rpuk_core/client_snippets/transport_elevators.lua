local inMenu = false

local access_points = {
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "police_vesp1", job = {"police", "ambulance"}, location = vector3(-1098.061, -849.675, 5.233), dist = 2, sizeOfText = 0.5},
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "police_vesp1", job = {"police", "ambulance"}, location = vector3(-1098.061, -849.675, 10.672), dist = 2, sizeOfText = 0.5},
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "police_vesp1", job = {"police", "ambulance"}, location = vector3(-1098.061, -849.675, 14.024), dist = 2, sizeOfText = 0.5},
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "police_vesp1", job = {"police", "ambulance"}, location = vector3(-1098.061, -849.675, 19.326), dist = 2, sizeOfText = 0.5},
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "police_vesp1", job = {"police", "ambulance"}, location = vector3(-1098.061, -849.675, 23.383), dist = 2, sizeOfText = 0.5},
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "police_vesp1", job = {"police", "ambulance"}, location = vector3(-1098.061, -849.675, 27.208), dist = 2, sizeOfText = 0.5},
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "police_vesp1", job = {"police", "ambulance"}, location = vector3(-1098.061, -849.675, 31.105), dist = 2, sizeOfText = 0.5},
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "police_vesp1", job = {"police", "ambulance"}, location = vector3(-1098.061, -849.675, 34.736), dist = 2, sizeOfText = 0.5},
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "police_vesp1", job = {"police", "ambulance"}, location = vector3(-1098.061, -849.675, 38.609), dist = 2, sizeOfText = 0.5},
	{prompt = "Admin To Vespucci Police\nPress [~b~E~s~] To Access Elevator", pool = "police_vesp1", location = vector3(116.354, -639.512, 206.366), dist = 2, sizeOfText = 0.5}, -- admin

	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_pillbox1", location = vector3(331.965, -597.182, 43.619), dist = 2, sizeOfText = 0.5}, -- Main Floor
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_pillbox1", location = vector3(329.971, -602.658, 43.619), dist = 2, sizeOfText = 0.5}, -- Main Floor
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_pillbox1", location = vector3(325.628, -603.433, 43.619), dist = 2, sizeOfText = 0.5}, -- Main Floor
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_pillbox1", location = vector3(338.274, -583.719, 74.463), dist = 2, sizeOfText = 0.5}, -- helipad
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_pillbox1", location = vector3(344.721, -584.740, 29.152), dist = 2, sizeOfText = 0.5}, -- lower 1
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_pillbox1", location = vector3(346.078, -581.011, 29.104), dist = 2, sizeOfText = 0.5}, -- lower 2
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_pillbox1", location = vector3(339.725, -586.226, 29.139), dist = 2, sizeOfText = 0.5}, -- lower 3
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_pillbox1", location = vector3(341.066, -582.537, 29.145), dist = 2, sizeOfText = 0.5}, -- lower 4
	{prompt = "Admin To Pillbox Hospital\nPress [~b~E~s~] To Access Elevator", pool = "public_pillbox1", location = vector3(117.380, -636.692, 206.366), dist = 2, sizeOfText = 0.5}, -- admin

	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_humane", location = vector3(3541.915, 3673.860, 21.092), dist = 2, sizeOfText = 0.5}, -- Upper
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_humane", location = vector3(3541.915, 3673.860, 28.228), dist = 2, sizeOfText = 0.5}, -- Lower

	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_humane", location = vector3(3541.915, 3673.860, 21.092), dist = 2, sizeOfText = 0.5}, -- Upper
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_humane", location = vector3(3541.915, 3673.860, 28.228), dist = 2, sizeOfText = 0.5}, -- Lower

	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_fibbuilding", location = vector3(106.46172332764, -638.63885498047, 31.632551193237), dist = 2, sizeOfText = 0.5}, -- groundFloor
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_fibbuilding", location = vector3(139.410, -764.427, 45.911), dist = 2, sizeOfText = 0.5}, -- Lower
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_fibbuilding", location = vector3(136.636, -763.417, 242.294), dist = 2, sizeOfText = 0.5}, -- iopc
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "public_fibbuilding", location = vector3(156.986, -756.959, 258.451), dist = 2, sizeOfText = 0.5}, -- council top

	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "rm_office", location = vector3(-1365.1018066406, -470.12191772461, 32.131816864014), dist = 2, sizeOfText = 0.5}, -- RM Office Car Park
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "rm_office", location = vector3(-1369.8299560547, -472.22940063477, 84.92463684082), dist = 2, sizeOfText = 0.5}, -- RM Office Roof
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "rm_office", location = vector3(-1394.9742431641, -481.12286376953, 72.241989135742), dist = 2, sizeOfText = 0.5}, -- RM Office 

	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "g6_office", location = vector3(21.17197227478, -903.10894775391, 30.164484024048), dist = 2, sizeOfText = 0.5}, -- Gruppe6 office
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "g6_office", location = vector3(-0.75470542907715, -702.50799560547, 16.587804794312), dist = 2, sizeOfText = 0.5}, -- Gruppe6 Vault
	{prompt = "Press [~b~E~s~] To Access Elevator", pool = "g6_office", location = vector3(21.209489822388, -903.13525390625, 33.592067718506), dist = 2, sizeOfText = 0.5}, -- Gruppe6 Armoury
}

local elevators = {
	["police_vesp1"] = {
		{label = "[6] Helipad | Roof", location = vector3(-1096.271, -850.282, 37.307), vehicle = false},
		{label = "[5] National Crime", location = vector3(-1096.271, -850.282, 33.361), vehicle = false},
		{label = "[4] Operations | Command", location = vector3(-1096.271, -850.282, 29.757)},
		{label = "[3] Gym | Division Offices | Briefing", location = vector3(-1096.271, -850.282, 25.828), vehicle = false},
		{label = "[2] Cafe | Department Offices", location = vector3(-1096.271, -850.282, 22.039), vehicle = false},
		{label = "[1] Lobby | Interviews | Conference", location = vector3(-1096.271, -850.282, 18.001), vehicle = false},
		{label = "[-3] Armory | Lockeroom | Garage 1", location = vector3(-1096.271, -850.282, 12.687), vehicle = false},
		{label = "[-2] Crime Lab | Evidence", location = vector3(-1096.271, -850.282, 9.277), vehicle = false},
		{label = "[-1] Detention | ID & Interrogation | Garage 2", location = vector3(-1096.271, -850.282, 3.884), vehicle = false},
	},
	["public_pillbox1"] = {
		{label = "[3] Helipad | Roof", location = vector3(339.256, -584.066, 73.164), vehicle = false},
		{label = "[2] Main Hospital", location = vector3(329.227, -597.939, 42.284), vehicle = false},
		{label = "[1] Lower Pillbox | Garage | A&E Intake", location = vector3(345.894, -584.686, 27.797), vehicle = false},
	},
	["public_humane"] = {
		{label = "[0] Main Operations Floor", location = vector3(3540.619, 3675.610, 27.121), vehicle = false},
		{label = "[-1] Lower Maintenance Floor", location = vector3(3540.619, 3675.610, 19.992), vehicle = false},
	},
	["public_fibbuilding"] = {
		{label = "[-1] Parking Floor", location = vector3(106.46172332764, -638.63885498047, 31.632551193237), vehicle = false},
		{label = "[0] Ground Floor", location = vector3(139.03, -762.65, 45.75), vehicle = false},
		{label = "[49] IOPC", location = vector3(136.10, -761.71, 242.15), vehicle = false},
		{label = "[53] Council & Private Meetings", location = vector3(154.94, -757.77, 258.15), vehicle = false},
	},
	["rm_office"] = {
		{label = "[24] Roof", location = vector3(-1369.1324462891, -471.53942871094, 83.446937561035), vehicle = false},
		{label = "[20] Office", location = vector3(-1395.8461914062, -481.21551513672, 71.042144775391), vehicle = false},
		{label = "[-1] Car Park", location = vector3(-1364.8468017578, -472.50140380859, 30.595788955688), vehicle = false},
	},
	["g6_office"] = {
		{label = "[2] Armoury", location = vector3(21.736423492432, -902.30206298828, 32.436225891113)},
		{label = "[1] Office", location = vector3(22.087766647339, -902.40411376953, 28.981962203979)},
		{label = "[-5] Vault", location = vector3(1.1360368728638, -702.58941650391, 15.131031036377)},
	},
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local canSleep = true
		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(access_points) do
			if #(coords - v.location) < v.dist then
				if v.job == nil or isInList(ESX.Player.GetJobName(), v.job) then
					canSleep = false
					ESX.Game.Utils.DrawText3D(v.location, v.prompt, v.sizeOfText, 6)
					if IsControlJustReleased(0, 38) then
						elevator(v.pool)
					end
				end
			end
		end

		if canSleep then
			Citizen.Wait(1000)
		end
	end
end)

function isInList(val, list)
	for k,v in pairs(list) do
		if val == v then
			return true
		end
	end
	return false
end

function elevator(pool)
	inMenu = true
	local elements = {}

	for k, v in pairs(elevators[pool]) do
		table.insert(elements, {label = v.label, value = "transport", location = {x = v.location.x, y = v.location.y, z = v.location.z}, vehicle = v.vehicle})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'elevator_menu', {
		title    = '',
		css 	 =  "elevator",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == "transport" then
			local ped = PlayerPedId()
			DoScreenFadeOut(1000)
			Citizen.Wait(1000)
			if data.current.vehicle then
				if IsPedInAnyVehicle(ped, 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(ped, 0), -1) == ped) then
					SetEntityCoords(GetVehiclePedIsIn(ped, 0), data.current.location.x, data.current.location.y, data.current.location.z)
				else
					SetEntityCoords(ped, data.current.location.x, data.current.location.y, data.current.location.z)
				end
			else
				SetEntityCoords(ped, data.current.location.x, data.current.location.y, data.current.location.z)
			end
			DoScreenFadeIn(750)
			ESX.UI.Menu.CloseAll()
		end
	end, function(data, menu)
		menu.close()
		inMenu = false
	end)
end