ESX.RegisterServerCallback("rpuk_prison:fetchCurrentJailStatus", function(source, cb)
	local result = MySQL.Sync.fetchAll('SELECT p.*, u.firstname, u.lastname FROM prison_sentences p JOIN users u ON p.rpuk_charid = u.rpuk_charid WHERE p.status = "jail"',{})
	local data = {}
	for k, v in pairs(result) do
		if ESX.GetPlayerFromCharId(v.rpuk_charid) then
			table.insert(data, {
				id = v.id,
				name = v.firstname.. ' '.. v.lastname,
				remaining_time = v.remaining_time,
				time = v.time,
				arresting_officer = v.arresting_officer,
				reason = v.reason,
				rpuk_charid = v.rpuk_charid
			})
		end
	end
	cb(data)
end)

RegisterNetEvent("rpuk_prison:changeSentenceTime")
AddEventHandler("rpuk_prison:changeSentenceTime", function(data, time)
	local _source = source
	local result = MySQL.Sync.execute("UPDATE prison_sentences SET remaining_time = @remaining_time WHERE id = @id", {
		["@id"] = data.id,
		["@remaining_time"] = time
	})
	if result then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 5000, type = 'inform', text = 'You have updated the sentence to '..time..' months' })
	end
end)


RegisterNetEvent("rpuk_prison:lockdown")
AddEventHandler("rpuk_prison:lockdown", function(state)
	TriggerClientEvent("rpuk_prison:startLockdown", -1, state)
end)