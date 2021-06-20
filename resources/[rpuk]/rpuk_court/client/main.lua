local interactions = {}
local activeInteractions = {}

RegisterNetEvent("rpuk_court:requestPayment")
RegisterNetEvent('rpuk_court:openTicketSearch')
RegisterNetEvent('rpuk_court:openWarrantSearch')
RegisterNetEvent('rpuk_court:openPrisonerSearch')
RegisterNetEvent('rpuk_court:openBookingSystem')
RegisterNetEvent('rpuk_court:openNHSBookingForm')

function getDistance(coords1, coords2)
	return Vdist2(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z)
end

function Draw3DText(x,y,z, text)
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

function activateInteraction(id)
	Citizen.CreateThread(function()
		local v = nil
		activeInteractions[id] = true
		while true do
			Citizen.Wait(0)
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			v = interactions[id]
			if v == nil then
			  break
			end
			if getDistance(coords, v.pos) < v.dist then
				Draw3DText(v.pos.x, v.pos.y, v.pos.z+1.5, v.text)
				if IsControlJustReleased(0, 38) and v.action ~= nil then
					v.action()
					Wait(0)
				end
			else
				break
			end
		end
		activeInteractions[id] = nil
	end)
end


Citizen.CreateThread(function()
	while true do
		Wait(500)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(interactions) do
			if getDistance(coords, v.pos) < v.dist and activeInteractions[k] == nil then
				activateInteraction(k)
			end
		end
	end
end)

for k,v in pairs(config.location) do
	interactions["ticket:" .. k] = {
		id = k,
		pos = v.ticketMachine,
		text = v.ticketMachine.text,
		dist = v.ticketMachine.dist,
		action = function()
		openCivMenu()
	end}
end

for k,v in pairs(config.locationFund) do
	interactions["funds:" .. k] = {
		id = k,
		pos = v.fundAccount,
		text = "Press ~y~[E]~s~ to check accounts",
		dist = 7,
		action = function()
		checkFunds()
	end}
end

for k,v in pairs(config.iframePanel) do
	interactions["iframe:" .. k] = {
		id = k,
		pos = v.frankTheNpc,
		text = "Press ~y~[E]~s~ to speak to Frank",
		dist = 7,
		action = function()
		openIframeMenu()
	end}
end

function capEachFirst(str)
	str = string.lower(str)
	str = string.gsub(" "..str, "%W%l", string.upper):sub(2)
	return str
end

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


function openIframeMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	table.insert(elements, {
		label = "Submit A Judge Application",
		value = "judge"
	})
	table.insert(elements, {
		label = "Submit A Solictor Application",
		value = "solictors"
	})
	table.insert(elements, {
		label = " ",
		value = nil
	})
	table.insert(elements, {
		label = "Submit A Court Case",
		value = "case"
	})
	table.insert(elements, {
		label = "Court Roles and Responsibilities",
		value = "responsibilities"
	})
	table.insert(elements, {
		label = "Court Hearing Procedures",
		value = "hearingProcedures"
	})
	table.insert(elements, {
		label = "House Raid Warrant Procedure",
		value = "warrantProcedure"
	})
	if ESX.Player.GetJobName() == "court" and ESX.Player.GetJobGrade() >= 1 then
		table.insert(elements, {
			label = " ",
			value = nil
		})
		table.insert(elements, {
			label = "View Court Cases",
			value = "court"
		})
	end
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), "personalMenu",
	{
		css = "interaction",
		align = "top-left",
		elements = elements
	}, function(data, menu)
		if data.current.value == "judge" then
			TriggerEvent("rpuk:iframe", true, "https://docs.google.com/forms/d/e/1FAIpQLSdofXzAB2kFaTZPNoUJ3ZI5TRRsy2QB-O4YIju8ymr9fBAd9Q/viewform")
			menu.close()
		elseif data.current.value == "solictors" then
			TriggerEvent("rpuk:iframe", true, "https://docs.google.com/forms/d/1yNFrIm7cFgrURTd-UjkZnTrU3WFhkIWuryHumoaXAPA/viewform")
			menu.close()
		elseif data.current.value == "court" then
			viewFiles()
			menu.close()
		elseif data.current.value == "case" then
			TriggerEvent("rpuk:iframe", true, "https://docs.google.com/forms/d/e/1FAIpQLSejX2S_qLNnFSn0j5eV9Ct0VYQ40qLdMdAsU0xd-3jFZrVi6g/viewform")
			menu.close()
		elseif data.current.value == "responsibilities" then
			TriggerEvent("rpuk:iframe", true, "https://docs.google.com/document/d/1phFVWP4mSewZKR8Vs9RKtKJiAPujOwsSAa67C28vNpA/?rm=minimal")
			menu.close()
		elseif data.current.value == "hearingProcedures" then
			TriggerEvent("rpuk:iframe", true, "https://docs.google.com/document/d/1uVuDeV7WKWtzCP11x-k6tCUqmpSWOIM1--bNDAlyOJA/?rm=minimal")
			menu.close()
		elseif data.current.value == "warrantProcedure" then
			TriggerEvent("rpuk:iframe", true, "https://docs.google.com/document/d/1l_LI2wmU4sLC3ZnMzgcEHhivfcEk0vHfA6Jj8lHJmq0/?rm=minimal")
			menu.close()
		else
			ESX.UI.Menu.CloseAll()
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function openCivMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	table.insert(elements, {
		label = "View Personal Tickets",
		value = "ticketCheck"
	})
	table.insert(elements, {
		label = "View Solictors",
		value = "solictors"
	})
	table.insert(elements, {
		label = " ",
		value = nil
	})
	if ESX.Player.GetJobName() == "police" then
		table.insert(elements, {
			label = "View Police Computer",
			value = "police"
		})
	end
	if ESX.Player.GetJobName() == "court" and ESX.Player.GetJobGrade() > 1 then
		table.insert(elements, {
			label = "View Court Computer",
			value = "court"
		})
	end
	if ESX.Player.GetJobName() == "court" and ESX.Player.GetJobGrade() >= 1 then
		table.insert(elements, {
			label = "View Court Cases",
			value = "files"
		})
	end
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), "personalMenu",
	{
		css = "interaction",
		align = "top-left",
		elements = elements
	}, function(data, menu)
		if data.current.value == "ticketCheck" then
			personalTicketMenu()
			menu.close()
		elseif data.current.value == "files" then
			viewFiles()
			menu.close()
		elseif data.current.value == "police" then
			openPoliceMenu()
			menu.close()
		elseif data.current.value == "court" then
			openJudgeMenu()
			menu.close()
		elseif data.current.value == "solictors" then
			openSolictors()
			menu.close()
		else
			ESX.UI.Menu.CloseAll()
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function openSolictors()
	ESX.TriggerServerCallback("rpuk_court:fetchSolictors", function(result)
		ESX.UI.Menu.CloseAll()
		local elements = {}
		for _,v in pairs(result) do
			if v.status == "Offline" then
				table.insert(elements, {
					label = "Status: <span style='color:red;'>"..v.status.."</span> | Name: ".. v.firstname .." ".. v.lastname.. " | Number: ".. v.phone_number,
					value = nil
				})
			else
				table.insert(elements, {
					label = "Status: <span style='color:green;'>"..v.status.."</span> | Name: ".. v.firstname .." ".. v.lastname.. " | Number: ".. v.phone_number,
					value = nil
				})
			end
		end
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "onlineStatus", {
		title = "Solictors",
		css = "interaction",
		align = "top-left",
		elements = elements
		}, function(data, menu)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function openNCAMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), "NCAMenu",
	{
		title = "",
		css = "interaction",
		align = "top-left",
		elements = {
			{
				label = "Submit Search Warrant Request",
				value = "submitWarrantReport"
			},

			{
				label = "  ",
				value = "  "
			},

			{
				label = "Ticket Database",
				value = "ticketSearch"
			},

			{
				label = "Warrant Database",
				value = "warrantDatabase"
			},

			{
				label = "Compensations Database",
				value = "searchcomp"
			},

			{
				label = "  ",
				value = "  "
			},

			{
				label = "Back",
				value = "back"
			}
		}
	}, function(data, menu)
		if data.current.value == "ticketSearch" then
			if ESX.Player.GetJobName() == "police" then
				suspectTicketSearch()
			else
				TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "No Permission"})
			end
			menu.close()
		elseif data.current.value == "submitWarrantReport" then
			if (ESX.Player.GetJobName() == "police" and ESX.Player.GetJobGrade() >= 3) then
				addWarrants()
			else
				TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "No Permission"})
			end
			menu.close()
		elseif data.current.value == "warrantDatabase" then
			if ESX.Player.GetJobName() == "police" then
				searchForWarrants()
			else
				TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "No Permission"})
			end
			menu.close()
		elseif data.current.value == "searchcomp" then
			if (ESX.Player.GetJobName() == "police" and ESX.Player.GetJobGrade() >= 6) then
				searchForCompToReview()
				menu.close()
			else
				TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "No Permission"})
			end
		else
			menu.close()
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function openPoliceMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), "PoliceMenu",
	{
		title = "",
		css = "interaction",
		align = "top-left",
		elements = {
			{
				label = "Submit Search Warrant Request",
				value = "submitWarrantReport"
			},

			{
				label = "  ",
				value = "  "
			},

			{
				label = "Ticket Database",
				value = "ticketSearch"
			},

			{
				label = "Warrant Database",
				value = "warrantDatabase"
			},

			{
				label = "Compensations Database",
				value = "searchcomp"
			},

			{
				label = "  ",
				value = "  "
			},

			{
				label = "Back",
				value = "back"
			}
		}
	}, function(data, menu)
		if data.current.value == "ticketSearch" then
			if ESX.Player.GetJobName() == "police" then
				suspectTicketSearch()
			else
				TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "No Permission"})
			end
			menu.close()
		elseif data.current.value == "submitWarrantReport" then
			if (ESX.Player.GetJobName() == "police" and ESX.Player.GetJobGrade() >= 3) then
				addWarrants()
			else
				TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "No Permission"})
			end
			menu.close()
		elseif data.current.value == "warrantDatabase" then
			if ESX.Player.GetJobName() == "police" then
				searchForWarrants()
			else
				TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "No Permission"})
			end
			menu.close()
		elseif data.current.value == "searchcomp" then
			if (ESX.Player.GetJobName() == "police" and ESX.Player.GetJobGrade() >= 6) then
				searchForCompToReview()
				menu.close()
			else
				TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "No Permission"})
			end
		else
			menu.close()
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function openJudgeMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), "JudgeMenu",
	{
		css = "interaction",
		align = "top-left",
		elements = {
			{
				label = "Ticket Database Search",
				value = "ticketSearch"
			},
			{
				label = "Warrant Reports",
				value = "reviewWarrantReport"
			},
			{
				label = "Compensation Database",
				value = "compensationDatabase"
			},
			{
				label = "Submit Compensation Request",
				value = "compensation"
			},
			{
				label = "Search House Number",
				value = "searchHouseAddress"
			},
			{
				label = "  ",
				value = nil
			},
			{
				label = "Back",
				value = "back"
			}
		}
	}, function(data, menu)
		if data.current.value == "ticketSearch" then
			if ESX.Player.GetJobName() == "court" then
				suspectTicketSearch()
			else
				TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "No Permission"})
			end
			menu.close()
		elseif data.current.value == "reviewWarrantReport" then
			if ESX.Player.GetJobName() == "court" then
				searchForWarrantsToReview()
			else
				TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "No Permission"})
			end
			menu.close()
		elseif data.current.value == "nameChange" then
			nameChangeMenu()
			menu.close()
		elseif data.current.value == "compensation" then
			addCompensation()
			menu.close()
		elseif data.current.value == "compensationDatabase" then
			searchForCompToView()
			menu.close()
		elseif data.current.value == "searchHouseAddress" then
			searchHouseAddress()
			menu.close()
		else
			ESX.UI.Menu.CloseAll()
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function viewFiles()
	local iframe = "https://docs.google.com/spreadsheets/d/1our7K8rZLzgtEz1uKXdshN5Pzo67df7NN_FWp9xHkb8/edit?rm=minimal#gid=2014828473"
	TriggerEvent("rpuk:iframe", true, iframe)
