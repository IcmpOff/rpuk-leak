function OpenGatewayMenu(storeData)
	isMenuOpen = true

	local elements = {
		--{ label = "Ranged Weapons", value = 'r_weaponmenu' },
		{ label = "Melee Weapons", value = 'm_weaponmenu' },
		{ label = "Accessories / Vests", value = 'w_accessories' },
		--{ label = "Components / Ammo", value = 'w_components' },
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'playermenu', {
		["title"] = '',
		["align"] = 'top-left',
		["css"] = 'ammo',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'r_weaponmenu' then
			OpenWeaponMenu_Ranged(storeData)
		elseif data.current.value == 'm_weaponmenu' then
			OpenWeaponMenu_Melee(storeData)
		elseif data.current.value == 'w_accessories' then
			OpenAccessoriesMenu()
		elseif data.current.value == 'w_components' then
			OpenWeaponComponentMenu()
		end
	end, function(data, menu)
		menu.close()
		isMenuOpen = false
	end)
end

function OpenWeaponComponentMenu()
	local elements = {}

	if HasPedGotWeapon(PlayerPedId(),GetHashKey('WEAPON_PISTOL'),false) then
		table.insert(elements, {label = "<span style='color:;'>Standard Pistol</span>", value = "WEAPON_PISTOL"})
	end

	if HasPedGotWeapon(PlayerPedId(),GetHashKey('WEAPON_VINTAGEPISTOL'),false) then
		table.insert(elements, {label = "<span style='color:;'>Vintage Pistol</span>", value = "WEAPON_VINTAGEPISTOL"})
	end

	if HasPedGotWeapon(PlayerPedId(),GetHashKey('WEAPON_SNSPISTOL_MK2'),false) then
		table.insert(elements, {label = "<span style='color:;'>SNS Pistol</span>", value = "WEAPON_SNSPISTOL_MK2"})
	end

	if HasPedGotWeapon(PlayerPedId(),GetHashKey('WEAPON_COMBATPISTOL'),false) then
		table.insert(elements, {label = "<span style='color:red;'>Combat Pistol</span>", value = "WEAPON_COMBATPISTOL"})
	end

	if HasPedGotWeapon(PlayerPedId(),GetHashKey('WEAPON_PISTOL50'),false) then
		table.insert(elements, {label = "<span style='color:red;'>.50 Pistol</span>", value = "WEAPON_PISTOL50"})
	end

	if HasPedGotWeapon(PlayerPedId(),GetHashKey('WEAPON_MICROSMG'),false) then
		table.insert(elements, {label = "<span style='color:red;'>Micro SMG</span>", value = "WEAPON_MICROSMG"})
	end

	if HasPedGotWeapon(PlayerPedId(),GetHashKey('WEAPON_SMG'),false) then
		table.insert(elements, {label = "<span style='color:red;'>SMG</span>", value = "WEAPON_SMG"})
	end

	if HasPedGotWeapon(PlayerPedId(),GetHashKey('WEAPON_ASSAULTSMG'),false) then
		table.insert(elements, {label = "<span style='color:red;'>Assault SMG</span>", value = "WEAPON_ASSAULTSMG"})
	end

	if HasPedGotWeapon(PlayerPedId(),GetHashKey('WEAPON_SPECIALCARBINE'),false) then
		table.insert(elements, {label = "<span style='color:red;'>Assault Carbine</span>", value = "WEAPON_SPECIALCARBINE"})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'componentmenu', {
		["title"] = '',
		["align"] = 'top-left',
		["css"] = 'ammo',
	elements = elements
	}, function(data, menu)
		OpenSingleComponentMenu(data.current.label, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenSingleComponentMenu(s_label, s_value)
	local elements = {}
	local weaponHash = GetHashKey(s_value)

	if s_value == "WEAPON_PISTOL" then
		table.insert(elements, {label = "Ammo x30 <span style='color:green;'>(£200)</span>", ammo = true, price = 200})
		table.insert(elements, {label = "Extended Magazine <span style='color:green;'>(£500)</span>", component = "COMPONENT_PISTOL_CLIP_02", price = 500})
		table.insert(elements, {label = "Supressor <span style='color:green;'>(£750)</span>", component = "COMPONENT_AT_PI_SUPP_02", price = 750})
		table.insert(elements, {label = "Flashlight <span style='color:green;'>(£500)</span>", component = "COMPONENT_AT_PI_FLSH", price = 500})
	end

	if s_value == "WEAPON_VINTAGEPISTOL" then
		table.insert(elements, {label = "Ammo x30 <span style='color:green;'>(£200)</span>", ammo = true, price = 200})
		table.insert(elements, {label = "Extended Magazine <span style='color:green;'>(£500)</span>", component = "COMPONENT_VINTAGEPISTOL_CLIP_02", price = 500})
		table.insert(elements, {label = "Supressor <span style='color:green;'>(£750)</span>", component = "COMPONENT_AT_PI_SUPP", price = 750})
	end

	if s_value == "WEAPON_PISTOL50" then
		table.insert(elements, {label = "Ammo x30 <span style='color:green;'>(£200)</span>", ammo = true, price = 200})
		table.insert(elements, {label = "Extended Magazine <span style='color:green;'>(£500)</span>", component = "COMPONENT_PISTOL50_CLIP_02", price = 500})
		table.insert(elements, {label = "Supressor <span style='color:green;'>(£750)</span>", component = "COMPONENT_AT_AR_SUPP_02", price = 750})
		table.insert(elements, {label = "Flashlight <span style='color:green;'>(£500)</span>", component = "COMPONENT_AT_PI_FLSH", price = 500})
	end

	if s_value == "WEAPON_SNSPISTOL_MK2" then
		table.insert(elements, {label = "Ammo x30 <span style='color:green;'>(£200)</span>", ammo = true, price = 200})
		table.insert(elements, {label = "Extended Magazine <span style='color:green;'>(£500)</span>", component = "COMPONENT_SNSPISTOL_MK2_CLIP_02", price = 500})
		table.insert(elements, {label = "Supressor <span style='color:green;'>(£750)</span>", component = "COMPONENT_AT_PI_SUPP_02", price = 750})
		table.insert(elements, {label = "Flashlight <span style='color:green;'>(£500)</span>", component = "COMPONENT_AT_PI_FLSH_03", price = 500})
	end

	if s_value == "WEAPON_COMBATPISTOL" then
		table.insert(elements, {label = "Ammo x30 <span style='color:green;'>(£200)</span>", ammo = true, price = 200})
		table.insert(elements, {label = "Extended Magazine 1 <span style='color:green;'>(£500)</span>", component = "COMPONENT_COMBATPISTOL_CLIP_02", price = 500})
		table.insert(elements, {label = "Supressor <span style='color:green;'>(£750)</span>", component = "COMPONENT_AT_PI_SUPP", price = 750})
		table.insert(elements, {label = "Flashlight <span style='color:green;'>(£500)</span>", component = "COMPONENT_AT_PI_FLSH", price = 500})
	end

	if s_value == "WEAPON_SMG" then
		table.insert(elements, {label = "Ammo x30 <span style='color:green;'>(£400)</span>", ammo = true, price = 400})
		table.insert(elements, {label = "Extended Magazine 1 <span style='color:green;'>(£500)</span>", component = "COMPONENT_SMG_CLIP_02", price = 750})
		--table.insert(elements, {label = "Extended Magazine (Drum) <span style='color:green;'>(£500)</span>", component = "COMPONENT_SMG_CLIP_03", price = 1000}) -- Drum mag
		table.insert(elements, {label = "Supressor <span style='color:green;'>(£750)</span>", component = "COMPONENT_AT_PI_SUPP", price = 750})
		table.insert(elements, {label = "Flashlight <span style='color:green;'>(£500)</span>", component = "COMPONENT_AT_AR_FLSH", price = 500})
		table.insert(elements, {label = "Scope (Macro 02) <span style='color:green;'>(£500)</span>", component = "COMPONENT_AT_SCOPE_MACRO_02", price = 500})
	end

	if s_value == "WEAPON_MICROSMG" then
		table.insert(elements, {label = "Ammo x30 <span style='color:green;'>(£300)</span>", ammo = true, price = 300})
		table.insert(elements, {label = "Extended Magazine <span style='color:green;'>(£500)</span>", component = "COMPONENT_MICROSMG_CLIP_02", price = 500})
		table.insert(elements, {label = "Supressor <span style='color:green;'>(£700)</span>", component = "COMPONENT_AT_AR_SUPP_02", price = 750})
		table.insert(elements, {label = "Flashlight <span style='color:green;'>(£500)</span>", component = "COMPONENT_AT_PI_FLSH", price = 500})
		table.insert(elements, {label = "Scope (Macro) <span style='color:green;'>(£500)</span>", component = "COMPONENT_AT_SCOPE_MACRO", price = 500})
	end

	if s_value == "WEAPON_ASSAULTSMG" then
		table.insert(elements, {label = "Ammo x30 <span style='color:green;'>(£500)</span>", ammo = true, price = 500})
		table.insert(elements, {label = "Extended Magazine <span style='color:green;'>(£500)</span>", component = "COMPONENT_ASSAULTSMG_CLIP_02", price = 500})
		table.insert(elements, {label = "Supressor <span style='color:green;'>(£750)</span>", component = "COMPONENT_AT_AR_SUPP_02", price = 750})
		table.insert(elements, {label = "Flashlight <span style='color:green;'>(£500)</span>", component = "COMPONENT_AT_AR_FLSH", price = 500})
		table.insert(elements, {label = "Scope (Macro) <span style='color:green;'>(£1250)</span>", component = "COMPONENT_AT_SCOPE_MACRO", price = 1250})
	end

	if s_value == "WEAPON_SPECIALCARBINE" then
		table.insert(elements, {label = "Ammo x30 <span style='color:green;'>(£700)</span>", ammo = true, price = 700})
		table.insert(elements, {label = "Extended Magazine <span style='color:green;'>(£500)</span>", component = "COMPONENT_SPECIALCARBINE_CLIP_02", price = 500})
		table.insert(elements, {label = "Supressor <span style='color:green;'>(£750)</span>", component = "COMPONENT_AT_AR_SUPP_02", price = 750})
		table.insert(elements, {label = "Flashlight <span style='color:green;'>(£500)</span>", component = "COMPONENT_AT_AR_FLSH", price = 500})
		table.insert(elements, {label = "Scope (Medium) <span style='color:green;'>(900)</span>", component = "COMPONENT_AT_SCOPE_MEDIUM", price = 900})
		table.insert(elements, {label = "Grip <span style='color:green;'>(£1500)</span>", component = "COMPONENT_AT_AR_AFGRIP", price = 1500})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'singlecomponentmenu', {
		["title"] = '',
		["align"] = 'top-left',
		["css"] = 'ammo',
	elements = elements
	}, function(data, menu)
		if data.current.ammo == true then
			ESX.TriggerServerCallback("rpuk_weaponshop:validatePurchase", function(errorMessage)
				DrawBusySpinner("Validating...")
				Citizen.Wait(750)

				if errorMessage then
					DrawBusySpinner(errorMessage)
					Citizen.Wait(750)
				else
					DrawBusySpinner("Validation completed...")
					PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
				end

				RemoveLoadingPrompt()
			end, data.current.price, s_value)
		else
			ESX.TriggerServerCallback("rpuk_weaponshop:validatePurchase", function(errorMessage)
				DrawBusySpinner("Validating...")
				Citizen.Wait(750)

				if errorMessage then
					DrawBusySpinner(errorMessage)
					Citizen.Wait(750)
				else
					DrawBusySpinner("Validation completed...")
					PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
					GiveWeaponComponentToPed(PlayerPedId(), weaponHash, GetHashKey(data.current.component))
				end

				RemoveLoadingPrompt()
			end, data.current.price)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenAccessoriesMenu()
	local elements = {
		{ label = "Remove All Armour", value = 'remove' },
		{ label = "Add Armour: 25% (<span style='color:green;'>£125</span>)", value = 'armour', price = 125, armour = 25 },
		{ label = "Add Armour: 50% (<span style='color:green;'>£240</span>)", value = 'armour', price = 240, armour = 50 },
		{ label = "Add Armour: 75% (<span style='color:green;'>£350</span>)", value = 'armour', price = 350, armour = 75 },
		{ label = "Add Armour: 100% (<span style='color:green;'>£400</span>)", value = 'armour', price = 400, armour = 100 }
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vestplayermenu', {
		["title"] = '',
		["align"] = 'top-left',
		["css"] = 'ammo',
	elements = elements
	}, function(data, menu)
		if data.current.value == 'remove' then
			SetPedArmour(cachedData["ped"], 0)
		else
			ESX.TriggerServerCallback("rpuk_weaponshop:validatePurchase", function(errorMessage)
				DrawBusySpinner("Validating...")
				Citizen.Wait(750)

				if errorMessage then
					DrawBusySpinner(errorMessage)
					Citizen.Wait(750)
				else
					DrawBusySpinner("Validation completed...")
					PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
					AddArmourToPed(cachedData.ped, data.current.armour)
				end

				RemoveLoadingPrompt()
			end, data.current.price)
		end
	end, function(data, menu)
		menu.close()
	end)
end

OpenWeaponMenu_Melee = function(storeData2) --	OpenWeaponMenu_Melee(shopData)
	InitiateCamera(storeData2)
	local menuElements = GetMeleeWeaponMenuElements(Config.DefaultMeleeWeapon["model"])
	InitiateWeapon(storeData2["object"]["position"], Config.DefaultMeleeWeapon)

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "weapon_clerk", {
		["title"] = '',
		["align"] = 'top-left',
		["css"] = 'ammo',
		["elements"] = menuElements
	}, function(menuData, menuHandle)
		local current = menuData["current"]

		if current["name"] == "ammo" then
			ESX.TriggerServerCallback("rpuk_weaponshop:validatePurchase", function(errorMessage)
				DrawBusySpinner("Validating...")
				Citizen.Wait(750)

				if errorMessage then
					DrawBusySpinner(errorMessage)
					Citizen.Wait(750)
				else
					DrawBusySpinner("Validation completed...")
					PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
				end

				RemoveLoadingPrompt()
			end, current["price"], currentWeapon["model"])
		else
			cachedData["purchasing"] = true

			ConfirmPurchase(function(totalPayment)
				if totalPayment then
					ESX.TriggerServerCallback("rpuk_weaponshop:validatePurchase", function(errorMessage)
						DrawBusySpinner("Validating...")
						Citizen.Wait(750)

						if errorMessage then
							DrawBusySpinner(errorMessage)
							Citizen.Wait(750)
						else
							DrawBusySpinner("Validation completed...")
							PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
							menuHandle.close()
							HandOverWeapon(storeData2)
						end

						RemoveLoadingPrompt()
					end, totalPayment, cachedData["currentWeapon"]["model"])
				end
			end)
		end
	end, function(menuData, menuHandle)
		PlaySoundFrontend(-1, "BACK", "HUD_AMMO_SHOP_SOUNDSET", true)

		menuHandle.close()

		DeleteCamera()
		DeleteWeapon(cachedData["weaponObject"])
	end, function(menuData, menuHandle)
		local currentElement = menuData["current"]

		PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", true)

		local weaponObject = cachedData["weaponObject"]

		if currentElement["name"] == "weapon_slider" then
			local lastWeapon = cachedData["currentWeapon"]
			local currentWeapon = Config.MeleeWeapons[currentElement["value"] + 1]

			if currentWeapon["model"] == lastWeapon["model"] then return end

			menuData["elements"] = GetMeleeWeaponMenuElements(currentWeapon["model"], currentElement)
			-- menuHandle.setElements(menuData["elements"])
			menuHandle.refresh()

			InitiateWeapon(storeData2["object"]["position"], currentWeapon)
		elseif currentElement["name"] == "weapon_component" then
			HandleComponentElement(currentElement)
		elseif currentElement["name"] == "weapon_tint" then
			local tintValue = currentElement["value"]
			SetWeaponObjectTintIndex(weaponObject, tintValue)

			if tintValue > 0 then
				cachedData["attachedComponents"]["tint"] = {["price"] = 500}
			else
				cachedData["attachedComponents"]["tint"] = nil
			end
		end
	end)
