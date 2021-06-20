RegisterNetEvent("rpuk_prison:collectClothes")
AddEventHandler("rpuk_prison:collectClothes", function()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end)

RegisterNetEvent("rpuk_prison:collectionCheck")
AddEventHandler("rpuk_prison:collectionCheck", function(type)
	local player = PlayerPedId()
	local coord = GetEntityCoords(player)
	local closeToInteract = (clothes:isPointInside(coord) or collection:isPointInside(coord))
	if closeToInteract then
		if type == "clothes" then
			local PlayerPed = PlayerPedId()
			TriggerEvent("rpuk_prison:collectClothes")
			TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'inform', text = 'Your clothes have been washed, just for you!' })
			LoadAnim("mp_clothing@female@shirt")
			TaskPlayAnim(PlayerPed, "mp_clothing@female@shirt", "try_shirt_positive_a", 8.0, 1.0, 6200, 49, 0, 0, 0, 0 )
		elseif type == "store" then
			TriggerServerEvent("rpuk_prison:openCollectionPoint")
		end
	end
end)