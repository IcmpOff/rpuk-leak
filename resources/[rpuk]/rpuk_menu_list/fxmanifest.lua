fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script '@rpuk/imports.lua'

client_scripts {
	'@rpuk/client/wrapper.lua',
	'client/main.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',

	'html/css/app.css',

	'html/js/mustache.min.js',
	'html/js/app.js'
}

dependency 'rpuk'