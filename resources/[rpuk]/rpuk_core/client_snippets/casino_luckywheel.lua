local _wheel, _lambo = nil, nil
local _wheelPos = vector3(1109.76, 227.89, -49.64)
local _baseWheelPos = vector3(1111.05, 229.81, -50.38)
local _isShowCar, _isRolling = false, false
local carmodel, carSpawned, carPosX, carPosY, carPosZ, carPosH = GetHashKey('prototipo'), false, 1100.39, 220.09, -50.0, 0.0 -- Car details

Citizen.CreateThread(function()
	local model = GetHashKey('vw_prop_vw_luckywheel_02a')
	local baseWheelModel = GetHashKey('vw_prop_vw_luckywheel_01a')
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end

	_wheel = CreateObject(model, 1111.05, 229.81, -50.38, false, false, true)
	SetEntityHeading(_wheel, 0.0000)
	SetModelAsNoLongerNeeded(model)
end)

-- if GetDistanceBetweenCoords(coords, Config.Standard[i].x, Config.Standard[i].y,Config.Standard[i].z, true) < Config.Standard[i].spawnDistance then

Citizen.CreateThread(function()
	while true do
		if carSpawned == false then
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, carPosX, carPosY, carPosZ, true) < 30 then
				RequestModel(carmodel)
				while not HasModelLoaded(carmodel) do
					Citizen.Wait(0)
				end

				local vehicle = CreateVehicle(carmodel, carPosX, carPosY, carPosZ, carPosH, false, false)

				SetModelAsNoLongerNeeded(carmodel) -- let the client release it

				SetVehicleDoorsLockedForAllPlayers(vehicle, true)
				FreezeEntityPosition(vehicle, true)
				local _curPos = GetEntityCoords(vehicle)
				SetEntityCoords(vehicle, _curPos.x, _curPos.y, _curPos.z + 1, false, false, true, true)

				_lambo = vehicle
				carSpawned = true
			end
		end
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		if _lambo ~= nil then
			local _heading = GetEntityHeading(_lambo)
			local _z = _heading - 0.3
			SetEntityHeading(_lambo, _z)
		end
		Citizen.Wait(5)
	end
end)

RegisterNetEvent("esx_tpnrp_luckywheel:doRoll")
AddEventHandler("esx_tpnrp_luckywheel:doRoll", function(_prizeIndex)
	_isRolling = true
	SetEntityHeading(_wheel, -30.0)
	SetEntityRotation(_wheel, 0.0, 0.0, 0.0, 1, true)
	Citizen.CreateThread(function()
		local speedIntCnt = 1
		local rollspeed = 0.1

		--print("======================================================================================================")
		--print("Prize " .. _prizeIndex .. " +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
		--print("======================================================================================================")

		local _winAngle = (_prizeIndex - 1) * 18
 		--print("winAngle " .. _winAngle)

		local _rollAngle = _winAngle + (360 * 8)
		--print("rollAngle " .. _rollAngle)

		local _midLength = (_rollAngle / 2)
		--print("midLength " .. _midLength)

		while _rollAngle > 0 do

			local retval = GetEntityRotation(_wheel, 1)
			--print ("retval.y " ..  retval.y)

			rollspeed = speedIntCnt / 10
			--print ("                                       rollspeed " ..  rollspeed)
			local _y = retval.y - rollspeed
			--print ("                                                                 y " .. _y)
			_rollAngle = _rollAngle - rollspeed
			--print ("                                                                                      rollAngle " ..  _rollAngle)

			SetEntityRotation(_wheel, 0.0, _y, 0.0, 1, true)

			 if _rollAngle >= _midLength then
				speedIntCnt = speedIntCnt + 1
			else
				speedIntCnt = speedIntCnt - 1
				if speedIntCnt < 2 then
					speedIntCnt = 2
				end
			end
			--print("                                                                                                            speedIntCnt " .. speedIntCnt)
			Citizen.Wait(0)
		end
		-- SetEntityRotation(_wheel, 0.0, _winAngle, 0.0, 1, true)
	end)
end)

RegisterNetEvent("esx_tpnrp_luckywheel:rollFinished")
AddEventHandler("esx_tpnrp_luckywheel:rollFinished", function()
	_isRolling = false
end)

function doRoll()
	if not _isRolling then
		_isRolling = true
		local playerPed = PlayerPedId()
		local _lib = 'anim_casino_a@amb@casino@games@lucky7wheel@female'
		if IsPedMale(playerPed) then
			_lib = 'anim_casino_a@amb@casino@games@lucky7wheel@male'
		end
		local lib, anim = _lib, 'enter_right_to_baseidle'
		ESX.Streaming.RequestAnimDict(lib, function()
			local _movePos = vector3(1109.55, 228.88, -49.64)
			TaskGoStraightToCoord(playerPed,  _movePos.x,  _movePos.y,  _movePos.z,  1.0,  -1,  312.2,  0.0)
			local _isMoved = false
			while not _isMoved do
				local coords = GetEntityCoords(PlayerPedId())
				if coords.x >= (_movePos.x - 0.01) and coords.x <= (_movePos.x + 0.01) and coords.y >= (_movePos.y - 0.01) and coords.y <= (_movePos.y + 0.01) then
					_isMoved = true
				end
				Citizen.Wait(0)
			end
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
					Citizen.Wait(0)
					DisableAllControlActions(0)
			end
			TaskPlayAnim(playerPed, lib, 'enter_to_armraisedidle', 8.0, -8.0, -1, 0, 0, false, false, false)
			while IsEntityPlayingAnim(playerPed, lib, 'enter_to_armraisedidle', 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end
			TriggerServerEvent("esx_tpnrp_luckywheel:getLucky")
			TaskPlayAnim(playerPed, lib, 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)
		end)
	end
end

-- Menu Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local coords = GetEntityCoords(PlayerPedId())

		if(GetDistanceBetweenCoords(coords, _wheelPos.x, _wheelPos.y, _wheelPos.z, true) < 1.5) and not _isRolling then
			ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to test your luck! [~b~1000 Tokens~s~]")
			if IsControlJustReleased(0, 38) then
				ESX.TriggerServerCallback('esx_tpnrp_luckywheel:checkRollTokens', function(canRoll)
					if canRoll then
						doRoll()
					end
				end)
			end
		end
	end
end)