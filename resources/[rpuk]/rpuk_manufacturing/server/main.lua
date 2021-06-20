config.skillData = ESX.GetSkill()
local currentCallers = {}

RegisterNetEvent("rpuk_manufacturing:openManufacturing")
RegisterNetEvent("rpuk_manufacturing:doneManufacturing")
RegisterNetEvent("rpuk_manufacturing:custom")

function print(val)
	TriggerEvent("rpuk:debug", val)
end

--[[
	example:
	TriggerServerEvent("rpuk_manufacturing:custom", {
		recipes = {
			"coal_coke",
			"copper_ingot",
			"iron",
			"silver_ingot",
			"titanium_ingot",
			"aluminium_ingot",
			"gold",
			"steel_ingot",
			"lead_ingot"
		}
	})
]]

AddEventHandler("rpuk_manufacturing:custom", function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local tempItems = xPlayer.getInventory()
	local ammo = xPlayer.getAmmo()
	local loadout = xPlayer.getLoadout()
	local canCraft = {
		weapons = {},
		ammo = {},
		items = {}
	}
	local skillData = json.decode(xPlayer.progressdata)
	local items = {}

	for _,v in pairs(tempItems) do
		items[v.name] = v
	end

	for _,v in pairs(data.recipes) do
		local recipe = config.recipes[v]
		local canCraftItem = true
		for key, val in pairs(recipe.itemsRequired) do
			if val.type == "item_standard" then
				if items[key].count < val.count then
					canCraftItem = false
					break
				end
			elseif val.type == "item_ammo" then
				if ammo[key].count < val.count then
					canCraftItem = false
					break
				end
			elseif val.type == "item_weapon" then
				if not loadout[key] then
					canCraftItem = false
					break
				end
			end
		end

		if canCraftItem then
			if recipe.secondInventory.type == "item_standard" then
				table.insert(canCraft.items, {
					name = recipe.secondInventory.name,
					count = 1,
					label = ESX.GetItemLabel(recipe.secondInventory.name),
					data = v
				})
			elseif recipe.secondInventory.type == "item_weapon" then
				table.insert(canCraft.weapons, {
					name = recipe.secondInventory.name,
					count = 1,
					label = ESX.GetWeaponLabel(recipe.secondInventory.name),
					data = v
				})
			elseif recipe.secondInventory.type == "item_ammo" then
				table.insert(canCraft.ammo, {
					name = recipe.secondInventory.name,
					count = 1,
					label = ammo[recipe.secondInventory.name].label,
					data = v
				})
			end
		end
	end

	TriggerClientEvent("rpuk_inventory:openSecondaryInventory", _source, {
		id = id,
		text = "",
		type = "rpuk_manufacturing",
		interaction = interaction,
	}, nil, canCraft.items, canCraft.weapons, canCraft.ammo)
end)

AddEventHandler("rpuk_manufacturing:openManufacturing", function(id, interaction)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local tempItems = xPlayer.getInventory()
	local ammo = xPlayer.getAmmo()
	local loadout = xPlayer.getLoadout()
	local canCraft = {
		weapons = {},
		ammo = {},
		items = {}
	}
	local skillData = json.decode(xPlayer.progressdata)
	local data = config.locations[id]
	local items = {}

	for _,v in pairs(tempItems) do
		items[v.name] = v
	end

	for _,v in pairs(data.recipes) do
		local recipe = config.recipes[v]
		local canCraftItem = true
		for key, val in pairs(recipe.itemsRequired) do

			if val.type == "item_standard" then
				if items[key] == nil then
					print("RPUK_MANUFACTURING: ERROR WITH CRAFTING | KEY VALUE "..key.. "| - ARCHIE")
				end
				if items[key].count < val.count then
					canCraftItem = false
					break
				end
			elseif val.type == "item_ammo" then
				if ammo[key].count < val.count then
					canCraftItem = false
					break
				end
			elseif val.type == "item_weapon" then
				if not loadout[key] then
					canCraftItem = false
					break
				end
			end
		end

		if canCraftItem then
			if recipe.secondInventory.type == "item_standard" then
				table.insert(canCraft.items, {
					name = recipe.secondInventory.name,
					count = 1,
					label = ESX.GetItemLabel(recipe.secondInventory.name),
					data = v
				})
			elseif recipe.secondInventory.type == "item_weapon" then
				table.insert(canCraft.weapons, {
					name = recipe.secondInventory.name,
					count = 1,
					label = ESX.GetWeaponLabel(recipe.secondInventory.name),
					data = v
				})
			elseif recipe.secondInventory.type == "item_ammo" then
				table.insert(canCraft.ammo, {
					name = recipe.secondInventory.name,
					count = 1,
					label = ammo[recipe.secondInventory.name].label,
					data = v
				})
			end
		end
	end

	TriggerClientEvent("rpuk_inventory:openSecondaryInventory", _source, {
		id = id,
		text = data.shopName,
		type = "rpuk_manufacturing",
		interaction = interaction,
	}, nil, canCraft.items, canCraft.weapons, canCraft.ammo)
end)

