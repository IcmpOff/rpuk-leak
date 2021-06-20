function prisonRadius()
	Citizen.CreateThread(function()
		while true do
			Wait(100)
			local plyPed = PlayerPedId()
			local coord = GetEntityCoords(plyPed)
			local insidePrison = prisonDrain:isPointInside(coord)
			if not insidePrison then
				TriggerServerEvent("rpuk_prison:unJailPlayer", GetPlayerServerId(PlayerId(-1)), "escape", true)
				break
			end
		end
	end)
end


RegisterNetEvent("rpuk_prison:alertPolice")
AddEventHandler("rpuk_prison:alertPolice", function(targetName)
	TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "prisonerescape", extraNotes = targetName})
	TriggerServerEvent("rpuk_core:SavePlayer")
end)

RegisterNetEvent("rpuk_prison:spawnedBack")
AddEventHandler("rpuk_prison:spawnedBack", function()
	prisonRadius()
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, config.clothes.male)
		else
			TriggerEvent('skinchanger:loadClothes', skin, config.clothes.female)
		end
	end)
	TriggerEvent('mythic_notify:client:SendAlert', {length = 15000, type = 'inform', text = 'Welcome back! <br> Let me remind you that at any point you can check your remaining sentence from using the wheel menu (Interactions) near phone booths. Remember you can use the wheel menu (Interactions) to clean tables etc to cut time of your sentence!' })
end)

RegisterNetEvent("rpuk_prison:releasedPrisoner")
AddEventHandler("rpuk_prison:releasedPrisoner", function()
	local PlayerPed = PlayerPedId()
	DoScreenFadeOut(1000)
	Citizen.Wait(1200)
	SetEntityCoords(PlayerPed, config.postions.releasePoint.x, config.postions.releasePoint.y, config.postions.releasePoint.z)
	SetEntityHeading(PlayerPed, config.postions.releasePoint.h)
	DoScreenFadeIn(800)
	TriggerServerEvent("rpuk_core:SavePlayer")
	TriggerEvent('mythic_notify:client:SendAlert', {length = 16000, type = 'inform', text = 'Welcome back to the free world! <br> You have been given one more chance, do not fuck up. <br> Do not forget to collect your clothes from the desk on your right from the wheel menu (Interactions) and if you have any belongings please goto the front desk and use the wheel menu (Interactions)!' })
end)