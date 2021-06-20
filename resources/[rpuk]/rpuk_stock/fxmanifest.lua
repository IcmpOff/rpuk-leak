fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Stock Ordering - Vehicle & Material'

shared_scripts {
	'@rpuk/imports.lua',
	'@rpuk_shops/config.lua' -- using rpuk shops config for shop pos
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'server/delivery.lua'
}

client_scripts {
	'client/client.lua',
	'client/delivery.lua'
}

ui_page 'client/html/index.html'

files {
	'client/html/index.html',
	'client/html/script.js',
	'client/html/style.css'
}

dependency 'rpuk'
