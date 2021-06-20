-- archived migrations

RegisterCommand('migrate_kashacter1', function(a,b,c)
	local playerIdentifierReplacements, asyncTask, timeStart, currentlyMigrating = {}, {}, os.clock(), 1

	MySQL.Async.fetchAll('SELECT identifier, rpuk_charid, character_index FROM users WHERE state = 0', {}, function(result)
		for k,v in ipairs(result) do
			if string.sub(v.identifier, 1, 4) == 'Char' then -- Starts with "Char" ?
				local characterIndex = tonumber(string.sub(v.identifier, 5, 5)) -- extract character index
				local newIdentifier = string.gsub(v.identifier, "Char" .. characterIndex, "steam") -- replace "Char<character index>" with "steam:"

				playerIdentifierReplacements[v.identifier] = {
					newIdentifier = newIdentifier,
					characterIndex = characterIndex,
					characterId = v.rpuk_charid
				}
			end
		end

		for oldIdentifier,data in pairs(playerIdentifierReplacements) do
			table.insert(asyncTask, function(cb)
				MySQL.Async.execute('UPDATE users SET identifier = @new_identifier, character_index = @character_index WHERE rpuk_charid = @rpuk_charid', {
					['@new_identifier'] = data.newIdentifier,
					['@character_index'] = data.characterIndex,
					['@rpuk_charid'] = data.characterId,
				}, function(rowsChanged)
					MySQL.Async.execute('UPDATE phone_users_contacts SET rpuk_charid = @rpuk_charid WHERE identifier = @identifier', {
						['@identifier'] = oldIdentifier,
						['@rpuk_charid'] = data.characterId
					}, function(rowsChanged2)
						MySQL.Async.execute('UPDATE twitter_tweets SET rpuk_charid = @rpuk_charid, realUser = @new_identifier WHERE realUser = @old_identifier', {
							['@old_identifier'] = oldIdentifier,
							['@new_identifier'] = data.newIdentifier,
							['@rpuk_charid'] = data.characterId
						}, function(rowsChanged3)
							print(('[rpuk_migrate] [^2INFO^7] migrated %s to %s [%s-%s-%s] [%s/%s]'):format(oldIdentifier, data.newIdentifier, rowsChanged, rowsChanged2, rowsChanged3, currentlyMigrating, ESX.Table.SizeOf(playerIdentifierReplacements)))
							currentlyMigrating = currentlyMigrating + 1
							cb()
						end)
					end)
				end)
			end)
		end

		Async.parallelLimit(asyncTask, 8, function(results)
			print(('[rpuk_migrate] [^2INFO^7] task complete! migrating %s entries took %.0f seconds'):format(ESX.Table.SizeOf(playerIdentifierReplacements), os.clock() - timeStart))
		end)
	end)
end, true)

RegisterCommand('migrate_kashacter2', function(a,b,c)
	local busyCharacterIndexesForIdentifier, newCharacterIndexesForCharacterId, asyncTask, timeStart, currentlyMigrating = {}, {}, {}, os.clock(), 1

	MySQL.Async.fetchAll('SELECT identifier, rpuk_charid, character_index FROM users WHERE state = 0', {}, function(result)
		print('[rpuk_migrate] [^2INFO^7] looking for entries with busy character index')

		for k,v in ipairs(result) do
			if string.sub(v.identifier, 1, 5) == 'steam' then
				if v.character_index > 0 then
					if not busyCharacterIndexesForIdentifier[v.identifier] then busyCharacterIndexesForIdentifier[v.identifier] = {} end
					busyCharacterIndexesForIdentifier[v.identifier][v.character_index] = true
				end
			end
		end

		print('[rpuk_migrate] [^2INFO^7] cross referencing busy character indexes with missing ones to find a available one')

		for k,v in ipairs(result) do
			if string.sub(v.identifier, 1, 5) == 'steam' then
				if v.character_index == 0 then
					if busyCharacterIndexesForIdentifier[v.identifier] then
						for characterIndex=1,4 do
							if not busyCharacterIndexesForIdentifier[v.identifier][characterIndex] then
								busyCharacterIndexesForIdentifier[v.identifier][characterIndex] = true
								newCharacterIndexesForCharacterId[v.rpuk_charid] = {identifier = v.identifier, characterIndex = characterIndex}
								break
							end
						end
					else
						-- no other characters that belongs to this player, so set the character index to 1
						busyCharacterIndexesForIdentifier[v.identifier] = {[1] = true}
						newCharacterIndexesForCharacterId[v.rpuk_charid] = {identifier = v.identifier, characterIndex = 1}
					end
				end
			end
		end

		for characterId,data in pairs(newCharacterIndexesForCharacterId) do
			table.insert(asyncTask, function(cb)
				MySQL.Async.execute('UPDATE users SET character_index = @character_index WHERE rpuk_charid = @rpuk_charid', {
					['@character_index'] = data.characterIndex,
					['@rpuk_charid'] = characterId
				}, function(rowsChanged)
					MySQL.Async.execute('UPDATE phone_users_contacts SET rpuk_charid = @rpuk_charid WHERE identifier = @identifier AND rpuk_charid IS NULL', {
						['@rpuk_charid'] = characterId,
						['@identifier'] = data.identifier
					}, function(rowsChanged2)
						MySQL.Async.execute('UPDATE twitter_tweets SET rpuk_charid = @rpuk_charid WHERE realUser = @identifier AND rpuk_charid IS NULL', {
							['@rpuk_charid'] = characterId,
							['@identifier'] = data.identifier
						}, function(rowsChanged3)
							print(('[rpuk_migrate] [^2INFO^7] migrated %s [%s-%s-%s] [%s/%s]'):format(characterId, rowsChanged, rowsChanged2, rowsChanged3, currentlyMigrating, ESX.Table.SizeOf(newCharacterIndexesForCharacterId)))
							currentlyMigrating = currentlyMigrating + 1
							cb()
						end)
					end)
				end)
			end)
		end

		Async.parallelLimit(asyncTask, 8, function(results)
			print(('[rpuk_migrate] [^2INFO^7] task complete! migrating %s entries took %.0f seconds'):format(ESX.Table.SizeOf(newCharacterIndexesForCharacterId), os.clock() - timeStart))
		end)
	end)
end, true)

