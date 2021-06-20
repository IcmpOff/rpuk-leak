local formatMoney = function(amount)
	local formatted = amount
	while true do
		Citizen.Wait(0)
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

function ConvertTime(Unix)
	local UnixConvert = tonumber(math.floor(Unix))
	local mil2sec = UnixConvert / 1000
	local date = os.date("*t", mil2sec)
	local passback = date.day .. "/" .. date.month .. "/" .. date.year
	return passback
end

function convertCorrect(Unix)
	local current = os.time()
	local final = Unix/1000+1209600
	local days = math.floor((final - current)/60/60/24)
	if days < 0 then
		return "Overdue"
	else
		return days
	end
end

RegisterNetEvent("rpuk_court:requestPaymentSV")
RegisterNetEvent("rpuk_court:deniedToPay")
RegisterNetEvent("rpuk_court:submitWarrant")
RegisterNetEvent("rpuk_court:completeWarrant")
RegisterNetEvent("rpuk_court:denyWarrant")
RegisterNetEvent("rpuk_court:approveWarrant")
RegisterNetEvent("rpuk_court:payNow")
RegisterNetEvent("rpuk_court:payTicket")
RegisterNetEvent("rpuk_court:removeTicket")
RegisterNetEvent("rpuk_court:payLater")
RegisterNetEvent('rpuk_court:showWarrant')
RegisterNetEvent('rpuk_court:submitNameChange')
RegisterNetEvent('rpuk_court:reviewWarrant')
RegisterNetEvent('rpuk_court:changeTicketPrice')
RegisterNetEvent('rpuk_court:submitCompensationRequest')
RegisterNetEvent('rpuk_court:acceptCompensationRequest')
RegisterNetEvent('rpuk_court:denyCompensationRequest')
RegisterNetEvent('rpuk_court:increaseFund')


AddEventHandler('rpuk_court:showWarrant', function(target,data)
local _source = source

	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'inform', text = "Warrant For: ".. data.target_name})
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'inform', text = "Warrant Reason: "..data.reason})
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'inform', text = "Warrant Status: "..string.upper(data.status)})
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'inform', text = "Warrant Reviewed Date: ".. data.formattedDecisionDate})

	TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'inform', text = "Warrant For: ".. data.target_name})
	TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'inform', text = "Warrant Reason: "..data.reason})
	TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'inform', text = "Warrant Status: "..string.upper(data.status)})
	TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 9000, type = 'inform', text = "Warrant Reviewed Date: ".. data.formattedDecisionDate})

end)

AddEventHandler("rpuk_court:requestPaymentSV", function(target, amount, reason)
	TriggerClientEvent("rpuk_court:requestPayment", target, amount, source, reason)
end)

AddEventHandler("rpuk_court:deniedToPay", function(target)
	TriggerClientEvent('mythic_notify:client:SendAlert', target, { length = 6000, type = 'inform', text = 'Suspect refused to pay ticket!'})
end)

AddEventHandler("rpuk_court:acceptCompensationRequest", function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local phoneNumber
	local xTarget = ESX.GetPlayerFromCharId(data.claimant_rpuk_charid)

	local fundAccount = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @faction", {
		["@faction"] = data.account,
	})[1]

	local personalAccount = MySQL.Sync.fetchAll("SELECT JSON_EXTRACT(accounts, '$.bank') AS Bank FROM users WHERE rpuk_charid = @charid", {
		["@charid"] = data.claimant_rpuk_charid
	})[1]

	if fundAccount.fund >= data.amount then
		MySQL.Async.execute("UPDATE fund_compensation SET status = 'accepted', decision_date = current_timestamp(), reviewed_by = @name WHERE id = @id", {
			["@id"] = data.id,
			["@name"] = xPlayer.firstname .. " " .. xPlayer.lastname
		})
		MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @faction", {
			["@faction"] = xPlayer.job.name,
			["@fund"] = fundAccount.fund-data.amount,
		})
		if xTarget then
			phoneNumber = xTarget.phoneNumber
			TriggerEvent('gcPhone:_internalAddMessage', "court", phoneNumber, 'Your Compensation for £'.. formatMoney(data.amount).. ' has been approved by '.. xPlayer.job.grade_label .. " " .. xPlayer.firstname .. " " .. xPlayer.lastname .. ', it will take 3 to 5 working days to receive the money.', 0, function(object)
				TriggerClientEvent('gcPhone:receiveMessage', xTarget.source, object)
			end)
			xTarget.addAccountMoney('bank', data.amount, "RPUK:Court - Comp Paid")
		else
			MySQL.Async.execute("UPDATE users SET accounts = JSON_SET(accounts, '$.bank', @newbank) WHERE rpuk_charid = @charid", {
				["@charid"] = data.claimant_rpuk_charid,
				["@newbank"] = data.amount+personalAccount.Bank,
			})
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 9000, type = 'inform', text = "Payment did not go through, your fund account did not have the funds."})
	end
