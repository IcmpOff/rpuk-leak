local transformer = {}
local panel = {}
local safe = {}
local boxes = {}
local powerStatus = true
local vaultDoor = false
local approved_payouts = {}

RegisterNetEvent("rpuk_pacificHeist:C4Check")
RegisterNetEvent("rpuk_pacificHeist:smoke")
RegisterNetEvent("rpuk_pacificHeist:transformerCheck")
RegisterNetEvent("rpuk_pacificHeist:vaultPanel")
RegisterNetEvent("rpuk_pacificHeist:setPowerOnline")
RegisterNetEvent("rpuk_pacificHeist:fireTransformer")
RegisterNetEvent("rpuk_pacificHeist:openDoorSV")
RegisterNetEvent("rpuk_pacificHeist:closeDoorSV")
RegisterNetEvent("rpuk_pacificHeist:keycardCheck")
RegisterNetEvent("rpuk_pacificHeist:safeFix")
RegisterNetEvent("rpuk_pacificHeist:safeReward")
RegisterNetEvent("rpuk_pacificHeist:drillCheck")
RegisterNetEvent("rpuk_pacificHeist:depositBoxReward")
RegisterNetEvent("rpuk_pacificHeist:hackPanel")
RegisterNetEvent("rpuk_pacificHeist:registerPanelInUse")
RegisterNetEvent("rpuk_pacificHeist:vaultOpen")


for k,v in pairs(config.transformerLocation) do
	transformer["transformer:" .. k] = 0
end


for k,v in pairs(config.officeSafe) do
	safe["safe:" .. k] = 0
end

for k,v in pairs(config.depositBoxes) do
	safe["boxes:" .. k] = 0
end

ESX.RegisterServerCallback('rpuk_pacificHeist:getPowerInfo', function(source, cb)
	cb(powerStatus)
end)

ESX.RegisterServerCallback('rpuk_pacificHeist:vaultDoorInfo', function(source, cb)
	cb(vaultDoor)
end)

ESX.RegisterServerCallback("rpuk_pacificHeist:getPanel", function(source, cb)
	cb(panel)
end)

-- Money Function

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

-------------------------------------------------------------------------

AddEventHandler("rpuk_pacificHeist:C4Check", function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem("c4")

	if ESX.GetInActiveJob("police") < config.minPolice then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "Police are currently conducting raids in this area!" })
		return
	elseif transformer[id] > 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "Transformer is currently being fixed" })
		return
	end

	if xPlayer.getInventoryItem("c4") ~= nil then
		if xPlayer.getInventoryItem('c4').count >= 1 then
			xPlayer.removeInventoryItem("c4", 1)
			TriggerClientEvent("rpuk_pacificHeist:placeC4", _source, id)
			TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "text", "Placing C4")
			TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "action")
			return
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "You dont have a C4 to place down!" })
		end
	end
end)

AddEventHandler("rpuk_pacificHeist:setPowerOnline", function(id)
	powerStatus = true
	vault = false
	TriggerClientEvent("rpuk_pacificHeist:setupVault", -1, id)
end)

AddEventHandler("rpuk_pacificHeist:smoke", function(id)
	TriggerClientEvent("rpuk_pacificHeist:startSmoke", -1)
	powerStatus = false
	TriggerClientEvent("rpuk_pacificHeist:setupVault", -1, id)
end)

AddEventHandler("rpuk_pacificHeist:fireTransformer", function(id)
	TriggerClientEvent("rpuk_pacificHeist:explosion", source)
	TriggerClientEvent("rpuk_pacificHeist:countDown", -1)
	Citizen.Wait(13000)
	TriggerEvent('rpuk_alerts:sNotification', {notiftype = "powerstationtransformer"})
end)

AddEventHandler('rpuk_pacificHeist:transformerCheck', function(id)
	transformer[id] = config.transformerRebootTime
	Citizen.CreateThread(function()
		while transformer[id] > 0 do
			Citizen.Wait(1000)
			transformer[id] = transformer[id]-1
			TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "text", "Time Until Power Is Restored | " .. transformer[id])
		end
		TriggerClientEvent("rpuk_pacificHeist:stopFlames", -1)
		TriggerClientEvent("rpuk_pacificHeist:rebootTransformer", -1, id)
	end)
end)

------------------------------

AddEventHandler("rpuk_pacificHeist:vaultPanel", function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem("code_cracker")

	if xPlayer.getInventoryItem("code_cracker") ~= nil then
		if xPlayer.getInventoryItem('code_cracker').count >= 1 then
			xPlayer.removeInventoryItem("code_cracker", 1)
			TriggerClientEvent("rpuk_pacificHeist:connectDevice", _source, id)
			TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "text", "Panel Occupied", {
				exclude = {
					"police"
				},
			})
			TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "action", nil, {
				exclude = {
					"police"
				},
			})
			return
		else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "You dont have the correct equipment to open the vault!" })
		end
	end
end)

AddEventHandler("rpuk_pacificHeist:openDoorSV", function(id)
	vaultDoor = true
	TriggerClientEvent("rpuk_pacificHeist:vaultDoorOpen", -1)
	TriggerClientEvent("rpuk_pacificHeist:activateDepositBoxes", -1, id)
end)


AddEventHandler("rpuk_pacificHeist:closeDoorSV", function(id)
	vaultDoor = false
	TriggerClientEvent("rpuk_pacificHeist:vaultDoorClose", -1)
	TriggerClientEvent("rpuk_pacificHeist:activateDepositBoxes", -1, id)
end)

