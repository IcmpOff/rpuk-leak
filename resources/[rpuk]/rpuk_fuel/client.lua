local isNearPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local currentCash = 0
local fuelSynced = false
local inBlacklisted = false
local initialAccounts = ESX.Player.GetAccounts()

if initialAccounts.money then currentCash = initialAccounts.money.money end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	if playerData.accounts.money then
		currentCash = playerData.accounts.money.money
	end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == 'money' then
		currentCash = account.money
	end
end)

function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, Config.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))

		fuelSynced = true
	end

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
	end
end

Citizen.CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)

	for index = 1, #Config.Blacklist do
		if type(Config.Blacklist[index]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[index])] = true
		else
			Config.Blacklist[Config.Blacklist[index]] = true
		end
	end

	for index = #Config.Blacklist, 1, -1 do
		table.remove(Config.Blacklist, index)
	end

	while true do
		Citizen.Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

			if Config.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end

			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end

			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(250)

		local pumpObject, pumpDistance = FindNearestFuelPump()

		if pumpDistance < 2.5 then
			isNearPump = pumpObject
		else
			isNearPump = false

			Citizen.Wait(math.ceil(pumpDistance * 20))
		end
	end
end)

AddEventHandler('fuel:startFuelUpTick', function(isPumpingFromGasStation, ped, vehicle)
	currentFuel = GetVehicleFuelLevel(vehicle)

	while isFueling do
		Citizen.Wait(500)

		local oldFuel = DecorGetFloat(vehicle, Config.FuelDecor)
		local fuelToAdd = math.random(10, 20) / 10.0
		local extraCost = fuelToAdd / 1.5 * Config.CostMultiplier

		if isPumpingFromGasStation then
			currentFuel = oldFuel + fuelToAdd
		else
			if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100 >= 0 then
				currentFuel = oldFuel + fuelToAdd

				SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100))
				TriggerServerEvent('esx:updateWeaponAmmo', 'WEAPON_PETROLCAN', GetAmmoInPedWeapon(ped, 883325847))
			else
				isFueling = false
			end
		end

		if currentFuel > 100.0 then
			currentFuel = 100.0
			isFueling = false
		end

		currentCost = ESX.Math.Round(currentCost + extraCost)
		if currentCost < 0 then currentCost = 1 end

		if currentCash >= currentCost or not isPumpingFromGasStation then
			SetFuel(vehicle, currentFuel)
		else
			isFueling = false
		end
	end

	if isPumpingFromGasStation then
		TriggerServerEvent('rpuk_fuel:pay', currentCost)
	end

	currentCost = 0.0
end)

