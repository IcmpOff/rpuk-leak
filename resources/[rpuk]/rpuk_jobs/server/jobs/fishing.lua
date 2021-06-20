ESX.RegisterUsableItem('turtlebait', function(source)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', playerId, "turtle")
		xPlayer.removeInventoryItem('turtlebait', 1)
		TriggerClientEvent('esx:showNotification', playerId, "You attach the turtle bait onto your fishing rod")
	else
		TriggerClientEvent('esx:showNotification', playerId, "You dont have a fishing rod")
	end
end)

ESX.RegisterUsableItem('fishbait', function(source)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if xPlayer.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', playerId, "fish")
		xPlayer.removeInventoryItem('fishbait', 1)
		TriggerClientEvent('esx:showNotification', playerId, "You attach the fish bait onto your fishing rod")
	else
		TriggerClientEvent('esx:showNotification', playerId, "You dont have a fishing rod")
	end
end)

ESX.RegisterUsableItem('turtle', function(source)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if xPlayer.getInventoryItem('fishingrod').count > 0 then
		TriggerClientEvent('fishing:setbait', playerId, "shark")

		xPlayer.removeInventoryItem('turtle', 1)
		TriggerClientEvent('esx:showNotification', playerId, "You attach the turtle meat onto the fishing rod")
	else
		TriggerClientEvent('esx:showNotification', playerId, "You dont have a fishing rod")
	end
end)

ESX.RegisterUsableItem('fishingrod', function(source)
	local playerId = source
	TriggerClientEvent('fishing:fishstart', playerId)
end)

RegisterNetEvent('fishing:catch')
AddEventHandler('fishing:catch', function(bait)
	local playerId = source
	local weight
	local rnd = math.random(1,100)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if bait == "turtle" then
		if rnd >= 78 then
			if rnd >= 94 then
				TriggerClientEvent('fishing:setbait', playerId, "none")
				TriggerClientEvent('esx:showNotification', playerId, "It was huge and it broke your fishing rod!")
				TriggerClientEvent('fishing:break', playerId)
				xPlayer.removeInventoryItem('fishingrod', 1)
			else
				TriggerClientEvent('fishing:setbait', playerId, "none")
				if xPlayer.getInventoryItem('turtle').count > 4 then
					TriggerClientEvent('esx:showNotification', playerId, "You cant hold more turtles")
				else
					TriggerClientEvent('esx:showNotification', playerId, "You caught a turtle\nThese are endangered species and are illegal to posses")
					xPlayer.addInventoryItem('turtle', 1)
				end
			end
		else
			if rnd >= 75 then
				if xPlayer.canCarryItem('fish', 1) then
					weight = math.random(4,9)
					TriggerClientEvent('esx:showNotification', playerId, "You caught fish: " .. weight .. "")
					xPlayer.addInventoryItem('fish', weight)
				else
					TriggerClientEvent('esx:showNotification', playerId, "You cant hold more fish")
				end
			else
				if xPlayer.canCarryItem('fish', 1) then
					weight = math.random(2,6)
					TriggerClientEvent('esx:showNotification', playerId, "You caught a fish: " .. weight .. "")
					xPlayer.addInventoryItem('fish', weight)
				else
					TriggerClientEvent('esx:showNotification', playerId, "You cant hold more fish")
				end
			end
		end
	else
		if bait == "fish" then
			if rnd >= 75 then
				TriggerClientEvent('fishing:setbait', playerId, "none")
				if xPlayer.canCarryItem('fish', 1) then
					weight = math.random(4,11)
					TriggerClientEvent('esx:showNotification', playerId, "You caught a fish: " .. weight .. "")
					xPlayer.addInventoryItem('fish', weight)
				else
					TriggerClientEvent('esx:showNotification', playerId, "You cant hold more fish")
				end
			else
				if xPlayer.canCarryItem('fish', 1) then
					weight = math.random(1,6)
					TriggerClientEvent('esx:showNotification', playerId, "You caught a fish: " .. weight .. "")
					xPlayer.addInventoryItem('fish', weight)
				else
					TriggerClientEvent('esx:showNotification', playerId, "You cant hold more fish")
				end
			end
		end
		if bait == "none" then
			if rnd >= 70 then
			TriggerClientEvent('esx:showNotification', playerId, "You are currently fishing without any equipped bait")
				if xPlayer.canCarryItem('fish', 1) then
					weight = math.random(1,4)
					TriggerClientEvent('esx:showNotification', playerId, "You caught a fish: " .. weight .. "")
					xPlayer.addInventoryItem('fish', weight)
				else
					TriggerClientEvent('esx:showNotification', playerId, "You cant hold more fish")
				end

				else
				TriggerClientEvent('esx:showNotification', playerId, "You are currently fishing without any equipped bait")
					if xPlayer.canCarryItem('fish', 1) then
						weight = math.random(2,6)
						TriggerClientEvent('esx:showNotification', playerId, "You caught a fish: " .. weight .. "")
						xPlayer.addInventoryItem('fish', weight)
					else
						TriggerClientEvent('esx:showNotification', playerId, "You cant hold more fish")
					end
				end
		end
		if bait == "shark" then
			if rnd <= 91 then
				TriggerClientEvent('fishing:setbait', playerId, "none")
				TriggerClientEvent('esx:showNotification', playerId, "It was huge and it broke your fishing rod!")
				TriggerClientEvent('fishing:break', playerId)
				xPlayer.removeInventoryItem('fishingrod', 1)
			else
				if xPlayer.getInventoryItem('shark').count > 0  then
					TriggerClientEvent('fishing:setbait', playerId, "none")
					TriggerClientEvent('esx:showNotification', playerId, "You cant hold more sharks")
				else
					TriggerClientEvent('esx:showNotification', playerId, "You caught a shark!\n These are endangered species and are illegal to posses")
					TriggerClientEvent('fishing:spawnPed', playerId)
					xPlayer.addInventoryItem('shark', 1)
				end
			end
		end
end
end)

