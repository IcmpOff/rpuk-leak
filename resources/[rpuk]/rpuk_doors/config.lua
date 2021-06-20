Config = {}
Config.debug = false

Config.text = {
	unlocked = '~g~Unlocked ~s~',
	locked = '~r~Locked ~s~',
	not_auth = 'You do ~r~not~s~ have the keys for this door.',
	press_button = ' \n[E]',
	ID = '~y~ ID-~s~',
	lockpick = "Press [E] to use Equipment",
	hackable = "Press [E] to start hacking",
	ziptie = "Press [E] to ziptie",
	ziptied = "Press [E] to cut ziptie",
	breach = "Press [E] to breach",
	repair = "Press [E] to repair door",
	locking = "~r~Locking~s~",
	unlocking = "~g~Unlocking~s~",
}

Config.LockTimer = 2000
Config.levelMinDifficulty = 2
Config.levelMaxDifficulty = 8
Config.minHackTime = 8 --Sec
Config.maxHackTime = 28 --Sec

Config.DoorList = {

--[[
	-- Door Template
{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = 110411286,
			objCoords	= {x = 232.46189880371, y = 214.68446350098, z = 106.2865524292},
		},
		{
			objHash = 110411286,
			objCoords	= {x = 231.53071594238, y = 215.91058349609, z = 106.28022766113},
		},
	},
	authorizedJobs = { -- Job Restriction
		{
			name = 'police',
			rank = 0,	--- 0 = Everyone
			specUnit = {} --- TBC
		}
	},
	unAuthorized = {
		{
		 name = "police", -- Every other job except
		}
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	textCoords = {x = 434.747, y = -981.70, z = 30.80}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	id = "front_police_1", -- Custom ID (Never leave blank)
	ziptie = true, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = true, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},
--]]


----- Pacific Heist -----

-- Front MainDoors
{
	doors = {
		{
				objHash = 110411286,
				objCoords	= {x = 232.46189880371, y = 214.68446350098, z = 106.2865524292},
				objCloseState = {pitch = 0.0, roll = -0.0,yaw = 115.04},
		},
		{
				objHash = 110411286,
				objCoords	= {x = 231.53071594238, y = 215.91058349609, z = 106.28022766113},
				objCloseState = {pitch = 0.0, roll = -0.0,yaw = -65.05},
		},
	},
	textCoords = {x = 232.06541442871, y = 215.39892578125, z = 106.28652954102},
	authorizedJobs = {},
	id = "bankPacific_1",
	locked = false,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	hackable = false,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
},

-- BackDoors

{
	doors = {
		{
				objHash = 110411286,
				objCoords	= {x = 260.6432, y = 203.2052, z = 106.4049},
				objCloseState = {pitch = 0.0, roll = -0.0,yaw = 159.0},
		},
		{
				objHash = 110411286,
				objCoords	= {x = 258.2022, y = 204.1005, z = 106.4049},
				objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},
	},
	textCoords = {x = 259.35528564453, y = 203.19026184082, z = 106.28006744385},
	authorizedJobs = {},
	id = "bankPacific_2",
	locked = false,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	hackable = false,
	frozenDist = 110.0,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	lockpick = true
},
-- First Gate
{
	doors = {
		{
			objHash = -222270721,
			objCoords = {x = 257.01879882813, y = 220.4497833252, z = 106.28510284424},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},
	},
	textCoords = {x = 257.01879882813, y = 220.4497833252, z = 106.28510284424},
	authorizedJobs = {},
	id = "bankPacific_3",
	locked = true,
	size = 0.5,
	distance = 1.0,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	breachable = true,
	hackable = false,
	ziptie = true
},

-- Second Gate
{
	doors = {
		{
			objHash = 746855201,
			objCoords = {x = 261.82318115234, y = 221.8939666748, z = 106.28388977051},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},
	},
	textCoords = {x = 262.64929199219, y = 223.23258972168, z = 106.36531066895},
	id = "bankPacific_4",
	locked = true,
	size = 0.5,
	distance = 1.0,
	hackable = true,
	ziptie = false,
	breachable = false,
	lockpick = false,
	frozenDist = 110.0,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {"police", "nca"},
},

-- Door to stairs from entrance

{
	doors = {
		{
			objHash = 1956494919,
			objCoords = {x = 236.99514770508, y = 228.23680114746, z = 106.2834854126},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},
	},
	textCoords = {x = 236.99514770508, y = 228.23680114746, z = 106.2834854126},
	authorizedJobs = {},
	id = "bankPacific_5",
	distance = 1.0,
	locked = true,
	size = 0.5,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	hackable = false
},

-- Door to hallway from stairs

{
	doors = {
		{
			objHash = 1956494919,
			objCoords = {x = 237.17782592773, y = 227.94946289063, z = 110.28280639648},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 160.0},
		},
	},
	textCoords = {x = 237.17782592773, y = 227.94946289063, z = 110.28280639648},
	authorizedJobs = {},
	id = "bankPacific_6",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	hackable = false
},

-- Door to hallway of managers office

{
	doors = {
		{
			objHash = 1956494919,
			objCoords = {x = 256.97500610352, y = 206.60784912109, z = 110.2829284668},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -110.0},
		},
	},
	textCoords = {x = 256.97500610352, y = 206.60784912109, z = 110.2829284668},
	authorizedJobs = {},
	id = "bankPacific_7",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	hackable = false
},

--- Managers Office
{
	doors = {
		{
			objHash = 964838196,
			objCoords = {x = 260.75912475586, y = 209.80059814453, z = 110.28747558594},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 70.0},
		},
	},
	textCoords = {x = 260.75912475586, y = 209.80059814453, z = 110.28747558594},
	authorizedJobs = {},
	id = "bankPacific_8",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	hackable = false
},

--- Second Office

{
	doors = {
		{
			objHash = 964838196,
			objCoords = {x = 262.27374267578, y = 214.3487701416, z = 110.2830581665},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 70.0},
		},
	},
	textCoords = {x = 262.27374267578, y = 214.3487701416, z = 110.2830581665},
	authorizedJobs = {},
	id = "bankPacific_9",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	hackable = false
},

--- Door to stairs to desks

{
	doors = {
		{
			objHash = 1956494919,
			objCoords = {x = 265.71142578125, y = 217.5686340332, z = 110.28305053711},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},
	},
	textCoords = {x = 265.71142578125, y = 217.5686340332, z = 110.28305053711},
	authorizedJobs = {},
	id = "bankPacific_10",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1508355822,
			objCoords = {x = 252.50338745117, y = 220.68058776855, z = 101.68347930908},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 160.0},
		},
	},
	textCoords = {x = 252.50338745117, y = 220.68058776855, z = 101.68347930908},
	authorizedJobs = {},
	id = "bankPacific_11",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1508355822,
			objCoords = {x = 261.63830566406, y = 215.13217163086, z = 101.68347167969},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -110.0},
		},
	},
	textCoords = {x = 261.63830566406, y = 215.13217163086, z = 101.68347167969},
	authorizedJobs = {},
	id = "bankPacific_13",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 110411286,
			objCoords = {x = 259.42373657227, y = 214.76426696777, z = 106.28676605225},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -110.0},
		},

		{
			objHash = 110411286,
			objCoords = {x = 259.33010864258, y = 213.29254150391, z = 106.28345489502},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 70.0},
		},
	},
	textCoords = {x = 259.40090942383, y = 214.1537322998, z = 106.28674316406},
	authorizedJobs = {},
	id = "bankPacific_14",
	locked = false,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	chanceToNotify = 50,
	requiredPoliceOnDuty = 0,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	hackable = false
},




-------------------

--- Mission Row PD

{
	doors = {
		{
			objHash = -1406685646,
			objCoords	= {x = 440.520, y = -977.601, z = 30.823},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 0.0},
		},

	},
	textCoords = {x = 441.619, y = -977.720, z = 30.955},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.1, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_00",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -96679321,
			objCoords	= {x = 441.593, y = -986.205, z = 30.850},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -180.0},
		},

	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 441.628, y = -986.118, z = 30.942},
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.1, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_01",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1547307588,
			objCoords	= {x = 440.739, y = -998.746, z = 30.815},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},

		{
			objHash = -1547307588,
			objCoords	= {x = 443.062, y = -998.746, z = 30.815},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -179.0},
		},

	},
	textCoords = {x = 441.910, y = -998.788, z = 30.791},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_02",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1547307588,
			objCoords	= {x = 457.349, y = -972.245, z = 31.046},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -179.0},
		},

		{
			objHash = -1547307588,
			objCoords	= {x = 456.265, y = -972.235, z = 31.121},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},

	},
	textCoords = {x = 457.064, y = -972.208, z = 30.797},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_03",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -692649124,
			objCoords	= {x = 464.284, y = -983.927, z = 43.868},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 89.0},
		},
	},
	textCoords = {x = 464.265, y = -983.449, z = 43.952},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.1, -- Forward/Backward
		offsetZ = 0.2 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_04",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 2130672747,
			objCoords	= {x = 431.781, y = -1000.684, z = 26.181},
		},
	},
	textCoords = {x = 433.763, y = -1000.642, z = 26.290},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_05",
	locked = true,
	size = 0.5,
	distance = 150.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 2130672747,
			objCoords	= {x = 452.111, y = -1000.744, z = 26.239},
		},

	},
	textCoords = {x = 454.721, y = -1001.265, z = 26.229},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_06",
	locked = true,
	size = 0.5,
	distance = 150.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1603817716,
			objCoords	= {x = 488.820, y = -1020.562, z = 28.580},
		},

	},
	textCoords = {x = 488.490, y = -1023.111, z = 29.037},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_07",
	locked = true,
	size = 0.5,
	distance = 150.0,
	ziptie = false,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 150.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -692649124,
			objCoords	= {x = 468.263, y = -1014.431, z = 26.744},
			objCloseState = {pitch 	= 0.0, roll = -0.0,yaw = 0.0},
		},

		{
			objHash = -692649124,
			objCoords	= {x = 469.166, y = -1014.431, z = 26.565},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -180.0},
		},

	},
	textCoords = {x = 468.588, y = -1014.431, z = 26.565},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_09",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
				objHash = 149284793,
				objCoords	= {x = 471.353, y = -1008.744, z = 26.5594},
				objCloseState = {pitch = 0.0, roll = -0.0,yaw = -89.0},
		},

		{
				objHash = 149284793,
				objCoords	= {x = 471.366, y = -1009.592, z = 26.497},
				objCloseState = {pitch = 0.0, roll = -0.0,yaw = 90.0},
		},

	},
	textCoords = {x = 471.358, y = -1008.998, z = 26.487},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_10",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -53345114,
			objCoords	= {x = 476.581, y = -1008.255, z = 26.629},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -89.0},
		},

	},
	textCoords = {x = 476.593, y = -1007.820, z = 26.456},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_11",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -53345114,
			objCoords	= {x = 476.819, y = -1012.163, z = 26.501},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},

	},
	textCoords = {x = 476.810, y = -1012.163, z = 26.503},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_12",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -53345114,
			objCoords	= {x = 479.842, y = -1012.163, z = 26.499},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},

	},
	textCoords = {x = 479.796, y = -1012.163, z = 26.499},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_13",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -53345114,
			objCoords	= {x = 482.871, y = -1012.163, z = 26.496},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},

	},
	textCoords = {x = 482.832, y = -1012.163, z = 26.514},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_14",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -53345114,
			objCoords	= {x = 485.825, y = -1012.163, z = 26.466},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},

	},
	textCoords = {x = 485.825, y = -1012.163, z = 26.510},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_15",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -53345114,
			objCoords	= {x = 485.175, y = -1007.745, z = 26.544},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 180.0},
		},

	},
	textCoords = {x = 485.264, y = -1007.760, z = 26.506},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_16",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -53345114,
			objCoords	= {x = 482.021, y = -1004.144, z = 26.500},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -180.0},
		},
	},
	textCoords = {x = 482.078, y = -1004.144, z = 26.522},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_17",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -288803980,
			objCoords	= {x = 479.060, y = -1002.271, z = 26.533},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 89.0},
		},

	},
	textCoords = {x = 479.173, y = -1002.081, z = 26.542},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1	, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_18",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1258679973,
			objCoords	= {x = 474.777, y = -992.049, z = 26.700},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},
	},
	textCoords = {x = 474.398, y = -991.990, z = 26.623},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_19",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1830360419,
			objCoords	= {x = 464.189, y = -996.699, z = 26.810},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 89.0},
		},
	},
	textCoords = {x = 464.220, y = -996.414, z = 26.484},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.2 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_20",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1830360419,
			objCoords	= {x = 464.158, y = -975.116, z = 26.545},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -90.0},
		},
	},
	textCoords = {x = 464.216, y = -975.757, z = 26.498},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.2 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_21",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 149284793,
			objCoords	= {x = 479.082, y = -986.607, z = 26.566},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 89.0},
		},

		{
			objHash = 149284793,
			objCoords	= {x = 479.081, y = -985.495, z = 26.638},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -89.0},
		},


	},
	textCoords = {x = 479.087, y = -986.212, z = 26.463},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_22",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -288803980,
			objCoords	= {x = 469.094, y = -1000.519, z = 26.440},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -180.0},
		},

		{
			objHash = -288803980,
			objCoords	= {x = 467.998, y = -1000.519, z = 26.416},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},


	},
	textCoords = {x = 468.717, y = -1000.520, z = 26.476},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_23",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -692649124,
			objCoords	= {x = 479.726, y = -998.945, z = 30.949},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 88.0},
		},

	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.2 -- Up/Down
	},
	textCoords = {x = 479.711, y = -998.527, z = 30.930},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_24",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -692649124,
			objCoords	= {x = 486.674, y = -1000.232, z = 31.026},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -178.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.2 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 486.322, y = -1000.276, z = 30.922},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_25",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1406685646,
			objCoords	= {x = 482.637, y = -996.572, z = 26.349},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -89.0},
		},

	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.2 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 482.626, y = -996.829, z = 26.480},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_26",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1406685646,
			objCoords	= {x = 482.671, y = -988.449, z = 26.603},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -89.0},
		},

	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.2 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 482.637, y = -988.699, z = 26.473},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_27",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1635161509,
			objCoords	= {x = 409.939, y = -1028.792, z = 28.917},
		},
	},
	textCoords = {x = 412.276, y = -1025.771, z = 29.072},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_28",
	locked = true,
	size = 0.5,
	distance = 400.0,
	ziptie = false,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 400.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1868050792,
			objCoords	= {x = 409.939, y = -1019.613, z = 28.845},
		},

	},
	textCoords = {x = 412.189, y = -1022.695, z = 29.072},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
	},
	id = "missionRow_29",
	locked = true,
	size = 0.5,
	distance = 400.0,
	ziptie = false,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 400.0,
	hackable = false
},

