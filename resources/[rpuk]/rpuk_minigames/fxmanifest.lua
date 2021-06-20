fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

shared_scripts {
	'@rpuk/imports.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'slots/consts.lua', -- Ciaran Created This
	'slots/server.lua', -- Ciaran Created This

	'darts/server.lua', -- From a github repo, unable to deobfuscate
	'darts/credentials.lua', -- From a github repo, unable to deobfuscate
}

client_scripts {
	'slots/consts.lua', -- Ciaran Created This
	'slots/client.lua', -- Ciaran Created This

	'arcade/client.lua', -- https://github.com/utkuali/degenatron-arcade-games

	"darts/client.lua", -- From a github repo, unable to deobfuscate
}

files {
	'../rpuk_audio_00/audio/dlcvinewood_game.dat151',
	'../rpuk_audio_00/audio/dlcvinewood_game.dat151.nametable',
	'../rpuk_audio_00/audio/dlcvinewood_game.dat151.rel',

	'../rpuk_audio_00/audio/dlcvinewood_sounds.dat54',
	'../rpuk_audio_00/audio/dlcvinewood_sounds.dat54.nametable',
	'../rpuk_audio_00/audio/dlcvinewood_sounds.dat54.rel',

	'../rpuk_audio_00/audio/dlcvinewood_amp.dat10',
	'../rpuk_audio_00/audio/dlcvinewood_amp.dat10.nametable',
	'../rpuk_audio_00/audio/dlcvinewood_amp.dat10.rel',

	'../rpuk_audio_00/audio/dlcvinewood_mix.dat15',
	'../rpuk_audio_00/audio/dlcvinewood_mix.dat15.nametable',
	'../rpuk_audio_00/audio/dlcvinewood_mix.dat15.rel',

	'../rpuk_audio_00/audio/dlcvinewood_speech.dat4',
	'../rpuk_audio_00/audio/dlcvinewood_speech.dat4.nametable',
	'../rpuk_audio_00/audio/dlcvinewood_speech.dat4.rel',

	'../rpuk_audio_00/audio/sfx/dlc_vinewood/casino_general.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/casino_interior_stems.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/casino_slot_machines_01.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/casino_slot_machines_02.awc',
	'../rpuk_audio_00/audio/sfx/dlc_vinewood/casino_slot_machines_03.awc',

    "html/helptext.png",
    "html/frame.png",
    "html/video.ogv",
    "html/index.html",
    "html/script.js",
}

ui_page "html/index.html"

data_file 'AUDIO_GAMEDATA' '../rpuk_audio_00/audio/dlcvinewood_game.dat'
data_file 'AUDIO_SOUNDDATA' '../rpuk_audio_00/audio/dlcvinewood_sounds.dat'
data_file 'AUDIO_DYNAMIXDATA' '../rpuk_audio_00/audio/dlcvinewood_mix.dat'
data_file 'AUDIO_SYNTHDATA' '../rpuk_audio_00/audio/dlcvinewood_amp.dat'
data_file 'AUDIO_SPEECHDATA' '../rpuk_audio_00/audio/dlcvinewood_speech.dat'
data_file 'AUDIO_WAVEPACK' '../rpuk_audio_00/audio/sfx/dlc_vinewood'

dependencies {
	'rpuk',
	'rpuk_audio_00'
}