VehicleList = {}


VehicleList.AssignedVehicles = { -- police_data police_data lost_data civ_job
	["police"] = {
		{
			model = "rpPolice1",
			type = "car",
			label = "Interceptor", -- a label (A distinctive label) will be concatonated to the model eg: Audi A4 (Traffic)
			vehicleName = "Volvo V90",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["driving"] = 3}}, -- the required flag and required flag level needed to access the vehicle
			default_mods = { -- the mods it will come with when spawned in
				modLivery = 1,
				modTurbo = 1,
				modTransmission = 2,
				modBrakes = 1,
				dirtLevel = 0,
				--windowTint = 1,
				--modArmor = 1,
				--modSuspension = 1,
				--modEngineBlock = 1,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice4",
			type = "car",
			label = "Interceptor",
			vehicleName = "Audi A4",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["driving"] = 3}},
			default_mods = {
				modLivery = 1,
				modTurbo = 1,
				modTransmission = 1,
				modBrakes = 1,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice7",
			type = "car",
			label = "Interceptor",
			vehicleName = "BMW 3 Series",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["driving"] = 3}},
			default_mods = {
				modLivery = 1,
				modTurbo = 1,
				modTransmission = 1,
				modBrakes = 1,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice10",
			type = "car",
			label = "Interceptor",
			vehicleName = "BMW M5",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 1500,
			needed_flags = {flag_type = "police_data", flags = {["driving"] = 3}},
			default_mods = {
				modLivery = 1,
				modTurbo = 1,
				modTransmission = 1,
				modBrakes = 1,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice1",
			type = "car",
			label = "Traffic", -- a label (A distinctive label) will be concatonated to the model eg: Audi A4 (Traffic)
			vehicleName = "Volvo V90",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["driving"] = 2}}, -- the required flag and required flag level needed to access the vehicle
			default_mods = { -- the mods it will come with when spawned in
				modLivery = 0,
				modTurbo = 1,
				modTransmission = 2,
				modBrakes = 1,
				dirtLevel = 0,
				--windowTint = 1,
				--modArmor = 1,
				--modSuspension = 1,
				--modEngineBlock = 1,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice4",
			type = "car",
			label = "Traffic",
			vehicleName = "Audi A4",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["driving"] = 2}},
			default_mods = {
				modLivery = 0,
				modTurbo = 1,
				modTransmission = 1,
				modBrakes = 1,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice7",
			type = "car",
			label = "Traffic",
			vehicleName = "BMW 3 Series",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["driving"] = 2}},
			default_mods = {
				modLivery = 0,
				modTurbo = 1,
				modTransmission = 1,
				modBrakes = 1,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice6",
			type = "car",
			label = "Traffic",
			vehicleName = "Vauxhall Insignia",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["driving"] = 1}},
			default_mods = {
				modLivery = 0,
				modTurbo = 1,
				modTransmission = 1,
				modBrakes = 1,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpNHS6",
			type = "car",
			label = "Traffic",
			vehicleName = "BMW R 1200RT",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["driving"] = 1}},
			default_mods = {
				modLivery = 2,
				modTurbo = 1,
				modTransmission = 1,
				modBrakes = 1,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice3",
			type = "car",
			label = "Firearms",
			vehicleName = "BMW 540i",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["firearms"] = 3}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice8",
			type = "car",
			label = "Firearms",
			vehicleName = "BMW x5",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["firearms"] = 2}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice12",
			type = "car",
			label = "Firearms",
			vehicleName = "Volvo XC90",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["firearms"] = 2}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice11",
			type = "car",
			label = "DSU",
			vehicleName = "Skoda Superb",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["dog"] = 1}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modEngine = 1,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice2",
			type = "car",
			label = "MPO",
			vehicleName = "Ford Ranger",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {["boat"] = 1}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modArmor = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice13",
			type = "car",
			label = "Frontline",
			vehicleName = "308sw",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {}},
			default_mods = {
				modLivery = 0,
				modTransmission = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modEngine = 1,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice14",
			type = "car",
			label = "Frontline",
			vehicleName = "Skoda Octavia",
			min_grade = 1, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {}},
			default_mods = {
				modLivery = 0,
				modTransmission = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modEngine = 1,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice9",
			type = "car",
			label = "Frontline",
			vehicleName = "Mercedes Sprinter",
			min_grade = 1, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modEngine = 1,
				extras = {
					[4] = 1, -- the esx script reverses it when applied so keep as 0
				},
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice9",
			type = "car",
			label = "Frontline",
			vehicleName = "Mercedes Sprinter - Riot",
			min_grade = 1, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modEngine = 1,
				extras = {
					[4] = 0, -- the esx script reverses it when applied so keep as 0
				},
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPoliceB1",
			type = "boat",
			label = "MPO",
			vehicleName = "RHIB",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 550,
			needed_flags = {flag_type = "police_data", flags = {["boat"] = 1}},
			default_mods = {
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPoliceB2",
			type = "boat",
			label = "MPO",
			vehicleName = "Patrol Boat",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 550,
			needed_flags = {flag_type = "police_data", flags = {["boat"] = 1}},
			default_mods = {
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPoliceH1",
			type = "air",
			label = "NPAS",
			vehicleName = "EC135",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 15000,
			needed_flags = {flag_type = "police_data", flags = {["pilot"] = 1}},
			default_mods = {
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPoliceUC1",
			type = "car",
			label = "Firearms",
			vehicleName = "UC-BMW x5",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 1500,
			needed_flags = {flag_type = "police_data", flags = {["firearms"] = 2}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				dirtLevel = 0,
				windowTint = 0,
				color1 = 0,
				color2 = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPoliceUC2",
			type = "car",
			label = "Firearms",
			vehicleName = "UC-Baller",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 1500,
			needed_flags = {flag_type = "police_data", flags = {["firearms"] = 2}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				dirtLevel = 0,
				windowTint = 0,
				color1 = 0,
				color2 = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPoliceUC3",
			type = "car",
			label = "Traffic",
			vehicleName = "UC-BMW 530D F11",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 1500,
			needed_flags = {flag_type = "police_data", flags = {["driving"] = 2}},
			default_mods = {
				modLivery = 1,
				modTurbo = 1,
				modTransmission = 1,
				modBrakes = 1,
				dirtLevel = 0,
				windowTint = 0,
				color1 = 0,
				color2 = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPoliceUC4",
			type = "car",
			label = "Frontline",
			vehicleName = "UC-Ford Mondeo",
			min_grade = 1, -- minimum job grade needed to access the vehicle
			price = 1500,
			needed_flags = {flag_type = "police_data", flags = {}},
			default_mods = {
				modLivery = 0,
				modTransmission = 1,
				modSuspension = 1,
				modEngine = 1,
				modEngineBlock = 1,
				windowTint = 0,
				color1 = 0,
				color2 = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPoliceUC5",
			type = "car",
			label = "Firearms",
			vehicleName = "UC- Mercedes V Class ",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 1500,
			needed_flags = {flag_type = "police_data", flags = {["firearms"] = 2}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				dirtLevel = 0,
				windowTint = 0,
				color1 = 0,
				color2 = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPoliceUC6",
			type = "car",
			label = "Unmarked",
			vehicleName = "UC-BMW 540i",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 1000,
			needed_flags = {flag_type = "police_data", flags = {["cid"] = 1}},
			default_mods = {
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 4,
				dirtLevel = 0,
				color1 = 1,
				color2 = 1,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPoliceUC7",
			type = "car",
			label = "Unmarked",
			vehicleName = "UC-Range Rover Sport SVR",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 1000,
			needed_flags = {flag_type = "police_data", flags = {["cid"] = 1}},
			default_mods = {
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 4,
				dirtLevel = 0,
				color1 = 1,
				color2 = 1,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPoliceUC8",
			type = "car",
			label = "Unmarked",
			vehicleName = "UC-Oracle",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 1000,
			needed_flags = {flag_type = "police_data", flags = {["covert"] = 1}},
			default_mods = {
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 4,
				dirtLevel = 0,
				color1 = 1,
				color2 = 1,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPoliceUC9",
			type = "car",
			label = "Unmarked",
			vehicleName = "UC-Volvo V90",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 1000,
			needed_flags = {flag_type = "police_data", flags = {["cid"] = 1}},
			default_mods = {
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 4,
				dirtLevel = 0,
				color1 = 1,
				color2 = 1,
			},
		},
		{
			model = "sheriff2",
			type = "car",
			label = "Specialist",
			vehicleName = "UC-Granger",
			min_grade = 6, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "police_data", flags = {}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modTurbo = 1,
				modBrakes = 1,
				windowTint = 0,
				color1 = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
	},
	["ambulance"] = {
		{
			model = "rpNHS1",
			type = "car",
			label = "NHS",
			vehicleName = "Mercedes Sprinter",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {}},
			default_mods = {
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpNHS2",
			type = "car",
			label = "NHS",
			vehicleName = "Fiat Ducato",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {}},
			default_mods = {
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpNHS3",
			type = "car",
			label = "T&R",
			vehicleName = "Range Rover SVR",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {["training"] = 1}},
			default_mods = {
				modLivery = 0,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpNHS4",
			type = "car",
			label = "HART",
			vehicleName = "Skoda Karoq",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {["hart"] = 1}},
			default_mods = {
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpNHS5",
			type = "car",
			label = "HART",
			vehicleName = "Mercedes Vito",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {["hart"] = 1}},
			default_mods = {
				modLivery = 0,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice14",
			type = "car",
			label = "T&R",
			vehicleName = "Skoda Octavia",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {["training"] = 1}},
			default_mods = {
				modLivery = 3,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice14",
			type = "car",
			label = "Blood",
			vehicleName = "Skoda Octavia",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {}},
			default_mods = {
				modLivery = 2,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpNHS6",
			type = "car",
			label = "HART",
			vehicleName = "BMW 1200RT",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {["hart"] = 1}},
			default_mods = {
				modLivery = 0,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpNHS6",
			type = "car",
			label = "Blood",
			vehicleName = "BMW 1200RT",
			min_grade = 3, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {}},
			default_mods = {
				modLivery = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpPolice14",
			type = "car",
			label = "HEMS",
			vehicleName = "Skoda Octavia",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {["pilot"] = 1}},
			default_mods = {
				modLivery = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpNHS7",
			type = "car",
			label = "Event",
			vehicleName = "Blood Bus",
			min_grade = 5, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {}},
			default_mods = {
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "seasparrow",
			type = "air",
			label = "HEMS",
			vehicleName = "Seasparrow",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {["pilot"] = 1}},
			default_mods = {
				modLivery = 2,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpNHSH1",
			type = "air",
			label = "HEMS",
			vehicleName = "Air Ambulance",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "nhs_data", flags = {["pilot"] = 1}},
			default_mods = {
				modLivery = 2,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "dinghy",
			type = "boat",
			label = "NHS",
			vehicleName = "Rescue Boat",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 550,
			needed_flags = {flag_type = "nhs_data", flags = {}},
			default_mods = {
				color1 = 43,
				color2 = 0,
			},
		},
	},
	["gruppe6"] = {
		{
			model = "rpG61",
			type = "car",
			label = "Standard",
			vehicleName = "Explorer",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 1}},
			default_mods = {
				modArmor = 3,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpG62",
			type = "car",
			label = "Specialist",
			vehicleName = "Renault Lorry",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 1000,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 3}},
			default_mods = {
				modLivery = 1,
				modTransmission = 4,
				modArmor = 4,
				modSuspension = 4,
				modEngineBlock = 4,
				modTurbo = 4,
				modBrakes = 4,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpG63",
			type = "car",
			label = "Transport",
			vehicleName = "L - Prison Bus",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 2}},
			default_mods = {
				modArmor = 3,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpG64",
			type = "car",
			label = "Transport",
			vehicleName = "Prison Truck",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 2}},
			default_mods = {
				modArmor = 3,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpG65",
			type = "car",
			label = "Transport",
			vehicleName = "Prison Van",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 1}},
			default_mods = {
				modArmor = 3,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpG66",
			type = "car",
			label = "Transport",
			vehicleName = "MT-Stockade",
			min_grade = 2, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 2}},
			default_mods = {
				modArmor = 3,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rpG67",
			type = "car",
			label = "Transport",
			vehicleName = "MT-Van",
			min_grade = 2, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 2}},
			default_mods = {
				modArmor = 3,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "pbus",
			type = "car",
			label = "Transport",
			vehicleName = "S - Prision Bus",
			min_grade = 2, -- minimum job grade needed to access the vehicle
			price = 500,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 2}},
			default_mods = {
				modArmor = 3,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "cognoscenti2",
			type = "car",
			label = "Security",
			vehicleName = "A-Cognoscenti2",
			min_grade = 2, -- minimum job grade needed to access the vehicle
			price = 800,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 2}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modTurbo = 1,
				modBrakes = 1,
				windowTint = 2,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "cog552",
			type = "car",
			label = "Security",
			vehicleName = "A-Cog552",
			min_grade = 2, -- minimum job grade needed to access the vehicle
			price = 800,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 2}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modTurbo = 1,
				modBrakes = 1,
				windowTint = 2,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "schafter5",
			type = "car",
			label = "Security",
			vehicleName = "A-Schafter5",
			min_grade = 2, -- minimum job grade needed to access the vehicle
			price = 800,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 2}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modTurbo = 1,
				modBrakes = 1,
				windowTint = 2,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "schafter6",
			type = "car",
			label = "Security",
			vehicleName = "A-Schafter6",
			min_grade = 2, -- minimum job grade needed to access the vehicle
			price = 800,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 2}},
			default_mods = {
				modLivery = 1,
				modTransmission = 1,
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modTurbo = 1,
				modBrakes = 1,
				windowTint = 2,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "trailers",
			type = "car",
			label = "Security",
			vehicleName = "Trailer",
			min_grade = 4, -- minimum job grade needed to access the vehicle
			price = 800,
			needed_flags = {flag_type = "civ_job", flags = {["gruppe6"] = 3}},
			default_mods = {
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
	},
	["weazel"] = {
		{
			model = "newsvan",
			type = "car",
			label = "Broadcasting",
			vehicleName = "News Van",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 0,
			needed_flags = {flag_type = "civ_job", flags = {["weazel"] = 1}},
			default_mods = {
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "rumpo",
			type = "car",
			label = "Standard",
			vehicleName = "Rumpo",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 0,
			needed_flags = {flag_type = "civ_job", flags = {["weazel"] = 1}},
			default_mods = {
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				modLivery = 0,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "newsheli2",
			type = "air",
			label = "Standard",
			vehicleName = "News Heli 1",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 0,
			needed_flags = {flag_type = "civ_job", flags = {["weazel"] = 1}},
			default_mods = {
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				modLivery = 0,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
		{
			model = "wnewsheli1",
			type = "air",
			label = "Standard",
			vehicleName = "News Heli 2",
			min_grade = 0, -- minimum job grade needed to access the vehicle
			price = 0,
			needed_flags = {flag_type = "civ_job", flags = {["weazel"] = 1}},
			default_mods = {
				modArmor = 1,
				modSuspension = 1,
				modEngineBlock = 1,
				modBrakes = 1,
				modLivery = 0,
				windowTint = 0,
				dirtLevel = 0,
				fuelLevel = 1000,
			},
		},
	},
}