local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
	}

local interactions = {}
local blockbuttons = false
local menuopen = false
local currentCameraIndex = 0
local currentCameraIndexIndex = 0
local createdCamera = 0

function getDistance(coords1, coords2)
	return Vdist2(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z)
end

function Draw3DText(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.02+ factor, 0.03, 110, 110, 110, 75)
end

function ChangeSecurityCamera(x, y, z, r)
	if createdCamera ~= 0 then
		DestroyCam(createdCamera, 0)
		createdCamera = 0
	end

	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	SetCamCoord(cam, x, y, z)
	SetCamRot(cam, r.x, r.y, r.z, 2)
	RenderScriptCams(1, 0, 0, 1, 1)

	createdCamera = cam
end

function CloseSecurityCamera()
	DestroyCam(createdCamera, 0)
	RenderScriptCams(0, 0, 1, 1, 1)
	createdCamera = 0
	ClearTimecycleModifier("scanline_cam_cheap")
	SetFocusEntity(GetPlayerPed(PlayerId()))
end

function CreateInstuctionScaleform(scaleform)
	local scaleform = RequestScaleformMovie(scaleform)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(10)
	end

	PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
	PushScaleformMovieFunctionParameterInt(200)
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, Keys["RIGHT"], true))
	InstructionButtonMessage("NEXT CAMERA")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(1)
	PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, Keys["LEFT"], true))
	InstructionButtonMessage("PREVIOUS CAMERA")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(4)
	PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, Keys["BACKSPACE"], true))
	InstructionButtonMessage("CLOSE CAMERA")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(80)
	PopScaleformMovieFunctionVoid()

	return scaleform
end

function InstructionButtonMessage(text)
	BeginTextCommandScaleformString("STRING")
	AddTextComponentScaleform(text)
	EndTextCommandScaleformString()
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if blockbuttons then
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 257, true)
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 263, true)
			DisableControlAction(2, Keys['R'], true)
			DisableControlAction(2, Keys['SPACE'], true)
			DisableControlAction(2, Keys['Q'], true)
			DisableControlAction(2, Keys['TAB'], true)
			DisableControlAction(2, Keys['F'], true)
			DisableControlAction(2, Keys['F1'], true)
			DisableControlAction(2, Keys['F2'], true)
			DisableControlAction(2, Keys['F3'], true)
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['F7'], true)
			DisableControlAction(2, Keys['F10'], true)
		else
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(500)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(interactions) do
		while getDistance(coords, v.pos) < v.dist do
			Wait(0)
			ped = PlayerPedId()
			coords = GetEntityCoords(ped)
			if getDistance(coords, v.pos) < v.dist then
			Draw3DText(v.pos.x, v.pos.y, v.pos.z+1.5, v.text)
			if IsControlJustReleased(0, Keys["E"]) then
				v.action()
				Wait(250)
			end
			end
		end
		end
	end
	end)

	for k,v in pairs(Config.CCTVPanel) do
	table.insert(interactions, {
		text = "Press E to use CCTV",
		action = function()
		CCTVMenu()
		end,
		pos = v,
		dist = 9
	})
	end

function CCTVMenu()
	if not menuopen then
	menuopen = true
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), "rpuk_cctv",
	{
		css = "interaction",
		align = "top-left",
		elements = {
		{
			label = "Pacific Standard Bank",
			value = "bankcctv"
		}
		}
	}, function(data, menu)
		if data.current.value == 'bankcctv' then
		blockbuttons = true
		local firstCamx = Config.Locations[1].bankCameras[1].x
		local firstCamy = Config.Locations[1].bankCameras[1].y
		local firstCamz = Config.Locations[1].bankCameras[1].z
		local firstCamr = Config.Locations[1].bankCameras[1].r
		SetFocusArea(firstCamx, firstCamy, firstCamz, firstCamx, firstCamy, firstCamz)
		ChangeSecurityCamera(firstCamx, firstCamy, firstCamz, firstCamr)
		SendNUIMessage({
			type = "enablecam",
			label = Config.Locations[1].bankCameras[1].label,
			box = Config.Locations[1].bankCamLabel.label
		})
		currentCameraIndex = 1
		currentCameraIndexIndex = 1
		menuopen = false
		TriggerEvent('rpuk_cctv:freezeClient', true)
		menu.close()
		CCTV()
		end
	end, function(data, menu)
		ESX.UI.Menu.CloseAll()
		menuopen = false
	end)
	end
