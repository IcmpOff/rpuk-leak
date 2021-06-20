occupied = false
ds = {
	signup_points = {
		--{model = "u_f_m_drowned_01", location = vector4(246.22, -888.62, 29.49, 28.63), anim = {"WORLD_HUMAN_CLIPBOARD"}, type = "sign_up", event = "purge", spawned = false, text = "| ~r~Server Purge Event~s~ |\n[~g~E~s~] To Sign Up"}, -- legion
		--{model = "u_f_m_drowned_01", location = vector4(297.68, -591.77, 42.28, 278.33), anim = {"WORLD_HUMAN_CLIPBOARD"}, type = "sign_up", event = "purge", spawned = false, text = "| ~r~Server Purge Event~s~ |\n[~g~E~s~] To Sign Up"}, -- pillbox
		--{model = "u_f_m_drowned_01", location = vector4(-1106.94, -838.76, 18.00, 301.07), anim = {"WORLD_HUMAN_CLIPBOARD"}, type = "sign_up", event = "purge", spawned = false, text = "| ~r~Server Purge Event~s~ |\n[~g~E~s~] To Sign Up"}, -- vesp police
		{model = "s_m_y_clown_01", location = vector4(329.15, -2040.70, 19.83, 338.37), anim = {"rcmnigel1bnmt_1b", "dance_loop_tyler"}, type = "vendor", event = "masks", spawned = false, text = "| ~r~Halloween Token Vendor~s~ |\n[~g~E~s~] To Browse Masks"},
		{model = "s_m_y_clown_01", location = vector4(321.920, -2035.29, 19.67, 323.31), anim = {"anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", "low_center_down"}, type = "vendor", event = "tops", spawned = false, text = "| ~r~Halloween Token Vendor~s~ |\n[~g~E~s~] To Browse Tops"},
		{model = "s_m_y_clown_01", location = vector4(334.67, -2034.99, 20.19, 108.91), anim = {"move_clown@p_m_zero_idles@", "fidget_short_dance"}, type = "vendor", event = "hats", spawned = false, text = "| ~r~Halloween Token Vendor~s~ |\n[~g~E~s~] To Browse Hats"},	
		--{model = "ig_trafficwarden", location = vector4(215.71, -917.81, 52.71, 323.57), anim = {"rcmnigel1bnmt_1b", "dance_loop_tyler"}, type = "sign_up", event = "purge", spawned = false, text = "| ~r~Server Purge Event~s~ |\n[~g~E~s~] To Sign Up"},
		{model = "ig_johnnyklebitz", location = vector4(990.97, -97.15, 73.85, 129.24), anim = {"timetable@ron@ig_3_couch", "base"}, type = "lost_model", event = "hats", spawned = false, text = "| ~r~Johnny Klebitz~s~ |\n[~g~E~s~] To Speak"},	
	}
}

RegisterNetEvent('rpuk_halloween:event_menu')
AddEventHandler('rpuk_halloween:event_menu', function()
	openMenu()
end)

