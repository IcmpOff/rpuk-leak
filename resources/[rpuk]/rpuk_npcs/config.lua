Config = {}

--[[
Please try to maintain catagories and format throughout

For random location generation I have kept drug runs and money wash in their individual files

https://docs.fivem.net/docs/game-references/ped-models/

As I go on, exclusive blips are size 0.9 and mass blips like Standard are 0.7
]]--

Config.Standard = {
	{name = "Casino_BarStaff",	model = "s_m_y_casino_01", x = 1110.11,   y = 208.29,  z = -50.44, h = 81.05, godmode = true, spawnDistance = 50.0, spawnedFlag = false}, -- Casino Bar Staff 1
	{name = "Casino_BarStaff",	model = "s_m_y_casino_01", x = 1113.64,   y = 208.82,  z = -50.44, h = 310.05, godmode = true, spawnDistance = 50.0, spawnedFlag = false}, -- Casino Bar Staff 2
	{name = "Casino_ClothingStaff",	model = "s_m_y_casino_01", x = 1100.39,   y = 195.65,  z = -50.44, h = 313.29, godmode = true, spawnDistance = 50.0, spawnedFlag = false}, -- Casino Clothing Staff 1
	{name = "Casino_TokenStaff",	model = "u_f_m_casinocash_01", x = 1117.41,   y = 219.46,  z = -50.44, h = 70.15, godmode = true, spawnDistance = 50.0, spawnedFlag = false}, -- Casino Token Staff 1
	{name = "Casino_FrontStaff",	model = "s_m_y_casino_01", x = 1087.97,   y = 221.16,  z = -50.20, h = 169.96, godmode = true, spawnDistance = 50.0, spawnedFlag = false}, -- Casino Token Staff 1
	{name = "Casino_Security",	model = "mp_m_securoguard_01", x = 1118.27,   y = 215.41,  z = -49.17, h = 126.60, godmode = false, spawnDistance = 50.0, spawnedFlag = false}, -- Casino Security 1
	{name = "Casino_Security",	model = "mp_m_securoguard_01", x = 1105.10,   y = 262.83,  z = -50.84, h = 176.60, godmode = false, spawnDistance = 50.0, spawnedFlag = false}, -- Casino Security 2
	{name = "Casino_Security",	model = "mp_m_securoguard_01", x = 927.46,   y = 50.68,  z = 81.11, h = 91.43, godmode = false, spawnDistance = 150.0, spawnedFlag = false}, -- Casino Door Security 1
	{name = "Casino_Security",	model = "mp_m_securoguard_01", x = 922.66,   y = 42.55,  z = 81.11, h = 23.36, godmode = false, spawnDistance = 150.0, spawnedFlag = false}, -- Casino Door Security 1
	{name = "Casino_Penthouse_BarStaff", model = "s_m_y_casino_01", x = 946.43,   y = 15.19,  z = 116.16, h = 56.50, godmode = true, spawnDistance = 50.0, spawnedFlag = false}, -- Casino Penthouse Bar Staff 1

	{name = "Hospital_Shower",	model = "a_f_m_beach_01", x = 341.03,   y = -595.95,  z = 42.33, h = 36.03, godmode = true, spawnDistance = 30.0, spawnedFlag = false}, -- Police Station 5

	{name = "TB_Jewellers", model = "s_m_m_highsec_01",  x=-623.193, y=-230.597, z=37.057, h = -220.0, godmode = true, spawnDistance = 50.0,  spawnedFlag = false}, --TBJewellers

	{name = "CityHall_Booth00", model = "u_m_m_fibarchitect",  x=-553.04, y=-188.75, z=37.22, h = 209.19, godmode = true, spawnDistance = 50.0,  spawnedFlag = false}, --TBJewellers
	{name = "CityHall_Booth01", model = "s_m_m_fiboffice_02",  x=-554.662, y=-189.620, z=37.220, h = 209.19, godmode = true, spawnDistance = 50.0,  spawnedFlag = false}, --TBJewellers
	{name = "CityHall_Clerk", model = "s_m_m_fiboffice_02",  x = -556.81, y = -194.33, z = 41.70, h = 250.0, godmode = true, spawnDistance = 50.0,  spawnedFlag = false}, --TBJewellers

	{name = "Prison_Frontdesk",	model = "s_m_m_armoured_01", x = 1835.273,   y = 2590.408,  z = 44.952, h = 144.603, scen = "WORLD_HUMAN_CLIPBOARD", godmode = true, spawnDistance = 50.0, spawnedFlag = false}, -- Prison 1
	{name = "Prison_Booking",	model = "s_m_m_armoured_01", x = 1788.037,   y = 2597.818,  z = 44.798, h = 179.795, scen = "WORLD_HUMAN_CLIPBOARD", godmode = true, spawnDistance = 50.0, spawnedFlag = false}, -- Prison 2
	{name = "Prison_Entrance",	model = "s_m_m_armoured_02", x = 1830.758,   y = 2603.451,  z = 44.889, h = 1.078, scen = "WORLD_HUMAN_CLIPBOARD", godmode = true, spawnDistance = 50.0, spawnedFlag = false}, -- Prison 3

	{name = "Grinder_1",	model = "s_m_y_sheriff_01", x = 2854.52, y = 1564.74, z = 24.73, h = 122.13, scen = "WORLD_HUMAN_CLIPBOARD", godmode = false, spawnDistance = 300.0, spawnedFlag = false}, -- Prison 3
	{name = "Grinder_2",	model = "s_m_m_armoured_02", x = 2824.66, y = 1580.37, z = 24.56, h = 213.64, scen = "WORLD_HUMAN_DRINKING", godmode = false, spawnDistance = 300.0, spawnedFlag = false}, -- Prison 3
	{name = "Grinder_3",	model = "s_m_m_armoured_02", x = 2821.04, y = 1581.31, z = 24.65, h = 348.52, scen = "WORLD_HUMAN_CLIPBOARD", godmode = false, spawnDistance = 300.0, spawnedFlag = false}, -- Prison 3
	{name = "Grinder_4",	model = "s_m_m_armoured_02", x = 2824.87, y = 1578.89, z = 24.56, h = 331.24, scen = "WORLD_HUMAN_COP_IDLES", godmode = false, spawnDistance = 300.0, spawnedFlag = false}, -- Prison 3
	{name = "Grinder_5",	model = "s_m_m_armoured_01", x = 2839.97, y = 1550.15, z = 24.73, h = 320.26, scen = "WORLD_HUMAN_CLIPBOARD", godmode = false, spawnDistance = 300.0, spawnedFlag = false}, -- Prison 3
	{name = "Grinder_6",	model = "s_m_m_armoured_02", x = 2842.80, y = 1540.12, z = 29.38, h = 347.08, scen = "WORLD_HUMAN_SECURITY_SHINE_TORCH", godmode = false, spawnDistance = 300.0, spawnedFlag = false}, -- Prison 3
	{name = "Grinder_7",	model = "s_m_m_armoured_01", x = 2841.50, y = 1536.08, z = 29.38, h = 159.23, scen = "WORLD_HUMAN_BINOCULARS", godmode = false, spawnDistance = 300.0, spawnedFlag = false}, -- Prison 3
	{name = "Grinder_8",	model = "s_m_m_armoured_02", x = 2816.38, y = 1544.98, z = 29.51, h = 127.42, scen = "WORLD_HUMAN_BINOCULARS", godmode = false, spawnDistance = 300.0, spawnedFlag = false}, -- Prison 3
	{name = "Grinder_9",	model = "s_m_m_armoured_01", x = 2834.83, y = 1571.32, z = 29.38, h = 40.32, scen = "WORLD_HUMAN_BINOCULARS", godmode = false, spawnDistance = 300.0, spawnedFlag = false}, -- Prison 3
	{name = "west_garrage",	model = "s_m_y_garbage", x = -625.33087158203, y = 194.52481079102, z = 68.884826660156, h = 80.078, scen = "WORLD_HUMAN_CLIPBOARD", godmode = false, spawnDistance = 300.0, spawnedFlag = false}, -- Prison 3

}

