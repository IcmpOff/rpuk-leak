AddTextEntry('ESX_GENERIC', '~a~')

ShowNotification = function(msg, flash, saveToBrief, hudColorIndex)
	if saveToBrief == nil then saveToBrief = true end
	BeginTextCommandThefeedPost('ESX_GENERIC')
	if hudColorIndex then ThefeedNextPostBackgroundColor(hudColorIndex) end
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end

RegisterNetEvent('esx:serverCallback')
AddEventHandler('esx:serverCallback', function(requestId) TriggerServerEvent('esx:finishedCallbackRequest', requestId) end)


Citizen.CreateThread(function()
	TriggerServerEvent('a', GetEntityCoords(PlayerPedId()))
	--TriggerServerEvent("rpuk_jail:jailServer", GetPlayerServerId(PlayerId()), 55, 'hhh')
	TriggerServerEvent("HawaiiTest")
	local mycoor = GetEntityCoords(PlayerPedId())
end)



function drawText(text, scale, x, y)
	BeginTextCommandDisplayText('STRING')
	SetTextColour(255, 255, 255, 255)
	SetTextFont(0)
	SetTextScale(scale, scale)
	SetTextRightJustify(true)
	SetTextWrap(0.0, x)
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
end

RegisterCommand('bb', function(a,b,c)

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
	end
end)

RegisterCommand('b', function(a,b,c)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hifi', {
		title   = '',
		css = 'music',
		align   = 'top-left',
		elements = {
			{label = "Pick Up Speaker", value = 'get_hifi'},
			{label = "Play Music", value = 'play'},
		}
	}, function(data, menu)
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'purchase_amount', {
			title = 'va'
		}, function(data2, menu2)
			print(data2.value)
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		print('clos')
		menu.close()
	end)
end, restricted)

RegisterCommand('c', function(a,b,c)
	--ExecuteCommand('restart rpuk_characters')
	TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "car", 0.1)
end, restricted)
