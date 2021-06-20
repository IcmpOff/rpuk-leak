fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'server/main.lua'
}

client_scripts {
	'client/interactions.lua',
	'client/main.lua'
}

dependencies {
	'rpuk',
	'async',
}

ui_page "html/main.html"

files {
	"html/main.html",
	"html/main.css",
	"html/main.js",
	"html/img/*.jpg",
}