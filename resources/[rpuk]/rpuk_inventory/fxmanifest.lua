fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'ESX Inventory HUD'

ui_page 'html/ui.html'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'server/items.lua',
	'server/pickupClass.lua',
	'server/pickup.lua',
	'server/restrain.lua',
	'server/trunkClass.lua',
	'server/trunk.lua'
}

client_script 'client/*.lua'

files {
	'html/ui.html',
	'html/css/*.css',
	'html/js/*.js',
	'html/js/contextmenu/*.js',
	'html/img/**/*.png'
}

exports {
	'getStatus',
}