local restarting = false

AddEventHandler('rpuk:shutdown_server', function()
	restarting = true

	for _, id in ipairs(GetPlayers()) do
	   DropPlayer(id, "Server is restarting.")
	end

	ESX.SavePlayers()
	Citizen.Wait(8000) -- let it all catch up, stressed it and 8k is plenty
	init_logging()
	post_logs()
end)

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	deferrals.defer()
	Citizen.Wait(0)

	if restarting then
		deferrals.done('The server is restarting, please rejoin in a moment.')
	else
		deferrals.done()
	end
end)