end

-- System for Name Change [Gets Overwritten by esx.savePlayer]
-- function nameChangeMenu()
-- 	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list',
-- 	{
-- 		title = "Enter Player CharID",
-- 	}, function(data, menu)
-- 		if tonumber(data.value) == nil and data.value == nil then
-- 			TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "Invalid"})
-- 			menu.close()
-- 		else
-- 			menu.close()
-- 			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list',
-- 			{
-- 				title = "Enter First Name",
-- 			}, function(data2, menu2)
-- 				menu2.close()
-- 				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list',
-- 				{
-- 					title = "Enter Last Name",
-- 				}, function(data3, menu3)
-- 					menu3.close()
-- 					TriggerServerEvent("rpuk_court:submitNameChange", data.value, capEachFirst(data2.value), capEachFirst(data3.value))
-- 					TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You have sent your warrant request!"})
-- 				end, function(data3, menu3)
-- 					menu3.close()
-- 				end)
-- 			end, function(data2, menu2)
-- 				menu2.close()
-- 			end)
-- 		end
-- 	end, function(data, menu)
-- 		menu.close()
-- 	end)
-- end

function addWarrants()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list',
	{
		title = "Enter Suspects Name",
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 30 then
			TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "Invalid"})
			menu.close()
		else
			menu.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list',
			{
				title = "Enter Senior Officers Name",
			}, function(data2, menu2)
				menu2.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list',
				{
					title = "Enter Reason For Your Warrant Of The Property",
				}, function(data3, menu3)
					local lengthData3 = string.len(data3.value)
					if data.value and lengthData3 < 1000 then
						menu3.close()
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list',
						{
							title = 'Enter House ID (Leave blank if not used)',
						}, function(data4, menu4)
							menu4.close()
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list',
							{
								title = 'Enter Buissness ID (Leave blank if not used)',
							}, function(data5, menu5)
								if data4.value == nil then data4.value = 0 end
								if data5.value == nil then data5.value = 0 end
								TriggerServerEvent("rpuk_court:submitWarrant", capEachFirst(data.value), capEachFirst(data2.value), data3.value, data4.value, data5.value)
								TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You have sent your warrant request!"})
								menu5.close()
							end, function(data5, menu5)
								menu5.close()
							end)
						end, function(data4, menu4)
							menu4.close()
						end)
					else
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You might wanna submit a link to a google form instead."})
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function addCompensation()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'comp1',
	{
		title = "Enter Character ID of person getting compensation",
	}, function(data, menu)
		if tonumber(data.value) == nil or data.value == nil then
			TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "Enter Character ID ONLY"})
			return
		end
		menu.close()
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'comp2',
		{
			title = "Enter account name of the fund",
		}, function(data2, menu2)
			if data2.value ~= "police" and data.value == nil then
				TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "Incorrect account name type"})
				menu.close()
				return
			end
			menu2.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'comp3',
			{
				title = "Enter amount of compensation",
			}, function(data3, menu3)
				menu3.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'comp4',
				{
					title = 'Enter reason for compensation',
				}, function(data4, menu4)
					menu4.close()
					TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "Your request has been sent through!"})
					TriggerServerEvent("rpuk_court:submitCompensationRequest", data.value, string.lower(data2.value), data3.value, data4.value)
				end, function(data4, menu4)
					menu4.close()
				end)
			end, function(data3, menu3)
				menu3.close()
			end)
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function searchHouseAddress()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list',
	{
		title = "Enter House ID",
	}, function(data, menu)
		menu.close()
		ESX.TriggerServerCallback("rpuk_court:fetchHouseNumber", function(result)
			local elements = {}
			if next(result) == nil then
				TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'inform', text = "No one owns this home" })
				return
			else
				for k,v in pairs(result) do
					table.insert(elements, {
						label = v.firstname.. " "..v.lastname,
						value = k
					})
				end
			end

			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "houseNumber", {
			title = "House Search",
			css = "",
			align = "top-left",
			elements = elements
			}, function(data2, menu2)
				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "houseNumber2", {
					title = result[data2.current.value].name,
					css = "",
					align = "top-left",
					elements = {
						{
							label = "Owner Of Home: "..result[data2.current.value].firstname.. " ".. result[data2.current.value].lastname,
							value = nil
						},
						{
							label = "House Number: ".. result[data2.current.value].houseId,
							value = nil
						},
						{
							label = "Back To House Search",
							value = "back"
						}
					}
				}, function(data3, menu3)
					if data3.current.value == "back" then
						menu3.close()
					end
				end, function(data3, menu3)
					menu3.close()
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		end, capEachFirst(data.value))
	end, function(data, menu)
		menu.close()
	end)
