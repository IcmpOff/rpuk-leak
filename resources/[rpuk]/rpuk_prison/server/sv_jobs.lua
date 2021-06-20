RegisterNetEvent('rpuk_prison:resultFromJob')
AddEventHandler('rpuk_prison:resultFromJob', function(type)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = config.items[math.random(#config.items)]
	local quantity = 1

	if type == "search" then
		if math.random(1,100) <= 50 then
			if not xPlayer.canCarryItem(item, quantity) then
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 2500, type = 'error', text = "Item too heavy"})
				return
			end
			xPlayer.addInventoryItem(item, quantity)
			TriggerClientEvent("mythic_notify:client:SendAlert", _source, {
			text = "You found " .. quantity .. " " .. ESX.GetItemLabel(item),
			type = 'success',})
		else
			TriggerClientEvent("mythic_notify:client:SendAlert", _source, {
				text = "You found nothing!",
				type = 'error',
			})
		end
	else
		local data = MySQL.Sync.fetchAll('SELECT * FROM prison_sentences WHERE status = "jail" AND rpuk_charid = @rpuk_charid',{["@rpuk_charid"] = xPlayer.rpuk_charid})[1]
		local randomTime = math.random(1,4)
		if data then
			if data.remaining_time >= data.time*0.5 then
				MySQL.Sync.execute("UPDATE prison_sentences SET remaining_time = @remaining_time WHERE id = @id", {
					["@id"] = data.id,
					["@remaining_time"] = data.remaining_time-randomTime
				})
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 6000, type = 'inform', text = 'Thank you for doing that, we appreciate you! You now have '..data.remaining_time-randomTime.. ' months' })
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 6000, type = 'inform', text = 'Thank you for doing that, we appreciate you!' })
			end
		end
	end
end)