---- Pillbox

{
	doors = {
		{
			objHash = 854291622,
			objCoords	= {x = 345.89868164063, y = -596.64520263672, z = 43.284061431885},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 70.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.2 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 345.89868164063, y = -596.64520263672, z = 43.284061431885},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_1",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 854291622,
			objCoords	= {x = 341.50756835938, y = -582.05029296875, z = 43.284065246582},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -20.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.0 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 341.50756835938, y = -582.05029296875, z = 43.284065246582},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_2",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

-- {
--	 doors = {
--		 {
--				 objHash = 854291622,
--				 objCoords	= {x = 308.49224853516, y = -597.21844482422, z = 43.284008026123},
--		 },

--	 },
--	 textCoords = {x = 308.49224853516, y = -597.21844482422, z = 43.284008026123},
--	 authorizedJobs = {
--		 {
--			 name = "ambulance",
--			 rank = 0,
--			 specUnit = {}
--		 }
--	 },
--	 id = "pillbox_3",
--	 locked = true,
--	 size = 0.5,
--	 distance = 1.0,
--	 ziptie = true,
--	 breachable = true,
--	 lockpick = true,
--	 requiredPoliceOnDuty = 0,
--	 allowedToRepairDoor = {},
--	 frozenDist = 110.0,
--	 hackable = false
-- },

{
	doors = {
		{
			objHash = 854291622,
			objCoords	= {x = 307.79528808594, y = -569.89208984375, z = 43.284042358398},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.0 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 307.79528808594, y = -569.89208984375, z = 43.284042358398},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_4",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 854291622,
			objCoords	= {x = 304.1999206543, y = -571.88989257813, z = 43.284072875977},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 70.0},
		},

	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.0 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 304.1999206543, y = -571.88989257813, z = 43.284072875977},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_5",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 854291622,
			objCoords	= {x = 339.80838012695, y = -586.85345458984, z = 43.284042358398},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},

	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.0 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 339.80838012695, y = -586.85345458984, z = 43.284042358398},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_6",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -434783486,
			objCoords	= {x = 312.56481933594, y = -571.64611816406, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},
		{
			objHash = -1700911976,
			objCoords	= {x = 313.76593017578, y = -572.07458496094, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},

	},
	textCoords = {x = 313.18740844727, y = -571.80700683594, z = 43.472213745117},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_7",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -434783486,
			objCoords	= {x = 318.42184448242, y = -573.71453857422, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},
		{
			objHash = -1700911976,
			objCoords	= {x = 319.68737792969, y = -574.17907714844, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},

	},
	textCoords = {x = 319.04425048828, y = -573.94030761719, z = 43.643405914307},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_8",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -434783486,
			objCoords	= {x = 323.81948852539, y = -575.71069335938, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},
		{
			objHash = -1700911976,
			objCoords	= {x = 325.12084960938, y = -576.16821289062, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},

	},
	textCoords = {x = 324.43511962891, y = -575.89477539062, z = 43.600898742676},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_9",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 854291622,
			objCoords	= {x = 336.71469116211, y = -580.38598632812, z = 42.304397583008},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},

	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.0 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 337.19088745117, y = -580.5517578125, z = 43.491031646729},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_10",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 854291622,
			objCoords	= {x = 347.36813354492, y = -584.27880859375, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},

	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.0 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 347.72821044922, y = -584.39031982422, z = 43.537590026855},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_11",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 854291622,
			objCoords	= {x = 359.37973022461, y = -594.02935791016, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -20.0},
		},

	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.0 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 359.73809814453, y = -594.20959472656, z = 43.55700302124},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_12",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1700911976,
			objCoords	= {x = 325.89251708984, y = -579.9599609375, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -110.0},
		},
		{
			objHash = -434783486,
			objCoords	= {x = 326.42309570312, y = -578.62432861328, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -110.0},
		},

	},
	textCoords = {x = 326.13803100586, y = -579.275390625, z = 43.307716369629},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_13",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1700911976,
			objCoords	= {x = 324.8056640625, y = -589.33862304688, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},
		{
			objHash = -434783486,
			objCoords	= {x = 326.06838989258, y = -589.85113525391, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -19.0},
		},

	},
	textCoords = {x = 325.46875, y = -589.63586425781, z = 43.317825317383},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_14",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1700911976,
			objCoords	= {x = 348.59310913086, y = -588.14935302734, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -110.0},
		},
		{
			objHash = -434783486,
			objCoords	= {x = 349.06533813477, y = -586.87817382812, z = 42.284076690674},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -110.0},
		},

	},
	textCoords = {x = 348.84545898438, y = -587.52801513672, z = 43.34496307373},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_15",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},
--new dlc doors (bottom floor)
{
	doors = {
		{
			objHash = 854291622,
			objCoords	= {x = 348.55, y = -585.16, z = 28.95},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -109.0},
		},

	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.0 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 348.268, y = -585.800, z = 29.151},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_16",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},
{
	doors = {
		{
			objHash = -1700911976,
			objCoords	= {x = 339.33, y = -587.63, z = 28.95},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 70.0},

		},
		{
			objHash = -434783486,
			objCoords	= {x = 338.45, y = -590.05, z = 28.95},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 70.0},

		},

	},
	textCoords = {x = 338.926, y = -588.842, z = 29.091},
	authorizedJobs = {
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
	},
	id = "pillbox_17",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},


------------------------------------------------------
--- IVE GOT HERE WITH DOING DOOR CLOSE STATES - Archie
------------------------------------------------------

--- Paleto Bay Poilce Station

{
	doors = {
	{
		objHash = -1501157055,
		objCoords	= {x = -444.28625488281, y = 6016.552734375, z = 31.716339111328},
		objCloseState = {pitch = 0.0, roll = -0.0,yaw = 135.0},
	},

	{
		objHash = -1501157055,
		objCoords	= {x = -443.14123535156, y = 6015.5581054688, z = 31.716331481934},
		objCloseState = {pitch = 0.0, roll = -0.0,yaw = -44.0},
	},

	},
	textCoords = {x = -443.77389526367, y = 6015.990234375, z = 31.716331481934},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		}
	},
	id = "paleto_1",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 964838196,
			objCoords	= {x = -442.35598754883, y = 6011.39453125, z = 31.716361999512},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -135.0},
		},

		{
			objHash = 964838196,
			objCoords	= {x = -441.28381347656, y = 6012.3354492188, z = 31.716339111328},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 45.0},
		},

	},
	textCoords = {x = -441.97647094727, y = 6011.9819335938, z = 31.716337203979},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		}
	},
	id = "paleto_2",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},


{
	doors = {
		{
			objHash = 245182344,
			objCoords	= {x = -449.10916137695, y = 6008.1689453125, z = 31.716360092163},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -44.0},
		},

		{
			objHash = -681066206,
			objCoords	= {x = -448.16952514648, y = 6007.220703125, z = 31.716361999512},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 135.0},
		},

	},
	textCoords = {x = -448.63690185547, y = 6007.7236328125, z = 31.716360092163},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		}
	},
	id = "paleto_4",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},



{
	doors = {
		{
			objHash = -2023754432,
			objCoords	= {x = -450.35507202148, y = 6015.767578125, z = 31.716360092163},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 135.0},
		},

	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.0 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = -450.35507202148, y = 6015.767578125, z = 31.716360092163},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		}
	},
	id = "paleto_5",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 452874391,
			objCoords	= {x = -446.7936706543, y = 6001.8608398438, z = 31.7161693573},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 135.0},
		},

	},
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.0 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = -446.7936706543, y = 6001.8608398438, z = 31.7161693573},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		}
	},
	id = "paleto_7",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1011692606,
			objCoords	= {x = -437.03732299805, y = 5992.330078125, z = 31.716190338135},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 135.0},
		},

	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.4, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = -437.03732299805, y = 5992.330078125, z = 31.716190338135},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		}
	},
	id = "paleto_9",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 631614199,
			objCoords	= {x = -432.68548583984, y = 5992.6499023438, z = 31.7161693573},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -44.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = -432.68548583984, y = 5992.6499023438, z = 31.7161693573},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		}
	},
	id = "paleto_10",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 631614199,
			objCoords	= {x = -428.62020874023, y = 5997.0493164063, z = 31.716175079346},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -44.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = -428.62020874023, y = 5997.0493164063, z = 31.716175079346},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		}
	},
	id = "paleto_11",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 631614199,
			objCoords	= {x = -431.76403808594, y = 6000.2456054688, z = 31.716196060181},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -44.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = -431.76403808594, y = 6000.2456054688, z = 31.716196060181},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		}
	},
	id = "paleto_12",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},


	--
	-- Bolingbroke Penitentiary
  --
  
  --- Main Gates

  --- Gate #1

{
	doors = {
		{
			objHash = 741314661,
			objCoords  = {x = 1844.9378662109, y = 2608.4682617188, z = 45.589687347412},
		},
	},
	textCoords = {x = 1846.2666015625, y = 2604.6977539063, z = 45.652938842773},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_1",
	locked = true,
	size = 0.5,
	distance = 190.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 190.0,
	hackable = true
},

--- Gate #2

{
	doors = {
		{
			objHash = 741314661,
			objCoords  = {x = 1818.0357666016, y = 2608.4990234375, z = 45.595928192139},
		},
	},
	textCoords = {x = 1819.7235107422, y = 2604.6616210938, z = 45.561592102051},
	authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
},
	id = "bolingbroke_2",
	locked = true,
	size = 0.5,
	distance = 250.0,
	ziptie = false,
	breachable = false,
	lockpick = false,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 150.0,
	hackable = true
},

{
  doors = {
	{
		objHash = -1033001619,
		objCoords  = {x = 1826.5543212891, y = 2585.9484863281, z = 45.952293395996},
		objCloseState = {pitch = 0.0, roll = -0.0,yaw = 89.0},
	},

  },
  textCoords = {x = 1826.619, y = 2586.854, z = 46.170},
  authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_3",
  locked = true,
  size = 0.5,
  distance = 2.0,
  ziptie = true,
  breachable = true,
  lockpick = true,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 80.0,
  hackable = false
},


{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1828.1080322266, y = 2587.197265625, z = 45.952320098877},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 1.0},
		},
	},
	textCoords = {x = 1828.502, y = 2587.444, z = 46.101},
	authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_4",
  locked = true,
  size = 0.5,
  textOnDoor = true,
  positionForDoorText = {
	offsetX = 1.2, -- Left/Right
	offsetY = 0.0, -- Forward/Backward
	offsetZ = 0.0 -- Up/Down
  },
  distance = 2.0,
  ziptie = true,
  breachable = true,
  lockpick = true,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 80.0,
  hackable = false
},


{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1828.4001464844, y = 2584.6379394531, z = 45.952320098877},
		},
	},
	textCoords = {x = 1829.264, y = 2584.723, z = 46.195},
	authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
	},
	id = "bolingbroke_5",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1819.1619873047, y = 2594.3278808594, z = 46.076808929443},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 89.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 1819.227, y = 2594.777, z = 46.095},
	authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_6",
  locked = true,
  size = 0.5,
  distance = 2.0,
  ziptie = true,
  breachable = true,
  lockpick = true,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 80.0,
  hackable = false
},

{
doors = {
	{
		objHash = 1028191914,
		objCoords  = {x = 1783.8721923828, y = 2598.4533691406, z = 45.797843933105},
		objCloseState = {pitch = 0.0, roll = -0.0,yaw = 89.0},
	},

	},
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 1783.8721923828, y = 2598.4533691406, z = 45.797843933105},
	authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_7",
  locked = true,
  size = 0.5,
  distance = 2.0,
  ziptie = true,
  breachable = true,
  lockpick = true,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 80.0,
  hackable = false
},

