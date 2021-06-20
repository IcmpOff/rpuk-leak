function createStorage(data)
    local self = {}

	self.id = data.id
	self.saving = false
    self.config = config.lockers[data.id]
    self.items = {}
    self.weapons = {}
    self.ammo = ESX.deepCopy(config.ammoTypes)
	self.money = {}
	self.accounts = {black_money = 0, money = 0}

	if data.items.weapons then
		self.weapons = data.items.weapons
	end

	if data.items.items then
		self.items = data.items.items
	end

	if data.items.ammo then
		for k,v in pairs(data.items.ammo) do
			self.ammo[v.name].count = v.count
		end
	end

	if data.items.accounts then
		for k,v in pairs(data.items.accounts) do
			self.accounts[k] = v
		end
	end

	self.formatAmmo = function()
		local temp = {}
		for k,v in pairs(self.ammo) do
			if v.count > 0 then
				table.insert(temp, {
					name = k,
					count = v.count
				})
			end
		end
		if next(temp) then
			return temp
		else
			return nil
		end
	end

	self.formatWeapons = function()
		if next(self.weapons) then
			return self.weapons
		else
			return nil
		end
	end

	self.formatAccounts = function()
		local temp = {}
		for k,v in pairs(self.accounts) do
			if v > 0 then
				temp[k] = v
			end
		end
		if next(temp) then
			return temp
		else
			return nil
		end
	end

	self.formatItems = function()
		if next(self.items) then
			return self.items
		else
			return nil
		end
	end

	self.formatForSecondInventory = function(positionId)
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

		for k,v in pairs(self.weapons) do
			table.insert(weapons, {
				label = ESX.GetWeaponLabel(k),
				count = v,
				name = k,
			})
		end

		for k,v in pairs(self.ammo) do
			if v.count > 0 then
				table.insert(ammo, {
					label = config.ammoTypes[k].label,
					count = v.count,
					name = k
				})
			end
		end

		for k,v in pairs(self.accounts) do
			local label = ""
			if k == "black_money" then
				label = "Dirty money"
			elseif k == "money" then
				label = "Cash"
			end
			table.insert(accounts, {
				label = label,
				count = v,
				name = k
			})
		end

		return {
			positionId = positionId,
			id = self.id,
			text = "Locker",
			type = "rpuk_evidencelocker",
		}, accounts, items, weapons, ammo
	end

	self.canDeposit = function(job, position)
		if self.config.access then
			if self.config.access.deposit[job.name] then
				if self.config.access.deposit[job.name] > job.grade then
					return false, "You dont have the required rank to deposit"
				end
			else
				return false, "You dont have the job required to deposit"
			end
		else
			return true
		end
		if self.config.positions[position].canDeposit then
			return true
		else
			return false, "You cant deposit from this location"
		end
	end

	self.canWithdraw = function(job, position)
		if self.config.access then
			if self.config.access.withdraw[job.name] then
				if self.config.access.withdraw[job.name] > job.grade then
					return false, "You dont have the required rank to withdraw"
				end
			else
				return false, "You dont have the job required to withdraw"
			end
		else
			return true
		end
		if self.config.positions[position].canWithdraw then
			return true
		else
			return false, "You cant withdraw from this"
		end
	end

	self.addItem = function(item, count)
		if self.items[item] then
			self.items[item] = self.items[item]+count
		else
			self.items[item] = count
		end
		self.save()
		return true, "Added item to storage"
	end

	self.removeItem = function(item, count)
		if self.items[item] then
			if self.items[item] >= count then
				if self.items[item] == count then
					self.items[item] = nil
				else
					self.items[item] = self.items[item] - count
				end
				self.save()
				return true, "Withdrawn item"
			else
				return false, "Not this many of the item in storage"
			end
		else
			return false, "Item does not exist in storage"
		end
	end

	self.addWeapon = function(weapon, count)
		if self.weapons[weapon] then
			self.weapons[weapon] = self.weapons[weapon]+count
		else
			self.weapons[weapon] = count
		end
		self.save()
		return true, "Added weapon to storage"
	end
	
	self.removeWeapon = function(weapon, count)
		if self.weapons[weapon] then
			if self.weapons[weapon] >= count then
				if self.weapons[weapon] == count then
					self.weapons[weapon] = nil
				else
					self.weapons[weapon] = self.weapons[weapon]-count
				end
				self.save()
				return true, "Withdrawn weapon from storage"
			else
				return false, "Not this many of selected weapon in storage"
			end
		else
			return false, "Weapon does not exist in storage"
		end
	end

	self.addAccountMoney = function(account, count)
		self.accounts[account] = self.accounts[account]+count
		self.save()
		return true, "Added money to storage"
	end

	self.removeAccountMoney = function(account, count)
		if self.accounts[account] >= count then
			self.accounts[account] = self.accounts[account]-count
			self.save()
			return true, "Taken money out of storage"
		else
			return false, "Not enogh of selected money in storage"
		end
	end

	self.addAmmo = function(type, count)
		self.ammo[type].count = self.ammo[type].count+count
		self.save()
		return true, "Added ammo to storage"
	end

	self.removeAmmo = function(type, count)
		if self.ammo[type].count >= count then
			self.ammo[type].count = self.ammo[type].count-count
			self.save()
			return true, "Removed ammo from storage"
		else
			return false, "Not enough of selected ammo in storage"
		end
	end

	self.save = function()
		while self.saving do
			Citizen.Wait(100)
		end			
		self.saving = true
		MySQL.Sync.execute("UPDATE evidencelocker SET data = @data WHERE name = @name", {
			["@data"] = json.encode({
				items = self.formatItems(),
				weapons = self.formatWeapons(),
				ammo = self.formatAmmo(),
				accounts = self.formatAccounts()
			}),
			["@name"] = self.id
		})
		self.saving = false
	end

    return self
end