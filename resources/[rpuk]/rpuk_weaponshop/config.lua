Config = {}

Config.Debug = false

Config.AlignMenu = "top-left" -- this is where the menu is located [left, right, center, top-right, top-left etc.]

Config.StoreBlips = false -- enable blips on every store.

Config.BlackMoney = false -- if you want to purchase with black money.

Config.DefaultAmmo = 60 -- this is the ammo you will get when purchasing a weapon.

Config.MarkerData = {
    ["type"] = 1,
    ["size"] = vector3(1.5, 1.5, 0.5),
    ["color"] = vector3(0, 255, 150),
    ["range"] = 5.0
}

Config.WeaponShops = {
    {
        ["name"] = "AMMUNATION",
        ["clerkMarker"] = {
            ["position"] = vector3(20.174058914185, -1106.2066650391, 29.797029495239),
            ["heading"] = 340.0
        },
        ["clerk"] = {
            ["model"] = 0x9E08633D,
            ["position"] = vector3(20.823081970215, -1104.3601074219, 29.797029495239),
            ["heading"] = 160.0
        },
        ["camera"] = {
            ["x"] = 21.343982696533, 
            ["y"] = -1107.1812744141, 
            ["z"] = 30.963396072388, 
            ["rotationX"] = -26.204723984003, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -110.33070892096
        },
        ["object"] = {
            ["position"] = vector3(23.115102767944, -1107.7210693359, 30.272029876709)
        }
    },
    {
        ["name"] = "AMMUNATION",
        ["clerkMarker"] = {
            ["position"] = vector3(810.2, -2157.3, 29.6),
            ["heading"] = 340.0
        },
        ["clerk"] = {
            ["model"] = 0x9E08633D,
            ["position"] = vector3(810.2, -2159.3, 28.6),
            ["heading"] = 0.421
        },
        ["camera"] = {
            ["x"] = 810.07, 
            ["y"] = -2158.0, 
            ["z"] = 30.2, 
            ["rotationX"] = -180.204723984003, 
            ["rotationY"] = -180.0, 
            ["rotationZ"] = -110.33070892096
        },
        ["object"] = {
            ["position"] = vector3(808.743, -2157.145, 29.7)
        }
    },	
    {
        ["name"] = "AMMUNATION",
        ["clerkMarker"] = {
            ["position"] = vector3(1693.4, 3759.5, 34.7),
            ["heading"] = 340.0
        },
        ["clerk"] = {
            ["model"] = 0x9E08633D,
            ["position"] = vector3(1692.4, 3761.5, 33.7),
            ["heading"] = -140.0
        },
        ["camera"] = {
            ["x"] = 1695.73, 
            ["y"] = 3758.72, 
            ["z"] = 35.2, 
            ["rotationX"] = 10.204723984003, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 0.33070892096
        },
        ["object"] = {
            ["position"] = vector3(1696.106, 3760.037, 35.0)
        }
    },	
    {
        ["name"] = "AMMUNATION",
        ["clerkMarker"] = {
            ["position"] = vector3(-330.2, 6083.8, 31.4),
            ["heading"] = 340.0
        },
        ["clerk"] = {
            ["model"] = 0x9E08633D,
            ["position"] = vector3(-331.625, 6085.278, 30.455),
            ["heading"] = -140.0
        },
        ["camera"] = {
            ["x"] = -327.95, 
            ["y"] = 6082.0, 
            ["z"] = 32.0, 
            ["rotationX"] = 10.204723984003, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 0.33070892096
        },
        ["object"] = {
            ["position"] = vector3(-327.744, 6083.702, 31.7)
        }
    },	
}

Config.Weapons = {
	--[[{
        ["model"] = "WEAPON_VINTAGEPISTOL",
        ["price"] = 35000
    },
	{
        ["model"] = "WEAPON_PISTOL",
        ["price"] = 20000
    },
	{
        ["model"] = "WEAPON_SNSPISTOL_MK2",
        ["price"] = 11000
    }
    {
        ["model"] = "WEAPON_MICROSMG",
        ["price"] = 7000
    }]]
}

