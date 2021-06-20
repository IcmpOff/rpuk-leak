RPUK_GANGS = {}
local updateGangQuery = -1
MySQL.Async.store("UPDATE gangs SET ? WHERE ? ", function(storedId) updateGangQuery = storedId end)
-- Stored query used for updating anything on the gangs table given a gang ID
-- Query can be called as following:
-- MySQL.Async.execute(updateUserQuery, {
-- -- {
-- -- [column] = value
-- -- [column2] = value2
-- -- },
-- -- {
-- -- ['id'] = gang ID
-- -- }
-- -- }, function(rowsChanged) end)

function createGang(data)
	local self = {}
	self.id = data.id
	self.name = data.name
	self.members = data.members
	self.ranks = data.ranks
	self.items = {}
	self.ammo = ESX.GetAmmo()
	self.weapons = {}
	self.accounts = {}
	self.maxWeight = 50000
	self.currentWeight = 0
	self.saving = false

	self.claimed = {
		["blueprint"] = data.claim_blueprint,
		["drugs"] = data.claim_drugs,
		["tips"] = data.claim_tips,
	}

	-- functions
	self.getName = function()
		return self.name
	end

	self.getClaimed = function(val)
		return self.claimed[val]
	end

	self.updateClaimed = function(val, val2)
		self.claimed[val] = val2
		self.saveSpecificData({
			['claim_blueprint'] = self.claimed["blueprint"],
			['claim_drugs'] = self.claimed["drugs"],
			['claim_tips']	= self.claimed["tips"],
		})
	end	

	self.getLeader = function() -- usage ``local leader_rpuk_charid = xGang.getLeader()``
		for k, v in pairs(self.members) do
			if v.rank == 1 then
				return k
			end
		end
	end

	self.getMembers = function()
		return self.members
	end

	self.getRanks = function()
		return self.ranks
	end

	self.getMemberFromId = function(rpuk_charid) -- usage ``local xGangMember = xGang.getMemberFromId(rpuk_charid) -- Returns a table of rank, charid, rank label, and rank permissions``
		for k, v in pairs(self.members) do
			if tonumber(k) == tonumber(rpuk_charid) then
				local rank_label, rank_permissions = "", ""
				if self.ranks[v.rank] then
					rank_label = self.ranks[v.rank].label
					rank_permissions = self.ranks[v.rank].permissions
				end
				return {rpuk_charid = k, rank = v.rank, rank_label = rank_label, rank_permissions = rank_permissions}
			end
		end
	end

	self.addMember = function(rpuk_charid) -- usage ``local success = xGang.addMember(rpuk_charid) -- Returns a if adding member was success``
		rpuk_charid = tonumber(rpuk_charid)
		local xTarget = ESX.GetPlayerFromCharId(rpuk_charid)
		if xTarget then
			local gang_id, gang_rank = xTarget.getGang()
			if gang_id == 0 then
				local lowest_rank = tablelength(self.ranks)
				self.members[xTarget.rpuk_charid] = {}
				self.members[xTarget.rpuk_charid].rank = lowest_rank
				self.members[xTarget.rpuk_charid].name = xTarget.firstname .. " " .. xTarget.lastname
				self.saveSpecificData({
					['gang_members'] = json.encode(self.members)
				})
				xTarget.setGang(self.id, lowest_rank)
				print("RPUK Gangs: Added " .. rpuk_charid .. " [Online]")
				return true
			else
				return false
			end
		else
			return false
		end
	end

	self.removeMember = function(rpuk_charid) -- usage ``local success = xGang.removeMember(rpuk_charid) -- Returns a if removing was a success``
		local rpuk_charid = tonumber(rpuk_charid)
		for k, v in pairs(self.members) do
			if tonumber(k) == rpuk_charid then
				self.members[k] = nil
				self.saveSpecificData({
					['gang_members'] = json.encode(self.members)
				})
				local xTarget = ESX.GetPlayerFromCharId(rpuk_charid)
				if xTarget then
					xTarget.setGang(0, 0)
					print("RPUK Gangs: Removed " .. rpuk_charid .. " [Online]")
				else
					MySQL.Async.execute("UPDATE users SET gang_data=@gang_data WHERE rpuk_charid=@rpuk_charid", {
						['@gang_data'] = '{"gang_id":0,"gang_rank":0}',
						['@rpuk_charid'] = rpuk_charid,
					})
					print("RPUK Gangs: Removed " .. rpuk_charid .. " [Offline]")
				end
				return true
			end
		end
		return false
	end

	self.changeMemberRank = function(rpuk_charid, rank)
		if not self.ranks[rank] then
			return false
		end
		local rpuk_charid = tonumber(rpuk_charid)
		for k, v in pairs(self.members) do
			if tonumber(k) == rpuk_charid then
				if self.ranks[rank].limit then
					local rank_limit = 0
					for _, mRank in pairs(self.members) do
						if mRank.rank == rank then
							rank_limit = rank_limit + 1
						end
					end
					if rank_limit < self.ranks[rank].limit then
						self.members[k].rank = tonumber(rank)
						self.saveSpecificData({
							['gang_members'] = json.encode(self.members)
						})
						local xTarget = ESX.GetPlayerFromCharId(rpuk_charid)
						if xTarget then
							xTarget.setGang(self.id, self.members[k].rank)
							print("RPUK Gangs: Promoted " .. rpuk_charid .. " [Online]" .. " to " .. self.members[k].rank)
						end
						return true
					else
						print("RPUK Gangs: Unable to promote " .. rpuk_charid .. " [Online]" .. " to " .. rank .. " (Limit reached for rank)")
						return false
					end
				else
					self.members[k].rank = tonumber(rank)
					self.saveSpecificData({
						['gang_members'] = json.encode(self.members)
					})
					local xTarget = ESX.GetPlayerFromCharId(rpuk_charid)
					if xTarget then
						xTarget.setGang(self.id, self.members[k].rank)
						print("RPUK Gangs: Promoted " .. rpuk_charid .. " [Online]" .. " to " .. self.members[k].rank)
					end
					return true
				end
			end
		end
		return false
	end

	self.hasPermission = function(rank, permission_string)
		rank, permission_string = tonumber(rank), tostring(permission_string)
		for index, permission in pairs(self.ranks[rank].permissions) do
			if tostring(permission) == permission_string then
				return true
			end
		end
		return false
	end

	self.changeName = function(new_name)
		local new_name = tostring(new_name)
		for k, v in pairs(RPUK_GANGS) do
			if v.name == new_name then
				return false
			end		
		end
		self.name = new_name
		self.self.saveSpecificData({
			['gang_name'] = self.name
		})()
		return true
	end

	self.changeRankLabel = function(rank, label)
		local new_name, rank = tostring(label), tonumber(rank)
		for k, v in pairs(self.ranks) do
			if k == rank then
				self.ranks[k].label = label
				self.saveSpecificData({
					['gang_ranks'] = json.encode(self.ranks)
				})
				return true
			end
		end
		return false
	end

	self.toggleRankPermission = function(rank, permission)
		local permission, rank = tostring(permission), tonumber(rank)
		local array_size = 0
		for k, v in pairs(self.ranks[rank].permissions) do
			array_size = array_size + 1
			if v == permission then
				self.ranks[rank].permissions[k] = nil
				self.saveSpecificData({
					['gang_ranks'] = json.encode(self.ranks)
				})
				return true
			end
		end
		print(permission)
		self.ranks[rank].permissions[array_size + 1] = permission
		self.saveSpecificData({
			['gang_ranks'] = json.encode(self.ranks)
		})
		return true
	end

	self.createRank = function(rank_label)
		local rank_label = tostring(rank_label)	
		table.insert(self.ranks, {label = rank_label, permissions = {}})
		self.saveSpecificData({
			['gang_ranks'] = json.encode(self.ranks)
		})
		return true
	end

	self.deleteRank = function(rank_id)
		local rank_id = tonumber(rank_id)	
		table.remove(self.ranks, rank_id)
		local new_index, new_ranks = 1, {}
		for k, v in pairs(self.ranks) do
			new_ranks[new_index] = {permissions = v.permissions, label = v.label}
			if v.limit then
				new_ranks[new_index].limit = v.limit
			end
			new_index = new_index + 1
		end
		self.saveSpecificData({
			['gang_ranks'] = json.encode(self.ranks)
		})
		return true
	end

	-- STORAGE
	local temp = json.decode(data.storage)
	if temp.items then
		self.items = temp.items
		for k,v in pairs(self.items) do
			if Config.localWeight[k] then
				self.currentWeight = (Config.localWeight[k]*v) + self.currentWeight
			else
				self.currentWeight = self.currentWeight + (Config.defaultWeight*v)
			end
		end
	end

	if temp.weapons then
		self.weapons = temp.weapons
		for k,v in pairs(self.weapons) do
			if Config.localWeight[v.name] then
				self.currentWeight = (Config.localWeight[v.name]*v.count) + self.currentWeight
			else
				self.currentWeight = self.currentWeight + (Config.defaultWeight*v.count)
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

	self.addItem = function(name, count)
		local addedWeight
		if Config.localWeight[name] then
			addedWeight = Config.localWeight[name]*count
		else
			addedWeight = Config.defaultWeight*count
		end
		if self.currentWeight+addedWeight <= self.maxWeight then
			if self.items[name] then
				self.items[name] = self.items[name]+count
			else
				self.items[name] = count
			end
			self.currentWeight = self.currentWeight+addedWeight
			self.saveSpecificData({
				['gang_safe'] = json.encode({
					items = self.minifyItems(self.items),
					weapons = self.minifyWeapons(self.weapons),
					accounts = self.minifyAccounts(self.accounts),
					ammo = self.minifyAmmo(self.ammo)
				}),
			})
			return true, "Added item to storage"
		else
			return false, "Storage is full"
		end
	end

	self.removeItem = function(name, count)
		if self.items[name] then
			if self.items[name] >= count then
				local addedWeight
				if Config.localWeight[name] then
					addedWeight = Config.localWeight[name]*count
				else
					addedWeight = Config.defaultWeight*count
				end
				if self.items[name] == count then
					self.items[name] = nil
				else
					self.items[name] = self.items[name]-count
				end
				self.currentWeight = self.currentWeight-addedWeight
				self.saveSpecificData({
					['gang_safe'] = json.encode({
						items = self.minifyItems(self.items),
						weapons = self.minifyWeapons(self.weapons),
						accounts = self.minifyAccounts(self.accounts),
						ammo = self.minifyAmmo(self.ammo)
					}),
				})
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
		if Config.localWeight[name] then
			addedWeight = Config.localWeight[name]*count
		else
			addedWeight = Config.defaultWeight*count
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
			self.saveSpecificData({
				['gang_safe'] = json.encode({
					items = self.minifyItems(self.items),
					weapons = self.minifyWeapons(self.weapons),
					accounts = self.minifyAccounts(self.accounts),
					ammo = self.minifyAmmo(self.ammo)
				}),
			})
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
				if Config.localWeight[name] then
					addedWeight = Config.localWeight[name]*count
				else
					addedWeight = Config.defaultWeight*count
				end
				if self.weapons[index].count == count then
					self.weapons[index] = nil
				else
					self.weapons[index].count = self.weapons[index].count-count
				end
				self.currentWeight = self.currentWeight-addedWeight
				self.saveSpecificData({
					['gang_safe'] = json.encode({
						items = self.minifyItems(self.items),
						weapons = self.minifyWeapons(self.weapons),
						accounts = self.minifyAccounts(self.accounts),
						ammo = self.minifyAmmo(self.ammo)
					}),
				})
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
			self.saveSpecificData({
				['gang_safe'] = json.encode({
					items = self.minifyItems(self.items),
					weapons = self.minifyWeapons(self.weapons),
					accounts = self.minifyAccounts(self.accounts),
					ammo = self.minifyAmmo(self.ammo)
				}),
			})
			return true, "Taken ammo from trunk"
		else
			return false, "Not enough ammo in trunk"
		end
	end

	self.addAmmo = function(name, count)
		self.ammo[name].count = self.ammo[name].count + count
		self.saveSpecificData({
			['gang_safe'] = json.encode({
				items = self.minifyItems(self.items),
				weapons = self.minifyWeapons(self.weapons),
				accounts = self.minifyAccounts(self.accounts),
				ammo = self.minifyAmmo(self.ammo)
			}),
		})
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
				self.saveSpecificData({
					['gang_safe'] = json.encode({
						items = self.minifyItems(self.items),
						weapons = self.minifyWeapons(self.weapons),
						accounts = self.minifyAccounts(self.accounts),
						ammo = self.minifyAmmo(self.ammo)
					}),
				})
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
		self.saveSpecificData({
			['gang_safe'] = json.encode({
				items = self.minifyItems(self.items),
				weapons = self.minifyWeapons(self.weapons),
				accounts = self.minifyAccounts(self.accounts),
				ammo = self.minifyAmmo(self.ammo)
			}),
		})
		return true, "Money added"
	end

	self.save = function()
		while self.saving do
			Citizen.Wait(100)
		end
		self.saving = true
		MySQL.Async.execute('UPDATE gangs SET gang_name=@gang_name, gang_members=@gang_members, gang_ranks=@gang_ranks, gang_safe=@gang_safe, claim_blueprint=@claim_blueprint, claim_drugs=@claim_drugs, claim_tips=@claim_tips WHERE id=@gang_id', {
			['@gang_id'] = self.id,
			['@gang_name'] = self.name,
			['@gang_members'] = json.encode(self.members),
			['@gang_ranks'] = json.encode(self.ranks),
			["@gang_safe"] = json.encode({
				items = self.minifyItems(self.items),
				weapons = self.minifyWeapons(self.weapons),
				accounts = self.minifyAccounts(self.accounts),
				ammo = self.minifyAmmo(self.ammo)
			}),
			['@claim_blueprint'] = self.claimed["blueprint"],
			['@claim_drugs'] = self.claimed["drugs"],
			['@claim_tips']	= self.claimed["tips"],
		})
		self.saving = false
	end

	self.saveSpecificData = function(updates)
		while self.saving do
			Citizen.Wait(100)
		end
		self.saving = true

		MySQL.Async.execute(updateGangQuery, {
			updates,
			{
			['id'] = self.id
			}
		})
		self.saving = false
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
			id = self.id,
			text = "Storage",
			type = "rpuk_gangs",
		}, money, items, weapons, ammo
	end

	print("Created RPUK Gang: " .. data.name .. " with ID: " .. data.id)
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