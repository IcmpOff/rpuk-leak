fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Prison'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/sv_sentence.lua',
	'server/sv_collectionPoint.lua',
	'server/sv_stashPoints.lua',
	'server/sv_computer.lua',
	'server/sv_jobs.lua',
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'client/cl_functions.lua',
	'client/cl_release.lua',
	'client/cl_sentence.lua',
	'client/cl_airSpace.lua',
	'client/cl_jobs.lua',
	'client/cl_collection.lua',
	'client/cl_computer.lua'
}

exports {
	'getJailStatus',
}