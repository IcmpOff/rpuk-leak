-- Taken from _SetSlotScaleformTheme in casino_slots.c
SLOT_THEME_TO_SCALEFORM_THEME = {6, 2, 3, 7, 4, 5, 1, 8}

-- Taken from _GetSlotTextureDictName in casino_slots.c
SLOT_THEME_TO_TEXTURE_DICT = {
	"CasinoUI_Slots_Angel",
	"CasinoUI_Slots_Impotent",
	"CasinoUI_Slots_Ranger",
	"CasinoUI_Slots_Fame",
	"CasinoUI_Slots_Deity",
	"CasinoUI_Slots_Knife",
	"CasinoUI_Slots_Diamond",
	"CasinoUI_Slots_Evacuator"
}

SLOT_THEME_TO_NAME = {
	"Angel Knight",
	"Impotent Rage",
	"Space Rangers",
	"Fame or Shame",
	"Deity of the Sun",
	"Twilight Knife",
	"Diamond Miner",
	"Evacuator"
}

SLOT_THEME_TO_BET_VALUE = {
	100, -- Angel
	25, -- Impotent
	25, -- Ranger
	5, -- Fame
	100, -- Deity
	100, -- Knife
	100, -- Diamond
	5 -- Evacuator
}

-- Whole integers only please!
SLOT_RESULT_CHANCE = {
	8,
	1, -- this is our main problematic one
	8,
	8,
	8,
	8,
	1 -- this is only a win if all 3 show, so you have to be lucky
}
SLOT_RESULT_CHANCE_SUM = 0
for _, v in pairs(SLOT_RESULT_CHANCE) do
	SLOT_RESULT_CHANCE_SUM = SLOT_RESULT_CHANCE_SUM + v
end

SLOT_RESULT_TO_NAME = {
	-- Angel Knight
	-- 1 Throwing Star: 2x~n~2 Throwing Stars: 5x~n~3 Throwing Stars: 500x~n~3 Cherries: 25x~n~3 Plums: 50x~n~3 Melons: 75x~n~3 Bells: 100x~n~3 Sevens: 250x~n~3 Keytars: 1000x
	{
		"Seven", "Throwing Star", "Cherries", "Bell", "Plum", "Melon", "Keytars"
	},
	-- Impotent Rage
	-- 1 Lightning Bolt: 2x~n~2 Lightning Bolts: 5x~n~3 Lightning Bolts: 500x~n~3 Cherries: 25x~n~3 Plums: 50x~n~3 Melons: 75x~n~3 Bells: 100x~n~3 Sevens: 250x~n~3 Impotent Rage: 1000x
	{
		"Seven", "Lightning Bolt", "Cherries", "Bell", "Plum", "Melon", "Impotent Rage"
	},
	-- Space Rangers
	-- 1 Bottle: 2x~n~2 Bottles: 5x~n~3 Bottles: 500x~n~3 Cherries: 25x~n~3 Plums: 50x~n~3 Melons: 75x~n~3 Bells: 100x~n~3 Sevens: 250x~n~3 Republican Space Rangers: 1000x
	{
		"Seven", "Bottle", "Cherries", "Bell", "Plum", "Melon", "Republican Space Rangers"
	},
	-- Fame or Shame
	-- 1 Microphone: 2x~n~2 Microphones: 5x~n~3 Microphones: 500x~n~3 Cherries: 25x~n~3 Plums: 50x~n~3 Melons: 75x~n~3 Bells: 100x~n~3 Sevens: 250x~n~3 Superstars: 1000x
	{
		"Seven", "Microphone", "Cherries", "Bell", "Plum", "Melon", "Superstars"
	},
	-- Deity of the Sun
	-- 1 Ankh: 2x~n~2 Ankhs: 5x~n~3 Ankhs: 500x~n~3 Cherries: 25x~n~3 Plums: 50x~n~3 Melons: 75x~n~3 Bells: 100x~n~3 Sevens: 250x~n~3 Pharaohs: 1000x
	{
		"Seven", "Anhk", "Cherries", "Bell", "Plum", "Melon", "Pharoh"
	},
	-- Twilight Knife
	-- 1 Knife: 2x~n~2 Knives: 5x~n~3 Knives: 500x~n~3 Cherries: 25x~n~3 Plums: 50x~n~3 Melons: 75x~n~3 Bells: 100x~n~3 Sevens: 250x~n~3 Chainsaws: 1000x
	{
		"Seven", "Knife", "Cherries", "Bell", "Plum", "Melon", "Chainsaw"
	},
	-- Diamond Miner
	-- 1 Diamond: 2x~n~2 Diamonds: 5x~n~3 Diamonds: 500x~n~3 Cherries: 25x~n~3 Plums: 50x~n~3 Melons: 75x~n~3 Bells: 100x~n~3 Sevens: 250x~n~3 Diamond Sets: 1000x
	{
		"Seven", "Diamond", "Cherries", "Bell", "Plum", "Melon", "Diamond Sets"
	},
	-- Evacuator
	-- 1 Sock: 2x~n~2 Socks: 5x~n~3 Socks: 500x~n~3 Grenades: 25x~n~3 Plums: 50x~n~3 Melons: 75x~n~3 Bells: 100x~n~3 Sevens: 250x~n~3 RPGs: 1000x
	{
		"Seven", "Sock", "Cherries", "Bell", "Plum", "Melon", "RPG"
	}
}