Config.Interations = {
	{name = "Casino_Dirty_Money_Dealer", model = "g_f_y_vagos_01",  x = 1166.033,   y = 251.592,  z = -52.041, h = 178.34, godmode = true, interactionType = "BlackMarket", textDistance = 1.5, spawnDistance = 50.0, spawnedFlag = false},
	{name = "Casino_Dirty_Money_Dealer", model = "a_m_y_epsilon_02",  x = 1133.983,   y = 283.882,  z = -52.041, h = 88.34, godmode = true, interactionType = "BlackMarket", textDistance = 1.5, spawnDistance = 50.0, spawnedFlag = false},

	{name = "Pillbox_Hospital_Medical_Supplies", model = "s_m_m_doctor_01",  x = 308.48,   y = -595.29,  z = 42.28, h = 42.87, godmode = true, textDistance = 2.0, spawnDistance = 50.0,  spawnedFlag = false},
	{name = "Pillbox_Hospital_Medical_Supplies", model = "s_m_m_doctor_01",  x = 311.45,   y = -593.96,  z = 42.28, h = 334.71, godmode = true, interactionType = "shop", shopType = "NHSDesk", textDistance = 2.0, spawnDistance = 50.0,  spawnedFlag = false},
	{name = "Pillbox_Hospital_Medical_Supplies", model = "s_f_y_scrubs_01",  x = 310.99,   y = -565.95,  z = 42.28, h = 255.49, godmode = true, interactionType = "shop", shopType = "NHSDesk", textDistance = 2.0, spawnDistance = 50.0,  spawnedFlag = false},

	--{name = "Halloween_Vendor", model = "s_m_y_clown_01",  x = 329.31, y = -2030.74, z = 20.06, h = 137.02, godmode = true, interactionType = "HalloweenToken", textDistance = 2.0, spawnDistance = 50.0,  spawnedFlag = false},

	{name = "LostMC_ClubhouseBar_00", model = "g_m_y_lost_02",  x = 987.57, y = -95.51, z = 73.85, h = 210.91, godmode = true, interactionType = "lostClubhouseBar", textDistance = 2.0, spawnDistance = 50.0,  spawnedFlag = false},
	{name = "LostMC_ClubhouseBar_01", model = "g_m_y_lost_02",  x = 981.39, y = -131.50, z = 77.89, h = 311.15, godmode = true, interactionType = "lostClubhouseBar", textDistance = 2.0, spawnDistance = 50.0,  spawnedFlag = false},
	{name = "LostMC_ClubhouseBar_02", model = "g_m_y_lost_02",  x = 1984.38, y = 3054.50, z = 46.22, h = 239.68, godmode = true, interactionType = "lostClubhouseBar", textDistance = 2.0, spawnDistance = 50.0,  spawnedFlag = false},

	{name = "Ranger_Meat_Vendor_00", model = "csb_chef",  x = 969.08, y = -2109.67, z = 30.48, h = 68.55, godmode = true, scen = "WORLD_HUMAN_CLIPBOARD", interactionType = "butcherVendor", textDistance = 2.0, spawnDistance = 50.0,  spawnedFlag = false},
	{name = "Warehouse_01", model = "s_m_m_gardener_01",  x = -1063.8377685547, y = -2079.3293457031, z = 12.29150390625, h = -30.55, godmode = true, scen = "WORLD_HUMAN_CLIPBOARD", interactionType = "resourceExport", textDistance = 2.0, spawnDistance = 50.0,  spawnedFlag = false},


	--Tutorial Hints
	{name = "tutorial_01", model = "a_m_y_bevhills_01",  x = 320.288, y = -198.420, z = 53.2, h = 150.83, godmode = true, scen = "WORLD_HUMAN_DRINKING", interactionType = "tutorial", tutorialType = "pinkcage", textDistance = 3.0, spawnDistance = 50.0,  spawnedFlag = false},
	{name = "tutorial_02", model = "s_m_m_fiboffice_02",  x=-554.662, y=-189.620, z=37.220, h = 209.19, godmode = true, interactionType = "tutorial", tutorialType = "cityhall", textDistance = 2.6, spawnDistance = 50.0,  spawnedFlag = false},
	{name = "tutorial_03", model = "mp_s_m_armoured_01",  x=1776.996, y=2590.009, z=44.798, h = 180.51, godmode = true, scen = "WORLD_HUMAN_COP_IDLES", interactionType = "tutorial", tutorialType = "prison", textDistance = 3.6, spawnDistance = 50.0,  spawnedFlag = false},
	{name = "tutorial_04", model = "s_m_y_xmech_01",  x=369.012, y=-1607.762, z=28.292, h = 220.317, godmode = true, scen = "WORLD_HUMAN_LEANING", interactionType = "tutorial", tutorialType = "mechanic", textDistance = 3.6, spawnDistance = 50.0,  spawnedFlag = false},
	{name = "tutorial_05", model = "s_m_y_construct_02",  x=-595.497, y=2094.609, z=130.451, h = 50.317, godmode = true, scen = "WORLD_HUMAN_DRINKING", interactionType = "tutorial", tutorialType = "mining", textDistance = 3.6, spawnDistance = 50.0,  spawnedFlag = false},
	{name = "tutorial_06", model = "g_m_m_armlieut_01",  x=905.059, y=-164.901, z=73.100, h = 250.317, godmode = true, scen = "WORLD_HUMAN_DRINKING", interactionType = "tutorial", tutorialType = "taxi", textDistance = 3.6, spawnDistance = 50.0,  spawnedFlag = false},
	{name = "tutorial_07", model = "u_m_y_burgerdrug_01",  x=-1275.327, y=-885.884, z=10.929, h = 250.317, godmode = true, scen = "WORLD_HUMAN_SMOKING", interactionType = "tutorial", tutorialType = "fooddelivery", textDistance = 3.6, spawnDistance = 50.0,  spawnedFlag = false},
	{name = "tutorial_08", model = "s_m_m_ups_02",  x=1018.360, y=-2525.003, z=27.32, h = 50.317, godmode = true, scen = "WORLD_HUMAN_SMOKING", interactionType = "tutorial", tutorialType = "commercial", textDistance = 3.6, spawnDistance = 50.0,  spawnedFlag = false},
}