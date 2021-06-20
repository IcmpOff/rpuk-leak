config = {}
config.percentageForReward = 2
config.percentageForFund = 2

config.dropoffLocations = {
	dropOff = {
		whitelisted = {"gruppe6"},
		positions = {
			{
				x = 4.4722294807434,
				y = -676.19390869141,
				z = 14.7,
				items = {
					money_bag = {
						price = 600
					}
				},
				text = "Push [E] to drop off money",
			},
			{
				x = 0.40346711874008,
				y = -657.501953125,
				z = 15.120307159424,
				items = {
					gold = {
						price = 120
					},
				},
				text = "Push [E] to drop off gold",
			},
		}
	}
}

config.pickupLocations = {
	transfer = {
		text = "Push [E] to collect",
		whitelisted = {"gruppe6"},
		positions = {
			{
				locationName = "Paleto Bank",
				x = -111.76389312744,
				y = 6480.8681640625,
				z = 30.495933532715,
				items = {
					gold = {
						count = 40,
						max = 40
					},
					money_bag = {
						count = 75,
						max = 75
					},
				},
				restockTimer = 21600,
				defaultTimer = 21600,
				requiredAmountOfG6 = 4,
			},
			{
				locationName = "Great Ocean Bank",
				x = -2948.365234375,
				y = 477.83184814453,
				z = 14.390132904053,
				items = {
					money_bag = {
						count = 50,
						max = 50
					},
				},
				restockTimer = 14400,
				defaultTimer = 14400,
				requiredAmountOfG6 = 2,
			},
			{
				locationName = "Pacific Bank",
				x = 251.87509155273,
				y = 222.24612426758,
				z = 105.1,
				items = {
					gold = {
						count = 60,
						max = 60
					},
					money_bag = {
						count = 150,
						max = 150
					},
				},
				restockTimer = 43200,
				defaultTimer = 43200,
				requiredAmountOfG6 = 4,
			},
			{
				locationName = "Legion Bank",
				x = 136.86436462402,
				y = -1046.2980957031,
				z = 28.295518112183,
				items = {
					money_bag = {
						count = 60,
						max = 60
					},
				},
				restockTimer = 14400,
				defaultTimer = 14400,
				requiredAmountOfG6 = 2,
			},
			{
				locationName = "Route68 Bank",
				x = 1184.2211914062,
				y = 2721.4326171875,
				z = 37.595943450928,
				items = {
					money_bag = {
						count = 50,
						max = 50
					},
				},
				restockTimer = 14400,
				defaultTimer = 14400,
				requiredAmountOfG6 = 2,
			},
			{
				locationName = "Bean Machine",
				x = -634.61590576172,
				y = 225.32069396973,
				z = 81.025634765625,
				items = {
					money_bag = {
						count = 15,
						max = 15
					},
				},
				restockTimer = 7200,
				defaultTimer = 7200,
				requiredAmountOfG6 = 2,
			},
		},
	}
}