RegisterNetEvent("fishing:lowmoney")
AddEventHandler("fishing:lowmoney", function(money)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	xPlayer.removeMoney(money, ('%s [%s]'):format('Fishing Low Money', GetCurrentResourceName()))
end)

RegisterNetEvent('fishing:startSelling')
AddEventHandler('fishing:startSelling', function(item)
	local playerId = source
	local xPlayer  = ESX.GetPlayerFromId(playerId)
	local FishQuantity = xPlayer.getInventoryItem('fish').count
	local TurtleQuantity = xPlayer.getInventoryItem('turtle').count
	local SharkQuantity = xPlayer.getInventoryItem('shark').count

	if item == "fish" and FishQuantity > 0 then
		xPlayer.removeInventoryItem('fish', FishQuantity)
		local payment = math.random(Config.Fishing.FishPrice.a, Config.Fishing.FishPrice.b) * FishQuantity
		xPlayer.addMoney(payment, ('%s [%s]'):format('Fishing Sale', GetCurrentResourceName()))
		TriggerClientEvent('esx:showNotification', source, 'You sold ' ..FishQuantity.. ' Fish (£'..payment..')')
	end

	if item == "turtle" and TurtleQuantity > 0 then
		xPlayer.removeInventoryItem('turtle', TurtleQuantity)
		local payment = math.random(Config.Fishing.TurtlePrice.a, Config.Fishing.TurtlePrice.b) * TurtleQuantity
		xPlayer.addAccountMoney('black_money', payment, ('%s [%s]'):format('Fishing Sale', GetCurrentResourceName()))
		TriggerClientEvent('esx:showNotification', source, 'You sold ' ..TurtleQuantity.. ' turtle (£'..payment..')')
	end

	if item == "shark" and SharkQuantity > 0 then
		xPlayer.removeInventoryItem('shark', SharkQuantity)
		local payment = math.random(Config.Fishing.SharkPrice.a, Config.Fishing.SharkPrice.b) * SharkQuantity
		xPlayer.addAccountMoney('black_money', payment, ('%s [%s]'):format('Fishing Sale', GetCurrentResourceName()))
		TriggerClientEvent('esx:showNotification', source, 'You sold ' ..SharkQuantity.. ' shark (£'..payment..')')
	end
end)

ESX.RegisterServerCallback("fishing:validatePurchase", function(source, cb, amount)
	local player = ESX.GetPlayerFromId(source)

	if player then
		local paid = false

		if player.getMoney() >= amount then
			player.removeMoney(amount, ('%s [%s]'):format('Fishing Purchase', GetCurrentResourceName()))
			paid = true
		elseif player.getAccount("bank")["money"] >= amount then
			player.removeAccountMoney("bank", amount, ('%s [%s]'):format('Fishing Purchase', GetCurrentResourceName()))
			paid = true
		end

		cb(paid)
	else
		cb(false)
	end
end)