function CreateStatus(name, max, tickCallback)
	local self = {}

	self.val = ESX.Math.Round(max)
	self.max = ESX.Math.Round(max)
	self.name = name
	self.tickCallback = tickCallback

	self.onTick = function() self.tickCallback(self) end
	self.getPercent = function() return ESX.Math.Round((self.val / self.max) * 100) end

	self.set = function(val)
		if val > self.max then
			self.val = self.max
		else
			self.val = val
		end

		TriggerEvent('esx_status:onStatusChange', self.name, self.val)
	end

	self.add = function(val)
		if self.val + val > self.max then
			self.val = self.max
		else
			self.val = ESX.Math.Round(self.val + val)
		end

		TriggerEvent('esx_status:onStatusChange', self.name, self.val)
	end

	self.remove = function(val)
		if self.val - val < 0 then
			self.val = 0
		else
			self.val = ESX.Math.Round(self.val - val)
		end

		TriggerEvent('esx_status:onStatusChange', self.name, self.val)
	end

	return self
end