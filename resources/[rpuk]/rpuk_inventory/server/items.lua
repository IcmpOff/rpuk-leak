for index,data in pairs(Config.maskList) do
	ESX.RegisterUsableItem(data[1], function(source)
		TriggerClientEvent('rpuk_consume:applyMask', source, data[2], data[3])
	end)
end

for index,data in pairs(Config.food) do
	ESX.RegisterUsableItem(data[1], function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('rpuk_consume:eat', source, data[1], data[2], data[3])
		xPlayer.removeInventoryItem(data[1], 1)
	end)
end

for index,data in pairs(Config.alcohol) do
	ESX.RegisterUsableItem(data, function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('rpuk_consume:useItem', source, data)
		xPlayer.removeInventoryItem(data, 1)
	end)
end

for index,data in pairs(Config.drugs) do
	ESX.RegisterUsableItem(data, function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('rpuk_consume:useItem', source, data)
		xPlayer.removeInventoryItem(data, 1)
	end)
end

for index,data in pairs(Config.Deployables) do
	ESX.RegisterUsableItem(data[1], function(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('rpuk_consume:useDeployable', source, data)
		xPlayer.removeInventoryItem(data[1], 1)
	end)
end

ESX.RegisterUsableItem('PLASTIC_SHEET', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local randomGen = math.random(1,11)
	for index,data in pairs(Config.maskList) do
		if index == randomGen then
			xPlayer.addInventoryItem(data[1], 1)
			xPlayer.removeInventoryItem("PLASTIC_SHEET", 1)
		end
	end
end)

ESX.RegisterUsableItem('armor', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getArmour() < 100 then
		TriggerClientEvent('rpuk_consume:applyArmor', source, 100)
		xPlayer.removeInventoryItem("armor", 1)
	else
		xPlayer.showNotification('You already have 100% armour!')
	end
end)

ESX.RegisterUsableItem('lockpick', function(source)
	TriggerClientEvent('rpuk_items:lockpickVehicle', source, "lockpick")
	TriggerClientEvent("rpuk_inventory:closeInventory", source)
end)

ESX.RegisterUsableItem('advanced_lockpick', function(source)
	TriggerClientEvent('rpuk_items:lockpickVehicle', source, "advanced_lockpick")
	TriggerClientEvent("rpuk_inventory:closeInventory", source)
end)

ESX.RegisterUsableItem('bandage', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getHealth() < 200 then
		TriggerClientEvent('rpuk_consume:useItem', source, 'bandage')
		xPlayer.removeInventoryItem("bandage", 1)
	else
		xPlayer.showNotification('You don\'t need to use a bandage')

	end
end)

ESX.RegisterUsableItem('repairkit', function(source)
	local _source = source
	TriggerClientEvent('rpuk_consume:useItem', _source, 'repairkit')
end)

ESX.RegisterUsableItem('money_bag', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = math.random(400,600)
	if 100 * math.random() < 50 then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 4000, type = 'inform', text = 'You have found £'..money..' in the bag.' })
		xPlayer.addAccountMoney("money", money, ('%s [%s]'):format('Money bag', GetCurrentResourceName()))
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 4000, type = 'inform', text = 'Dye pack has exploded all over the money.' })
		TriggerClientEvent("rpuk_consume:dyePackExplode", _source)
	end
	TriggerClientEvent("rpuk_inventory:closeInventory", _source)
	xPlayer.removeInventoryItem("money_bag", 1)
end)

ESX.RegisterUsableItem('washkit', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('rpuk_consume:useItem', source, 'washkit')
	if xPlayer.job.name == "mechanic" then
		if math.random(1,2) == 1 then
			xPlayer.removeInventoryItem("washkit", 1)
		end
	else
		xPlayer.removeInventoryItem("washkit", 1)
	end
end)

ESX.RegisterUsableItem('binoculars', function(source)
	local _source = source
	TriggerClientEvent('binoculars:Activate', _source)
end)

ESX.RegisterUsableItem('scuba', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('rpuk_consume:applyScuba', source)
	xPlayer.removeInventoryItem("scuba", 1)
end)

ESX.RegisterUsableItem("blueprint_pistol", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "pistol")
end)

ESX.RegisterUsableItem("blueprint_50pistol", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "50pistol")
end)

ESX.RegisterUsableItem("blueprint_compactrifle", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "compactrifle")
end)

ESX.RegisterUsableItem("blueprint_doubleAction", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "doubleAction")
end)

ESX.RegisterUsableItem("blueprint_gusenberg", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "gusenberg")
end)

ESX.RegisterUsableItem("blueprint_machinepistol", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "machinepistol")
end)

ESX.RegisterUsableItem("blueprint_molotov", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "molotov")
end)

ESX.RegisterUsableItem("blueprint_pumpshotgun", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "pumpshotgun")
end)

ESX.RegisterUsableItem("blueprint_sawnoff", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "sawnoff")
end)

ESX.RegisterUsableItem("blueprint_uzi", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "uzi")
end)

ESX.RegisterUsableItem("blueprint_vintage", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "vintage")
end)

ESX.RegisterUsableItem("blueprint_combatpdw", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "combatpdw")
end)

ESX.RegisterUsableItem("blueprint_gangpistol", function(source)
	TriggerClientEvent('rpuk_manufacturing:openBlueprint', source, "gangm1911")
end)

RegisterNetEvent('returnItem')
AddEventHandler('returnItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addInventoryItem(item, 1)
end)

RegisterNetEvent('removeItem')
AddEventHandler('removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem(item, 1)
end)

RegisterNetEvent('rpuk_blindfold:placeBlindFoldOnPlayer')
RegisterNetEvent('rpuk_blindfold:placeBlindFoldOffPlayer')

AddEventHandler('rpuk_blindfold:placeBlindFoldOnPlayer', function(closestPlayer)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(closestPlayer)
	local item = xPlayer.getInventoryItem("blindfold")
	if item.count >= 1 then
		TriggerClientEvent("rpuk_blindfold:anim", _source)
		TriggerClientEvent("rpuk_blindfold:bagHead", closestPlayer)
		xPlayer.removeInventoryItem("blindfold", 1)
		xTarget.addInventoryItem("blindfold", 1)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "You do not have a bag on you." })
	end
end)

AddEventHandler('rpuk_blindfold:placeBlindFoldOffPlayer', function(closestPlayer)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(closestPlayer)
	local item = xTarget.getInventoryItem("blindfold")

	if item.count >= 1 then
		xPlayer.addInventoryItem("blindfold", 1)
		xTarget.removeInventoryItem("blindfold", 1)
		TriggerClientEvent("rpuk_blindfold:anim", _source)
		TriggerClientEvent("rpuk_blindfold:removeBagHead", closestPlayer)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', closestPlayer, { length = 5000, type = 'error', text = "You do not have a bag on you." })
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 5000, type = 'error', text = "They do not have a bag on them?" })
	end
end)