end

function searchForCompToView()
	ESX.TriggerServerCallback("rpuk_court:fetchAllCompensations", function(result)
		local elements = {}
		if next(result) == nil then
			TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'inform', text = "No Outstanding Compensations" })
			return
		else
			for k,v in pairs(result) do
				if v.status == "rejected" then
					table.insert(elements, {
						label = "<span style='color:red;'>" .. v.formattedTime .. "</span> | Rejected | Compensator: "..capEachFirst(v.account),
						value = k
					})
				elseif v.status == "pending" then
					table.insert(elements, {
						label = "<span style='color:yellow;'>" .. v.formattedTime .. "</span> | Pending | Compensator: "..capEachFirst(v.account),
						value = k
					})
				elseif v.status == "accepted" then
					table.insert(elements, {
						label = "<span style='color:green;'>" .. v.formattedTime .. "</span> | Accepted | Compensator: "..capEachFirst(v.account),
						value = k
					})
				end
			end
		end
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "reviewWarrants", {
		title = "Compensation Requests",
		css = "",
		align = "top-left",
		elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "reviewWarrants2", {
				title = result[data.current.value].claimant_name,
				css = "",
				align = "top-left",
				elements = {
					{
						label = "Claimant's Name: "..result[data.current.value].claimant_name,
						value = nil
					},

					{
						label = "Judge Name: "..result[data.current.value].judge_name,
						value = nil
					},

					{
						label = " ",
						value = nil
					},

					{
						label = "Compensation Amount: £"..formatMoney(result[data.current.value].amount),
						value = nil
					},

					{
						label = "Compensation Reason (Click Here)",
						value = "reason"
					},

					{
						label = "Compensation Requested Date: "..result[data.current.value].formattedTime,
						value = nil
					},

					{
						label = " ",
						value = nil
					},

					{
						label = "Compensation Reviewed By: "..result[data.current.value].nameOfPersonWhoReviewed,
						value = nil
					},

					{
						label = "Compensator: "..capEachFirst(result[data.current.value].account),
						value = nil
					},

					{
						label = "Compensation Reviewed Date: "..result[data.current.value].decisionFormattedTime,
						value = nil
					},

					{
						label = " ",
						value = nil
					},

					{
						label = "Back To Compensations",
						value = "back"
					}
				}
			}, function(data3, menu3)
				if data3.current.value == "reason" then
					TriggerEvent('mythic_notify:client:SendAlert', { length = 20000, type = 'inform', text =  "Reason: ".. result[data.current.value].reason })
				else
					menu3.close()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end



function searchForCompToReview()
	ESX.TriggerServerCallback("rpuk_court:fetchCompensations", function(result)
		local elements = {}
		if next(result) == nil then
			TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'inform', text = "No Outstanding Compensations" })
			return
		else
			for k,v in pairs(result) do
				if v.status == "rejected" then
					table.insert(elements, {
						label = "<span style='color:red;'>" .. v.formattedTime .. "</span> | Rejected",
						value = k
					})
				elseif v.status == "pending" then
					table.insert(elements, {
						label = "<span style='color:yellow;'>" .. v.formattedTime .. "</span> | Pending",
						value = k
					})
				elseif v.status == "accepted" then
					table.insert(elements, {
						label = "<span style='color:green;'>" .. v.formattedTime .. "</span> | Accepted",
						value = k
					})
				end
			end
		end
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "reviewWarrants", {
		title = "Compensation Requests",
		css = "",
		align = "top-left",
		elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "reviewWarrants2", {
				title = result[data.current.value].claimant_name,
				css = "",
				align = "top-left",
				elements = {
					{
						label = "Claimant's Name: "..result[data.current.value].claimant_name,
						value = nil
					},

					{
						label = "Judge Name: "..result[data.current.value].judge_name,
						value = nil
					},


					{
						label = " ",
						value = nil
					},

					{
						label = "Compensation Amount: £"..formatMoney(result[data.current.value].amount),
						value = nil
					},

					{
						label = "Compensation Reason (Click Here)",
						value = "reason"
					},

					{
						label = "Compensation Requested Date "..result[data.current.value].formattedTime,
						value = nil
					},

					{
						label = " ",
						value = nil
					},

					{
						label = "Compensation Reviewed By: "..result[data.current.value].nameOfPersonWhoReviewed,
						value = nil
					},


					{
						label = "Compensation Reviewed Date: "..result[data.current.value].decisionFormattedTime,
						value = nil
					},

					{
						label = " ",
						value = nil
					},

					{
						label = "Accept Compensation",
						value = "accepted"
					},

					{
						label = "Reject Compensation",
						value = "rejected"
					},

					{
						label = " ",
						value = nil
					},

					{
						label = "Back To Compensations",
						value = "back"
					}
				}
			}, function(data3, menu3)
				if data3.current.value == "reason" then
					TriggerEvent('mythic_notify:client:SendAlert', { length = 20000, type = 'inform', text =  "Reason: ".. result[data.current.value].reason })
				elseif data3.current.value == "accepted" then
					ESX.UI.Menu.CloseAll()
					if result[data.current.value].status ~= "pending" then
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You can not use this, this has been dealt with."})
					else
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You have accepted ".. result[data.current.value].claimant_name.. " compensation request!"})
						TriggerServerEvent("rpuk_court:acceptCompensationRequest",result[data.current.value])
						ESX.UI.Menu.CloseAll()
					end
				elseif data3.current.value == "rejected" then
					ESX.UI.Menu.CloseAll()
					if result[data.current.value].status ~= "pending" then
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You can not use this, this has been dealt with."})
					else
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You have denied ".. result[data.current.value].claimant_name.. " compensation request!"})
						TriggerServerEvent("rpuk_court:rejectedCompensationRequest",result[data.current.value])
						ESX.UI.Menu.CloseAll()
					end
				else
					menu.close()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function searchForWarrantsToReview()
	ESX.TriggerServerCallback("rpuk_court:fetchAllWarrants", function(result)
		local elements = {}
		if next(result) == nil then
			TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'inform', text = "No Warrants" })
			return
		else
			for k,v in pairs(result) do
				if v.status == "denied" then
					table.insert(elements, {
						label = "<span style='color:red;'>" .. v.formattedTime .. "</span> | ".. v.officer_rank .. " ".. v.officer_name .." | Denied",
						value = k
					})
				elseif v.status == "pending" then
					table.insert(elements, {
						label = "<span style='color:yellow;'>" .. v.formattedTime .. "</span> | ".. v.officer_rank .. " ".. v.officer_name .." | Pending",
						value = k
					})
				elseif v.status == "accepted" then
					table.insert(elements, {
						label = "<span style='color:purple;'>" .. v.formattedTime .. "</span> | ".. v.officer_rank .. " ".. v.officer_name .." | Accepted",
						value = k
					})
				elseif v.status == "review" then
					table.insert(elements, {
						label = "<span style='color:orange;'>" .. v.formattedTime .. "</span> | ".. v.officer_rank .. " ".. v.officer_name .." | Review",
						value = k
					})
				elseif v.status == "completed" then
					table.insert(elements, {
						label = "<span style='color:green;'>" .. v.formattedTime .. "</span> | ".. v.officer_rank .. " ".. v.officer_name .." | Completed",
						value = k
					})
				end
			end
		end
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "reviewWarrants", {
		title = "Warrants",
		css = "",
		align = "top-left",
		elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "reviewWarrants2", {
				title = result[data.current.value].target_name,
				css = "",
				align = "top-left",
				elements = {
					{
						label = "Officer's Name: "..result[data.current.value].officer_name,
						value = nil
					},
					{
						label = "Officer's Rank: "..result[data.current.value].officer_rank,
						value = nil
					},
					{
						label = "Officer's Number: "..result[data.current.value].officerNumber,
						value = nil
					},
					{
						label = "Senior Officer's Name: "..result[data.current.value].senior_auth,
						value = nil
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "House ID: ".. result[data.current.value].houseIDResponse,
						value = nil
					},
					{
						label = "Business ID: ".. result[data.current.value].businessIDResponse,
						value = nil
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "Warrant for: ".. result[data.current.value].target_name,
						value = nil
					},
					{
						label = "Warrant Status: ".. string.upper(result[data.current.value].status),
						value = nil
					},
					{
						label = "Reason (Click Here)",
						value = "reason"
					},

					{
						label = "Date Created: ".. result[data.current.value].formattedTime,
						value = nil
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "Reviewed By Judge: ".. result[data.current.value].nameOfPersonWhoReviewed,
						value = ""
					},
					{
						label = "Date Reviewed: ".. result[data.current.value].formattedDecisionDate,
						value = ""
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "Set Warrant - [Completed]",
						value = "complete"
					},
					{
						label = "Set Warrant - [Accepted]",
						value = "accepted"
					},
					{
						label = "Set Warrant - [Under Review]",
						value = "review"
					},
					{
						label = "Set Warrant - [Denied]",
						value = "deny"
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "Executed By: ".. result[data.current.value].nameOfPersonWhoExcuted,
						value = nil
					},
					{
						label = "Executed On: ".. result[data.current.value].warrantExecutedDate,
						value = nil
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "Show Warrant",
						value = "showWarrant"
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "Back To Warrants",
						value = "back"
					}
				}
			}, function(data3, menu3)
				if data3.current.value == "reason" then
					TriggerEvent('mythic_notify:client:SendAlert', { length = 20000, type = 'inform', text =  "Reason: ".. result[data.current.value].reason })
				elseif data3.current.value == "accepted" then
					if result[data.current.value].status ~= "accepted" then
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You have accepted ".. result[data.current.value].officer_name.. " warrant request!"})
						TriggerServerEvent("rpuk_court:approveWarrant",result[data.current.value])
						ESX.UI.Menu.CloseAll()
					else
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You can not accept an already accepted warrant."})
					end
				elseif data3.current.value == "deny" then
					if result[data.current.value].status ~= "denied"  then
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You have denied ".. result[data.current.value].officer_name.. " warrant request!"})
						TriggerServerEvent("rpuk_court:denyWarrant",result[data.current.value])
						ESX.UI.Menu.CloseAll()
					else
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You can not deny a already denied warrant."})
					end
				elseif data3.current.value == "review" then
					if result[data.current.value].status ~= "review"  then
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You have set the warrant to reviewed for ".. result[data.current.value].officer_name})
						TriggerServerEvent("rpuk_court:reviewWarrant",result[data.current.value])
						ESX.UI.Menu.CloseAll()
					else
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You can not set warrant for review when it has been set to reviewed already."})
					end
				elseif data3.current.value == "complete" then
					if result[data.current.value].status ~= "completed"  then
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You have set the warrant to completed for ".. result[data.current.value].officer_name})
						TriggerServerEvent("rpuk_court:completeWarrant",result[data.current.value])
						ESX.UI.Menu.CloseAll()
					else
						TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You can not set warrant to completed when it has been set to completed already."})
					end
				elseif data3.current.value == "showWarrant" then
					showWarrant(result[data.current.value])
				else
					menu3.close()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function showWarrant(data)
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()

	if closestPlayer ~= -1 and distance < 3.0 then
		TriggerServerEvent("rpuk_court:showWarrant", GetPlayerServerId(closestPlayer), data)
	else
		TriggerEvent('mythic_notify:client:SendAlert', { length = 5000, type = 'error', text = "There is no player near-by" })
	end
end

function searchForWarrants()
	ESX.TriggerServerCallback("rpuk_court:fetchLast31DaysWarrants", function(result)
		local elements = {}
		if next(result) == nil then
			TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'inform', text = "No Warrants" })
			return
		else
			for k,v in pairs(result) do
				if v.status == "denied" then
					table.insert(elements, {
						label = "<span style='color:red;'>" .. v.formattedTime .. "</span> | ".. v.officer_rank .. " ".. v.officer_name .." | Denied",
						value = k
					})
				elseif v.status == "pending" then
					table.insert(elements, {
						label = "<span style='color:yellow;'>" .. v.formattedTime .. "</span> | ".. v.officer_rank .. " ".. v.officer_name .." | Pending",
						value = k
					})
				elseif v.status == "accepted" then
					table.insert(elements, {
						label = "<span style='color:purple;'>" .. v.formattedTime .. "</span> | ".. v.officer_rank .. " ".. v.officer_name .." | Accepted",
						value = k
					})
				elseif v.status == "review" then
					table.insert(elements, {
						label = "<span style='color:orange;'>" .. v.formattedTime .. "</span> | ".. v.officer_rank .. " ".. v.officer_name .." | Review",
						value = k
					})
				elseif v.status == "completed" then
					table.insert(elements, {
						label = "<span style='color:green;'>" .. v.formattedTime .. "</span> | ".. v.officer_rank .. " ".. v.officer_name .." | Completed",
						value = k
					})
				end
			end
		end
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "currentWarrants", {
		title = "Current Warrants",
		css = "",
		align = "top-left",
		elements = elements
		}, function(data, menu)
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "currentWarrants2", {
				title = result[data.current.value].target_name,
				css = "",
				align = "top-left",
				elements = {
					{
						label = "Officer's Name: "..result[data.current.value].officer_name,
						value = nil
					},
					{
						label = "Officer's Rank: "..result[data.current.value].officer_rank,
						value = nil
					},
					{
						label = "Officer's Number: "..result[data.current.value].officerNumber,
						value = nil
					},
					{
						label = "Senior Officer's Name: "..result[data.current.value].senior_auth,
						value = nil
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "House ID: ".. result[data.current.value].houseIDResponse,
						value = nil
					},
					{
						label = "Business ID: ".. result[data.current.value].businessIDResponse,
						value = nil
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "Warrant for: ".. result[data.current.value].target_name,
						value = nil
					},
					{
						label = "Warrant Status: ".. string.upper(result[data.current.value].status),
						value = nil
					},
					{
						label = "Reason (Click Here)",
						value = "reason"
					},

					{
						label = "Date Created: ".. result[data.current.value].formattedTime,
						value = nil
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "Reviewed By Judge: ".. result[data.current.value].nameOfPersonWhoReviewed,
						value = nil
					},
					{
						label = "Date Reviewed: ".. result[data.current.value].formattedDecisionDate,
						value = nil
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "Executed By: ".. result[data.current.value].nameOfPersonWhoExcuted,
						value = nil
					},
					{
						label = "Executed On: ".. result[data.current.value].warrantExecutedDate,
						value = nil
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "Show Warrant",
						value = "showWarrant"
					},
					{
						label = "    ",
						value = nil
					},
					{
						label = "Back To Warrants",
						value = "back"
					}
				}
			}, function(data3, menu3)
				if data3.current.value == "reason" then
					TriggerEvent('mythic_notify:client:SendAlert', { length = 20000, type = 'inform', text =  "Reason: ".. result[data.current.value].reason })
				elseif data3.current.value == "showWarrant" then
					showWarrant(result[data.current.value])
				else
					menu3.close()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function suspectTicketSearch()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list',
	{
		title = "Enter Suspects Name",
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 30 then
			TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "Invalid"})
			menu.close()
		else
			menu.close()
			ESX.TriggerServerCallback("rpuk_court:fetchTickets", function(result)
				local elements = {}
				local name = ""

				if next(result) == nil then
					TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'inform', text = "No one matches this name with tickets" })
					return
				else
					for k,v in pairs(result) do
						name = v.name
						if v.status then
							table.insert(elements, {
								label = "<span style='color:red;'>" .. v.formattedTime .. "</span>  | " .. "Amount Due: £"..  v.amount .. " | " .. "Days Remaining: "..  v.timeCheck .. "",
								value = k
							})
						else
							table.insert(elements, {
								label = "<span style='color:green;'>" .. v.formattedTime .. "</span> | ".. "Amount Paid: £"..  v.amount .. "",
								value = k
							})
						end
					end
				end

				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "Suspecttickets", {
				title = name,
				css = "",
				align = "top-left",
				elements = elements
				}, function(data2, menu2)
					ESX.UI.Menu.Open("default", GetCurrentResourceName(), "Suspecttickets2", {
						title = result[data2.current.value].name,
						css = "",
						align = "top-left",
						elements = {
							{
								label = "Issued By: "..result[data2.current.value].biller_name,
								value = nil
							},
							{
								label = "Reason: ".. result[data2.current.value].reason,
								value = nil
							},
							{
								label = "Amount Due: £".. result[data2.current.value].amount,
								value = nil
							},
							{
								label = "Date Created: ".. result[data2.current.value].formattedTime,
								value = nil
							},
							{
								label = "Date Paid: ".. result[data2.current.value].datePaidConvert,
								value = nil
							},
							{
								label = "    ",
								value = nil
							},
							{
								label = "Remove Ticket",
								value = "remove"
							},

							{
								label = "Change Ticket Price",
								value = "price"
							},

							{
								label = "Back To Unpaid Tickets",
								value = "back"
							}
						}
					}, function(data3, menu3)
						if data3.current.value == "remove" then
							if result[data2.current.value].status then
								TriggerServerEvent("rpuk_court:removeTicket", result[data2.current.value])
								ESX.UI.Menu.CloseAll()
							else
								TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'error', text = "You can not remove a ticket which has been paid." })
							end
							menu3.close()
						elseif data3.current.value == "price" then
							if result[data2.current.value].status then
								ESX.UI.Menu.CloseAll()
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list',
								{
									title = "Enter New Ticket Price",
								}, function(data4, menu4)
									if tonumber(data4.value) ~= nil then
										TriggerServerEvent("rpuk_court:changeTicketPrice", result[data2.current.value], data4.value)
										TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You have sent the ticket price to " ..data4.value})
										menu4.close()
									else
										menu4.close()
										TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'inform', text = "You need to enter a number. "})
									end
								end, function(data4, menu4)
									menu4.close()
								end)
							else
								TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'error', text = "You can not remove a ticket which has been paid." })
							end
							menu3.close()
						else
							menu3.close()
						end
					end, function(data3, menu3)
						menu3.close()
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end, capEachFirst(data.value))
		end
	end, function(data, menu)
		menu.close()
	end)
