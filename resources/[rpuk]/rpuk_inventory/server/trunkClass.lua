function createTrunk(data)
	local self = {}

	self.plate = data.plate
	self.owned = data.owned
	self.owner = data.owner
	self.class = data.class
	self.maxWeight = Config.VehicleLimit[self.class]
	self.currentWeight = 0
	self.saving = false

	if self.owned then
		local temp = json.decode(data.data)
		self.items = {}
		if temp.black_money then
			self.dirtyMoney = temp.black_money[1].amount
		else
			self.dirtyMoney = 0
		end
		if temp.money then
			self.money = temp.money[1].amount
		else
			self.money = 0
		end
		self.weapons = {}
		self.ammo = ESX.deepCopy(Config.ammoTypes)

		if temp.coffre then
			for _,v in pairs(temp.coffre) do
				self.items[v.name] = v.count
				if Config.localWeight[v.name] then
					self.currentWeight = self.currentWeight+Config.localWeight[v.name]*v.count
				else
					self.currentWeight = self.currentWeight+Config.defaultWeight*v.count
				end
			end
		end

		if temp.ammo then
			for _,v in pairs(temp.ammo) do
				self.ammo[v.name].count = v.count
			end
		end

		if temp.weapons then
			local ammoLoaded = false
			local tempWeapons = {}
			for _,v in pairs(temp.weapons) do
				if v.ammo then
					if tempWeapons[v.name] then
						tempWeapons[v.name].count = tempWeapons[v.name].count+1
					else
						tempWeapons[v.name] = {
							count = 1,
						}
					end
					if self.currentWeight then
						self.currentWeight = self.currentWeight + Config.localWeight[v.name]
					else
						self.currentWeight = self.currentWeight + Config.defaultWeight
					end
					local ammoType = Config.ammo[v.name]
					self.ammo[ammoType].count = self.ammo[ammoType].count+v.ammo
				else
					ammoLoaded = true
					table.insert(self.weapons, {
						name = v.name,
						count = v.count,
						components = v.components
					})
				end
			end
			if not ammoLoaded then
				for _,v in pairs(tempWeapons) do
					table.insert(self.weapons, {
						name = v.name,
						count = v.count
					})
				end
			end
		end
	else
		self.items = {}
		self.dirtyMoney = 0
		self.money = 0
		self.weapons = {}
		self.ammo = ESX.deepCopy(Config.ammoTypes)
	end

	self.canFit = function(item, count)
		if Config.localWeight[name] then
			return self.currentWeight + Config.localWeight[name]*count <= self.maxWeight
		else
			return self.currentWeight + Config.defaultWeight*count <= self.maxWeight
		end
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

	self.formatForSecondInventory = function()
		local items = {}
		local weapons = {}
		local accounts = {}
		local ammo = {}

		for k,v in pairs(self.items) do
			table.insert(items, {
				count = v,
				name = k,
				label = ESX.GetItemLabel(k)
			})
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
						components = v.components,
						index = k
					}
				})
			end
		end

		if next(self.ammo) then
			for k,v in pairs(self.ammo) do
				table.insert(ammo, {
					label = Config.ammoTypes[k].label,
					count = v.count,
					name = k
				})
			end
		end

		if self.dirtyMoney then
			if self.dirtyMoney > 0 then
				table.insert(accounts, {
					count = self.dirtyMoney,
					name = "black_money",
					label = "Dirty money"
				})
			end
		end

		if self.money then
			if self.money > 0 then
				table.insert(accounts, {
					count = self.money,
					name = "money",
					label = "Cash"
				})
			end
		end

		return {
			id = self.plate,
			text = ('%s / %s'):format(self.currentWeight, self.maxWeight),
			type = "rpuk_trunk",
		}, accounts, items, weapons, ammo
	end

	self.addItem = function(item, count)
		if self.canFit(item, count) then
			if self.items[item] then
				self.items[item] = self.items[item]+count
			else
				self.items[item] = count
			end
			if Config.localWeight[name] then
				self.currentWeight = self.currentWeight + Config.localWeight[name]*count
			else
				self.currentWeight = self.currentWeight + Config.defaultWeight*count
			end
			if self.owned then
				self.save()
			end
			return true, "Item stored"
		else
			return false, "Item can not fit on the trunk"
		end
	end

	self.removeItem = function(item, count)
		if self.items[item] then
			if self.items[item] >= count then
				if self.items[item] == count then
					self.items[item] = nil
				else
					self.items[item] = self.items[item] - count
				end
				if Config.localWeight[name] then
					self.currentWeight = self.currentWeight - Config.localWeight[name]*count
				else
					self.currentWeight = self.currentWeight- Config.defaultWeight*count
				end
				
				if self.owned then
					self.save()
				end
				return true, "Item taken out of trunk"
			else
				return false, "Not enough of selected item in trunk"
			end
		else
			return false, "Item does not exist in trunk"
		end
	end

	self.addWeapon = function(weapon, count, components)
		if components then
			if next(components) == nil then
				components = nil
			end
		end
		if self.canFit(weapon, count) then
			local index = self.getWeaponIndex(weapon, components)
			if index == nil then
				table.insert(self.weapons, {
					name = weapon,
					count = count,
					components = components
				})
			else
				self.weapons[index].count = self.weapons[index].count+count
			end
			if self.owned then
				self.save()
			end
			return true, "Added weapon to trunk"
		else
			return false, "Weapon does not fit"
		end
	end

	self.removeWeapon = function(weaponName, count, components)
		local index = self.getWeaponIndex(weaponName, components)
		if self.weapons[index] then
			if self.weapons[index].count >= count then
				if self.weapons[index].name == weaponName then
					if self.weapons[index].count == count then
						local temp = {}
						for k,v in pairs(self.weapons) do
							if k ~= index then
								table.insert(temp, v)
							end
						end
						self.weapons = temp
					else
						self.weapons[index].count = self.weapons[index].count-count
					end
					if self.owned then
						self.save()
					end
					return true, "Pulled weapon out of trunk"
				else
					return false, "Weapon is not in trunk"
				end
			else
				return false, "Not enough of weapon in trunk"
			end
		else
			return false, "Weapon is not in trunk"
		end
	end

	self.addAmmo = function(name, count)
		self.ammo[name].count = self.ammo[name].count+count
		if self.owned then
			self.save()
		end
		return true, "Added ammo to trunk"
	end

	self.removeAmmo = function(name, count) 
		if self.ammo[name].count >= count then
			self.ammo[name].count = self.ammo[name].count - count
			if self.owned then
				self.save()
			end
			return true, "Taken ammo out of trunk"
		else
			return false, "Not enough ammo in trunk"
		end
	end

	self.addBlackMoney = function(count)
		self.dirtyMoney = self.dirtyMoney+count
		if self.owned then
			self.save()
		end
		return true, "Added dirty money to trunk"
	end

	self.removeBlackMoney = function(count)
		if self.dirtyMoney >= count then
			self.dirtyMoney = self.dirtyMoney-count
			if self.owned then
				self.save()
			end
			return true, "Removed dirty money from trunk"
		else
			return false, "Not enough dirty money in trunk"
		end
	end

	self.addMoney = function(count)
		self.money = self.money+count
		if self.owned then
			self.save()
		end
		return true, "Added cash to trunk"
	end

	self.removeMoney = function(count)
		if self.money >= count then
			self.money = self.money-count
			if self.owned then
				self.save()
			end
			return true, "Removed cash from trunk"
		else
			return false, "Not enough cash in trunk"
		end
	end

	self.minifyItems = function()
		if next(self.items) == nil then
			return
		end
		local temp = {}
		for k,v in pairs(self.items) do
			table.insert(temp, {
				name = k,
				count = v
			})
		end
		return temp
	end

	self.minifyWeapons = function()
		if next(self.weapons) == nil then
			return
		end
		local temp = {}
		for k,v in pairs(self.weapons) do
			table.insert(temp, {
				name = v.name,
				count = v.count,
				components = v.components
			})
		end
		return temp
	end

	self.minifyAmmo = function()
		local temp = {}
		for k,v in pairs(self.ammo) do
			if v.count > 0 then
				table.insert(temp, {
					name = k,
					count = v.count
				})
			end
		end
		if temp[1] then
			return temp
		end
	end

	self.save = function()
		while self.saving do
			Citizen.Wait(100)
		end
		self.saving = true
		MySQL.Sync.execute("UPDATE trunk_inventory SET data = @data WHERE plate = @plate", {
			["@data"] = json.encode({
				coffre = self.minifyItems(),
				ammo = self.minifyAmmo(),
				weapons = self.minifyWeapons(),
				black_money = ternary(self.dirtyMoney > 0, {{amount = self.dirtyMoney}}, nil),
				money = ternary(self.money > 0, {{amount = self.money}}, nil)
			}),
			["@plate"] = self.plate
		})
		self.saving = false
	end

	return self
end

function ternary(cond, t, f)
	if cond then return t else return f end
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