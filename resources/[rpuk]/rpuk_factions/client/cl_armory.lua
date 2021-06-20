RegisterNetEvent('rpuk_factions:openArmory')
AddEventHandler('rpuk_factions:openArmory', function(job)
	local dataType

	if ESX.Player.GetJobName() == "police" then
		dataType = ESX.Player.GetPoliceData()
	elseif ESX.Player.GetJobName() == "ambulance" then
		dataType = ESX.Player.GetNHSData()
	elseif ESX.Player.GetJobName() == "lost" then
		dataType = ESX.Player.GetLostData()
	else
		dataType = ESX.Player.GetCivJob()
	end

	local items = {}
	local weapons = {}
	local ammo = {}
	if Armory.AssignedLoadouts[job] then
		for k,v in pairs(Armory.AssignedLoadouts[job]) do
			if tonumber(dataType[v.flag]) >= v.level then
				if v.type == "item_standard" then
					table.insert(items, {
						label = v.label.. "<br>£"..v.price,
						name = v.item,
						count = 1,
						data = k
					})
				elseif v.type == "item_ammo" then
					table.insert(ammo, {
						label = v.label,
						name = v.item,
						count = 1,
						data = k
					})
				elseif v.type == "item_weapon" then
					table.insert(weapons, {
						label = v.label,
						name = v.item,
						count = 1,
						data = k
					})
				end
			end
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'error', text = 'No weapons are here.' })
		return
	end

	TriggerEvent("rpuk_inventory:openSecondaryInventory", {
		id = job,
		type = "rpuk_factions_locker",
		typeOfInventory = "store"
	}, {}, items, weapons, ammo)
end)

RegisterNetEvent('rpuk_factions:openAttachmentMenu')
AddEventHandler('rpuk_factions:openAttachmentMenu', function(job)
	local ped = PlayerPedId()
	if (ESX.Player.GetJobName() == "police" and tonumber(ESX.Player.GetPoliceData().firearms) >= 2) then
		local elements = {}

		for _, v in pairs(ESX.GetWeaponList()) do
			if HasPedGotWeapon(ped, GetHashKey(v.name)) and v.components[1] then
				table.insert(elements, {label = v.label, value = v})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_list', {
			title   = '',
			css =  job,
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				weapon_attachment_list(job, data.current.value)
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		TriggerEvent('mythic_notify:client:SendAlert', {length = 5000, type = 'error', text = 'You do not have permission to use attachments!' })
	end
end)

function weapon_attachment_list(job, weapon_data)
	local elements = {}
	for _, component in pairs(weapon_data.components) do
		if component.useInShop then
			table.insert(elements, {label = component.label, hash = component.hash, value = component, weapon = weapon_data.name})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_attachment_list', {
		title    = '',
		css =  job,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value then
			local weaponHash = data.current.weapon
			local attachHash = data.current.hash
			local hasAttachment = HasPedGotWeaponComponent(PlayerPedId(), weaponHash, attachHash)
			TriggerServerEvent('rpuk_factions:attachmentSelected', data.current.weapon, data.current.value.name, hasAttachment)
		end
	end, function(data, menu)
		menu.close()
	end)
end