SLOT_REELPOS_TO_RESULT = {
	1, -- Sevens
	2, -- Ankh
	3, -- Cherries
	4, -- Bell
	5, -- Plum
	2, -- Ankh
	6, -- Melon
	5, -- Plum
	1, -- Sevens
	4, -- Bell
	3, -- Cherries
	7, -- Pharoh
	2, -- Ankh
	6, -- Melon
	3, -- Cherries
	5 -- Plum
}

-- Generate a reverse LUT for the SLOT_REELPOS_TO_RESULT
SLOT_RESULT_TO_REELPOS = {}

for i, posValue in pairs(SLOT_REELPOS_TO_RESULT) do
	if SLOT_RESULT_TO_REELPOS[posValue] == nil then
		SLOT_RESULT_TO_REELPOS[posValue] = {}
	end

	table.insert(SLOT_RESULT_TO_REELPOS[posValue], i)
end

SLOT_THEME_TO_SOUNDS = {
	"dlc_vw_casino_slot_machine_ak_player_sounds",
	"dlc_vw_casino_slot_machine_ir_player_sounds",
	"dlc_vw_casino_slot_machine_rsr_player_sounds",
	"dlc_vw_casino_slot_machine_fs_player_sounds",
	"dlc_vw_casino_slot_machine_ds_player_sounds",
	"dlc_vw_casino_slot_machine_kd_player_sounds",
	"dlc_vw_casino_slot_machine_td_player_sounds",
	"dlc_vw_casino_slot_machine_hz_player_sounds"
}

SLOT_WIN_TABLE = {
	-- Three sevens
	["1"] = {
		["1"] = {
			["1"] = 250
		}
	},
	["2"] = {
		["default"] = 2, -- one normal

		["2"] = {
			["default"] = 5, -- two normals

			["2"] = 500 -- three normals
		}
	},
	["3"] = {
		["3"] = {
			["3"] = 25 -- three cherries
		}
	},
	["4"] = {
		["4"] = {
			["4"] = 100 -- three bells
		}
	},
	["5"] = {
		["5"] = {
			["5"] = 50 -- three plums
		}
	},
	["6"] = {
		["6"] = {
			["6"] = 75 -- three melons
		}
	},
	["7"] = {
		["7"] = {
			["7"] = 1000 -- three specials
		}
	}
}

-- Left to right
SLOT_REEL_OFFSETS = {
	{ -0.115, 0.047, 0.906 },
	{ 0.005, 0.047, 0.906 },
	{ 0.125, 0.047, 0.906 }
}

