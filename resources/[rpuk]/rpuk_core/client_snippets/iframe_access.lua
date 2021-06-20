local gui_toggled = false

local iframe_locations = {
	{pos = {{x = 308.328, y = -602.553, z = 42.284}}, frame = 'https://docs.google.com/forms/d/e/1FAIpQLSejGfydPqYPH7oQCzofsMlpVcqZAA-SuFKOvl_6ioLRoJImsQ/viewform', job = {'ambulance'}, text = 'Press [~r~E~s~] to Access Photocopier'},
	{pos = {{x = 324.901, y = -601.299, z = 42.2}}, frame = 'https://docs.google.com/forms/d/e/1FAIpQLSf7ekY3GqweoPrdpFFXd-1Yp_cvIJBpulrg2BYf_tWVU0aawQ/viewform', job = nil, text = 'Press [~r~E~s~] to Access Disability Card Application'},
}

function Draw3DTextL(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.02+ factor, 0.03, 110, 110, 110, 75)
end

function getDistanceL(coords1, coords2)
	return Vdist2(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z)
end

function isInList(val, list)
	for _,v in pairs(list) do
		if val == v then
			return true
		end
	end
	return false
end

local inZone = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for _,v in pairs(iframe_locations) do
			for _, val in pairs(v.pos) do
				while getDistance(coords, val) < 5 do
					Citizen.Wait(0)
					coords = GetEntityCoords(ped)
					if v.job == nil or isInList(ESX.Player.GetJobName(), v.job) then
						if getDistanceL(coords, val) < 8 then
							Draw3DTextL(val.x, val.y, val.z+1.5, v.text)
							inZone = true
							if IsControlPressed(0, 38) then
								gui_toggle(true, v.frame)
								Citizen.Wait(100)
							end
						else
							inZone = false
						end
					end
				end
			end
		end
	end
end)

RegisterNetEvent("rpuk:iframe")
AddEventHandler("rpuk:iframe", function(bool, frame)
	gui_toggle(bool, frame)
end)

-- RegisterCommand('guide', function(playerId, args, rawCommand)
-- 	TriggerEvent("rpuk:toggleGuide", true)
-- end)

RegisterNetEvent("rpuk:toggleGuide")
AddEventHandler("rpuk:toggleGuide", function(bool)
	Wait(1000)
	gui_toggled = bool
	SetNuiFocus(bool, bool)
	SetNuiFocusKeepInput(bool)
	if bool then
		SendNUIMessage({
			type = 'guide',
			enable = true,
			guide = "https://docs.google.com/presentation/d/e/2PACX-1vRzCZLvCyLwKxfE7cCRzLtwUdXLFfJNey-JYxcwXXz486NJMhSffqCjC1vYJhyT6PYItWa3fmg7C5aP/pub?start=true&loop=true&delayms=30000",
		})
	else
		SendNUIMessage({
			type = 'guide',
			enable = false
		})
	end
end)

function gui_toggle(bool, frame)
	Wait(1000)
	gui_toggled = bool
	SetNuiFocus(bool, bool)
	SetNuiFocusKeepInput(bool)
	if bool then
		SendNUIMessage({
			type = 'enableui',
			enable = true,
			iframe = frame,
		})
	else
		SendNUIMessage({
			type = 'enableui',
			enable = false
		})
	end
end

RegisterNUICallback('NUIFocusOff', function()
	gui_toggle(false)
end)

Citizen.CreateThread(function()
	gui_toggle(false)
	while true do
		Citizen.Wait(0)
		local canSleep = true
		if gui_toggled then
			canSleep = false
			DisableAllControlActions(0)
		end
		if canSleep then
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if GetCurrentResourceName() == resource then
		gui_toggle(false)
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if GetCurrentResourceName() == resource then
		gui_toggle(false)
	end
end)