RegisterCommand('migrate_inventory', function(a,b,c)
	local playerInventory, timeStart, currentlyMigrating = {}, os.clock(), 1

	MySQL.Async.fetchAll('SELECT identifier, item, count FROM user_inventory', {}, function(result)
		for k,v in ipairs(result) do
			if v.count > 0 then
				if not playerInventory[v.identifier] then playerInventory[v.identifier] = {} end
				playerInventory[v.identifier][v.item] = v.count
			end
		end

		for identifier,inventory in pairs(playerInventory) do
			MySQL.Sync.execute('UPDATE users SET inventory = @inventory WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@inventory'] = json.encode(inventory)
			})

			print(('[rpuk_migrate] [^2INFO^7] migrated %s [%s/%s]'):format(identifier, currentlyMigrating, ESX.Table.SizeOf(playerInventory)))
			currentlyMigrating = currentlyMigrating + 1
		end

		print(('[rpuk_migrate] [^2INFO^7] done! migrating %s entries took %s seconds'):format(ESX.Table.SizeOf(playerInventory), os.clock() - timeStart))
	end)
end, true)

RegisterCommand('migrate_accounts', function(a,b,c)
	local playerAccount, timeStart, currentlyMigrating = {}, os.clock(), 1

	MySQL.Async.fetchAll('SELECT identifier, money FROM user_accounts', {}, function(blackMoneyAccountResult)
		for k,v in ipairs(blackMoneyAccountResult) do
			if v.money > 0 then
				playerAccount[v.identifier] = {}
				playerAccount[v.identifier].black_money = v.money
			end
		end

		MySQL.Async.fetchAll('SELECT identifier, money, bank FROM users', {}, function(sharedMoneyAccountResult)
			for k2,v2 in ipairs(sharedMoneyAccountResult) do
				if not playerAccount[v2.identifier] then playerAccount[v2.identifier] = {} end
				if v2.money and v2.money > 0 then
					playerAccount[v2.identifier].money = v2.money
				end

				if v2.bank and v2.bank > 0 then
					playerAccount[v2.identifier].bank = v2.bank
				end
			end

			for identifier,account in pairs(playerAccount) do
				MySQL.Sync.execute('UPDATE users SET accounts = @accounts WHERE identifier = @identifier', {
					['@identifier'] = identifier,
					['@accounts'] = json.encode(account)
				})

				print(('[rpuk_migrate] [^2INFO^7] migrated account %s [%s/%s]'):format(identifier, currentlyMigrating, ESX.Table.SizeOf(playerAccount)))
				currentlyMigrating = currentlyMigrating + 1
			end

			print(('[rpuk_migrate] [^2INFO^7] done! migrating %s accounts took %s seconds'):format(ESX.Table.SizeOf(playerAccount), os.clock() - timeStart))
		end)
	end)
end, true)

