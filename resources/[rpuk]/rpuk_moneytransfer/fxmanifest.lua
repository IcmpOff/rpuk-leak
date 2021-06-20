fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'server/sv_main.lua',
	'@mysql-async/lib/MySQL.lua'
}

client_scripts {
	'client/cl_interactions.lua',
	'client/cl_money.lua'
}