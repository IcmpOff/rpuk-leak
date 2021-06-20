local fov_max = 80.0
local fov_min = 10.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 2.0 -- camera zoom speed
local speed_lr = 3.0 -- speed by which the camera pans left-right
local speed_ud = 3.0 -- speed by which the camera pans up-down
local toggle_helicam = 51 -- control id of the button by which to toggle the helicam mode. Default: INPUT_CONTEXT (E)
local toggle_vision = 25 -- control id to toggle vision mode. Default: INPUT_AIM (Right mouse btn)
local toggle_rappel = 154 -- control id to rappel out of the heli. Default: INPUT_DUCK (X)
local toggle_spotlight = 183 -- control id to toggle the front spotlight Default: INPUT_PhoneCameraGrid (G)
local toggle_lock_on = 22 -- control id to lock onto a vehicle with the camera. Default is INPUT_SPRINT (spacebar)
local helicam = false
local heli_hash = GetHashKey("rpPoliceH1")
local fov = (fov_max+fov_min)*0.5
local vision_state = 0 -- 0 is normal, 1 is nightmode, 2 is thermal vision
local maxLockDistance = 400

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		--[[
		if IsPlayerInPolheli() then
			local lPed = PlayerPedId()
			local heli = GetVehiclePedIsIn(lPed)

			if IsHeliHighEnough(heli) then

				if IsControlJustPressed(0, toggle_rappel) then -- Initiate rappel
					Citizen.Trace("try to rappel")
					if GetPedInVehicleSeat(heli, 1) == lPed or GetPedInVehicleSeat(heli, 2) == lPed then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						TaskRappelFromHeli(PlayerPedId(), 1)
					else
						SetNotificationTextEntry( "STRING" )
						AddTextComponentString("~r~Can't rappel from this seat")
						DrawNotification(false, false )
						PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false)
					end
				end
			end
		end
		]]

		if helicam then
			SetTimecycleModifier("heliGunCam")
			SetTimecycleModifierStrength(0.3)
			local scaleform = RequestScaleformMovie("HELI_CAM")
			local promptScaleform = ESX.Scaleform.PrepareBasicInstructional({{button = {38}, text = "Exit camera"}, {button = {22}, text = "Toggle vehicle lock on"}, {button = {25}, text = "Toggle thermals"}, {button = {334}, text = "Zoom"}})

			while not HasScaleformMovieLoaded(scaleform) do Citizen.Wait(0) end
			local lPed = PlayerPedId()
			local heli = GetVehiclePedIsIn(lPed)
			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

			AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(heli))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			BeginScaleformMovieMethod(scaleform, "SET_CAM_LOGO")
			ScaleformMovieMethodAddParamInt(1) -- 0 for nothing, 1 for LSPD logo
			EndScaleformMovieMethod()
			local lockedOnEntityHandle = nil

			while helicam and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == heli) do
				Citizen.Wait(0)
				local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)

				if IsControlJustReleased(0, toggle_vision) then
					ChangeHeliVision()
				end

				if lockedOnEntityHandle then
					local distance = #(GetEntityCoords(heli) - GetEntityCoords(lockedOnEntityHandle))

					if DoesEntityExist(lockedOnEntityHandle)
						and distance < maxLockDistance
						and HasEntityClearLosToEntity(heli, lockedOnEntityHandle, 17)
					then
						PointCamAtEntity(cam, lockedOnEntityHandle, 0.0, 0.0, 0.0, true)
						RenderVehicleInfo(lockedOnEntityHandle, distance)

						if IsControlJustReleased(0, toggle_lock_on) then
							PlaySoundFrontend(-1, "On_Call_Player_Join", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false)
							cam = ResetVehicleLock(cam, heli)
							lockedOnEntityHandle = nil
						end
					else
						PlaySoundFrontend(-1, "Lost_Target", "POLICE_CHOPPER_CAM_SOUNDS", false)
						cam = ResetVehicleLock(cam, heli)
						lockedOnEntityHandle = nil -- Cam will auto unlock when entity doesn't exist anyway
					end
				else
					CheckInputRotation2(cam, zoomvalue)
					local vehicleHandleInView = GetVehicleInView(cam)

					if vehicleHandleInView and DoesEntityExist(vehicleHandleInView) then
						local distance = #(GetEntityCoords(heli) - GetEntityCoords(vehicleHandleInView))
						RenderVehicleInfo(vehicleHandleInView, distance)

						if IsControlJustReleased(0, toggle_lock_on) and HasEntityClearLosToEntity(heli, vehicleHandleInView, 17) then
							PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", false)
							lockedOnEntityHandle = vehicleHandleInView
						end
					end
				end

				local helicopterCoords = GetEntityCoords(heli)
				HandleCameraZoomThisFrame(cam)
				HideHUDThisFrame2()

				BeginScaleformMovieMethod(scaleform, "SET_ALT_FOV_HEADING")
				ScaleformMovieMethodAddParamFloat(helicopterCoords.z)
				ScaleformMovieMethodAddParamFloat(zoomvalue)
				ScaleformMovieMethodAddParamFloat(GetCamRot(cam, 2).z)
				EndScaleformMovieMethod()

				BeginScaleformMovieMethod(scaleform, "SET_CAM_ALT")
				ScaleformMovieMethodAddParamFloat(helicopterCoords.z)
				EndScaleformMovieMethod()

				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				DrawScaleformMovieFullscreen(promptScaleform, 255, 255, 255, 255)
			end

			helicam = false
			ClearTimecycleModifier()
			fov = (fov_max+fov_min)*0.5 -- reset to starting zoom level
			vision_state = 0 -- reset
			RenderScriptCams(false, false, 0, true, false) -- Return to gameplay camera
			SetScaleformMovieAsNoLongerNeeded(scaleform)
			SetScaleformMovieAsNoLongerNeeded(promptScaleform)
			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
		else
			Citizen.Wait(500)
		end
	end