RegisterCommand('migrate_loadout', function(a,b,c)
	local playerLoadout, timeStart, currentlyMigrating, validWeapons = {}, os.clock(), 1, {}

	for k,v in ipairs(ESX.GetConfig().Weapons) do
		validWeapons[v.name] = true
	end

	MySQL.Async.fetchAll('SELECT identifier, loadout FROM users', {}, function(result)
		for k,v in ipairs(result) do
			if v.loadout then
				local loadout = json.decode(v.loadout)

				if #loadout > 0 then
					playerLoadout[v.identifier] = {}

					for k2,v2 in ipairs(loadout) do
						if validWeapons[v2.name] then
							playerLoadout[v.identifier][v2.name] = {ammo = v2.ammo}

							if #v2.components > 0 then
								local components = {}

								for k3,component in ipairs(v2.components) do
									if component ~= 'clip_default' then
										table.insert(components, component)
									end
								end

								if #components > 0 then
									playerLoadout[v.identifier][v2.name].components = components
								end
							end
						end
					end
				end
			end
		end

		for identifier,loadout in pairs(playerLoadout) do
			MySQL.Sync.execute('UPDATE users SET loadout = @loadout WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@loadout'] = json.encode(loadout)
			})

			print(('[rpuk_migrate] [^2INFO^7] migrated loadout %s [%s/%s]'):format(identifier, currentlyMigrating, ESX.Table.SizeOf(playerLoadout)))
			currentlyMigrating = currentlyMigrating + 1
		end

		print(('[rpuk_migrate] [^2INFO^7] done! migrating %s loadouts took %s seconds'):format(ESX.Table.SizeOf(playerLoadout), os.clock() - timeStart))
	end)
end, true)

function groupReplacement(group)
	if group == 'superadmin' then return 'staff_level_5'
	elseif group == 'admin' then return 'staff_level_1' end

	return group
end

RegisterCommand('migrate_groups', function(a,b,c)
	local playerGroup, timeStart, currentlyMigrating = {}, os.clock(), 1

	MySQL.Async.fetchAll('SELECT identifier, `group` FROM users', {}, function(result)
		for k,v in ipairs(result) do
			local replacement = groupReplacement(v.group)

			-- only change groups that need migrating
			if replacement ~= v.group then
				playerGroup[v.identifier] = replacement
			end
		end

		for identifier,group in pairs(playerGroup) do
			MySQL.Sync.execute('UPDATE users SET `group` = @group WHERE identifier = @identifier', {
				['@identifier'] = identifier,
				['@group'] = group
			})

			print(('[rpuk_migrate] [^2INFO^7] migrated %s, to %s [%s/%s]'):format(identifier, group, currentlyMigrating, ESX.Table.SizeOf(playerGroup)))
			currentlyMigrating = currentlyMigrating + 1
		end

		print(('[rpuk_migrate] [^2INFO^7] done! migrating %s entries took %s seconds'):format(ESX.Table.SizeOf(playerGroup), os.clock() - timeStart))
	end)
end, true)

-- ALTER TABLE owned_vehicles ADD COLUMN `inv_boot` LONGTEXT DEFAULT '{"weapons":[],"items":[]}';
RegisterCommand('migrate_veh_invs', function(a,b,c)
	local migrateData, timeStart, currentlyMigrating = {}, os.clock(), 1

	MySQL.Async.fetchAll('SELECT plate, data FROM trunk_inventory', {}, function(result)
		for k,v in ipairs(result) do
			local oldInventory = json.decode(v.data)

			local newInventory = {}
			newInventory["items"] = {}
			newInventory["weapons"] = {}

			if oldInventory["coffre"] then
				for _, item in pairs(oldInventory["coffre"]) do
					table.insert(newInventory["items"], item)
				end
			end
			if oldInventory["weapons"] then
				for _, weapon in pairs(oldInventory["weapons"]) do
					table.insert(newInventory["weapons"], weapon)
				end
			end
			MySQL.Async.execute('UPDATE owned_vehicles SET inv_boot = @inventory_data WHERE plate = @plate', {
				['@plate'] = v.plate,
				["@inventory_data"] = json.encode(newInventory)
			})
			MySQL.Async.execute('DELETE FROM `trunk_inventory` WHERE plate = @plate', {
				['@plate'] = v.plate,
			})
		end
		print(('[rpuk_migrate] [^2INFO^7] done! migrating %s entries took %s seconds'):format(ESX.Table.SizeOf(result), os.clock() - timeStart))
	end)
end, true)

local mods = {
	["modEngine"] = {
		[0] = 10000,
		[1] = 12500,
		[2] = 15000,
	},
	["modBrakes"] = {
		[0] = 6500,
		[1] = 8775,
		[2] = 11375,
	},
	["modArmor"] = {
		[0] = 2500,
		[1] = 5000,
		[2] = 7500,
		[3] = 10000,
		[4] = 12500,
	},
	["modEngineBlock"] = {
		[0] = 4500,
		[1] = 8000,
		[2] = 10500,
	},
	["modSuspension"] = {
		[0] = 1000,
		[1] = 2000,
		[2] = 3500,
		[3] = 4000,
	},
	["modTurbo"] = {
		[1] = 15000,
	},
	["modHorns"] = {
		[0] = 1625,
		[1] = 4062,
		[2] = 6500,
		[3] = 11375,
	},
}

