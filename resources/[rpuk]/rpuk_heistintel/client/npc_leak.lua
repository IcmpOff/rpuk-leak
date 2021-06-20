local interactions = {}

RegisterNetEvent('rpuk_heistintel:copPed')

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

function getDistance(coords1, coords2)
	return Vdist2(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z)
end

-- Threads
Citizen.CreateThread(function()
	for k,v in pairs(config.leaks) do
		RequestModel(v.ped)
		while not HasModelLoaded(v.ped) do
			Wait(1)
		end

		local ped = CreatePed(0, v.ped, v.pos.x, v.pos.y, v.pos.z, v.pos.h, false, true)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetPedCanPlayAmbientAnims(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		SetPedDiesWhenInjured(ped, false)
		SetPedCanRagdollFromPlayerImpact(ped, false)
		SetEntityInvincible(ped, true)
		FreezeEntityPosition(ped, true)
		TaskStartScenarioInPlace(ped, v.anim, 0, true);

		table.insert(interactions,
		{
			pedId = ped,
			text = v.text,
			action = function()
				TriggerEvent('rpuk_heistintel:'..k)
			end,
			pos = v.pos,
			dist = v.dist
		})
	end

	Wait(10000)
	--	deletePeds()
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
					if IsControlPressed(0, 38) then
						v.action()
						Wait(5000)
					end
				end
			end
		end
	end
end)

function deletePeds()
	local temp = {}
	for k,v in pairs(interactions) do
		if v.pedId ~= nil then
			DeletePed(v.pedId)
		else
			table.insert(temp, v)
		end
	end
	interactions = temp
end

AddEventHandler('rpuk_heistintel:copPed', function()
	TriggerEvent("mythic_notify:client:SendAlert", {
		text = "You looking for me?",
		type = 'inform',
	})

	Citizen.Wait(3000)
	TriggerEvent("mythic_notify:client:SendAlert", {
		text = "Lets get some things straight. Im only letting you know this information because you have been vouched for so dont fuck up!",
		type = 'inform',
		length = 6000,
	})

	Citizen.Wait(3000)
	TriggerEvent("mythic_notify:client:SendAlert", {
		text = "I want $"..config.intelleak.." cash and I will continue!",
		type = 'inform',
		length = 5000,
	})

	Citizen.Wait(2000)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), "rpuk_heistintel",
		{
			css = "cokain_bar_contact",
			align = "top-left",
			elements = {
				{
					label = "Fine",
					value = true
				},
				{
					label = "Nevermind",
					value = false
				}
			}
		},
		function(data, menu)
			if data.current.value then
				TriggerServerEvent('rpuk_lester:paycopPed')
				ESX.UI.Menu.CloseAll()
			else
				TriggerEvent("mythic_notify:client:SendAlert", {
					text = "Dont waste my time! Get Lost!",
					type = 'inform',
				})
				menu.close()
			end
		end, function(data, menu)
		menu.close()
	end)
end)