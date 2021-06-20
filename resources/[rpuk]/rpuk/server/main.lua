
ESX.RegisterCommand('aaa', 'staff_level_5', function(xPlayer, args, showError)
    showError(ESX.DumpTable(requestIdsNotReturned))
end, true, {help = 'callback size', validate = false})

Citizen.CreateThread(function()
	SetMapName('San Andreas')
	SetGameType('Roleplay')

	SetConvarServerInfo('Forum', 'roleplay.co.uk')
	SetConvarServerInfo('Discord', 'discord.gg/roleplay')
end)

AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == 'rpuk_characters' then
		print(('[ESX] [^3WARNING^7] Resource ^3rpuk_characters^7 is stopping! Saving & unloading all players'):format(playerId))

		for _,playerId in ipairs(ESX.GetPlayers()) do
			local xPlayer = ESX.GetPlayerFromId(playerId)

			if xPlayer then
				xPlayer.save(function()
					ESX.Players[playerId] = nil
				end)
			end
		end
	end
end)

AddEventHandler('esx:onPlayerJoined', function(playerId, characterIndex)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		print(('[ESX] [^3WARNING^7] Player id "%s^7" who already is connected has been called ^3onPlayerJoined^7 on. ' ..
			'Will save player and query new character from database.'):format(playerId))

		ESX.SavePlayer(xPlayer, function()
			ESX.Players[playerId] = nil
			onPlayerJoined(playerId, characterIndex)
		end)
	else
		onPlayerJoined(playerId, characterIndex)
	end
end)

function onPlayerJoined(playerId, characterIndex)
	local identifier

	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'steam:') then
			identifier = v
			break
		end
	end

	if identifier then
		if ESX.GetPlayerFromIdentifier(identifier) then
			DropPlayer(playerId, ('there was an error loading your character!\nError code: identifier-active-ingame\n\n' ..
				'This error is caused because there is a player on the server with the same identifier as yours.\n\n' ..
				'Or this error can also be caused whilst the server saves your data to the hive, ' ..
				'please allow up to 10 minutes for your data to save. If it does not finish saving ' ..
				'there is a possiblity that your data had an issue saving.\n\n' ..
				'Your Steam identifier: %s\nYour Server ID: %s\n\nForum: roleplay.co.uk\nDiscord: discord.gg/roleplay' ..
				'\nTeamSpeak: ts.roleplay.co.uk'):format(tonumber(string.sub(GetPlayerIdentifier(playerId), 7, -1), 16), playerId))
		else
			loadESXPlayer(identifier, playerId, characterIndex)
		end
	else
		DropPlayer(playerId, 'there was an error loading your character!\nError code: identifier-missing-ingame\n\n' ..
			'This issue occured because your Steam identification isn\'t available, make sure Steam is running!')
	end
end

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	deferrals.defer()
	local tempId, identifier = source
	Citizen.Wait(0)

	for k,v in ipairs(GetPlayerIdentifiers(tempId)) do
		if string.match(v, 'steam:') then
			identifier = v
			break
		end
	end

	if identifier then
		if ESX.GetPlayerFromIdentifier(identifier) then
			deferrals.done(('there was an error loading your character!\nError code: identifier-active\n\n' ..
				'This error is caused because there is a player on the server with the same identifier as yours.\n\n' ..
				'Or this error can also be caused whilst the server saves your data to the hive, ' ..
				'please allow up to 10 minutes for your data to save. If it does not finish saving ' ..
				'there is a possiblity that your data had an issue saving.\n\n' ..
				'Your Steam identifier: %s\nYour Temp ID: %s\n\nForum: roleplay.co.uk\nDiscord: discord.gg/roleplay' ..
				'\nTeamSpeak: ts.roleplay.co.uk'):format(tonumber(string.sub(GetPlayerIdentifier(tempId), 7, -1), 16), tempId))
		else
			deferrals.done()
		end
	else
		deferrals.done('there was an error loading your character!\nError code: identifier-missing\n\n' ..
			'This issue occured because your Steam identification isn\'t available, make sure Steam is running!')
	end
end)

