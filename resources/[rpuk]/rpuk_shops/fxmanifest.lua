fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'server/robbery.lua',
	'server/bank.lua'
}

client_scripts {
	'client/main.lua',
	'client/shop.lua',
	'client/robbery.lua',
	'client/safe.lua',
	'client/bank.lua'
}

dependency 'rpuk'