end

OpenWeaponMenu_Ranged = function(storeData) --	OpenWeaponMenu_Ranged(shopData)
	InitiateCamera(storeData)
	local menuElements = GetWeaponMenuElements(Config.DefaultWeapon["model"])
	InitiateWeapon(storeData["object"]["position"], Config.DefaultWeapon)

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "weapon_clerk", {
		["title"] = '',
		["align"] = 'top-left',
		["css"] = 'ammo',
		["elements"] = menuElements
	}, function(menuData, menuHandle)
		local current = menuData["current"]

		if current["name"] == "ammo" then
			ESX.TriggerServerCallback("rpuk_weaponshop:validatePurchase", function(errorMessage)
				DrawBusySpinner("Validating...")
				Citizen.Wait(750)

				if errorMessage then
					DrawBusySpinner(errorMessage)
					Citizen.Wait(750)
				else
					DrawBusySpinner("Validation completed...")
					PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
				end

				RemoveLoadingPrompt()
			end, current["price"], currentWeapon["model"])
		else
			cachedData["purchasing"] = true

			ConfirmPurchase(function(totalPayment)
				if totalPayment then
					ESX.TriggerServerCallback("rpuk_weaponshop:validatePurchase", function(errorMessage)
						DrawBusySpinner("Validating...")
						Citizen.Wait(750)

						if errorMessage then
							DrawBusySpinner(errorMessage)
							Citizen.Wait(750)
						else
							DrawBusySpinner("Validation completed...")
							PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
							menuHandle.close()
							HandOverWeapon(storeData)
						end

						RemoveLoadingPrompt()
					end, totalPayment, cachedData["currentWeapon"]["model"])
				end
			end)
		end
	end, function(menuData, menuHandle)
		PlaySoundFrontend(-1, "BACK", "HUD_AMMO_SHOP_SOUNDSET", true)
		menuHandle.close()
		DeleteCamera()
		DeleteWeapon(cachedData["weaponObject"])
	end, function(menuData, menuHandle)
		local currentElement = menuData["current"]

		PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", true)

		local weaponObject = cachedData["weaponObject"]

		if currentElement["name"] == "weapon_slider" then
			local lastWeapon = cachedData["currentWeapon"]

			local currentWeapon = Config.Weapons[currentElement["value"] + 1]

			if currentWeapon["model"] == lastWeapon["model"] then return end

			menuData["elements"] = GetWeaponMenuElements(currentWeapon["model"], currentElement)

			 -- menuHandle.setElements(menuData["elements"])

			menuHandle.refresh()

			InitiateWeapon(storeData["object"]["position"], currentWeapon)
		elseif currentElement["name"] == "weapon_component" then
			HandleComponentElement(currentElement)
		elseif currentElement["name"] == "weapon_tint" then
			local tintValue = currentElement["value"]

			SetWeaponObjectTintIndex(weaponObject, tintValue)

			if tintValue > 0 then
				cachedData["attachedComponents"]["tint"] = {
					["price"] = 500
				}
			else
				cachedData["attachedComponents"]["tint"] = nil
			end
		end
	end)
