fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Developer Resource - Only Load on Dev Servers'

shared_script '@rpuk/imports.lua'

server_scripts {
	'server/*.lua'
}

client_scripts {
	'client/*.lua',
}
