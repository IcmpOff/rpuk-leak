Config.Mining = {}

Config.Mining.mainBlip = {
	x = -596.32592773438,
	y = 2089.04296875,
	z = 131.41265869141,
	sprite = 618,
	display = "Mineshaft"
}

Config.Mining.maxSkill = 5

Config.Mining.entrance = vector3(-595.8, 2088.4, 131.4)

Config.Mining.ores = {
	coal = {
		positions = {
			{
				x = -590.28961181641,
				y = 2059.3469238281,
				z = 129.8194732666
			},
		},
		returnedItems = {
			{
				name = "coal",
				count = 1,
			}
		},
		requiredSkill = 0,
		skill = "pro_mining",
		blip = {
			sprite = 618,
			colour = 40,
			display = "Coal"
		},
		text = "Press [E] to mine coal",
		time = 6500,
		skills = {
			increase = {
				pro_mining = 0.001
			},
		}
	},
	copper_ore = {
		positions = {
			{
				x = -562.47448730469,
				y = 2011.8083496094,
				z = 126.38369750977
			},
		},
		returnedItems = {
			{
				name = "copper_ore",
				count = 1,
			}
		},
		requiredSkill = 1,
		skill = "pro_mining",
		blip = {
			sprite =  618,
			colour = 64,
			display = "Copper"
		},
		text = "Press [E] to mine copper",
		time = 6500,
		skills = {
			increase = {
				pro_mining = 0.0008
			},
		}
	},
	ore_iron = {
		positions = {
			{
				x = -579.38629150391,
				y = 2031.1461181641,
				z = 127.49267578125
			},
		},
		returnedItems = {
			{
				name = "ore_iron",
				count = 1,
			}
		},
		requiredSkill = 1,
		skill = "pro_mining",
		blip = {
			sprite = 618,
			colour = 62,
			display = "Iron"
		},
		text = "Press [E] to mine iron",
		time = 6500,
		skills = {
			increase = {
				pro_mining = 0.0008
			},
		}
	},
	silver_ore = {
		positions = {
			{
				x = -547.26483154297,
				y = 1986.0786132813,
				z = 126.1535949707
			},
		},
		returnedItems = {
			{
				name = "silver_ore",
				count = 1,
			}
		},
		requiredSkill = 2,
		skill = "pro_mining",
		blip = {
			sprite = 618,
			colour = 55,
			display = "Silver"
		},
		text = "Press [E] to mine silver",
		time = 6500,
		skills = {
			increase = {
				pro_mining = 0.0007
			},
		}

	},
	titanium_ore = {
		positions = {
			{
				x = -532.14758300781,
				y = 1979.3371582031,
				z = 126.1153717041
			},
		},
		returnedItems = {
			{
				name = "titanium_ore",
				count = 1,
			}
		},
		requiredSkill = 2,
		skill = "pro_mining",
		blip = {
			sprite = 618,
			colour = 57,
			display = "Titanium"
		},
		text = "Press [E] to mine titanium",
		time = 6500,
		skills = {
			increase = {
				pro_mining = 0.0007
			},
		}
	},
	aluminium_ore = {
		positions = {
			{
				x = -540.62969970703,
				y = 1965.2219238281,
				z = 125.80959320068
			},
		},
		returnedItems = {
			{
				name = "aluminium_ore",
				count = 1,
			}
		},
		requiredSkill = 2,
		skill = "pro_mining",
		blip = {
			sprite = 618,
			colour = 39,
			display = "Aluminium"
		},
		text = "Press [E] to mine aluminium",
		time = 6500,
		skills = {
			increase = {
				pro_mining = 0.0007
			},
		}
	},
	potassium_nitrate = {
		positions = {
			{
				x = -554.71337890625,
				y = 1998.8961181641,
				z = 125.8473739624
			}
		},
		returnedItems = {
			{
				name = "potassium_nitrate",
				count = 1,
			}
		},
		requiredSkill = 3,
		skill = "pro_mining",
		blip = {
			sprite = 618,
			color = 45,
			display = "Potassium Nitrate"
		},
		text = "Press [E] to mine potassium nitrate",
		time = 6500,
	},
	sulphur = {
		positions = {
			{
				x = -540.91052246094,
				y = 1972.0069580078,
				z = 125.85345458984
			}
		},
		returnedItems = {
			{
				name = "sulphur",
				count = 1,
			}
		},
		requiredSkill = 2,
		skill = "pro_mining",
		blip = {
			sprite = 618,
			color = 28,
			display = "Sulphuric Acid"
		},
		text = "Press [E] to mine sulphuric acid",
		time = 6500,
	},
	lead_ore = {
		positions = {
			{
				x = -532.47808837891,
				y = 1982.5355224609,
				z = 127.60182952881
			}
		},
		returnedItems = {
			{
				name = "lead_ore",
				count = 1,
			}
		},
		requiredSkill = 3,
		skill = "pro_mining",
		blip = {
			sprite = 618,
			color = 28,
			display = "Lead"
		},
		text = "Press [E] to mine lead",
		time = 6500,
		skills = {
			increase = {
				pro_mining = 0.0005
			},
		}
	},

	ore_gold = {
		positions = {
			{
				x = -473.2170715332,
				y = 2085.9958496094,
				z = 119.09912872314
			},
		},
		requiredSkill = 4,
		skill = "pro_mining",
		blip = {
			sprite = 618,
			colour = 40,
			display = "Gold"
		},
		returnedItems = {
			{
				name = "ore_gold",
				count = 1,
			}
		},
		text = "Press [E] to mine gold",
		time = 6500,
		skills = {
			increase = {
				pro_mining = -0.005
			},
		}
	},
	diamond = {
		positions = {
			{
				x = -563.70794677734,
				y = 1885.5233154297,
				z = 122.03509521484
			},
		},
		returnedItems = {
			{
				name = "diamond",
				count = 1,
			}
		},
		requiredSkill = 5,
		skill = "pro_mining",
		blip = {
			sprite = 617,
			colour = 0,
			display = "Diamond"
		},
		text = "Press [E] to mine diamonds",
		time = 6500,
		skills = {
			increase = {
				pro_mining = -0.25
			},
		}
	}
}