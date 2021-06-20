function createPickup(data, first)
	local self = {}

	self.items = {}
	self.ammo = ESX.GetAmmo()
	self.weapons = {}
	self.accounts = {}
	self.saving = false
	self.pos = data.pos
	self.id = data.id

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

	self.addItem = function(name, count)
		if self.items[name] then
			self.items[name] = self.items[name] + count
		else
			self.items[name] = count
		end
		self.save()
		return true, "Thrown item on ground"
	end

	self.removeItem = function(name, count)
		if self.items[name] then
			if self.items[name] >= count then
				if self.items[name] == count then
					self.items[name] = nil
				else
					self.items[name] = self.items[name]-count
				end
				self.save()
				return true, "Picked up item"
			else
				return false, "Not enough of item on the ground"
			end
		else
			return false, "Item not on the ground"
		end
	end

	self.addWeapon = function(name, count, components)
		local index = self.getWeaponIndex(name, components)
		if index then
			self.weapons[index].count = self.weapons[index].count+count
		else
			table.insert(self.weapons, {
				name = name,
				count = count,
				components = components
			})
		end
		self.save()
		return true, "Thrown weapon on the ground"
	end

	self.removeWeapon = function(name, count, components)
		local index = self.getWeaponIndex(name, components)
		if index then
			if self.weapons[index].count == count then
				self.weapons[index] = nil
			else
				self.weapons[index].count = self.weapons[index].count-count
			end
			self.save()
			return true, "Picked up weapon"
		else
			return false, "Weapon is not on the ground"
		end
	end

	self.addAmmo = function(name, count)
		self.ammo[name].count = self.ammo[name].count+count
		self.save()
		return true, "Thrown ammo on the ground"
	end

	self.removeAmmo = function(name, count)
		if self.ammo[name].count >= count then
			self.ammo[name].count = self.ammo[name].count-count
			self.save()
			return true, "Picked up ammo"
		else
			return false, "Not enough ammo on the ground"
		end
	end

	self.addAccountMoney = function(name, count)
		if self.accounts[name] then
			self.accounts[name] = self.accounts[name]+count
		else
			self.accounts[name] = count
		end
		self.save()
		return true, "Dropped money"
	end

	self.removeAccountMoney = function(name, count)
		if self.accounts[name] then
			if self.accounts[name] >= count then
				if self.accounts[name] == count then
					self.accounts[name] = nil
				else
					self.accounts[name] = self.accounts[name]-count
				end
				self.save()
				return true, "Picked up money"
			else
				return false, "Not enough money on the ground"
			end
		else
			return false, "No money of this type on the ground"
		end
	end

	self.formatForSecondInventory = function()
		local items = {}
		local weapons = {}
		local money = {}
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
						components = v.components
					}
				})
			end
		end

		if next(self.ammo) then
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
			id = self.id,
			text = "Pickup",
			type = "rpuk_inventory:pickup",
		}, money, items, weapons, ammo
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
		if not next(temp) then
			return
		end
		return temp
	end

	self.isEmpty = function()
		if next(self.items) then
			return false
		elseif next(self.weapons) then
			return false
		elseif next(self.accounts) then
			return false
		end
		for k,v in pairs(self.ammo) do
			if v.count > 0 then
				return false
			end
		end
		return true
	end

	self.save = function()
		if self.isEmpty() then
			self.delete()
			return
		end
	end

	self.delete = function()
		TriggerClientEvent("rpuk_inventory:deletePickup", -1, self.id)
		deletePickup(self.id)
	end

	return self
end

function deletePickup(id)
	pickups[id] = nil
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