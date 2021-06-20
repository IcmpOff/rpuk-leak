fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_script 'server.lua'

client_script 'client.lua'

exports {'GetFuel', 'SetFuel'}