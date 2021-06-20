local Comp_Config, occupied = {}, false

Comp_Config.NPCs = {
	{model = "cs_andreas", location = vector4(-535.62, -195.85, 37.22, 67.27), anim = {"WORLD_HUMAN_CLIPBOARD"}, spawned = false},
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local canSleep = true

		if not occupied then
			for i=1, #Comp_Config.NPCs, 1 do
				local distance = GetDistanceBetweenCoords(coords, Comp_Config.NPCs[i].location[1], Comp_Config.NPCs[i].location[2], Comp_Config.NPCs[i].location[3], true)
				if distance < 50.0 and not Comp_Config.NPCs[i].spawned then
					WaitForModel(Comp_Config.NPCs[i].model)
					local pedHandle = CreatePed(5, Comp_Config.NPCs[i].model, Comp_Config.NPCs[i].location[1], Comp_Config.NPCs[i].location[2], Comp_Config.NPCs[i].location[3] , Comp_Config.NPCs[i].location[4], false)
					SetEntityAsMissionEntity(pedHandle, true, true)
					SetBlockingOfNonTemporaryEvents(pedHandle, true)
					SetModelAsNoLongerNeeded(Comp_Config.NPCs[i].model)
					SetEntityCanBeDamaged(pedHandle, false)
					FreezeEntityPosition(pedHandle, true)
					if Comp_Config.NPCs[i].anim then
						if Comp_Config.NPCs[i].anim[2] then
							RequestAnimDict(Comp_Config.NPCs[i].anim[1])
							while not HasAnimDictLoaded(Comp_Config.NPCs[i].anim[1]) do
								Citizen.Wait(10)
							end
							TaskPlayAnim(pedHandle, Comp_Config.NPCs[i].anim[1], Comp_Config.NPCs[i].anim[2], 8.0, -8.0, -1, 2, 0.0, 0, 0, 0)
						else
							TaskStartScenarioInPlace(pedHandle, Comp_Config.NPCs[i].anim[1], 0, true)
						end
					end
					Comp_Config.NPCs[i].spawned = true
				elseif distance < 1.5 and not occupied then
					local text_coord = vector3(Comp_Config.NPCs[i].location[1], Comp_Config.NPCs[i].location[2], Comp_Config.NPCs[i].location[3] + 1.3)
					ESX.Game.Utils.DrawText3D(text_coord, "[~p~Compensation Claims~s~]\nPress [~g~E~s~] To Check", 0.5, 6)
					canSleep = false
					if IsControlJustReleased(0, 38) then
						occupied = true
						open_comps()
					end
				end
			end
		end

		if canSleep then
			Citizen.Wait(2000)
		end
	end
end)

function open_comps()
	ESX.TriggerServerCallback('rpuk:compdata', function(returned)
		local elements = {
			head = {"Items (Quantity)", "Note", "Date", " "},
			rows = {}
		}
		for i=1, #returned, 1 do
			table.insert(elements.rows, {
				data = returned[i], claim_id = returned[i].id,
				cols = {
					returned[i].itm_string,
					returned[i].com_note,
					returned[i].com_date,
					'{{' .. "Claim Compensation" .. '|claim_comp}}' -- the value
				}
			})
		end
		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'compensation_client', elements, function(data, menu)
			if data.value == 'claim_comp' then
				TriggerServerEvent('rpuk:compclaim', data.data.id)
				ESX.UI.Menu.CloseAll()
				Citizen.Wait(2000)
				occupied = false
			end
		end, function(data, menu)
			occupied = false
			ESX.UI.Menu.CloseAll()
		end)
	end)
end

function WaitForModel(model_input)
	model = GetHashKey(model_input)	
    if not IsModelValid(model) then
        return
    end
	if not HasModelLoaded(model) then
		RequestModel(model)
	end	
	while not HasModelLoaded(model) do
		Citizen.Wait(1000)
	end
end