{
	doors = {
		{
			objHash = 1028191914,
			objCoords  = {x = 1787.6898193359, y = 2606.798828125, z = 50.549644470215},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -89.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 1787.6898193359, y = 2606.798828125, z = 50.549644470215},
	authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_8",
  locked = true,
  size = 0.5,
  distance = 2.0,
  ziptie = true,
  breachable = true,
  lockpick = true,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 80.0,
  hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1767.34, y = 2607.43, z = 49.55},
		},
	},
	textCoords = {x = 1767.42, y = 2606.85, z = 50.55},
	authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_9",
  locked = true,
  size = 0.5,
  distance = 4.0,
  ziptie = true,
  breachable = true,
  lockpick = true,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 80.0,
  hackable = false
},


{
	doors = {
		{
			objHash = 1028191914,
			objCoords  = {x = 1785.2447509766, y = 2566.9914550781, z = 45.824069976807},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 1785.2447509766, y = 2566.9914550781, z = 45.824069976807},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_10",
	locked = false,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1645000677,
			objCoords  = {x = 1776.2999267578, y = 2552.2307128906, z = 45.797790527344},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -90.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 1776.2999267578, y = 2552.2307128906, z = 45.797790527344},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_13",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1645000677,
			objCoords  = {x = 1791.0819091797, y = 2594.4716796875, z = 45.980731964111},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 89.0},
		},

		{
			objHash = 262839150,
			objCoords  = {x = 1790.7515869141, y = 2593.1845703125, z = 45.98059463501},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -89.0},
		},
	},
	textCoords = {x = 1790.7175292969, y = 2593.75390625, z = 45.98070526123},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_14",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1786.3897705078, y = 2589.7424316406, z = 45.797847747803},
		},
	},
	textCoords = {x = 1786.3897705078, y = 2589.7424316406, z = 45.797847747803},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_15",
	locked = true,
	size = 0.5,
	distance = 10.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1773.7414550781, y = 2589.9760742188, z = 45.797847747803},
		},
	},
	textCoords = {x = 1773.7414550781, y = 2589.9760742188, z = 45.797847747803},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_16",
	locked = false,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

-- {
--   doors = {
--     {
--         objHash = -1033001619,
--         objCoords  = {x = 1837.70, y = 2585.24, z = 46.10},
--     },

--   },
--   textCoords = {x = 1837.795, y = 2586.374, z = 46.080},
--   authorizedJobs = {
-- 	{
-- 		name = "police",
-- 		rank = 0,
-- 		specUnit = {}
-- 	},
-- 	{
-- 		name = "nca",
-- 		rank = 1,
-- 		specUnit = {}
-- 	},
-- 	{
-- 		name = "gruppe6",
-- 		rank = 1,
-- 		specUnit = {}
-- 	}
--   },
--   id = "bolingbroke_17",
--   locked = true,
--   size = 0.5,
--   distance = 1.0,
--   ziptie = true,
--   breachable = true,
--   lockpick = true,
--   requiredPoliceOnDuty = 10,
--   chanceToNotify = 100,
--   allowedToRepairDoor = {},
--   frozenDist = 80.0,
--   hackable = false
-- },

{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1837.71, y = 2595.19, z = 46.10},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -90.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 1837.819, y = 2594.049, z = 46.099},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_18",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	frozenDist = 80.0,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	hackable = false,
},

{
	doors = {
		{
			objHash = 262839150,
			objCoords  = {x = 1786.38, y = 2600.23, z = 46.09},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -4.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 1785.62, y = 2600.24, z = 45.80},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
		},
	id = "bolingbroke_19",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
	{
		objHash = 741314661,
		objCoords  = {x = 1799.61, y = 2616.97, z = 44.60},
	},

	},
	textCoords = {x = 1796.1989746094, y = 2617.0400390625, z = 47.281337738037},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_20",
	locked = true,
	size = 0.5,
	distance = 190.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 190.0,
	hackable = true
  },

{
	doors = {
		{
			objHash = 1028191914,
			objCoords  = {x = 1782.37, y = 2595.81, z = 45.97},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -4.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 1781.48, y = 2595.80, z = 45.80},
	authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_21",
  locked = true,
  size = 0.5,
  distance = 1.0,
  ziptie = true,
  breachable = true,
  lockpick = true,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 80.0,
  hackable = false
},

{
	doors = {
		{
			objHash = 1028191914,
			objCoords  = {x = 1782.01, y = 2545.44, z = 45.98},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 3.0},
		},
	},
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 1781.45, y = 2545.27, z = 45.80},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_22",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1028191914,
			objCoords  = {x = 1784.65, y = 2550.30, z = 45.98},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -179.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1785.49, y = 2550.32, z = 45.81},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_23",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 262839150,
			objCoords  = {x = 1791.68, y = 2551.34, z = 46.09},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -90.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1791.73, y = 2552.17, z = 45.56},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_24",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1028191914,
			objCoords  = {x = 1780.35, y = 2596.02, z = 50.84},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1779.57, y = 2595.97, z = 50.68},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_25",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1028191914,
			objCoords  = {x = 1781.95, y = 2613.58, z = 46.15},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -89.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1781.99, y = 2614.30, z = 45.97},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_26",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1645000677,
			objCoords  = {x = 1759.91, y = 2614.65, z = 45.93},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -90.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1759.93, y = 2615.26, z = 45.71},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_27",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 262839150,
			objCoords  = {x = 1787.06, y = 2621.04, z = 45.97},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -0.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1786.22, y = 2621.20, z = 45.56},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_28",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1028191914,
			objCoords  = {x = 1766.90, y = 2615.48, z = 46.15},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -0.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1766.24, y = 2615.43, z = 45.97},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_29",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1768.39, y = 2569.32, z = 44.80},
		},
	},
	textCoords = {x = 1768.36, y = 2569.97, z = 45.80},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_30",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1645000677,
			objCoords  = {x = 1766.30, y = 2566.60, z = 45.98},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -0.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1765.77, y = 2566.62, z = 45.70},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_31",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1028191914,
			objCoords  = {x = 1764.96, y = 2608.42, z = 50.73},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 89.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1764.85, y = 2607.73, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_32",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1763.17, y = 2600.22, z = 49.55},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	textCoords = {x = 1763.97, y = 2600.13, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_33",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 871712474,
			objCoords  = {x = 1762.77, y = 2596.51, z = 50.67},
		},
	},
	textCoords = {x = 1762.93, y = 2597.10, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_34",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 871712474,
			objCoords  = {x = 1765.20, y = 2597.70, z = 50.67},
		},
	},
	textCoords = {x = 1765.15, y = 2596.92, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_35",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = false,
	breachable = false,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
  doors = {
	{
		objHash = 871712474,
		objCoords  = {x = 1762.78, y = 2593.57, z = 50.67},
	},

  },
  textCoords = {x = 1762.69, y = 2594.25, z = 50.55},
  authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_36",
  locked = true,
  size = 0.5,
  distance = 1.0,
  ziptie = false,
  breachable = false,
  lockpick = true,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 80.0,
  hackable = false
},

{
  doors = {
	{
		objHash = 871712474,
		objCoords  = {x = 1765.19, y = 2594.76, z = 50.67},
	},

  },
  textCoords = {x = 1765.15, y = 2594.11, z = 50.55},
  authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_37",
  locked = true,
  size = 0.5,
  distance = 1.0,
  ziptie = false,
  breachable = false,
  lockpick = true,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 80.0,
  hackable = false
},

{
  doors = {
	{
		objHash = 871712474,
		objCoords  = {x = 1762.78, y = 2590.63, z = 50.67},
	},

  },
  textCoords = {x = 1762.76, y = 2591.47, z = 50.55},
  authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_38",
  locked = true,
  size = 0.5,
  distance = 1.0,
  ziptie = false,
  breachable = false,
  lockpick = true,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 80.0,
  hackable = false
},

{
  doors = {
	{
		objHash = 871712474,
		objCoords  = {x = 1765.19, y = 2591.82, z = 50.67},
	},

  },
  textCoords = {x = 1765.12, y = 2591.22, z = 50.55},
  authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_39",
  locked = true,
  size = 0.5,
  distance = 1.0,
  ziptie = false,
  breachable = false,
  lockpick = true,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 80.0,
  hackable = false
},

{
	doors = {
		{
			objHash = 871712474,
			objCoords  = {x = 1762.77, y = 2587.68, z = 50.67},
		},

	},
	textCoords = {x = 1762.77, y = 2588.34, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_40",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = false,
	breachable = false,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 871712474,
			objCoords  = {x = 1765.19, y = 2588.87, z = 50.67},
		},
	},
	textCoords = {x = 1765.16, y = 2588.20, z = 50.55},
	authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
	},
	id = "bolingbroke_41",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = false,
	breachable = false,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1645000677,
			objCoords  = {x = 1787.12, y = 2609.73, z = 46.30},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 0.0},
		},

		{
			objHash = 262839150,
			objCoords  = {x = 1784.53, y = 2609.67, z = 46.30},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -179.0},
		},
	},
	textCoords = {x = 1785.80, y = 2609.75, z = 45.97},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_42",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1156020871,
			objCoords  = {x = 1797.76, y = 2596.56, z = 46.39},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 179.0},
		},

	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.5, -- Left/Right
		offsetY = -0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	textCoords = {x = 1796.154, y = 2596.515, z = 46.298},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_43",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1156020871,
			objCoords  = {x = 1798.09, y = 2591.69, z = 46.42},
		},
	},
	textCoords = {x = 1796.419, y = 2591.722, z = 46.317},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_44",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 741314661,
			objCoords  = {x = 1813.7546, y = 2488.91, z = 44.46},
		},

		{
			objHash = 741314661,
			objCoords  = {x = 1808.99, y = 2474.51, z = 44.48},
		},
	},
	textCoords = {x = 1811.22, y = 2481.68, z = 46.961},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_45",
	locked = true,
	size = 0.5,
	distance = 190.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 190.0,
	hackable = true
},

{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1821.17, y = 2476.26, z = 45.69},
		},
	},
	textCoords = {x = 1821.548, y = 2477.228, z = 45.712},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_46",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 741314661,
			objCoords  = {x = 1762.54, y = 2426.51, z = 44.44},
		},

		{
			objHash = 741314661,
			objCoords  = {x = 1749.14, y = 2419.81, z = 44.43},
		},
	},
	textCoords = {x = 1755.68, y = 2423.34, z = 46.848},
	authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_47",
  locked = true,
  size = 0.5,
  distance = 190.0,
  ziptie = false,
  breachable = true,
  lockpick = false,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 190.0,
  hackable = true
},

{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1759.62, y = 2412.84, z = 45.71},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 24.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.15, -- Left/Right
		offsetY = -0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	textCoords = {x = 1760.550, y = 2413.386, z = 45.712},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_48",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 741314661,
			objCoords  = {x = 1667.67, y = 2407.65, z = 44.43},
		},
		{
			objHash = 741314661,
			objCoords  = {x = 1652.98, y = 2409.57, z = 44.44},
		},
	},
	textCoords = {x = 1660.37, y = 2408.76, z = 46.848},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_49",
	locked = true,
	size = 0.5,
	distance = 190.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 190.0,
	hackable = true
},

{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1658.58, y = 2397.72, z = 45.72},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -4.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.15, -- Left/Right
		offsetY = -0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	textCoords = {x = 1659.707, y = 2397.722, z = 45.717},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_50",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 741314661,
			objCoords  = {x = 1558.22, y = 2469.35, z = 44.39},
		},
		{
			objHash = 741314661,
			objCoords  = {x = 1550.93, y = 2482.75, z = 44.39},
		},
	},
	textCoords = {x = 1554.68, y = 2476.19, z = 46.848},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_51",
	locked = true,
	size = 0.5,
	distance = 190.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 190.0,
	hackable = true
},

{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1543.24, y = 2471.29, z = 45.71},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -69.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.15, -- Left/Right
		offsetY = -0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	textCoords = {x = 1543.713, y = 2470.275, z = 45.702},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_52",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
  doors = {
	{
		objHash = 741314661,
		objCoords  = {x = 1546.98, y = 2576.13, z = 44.39},
	},

	{
	  objHash = 741314661,
	  objCoords  = {x = 1547.71, y = 2591.28, z = 44.51},
	},

  },
  textCoords = {x = 1547.55, y = 2583.81, z = 46.848},
  authorizedJobs = {
	{
		name = "police",
		rank = 0,
		specUnit = {}
	},
	{
		name = "nca",
		rank = 1,
		specUnit = {}
	},
	{
		name = "gruppe6",
		rank = 1,
		specUnit = {}
	}
  },
  id = "bolingbroke_53",
  locked = true,
  size = 0.5,
  distance = 190.0,
  ziptie = false,
  breachable = true,
  lockpick = false,
  requiredPoliceOnDuty = 10,
  chanceToNotify = 100,
  allowedToRepairDoor = {},
  frozenDist = 190.0,
  hackable = true
},

{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1537.81, y = 2586.00, z = 45.69},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -84.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.15, -- Left/Right
		offsetY = -0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	textCoords = {x = 1537.906, y = 2584.857, z = 45.696},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_54",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 741314661,
			objCoords  = {x = 1575.72, y = 2667.15, z = 44.51},
		},
		{
			objHash = 741314661,
			objCoords  = {x = 1584.65, y = 2679.75, z = 44.51},
		},
	},
	textCoords = {x = 1580.34, y = 2673.31, z = 46.848},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_55",
	locked = true,
	size = 0.5,
	distance = 190.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 190.0,
	hackable = true
},

