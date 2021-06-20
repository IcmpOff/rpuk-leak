fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
shared_script '@rpuk/imports.lua'

server_script 'server/main.lua'

client_script 'client/main.lua'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/sounds/*.ogg'
}