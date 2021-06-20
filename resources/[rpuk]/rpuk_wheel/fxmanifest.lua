fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script '@rpuk/imports.lua'

server_scripts {
	'sv_events.lua',
	'@mysql-async/lib/MySQL.lua',
}

client_script {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'@rpuk_factions/config/config_vehicles.lua',
	'@rpuk_factions/config/config.lua',
	'config.lua',
	'cl_events.lua',
	'cl_menu.lua',
	'cl_vehicle.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/css/RadialMenu.css',
	'html/js/RadialMenu.js',
	'html/css/all.min.css',
	'html/js/all.min.js'
}

exports {
	'getStatus',
}