AddEventHandler("rpuk_pacificHeist:keycardCheck", function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem("bank_securitycard_paleto")

	if safe[id] > 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "Safe is currently being used" })
		return
	end

	if xPlayer.getInventoryItem('bank_securitycard_paleto').count >= 1 then
		xPlayer.removeInventoryItem("bank_securitycard_paleto", 1)
		TriggerClientEvent("rpuk_pacificHeist:searchingSafe", _source, id)
		TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "text", "Searching Safe")
		TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "action")
		return
	elseif xPlayer.getInventoryItem('bank_securitycard_legion').count >= 1 then
		xPlayer.removeInventoryItem("bank_securitycard_legion", 1)
		TriggerClientEvent("rpuk_pacificHeist:searchingSafe", _source, id)
		TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "text", "Searching Safe")
		TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "action")
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "You dont have the correct equipment to open the safe!" })
	end
end)

AddEventHandler('rpuk_pacificHeist:safeFix', function(id)
	safe[id] = config.safeCooldown
	Citizen.CreateThread(function()
		while safe[id] > 0 do
			Citizen.Wait(1000)
			safe[id] = safe[id]-1
			TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "text", "Safe Disabled | " .. safe[id])
			TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "action")
		end
		TriggerClientEvent("rpuk_pacificHeist:restartSafe", -1, id)
	end)
end)


AddEventHandler('rpuk_pacificHeist:safeReward', function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = "safe_keys"
	local itemAmount = math.random(config.minAmountOfKeys, config.maxAmountOfKeys)
	xPlayer.addInventoryItem(item, itemAmount)
	TriggerEvent("rpuk_pacificHeist:safeFix", id)
end)

-----

AddEventHandler("rpuk_pacificHeist:drillCheck", function(id, type)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local itemDrill = xPlayer.getInventoryItem("drill")
	local itemKeys = xPlayer.getInventoryItem("safe_keys")

	if safe[id] > 0 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "This action is busy" })
		return
	end

	if type == "keys" then
		if xPlayer.getInventoryItem("safe_keys") ~= nil then
			if xPlayer.getInventoryItem('safe_keys').count >= 1 then
				xPlayer.removeInventoryItem('safe_keys', 1)
				TriggerClientEvent("rpuk_pacificHeist:boxRewardInteraction", _source, id)
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'inform', text = "You have used a key to unlock the deposit box!" })
				approved_payouts[xPlayer.identifier] = true
				return
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "You do not have deposit box keys!" })
			end
		end
	else
		if xPlayer.getInventoryItem("drill") ~= nil then
			if xPlayer.getInventoryItem('drill').count >= 1 then
				TriggerClientEvent("rpuk_pacificHeist:beginDrill", _source, id)
				TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "text", "Drilling Deposit Box")
				TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "action")
				approved_payouts[xPlayer.identifier] = true
				return
			end
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "You dont have the correct equipment to open the deposit box!" })
		end
	end
end)

AddEventHandler('rpuk_pacificHeist:depositBoxReward', function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local rewardAmount = math.random(150000, 200000)

	if approved_payouts[xPlayer.identifier] == nil then -- ensures it is true and not nil // don't set to false or remove it
		print("RPUK PACIFICHEIST " .. xPlayer.identifier .. " " .. _source .. " was refused access to event [Not expected]" .. " Coords: " .. tostring(GetEntityCoords(GetPlayerPed(_source))))
		return
	end

	local coords = vector3(259.002, 216.083, 100.683)

	if id then
		if #(GetEntityCoords(GetPlayerPed(_source)) - coords) < 125.0 then
			-- Need to add inventory system to get said items
			TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "text", "Safe has been looted")
			TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "action")
			-- xPlayer.addInventoryItem(item, itemAmount)
			xPlayer.addMoney(rewardAmount, ('%s [%s]'):format('Pacific Heist Payout', GetCurrentResourceName()))
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'info', text = "You have found £" .. formatMoney(rewardAmount)})
			print("RPUK PACIFICHEIST | [".. xPlayer.identifier .."] Reward Amount [ £".. formatMoney(rewardAmount).."] ")
		else
			print("RPUK PACIFICHEIST " .. xPlayer.identifier .. " called the depositBoxReward event without meeting requirement1s [was more than 125.0 units away from the bank]")
		end
	else
		print("RPUK PACIFICHEIST " .. xPlayer.identifier .. " called the depositBoxReward event without meeting requirement1s [val id was nil]")
	end
end)

AddEventHandler("rpuk_pacificHeist:hackPanel", function(id, stage)
	if stage == 1 then
		TriggerClientEvent("rpuk_pacificHeist:hackingStageOne", -1, id)
	elseif stage == 2 then
		TriggerClientEvent("rpuk_pacificHeist:hackingStageTwo", -1, id)
	elseif stage == 3 then
		TriggerClientEvent("rpuk_pacificHeist:hackingStageThree", -1, id)
	end

	panel[id] = stage
end)

AddEventHandler("rpuk_pacificHeist:restartPanel", function(id)
	TriggerClientEvent("rpuk_pacificHeist:restartHacking", -1, id)
	panel[id] = 0
end)

AddEventHandler("rpuk_pacificHeist:registerPanelInUse", function(id)
	TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "text", "Panel occupied", {
		exclude = {
			"police"
		}
	})
	TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "action", nil, {
		exclude = {
			"police"
		}
	})
end)

AddEventHandler("rpuk_pacificHeist:vaultOpen", function(id)
	TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "text", "Vault Open", {
		exclude = {
			"police"
		}
	})
	TriggerClientEvent("rpuk_pacificHeist:updateInteraction", -1, id, "action", nil, {
		exclude = {
			"police"
		}
	})
end)