function loadESXPlayer(identifier, playerId, characterIndex)
	local userData = {
		accounts = {},
		inventory = {},
		job = {},
		loadout = {},
		playerName = GetPlayerName(playerId):gsub("%W", " "),
		weight = 0,
		ammo = ESX.deepCopy(Config.ammoTypes)
	}

	MySQL.Async.fetchAll([===[
		SELECT
			users.rpuk_charid, user_groups.groups, users.accounts, users.job, users.job_grade, users.loadout, users.position,
			users.firstname, users.lastname, users.policelevel, users.policedata, users.nhslevel, users.nhsdata, users.lostlevel,
			users.lostdata, users.mutexjobdata, users.progressdata, users.gang_data, users.dead, users.jailed, users.wardrobe,
			users.dateofbirth, users.sex, users.height, users.skin, users.status, users.phone_number, users.inventory
		FROM users
		LEFT JOIN user_groups
		ON users.identifier = user_groups.identifier
		WHERE users.identifier = @identifier AND users.character_index = @character_index AND users.state = 0
		]===], {
		['@identifier'] = identifier,
		['@character_index'] = characterIndex
	}, function(result)
		if result and result[1] then
			local job, grade, jobObject, gradeObject = result[1].job, tostring(result[1].job_grade)
			local foundAccounts, foundItems = {}, {}

			userData.characterId = result[1].rpuk_charid
			userData.firstName = result[1].firstname
			userData.lastName = result[1].lastname
			userData.policeLevel = result[1].policelevel
			userData.policeData = result[1].policedata
			userData.nhsLevel = result[1].nhslevel
			userData.nhsData = result[1].nhsdata
			userData.lostLevel = result[1].lostlevel
			userData.lostData = result[1].lostdata
			userData.mutexJobData = result[1].mutexjobdata
			userData.gangData = result[1].gang_data
			userData.progressData = result[1].progressdata
			userData.dead = result[1].dead
			userData.jailed = result[1].jailed
			userData.wardrobe = result[1].wardrobe
			userData.dateOfBirth = result[1].dateofbirth
			userData.sex = result[1].sex
			userData.height = result[1].height
			userData.phoneNumber = result[1].phone_number
			userData.health = result[1].health
			userData.armour = result[1].armour

			-- Skin
			if result[1].skin and result[1].skin ~= '' then
				local skin = json.decode(result[1].skin)

				if skin then
					userData.skin = skin
				end
			end

			-- Status
			if result[1].status and result[1].status ~= '' then
				local status = json.decode(result[1].status)

				if status then
					userData.status = status
				end
			end

			-- Accounts
			if result[1].accounts and result[1].accounts ~= '' then
				local accounts = json.decode(result[1].accounts)

				for account,money in pairs(accounts) do
					foundAccounts[account] = money
				end
			end

			for account,label in pairs(Config.Accounts) do
				table.insert(userData.accounts, {
					name = account,
					money = foundAccounts[account] or Config.StartingAccountMoney[account] or 0,
					label = label
				})
			end

			-- Job
			if ESX.DoesJobExist(job, grade) then
				jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
			else
				print(('[ESX] [^3WARNING^7] Ignoring invalid job for %s [job: %s, grade: %s]'):format(identifier, job, grade))
				job, grade = 'unemployed', '0'
				jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
			end

			userData.job.id = jobObject.id
			userData.job.name = jobObject.name
			userData.job.label = jobObject.label

			userData.job.grade = tonumber(grade)
			userData.job.grade_name = gradeObject.name
			userData.job.grade_label = gradeObject.label
			userData.job.grade_salary = gradeObject.salary

			userData.job.skin_male = {}
			userData.job.skin_female = {}

			if gradeObject.skin_male then userData.job.skin_male = json.decode(gradeObject.skin_male) end
			if gradeObject.skin_female then userData.job.skin_female = json.decode(gradeObject.skin_female) end

			-- Inventory
			if result[1].inventory and result[1].inventory ~= '' then
				local inventory = json.decode(result[1].inventory)

				for name,count in pairs(inventory) do
					local item = ESX.Items[name]

					if item then
						foundItems[name] = count
					else
						print(('[ESX] [^3WARNING^7] Ignoring invalid item "%s" for "%s"'):format(name, identifier))
					end
				end
			end

			for name,item in pairs(ESX.Items) do
				local count = foundItems[name] or 0
				if count > 0 then userData.weight = userData.weight + (item.weight * count) end

				table.insert(userData.inventory, {
					name = name,
					count = count,
					label = item.label,
					weight = item.weight,
					usable = ESX.UsableItemsCallbacks[name] ~= nil,
					rare = item.rare,
					canRemove = item.canRemove
				})
			end

			table.sort(userData.inventory, function(a, b)
				return a.label < b.label
			end)

			-- Groups
			if result[1].groups and result[1].groups ~= '' then
				local groups = json.decode(result[1].groups)
				userData.groups = groups
			else
				userData.groups = {['user'] = true}
			end

			-- Loadout
			if result[1].loadout and result[1].loadout ~= '' then
				local loadout = json.decode(result[1].loadout)

				if loadout.weapons == nil then
					for k,v in pairs(loadout) do
						k = string.upper(k)
						if Config.Weapons[k].ammoType and v.ammo > 0 then
							if Config.ammoTypes[Config.Weapons[k].ammoType].max ~= userData.ammo[Config.Weapons[k].ammoType].count then
								if userData.ammo[Config.Weapons[k].ammoType].count + v.ammo > Config.ammoTypes[Config.Weapons[k].ammoType].max then
									userData.ammo[Config.Weapons[k].ammoType].count = Config.ammoTypes[Config.Weapons[k].ammoType].max
								else
									userData.ammo[Config.Weapons[k].ammoType].count = userData.ammo[Config.Weapons[k].ammoType].count + v.ammo
								end
							end
						end
					end

					for name,weapon in pairs(loadout) do
						name = string.upper(name)
						local label = ESX.GetWeaponLabel(name)

						if label then
							if not weapon.components then weapon.components = {} end
							if not weapon.tintIndex then weapon.tintIndex = 0 end

							userData.loadout[name] = {
								name = name,
								label = label,
								components = weapon.components,
								tintIndex = weapon.tintIndex
							}
						end
					end
				else
					for k,v in pairs(Config.ammoTypes) do
						if loadout.ammo[k] then
							userData.ammo[k].count = loadout.ammo[k]
						else
							userData.ammo[k].count = 0
						end
					end

					for name,weapon in pairs(loadout.weapons) do
						local label = ESX.GetWeaponLabel(name)

						if label then
							if not weapon.components then weapon.components = {} end
							if not weapon.tintIndex then weapon.tintIndex = 0 end

							userData.loadout[name] = {
								name = name,
								label = label,
								components = weapon.components,
								tintIndex = weapon.tintIndex
							}
						end
					end
				end
			end

			-- Position
			if result[1].position and result[1].position ~= '' then
				userData.coords = json.decode(result[1].position)
			else
				userData.coords = {x = 345.1, y = -213.7, z = 58.0, heading = 0.0}
			end

			-- Create ESX player object
			local xPlayer = CreateESXPlayer(playerId, identifier, userData.groups, userData.accounts, userData.inventory,
			userData.weight, userData.job, userData.loadout, userData.playerName, userData.coords, userData.characterId,
			userData.firstName, userData.lastName, userData.policeLevel, userData.policeData, userData.nhsLevel,
			userData.nhsData, userData.lostLevel, userData.lostData, userData.mutexJobData, userData.gangData,
			userData.progressData, userData.dead, userData.jailed, userData.wardrobe, userData.mdt, userData.dateOfBirth,
			userData.sex, userData.height, userData.skin, userData.status, userData.phoneNumber, userData.ammo, userData.health,
			userData.armour)

			ESX.Players[playerId] = xPlayer
			TriggerEvent('esx:playerLoaded', playerId, xPlayer)

			xPlayer.triggerEvent('esx:playerLoaded', { -- all this under will REPLACE PlayerData
				inventory = xPlayer.getInventory(false, true),
				maxWeight = xPlayer.getMaxWeight(),
				loadout = xPlayer.getLoadout(),
				ammo = xPlayer.getAmmo(),
				accounts = xPlayer.getAccounts(false, true),
				coords = xPlayer.getCoords(),
				identifier = xPlayer.getIdentifier(),
				job = xPlayer.getJob(),
				money = xPlayer.getMoney(),
				skin = xPlayer.getSkin(),
				status = xPlayer.getStatus(),
				name = xPlayer.getFullName(),
				police_level = userData.policeLevel,
				police_data = json.decode(userData.policeData),
				nhs_level = userData.nhsLevel,
				nhs_data = json.decode(userData.nhsData),
				lost_level = userData.lostLevel,
				lost_data = json.decode(userData.lostData),
				civ_job = json.decode(userData.mutexJobData),
				gang_data = json.decode(userData.gangData),
				stats = json.decode(userData.progressData),
				death_state = userData.dead,
				jail_state = userData.jailed,
				wardrobe = json.decode(userData.wardrobe),
			})

			xPlayer.triggerEvent('esx:setGroups', userData.groups)
			xPlayer.triggerEvent('esx:registerSuggestions', ESX.RegisteredCommands)
			print(('[ESX] [^2INFO^7] A player with name "%s^7" has connected to the server with assigned player id %s'):format(xPlayer.getName(), playerId))
		else
			DropPlayer(playerId, 'Character query failed')
		end
	end)
