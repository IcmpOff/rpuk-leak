--[[
	RPUK Traffic Manager
	Made By: Dan B
]]

local scaleform = nil
local isEnabled = false

RegisterNetEvent("rpuk_factions:openTrafficManager")
AddEventHandler("rpuk_factions:openTrafficManager", function()
	isEnabled = not isEnabled
	setupScaleForm()
	while isEnabled do
		Citizen.Wait(0)
		for i=1, 10 do
			local myPos = GetEntityCoords(PlayerPedId(), true)
			local nodeId = GetNthClosestVehicleNodeId(myPos, i, 1, 0.0, 0.0)
			if IsVehicleNodeIdValid(nodeId) then
				local nodePos = GetVehicleNodePosition(nodeId)
				if GetVehicleNodeIsSwitchedOff(nodeId) then
					DrawMarker(28, nodePos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 255, false, false, 2, false, null, null, false)
				else
					DrawMarker(28, nodePos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 0, 255, false, false, 2, false, null, null, false)
				end
			end
		end
		DisableControlAction(0, 25, true);
		if IsDisabledControlJustPressed(0, 25) then
			SetScaleformMovieAsNoLongerNeeded(scaleform)
			isEnabled = false
		end
		DisableControlAction(0, 38, true)
		if IsDisabledControlJustPressed(0, 38) then
			local coords = GetEntityCoords(PlayerPedId(), true)
			local nodeId = GetNthClosestVehicleNodeId(coords, 0, 1, 0.0, 0.0)
			if IsVehicleNodeIdValid(nodeId) then
				local nodePos = GetVehicleNodePosition(nodeId)
				if #(coords - nodePos) < 2.0 then
					TriggerServerEvent("rpuk_factions:TriggerNode", nodePos, GetVehicleNodeIsSwitchedOff(nodeId))
				end
			end
		end
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0);
	end
end)

function setupScaleForm()
	scaleform = RequestScaleformMovie("instructional_buttons")
	while not HasScaleformMovieLoaded(scaleform) do Wait(0) end
	BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
	EndScaleformMovieMethod()
	BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, 25, 1))
	BeginTextCommandScaleformString("STRING");
	AddTextComponentSubstringKeyboardDisplay("Exit editor");
	EndTextCommandScaleformString();
	EndScaleformMovieMethod()
	BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(1)
	ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, 38, 1))
	BeginTextCommandScaleformString("STRING");
	AddTextComponentSubstringKeyboardDisplay("Toggle Node");
	EndTextCommandScaleformString();
	EndScaleformMovieMethod()
	BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	EndScaleformMovieMethod()
end



RegisterNetEvent("rpuk_factions:TriggerNode")
AddEventHandler("rpuk_factions:TriggerNode", function(pos, enabled)
	if not enabled then
		SetRoadsInArea(pos.x + 0.5, pos.y + 0.5, pos.z + 0.5, pos.x - 0.5, pos.y - 0.5, pos.z - 0.5, enabled, false);
		SetIgnoreSecondaryRouteNodes(true);
	else
		SetRoadsBackToOriginal(pos.x + 0.5, pos.y + 0.5, pos.z + 0.5, pos.x - 0.5, pos.y - 0.5, pos.z - 0.5);
	end
end)