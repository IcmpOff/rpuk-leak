RegisterNetEvent('rpuk_ammo:useAmmoItem')
AddEventHandler('rpuk_ammo:useAmmoItem', function(ammo)
	local playerPed = PlayerPedId()
	local weapon, weaponName
	local found, currentWeaponHash = GetCurrentPedWeapon(playerPed, true)

	if found then
		for k,v in pairs(ammo.weapons) do
			local weaponHash = GetHashKey(v)

			if currentWeaponHash == weaponHash then
				weapon, weaponName = weaponHash, v
				break
			end
		end

		if weapon then
			local pedAmmo = GetAmmoInPedWeapon(playerPed, weapon)
			local newAmmo = pedAmmo + ammo.count
			ClearPedTasks(playerPed)
			local found2, maxAmmo = GetMaxAmmo(playerPed, weapon)

			if newAmmo < maxAmmo then
				TaskReloadWeapon(playerPed)
				TriggerServerEvent('rpuk_ammo:removeAmmoItem', ammo.name, ammo.count, weaponName)
				TriggerEvent("mythic_notify:client:SendAlert", {text = "Reloaded", type = 'success',})
			else
				TriggerEvent("mythic_notify:client:SendAlert", {text = "Max Ammo", type = 'error',})
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local currentWeaponHash = GetSelectedPedWeapon(PlayerPedId())
		DisplayAmmoThisFrame(currentWeaponHash)
	end
end)