
RegisterNetEvent('rpuk_factions:fundManagementMenu')
AddEventHandler('rpuk_factions:fundManagementMenu', function(job)
	Citizen.Wait(500)
	ESX.TriggerServerCallback("rpuk_factions:getEmployeeList", function(employees)
		ESX.TriggerServerCallback("rpuk_factions:getFund", function(fund, access)
			ESX.UI.Menu.CloseAll()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fund_access_names', {
				title    = '',
				css 	 =  job,
				align    = 'top-left',
				elements = {
					{
						label = "Search by character ID",
						value = "rpuk_charid"
					},
					{
						label = "Search by steam ID",
						value = "steam_id"
					},
					{
						label = "Search by server ID",
						value = "server_id"
					},
					{
						label = "List members with access to withdraw",
						value = "list_members"
					}
				}
			}, function(data, menu)
				if data.current.value == "list_members" then
					listMembersWithAccess(fund.access, job)
					Citizen.Wait(500)
				else
					Citizen.Wait(500)
					ESX.UI.Menu.Open(
						"dialog", GetCurrentResourceName(), "fund_access_search", {
							align = "bottom-right"
						}, function(data2, menu2)
							ESX.TriggerServerCallback("rpuk_factions:searchForPlayer", function(result)
								local elements = {}
								if result[1] == nil then
									TriggerEvent('mythic_notify:client:SendAlert', { length = 2000, action = 'longnotif', type = 'inform', text = "No whitelisted player with this ID" })
									return
								else
									for k,v in pairs(result) do
										table.insert(elements, {
											label = v.firstname .. " " .. v.lastname,
											value = v.rpuk_charid
										})
									end
									menu.close()
									menu2.close()
									ESX.UI.Menu.Open("default", GetCurrentResourceName(), "fund_access_choice", {
										title = "",
										css = job,
										align = "top-left",
										elements = elements,
									}, function(data3, menu3)
										ESX.UI.Menu.Open("default", GetCurrentResourceName(), "fund_access_confirm", {
											title = "",
											css = job,
											align = "top-left",
											elements = {
												{
													label = (fund.access[data2.value] ~= nil and "Remove access" or "Give access"),
													value = (fund.access[data2.value] ~= nil and "remove" or "give")
												},
												{
													label = "Back",
													value = "back"
												},
											}
										}, function(data4, menu4)
											if value == "back" then
												menu4.close()
											else
												if data4.current.value == "give" then
													TriggerServerEvent("rpuk_factions:addToFundAccess", data3.current.value, job)
												else
													TriggerServerEvent("rpuk_factions:removeFundAccess", data3.current.value, job, data3.current.label)
												end
												inMenu = false
												ESX.UI.Menu.CloseAll()
											end
										end, function(data4, menu4)
											menu4.close()
										end)
									end, function(data3, menu3)
										menu3.close()
									end)
								end
							end, data.current.value, data2.value, job)
						end, function(data2, menu2)
							menu2.close()
						end)
				end
			end, function(data, menu)
				menu.close()
			end)
		end, job)
	end, job)
end)

function listMembersWithAccess(list, job)
	local lists = {}
	local x = 0
	local index = 1
	for k,v in pairs(list) do
		if x == 19 then
			if index == 1 then
				table.insert(lists[index], {
					label = ">>>>>>>",
					value = "right"
				})
			else
				table.insert(lists[index], {
					label = ">>>>>>>",
					value = "right"
				})
				table.insert(lists[index], {
					label = "<<<<<<<",
					value = "left"
				})
			end
			index = index+1
			x = 0
		end
		if x == 0 then
			lists[index] = {}
		end
		x = x+1
		table.insert(lists[index], {
			label = v,
			value = k
		})
	end
	table.insert(lists[index], {
		label = "<<<<<<<",
		value = "left"
	})
	openMenu(lists, 1, job)
end

function openMenu(lists, index, job)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "fund_access_members_list", {
		title = "",
		css = job,
		align = "top-left",
		elements = lists[index]
	}, function(data, menu)
		if data.current.value == "left" then
			openMenu(lists, index-1, job)
		elseif data.current.value == "right" then
			openMenu(lists, index+1, job)
		else
			openConfirmation(data.current, job)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function openConfirmation(data, job)
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "fund_access_members_list_confirmation", {
		title = "",
		css = job,
		align = "top-left",
		elements = {
			{
				label = data.label,
				value = ""
			},
			{
				label = "Remove access",
				value = "remove"
			},
			{
				label = "Back",
				value = "back"
			}
		}
	}, function(data2, menu2)
		if data2.current.value == "back" then
			menu2.close()
		elseif data2.current.value == "remove" then
			TriggerServerEvent("rpuk_factions:removeFundAccess", data.value, job, data.label)
			ESX.UI.Menu.CloseAll()
		end
	end, function(data2, menu2)
		menu2.close()
	end)
end