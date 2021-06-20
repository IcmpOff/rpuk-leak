fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script '@rpuk/imports.lua'

server_script 'server/main.lua'

client_script 'client/main.lua'

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/style.css',
	'html/script.js',
	'html/assets/img/curve.png',
	'html/assets/img/logo.png'
}