SLOT_MACHINES = {
	{
		['position'] = { 1100.483, 230.4082, -50.8409 };
		['heading'] = 45.0,
		['theme'] = 4
	},

	{
		['position'] = { 1100.939, 231.0017, -50.8409 };
		['heading'] = 60.0,
		['theme'] = 5
	},

	{
		['position'] = { 1101.221, 231.6943, -50.8409 };
		['heading'] = 75.0,
		['theme'] = 6
	},

	{
		['position'] = { 1101.323, 232.4321, -50.8409 };
		['heading'] = 90.0,
		['theme'] = 7
	},

	{
		['position'] = { 1101.229, 233.1719, -50.8409 };
		['heading'] = 105.0,
		['theme'] = 8
	},

	{
		['position'] = { 1108.938, 239.4797, -50.8409 };
		['heading'] = 360.0 - 45.0,
		['theme'] = 1
	},

	{
		['position'] = { 1109.536, 239.0278, -50.8409 };
		['heading'] = 360.0 - 30.0,
		['theme'] = 2
	},

	{
		['position'] = { 1110.229, 238.7428, -50.8409 };
		['heading'] = 360.0 - 15.0,
		['theme'] = 3
	},

	{
		['position'] = { 1110.974, 238.642, -50.8409 };
		['heading'] = 0.0,
		['theme'] = 4
	},

	{
		['position'] = { 1111.716, 238.7384, -50.8409 };
		['heading'] = 15.0,
		['theme'] = 5
	},

	{
		['position'] = { 1112.407, 239.0216, -50.8409 };
		['heading'] = 30.0,
		['theme'] = 6
	},

	{
		['position'] = { 1112.999, 239.4742, -50.8409 };
		['heading'] = 45.0,
		['theme'] = 7
	},

	{
		['position'] = { 1120.853, 233.1621, -50.8409 };
		['heading'] = 360.0 - 105.0,
		['theme'] = 1
	},

	{
		['position'] = { 1120.753, 232.4272, -50.8409 };
		['heading'] = 360.0 - 90.0,
		['theme'] = 2
	},

	{
		['position'] = { 1120.853, 231.6886, -50.8409 };
		['heading'] = 360.0 - 75.0,
		['theme'] = 3
	},

	{
		['position'] = { 1121.135, 230.9999, -50.8409 };
		['heading'] = 360.0 - 60.0,
		['theme'] = 4
	},

	{
		['position'] = { 1121.592, 230.4106, -50.8409 };
		['heading'] = 360.0 - 45.0,
		['theme'] = 5
	},

	{
		['position'] = { 1104.572, 229.4451, -50.8409 };
		['heading'] = 360.0 - 36.0,
		['theme'] = 4
	},

	{
		['position'] = { 1104.302, 230.3183, -50.8409 };
		['heading'] = 360.0 - 108.0,
		['theme'] = 5
	},

	{
		['position'] = { 1105.049, 230.845, -50.8409 };
		['heading'] = 180.0,
		['theme'] = 1
	},

	{
		['position'] = { 1105.781, 230.2973, -50.8409 };
		['heading'] = 108.0,
		['theme'] = 2
	},

	{
		['position'] = { 1105.486, 229.4322, -50.8409 };
		['heading'] = 36.0,
		['theme'] = 3
	},

	{
		['position'] = { 1108.005, 233.9177, -50.8409 };
		['heading'] = 360.0 - 36.0,
		['theme'] = 7
	},

	{
		['position'] = { 1107.735, 234.7909, -50.8409 };
		['heading'] = 360.0 - 108.0,
		['theme'] = 8
	},

	{
		['position'] = { 1108.482, 235.3176, -50.8409 };
		['heading'] = 180.0,
		['theme'] = 4
	},

	{
		['position'] = { 1109.214, 234.7699, -50.8409 };
		['heading'] = 108.0,
		['theme'] = 5
	},

	{
		['position'] = { 1108.919, 233.9048, -50.8409 };
		['heading'] = 36.0,
		['theme'] = 6
	},

	{
		['position'] = { 1113.64, 233.6755, -50.8409 };
		['heading'] = 360.0 - 36.0,
		['theme'] = 4
	},

	{
		['position'] = { 1113.37, 234.5486, -50.8409 };
		['heading'] = 360.0 - 108.0,
		['theme'] = 5
	},

	{
		['position'] = { 1114.117, 235.0753, -50.8409 };
		['heading'] = 180.0,
		['theme'] = 1
	},

	{
		['position'] = { 1114.848, 234.5277, -50.8409 };
		['heading'] = 108.0,
		['theme'] = 2
	},

	{
		['position'] = { 1114.554, 233.6625, -50.8409 };
		['heading'] = 36.0,
		['theme'] = 3
	},

	{
		['position'] = { 1116.662, 228.8896, -50.8409 };
		['heading'] = 360.0 - 36.0,
		['theme'] = 7
	},

	{
		['position'] = { 1116.392, 229.7628, -50.8409 };
		['heading'] = 360.0 - 108.0,
		['theme'] = 8
	},

	{
		['position'] = { 1117.139, 230.2895, -50.8409 };
		['heading'] = 180.0,
		['theme'] = 4
	},

	{
		['position'] = { 1117.871, 229.7419, -50.8409 };
		['heading'] = 108.0,
		['theme'] = 5
	},

	{
		['position'] = { 1117.576, 228.8767, -50.8409 };
		['heading'] = 36.0,
		['theme'] = 6
	},

	{
		['position'] = { 1129.64, 250.451, -52.0409 };
		['heading'] = 180.0,
		['theme'] = 8
	},

	{
		['position'] = { 1130.376, 250.3577, -52.0409 };
		['heading'] = 165.0,
		['theme'] = 7
	},

	{
		['position'] = { 1131.062, 250.0776, -52.0409 };
		['heading'] = 150.0,
		['theme'] = 6
	},

	{
		['position'] = { 1131.655, 249.6264, -52.0409 };
		['heading'] = 135.0,
		['theme'] = 5
	},

	{
		['position'] = { 1132.109, 249.0355, -52.0409 };
		['heading'] = 120.0,
		['theme'] = 4
	},

	{
		['position'] = { 1132.396, 248.3382, -52.0409 };
		['heading'] = 105.0,
		['theme'] = 3
	},

	{
		['position'] = { 1132.492, 247.5984, -52.0409 };
		['heading'] = 90.0,
		['theme'] = 2
	},

	{
		['position'] = { 1133.952, 256.1037, -52.0409 };
		['heading'] = 360.0 - 45.0,
		['theme'] = 3
	},

	{
		['position'] = { 1133.827, 256.9098, -52.0409 };
		['heading'] = 360.0 - 117.0,
		['theme'] = 4
	},

	{
		['position'] = { 1134.556, 257.2778, -52.0409 };
		['heading'] = 171.0,
		['theme'] = 5
	},

	{
		['position'] = { 1135.132, 256.699, -52.0409 };
		['heading'] = 99.0,
		['theme'] = 1
	},

	{
		['position'] = { 1134.759, 255.9734, -52.0409 };
		['heading'] = 27.0,
		['theme'] = 2
	},

	{
		['position'] = { 1138.195, 251.8611, -52.0409 };
		['heading'] = 360.0 - 45.0,
		['theme'] = 6
	},

	{
		['position'] = { 1138.07, 252.6677, -52.0409 };
		['heading'] = 360.0 - 117.0,
		['theme'] = 7
	},

	{
		['position'] = { 1138.799, 253.0363, -52.0409 };
		['heading'] = 171.0,
		['theme'] = 8
	},

	{
		['position'] = { 1139.372, 252.4563, -52.0409 };
		['heading'] = 99.0,
		['theme'] = 4
	},

	{
		['position'] = { 1139, 251.7306, -52.0409 };
		['heading'] = 27.0,
		['theme'] = 5
	}
}

