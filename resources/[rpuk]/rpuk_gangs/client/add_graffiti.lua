local inGraffitiMenu = false
local spawnedObj = nil
local spawnedCoords = nil
local spawnedRotation = nil

RegisterNetEvent('rpuk_gangs:graffiti')
AddEventHandler('rpuk_gangs:graffiti', function()
	if inGraffitiMenu then
		return
	end
	local playerPed = PlayerPedId()
	inGraffitiMenu = true
	spawnedCoords = GetEntityCoords(playerPed)
	spawnedObj = CreateObject(Config.gfxTags[ESX.Player.GetGangId()].model, spawnedCoords.x, spawnedCoords.y, spawnedCoords.z, false, false, false)

	SetEntityCoordsNoOffset(spawnedObj, spawnedCoords.x+1.0, spawnedCoords.y, spawnedCoords.z)
	SetEntityHeading(spawnedObj, GetEntityHeading(playerPed))
	spawnedRotation = GetEntityRotation(spawnedObj)

	while inGraffitiMenu do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(playerPed)
		local scaleform = ESX.Scaleform.PrepareBasicInstructional({{button = {168}, text = "Stop Graffiti"}, {button = {304}, text = "Spray Art"}, {button = {172, 173}, text = "X Coord"}, {button = {174, 175}, text = "Y Coord"}, {button = {14, 15}, text = "X Rotation"}, {button = {24, 25}, text = "Z Rotation"}})
		DrawScaleformMovieFullscreen(scaleform)
		SetEntityCoordsNoOffset(spawnedObj, spawnedCoords.x+1.0, spawnedCoords.y+1.0, spawnedCoords.z)
		SetEntityRotation(spawnedObj, spawnedRotation, 0, 1)
		DisableControlAction(0, 24)
		DisableControlAction(0, 25)
		DisableControlAction(0, 14)
		DisableControlAction(0, 15)
		DisableControlAction(0, 16)
		DisableControlAction(0, 17)
		DisableControlAction(0, 24)
		DisableControlAction(0, 25)
		DisableControlAction(0, 304)
		if IsControlJustReleased(1, 168) then
			stopGraffiti()
			TriggerServerEvent('returnItem', 'graffiti_spraycan')
		elseif IsControlPressed(1, 172) then
			spawnedCoords = vector3(spawnedCoords.x + 0.01, spawnedCoords.y, spawnedCoords.z)
		elseif IsControlPressed(1, 173) then
			spawnedCoords = vector3(spawnedCoords.x - 0.01, spawnedCoords.y, spawnedCoords.z)
		elseif IsControlPressed(1, 174) then
			spawnedCoords = vector3(spawnedCoords.x, spawnedCoords.y + 0.01, spawnedCoords.z)
		elseif IsControlPressed(1, 175) then
			spawnedCoords = vector3(spawnedCoords.x, spawnedCoords.y - 0.01, spawnedCoords.z)
		elseif IsDisabledControlPressed(0, 14) then
			spawnedRotation = vector3(spawnedRotation.x + 1.0, spawnedRotation.y, spawnedRotation.z)
		elseif IsDisabledControlPressed(0, 15) then
			spawnedRotation = vector3(spawnedRotation.x - 1.0, spawnedRotation.y, spawnedRotation.z)			
		elseif IsDisabledControlPressed(0, 24) then
			spawnedRotation = vector3(spawnedRotation.x, spawnedRotation.y, spawnedRotation.z + 0.5)
		elseif IsDisabledControlPressed(0, 25) then
			spawnedRotation = vector3(spawnedRotation.x, spawnedRotation.y, spawnedRotation.z - 0.5)		
		elseif IsDisabledControlJustReleased(1, 304) then
			local netCoords = GetEntityCoords(spawnedObj)
			local netRotation = GetEntityRotation(spawnedObj)
			DeleteEntity(spawnedObj)
			TriggerEvent("mythic_progbar:client:progress", {
				name = "gang_gfx_tagging",
				duration = 20000,
				label = "Tagging",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
					closeInv = true,
				},
				animation = {
					animDict = "switch@franklin@lamar_tagging_wall",
					anim = "lamar_tagging_wall_exit_lamar",
					flags = 49,
					task = nil,
				},
				prop = {
					model = "ng_proc_spraycan01b",
					bone = 28422,
					coords = { x = 0.0, y = 0.0, z = 0.0 },
					rotation = { x = 45.0, y = 0.0, z = 45.0 },
				}
			  }, function(status)
				if not status then
					local netSpray = CreateObject(Config.gfxTags[ESX.Player.GetGangId()].model, netCoords.x, netCoords.y, netCoords.z, 1, 1, 1)
					SetEntityCoordsNoOffset(netSpray, netCoords)
					SetEntityRotation(netSpray, netRotation, 0, 1)
				else
					TriggerServerEvent('returnItem', 'graffiti_spraycan')
				end
			end)
			stopGraffiti()
		end	
	end


end)

function stopGraffiti()
	inGraffitiMenu = false
	DeleteEntity(spawnedObj)
	spawnedObj = nil
	spawnedCoords = nil
end