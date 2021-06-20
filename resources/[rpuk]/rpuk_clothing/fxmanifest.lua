fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

client_scripts {
	--'dependencies/client.lua',
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	--'dependencies/server.lua',
	'server.lua',
}

shared_scripts {
	'@rpuk/imports.lua',
	--'dependencies/skin_config.lua',
	'datastore/locations.lua',
	'datastore/tops.lua',
	'datastore/trousers.lua',
	'datastore/shoes.lua',
	'datastore/hats.lua',
	'datastore/bags.lua',
	'datastore/masks.lua',
	'datastore/accessories.lua',
	'datastore/bodyarmour.lua',
}