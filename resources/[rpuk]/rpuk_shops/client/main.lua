-- Update the banks list
ESX.TriggerServerCallback('rpuk_robberies:getAll', function(bankInfo)
	Config.Banks = bankInfo -- todo
end)

AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() and inMenu then
		ESX.UI.Menu.CloseAll()
	end
end)