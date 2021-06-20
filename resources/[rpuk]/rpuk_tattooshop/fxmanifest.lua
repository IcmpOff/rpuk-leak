fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'ESX Tattoo Shop'

--https://github.com/root-cause/v-tattoos

shared_scripts {
	'@rpuk/imports.lua',
	'@rpuk/locale.lua',
	'locales/en.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua'
}

dependencies {
	'rpuk',
	'skinchanger',
	'rpuk_skincreator'
}

files {
	'client/v-tattoos/mpbusiness_overlays.json',
	'client/v-tattoos/mphipster_overlays.json',
	'client/v-tattoos/mpbiker_overlays.json',
	'client/v-tattoos/mpairraces_overlays.json',
	'client/v-tattoos/mpbeach_overlays.json',
	'client/v-tattoos/multiplayer_overlays.json',
	'client/v-tattoos/mpgunrunning_overlays.json',
	'client/v-tattoos/mpimportexport_overlays.json',
	'client/v-tattoos/mplowrider_overlays.json',
	'client/v-tattoos/mplowrider2_overlays.json',
	'client/v-tattoos/mpluxe_overlays.json',
	'client/v-tattoos/mpluxe2_overlays.json',
	'client/v-tattoos/mpchristmas2_overlays.json',
	'client/v-tattoos/mpchristmas2017_overlays.json',
	'client/v-tattoos/mpchristmas2018_overlays.json',
	'client/v-tattoos/mpsmuggler_overlays.json',
	'client/v-tattoos/mpstunt_overlays.json',
	'client/v-tattoos/mpvinewood_overlays.json',
	'client/v-tattoos/mpheist3_overlays.json',
	'client/v-tattoos/mpheist4_overlays.json',

	'client/tattoozones/tattoozones.mpbusiness_overlays.json',
	'client/tattoozones/tattoozones.mphipster_overlays.json',
	'client/tattoozones/tattoozones.mpbiker_overlays.json',
	'client/tattoozones/tattoozones.mpairraces_overlays.json',
	'client/tattoozones/tattoozones.mpbeach_overlays.json',
	'client/tattoozones/tattoozones.multiplayer_overlays.json',
	'client/tattoozones/tattoozones.mpgunrunning_overlays.json',
	'client/tattoozones/tattoozones.mpimportexport_overlays.json',
	'client/tattoozones/tattoozones.mplowrider_overlays.json',
	'client/tattoozones/tattoozones.mplowrider2_overlays.json',
	'client/tattoozones/tattoozones.mpluxe_overlays.json',
	'client/tattoozones/tattoozones.mpluxe2_overlays.json',
	'client/tattoozones/tattoozones.mpchristmas2_overlays.json',
	'client/tattoozones/tattoozones.mpchristmas2017_overlays.json',
	'client/tattoozones/tattoozones.mpchristmas2018_overlays.json',
	'client/tattoozones/tattoozones.mpsmuggler_overlays.json',
	'client/tattoozones/tattoozones.mpstunt_overlays.json',
	'client/tattoozones/tattoozones.mpvinewood_overlays.json',
	'client/tattoozones/tattoozones.mpheist3_overlays.json',
	'client/tattoozones/tattoozones.mpheist4_overlays.json',

	'client/tattoozones/updateGroup.json'
}
