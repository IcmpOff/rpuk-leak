function makeDoor(data)
	local self = {}
	assert(data.textCoords.x ~= nil, "textCoords.x in door object can not be nil")
	assert(data.textCoords.y ~= nil, "textCoords.y in door object can not be nil")
	assert(data.textCoords.z ~= nil, "textCoords.z in door object can not be nil")
	assert(data.distance ~= nil, "Distance to interact can not be nil")
	assert(data.doors[1] ~= nil, "You need to give at least one door obj")
	assert(data.id ~= nil, "You need to give an id to door")

	self.textCoords = data.textCoords
	self.authorizedJobs = data.authorizedJobs
	self.locked = (data.locked == nil and false or data.locked)
	self.distance = data.distance
	self.size = (data.size == nil and 1 or data.size)
	self.lockpick = (data.lockpick == nil and false or data.lockpick)
	self.doors = data.doors
	self.id = data.id
	self.frozenDist = data.frozenDist
	self.textOnDoor = (data.ziptie ~= nil and false or data.textOnDoor)
	self.positionForDoorText = data.positionForDoorText

	self.ziptie = (data.ziptie ~= nil and false or data.ziptie)
	self.unblock = (data.unblock ~= nil and false or data.unblock)
	self.hackable = (data.hackable ~= nil and false or data.hackable)
	self.lockpick = (data.lockpick ~= nil and false or data.lockpick)
	self.breachable = (data.breachable ~= nil and false or data.breachable)

	self.allowedToRepairDoor = (data.allowedToRepairDoor == nil and {} or data.allowedToRepairDoor)

	self.requiredPoliceOnDuty = (data.requiredPoliceOnDuty == nil and 0 or data.requiredPoliceOnDuty)
	self.isEnoughCopsOnDuty = (ESX.GetInActiveJob("police") >= self.requiredPoliceOnDuty and true or false)

	self.chanceToNotify = (data.chanceToNotify == nil and 0 or data.chanceToNotify)

	self.ziptied = false

	if Config.debug then
		self.textIfAuthorized = (self.locked and Config.text.locked or Config.text.unlocked) .. Config.text.press_button.. ' '..self.id
		self.textIfUnAuthorized = (self.locked and Config.text.locked or Config.text.unlocked).. ' '..self.id
	else
		self.textIfAuthorized = (self.locked and Config.text.locked or Config.text.unlocked) .. Config.text.press_button
		self.textIfUnAuthorized = (self.locked and Config.text.locked or Config.text.unlocked)
	end

	-- self.textIfHackable = (self.locked and Config.text.unlocked or Config.text.hackable)

	-- self.textIfZiptie = Config.text.ziptie

	-- self.textIfZiptiedCiv = Config.text.ziptied
	-- self.textIfBreach = Config.text.breach
	self.toggleLock = function()
		self.locked = not self.locked

		if not self.locked then
			self.ziptied = false
		end

		self.textIfAuthorized = (self.locked and Config.text.locked or Config.text.unlocked) .. Config.text.press_button
		self.textIfUnAuthorized = (self.locked and Config.text.locked or Config.text.unlocked)
		TriggerClientEvent('rpuk_doors:updateDoor', -1, self.id, {
			locked = self.locked,
			ziptied = self.ziptied,
			textIfAuthorized = self.textIfAuthorized,
			textIfUnAuthorized = self.textIfUnAuthorized
		}, {
			textIfAuthorized = self.locked and Config.text.locking or Config.text.unlocking,
			textIfUnAuthorized = self.locked and Config.text.locking or Config.text.unlocking,
		})
	end

	self.SetLock = function()
		self.locked = true

		self.textIfAuthorized = (self.locked and Config.text.locked or Config.text.unlocked) .. Config.text.press_button
		self.textIfUnAuthorized = (self.locked and Config.text.locked or Config.text.unlocked)
		TriggerClientEvent('rpuk_doors:updateDoor', -1, self.id, {
			locked = self.locked,
			textIfAuthorized = self.textIfAuthorized,
			textIfUnAuthorized = self.textIfUnAuthorized
		})
	end


	self.SetUnLocked = function()
		self.locked = false

		self.ziptied = false

		self.textIfAuthorized = (self.locked and Config.text.locked or Config.text.unlocked) .. Config.text.press_button
		self.textIfUnAuthorized = (self.locked and Config.text.locked or Config.text.unlocked)
		TriggerClientEvent('rpuk_doors:updateDoor', -1, self.id, {
			locked = self.locked,
			ziptied = self.ziptied,
			textIfAuthorized = self.textIfAuthorized,
			textIfUnAuthorized = self.textIfUnAuthorized
		})
	end

	self.taskZiptie = function()
		self.locked = true

		self.ziptied = true

		self.textIfAuthorized = (self.locked and Config.text.locked or Config.text.unlocked) .. Config.text.press_button
		self.textIfUnAuthorized = (self.locked and Config.text.locked or Config.text.unlocked)
		TriggerClientEvent('rpuk_doors:updateDoor', -1, self.id, {
			locked = self.locked,
			ziptied = self.ziptied,
			textIfAuthorized = self.textIfAuthorized,
			textIfUnAuthorized = self.textIfUnAuthorized
		})
	end

	self.unZiptie = function()
		self.locked = false

		self.ziptied = false

		self.textIfAuthorized = (self.locked and Config.text.locked or Config.text.unlocked) .. Config.text.press_button
		self.textIfUnAuthorized = (self.locked and Config.text.locked or Config.text.unlocked)
		TriggerClientEvent('rpuk_doors:updateDoor', -1, self.id, {
			locked = self.locked,
			ziptied = self.ziptied,
			textIfAuthorized = self.textIfAuthorized,
			textIfUnAuthorized = self.textIfUnAuthorized
		})
	end

	self.updateJob = function()
		if (ESX.GetInActiveJob("police") >= self.requiredPoliceOnDuty and true or false) ~= self.isEnoughCopsOnDuty then
			self.isEnoughCopsOnDuty = ESX.GetInActiveJob("police") >= self.requiredPoliceOnDuty
			TriggerClientEvent('rpuk_doors:updateDoor', -1, self.id, {
				isEnoughCopsOnDuty = self.isEnoughCopsOnDuty,
			})
		end
	end

	self.getLockedState = function()
		return self.locked
	end

	return self
end