-- Must remain localised
local traceSearch = {
	"[Cience]",
	"menu property changed",
	"Modified by Fallen#0811",
	"Object placed with index",
	"Deleted object with index",
	"Script has been stopped",
	"~",
	"Configured speed is currently",
	"Rev ",
	"[gaybuild]",
	"hello u here to disconnect eh? -Cat",
	"[TMmenu]",
	"Osquerna Menu : ON",
	"[LynxRevo]",
	"Fallen#0811",
	"Lynx Revolution injected successfully",
	"[LynxEvo]",
	"[FantaMenuEvo]",
	"[GMmenu]",
	"measure worked",
	"Motion Best Menu Out Now made by: MestariHalla-aho#7167",
	"RESOURCES FOUND",
	"END OF RESOURCES",
	"________________",
	"Lynx",
	"Hoax",
	"Fallen",
	"[WarMenu]"
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local limit = false
		local orig = _G.Citizen.Trace
		_G.Citizen.Trace = function(data) orig(data)
			for index, searchString in pairs(traceSearch) do
				if string.find(data, searchString) then
					-- Trigger ban
					Citizen.Wait(5000)
				end
			end
		end
	end
end)