-- [[ Roleplay.co.uk ]] --
-- Weapon damage and control
-- Stealthee 21/01/2020

-- [[ Handy References ]] --
-- https://runtime.fivem.net/doc/natives/?_0xCE07B9F7817AADA3
-- https://docs.fivem.net/docs/game-references/controls/
-- https://wiki.rage.mp/index.php?title=Weapons

-- [[ This runs a lot better with the wait 0's in, not sure why // Stealthee 02/03/2020 ]] --
Citizen.CreateThread(function()
	while true do
		--[[ MISC WEAPONS / DAMAGE ]]--
		SetWeaponDamageModifier(GetHashKey("WEAPON_STUNGUN"), 0.0) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_HIT_BY_WATER_CANNON"), 0.0) Wait(0)

		--[[ MELEE WEAPONS KNIVES ]]--
		SetWeaponDamageModifier(GetHashKey("WEAPON_POOLCUE"), 0.25) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 0.2) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_NIGHTSTICK"), 0.4) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_HAMMER"), 0.5) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_BOTTLE"), 0.5) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_BAT"), 0.5) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_CROWBAR"), 0.5) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_FLASHLIGHT"), 0.25) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_GOLFCLUB"), 0.3) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_KNUCKLE"), 0.4) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_WRENCH"), 0.4) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_STONE_HATCHET"), 0.5) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_SNOWBALL"), 0.0) Wait(0)

		--[[ MELEE WEAPONS ]]--
		SetWeaponDamageModifier(GetHashKey("WEAPON_DAGGER"), 0.5) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_HATCHET"), 0.5) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_KNIFE"), 0.5) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_MACHETE"), 0.5) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_SWITCHBLADE"), 0.5) Wait(0)
		SetWeaponDamageModifier(GetHashKey("WEAPON_BATTLEAXE"), 0.5) Wait(0)
	end
end)

--https://runtime.fivem.net/doc/natives/?_0x6806C51AD12B83B8
-- Hide weapon reticle & Show stungun reticle

crosshair_active = false

RegisterNetEvent('rpuk_core:toggle_crosshair')
AddEventHandler("rpuk_core:toggle_crosshair", function()
	crosshair_active = not crosshair_active
end)

local checked_current_vehicle, shuffle = false, false
local current_weapon = nil
local rate_limit = false
-- -- Force 1st person shooting when shooting from car
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local player = PlayerPedId()
-- 		local vehicle = GetVehiclePedIsIn(player, false)
-- 		if IsPedInAnyVehicle(player, false) and not checked_current_vehicle then
-- 			SetCurrentPedWeapon(player, -1569615261, true)
-- 			checked_current_vehicle = true
-- 		elseif not IsPedInAnyVehicle(player, false) and checked_current_vehicle then
-- 			checked_current_vehicle = false
-- 		end
-- 		current_weapon = GetSelectedPedWeapon(player)
-- 		if IsPedInAnyVehicle(player, 0) then
-- 			if GetIsTaskActive(player, 165) and not shuffle then
-- 				SetPedIntoVehicle(player, vehicle, 0)
-- 			end
-- 			if current_weapon == -1569615261 then
-- 				SetCurrentPedWeapon(player, current_weapon, true)
-- 			end
-- 			if GetSelectedPedWeapon(player) ~= -1569615261 then
-- 				if not rate_limit then
-- 					rate_limit = true
-- 					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'View set to first person, To return to 3rd, unequip all firearms when in a vehicle.' })
-- 				end
-- 				SetFollowVehicleCamViewMode(4)
-- 				if GetVehicleClass(vehicle) == 8 then
-- 					if GetSelectedPedWeapon(player) == 324215364 then
-- 						TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You can not use this weapon on a bike.' })
-- 						SetCurrentPedWeapon(player, -1569615261, true)
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local player = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(player, false)
		if IsPedInAnyVehicle(player, 0) then
			if GetIsTaskActive(player, 165) and not shuffle then
				SetPedIntoVehicle(player, vehicle, 0)
			end
		end
		if GetVehicleClass(vehicle) == 8 then
			if GetSelectedPedWeapon(player) == 324215364 then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You can not use this weapon on a bike.' })
				SetCurrentPedWeapon(player, -1569615261, true)
			end
		end
	end
end)

RegisterCommand("shuff", function(source, args, raw)
	if IsVehicleSeatFree(GetVehiclePedIsIn(PlayerPedId()), -1) then
		shuffle = true
		Citizen.Wait(3000)
		shuffle = false
	end
end, false)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if rate_limit then
			Citizen.Wait(40000)
			rate_limit = false
		end
	end
end)
