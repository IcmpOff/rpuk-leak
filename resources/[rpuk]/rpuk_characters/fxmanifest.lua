fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'ESX Kashacters'

loadscreen_manual_shutdown 'yes'

shared_script '@rpuk/imports.lua'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

ui_page 'html/ui.html'

loadscreen 'html/loadingscreen.html'

files {
	'html/*',
	'html/css/*',
	'html/js/*',
	'html/intro/*',
	'html/image/*',
	'html/music/*'
}