{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1572.66, y = 2679.19, z = 45.73},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -125.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.15, -- Left/Right
		offsetY = -0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	textCoords = {x = 1572.094, y = 2678.214, z = 45.733},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_56",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 741314661,
			objCoords  = {x = 1648.41, y = 2741.67, z = 44.45},
		},

		{
			objHash = 741314661,
			objCoords  = {x = 1662.01, y = 2748.70, z = 44.45},
		},
	},
	textCoords = {x = 1655.39, y = 2745.10, z = 46.848},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_57",
	locked = true,
	size = 0.5,
	distance = 190.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 190.0,
	hackable = true
},

{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1651.16, y = 2755.44, z = 45.88},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -172.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.15, -- Left/Right
		offsetY = -0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	textCoords = {x = 1650.132, y = 2754.958, z = 45.854},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_58",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 741314661,
			objCoords  = {x = 1762.17, y = 2752.50, z = 44.44},
		},

		{
			objHash = 741314661,
			objCoords  = {x = 1776.70, y = 2747.15, z = 44.44},
		},
	},
	textCoords = {x = 1769.46, y = 2749.67, z = 46.848},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_59",
	locked = true,
	size = 0.5,
	distance = 190.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 190.0,
	hackable = true
},

{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1773.11, y = 2759.70, z = 45.89},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 163.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.15, -- Left/Right
		offsetY = -0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	textCoords = {x = 1771.992, y = 2759.900, z = 45.885},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_60",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 741314661,
			objCoords  = {x = 1830.13, y = 2703.50, z = 44.45},
		},
		{
			objHash = 741314661,
			objCoords  = {x = 1835.28, y = 2689.10, z = 44.45},
		},
	},
	textCoords = {x = 1832.57, y = 2696.19, z = 46.848},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_61",
	locked = true,
	size = 0.5,
	distance = 190.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 190.0,
	hackable = true
},

{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1845.79, y = 2698.62, z = 45.96},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 94.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.15, -- Left/Right
		offsetY = -0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	textCoords = {x = 1845.598, y = 2699.724, z = 45.949},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_62",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1033001619,
			objCoords  = {x = 1820.77, y = 2620.77, z = 45.95},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 84.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.15, -- Left/Right
		offsetY = -0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	textCoords = {x = 1820.773, y = 2621.901, z = 45.919},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_63",
	locked = true,
	size = 0.5,
	distance = 2.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1787.58, y = 2585.69, z = 44.79},
		},
	},
	textCoords = {x = 1787.497, y = 2586.832, z = 45.79},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_64",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1787.58, y = 2581.76, z = 44.79},
		},
	},
	textCoords = {x = 1787.497, y = 2582.941, z = 45.79},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_65",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1787.58, y = 2577.85, z = 44.79},
		},
	},
	textCoords = {x = 1787.497, y = 2579.022, z = 45.79},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_66",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1787.58, y = 2573.94, z = 44.79},
		},
	},
	textCoords = {x = 1787.582, y = 2575.107, z = 45.79},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_67",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1785.82, y = 2572.01, z = 44.79},
		},
	},
	textCoords = {x = 1784.645, y = 2572.028, z = 45.79},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_68",
	locked = false,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1773.65, y = 2572.05, z = 44.78},
		},
	},
	textCoords = {x = 1772.542, y = 2572.061, z = 45.663},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_69",
	locked = false,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1771.64, y = 2574.012, z = 44.79},
		},
	},
	textCoords = {x = 1771.723, y = 2573.003, z = 45.79},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_69",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1771.65, y = 2578.03, z = 44.79},
		},
	},
	textCoords = {x = 1771.727, y = 2576.892, z = 45.79},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_70",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1771.65, y = 2581.94, z = 44.79},
		},
	},
	textCoords = {x = 1771.726, y = 2580.819, z = 45.79},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_71",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1771.65, y = 2581.94, z = 44.79},
		},
	},
	textCoords = {x = 1771.65, y = 2584.752, z = 45.79},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_72",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1785.82, y = 2600.00, z = 49.55},
		},
	},
	textCoords = {x = 1784.684, y = 2599.922, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_73",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1787.57, y = 2597.56, z = 49.55},
		},
	},
	textCoords = {x = 1787.496, y = 2598.709, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_74",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1787.55, y = 2593.61, z = 49.55},
		},
	},
	textCoords = {x = 1787.475, y = 2594.746, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_75",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1787.57, y = 2589.68, z = 49.55},
		},
	},
	textCoords = {x = 1787.488, y = 2590.804, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_76",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1787.58, y = 2585.73, z = 49.55},
		},
	},
	textCoords = {x = 1787.497, y = 2586.854, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_77",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1787.58, y = 2581.76, z = 49.55},
		},
	},
	textCoords = {x = 1787.500, y = 2582.892, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_78",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1787.58, y = 2577.85, z = 49.55},
		},
	},
	textCoords = {x = 1787.501, y = 2578.987, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_79",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1787.58, y = 2573.94, z = 49.55},
		},

	},
	textCoords = {x = 1787.499, y = 2575.082, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_80",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
	{
		objHash = 430324891,
		objCoords  = {x = 1785.64, y = 2570.06, z = 49.55},
	},

	},
	textCoords = {x = 1786.762, y = 2570.135, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_81",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1781.73, y = 2570.06, z = 49.55},
		},

	},
	textCoords = {x = 1782.856, y = 2570.135, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_82",
	locked = false,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1777.82, y = 2570.06, z = 49.55},
		},

	},
	textCoords = {x = 1778.951, y = 2570.135, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_83",
	locked = false,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1773.91, y = 2570.06, z = 49.55},
		},
	},
	textCoords = {x = 1775.027, y = 2570.135, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_84",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1771.65, y = 2574.12, z = 49.55},
		},
	},
	textCoords = {x = 1771.732, y = 2572.975, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_85",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1771.65, y = 2578.03, z = 49.55},
		},
	},
	textCoords = {x = 1771.731, y = 2576.869, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_86",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1771.65, y = 2581.94, z = 49.55},
		},
	},
	textCoords = {x = 1771.727, y = 2580.822, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_87",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1771.65, y = 2585.91, z = 49.55},
		},
	},
	textCoords = {x = 1771.727, y = 2584.756, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_88",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1771.73, y = 2589.86, z = 49.55},
		},
	},
	textCoords = {x = 1771.727, y = 2588.707, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_89",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1771.72, y = 2593.78, z = 49.55},
		},
	},
	textCoords = {x = 1771.727, y = 2592.634, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_90",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1771.73, y = 2597.73, z = 49.55},
		},
	},
	textCoords = {x = 1771.727, y = 2596.596, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_91",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 430324891,
			objCoords  = {x = 1773.65, y = 2599.73, z = 49.55},
		},
	},
	textCoords = {x = 1772.515, y = 2599.915, z = 50.55},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_92",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1762.32, y = 2560.11, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 90.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1762.3551025391, y = 2562.0258789063, z = 45.820579528809},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_93",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1760.23, y = 2556.80, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -64.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1761.0827636719, y = 2555.056640625, z = 45.827156066895},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_96",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1770.55, y = 2552.69, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -89.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1770.5198974609, y = 2550.7529296875, z = 45.814811706543},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_97",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1725.78, y = 2557.86, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -179.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1723.8751220703, y = 2557.8273925781, z = 45.872406005859},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_98",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1741.71, y = 2527.97, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -151.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1739.9875488281, y = 2527.0832519531, z = 45.849815368652},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_99",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1682.77, y = 2558.08, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 178.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1680.802734375, y = 2558.0439453125, z = 45.875579833984},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_100",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1644.88, y = 2512.80, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 138.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1643.4470214844, y = 2514.0952148438, z = 45.839519500732},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_101",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1744.32, y = 2563.60, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -89.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1744.3582763672, y = 2561.6374511719, z = 45.856174468994},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_102",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1708.64, y = 2566.07, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -89.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1708.677734375, y = 2564.103515625, z = 45.840480804443},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_103",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1681.43, y = 2566.01, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -89.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1681.4630126953, y = 2564.0415039063, z = 45.868915557861},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_104",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1616.63, y = 2575.44, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -40.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1618.0550537109, y = 2574.1101074219, z = 45.863967895508},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_105",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1616.72, y = 2532.00, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 46.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1618.0494384766, y = 2533.3442382813, z = 45.834167480469},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_106",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1620.73, y = 2519.11, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 5.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1622.6512451172, y = 2519.3500976563, z = 45.881866455078},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_107",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1654.27, y = 2491.30, z = 45.90},
		},
	},
	textCoords = {x = 1654.2056884766, y = 2493.2163085938, z = 45.824405670166},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_108",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1671.15, y = 2488.11, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 46.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1672.4583740234, y = 2489.5141601563, z = 45.84224319458},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_109",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1713.29, y = 2489.56, z = 45.90},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = -46.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1714.66015625, y = 2488.1875, z = 45.83825302124},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_110",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1726.13, y = 2507.40, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 75.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1726.6330566406, y = 2509.2292480469, z = 45.831386566162},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_111",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1763.72, y = 2528.91, z = 45.91},
			objCloseState = {pitch = 0.0, roll = -0.0,yaw = 166.0},
		},
	},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.9, -- Left/Right
		offsetY = -0.1, -- Forward/Backward
		offsetZ = 0.1 -- Up/Down
	},
	textCoords = {x = 1761.8907470703, y = 2529.5073242188, z = 45.828266143799},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_112",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 80.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 741314661,
			objCoords  = {x = 1618.50, y = 2581.43, z = 44.58},
		},
	},
	textCoords = {x = 1618.5010986328, y = 2581.0458984375, z = 46.574775695801},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_113",
	locked = true,
	size = 0.5,
	distance = 190.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 190.0,
	hackable = true
},

{
	doors = {
		{
			objHash = 91564889,
			objCoords  = {x = 1730.95, y = 2541.70, z = 45.91},
		},
	},
	textCoords = {x = 1731.851, y = 2540.068, z = 45.861},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "bolingbroke_114",
	locked = true,
	size = 0.5,
	distance = 190.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 100,
	allowedToRepairDoor = {},
	frozenDist = 190.0,
	hackable = false
  },

--[[LOST MC]]--

{
	doors = {
		{
				objHash = 1544229216,
				objCoords	= {x = 991.77, y = -116.50, z = 74.37},
		},

	},
	textCoords = {x = 991.792, y = -116.475, z = 74.030},
	authorizedJobs = {
		{
			name = "lost",
			rank = 0,
			specUnit = {}
		}
	},
	id = "lostMCIntWep_00",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
				objHash = -197537718,
				objCoords	= {x = 982.39, y = -125.37, z = 74.99},
		},

	},
	textCoords = {x = 982.308, y = -125.367, z = 74.297},
	authorizedJobs = {
		{
			name = "lost",
			rank = 0,
			specUnit = {}
		}
	},
	id = "lostMCExtGar_00",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
				objHash = -710818483,
				objCoords	= {x = 991.52557373047, y = -133.32926940918, z = 74.061248779297},
				objCloseState = {pitch = 0.0, roll = 0.0,yaw = 150.0},
		},

	},
	textCoords = {x = 991.52557373047, y = -133.32926940918, z = 74.061248779297},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "lost",
			rank = 0,
			specUnit = {}
		}
	},
	id = "lostMC_01",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
				objHash = -710818483,
				objCoords	= {x = 995.07409667969, y = -120.31466674805, z = 74.061332702637},
				objCloseState = {pitch = 0.0, roll = 0.0,yaw = 150.0},
		},

	},
	textCoords = {x = 995.07409667969, y = -120.31466674805, z = 74.061332702637},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "lost",
			rank = 0,
			specUnit = {}
		}
	},
	id = "lostMC_02",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
				objHash = -710818483,
				objCoords	= {x = 1003.2656860352, y = -125.04386901855, z = 74.070365905762},
				objCloseState = {pitch = 0.0, roll = 0.0,yaw = 150.0},
		},

	},
	textCoords = {x = 1003.2656860352, y = -125.04386901855, z = 74.070365905762},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "lost",
			rank = 0,
			specUnit = {}
		}
	},
	id = "lostMC_03",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
				objHash = -547305886,
				objCoords	= {x = 1980.6058349609, y = 3050.1020507813, z = 50.515506744385},
				objCloseState = {pitch = 0.0, roll = 0.0,yaw = -31.0},
		},

	},
	textCoords = {x = 1980.6058349609, y = 3050.1020507813, z = 50.515506744385},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.2 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "lost",
			rank = 0,
			specUnit = {}
		}
	},
	id = "lostMC_05",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
				objHash = -930593859,
				objCoords	= {x = 960.1044921875, y = -140.12829589844, z = 74.485656738281},
		},

	},
	textCoords = {x = 960.1044921875, y = -140.12829589844, z = 74.485656738281},
	authorizedJobs = {
		{
			name = "lost",
			rank = 0,
			specUnit = {}
		}
	},
	id = "lostMC_06",
	locked = true,
	size = 0.5,
	distance = 110.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
				objHash = 19193616,
				objCoords	= {x = 3525.2084960938, y = 3702.2854003906, z = 20.99168586731},
				objCloseState = {pitch = 0.0, roll = 0.0,yaw = 170.0},
		},

	},
	textCoords = {x = 3525.2084960938, y = 3702.2854003906, z = 20.99168586731},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.4, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "lost",
			rank = 0,
			specUnit = {}
		}
	},
	id = "lostMC_07",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

-- FightClub