end

ConfirmPurchase = function(callback)
	local menuElements = {
		{
			["label"] = "Validate purchase",
			["action"] = "yes"
		},
		{
			["label"] = "Cancel purchase",
			["action"] = "no"
		}
	}

	local currentWeapon = cachedData["currentWeapon"]

	local totalCost = currentWeapon["price"]

	for componentType, attachedComponentData in pairs(cachedData["attachedComponents"]) do
		totalCost = totalCost + attachedComponentData["price"]
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "weapon_clerk_confirm", {
		["title"] = "Total cost: £" .. ESX.Math.GroupDigits(totalCost),
		["align"] = 'top-left',
		["css"] = 'rpuk',
		["elements"] = menuElements
	}, function(menuData, menuHandle)
		local currentAction = menuData["current"]["action"]
		menuHandle.close()
		callback(currentAction == "yes" and totalCost or false)
	end, function(menuData, menuHandle)
		menuHandle.close()
	end)
end

HandleComponentElement = function(currentElement)
	local weaponObject = cachedData["weaponObject"]
	local currentWeapon = cachedData["currentWeapon"]
	local componentLocation = currentElement["component"]
	local componentIndex = currentElement["value"]
	local attachedComponent = cachedData["attachedComponents"][componentLocation]

	if attachedComponent then
		RemoveWeaponComponentFromWeaponObject(weaponObject, GetHashKey(attachedComponent["component"]))
		attachedComponent = false
	end

	if componentIndex == 0 then
		return
	end

	local componentData = Config.WeaponComponents[currentWeapon["model"]][componentLocation][componentIndex]
	cachedData["attachedComponents"][componentLocation] = componentData
	GiveWeaponComponentToWeaponObject(weaponObject, GetHashKey(componentData["component"]))