end)

AddEventHandler("rpuk_court:rejectedCompensationRequest", function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromCharId(data.claimant_rpuk_charid)

	MySQL.Async.execute("UPDATE fund_compensation SET status = 'rejected', decision_date = current_timestamp(), reviewed_by = @name WHERE id = @id", {
		["@id"] = data.id,
		["@name"] = xPlayer.firstname .. " " .. xPlayer.lastname
	})

	if xTarget then
		TriggerEvent('gcPhone:_internalAddMessage', "court", xTarget.phoneNumber, 'Your Compensation for £'.. formatMoney(data.amount).. ' has been denied by ' .. xPlayer.job.grade_label .. " " .. xPlayer.firstname .. " " .. xPlayer.lastname ..', if you feel like this is incorrect please contact your solicitor.', 0, function(object)
			TriggerClientEvent('gcPhone:receiveMessage', xTarget.source, object)
		end)
	end

end)

AddEventHandler("rpuk_court:submitCompensationRequest", function(targetCharID, acountName, amount, reason)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll("SELECT identifier, firstname, lastname FROM users WHERE rpuk_charid = @targetCharID",{
		["@targetCharID"] = targetCharID
	})[1]

	MySQL.Async.execute('INSERT INTO fund_compensation (judge_name, claimant_name, claimant_rpuk_charid, claimant_identifier, amount, account, reason, date_requested, status) VALUES (@judge_name, @claimant_name, @claimant_rpuk_charid, @claimant_identifier, @amount, @account, @reason, current_timestamp(), "pending")',{
		['@judge_name'] = xPlayer.firstname .. ' '.. xPlayer.lastname,
		['@claimant_name'] = result.firstname .. ' ' .. result.lastname,
		['@claimant_rpuk_charid'] = targetCharID,
		['@claimant_identifier'] = result.identifier,
		['@amount']	= amount,
		['@account'] = acountName,
		['@reason']	= reason,
	}, function(data)
	end)
end)

AddEventHandler("rpuk_court:increaseFund", function(amount, job)
	local _source = source
	local data = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
		["@job"] = job
	})[1]
	if data then
		MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
			["@fund"] = amount+data.fund,
			["@job"] = job
		})
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 6000, type = 'inform', text = 'The Account has been increased to £'..formatMoney(math.floor(amount+data.fund))})
	end
end)


ESX.RegisterServerCallback("rpuk_court:fetchFundAccounts", function(source, cb)
	local result = MySQL.Sync.fetchAll('SELECT * FROM faction_funds',{})
	cb(result)
end)

ESX.RegisterServerCallback("rpuk_court:fetchCompensations", function(source, cb)
	local result
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	result = MySQL.Sync.fetchAll('SELECT * FROM fund_compensation WHERE account = @account ORDER BY date_requested DESC',{
		["@account"] = xPlayer.job.name
	})
	for k,v in pairs(result) do
		result[k].formattedTime = ConvertTime(v.date_requested)
		if v.decision_date > 0 then
			result[k].decisionFormattedTime = ConvertTime(v.decision_date)
		else
			result[k].decisionFormattedTime = "No Decision Made"
		end

		if v.reviewed_by == nil then
			result[k].nameOfPersonWhoReviewed = "Not Approved"
		else
			result[k].nameOfPersonWhoReviewed = v.reviewed_by
		end
	end
	cb(result)
end)

