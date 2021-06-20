local walkingTypeName = nil

function WalkMenuStart(name)
	walkingTypeName = name
	ESX.Streaming.RequestAnimSet(name)
	SetPedMovementClipset(PlayerPedId(), name, 0.2)
	RemoveAnimSet(name)
end

function WalksOnCommand(source, args, raw)
	local WalksCommand = ""
	for a in pairsByKeys(DP.Walks) do
		WalksCommand = WalksCommand .. ""..string.lower(a)..", "
	end
	EmoteChatMessage(WalksCommand)
	EmoteChatMessage("To reset do /walk reset")
end

function WalkCommandStart(source, args, raw)
	local name = firstToUpper(args[1])

	if name == "Reset" then
		ResetPedMovementClipset(PlayerPedId(), 0.0)
		walkingTypeName = nil
		return
	end

	if DP.Walks[name] then
		local name2 = table.unpack(DP.Walks[name])
		if name2 ~= nil then
			WalkMenuStart(name2)
		else
			EmoteChatMessage("'"..name.."' is not a valid walk")
		end
	else
		EmoteChatMessage("'"..name.."' is not a valid walk")
	end
end

local crouched = false

RequestAnimSet('move_ped_crouched')
RequestAnimSet('move_ped_crouched_strafing')
RequestAnimSet('move_m@casual@d')

function toggleCrouch()
	local playerPed = PlayerPedId()

	if
		IsPedOnFoot(playerPed)
		and not IsEntityPlayingAnim(playerPed, 'misslamar1dead_body', 'dead_idle', 3)
		and not IsPauseMenuActive()
	then
		crouched = not crouched

		if crouched then
			SetPedMovementClipset(playerPed, 'move_ped_crouched', 0.55)
			SetPedStrafeClipset(playerPed, 'move_ped_crouched_strafing')
		else
			ResetPedStrafeClipset(playerPed)

			if walkingTypeName then
				ESX.Streaming.RequestAnimSet(walkingTypeName)
				SetPedMovementClipset(playerPed, walkingTypeName, 0.55)
				RemoveAnimSet(walkingTypeName)
			else
				SetPedMovementClipset(playerPed, 'move_m@casual@d', 0.55)
				ResetPedMovementClipset(playerPed, 1.0)
			end
		end
	end
end

RegisterKeyMapping('crouch', 'Toggle Crouching', 'keyboard', 'lcontrol')

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/e', 'Play an emote', {{ name="emotename", help="dance, camera, sit or any valid emote"}})
	TriggerEvent('chat:addSuggestion', '/emote', 'Play an emote', {{ name="emotename", help="dance, camera, sit or any valid emote"}})
	TriggerEvent('chat:addSuggestion', '/emotemenu', 'Open emotes menu')
	TriggerEvent('chat:addSuggestion', '/emotes', 'List available emotes')
	TriggerEvent('chat:addSuggestion', '/walk', 'Set your walkingstyle', {{ name="style", help="/walks for a list of valid styles"}})
	TriggerEvent('chat:addSuggestion', '/walks', 'List available walking styles')
	TriggerEvent('chat:addSuggestion', '/crouch', 'Toggle crouching')
end)

RegisterCommand('e', EmoteCommandStart)
RegisterCommand('emote', EmoteCommandStart)
RegisterCommand('emotemenu', OpenEmoteMenu)
RegisterCommand('emotes', EmotesOnCommand)
RegisterCommand('walk', WalkCommandStart)
RegisterCommand('walks', WalksOnCommand)
RegisterCommand('crouch', toggleCrouch)