fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'server/object.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua',
	"client/events.lua"
}