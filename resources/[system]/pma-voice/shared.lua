Cfg = {
	voiceModes = {
		{3.0, "Whisper"}, -- Whisper speech distance in gta distance units
		{17.0, "Normal"}, -- Normal speech distance in gta distance units
		{30.0, "Shouting"} -- Shout speech distance in gta distance units
	},
	radioEnabled = true, -- Enable or disable using the radio
	micClicks = true, -- Are clicks enabled or not
	radioPressed = false,

	radioChannelOverrides = { -- Add named radio channels (Defaults to [channel number] MHz)
		"[R] LS Police 1",
		"[R] LS Police 2",
		"[R] LS Police 3",
		"[R] Operations 1",
		"[R] LS NHS 1",
		"[R] LS NHS 2",
		"[R] Operations 2",
		"[R] LS Gruppe6 1",
		"[R] LS Gruppe6 2",
		"[R] InterOps 1"
	},
}

radioConfig = {
	Controls = {
		Activator = { -- Open/Close Radio
			Name = "INPUT_VEH_HEADLIGHT", -- Control name
			Key = 74, -- H
		},
		Secondary = {
			Name = "INPUT_SPRINT",
			Key = 21, -- Left Shift
			Enabled = true, -- Require secondary to be pressed to open radio with Activator
		},
		Toggle = { -- Toggle radio on/off
			Name = "INPUT_CONTEXT", -- Control name
			Key = 51, -- E
		},
		Increase = { -- Increase Frequency
			Name = "INPUT_CELLPHONE_RIGHT", -- Control name
			Key = 175, -- Right Arrow
			Pressed = false,
		},
		Decrease = { -- Decrease Frequency
			Name = "INPUT_CELLPHONE_LEFT", -- Control name
			Key = 174, -- Left Arrow
			Pressed = false,
		},
		Input = { -- Choose Frequency
			Name = "INPUT_FRONTEND_ACCEPT", -- Control name
			Key = 201, -- Enter
			Pressed = false,
		},
		Broadcast = {
			Name = "INPUT_INTERACTION_MENU", -- Control name
			Key = 244, -- Caps Lock
		},
		ToggleClicks = { -- Toggle radio click sounds
			Name = "INPUT_SELECT_WEAPON", -- Control name
			Key = 37, -- Tab
		}
	},
	Frequency = {
		Private = { -- List of private frequencies
			[1] = true,
			[2] = true,
			[3] = true,
			[4] = true,
			[5] = true,
			[6] = true,
			[7] = true,
			[8] = true,
			[9] = true,
			[10] = true,
			[11] = true,
			[12] = true,
		}, -- List of private frequencies
		Current = 1, -- Don't touch
		CurrentIndex = 1, -- Don't touch
		Min = 1, -- Minimum frequency
		Max = 1000, -- Max number of frequencies
		List = {}, -- Frequency list, Don't touch
		Access = {}, -- List of freqencies a player has access to
	},
	AllowRadioWhenClosed = true -- Allows the radio to be used when not open (uses police radio animation)
}