fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'client/main.lua',
	'client/metal.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'server/metal.lua',
}

exports {
	'checkZoneDetector',
	'checkZoneDetectorStatus',
	'checkZoneDetectorPerms'
}
