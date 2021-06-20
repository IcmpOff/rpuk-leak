local IsHandcuffed	= false
local isZiptied = false
local DragStatus	= {}
local arrest	 = false
local arrested = false
local surrender = false
DragStatus.IsDragged = false
local isSearching = nil

RegisterNetEvent('rpuk_restrain:handcuff')
RegisterNetEvent('rpuk_restrain:unrestrain')
RegisterNetEvent('rpuk_restrain:registerIsSearching')
RegisterNetEvent('rpuk_restrain:drag')
RegisterNetEvent('rpuk_restrain:removefromVehicle')
RegisterNetEvent('rpuk_restrain:putplayerInVehicle')
RegisterNetEvent('rpuk_restrain:arrested')
RegisterNetEvent('rpuk_restrain:arrest')
RegisterNetEvent('rpuk_restrain:ziptied')
RegisterNetEvent('rpuk_restrain:ziptiedAnim')
RegisterNetEvent('rpuk_restrain:ziptieingAnim')
RegisterNetEvent('rpuk_restrain:pickLock')
RegisterNetEvent('rpuk_restain:pickLockProgress')
RegisterNetEvent('rpuk_restain:restrainMethod')
RegisterNetEvent('rpuk_restain:dragFromMenu')
RegisterNetEvent('rpuk_restrain:unRestrainAnim')
RegisterNetEvent('rpuk_restrain:detachDrag')
RegisterNetEvent("rpuk_inventory:inventorySatus")
RegisterNetEvent('rpuk_restrain:removeZiptie')
RegisterNetEvent('rpuk_restrain:removeZiptieAnim')


AddEventHandler('playerSpawned', function(spawn)
	TriggerEvent('rpuk_restrain:unrestrain')
end)

AddEventHandler('esx:onPlayerDeath', function()
	surrender = false
	DragStatus.IsDragged = false
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('rpuk_restrain:unrestrain')
		surrender = false
	end
end)

RegisterKeyMapping('+handsup', 'Hands Up (Hold)', 'keyboard', 'x')

RegisterCommand('+handsup', function()
	local dict = "random@mugging3"
	DisablePlayerFiring(PlayerPedId(), true)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
	TaskPlayAnim(PlayerPedId(), dict, "handsup_standing_base", 2.0, -2.0, -1, 49, 0.0, false, false, false)
	surrender = true
end)

RegisterCommand('-handsup', function()
	surrender = false
	ClearPedTasks(PlayerPedId())
	DisablePlayerFiring(PlayerPedId(), false)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		DisableControlAction(0, 140, true) -- Disable R throw much always

		if IsPedOnFoot(PlayerPedId()) then
			if IsControlPressed(0, 19) and IsInputDisabled(0) then -- Holding ALT
				if IsDisabledControlJustReleased(0,140) then -- Restrain // r
					TriggerEvent("rpuk_restain:restrainMethod", "handcuff")
				end
			elseif IsControlPressed(0, 61) and IsInputDisabled(0) then -- Holding shift
				if IsControlJustPressed(0,183) then -- Escort // g
					TriggerEvent("rpuk_restain:dragFromMenu")
				end
			end
		end

		--- Z Cancel Animations
		if IsControlJustReleased(0, 20) then
			if not IsHandcuffed and not isZiptied and not surrender then
				ClearPedTasks(PlayerPedId())
			end
		end
	end
end)

AddEventHandler('rpuk_restain:restrainMethod', function(type)
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
	local playerPed = GetPlayerPed(closestPlayer)

	if IsHandcuffed or arrest or arrested or surrender or isZiptied then
		return
	end
	if closestPlayer ~= -1 and distance <= 3.0 and GetVehiclePedIsIn(playerPed, false) == 0 then
		local data = anim_state(closestPlayer)
		if type == "handcuff" then
			if isInList(ESX.Player.GetJobName(), Config.AccessToRestrain) then
				if not data[4] then
					if data[2] then
						TriggerEvent("rpuk_restrain:unRestrainAnim")
						Citizen.Wait(3000)
						TriggerServerEvent('rpuk_restrain:handcuff', GetPlayerServerId(closestPlayer))
						Citizen.Wait(400)
					else
						arrest = true
						TriggerServerEvent('rpuk_restrain:animation', GetPlayerServerId(closestPlayer))
						Citizen.Wait(4300)
						TriggerServerEvent('rpuk_restrain:handcuff', GetPlayerServerId(closestPlayer))
						Citizen.Wait(400)
					end
				end
			end
		else
			if not data[2] then
				if not data[4] and (data[1] or data[3]) then
					arrest = true
					TriggerServerEvent('rpuk_restrain:ziptieCheck', GetPlayerServerId(closestPlayer))
					Citizen.Wait(400)
				elseif data[4] then
					TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'error', text = "You need a knife!" })
				else
					TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, type = 'error', text = "Suspect needs to put there hands up" })
				end
			end
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'No one is close to restrain!' })
	end
