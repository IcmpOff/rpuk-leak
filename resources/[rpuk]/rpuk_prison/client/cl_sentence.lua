local signmodel = GetHashKey("prop_police_id_board")
local textmodel = GetHashKey("prop_police_id_text")
local SignProp1 = {}
local SignProp2 = {}
local text = {}
local scaleform = {}
local playingAnim = false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if playingAnim then
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 257, true)
			DisableControlAction(0, 73, true)
			DisableControlAction(2, 263, true)
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	scaleform = LoadScaleform("mugshot_board_01")
	text = CreateNamedRenderTargetForModel("ID_TEXT", textmodel)

	while text do
		Citizen.Wait(1)
		SetTextRenderId(text) -- set render target
		SetScriptGfxDrawOrder(4)
		SetScriptGfxDrawBehindPausemenu(true)
		SetScriptGfxDrawBehindPausemenu(false)
		SetScriptGfxDrawBehindPausemenu(true)
		DrawScaleformMovie(scaleform, 0.40, 0.35, 0.80, 0.75, 255, 255, 255, 255, 0)
		SetScriptGfxDrawBehindPausemenu(false)
		SetTextRenderId(GetDefaultScriptRendertargetRenderId())
	end
end)

RegisterNetEvent("rpuk_prison:createSign")
AddEventHandler("rpuk_prison:createSign", function(name, time)
	local ped = PlayerPedId()
	SignProp1 = CreateObject(signmodel, 1, 1, 1, false, true, false)
	SignProp2 = CreateObject(textmodel, 1, 1, 1, false, true, false)
	AttachEntityToEntity(SignProp1, ped, GetPedBoneIndex(ped, 58868), 0.12, 0.24, 0.0, 5.0, 0.0, 70.0, true, true, false, false, 2, true);
	AttachEntityToEntity(SignProp2, ped, GetPedBoneIndex(ped, 58868), 0.12, 0.24, 0.0, 5.0, 0.0, 70.0, true, true, false, false, 2, true);

	local ScaleformMovie = RequestScaleformMovie("MUGSHOT_BOARD_01")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
	while HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
		PushScaleformMovieFunction(ScaleformMovie, "SET_BOARD")
		PushScaleformMovieFunctionParameterString(time.." Months")
		PushScaleformMovieFunctionParameterString(capEachFirst(name))
		PushScaleformMovieFunctionParameterString("LOS SANTOS POLICE SERVICE")
		PushScaleformMovieFunctionParameterString(0)
		PushScaleformMovieFunctionParameterString(0)
		PushScaleformMovieFunctionParameterString("")
		PushScaleformMovieFunctionParameterString(0)
		PopScaleformMovieFunctionVoid()
	end
end)

