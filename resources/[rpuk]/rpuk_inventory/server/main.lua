ammoTypes = ESX.GetAmmo()
Config.ammoTypes = ESX.GetAmmo()
Config.defaultWeight, Config.localWeight = ESX.getLocalWeight()

ESX.RegisterServerCallback("rpuk_inventory:closestPickup", function(source, cb, coords)
	cb(getClosestPickup(coords))
end)

ESX.RegisterServerCallback("rpuk_inventory:getPickups", function(source, cb)
	cb(pickups)
end)