end)

function ResetVehicleLock(cam, heli)
	local rot = GetCamRot(cam, 2) -- All this because I can't seem to get the camera unlocked from the entity
	local _fov = GetCamFov(cam)
	local old_cam = cam
	DestroyCam(old_cam, false)
	cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
	AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
	SetCamRot(cam, rot, 2)
	SetCamFov(cam, _fov)
	RenderScriptCams(true, false, 0, 1, 0)

	return cam
end

function IsPlayerInPolheli()
	local lPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(lPed)
	return IsVehicleModel(vehicle, heli_hash)
end

function IsHeliHighEnough(heli) return GetEntityHeightAboveGround(heli) > 1.5 end

function ChangeHeliVision()
	if vision_state == 0 then
		PlaySoundFrontend(-1, "THERMAL_VISION_GOGGLES_ON_MASTER", 0, false)
		SetNightvision(true)
		vision_state = 1
	elseif vision_state == 1 then
		SetNightvision(false)
		SetSeethrough(true)
		vision_state = 2
	else
		SetSeethrough(false)
		vision_state = 0
	end
end

function HideHUDThisFrame2()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(19) -- weapon wheel
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
end

function CheckInputRotation2(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleCameraZoomThisFrame(cam)
	local current_fov = GetCamFov(cam)

	-- Scrollup
	if IsControlJustPressed(0,241) then fov = math.max(fov - zoomspeed, fov_min) end

	-- ScrollDown
	if IsControlJustPressed(0,242) then fov = math.min(fov + zoomspeed, fov_max) end

	-- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
	if math.abs(fov-current_fov) < 0.1 then fov = current_fov end

	SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	--DrawLine(coords, coords+(forward_vector*100.0), 255,0,0,255) -- debug line to show LOS of cam
	local rayhandle = CastRayPointToPoint(coords, coords+(forward_vector*200.0), 10, GetVehiclePedIsIn(PlayerPedId()), 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit>0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RenderVehicleInfo(vehicle, distance)
	local model = GetEntityModel(vehicle)
	local vehname = GetLabelText(GetDisplayNameFromVehicleModel(model))
	local licenseplate = GetVehicleNumberPlateText(vehicle)
	local coords = GetEntityCoords(vehicle)
	local streetName, crossing = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	streetName = GetStreetNameFromHashKey(streetName)
	local vehicleSpeed = GetEntitySpeed(vehicle)
	local speedText = 'Speed: %.0f %s | Distance: %.0f %s'


	if ShouldUseMetricMeasurements() then
		speedText = speedText
			:format(vehicleSpeed * 3.6, 'KM/H', distance, 'meters')
	else
		speedText = speedText
			:format(vehicleSpeed * 2.2369, 'MPH', distance * 3.2808, 'feet')
	end

	SetTextFont(4)
	SetTextScale(0.5, 0.5)
	SetTextJustification(0)
	SetTextOutline()

	BeginTextCommandDisplayText("STRING")
	local msg = ('Model: %s | Plate: %s~n~%s~n~Street: %s')
		:format(vehname, licenseplate, speedText, streetName)
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayText(0.5, 0.90)
end

function RotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

RegisterKeyMapping('helicam_toggle', 'Helicopter Camera Toggle', 'keyboard', 'e')
RegisterCommand('helicam_toggle', function(source)
	if IsPlayerInPolheli() then
		local playerPed = PlayerPedId()
		local helicopterEntity = GetVehiclePedIsIn(playerPed)

		if IsHeliHighEnough(helicopterEntity) and GetPedInVehicleSeat(helicopterEntity, 1) == playerPed then
			helicam = not helicam

			if helicam then
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
			else
				PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
			end
		end
	end
end)