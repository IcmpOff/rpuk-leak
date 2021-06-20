
RegisterNetEvent('rpuk_health:docPed')

-- Threads

Citizen.CreateThread(function()
	for k,v in pairs(config.npc) do
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
	end

	Wait(10000)
	--	deletePeds()
end)

AddEventHandler('rpuk_health:docPed', function()
	TriggerEvent("mythic_notify:client:SendAlert", {
		text = "Welcome, Patient!",
		type = 'inform',
	})
	Citizen.Wait(3000)
	TriggerEvent("mythic_notify:client:SendAlert", {
		text = "Understand what happens here is upto you, I will give you the equipment however I am not claiming responsablity for what you do with it.",
		type = 'inform',
		length = 6000,
	})
	Citizen.Wait(3000)
	TriggerEvent("mythic_notify:client:SendAlert", {
		text = "I want £"..config.price.." cash and then we can continue",
		type = 'inform',
		length = 5000,
	})
	Citizen.Wait(2000)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), "rpuk_health",
	{
		css = "",
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
		TriggerServerEvent('rpuk_health:payDocPed')
		ESX.UI.Menu.CloseAll()
		TriggerEvent("mythic_notify:client:SendAlert", {
			text = "You need to understand that the equipment can only be used within these four walls",
			type = 'inform',
			length = 6000,
		})
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