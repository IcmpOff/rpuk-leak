-------------------------------------
--    Handles the event signups    --
-------------------------------------
-- Start Event Signup
event_signups = {}
event_participants = {}

ESX.RegisterCommand('event_sync', 'staff_level_1', function(xPlayer, args, showError)
	event_signup()
end, false, {help = '[Staff] Force Sync of Event Signups'})

ESX.RegisterCommand('event_menu', {'staff_level_5', 'dev_level_1'}, function(xPlayer, args, showError)
	TriggerClientEvent('rpuk_halloween:event_menu', xPlayer.source)
end, false, {help = '[Staff] Halloween Event Menu'})

RegisterNetEvent('rpuk_halloween:event_signup')
AddEventHandler('rpuk_halloween:event_signup', function(event)
	local xPlayer = ESX.GetPlayerFromId(source)
	local event = tostring(event)
	if xPlayer then
		MySQL.Async.fetchAll('SELECT * FROM event_signups WHERE identifier = @identifier AND rpuk_charid = @character_id AND event = @event', {
			['@identifier'] = xPlayer.identifier,
			["@character_id"] = xPlayer.rpuk_charid,
			['@event'] = event
		}, function(result)
			if not result[1] then
				local found = false
				for i=1, #event_signups, 1 do
					if event_signups[i].identifier == xPlayer.identifier then
						found = true
					end
				end
				if found then
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'error', text = 'You are already signed up to this event!' })
				else
					table.insert(event_signups, {
						identifier = xPlayer.identifier,
						character_id = xPlayer.rpuk_charid,
						event = tostring(event)
					})
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = 'Signed up for the event ' .. event .. '. Check Roleplay.co.uk and discord for further updates.' })
				end
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'error', text = 'You are already signed up to this event!' })
			end
		end)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { length = 6000, type = 'error', text = 'Something went wrong when signing up to this event.' })
	end
end)

function event_signup()
	for i=1, #event_signups, 1 do
		MySQL.Async.execute('INSERT INTO event_signups (identifier, rpuk_charid, event) VALUES (@identifier, @character_id, @event)', {			
			["@identifier"] = event_signups[i].identifier,
			["@character_id"] = event_signups[i].character_id,
			["@event"] = event_signups[i].event,
		}, function(result)
			if result then

			end
		end)
	end
	event_signups = {}
	print("SQL Event Signup Complete (Waiting 2 Minutes.)")
	SetTimeout(150000, event_signup) -- 300000=2 min
end

event_signup()

--[[
CREATE TABLE IF NOT EXISTS `event_signups` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`identifier` varchar(50) NOT NULL,
	`rpuk_charid` int(11) NOT NULL,
	`event` varchar(25) NOT NULL,
	`data` longtext,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
]]
-- End Event Signup

-------------------------------------
-- Handles the event announcements --
-------------------------------------
-- Start Event Announcements
function event_announce()
	local message = "Be sure to checkout Roleplay.co.uk for up and coming halloween events!"
	local message2 = "Exclusive rewards and prizes to be won!"
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(0, 153, 51, 0.3); border-radius: 3px;"><img style="position:absolute;z-index:10;right:0;height:3vw;top:auto;"src="https://www.roleplay.co.uk/images/rplogo.png" /> <b>EVENT ANNOUNCEMENT</b><br> {1}<br>{2}</div><br><br>',
		args = {'', message, message2}
	})
	SetTimeout(900000, event_announce) -- 900000=15 min
end
event_announce()
-- End Event Announcements