end

GetWeaponMenuElements = function(weaponModel, weaponElement)
	local ammoPrice = Config.AmmoTypes[GetPedAmmoTypeFromWeapon(cachedData["ped"], GetHashKey(Config.Weapons[weaponElement and weaponElement["value"] + 1 or 1]["model"]))] * 30

	local menuElements = {
		{
			["name"] = "weapon_slider",
			["label"] = "Weapon",
			["max"] = #Config.Weapons -1,
			["min"] = 0,
			["value"] = weaponElement and weaponElement["value"] or 0,
			["type"] = "slider",
			["options"] = {}
		}
		--[[{
			["name"] = "ammo",
			["label"] = "Buy 30 rounds £" .. ammoPrice,
			["price"] = ammoPrice
		}]]
	}

	for weaponIndex, weaponData in ipairs(Config.Weapons) do
		table.insert(menuElements[1]["options"], GetWeaponLabel(weaponData["model"]) .. " | £" .. weaponData["price"])
	end

	for componentLocation, weaponComponents in pairs(Config.WeaponComponents[string.upper(weaponModel)]) do
		local componentElement = {
			["name"] = "weapon_component",
			["component"] = componentLocation,
			["label"] = componentLocation,
			["max"] = #weaponComponents,
			["min"] = 0,
			["value"] = 0,
			["type"] = "slider",
			["options"] = {
				"None"
			}
		}

		for componentIndex, componentData in ipairs(weaponComponents) do
			table.insert(componentElement["options"], "£" .. componentData["price"])
		end

		table.insert(menuElements, componentElement)
	end

	local componentElement = {
		["name"] = "weapon_tint",
		["label"] = "Tint",
		["max"] = GetWeaponTintCount(GetHashKey(weaponModel)) - 1,
		["min"] = 0,
		["value"] = 0,
		["type"] = "slider"
	}

	table.insert(menuElements, componentElement)

	return menuElements
