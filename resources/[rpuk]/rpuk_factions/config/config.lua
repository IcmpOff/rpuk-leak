Config = {}

Config.teleportToHospital = {
	["Pillbox"] = vector3(354.11, -593.0, 43.99), -- pillbox
	["Sandy"] = vector3(1823.26 , 3680.87, 35.2), -- sandy
	["Paleto"] = vector3(-258.16, 6321.31, 33.5), -- paleto
}

Config.maxMutexRank = {
	["city"] = 2,
	["gruppe6"] = 4,
	["weazel"] = 2,
	["court"] = 3,
}

Config.Management = {
	["lost"] = 8,
	["police"] = 5,
	["ambulance"] = 5,
	["city"] = 2,
	["gruppe6"] = 3,
	["weazel"] = 2,
	["court"] = 3,
}

Config.checkLog = {
	["lost"] = {
		Armory = false,
		Evidence = true,
		Fund = true
	},
	["police"] = {
		Armory = true,
		Evidence = true,
		Fund = true
	},
	["ambulance"] = {
		Armory = true,
		Evidence = true,
		Fund = true
	},
	["city"] = {
		Armory = false,
		Evidence = false,
		Fund = false
	},
	["gruppe6"] = {
		Armory = true,
		Evidence = true,
		Fund = true
	},
	["weazel"] = {
		Armory = false,
		Evidence = false,
		Fund = false
	},
	["court"] = {
		Armory = false,
		Evidence = false,
		Fund = false
	},
}

Config.LookupOverride = {
	['police'] = {level = 'policelevel', data = 'policedata', flags = {
		['taser'] = 'Taser',
		['dog'] = 'Dog Handler',
		['firstaid'] = 'First Aid Training',
		['driving'] = 'Advanced Driver',
		['pilot'] = 'Pilot',
		['boat'] = 'Boat Training',
		['firearms'] = 'Firearms Training',
		['covert'] = 'Covert',
		['cid'] = "CID",
		['special'] = 'Special',
	}},
	['ambulance'] = {level = 'nhslevel', data = 'nhsdata', flags = {
		['firstaid'] = 'First Aid Training',
		['driving'] = 'Advanced Driving',
		['pilot'] = 'Pilot',
		['boat'] = 'Boat Training',
		['special'] = 'Special',
		['hart'] = 'Hart',
		['training'] = 'Training',
	}},
	['lost'] = {level = 'lostlevel', data = 'lostdata', flags = {
		['manufacture'] = 'Weapon Manufacturing',
		['bank'] = 'Bank Access',
		['launder'] = 'Money Laundary',
		['smuggling'] = 'Smuggler',
		['special'] = 'Special'
	}}
}

Config.fundAccess = {
	["police"] = {
		Admin = 5,
		View = 5
	},
	["lost"] = {
		Admin = 8,
		View = 0
	},
	["city"] = {
		Admin = 2,
		View = 2
	},
	["ambulance"] = {
		Admin = 5,
		View = 5
	},
	["gruppe6"] = {
		Admin = 3,
		View = 2
	},
}

Config.DistToSearch = 10

Config.AccessToPerformMedicalActions = {
	"police",
	"ambulance",
	"nca"
}

Config.AccessToRestrain = {
	"police",
	"gruppe6",
}

Config.AccessToSearchPlayer = {
	"police",
	"gruppe6",
}

Config.AccessToDrag = {
	"police",
	"gruppe6",
	"ambulance"
}

Config.AccessToUseVehiclePlacement = {
	"police",
	"gruppe6",
	"ambulance"
}

Config.AccessToCheckLicences = {
	"police",
	"gruppe6",
	"court"
}

Config.AccessToVehicleOptions = {
	"police",
	"gruppe6",
}

Config.AccessToSpawnObjectMenu = {
	"police",
	"gruppe6",
	"ambulance",
}

Config.AccessToGetClothesFromTrunk = {
	"police",
	"ambulance",
}

Config.AccessToUseQuickVehicleSearch = {
	"police",
}

Config.AccessToJailPlayer = {
	"police",
	"gruppe6"
}

Config.AccessToPNC = {
	"police",
	"court"
}

Config.AccessToRadioFreq = {
	"police",
	"gruppe6",
	"ambulance"
}