end

AddEventHandler('chatMessage', function(playerId, author, message)
	if message:sub(1, 1) == '/' and playerId > 0 then
		CancelEvent()
		local commandName = message:sub(1):gmatch("%w+")()
		TriggerClientEvent('chat:addMessage', playerId, {templateId = 'rpuk', args = {('%s is not a valid command!'):format(commandName)}})
	end
end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		TriggerEvent('esx:playerDropped', playerId, reason)

		ESX.SavePlayer(xPlayer, function()
			print(('[ESX] [^2INFO^7] A player with name "%s^7" with server id %s has left the server'):format(xPlayer.getName(), playerId))
			ESX.Players[playerId] = nil
		end)
	end
end)

RegisterNetEvent('esx:updateCoords')
AddEventHandler('esx:updateCoords', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.updateCoords(coords)
	end
end)

RegisterNetEvent('esx:updateHealth')
AddEventHandler('esx:updateHealth', function(health, armour)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		if type(health) == 'number' and type(armour) == 'number' then
			xPlayer.updateHealth(health, armour)
		end
	end
end)

RegisterNetEvent('esx:updateWeaponAmmo')
AddEventHandler('esx:updateWeaponAmmo', function(weaponName, ammoCount)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.updateWeaponAmmo(weaponName, ammoCount)
	end
end)