AddEventHandler('rpuk_fuel:startFuelVehicle', function(pumpObject, ped, vehicle)
	TaskTurnPedToFaceEntity(ped, vehicle, 1000)
	Citizen.Wait(1000)
	SetCurrentPedWeapon(ped, -1569615261, true)
	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

	TriggerEvent('fuel:startFuelUpTick', pumpObject, ped, vehicle)

	while isFueling do
		for _, controlIndex in pairs(Config.DisableKeys) do
			DisableControlAction(0, controlIndex)
		end

		if pumpObject then
			local stringCoords = GetOffsetFromEntityInWorldCoords(pumpObject, 0.0, 0.0, 1.2)
			local msg = ('Press ~y~E~s~ to stop fueling~n~Cost: ~g~£%s~s~~n~Fueled: ~b~%s %%~s~'):format(ESX.Math.Round(currentCost), ESX.Math.Round(currentFuel))
			ESX.Game.Utils.DrawText3D(stringCoords, msg, 0.7, 4)
		else
			local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 0.0, 0.5)
			local jerryCanAmmo = ESX.Math.Round(GetAmmoInPedWeapon(ped, 883325847) / 4500 * 100)
			local msg = ('Press ~y~E~s~ to stop fueling~n~Jerry Can: ~g~%s %%~s~ | ~g~Vehicle: %s %%~s~'):format(jerryCanAmmo, ESX.Math.Round(currentFuel))
			ESX.Game.Utils.DrawText3D(vehicleCoords, msg, 0.7, 4)
		end

		if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end

		if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (isNearPump and GetEntityHealth(pumpObject) <= 0) then
			isFueling = false
		end

		Citizen.Wait(0)
	end

	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		local isRefillingWithJerryCan = false

		if not isFueling and ((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) then
			if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped then
				local pumpCoords = GetOffsetFromEntityInWorldCoords(isNearPump, 0.0, 0.0, 1.2)

				ESX.Game.Utils.DrawText3D(pumpCoords, 'You cannot fuel your vehicle from inside it', 0.7, 4)
			else
				local vehicle = GetPlayersLastVehicle()
				local vehicleCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 0.0, 1.2)

				if DoesEntityExist(vehicle) and #(GetEntityCoords(ped) - vehicleCoords) < 2.5 then
					if not DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
						local stringCoords = GetOffsetFromEntityInWorldCoords(isNearPump, 0.0, 0.0, 1.2)
						local canFuel = true

						if GetSelectedPedWeapon(ped) == 883325847 then
							stringCoords = vehicleCoords
							isRefillingWithJerryCan = true

							if GetAmmoInPedWeapon(ped, 883325847) < 100 then
								canFuel = false
							end
						end

						if GetVehicleFuelLevel(vehicle) < 95 and canFuel then
							if currentCash > 0 or isRefillingWithJerryCan then
								ESX.Game.Utils.DrawText3D(stringCoords, 'Press ~y~E~s~ to start fueling vehicle', 0.7, 4)

								if IsControlJustReleased(0, 38) then
									isFueling = true

									TriggerEvent('rpuk_fuel:startFuelVehicle', isNearPump, ped, vehicle)
									LoadAnimDict("timetable@gardener@filling_can")
								end
							else
								ESX.Game.Utils.DrawText3D(stringCoords, 'You cannot afford to refill your vehicle', 0.7, 4)
							end
						elseif not canFuel then
							ESX.Game.Utils.DrawText3D(stringCoords, 'Your ~o~Jerry Can~s~ is empty', 0.7, 4)
						else
							ESX.Game.Utils.DrawText3D(stringCoords, 'Your vehicle tank is full', 0.7, 4)
						end
					end
				elseif isNearPump then
					local stringCoords = GetOffsetFromEntityInWorldCoords(isNearPump, 0.0, 0.0, 1.2)

					if HasPedGotWeapon(ped, 883325847) then
						local refillCost = Round(Config.RefillCost * (1 - GetAmmoInPedWeapon(ped, 883325847) / 4500))

						if refillCost > 0 then
							if currentCash >= refillCost then
								ESX.Game.Utils.DrawText3D(stringCoords, ('Press ~y~E~s~ to refill your ~o~Jerry Can~s~ for ~g~£%s~s~'):format(ESX.Math.Round(refillCost)), 0.7, 4)

								if IsControlJustReleased(0, 38) then
									TriggerServerEvent('rpuk_fuel:pay', refillCost, false, true)
								end
							else
								ESX.Game.Utils.DrawText3D(stringCoords, ('You cannot afford to refill your ~o~Jerry Can~s~ for ~g~£%s~s~'):format(ESX.Math.Round(refillCost)), 0.7, 4)
							end
						else
							ESX.Game.Utils.DrawText3D(stringCoords, 'Your ~o~Jerry Can~s~ is full. If you want to refill an vehicle, you will have to bring it closer.', 0.7, 4)
						end
					else
						if currentCash >= Config.JerryCanCost then
							ESX.Game.Utils.DrawText3D(stringCoords, ('Press ~y~E~s~ to buy a ~o~Jerry Can~s~~n~It costs ~g~£%s~s~'):format(Config.JerryCanCost), 0.7, 4)

							if IsControlJustReleased(0, 38) then
								TriggerServerEvent('rpuk_fuel:pay', Config.JerryCanCost, true, false)
							end
						else
							ESX.Game.Utils.DrawText3D(stringCoords, ('You cannot afford a ~o~Jerry Can~s~~n~It costs ~g~£%s~s~'):format(Config.JerryCanCost), 0.7, 4)
						end
					end

				else
					Citizen.Wait(250)
				end
			end
		else
			Citizen.Wait(250)
		end
	end
end)

if Config.ShowNearestGasStationOnly then
	Citizen.CreateThread(function()
		local currentGasBlip = 0

		while true do
			local coords = GetEntityCoords(PlayerPedId())
			local closest = 1000
			local closestCoords

			for _, gasStationCoords in pairs(Config.GasStations) do
				local dstcheck = #(coords - gasStationCoords)

				if dstcheck < closest then
					closest = dstcheck
					closestCoords = gasStationCoords
				end
			end

			if DoesBlipExist(currentGasBlip) then
				RemoveBlip(currentGasBlip)
			end

			currentGasBlip = CreateBlip(closestCoords)

			Citizen.Wait(10000)
		end
	end)
elseif Config.ShowAllGasStations then
	Citizen.CreateThread(function()
		for _, gasStationCoords in pairs(Config.GasStations) do
			CreateBlip(gasStationCoords)
		end
	end)
end

function GetFuel(vehicle)
	return DecorGetFloat(vehicle, Config.FuelDecor)
end

function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
	end
end

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)

	return math.floor(num * mult + 0.5) / mult
end

function CreateBlip(coords)
	local blip = AddBlipForCoord(coords)

	SetBlipSprite(blip, 361)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, 4)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Fuel Station")
	EndTextCommandSetBlipName(blip)

	return blip
end

function FindNearestFuelPump()
	local coords = GetEntityCoords(PlayerPedId())
	local fuelPumps = {}
	local handle, object = FindFirstObject()
	local success

	repeat
		if Config.PumpModels[GetEntityModel(object)] then
			table.insert(fuelPumps, object)
		end

		success, object = FindNextObject(handle, object)
	until not success

	EndFindObject(handle)

	local pumpObject = 0
	local pumpDistance = 1000

	for _, fuelPumpObject in pairs(fuelPumps) do
		local dstcheck = #(coords - GetEntityCoords(fuelPumpObject))

		if dstcheck < pumpDistance then
			pumpDistance = dstcheck
			pumpObject = fuelPumpObject
		end
	end

	return pumpObject, pumpDistance
end