fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script '@rpuk/imports.lua'

server_scripts {
	'server/sv_main.lua',
	'@mysql-async/lib/MySQL.lua'
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua',
	'client/*.lua',
}

ui_page {
	'html/alerts.html',
}

files {
	'html/alerts.html',
	'html/main.js', 
	'html/style.css',
}

exports {
	'getStatus',
}