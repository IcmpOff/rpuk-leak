local transactions = {}
local loggingEnabled = true
local flushPeriod = 1 * 60 * 1000
local insertLogQuery = -1

MySQL.Async.store([===[
    INSERT INTO rpuk_logs (
        identifier, character_id, character_name, log_type, log_subtype, log_value,
        log_description, time, current_cash_value, current_bank_value
    )
    VALUES ?
    ]===], function(id)
        insertLogQuery = id

        onLogsReady()
    end)


AddEventHandler('rpuk_log:new_log', function(steamId, charId, charName, type, subType, value, description, cashValue, bankValue)
    if loggingEnabled then
        if type == "Transaction" then
            table.insert(transactions, {
                steamId, charId, charName, 
                type, subType, value,
                description, os.time(),
                cashValue, bankValue
            })
        end
    end
end)

function storeLogsInDatabase()
    if #transactions == 0 then
        return
    end

    local timeStart = os.clock()
    MySQL.Sync.execute(insertLogQuery, { transactions })

    print(('[rpuk_snippets] [^2INFO^7] storeLogsInDatabase() took %.0f seconds (%d items)'):format(os.clock() - timeStart, #transactions))

    transactions = {}
end

function storeTranscations()
    storeLogsInDatabase()
    SetTimeout(flushPeriod, storeTranscations)
end

function onLogsReady()
    SetTimeout(flushPeriod, storeTranscations)
end
