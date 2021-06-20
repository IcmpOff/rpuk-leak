RegisterCommand('roll', function(source, args, rawCommand)
	local die = 6
	if args[1] ~= nil and tonumber(args[1]) then
		die = tonumber(args[1])
	end

	math.randomseed(GetGameTimer())
	local number = math.random(1, die)

	loadAnimDict('anim@mp_player_intcelebrationmale@wank')
	TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intcelebrationmale@wank', 'wank', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
	Citizen.Wait(1500)
	ClearPedTasks(PlayerPedId())
	TriggerServerEvent('3dme:shareDisplay', 'Rolled a ' .. die .. ' sided die. Result: ' .. number)
end)

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end