activeBeds = {}
waitingList = {}

function timeForRevive()
	local time = 600000
	if ESX.GetInActiveJob("ambulance") == 1 then
		time = 660000
	elseif ESX.GetInActiveJob("ambulance") == 2 then
		time = 720000
	elseif ESX.GetInActiveJob("ambulance") >= 3 then
		time = 780000
	end
	return time
end

RegisterNetEvent('rpuk_health:checkIntoHospital')
AddEventHandler('rpuk_health:checkIntoHospital', function(bedData, waitingRoomData, deadStatus)
	local _source = source
	local temp = {}
	if deadStatus then
		for _, v in pairs(bedData) do
			if activeBeds[v.bedId] then
				for key, val in pairs(activeBeds[v.bedId]) do
					if v.bedId ~= val.bedID then
						table.insert(temp, {
							bedID = v.bedId,
							playerID = _source
						})
						activeBeds[v.bedId] = temp
						TriggerClientEvent("rpuk_health:sendPatientToFreeBed", _source, v, timeForRevive())
						return
					end
				end
			else
				table.insert(temp, {
					bedID = v.bedId,
					playerID = _source
				})
				activeBeds[v.bedId] = temp
				TriggerClientEvent("rpuk_health:sendPatientToFreeBed", _source, v, timeForRevive())
				return
			end
		end
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 5000, type = 'error', text = 'No Available Beds' })
	else
		if waitingRoomData then
			if ESX.GetInActiveJob("ambulance") > 0 then
				if _source ~= waitingList[_source] then
					waitingList[_source] = _source
					TriggerClientEvent("rpuk_health:sendToWaitingRoom", _source, waitingRoomData)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 5000, type = 'error', text = 'You already have a appointment booked!' })
				end
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, {length = 5000, type = 'error', text = 'Sorry! We are closed today, come back soon!' })
			end
		else
			TriggerClientEvent("rpuk_health:prisonTreatment", _source)
		end
	end
end)

RegisterNetEvent('rpuk_health:takePatientOffBed')
AddEventHandler('rpuk_health:takePatientOffBed', function(target)
	for key, val in pairs(activeBeds) do
		for k, v in pairs(val) do
			if v.playerID == target then
				TriggerClientEvent("rpuk_health:releaseFromBedFromDoctor", target)
				activeBeds[key] = nil
			end
		end
	end
end)

RegisterNetEvent('rpuk_health:checkOutOfTheHospital')
AddEventHandler('rpuk_health:checkOutOfTheHospital', function(bedData)
	for key, val in pairs(activeBeds[bedData.bedId]) do
		if val.bedID == bedData.bedId then
			activeBeds[bedData.bedId] = nil
		end
	end
end)

RegisterNetEvent('rpuk_health:leftWaitingRoom')
AddEventHandler('rpuk_health:leftWaitingRoom', function(waitingRoomData)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = xPlayer.getAccount('bank').money

	if _source == waitingList[_source] then
		waitingList[_source] = nil
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, {
			length = 5000,
			type = 'inform',
			text = 'You have left the hospital without being checked off by a doctor, you will recieve a fee for wasting time of the NHS!'
		})
		if money > Beds.feeAmount then
			xPlayer.removeAccountMoney('bank', Beds.feeAmount, "RPUK:HEALTH - Paid Time Waste Fee")
		else
			MySQL.Async.execute('INSERT INTO fines (identifier, rpuk_charid, biller_identifier,biller_rpuk_charid,name, biller_name, amount, reason) VALUES (@identifier, @rpuk_charid, @biller_identifier, @biller_rpuk_charid, @name, @biller_name, @amount, @reason)',{
				['@identifier']		= xPlayer.identifier,
				['@rpuk_charid']		= xPlayer.rpuk_charid,
				['@biller_identifier']	= "N/A",
				['@biller_rpuk_charid']		= "0",
				['@name']	= xPlayer.firstname.." "..xPlayer.lastname,
				['@biller_name']	= "Automated Fee For Wasting NHS Time",
				['@amount']	= Beds.feeAmount,
				['@reason']	= "Wasting NHS Time, left hospital without seeing a doctor."
			}, function(result)
				if result then
					print("Billed Player: " .. xPlayer.firstname .. " " .. xPlayer.lastname .. "[" .. xPlayer.rpuk_charid .."] [NHS Wating Time Fee] FOR: £".. Beds.feeAmount .. "")
				end
			end)
		end
		local accountType = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
			["@job"] = "ambulance"
		})[1]
		if accountType then
			MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
				["@fund"] = Beds.feeAmount+accountType.fund,
				["@job"] = "ambulance"
			})
		end
	end
end)

RegisterNetEvent('rpuk_health:checkMedicalListForTarget')
AddEventHandler('rpuk_health:checkMedicalListForTarget', function(target)
	local _source = source
	if target == waitingList[target] then
		waitingList[target] = nil
		TriggerClientEvent('mythic_notify:client:SendAlert', target, {
			length = 5000,
			type = 'inform',
			text = 'You have been taken off the waiting list, thank you for your visit!'
		})
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, {
			length = 5000,
			type = 'inform',
			text = 'You have took the patient off the waiting list, thank you for your service!'
		})
	else
		TriggerEvent('mythic_notify:client:SendAlert', _source, {
			length = 5000,
			type = 'error',
			text = 'Patient is not on the list!'
		})
	end
end)