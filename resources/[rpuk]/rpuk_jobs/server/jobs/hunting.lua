local currentCallers = {}

RegisterNetEvent('rpuk_hunting:clear_cull')
AddEventHandler('rpuk_hunting:clear_cull', function(onJob, entity, distance)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ranger' or not entity or not distance then
		TriggerEvent('rpuk_anticheat:sab', xPlayer.source, "job_restricted")
		return
	end

	if onJob == 1 then
		math.randomseed(os.time())
		local dMoney = math.floor(distance/2)
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = ('Animal skinned. Job complete £%s.'):format(dMoney)})
		xPlayer.addAccountMoney('bank', math.floor(dMoney), ('%s [%s]'):format('Hunting Job Payout', GetCurrentResourceName()))
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = 'Animal skinned.'})
	end

	xPlayer.addInventoryItem('leather', 1)
	xPlayer.addInventoryItem('meat', math.random(1,3))
	if math.random(1,3) == 3 then
		xPlayer.addInventoryItem('fur', 1)
	end
end)

RegisterNetEvent('rpuk_hunting:clear_photo')
AddEventHandler('rpuk_hunting:clear_photo', function(onJob, distance)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'ranger' or not distance then
		TriggerEvent('rpuk_anticheat:sab', xPlayer.source, "job_restricted")
		return
	end

	if onJob == 211020 then -- just a random number // fuck it might as well?
		math.randomseed(os.time())
		local dMoney = math.floor(distance/2)
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { length = 6000, type = 'inform', text = ('Photo taken. Job complete £%s.'):format(dMoney)})
		xPlayer.addAccountMoney('bank', math.floor(dMoney), ('%s [%s]'):format('Hunting Job Payout', GetCurrentResourceName()))
		xPlayer.addInventoryItem('photo', 1)
	else
		TriggerEvent('rpuk_anticheat:sab', xPlayer.source, "job_restricted")
		return
	end
end)

RegisterNetEvent("rpuk_hunting:openShop")
AddEventHandler("rpuk_hunting:openShop", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammo = {}
	local weapons = {}
	local items = {}
	if xPlayer.job.name ~= "ranger" then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 2000, type = 'error', text = 'You are not a ranger' })
		return
	end

	for k,v in pairs(Config.Hunting.shop) do
		if v.type == "item_standard" then
			table.insert(items, {
				count = v.price,
				label = ESX.GetItemLabel(k),
				name = k
			})
		elseif v.type == "item_ammo" then
			table.insert(ammo, {
				count = v.price,
				label = ESX.GetAmmoLabel(k),
				name = k
			})
		elseif v.type == "item_weapon" then
			table.insert(weapons, {
				count = v.price,
				label = ESX.GetWeaponLabel(k),
				name = k
			})
		end
	end

	TriggerClientEvent("rpuk_inventory:openSecondaryInventory", source, {
		type = "rpuk_hunting",
		typeOfInv = "store",
		text = "Hunting store"
	}, _, items, weapons, ammo)
end)

ESX.RegisterServerCallback('rpuk_hunting:getItem', function(playerId, cb, type, name, amount, data, itemData)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local cbResult = false

	if not currentCallers[playerId] then
		currentCallers[playerId] = true

		if xPlayer.job.name == "ranger" and xPlayer.job.grade >= Config.Hunting.shop[name].rank then
			if type == "item_standard" then
				local price = Config.Hunting.shop[name].price*amount
				if xPlayer.getAccountBalance(Config.Hunting.payType) >= price then
					if xPlayer.canCarryItem(name, amount) then
						xPlayer.removeAccountMoney(Config.Hunting.payType, price, ('%s (%s) [%s]'):format('Purchases item from hunting locker', name, GetCurrentResourceName()))
						xPlayer.addInventoryItem(name, amount)
						xPlayer.showNotification("Bought item.", 2500, 'inform', 'longnotif')
						cbResult = true
					else
						xPlayer.showNotification('You do not have enough room in your inventory', 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('Insufficient funds', 2500, 'error', 'longnotif')
				end
			elseif type == "item_ammo" then
				local ammo = xPlayer.getAmmoOfType(name)

				if ammo.count+amount > ammo.max then
					amount = ammo.max - ammo.count
				end

				if amount > 0 then
					local price = Config.Hunting.shop[name].price*amount

					if xPlayer.getAccountBalance(Config.Hunting.payType) >= price then
						xPlayer.removeAccountMoney(Config.Hunting.payType, price, ('%s (%s) [%s]'):format('Purchased ammo from hunting locker', name, GetCurrentResourceName()))
						xPlayer.addWeaponAmmo(name, amount)
						xPlayer.showNotification('Bought ammo', 2500, 'inform', 'longnotif')
						cbResult = true
					else
						xPlayer.showNotification('Insufficient funds', 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('Ammo of this type is already full', 2500, 'error', 'longnotif')
				end
			elseif type == "item_weapon" then
				if not xPlayer.hasWeapon(name) then
					local price = Config.Hunting.shop[name].price

					if xPlayer.getAccountBalance(Config.Hunting.payType) >= price then
						xPlayer.removeAccountMoney(Config.Hunting.payType, price, ('%s (%s) [%s]'):format('Purchased weapon from hunting locker', name, GetCurrentResourceName()))
						xPlayer.addWeapon(name)
						xPlayer.showNotification("Bought weapon.", 2500, 'inform', 'longnotif')
						cbResult = true
					else
						xPlayer.showNotification('Insufficient funds', 2500, 'error', 'longnotif')
					end
				else
					xPlayer.showNotification('You already have this weapon', 2500, 'error', 'longnotif')
				end
			end
		else
			xPlayer.showNotification('Ranger rank too low', 2500, 'error', 'longnotif')
		end
	end

	currentCallers[playerId] = nil
	cb(cbResult)
end)