ESX.RegisterServerCallback("rpuk_court:fetchAllCompensations", function(source, cb)
	local result = MySQL.Sync.fetchAll('SELECT * FROM fund_compensation ORDER BY date_requested DESC',{})
	for k,v in pairs(result) do
		result[k].formattedTime = ConvertTime(v.date_requested)
		if v.decision_date > 0 then
			result[k].decisionFormattedTime = ConvertTime(v.decision_date)
		else
			result[k].decisionFormattedTime = "No Decision Made"
		end

		if v.reviewed_by == nil then
			result[k].nameOfPersonWhoReviewed = "Not Approved"
		else
			result[k].nameOfPersonWhoReviewed = v.reviewed_by
		end
	end
	cb(result)
end)

AddEventHandler("rpuk_court:submitWarrant", function(targetName, seniorAuth, reason, houseID, business_id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO warrants (identifier, rpuk_charid, officer_workplace, officer_name, officer_rank, senior_auth, target_name, house_id, business_id, reason, status, reviewed_by, date_created, decision_date) VALUES (@identifier, @rpuk_charid, @officer_workplace, @officer_name, @officer_rank, @senior_auth, @target_name, @house_id, @business_id, @reason, "pending", @reviewed_by, current_timestamp(), @decision_date)',{
		['@identifier']		= xPlayer.identifier,
		['@rpuk_charid']	= xPlayer.rpuk_charid,
		['@officer_workplace'] = xPlayer.job.name,
		['@officer_name']	= xPlayer.firstname .. ' '.. xPlayer.lastname,
		['@officer_rank']	= xPlayer.job.grade_label,
		['@senior_auth']	= seniorAuth,
		['@target_name']	= targetName,
		['@house_id'] = houseID,
		['@business_id'] = business_id,
		['@reason']	= reason,
	}, function(data)
		if data then
			if xPlayer.job.name == "police" then
				TriggerEvent('rpuk:disc_post', 0, "warrant_alert_police", "New Warrant Request", "Incoming request from "..xPlayer.job.grade_label.. " " .. xPlayer.firstname .. ' '.. xPlayer.lastname .. " | Phone Number: "..xPlayer.phoneNumber.." | ".. targetName .." for "..reason .. ". Senior officer: "..seniorAuth)
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 6000, type = 'inform', text = 'Your warrant has not been sent through, please try again.'})
		end
	end)
end)

ESX.RegisterServerCallback("rpuk_court:fetchAllWarrants", function(source, cb)
	local result

	result = MySQL.Sync.fetchAll('SELECT * FROM warrants ORDER BY date_created DESC', {})
	for k,v in pairs(result) do
		result[k].formattedTime = ConvertTime(v.date_created)
		local xOfficer = ESX.GetPlayerFromCharId(v.rpuk_charid)
		local phoneNumber
		if xOfficer then
			phoneNumber = xOfficer.phoneNumber
		else
			phoneNumber = MySQL.Sync.fetchAll("SELECT phone_number FROM users WHERE rpuk_charid = @id", {["@id"] = v.rpuk_charid})[1].phone_number
		end

		result[k].officerNumber = phoneNumber

		if v.decision_date > 0 then
			result[k].formattedDecisionDate = ConvertTime(v.decision_date)
		else
			result[k].formattedDecisionDate = "No Decision Made"
		end

		if v.reviewed_by == nil then
			result[k].nameOfPersonWhoReviewed = "Not Approved"
		else
			result[k].nameOfPersonWhoReviewed = v.reviewed_by
		end

		if v.warrant_executed_by == nil then
			result[k].nameOfPersonWhoExcuted = "Not Been Executed"
		else
			result[k].nameOfPersonWhoExcuted = v.warrant_executed_by
		end

		if v.executed_date > 0 then
			result[k].warrantExecutedDate = ConvertTime(v.executed_date)
		else
			result[k].warrantExecutedDate = "Not Been Executed"
		end

		if v.house_id == 0 then
			result[k].houseIDResponse = "Not Used"
		else
			result[k].houseIDResponse = v.house_id
		end


		if v.business_id == 0 then
			result[k].businessIDResponse = "Not Used"
		else
			result[k].businessIDResponse = v.business_id
		end

	end
	cb(result)
end)

