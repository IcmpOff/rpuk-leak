fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_script {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'server/garage.lua'
}

client_scripts {
	'@rpuk/client/entityiter.lua',
	'client/main.lua',
	'client/datastore.lua',
	'client/damage.lua',
	'client/garage.lua',
	'client/shop.lua'
}

dependencies {
	'rpuk'
}

export 'GeneratePlate'