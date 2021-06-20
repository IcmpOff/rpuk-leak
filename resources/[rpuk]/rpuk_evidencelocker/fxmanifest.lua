fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/obj.lua',
	'server/main.lua',
	'updateDb.lua'
}

client_scripts {
	'client/interactions.lua',
	'client/main.lua'
}

dependency 'rpuk'