config = {}

config.clothes = {
	male = {
		['tshirt_1'] = 15,  ['tshirt_2'] = 0,
		['torso_1']  = 146, ['torso_2']  = 0,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms']     = 0,   ['pants_1']  = 3,
		['pants_2']  = 7,   ['shoes_1']  = 12,
		['shoes_2']  = 12,  ['chain_1']  = 0,
		['chain_2']  = 0,
		['mask_1'] = 0,     ['mask_2'] = 0,
		['bags_1'] = 0,     ['bags_2'] = 0,
		['bproof_1'] = 0,    ['bproof_2'] = 0,
		['ears_1'] = 3,     ['ears_2'] = 0,
		['helmet_1'] = 11,  ['helmet_2'] = 0,
	},
	female = {
		['tshirt_1'] = 3,   ['tshirt_2'] = 0,
		['torso_1']  = 38,  ['torso_2']  = 3,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms']     = 2,   ['pants_1']  = 3,
		['pants_2']  = 15,  ['shoes_1']  = 66,
		['shoes_2']  = 5,   ['chain_1']  = 0,
		['chain_2']  = 0,
		['mask_1'] = 0,     ['mask_2'] = 0,
		['bags_1'] = 0,     ['bags_2'] = 0,
		['bproof_1'] = 0,    ['bproof_2'] = 0,
		['ears_1'] = 3,     ['ears_2'] = 0,
		['helmet_1'] = 11,  ['helmet_2'] = 0,
	},
}

config.postions = {
	aiSpawnLocation = {
		x = 402.91702270508,
		y = -1000.6376953125,
		z = -99.004028320313,
		h = 356.88052368164
	},
	prisonerPictureLocation = {
		x = 406.04,
		y = -996.97,
		z = -99.00,
		h = 93.41
	},
	cameraPostion = {
		x = 402.85266113281,
		y = -999.14752197266,
		z = -98.00407409668,
		rotationX = -15.433070763946,
		rotationY = 0.0,
		rotationZ = -0.31496068835258,
		cameraId = 0
	},
	cell = {
		x = 1782.5910644531,
		y = 2568.3203125,
		z = 49.549819946289,
		h = 200.0,
	},
	releasePoint = {
		x = 1829.1947021484,
		y = 2585.8107910156,
		z = 44.952327728271,
		h = 200.0
	}
}

config.items = { -- Reward items
	"bandage",
	"apple",
	"cocaine",
	"PLASTIC_SHEET",
	"phone"
}

config.jobAnims = {
	clean = {
		label = "Cleaning Table",
		time = 20000,
		animation = {
			animDict = "timetable@floyd@clean_kitchen@base",
			anim = "base",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "prop_sponge_01",
			bone = 28422,
			coords = { x = 0.0, y = 0.0, z = -0.01 },
			rotation = { x = 90.0, y = 0.0, z = 0.0 },
		},
	},
	search = {
		label = "Searching",
		time = 15000,
		animation = {
			animDict = "missexile3",
			anim = "ex03_dingy_search_case_a_michael",
			flags = 49,
			task = nil,
		},
	},
	sink = {
		label = "Cleaning Dishes",
		time = 19000,
		animation = {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
			task = nil,
		},
	},
	stock = {
		label = "Checking Stock",
		time = 15000,
		animation = {
			animDict = "missfam4",
			anim = "base",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "p_amb_clipboard_01",
			bone = 36029,
			coords = { x = 0.16, y = 0.08, z = 0.01 },
			rotation = { x = -130.0, y = -50.0, z = 0.0 },
		},
	},
}


config.allowedInFlyZone = {
	"police",
	"ambulance",
}