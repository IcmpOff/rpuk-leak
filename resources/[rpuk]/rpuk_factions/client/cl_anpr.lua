--	  Uses Numpad5 to turn on
--    Uses Numpad8 to freeze	
local authCars = { -- Taken from the ELS VCF File list
	"rpPolice1",
	"rpPolice2",
	"rpPolice3",
	"rpPolice4",
	"rpPolice5",
	"rpPolice6",
	"rpPolice7",
	"rpPolice8",
	"rpPolice9",
	"rpPolice10",
	"rpPolice11",
	"rpPolice13",
	"rpPolice14",
	"rpPolice15",
	"rpPoliceUC1",
	"rpPoliceUC2",
	"rpPoliceUC3",
	"rpPoliceUC4",
	"rpPoliceUC5",
	"rpPoliceUC6",
	"rpPoliceUC7",
	"rpPoliceUC8",
	"rpPoliceUC9",
	"fbi2",
	"policeold2",
	"sheriff2",
	"rpNHS5",
	"rpNHS6"
}

local radar =
{
	shown = false,
	freeze = false,
	info = "~y~Initialised ANPR",
	info2 = "~y~Initialised ANPR",
	minSpeed = 5.0,
	maxSpeed = 75.0,
}
--local distanceToCheckFront = 50

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextScale(sc, sc)
	SetTextJustification(jus)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

local plateCheckF = nil
local plateCheckR = nil
local plateCheckModel = nil
Citizen.CreateThread( function()
	while true do
		Wait(0)
		local canSleep = true
		for _, authVeh in pairs (authCars) do
			local authModel = GetHashKey(authVeh)
			local currVeh = GetVehiclePedIsIn(PlayerPedId(), false)
			if tostring(authModel) == tostring(GetEntityModel(currVeh)) then
				if (jobName == "police") then
					canSleep = false
					if IsControlJustPressed(1, 128) then
						if radar.shown then 
							radar.shown = false 
							radar.info = string.format("~y~Initialised ANPR")
							radar.info2 = string.format("~y~Initialised ANPR")
							plateCheckF = nil
							plateCheckR = nil
						else
							radar.shown = true
						end
						Wait(75)
					end
					if IsControlJustPressed(1, 127) then
						if radar.freeze then radar.freeze = false else radar.freeze = true end
					end
					if IsControlJustReleased(1, 107) and plateCheckF then
						if string.find(plateCheckF, " ") then
							ESX.TriggerServerCallback('rpuk_factions:anpr_check', function(result)
								local stat = result[1].status and "\n~r~Status: Reported As Stolen" or ""
								local mark = ""
								if result[1].markers ~= "No Active Markers" then
									local jsonMarkers = json.decode(result[1].markers)
									local isFirst = true
									for k,v in pairs(jsonMarkers) do
										if v == 1 then
											if isFirst then
												mark = k
											else 
												mark = mark .. ', ' .. k
											end
											isFirst = false
										end
									end
								end

								local formMarks = mark == "" and "No Active Markers" or mark

								ESX.ShowAdvancedNotification('Police ANPR', "Plate: " .. tostring(result[1].plate), "Keeper: " .. tostring(result[1].owner) .. "\nMarkers: ".. formMarks .. stat, 'CHAR_CALL911', 0)
							end, plateCheckF)
						else
							ESX.ShowAdvancedNotification('Police ANPR', "Plate: *" .. tostring(plateCheckF), "Keeper: No Information\nMarkers: No Active Markers", 'CHAR_CALL911', 0)
						end
						plateCheckF = nil
					end
					if IsControlJustReleased(1, 108) and plateCheckR then
						if string.find(plateCheckR, " ") then
							ESX.TriggerServerCallback('rpuk_factions:anpr_check', function(result)
								local stat = result[1].status and "\n~r~Status: Reported As Stolen" or ""
								local mark = ""
								if result[1].markers ~= "No Active Markers" then
									local jsonMarkers = json.decode(result[1].markers)
									local isFirst = true
									for k,v in pairs(jsonMarkers) do
										if v == 1 then
											if isFirst then
												mark = k
											else 
												mark = mark .. ', ' .. k
											end
											isFirst = false
										end
									end
								end

								local formMarks = mark == "" and "No Active Markers" or mark
								ESX.ShowAdvancedNotification('Police ANPR', "Plate: " .. tostring(result[1].plate), "Keeper: " .. tostring(result[1].owner) .. "\nMarkers: ".. formMarks .. stat, 'CHAR_CALL911', 0)
							end, plateCheckR)
						else
							ESX.ShowAdvancedNotification('Police ANPR', "Plate: *" .. tostring(plateCheckR), "Keeper: No Information\nMarkers: No Active Markers", 'CHAR_CALL911', 0)
						end
						plateCheckR = nil
					end
					if IsControlJustReleased(1, 117) then
						if plateCheckF ~= nil then
							TriggerServerEvent('rpuk_alerts:sNotification', {notiftype = "fts", plate = plateCheckF, model = plateCheckModel})
						end
					end

					if radar.shown  then
						if radar.freeze == false then
							local veh = GetVehiclePedIsIn(PlayerPedId(), false)
							local coordA = GetOffsetFromEntityInWorldCoords(veh, 0.0, 1.0, 1.0)
							local coordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, 105.0, 0.0)
							local frontcar = StartShapeTestCapsule(coordA, coordB, 3.0, 10, veh, 7)
							local a, b, c, d, e = GetShapeTestResult(frontcar)

							if IsEntityAVehicle(e) then
								local fmodel = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(e)))
								plateCheckModel = fmodel
								local fvspeed = GetEntitySpeed(e)*2.236936
								local fplate = GetVehicleNumberPlateText(e)
								plateCheckF = fplate
								radar.info = string.format("~y~Plate: ~w~%s  ~y~Model: ~w~%s  ~y~Speed: ~w~%s mph", fplate, fmodel, math.ceil(fvspeed))
							end

							local bcoordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, -105.0, 0.0)
							local rearcar = StartShapeTestCapsule(coordA, bcoordB, 3.0, 10, veh, 7)
							local f, g, h, i, j = GetShapeTestResult(rearcar)

							if IsEntityAVehicle(j) then
								local bmodel = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(j)))
								local bvspeed = GetEntitySpeed(j)*2.236936
								local bplate = GetVehicleNumberPlateText(j)
								plateCheckR = bplate
								radar.info2 = string.format("~y~Plate: ~w~%s  ~y~Model: ~w~%s  ~y~Speed: ~w~%s mph", bplate, bmodel, math.ceil(bvspeed))	
							end
						end

						DrawRect(0.91, 0.73, 0.19, 0.116, 0, 0, 0, 150)
						DrawAdvancedText(1.0, 0.69, 0.005, 0.0028, 0.4, "Front Radar", 0, 191, 255, 255, 6, 0)
						DrawAdvancedText(1.0, 0.74, 0.005, 0.0028, 0.4, "Rear Radar", 0, 191, 255, 255, 6, 0)
						DrawAdvancedText(1.003, 0.715, 0.005, 0.0028, 0.4, radar.info, 255, 255, 255, 255, 6, 0)
						DrawAdvancedText(1.0, 0.765, 0.005, 0.0028, 0.4, radar.info2, 255, 255, 255, 255, 6, 0)
					end
					if(not IsPedInAnyVehicle(PlayerPedId())) then
						radar.shown = false
						radar.info = string.format("~y~Initialised ANPR")
						radar.info2 = string.format("~y~Initialised ANPR")
					end
				end
			end
		end
		if canSleep then
			Citizen.Wait(1000)
		end
	end
end)