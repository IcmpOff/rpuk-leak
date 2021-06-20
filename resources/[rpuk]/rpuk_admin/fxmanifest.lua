fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_script 'server.lua'

client_scripts {
	'client.lua',
	'cam.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css'
}