{
	doors = {
		{
				objHash = -249203650,
				objCoords	= {x = 928.92169189453, y = -1787.7126464844, z = 30.749141693115},
				objCloseState = {pitch = 0.0, roll = 0.0,yaw = -5.0},
		},

	},
	textCoords = {x = 928.92169189453, y = -1787.7126464844, z = 30.749141693115},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.4, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "lost",
			rank = 0,
			specUnit = {}
		}
	},
	id = "lostMC_09",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
				objHash = 2140720422,
				objCoords	= {x = 919.11450195313, y = -1809.8922119141, z = 24.967535018921},
				objCloseState = {pitch = 0.0, roll = 0.0,yaw = 150.0},
		},

		{
			objHash = 2140720422,
			objCoords	= {x = 917.49542236328, y = -1808.9853515625, z = 24.967542648315},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -29.0},
		},

	},
	textCoords = {x = 918.281, y = -1809.396, z = 25.156},
	authorizedJobs = {
		{
			name = "lost",
			rank = 0,
			specUnit = {}
		}
	},
	id = "lostMC_10",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},


{
	doors = {
		{
				objHash = -249203650,
				objCoords	= {x = 924.14813232422, y = -1807.2702636719, z = 24.967428207397},
				objCloseState = {pitch = 0.0, roll = 0.0,yaw = -4.0},
		},

	},
	textCoords = {x = 924.14813232422, y = -1807.2702636719, z = 24.967428207397},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.4, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "lost",
			rank = 0,
			specUnit = {}
		}
	},
	id = "lostMC_11",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
				objHash = 190770132,
				objCoords	= {x = 981.59313964844, y = -102.78897857666, z = 74.845123291016},
				objCloseState = {pitch = 0.0, roll = 0.0,yaw = 42.0},
		},

	},
	textCoords = {x = 981.59313964844, y = -102.78897857666, z = 74.845123291016},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "lost",
			rank = 0,
			specUnit = {}
		}
	},
	id = "lostMC_12",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

---- Vespucci Police/NCA building

{
	doors = {
		{
			objHash = -350181704,
			objCoords	= {x = -1112.7784423828, y = -829.05383300781, z = 26.859033584595},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 37.0},
		},

		{
			objHash = -350181704,
			objCoords	= {x = -1113.7424316406, y = -830.00927734375, z = 26.834646224976},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -142.0},
		},

	},
	textCoords = {x = -1113.2808837891, y = -829.56610107422, z = 26.827449798584},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_06",
	locked = true,
	size = 0.5,
	distance = 5.4,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -350181704,
			objCoords = {x = -1112.5367431641, y = -847.43609619141, z = 13.483416557312},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.0},
		},

		{
			objHash = -350181704,
			objCoords = {x = -1111.5297851563, y = -848.51843261719, z = 13.483431816101},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.0},
		},

	},
	textCoords = {x = -1111.9729003906, y = -847.96368408203, z = 13.483432769775},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_09",
	locked = true,
	size = 0.5,
	distance = 5.4,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},


{
	doors = {
		{
			objHash = -2023754432,
			objCoords = {x = -1058.2452392578, y = -840.29998779297, z = 5.1101655960083},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 37.0},
		},

		{
			objHash = -2023754432,
			objCoords = {x = -1057.2806396484, y = -839.52142333984, z = 5.1104331016541},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -142.0},
		},

	},
	textCoords = {x = -1057.7526855469, y = -840.02862548828, z = 5.0339484214783},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_10",
	locked = true,
	size = 0.5,
	distance = 5.4,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},


{
	doors = {
		{
			objHash = -1255368438,
			objCoords = {x = -1098.2365722656, y = -836.07470703125, z = 19.001533508301},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.0},
		},

		{
			objHash = -1255368438,
			objCoords = {x = -1098.8765869141, y = -835.12573242188, z = 19.001502990723},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.0},
		},

	},
	textCoords = {x = -1098.6573486328, y = -835.60589599609, z = 19.001546859741},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_13",
	locked = true,
	size = 0.5,
	distance = 5.4,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1255368438,
			objCoords = {x = -1094.2999267578, y = -844.82360839844, z = 19.001457214355},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.0},
		},

		{
			objHash = -1255368438,
			objCoords = {x = -1095.1195068359, y = -844.05737304688, z = 19.001457214355},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.0},
		},

	},
	textCoords = {x = -1094.6978759766, y = -844.54272460938, z = 19.001457214355},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_14",
	locked = true,
	size = 0.5,
	distance = 5.4,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1255368438,
			objCoords = {x = -1094.4351806641, y = -843.52709960938, z = 34.360893249512},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.0},
		},

		{
			objHash = -1255368438,
			objCoords = {x = -1093.6976318359, y = -844.62115478516, z = 34.360904693604},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.0},
		},

	},
	textCoords = {x = -1093.9533691406, y = -843.82788085938, z = 34.360904693604},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_15",
	locked = true,
	size = 0.5,
	distance = 5.4,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1828187002,
			objCoords = {x = -1072.7902832031, y = -850.77941894531, z = 4.9602279663086},
		},

	},
	textCoords = {x = -1072.7902832031, y = -850.77941894531, z = 4.9602279663086},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_16",
	locked = true,
	size = 0.5,
	distance = 300.0,
	ziptie = false,
	breachable = false,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 300.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1828187002,
			objCoords = {x = -1119.32, y = -838.45, z = 14.39},
		},

	},
	textCoords = {x = -1119.2086181641, y = -838.59381103516, z = 13.418855667114},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_17",
	locked = true,
	size = 0.5,
	distance = 200.0,
	ziptie = true,
	breachable = false,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 200.0,
	hackable = false
},

-- Hunting Ranch Door

{
	doors = {
		{
			objHash = -868087669,
			objCoords = {x = 381.26, y = 795.56, z = 187.83},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 0.0},
		},

	},
	textCoords = {x = 380.13726806641, y = 795.56811523438, z = 187.80725097656},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "ranger",
			rank = 1,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "ranger_00",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

--- Cell Doors

{
	doors = {
		{
			objHash = 631614199,
			objCoords = {x = -1087.2075195313, y = -829.38409423828, z = 5.4796867370605},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -142.4026},
		},

	},
	textCoords = {x = -1087.2075195313, y = -829.38409423828, z = 5.4796867370605},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_20",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 631614199,
			objCoords = {x = -1086.2585449219, y = -827.20886230469, z = 5.4797787666321},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},

	},
	textCoords = {x = -1086.2585449219, y = -827.20886230469, z = 5.4797787666321},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_21",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 631614199,
			objCoords = {x = -1091.6026611328, y = -826.59307861328, z = 5.4799327850342},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},

	},
	textCoords = {x = -1091.6026611328, y = -826.59307861328, z = 5.4799327850342},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_22",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 631614199,
			objCoords = {x = -1088.7221679688, y = -824.12292480469, z = 5.4799661636353},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},

	},
	textCoords = {x = -1088.7221679688, y = -824.12292480469, z = 5.4799661636353},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_23",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 631614199,
			objCoords = {x = -1094.0462646484, y = -823.22375488281, z = 5.4799418449402},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},

	},
	textCoords = {x = -1094.0462646484, y = -823.22375488281, z = 5.4799418449402},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_24",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 631614199,
			objCoords = {x = -1091.1663818359, y = -820.96502685547, z = 5.4799695014954},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},

	},
	textCoords = {x = -1091.1663818359, y = -820.96502685547, z = 5.4799695014954},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_25",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 631614199,
			objCoords = {x = -1096.4018554688, y = -820.16052246094, z = 5.4799394607544},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},

	},
	textCoords = {x = -1096.4018554688, y = -820.16052246094, z = 5.4799394607544},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_26",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -147325430,
			objCoords = {x = -1089.9732666016, y = -840.97698974609, z = 37.763534545898},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.4026},
		},

	},
	textCoords = {x = -1089.9732666016, y = -840.97698974609, z = 37.763534545898},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_27",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1255368438,
			objCoords = {x = -1094.4718017578, y = -843.64764404297, z = 30.756948471069},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.4026},
		},

		{
			objHash = -1255368438,
			objCoords = {x = -1093.6961669922, y = -844.38684082031, z = 30.756980895996},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},

	},
	textCoords = {x = -1094.0634765625, y = -844.044921875, z = 30.756956100464},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_28",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1255368438,
			objCoords = {x = -1094.4653320313, y = -843.66589355469, z = 26.827417373657},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.4026},
		},

		{
			objHash = -1255368438,
			objCoords = {x = -1093.7083740234, y = -844.41888427734, z = 26.827417373657},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},

	},
	textCoords = {x = -1094.2783203125, y = -843.85186767578, z = 26.827451705933},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_29",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -147325430,
			objCoords = {x = -1077.24609375, y = -830.14422607422, z = 27.036386489868},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 37.4026},
		},

	},
	textCoords = {x = -1077.24609375, y = -830.14422607422, z = 27.036386489868},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_30",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -147325430,
			objCoords = {x = -1077.2574462891, y = -830.16644287109, z = 19.035827636719},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 37.4026},
		},

	},
	textCoords = {x = -1077.2574462891, y = -830.16644287109, z = 19.035827636719},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_31",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -147325430,
			objCoords = {x = -1077.2769775391, y = -830.09497070313, z = 15.036387443542},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 37.4026},
		},

	},
	textCoords = {x = -1077.2769775391, y = -830.09497070313, z = 15.036387443542},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_32",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -147325430,
			objCoords = {x = -1077.2259521484, y = -830.28961181641, z = 11.037841796875},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 37.4026},
		},

	},
	textCoords = {x = -1077.2259521484, y = -830.28961181641, z = 11.037841796875},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_32",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1255368438,
			objCoords = {x = -1079.0827636719, y = -825.80041503906, z = 11.037040710449},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -143.4026},
		},

		{
			objHash = -1255368438,
			objCoords = {x = -1078.09375, y = -825.10949707031, z = 11.037259101868},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 37.4026},
		},

	},
	textCoords = {x = -1078.8045654297, y = -825.408203125, z = 11.037015914917},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_33",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -147325430,
			objCoords = {x = -1071.2506103516, y = -833.39392089844, z = 5.4797334671021},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.4026},
		},

	},
	textCoords = {x = -1071.2506103516, y = -833.39392089844, z = 5.4797334671021},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_34",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 631614199,
			objCoords = {x = -1073.0572509766, y = -826.90191650391, z = 5.47971153259281},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -142.4026},
		},

	},
	textCoords = {x = -1073.0572509766, y = -826.90191650391, z = 5.4797115325928},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_35",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -2023754432,
			objCoords = {x = -1065.7244873047, y = -827.64031982422, z = 5.4798855781555},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},

		{
			objHash = -2023754432,
			objCoords = {x = -1064.8216552734, y = -828.65539550781, z = 5.479896068573},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.4026},
		},

	},
	textCoords = {x = -1065.2481689453, y = -827.97839355469, z = 5.4798827171326},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_36",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},


{
	doors = {
		{
			objHash = -2023754432,
			objCoords = {x = -1075.0963134766, y = -822.75506591797, z = 5.4799180030823},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 37.4026},
		},

		{
			objHash = -2023754432,
			objCoords = {x = -1074.0621337891, y = -821.83782958984, z = 5.4798579216003},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -142.4026},
		},


	},
	textCoords = {x = -1074.6031494141, y = -822.24920654297, z = 5.4798736572266},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_37",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -2023754432,
			objCoords = {x = -1093.6799316406, y = -816.82189941406, z = 5.4799942970276},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},

		{
			objHash = -2023754432,
			objCoords = {x = -1092.8823242188, y = -817.91638183594, z = 5.4799656867981},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.4026},
		},


	},
	textCoords = {x = -1093.2570800781, y = -817.16296386719, z = 5.47993516922},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_38",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -2023754432,
			objCoords = {x = -1091.1334228516, y = -835.59558105469, z = 5.479781627655},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.4026},
		},

		{
			objHash = -2023754432,
			objCoords = {x = -1091.9283447266, y = -834.3623046875, z = 5.4798774719238},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},


	},
	textCoords = {x = -1091.6921386719, y = -835.05541992188, z = 5.4797525405884},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_39",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -147325430,
			objCoords = {x = -1092.7742919922, y = -842.59625244141, z = 4.8770937919617},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.4026},
		},

	},
	textCoords = {x = -1092.7742919922, y = -842.59625244141, z = 4.8770937919617},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_40",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -2023754432,
			objCoords = {x = -1090.62109375, y = -847.30999755859, z = 4.8840832710266},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},

		{
			objHash = -2023754432,
			objCoords = {x = -1089.8504638672, y = -848.21038818359, z = 4.8841834068298},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.4026},
		},

	},
	textCoords = {x = -1090.2102050781, y = -847.69360351563, z = 4.8841114044189},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_41",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -2023754432,
			objCoords = {x = -1101.6995849609, y = -846.64947509766, z = 13.685926437378},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -142.4026},
			
		},

		{
			objHash = -2023754432,
			objCoords = {x = -1102.6109619141, y = -847.44879150391, z = 13.68569278717},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 37.4026},
		},

	},
	textCoords = {x = -1102.0498046875, y = -846.98736572266, z = 13.685855865479},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_42",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 569833973,
			objCoords = {x = -1061.5424804688, y = -878.19067382813, z = 5.0546059608459},
		},

	},
	textCoords = {x = -1061.5424804688, y = -878.19067382813, z = 6.0546059608459},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "vespucci_43",
	locked = true,
	size = 0.5,
	distance = 400.0,
	ziptie = false,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 400.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -655468553,
			objCoords = {x = -1056.5267333984, y = -875.04516601563, z = 5.141637802124},
		},

	},
	textCoords = {x = -1056.5267333984, y = -875.04516601563, z = 6.141637802124},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "vespucci_44",
	locked = true,
	size = 0.5,
	distance = 400.0,
	ziptie = false,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 400.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -2125423493,
			objCoords = {x = -1144.9201660156, y = -846.38342285156, z = 14.389140129089},
		},

	},
	textCoords = {x = -1144.9201660156, y = -846.38342285156, z = 14.389140129089},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	id = "vespucci_45",
	locked = true,
	size = 0.5,
	distance = 300.0,
	ziptie = false,
	breachable = false,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 300.0,
	hackable = false
},
----------
{
	doors = {
		{
			objHash = -1255368438,
			objCoords = {x = -1094.4641113281, y = -843.68225097656, z = 23.038469314575},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.4026},
		},

		{
			objHash = -1255368438,
			objCoords = {x = -1093.8564453125, y = -844.45806884766, z = 23.038486480713},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -52.4026},
		},


	},
	textCoords = {x = -1094.1182861328, y = -844.08209228516, z = 23.038469314575},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_46",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -147325430,
			objCoords = {x = -1091.0234375, y = -841.31188964844, z = 14.362639427185},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 127.4026},
		},

	},
	textCoords = {x = -1091.0234375, y = -841.31188964844, z = 14.362639427185},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_47",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -147325430,
			objCoords = {x = -1091.1872558594, y = -841.38781738281, z = 10.276664733887},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 131.4026},
		},

	},
	textCoords = {x = -1091.1872558594, y = -841.38781738281, z = 10.276664733887},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_48",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},


