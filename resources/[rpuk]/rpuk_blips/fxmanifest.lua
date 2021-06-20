fx_version 'cerulean'
game 'gta5'
--lua54 'yes'

usage [[
	exports['blip_info']:ResetBlipInfo(blip)
	exports['blip_info']:SetBlipInfo(blip, infoData)
	exports['blip_info']:SetBlipInfoTitle(blip, title, rockstarVerified)
	exports['blip_info']:SetBlipInfoImage(blip, dict, tex)
	exports['blip_info']:SetBlipInfoEconomy(blip, rp, money)
	exports['blip_info']:AddBlipInfoText(blip, leftText, rightText)
	exports['blip_info']:AddBlipInfoName(blip, leftText, rightText)
	exports['blip_info']:AddBlipInfoHeader(blip, leftText, rightText)
	exports['blip_info']:AddBlipInfoIcon(blip, leftText, rightText, iconId, iconColor, checked)
]]

client_script 'blip_info.lua'
client_script 'config.lua'
client_script 'main.lua'

export 'ResetBlipInfo'
export 'SetBlipInfo'
export 'SetBlipInfoTitle'
export 'SetBlipInfoImage'
export 'SetBlipInfoEconomy'
export 'AddBlipInfoText'
export 'AddBlipInfoName'
export 'AddBlipInfoHeader'
export 'AddBlipInfoIcon'
