createInstance = function(data)
	local self = {}

	for k,v in pairs(config.houseSpawns) do
		if not v.taken then
			self.houseSpawn = k
			config.houseSpawns[k].taken = true
			break
		end
	end

	self.id = data.id
	self.prop = config.houses[self.id].prop
	self.exit = {x = config.houseSpawns[self.houseSpawn].coords.x + config.offsets[self.prop].door.x, y = config.houseSpawns[self.houseSpawn].coords.y + config.offsets[self.prop].door.y, z = config.houseSpawns[self.houseSpawn].coords.z + config.offsets[self.prop].door.z}
	self.entrance = config.houses[self.id].door
	self.players = {
		[data.source] = {
			type = data.type,
			access = config.access[data.type]
		}
	}
	if data.type == "visit" then
		self.furniture = {}
		self.isBrokenInto = false
	else
		self.isBrokenInto = data.isBrokenInto
		self.furniture = json.decode(MySQL.Sync.fetchAll("SELECT * FROM houses WHERE houseId = @houseId", {["@houseId"] = self.id})[1].furniture)
	end

	self.knocked = {}

	self.enter = function(source, type)
		self.players[source] = {
			type = type, -- Raider / Owner / Visitor / Thief etc
			access = config.access[type]
		}
		TriggerClientEvent("rpuk_housing:enterHouse", source, self, type)
	end

	self.leave = function(source)
		self.players[source] = nil
		local entrance = self.entrance
		if next(self.players) == nil then
			if self.isBrokenInto then
				Citizen.CreateThread(function()
					local timer = 10
					while timer > 0 do
						Wait(1000)
						timer = timer - 1
						if next(self.players) ~= nil then
							break
						end
					end

					if next(self.players) == nil then
						config.houseSpawns[self.houseSpawn].taken = false
						TriggerClientEvent("rpuk_housing:registerInteractionDefault", -1, self.id)
						activeHouses[self.id] = nil
					end
				end)
			else
				config.houseSpawns[self.houseSpawn].taken = false
				activeHouses[self.id] = nil
			end
		end
		TriggerClientEvent("rpuk_housing:leaveHouse", source, entrance)
	end

	self.knock = function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		self.knocked[source] = xPlayer.firstname .. " " .. xPlayer.lastname
		for k,v in pairs(self.players) do
			if v.access.letIn then
				TriggerEvent("InteractSound_SV:PlayOnOne", k, "doorbell", 1.0)
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { length = 2500, action = 'longnotif', type = 'inform', text = "You have pushed the door bell"})
				TriggerClientEvent('mythic_notify:client:SendAlert', k, { length = 2500, action = 'longnotif', type = 'inform', text = xPlayer.firstname .. " " .. xPlayer.lastname .. " has pushed the door bell"})
				TriggerClientEvent("rpuk_housing:knockedDoor", k, source, xPlayer.firstname .. " " .. xPlayer.lastname)
				return
			end
		end
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { length = 2500, action = 'longnotif', type = 'inform', text = "Owner is not home"})
	end

	self.breach = function(source)
		self.isBrokenInto = true
		self.enter(source, "raider")
	end

	return self
end