RegisterCommand('migrate_veh_group', function(a,b,c)
	local compData = {}

	MySQL.Async.fetchAll("SELECT * from owned_vehicles where job='police' OR job='ambulance' OR job='nca' OR job='iopc' OR job='gruppe6'", {}, function(result)
		for k,v in ipairs(result) do
			local vehicleData = json.decode(v.vehicle)
			local plate = v.plate

			local rawId = string.sub(v.owner, string.find(v.owner, ":") + 1)
			local identifier = "steam:" .. rawId

			for mod, num in pairs(vehicleData) do
				if mods[mod] then
					if mods[mod][num] then
						if not compData[identifier] then
							compData[identifier] = 0
							compData[identifier] = mods[mod][num]
						else
							compData[identifier] = compData[identifier] + mods[mod][num]
						end
					end
				end
			end

			MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
				['@plate'] = v.plate,
			})
			print(v.plate .. " Compensated (" .. v.job .. ")")
		end
		for identifier, comp_value in pairs(compData) do
			local comp_data = {account_bank = comp_value}
			MySQL.Async.execute('INSERT INTO comp_requests (identifier, rpuk_charid, comp_data, public_note, staff, staff_note) VALUES (@identifier, -1, @comp_data, "Police Vehicle Modification Compensation", "Stealthee (Lew)", "Development action: Compensating all current police/job vehicle purchases to move to a rented system")', {
				['@identifier'] = identifier,
				["@comp_data"] = json.encode(comp_data),
			})
		end

	end)
end, true)

RegisterCommand('migrate_veh_char', function(a,b,c)
	MySQL.Async.fetchAll("SELECT identifier, rpuk_charid from users", {}, function(result)
		for _,v in ipairs(result) do
			local identifier = v.identifier
			if string.find(v.identifier, "Char1:") or string.find(v.identifier, "Char2:") or string.find(v.identifier, "Char3:") or string.find(v.identifier, "Char4:") then
				local unformatted_ident = string.sub(v.identifier, string.find(v.identifier, ":" )+1)
				identifier = "steam:" .. unformatted_ident
				print(v.identifier .. " now " .. identifier)
			end
			MySQL.Async.execute('UPDATE owned_vehicles SET owner=@identifier, rpuk_charid=@rpukid where owner=@oldident', {
				['@identifier'] = identifier,
				['@rpukid'] = v.rpuk_charid,
				['@oldident'] = v.identifier,
			})
		end
	end)
end, true)

--- populate empty phone numbers
RegisterCommand('migrate_phonenumbers', function(a,b,c)
	local phoneNumberByCharacterId, busyPhoneNumbers, asyncTask, timeStart, currentlyMigrating = {}, {}, {}, os.clock(), 1

	MySQL.Async.fetchAll('SELECT rpuk_charid FROM users WHERE phone_number IS NULL', {}, function(result)
		for k,v in ipairs(result) do
			local phoneNumber = generatePhoneNumber(busyPhoneNumbers)
			phoneNumberByCharacterId[v.rpuk_charid] = phoneNumber
			busyPhoneNumbers[phoneNumber] = true
		end

		for characterId,phoneNumber in pairs(phoneNumberByCharacterId) do
			table.insert(asyncTask, function(cb)
				MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE rpuk_charid = @rpuk_charid', {
					['@rpuk_charid'] = characterId,
					['@phone_number'] = phoneNumber
				}, function(rowsChanged)
					print(('[rpuk_migrate] [^2INFO^7] populated number %s for character %s [%s/%s]'):format(phoneNumber, characterId, currentlyMigrating, ESX.Table.SizeOf(phoneNumberByCharacterId)))
					currentlyMigrating = currentlyMigrating + 1
					cb()
				end)
			end)
		end

		Async.parallelLimit(asyncTask, 8, function(results)
			print(('[rpuk_migrate] [^2INFO^7] task complete! migrating %s entries took %.0f seconds'):format(ESX.Table.SizeOf(phoneNumberByCharacterId), os.clock() - timeStart))
		end)
	end)
end, true)


--- Generate number (string now) with format XXX-XXXX
function generatePhoneNumber(busyPhoneNumbers)
	while true do
		Citizen.Wait(100)
		local prefix, suffix = math.random(0, 999), math.random(0, 9999)
		local formattedNumber = ('%s-%s'):format(prefix, suffix)

		if not busyPhoneNumbers[formattedNumber] and isPhoneNumberAvailable(formattedNumber) then
			return formattedNumber
		end
	end
end
-- Check if phone number is available
function isPhoneNumberAvailable(phoneNumber)
	local fetched = MySQL.Sync.fetchScalar('SELECT 1 FROM users WHERE phone_number = @phone_number', {
		['@phone_number'] = phoneNumber
	})

	return fetched == nil
end