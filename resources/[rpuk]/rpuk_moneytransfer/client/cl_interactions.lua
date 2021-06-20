local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
  
  RegisterNetEvent(GetCurrentResourceName() .. ":updateInteraction")
  
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
	interactionKey = "E",
	dist = 12,
	canInteractWithCar = false
  }
  
  function Draw3DText(data)
	local onScreen,_x,_y=World3dToScreen2d(data.pos.x,data.pos.y,data.pos.z+1.5)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
  
	SetTextScale(data.textScale[1], data.textScale[2])
	SetTextFont(data.textFont)
	SetTextProportional(data.textProportional)
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
	  self.colour = (data.colour == nil and
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
  
  Citizen.CreateThread(function()
	  while true do
		  Wait(500)
		  local ped = PlayerPedId()
		  local coords = GetEntityCoords(ped)
		  for k,v in pairs(interactions) do
			  if activeInteractions[k] == nil and getDistance(coords, v.pos) < v.dist and interactions[k] ~= nil and (v.whitelist[1] == nil or isInList(ESX.Player.GetJobName(), v.whitelist)) and (v.blacklist[1] == nil or not isInList(ESX.Player.GetJobName(), v.blacklist))  then
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
		  while interactions[k] and getDistance(coords, v.pos) < v.dist and not interactions[k].refreshInteractions do
			  v = interactions[k]
			  Wait(0)
			  ped = PlayerPedId()
			  coords = GetEntityCoords(ped)
			  if getDistance(coords, v.pos) < v.dist and (v.canInteractWithCar or (not v.canInteractWithCar and (not (GetVehiclePedIsIn(ped, false) ~= 0)))) then
				  Draw3DText(v)
				  if IsControlJustReleased(0, Keys[v.interactionKey]) and v.id == closestInteraction() and v.action ~= nil then
					  v.action()
				  end
			  end
		  end
		  if v.actionOnLeave ~= nil then
			  v.actionOnLeave()
		  end
		  if interactions[k] ~= nil then
			  interactions[k].refreshInteractions = false
		  end
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
  
  function getDistance(coords1, coords2)
	  return Vdist2(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z)
  end
  
  AddEventHandler(GetCurrentResourceName() .. ":updateInteraction", function(id, key, val)
	  interactions[id][key] = val
  end)