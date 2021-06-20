local tbl = {
	[1] = {locked = false, player = nil},
	[2] = {locked = false, player = nil},
	[3] = {locked = false, player = nil},
	[4] = {locked = false, player = nil},
	[5] = {locked = false, player = nil},
	[6] = {locked = false, player = nil},
	[7] = {locked = false, player = nil},
}

RegisterNetEvent('lockGarage')
AddEventHandler('lockGarage', function(b,garage)
	tbl[tonumber(garage)].locked = b
	if not b then
		tbl[tonumber(garage)].player = nil
	else
		tbl[tonumber(garage)].player = source
	end
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)

RegisterNetEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)

AddEventHandler('playerDropped', function()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('lockGarage',-1,tbl)
			end
		end
	end
end)

RegisterNetEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button, currentPlate)
	local xPlayer = ESX.GetPlayerFromId(source)
	if button.price then -- check if button have price
		TriggerClientEvent("LSC:buttonSelected", source, name, button, button.price <= xPlayer.getMoney())
	end
end)

RegisterNetEvent("LSC:finishPurchase")
AddEventHandler("LSC:finishPurchase", function(name, button, currentPlate)
	local xPlayer = ESX.GetPlayerFromId(source)
	if button.price then -- check if button have price
		if button.price <= xPlayer.getMoney() then
			TriggerClientEvent('esx:showNotification', source, "Purchased")
			xPlayer.removeMoney(button.price, ('%s (%s:%s) [%s]'):format('Vehicle Modification Purchase', currentPlate, button.name, GetCurrentResourceName()))
			print("RPUK TRANSACTION: LSCUSTOMS > " .. xPlayer.identifier .. " Purchased [" .. button.name .. "] for vehicle [" .. currentPlate .. "] [£" .. button.price .. "]")
		else
			TriggerClientEvent('esx:showNotification', source, "Not enough money!")
		end
	end
end)

RegisterNetEvent("LSC:finished")
AddEventHandler("LSC:finished", function(veh)
	local model = veh.model --Display name from vehicle model(comet2, entityxf)
	local mods = veh.mods
	--[[
	mods[0].mod - spoiler
	mods[1].mod - front bumper
	mods[2].mod - rearbumper
	mods[3].mod - skirts
	mods[4].mod - exhaust
	mods[5].mod - roll cage
	mods[6].mod - grille
	mods[7].mod - hood
	mods[8].mod - fenders
	mods[10].mod - roof
	mods[11].mod - engine
	mods[12].mod - brakes
	mods[13].mod - transmission
	mods[14].mod - horn
	mods[15].mod - suspension
	mods[16].mod - armor
	mods[23].mod - tires
	mods[23].variation - custom tires
	mods[24].mod - tires(Just for bikes, 23:front wheel 24:back wheel)
	mods[24].variation - custom tires(Just for bikes, 23:front wheel 24:back wheel)
	mods[25].mod - plate holder
	mods[26].mod - vanity plates
	mods[27].mod - trim design
	mods[28].mod - ornaments
	mods[29].mod - dashboard
	mods[30].mod - dial design
	mods[31].mod - doors
	mods[32].mod - seats
	mods[33].mod - steering wheels
	mods[34].mod - shift leavers
	mods[35].mod - plaques
	mods[36].mod - speakers
	mods[37].mod - trunk
	mods[38].mod - hydraulics
	mods[39].mod - engine block
	mods[40].mod - cam cover
	mods[41].mod - strut brace
	mods[42].mod - arch cover
	mods[43].mod - aerials
	mods[44].mod - roof scoops
	mods[45].mod - tank
	mods[46].mod - doors
	mods[48].mod - liveries
	
	--Toggle mods
	mods[20].mod - tyre smoke
	mods[22].mod - headlights
	mods[18].mod - turbo
	
	--]]
	local color = veh.color
	local extracolor = veh.extracolor
	local neoncolor = veh.neoncolor
	local smokecolor = veh.smokecolor
	local plateindex = veh.plateindex
	local windowtint = veh.windowtint
	local wheeltype = veh.wheeltype
	local bulletProofTyres = veh.bulletProofTyres
	--Do w/e u need with all this stuff when vehicle drives out of lsc
end)

ESX.RegisterServerCallback('lscustoms:checkOwner', function(source, callback, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate=@plate AND rpuk_charid=@rpukid', {
		['@plate'] = tostring(plate),
		['@rpukid'] = xPlayer.rpuk_charid,
	}, function(rdata)
		if rdata[1] then
			callback(true)
		else
			callback(false)
		end
	end)
end)
