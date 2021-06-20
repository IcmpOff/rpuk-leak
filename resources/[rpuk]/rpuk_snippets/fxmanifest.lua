fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Snippets'

shared_script '@rpuk/imports.lua'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}

dependencies {
	'rpuk',
	'mysql-async'
}