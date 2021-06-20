local holstered  = true
local bigholstered  = true
local blocked	 = false

------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		loadAnimDict("rcmjosh4")
		loadAnimDict("reaction@intimidation@cop@unarmed")
		loadAnimDict("reaction@intimidation@1h")
		local ped = PlayerPedId()
		if IsPedOnFoot(ped, false) then
			if GetVehiclePedIsTryingToEnter(ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
				if CheckWeapon(ped, "large") then
					if bigholstered then
						blocked   = true
						SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
						TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 50, 0, 0, 0, 0 )
						Citizen.Wait(1250)
						SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
						Citizen.Wait(400)
						ClearPedTasks(ped)
						bigholstered = false
					else
						blocked = false
					end
				else
					if not bigholstered then
						blocked = false
						TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 3.0, -1, 50, 0, 0, 0.125, 0 ) -- Change 50 to 30 if you want to stand still when holstering weapon
						Citizen.Wait(1700)
						ClearPedTasks(ped)
						bigholstered = true
					end
				end
				if CheckWeapon(ped, "small") then
					if holstered then
						blocked	= true
						SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
						TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 ) -- Change 50 to 30 if you want to stand still when removing weapon
						Citizen.Wait(400)
						SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
						TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
						Citizen.Wait(60)
						ClearPedTasks(ped)
						holstered = false
					else
						blocked = false
					end
				else
					if not holstered then
						TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
						Citizen.Wait(280)
						TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 ) -- Change 50 to 30 if you want to stand still when holstering weapon
						Citizen.Wait(60)
						ClearPedTasks(ped)
						holstered = true
					end
				end
			else
				SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
			end
		else
			holstered = true
			bigholstered = true
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if blocked then
			DisableControlAction(1, 25, true )
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 23, true)
			DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
			DisablePlayerFiring(ped, true) -- Disable weapon firing
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent("wheelfix")
AddEventHandler('wheelfix', function()
	if blocked then
		blocked = false
	end
end)


function CheckWeapon(ped, type)
	if IsEntityDead(ped) then
		blocked = false
			return false
		else
			if type == "small" then
				for i = 1, #h_Config.Weapons do
					if GetHashKey(h_Config.Weapons[i]) == GetSelectedPedWeapon(ped) then
						return true
					end
				end
			elseif type == "large" then
				for i = 1, #h_Config.Weapons do
					if GetHashKey(h_Config.BigWeapons[i]) == GetSelectedPedWeapon(ped) then
						return true
					end
				end
			end
		return false
	end
end


function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end


---------------------------------------------------------------------------------------
--Holster Clothing
---------------------------------------------------------------------------------------
local enabled = true
local active = false
local ped = nil -- The hash of the current ped
local currentPedData = nil -- Config data for the current ped
local weapons = { }

function table_invert(t)
  local s={}
  for k,v in pairs(t) do
    s[v]=k
  end
  return s
end

-- Returns if the given weapon (hash) is in the config
function isConfigWeapon(weapon)
	return weapons[weapon] ~= nil
  end
  
  -- Adds the weapon hash to the 'weapons' table, for a given string or hash
  local function loadWeapon(weapon)
	local hash = weapon
	if not tonumber(weapon) then -- If not already a hash
	  hash = GetHashKey(weapon)
	end
	if not IsWeaponValid(hash) then 
	  error('Invalid weapon ' .. tostring(weapon))
	end
	if isConfigWeapon(weapon) then return end -- Don't add duplicate weapons
	weapons[hash] = true
  end
  
  if type(Config.clothes["weapon"]) == 'table' then
	for _, weapon in ipairs(Config.clothes["weapon"]) do
	  loadWeapon(weapon)
	end
  else -- Backwards compatibility for old config versions where 'config.weapon' was just a string
	loadWeapon(Config.clothes["weapon"])
  end
  
  -- Slow loop to determine the player ped and if it is of interest to the algorithm
  Citizen.CreateThread(function()
	while true do
	  ped = PlayerPedId()
	  local ped_hash = GetEntityModel(ped)
	  local enable = false -- We updated the 'enabled' variable in the upper scope with this at the end
	  -- Loop over peds in the config
	  for config_ped, data in pairs(Config.clothes["peds"]) do
		if GetHashKey(config_ped) == ped_hash then 
		  enable = true -- By default, the ped will have its holsters enabled
		  if data.enabled ~= nil then -- Optional 'enabled' option
			enable = data.enabled
		  end
		  currentPedData = data
		  break
		end
	  end
	  active = enable
	  Citizen.Wait(5000)
	end
  end)
  
  -- Faster loop to change holster textures
  local last_weapon = nil -- Variable used to save the weapon from the last tick
  Citizen.CreateThread(function()
	while true do
	  if active and enabled then -- A ped in the config is in use, so we start checking
		current_weapon = GetSelectedPedWeapon(ped)
		if current_weapon ~= last_weapon then -- The weapon in hand has changed, so we need to check for holsters
		  for component, holsters in pairs(currentPedData.components) do
			local holsterDrawable = GetPedDrawableVariation(ped, component) -- Current drawable of this component
			local holsterTexture = GetPedTextureVariation(ped, component) -- Current texture, we need to preserve this
  
			local emptyHolster = holsters[holsterDrawable] -- The corresponding empty holster
			if emptyHolster and isConfigWeapon(current_weapon) then
			  SetPedComponentVariation(ped, component, emptyHolster, holsterTexture, 0)
			  break
			end
  
			local filledHolster = table_invert(holsters)[holsterDrawable] -- The corresponding filled holster
			if filledHolster and not isConfigWeapon(current_weapon) then
			  SetPedComponentVariation(ped, component, filledHolster, holsterTexture, 0)
			  break
			end
		  end
		end
		last_weapon = current_weapon
	  end
	  Citizen.Wait(200)
	end
  end)