end

GetMeleeWeaponMenuElements = function(weaponModel, weaponElement)

	local menuElements = {
		{
			["name"] = "weapon_slider",
			["label"] = "Weapon",
			["max"] = #Config.MeleeWeapons - 1,
			["min"] = 0,
			["value"] = weaponElement and weaponElement["value"] or 0,
			["type"] = "slider",
			["options"] = {}
		}
	}

	for weaponIndex, weaponData in ipairs(Config.MeleeWeapons) do
		table.insert(menuElements[1].options, ('%s | <span style="color:green;">£%s</span>')
			:format(GetWeaponLabel(weaponData.model), ESX.Math.GroupDigits(weaponData.price)))
	end

	for componentLocation, MeleeWeaponComponents in pairs(Config.MeleeWeaponComponents[string.upper(weaponModel)]) do
		local componentElement = {
			["name"] = "weapon_component",
			["component"] = componentLocation,
			["label"] = componentLocation,
			["max"] = #MeleeWeaponComponents,
			["min"] = 0,
			["value"] = 0,
			["type"] = "slider",
			["options"] = {
				"None"
			}
		}

		for componentIndex, componentData in ipairs(MeleeWeaponComponents) do
			table.insert(componentElement["options"], "£" .. componentData["price"])
		end

		table.insert(menuElements, componentElement)
	end

	local componentElement = {
		["name"] = "weapon_tint",
		["label"] = "Tint",
		["max"] = GetWeaponTintCount(GetHashKey(weaponModel)) - 1,
		["min"] = 0,
		["value"] = 0,
		["type"] = "slider"
	}

	table.insert(menuElements, componentElement)

	return menuElements