ESX.RegisterServerCallback("rpuk_court:fetchLast31DaysWarrants", function(source, cb)
	local result = MySQL.Sync.fetchAll('SELECT * FROM warrants WHERE DATEDIFF(NOW(),date_created) < 31 ORDER BY date_created DESC', {})
	for k,v in pairs(result) do
		result[k].formattedTime = ConvertTime(v.date_created)
		local xOfficer = ESX.GetPlayerFromCharId(v.rpuk_charid)
		if xOfficer then
			phoneNumber = xOfficer.phoneNumber
		else
			phoneNumber = MySQL.Sync.fetchAll("SELECT phone_number FROM users WHERE rpuk_charid = @id", {["@id"] = v.rpuk_charid})[1].phone_number
		end
		result[k].officerNumber = phoneNumber

		if v.decision_date > 0 then
			result[k].formattedDecisionDate = ConvertTime(v.decision_date)
		else
			result[k].formattedDecisionDate = "No Decision Made"
		end

		if v.reviewed_by == nil then
			result[k].nameOfPersonWhoReviewed = "Not Approved"
		else
			result[k].nameOfPersonWhoReviewed = v.reviewed_by
		end

		if v.warrant_executed_by == nil then
			result[k].nameOfPersonWhoExcuted = "Not Been Executed"
		else
			result[k].nameOfPersonWhoExcuted = v.warrant_executed_by
		end

		if v.executed_date > 0 then
			result[k].warrantExecutedDate = ConvertTime(v.executed_date)
		else
			result[k].warrantExecutedDate = "Not Been Executed"
		end

		if v.house_id == 0 then
			result[k].houseIDResponse = "Not Used"
		else
			result[k].houseIDResponse = v.house_id
		end


		if v.business_id == 0 then
			result[k].businessIDResponse = "Not Used"
		else
			result[k].businessIDResponse = v.business_id
		end

	end
	cb(result)
end)

ESX.RegisterServerCallback("rpuk_court:fetchSolictors", function(source, cb)
	local result = MySQL.Sync.fetchAll("SELECT phone_number, firstname, lastname, rpuk_charid FROM users WHERE job = 'court' AND job_grade = 1",{})
	local temp = {}
	for _,v in pairs(result) do
		local xPlayer = ESX.GetPlayerFromCharId(v.rpuk_charid)
		table.insert(temp, {
			firstname = v.firstname,
			phone_number = v.phone_number,
			lastname = v.lastname,
			status = (xPlayer == nil and "Offline" or "Online")
		})
	end
	cb(temp)
end)

