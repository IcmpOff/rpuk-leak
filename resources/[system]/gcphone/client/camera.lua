local phone = false
local useFrontCamera
local firstTime
local buttonsScaleform
useFrontCamera = false

function CellFrontCamActivate(activate) return Citizen.InvokeNative(0x2491A93618B7D838, activate) end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if phone then
			if IsControlJustPressed(0, 177) and phone then -- CLOSE PHONE
				DestroyMobilePhone()
				phone = false
				CellCamActivate(false, false)

				if firstTime then
					firstTime = false
					Citizen.Wait(2500)
				end
			end

			if IsControlJustPressed(0, 27) and phone then -- SELFIE MODE
				useFrontCamera = not useFrontCamera
				CellFrontCamActivate(useFrontCamera)
			end

			if phone then
				HideHudComponentThisFrame(7)
				HideHudComponentThisFrame(8)
				HideHudComponentThisFrame(9)
				HideHudComponentThisFrame(6)
				HideHudComponentThisFrame(19)
				HideHudAndRadarThisFrame()
			end

			local renderId = GetMobilePhoneRenderId()
			SetTextRenderId(renderId)

			-- Everything rendered inside here will appear on your phone.
			SetTextRenderId(1) -- NOTE: 1 is default
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNUICallback('takePhoto', function(data, cb)
	CreateMobilePhone(1)
	CellCamActivate(true, true)
	isUsingCamera = true
	Citizen.Wait(0)
	buttonsScaleform = ESX.Scaleform.Utils.RequestScaleformMovie('instructional_buttons')

	if hasFocus then
		SetNuiFocus(false, false)
		hasFocus = false
	end

	while isUsingCamera do
		Citizen.Wait(0)
		drawButtonsThisFrame()

		if IsControlJustReleased(0, 27) then -- Toogle Mode
			useFrontCamera = not useFrontCamera
			CellFrontCamActivate(useFrontCamera)
		elseif IsControlJustReleased(0, 177) then -- CANCEL
			DestroyMobilePhone()
			CellCamActivate(false, false)
			cb(json.encode({ url = nil }))
			isUsingCamera = false
		elseif IsControlJustReleased(0, 176) then
			Citizen.CreateThread(function()
				TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 8, 'iphone_camera', 0.3)
				Citizen.Wait(100) -- wait for scaleform to stop drawing

				TriggerEvent('rpuk_core:takeImgurScreenshot', function(url)
					cb(json.encode({url = url}))
					DestroyMobilePhone()
					CellCamActivate(false, false)
					isUsingCamera = false
				end)
			end)

			break
		end
	end

	while isUsingCamera do Citizen.Wait(500) end
	PhonePlayAnim('text', false, true)
	SetScaleformMovieAsNoLongerNeeded(buttonsScaleform)
end)

function drawButtonsThisFrame()
	BeginScaleformMovieMethod(buttonsScaleform, 'CLEAR_ALL')
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(buttonsScaleform, 'SET_CLEAR_SPACE')
	ScaleformMovieMethodAddParamInt(200)
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(buttonsScaleform, 'SET_DATA_SLOT')
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamTextureNameString('~INPUT_PHONE~')
	ScaleformMovieMethodAddParamTextureNameString('Switch camera')
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(buttonsScaleform, 'SET_DATA_SLOT')
	ScaleformMovieMethodAddParamInt(1)
	ScaleformMovieMethodAddParamTextureNameString('~INPUT_CELLPHONE_CANCEL~')
	ScaleformMovieMethodAddParamTextureNameString('Cancel')
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(buttonsScaleform, 'SET_DATA_SLOT')
	ScaleformMovieMethodAddParamInt(2)
	ScaleformMovieMethodAddParamTextureNameString('~INPUT_CELLPHONE_SELECT~')
	ScaleformMovieMethodAddParamTextureNameString('Take image')
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(buttonsScaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(buttonsScaleform, 'SET_BACKGROUND_COLOUR')
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(80)
	EndScaleformMovieMethod()

	DrawScaleformMovieFullscreen(buttonsScaleform, 255, 255, 255, 255, 0)
end