end

function suspectPrisonSearch()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'list',
	{
		title = "Enter Suspects Name",
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 50 then
			TriggerEvent('mythic_notify:client:SendAlert', {type = "inform", text = "Invalid"})
			menu.close()
		else
			menu.close()
			ESX.TriggerServerCallback("rpuk_court:fetchPrisonSentenceInfo", function(result)
				local elements = {}
				local name = ""

				if next(result) == nil then
					TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'inform', text = "No one with this name matches the prisoner database." })
					return
				else
					for k,v in pairs(result) do
						name = (v.fullname)
						if v.active then
							table.insert(elements, {
								label = "<span style='color:red;'>" .. v.formattedTime .. "</span>" ,
								value = k
							})
						else
							table.insert(elements, {
								label = "<span style='color:green;'>" .. v.formattedTime .. "</span>",
								value = k
							})
						end
					end
				end

				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "prisonSearch", {
				title = name,
				css = "",
				align = "top-left",
				elements = elements
				}, function(data2, menu2)
					ESX.UI.Menu.Open("default", GetCurrentResourceName(), "prisonSearch2", {
						title = result[data2.current.value].fullname,
						css = "",
						align = "top-left",
						elements = {
							{
								label = "Arresting Officer: "..result[data2.current.value].arresting_officer,
								value = nil
							},
							{
								label = "Reason: ".. result[data2.current.value].reason,
								value = nil
							},
							{
								label = "Sentence Length: ".. result[data2.current.value].time .. " Months",
								value = nil
							},
							{
								label = "Date Sentenced: ".. result[data2.current.value].formattedTime,
								value = nil
							},
							{
								label = "    ",
								value = nil
							},
							{
								label = "Back To Previous Sentences",
								value = "back"
							}
						}
					}, function(data3, menu3)
							menu3.close()
					end, function(data3, menu3)
						menu3.close()
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end, capEachFirst(data.value))
		end
	end, function(data, menu)
		menu.close()
	end)