AddEventHandler("rpuk_court:submitNameChange", function(charID, firstName, lastName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Sync.execute("UPDATE users SET firstname = @firstname, lastname = @lastname WHERE rpuk_charid = @id",{
		["@id"] = charID,
		["@firstname"] = firstName,
		["@lastname"] = lastName,
	})
	ESX.SavePlayer(xPlayer)
	print("RPUK:Courts - "..xPlayer.firstname .. " ".. xPlayer.lastname .. " has approved a name change, the new name is "..firstName .." " ..lastName .. "CharID: "..charID)
end)

AddEventHandler("rpuk_court:denyWarrant", function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local dataList
	MySQL.Async.execute("UPDATE warrants SET status = 'denied', decision_date = current_timestamp(), reviewed_by = @name WHERE id = @id", {
		["@id"] = data.id,
		["@name"] = xPlayer.firstname .. " " .. xPlayer.lastname
	})
	dataList = MySQL.Sync.fetchAll("SELECT * FROM warrants WHERE warrants.id = @id", {
		["@id"] = data.id,
	})
	for _,v in pairs(dataList) do
		local xOfficer = ESX.GetPlayerFromCharId(v.rpuk_charid)
		local phoneNumber
		if xOfficer then
			phoneNumber = xOfficer.phoneNumber
			TriggerEvent('gcPhone:_internalAddMessage', "court", phoneNumber, 'Your Warrant for ' ..data.target_name.. ' has been DENIED by Judge '.. xPlayer.firstname .. " " .. xPlayer.lastname, 0, function(object)
				TriggerClientEvent('gcPhone:receiveMessage', xOfficer.source, object)
			end)
		end
	end
	if data.officer_workplace == "police" then
		TriggerEvent('rpuk:disc_post', 0, "warrant_alert_police", "Denied Warrant", "Judge ".. xPlayer.firstname .. " " .. xPlayer.lastname .." | DENIED warrant from "..data.officer_rank.. " " .. data.officer_name .. " on ".. data.target_name)
	end
end)

AddEventHandler("rpuk_court:completeWarrant", function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local dataList
	MySQL.Async.execute("UPDATE warrants SET status = 'completed', executed_date = current_timestamp(), warrant_executed_by = @name WHERE id = @id", {
		["@id"] = data.id,
		["@name"] = xPlayer.firstname .. " " .. xPlayer.lastname
	})
	dataList = MySQL.Sync.fetchAll("SELECT * FROM warrants WHERE warrants.id = @id", {
		["@id"] = data.id,
	})
	for _,v in pairs(dataList) do
		local xOfficer = ESX.GetPlayerFromCharId(v.rpuk_charid)
		local phoneNumber
		if xOfficer then
			phoneNumber = xOfficer.phoneNumber
			TriggerEvent('gcPhone:_internalAddMessage', "court", phoneNumber, ('Your Warrant for ' ..data.target_name.. ' has been Completed by Judge '.. xPlayer.firstname .. " " .. xPlayer.lastname), 0, function(object)
				TriggerClientEvent('gcPhone:receiveMessage', xOfficer.source, object)
			end)
		end
	end
	if data.officer_workplace == "police" then
		TriggerEvent('rpuk:disc_post', 0, "warrant_alert_police", "Completed Warrant", "Judge ".. xPlayer.firstname .. " " .. xPlayer.lastname .." has Completed warrant from "..data.officer_rank.. " " .. data.officer_name .. " on ".. data.target_name)
	end
end)

AddEventHandler("rpuk_court:approveWarrant", function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local dataList
	MySQL.Async.execute("UPDATE warrants SET status = 'accepted', decision_date = current_timestamp(), reviewed_by = @name WHERE id = @id", {
		["@id"] = data.id,
		["@name"] = xPlayer.firstname .. " " .. xPlayer.lastname
	})
	dataList = MySQL.Sync.fetchAll("SELECT * FROM warrants WHERE warrants.id = @id", {
		["@id"] = data.id,
	})
	for _,v in pairs(dataList) do
		local xOfficer = ESX.GetPlayerFromCharId(v.rpuk_charid)
		local phoneNumber
		if xOfficer then
			phoneNumber = xOfficer.phoneNumber
			TriggerEvent('gcPhone:_internalAddMessage', "court", phoneNumber, ('Your Warrant for ' ..data.target_name.. ' has been ACCEPTED by Judge '.. xPlayer.firstname .. " " .. xPlayer.lastname), 0, function(object)
				TriggerClientEvent('gcPhone:receiveMessage', xOfficer.source, object)
			end)
		end
	end
	if data.officer_workplace == "police" then
		TriggerEvent('rpuk:disc_post', 0, "warrant_alert_police", "Accepted Warrant", "Judge ".. xPlayer.firstname .. " " .. xPlayer.lastname .." has ACCEPTED warrant from "..data.officer_rank.. " " .. data.officer_name .. " on ".. data.target_name)
	end
end)

AddEventHandler("rpuk_court:reviewWarrant", function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local dataList
	MySQL.Async.execute("UPDATE warrants SET status = 'review', decision_date = current_timestamp(), reviewed_by = @name WHERE id = @id", {
		["@id"] = data.id,
		["@name"] = xPlayer.firstname .. " " .. xPlayer.lastname
	})
	dataList = MySQL.Sync.fetchAll("SELECT * FROM warrants WHERE warrants.id = @id", {
		["@id"] = data.id,
	})
	for _,v in pairs(dataList) do
		local xOfficer = ESX.GetPlayerFromCharId(v.rpuk_charid)
		local phoneNumber
		if xOfficer then
			phoneNumber = xOfficer.phoneNumber
			TriggerEvent('gcPhone:_internalAddMessage', "court", phoneNumber, ('Your Warrant for ' ..data.target_name.. ' has been set to REVIEWED by Judge '.. xPlayer.firstname .. " " .. xPlayer.lastname), 0, function(object)
				TriggerClientEvent('gcPhone:receiveMessage', xOfficer.source, object)
			end)
		end
	end
	if data.officer_workplace == "police" then
		TriggerEvent('rpuk:disc_post', 0, "warrant_alert_police", "Review Warrant", "Judge ".. xPlayer.firstname .. " " .. xPlayer.lastname .." has set warrant to be REVIEWED from "..data.officer_rank.. " " .. data.officer_name .. " on ".. data.target_name)
	end
end)

AddEventHandler("rpuk_court:payNow", function(amount, biller, reason)
	local _source = source
	local xBiller = ESX.GetPlayerFromId(biller)
	local xTarget = ESX.GetPlayerFromId(_source)
	local money = xTarget.getAccount('bank').money

	if money > amount then
		xTarget.removeAccountMoney('bank', amount, "RPUK:Billing - Paid Ticket")
		TriggerClientEvent('mythic_notify:client:SendAlert', biller, { length = 6000, type = 'inform', text = 'You have fined ' .. xTarget.firstname .. ' ' .. xTarget.lastname ..' for £' .. formatMoney(amount) .. '.' })
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 6000, type = 'inform', text = 'You have been fined by ' .. xBiller.firstname.. ' ' .. xBiller.lastname ..' for £' .. formatMoney(amount) .. '.'})
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', biller, { length = 6000, type = 'inform', text = 'Suspect does not have the funds to pay fine.'})
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 6000, type = 'inform', text = "Missing £" .. amount-money})
		return
	end

	print("Billed Player: " .. xTarget.firstname .. " " .. xTarget.lastname .. "[" .. xTarget.rpuk_charid .."] BY: " .. xBiller.firstname .. " " .. xBiller.lastname .. "[" .. xBiller.rpuk_charid .. "] FOR: £".. formatMoney(amount) .. "")
	MySQL.Async.execute('INSERT INTO fines (identifier, rpuk_charid, biller_identifier,biller_rpuk_charid,name, biller_name, amount, reason, status, date_paid) VALUES (@identifier, @rpuk_charid, @biller_identifier, @biller_rpuk_charid, @name, @biller_name, @amount, @reason, 0, current_timestamp())',{
		['@identifier']		= xTarget.identifier,
		['@rpuk_charid']		= xTarget.rpuk_charid,
		['@biller_identifier']	= xBiller.identifier,
		['@biller_rpuk_charid']		= xBiller.rpuk_charid,
		['@name']	= xTarget.firstname.." "..xTarget.lastname,
		['@biller_name']	= xBiller.firstname.." "..xBiller.lastname,
		['@amount']	= amount,
		['@reason']	= reason
	}, function(data)
	end)
	local data = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
		["@job"] = xBiller.job.name
	})[1]
	MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
		["@fund"] = amount+data.fund,
		["@job"] = xBiller.job.name
	})

