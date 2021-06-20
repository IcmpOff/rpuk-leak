fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Hud'

shared_script '@rpuk/imports.lua'

client_script 'cl_hud.lua'

ui_page 'html/index.html'

files {
	"html/script.js",
	"html/jquery.min.js",
	"html/jquery-ui.min.js",
	"html/styles.css",
	"html/img/*.svg",
	"html/img/*.png",
	"html/index.html",
}

exports {
	"getOxygenStatus",
}