end

function personalTicketMenu()
	ESX.TriggerServerCallback("rpuk_court:fetchPersonalTickets", function(result)
		local elements = {}

		if next(result) == nil then
			TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'inform', text = "No unpaid tickets" })
			return
		else
			for k,v in pairs(result) do
				table.insert(elements, {
					label = "<span style='color:red;'>" .. v.formattedTime .. "</span> | " .. "Amount Due: £"..  v.amount .. " | " .. "Days Remaining: "..  v.timeCheck .. "",
					value = k
				})
			end

			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "tickets", {
				title = "Unpaid Ticket List",
				css = "",
				align = "top-left",
				elements = elements
			}, function(data, menu)
				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "tickets2", {
					title = "Tickets",
					css = "",
					align = "top-left",
					elements = {
						{
							label = "Biller Name: "..result[data.current.value].biller_name,
							value = nil
						},
						{
							label = "Reason: ".. result[data.current.value].reason,
							value = nil
						},
						{
							label = "Amount Due: £".. result[data.current.value].amount,
							value = nil
						},
						{
							label = "Date Created: ".. result[data.current.value].formattedTime,
							value = nil
						},
						{
							label = "    ",
							value = nil
						},
						{
							label = "Pay Ticket [Bank]",
							value = "bank"
						},
						{
							label = "Pay Ticket [Cash]",
							value = "money"
						},

						{
							label = "Back To Unpaid Tickets",
							value = "back"
						}
					}
				}, function(data2, menu2)
					if data2.current.value == "bank" then
						TriggerServerEvent("rpuk_court:payTicket", result[data.current.value], "bank")
						ESX.UI.Menu.CloseAll()
					elseif data2.current.value == "money" then
						TriggerServerEvent("rpuk_court:payTicket", result[data.current.value], "money")
						ESX.UI.Menu.CloseAll()
					else
						menu2.close()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end, function(data, menu)
				menu.close()
			end)
		end
	end)
