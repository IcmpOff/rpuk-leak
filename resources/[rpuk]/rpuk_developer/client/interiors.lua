Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local interiorId = GetInteriorFromEntity(playerPed)
		if IsValidInterior(interiorId) then
			local roomHash = GetRoomKeyFromEntity(playerPed)
			local roomId = GetInteriorRoomIndexByHash(interiorId, roomHash)
			local intcoords, namehash = GetInteriorInfo(interiorId)
			DrawAdvancedText(0.6, 0.03, 0.005, 0.0028, 0.4, "RoomID: "..roomId.." | Hash: "..roomHash.." | Interior ID: "..interiorId, 225, 45, 45, 200, 6, 0) --Old draw in middle
			DrawAdvancedText(0.1, 0.03, 0.005, 0.0028, 0.4, "IID: ~r~"..interiorId.."~s~\nPOS: ~r~"..round(intcoords.x, 2).." "..round(intcoords.y, 2).." "..round(intcoords.z, 2).."~s~\nPortals: ~r~"..GetInteriorPortalCount(interiorId).."~s~ Rooms: ~r~"..GetInteriorRoomCount(interiorId).."~s~\nCR: ~r~"..roomId, 255, 255, 255, 200, 6, 1) --New top left with more info
			local count = GetInteriorPortalCount(interiorId)
			for i=0,count-1 do
				local x, y, z = GetInteriorPortalCornerPosition(interiorId, i, 0)
				local one = GetOffsetFromInteriorInWorldCoords(interiorId, x, y, z)
				local x2, y2, z2 = GetInteriorPortalCornerPosition(interiorId, i, 2)
				local two = GetOffsetFromInteriorInWorldCoords(interiorId, x2, y2, z2)
				DrawBox(one, two, 193, 66, 66, 200)
				ESX.Game.Utils.DrawText3D(one, "Portal: "..i.."\nFrom: "..GetInteriorPortalRoomFrom(interiorId, i).." To: "..GetInteriorPortalRoomTo(interiorId, i), 0.6, 6)
				--DrawText3Ds(one.x, one.y, one.z, "Portal: "..i.."\nFrom: "..GetInteriorPortalRoomFrom(interiorId, i).." To: "..GetInteriorPortalRoomTo(interiorId, i))
			end
		end
	end
end)

function DrawAdvancedText(x, y, w, h, sc, text, r, g, b, a, font, jus)
    SetTextFont(font)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end