{
	doors = {
		{
			objHash = -2023754432,
			objCoords = {x = -1101.2238769531, y = -827.07525634766, z = 14.284038543701},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -142.889},
		},

	},
	textCoords = {x = -1101.2238769531, y = -827.07525634766, z = 14.284038543701},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_49",
	locked = true,
	size = 0.5,
	distance = 4.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -147325430,
			objCoords = {x = -1077.2229003906, y = -830.23583984375, z = 15.03638458252},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 37.42569},
		},

	},
	textCoords = {x = -1077.2229003906, y = -830.23583984375, z = 15.03638458252},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	id = "vespucci_50",
	locked = true,
	size = 0.5,
	distance = 8.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

--- Substation
{
	doors = {
		{
			objHash = -1023447729,
			objCoords = {x = 735.71826171875, y = 133.05603027344, z = 80.737907409668},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 60.0},
		},

	},
	textCoords = {x = 735.71826171875, y = 133.05603027344, z = 80.737907409668},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {},
	id = "transformer_1",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = false,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 100,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	hackable = false
},

--- Lifeinvader
{
	doors = {
		{
			objHash = -1679881977,
			objCoords = {x = -1083.62, y = -260.42, z = 38.19},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 27.4915},
		},

		{
			objHash = -1045015371,
			objCoords = {x = -1080.97, y = -259.02, z = 38.19},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 28.4915},
		},

	},
	textCoords = {x = -1082.36, y = -259.88, z = 37.81},
	authorizedJobs = {},
	id = "LifeInvader_1",
	locked = false,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1104171198,
			objCoords = {x = -1045.12, y = -232.00, z = 39.44},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 117.4915},
		},

		{
			objHash = -1425071302,
			objCoords = {x = -1046.52, y = -229.36, z = 39.44},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 117.4915},
		},

	},
	textCoords = {x = -1046.010, y = -230.74, z = 39.01},
	authorizedJobs = {},
	id = "LifeInvader_2",
	locked = false,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -495720969,
			objCoords = {x = -1055.96, y = -236.43, z = 44.17},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -152.5},
		},

	},
	textCoords = {x = -1055.17, y = -236.20, z = 44.02},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {},
	id = "LifeInvader_3",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 50,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -340230128,
			objCoords = {x = -1042.52, y = -240.69, z = 38.12},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 27.4884},
		},

	},
	textCoords = {x = -1041.81, y = -240.57, z = 37.96},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {},
	id = "LifeInvader_4",
	locked = false,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 50,
	allowedToRepairDoor = {"police", "nca"},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 988364535,
			objCoords = {x = -1864.21, y = 2061.27, z = 141.15},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -90.0},
		},

		{
			objHash = -1141522158,
			objCoords = {x = -1864.20, y = 2059.90, z = 141.15},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -90.0},
		},

	},
	textCoords = {x = -1864.2017822266, y = 2060.4064941406, z = 141.20643615723},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 2,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_int0", -- fridge
	locked = true,
	size = 0.5,
	distance = 0.5,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- noble manor
	doors = {
		{
			objHash = 1077118233,
			objCoords = {x = -1890.23, y = 2052.24, z = 141.31},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 160.0},
		},

		{
			objHash = 1077118233,
			objCoords = {x = -1887.90, y = 2051.39, z = 141.31},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -20.0},
		},

	},
	textCoords = {x = -1889.102, y = 2051.777, z = 141.177},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_ext00",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1077118233,
			objCoords = {x = -1887.53, y = 2051.23, z = 141.31},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 160.0},
		},

		{
			objHash = 1077118233,
			objCoords = {x = -1885.21, y = 2050.38, z = 141.31},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -20.0},
		},

	},
	textCoords = {x = -1886.405, y = 2050.772, z = 141.239},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_ext01",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1843224684,
			objCoords = {x = -1912.10, y = 2075.56, z = 140.91},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 140.0},
		},

		{
			objHash = 1843224684,
			objCoords = {x = -1910.21, y = 2073.97, z = -40.91},
		},

	},
	textCoords = {x = -1911.212, y = 2074.834, z = 141.002},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_ext02",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1843224684,
			objCoords = {x = -1909.62, y = 2073.47, z = 140.91},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 140.0},
		},

		{
			objHash = 1843224684,
			objCoords = {x = -1907.73, y = 2071.88, z = 140.91},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -40.0},
		},

	},
	textCoords = {x = -1908.610, y = 2072.578, z = 141.002},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_ext03",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1843224684,
			objCoords = {x = -1910.20, y = 2080.68, z = 140.91},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 50.0},
		},

		{
			objHash = 1843224684,
			objCoords = {x = -1911.81, y = 2078.79, z = 140.91},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -130.0},
		},

	},
	textCoords = {x = -1910.948, y = 2079.851, z = 141.036},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_ext04",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1843224684,
			objCoords = {x = -1905.99, y = 2085.63, z = 140.91},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 140.0},
		},

		{
			objHash = 1843224684,
			objCoords = {x = -1907.60, y = 2083.74, z = 140.91},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -130.0},
		},

	},
	textCoords = {x = -1906.8843994141, y = 2084.6186523438, z = 141.04238891602},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_ext05",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1843224684,
			objCoords = {x = -1900.99, y = 2084.95, z = 140.91},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -40.0},
		},

		{
			objHash = 1843224684,
			objCoords = {x = -1902.88, y = 2086.54, z = 140.91},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 140.0},
		},

	},
	textCoords = {x = -1901.9916992188, y = 2085.8234863281, z = 141.07202148438},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_ext06",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1843224684,
			objCoords = {x = -1898.51, y = 2082.85, z = 140.91},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -40.0},
		},

		{
			objHash = 1843224684,
			objCoords = {x = -1900.41, y = 2084.45, z = 140.91},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 140.0},
		},

	},
	textCoords = {x = -1899.5433349609, y = 2083.7487792969, z = 141.06129455566},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_ext07",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1077118233,
			objCoords = {x = -1892.83, y = 2074.38, z = 141.31},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -40.0},
		},

		{
			objHash = 1077118233,
			objCoords = {x = -1894.73, y = 2075.97, z = 141.31},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 140.0},
		},

	},
	textCoords = {x = -1893.811, y = 2075.166, z = 141.31},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_ext08",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1077118233,
			objCoords = {x = -1884.92, y = 2073.46, z = 141.31},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -20.0},
		},

		{
			objHash = 1077118233,
			objCoords = {x = -1887.24, y = 2074.31, z = 141.31},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 160.0},
		},

	},
	textCoords = {x = -1886.0805664063, y = 2073.9123535156, z = 141.23324584961},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_ext09",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1077118233,
			objCoords = {x = -1873.29, y = 2069.22, z = 141.31},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -20.0},
		},

		{
			objHash = 1077118233,
			objCoords = {x = -1875.61, y = 2070.07, z = 141.31},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 160.0},
		},

	},
	textCoords = {x = -1874.454, y = 2069.620, z = 141.31},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_ext10",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1077118233,
			objCoords = {x = -1861.69, y = 2054.12, z = 141.35},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 180.0},
		},

		{
			objHash = 1077118233,
			objCoords = {x = -1859.21, y = 2054.12, z = 141.35},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 0.0},
		},

	},
	textCoords = {x = -1860.462, y = 2054.075, z = 141.00881958008},
	authorizedJobs = {
		{
			name = 9, -- noble,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "noble_Manor_ext11",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = 262671971,
		objCoords = {x = 1407.55, y = 1128.33, z = 114.49},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = -180.0},
	},
	},
	textCoords = {x = 1406.573, y = 1128.160, z = 114.581},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.0, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
	{
		name = 7, -- morrisons
		rank = 1,
		specUnit = {},
		type = "gang"
	}
	},
	id = "Morrison_Manor_ext00",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = 1504256620,
		objCoords = {x = 1395.92, y = 1142.90, z = 114.79},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = -90.0},
	},

	{
		objHash = 262671971,
		objCoords = {x = 1395.92, y = 1140.70, z = 114.79},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 90.0},
	},
	},
	textCoords = {x = 1395.870, y = 1141.808, z = 114.853},
	authorizedJobs = {
	{
		name = 7, -- morrisons
		rank = 1,
		specUnit = {},
		type = "gang"
	}
	},
	id = "Morrison_Manor_ext01",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = -52575179,
		objCoords = {x = 1390.67, y = 1133.32, z = 114.48},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 90.0},
	},

	{
		objHash = -1032171637,
		objCoords = {x = 1390.67, y = 1131.12, z = 114.48},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 90.0},
	},
	},
	textCoords = {x = 1390.624, y = 1132.206, z = 114.478},
	authorizedJobs = {
	{
		name = 7, -- morrisons
		rank = 1,
		specUnit = {},
		type = "gang"
	}
	},
	id = "Morrison_Manor_ext02",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = -52575179,
		objCoords = {x = 1399.39, y = 1128.31, z = 114.48},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 180.0},
	},

	{
		objHash = -1032171637,
		objCoords = {x = 1401.59, y = 1128.31, z = 114.48},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 180.0},
	},
	},
	textCoords = {x = 1400.489, y = 1128.275, z = 114.453},
	authorizedJobs = {
	{
		name = 7, -- morrisons
		rank = 1,
		specUnit = {},
		type = "gang"
	}
	},
	id = "Morrison_Manor_ext03",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = -52575179,
		objCoords = {x = 1390.42, y = 1163.44, z = 114.49},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 90.0},
	},

	{
		objHash = -1032171637,
		objCoords = {x = 1390.41, y = 1161.24, z = 114.49},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 90.0},
	},
	},
	textCoords = {x = 1390.380, y = 1162.346, z = 114.492},
	authorizedJobs = {
	{
		name = 7, -- morrisons
		rank = 1,
		specUnit = {},
		type = "gang"
	}
	},
	id = "Morrison_Manor_ext04",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = -52575179,
		objCoords = {x = 1408.17, y = 1165.83, z = 114.49},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 90.0},
	},

	{
		objHash = -1032171637,
		objCoords = {x = 1408.17, y = 1163.63, z = 114.49},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 90.0},
	},
	},
	textCoords = {x = 1408.204, y = 1164.726, z = 114.397},
	authorizedJobs = {
	{
		name = 7, -- morrisons
		rank = 1,
		specUnit = {},
		type = "gang"
	}
	},
	id = "Morrison_Manor_ext05",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = -52575179,
		objCoords = {x = 1408.17, y = 1161.15, z = 114.49},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 90.0},
	},

	{
		objHash = -1032171637,
		objCoords = {x = 1408.16, y = 1158.96, z = 114.49},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 90.0},
	},
	},
	textCoords = {x = 1408.204, y = 1160.044, z = 114.397},
	authorizedJobs = {
	{
		name = 7, -- morrisons
		rank = 1,
		specUnit = {},
		type = "gang"
	}
	},
	id = "Morrison_Manor_ext06",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = -626684119,
		objCoords = {x = 99.08, y = -1293.70, z = 29.42},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 30.0},
	},

	},
	textCoords = {x = 100.129, y = -1293.155, z = 29.353},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.2 -- Up/Down
	},
	authorizedJobs = {
	{
		name = 7, -- morrisons
		rank = 1,
		specUnit = {},
		type = "gang"
	}
	},
	id = "Vinilla_Unicorn_int00",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = 668467214,
		objCoords = {x = 96.09, y = -1284.85, z = 29.44},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = -150.0},
	},

	},
	textCoords = {x = 95.088, y = -1285.465, z = 29.381},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.2 -- Up/Down
	},
	authorizedJobs = {
	{
		name = 7, -- morrisons
		rank = 1,
		specUnit = {},
		type = "gang"
	}
	},
	id = "Vinilla_Unicorn_int01",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

--Bank Doors--