end)
AddEventHandler('rpuk_restain:dragFromMenu', function()
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
	local closestPlayerPed = GetPlayerPed(closestPlayer)
	if closestPlayer ~= -1 and distance <= 3.0 then
		local data = anim_state(closestPlayer)
		if isInList(ESX.Player.GetJobName(), Config.AccessToDrag) then
			if (data[5] or data[2] or data[6] or data[4] or IsPedRagdoll(closestPlayerPed)) then
				TriggerServerEvent('rpuk_restrain:drag', GetPlayerServerId(closestPlayer))
			else
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You can not escort.' })
			end
		else
			if data[4] then
				TriggerServerEvent('rpuk_restrain:drag', GetPlayerServerId(closestPlayer))
			else
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You can not escort.' })
			end
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'No one is close to escort!' })
	end
end)

AddEventHandler('rpuk_restrain:vehiclePlacement', function(seatNumber)
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
	local closestPlayerPed = GetPlayerPed(closestPlayer)

	seatNumber = seatNumber[1]
	local vehicle = ESX.Game.GetClosestVehicle()
	local seat = IsVehicleSeatFree(vehicle,seatNumber)
	local takeOut = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehicle, seatNumber)))

	if closestPlayer ~= -1 and distance <= 4.0 and seat and GetVehiclePedIsIn(closestPlayerPed, false) == 0 then
		local data = anim_state(closestPlayer)
		if data[2] or data[4] or data[5] or data[6] then
			TriggerServerEvent('rpuk_restrain:putInVehicle', GetPlayerServerId(closestPlayer), seatNumber)
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Target needs to be in the correct state to place in vehicle.' })
		end
	elseif not seat then
		local data = anim_state(closestPlayer)
		if isInList(ESX.Player.GetJobName(), Config.AccessToUseVehiclePlacement) then
			TriggerServerEvent("rpuk_restrain:OutVehicle", takeOut)
		else
			if data[4] or data[6] then
				TriggerServerEvent("rpuk_restrain:OutVehicle", takeOut)
			else
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Target needs to be ziptied.' })
			end
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'No one is close to put in or out of the vehicle' })
	end
end)

function anim_state(player)
	local ped = GetPlayerPed(player)
	local anim_data = {}
	anim_data[1] = IsEntityPlayingAnim(ped, "random@mugging3", "handsup_standing_base", 3) -- Surrender Standing Up Anim
	anim_data[2] = IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) -- Restrain Anim
	anim_data[3] = IsEntityPlayingAnim(ped, "random@arrests@busted", "idle_a", 3)
	anim_data[4] = IsEntityPlayingAnim(ped, "anim@move_m@prisoner_cuffed", "idle", 3) -- Ziptie Anim
	anim_data[5] = IsEntityPlayingAnim(ped, "dead", "dead_a", 3) -- Sedate Anim
	anim_data[6] = IsEntityPlayingAnim(ped, "misslamar1dead_body", "dead_idle", 3) -- Dead Anim
	return anim_data
end

AddEventHandler('rpuk_restain:pickLockProgress', function(item)
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and distance <= 3.0 then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "lockpicking",
			duration = 8000,
			label = "Lockpicking",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			},
			animation = {
			animDict = "missheistfbisetup1",
			anim = "unlock_loop_janitor",
			},
		}, function(status)
			if not status then
				if item == "lockpick" then
					if math.random(100) > 65 then
						TriggerServerEvent('rpuk_restrain:handcuff', GetPlayerServerId(closestPlayer))
						Citizen.Wait(400)
					else
						TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'inform', text = "You have broke your lockpick" })
					end
				elseif item == "advanced_lockpick" then
					if math.random(100) > 50 then
						TriggerServerEvent('rpuk_restrain:handcuff', GetPlayerServerId(closestPlayer))
						Citizen.Wait(400)
					else
						TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'inform', text = "You have broke your lockpick" })
					end
				end
			else
				TriggerServerEvent('returnItem', item)
				TriggerEvent('mythic_notify:client:SendAlert', { length = 8000, action = 'longnotif', type = 'inform', text = "You have stopped lockpicking" })
			end
		end)
	end
