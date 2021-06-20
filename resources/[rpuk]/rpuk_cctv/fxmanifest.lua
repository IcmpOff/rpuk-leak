fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script '@rpuk/imports.lua'

client_scripts {
	'config.lua',
	'client/cl_main.lua'
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/vue.min.js',
	'ui/script.js'
}