{
	doors = {
	{
		objHash = 73386408,
		objCoords = {x = 152.06, y = -1038.12, z = 29.72},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 160.0},
	},

	{
		objHash = -1152174184,
		objCoords = {x = 149.63, y =-1037.23, z = 29.72},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 160.0},
	},
	},
	textCoords = {x = 150.864, y = -1037.624, z = 29.602},
	authorizedJobs = {},
	id = "Bank_01",
	locked = false,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = 73386408,
		objCoords = {x = -1213.07, y = -327.35, z = 38.13},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = -153.0},
	},

	{
		objHash = -1152174184,
		objCoords = {x = -1215.39, y = -328.52, z = 38.13},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = -153.0},
	},
	},
	textCoords = {x = -1214.266, y = -327.893, z = 37.983},
	authorizedJobs = {},
	id = "Bank_02",
	locked = false,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = 73386408,
		objCoords = {x = 1173.90, y = 2703.61, z = 38.44},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 0.0},
	},

	{
		objHash = -1152174184,
		objCoords = {x = 1176.49, y = 2703.61, z = 38.44},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 0.0},
	},
	},
	textCoords = {x = 1175.197, y = 2703.556, z = 38.311},
	authorizedJobs = {},
	id = "Bank_03",
	locked = false,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = -353187150,
		objCoords = {x = -111.48, y = 6463.94, z = 31.98},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = -45.0},
	},

	{
		objHash = -1152174184,
		objCoords = {x = -109.65, y = 6462.11, z = 31.98},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = -45.0},
	},
	},
	textCoords = {x = -110.668, y = 6462.954, z = 31.889},
	authorizedJobs = {},
	id = "Bank_04",
	locked = false,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 10,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
	{
		objHash = -1184592117,
		objCoords = {x = -108.91, y = 6469.10, z = 31.91},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 45.0},
	},
	},
	textCoords = {x = -109.616, y = 6468.353, z = 31.704},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = -0.2 -- Up/Down
	},
	authorizedJobs = {},
	id = "Bank_05",
	locked = true,
	size = 0.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},


 -- weazel
{
	doors = {
	{
		objHash = 300848144,
		objCoords = {x = -587.43, y = -928.36, z = 18.57},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 0.0},
	},
	{
		objHash = 300848144,
		objCoords = {x = -590.03, y = -928.36, z = 18.57},
		objCloseState = {pitch = 0.0, roll = 0.0,yaw = 180.0},
	},
	},
	textCoords = {x = -588.703, y = -928.303, z = 18.485},
	authorizedJobs = {
	{
		name = "weazel",
		rank = 1,
		specUnit = {}
	}
	},
	id = "weazel_int_00",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 300848144,
			objCoords = {x = -586.93, y = -929.84, z = 24.02},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 90.0},
		},
		{
			objHash = 300848144,
			objCoords = {x = -586.90, y = -932.44, z = 24.02},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -90.0},
		},
	},
	textCoords = {x = -586.971, y = -931.144, z = 23.934},
	authorizedJobs = {
	{
		name = "weazel",
		rank = 1,
		specUnit = {}
	}
	},
	id = "weazel_int_01",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1808123841,
			objCoords = {x = -573.48, y = -939.58, z = 24.03},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 180.0},
		},
		{
			objHash = 1808123841,
			objCoords = {x = -576.08, y = -939.57, z = 24.03},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 0.0},
		},
	},
	textCoords = {x = -574.772, y = -939.519, z = 23.969},
	authorizedJobs = {
	{
		name = "weazel",
		rank = 1,
		specUnit = {}
	}
	},
	id = "weazel_ext_00",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1320503032,
			objCoords = {x = -579.62, y = -919.21, z = 28.31},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 180.0},
		},
	},
	textCoords = {x = -578.997, y = -919.183, z = 28.062},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
	{
		name = "weazel",
		rank = 1,
		specUnit = {}
	}
	},
	id = "weazel_ext_01",
	locked = true,
	size = 0.5,
	distance = 1.0,
	ziptie = false,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

--Court Doors (Offices and Court Rooms)

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -739665083,
			objCoords	= {x = -569.72991943359, y = -209.61474609375, z = 37.219696044922},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -150.0},
		},
	},
	textCoords = {x = -569.71734619141, y = -209.63899230957, z = 38.518081665039}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "court",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "court_room1_1", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -739665083,
			objCoords	= {x = -577.13287353516, y = -213.92022705078, z = 37.218254089355},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 30.0},
		},
	},
	textCoords = {x = -577.11785888672, y = -213.91795349121, z = 38.343887329102}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "court",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "court_room1_2", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -29187315,
			objCoords	= {x = -556.67266845703, y = -228.19808959961, z = 37.32933807373},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 120.0},
		},
		{
			objHash = -29187315,
			objCoords	= {x = -556.14105224609, y = -229.17443847656, z = 37.32933807373},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -60.0},
		}
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "court",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	textCoords = {x = -556.42291259766, y = -228.68850708008, z = 38.631313323975}, -- Text Coords
	id = "court_room1_3", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = 1858896923,
			objCoords	= {x = -567.67559814453, y = -235.75466918945, z = 33.228679656982},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -60.0},
		},
		{
			objHash = 1858896923,
			objCoords	= {x = -568.26873779297, y = -234.78485107422, z = 33.228679656982},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 120.0},
		}
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "court",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	textCoords = {x = -567.96337890625, y = -235.29975891113, z = 34.519916534424}, -- Text Coords
	id = "court_room1_4", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = 1956494919,
			objCoords	= {x = -568.30389404297, y = -201.11595153809, z = 32.468437194824},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 30.0},
		},
		{
			objHash = 1956494919,
			objCoords	= {x = -569.41656494141, y = -201.75836181641, z = 32.429191589355},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -150.0},
		}
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "court",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	textCoords = {x = -568.85498046875, y = -201.43411254883, z = 33.660221099854}, -- Text Coords
	id = "court_room1_5", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = 736699661,
			objCoords	= {x = -521.05590820312, y = -181.3610534668, z = 37.219650268555},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -150.0},
		},
	},
	textCoords = {x = -527.69299316406, y = -185.20193481445, z = 38.50333404541}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "court",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	textCoords = {x = -521.06555175781, y = -181.37557983398, z = 38.492961883545}, -- Text Coords
	id = "court_room2_1", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = 736699661,
			objCoords	= {x = -527.72247314453, y = -185.21894836426, z = 37.228782653809},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 30.0},
		},
	},
	textCoords = {x = -527.69299316406, y = -185.20193481445, z = 38.50333404541}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "court",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "court_room2_2", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -29187315,
			objCoords	= {x = -515.638671875, y = -210.95372009277, z = 37.355968475342},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -60.0},
		},
		{
			objHash = -29187315,
			objCoords	= {x = -516.19329833984, y = -210.00527954102, z = 37.329128265381},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 119.9999},
		},
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "court",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	textCoords = {x = -515.90863037109, y = -210.48614501953, z = 38.607288360596}, -- Text Coords
	id = "court_room2_3", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

--Court Offices (Tower)

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = 736699661,
			objCoords	= {x = -556.11712646484, y = -191.37922668457, z = 55.324966430664},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -60.0},
		},
	},
	textCoords = {x = -556.12756347656, y = -191.36097717285, z = 56.587554931641}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "court",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "court_office_1", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = 736699661,
			objCoords	= {x = -556.1416015625, y = -191.33155822754, z = 59.929740905762},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -60.0},
		},
	},
	textCoords = {x = -556.12768554688, y = -191.35563659668, z = 61.222621917725}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "court",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "court_office_2", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = 736699661,
			objCoords	= {x = -556.1142578125, y = -191.37893676758, z = 64.483917236328},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -60.0},
		},
	},
	textCoords = {x = -556.12280273438, y = -191.36407470703, z = 65.758682250977}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "court",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "court_office_3", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = 736699661,
			objCoords	= {x = -556.12115478516, y = -191.3669128418, z = 69.000480651855},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -60.0},
		},
	},
	textCoords = {x = -556.11566162109, y = -191.37644958496, z = 70.271797180176}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "court",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "court_office_4", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

--Richards Majestic / Callaghan Office

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = 220394186,
			objCoords	= {x = -1387.6280517578, y = -478.27862548828, z = 71.042144775391},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 97.8},
		},
		{
			objHash = 220394186,
			objCoords	= {x = -1387.4508056641, y = -479.14944458008, z = 71.051956176758},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -81.37},
		},
	},
	textCoords = {x = -1387.4990234375, y = -478.71090698242, z = 72.323043823242}, -- Text Coords
	authorizedJobs = { -- Job Restriction
		{
			name = 8, -- callaghan
			rank = 1,
			specUnit = {},
			type = "gang"
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "rm_office_1", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = true, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = true, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 50, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 250.0, -- Frozen Dist for coords
},

--G6 Office

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -129553421,
			objCoords	= {x = 30.030019760132, y = -901.09362792969, z = 28.96068572998},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 160.0},
		},
	},
	textCoords = {x = 30.013263702393, y = -901.13909912109, z = 30.21361541748}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	textCoords = {x = 30.013263702393, y = -901.13909912109, z = 30.21361541748}, -- Text Coords
	id = "g6_office_1", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = true, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = true, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 250.0, -- Frozen Dist for coords
},

--G6 Vault

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -1932297301,
			objCoords	= {x = -3.3723213672638, y = -686.14422607422, z = 15.300377845764},
		},
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	textCoords = {x = -4.0460247993469, y = -685.89904785156, z = 16.464744567871}, -- Text Coords
	id = "g6_office_2", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = true, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = true, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 10, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 250.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -2125423493,
			objCoords	= {x = 58.413, y = -879.695, z = 29.587},
		},
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 100, -- Distance to see text
	textCoords = {x = 58.018486022949, y = -879.92254638672, z = 30.601169586182}, -- Text Coords
	id = "g6_office_3", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = true, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -2125423493,
			objCoords	= {x = 51.552, y = -898.417, z = 29.300},
		},
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 100, -- Distance to see text
	textCoords = {x = 51.196434020996, y = -898.61395263672, z = 30.326118469238}, -- Text Coords
	id = "g6_office_4", -- Custom ID (Never leave blank)
	ziptie = false, -- Ablity for civs to ziptie door shut
	hackable = true, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = false, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

-- Sandy PD

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -1765048490,
			objCoords	= {x = 1855.71, y = 3683.93, z = 34.59},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 29.90},
		},
	},
	textCoords = {x = 1854.6928710938, y = 3683.3005371094, z = 34.408336639404}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = false, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "sandypd_01", -- Custom ID (Never leave blank)
	ziptie = true, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = true, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -2023754432,
			objCoords	= {x = 1850.851, y = 3682.778, z = 33.269},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -60.0},
		},
	},
	textCoords = {x = 1850.851, y = 3682.778, z = 34.26}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "sandypd_02", -- Custom ID (Never leave blank)
	ziptie = true, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = true, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -2023754432,
			objCoords	= {x = 1848.308, y = 3690.474, z = 34.216},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -150.0},
		},
	},
	textCoords = {x = 1848.308, y = 3690.474, z = 34.416}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "sandypd_03", -- Custom ID (Never leave blank)
	ziptie = true, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = true, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -2023754432,
			objCoords	= {x = 1856.936, y = 3689.633, z = 34.216},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -150.0},
		},
	},
	textCoords = {x = 1856.936, y = 3689.633, z = 34.416}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "sandypd_04", -- Custom ID (Never leave blank)
	ziptie = true, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = true, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -2023754432,
			objCoords	= {x = 1852.35, y = 3694.70, z = 33.35},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 120.0},
		},
	},
	textCoords = {x = 1852.35, y = 3694.70, z = 34.35}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 1.0, -- Distance to see text
	id = "sandypd_05", -- Custom ID (Never leave blank)
	ziptie = true, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = true, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = -2023754432,
			objCoords	= {x = 1846.306, y = 3690.457, z = 34.457},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -60.0},
		},
	},
	textCoords = {x = 1846.306, y = 3690.457, z = 34.457}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 2.0, -- Distance to see text
	id = "sandypd_06", -- Custom ID (Never leave blank)
	ziptie = true, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = true, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = 631614199,
			objCoords	= {x = 1847.209, y = 3684.593, z = 34.427},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 120.058},
		},
	},
	textCoords = {x = 1847.209, y = 3684.593, z = 34.427}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 2.0, -- Distance to see text
	id = "sandypd_07", -- Custom ID (Never leave blank)
	ziptie = true, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = true, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},

{
	doors = {	-- You can have more than one door linked upto the text
		{
			objHash = 631614199,
			objCoords	= {x = 1845.468, y = 3687.638, z = 34.400},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 120.058},
		},
	},
	textCoords = {x = 1845.468, y = 3687.638, z = 34.400}, -- Text Coords
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = { -- Job Restriction
		{
			name = "police",
			rank = 0,
			specUnit = {}
		},
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "gruppe6",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		}
	},
	unAuthorized = {
	},
	locked = true, -- Server startup status
	size = 0.5, -- Size of text
	distance = 2.0, -- Distance to see text
	id = "sandypd_08", -- Custom ID (Never leave blank)
	ziptie = true, -- Ablity for civs to ziptie door shut
	hackable = false, -- Ablity to hack door open (Using Lester Hacking Device)
	lockpick = true, -- Ablity to drill/lockpick/advancelockpick door
	requiredPoliceOnDuty = 0, -- Ablity to restrict lockpicking doors if police are not online
	chanceToNotify = 100, -- Chance out of 100 to alert police if door is being touched
	allowedToRepairDoor = {}, -- Job to repair doors
	breachable = true, -- Ablity to use breaching_charge on door (POLICE ONLY)
	frozenDist = 110.0, -- Frozen Dist for coords
},