Config.MeleeWeapons = {
	{
        ["model"] = "WEAPON_BAT",
        ["price"] = 600
    },
	{
        ["model"] = "WEAPON_BOTTLE",
        ["price"] = 900
    },	
	{
        ["model"] = "WEAPON_CROWBAR",
        ["price"] = 1000
    },
	{
        ["model"] = "WEAPON_FLASHLIGHT",
        ["price"] = 900
    },
	{
        ["model"] = "WEAPON_POOLCUE",
        ["price"] = 900
    },	
	{
        ["model"] = "WEAPON_GOLFCLUB",
        ["price"] = 900
    },	
	{
        ["model"] = "WEAPON_HAMMER",
        ["price"] = 900
    },
	--[[{
        ["model"] = "WEAPON_HATCHET",
        ["price"] = 2500
    },	]]
	{
        ["model"] = "WEAPON_DAGGER",
        ["price"] = 1500
    },		
	{
        ["model"] = "WEAPON_KNUCKLE",
        ["price"] = 900
    },
	{
        ["model"] = "WEAPON_KNIFE",
        ["price"] = 1500
    },	
	{
        ["model"] = "WEAPON_MACHETE",
        ["price"] = 1600
    },
	{
        ["model"] = "WEAPON_SWITCHBLADE",
        ["price"] = 1700
    },	
	{
        ["model"] = "WEAPON_WRENCH",
        ["price"] = 900
    },
	--[[{
        ["model"] = "WEAPON_BATTLEAXE",
        ["price"] = 3000
    }]]
}

-- These are the prices for each ammo.
Config.AmmoTypes = {
    [`AMMO_PISTOL`] = 50,
    [`AMMO_SMG`] = 25,
    [`AMMO_RIFLE`] = 30,
    [`AMMO_SHOTGUN`] = 70,
    [`AMMO_SNIPER`] = 40
}

Config.WeaponComponents = {
    ["WEAPON_SNIPERRIFLE"] = {

    },

    ["WEAPON_PUMPSHOTGUN"] = {

    },
    
    ["WEAPON_SPECIALCARBINE"] = {

    },

    ["WEAPON_ASSAULTSMG"] = {

    },

    ["WEAPON_MICROSMG"] = {

    },

    ["WEAPON_SMG"] = {

    },

    ["WEAPON_APPISTOL"] = {

    },

    ["WEAPON_COMBATPISTOL"] = {

    },
    
	["WEAPON_PISTOL"] = {

    },		
	["WEAPON_VINTAGEPISTOL"] = {

    },		
    ["WEAPON_PISTOL50"] = {

    },	
	["WEAPON_SNSPISTOL_MK2"] = {

    },
    ["WEAPON_MUSKET"] = {

    }	
}

Config.MeleeWeaponComponents = {
    ["WEAPON_BAT"] = {

    },	
    ["WEAPON_BOTTLE"] = {

    },	
    ["WEAPON_CROWBAR"] = {

    },	
    ["WEAPON_FLASHLIGHT"] = {

    },	
    ["WEAPON_POOLCUE"] = {

    },	
    ["WEAPON_GOLFCLUB"] = {

    },	
    ["WEAPON_HAMMER"] = {

    },	
    ["WEAPON_HATCHET"] = {

    },	
    ["WEAPON_DAGGER"] = {

    },	
    ["WEAPON_KNUCKLE"] = {

    },	
    ["WEAPON_KNIFE"] = {

    },	
    ["WEAPON_MACHETE"] = {

    },	
    ["WEAPON_SWITCHBLADE"] = {

    },	
    ["WEAPON_WRENCH"] = {

    },	
    ["WEAPON_BATTLEAXE"] = {

    }	
}


Config.DefaultWeapon = Config.Weapons[1]
Config.DefaultMeleeWeapon = Config.MeleeWeapons[1]

