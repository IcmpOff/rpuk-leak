local currentCallers = {}

RegisterNetEvent("rpuk_prison:openCollectionPoint")
AddEventHandler("rpuk_prison:openCollectionPoint", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local data = MySQL.Sync.fetchAll("SELECT * FROM prison_sentences WHERE `rpuk_charid` = @charID", {["@charID"] = xPlayer.rpuk_charid})
	local items = {}
	local weapons = {}
	local ammo = {}

	for k,v in pairs(data) do
		local temp = json.decode(v.collection)
		if next(temp) then
			if temp.items then
				for key,val in pairs(temp.items) do
					table.insert(items, {
						name = key,
						count = val,
						label = ESX.GetItemLabel(key),
						data = v.id
					})
				end
			end
			if temp.weapons then
				for key,val in pairs(temp.weapons) do
					table.insert(weapons, {
						name = key,
						count = 1,
						label = ESX.GetWeaponLabel(key),
						data = v.id
					})
				end
			end
			if temp.ammo then
				for key,val in pairs(temp.ammo) do
					table.insert(ammo, {
						name = key,
						count = val,
						label = ESX.GetAmmoLabel(key),
						data = v.id
					})
				end
			end
		end
	end

	TriggerClientEvent("rpuk_inventory:openSecondaryInventory", _source, {
		type = "rpuk_prison"
	}, {}, items, weapons, ammo)
end)

ESX.RegisterServerCallback('rpuk_prison:getItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		local result = json.decode(MySQL.Sync.fetchAll("SELECT * FROM prison_sentences WHERE id = @id", {
			["@id"] = itemData.item.data
		})[1].collection)

		if type == "item_standard" then
			if result.items then
				if result.items[name] then
					if result.items[name] >= amount then
						if xPlayer.canCarryItem(name, amount) then
							xPlayer.addInventoryItem(name, amount)
							result.items[name] = result.items[name]-amount
							cbResult = true

							if result.items[name] == 0 then
								result.items[name] = nil
							end
						else
							xPlayer.showNotification('You do not have enough room in your inventory', 2500, 'error', 'longnotif')
						end
					end
				end
			else
				xPlayer.showNotification('You do not have this item type', 2500, 'error', 'longnotif')
			end
		elseif type == "item_ammo" then
			if result.ammo then
				if result.ammo[name] then
					if result.ammo[name] >= amount then
						local ammo = xPlayer.getAmmo()[name]

						if ammo.count+amount > config.ammoTypes[name].max then
							amount = config.ammoTypes[name].max - ammo.count
						end

						if amount > 0 then
							xPlayer.addWeaponAmmo(config.ammoTypes[name].weaponHash, amount)
							result.ammo[name] = result.ammo[name]-amount
							cbResult = true

							if result.ammo[name] == 0 then
								result.ammo[name] = nil
							end
						else
							xPlayer.showNotification('You are already full on this ammo type', 2500, 'error', 'longnotif')
						end
					end
				end
			end
		elseif type == "item_weapon" then
			if result.weapons then
				if result.weapons[name] then
					if xPlayer.hasWeapon(name) then
						xPlayer.showNotification('You already have this weapon on you', 2500, 'error', 'longnotif')
					else
						xPlayer.addWeapon(name)
						result.weapons[name] = nil
						cbResult = true
					end
				end
			end
		end

		if cbResult then
			MySQL.Sync.execute("UPDATE prison_sentences SET collection = @data WHERE id = @id", {
				["@data"] = json.encode(result),
				["@id"] = itemData.item.data
			})

			local newData = MySQL.Sync.fetchAll("SELECT * FROM prison_sentences WHERE `rpuk_charid` = @charID", {["@charID"] = xPlayer.rpuk_charid})
			local items = {}
			local weapons = {}
			local ammo = {}

			for k,v in pairs(newData) do
				local temp = json.decode(v.collection)

				if next(temp) then
					if temp.items then
						for key,val in pairs(temp.items) do
							table.insert(items, {
								name = key,
								count = val,
								label = ESX.GetItemLabel(key),
								data = v.id
							})
						end
					end

					if temp.weapons then
						for key,val in pairs(temp.weapons) do
							table.insert(weapons, {
								name = key,
								count = 1,
								label = ESX.GetWeaponLabel(key),
								data = v.id
							})
						end
					end

					if temp.ammo then
						for key,val in pairs(temp.ammo) do
							table.insert(ammo, {
								name = key,
								count = val,
								label = ESX.GetAmmoLabel(key),
								data = v.id
							})
						end
					end
				end
			end

			xPlayer.triggerEvent("rpuk_inventory:refreshSecondaryInventory", {
				type = "rpuk_prison"
			}, {}, items, weapons, ammo)
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)