SLOT_ENTER_ANIMS = {"enter_left", "enter_right", "enter_left_short", "enter_right_short"}

STRING_DEFS = {
	{"SLOTS_RT_BET", "Bet"},
	{"SLOTS_RT_LSTWIN", "Last Win"},
	{"SLOTS_MESN101", "Barf Me Out!"},
	{"SLOTS_MESP101", "Awesome!"},
	{"SLOTS_MESN102", "Not Even!"},
	{"SLOTS_MESP102", "Tubular"},
	{"SLOTS_MESN103", "Grody!"},
	{"SLOTS_MESP103", "Wow!"},
	{"SLOTS_MESN104", "Gnarly"},
	{"SLOTS_MESP104", "Fantastic!"},
	{"SLOTS_MESN105", "Oh. My. God."},
	{"SLOTS_MESP105", "Groovy"},
	{"SLOTS_MESN106", "Take a Chill Pill"},
	{"SLOTS_MESP106", "Radical!"},
	{"SLOTS_MESN107", "So Lame!"},
	{"SLOTS_MESP107", "Righteous!"},
	{"SLOTS_MESN108", "Hoser"},
	{"SLOTS_MESP108", "Like Totally!"},
	{"SLOTS_MESN109", "Spazz"},
	{"SLOTS_MESP109", "Clutch!"},
	{"SLOTS_MESN110", "You're Trippin'"},
	{"SLOTS_MESP110", "Illin!"},
	{"SLOTS_MESN111", "Harsh!"},
	{"SLOTS_MESP111", "Sick!"},
	{"SLOTS_MESN112", "Gag Me!"},
	{"SLOTS_MESP112", "Tight"},
	{"SLOTS_MESN113", "Bummer Dude!"},
	{"SLOTS_MESP113", "Bitchin'!"},
	{"SLOTS_MESN114", "Bogus!"},
	{"SLOTS_MESP114", "Totally Studly!"},
	{"SLOTS_MESN115", "Major Buzz Kill!"},
	{"SLOTS_MESP115", "Whoa!"},
	{"SLOTS_MESN116", "Wipe out!"},
	{"SLOTS_MESP116", "Sweet!"},
	{"SLOTS_MESN201", "Trigger Warning!"},
	{"SLOTS_MESP201", "You Can Do It!"},
	{"SLOTS_MESN202", "Not Fair!"},
	{"SLOTS_MESP202", "Breathe Deep!"},
	{"SLOTS_MESN203", "Pout!"},
	{"SLOTS_MESP203", "Keep It Up!"},
	{"SLOTS_MESN204", "Conservatives Suck!"},
	{"SLOTS_MESP204", "Stay Positive!"},
	{"SLOTS_MESN205", "Blame Conservatives!"},
	{"SLOTS_MESP205", "You're a Good Person"},
	{"SLOTS_MESN206", "Call Your Therapist"},
	{"SLOTS_MESP206", "You're in a Safe Space"},
	{"SLOTS_MESN207", "Feeling Oppressed?"},
	{"SLOTS_MESP207", "Virtue Signal!"},
	{"SLOTS_MESN208", "Trolled!"},
	{"SLOTS_MESP208", "You're No Snowflake!"},
	{"SLOTS_MESN209", "Check Your Privilege"},
	{"SLOTS_MESP209", "Do Yoga!"},
	{"SLOTS_MESN210", "Support Public Radio"},
	{"SLOTS_MESP210", "Meditate More!"},
	{"SLOTS_MESN211", "You're Not Woke!"},
	{"SLOTS_MESP211", "You Make a Difference!"},
	{"SLOTS_MESN212", "Be Conscious of Your Bias!"},
	{"SLOTS_MESP212", "Recycle!"},
	{"SLOTS_MESN213", "Don't Be a Troll!"},
	{"SLOTS_MESP213", "You're Precious!"},
	{"SLOTS_MESN214", "Woke!"},
	{"SLOTS_MESP214", "Enlightenment!"},
	{"SLOTS_MESN215", "Breathe Deep"},
	{"SLOTS_MESP215", "Mindfulness!"},
	{"SLOTS_MESN216", "Downvote!"},
	{"SLOTS_MESP216", "Acknowledge Privilege!"},
	{"SLOTS_MESN301", "Ouch!"},
	{"SLOTS_MESP301", "Lock and Load!"},
	{"SLOTS_MESN302", "That Ain't Good!"},
	{"SLOTS_MESP302", "Shoot One Off"},
	{"SLOTS_MESN303", "What the Hell?"},
	{"SLOTS_MESP303", "Get Some!"},
	{"SLOTS_MESN304", "Dead as Hell!"},
	{"SLOTS_MESP304", "Mission Accomplished!"},
	{"SLOTS_MESN305", "Well I'll Be!"},
	{"SLOTS_MESP305", "You're a Patriot!"},
	{"SLOTS_MESN306", "You Even Tryin'?"},
	{"SLOTS_MESP306", "Mericuh!"},
	{"SLOTS_MESN307", "Shucks!"},
	{"SLOTS_MESP307", "Yee-Hah!"},
	{"SLOTS_MESN308", "Confoundit!"},
	{"SLOTS_MESP308", "Let's Do This!"},
	{"SLOTS_MESN309", "Dagnabbit!"},
	{"SLOTS_MESP309", "Y'all Havin Fun?"},
	{"SLOTS_MESN310", "Well Crud!"},
	{"SLOTS_MESP310", "Be a Hero!"},
	{"SLOTS_MESN311", "Blame Foreigners"},
	{"SLOTS_MESP311", "Oorah!"},
	{"SLOTS_MESN312", "Friggin Bullshit!"},
	{"SLOTS_MESP312", "Target Acquired!"},
	{"SLOTS_MESN313", "Total ClusterF!"},
	{"SLOTS_MESP313", "Nuke'Em from Orbit!"},
	{"SLOTS_MESN314", "FUBAR!"},
	{"SLOTS_MESP314", "Alien BBQ!"},
	{"SLOTS_MESN315", "Man Down!"},
	{"SLOTS_MESP315", "Freedoms Protected!"},
	{"SLOTS_MESN316", "KIA!"},
	{"SLOTS_MESP316", "Darn Tootin'!"},
	{"SLOTS_MESN401", "Shamed!"},
	{"SLOTS_MESP401", "Famed!"},
	{"SLOTS_MESN402", "Embarrassing!"},
	{"SLOTS_MESP402", "Fame!"},
	{"SLOTS_MESN403", "Terrible!"},
	{"SLOTS_MESP403", "You Can Do It!"},
	{"SLOTS_MESN404", "How Awful!"},
	{"SLOTS_MESP404", "You're SO Talented"},
	{"SLOTS_MESN405", "Voted Off!"},
	{"SLOTS_MESP405", "You're a Star"},
	{"SLOTS_MESN406", "So Sorry!"},
	{"SLOTS_MESP406", "Be Amazing!"},
	{"SLOTS_MESN407", "That's a Fail!"},
	{"SLOTS_MESP407", "Do It!"},
	{"SLOTS_MESN408", "Well That Sucked!"},
	{"SLOTS_MESP408", "You're Number One!"},
	{"SLOTS_MESN409", "No Talent!"},
	{"SLOTS_MESP409", "You Got This!"},
	{"SLOTS_MESN410", "Is That You Lazlow?"},
	{"SLOTS_MESP410", "You're the Best!"},
	{"SLOTS_MESN411", "Suicide Watch!"},
	{"SLOTS_MESP411", "You're #1"},
	{"SLOTS_MESN412", "Dropped by Sponsors"},
	{"SLOTS_MESP412", "Be Unstoppable!"},
	{"SLOTS_MESN413", "Career OVER!"},
	{"SLOTS_MESP413", "Terrifyingly Talented!"},
	{"SLOTS_MESN414", "Upstaged!"},
	{"SLOTS_MESP414", "You're on FIRE!"},
	{"SLOTS_MESN415", "Boooo!"},
	{"SLOTS_MESP415", "So Hawt!"},
	{"SLOTS_MESN416", "What a Disaster!"},
	{"SLOTS_MESP416", "America's Darling!"},
	{"SLOTS_MESN501", "You Have Been Cursed!"},
	{"SLOTS_MESP501", "You Have Been Blessed!"},
	{"SLOTS_MESN502", "The Gods Are Enraged!"},
	{"SLOTS_MESP502", "The Pharaoh is Pleased!"},
	{"SLOTS_MESN503", "You Angered the Gods!"},
	{"SLOTS_MESP503", "Bask in the Glow!"},
	{"SLOTS_MESN504", "Ruined!"},
	{"SLOTS_MESP504", "Glory Awaits!"},
	{"SLOTS_MESN505", "Hope Eclipsed!"},
	{"SLOTS_MESP505", "The Gods are Pleased!"},
	{"SLOTS_MESN506", "Kingdom Ruined"},
	{"SLOTS_MESP506", "The Sphinx Awaits!"},
	{"SLOTS_MESN507", "Dynasty in Shambles"},
	{"SLOTS_MESP507", "Build the Pyramids!"},
	{"SLOTS_MESN508", "Life's a Desert"},
	{"SLOTS_MESP508", "Conquered!"},
	{"SLOTS_MESN509", "Tomb Prepared!"},
	{"SLOTS_MESP509", "Riches Await!"},
	{"SLOTS_MESN510", "Afterlife Awaits"},
	{"SLOTS_MESP510", "Prosperity is Coming!"},
	{"SLOTS_MESN511", "Dead and Buried"},
	{"SLOTS_MESP511", "Hail the New Pharaoh!"},
	{"SLOTS_MESN512", "Sands Take You!"},
	{"SLOTS_MESP512", "You Are the Golden God!"},
	{"SLOTS_MESN513", "Your Fate is Sealed"},
	{"SLOTS_MESP513", "You Are Legend!"},
	{"SLOTS_MESN514", "Dynasty in Ruins!"},
	{"SLOTS_MESP514", "Cats Are Great!"},
	{"SLOTS_MESN515", "Empire Destroyed!"},
	{"SLOTS_MESP515", "Magnificent Ruler!"},
	{"SLOTS_MESN516", "Mummified!"},
	{"SLOTS_MESP516", "A Bountiful Return!"},
	{"SLOTS_MESN601", "Wasted"},
	{"SLOTS_MESP601", "Take a Stab"},
	{"SLOTS_MESN602", "Murdered"},
	{"SLOTS_MESP602", "Make a Killing"},
	{"SLOTS_MESN603", "What a Massacre"},
	{"SLOTS_MESP603", "Kill it!"},
	{"SLOTS_MESN604", "Stabbed"},
	{"SLOTS_MESP604", "Time to Kill It!"},
	{"SLOTS_MESN605", "Annihilated!"},
	{"SLOTS_MESP605", "Play!"},
	{"SLOTS_MESN606", "Dead"},
	{"SLOTS_MESP606", "Slay It!"},
	{"SLOTS_MESN607", "Foul Play!"},
	{"SLOTS_MESP607", "Time for Blood"},
	{"SLOTS_MESN608", "Done!"},
	{"SLOTS_MESP608", "Slaughter It!"},
	{"SLOTS_MESN609", "Cooked!"},
	{"SLOTS_MESP609", "Be the Hunter!"},
	{"SLOTS_MESN610", "Slaughtered"},
	{"SLOTS_MESP610", "Bathe in Blood!"},
	{"SLOTS_MESN611", "What a Horror!"},
	{"SLOTS_MESP611", "Kill 'Em All!"},
	{"SLOTS_MESN612", "Destroyed"},
	{"SLOTS_MESP612", "No Remorse!"},
	{"SLOTS_MESN613", "You're the Victim!"},
	{"SLOTS_MESP613", "Draw First Blood!"},
	{"SLOTS_MESN614", "Fried"},
	{"SLOTS_MESP614", "More Body Bags!"},
	{"SLOTS_MESN615", "No Escape!"},
	{"SLOTS_MESP615", "You're a Cutter!"},
	{"SLOTS_MESN616", "Eradicated!"},
	{"SLOTS_MESP616", "Chop, Chop!"},
	{"SLOTS_MESN701", "Busted"},
	{"SLOTS_MESP701", "What a Tycoon!"},
	{"SLOTS_MESN702", "Broke!"},
	{"SLOTS_MESP702", "Magnate!"},
	{"SLOTS_MESN703", "Ouch!"},
	{"SLOTS_MESP703", "Get Mining!"},
	{"SLOTS_MESN704", "Bankrupt!"},
	{"SLOTS_MESP704", "So Prosperous!"},
	{"SLOTS_MESN705", "Chapter 11"},
	{"SLOTS_MESP705", "Loaded!"},
	{"SLOTS_MESN706", "That hurts!"},
	{"SLOTS_MESP706", "Dividends!"},
	{"SLOTS_MESN707", "Strapped for Cash!"},
	{"SLOTS_MESP707", "Bling!"},
	{"SLOTS_MESN708", "Soup Line!"},
	{"SLOTS_MESP708", "Priceless!"},
	{"SLOTS_MESN709", "Urgh!"},
	{"SLOTS_MESP709", "Rolling in It!"},
	{"SLOTS_MESN710", "You're No One!"},
	{"SLOTS_MESP710", "Easy!"},
	{"SLOTS_MESN711", "Worthless"},
	{"SLOTS_MESP711", "Impeccable Taste!"},
	{"SLOTS_MESN712", "Spent!"},
	{"SLOTS_MESP712", "So Extravagant!"},
	{"SLOTS_MESN713", "Bounced!"},
	{"SLOTS_MESP713", "Minted!"},
	{"SLOTS_MESN714", "Ruined!"},
	{"SLOTS_MESP714", "Fat Cat!"},
	{"SLOTS_MESN715", "Destitute!"},
	{"SLOTS_MESP715", "High Class!"},
	{"SLOTS_MESN716", "Faker!"},
	{"SLOTS_MESP716", "Sparkling!"},
	{"SLOTS_MESN801", "Washed up!"},
	{"SLOTS_MESP801", "You're Number One!"},
	{"SLOTS_MESN802", "You're C List Now!"},
	{"SLOTS_MESP802", "The 80's Rule!"},
	{"SLOTS_MESN803", "Vinewood Hates You!"},
	{"SLOTS_MESP803", "You Won the War!"},
	{"SLOTS_MESN804", "The 80's Are Over!"},
	{"SLOTS_MESP804", "Be an Action Hero!"},
	{"SLOTS_MESN805", "Your Career Is Done!"},
	{"SLOTS_MESP805", "America Loves You!"},
	{"SLOTS_MESN806", "Time to Retire"},
	{"SLOTS_MESP806", "Party it Up!"},
	{"SLOTS_MESN807", "You've Been Forgotten!"},
	{"SLOTS_MESP807", "You're Unstoppable!"},
	{"SLOTS_MESN808", "Eliminated"},
	{"SLOTS_MESP808", "You're the Biggest!"},
	{"SLOTS_MESN809", "Wasted"},
	{"SLOTS_MESP809", "You're the Best!"},
	{"SLOTS_MESN810", "Done!"},
	{"SLOTS_MESP810", "It's Never Over"},
	{"SLOTS_MESN811", "See Ya!"},
	{"SLOTS_MESP811", "You Saved America!"},
	{"SLOTS_MESN812", "America Hates You!"},
	{"SLOTS_MESP812", "Over the Top!"},
	{"SLOTS_MESN813", "Straight to DVD"},
	{"SLOTS_MESP813", "Blockbuster!"},
	{"SLOTS_MESN814", "Box Office Bomb!"},
	{"SLOTS_MESP814", "Pumped Up!"},
	{"SLOTS_MESN815", "Recast!"},
	{"SLOTS_MESP815", "Big Leagues!"},
	{"SLOTS_MESN816", "Only Terrorists Lose!"},
	{"SLOTS_MESP816", "Glory Days!"}
}