end)

AddEventHandler('rpuk_restrain:removeZiptie', function()
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and distance <= 3.0 then
		local data = anim_state(closestPlayer)
		if data[4] then
			TriggerServerEvent('rpuk_restrain:checkForKnife', GetPlayerServerId(closestPlayer))
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'The person is not handcuffed' })
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'No one is close to you!' })
	end
end)

AddEventHandler('rpuk_restrain:removeZiptieAnim', function(weapon)
	local playerPed = PlayerPedId()
	SetCurrentPedWeapon(playerPed, GetHashKey(weapon), true)
	Citizen.Wait(1000)
	RequestAnimDict('missheistfbisetup1')

	while not HasAnimDictLoaded('missheistfbisetup1') do
		Citizen.Wait(10)
	end

	TaskPlayAnim(playerPed, 'missheistfbisetup1', 'unlock_loop_janitor', 8.0, -8.0, 3000, 33, 0, false, false, false)

	Citizen.Wait(4000)
end)

AddEventHandler('rpuk_restain:pickLock', function()
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and distance <= 3.0 then
		local data = anim_state(closestPlayer)
		if data[2] then
			TriggerServerEvent('rpuk_restrain:lockpickhandcuff', GetPlayerServerId(closestPlayer))
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'The person is not handcuffed' })
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'No one is close to you!' })
	end
end)

AddEventHandler('rpuk_restrain:ziptied', function()
	isZiptied		= not isZiptied
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if isZiptied then

			RequestAnimDict('anim@move_m@prisoner_cuffed')
			while not HasAnimDictLoaded('anim@move_m@prisoner_cuffed') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
		else
			DragStatus.IsDragged = false
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
		end
	end)
end)

AddEventHandler('rpuk_restrain:handcuff', function()
	IsHandcuffed		= not IsHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()

		if IsHandcuffed then

			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end

			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "cuff", 0.3)
			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
		else
			DragStatus.IsDragged = false
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
		end
	end)
end)

AddEventHandler('rpuk_restrain:unrestrain', function()
	if IsHandcuffed or isZiptied then
		local playerPed = PlayerPedId()
		if IsHandcuffed then IsHandcuffed = false end
		if isZiptied then isZiptied = false end
		DragStatus.IsDragged = false
		ClearPedTasksImmediately(playerPed)
		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisableControlAction(1, 37, false) --Disables INPUT_SELECT_WEAPON (tab) Actions
		DisablePlayerFiring(playerPed, false) -- Disable weapon firing
		SetPedCanPlayGestureAnims(playerPed, true)
		EnableAllControlActions(0)
	end
end)
-- Handcuff and surrender disable
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)
		local playerPed = PlayerPedId()

		if (IsHandcuffed or isZiptied or arrested) then
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?
			DisableControlAction(0, 75, true) -- Vehicle Exit
			DisableControlAction(0, 288, true) -- Disable phone
			DisableControlAction(0, 170, true) -- Inventory
			DisableControlAction(0, 289, true) -- Animations
			DisableControlAction(0, 167, true) -- Job
			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle
			DisableControlAction(0, 21, true) -- Disable reversing in vehicle
			DisableControlAction(0, 172, true) --
			DisableControlAction(0, 175, true) --
			DisableControlAction(0, 19, true) --
			DisableControlAction(0, 174, true) --
			DisableControlAction(0, 173, true) --
			DisableControlAction(2, 303, true) --
			DisableControlAction(2, 171, true) --
			DisableControlAction(2, 36, true) -- Disable going stealth
			DisableControlAction(0, 47, true)	-- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee

			if IsHandcuffed then
				if (not IsEntityPlayingAnim(playerPed, "mp_arresting", "idle", 3)) or (IsPedRagdoll(playerPed)) then
					RequestAnimDict('mp_arresting')
					while not HasAnimDictLoaded("mp_arresting") do
						Citizen.Wait(1)
					end
					TaskPlayAnim(playerPed, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
				end
			elseif isZiptied then
				if (not IsEntityPlayingAnim(playerPed, "anim@move_m@prisoner_cuffed", "idle", 3)) or (IsPedRagdoll(playerPed)) then
					RequestAnimDict('anim@move_m@prisoner_cuffed')
					while not HasAnimDictLoaded("anim@move_m@prisoner_cuffed") do
						Citizen.Wait(1)
					end
					TaskPlayAnim(playerPed, "anim@move_m@prisoner_cuffed", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
				end
			end

		elseif surrender then
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?
			DisableControlAction(2, 303, true) --
			DisableControlAction(0, 47, true)	-- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
		else
			Citizen.Wait(1000)
		end
	end
end)

AddEventHandler('rpuk_restrain:ziptiedAnim', function(target)
	arrested = true
--- Guy being Restained
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict('mp_arrest_paired')

	while not HasAnimDictLoaded('mp_arrest_paired') do
		Citizen.Wait(10)
	end

	AttachEntityToEntity(playerPed, targetPed, 11816, 2, 0.72, 0.0, 0.0, 0.0, 180.0, false, false, false, false, 20, true)
	TaskPlayAnim(playerPed, 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8.0, 5500, 33, 0, false, false, false)

	Citizen.Wait(5000)
	DetachEntity(playerPed, true, false)

	arrested = false
end)

AddEventHandler('rpuk_restrain:ziptieingAnim', function()
	local playerPed = PlayerPedId()
-- Guy Cuffing said person
	RequestAnimDict('mp_arresting')

	while not HasAnimDictLoaded('mp_arresting') do
		Citizen.Wait(10)
	end

	TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8.0, 4150, 33, 0, false, false, false)

	Citizen.Wait(3000)

	arrest = false
end)