RegisterNetEvent('esx:givePlayerInventoryItem')
AddEventHandler('esx:givePlayerInventoryItem', function(target, type, itemName, itemCount)
	local playerId = source
	local sourceXPlayer = ESX.GetPlayerFromId(playerId)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if type == 'item_standard' then
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetXPlayer.canCarryItem(itemName, itemCount) then
				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem   (itemName, itemCount)

				sourceXPlayer.showNotification(_U('gave_item', itemCount, sourceItem.label))
				targetXPlayer.showNotification(_U('received_item', itemCount, sourceItem.label))
			else
				sourceXPlayer.showNotification(_U('ex_inv_lim'))
			end
		else
			sourceXPlayer.showNotification(_U('imp_invalid_quantity'))
		end
	elseif type == 'item_account' then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
			sourceXPlayer.removeAccountMoney(itemName, itemCount, ('%s (%s) [%s]'):format('Give Inventory Item', itemName, GetCurrentResourceName()))
			targetXPlayer.addAccountMoney(itemName, itemCount, ('%s (%s) [%s]'):format('Receive Inventory Item', itemName, GetCurrentResourceName()))

			sourceXPlayer.showNotification(_U('gave_account_money', ESX.Math.GroupDigits(itemCount), Config.Accounts[itemName]))
			targetXPlayer.showNotification(_U('received_account_money', ESX.Math.GroupDigits(itemCount), Config.Accounts[itemName]))
		else
			sourceXPlayer.showNotification(_U('imp_invalid_amount'))
		end
	elseif type == 'item_weapon' then
		if sourceXPlayer.hasWeapon(itemName) then
			local weaponLabel = ESX.GetWeaponLabel(itemName)

			if not targetXPlayer.hasWeapon(itemName) then
				local weapon = sourceXPlayer.getWeapon(itemName)

				targetXPlayer.addWeapon(itemName)

				if weapon.components[1] then
					for k,v in pairs(weapon.components) do
						targetXPlayer.addWeaponComponent(itemName, v)
					end
				end

				sourceXPlayer.removeWeapon(itemName)

				sourceXPlayer.showNotification(_U('gave_weapon', weaponLabel))
				targetXPlayer.showNotification(_U('received_weapon', weaponLabel))
			else
				sourceXPlayer.showNotification(_U('gave_weapon_hasalready', weaponLabel))
				targetXPlayer.showNotification(_U('received_weapon_hasalready', weaponLabel))
			end
		end
	elseif type == 'item_ammo' then
		if sourceXPlayer.hasWeapon(itemName) then
			local weapon = sourceXPlayer.getWeapon(itemName)

			if targetXPlayer.hasWeapon(itemName) then
				local weaponObject = ESX.GetWeapon(itemName)

				if weaponObject.ammo then
					local ammoLabel = weaponObject.ammo.label

					if weapon.ammo >= itemCount then
						sourceXPlayer.removeWeaponAmmo(itemName, itemCount)
						targetXPlayer.addWeaponAmmo(itemName, itemCount)

						sourceXPlayer.showNotification(_U('gave_weapon_ammo', itemCount, ammoLabel, weapon.label))
						targetXPlayer.showNotification(_U('received_weapon_ammo', itemCount, ammoLabel, weapon.label))
					end
				end
			else
				sourceXPlayer.showNotification(_U('gave_weapon_noweapon'))
				targetXPlayer.showNotification(_U('received_weapon_noweapon', weapon.label))
			end
		end
	end
end)

RegisterNetEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem(itemName).count

	if count > 0 then
		ESX.UseItem(source, itemName)
	else
		xPlayer.showNotification(_U('act_imp'))
	end
end)

RegisterNetEvent("esx:weaponAdded")
AddEventHandler("esx:weaponAdded", function(weaponHash)
	ESX.GetPlayerFromId(source).updateWeaponAmmo(weaponHash)
end)

ESX.RegisterServerCallback('esx:spawnVehicle', function(playerId, cb, model, coords, heading)
	local entityHandle = Citizen.InvokeNative(GetHashKey('CREATE_AUTOMOBILE'), model, coords, heading)
	cb(NetworkGetNetworkIdFromEntity(entityHandle))
end)

ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		loadout      = xPlayer.getLoadout(),
		ammo 		 = xPlayer.getAmmo(),
		money        = xPlayer.getMoney(),
		name 		 = xPlayer.firstname .. " " .. xPlayer.lastname
	})
end)

ESX.RegisterServerCallback('esx:getPlayerNames', function(source, cb, players)
	players[source] = nil

	for playerId,v in pairs(players) do
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			players[playerId] = xPlayer.getName()
		else
			players[playerId] = nil
		end
	end

	cb(players)
end)

ESX.StartDBSync()
ESX.StartPayCheck()

local trackedBlips = {}
ESX.RegisterServerCallback('esx:togglePlayerBlip', function(playerId, cb, serverId, toggle)
	local coords = nil
	if serverId and toggle ~= nil then
		local entity = GetPlayerPed(serverId)
		if toggle then
			if trackedBlips[serverId] == nil then --If the entity isnt being tracked at all by the server, make it
				if DoesEntityExist(entity) then
					trackedBlips[serverId] = {pids={playerId}}
					coords = GetEntityCoords(entity)
				end
			else
				table.insert(trackedBlips[serverId].pids, playerId)
				coords = GetEntityCoords(entity)
			end	
		else
			if trackedBlips[serverId] then
				local tempList = {}
				for index, data in pairs (trackedBlips[serverId].pids) do
					if data ~= playerId then
						table.insert(tempList, data)
					end
				end
				trackedBlips[serverId].pids = tempList
			end
		end
	end
	cb(coords)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		if trackedBlips ~= nil then
			for index, data in pairs (trackedBlips) do
				local coords = GetEntityCoords(GetPlayerPed(index))
				for i2, d2 in pairs (data.pids) do
					TriggerClientEvent("esx:updatePlayerBlip", i2, index, coords)
				end
			end
		end
	end
end)