end

SpawnClerks = function()
	cachedData["clerks"] = {}

	for shopIndex, shopData in ipairs(Config.WeaponShops) do
		WaitForModel(shopData["clerk"]["model"])

		local pedHandle = CreatePed(5, shopData["clerk"]["model"], shopData["clerk"]["position"], shopData["clerk"]["heading"], false)

		SetEntityAsMissionEntity(pedHandle, true, true)
		SetBlockingOfNonTemporaryEvents(pedHandle, true)

		cachedData["clerks"][shopData["name"]] = pedHandle

		SetModelAsNoLongerNeeded(shopData["clerk"]["model"])
	end
end

HandOverWeapon = function(storeData)
	DeleteCamera()

	local weaponModel = cachedData["currentWeapon"]["model"]

	local weaponObject = cachedData["weaponObject"]
	local clerkHandle = cachedData["clerks"][storeData["name"]]

	TaskTurnPedToFaceEntity(cachedData["ped"], clerkHandle, 500)

	GiveWeaponObjectToPed(weaponObject, cachedData["ped"])
	GiveWeaponObjectToPed(weaponObject, clerkHandle)

	SetCurrentPedWeapon(cachedData["ped"], GetHashKey("WEAPON_UNARMED"), true)
	SetCurrentPedWeapon(clerkHandle, GetHashKey("WEAPON_UNARMED"), true)

	local anim = "rifle"

	if GetWeapontypeGroup(weaponModel) == 416676503 then
		anim = "pistol"
	end

	PlayAnimation(clerkHandle, "mp_cop_armoury", anim .. "_on_counter_cop")

	Wait(1100)

	SetCurrentPedWeapon(clerkHandle, GetHashKey(weaponModel), true)

	PlayAnimation(cachedData["ped"], "mp_cop_armoury", anim .. "_on_counter")

	Wait(3100)

	RemoveWeaponFromPed(clerkHandle, GetHashKey(weaponModel))


	Citizen.Wait(60)

	SetCurrentPedWeapon(cachedData["ped"], GetHashKey(weaponModel), true)

	cachedData["purchasing"] = false