AddEventHandler('rpuk_restrain:arrested', function(target)
	arrested = true
--- Guy being Restained
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict('mp_arrest_paired')

	while not HasAnimDictLoaded('mp_arrest_paired') do
		Citizen.Wait(10)
	end

	AttachEntityToEntity(playerPed, targetPed, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 20, false)
	TaskPlayAnim(playerPed, 'mp_arrest_paired', 'crook_p2_back_left', 8.0, -8.0, 5500, 33, 0, false, false, false)

	Citizen.Wait(5000)
	DetachEntity(playerPed, true, false)

	arrested = false
end)

AddEventHandler('rpuk_restrain:arrest', function()
	local playerPed = PlayerPedId()
-- Guy Cuffing said person
	RequestAnimDict('mp_arrest_paired')

	while not HasAnimDictLoaded('mp_arrest_paired') do
		Citizen.Wait(10)
	end

	TaskPlayAnim(playerPed, 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8.0, 4150, 33, 0, false, false, false)

	Citizen.Wait(3000)

	arrest = false
end)

AddEventHandler('rpuk_restrain:unRestrainAnim', function()
	local playerPed = PlayerPedId()
	RequestAnimDict('missheistfbisetup1')

	while not HasAnimDictLoaded('missheistfbisetup1') do
		Citizen.Wait(10)
	end

	TaskPlayAnim(playerPed, 'missheistfbisetup1', 'unlock_loop_janitor', 8.0, -8.0, 3000, 33, 0, false, false, false)

	Citizen.Wait(3000)
end)

AddEventHandler('rpuk_restrain:putplayerInVehicle', function(seatNumber)
	local playerPed = PlayerPedId()
	local vehicle, distance = ESX.Game.GetClosestVehicle()

	if vehicle ~= 0 and vehicle ~= nil and distance then
		if IsVehicleSeatFree(vehicle,seatNumber) then
			TaskWarpPedIntoVehicle(playerPed, vehicle, seatNumber)
			DragStatus.IsDragged = false
		end
	end
end)

