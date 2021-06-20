--DISCORD WEBHOOKS FOR BAD TWITTER USERS ----------------------
local blwords = { -- blacklisted chat
	"^13^24^3B^4y^5T^6e ^1C^2o^3m^4m^5u^6n^7i^1t^2y",
	"Lynx 8",
	"www.lynxmenu.com",
	"You got raped by",
	"Fallen#0811-Mllll",
	"Add me Fallen#0811",
	"Fallen#0811",
	"Fallen#0811-BANANAPARTY",
	">:D Player Crash Attempt",
	"\76\121\110\120\32\56\32\126\32\119\119\119\46\108\121\110\120\109\101\110\117\46\99\111\109",
	"\89\111\117\32\103\111\116\32\114\97\112\101\100\32\98\121\32\76\121\110\120\32\56",
	"Fallen#0811-Fuuck",
	"Fallen#0811-CrashAtt",
	"^1L^2y^3n^4x ^5R^6e^7v^8o^9l^1u^2t^3i^5o^4n",
	"lynxmenu.com - Cheats and Anti-Lynx",
	"Vyorex Community",
	"Lynx 8 Vyorex",
	"https://discord.gg/7bM3z5P",
	"obl2 ~b~",
	"https://discord.gg/eUrxG46",
	"^8ObliviusV2Menu",
	"Made by LuaMenuFr#0221",
	"Luminous ~b~",
	"https://discord.gg/pQwzbdf",
	"BY TIAGOMODZ",
	"FUCK YOU SERVER BY",
	"BY TIAGO MODZ",
	"FUCK SERVER BY",
	"FUCK SERVER by TIAGO MODZ#5836",
	"by TIAGO MODZ#1696",
	"foriv#0002",
	"Desudo;",
	"Buy at https://discord.gg/hkZgrv3",
	"/ooc 6666 Menu!",
	"https://discord.gg/hkZgrv3",
	"Eulen Comunnity",
	"www.eulencheats.com",
	"You got raped by Eulen Comunnity",
	"FendinX Community",
	"Credit FendinX",
	"https://discord.io/FendinX",
	"^1D^2r^3e^4a ^5m^6M^7e^8n^9u",
	"AboDream Menu",
	"https://discord.gg/3vr4aVs",
	"Cheats and Anti-Lynx",
	"Andr[e]a Cheats",
	"^13^24^3B^4y^5T^6e ^1C^2o^3m^4m^5u^6n^7i^1t^2y",
	"Andr[e]a Menu",
	"Andr[€]a",
	"Leaker's Menu",
	"discord.gg/gJGbqTN",
	"^1L^2e^3a^4k^5e^6r^7'^8s ^1T^2e^3a^4m",
	"Leaker's Team",
	"Leaker's Menu",
	"L^1^2e^3a^4k^5e^6r^7'^8s ^1T^2e^3a^4m ^5discord.gg/gJGbqTN",
	"Come buy some ^6fivem cheats",
	"^1https://discord.gg/kgEh8mb",
	"^1LeX^2Menu",
	"1L^2e^3X ^41^5.^60",
	"^1Oh ^2shit ^3some ^4LeX ^5customers ^6on ^7the ^8server",
	"^4LeX",
	"^1L^2e^3X ^4M^6e^7n^8u",
	"4LeX ^5customers ^6on ^7the ^8server",
	"Made by Plane#0007",
	"by Luminous",
	"lynxmenu.com 9.1",
	"Yo add me Fallen#0811",
	"/tweet Yo add me Fallen#0811",
	"Nigger",
  "scripthook",
  "EulenCheats",
  "lua executor",
  "lua injector",
}

function steam64(input) -- convert to steam 64 id
	local steam16 = input
	steam16 = string.sub(steam16, string.find(steam16, ":" )+1)
	local final = tonumber(steam16, 16)
	return final
end

--Webhook for bad words
AddEventHandler('gcPhone:twitter_newTweet', function (tweet, source)
	local triggered = false
	for x = 1, #blwords do
		if string.find(string.lower(tweet.message), string.lower(blwords[x])) and not triggered then
			triggered = true
			local header, colour, f1_title, f1_desc, f2_title, f2_desc, f3_title, f3_desc, footer -- initial values
			local xPlayer = ESX.GetPlayerFromId(source)
			local hookAvatar = "https://i.imgur.com/ZPs8c4V.png"
			local hookContent = ""
			local username = "RPUK GTA RP Twitter Flag"
			local discord_webhook = "https://discordapp.com/api/webhooks/720371172788666439/k35n_8ApddFzgPTCcU0pDbl8rcRzLVmhLwUN-KGy_M0HmYZcAqYRDlvZFSFDqrlr6AuM"

			if xPlayer ~= nil then
				header = "Steam: " .. xPlayer.name .. "\nChar: " .. xPlayer.firstname .. " " .. xPlayer.lastname .. "\nSession ID: " .. xPlayer.source
				hookName = "RPUK Twitter Flag"
				colour = 15258703
				f1_title, f1_desc = "Steam Account", "[Search Account](https://steamcommunity.com/profiles/" .. steam64(xPlayer.identifier) .. ")"
				f2_title, f2_desc = "BM Search", "[Search Account](https://www.battlemetrics.com/rcon/players?filter%5Bsearch%5D=%22" .. steam64(xPlayer.identifier) .. "%22)"
				f3_title, f3_desc = "GTA Panel", "[Search Account](https://fivempanel.roleplay.co.uk/user/" .. xPlayer.identifier .. ")"
				footer = "Roleplay.co.uk • Twitter Flag"
				local embeds = {
					{
						["title"] = header,
						["description"] = "",
						["color"] = colour,
						["fields"] = {
							{
								["name"] = f1_title,
								["value"] = f1_desc,
								["inline"] = true
							},
							{
								["name"] = f2_title,
								["value"] = f2_desc,
								["inline"] = true
							},
							{
								["name"] = f3_title,
								["value"] = f3_desc,
								["inline"] = true,
							},
							{
								["name"] = "Message",
								["value"] = tweet.message,
								["inline"] = false,
							},
						},
						["thumbnail"] = {
							["url"] = "https://i.imgur.com/ZPs8c4V.png",
						},
						["footer"] = {
							["text"]= footer,
						},
					}
				}

				PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode({username = hookName, content = hookContent, avatar_url = hookAvatar, embeds = embeds}), { ['Content-Type'] = 'application/json' })
			else
				print("Tried to get the xplayer for twitter user "..tweet.authorId.." but failed. Message was "..tweet.message)
			end
		end
	end
end)