end



TriggerEvent('chat:addSuggestion', '/bill', 'Bill a player.', {{ name="sessionID", help="SessionID of player"}, { name="amount", help="Fine Amount 0 - 1000"}, { name="reason", help="Reason."}})
RegisterCommand('bill', function(source, args, raw)
	local target = tonumber(args[1])
	local amount = tonumber(args[2])
	local reason = ""

	for i=3,#args,1 do
		reason = reason.." "..args[i]
	end


	if ESX.Player.GetJobName() == "police" then
		if target ~= nil then
			if amount ~= nil then
				if amount < 100000 and amount > 0 then
					TriggerServerEvent("rpuk_court:requestPaymentSV", target, amount, reason)
				else
					TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'error', text = "You can not charge a suspect higher than £100,000 or below £0 ." })
				end
			else
				TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'error', text = "Please enter the suspect's special ID" })
			end
		else
			TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'error', text = 'Please enter a amount you wish to charge a suspect!' })
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'error', text = 'You do not have permission to do this.' })
	end
end)



AddEventHandler("rpuk_court:requestPayment", function(amount, biller, reason)
local payNow = false
local payLater = false
local timer = GetGameTimer() + 20000

	TriggerEvent('mythic_notify:client:PersistentAlert', {
		action = "START",
		id = 1,
		type = 'inform',
		text = 'You have the following options:'
	})
	TriggerEvent('mythic_notify:client:PersistentAlert', {
		action = "START",
		id = 2,
		type = 'inform',
		text = 'Pay Now (ENTER)'
	})
	TriggerEvent('mythic_notify:client:PersistentAlert', {
		action = "START",
		id = 3,
		type = 'inform',
		text = 'Pay later at police station (LEFT SHIFT)'
	})
	TriggerEvent('mythic_notify:client:PersistentAlert', {
		action = "START",
		id = 4,
		type = 'inform',
		text = 'Refuse ticket (BACKSPACE)'
	})

	while timer >= GetGameTimer() do
		Wait(0)
		if IsControlJustReleased(0, 194) then
			break
		elseif IsControlJustReleased(0, 131) then
			payLater = true
			break
		elseif IsControlJustReleased(0, 201) then
			payNow = true
			break
		end
	end

	if payLater then
		TriggerServerEvent("rpuk_court:payLater", amount, biller, reason)
		TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 1})
		TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 2})
		TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 3})
		TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 4})
	elseif payNow then
		TriggerServerEvent("rpuk_court:payNow", amount, biller, reason)
		TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 1})
		TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 2})
		TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 3})
		TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 4})
	else
		TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 1})
		TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 2})
		TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 3})
		TriggerEvent('mythic_notify:client:PersistentAlert', {action = "END", id = 4})
		TriggerEvent('mythic_notify:client:SendAlert', { length = 6000, type = 'error', text = 'You have refused to pay the fine!' })
		TriggerServerEvent("rpuk_court:deniedToPay", biller)
	end