AddEventHandler('rpuk_restrain:removefromVehicle', function(seatNumber)
	local player = PlayerPedId()
	local vehicle = ESX.Game.GetClosestVehicle()
	-- local sedated = exports.rpuk_health:GetSedate()

	if vehicle ~= 0 and vehicle ~= nil then
		TaskLeaveVehicle(player, vehicle, 16)
		if IsHandcuffed then
			Wait(50)
			ClearPedTasksImmediately(player)
			TaskPlayAnim(player, "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
		elseif isZiptied then
			Wait(50)
			ClearPedTasksImmediately(player)
			TaskPlayAnim(player, "anim@move_m@prisoner_cuffed", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
		-- elseif sedated then
		-- 	Wait(50)
		-- 	ClearPedTasksImmediately(player)
		-- 	TaskPlayAnim(player, 'dead', 'dead_a', 8.0, -8.0, -1, 1, 0, 0, 0, 0)
		end
	end

end)

AddEventHandler('rpuk_restrain:detachDrag', function()
	local playerPed = PlayerPedId()
	DragStatus.IsDragged = false
	DetachEntity(playerPed, true, false)
end)

AddEventHandler('rpuk_restrain:drag', function(copID)

	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId		 = tonumber(copID)

	Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		local playerPed = PlayerPedId()

		if DragStatus.IsDragged then
			local targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

			-- undrag if target is in an vehicle
			if not IsPedSittingInAnyVehicle(targetPed) then
				AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			else
				DragStatus.IsDragged = false
				DetachEntity(playerPed, true, false)
			end

		else
			DetachEntity(playerPed, true, false)
		end
	end
	end)
end)

Citizen.CreateThread(function()
	while true do
		if DragStatus.IsDragged and GetEntitySpeed(PlayerPedId()) > 0.2 then
			local plyPos = GetEntityCoords(PlayerPedId(),	true)
			SetEntityCoords(PlayerPedId(), plyPos.x, plyPos.y, plyPos.z)
		end
		Citizen.Wait(10000)
	end
end)


function formatForSecondaryInventory(data)
	local items = {}
	local money = {}
	local weapons = {}
	local ammo = {}

	if data.cash > 0 then
		table.insert(money, {
			count = data.cash,
			name = "money",
			label = "Cash"
		})
	end

	if data.blackMoney.money > 0 then
		table.insert(money, {
			count = data.blackMoney.money,
			name = data.blackMoney.name,
			label = data.blackMoney.label
		})
	end

	for k,v in pairs(data.ammo) do
		if v.count > 0 then
			table.insert(ammo, {
				label = v.label,
				name = k,
				count = v.count
			})
		end
	end

	for k,v in pairs(data.weapons) do
		table.insert(weapons, {
			count = 1,
			label = v.label,
			name = v.name
		})
	end

	return money, data.items, weapons, ammo
end

AddEventHandler('rpuk_inventory:searchPlayer', function()
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and distance <= 3.0 then
		local data = anim_state(closestPlayer)
		if data[1] or data[2] or data[4] then
			ESX.TriggerServerCallback('rpuk:search_player', function(inventory)
				data = {targetId = GetPlayerServerId(closestPlayer), text = "Searching Citizen", type = "rpuk_restrain"}
				TriggerEvent("rpuk_inventory:openSecondaryInventory", data, formatForSecondaryInventory(inventory))
				TriggerEvent("rpuk_restrain:registerIsSearching", GetPlayerServerId(closestPlayer))
			end, GetPlayerServerId(closestPlayer))
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You need to restrain them first.' })
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'No one is close to search' })
	end
end)

AddEventHandler('rpuk_inventory:inventoryStatus', function(status, data)
	if data then
		if data.type == "rpuk_restrain" then
			isSearching = nil
		end
	end
end)

function loadAnimDict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname)
		while not HasAnimDictLoaded(dictname) do
		Citizen.Wait(1)
		end
	end
end

AddEventHandler('rpuk_restrain:registerIsSearching', function(id)
	isSearching = id

	Citizen.CreateThread(function()

		while isSearching do
			Wait(500)
			local targetPed = GetPlayerPed(GetPlayerFromServerId(id))
			local ped = PlayerPedId()
			local anim = IsEntityPlayingAnim(ped, "missheistfbisetup1", "unlock_loop_janitor", 3)
			loadAnimDict("missheistfbisetup1")
			if not anim then
				TaskPlayAnim(ped, 'missheistfbisetup1', 'unlock_loop_janitor', 8.0, -8.0, 3000, 33, 0, false, false, false)
			end
			if #(GetEntityCoords(ped) - GetEntityCoords(targetPed)) > Config.DistToSearch then
				ClearPedTasks(ped)
				ClearPedTasksImmediately(ped)
				ClearPedSecondaryTask(ped)
				isSearching = nil
				TriggerEvent('rpuk_inventory:closeInventory')
			end
		end
	end)
end)

RegisterNetEvent('rpuk:unlockVehicle')
AddEventHandler("rpuk:unlockVehicle", function()
	local playerPed = PlayerPedId()
	local coords	= GetEntityCoords(playerPed)
	local vehicle = ESX.Game.GetClosestVehicle()
	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
		TriggerEvent("mythic_progbar:client:progress", {
			name = "repair",
			duration = 5000,
			label = "Gaining Access",
			useWhileDead = false,
			canCancel = true,
			controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
			},
			animation = {
			animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
			anim = "machinic_loop_mechandplayer",
			flags = 49,
			task = nil,
			}
		}, function(status)
			if not status then
			SetVehicleDoorsLocked(vehicle, 1)
			SetVehicleDoorsLockedForAllPlayers(vehicle, false)
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Vehicle is unlocked' })
			elseif status then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You have stopped attempting to get into the vehicle.' })
			end
		end)
	end
end)