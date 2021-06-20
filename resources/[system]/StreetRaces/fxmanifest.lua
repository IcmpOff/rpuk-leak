fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script '@rpuk/imports.lua'

server_scripts {
	'config.lua',
	'port_sv.lua',
	'races_sv.lua',
}

client_scripts {
	'config.lua',
	'races_cl.lua',
}