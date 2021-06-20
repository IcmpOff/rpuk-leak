local mainBlip = nil
local subBlips = {}
isMining = false

function getDistance(coords1, coords2)
	return Vdist2(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z)
end

-- Blips managing
Citizen.CreateThread(function()
	local newInterior = 0
	local oldInterior = 0
	displayMainblip()

	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		--local distance = #(coords - Config.Mining.entrance) / 10

		newInterior = GetInteriorFromEntity(ped)

		if newInterior == 202241 and oldInterior == 0 then
			displayOtherBlips()
		elseif newInterior == 0 and oldInterior == 202241 then
			displayMainblip()
		end

		oldInterior = newInterior
		Citizen.Wait(500)
	end
end)

function displayMainblip()
	if subBlips[1] ~= nil then
		for k,v in pairs(subBlips) do
		RemoveBlip(v)
		subBlips[k] = nil
		end
	end
	mainBlip = AddBlipForCoord(Config.Mining.mainBlip.x, Config.Mining.mainBlip.y, Config.Mining.mainBlip.z)
	SetBlipSprite(mainBlip, Config.Mining.mainBlip.sprite)
	SetBlipScale(mainBlip, 0.85)
	SetBlipColour(mainBlip, 5)
	SetBlipAsShortRange(mainBlip, true)
	SetBlipCategory(mainBlip, 10)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Config.Mining.mainBlip.display)
	EndTextCommandSetBlipName(mainBlip)
end

function displayOtherBlips()
	if mainBlip ~= nil then
		RemoveBlip(mainBlip)
	end
	for k,v in pairs(Config.Mining.ores) do
		for key, val in pairs(v.positions) do
			local blip = AddBlipForCoord(val.x, val.y, val.z)
			SetBlipSprite(blip, v.blip.sprite)
			SetBlipScale(blip, 0.85)
			SetBlipAsShortRange(blip, true)
			SetBlipColour(blip, v.blip.colour)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.blip.display)
			EndTextCommandSetBlipName(blip)
			table.insert(subBlips, blip)
		end
	end
end


RegisterNetEvent('rpuk_mining:mine')
AddEventHandler("rpuk_mining:mine", function(item, duration)
	isMining = true
	TriggerEvent('mythic_progbar:client:progress', {
		name = "startCutting",
		duration = duration,
		label = "Mining",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@heists@fleeca_bank@drilling",
			anim = "drill_left",
			flags = 49,
			task = nil,
		},
		prop = {
			model = "hei_prop_heist_drill",
			bone = 57005,
			coords = { x = 0.15, y = 0.0, z = -0.05 },
			rotation = { x = 0.0, y = 90.0, z = 90.0	},
		}
		}, function(status)
			if not status then
				TriggerServerEvent("rpuk_mining:doneMining", item)
			end
			Wait(1000)
			isMining = false
		end)
end)