end)

AddEventHandler('rpuk_court:openTicketSearch', function()
	suspectTicketSearch()
end)

AddEventHandler('rpuk_court:openWarrantSearch', function()
	searchForWarrants()
end)

AddEventHandler('rpuk_court:openPrisonerSearch', function()
	suspectPrisonSearch()
end)

AddEventHandler('rpuk_court:openBookingSystem', function()
	if ESX.Player.GetJobName() == "police" then
		local iframe = "https://docs.google.com/forms/d/e/1FAIpQLSccPNrWXBUzq3Zd7Ztmgm01VLWpT4_S6H8F73vsoWggyqN9IQ/viewform"
		TriggerEvent("rpuk:iframe", true, iframe)
	end
end)

AddEventHandler('rpuk_court:openNHSBookingForm', function()
	if ESX.Player.GetJobName() == "ambulance" then
		local iframe = "https://docs.google.com/forms/d/e/1FAIpQLSejGfydPqYPH7oQCzofsMlpVcqZAA-SuFKOvl_6ioLRoJImsQ/viewform"
		TriggerEvent("rpuk:iframe", true, iframe)
	end
end)

function checkFunds()
	if (ESX.Player.GetJobName() == "city" and ESX.Player.GetJobGrade() == 2) then
		ESX.TriggerServerCallback("rpuk_court:fetchFundAccounts", function(result)
			local elements = {}
			if next(result) == nil then
				TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'inform', text = "No Accounts" })
				return
			else
				for k,v in pairs(result) do
					if (v.faction ~= "lost" and v.faction ~= "sinclair") then
						table.insert(elements, {
							label = "Fund Account | "..capEachFirst(v.faction),
							value = k
						})
					end
				end
			end
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "funds", {
			title = "Accounts",
			css = "",
			align = "top-left",
			elements = elements
			}, function(data, menu)
				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "funds2", {
					title = capEachFirst(result[data.current.value].faction),
					css = "",
					align = "top-left",
					elements = {
						{
							label = "Account Name: "..capEachFirst(result[data.current.value].faction),
							value = nil
						},
						{
							label = "Account Fund Amount: £"..formatMoney(result[data.current.value].fund),
							value = nil
						},
						{
							label = "  ",
							value = nil
						},
						{
							label = "Increase Fund",
							value = "increase"
						},
						{
							label = "Back To Accounts",
							value = "back"
						}
					}
				}, function(data3, menu3)
					if data3.current.value == "increase" then
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fund3',
						{
							title = "Enter Amount You Want To Add To Fund",
						}, function(data4, menu4)
							if tonumber(data4.value) then
								TriggerServerEvent("rpuk_court:increaseFund", data4.value, result[data.current.value].faction)
								ESX.UI.Menu.CloseAll()
							end
						end, function(data4, menu4)
							menu4.close()
						end)
					elseif data3.current.value == "back" then
						menu3.close()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end, function(data, menu)
				menu.close()
			end)
		end)
	else
		TriggerEvent('mythic_notify:client:SendAlert', { length = 4000, type = 'error', text = "You do not have the ability to use this." })
	end
end

