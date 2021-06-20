
-- When the player is within CASINO_ACTIVIATION_RADIUS of CASINO_POSITION the slot machine scan loop will run
CASINO_POSITION = { x = 1111.050, y = 229.810, z = -49.137 }
CASINO_ACTIVATION_RADIUS = 50

-- Distance between the player and the slot machine to sit down
SLOT_ACTIVATION_DISTANCE = 2

Config = {}
Config.cleanBoardButton = 194 -- 
Config.cleanBoardButtonName = "~INPUT_FRONTEND_RRIGHT~"

Config.addYourNameButton = 191 -- Enter
Config.addYourNameButtonName = "~INPUT_FRONTEND_RDOWN~" -- 

Config.changeRuleDartsButton = 157 -- 1
Config.changeRuleDartsButtonName = "~INPUT_SELECT_WEAPON_UNARMED~"

Config.changeRulePointsButton = 158 -- 
Config.changeRulePointsButtonName = "~INPUT_SELECT_WEAPON_MELEE~"

Config.changeRuleDifficultyButton = 160 -- 
Config.changeRuleDifficultyButtonName = "~INPUT_SELECT_WEAPON_SHOTGUN~"

Config.rotateButton = 25 -- 
Config.rotateButtonName = "~INPUT_AIM~"

Config.exitButton = 194
Config.exitButtonName = "~INPUT_FRONTEND_RRIGHT~"

Config.throwButton = 86 -- 
Config.throwButtonName = "~INPUT_VEH_HORN~"

Config.playercancelRaceButton = 194-- Backspace
Config.playercancelRaceButtonName = "~INPUT_FRONTEND_RRIGHT~"-- Backspace

Config.marker = {
	type = 1,
	rgba = {255, 255, 255, 255},
	height = 0.2,
	size = 1.0

}

-- Helptext
Config.helptext = {}
Config.helptext.x = 0.8 -- Changing this is tricky, may cause problems 
Config.helptext.y = 0.75-- Changing this is tricky, may cause problems (x 0.8 y 0.85 bottom right corner)
Config.helptext.color = 5 -- over 200 colors 1 - 225


lang = {
	["clean_board"] = " Clean board",
	["write_your_name"] = " Name",
	["change_rule_darts"] = " Change rule darts",
	["change_rule_points"] = " Change rule points",
	["change_rule_difficulty"] = " Change rule difficulty",
	["points"] = "Points",
	["darts"] = "Darts",
	["difficulty"] = "Difficulty",
	["rules"] = "Rules",
	["throw"] = " Throw",
	["rotate"] = " Rotate",
	["exit"] = " Stop",
	

}

-- Spawn dartboards where ever you want 
Config.spawnDartboards = {
	vec4(-21.38, -1398.37, 30.44, 270.0), 
	vec4(-4.205, -1823.016, 30.40, 317.9),
	vec4(989.13, -100.39, 75.58, 222.65),
	vec4(987.11, -126.39, 79.49, 329.23),
	vec4(1553.049, 3601.219, 39.478, 120.23),
}

Config.ArcadeMachines = {
	-1501557515,
}


