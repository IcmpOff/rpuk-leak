fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

client_scripts {
	'menu.lua',
	'lscustoms.lua',
}

server_scripts {
	'@rpuk/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'lscustoms_server.lua',
}

shared_scripts {
	'@rpuk/imports.lua',
	'lsconfig.lua',
}

dependency 'rpuk'
