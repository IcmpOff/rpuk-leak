fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Health'

shared_script '@rpuk/imports.lua'

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	"config_beds.lua",
	"config_doctor.lua",
	'client/cl_interactions.lua',
	'client/*.lua',
}

server_scripts {
	"config_beds.lua",
	"config_doctor.lua",
	'server/sv_hospital.lua',
	'server/sv_death.lua',
	'@mysql-async/lib/MySQL.lua',
}

dependencies {
	'rpuk',
}

exports {
	'GetSedate',
	'deadStatus',
}