end)

AddEventHandler("rpuk_court:payTicket", function(data, payType)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = xPlayer.getAccount(payType).money
	if money > data.amount then
		xPlayer.removeAccountMoney(payType, data.amount, ('%s [%s]'):format('Paid ticket', GetCurrentResourceName()))
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 6000, type = 'inform', text = "Paid fine of £" .. data.amount})
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 6000, type = 'inform', text = "Missing £" .. data.amount-money})
		return
	end
	MySQL.Async.execute("UPDATE fines SET status = 0, date_paid = current_timestamp() WHERE id = @id", {
		["@id"] = data.id
	})
	local dataType = MySQL.Sync.fetchAll("SELECT * FROM faction_funds WHERE faction = @job", {
		["@job"] = "police"
	})[1]
	MySQL.Async.execute("UPDATE faction_funds SET fund = @fund WHERE faction = @job", {
		["@fund"] = data.amount+dataType.fund,
		["@job"] = "police"
	})
end)
AddEventHandler("rpuk_court:removeTicket", function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	print("RPUK:BILLING - Removed Ticket: "..xPlayer.rpuk_charid .." Removed from ".. data.name)
	MySQL.Async.execute("UPDATE fines SET status = 0, date_paid = current_timestamp() WHERE id = @id", {
		["@id"] = data.id
	})
end)

