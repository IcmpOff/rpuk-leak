fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Housing'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/database.lua',
	'server/object.lua',
	'server/main.lua',
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'client/interactions.lua',
	'client/main.lua',
}

exports {
	'inHouse',
	'hasAccess',
	'checkHouseData',
}

server_exports {
	'isInHouseCoords',
}