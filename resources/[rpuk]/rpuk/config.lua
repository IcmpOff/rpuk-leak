Config = {}
Config.Locale = 'en'

Config.Accounts = {
	bank = _U('account_bank'),
	black_money = _U('account_black_money'),
	money = _U('account_money')
}

Config.StartingAccountMoney = {bank = 5000, money = 1000}

Config.EnableHud            = false -- enable the default hud? Display current job and accounts (black, bank & cash)
Config.EnablePvP            = true -- enable pvp?
Config.MaxWeight            = 50   -- the max inventory weight without backpack

Config.PaycheckInterval     = 7 * 60000

Config.EnableDebug          = false

Config.skill = {
	pro_mining = {
		label = "Mining",
		max = 5
	},
	pro_smelt = {
		label = "Smelting",
		max = 4
	},
	pro_food = {
		label = "Hospitality",
		max = 4
	},
	pro_crafting = {
		label = "Crafting",
		max = 4
	},
	pro_weapons= {
		label = "Weapon Crafting",
		max = 4
	}
}