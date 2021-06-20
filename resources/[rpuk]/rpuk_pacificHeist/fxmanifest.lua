fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/sv_main.lua',
}

client_scripts {
	'client/cl_main.lua',
}