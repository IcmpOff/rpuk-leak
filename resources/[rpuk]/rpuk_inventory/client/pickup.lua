pickups = {}

RegisterNetEvent("esx:playerLoaded")
RegisterNetEvent("rpuk_inventory:deletePickup")
RegisterNetEvent("rpuk_inventory:pickupsLoadedIn")
RegisterNetEvent("rpuk_inventory:createPickup")

AddEventHandler("esx:playerLoaded", function()
	ESX.TriggerServerCallback("rpuk_inventory:getPickups", function(data)
		for k,v in pairs(data) do
			local obj = CreateObject(GetHashKey('v_ret_ta_box'), v.pos.x, v.pos.y, v.pos.z, false, false, false)
			FreezeEntityPosition(obj, true)
			pickups[v.id] = obj
		end
	end)
end)

AddEventHandler("rpuk_inventory:pickupsLoadedIn", function(data)
	for k,v in pairs(data) do
		local obj = CreateObject(GetHashKey('v_ret_ta_box'), v.pos.x, v.pos.y, v.pos.z, false, false, false)
		FreezeEntityPosition(obj, true)
		pickups[v.id] = obj
	end
end)

AddEventHandler("rpuk_inventory:deletePickup", function(id)
	DeleteObject(pickups[id])
end)

AddEventHandler("rpuk_inventory:createPickup", function(data)
	local obj = CreateObject(GetHashKey('v_ret_ta_box'), data.pos.x, data.pos.y, data.pos.z, false, false, false)
	FreezeEntityPosition(obj, true)
	pickups[data.id] = obj
end)