RegisterNetEvent(GetCurrentResourceName() .. ":updateInteraction")

interactions = {}
activeInteractions = {}

local defaultInteraction = {
	draw3dtext = {
		textScale = 0.7,
		textFont = 4,
	},
	interactionKey = 38,
	dist = 4,
	canInteractWithCar = false,
	hasToBeInCar = false
}

function createInteraction(data)
	local self = {}
	self.id = data.id
	self.pos = vector3(data.pos.x, data.pos.y, data.pos.z + 1.0)
	self.text = data.text
	self.action = data.action
	self.actionOnEnter = data.actionOnEnter
	self.actionOnLeave = data.actionOnLeave
	self.dist = (data.dist == nil and defaultInteraction.dist or data.dist)
	self.interactionKey = (data.interactionKey == nil and defaultInteraction.interactionKey or data.interactionKey)
	self.textScale = (data.textScale == nil and defaultInteraction.draw3dtext.textScale or data.textScale)
	self.textFont = (data.textFont == nil and defaultInteraction.draw3dtext.textFont or data.textFont)
	self.canInteractWithCar = (data.canInteractWithCar == nil and defaultInteraction.canInteractWithCar or data.canInteractWithCar)
	self.refreshInteraction = false
	self.blacklist = (data.blacklist == nil and {} or data.blacklist)
	self.whitelist = (data.whitelist == nil and {} or data.whitelist)
	self.hasToBeInCar = (data.hasToBeInCar == nil and defaultInteraction.hasToBeInCar or data.hasToBeInCar)

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

	self.getObj = function() return self end
	self.getVal = function(key) return self[key] end

	return self
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k,v in pairs(interactions) do
			if activeInteractions[k] == nil
				and #(coords - v.pos) < v.dist
				and interactions[k] ~= nil
				and (v.whitelist[1] == nil or isInList(ESX.Player.GetJobName(), v.whitelist))
				and (v.blacklist[1] == nil or not isInList(ESX.Player.GetJobName(), v.blacklist))
				and not (v.hasToBeInCar and GetVehiclePedIsIn(ped, false) == 0)
			then
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

		if v.actionOnEnter ~= nil then v.actionOnEnter() end

		while interactions[k] ~= nil and #(coords - v.pos) < v.dist and not interactions[k].refreshInteractions do
			if interactions[k] == nil or interactions[k].refreshInteractions then
				activeInteractions[k] = nil
				return
			end

			v = interactions[k]
			Wait(0)
			ped = PlayerPedId()
			coords = GetEntityCoords(ped)

			if #(coords - v.pos) < v.dist and (v.canInteractWithCar or (not v.canInteractWithCar and (not (GetVehiclePedIsIn(ped, false) ~= 0) and (not exports.rpuk_health:deadStatus())))) then
				ESX.Game.Utils.DrawText3D(v.pos, v.text, v.textScale, v.textFont)
				if IsControlJustReleased(0, v.interactionKey) and v.id == closestInteraction(coords) and v.action ~= nil then
					v.action()
				end
			end
		end

		if interactions[k] == nil then
			activeInteractions[k] = nil
			return
		end

		if v.actionOnLeave ~= nil then v.actionOnLeave() end

		interactions[k].refreshInteractions = false
		activeInteractions[v.id] = nil
	end)
end

function closestInteraction(coords)
	local ped = PlayerPedId()

	if not coords then
		coords = GetEntityCoords(ped)
	end

	local closestId = nil
	local closestDist = 9999999999999

	for k,v in pairs(interactions) do
		local dist = #(coords - v.pos)
		if dist < closestDist then
			closestId = k
			closestDist = dist
		end
	end

	return closestId
end

function isInList(val, list)
	if list == nil then
		return true
	end

	for k,v in pairs(list) do
		if val == v then
			return true
		end
	end

	return false
end

AddEventHandler(GetCurrentResourceName() .. ":updateInteraction", function(id, key, val)
	interactions[id][key] = val
end)

function getDistance(coords1, coords2)
	return Vdist2(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z)
end