RegisterNetEvent("rpuk_prison:sendToPrison")
AddEventHandler("rpuk_prison:sendToPrison", function(sentenceId)
	local PlayerPed = PlayerPedId()
	local modelHash = -1320879687

	TriggerEvent("rpuk_restrain:unrestrain")
	TriggerEvent("rpuk_hud:toggleHud", false)

	DoScreenFadeOut(400)
	Citizen.Wait(800)
	SetEntityCoords(PlayerPed, config.postions.prisonerPictureLocation.x, config.postions.prisonerPictureLocation.y, config.postions.prisonerPictureLocation.z - 1)
	SetEntityHeading(PlayerPed, config.postions.prisonerPictureLocation.h)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, config.clothes.male)
		else
			TriggerEvent('skinchanger:loadClothes', skin, config.clothes.female)
		end
	end)
	Citizen.Wait(1200)
	LoadModel(modelHash)
	local PolicePed = CreatePed(5, modelHash, config.postions.aiSpawnLocation.x, config.postions.aiSpawnLocation.y, config.postions.aiSpawnLocation.z, config.postions.aiSpawnLocation.h, false)
	TaskStartScenarioInPlace(PolicePed, "WORLD_HUMAN_PAPARAZZI", 0, false)
	spawnCamera()
	Citizen.Wait(900)
	DoScreenFadeIn(600)
	playingAnim = true
	TriggerServerEvent("rpuk_prison:getSignCredits", sentenceId)
	LoadAnim("mp_character_creation@customise@male_a")
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "OK_NEXT", 0.8)
	Wait (1000)
	TaskPlayAnim(PlayerPed, "mp_character_creation@customise@male_a", "intro", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	Wait(3000)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "StandStill", 0.8)
	Wait (6000)
	TaskPlayAnim(PlayerPed, "mp_character_creation@customise@male_a", "loop", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	Wait (800)
	TaskPlayAnim(PlayerPed, "mp_character_creation@customise@male_a", "clothes_a", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	Wait (800)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "LookLeft", 0.8)
	Wait (500)
	TaskPlayAnim(PlayerPed, "mp_character_creation@customise@male_a", "profile_l_intro", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	Wait (800)
	TaskPlayAnim(PlayerPed, "mp_character_creation@customise@male_a", "profile_l_loop", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	Wait (800)
	TaskPlayAnim(PlayerPed, "mp_character_creation@customise@male_a", "profile_l_outro", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	Wait(800)
	TaskPlayAnim(PlayerPed, "mp_character_creation@customise@male_a", "loop", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	Wait (800)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "LookRight", 0.8)
	Wait (500)
	TaskPlayAnim(PlayerPed, "mp_character_creation@customise@male_a", "profile_r_intro", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	Wait (800)
	TaskPlayAnim(PlayerPed, "mp_character_creation@customise@male_a", "profile_r_loop", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	Wait(800)
	TaskPlayAnim(PlayerPed, "mp_character_creation@customise@male_a", "profile_r_outro", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	Wait(800)
	TaskPlayAnim(PlayerPed, "mp_character_creation@customise@male_a", "loop", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	Wait (800)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "HoldSignStraight", 0.8)
	TaskPlayAnim(PlayerPed, "mp_character_creation@customise@male_a", "clothes_b", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	Wait (3500)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "WereDone147", 0.8)
	Wait (4000)
	playingAnim = false
	DoScreenFadeOut(500)
	Citizen.Wait(800)
	SetEntityCoords(PlayerPed, config.postions.cell.x, config.postions.cell.y, config.postions.cell.z)
	SetEntityHeading(PlayerPed, config.postions.cell.h)
	DeleteEntity(PolicePed)
	SetModelAsNoLongerNeeded(modelHash)
	Citizen.Wait(1000)
	DoScreenFadeIn(600)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "cell", 0.5)
	RenderScriptCams(false,  false,  0,  true,  true)
	FreezeEntityPosition(PlayerPed, false)
	DestroyCam(config.postions.cameraPostion.cameraId)
	DeleteObject(SignProp1)
	DeleteObject(SignProp2)
	TriggerEvent("rpuk_hud:toggleHud", true)
	Citizen.Wait(5000)
	prisonRadius()
	TriggerEvent('mythic_notify:client:SendAlert', {length = 120000, type = 'inform', text = 'Welcome to HMP Bolingbroke! <br> <br> This is no place for fun, this a chance for you to understand that what you did was wrong and reflect on how your actions may have affected others. <br> <br> However, while you are here, you have the ability to work hard and keep the Prison tidy through tasks such as checking the stock, cleaning tables and washing the dishes (You can do this via Caps Wheel). <br> <br> While working for the prison if... and only if... your behaviour has been good, we may look at reducing your sentence. <br> <br> While here you can use the wall phones on the lower floor to check your remaining sentence while holding caps lock. <br> <br> Los Santos Prison Service' })
	TriggerServerEvent("rpuk_core:SavePlayer")
end)

RegisterNetEvent("rpuk_jail:jailWheel")
AddEventHandler("rpuk_jail:jailWheel", function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= nil and closestPlayer ~= -1 and closestDistance <= 3 then
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'offer_amount', {
			title = "Jail Time"
			}, function(data, menu)
			if data.value == nil or tonumber(data.value) == nil then
				TriggerEvent('mythic_notify:client:SendAlert', {length = 4000, type = 'error', text = 'Invalid Time' })
			else
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'offer_amount', {
					title = "Reason"
					}, function(data2, menu2)
					if data2.value == nil then
						TriggerEvent('mythic_notify:client:SendAlert', {length = 4000, type = 'error', text = 'Invalid Reason' })
					else
						TriggerServerEvent("rpuk_prison:jailPlayer", GetPlayerServerId(closestPlayer), data.value, data2.value)
						menu.close()
					end
				end, function(data2, menu2)
					menu.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'No one is close to jail!' })
	end
end)

-- TriggerEvent('chat:addSuggestion', '/jail', 'Jail a player.', {{ name="sessionID", help="SessionID of player"}, { name="time", help="Jail time between 0 - 1000"}, { name="reason", help="Reason why you are sending the player to jail."}})
-- RegisterCommand('jail', function(source, args, raw)
-- 	local target = tonumber(args[1])
-- 	local time = tonumber(args[2])
-- 	local reason = ""

-- 	for i=3,#args,1 do
-- 		reason = reason.." "..args[i]
-- 	end

-- 	if target ~= nil then
-- 		if time ~= nil then
-- 			if time < 1000 and time > 0 then
-- 				TriggerServerEvent("rpuk_prison:jailPlayer", target, time, reason)
-- 			else
-- 				TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'error', text = "You can not send someone to jail for "..time.."."})
-- 			end
-- 		else
-- 			TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'error', text = "Please enter the suspect's special ID" })
-- 		end
-- 	else
-- 		TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'error', text = 'Please enter a amount of time!' })
-- 	end
-- end)