end

InitiateCamera = function(storeData)
	SetEntityCoords(cachedData["ped"], storeData["clerkMarker"]["position"] - vector3(0.0, 0.0, 0.985))
	SetEntityHeading(cachedData["ped"], storeData["clerkMarker"]["heading"])

	cachedData["weaponCamera"] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

	local camInformation = storeData["camera"]

	SetCamCoord(cachedData["weaponCamera"], camInformation["x"], camInformation["y"], camInformation["z"])
	SetCamRot(cachedData["weaponCamera"], camInformation["rotationX"], camInformation["rotationY"], camInformation["rotationZ"])

	RenderScriptCams(true, true, 500)
end

DeleteCamera = function()
	RenderScriptCams(false, true, 500)

	while IsCamRendering(cachedData["weaponCamera"]) do
		Citizen.Wait(0)
	end

	DestroyCam(cachedData["weaponCamera"])
end

DeleteWeapon = function(entity)
	if DoesEntityExist(entity) then
		DeleteEntity(entity)
	end
end

InitiateWeapon = function(weaponLocation, weaponData)
	cachedData["attachedComponents"] = {}

	local lastRotation = vector3(0.0, 0.0, 0.0)

	if DoesEntityExist(cachedData["weaponObject"]) then
		lastRotation = GetEntityRotation(cachedData["weaponObject"])

		DeleteEntity(cachedData["weaponObject"])
	end

	cachedData["currentWeapon"] = weaponData

	local weaponModel = GetHashKey(weaponData["model"])

	RequestWeaponAsset(weaponModel, 31, 0)

	while not HasWeaponAssetLoaded(weaponModel) do
		Citizen.Wait(0)
	end

	local weaponObject = CreateWeaponObject(weaponModel, Config.DefaultAmmo or 120, weaponLocation, false, 0.0, false)

	SetEntityRotation(weaponObject, lastRotation)

	FreezeEntityPosition(weaponObject, true)

	cachedData["weaponObject"] = weaponObject

	Citizen.CreateThread(function()
		while DoesEntityExist(weaponObject) and ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), "weapon_clerk") do
			Citizen.Wait(5)

			SetEntityRotation(weaponObject, GetEntityRotation(weaponObject) + vector3(0.0, 0.0, 0.6))
		end

		while cachedData["purchasing"] do
			Citizen.Wait(0)
		end

		DeleteWeapon(weaponObject)
	end)
