fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
url 'https://github.com/Xinerki/kgv-blackjack'

shared_scripts {
	'@rpuk/imports.lua',
	'coords.lua'
}

client_scripts {
	'timerbars.lua',
	'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

dependencies {
	'rpuk',
	'rpuk_audio_00'
}

files{
	"peds.meta",
	'../rpuk_audio_00/audio/dlcvinewood_amp.dat10',
	'../rpuk_audio_00/audio/dlcvinewood_amp.dat10.nametable',
	'../rpuk_audio_00/audio/dlcvinewood_amp.dat10.rel',

	'../rpuk_audio_00/audio/dlcvinewood_game.dat151',
	'../rpuk_audio_00/audio/dlcvinewood_game.dat151.nametable',
	'../rpuk_audio_00/audio/dlcvinewood_game.dat151.rel',

	'../rpuk_audio_00/audio/dlcvinewood_mix.dat15',
	'../rpuk_audio_00/audio/dlcvinewood_mix.dat15.nametable',
	'../rpuk_audio_00/audio/dlcvinewood_mix.dat15.rel',

	'../rpuk_audio_00/audio/dlcvinewood_sounds.dat54',
	'../rpuk_audio_00/audio/dlcvinewood_sounds.dat54.nametable',
	'../rpuk_audio_00/audio/dlcvinewood_sounds.dat54.rel',

	'../rpuk_audio_00/audio/dlcvinewood_speech.dat4',
	'../rpuk_audio_00/audio/dlcvinewood_speech.dat4.nametable',
	'../rpuk_audio_00/audio/dlcvinewood_speech.dat4.rel',

	'../rpuk_audio_00/audio/sfx/dlc_vinewood/casino_general.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/casino_interior_stems.awc',
	--'../rpuk_audio_00/audio/sfx/dlc_vinewood/casino_slot_machines_01.awc',
	--'../rpuk_audio_00/audio/sfx/dlc_vinewood/casino_slot_machines_02.awc',
	--'../rpuk_audio_00/audio/sfx/dlc_vinewood/casino_slot_machines_03.awc',
	--'../rpuk_audio_00/audio/sfx/dlc_vinewood/*.awc', --maybe not, cos this is 140 assets or more!

	--the ones we actually used before, are:
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/casino_general.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/casino_interior_stems.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/s_f_y_casino_01_asian_01.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/s_f_y_casino_01_asian_02.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/s_f_y_casino_01_latina_01.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/s_f_y_casino_01_latina_02.awc',

	'../rpuk_audio_00/audio/sfx/dlc_vinewood/s_m_y_casino_01_asian_01.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/s_m_y_casino_01_asian_02.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/s_m_y_casino_01_white_01.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/s_m_y_casino_01_white_02.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/u_f_m_casinocash_01.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/u_f_m_casinoshopkeeper_01.awc'


}

data_file 'AUDIO_GAMEDATA' '../rpuk_audio_00/audio/dlcvinewood_game.dat'
data_file 'AUDIO_SOUNDDATA' '../rpuk_audio_00/audio/dlcvinewood_sounds.dat'
data_file 'AUDIO_DYNAMIXDATA' '../rpuk_audio_00/audio/dlcvinewood_mix.dat'
data_file 'AUDIO_SYNTHDATA' '../rpuk_audio_00/audio/dlcVinewood_amp.dat'
data_file 'AUDIO_SPEECHDATA' '../rpuk_audio_00/audio/dlcvinewood_speech.dat'
data_file 'AUDIO_WAVEPACK' '../rpuk_audio_00/audio/sfx/dlc_vinewood'


--data_file 'DLC_ITYP_REQUEST' 'stream/tables/vw_prop_vw_tables.ityp'
--data_file 'DLC_ITYP_REQUEST' 'stream/cards/vw_prop_vw_cards.ityp'

