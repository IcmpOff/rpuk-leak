fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Weaponshop - Heavily Modififed version of James Weaponstore'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'server/main.lua'
}

client_scripts {
	'client/functions.lua',
	'client/main.lua'
}