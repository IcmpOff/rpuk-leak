fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Gang Script'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@async/async.lua',
	'server/*.lua'
}

client_scripts {
	'client/*.lua'
}

dependencies {
	'rpuk'
}

ui_page 'html/index.html'

files {
	'html/*',
}