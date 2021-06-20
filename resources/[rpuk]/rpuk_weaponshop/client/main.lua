cachedData = {
	["attachedComponents"] = {},
}

isMenuOpen = false

if Config.Debug then
	RemoveAllPedWeapons(PlayerPedId())

	ESX.UI.Menu.CloseAll()
end

Citizen.CreateThread(function()
	Citizen.Wait(500) -- Init time.

	if Config.StoreBlips then
		for shopIndex, shopData in ipairs(Config.WeaponShops) do
			local storeBlip = AddBlipForCoord(shopData["clerkMarker"]["position"])

			SetBlipSprite(storeBlip, 110)
			SetBlipScale(storeBlip, 0.7)
			SetBlipColour(storeBlip, 2)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(shopData["name"])
			EndTextCommandSetBlipName(storeBlip)
		end
	end

	SpawnClerks()

	while true do
		Citizen.Wait(0)
		local letSleep = true
		local ped = cachedData["ped"]
		local pedCoords = GetEntityCoords(ped)

		for shopIndex, shopData in ipairs(Config.WeaponShops) do
			local dstCheck = #(pedCoords - shopData["clerkMarker"]["position"])

			if dstCheck <= Config.MarkerData["range"] then
				letSleep = false

				if not isMenuOpen and dstCheck <= Config.MarkerData["size"]["x"] - 0.35 then
					local clerkHandle = cachedData["clerks"][shopData["name"]]

					local usable = not IsEntityDead(clerkHandle)
					local displayText = usable and "Press ~INPUT_PICKUP~ to access the ~o~Weapon Shop~s~" or shopData["name"] .. " is closed, come back later."

					if IsControlJustPressed(0, 38) and usable then
						OpenGatewayMenu(shopData)
					end

					ESX.ShowHelpNotification(displayText)
				end

				DrawScriptMarker({
					["type"] = Config.MarkerData["type"],
					["size"] = Config.MarkerData["size"],
					["color"] = Config.MarkerData["color"],
					["pos"] = shopData["clerkMarker"]["position"] - vector3(0.0, 0.0, 0.985)
				})

				break
			end
		end

		if letSleep then Citizen.Wait(500) end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)

		local ped = PlayerPedId()

		if cachedData["ped"] ~= ped then
			cachedData["ped"] = ped
		end
	end
end)