end

DrawScriptMarker = function(markerData)
	DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["size"] or vector3(1.0, 1.0, 1.0), markerData["color"] or vector3(150, 150, 150), 100, false, true, 2, false, false, false, false)
end

PlayAnimation = function(ped, dict, anim, settings)
	if dict then
		Citizen.CreateThread(function()
			RequestAnimDict(dict)

			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(100)
			end

			if settings == nil then
				TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
			else
				local speed = 1.0
				local speedMultiplier = -1.0
				local duration = 1.0
				local flag = 0
				local playbackRate = 0

				if settings["speed"] then
					speed = settings["speed"]
				end

				if settings["speedMultiplier"] then
					speedMultiplier = settings["speedMultiplier"]
				end

				if settings["duration"] then
					duration = settings["duration"]
				end

				if settings["flag"] then
					flag = settings["flag"]
				end

				if settings["playbackRate"] then
					playbackRate = settings["playbackRate"]
				end

				TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
			end

			RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

FadeOut = function(duration)
	DoScreenFadeOut(duration)

	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end
end

FadeIn = function(duration)
	DoScreenFadeIn(500)

	while not IsScreenFadedIn() do
		Citizen.Wait(0)
	end
end

WaitForModel = function(model)
	if not IsModelValid(model) then
		return
	end

	if not HasModelLoaded(model) then
		RequestModel(model)
	end

	while not HasModelLoaded(model) do
		Citizen.Wait(1000)
	end
end

DrawBusySpinner = function(text)
	SetLoadingPromptTextEntry("STRING")
	AddTextComponentSubstringPlayerName(text)
	ShowLoadingPrompt(3)
end

GetWeaponLabel = function(weaponModel)
	for itemIndex, itemData in ipairs(ESX.Player.GetInventory()) do
		if string.lower(itemData["name"]) == string.lower(weaponModel) then
			return itemData["label"]
		end
	end

	if ESX.GetWeaponLabel(weaponModel) then return ESX.GetWeaponLabel(weaponModel) end

	return weaponModel
end