Config.UnderDev = {
    -- ["WEAPON_SNSPISTOL"] = {"COMPONENT_SNSPISTOL_CLIP_02", "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER"},
    -- ["WEAPON_VINTAGEPISTOL"] = {"COMPONENT_VINTAGEPISTOL_CLIP_02", "COMPONENT_AT_PI_SUPP"},
    -- ["WEAPON_KNUCKLE"] = {"COMPONENT_KNUCKLE_VARMOD_BASE", "COMPONENT_KNUCKLE_VARMOD_PIMP", "COMPONENT_KNUCKLE_VARMOD_BALLAS", "COMPONENT_KNUCKLE_VARMOD_DOLLAR", "COMPONENT_KNUCKLE_VARMOD_DIAMOND", "COMPONENT_KNUCKLE_VARMOD_HATE", "COMPONENT_KNUCKLE_VARMOD_LOVE", "COMPONENT_KNUCKLE_VARMOD_PLAYER", "COMPONENT_KNUCKLE_VARMOD_KING", "COMPONENT_KNUCKLE_VARMOD_VAGOS"},
    -- ["WEAPON_SWITCHBLADE"] = {"COMPONENT_SWITCHBLADE_VARMOD_VAR1", "COMPONENT_SWITCHBLADE_VARMOD_VAR2"}
        -- ["WEAPON_HEAVYPISTOL"] = {"COMPONENT_HEAVYPISTOL_CLIP_02", "COMPONENT_AT_PI_FLSH", "COMPONENT_AT_PI_SUPP", "COMPONENT_HEAVYPISTOL_VARMOD_LUXE"},
    -- ["WEAPON_MINISMG"] = {"COMPONENT_MINISMG_CLIP_02"},
    -- ["WEAPON_MARKSMANPISTOL"] = {"COMPONENT_REVOLVER_VARMOD_BOSS", "COMPONENT_REVOLVER_VARMOD_GOON"},    -- ["WEAPON_COMBATMG"] = {"COMPONENT_COMBATMG_CLIP_02", "COMPONENT_AT_SCOPE_MEDIUM", "COMPONENT_AT_AR_AFGRIP"},
    -- ["WEAPON_COMBATPDW"] = {"COMPONENT_COMBATPDW_CLIP_02", "COMPONENT_COMBATPDW_CLIP_03", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_SMALL", "COMPONENT_AT_AR_AFGRIP"},
    -- ["WEAPON_GUSENBERG"] = {"COMPONENT_GUSENBERG_CLIP_02"},
    -- ["WEAPON_MACHINEPISTOL"] = {"COMPONENT_MACHINEPISTOL_CLIP_02", "COMPONENT_MACHINEPISTOL_CLIP_03", "COMPONENT_AT_PI_SUPP"},
    -- ["WEAPON_MG"] = {"COMPONENT_MG_CLIP_02", "COMPONENT_AT_SCOPE_SMALL_02"},-- ["WEAPON_SAWNOFFSHOTGUN"] = {"COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE"},
    -- ["WEAPON_ADVANCEDRIFLE"] = {"COMPONENT_ADVANCEDRIFLE_CLIP_02", "COMPONENT_AT_SCOPE_SMALL", "COMPONENT_AT_AR_SUPP", "COMPONENT_AT_AR_FLSH", "COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE"},
    -- ["WEAPON_ASSAULTRIFLE"] = {"COMPONENT_ASSAULTRIFLE_CLIP_02", "COMPONENT_ASSAULTRIFLE_CLIP_03", "COMPONENT_AT_SCOPE_MACRO", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_AT_AR_AFGRIP", "COMPONENT_AT_AR_FLSH", "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"},
    -- ["WEAPON_BULLPUPRIFLE"] = {"COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_AT_AR_AFGRIP"},
    -- ["WEAPON_CARBINERIFLE"] = {"COMPONENT_CARBINERIFLE_CLIP_02", "COMPONENT_CARBINERIFLE_CLIP_03", "COMPONENT_AT_SCOPE_MEDIUM", "COMPONENT_AT_AR_SUPP", "COMPONENT_AT_AR_AFGRIP", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_RAILCOVER_01", "COMPONENT_CARBINERIFLE_VARMOD_LUXE"},
        -- ["WEAPON_ASSAULTSHOTGUN"] = {"COMPONENT_ASSAULTSHOTGUN_CLIP_02", "COMPONENT_AT_AR_SUPP", "COMPONENT_AT_AR_AFGRIP", "COMPONENT_AT_AR_FLSH"},
    -- ["WEAPON_BULLPUPSHOTGUN"] = {"COMPONENT_BULLPUPRIFLE_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_SCOPE_SMALL", "COMPONENT_AT_AR_SUPP", "COMPONENT_AT_AR_AFGRIP", "COMPONENT_BULLPUPRIFLE_VARMOD_LOW"},
    -- ["WEAPON_HEAVYSHOTGUN"] = {"COMPONENT_HEAVYSHOTGUN_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_SUPP_02", "COMPONENT_AT_AR_AFGRIP"},
       -- ["WEAPON_GRENADELAUNCHER"] = {"COMPONENT_AT_SCOPE_SMALL", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_AFGRIP"},
    -- ["WEAPON_GRENADELAUNCHER_SMOKE"] = {"COMPONENT_AT_SCOPE_SMALL", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_AFGRIP"},
    -- ["WEAPON_HEAVYSNIPER"] = {"COMPONENT_AT_SCOPE_LARGE"}, 
    -- ["WEAPON_MARKSMANRIFLE"] = {"COMPONENT_MARKSMANRIFLE_CLIP_02", "COMPONENT_AT_AR_FLSH", "COMPONENT_AT_AR_SUPP", "COMPONENT_AT_AR_AFGRIP", "COMPONENT_MARKSMANRIFLE_VARMOD_LUXE"},
}