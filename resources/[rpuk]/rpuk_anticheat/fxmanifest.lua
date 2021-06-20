fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script '@rpuk/imports.lua'

client_scripts {
	'client/trace.lua',
	'client/*.lua',
}

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua', -- Keep this as * // prevents some of the shit client dumpers from grabbing
}

dependencies {
	'rpuk',
	'async',
	'cron',
}