{
	doors = {
		{
			objHash = -1989765534,
			objCoords = {x = 377.73, y = 267.78, z = 91.36},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 71.40752},
		},
	},
	textCoords = {x = 377.86242675781, y = 268.39834594727, z = 91.260269165039},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 8, -- callaghan
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "galaxy_nightclub_int00",
	locked = true,
	size = 0.5,
	distance = 0.5,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1695461688,
			objCoords = {x = 380.16, y = 266.63, z = 91.36},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -15.40752},
		},
	},
	textCoords = {x = 380.85070800781, y = 266.47439575195, z = 91.314331054688},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 8, -- callaghan
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "galaxy_nightclub_int01",
	locked = true,
	size = 0.5,
	distance = 0.5,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = -1555108147,
			objCoords = {x = 377.78, y = 267.77, z = 95.14},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 74.5925},
		},
	},
	textCoords = {x = 377.98431396484, y = 268.37924194336, z = 95.118690490723},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 8, -- callaghan
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "galaxy_nightclub_int02",
	locked = true,
	size = 0.5,
	distance = 0.5,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 1695461688,
			objCoords = {x = 354.45, y = 273.71, z = 94.36},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 74.7672},
		},
	},
	textCoords = {x = 354.66339111328, y = 274.39144897461, z = 94.312606811523},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 8, -- callaghan
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "galaxy_nightclub_int03",
	locked = true,
	size = 0.5,
	distance = 0.5,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 0,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

-- NCA Base

{
	doors = {
		{
			objHash = 2090220040,
			objCoords = {x = -2326.944, y = 278.131, z = 154.945},
		},
	},
	textCoords = {x = -2326.751, y = 277.700, z = 155.817}, 
	authorizedJobs = {
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
	},
	id = "nca_redacted_jail_1",
	locked = true,
	size = 0.5,
	distance = 5,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 0,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 2090220040,
			objCoords = {x = -2328.706, y = 282.220, z = 154.945},
		},
	},
	textCoords = {x = -2328.889, y = 282.647, z = 155.809},
	authorizedJobs = {
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
	},
	id = "nca_redacted_jail_2",
	locked = true,
	size = 0.5,
	distance = 5,
	ziptie = true,
	breachable = true,
	lockpick = true,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 0,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 871712474,
			objCoords = {x = -2320.979, y = 292.023, z = 155.409},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 24.05718},
		},
	},
	textCoords = {x = -2321.308, y = 291.873, z = 156.580},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
	},
	id = "nca_redacted_interview_1",
	locked = true,
	size = 0.5,
	distance = 5,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 0,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 346272656,
			objCoords = {x = -2347.980, y = 262.042, z = 163.502}, 
		},
	},
	textCoords = {x = -2348.022, y = 262.022, z = 165.309}, 
	authorizedJobs = {
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
	},
	id = "nca_redacted_main_door_1",
	locked = true,
	size = 0.5,
	distance = 300,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 15,
	chanceToNotify = 0,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{
	doors = {
		{
			objHash = 346272656,
			objCoords = {x = -2308.842, y = 249.526, z = 155.036},
		},  
	},
	textCoords = {x = -2308.888, y = 249.514, z = 156.786}, 
	authorizedJobs = {
		{
			name = "nca",
			rank = 1,
			specUnit = {}
		},
		{
			name = "ambulance",
			rank = 0,
			specUnit = {}
		},
	},
	id = "nca_redacted_main_door_2",
	locked = true,
	size = 0.5,
	distance = 300,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 15,
	chanceToNotify = 0,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},


-- Gang Stash Houses

{ -- Grove St, Diegos Garage
	doors = {
		{
			objHash = 703855057,
			objCoords = {x = 121.85, y = -1995.36, z = 18.56},
		},
	},
	textCoords = {x = 121.911, y = -1995.319, z = 18.359},
	authorizedJobs = {
		{
			name = 1, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "GroveStDiegos01",
	locked = true,
	size = 4.5,
	distance = 10.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Grove St, Diegos Garage Door
	doors = {
		{
			objHash = -2023754432,
			objCoords = {x = 116.01, y = -1990.55, z = 18.64},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -18.5999},
		},
	},
	textCoords = {x = 116.710, y = -1990.734, z = 18.588},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 1, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "GroveStDiegos02",
	locked = true,
	size = 4.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Grove St, Diegos Ext Door
	doors = {
		{
			objHash = -2023754432,
			objCoords = {x = 108.74, y = -2015.23, z = 18.64},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -18.5999},
		},
	},
	textCoords = {x = 109.419, y = -2015.409, z = 18.650},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 1, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "GroveStDiegos03",
	locked = true,
	size = 4.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Grove St, Hidden Door
	doors = {
		{
			objHash = -817177082,
			objCoords = {x = 117.87, y = -2003.05, z = 12.84},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -108.3827},
		},
	},
	textCoords = {x = 117.638, y = -2003.930, z = 12.705},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.6, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 1, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "GroveStDiegos04",
	locked = true,
	size = 4.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Grove St, Shop Ext Upper
	doors = {
		{
			objHash = 1413743677,
			objCoords = {x = 0.19, y = -1823.28, z = 29.64},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 49.98153},
		},
	},
	textCoords = {x = -0.269, y = -1823.924, z = 29.519},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 1, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "GroveStShop00",
	locked = true,
	size = 4.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Grove St, Shop Ext Down
	doors = {
		{
			objHash = 1531355165,
			objCoords = {x = 5.65, y = -1816.75, z = 25.48},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 49.98153},
		},
	},
	textCoords = {x = 6.029, y = -1816.299, z = 25.471},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.0, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 1, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "GroveStShop01",
	locked = true,
	size = 4.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Grove St, Shop Int Down
	doors = {
		{
			objHash = 1173348778,
			objCoords = {x = -4.97, y = -1817.68, z = 25.50},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -39.94539},
		},
	},
	textCoords = {x = -5.468, y = -1817.334, z = 25.407},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 1, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "GroveStShop02",
	locked = true,
	size = 4.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Marabunta Grande, Shop Int Hidden
	doors = {
		{
			objHash = -1688962825,
			objCoords = {x = 1337.01, y = -1653.69, z = 52.36},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 125.9575},
		},
	},
	textCoords = {x = 1337.296, y = -1654.267, z = 52.335},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.0, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 4, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "MBShopInt00",
	locked = true,
	size = 4.5,
	distance = 3.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Marabunta Grande, House Int Weapon Room
	doors = {
		{
			objHash = -453852320,
			objCoords = {x = 1439.92, y = -1488.63, z = 66.77},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 162.4365},
		},
	},
	textCoords = {x = 1439.301, y = -1488.373, z = 66.738},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 4, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "MBHouseInt00",
	locked = true,
	size = 4.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Ballas Carwash, Exterior Front
	doors = {
		{
			objHash = -2003105485,
			objCoords = {x = -32.68, y = -1392.06, z = 29.64},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 0.0},
		},
	},
	textCoords = {x = -32.098, y = -1392.06, z = 29.620},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 2, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "BallCarwashExt04",
	locked = true,
	size = 4.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Ballas Carwash, Exterior Front
	doors = {
		{
			objHash = -2003105485,
			objCoords = {x = -21.71, y = -1392.78, z = 29.64},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -179.5091},
		},
	},
	textCoords = {x = -22.309, y = -1392.783, z = 29.620},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 2, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "BallCarwashExt00",
	locked = true,
	size = 4.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Ballas Carwash, Exterior Side
	doors = {
		{
			objHash = -2003105485,
			objCoords = {x = -21.27, y = -1406.85, z = 29.64},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 89.62},
		},
	},
	textCoords = {x = -21.267, y = -1406.250, z = 29.620},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 2, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "BallCarwashExt01",
	locked = true,
	size = 4.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Ballas Carwash, Exterior Garage
	doors = {
		{
			objHash = -190780785,
			objCoords = {x = -21.03, y = -1410.73, z = 30.55},
		},
	},
	textCoords = {x = -21.095, y = -1407.877, z = 29.690},
	authorizedJobs = {
		{
			name = 2, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "BallCarwashExt02",
	locked = true,
	size = 4.5,
	distance = 10.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Ballas Carwash, Interior Drug Door
	doors = {
		{
			objHash = -2003105485,
			objCoords = {x = -24.23, y = -1403.07, z = 29.64},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 89.51},
		},
	},
	textCoords = {x = -24.223, y = -1402.460, z = 29.625},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.1, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 2, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "BallCarwashInt00",
	locked = true,
	size = 4.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Ballas Carwash, Exterior Gate 1
	doors = {
		{
			objHash = 1286535678,
			objCoords = {x = 40.87, y = -1410.22, z = 28.36},
		},
	},
	textCoords = {x = 41.005, y = -1413.994, z = 29.794},
	authorizedJobs = {
		{
			name = 2, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "BallCarwashGate01",
	locked = true,
	size = 4.5,
	distance = 80.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Ballas Carwash, Exterior Gate 2
	doors = {
		{
			objHash = 1286535678,
			objCoords = {x = -69.326, y = -1418.480, z = 29.843},
		},
	},
	textCoords = {x = -69.323, y = -1418.763, z = 29.700},
	authorizedJobs = {
		{
			name = 2, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "BallCarwashGate02",
	locked = true,
	size = 4.5,
	distance = 80.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Triads House, Exterior
	doors = {
		{
			objHash = -710818483,
			objCoords = {x = -716.80, y = -865.32, z = 23.35},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -89.99},
		},
	},
	textCoords = {x = -716.760, y = -864.612, z = 23.244},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 6, -- Grove Street
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "TriadsHouseExt00",
	locked = true,
	size = 4.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Vagos Autocar, Exterior Side
	doors = {
		{
			objHash = -2023754432,
			objCoords = {x = 474.82, y = -1903.00, z = 26.11},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -155.0312},
		},
	},
	textCoords = {x = 474.24, y = -1903.323, z = 26.11},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 3,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "VagosAutoExt00",
	locked = true,
	size = 4.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Vagos Autocar, Exterior Side 01
	doors = {
		{
			objHash = -1230442770,
			objCoords = {x = 483.68, y = -1876.06, z = 26.46},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 114.4563},
		},
	},
	textCoords = {x = 483.979, y = -1876.609, z = 26.390},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = -1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 3,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "VagosAutoExt01",
	locked = true,
	size = 4.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Vagos Autocar, Exterior Garage Doors
	doors = {
		{
			objHash = -976225932,
			objCoords = {x = 479.84, y = -1884.18, z = 26.51},
		},
	},
	textCoords = {x = 479.84, y = -1884.18, z = 26.51},
	authorizedJobs = {
		{
			name = 3,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "VagosAutoExt02",
	locked = true,
	size = 4.5,
	distance = 110.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Vagos Autocar, Exterior Garage Doors
	doors = {
		{
			objHash = -976225932,
			objCoords = {x = 475.13, y = -1886.37, z = 26.51},
		},
	},
	textCoords = {x = 475.13, y = -1886.37, z = 26.51},
	authorizedJobs = {
		{
			name = 3,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "VagosAutoExt03",
	locked = true,
	size = 4.5,
	distance = 110.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Aztecas Motel Ext 00
	doors = {
		{
			objHash = -1023447729,
			objCoords = {x = 1535.99, y = 3581.20, z = 38.86},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 30.0},
		},
	},
	textCoords = {x = 1536.616, y = 3581.516, z = 38.649},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 5,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "AztecaMotel00",
	locked = true,
	size = 4.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Aztecas Motel Ext 01
	doors = {
		{
			objHash = -1023447729,
			objCoords = {x = 1545.63, y = 3586.81, z = 38.88},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 30.0},
		},
	},
	textCoords = {x = 1546.257, y = 3587.125, z = 38.710},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 5,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "AztecaMotel01",
	locked = true,
	size = 4.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Aztecas Motel Ext 02
	doors = {
		{
			objHash = -1023447729,
			objCoords = {x = 1557.49, y = 3593.66, z = 38.88},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = 30.0},
		},
	},
	textCoords = {x = 1558.128, y = 3593.980, z = 38.88},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 5,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "AztecaMotel02",
	locked = true,
	size = 4.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

{ -- Aztecas Motel Ext 03 {model = -1023447729, coords = vector3(1587.488, 3590.905, 39.302)},
	doors = {
		{
			objHash = -1023447729,
			objCoords = {x = 1587.18, y = 3591.52, z = 38.88},
			objCloseState = {pitch = 0.0, roll = 0.0,yaw = -60.0},
		},
	},
	textCoords = {x = 1587.520, y = 3590.847, z = 38.88},
	textOnDoor = true, -- Text Freeze On Door
	positionForDoorText = { -- position of text on door offset
		offsetX = 1.2, -- Left/Right
		offsetY = 0.0, -- Forward/Backward
		offsetZ = 0.0 -- Up/Down
	},
	authorizedJobs = {
		{
			name = 5,
			rank = 1,
			specUnit = {},
			type = "gang"
		}
	},
	id = "AztecaMotel03",
	locked = true,
	size = 4.5,
	distance = 1.0,
	ziptie = true,
	breachable = true,
	lockpick = false,
	requiredPoliceOnDuty = 5,
	chanceToNotify = 50,
	allowedToRepairDoor = {},
	frozenDist = 110.0,
	hackable = false
},

}