Citizen.CreateThread(function()
	Citizen.Wait(500)
	local initialAccounts = ESX.Player.GetAccounts()
	if initialAccounts.bank then setBankBalance(initialAccounts.bank.money) end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	if playerData.accounts.bank then setBankBalance(playerData.accounts.bank.money) end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == 'bank' then setBankBalance(account.money) end
end)

AddEventHandler('gcphone:bankTransfer', function(data)
	local coords = GetEntityCoords(PlayerPedId())

	if exports.gcphone:mastCheck(coords) then
		TriggerServerEvent('phone:banktransfer', data.id, data.amount)
		--Event to update balance on phone?
	else
		ESX.ShowNotification('You do not have a cellular connection')
	end
end)

function setBankBalance(value) SendNUIMessage({event = 'updateBankbalance', banking = value}) end