isRoll = false
amount = 1000
carModel = "prototipo"

ESX.RegisterServerCallback('esx_tpnrp_luckywheel:checkRollTokens', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not isRoll then
		if xPlayer ~= nil then
			local tokenItem = xPlayer.getInventoryItem('casino_playtoken')
			local tokenCount = tokenItem.count
			if tokenCount < amount then
				TriggerClientEvent('esx:showNotification', source, "You don't have enough tokens to use the Lucky Spinner!")
				cb(false)
			else
				cb(true)
			end
		end
	end
end)

RegisterNetEvent('esx_tpnrp_luckywheel:getLucky')
AddEventHandler('esx_tpnrp_luckywheel:getLucky', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	TriggerEvent('rpuk_core:SavePlayerServer', source)
	if not isRoll then
		if xPlayer ~= nil then
			local tokenItem = xPlayer.getInventoryItem('casino_playtoken')
			local tokenCount = tokenItem.count
			if tokenCount >= amount then
				xPlayer.removeInventoryItem('casino_playtoken', amount)
				isRoll = true
				-- local _prizeIndex = math.random(1, 20)
				math.randomseed(os.time())

				local _randomPrize = math.random(1, 100) -- debug

				if _randomPrize == 1 then                          --(1% chance)
					-- Win car
					local _subRan = math.random(1,1000)
					if _subRan <= 1 then
						_prizeIndex = 19  --Vehicle --0.001 % chance
					else
						_prizeIndex = 20   --$50,000 --0.999% chance
					end

				elseif _randomPrize > 1 and _randomPrize <= 3 then --(2% chance)
					local _itemList = {}
					--RP tokens aka casino play tokens (cash value)
					_itemList[1] = 2  --RP 2,500  --0.4% chance each
					_itemList[2] = 6  --RP 5,000
					_itemList[3] = 10 --RP 7,500
					_itemList[4] = 14 --RP 10,000
					_itemList[5] = 18 --RP 15,000
					_prizeIndex = _itemList[math.random(1, 5)]

				elseif _randomPrize > 3 and _randomPrize <= 6 then --(3% chance)
					-- Win Mystery
					local _subRan = math.random(1,20)
					if _subRan <= 2 then
						_prizeIndex = 12 --Mystery --0.15% chance
					else
						_prizeIndex = 7 --$30,000  --2.85% chance
					end

				elseif _randomPrize > 6 and _randomPrize <= 16 then --(10% chance)
					-- Win Discount
					local _subRan = math.random(1,20)
					if _subRan <= 2 then
						_prizeIndex = 5 --Discount  --0.5% chance
					else
						_prizeIndex = 3 --$20,000  --9.5% chance
					end

				elseif _randomPrize > 16 and _randomPrize <= 36 then --(20% chance)
					local _itemList = {}
					_itemList[1] = 3  --$20,000 --5% chance each (14.5% overall)
					_itemList[2] = 7  --$30,000                 --(7.85% overall)
					_itemList[3] = 15 --$40,000
					_itemList[4] = 20 --$50,000                 --(5.999% overall)
					_prizeIndex = _itemList[math.random(1, 4)]

				elseif _randomPrize > 36 and _randomPrize <= 86 then --(50% chance)
					-- Blackjack Chips
					-- 4, 8, 11, 16
					local _itemList = {}
					_itemList[1] = 4  --BJ10,000  -- all 12.5% chance each
					_itemList[2] = 8  --BJ15,000
					_itemList[3] = 11 --BJ20,000
					_itemList[4] = 16 --BJ25,000
					_prizeIndex = _itemList[math.random(1, 4)]

				elseif _randomPrize > 86 and _randomPrize <= 100 then --(14% chance)
					-- 1, 9, 13, 17
					local _itemList = {}
					_itemList[1] = 1  --Clothing  --3.5% chance each
					_itemList[2] = 9  --Clothing
					_itemList[3] = 13 --Clothing
					_itemList[4] = 17 --Clothing
					_prizeIndex = _itemList[math.random(1, 4)]

				end

				local prizelog = "Lucky Wheel Prize " .. identifier  .. " (" .. source .. ") " .. _prizeIndex

				SetTimeout(14000, function()
					isRoll = false

					if _prizeIndex == 12 then --Mystery prize - make it any other except car or $50k
						_prizeIndex = math.random(1,18)

						prizelog = prizelog .. " Mystery Prize, New Prize " .. _prizeIndex
					end

					if _prizeIndex == 1 or _prizeIndex == 9 or _prizeIndex == 13 or _prizeIndex == 17 then --Clothing
						xPlayer.addInventoryItem('casino_clothingtoken', 1)
						local msg = "Has Won An Exclusive Casino Clothing Token!"
						prizelog = prizelog .. " Clothing"
						WinMessage(msg, source)
					elseif _prizeIndex == 4 or _prizeIndex == 8 or _prizeIndex == 11 or _prizeIndex == 16 then --Blackjack Chips
						local _bjChips = 0
						if _prizeIndex == 4 then
							_bjChips = 10000 --equals �1000 cash value
						elseif _prizeIndex == 8 then
							_bjChips = 15000 --equals �1500 cash value
						elseif _prizeIndex == 11 then
							_bjChips = 20000 --equals �2000 cash value
						elseif _prizeIndex == 16 then
							_bjChips = 25000 --equals �2500 cash value
						end

						prizelog = prizelog .. " Blackjack Chips " .. _bjChips
						xPlayer.addInventoryItem('casino_blackjack_chip', _bjChips)
						local msg = "Has Won A Huge Stack Of Blackjack Chips!"
						WinMessage(msg, source)

					elseif _prizeIndex == 3 or _prizeIndex == 7 or _prizeIndex == 15 or _prizeIndex == 20 then --Money
						local _money = 0
						if _prizeIndex == 3 then
							_money = 20000
						elseif _prizeIndex == 7 then
							_money = 30000
						elseif _prizeIndex == 15 then
							_money = 40000
						elseif _prizeIndex == 20 then
							_money = 50000
						end

						prizelog = prizelog .. " Money " .. _money

						xPlayer.addMoney(_money, ('%s [%s]'):format('Casino Lucky Wheel Payout', GetCurrentResourceName()))
						local msg = "Has Won A Massive Heap Of Cash!"
						WinMessage(msg, source)

					elseif _prizeIndex == 2 or _prizeIndex == 6 or _prizeIndex == 10 or _prizeIndex == 14 or _prizeIndex == 18 then --DirtyMoney
						local msg = "Has Won A Pile Of Casino Play Tokens!"
						WinMessage(msg, source)
						local add_playtoken = 0
						if _prizeIndex == 2 then
							add_playtoken = 250
						elseif _prizeIndex == 6 then
							add_playtoken = 500
						elseif _prizeIndex == 10 then
							add_playtoken = 750
						elseif _prizeIndex == 14 then
							add_playtoken = 1000
						elseif _prizeIndex == 18 then
							add_playtoken = 1500
						end

						prizelog = prizelog .. " Casino Play Tokens " .. add_playtoken

						xPlayer.addInventoryItem('casino_playtoken', add_playtoken)
						TriggerClientEvent('esx:showNotification', source, "Additional:Casino Play Tokens: x".. add_playtoken)

					elseif _prizeIndex == 5 then --Discount
						local msg = "Has Won A 95% Discount On Another Lucky Wheel Spin!" --Discount

						prizelog = prizelog .. " Discount Spin"

						WinMessage(msg, source)
						local add_playtoken = math.floor(amount * 0.95)
						xPlayer.addInventoryItem('casino_playtoken', add_playtoken)
						TriggerClientEvent('esx:showNotification', source, "Additional:Casino Play Tokens: x".. add_playtoken)

					elseif _prizeIndex == 19 then -- Vehicle Win

						prizelog = prizelog .. " Vehicle Winner!!"

						TriggerClientEvent("rpuk_casino_w:01", source, carModel)
						local msg = "Has Won An Exclusive Casino Vehicle!"
						WinMessage(msg, source)
					end

					--print(prizelog) --log the win to the console

					TriggerClientEvent("esx_tpnrp_luckywheel:rollFinished", -1)
					end)
				TriggerClientEvent("esx_tpnrp_luckywheel:doRoll", -1, _prizeIndex)
			else
				TriggerClientEvent("esx_tpnrp_luckywheel:rollFinished", -1)
				TriggerClientEvent('esx:showNotification', source, "You don't have enough tokens to use the Lucky Spinner!")
			end
		end
	end
end)

function WinMessage(message, playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	TriggerClientEvent('chat:addMessage', -1, {template = '<div style="padding-left: 0.5vw;position:relative; float:left; width:80%; left:1%; margin-top: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><img style="position:absolute;z-index:10;right:-5%;height:3vw;top:auto;"src="https://img.icons8.com/cotton/2x/twitter.png" /> <b>@{0}</b>:<br> {1}</div><br><br>',args = { xPlayer.getFullName(), message }})
	print ("RPUK DIAMOND CASINO WIN: " .. xPlayer.getFullName() .." [" .. playerId .. "] - " .. message)
end