ESX.RegisterServerCallback('rpuk_manufacturing:getItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local cbResult, hasItemsRequired = false, true

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		local ammo = xPlayer.getAmmo()
		local loadout = xPlayer.getLoadout()
		local items = {}
		local itemToCraft = config.recipes[itemData.item.data]
		local skillData = json.decode(xPlayer.progressdata)
		local formattedForWeight = {{},{}}

		for _,v in pairs(xPlayer.getInventory()) do
			items[v.name] = v
		end

		for k,v in pairs(itemToCraft.itemsReturned) do
			if v.type == "item_standard" then
				table.insert(formattedForWeight[2], {
					name = k,
					count = v.count*amount
				})
			elseif v.type == "item_weapon" then
				amount = 1

				if loadout[k] then
					xPlayer.showNotification('You already have this weapon on you', 2500, 'error', 'longnotif')
					hasItemsRequired = false
				end
			elseif v.type == "item_ammo" then
				local maxAmount = math.floor(ammo[k].max/ammo[k].count)

				if amount > maxAmount then
					amount = maxAmount
				end
			end
		end

		if hasItemsRequired then
			local time = itemToCraft.time * amount
			local itemsMissing = {}

			for key, val in pairs(itemToCraft.itemsRequired) do
				local count = val.count*amount

				if val.type == "item_standard" then
					if items[key].count < count then
						table.insert(itemsMissing, {
							label = ESX.GetItemLabel(key),
							count = count-items[key].count
						})
					end

					table.insert(formattedForWeight[1], {
						name = key,
						count = count
					})
				elseif val.type == "item_ammo" then
					if ammo[key].count < count then
						table.insert(itemsMissing, {
							label = ammo[key].label,
							count = count-ammo[key].count
						})
					end
				elseif val.type == "item_weapon" then
					if count > 1 then
						if not loadout[key] then
							table.insert(itemsMissing, {
								label = ESX.GetWeaponLabel(key),
								count = count
							})
						else
							table.insert(itemsMissing, {
								label = ESX.GetWeaponLabel(key),
								count = count-1
							})
						end
					else
						if not loadout[key] then
							table.insert(itemsMissing, {
								label = ESX.GetWeaponLabel(key),
								count = 1
							})
						end
					end
				end
			end

			if #itemsMissing == 0 then
				local skillsMissing = {}

				if itemToCraft.skill then
					if itemToCraft.skill.required then
						for k,v in pairs(itemToCraft.skill.required) do
							if skillData[v.name] then
								if skillData[v.name] < v.requiredLevel then
									table.insert(skillsMissing, {
										name = v.name,
										missing = v.requiredLevel,
										current = skillData[v.name]
									})
								end
							else
								xPlayer.setStatData(v.name, 0)

								if v.requiredLevel > 0 then
									table.insert(skillsMissing, {
										name = v.name,
										missing = v.requiredLevel,
										current = 0
									})
								end
							end
						end
					end
				end

				if #skillsMissing == 0 then
					if itemToCraft.skill then
						if skillData[itemToCraft.skill.name] then
							if skillData[itemToCraft.skill.name] ~= 0 then
								time = time-(time*itemToCraft.skill.speedIncreaseSkill/config.skillData[itemToCraft.skill.name].max*skillData[itemToCraft.skill.name])
							end
						end
					end

					if xPlayer.canSwapItems(formattedForWeight[2], formattedForWeight[1]) then
						xPlayer.triggerEvent("rpuk_manufacturing:manufactureItem", itemToCraft, itemData.item.data, amount, time)
						cbResult = true
					else
						xPlayer.showNotification('Recieved items too heavy', 2500, 'inform', 'longnotif')
					end
				else
					local text = "Missing skills: <br>"

					for k,v in pairs(skillsMissing) do
						text = text..v.current.."/"..v.missing.." "..config.skillData[v.name].label
					end

					xPlayer.showNotification(text, 2500, 'inform', 'longnotif')
				end
			else
				local label = "Missing items: <br>"

				for k,v in pairs(itemsMissing) do
					if k == #itemsMissing then
						label = label..v.count.." "..v.label
					else
						label = label..v.count.." "..v.label.."<br>"
					end
				end

				xPlayer.showNotification(label, 2500, 'inform', 'longnotif')
			end
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)

