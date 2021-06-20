last_change = os.time()
change_period = 600 -- 300=5mins -- The amount of time until crate locations change
countdown_period = 10 -- Time in seconds to instigate countdown till start
purge_active = false

-------------------------------------
--          Staff Command          --
-------------------------------------
-- Start Staff Commands

ESX.RegisterCommand('start_purge', 'staff_level_1', function(xPlayer, args, showError)
	start_purge()
end, false, {help = '[Staff] Start/End Purge Event'})

ESX.RegisterCommand('purge_crates', 'staff_level_1', function(xPlayer, args, showError)
	local config_length = tableLength(config.crates)
	for i = 4, 1, -1 do
		local array_selection = math.random(1, config_length)
		for i=1, #event_participants, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(event_participants[i].identifier)
			if xPlayer then
				TriggerClientEvent('rpuk_halloween:purge_crate', xPlayer.source, array_selection)
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = 'Crate locations have now changed.' })
			end
		end
	end	
	last_change = os.time()
end, false, {help = '[Staff] Force Crates To Change Locations'})

ESX.RegisterCommand('purge_npcs', 'staff_level_1', function(xPlayer, args, showError)
	local config_length = tableLength(config.crates)
	for i = 4, 1, -1 do
		local array_selection = math.random(1, config_length)
		for i=1, #event_participants, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(event_participants[i].identifier)
			if xPlayer then
				TriggerClientEvent('rpuk_halloween:purge_npcs', xPlayer.source)
				if i == 6 then				
					break
				end
			end
		end
	end	
	last_change = os.time()
end, false, {help = '[Staff] Force Spawn NPCS'})

-- End Staff Commands

-------------------------------------
--         Function Calls          --
-------------------------------------
-- Start Purge Functions
local countdown = nil

function start_purge()
	if purge_active then
		stop_purge()
		return		
	end
	purge_active = true
	countdown = countdown_period
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(0, 153, 51, 0.3); border-radius: 3px;"><img style="position:absolute;z-index:10;right:0;height:3vw;top:auto;"src="https://www.roleplay.co.uk/images/rplogo.png" /> <b>PURGE EVENT</b><br> {1}</div><br><br>',
		args = {'', "The Purge Event Will Start in " .. countdown_period .. " Seconds"}
	})
	while countdown > 0 do -- countdown for purge
		Citizen.Wait(1000)
		countdown = countdown - 1
	end
	if purge_active then
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(0, 153, 51, 0.3); border-radius: 3px;"><img style="position:absolute;z-index:10;right:0;height:3vw;top:auto;"src="https://www.roleplay.co.uk/images/rplogo.png" /> <b>PURGE EVENT</b><br> {1}</div><br><br>',
			args = {'', "The Purge Event Is Now Starting"}
		})
		last_change = os.time()
		MySQL.Async.fetchAll('SELECT * FROM event_signups WHERE event = @event', {
			['@event'] = "purge"
		}, function(event_players)
			for i=1, #event_players, 1 do
				local xPlayer = ESX.GetPlayerFromIdentifier(event_players[i].identifier)
				if xPlayer and xPlayer.rpuk_charid == event_players[i].rpuk_charid then
					TriggerClientEvent('rpuk_halloween:purge_start', xPlayer.source)
					table.insert(event_participants, {identifier = xPlayer.identifier})
				end
			end
		end)
		TriggerEvent('rpuk_halloween:toggle_weather', true)
	end
end

function stop_purge()
	purge_active = false
	countdown = nil
	TriggerClientEvent('rpuk_halloween:purge_stop', -1)
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(0, 153, 51, 0.3); border-radius: 3px;"><img style="position:absolute;z-index:10;right:0;height:3vw;top:auto;"src="https://www.roleplay.co.uk/images/rplogo.png" /> <b>PURGE EVENT</b><br> {1}</div><br><br>',
		args = {'', "The Purge Event Has Ended!"}
	})
	TriggerEvent('rpuk_halloween:toggle_weather', false)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local canSleep = true
		if purge_active then
			local canSleep = false
			local current_time = os.time()
			if os.time() - last_change >= change_period then
				local config_length = tableLength(config.crates)
				for i = 4, 1, -1 do
					local array_selection = math.random(1, config_length)
					for i=1, #event_participants, 1 do
						local xPlayer = ESX.GetPlayerFromIdentifier(event_participants[i].identifier)
						if xPlayer then
							TriggerClientEvent('rpuk_halloween:purge_crate', xPlayer.source, array_selection)
							TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = 'Crate locations have now changed.' })
						end
					end
				end
				last_change = os.time()
			elseif os.time() - last_change >= change_period / 2 then
				for i=1, #event_participants, 1 do
					local xPlayer = ESX.GetPlayerFromIdentifier(event_participants[i].identifier)
					if xPlayer then
						TriggerClientEvent('rpuk_halloween:purge_npcs', xPlayer.source)
						--TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = 'NPCs Have Spawned.' })
						break -- only need 1 player to spawn all the shit
					end
				end
			end
		end
		if canSleep then
			Citizen.Wait(5000)
		end
	end
end)

RegisterNetEvent('rpuk_halloween:crate_search')
AddEventHandler('rpuk_halloween:crate_search', function(index)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		if config.crates[index] then
			local crate_location = vector3(config.crates[index].location.x, config.crates[index].location.y, config.crates[index].location.z)
			local distance = #(crate_location - xPlayer.getCoords(true))
			if distance > 10 then
				print("RPUK Purge: " .. xPlayer.identifier .. " Failed Distance Check")
				return
			end
			for k, v in pairs(config.crates[index].pools) do
				if 100 * math.random() < config.crate_pools[v].chance then
					for i, e in pairs(config.crate_pools[v].contents) do		
						local length = tableLength(config.crate_pools[v].contents)
						if math.random(1, length) > length / 2 then
							local item = e
							if string.match(string.lower(item), "weapon_") then
								if item == "weapon_molotov" then
									xPlayer.addWeapon(item, 1)
								elseif v == "t3" or v == "t4" then
									xPlayer.addWeapon(item, math.random(10, 20))
								else
									xPlayer.addWeapon(item, math.random(30, 75))
								end
							else
								if v == "t3" or v == "t4" then
									xPlayer.addInventoryItem(item, math.random(1, 5))
								else
									xPlayer.addInventoryItem(item, math.random(5, 20))
								end
							end
						end
					end
				end
			end
		end		
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId, xSource)
	if purge_active then
		if xSource then
			TriggerClientEvent('rpuk_halloween:purge_start', xSource.source)
			TriggerClientEvent('mythic_notify:client:SendAlert', xSource.source, { length = 6000, type = 'inform', text = 'Delayed Purge Start. You will have to wait for the next crate cycle in order to loot/see the loot crates.' })
		end
	end
end)

-- End Purge Functions

function tableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end