createHouse = function(data)
	local self = {}

	self.houseId = data.houseId
	self.owner = data.owner
	self.furniture = json.decode(data.furniture)
	self.boughtFurniture = json.decode(data.bought_furniture)
	self.boughtTime = data.boughtTime
	self.paidMonth = (data.paidMonth == 1 or false and true)
	self.items = {}
	self.accounts = {}
	self.weapons = {}
	self.ammo = ESX.GetAmmo()
	self.maxWeight = config.props[config.houses[self.houseId].prop].maxStorage
	self.currentWeight = 0
	self.maxVehicles = config.props[config.houses[self.houseId].prop].maxVehicles
	self.price = config.houses[self.houseId].price

	self.saving = false

	local temp = json.decode(data.data)

	if temp.items then
		self.items = temp.items
		for k,v in pairs(self.items) do
			if config.localWeight[k] then
				self.currentWeight = (config.localWeight[k]*v) + self.currentWeight
			else
				self.currentWeight = self.currentWeight + (config.defaultWeight*v)
			end
		end
	end

	if temp.weapons then
		self.weapons = temp.weapons
		for k,v in pairs(self.weapons) do
			if config.localWeight[v.name] then
				self.currentWeight = (config.localWeight[v.name]*v.count) + self.currentWeight
			else
				self.currentWeight = self.currentWeight + (config.defaultWeight*v.count)
			end
		end
	end

	if temp.ammo then
		for k,v in pairs(temp.ammo) do
			self.ammo[k].count = v
		end
	end

	if temp.accounts then
		self.accounts = temp.accounts
	end

	self.minifyWeapons = function()
		local temp = nil
		if next(self.weapons) then
			temp = self.weapons
		end
		return temp
	end

	self.minifyAccounts = function()
		local temp = nil
		if next(self.accounts) then
			temp = self.accounts
		end
		return temp
	end

	self.minifyItems = function()
		local temp = nil
		if next(self.items) then
			temp = self.items
		end
		return temp
	end

	self.minifyAmmo = function()
		local temp = {}
		for k,v in pairs(self.ammo) do
			if v.count > 0 then
				temp[k] = v.count
			end
		end
		return temp
	end

	self.getWeaponIndex = function(weaponName, components)
		for k,v in pairs(self.weapons) do
			if v.name == weaponName then
				if components and v.components then
					if hasSameComponents(v.components, components) then
						return k
					end
				elseif components == nil and v.components == nil then
					return k
				end
			end
		end
	end

	self.save = function()
		while self.saving do
			Citizen.Wait(100)
		end
		self.saving = true
		MySQL.Sync.execute("UPDATE houses SET owner = @owner, furniture = @furniture, bought_furniture = @boughtFurniture, paidMonth = @paidMonth, data = @data WHERE houseId = @id", {
			["@owner"] = self.owner,
			["@id"] = self.houseId,
			["@furniture"] = json.encode(self.furniture),
			["@boughtFurniture"] = json.encode(self.boughtFurniture),
			["@paidMonth"] = self.paidMonth,
			["@data"] = json.encode({
				items = self.minifyItems(self.items),
				weapons = self.minifyWeapons(self.weapons),
				accounts = self.minifyAccounts(self.accounts),
				ammo = self.minifyAmmo(self.ammo)
			})
		})
		self.saving = false
	end

	self.saveFurniture = function()
		while self.saving do
			Citizen.Wait(100)
		end
		self.saving = true
		MySQL.Sync.execute("UPDATE houses SET furniture = @furniture WHERE houseId = @id", {
			["@furniture"] = json.encode(self.furniture),
			["@id"] = self.houseId
		})
		self.saving = false
	end

	self.saveStorage = function()
		while self.saving do
			Citizen.Wait(100)
		end
		self.saving = true
		MySQL.Sync.execute("UPDATE houses SET data = @data WHERE houseId = @id", {
			["@data"] = json.encode({
				items = self.minifyItems(self.items),
				weapons = self.minifyWeapons(self.weapons),
				accounts = self.minifyAccounts(self.accounts),
				ammo = self.minifyAmmo(self.ammo)
			}),
			["@id"] = self.houseId,
		})
		self.saving = false
	end

	self.addItem = function(name, count)
		local addedWeight
		if config.localWeight[name] then
			addedWeight = config.localWeight[name]*count
		else
			addedWeight = config.defaultWeight*count
		end
		if self.currentWeight+addedWeight <= self.maxWeight then
			if self.items[name] then
				self.items[name] = self.items[name]+count
			else
				self.items[name] = count
			end
			self.currentWeight = self.currentWeight+addedWeight
			self.saveStorage()
			return true, "Added item to storage"
		else
			return false, "Storage is full"
		end
	end

	self.removeItem = function(name, count)
		if self.items[name] then
			if self.items[name] >= count then
				local addedWeight
				if config.localWeight[name] then
					addedWeight = config.localWeight[name]*count
				else
					addedWeight = config.defaultWeight*count
				end
				if self.items[name] == count then
					self.items[name] = nil
				else
					self.items[name] = self.items[name]-count
				end
				self.currentWeight = self.currentWeight-addedWeight
				self.saveStorage()
				return true, "Removed item from storage"
			else
				return false, "Not enough of item in storage"
			end
		else
			return false, "This item does not exist in storage"
		end
	end

	self.addWeapon = function(name, count, components)
		local index = self.getWeaponIndex(name, components)
		local addedWeight
		if config.localWeight[name] then
			addedWeight = config.localWeight[name]*count
		else
			addedWeight = config.defaultWeight*count
		end
		if self.currentWeight+addedWeight <= self.maxWeight then
			if index then
				self.weapons[index].count = self.weapons[index].count+count
			else
				table.insert(self.weapons, {
					name = name,
					count = count,
					components = components
				})
			end
			self.currentWeight = self.currentWeight+addedWeight
			self.saveStorage()
			return true, "Added weapon to storage"
		else
			return false, "Storage is full"
		end
	end

	self.removeWeapon = function(name, count, components)
		local index = self.getWeaponIndex(name, components)
		if index then
			if self.weapons[index].count >= count then
				local index = self.getWeaponIndex(name, components)
				local addedWeight
				if config.localWeight[name] then
					addedWeight = config.localWeight[name]*count
				else
					addedWeight = config.defaultWeight*count
				end
				if self.weapons[index].count == count then
					self.weapons[index] = nil
				else
					self.weapons[index].count = self.weapons[index].count-count
				end
				self.currentWeight = self.currentWeight-addedWeight
				self.saveStorage()
				return true, "Taken weapon out of storage"
			else
				return false, "Not enough of selected weapon in storage"
			end
		else
			return false, "This weapon is not in storage"
		end
	end

	self.removeAmmo = function(name, count)
		if self.ammo[name].count >= count then
			self.ammo[name].count = self.ammo[name].count - count
			self.saveStorage()
			return true, "Taken ammo from trunk"
		else
			return false, "Not enough ammo in storage"
		end
	end

	self.addAmmo = function(name, count)
		self.ammo[name].count = self.ammo[name].count + count
		self.saveStorage()
		return true, "Added ammo to storage"
	end

	self.removeAccountMoney = function(name, count)
		if self.accounts[name] then
			if self.accounts[name] >= count then
				if self.accounts[name] == count then
					self.accounts[name] = nil
				else
					self.accounts[name] = self.accounts[name]-count
				end
				self.saveStorage()
				return true, "Money removed"
			else
				return false, "Not enough money in storage"
			end
		else
			return false, "No money of this type in storage"
		end
	end

	self.addAccountMoney = function(name, count)
		if self.accounts[name] then
			self.accounts[name] = self.accounts[name]+count
		else
			self.accounts[name] = count
		end
		self.saveStorage()
		return true, "Money added"
	end

	self.formatForSecondInventory = function()
		local items = {}
		local weapons = {}
		local money = {}
		local ammo = {}

		for k,v in pairs(self.items) do
			local label = ESX.GetItemLabel(k)

			if label then
				table.insert(items, {
					count = v,
					name = k,
					label = label
				})
			else
				print(('[rpuk_housing] [^3WARNING^7] ignoring invalid item "%s" in house id "%s"'):format(k, self.houseId))
			end
		end

		if next(self.weapons) ~= nil then
			for k,v in pairs(self.weapons) do
				local label = ""
				if v.components then
					label = "<b>"..ESX.GetWeaponLabel(v.name).."</b><br><i>"
					for key,val in pairs(v.components) do
						if key == #v.components then
							label = label .. ESX.GetWeaponComponent(v.name, val).short
						else
							label = label .. ESX.GetWeaponComponent(v.name, val).short .. " | "
						end
					end
					label = label.."</i>"
				else
					label = ESX.GetWeaponLabel(v.name)
				end
				table.insert(weapons, {
					label = label,
					count = v.count,
					name = v.name,
					data = {
						components = v.components
					}
				})
			end
		end

		if next(self.ammo) ~= nil then
			for k,v in pairs(self.ammo) do
				if v.count > 0 then
					table.insert(ammo, {
						label = v.label,
						count = v.count,
						name = k
					})
				end
			end
		end

		if next(self.accounts) then
			for k,v in pairs(self.accounts) do
				table.insert(money, {
					name = k,
					count = v,
					label = ESX.getAccountLabel(k)
				})
			end
		end

		return {
			id = self.houseId,
			text = "Storage",
			type = "rpuk_housing",
		}, money, items, weapons, ammo
	end

	self.addFurniture = function(prop, label, count)
		if self.boughtFurniture[prop] then
			self.boughtFurniture[prop].amount = self.boughtFurniture[prop].amount+count
		else
			self.boughtFurniture[prop] = {
				name = label,
				amount = count
			}
		end
		self.saveFurniture()
		return true, "Bought furniture"
	end

	self.removeFurniture = function(prop, count)
		if self.boughtFurniture[prop] then
			if self.boughtFurniture[prop].amount > count then
				self.boughtFurniture[prop].amount = self.boughtFurniture[prop].amount-1
			elseif self.boughtFurniture[prop].amount == count then
				self.boughtFurniture[prop] = nil
			else
				return false, "Not enough furniture in storage"
			end
			self.saveFurniture()
			return true, "Placed furniture"
		else
			return false, "Furniture is not in storage"
		end
	end

	self.placedFurniture = function(prop, coords, heading)
		local category = nil
		local label = nil
		for k,v in pairs(config.furniture) do
			for key,val in pairs(v) do
				if val[2] == prop then
					category = k
					label = val[1]
					break
				end
			end
			if category then
				break
			end
		end

		if prop == "prop_bucket_01a" then
			table.insert(self.furniture, {
				heading = heading,
				offset = {
					coords.x,
					coords.y,
					coords.z
				},
				object = prop,
				name = label,
				category = category,
				plantData = {
					seed = nil,
					soiled = nil,
					watered = nil,
					wateredTime = nil,
					wateredStage = nil,

				}
			})
		else
			table.insert(self.furniture, {
				heading = heading,
				offset = {
					coords.x,
					coords.y,
					coords.z
				},
				object = prop,
				name = label,
				category = category
			})
		end
		self.saveFurniture()
	end

	self.removeFurnished = function(id, propName)
		if self.boughtFurniture[propName] then
			self.boughtFurniture[propName].amount = self.boughtFurniture[propName].amount+1
		else
			local label = nil
			for _,v in pairs(config.furniture) do
				for _, val in pairs(v) do
					if val[2] == propName then
						label = val[1]
						break
					end
				end
				if label then
					break
				end
			end
			self.boughtFurniture[propName] = {
				name = label,
				amount = 1
			}
		end
		local tempList = {}
		for k,v in pairs(self.furniture) do
			if id ~= k then
				table.insert(tempList, v)
			end
		end
		self.furniture = tempList
		self.saveFurniture()
		return true, "Removed Furniture"
	end

	self.moveFurniture = function(id, offset, heading)
		self.furniture[id].offset = {
			offset.x,
			offset.y,
			offset.z
		}
		self.furniture[id].heading = heading
		self.saveFurniture()
		return true, "Moved furniture"
	end

	self.fetchFurniture = function()
		return self.furniture
	end

	self.updatePlantData = function(id, data, saveToDB)
		self.furniture[id].plantData = data
		if saveToDB then self.saveFurniture() end
		return true, "Data Updated"
	end

	self.getPlantData = function(id)
		if self.furniture[id] and self.furniture[id].plantData then
			return self.furniture[id].plantData
		elseif self.furniture[id] then
			self.startPlantData(id)
			return self.furniture[id].plantData
		else
			return false
		end
	end

	self.startPlantData = function(id)
		if self.furniture[id].plantData then
			return false
		else
			self.furniture[id].plantData = {
				seed = nil,
				soiled = nil,
				watered = nil,
				wateredTime = nil,
				wateredStage = nil,
			}
			self.saveFurniture()
			return true
		end
	end

	self.stopPlantData = function(id)
		self.furniture[id].plantData = nil
		self.saveFurniture()
		return true
	end

	self.sellHouse = function(rpukCharId)
		if self.owner == rpukCharId then
			MySQL.Sync.execute("DELETE FROM houses WHERE owner = @owner AND houseId = @houseId", {
				["@owner"] = self.owner,
				["@houseId"] = self.houseId
			})
			return true
		else
			return false, "You are not the owner of the house"
		end
	end

	return self
end

function hasSameComponents(objComponents, components)
	if #objComponents ~= #components then
		return false
	end
	local correct = 0
	for k,v in pairs(objComponents) do
		for key,val in pairs(components) do
			if v == val then
				correct = correct+1
			end
		end
	end
	if correct == #objComponents then
		return true
	else
		return false
	end
end