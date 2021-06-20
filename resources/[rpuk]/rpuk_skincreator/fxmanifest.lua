fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script '@rpuk/imports.lua'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
}

client_scripts {
	'client/main.lua'
}

dependencies {
	'rpuk',
	'skinchanger'
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/assets/*.png',
	'ui/assets/heritage/*.jpg',
	'ui/front.js',
	'ui/script.js',
	'ui/style.css',
	'ui/debounce.min.js',
	'ui/locales/en.js',
	'ui/tabs.css'
}