AddEventHandler("rpuk_manufacturing:doneManufacturing", function(name, amount, type)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local tempItems = xPlayer.getInventory()
	local ammo = xPlayer.getAmmo()
	local loadout = xPlayer.getLoadout()
	local items = {}
	local itemToCraft = config.recipes[name]
	local skillData = json.decode(xPlayer.progressdata)
	local formattedForWeight = {{},{}}

	for _,v in pairs(tempItems) do
		items[v.name] = v
	end

	for k,v in pairs(itemToCraft.itemsReturned) do
		if v.type == "item_standard" then
			table.insert(formattedForWeight[2], {
				name = k,
				count = v.count*amount
			})
		elseif v.type == "item_weapon" then
			amount = 1
			if loadout[k] then
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "You already have this weapon"})
				return
			end
		elseif v.type == "item_ammo" then
			local maxAmount = math.floor(ammo[k].max/ammo[k].count)
			if amount > maxAmount then
				amount = maxAmount
			end
		end
	end

	local itemsMissing = {}
	for key, val in pairs(itemToCraft.itemsRequired) do
		local count = val.count*amount
		if val.type == "item_standard" then
			if items[key].count < count then
				table.insert(itemsMissing, {
					label = ESX.GetItemLabel(key),
					count = count-items[key].count
				})
			end
			table.insert(formattedForWeight[1], {
				name = key,
				count = count
			})
		elseif val.type == "item_ammo" then
			if ammo[key].count < count then
				table.insert(itemsMissing, {
					label = ammo[key].label,
					count = count-ammo[key].count
				})
			end
		elseif val.type == "item_weapon" then
			if count > 1 then
				if not loadout[key] then
					table.insert(itemsMissing, {
						label = ESX.GetWeaponLabel(key),
						count = count
					})
				else
					table.insert(itemsMissing, {
						label = ESX.GetWeaponLabel(key),
						count = count-1
					})
				end
			else
				if not loadout[key] then
					table.insert(itemsMissing, {
						label = ESX.GetWeaponLabel(key),
						count = 1
					})
				end
			end
		end
	end

	if next(itemsMissing) then
		local label = "Missing items: <br>"
		for k,v in pairs(itemsMissing) do
			if k == #itemsMissing then
				label = label..v.count.." "..v.label
			else
				label = label..v.count.." "..v.label.."<br>"
			end
		end
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = label})
		return
	end

	local skillsMissing = {}
	if itemToCraft.skill then
		if itemToCraft.skill.required then
			for _,v in pairs(itemToCraft.skill.required) do
				if skillData[v.name] then
					if skillData[v.name] < v.requiredLevel then
						table.insert(skillsMissing, {
							name = v.name,
							missing = v.requiredLevel,
							current = skillData[v.name]
						})
					end
				else
					if v.requiredLevel > 0 then
						table.insert(skillsMissing, {
							name = v.name,
							missing = v.requiredLevel,
							current = skillData[v.name]
						})
					end
				end
			end
		end
	end

	if next(skillsMissing) then
		local text = "Missing skills: <br>"
		for _,v in pairs(skillsMissing) do
			text = text..v.current.."/"..v.missing.." "..config.skillData[v.name].label
		end
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = text})
		return
	end

	if not xPlayer.canSwapItems(formattedForWeight[2], formattedForWeight[1]) then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "Recieved items too heavy"})
		return
	end

	if itemToCraft.skill then

		if itemToCraft.skill.decrease then
			for _,v in pairs(itemToCraft.skill.decrease) do
				local _skillData = config.skillData[v.name]
				if skillData[v.name] and skillData[v.name] ~= 0 then
					if skillData[v.name]-v.decrease < 0 then
						xPlayer.setStatData(v.name, 0)
						TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 2500, type = 'inform', text = 'Decreased '.._skillData.label..' to 0'})
					else
						xPlayer.decreaseStat(v.name, v.decrease*amount)
						skillData[v.name] = skillData[v.name] - v.decrease*amount
						TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 2500, type = 'inform', text = 'Decreased '.._skillData.label..' to '..skillData[v.name]-(v.decrease*amount)})
					end
				end
			end
		end

		if itemToCraft.skill.increase then
			for _,v in pairs(itemToCraft.skill.increase) do
				TriggerEvent('rpuk:debug', v.name)
				local _skillData = config.skillData[v.name]
				if skillData[v.name] then
					if skillData[v.name] ~= _skillData.max then
						if skillData[v.name] == _skillData.max then
							TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, action = 'longnotif', type = 'inform', text = "Already max ".._skillData.label.." skill" })
						elseif skillData[v.name]+v.increase*amount > _skillData.max then
							xPlayer.setStatData(v.name, _skillData.max)
							TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 2500, type = 'inform', text = 'Max skill of '.._skillData.max .. " reached for " .. _skillData.label })
						else
							xPlayer.increaseStat(v.name, v.increase*amount)
							TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 2500, type = 'inform', text = 'New '.._skillData.label..' skill level '..skillData[v.name]+(v.increase*amount)})
						end
					end
				else
					xPlayer.setStatData(v.name, v.increase*amount)
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 2500, type = 'inform', text = 'New '.._skillData.label..' skill level '..v.increase*amount})
				end
			end
		end


	end

	for k,v in pairs(itemToCraft.itemsRequired) do
		if v.type == "item_standard" then
			if v.remove then
				xPlayer.removeInventoryItem(k, v.count*amount)
			end
		elseif v.type == "item_weapon" then
			if v.remove then
				xPlayer.removeWeapon(k)
			end
		elseif v.type == "item_ammo" then
			if v.remove then
				xPlayer.removeWeaponAmmo(k, v.count*amount)
			end
		end
	end

	for k,v in pairs(itemToCraft.itemsReturned) do
		if v.type == "item_standard" then
			xPlayer.addInventoryItem(k, v.count*amount)
		elseif v.type == "item_weapon" then
			xPlayer.addWeapon(k)
		elseif v.type == "item_ammo" then
			xPlayer.addWeaponAmmo(k, v.count*amount)
		end
	end
end)