fx_version 'cerulean'
game 'gta5'
--lua54 'yes'
description 'RPUK Core'

shared_script '@rpuk/imports.lua'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@async/async.lua',
	'config.lua',
	'main/server.lua',
	'server_snippets/*.lua'
}

client_scripts {
	'config.lua',
	'main/client.lua',
	'client_snippets/*.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/reset.css',
	'html/listener.js',
	'html/script.js',
	'theme/style.css',
	'theme/shadow.js',

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

	'weaponsnowball.meta',
}

data_file 'WEAPONINFO_FILE_PATCH' 'weaponsnowball.meta'
data_file 'AUDIO_GAMEDATA' '../rpuk_audio_00/audio/dlcvinewood_game.dat'
data_file 'AUDIO_SOUNDDATA' '../rpuk_audio_00/audio/dlcvinewood_sounds.dat'
data_file 'AUDIO_DYNAMIXDATA' '../rpuk_audio_00/audio/dlcvinewood_mix.dat'
data_file 'AUDIO_SYNTHDATA' '../rpuk_audio_00/audio/dlcVinewood_amp.dat'
data_file 'AUDIO_SPEECHDATA' '../rpuk_audio_00/audio/dlcvinewood_speech.dat'
data_file 'AUDIO_WAVEPACK' '../rpuk_audio_00/audio/sfx/dlc_vinewood'

chat_theme 'gtao' {
	styleSheet = 'theme/style.css',
	script = 'theme/shadow.js',
	msgTemplates = {
		default = '<b>{0}</b><span>{1}</span>'
	}
}

dependencies {
	'rpuk',
	'rpuk_audio_00',
}

exports {
	'GetCarry',
}
