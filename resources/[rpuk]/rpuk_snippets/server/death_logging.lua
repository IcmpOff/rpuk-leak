local insertDeathQuery = -1

MySQL.Async.store([===[
    INSERT INTO rpuk_logs_deaths (character_id_victim, character_id_killer, death_cause, death_time)
    VALUES (@character_id_victim, @character_id_killer, @death_cause, @death_time)
]===], function(id) insertDeathQuery = id end)


RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local xKiller

        if data.killedByPlayer then xKiller = ESX.GetPlayerFromId(data.killerServerId) end

        MySQL.Async.execute(insertDeathQuery, {
            ["@character_id_victim"] = xPlayer.getCharacterId(),
            ["@character_id_killer"] = xKiller and xKiller.getCharacterId() or nil,
            ["@death_cause"] = data.deathCause,
            ["@death_time"] = os.time()
        })
    end
end)
