fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',

	'locale.lua',
	'locales/en.lua',

	'config.lua',
	'config.weapons.lua',
	'config.items.lua',

	'server/common.lua',
	'server/classes/player.lua',
	'server/functions.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/commands.lua',

	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua'
}

client_scripts {
	'locale.lua',
	'locales/en.lua',

	'config.lua',
	'config.weapons.lua',
	'config.items.lua',

	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',

	'client/modules/death.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',

	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'imports.lua',
	'locale.js',
	'html/ui.html',

	'html/css/app.css',

	'html/js/mustache.min.js',
	'html/js/wrapper.js',
	'html/js/app.js'
}

dependencies {
	'mysql-async',
	'async'
}