
-- This release: Removed unused code. Changed UI to use binocular scaleform.
--CONFIG--
local fov_max = 70.0
local fov_min = 1.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 10.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right
local speed_ud = 8.0 -- speed by which the camera pans up-down

local binoculars = false
local fov = (fov_max+fov_min)*0.5

local storeBinoclarKey = 177

--THREADS--

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		if binoculars then
			local lPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(lPed)

			if IsPedOnFoot(lPed) then
				TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BINOCULARS", 0, 1)
				Citizen.Wait(1000)
			end

			TriggerEvent("rpuk_inventory:closeInventory")

			local scaleform = RequestScaleformMovie("BINOCULARS")
			while not HasScaleformMovieLoaded(scaleform) do Citizen.Wait(10) end

			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
			AttachCamToEntity(cam, lPed, 0.0,0.0,1.0, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)

			BeginScaleformMovieMethod(scaleform, "SET_CAM_LOGO")
			ScaleformMovieMethodAddParamInt(0)
			EndScaleformMovieMethod()
			TriggerEvent("rpuk_hud:toggleHud", false)

			while binoculars and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) do
				Citizen.Wait(0)

				if IsControlJustPressed(0, storeBinoclarKey) then -- Toggle binoculars
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					ClearPedTasks(lPed)
					Wait(800)
					binoculars = false
				end

				local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
				CheckInputRotation(cam, zoomvalue)

				HandleZoom(cam)
				HideHelpTextThisFrame()
				HideHudAndRadarThisFrame()
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			end

			binoculars = false
			ClearTimecycleModifier()
			fov = (fov_max+fov_min)*0.5
			RenderScriptCams(false, false, 0, 1, 0)
			SetScaleformMovieAsNoLongerNeeded(scaleform)
			DestroyCam(cam, false)
			TriggerEvent("rpuk_hud:toggleHud", true)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('binoculars:Activate')
AddEventHandler('binoculars:Activate', function()
	binoculars = not binoculars
end)

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local lPed = PlayerPedId()
	if not ( IsPedSittingInAnyVehicle( lPed ) ) then

		if IsControlJustPressed(0,241) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,17) then -- Scrollup
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,16) then
			fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
	end
end