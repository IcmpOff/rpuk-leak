local api_token = GetConvar("panel_access_token", "")
if api_token == "" then
    print("No panel_access_token defined. RPUK Panel access is disabled.")
    return
end

function getPlayerIdForIdentifier(identifier)
    for _, id in ipairs(GetPlayers()) do
        local identifiers = GetPlayerIdentifiers(id)

        for _,v in pairs(identifiers) do 
            if v == identifier then
                return id
            end
        end
    end

    return nil
end

local handlers = {
    ban = function(req, res, params)
        if
            not params.identifier or type(params.identifier) ~= 'string' or
            not params.reason or type(params.reason) ~= 'string'
        then
            res.send(json.encode({ error = 'Bad request.' }), 400)
            return
        end

        local xSource = getPlayerIdForIdentifier(params.identifier)
        if xSource == nil then
            res.send(json.encode({ online = false }), 200)
            return
        end
		local esxData = ESX.GetPlayerFromIdentifier(params.identifier)
		if esxData then
			TriggerClientEvent('chat:addMessage', -1, {template = 
			'<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(25, 25, 25, 0.6); border-radius: 3px;"><img style="position:absolute;right:0%;margin-top:auto;height:1.6vw;"src="https://www.roleplay.co.uk/images/rplogo.png" />^1 {0} {1}</div>',
			args = { esxData.firstname .. " " .. esxData.lastname, " Was Banned from the server" }})
		end

        DropPlayer(xSource, "You have been banned " .. params.reason)

        res.send(json.encode({ online = true }), 200)
    end,
    kick = function(req, res, params)
        if
            not params.identifier or type(params.identifier) ~= 'string' or
            not params.reason or type(params.reason) ~= 'string'
        then
            res.send(json.encode({ error = 'Bad request.' }), 400)
            return
        end

        local xSource = getPlayerIdForIdentifier(params.identifier)
        if xSource == nil then
            res.send(json.encode({ online = false }), 200)
            return
        end

		local esxData = ESX.GetPlayerFromIdentifier(params.identifier)
		if esxData then
			TriggerClientEvent('chat:addMessage', -1, {template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(25, 25, 25, 0.6); border-radius: 3px;"><img style="position:absolute;right:0%;margin-top:auto;height:1.6vw;"src="https://www.roleplay.co.uk/images/rplogo.png" /> {0} {1}</div>',
			args = { esxData.firstname .. " " .. esxData.lastname, "Was kicked from the server. ^3Reason: " .. params.reason }})
        end
		res.send(json.encode({ online = true }), 200)

        DropPlayer(xSource, "Kicked: " .. params.reason)
    end,
    getPlayers = function(req, res, params)
		local players = ESX.GetBasicPlayerInfo()

        res.send(json.encode({ players = players }), 200)
    end,
    restart = function(req, res, params)
        print('Server shutdown invoked!')
        TriggerEvent('rpuk:shutdown_server')
        res.send(json.encode({}), 200)
	end,
	announce = function(req, res, params)
		if not params.message or type(params.message) ~= 'string' then
            res.send(json.encode({ error = 'Bad request.' }), 400)
            return
        end
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(255, 20, 20, 0.3); border-radius: 3px;"><img style="position:absolute;z-index:10;right:0;height:3vw;top:auto;"src="https://www.roleplay.co.uk/images/rplogo.png" /> <b>STAFF ANNOUNCEMENT</b><br> {1}</div><br><br>',
			args = {'', params.message}
		})
		res.send(json.encode({}), 200)
	end
}

SetHttpHandler(function(req, res)
    -- We only accept post requests
    if req.method ~= 'POST' then
        res.send(json.encode({ error = 'Method not allowed' }), 405)
        return
    end

    req.setDataHandler(function(body)
        local data = json.decode(body)

        -- Check required fields are present
        if
            not data or type(data) ~= 'table' or
            not data.api_key or type(data.api_key) ~= 'string' or
            not data.params or type(data.params) ~= 'table' or
            not data.type or type(data.type) ~= 'string'
        then
            res.send(json.encode({ error = 'Bad request.'}), 400)
            return
        end

        -- If API token isn't correct exit out
        if data.api_key ~= api_token then
            print('Wrong token received: "'..data.api_key..'"')
            res.send(json.encode({ error = 'Unauthenticated' }), 401)
            return
        end

        local handler = handlers[data.type]
        if handler == nil then
            res.send(json.encode({ error = 'Unknown Handler' }), 400)
            return
        end

        handler(req, res, data.params)
    end)

end)