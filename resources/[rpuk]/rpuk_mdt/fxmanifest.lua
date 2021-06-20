fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script '@rpuk/imports.lua'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'sv_mdt.lua',
	'sv_vehcolors.lua'
}

client_script 'cl_mdt.lua'

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/vue.min.js',
	'ui/script.js',
	'ui/main.css',
	'ui/styles/police.css',
	'ui/styles/court.css',
	'ui/styles/nca.css',
	'ui/img/*.png'
}