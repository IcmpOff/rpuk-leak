fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'Define zones of different shapes and test whether a point is inside or outside of the zone'
version '2.3.0'

client_scripts {
	'client.lua',
	'BoxZone.lua',
	'EntityZone.lua',
	'CircleZone.lua',
	'ComboZone.lua',
	'creation/*.lua',
	'list.lua'
}

server_scripts {
	'server.lua'
}


exports {
	'inPolyZone',
}
