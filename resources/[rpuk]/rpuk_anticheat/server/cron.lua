function Cron_Announce(d, h, m)
	local message

	if m == 00 then
		message = "Register for the Police Service and NHS on our forums! Roleplay.co.uk"
	elseif m == 15 then	
		message = "You can use the /me command to enhance your roleplay!"
	elseif m == 30 then
		message = "Join us on Discord at Discord.gg/roleplay"
	elseif m == 45 then
		message = "This server restarts everyday at 16:00PM"
	else
		message = "Please read the full list of server rules at Roleplay.co.uk"
	end
	if message then
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(100, 20, 200, 0.3); border-radius: 3px;"><img style="position:absolute;z-index:10;right:0;height:3vw;top:auto;"src="https://www.roleplay.co.uk/images/rplogo.png" /> <b>{0}</b><br> {1}</div><br><br>',
			args = {"SERVER ANNOUNCEMENT", message}
		})
	end
end

function Restart_Announce(notice, secondaryMessage)
	local message

	message = 'Server restarting in ' .. notice .. ' minutes. ' .. secondaryMessage
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(255, 20, 20, 0.3); border-radius: 3px;"><img style="position:absolute;z-index:10;right:0;height:3vw;top:auto;"src="https://www.roleplay.co.uk/images/rplogo.png" /> <b>STAFF ANNOUNCEMENT</b><br> {1}</div><br><br>',
		args = {'', message}
	})
end

CreateThread(function()
	local hour = 24

	for i = 23,0,-1 do
		Wait(0)
		hour = hour-1
		TriggerEvent('cron:runAt', hour, 00, Cron_Announce)
		TriggerEvent('cron:runAt', hour, 15, Cron_Announce)
		TriggerEvent('cron:runAt', hour, 30, Cron_Announce)
		TriggerEvent('cron:runAt', hour, 45, Cron_Announce)
	end
end)

CreateThread(function()
	Wait(0)
	TriggerEvent('cron:runAt', 10, 00, CheckVehs)
	-- TriggerEvent('cron:runAt', 15, 45, Restart_Announce(15, 'Please store your vehicles and disconnect to ensure your data syncs properly. (16:00 Restart)'))
	-- TriggerEvent('cron:runAt', 15, 55, Restart_Announce(5, 'Please store your vehicles ASAP and disconnect to ensure your data syncs properly. (16:00 Restart)'))
	TriggerEvent('cron:runAt', 18, 00, CheckVehs)
end)

-- [[ run some reports ]]--
function CheckVehs()
	MySQL.Async.fetchAll('SELECT ov.* FROM owned_vehicles ov WHERE ov.plate NOT REGEXP "[A-Z]{4} [0-9]{3}"', {}, function(reportResults)
		for i=1, #reportResults, 1 do
			print(reportResults[i].plate)
			print(reportResults[i].owner)

			local targetSteamID = string.sub(reportResults[i].owner, string.find(reportResults[i].owner, ":" )+1)
			local steamid64 = tonumber(targetSteamID,16)

			local BMString = "\nBM Search | https://www.battlemetrics.com/players?filter%5Bsearch%5D=" .. tostring(steamid64) .. "&filter%5BplayerFlags%5D=&/"
			local RPUKString = "\nRPUK Panel | https://fivempanel.roleplay.co.uk/user/" .. reportResults[i].owner
			local message = "Vehicle Plate: " .. reportResults[i].plate .. "\nOwned By: " .. reportResults[i].owner .. "\nVehicle has an invalid numberplate!\nSteam | https://steamcommunity.com/profiles/" .. steamid64 .. BMString .. RPUKString
			sendToDiscord(Config.webhookban, "RPUK FiveM Anticheat", message, Config.purple, "Server Report [Numberplate]", reportResults[i].owner, "", "Possible Skiddie - Please Check", "Server Report Run")
		end
	end)
end