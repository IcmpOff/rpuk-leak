function CreateESXPlayer(playerId, identifier, groups, accounts, inventory, weight, job, loadout, name, coords,
	characterId, firstName, lastName, policeLevel, policeData, nhsLevel, nhsData, lostLevel, lostData, mutexJobData,
	gangData, progressData, dead, jailed, wardrobe, mdt, dateOfBirth, sex, height, skin, status, phoneNumber, ammo, health,
	armour)

	local self = {}

	self.accounts = accounts
	self.coords = coords
	self.identifier = identifier
	self.inventory = inventory
	self.job = job
	self.loadout = loadout
	self.ammo = ammo
	self.playerId = playerId
	self.source = playerId -- deprecated, use playerId instead!
	self.variables = {}
	self.weight = weight
	self.maxWeight = Config.MaxWeight

	self.health = health
	self.armour = armour

	self.characterId = characterId
	self.rpuk_charid = characterId -- deprecated

	self.name = name
	self.firstname = firstName
	self.lastname = lastName
	self.dateOfBirth = dateOfBirth
	self.sex = sex
	self.height = height

	-- Job Levels & Data
	self.policelevel = policeLevel
	self.policedata = policeData
	self.nhslevel = nhsLevel
	self.nhsdata = nhsData
	self.lostlevel = lostLevel
	self.lostdata = lostData
	self.gangdata = gangData

	-- Progression Levels
	self.mutexjobdata = mutexJobData
	self.progressdata = progressData

	self.dead = dead
	self.jailed = jailed
	self.wardrobe = wardrobe

	self.skin = skin
	self.status = status
	self.phoneNumber = phoneNumber
	self.groups = groups
	self.doesGroupsNeedSyncing = false

	for group,v in pairs(self.groups) do
		ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.identifier, group))
	end

	self.triggerEvent = function(eventName, ...) TriggerClientEvent(eventName, self.playerId, ...) end

	self.setCoords = function(_coords)
		self.updateCoords(_coords)
		self.triggerEvent('esx:teleport', _coords)
	end

	self.updateCoords = function(_coords)
		self.coords = ESX.Math.FormatCoordsTable(_coords, 'table')
	end

	self.getCoords = function(vector)
		local playerPed = GetPlayerPed(self.playerId)
		local playerCoords = GetEntityCoords(playerPed)
		print('[ESX DEV]', playerPed, playerCoords)

		if playerCoords then
			if vector then
				return ESX.Math.FormatCoordsTable(playerCoords, 'vector3')
			else
				return ESX.Math.FormatCoordsTable(playerCoords, 'table')
			end
		else
			if vector then
				return vector3(self.coords.x, self.coords.y, self.coords.z)
			else
				return self.coords
			end
		end
	end

	self.kick = function(reason) DropPlayer(self.playerId, reason) end

	self.setMoney = function(money)
		money = math.round(money)
		self.setAccountMoney('money', money)
	end

	self.getMoney = function() return self.getAccount('money').money end

	self.addMoney = function(money, reason)
		money = math.round(money)
		self.addAccountMoney('money', money, reason)
	end

	self.removeMoney = function(money, reason)
		money = math.round(money)
		self.removeAccountMoney('money', money, reason)
	end

	self.setHealth = function(newHealth)
		self.health = newHealth
		self.triggerEvent('esx:setHealth', self.health)
	end

	self.getHealth = function() return self.health end

	self.setArmour = function(newArmour)
		self.armour = newArmour
		self.triggerEvent('esx:setArmour', self.armour)
	end

	self.getArmour = function() return self.armour end

	self.updateHealth = function(_health, _armour)
		self.health = _health
		self.armour = _armour
	end

	self.getAccountBalance = function(accountName)
		local account = self.getAccount(accountName)

		if account then
			return account.money
		else
			return 0
		end
	end

	self.getIdentifier = function(steamDec)
		if steamDec then
			return tonumber(string.sub(self.identifier, 7, -1), 16)
		else
			return self.identifier
		end
	end

	self.getCharacterId = function() return self.characterId end

	self.addGroup = function(group)
		if self.groups[group] then
			return false
		else
			self.groups[group] = true
			self.doesGroupsNeedSyncing = true
			self.triggerEvent('esx:setGroups', self.groups)
			ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.identifier, group))
			return true
		end
	end

	self.removeGroup = function(group)
		if self.groups[group] then
			if group == 'user' then
				return false
			else
				self.groups[group] = nil
				self.doesGroupsNeedSyncing = true
				self.triggerEvent('esx:setGroups', self.groups)
				ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.identifier, group))
				return true
			end
		else
			return false
		end
	end

	self.getGroups = function() return self.groups end
	self.shouldUpdateGroups = function() return self.doesGroupsNeedSyncing end
	self.set = function(k, v) self.variables[k] = v end
	self.get = function(k) return self.variables[k] end

	self.getAccounts = function(minimal, keyValue)
		if minimal then
			local minimalAccounts = {}

			for k,v in ipairs(self.accounts) do
				minimalAccounts[v.name] = v.money
			end

			return minimalAccounts
		elseif keyValue then
			local minimalAccounts = {}

			for k,v in ipairs(self.accounts) do
				minimalAccounts[v.name] = v
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	self.getAccount = function(account)
		for k,v in ipairs(self.accounts) do
			if v.name == account then
				return v
			end
		end
	end

	self.getInventory = function(minimal, keyValue)
		if minimal then
			local minimalInventory = {}

			for k,v in ipairs(self.inventory) do
				if v.count > 0 then
					minimalInventory[v.name] = v.count
				end
			end

			return minimalInventory
		elseif keyValue then
			local minimalInventory = {}

			for k,v in ipairs(self.inventory) do
				minimalInventory[v.name] = v
			end

			return minimalInventory
		else
			return self.inventory
		end
	end

	self.getJob = function() return self.job end

	self.getLoadout = function(minimal)
		if minimal then
			local minimalLoadout = {}

			for k,v in pairs(self.loadout) do
				minimalLoadout[v.name] = {}
				if v.tintIndex > 0 then minimalLoadout[v.name].tintIndex = v.tintIndex end

				if #v.components > 0 then
					local components = {}

					for k2,component in ipairs(v.components) do
						if component ~= 'clip_default' then
							table.insert(components, component)
						end
					end

					if #components > 0 then
						minimalLoadout[v.name].components = components
					end
				end
			end

			return minimalLoadout
		else
			return self.loadout
		end
	end

	self.getAmmo = function(minimal)
		if minimal then
			local temp = {}
			for k,v in pairs(self.ammo) do
				if v.count > 0 then
					temp[k] = v.count
				end
			end
			return temp
		else
			return self.ammo
		end
	end

	self.getAmmoOfType = function(type) return self.ammo[type] end

	self.setAccountMoney = function(accountName, money, reason)
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = math.round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
				TriggerEvent('rpuk_log:new_log', self.identifier, self.characterId, ('%s %s'):format(self.firstname, self.lastname), "Transaction", ('%s %s'):format("Overwrite", accountName), money, reason, self.getMoney(), self.getAccountBalance("bank"))
			end
		end
	end

	self.addAccountMoney = function(accountName, money, reason)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money + math.round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
				TriggerEvent('rpuk_log:new_log', self.identifier, self.characterId, ('%s %s'):format(self.firstname, self.lastname), "Transaction", ('%s %s'):format("Add", accountName), money, reason, self.getMoney(), self.getAccountBalance("bank"))
			end
		end
	end

	self.removeAccountMoney = function(accountName, money, reason)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money - math.round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
				TriggerEvent('rpuk_log:new_log', self.identifier, self.characterId, ('%s %s'):format(self.firstname, self.lastname), "Transaction", ('%s %s'):format("Remove", accountName), money, reason, self.getMoney(), self.getAccountBalance("bank"))
			end
		end
	end

	self.getInventoryItem = function(name)
		for k,v in ipairs(self.inventory) do
			if v.name == name then
				return v
			end
		end

		return
	end

	self.hasItem = function(item) return self.getInventoryItem(item).count >= 1 end

	self.addInventoryItem = function(name, count)
		local item = self.getInventoryItem(name)

		if item then
			count = math.round(count)
			item.count = item.count + count
			self.weight = self.weight + (item.weight * count)

			TriggerEvent('esx:onAddInventoryItem', self.playerId, item.name, item.count)
			self.triggerEvent('esx:addInventoryItem', item.name, item.count)
		end
	end

	self.removeInventoryItem = function(name, count)
		local item = self.getInventoryItem(name)

		if item then
			count = math.round(count)
			local newCount = item.count - count

			if newCount >= 0 then
				item.count = newCount
				self.weight = self.weight - (item.weight * count)

				TriggerEvent('esx:onRemoveInventoryItem', self.playerId, item.name, item.count)
				self.triggerEvent('esx:removeInventoryItem', item.name, item.count)
			end
		end
	end

	self.setInventoryItem = function(name, count)
		local item = self.getInventoryItem(name)

		if item and count >= 0 then
			count = math.round(count)

			if count > item.count then
				self.addInventoryItem(item.name, count - item.count)
			else
				self.removeInventoryItem(item.name, item.count - count)
			end
		end
	end

	self.getWeight = function() return self.weight end
	self.getMaxWeight = function() return self.maxWeight end

	self.canCarryItems = function(data)
		local currentWeight = self.weight
		if data then
			for _,v in pairs(data) do
				currentWeight = currentWeight+(ESX.Items[v.name].weight*v.count)
			end
		end

		return currentWeight <= self.maxWeight
	end

	self.canCarryItem = function(name, count)
		local currentWeight, itemWeight = self.weight, ESX.Items[name].weight
		local newWeight = currentWeight + (itemWeight * count)

		return newWeight <= self.maxWeight
	end

	self.canCarryAmmo = function(ammo, count)
		local maxAmmo = ESX.GetAmmo(ammo).max
		local currentAmmo = self.getAmmo()[ammo].count
		return currentAmmo + count <= maxAmmo
	end

	self.canSwapItems = function(addedItems, removedItems)
		local currentWeight = self.weight
		if addedItems then
			for _, v in pairs(addedItems) do
				currentWeight = currentWeight + (ESX.Items[v.name].weight*v.count)
			end
		end
		if removedItems then
			for _, v in pairs(removedItems) do
				currentWeight = currentWeight - (ESX.Items[v.name].weight*v.count)
			end
		end
		return currentWeight <= self.maxWeight
	end

	self.canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
		local firstItemObject = self.getInventoryItem(firstItem)
		local testItemObject = self.getInventoryItem(testItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = math.round(self.weight - (firstItemObject.weight * firstItemCount))
			local weightWithTestItem = math.round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	self.setMaxWeight = function(newWeight)
		self.maxWeight = newWeight
		self.triggerEvent('esx:setMaxWeight', self.maxWeight)
	end

	self.setJob = function(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			if gradeObject.skin_male then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			else
				self.job.skin_male = {}
			end

			if gradeObject.skin_female then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			else
				self.job.skin_female = {}
			end

			TriggerEvent('esx:setJob', self.playerId, self.job, lastJob)
			self.triggerEvent('esx:setJob', self.job, lastJob)
		else
			print(('[ESX] [^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
		end
	end

	self.getGang = function()
		local x = json.decode(self.gangdata)
		return x.gang_id, x.gang_rank
	end

	self.getgangdata = function() return self.gangdata end

	self.setGang = function(gang, rank)
		local oldData = json.decode(self.gangdata)
		oldData.gang_id = gang
		oldData.gang_rank = rank
		self.gangdata = json.encode(oldData)
		self.showNotification('Your gang was updated.', 5000, 'inform')
		self.triggerEvent('esx:setGang', gang, rank)
	end

	self.addWeapon = function(weaponName, ammo)
		if Config.Weapons[string.upper(weaponName)] then
			if not self.hasWeapon(weaponName) then
				local weaponLabel = ESX.GetWeaponLabel(weaponName)

				self.loadout[weaponName] = {
					name = weaponName,
					label = weaponLabel,
					components = {},
					tintIndex = 0
				}

				self.triggerEvent('esx:addWeapon', weaponName)
				self.showInventoryItemNotification(weaponLabel, true)

				if ammo then
					self.addWeaponAmmo(weaponName, ammo)
				else
					self.updateWeaponAmmo(weaponName)
				end
			end
		end
	end

	self.addWeaponComponent = function(weaponName, weaponComponent)
		local weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if not self.hasWeaponComponent(weaponName, weaponComponent) then
					table.insert(self.loadout[weaponName].components, weaponComponent)
					self.triggerEvent('esx:addWeaponComponent', weaponName, weaponComponent)
					self.showInventoryItemNotification(component.label, true)
				end
			end
		end
	end

	self.addWeaponAmmo = function(name, ammo)
		local ammoType

		if Config.ammoTypes[name] then
			ammoType = name
		else
			ammoType = Config.Weapons[name].ammoType
		end

		if ammoType then
			local leftoverAmmo = 0
			if self.ammo[ammoType].max <= ammo+self.ammo[ammoType].count then
				leftoverAmmo = self.ammo[ammoType].count+ammo-self.ammo[ammoType].max
				self.ammo[ammoType].count = self.ammo[ammoType].max
			else
				self.ammo[ammoType].count = ammo+self.ammo[ammoType].count
			end

			self.triggerEvent("esx:setAmmo", ammoType, self.ammo[ammoType].count)
			return leftoverAmmo
		end
	end

	self.setWeaponAmmo = function(name, ammoCount)
		local ammoType

		if Config.ammoTypes[name] then
			ammoType = name
		else
			ammoType = Config.Weapons[name].ammoType
		end

		if ammoType then
			self.ammo[ammoType].count = ammoCount
			self.triggerEvent('esx:setAmmo', ammoType, ammoCount)
		end
	end

	self.updateWeaponAmmo = function(name, count)
		local ammoType
		if Config.ammoTypes[name] then
			ammoType = Config.ammoTypes[name]
		else
			if Config.Weapons[name] then
				ammoType = Config.Weapons[name].ammoType
			end
		end
		if ammoType then
			if count == nil then
				count = self.ammo[ammoType].count
			end
			self.ammo[ammoType].count = count
			self.triggerEvent('esx:setAmmo', ammoType, count)
		end
	end

	self.setWeaponTint = function(weaponName, weaponTintIndex)
		local weapon = self.getWeapon(weaponName)

		if weapon then
			local weaponObject = ESX.GetWeapon(weaponName)

			if weaponObject.tints and weaponObject.tints[weaponTintIndex] then
				self.loadout[weaponName].tintIndex = weaponTintIndex
				self.triggerEvent('esx:setWeaponTint', weaponName, weaponTintIndex)
				self.showInventoryItemNotification(weaponObject.tints[weaponTintIndex], true)
			end
		end
	end

	self.getWeaponTint = function(weaponName)
		local weapon = self.getWeapon(weaponName)

		if weapon then
			return weapon.tintIndex
		end

		return 0
	end

	self.removeWeapon = function(weaponName)
		local weaponLabel

		if self.loadout[weaponName] ~= nil then
			weaponLabel = self.loadout[weaponName].label

			for k2,v2 in ipairs(self.loadout[weaponName].components) do
				self.removeWeaponComponent(weaponName, v2)
			end

			self.loadout[weaponName] = nil

			self.triggerEvent('esx:removeWeapon', weaponName)
			self.showInventoryItemNotification(weaponLabel, false)
		end
	end

	self.removeWeaponComponent = function(weaponName, weaponComponent)
		local weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if self.hasWeaponComponent(weaponName, weaponComponent) then
					for k,v in ipairs(self.loadout[weaponName].components) do
						if v == weaponComponent then
							table.remove(self.loadout[weaponName].components, k)
							break
						end
					end

					self.triggerEvent('esx:removeWeaponComponent', weaponName, weaponComponent)
					self.showInventoryItemNotification(component.label, false)
				end
			end
		end
	end

	self.removeWeaponAmmo = function(name, ammoCount)
		local ammoType
		if Config.ammoTypes[name] then
			ammoType = name
		else
			ammoType = Config.Weapons[name].ammoType
		end

		if self.ammo[ammoType].count - ammoCount < 0 then
			self.ammo[ammoType].count = 0
		else
			self.ammo[ammoType].count = self.ammo[ammoType].count - ammoCount
		end

		self.triggerEvent('esx:setAmmo', ammoType, self.ammo[ammoType].count)
	end

	self.hasWeaponComponent = function(weaponName, weaponComponent)
		local weapon = self.getWeapon(weaponName)

		if weapon then
			for k,v in ipairs(weapon.components) do
				if v == weaponComponent then
					return true
				end
			end

			return false
		else
			return false
		end
	end

	self.hasWeapon = function(weaponName)
		if self.loadout[weaponName] then
			return true
		else
			return false
		end
	end

	self.getWeapon = function(weaponName) return self.loadout[weaponName] end
	self.showNotification = function(msg, length, notificationType, notificationAction) self.triggerEvent('esx:showNotification', msg, length, notificationType, notificationAction) end
	self.showHelpNotification = function(msg, thisFrame, beep, duration) self.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration) end
	self.showAdvancedNotification = function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex) self.triggerEvent('esx:showAdvancedNotification', sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex) end
	self.showInventoryItemNotification = function(msg, add) self.triggerEvent('esx:showInventoryItemNotification', msg, add) end
	self.save = function(cb) ESX.SavePlayer(self, cb) end
	self.getName = function() return self.name end
	self.getfirstname = function() return self.firstname end
	self.getlastname = function() return self.lastname end
	self.getFullName = function() return ('%s %s'):format(self.firstname, self.lastname) end
	self.getpolicelevel = function() return self.policelevel end
	self.getpolicedata = function() return self.policedata end
	self.getnhslevel = function() return self.nhslevel end
	self.getnhsdata = function() return self.nhsdata end
	self.getlostlevel = function() return self.lostlevel end
	self.getlostdata = function() return self.lostdata end
	self.getmutexjobdata = function() return self.mutexjobdata end
	self.getprogressdata = function() return self.progressdata end
	self.getdeadstate = function() return self.dead end
	self.getjailedstate = function() return self.jailedstate end
	self.getwardrobe = function() return self.wardrobe end

	self.setWhitelist = function(faction, level, flag)
		print("RPUK Faction Change: " .. self.firstname .. " " .. self.lastname .. " [" .. self.playerId .. "] " .. faction .. " " .. level .. " " .. tostring(flag))

		if faction == "police" then
			if flag == nil then
				self.policelevel = level
			else
				local oldData = json.decode(self.policedata)
				oldData[flag] = level
				local newData = json.encode(oldData)
				self.policedata = newData
			end
		elseif faction == "nhs" then
			if flag == nil then
				self.nhslevel = level
			else
				local oldData = json.decode(self.nhsdata)
				oldData[flag] = level
				local newData = json.encode(oldData)
				self.nhsdata = newData
			end
		elseif faction == "lost" then
			if flag == nil then
				self.lostlevel = level
			else
				local oldData = json.decode(self.lostdata)
				oldData[flag] = level
				local newData = json.encode(oldData)
				self.lostdata = newData
			end
		end

		self.triggerEvent('esx:setFaction', faction, level, flag)
	end

	self.resetWhitelistFlags = function(faction)
		if faction == "police" then
			local oldData = json.decode(self.policedata)
			for k,v in pairs(oldData) do oldData[k] = 0 end
			self.policedata = json.encode(oldData)
		elseif faction == "nhs" then
			local oldData = json.decode(self.nhsdata)
			for k,v in pairs(oldData) do oldData[k] = 0 end
			self.nhsdata = json.encode(oldData)
		elseif faction == "lost" then
			local oldData = json.decode(self.lostdata)
			for k,v in pairs(oldData) do oldData[k] = 0 end
			self.lostdata = json.encode(oldData)
		end
	end

	self.setMutexJob = function(job, level)
		local oldData = json.decode(self.mutexjobdata)

		if oldData[job] then
			print("RPUK Civilian Level Change: [" .. self.identifier .."] " .. job .. " " .. level .. "")
			oldData[job] = level
			self.mutexjobdata = json.encode(oldData)
			TriggerClientEvent('esx:setFaction', self.playerId, job, level)
		else
			oldData[job] = {}
			oldData[job] = level
			self.mutexjobdata = json.encode(oldData)
			print("RPUK Civilian Job Created For: [" .. self.identifier .."] " .. job .. " " .. level .. "")
			print("RPUK Civilian Level Change: [" .. self.identifier .."] " .. job .. " " .. level .. "")
			TriggerClientEvent('esx:setFaction', self.playerId, job, level)
		end
	end

	self.setStatData = function(stat, level)
		local oldData = json.decode(self.progressdata)
		if oldData[stat] then
			if oldData[stat] < 100 then
				print("RPUK Stat Change: [" .. self.identifier .."] " .. stat .. " " .. level .. "")
				oldData[stat] = level
				self.progressdata = json.encode(oldData)
				TriggerClientEvent('esx:setStat', self.playerId, stat, level)
			end
		else
			oldData[stat] = {}
			oldData[stat] = level
			self.progressdata = json.encode(oldData)
			print("RPUK Stat Created For: [" .. self.identifier .."] " .. stat .. " " .. level .. "")
			print("RPUK Stat Change: [" .. self.identifier .."] " .. stat .. " " .. level .. "")
			TriggerClientEvent('esx:setStat', self.playerId, stat, level)
		end
	end

	self.increaseStat = function(stat, increase)
		local oldData = json.decode(self.progressdata)
		if oldData[stat] == nil then
			oldData[stat] = 0
		end
		oldData[stat] = oldData[stat] + increase
		print("RPUK Stat Change: [" .. self.identifier .."] " .. stat .. " " .. oldData[stat] .. "")
		TriggerClientEvent('esx:setStat', self.playerId, stat, oldData[stat])
		self.progressdata = json.encode(oldData)
	end

	self.decreaseStat = function(stat, decrease)
		local oldData = json.decode(self.progressdata)
		if oldData[stat] == nil then
			oldData[stat] = 0
		end
		if oldData[stat] - decrease < 0 then
			oldData[stat] = 0
		else
			oldData[stat] = oldData[stat] - decrease
		end
		print("RPUK Stat Change: [" .. self.identifier .."] " .. stat .. " " .. oldData[stat] .. "")
		TriggerClientEvent('esx:setStat', self.playerId, stat, oldData[stat])
		self.progressdata = json.encode(oldData)
	end

	self.setState = function(state, value)
		if tostring(state) == "dead" then
			self.dead = value
		elseif tostring(state) == "jailed" then
			self.jailed = value
		end
		TriggerClientEvent('rpuk:setState', self.playerId, state, value)
	end

	self.giveClothing = function(category, drawable, texture)
		local wardrobe_data = json.decode(self.wardrobe)
		for index, data in pairs(wardrobe_data[category]) do
			if data == drawable .. ":" .. texture then
				return -- go no further // stops the event here
			end
		end
		local wardrobe_data = json.decode(self.wardrobe)
		table.insert(wardrobe_data[category], drawable .. ":" .. texture)
		self.wardrobe = json.encode(wardrobe_data)
		--TriggerClientEvent('rpuk:sync_clothing', self.playerId, self.wardrobe)
	end

	-- Job check
	self.isJobONLY_FOR_SECURITY = function(job, check_location)
		-- If it's a table, they can be any of the specified jobs
		if type(job) == 'table' then
			for _, v in ipairs(job) do
				if self.job.name == v then return true end
			end
		else
			if self.job.name == job then return true end
		end

		if self.isAceAllowed('staff.check') then return true end

		print("SECURITY_VIOLATION: '" .. GetPlayerName(self.playerId) .. "' failed job security check: " .. check_location)

		TriggerEvent('rpuk_anticheat:sab', self.playerId, "fakeevent")
		return false
	end

	-- Admin check
	self.isAdminONLY_FOR_SECURITY = function(check_location)
		if self.isAceAllowed('staff.check') then return true end

		print("SECURITY_VIOLATION: '" .. GetPlayerName(self.playerId) .. "' failed STAFF LEVEL CHECK security check: " .. check_location)
		TriggerEvent('rpuk_anticheat:sab', self.playerId, "fakeevent")
		return false
	end

	self.isAceAllowed = function(object) return IsPlayerAceAllowed(self.playerId, object) end

	self.setName = function(firstname, lastname)
		if firstname and firstname ~= "" and lastname and lastname ~= "" then
			print(('[ESX] [^2INFO^7] Name Change "%s %s" to "%s %s"'):format(self.firstname, self.lastname, firstname, lastname))
			self.firstname = firstname
			self.lastname = lastname

			TriggerEvent('rpuk:updateName', self.playerId, ('%s %s'):format(self.firstname, self.lastname))
			TriggerEvent('esx:setName', self.playerId, ('%s %s'):format(self.firstname, self.lastname))
		end
	end

	self.setIdentity = function(_firstName, _lastName, _dateOfBirth, _sex, _height)
		self.firstname = _firstName
		self.lastname = _lastName
		self.dateOfBirth = _dateOfBirth
		self.sex = _sex
		self.height = _height

		TriggerEvent('rpuk:updateName', self.playerId, ('%s %s'):format(self.firstname, self.lastname))
		TriggerEvent('esx:setName', self.playerId, ('%s %s'):format(self.firstname, self.lastname))
	end

	self.getIdentity = function() return self.firstname, self.lastname, self.dateOfBirth, self.sex, self.height end
	self.setSkin = function(newSkin) self.skin = newSkin end
	self.getSkin = function() return self.skin end
	self.getStatus = function() return self.status end
	self.setStatus = function(newStatus) self.status = newStatus end
	self.getPhoneNumber = function() return self.phoneNumber end

	return self
end