end

function CCTV()
	Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if createdCamera ~= 0 then
			local instructions = CreateInstuctionScaleform("instructional_buttons")

			DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
			SetTimecycleModifier("scanline_cam_cheap")
			SetTimecycleModifierStrength(2.0)

			-- CLOSE CAMERAS
		if IsControlJustPressed(0, Keys["BACKSPACE"]) then
			PlaySoundFrontend( 0, "NAV_UP_DOWN", "HUD_MINI_GAME_SOUNDSET", true );
				CloseSecurityCamera()
				SendNUIMessage({
				type = "disablecam",
				})
				blockbuttons = false
			currentCameraIndex = 0
			currentCameraIndexIndex = 0
			TriggerEvent('rpuk_cctv:freezeClient', false)
		end
		end

		-- GO BACK CAMERA
		if IsControlJustPressed(0, Keys["LEFT"]) then
		 PlaySoundFrontend( 0, "NAV_UP_DOWN", "HUD_MINI_GAME_SOUNDSET", true );
			local newCamIndex

			if currentCameraIndexIndex == 1 then
			newCamIndex = #Config.Locations[currentCameraIndex].bankCameras
			else
			newCamIndex = currentCameraIndexIndex - 1
			end

			local newCamx = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].x
			local newCamy = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].y
			local newCamz = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].z
			local newCamr = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].r

			SetFocusArea(newCamx, newCamy, newCamz, newCamx, newCamy, newCamz)
			SendNUIMessage({
			type = "updatecam",
			label = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].label
			})

			ChangeSecurityCamera(newCamx, newCamy, newCamz, newCamr)
			currentCameraIndexIndex = newCamIndex
		end

		-- GO FORWARD CAMERA
		if IsControlJustPressed(0, Keys["RIGHT"]) then
		 PlaySoundFrontend( 0, "NAV_UP_DOWN", "HUD_MINI_GAME_SOUNDSET", true );
			local newCamIndex

			if currentCameraIndexIndex == #Config.Locations[currentCameraIndex].bankCameras then
			newCamIndex = 1
			else
			newCamIndex = currentCameraIndexIndex + 1
			end

			local newCamx = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].x
			local newCamy = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].y
			local newCamz = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].z
			local newCamr = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].r

			SendNUIMessage({
			type = "updatecam",
			label = Config.Locations[currentCameraIndex].bankCameras[newCamIndex].label
			})

			ChangeSecurityCamera(newCamx, newCamy, newCamz, newCamr)
		currentCameraIndexIndex = newCamIndex
		end

		-- if Config.Locations[currentCameraIndex].bankCameras[currentCameraIndexIndex].canRotate then
		local getCameraRot = GetCamRot(createdCamera, 2)

			-- ROTATE LEFT
			if IsControlPressed(1, Keys['N4']) then
			SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z + 0.7, 2)
			 PlaySoundFrontend( 0, "NAV_UP_DOWN", "HUD_MINI_GAME_SOUNDSET", true );
			end

			-- ROTATE RIGHT
			if IsControlPressed(1, Keys['N6']) then
			SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z - 0.7, 2)
			 PlaySoundFrontend( 0, "NAV_UP_DOWN", "HUD_MINI_GAME_SOUNDSET", true );
		end
		end
	-- end
	end)
end

RegisterNetEvent('rpuk_cctv:freezeClient')
AddEventHandler('rpuk_cctv:freezeClient', function(freeze)
	local ped = PlayerPedId()
	FreezeEntityPosition(ped, freeze)
end)