function openMenu()
	local elements = {}

	table.insert(elements, {label = '<strong>Change Player Model</strong>', value = '', extra = ""})
	table.insert(elements, {label = 'Your Player', value = 'default'})
	table.insert(elements, {label = 'Clown', value = 'model', extra = "s_m_y_clown_01"})
	table.insert(elements, {label = 'Pennywise', value = 'model', extra = "ig_trafficwarden"})
	table.insert(elements, {label = 'Chucky', value = 'model', extra = "u_m_y_imporage"})
	table.insert(elements, {label = 'Skeleton', value = 'model', extra = "u_f_m_drowned_01"})
	table.insert(elements, {label = 'Headless Biker', value = 'model', extra = "ig_johnnyklebitz"})
	table.insert(elements, {label = 'Cat', value = 'model', extra = "a_c_cat_01"})
	table.insert(elements, {label = 'Mime', value = 'model', extra = "s_m_y_mime"})
	table.insert(elements, {label = 'Doctor', value = 'model', extra = "s_m_m_doctor_01"})
	table.insert(elements, {label = 'Alien', value = 'model', extra = "s_m_m_movalien_01"})
	table.insert(elements, {label = '<strong></strong>', value = '', extra = ""})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'event_menu', {
		title    = "",
		css 	 =  'dev',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'model' then
			local model = data.current.extra
			if IsModelInCdimage(model) and IsModelValid(model) then
				RequestModel(model)
				while not HasModelLoaded(model) do Citizen.Wait(1000) end
				SetPlayerModel(PlayerId(-1), model)
				TriggerEvent('esx:restoreLoadout')
			end			
		elseif data.current.value == 'default' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local model = 'mp_f_freemode_01'
				if skin.sex == 0 then
					model = 'mp_m_freemode_01'
				end
				if IsModelInCdimage(model) and IsModelValid(model) then
					RequestModel(model)
					while not HasModelLoaded(model) do Citizen.Wait(1000) end
					SetPlayerModel(PlayerId(-1), model)
				end
				TriggerEvent('skinchanger:loadSkin', skin)
				TriggerEvent('esx:restoreLoadout')
			end)		
		end
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local canSleep = true
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			for i=1, #ds.signup_points, 1 do
				local distance = GetDistanceBetweenCoords(coords, ds.signup_points[i].location[1], ds.signup_points[i].location[2], ds.signup_points[i].location[3], true)
				if distance < 50.0 and not ds.signup_points[i].spawned then
					WaitForModel(ds.signup_points[i].model)
					local pedHandle = CreatePed(5, ds.signup_points[i].model, ds.signup_points[i].location[1], ds.signup_points[i].location[2], ds.signup_points[i].location[3] , ds.signup_points[i].location[4], false)
					SetEntityAsMissionEntity(pedHandle, true, true)
					SetBlockingOfNonTemporaryEvents(pedHandle, true)
					SetModelAsNoLongerNeeded(ds.signup_points[i].model)
					SetEntityCanBeDamaged(pedHandle, false)
					FreezeEntityPosition(pedHandle, true)
					if ds.signup_points[i].anim then
						if ds.signup_points[i].anim[2] then
							RequestAnimDict(ds.signup_points[i].anim[1])
							while not HasAnimDictLoaded(ds.signup_points[i].anim[1]) do
								Citizen.Wait(10)
							end
							TaskPlayAnim(pedHandle, ds.signup_points[i].anim[1], ds.signup_points[i].anim[2], 8.0, -8.0, -1, 3, 0.0, 0, 0, 0)
						else
							TaskStartScenarioInPlace(pedHandle, ds.signup_points[i].anim[1], 0, true)
						end
					end
					ds.signup_points[i].spawned = true
				elseif distance < 1.5 then
					local text_coord = vector3(ds.signup_points[i].location[1], ds.signup_points[i].location[2], ds.signup_points[i].location[3] + 1.3)
					ESX.Game.Utils.DrawText3D(text_coord, ds.signup_points[i].text, 0.8, 6)
					canSleep = false
					if IsControlJustReleased(0, 38) and not occupied then
						if ds.signup_points[i].type == "sign_up" then
							sign_up(ds.signup_points[i].event)
						elseif ds.signup_points[i].type == "vendor" then
							vendor_clothing(ds.signup_points[i].event)
						elseif ds.signup_points[i].type == "lost_model" then
							if ESX.Player.GetJobName() ~= "lost" then
								TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, action = 'longnotif', type = 'inform', text = "Get the fuck out of here... You aren't a member of the Lost..."})
								occupied = false
								return
							end
							local model = GetEntityModel(PlayerPedId())
							if model == GetHashKey("mp_f_freemode_01") or model == GetHashKey("mp_m_freemode_01") then
								if IsModelInCdimage("ig_johnnyklebitz") and IsModelValid("ig_johnnyklebitz") then
									RequestModel("ig_johnnyklebitz")
									while not HasModelLoaded("ig_johnnyklebitz") do Citizen.Wait(100) end
									SetPlayerModel(PlayerId(), 'ig_johnnyklebitz')
									SetPedDefaultComponentVariation(PlayerPedId())
									SetModelAsNoLongerNeeded('ig_johnnyklebitz')
									TriggerEvent('esx:restoreLoadout')
								end
							else
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
									TriggerEvent('esx:restoreLoadout')
								end)
							end
						end
					end

				end
			end
		if canSleep then
			Citizen.Wait(2000)
		end
	end
end)

function sign_up(event)
	occupied = true
	TriggerServerEvent('rpuk_halloween:event_signup', event)
	Citizen.Wait(5000)
	occupied = false
end