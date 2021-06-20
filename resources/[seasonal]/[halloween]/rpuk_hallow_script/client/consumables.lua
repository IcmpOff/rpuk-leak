local potion_active = false

local effect_list = {
	["hallow_pot_1"] = {effect = "transform", array = {"s_m_y_clown_01", "s_m_m_movspace_01", "s_m_y_mime", "u_m_y_zombie_01"}},
	["hallow_pot_2"] = {effect = "transform", array = {"ig_trafficwarden", "u_f_m_drowned_01", "s_m_m_movalien_01"}},
	["hallow_pot_3"] = {effect = "stats", array = {"MP0_STAMINA", "MP0_LUNG_CAPACITY"}},
	["hallow_pot_4"] = {effect = "transform", array = {"u_m_y_imporage"}},
}

local strings = {
	["MP0_STAMINA"] = "stamina",
	["MP0_LUNG_CAPACITY"] = "lung capacity",
	["s_m_y_clown_01"] = "Local Clown",
	["s_m_m_movspace_01"] = "Local Spaceman",
	["s_m_y_mime"] = "Local Mimer",
	["u_m_y_zombie_01"] = "Local Zombie",
	["ig_trafficwarden"] = "Pennywise",
	["u_f_m_drowned_01"] = "Skeleton",
	["s_m_m_movalien_01"] = "Movie Alien",
	["u_m_y_imporage"] = "Chucky",
}

RegisterNetEvent('rpuk_halloween:use_potion')
AddEventHandler('rpuk_halloween:use_potion', function(potion)
	if effect_list[potion] then
		local rnd = math.random(1, tableLength(effect_list[potion].array))
		TriggerEvent("mythic_progbar:client:progress", {
			name = "consumingHalloween",
			duration = 6000,
			label = "Drinking Potion",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			  disableMovement = false,
			  disableCarMovement = true,
			  disableMouse = false,
			  disableCombat = true,
			  closeInv = true,
			},
			animation = {
				animDict = "mp_player_intdrink",
				anim = "loop_bottle",
				flags = 49,
				task = nil,
			},
			prop = {
				model = "v_res_r_lotion",
			}
		  }, function(status)
			if not status then
				if effect_list[potion].effect == "transform" then
					local model = effect_list[potion].array[rnd]
					if IsModelInCdimage(model) and IsModelValid(model) then
						RequestModel(model)
						while not HasModelLoaded(model) do Citizen.Wait(100) end
						SetPlayerModel(PlayerId(), model)
						SetPedDefaultComponentVariation(PlayerPedId())
						SetModelAsNoLongerNeeded(model)

						TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = ('Your player model has been changed temporarily to %s'):format(strings[effect_list[potion].array[rnd]])})
						TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = "To revert to your character model use the command /cancel_potion"})
						TriggerEvent('esx:restoreLoadout')
						potion_active = true
					end
				elseif effect_list[potion].effect == "stats" then
					StatSetInt(effect_list[potion].array[rnd], 25, true)
					TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = ('Your %s has been temporarily increased!'):format(strings[effect_list[potion].array[rnd]])})
				end		
			elseif status then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'You have stopped drinking the potion!' })
				TriggerServerEvent('returnItem', itemName)
			end
		end)
	end
end)

RegisterCommand("cancel_potion", function(source, args, rawCommand)
    if potion_active then
		TriggerEvent('skinchanger:getSkin', function(skin)
			local model = 'mp_f_freemode_01'
			if skin.sex == 0 then
				model = 'mp_m_freemode_01'
			end
			if IsModelInCdimage(model) and IsModelValid(model) then
				RequestModel(model)
				while not HasModelLoaded(model) do Citizen.Wait(100) end
				SetPlayerModel(PlayerId(), model)
				SetPedDefaultComponentVariation(PlayerPedId())
				SetModelAsNoLongerNeeded(model)
			end
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
		TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = "Your player model has been reset"})
		TriggerEvent('esx:restoreLoadout')
		potion_active = false
	else
		TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = "You need an active potion effect to use this command!"})
	end
end, false)
