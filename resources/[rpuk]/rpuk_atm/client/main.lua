local isMenuOpen = false
local isBlurry = false

Citizen.CreateThread(function()
	while not ESX.IsPlayerLoaded() do Citizen.Wait(500) end
	Citizen.Wait(2000)
	SendNUIMessage({action = 'setPlayerName', playerName = ESX.Player.GetName()})
end)

RegisterNetEvent('rpuk_weather:isBlurry')
AddEventHandler('rpuk_weather:isBlurry', function(_isBlurry) isBlurry = _isBlurry end)

RegisterNetEvent('esx:setName')
AddEventHandler('esx:setName', function(newName)
	SendNUIMessage({action = 'setPlayerName', playerName = newName})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == 'bank' then
		SendNUIMessage({action = 'setBalance', balance = account.money})
	end
end)

AddEventHandler('rpuk_atm:OpenRemotely', function(job)
	ESX.TriggerServerCallback('rpuk_factions:getFund', function(fund, canWithdraw)
		openATM(fund, canWithdraw)
	end, job)
end)

function openATM(fund, canWithdraw)
	isMenuOpen = true
	SetNuiFocus(true, true)
	SetTimecycleModifier('hud_def_blur')

	if fund then
		SendNUIMessage({action = 'openGeneral', atmType = 'fund', balance = fund.fund, canWithdraw = canWithdraw})
	else
		SendNUIMessage({action = 'openGeneral', atmType = 'normal', balance = ESX.Player.GetAccounts().bank.money})
	end
end

function GetModelInFrontOfPlayer()
	local Ent = nil
	local CoA = GetEntityCoords(PlayerPedId(), 1)
	local CoB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, 0.0)
	local RayHandle = CastRayPointToPoint(CoA.x, CoA.y, CoA.z, CoB.x, CoB.y, CoB.z, 16, PlayerPedId(), 0)
	local _,_,_,_,Ent = GetRaycastResult(RayHandle)
	local modelHash = GetEntityModel(Ent)
	return modelHash
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local canSleep, playerPed = true, PlayerPedId()

		for k,hash in ipairs({
			-870868698, --Portable ATM Machine
			-1126237515, -- BLUE WALL ATM Machine
			-1364697528, -- RED WALL ATM Machine
			506770882, -- GREEN FLEECA WALL ATM Machine
		}) do
			if GetModelInFrontOfPlayer() == hash and not isMenuOpen and IsPedOnFoot(playerPed) then
				local objHandle = GetClosestObjectOfType(GetEntityCoords(playerPed), 1.0, hash, false)
				canSleep = false
				local entityCoords = GetEntityCoords(objHandle) + vector3(0, 0, 1.0)
				ESX.Game.Utils.DrawText3D(entityCoords, "Press [~b~E~s~] To Access The ~g~ATM~s~", 0.6, 6)

				if IsControlJustReleased(0, 38) and not menuIsShowed then
					TaskTurnPedToFaceEntity(playerPed, objHandle, 2000)
					ESX.Streaming.RequestAnimDict('mp_common')
					TaskPlayAnim(playerPed, 'mp_common', 'givetake1_a', 1.0, -1.0, 2500, 49, 1, false, false, false)
					RemoveAnimDict('mp_common')
					Citizen.Wait(2500)
					openATM()
				end

				break
			end
		end

		if canSleep then
			Citizen.Wait(1500)
		end
	end
end)

RegisterNUICallback('deposit', function(data, cb)
	ESX.TriggerServerCallback('rpuk_atm:deposit', function(newBalance)
		cb(newBalance)
	end, tonumber(data.amount), data.atmType)
end)

RegisterNUICallback('withdraw', function(data, cb)
	ESX.TriggerServerCallback('rpuk_atm:withdraw', function(newBalance)
		cb(newBalance)
	end, tonumber(data.amount), data.atmType)
end)

RegisterNUICallback('onMenuClose', function(data, cb)
	isMenuOpen = false
	SetNuiFocus(false)
	if not isBlurry then SetTimecycleModifier('default') end
	cb(true)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() and isMenuOpen then
		SetNuiFocus(false)
		if not isBlurry then SetTimecycleModifier('default') end
	end
end)