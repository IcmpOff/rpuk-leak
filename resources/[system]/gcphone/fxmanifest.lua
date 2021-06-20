fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script '@rpuk/imports.lua'

server_script {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/server.lua',

	'server/job.lua',
	'server/reddit.lua',
	'server/twitter.lua',
	'server/bank.lua',
	'server/life_invaders.lua',
	'server/radio_masts.lua',
	'server/anticheat.lua'
}

client_script {
	'config.lua',
	'client/animation.lua',
	'client/client.lua',

	'client/job.lua',
	'client/camera.lua',
	'client/reddit.lua',
	'client/bank.lua',
	'client/twitter.lua',
	'client/life_invaders.lua',
	'client/radio_masts.lua',
	'datastore.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/static/css/app.css',
	'html/static/js/app.js',
	'html/static/js/manifest.js',
	'html/static/js/vendor.js',

	'html/static/config/config.json',
	'html/static/sound/*.ogg',

	'html/static/img/*.png',
	'html/static/img/apps/*.png', -- app icons
	'html/static/img/background/*.jpg', -- backgrounds
	'html/static/img/skins/*.png' -- skins'
}

exports {
	'mastCheck',
	'getStatus',
}

