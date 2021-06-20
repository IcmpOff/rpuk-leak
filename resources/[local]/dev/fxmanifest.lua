fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script '@rpuk/imports.lua'

ui_page 'html.html'

files {
	'html.html',
}

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'server1.lua'
}

client_scripts {
	'client1.lua'
}