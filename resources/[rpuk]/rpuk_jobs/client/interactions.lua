interactions = {}
activeInteractions = {}

local defaultInteraction = {
	draw3dtext = {
		textScale = {0.4, 0.4},
		textFont = 4,
		textProportional = 1,
		colour = {
			r = 255, -- Red
			g = 255, -- Green
			b = 255, -- Blue
			a = 215, -- Alpha
		},
		textEntry = "STRING",
		textCentre = 1,
		background = false
	},
	interactionKey = 38,
	dist = 12,
	canInteractWithCar = false
}

function Draw3DText(data)
	local onScreen,_x,_y=World3dToScreen2d(data.pos.x,data.pos.y,data.pos.z+1.5)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(data.textScale[1], data.textScale[2])
	SetTextFont(data.textFont)
	SetTextColour(data.colour.r, data.colour.g, data.colour.b, data.colour.a)
	SetTextEntry(data.textEntry)
	SetTextCentre(data.textCentre)
	AddTextComponentString(data.text)
	DrawText(_x,_y)
	if data.background then
		local factor = (string.len(data.text)) / 370
		DrawRect(_x,_y+0.0125, 0.02 + factor, 0.05, 110, 110, 110, 75)
	end
end

function createInteraction(data)
	local self = {}
	self.id = data.id
	self.pos = data.pos
	self.text = data.text
	self.action = data.action
	self.actionOnEnter = data.actionOnEnter
	self.actionOnLeave = data.actionOnLeave
	self.dist = (data.dist == nil and defaultInteraction.dist or data.dist)
	self.interactionKey = (data.interactionKey == nil and defaultInteraction.interactionKey or data.interactionKey)
	self.textScale = (data.textScale == nil and defaultInteraction.draw3dtext.textScale or data.textScale)
	self.textFont = (data.textFont == nil and defaultInteraction.draw3dtext.textFont or data.textFont)
	self.textProportional = (data.textProportional == nil and defaultInteraction.draw3dtext.textProportional or data.textProportional)
	self.colour = (data.colur == nil and
	{
		r = defaultInteraction.draw3dtext.colour.r,
		g = defaultInteraction.draw3dtext.colour.g,
		b = defaultInteraction.draw3dtext.colour.b,
		a = defaultInteraction.draw3dtext.colour.a
	} or
	{
		r = (data.colour.r == nil and defaultInteraction.draw3dtext.colour.r or data.colour.r),
		g = (data.colour.g == nil and defaultInteraction.draw3dtext.colour.g or data.colour.g),
		r = (data.colour.b == nil and defaultInteraction.draw3dtext.colour.b or data.colour.b),
		r = (data.colour.a == nil and defaultInteraction.draw3dtext.colour.r or data.colour.a),
	})
	self.textEntry = (data.textEntry == nil and defaultInteraction.draw3dtext.textEntry or data.textEntry)
	self.textCentre = (data.textCentre == nil and defaultInteraction.draw3dtext.textCentre or data.textEntry)
	self.background = (data.background == nil and defaultInteraction.draw3dtext.background or data.background)
	self.canInteractWithCar = (data.canInteractWithCar == nil and defaultInteraction.canInteractWithCar or data.canInteractWithCar)
	self.refreshInteraction = false
	self.blacklist = (data.blacklist == nil and {} or data.blacklist)
	self.whitelist = (data.whitelist == nil and {} or data.whitelist)

	self.update = function(update)
		-- TriggerServerEvent('ut:debug', type(update.action))
		for k, v in pairs(update) do
			-- assert(self[k] ~= nil, "Key: " .. k .. " is not used by the script and the update of the value has failed")
			interactions[self.id][k] = v
			if k == pos then
				self.refreshInteraction = true
			end
		end
	end

	self.getObj = function()
		return self
	end

	self.getVal = function(key)
		return self[key]
	end

	return self
end

for k,v in pairs(Config.Mining.ores) do
	for key, val in pairs(v.positions) do
		interactions[k .. "_" .. key] = createInteraction({
			id = k .. "_" .. key,
			pos = val,
			text = v.text,
			action = function()
				if not isMining then
					TriggerServerEvent("rpuk_mining:mine", k)
				end
			end,
		})
	end
end

Citizen.CreateThread(function()
	while true do
		Wait(500)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(interactions) do
			if activeInteractions[k] == nil and getDistance(coords, v.pos) < v.dist and interactions[k] ~= nil and (v.whitelist[1] == nil or isInList(ESX.Player.GetJobName(), v.whitelist)) and (v.blacklist[1] == nil or not isInList(ESX.Player.GetJobName(), v.blacklist))	then
				activeInteractions[k] = true
				closeToInteraction(k, v)
			end
		end
	end
end)

function closeToInteraction(k, v)
	Citizen.CreateThread(function()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if v.actionOnEnter ~= nil then
			v.actionOnEnter()
		end

		while getDistance(coords, v.pos) < v.dist or not interactions[k].refreshInteractions do
			v = interactions[k]
			Wait(0)
			ped = PlayerPedId()
			coords = GetEntityCoords(ped)
		if getDistance(coords, v.pos) < v.dist and (v.canInteractWithCar or (not v.canInteractWithCar and (not (GetVehiclePedIsIn(ped, false) ~= 0) and (not exports.rpuk_health:deadStatus())))) then
				Draw3DText(v)
				if IsControlJustReleased(0, v.interactionKey) and v.id == closestInteraction() and v.action ~= nil then
					v.action()
				end
			end
		end
		if v.actionOnLeave ~= nil then
			v.actionOnLeave()
		end

		interactions[k].refreshInteractions = false
		activeInteractions[v.id] = nil
	end)
end

function closestInteraction()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local closestId = nil
	local closestDist = 9999999999999
	for k,v in pairs(interactions) do
		local dist = getDistance(coords, v.pos)
		if dist < closestDist then
			closestId = k
			closestDist = dist
		end
	end

	return closestId
end