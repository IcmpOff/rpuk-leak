local safes = {}
local cashier = {}

RegisterNetEvent("rpuk_storeRobbery:startCrack:safe")
RegisterNetEvent("rpuk_storeRobbery:startCrackTimer:safe")
RegisterNetEvent("rpuk_storeRobbery:grabMoney:safe")
RegisterNetEvent('rpuk_storeRobbery:collectMoney')
RegisterNetEvent('rpuk_storeRobbery:repairSafeSV')
RegisterNetEvent('rpuk_storeRobbery:restartSafeSV')
RegisterNetEvent('rpuk_storeRobbery:collectInteraction')

for k,v in pairs(Config.robbery) do
	safes["safe:" .. k] = 0
end

for k,v in pairs(Config.robbery) do
	cashier["cashier:" .. k] = 0
end

formatMoney = function(amount)
	local formatted = amount
	while true do
		Citizen.Wait(0)
	formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
	if (k==0) then
		break
	end
	end
	return formatted
end

AddEventHandler("rpuk_storeRobbery:startCrack:safe", function(id)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem("lockpick")

	if xPlayer.job.name == "unemployed" or xPlayer.job.name == "lost" then
		if ESX.GetInActiveJob("police") < Config.minPolice then
			xPlayer.showNotification('There is not enough cops online to rob a store', 5000, 'error')
		elseif safes[id] > 0 then
			xPlayer.showNotification('This safe has recently been hit', 5000, 'error')
		elseif item.count <= 0 then
			xPlayer.showNotification('You do not have any lockpicks', 5000, 'error', 'longnotif')
		elseif item.count >= 1 then
			xPlayer.removeInventoryItem("lockpick", 1)
			xPlayer.triggerEvent("rpuk_storeRobbery:startSafe", id)
			TriggerClientEvent("rpuk_storeRobbery:addBlip", -1, id)
			TriggerClientEvent("rpuk_storeRobbery:updateInteraction", -1, id, "text", "Currently being opened")
			TriggerClientEvent("rpuk_storeRobbery:updateInteraction", -1, id, "action")
			TriggerClientEvent("rpuk_storeRobbery:repairSafe", -1, id)
		end
	else
		xPlayer.showNotification('You cannot rob stores because of your job', 5000, 'error')
	end
end)

AddEventHandler("rpuk_storeRobbery:repairSafeSV", function(id)
	TriggerClientEvent("rpuk_storeRobbery:restartSafe", -1, id)
	safes[id] = 0
end)

AddEventHandler("rpuk_storeRobbery:restartSafeSV", function(id)
	TriggerClientEvent("rpuk_storeRobbery:restartSafe", -1, id)
	safes[id] = 0
end)

-- AddEventHandler("rpuk_storeRobbery:crackCash:cashier", function(id)
--	 local _source = source
--	 local xPlayer = ESX.GetPlayerFromId(_source)

--	 if ESX.GetInActiveJob("police") < Config.minPolice then
--		 -- TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "Too much security due to lack of police in city" })
--		 -- return
--	 elseif cashier[id] > 0 then
--		 TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "Cashier has recently been hit" })
--		 return
--	 end
--	 -- if item == nil then
--	 --	 TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "You dont have the correct equipment to open the safe!" })
--	 --	 return
--	 -- end
--	 if HasPedGotWeapon(_source, -2067956739, false) then
--		 TriggerClientEvent("rpuk_storeRobbery:startSafe", _source, id)
--		 TriggerClientEvent("rpuk_storeRobbery:updateInteraction", -1, id, "text", "Currently being opened")
--		 TriggerClientEvent("rpuk_storeRobbery:updateInteraction", -1, id, "action")
--	 else
--		 TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "You dont have the correct equipment to open the safe!" })
--	 end
-- end)

AddEventHandler("rpuk_storeRobbery:startCrackTimer:safe", function(id, time, func)
	Citizen.CreateThread(function()
	safes[id] = time
	while safes[id] > 0 do
		TriggerClientEvent("rpuk_storeRobbery:updateInteraction", -1, id, "text", "Time until open " .. safes[id])
		Citizen.Wait(1000)
		safes[id] = safes[id] - 1
	end
	TriggerClientEvent("rpuk_storeRobbery:safeIsReadyToOpen", -1, id)
	TriggerClientEvent("rpuk_storeRobbery:repairSafe", -1, id)
	end)
end)

AddEventHandler('rpuk_storeRobbery:collectInteraction', function(id)
	TriggerClientEvent("rpuk_storeRobbery:updateInteraction", -1, id, "text", "Currently being opened")
	TriggerClientEvent("rpuk_storeRobbery:updateInteraction", -1, id, "action")
end)


AddEventHandler('rpuk_storeRobbery:collectMoney', function(id, coords, safecoords)
	local xPlayer = ESX.GetPlayerFromId(source)
	local dist = math.sqrt(math.pow(Config.centerOfTown.x-coords.x, 2) + math.pow(Config.centerOfTown.y-coords.y, 2) + math.pow(Config.centerOfTown.z-coords.z, 2))
	local modifier = math.abs((dist/8050)-1)
	if id then
		local safeLocation = #(vector3(safecoords.x, safecoords.y, safecoords.z) - xPlayer.getCoords(true))
		if safes[id] == nil or safes[id] == 0 then
			safes[id] = Config.cooldown
			TriggerClientEvent("rpuk_storeRobbery:updateInteraction", -1, id, "text", "Safe has recently been hit, you need to wait " .. safes[id])
			TriggerClientEvent("rpuk_storeRobbery:updateInteraction", -1, id, "action")
			Citizen.CreateThread(function()
				while safes[id] > 0 do
					Citizen.Wait(1000)
					safes[id] = safes[id]-1
					TriggerClientEvent("rpuk_storeRobbery:updateInteraction", -1, id, "text", "Safe has recently been hit, you need to wait " .. safes[id])
				end
				TriggerClientEvent("rpuk_storeRobbery:restartSafe",-1, id)
			end)
			modifier = (modifier > 0.7 and 1.3 or (modifier < 0.4 and 0.7 or 1))
			if safeLocation < 20.0 then
				local money = math.random(Config.minCash*modifier, Config.maxCash*modifier)
				xPlayer.addMoney(money, ('%s [%s]'):format('General Store Robbery Payout', GetCurrentResourceName()))
				print("RPUK StoreRobbery | [".. xPlayer.identifier .."] Reward Amount [ £".. formatMoney(money).."] ")
				TriggerClientEvent("mythic_notify:client:SendAlert", {
					text = "You have collected £ " .. formatMoney(money),
					type = 'inform',
					length = 5000,
				})
			else
				print("RPUK SHOP ROBBERY" .. xPlayer.identifier .. " called the collectMoney event without being close to the safe [Coords listed below]")
				print("RPUK SHOP ROBBERY" .. xPlayer.identifier .. 'Safe Coords - x = '..safecoords.x..', y = '..safecoords.y..', z = '..safecoords.z)
				print("RPUK SHOP ROBBERY" .. xPlayer.identifier .. " Players Coords - "..xPlayer.getCoords(true))
				TriggerEvent('rpuk_anticheat:saw', xPlayer.source, "shopLocationExploit")
			end
			TriggerClientEvent("rpuk_storeRobbery:removeBlip", -1, id)
		else
			print("RPUK SHOP ROBBERY" .. xPlayer.identifier .. " called the collectMoney event without meeting requirements [cooldown active]")
		end
	else
		print("RPUK SHOP ROBBERY" .. xPlayer.identifier .. " called the collectMoney event without meeting requirements [val id was nil]")
	end
end)