fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	"shared/sh_queue.lua",
	"connectqueue.lua",
	"server/sv_queue_config.lua",
}

client_scripts {
	"shared/sh_queue.lua",
}