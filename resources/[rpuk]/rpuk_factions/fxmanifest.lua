fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_scripts {
	'@rpuk/imports.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config/config.lua',
	'config/config_armory.lua',
	'config/config_clothing.lua',
	'config/config_vehicles.lua',
	'server/sv_functions.lua',
	'server/*.lua',
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'config/config.lua',
	'config/config_armory.lua',
	'config/config_clothing.lua',
	'config/config_postions.lua',
	'config/config_vehicles.lua',
	'config/config_speedCameras.lua',
	'client/*.lua'
}

exports {
	'checkPolyZone',
	'checkForJobRadius',
	'checkZoneCameraStatus',
	'checkZoneCamera',
	'checkIfCanCutPower',
	'checkZoneCameraPerms'
}

ui_page 'html/ui.html'

files {
	'html/script.js',
	'html/style.css',
	'html/ui.html'
}

dependencies {
	'PolyZone'
}