-- local HasWeaponSlingOne, SlingWeaponOne, WeaponToSlingOne, AmmoInSlingOne, HasWeaponSlingTwo, SlingWeaponTwo, WeaponToSlingTwo, AmmoInSlingTwo = false, nil, nil, 0, false, nil, nil, 0
-- RegisterKeyMapping('sling', 'Sling', 'keyboard', '.')
-- TriggerEvent('chat:addSuggestion', '/sling', 'Sling')
-- RegisterCommand('sling', function(playerId, args, rawCommand) sling() end)

-- function sling()
-- 	local player = PlayerPedId()
-- 	if ESX.Player.GetJobName() == "police" or ESX.Player.GetJobName() == "nca" then 
-- 		if GetSelectedPedWeapon(player) == (`WEAPON_CARBINERIFLE` or `WEAPON_SPECIALCARBINE`) then
-- 			if not HasWeaponSlingOne then
-- 				WeaponToSlingOne = GetSelectedPedWeapon(player)
-- 				AmmoInSlingOne = GetAmmoInPedWeapon(player, WeaponToSlingOne)
-- 				Wait(100)
-- 				if not HasWeaponAssetLoaded(WeaponToSlingOne) then
-- 					RequestWeaponAsset(WeaponToSlingOne)
-- 					while not HasWeaponAssetLoaded(WeaponToSlingOne) do
-- 						Wait(0)
-- 					end
-- 				end
-- 				SlingWeaponOne = CreateWeaponObject(WeaponToSlingOne, 50, 1.0, 1.0, 1.0, true, 1.0, 0)
-- 				AttachEntityToEntity(SlingWeaponOne, player, GetPedBoneIndex(player, 18905), 0.0, 0.0, 0.0, 50.0, 90.0, 0.0, 1, 1, 0, 1, 1, 0)
-- 				RemoveWeaponFromPed(player, WeaponToSlingOne)
-- 				HasWeaponSlingOne = true
-- 				SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)
-- 				loadAnimDict("mp_player_intdrink")
-- 				TaskPlayAnim(player, 'mp_player_intdrink', 'loop_bottle', 8.0, -8.0, 200, 49, 0, 0, 0, 0)
-- 				Wait(100)
-- 				ClearPedTasks(player)
-- 				RemoveAnimDict("mp_player_intdrink")
-- 				AttachEntityToEntity(SlingWeaponOne, player, GetPedBoneIndex(player, 24816), 0.0, 0.27, -0.02, 0.0, 320.0, 175.0, 1, 1, 0, 0, 2, 1)
-- 			end
-- 		elseif HasWeaponSlingOne and GetSelectedPedWeapon(player) == `WEAPON_UNARMED` then
-- 			HasWeaponSlingOne = false
-- 			loadAnimDict("mp_player_intdrink")
-- 			TaskPlayAnim(player, 'mp_player_intdrink', 'loop_bottle', 8.0, -8.0, 200, 49, 0, 0, 0, 0)
-- 			Wait(50)
-- 			AttachEntityToEntity(SlingWeaponOne, player, GetPedBoneIndex(player, 18905), 0.0, 0.0, 0.0, 90.0, 90.0, 0.0, 1, 1, 0, 1, 1, 0)
-- 			Wait(50)
-- 			ClearPedTasks(player)
-- 			RemoveAnimDict("mp_player_intdrink")
-- 			if DoesEntityExist(SlingWeaponOne) then
-- 				DeleteObject(SlingWeaponOne)
-- 				RemoveWeaponAsset(SlingWeaponOne)
-- 				SetModelAsNoLongerNeeded(SlingWeaponOne)
-- 			end
-- 			GiveWeaponToPed(player, WeaponToSlingOne, AmmoInSlingOne, false)
-- 			SetCurrentPedWeapon(player, WeaponToSlingOne, true)
-- 			SetPedAmmo(player, WeaponToSlingOne, AmmoInSlingOne)
-- 		end
-- 	end
-- end