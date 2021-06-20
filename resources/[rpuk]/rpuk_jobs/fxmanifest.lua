fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Jobs'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua',
	'config/*.lua'
}

server_scripts {
	'server/*.lua',
	'server/jobs/*.lua'
}

client_scripts {
	'@rpuk_vehicle/client/datastore.lua',
	'client/*.lua',
	'client/jobs/*.lua'
}