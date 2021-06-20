fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script '@rpuk/imports.lua'

server_scripts {
	'Config.lua',
	'Server/*.lua'
}

client_scripts {
	'NativeUI.lua',
	'Config.lua',
	'Client/*.lua'
}