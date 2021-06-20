fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Halloween Script Resource'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@async/async.lua',
	'server/*.lua',
}

client_scripts {
	'client/*.lua'
}

dependencies {
	'rpuk'
}