AddEventHandler("rpuk_court:changeTicketPrice", function(data,newPrice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	print("RPUK:BILLING - Changed Ticket Price: "..xPlayer.rpuk_charid .." from £".. data.amount .. "to £".. newPrice)
	MySQL.Async.execute("UPDATE fines SET amount = @newPrice WHERE id = @id", {
		["@id"] = data.id,
		["@newPrice"] = newPrice
	})
end)


AddEventHandler("rpuk_court:payLater", function(amount, biller, reason)
	local _source = source
	local xBiller = ESX.GetPlayerFromId(biller)
	local xTarget = ESX.GetPlayerFromId(_source)
	print("Billed Player: " .. xTarget.firstname .. " " .. xTarget.lastname .. "[" .. xTarget.rpuk_charid .."] BY: " .. xBiller.firstname .. " " .. xBiller.lastname .. "[" .. xBiller.rpuk_charid .. "] FOR: £".. formatMoney(amount) .. "")
	MySQL.Async.execute('INSERT INTO fines (identifier, rpuk_charid, biller_identifier,biller_rpuk_charid,name, biller_name, amount, reason) VALUES (@identifier, @rpuk_charid, @biller_identifier, @biller_rpuk_charid, @name, @biller_name, @amount, @reason)',{
		['@identifier']		= xTarget.identifier,
		['@rpuk_charid']		= xTarget.rpuk_charid,
		['@biller_identifier']	= xBiller.identifier,
		['@biller_rpuk_charid']		= xBiller.rpuk_charid,
		['@name']	= xTarget.firstname.." "..xTarget.lastname,
		['@biller_name']	= xBiller.firstname.." "..xBiller.lastname,
		['@amount']	= amount,
		['@reason']	= reason
	}, function(data)
		if data then
			TriggerClientEvent('mythic_notify:client:SendAlert', biller, { length = 8000, type = 'inform', text = 'You have fined ' .. xTarget.firstname .. ' ' .. xTarget.lastname ..' for £' .. formatMoney(amount) .. ' they have decided to use the pay later scheme.' })
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { length = 8000, type = 'inform', text = 'You have been fined by ' .. xBiller.firstname.. ' ' .. xBiller.lastname ..' for £' .. formatMoney(amount) .. ' You have 14 Days to pay your fine or you will have a warrant for your arrest.'})
		end
	end)

end)

ESX.RegisterServerCallback("rpuk_court:fetchPersonalTickets", function(source, cb)
	local result
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	result = MySQL.Sync.fetchAll('SELECT * FROM fines WHERE rpuk_charid = @rpuk_charid AND status = 1', {
		['@rpuk_charid'] = xPlayer.rpuk_charid
	})
	for k,v in pairs(result) do
		result[k].formattedTime = ConvertTime(v.date_created)
		result[k].timeCheck = convertCorrect(v.date_created)
	end
	cb(result)
end)


ESX.RegisterServerCallback("rpuk_court:fetchTickets", function(source, cb, target)
	local result

	result = MySQL.Sync.fetchAll('SELECT * FROM fines WHERE name = @target ORDER BY date_created DESC', {
		['@target'] = target
	})
	for k,v in pairs(result) do
		result[k].formattedTime = ConvertTime(v.date_created)
		result[k].timeCheck = convertCorrect(v.date_created)
		if v.date_paid == 0 then
			result[k].datePaidConvert = "Unpaid"
		else
			result[k].datePaidConvert = ConvertTime(v.date_paid)
		end

	end
	cb(result)
end)

ESX.RegisterServerCallback("rpuk_court:fetchHouseNumber", function(source, cb, houseID)
	local result = MySQL.Sync.fetchAll('SELECT h.*, u.firstname, u.lastname FROM houses h JOIN users u ON h.owner = u.rpuk_charid WHERE h.houseId = @houseID', {
		['@houseID'] = houseID
	})
	cb(result)
end)

ESX.RegisterServerCallback("rpuk_court:fetchPrisonSentenceInfo", function(source, cb, target)
	local result
	-- AND DATEDIFF(NOW(),ps.game_time) < 31 // left it here incase you wanna read Archie
	result = MySQL.Sync.fetchAll('SELECT ps.*, CONCAT(u.firstname, " ", u.lastname) AS fullname FROM prison_sentences ps INNER JOIN users u ON ps.rpuk_charid = u.rpuk_charid WHERE CONCAT(u.firstname, " ", u.lastname) = @target ORDER BY game_time DESC', {
		['@target'] = target
	})
	for k,v in pairs(result) do
		result[k].formattedTime = ConvertTime(v.game_time)
		if v.arresting_officer == nil then
			v.arresting_officer = "No Information"
		end
	end
	cb(result)
end)