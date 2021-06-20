local pTypes = {
	"hallow_pot_1",
	"hallow_pot_2",
	"hallow_pot_3",
	"hallow_pot_4",
}

Citizen.CreateThread(function()
	for _, item in pairs(pTypes) do
		ESX.RegisterUsableItem(item, function(source)
			local xPlayer = ESX.GetPlayerFromId(source)
			TriggerClientEvent('rpuk_halloween:use_potion', source, item)
			xPlayer.removeInventoryItem(item, 1)
			Citizen.Wait(5000)
		end)
	end
end)