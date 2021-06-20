fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Processing Zones'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua'
}

dependency 'rpuk'