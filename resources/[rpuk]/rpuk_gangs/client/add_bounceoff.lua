local bouncing = false
local sequencing, sequencingPosition = false, 0.9
local points = 0
local speedModifier = 0.001

local bounceStrings = {
	["win"] = {
		"Gottem!",
		"Nice One!",
		"Winnnnerrrr!",
		"Yes Lad!",
	},	
	["lose"] = {
		"What dogshit!",
		"Cmon...",
		"Fucking embarrassing",
		"Shocking...",
	}
}

RegisterCommand('bounce', function(source)
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	bouncing = not bouncing
	if bouncing then
		 startBouncing()
	end
end)

function startBouncing()
	points = 0
	Citizen.CreateThread(function()
		while bouncing do
			Citizen.Wait(10)
			startSequence()
		end
	end)
end

local correctSelection = nil
local maxLeft, maxRight = 0.47, 0.525
function startSequence()
	if not sequencing and bouncing then
		resetSequence()
		sequencing = true
		Citizen.CreateThread(function()
			correctSelection = math.random(1,4)
			local stringGen = tostring(correctSelection)
			while sequencing and bouncing do
				Citizen.Wait(0)
				DrawStatic(0.5, 0.8, "white") -- fixed red zone
				DrawScore()
				if points < 20 then speedModifier = 0.001
				elseif points < 40 then speedModifier = 0.002
				elseif points < 60 then speedModifier = 0.004
				elseif points < 100 then speedModifier = 0.005
				end
				sequencingPosition = sequencingPosition - (0.001 + speedModifier)
				DrawMovement(stringGen, sequencingPosition, 0.865)
				if sequencingPosition < maxLeft then
					local count = 0
					while count < 100 do Citizen.Wait(0) count = count + 1 DrawStatic(0.5, 0.8, "red") DrawScore("~r~"..bounceStrings["lose"][correctSelection]) end
					points = points - 7
					resetSequence()
				else
					if IsControlPressed(2, 337) then -- Holding X // Bounce Mode
						if IsControlJustPressed(2, 338) then -- Bounce Left
							keyPress(1)
						elseif IsControlJustPressed(2, 339) then -- Bounce Right
							keyPress(2)
						elseif IsControlJustPressed(2, 340) or IsControlJustPressed(2, 127) then -- Bounce Front
							keyPress(3)
						elseif IsControlJustPressed(2, 341) or IsControlJustPressed(2, 128) then -- Bounce Rar
							keyPress(4)
						end
					elseif IsControlJustPressed(2, 168) then -- Cancel
						bouncing = false
						resetSequence()
					end
				end
			end
		end)
	end
end

function keyPress(selection)
	local stringGen = math.random(1,4)
	if sequencingPosition > maxRight then
		points = points - 5
		local count = 0
		while count < 100 do Citizen.Wait(0) count = count + 1 DrawStatic(0.5, 0.8, "red") DrawScore("~r~"..bounceStrings["lose"][stringGen]) end
		resetSequence()
	else
		if selection == correctSelection then
			points = points + 10
			local count = 0
			while count < 100 do Citizen.Wait(0) count = count + 1 DrawStatic(0.5, 0.8, "green") DrawScore("~g~"..bounceStrings["win"][stringGen]) end
		else
			points = points - 5
			local count = 0
			while count < 100 do Citizen.Wait(0) count = count + 1 DrawStatic(0.5, 0.8, "red") DrawScore("~r~"..bounceStrings["lose"][stringGen]) end
		end
	end
	resetSequence()
end

function resetSequence()
	sequencingPosition = 0.9
	sequencing = false
end

function DrawStatic(x, y, colour)
	SetTextFont(3)
	SetTextScale(2.0, 2.0)	
	if colour == "red" then
		SetTextColour(255, 0, 0, 255)
	elseif colour == "green" then
		SetTextColour(0, 255, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end	
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
	AddTextEntry('bounceTextStatic', "l")
	BeginTextCommandDisplayText('bounceTextStatic')
	EndTextCommandDisplayText(x, y)
	local scaleform = ESX.Scaleform.PrepareBasicInstructional({{button = {168}, text = "Stop Bouncing"}, {button = {337}, text = "Prep (Hold)"}, {button = {127, 128}, text = "Front/Rear"}, {button = {338, 339}, text = "Left/Right"}})
	DrawScaleformMovieFullscreen(scaleform)
end

function DrawMovement(text, x, y)
	SetTextFont(3)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
	AddTextEntry('bounceTextFlow', text)
	BeginTextCommandDisplayText('bounceTextFlow')
	EndTextCommandDisplayText(x, y)
end

function DrawScore(extra)
	SetTextFont(7)
	SetTextScale(1.5, 1.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
	if extra then
		AddTextEntry('bounceScore', "Score: " .. points .. "\n" .. extra)
	else
		AddTextEntry('bounceScore', "Score: " .. points)
	end
	BeginTextCommandDisplayText('bounceScore')
	EndTextCommandDisplayText(0.75, 0.1)		
end